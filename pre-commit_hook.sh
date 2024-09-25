#!/bin/bash

# allxiaa
# version 1.2
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

    # Створення директорії ~/bin, якщо її не існує
    mkdir -p ~/bin

    curl -s https://raw.githubusercontent.com/gitleaks/gitleaks/7098f6d958ddf7a96448737edea8ae1dc9e6a660/config/gitleaks.toml -L -o ~/bin/.gitleaks.toml

    # Розпакування та встановлення
    tar xf gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz -C ~/bin gitleaks
    if [[ $? -ne 0 ]]; then
        echo "Помилка інсталяції Gitleaks."
	rm -rf gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz
        exit 1
    fi
    echo "Gitleaks успішно встановлений."
    rm -rf gitleaks_${GITLEAKS_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz
    
    # Додавання ~/bin до $PATH, якщо це необхідно
    if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
        export PATH="$HOME/bin:$PATH"
    fi

fi

# Запуск Gitleaks перед комітом
echo "Запуск Gitleaks..."
if [[ -f "$HOME/bin/.gitleaks.toml" && -r "$HOME/bin/.gitleaks.toml" ]]; then
    gitleaks detect --source . --config "$HOME/bin/.gitleaks.toml" --redact --verbose --log-opts "-p -n 1"
else
    gitleaks detect --source . --redact --verbose --log-opts "-p -n 1"
fi

# Перевірка вихідного коду
if [[ $? -ne 0 ]]; then
    echo "Виявлені секрети. Коміт зупинено."
    exit 1
fi

echo "Gitleaks не виявив секретів. Коміт дозволено."
exit 0
