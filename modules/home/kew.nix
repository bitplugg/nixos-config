# kew - консольный музыкальный плеер + kew-video
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kew
    mpv          # Плеер для видео
    python3      # Для запуска скрипта
  ];

  # Создаём команду kew-video из локального скрипта
  home.file.".local/bin/kew-video".source = ./scripts/kew-video;
  home.file.".local/bin/kew-video".executable = true;

  # Настройка горячих клавиш (опционально)
  home.keyboard = {
    enabled = true;
    extraConfig = ''
      # Пример: запуск kew по Ctrl+Alt+M
      control + alt + m = "exec kew";
      # Запуск kew-video по Ctrl+Alt+V
      control + alt + v = "exec kew-video --playlist";
    '';
  };

  # Создаём исполняемые алиасы в ~/.local/bin
  home.file = {
    ".local/bin/kew-video".text = ''
      #!${pkgs.runtimeShell}
      exec kew-video "$@"
    '';
    ".local/bin/kew-video".executable = true;

    ".local/bin/openclaw-widget".text = ''
      #!${pkgs.runtimeShell}
      exec quickshell ${./quickshell/widgets/openclaw_widget.qs} "$@"
    '';
    ".local/bin/openclaw-widget".executable = true;

    ".local/bin/kew-widget".text = ''
      #!${pkgs.runtimeShell}
      exec quickshell ${./quickshell/widgets/kew_widget.qs} "$@"
    '';
    ".local/bin/kew-widget".executable = true;

    ".local/bin/wallpaper-widget".text = ''
      #!${pkgs.runtimeShell}
      exec quickshell ${./quickshell/widgets/wallpaper_widget.qs} "$@"
    '';
    ".local/bin/wallpaper-widget".executable = true;
  };

  # Автозапуск виджетов
  home.activation = {
    runAfterHomeManagerSwitch = [
      "openclaw-widget &"
      "kew-widget &"
    ];
  };
}

