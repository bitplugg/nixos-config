# modules/home/gradle.nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gradle
    jdk17 # Или другая нужная тебе версия JDK
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
  };

  # Опционально: настройка глобального файла конфигурации Gradle
  home.file.".gradle/gradle.properties".text = ''
    org.gradle.java.home=${pkgs.jdk17}/lib/openjdk
  '';
}
