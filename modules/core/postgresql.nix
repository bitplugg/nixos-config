{ config, pkgs, lib, ... }:
{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "msf" ];
    ensureUsers = [
      {
        name = "msf";
        ensureDBOwnership = true;   # даёт пользователю все права на базу msf
      }
    ];
  };

  services.postgresql.authentication = lib.mkOverride 10 ''
    local all msf trust
    host all msf 127.0.0.1/32 trust
    host all msf ::1/128 trust
  '';
}
