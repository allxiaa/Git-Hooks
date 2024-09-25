###                       Git-Hooks Gitleaks

Інсталяція:
```sh
curl -s https://raw.githubusercontent.com/allxiaa/Git-Hooks/refs/heads/main/pre-commit_hook.sh -L -o pre-commit_hook.sh && \
chmod +x pre-commit_hook.sh && \
mv pre-commit_hook.sh .git/hooks/pre-commit && \
git config hooks.gitleaks-enable true
```
Або додайте цей скрипт у .git/hooks/pre-commit. 

Надайте йому права на виконання:
```sh
chmod +x .git/hooks/pre-commit
```

Увімкніть hook через git config:
```sh
git config hooks.gitleaks-enable true
```

Додайте ~/bin у файл .bashrc або .zshrc:
```sh
export PATH="$HOME/bin:$PATH"
```
