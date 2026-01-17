{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
} // lib.mkIf config.isDesktop {
  # Various services
  services.jellyfin = {
    enable = true;
    user = "spring";
    openFirewall = true;
  };

  services.flatpak.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  services.udev.packages = with pkgs; [
    wooting-udev-rules
  ];
}
