import subprocess
from gi.repository import Gtk

class Plugin(Gtk.Box):
    def __init__(self):
        Gtk.Box.__init__(self, orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.set_border_width(10)
        
        # Заголовок
        title = Gtk.Label(label="<b>Kew Player</b>", use_markup=True)
        self.pack_start(title, False, False, 0)
        
        # Кнопки управления
        btn_audio = Gtk.Button(label="🎵 Запустить Kew Audio")
        btn_audio.connect("clicked", self.on_audio_clicked)
        self.pack_start(btn_audio, False, False, 0)
        
        btn_video = Gtk.Button(label="🎥 Запустить Kew Video")
        btn_video.connect("clicked", self.on_video_clicked)
        self.pack_start(btn_video, False, False, 0)
        
        # Поле поиска
        self.search_entry = Gtk.Entry()
        self.search_entry.set_placeholder_text("Поиск видео...")
        self.pack_start(self.search_entry, False, False, 0)
        
        btn_search = Gtk.Button(label="🔍 Найти")
        btn_search.connect("clicked", self.on_search_clicked)
        self.pack_start(btn_search, False, False, 0)
    
    def get_title(self):
        return "Kew"
    
    def on_audio_clicked(self, button):
        subprocess.run(["kew"])
    
    def on_video_clicked(self, button):
        subprocess.run(["kew-video", "--playlist"])
    
    def on_search_clicked(self, button):
        query = self.search_entry.get_text()
        if query:
            subprocess.run(["kew-video", "--search", query])