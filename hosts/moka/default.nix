lib: {
  class = "nixos";
  config = lib.nixosSystem' ({ config, pkgs, ... }: {
    imports = [
      ./hardware.nix
    ];

    type = "server";

    networking.hostName = "moka";

    users.users.spring = {
      isNormalUser = true;
      description = "spring";
      extraGroups = [
        "wheel"
      ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7ISHEtrXPczITdF5vOOJGSqmsTBG7nkRccQJzgolhG xaskii"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEDheq2VO1MROtfrod8szRaqaTrWX1A5riZOuzgD1zu spring@four"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcBV7sB6ZBziiJy1Z3q8zNDOXRIBqjw4aoYln8UN6QY XAVIIIII"
      ];
    };
    users.users.root.openssh.authorizedKeys.keys =
      config.users.users.spring.openssh.authorizedKeys.keys;

    home-manager.users.spring.home = {
      stateVersion  = "24.11";
      homeDirectory = "/home/spring";
    };

    system.stateVersion = "24.11";
  });
}
