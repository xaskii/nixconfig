{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
    };
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = false;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  swapDevices = [ ];

  networking.useDHCP = true;
  nixpkgs.hostPlatform = "x86_64-linux";
}
