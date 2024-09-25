### Git-Hooks Gitleaks

Додайте цей скрипт у .git/hooks/pre-commit.
```sh
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
