#!/usr/bin/env bash
# Установка tuna.am в ~/.local/bin

mkdir -p ~/.local/bin
curl -sSLf https://get.tuna.am | TUNA_INSTALL_DIR=~/.local/bin sh

# Добавляем ~/.local/bin в PATH, если ещё не добавлен
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc 2>/dev/null || true
    export PATH="$HOME/.local/bin:$PATH"
fi

echo "tuna установлен. Запустите 'tuna login' для авторизации."
