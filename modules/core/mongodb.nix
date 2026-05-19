{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mongodb;
in
{
  options.services.mongodb = {
    enable = mkEnableOption "MongoDB";
    package = mkPackageOption pkgs "mongodb" {
      default = pkgs.mongodb-ce;
      example = "pkgs.mongodb-ce-7_0";
    };
    enableAuth = mkEnableOption "MongoDB authentication" // { default = false; };
    bind_ip = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Interfaces for MongoDB to listen on";
    };
    port = mkOption {
      type = types.port;
      default = 27017;
      description = "Port for MongoDB to listen on";
    };
    dbPath = mkOption {
      type = types.path;
      default = "/var/lib/mongodb";
      description = "Path for MongoDB data directory";
    };
    initialRootPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "File containing the initial root password for MongoDB";
    };
  };

  config = mkIf cfg.enable {
    services.mongodb = {
      enable = true;
      package = cfg.package;
      enableAuth = cfg.enableAuth;
      bind_ip = cfg.bind_ip;
      port = cfg.port;
      dbPath = cfg.dbPath;
      initialRootPasswordFile = cfg.initialRootPasswordFile;
    };

    environment.systemPackages = [ cfg.package ];

    # Если включена аутентификация и указан файл с паролем
    assertions = [
      {
        assertion = cfg.enableAuth -> cfg.initialRootPasswordFile != null;
        message = "MongoDB authentication requires initialRootPasswordFile to be set";
      }
    ];
  };
}
