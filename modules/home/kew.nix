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

  # Alias для виджетов
  home.aliases = {
    "kew-video" = "kew-video";
    "openclaw-widget" = "quickshell ${./quickshell/widgets/openclaw_widget.qs}";
    "kew-widget" = "quickshell ${./quickshell/widgets/kew_widget.qs}";
    "wallpaper-widget" = "quickshell ${./quickshell/widgets/wallpaper_widget.qs}";
  };

  # Автозапуск виджетов
  home.activation = {
    runAfterHomeManagerSwitch = [
      "openclaw-widget &"
      "kew-widget &"
    ];
  };
}

