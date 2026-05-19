import subprocess
from gi.repository import Gtk

class Plugin(Gtk.Box):
    def __init__(self):
        Gtk.Box.__init__(self, orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.set_border_width(10)
        
        # Заголовок
        title = Gtk.Label(label="<b>Погода</b>", use_markup=True)
        self.pack_start(title, False, False, 0)
        
        # Город по умолчанию
        self.city = "Москва"
        
        # Метка для погоды
        self.weather_label = Gtk.Label(label="Загрузка...")
        self.pack_start(self.weather_label, False, False, 0)
        
        # Кнопка обновления
        btn_refresh = Gtk.Button(label="🔄 Обновить")
        btn_refresh.connect("clicked", self.on_refresh_clicked)
        self.pack_start(btn_refresh, False, False, 0)
        
        # Поле для ввода города
        self.city_entry = Gtk.Entry()
        self.city_entry.set_placeholder_text("Город...")
        self.city_entry.set_text(self.city)
        self.pack_start(self.city_entry, False, False, 0)
        
        # Кнопка поиска
        btn_search = Gtk.Button(label="🔍 Найти")
        btn_search.connect("clicked", self.on_search_clicked)
        self.pack_start(btn_search, False, False, 0)
        
        # Загружаем погоду при старте
        self.update_weather()
    
    def get_title(self):
        return "Погода"
    
    def update_weather(self):
        """Обновляет погоду через wttr.in"""
        try:
            result = subprocess.run(
                ["curl", "-s", f"https://wttr.in/{self.city}?format=%C+%t"],
                capture_output=True, text=True
            )
            if result.returncode == 0:
                weather = result.stdout.strip()
                self.weather_label.set_text(f"Погода в {self.city}: {weather}")
            else:
                self.weather_label.set_text("Ошибка при загрузке погоды")
        except Exception as e:
            self.weather_label.set_text(f"Ошибка: {e}")
    
    def on_refresh_clicked(self, button):
        self.update_weather()
    
    def on_search_clicked(self, button):
        self.city = self.city_entry.get_text()
        if self.city:
            self.update_weather()