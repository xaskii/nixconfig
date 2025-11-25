{ config, pkgs, lib, ... }:

{
  # Bootloader configuration
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
