lib: {
  class = "nixos";
  config = lib.nixosSystem' ({ config, lib, pkgs, inputs, ... }: {
    imports = [
      ./hardware.nix
      ./home.nix
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

  type = "desktop";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.extraEntries."windows.conf" = ''
    title Windows
    efi /EFI/Microsoft/Boot/bootmgfw.efi
  '';
  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";


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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7ISHEtrXPczITdF5vOOJGSqmsTBG7nkRccQJzgolhG xaskii"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEDheq2VO1MROtfrod8szRaqaTrWX1A5riZOuzgD1zu spring@four"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcBV7sB6ZBziiJy1Z3q8zNDOXRIBqjw4aoYln8UN6QY XAVIIIII"
    ];
  };

  networking.firewall = {
    interfaces."eth0".allowedTCPPorts = [
      8080
      1080
      8188
    ];
    interfaces."tailscale0".allowedTCPPorts = [
      53
      443
      8080
      1080
    ];
    interfaces."tailscale0".allowedUDPPorts = [ 53 ];
  };

  system.stateVersion = "24.11";
  });
}
