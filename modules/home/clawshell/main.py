#!/usr/bin/env python3
import gi
import json
import os

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk

# Загружаем конфиг
CONFIG_PATH = os.path.join(os.path.dirname(__file__), "config.json")

class ClawShell(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="ClawShell")
        self.set_default_size(800, 600)
        self.set_border_width(10)
        
        # Стиль Gruvbox (можно заменить на Catppuccin/Nord)
        css = b"""
        window {
            background-color: #282828;
            color: #ebdbb2;
        }
        button {
            background-color: #458588;
            color: #ebdbb2;
            border-radius: 5px;
            padding: 8px;
        }
        button:hover {
            background-color: #83a598;
        }
        stacksidebar {
            background-color: #3c3836;
        }
        """
        style_provider = Gtk.CssProvider()
        style_provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            style_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )
        
        # Боковая панель для плагинов
        self.sidebar = Gtk.StackSidebar()
        self.stack = Gtk.Stack()
        self.sidebar.set_stack(self.stack)
        
        # Загружаем плагины из конфига
        self.load_plugins()
        
        # Компоновка
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        hbox.pack_start(self.sidebar, False, False, 0)
        hbox.pack_start(self.stack, True, True, 0)
        self.add(hbox)
    
    def load_plugins(self):
        """Загружает плагины из config.json"""
        try:
            with open(CONFIG_PATH, "r") as f:
                config = json.load(f)
                for plugin_name in config.get("plugins", []):
                    try:
                        module = __import__(f"plugins.{plugin_name}", fromlist=["Plugin"])
                        plugin_class = getattr(module, "Plugin")
                        self.add_plugin(plugin_name, plugin_class())
                    except Exception as e:
                        print(f"Ошибка загрузки плагина {plugin_name}: {e}")
        except FileNotFoundError:
            print(f"Конфиг {CONFIG_PATH} не найден. Создайте его.")
    
    def add_plugin(self, name, widget):
        """Добавляет плагин в боковую панель"""
        self.stack.add_titled(widget, name, widget.get_title())

if __name__ == "__main__":
    win = ClawShell()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()