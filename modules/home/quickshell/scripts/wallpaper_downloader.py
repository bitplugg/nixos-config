#!/usr/bin/env bash

# Настройки
UNSPLASH_ACCESS_KEY="xJrfWbR_d1-emmP-JEVotA667Qe1RPRiKdhX_urGVIE"
DOWNLOAD_DIR="$HOME/Pictures/Wallpapers"
WALLHAVEN_API_KEY=""  # Оставь пустым или добавь свой ключ
WALLHAVEN_URL="https://wallhaven.cc/api/v1/search"
QUERY="$1"

# Создаём директорию
mkdir -p "$DOWNLOAD_DIR"

# Скачивание с Unsplash
download_unsplash() {
    local json_url="https://api.unsplash.com/photos/random?query=$QUERY&client_id=$UNSPLASH_ACCESS_KEY"
    local image_url=$(curl -s "$json_url" | jq -r '.urls.full')
    if [ "$image_url" != "null" ]; then
        local filename="$DOWNLOAD_DIR/unsplash_${QUERY}_$(date +%s).jpg"
        curl -s -o "$filename" "$image_url"
        echo "Скачано с Unsplash: $filename"
    else
        echo "Ошибка при скачивании с Unsplash"
    fi
}

# Скачивание с Wallhaven
download_wallhaven() {
    local params="q=$QUERY&apikey=$WALLHAVEN_API_KEY&atleast=1920x1080&sorting=random"
    local json_url="$WALLHAVEN_URL?$params"
    local wallpapers=$(curl -s "$json_url")
    local image_url=$(echo "$wallpapers" | jq -r '.data[0].path')
    if [ "$image_url" != "null" ]; then
        local filename="$DOWNLOAD_DIR/wallhaven_${QUERY}_$(date +%s).jpg"
        curl -s -o "$filename" "$image_url"
        echo "Скачано с Wallhaven: $filename"
    else
        echo "Обои не найдены на Wallhaven"
    fi
}

# Основная логика
if [ -n "$QUERY" ]; then
    download_unsplash
    download_wallhaven
else
    echo "Использование: $0 <тема_обоев>"
fi