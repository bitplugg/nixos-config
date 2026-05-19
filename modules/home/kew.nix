# kew - консольный музыкальный плеер
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kew
  ];

  # Настройка горячих клавиш (опционально)
  home.keyboard = {
    enabled = true;
    extraConfig = ''
      # Пример: запуск kew по Ctrl+Alt+M
      control + alt + m = "exec kew";
    '';
  };
}