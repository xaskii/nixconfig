{ config, lib, ... }:

lib.mkIf config.isDesktop {
  # Bluetooth
  hardware.bluetooth.enable = true;
}
