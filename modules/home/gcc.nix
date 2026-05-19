{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    musl
    meson
    ninja
#    make
    pkg-config
    git
    curl
    json_c
#    ncurses
    readline
    libxcrypt
    libxkbfile # нужен для раскладки клавиатуры (xkbfile)
  ];
}
