{ ... }:

{
  # Graphics configuration
  hardware.graphics.enable = true;

  hardware.nvidia.open = true;

  services.xserver.videoDrivers = [ "nvidia" ];
}
