lib: {
  class = "nixos";
  config = lib.nixosSystem' ({ config, lib, pkgs, inputs, ... }: {
    imports = [
      ./hardware.nix
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

  networking.hostName = "unagi";

  users.users.spring = {
    isNormalUser = true;
    description = "spring";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7ISHEtrXPczITdF5vOOJGSqmsTBG7nkRccQJzgolhG spring@life"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEDheq2VO1MROtfrod8szRaqaTrWX1A5riZOuzgD1zu spring@life.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcBV7sB6ZBziiJy1Z3q8zNDOXRIBqjw4aoYln8UN6QY XAVIIIII"
    ];
  };

  home-manager.users.spring.home = {
    stateVersion  = "24.11";
    homeDirectory = "/home/spring";
  };

  system.stateVersion = "24.11";
  });
}
