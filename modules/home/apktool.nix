{ pkgs, ... }:
{
  home.packages = with pkgs; [
    apktool
    apksigner
    jadx
    dx
    d8
  ];
}

