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

  # Alias для kew (запуск kew-video из kew)
  home.aliases = {
    "kew-video" = "kew-video";
  };
}
}