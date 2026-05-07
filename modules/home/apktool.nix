{ pkgs, ... }:
{
  home.packages = with pkgs; [
    apktool
    apksigner
  ];
}

