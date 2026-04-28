# modules/home/llm-agents.nix
{ pkgs, inputs, ... }:

let
  llm-agents = inputs.llm-agents.packages.${pkgs.system};
in
{
  # Агенты вроде Claude Code требуют unfree-лицензии
  nixpkgs.config.allowUnfree = true;

  # Кэш Numtide, чтобы не собирать всё из исходников
  nix.settings = {
    substituters = [ "https://numtide.cachix.org" ];
    trusted-public-keys = [
      "numtide.cachix.org-1:9C9oA1JsdMP6PboNauC2A1ZrQqZnqDhMWOoKwmHJfHg="
    ];
  };

  home.packages = with llm-agents; [
    claude-code
    codex
    gemini-cli
    # copilot-cli  # раскомментируй, если нужен
  ];
}
