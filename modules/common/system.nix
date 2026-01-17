{ config, lib, ... }:
let
  inherit (builtins) splitString;
  inherit (lib) last mkOption types;
  hostSystem = (lib.systems.elaborate config.nixpkgs.hostPlatform).system;
in
{
  options = {
    os = mkOption {
      type = types.str;
      readOnly = true;
      default = last (splitString "-" hostSystem);
    };

    isLinux = mkOption {
      type = types.bool;
      readOnly = true;
      default = config.os == "linux";
    };

    isDarwin = mkOption {
      type = types.bool;
      readOnly = true;
      default = config.os == "darwin";
    };

    type = mkOption {
      type = types.enum [ "server" "desktop" ];
      default = "server";
    };

    isDesktop = mkOption {
      type = types.bool;
      readOnly = true;
      default = config.type == "desktop";
    };

    isServer = mkOption {
      type = types.bool;
      readOnly = true;
      default = config.type == "server";
    };
  };
}
