#!/usr/bin/env python3
import os
import sys
import requests

# Unsplash API
UNSPLASH_ACCESS_KEY = "ТВОЙ_КЛЮЧ"  # Замени на свой ключ
DOWNLOAD_DIR = os.path.expanduser("~/Pictures/Wallpapers")

def download_wallpaper(query):
    url = f"https://api.unsplash.com/photos/random?query={query}&client_id={UNSPLASH_ACCESS_KEY}"
    response = requests.get(url)
    if response.status_code == 200:
        image_url = response.json()["urls"]["full"]
        image_data = requests.get(image_url).content
        filename = os.path.join(DOWNLOAD_DIR, f"{query}.jpg")
        with open(filename, "wb") as f:
            f.write(image_data)
        print(f"Скачано: {filename}")
    else:
        print("Ошибка при скачивании")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        os.makedirs(DOWNLOAD_DIR, exist_ok=True)
        download_wallpaper(sys.argv[1])