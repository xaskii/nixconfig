{ config, pkgs, ... }:

{
  # Graphics configuration
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
