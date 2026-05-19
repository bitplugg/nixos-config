{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    python3
    python3Packages.requests
    qt5.qtwayland  # Поддержка Wayland
    qt5.qtdeclarative  # Для qmlscene/qml
      # Для установки зависимостей
  ];

  # Автозагрузка виджета погоды в Hyprland
  xdg.configFile."hypr/autostart.conf".text = ''
    exec = quickshell ${./widgets/openclaw_widget.qs}
  '';

  # Горячие клавиши для Hyprland
  xdg.configFile."hypr/keybinds.conf".text = ''
    bind = CTRL ALT W, exec, quickshell ${./widgets/kew_widget.qs}
    bind = CTRL ALT D, exec, quickshell ${./widgets/openclaw_widget.qs}
    bind = CTRL ALT P, exec, quickshell ${./widgets/wallpaper_widget.qs}
  '';

  # Настройка Qt для работы в Wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_PLUGIN_PATH = "${pkgs.qt5.qtbase}/lib/qt-5.15.8/plugins";
  };

  # Создаём команду для скачивания обоев
  home.file.".local/bin/wallpaper-downloader".source = ./scripts/wallpaper_downloader.py;
  home.file.".local/bin/wallpaper-downloader".executable = true;
}
