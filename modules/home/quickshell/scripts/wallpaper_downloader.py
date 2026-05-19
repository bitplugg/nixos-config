#!/usr/bin/env python3
import os
import sys
import requests
import random

# Настройки
UNSPLASH_ACCESS_KEY = "ТВОЙ_КЛЮЧ"  # Замени на свой ключ
DOWNLOAD_DIR = os.path.expanduser("~/Pictures/Wallpapers")
WALLPAPER_BANK_URL = "https://raw.githubusercontent.com/jakoolit/wallpaper-bank/main/wallpapers.json"

def download_from_unsplash(query):
    """Скачивает обои с Unsplash"""
    url = f"https://api.unsplash.com/photos/random?query={query}&client_id={UNSPLASH_ACCESS_KEY}"
    response = requests.get(url)
    if response.status_code == 200:
        image_url = response.json()["urls"]["full"]
        image_data = requests.get(image_url).content
        filename = os.path.join(DOWNLOAD_DIR, f"unsplash_{query}_{random.randint(1, 1000)}.jpg")
        with open(filename, "wb") as f:
            f.write(image_data)
        print(f"Скачано с Unsplash: {filename}")
    else:
        print("Ошибка при скачивании с Unsplash")

def download_from_wallpaper_bank(query):
    """Скачивает обои из Wallpaper Bank (Jakoolit)"""
    try:
        response = requests.get(WALLPAPER_BANK_URL)
        if response.status_code == 200:
            wallpapers = response.json()
            filtered = [wp for wp in wallpapers if query.lower() in wp["tags"]]
            if filtered:
                wallpaper = random.choice(filtered)
                image_data = requests.get(wallpaper["url"]).content
                filename = os.path.join(DOWNLOAD_DIR, f"wallbank_{query}_{random.randint(1, 1000)}.jpg")
                with open(filename, "wb") as f:
                    f.write(image_data)
                print(f"Скачано из Wallpaper Bank: {filename}")
            else:
                print("Обои не найдены в Wallpaper Bank")
        else:
            print("Ошибка при загрузке Wallpaper Bank")
    except Exception as e:
        print(f"Ошибка: {e}")

def download_wallpaper(query):
    """Скачивает обои из всех источников"""
    os.makedirs(DOWNLOAD_DIR, exist_ok=True)
    download_from_wallpaper_bank(query)
    download_from_unsplash(query)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        download_wallpaper(sys.argv[1])