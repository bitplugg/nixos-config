{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python3
    python3Packages.pygobject3  # Для GTK
  ];

  # Создаём команду для запуска ClawShell
  home.file.".local/bin/clawshell".text = ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.python3}/bin/python3 ${./main.py}
  '';
  home.file.".local/bin/clawshell".executable = true;

  # Горячая клавиша для Hyprland
  xdg.configFile."hypr/keybinds.conf".text = ''
    bind = CTRL ALT C, exec, clawshell
  '';
}