{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pipx  # Утилита для установки Python-приложений в изолированные окружения
    aider-chat
  ];
}
