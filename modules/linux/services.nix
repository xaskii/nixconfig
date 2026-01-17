{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
} // lib.mkIf config.isDesktop {
  services.jellyfin = {
    enable = true;
    user = "spring";
    openFirewall = true;
  };

  services.flatpak.enable = true;
  services.udev.packages = with pkgs; [
    wooting-udev-rules
  ];
}
