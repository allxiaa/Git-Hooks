#!/bin/bash

# allxiaa
# version 1.0
# Pre-commit hook для автоматичного встановлення gitleaks

# Налаштування змінних
GITLEAKS_VERSION=$(curl -s "https://api.github.com/repos/gitleaks/gitleaks/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
TARGETOS=$(uname | tr '[:upper:]' '[:lower:]')
TARGETARCH=$(uname -m | sed -e 's/^aarch64/arm64/' -e 's/^x86_64/x64/' -e 's/^i.86/x32/')

# Перевірка, чи увімкнено Gitleaks через git config
GITLEAKS_ENABLED=$(git config --get hooks.gitleaks-enable)

if [[ "$GITLEAKS_ENABLED" != "true" ]]; then
    echo "Gitleaks hook вимкнено. Увімкніть використовуючі: git config hooks.gitleaks-enable true"
    exit 0
fi

# Перевірка, чи встановлений gitleaks
if ! command -v gitleaks &> /dev/null; then
    echo "Gitleaks не встановлений. Починається автоматична установка..."

    # Завантаження та встановлення Gitleaks
    curl -s https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz -L -o gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz

    if [[ $? -ne 0 ]]; then
        echo "Помилка завантаження Gitleaks."
        exit 1
    fi

    # Розпакування та встановлення
    sudo tar xf gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz -C /usr/local/bin gitleaks
    if [[ $? -ne 0 ]]; then
        echo "Помилка інсталяції Gitleaks."
        exit 1
    fi
    echo "Gitleaks успішно встановлений."
fi

# Запуск Gitleaks перед комітом
echo "Запуск Gitleaks..."
gitleaks detect --source . --redact --verbose

# Перевірка вихідного коду
if [[ $? -ne 0 ]]; then
    echo "Виявлені секрети. Коміт зупинено."
    exit 1
fi

echo "Gitleaks не виявив секретів. Коміт дозволено."
exit 0
