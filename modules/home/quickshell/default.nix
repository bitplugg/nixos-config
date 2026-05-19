{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    python3
    python3Packages.requests
    pipx  # Для установки зависимостей
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

  # Создаём команду для скачивания обоев
  home.file.".local/bin/wallpaper-downloader".source = ./scripts/wallpaper_downloader.py;
  home.file.".local/bin/wallpaper-downloader".executable = true;
}
