{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pipx  # Утилита для установки Python-приложений в изолированные окружения
    aider-chat
    python3Packages.beautifulsoup4
    python3Packages.requests
  ];
}
