###                       Git-Hooks Gitleaks

Додайте цей скрипт у .git/hooks/pre-commit. 
```sh
curl -s https://raw.githubusercontent.com/allxiaa/Git-Hooks/refs/heads/main/pre-commit_hook.sh -L -o pre-commit_hook.sh
cp pre-commit_hook.sh PATH_TO_PROJECT_NAME/.git/hooks/pre-commit
```

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
