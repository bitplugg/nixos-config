{ pkgs, ... }:
{
  home.packages = with pkgs; [
    apktool
    apksigner
    jadx
    android-build-tools
  ];
}

