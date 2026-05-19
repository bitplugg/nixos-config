{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.nix-openclaw.homeManagerModules.openclaw ];

  programs.openclaw = {
    enable = true;

    environment = {
      OPENROUTER_API_KEY = "/home/bitplugg/.secrets/openrouter.env";
      MISTRAL_API_KEY = "/home/bitplugg/.secrets/openclaw.env";
    };

    config = {
      gateway = {
        mode = "local";
        auth.token = "34bf26ab85cf282818e67e69f8556e7d9b594a6a0c8d8df9d250b5ca62808e5f";
      };
      agents.defaults.model = "mistral/mistral-large-latest";
      channels.telegram = {
        tokenFile = "/home/bitplugg/.secrets/telegram-bot-token";
        allowFrom = [ 7590598820 ];
      };
    };
  };
}
