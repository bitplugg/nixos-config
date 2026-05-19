import subprocess
import os
from gi.repository import Gtk, GdkPixbuf

class Plugin(Gtk.Box):
    def __init__(self):
        Gtk.Box.__init__(self, orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.set_border_width(10)
        
        # Заголовок
        title = Gtk.Label(label="<b>Обои</b>", use_markup=True)
        self.pack_start(title, False, False, 0)
        
        # Поле для поиска
        self.search_entry = Gtk.Entry()
        self.search_entry.set_placeholder_text("Тема обоев...")
        self.pack_start(self.search_entry, False, False, 0)
        
        # Кнопка скачивания
        btn_download = Gtk.Button(label="🔍 Скачать")
        btn_download.connect("clicked", self.on_download_clicked)
        self.pack_start(btn_download, False, False, 0)
        
        # Миниатюра обоев
        self.thumbnail = Gtk.Image()
        self.pack_start(self.thumbnail, True, True, 0)
        
        # Кнопка установки
        btn_set = Gtk.Button(label="🖼 Установить обои")
        btn_set.connect("clicked", self.on_set_clicked)
        self.pack_start(btn_set, False, False, 0)
        
        # Путь к скачанному файлу
        self.wallpaper_path = None
    
    def get_title(self):
        return "Обои"
    
    def on_download_clicked(self, button):
        """Скачивает обои с Unsplash"""
        query = self.search_entry.get_text()
        if not query:
            return
        
        try:
            # Скачиваем обои через wallpaper_downloader.py
            subprocess.run([
                "wallpaper-downloader", query
            ], check=True)
            
            # Ищем последний скачанный файл
            download_dir = os.path.expanduser("~/Pictures/Wallpapers")
            files = sorted(
                [os.path.join(download_dir, f) for f in os.listdir(download_dir)],
                key=os.path.getmtime, reverse=True
            )
            if files:
                self.wallpaper_path = files[0]
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                    self.wallpaper_path, 300, 200, True
                )
                self.thumbnail.set_from_pixbuf(pixbuf)
        except Exception as e:
            print(f"Ошибка при скачивании: {e}")
    
    def on_set_clicked(self, button):
        """Устанавливает обои через swww"""
        if not self.wallpaper_path:
            return
        
        try:
            subprocess.run([
                "swww", "img", self.wallpaper_path
            ], check=True)
        except Exception as e:
            print(f"Ошибка при установке обоев: {e}")