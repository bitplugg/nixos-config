{ pkgs, ... }:
{
  home.packages = with pkgs; [
    apktool
    apksigner
    jadx
    d8
  ];
}

