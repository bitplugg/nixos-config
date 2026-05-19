{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    yarn
    #    opencode-ai
    nodemon
    #    qwen
    docker
    docker-compose
    kubernetes
    claude-code
  ];
#  pkgs.brrfetch;
}
