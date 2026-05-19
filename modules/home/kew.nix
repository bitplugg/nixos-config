# kew - консольный музыкальный плеер + kew-video
{ config, pkgs, ... }:

let
  kew-video = pkgs.writeShellScriptBin "kew-video" ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.python3}/bin/python3 ${./scripts/kew-video} "$@"
  '';
in {
  home.packages = with pkgs; [
    kew
    kew-video  # Добавляем kew-video как команду
  ];

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