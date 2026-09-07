{ config, lib, pkgs, ... }:

lib.mkIf config.isDesktop {
  # Keep the existing login manager and launch Niri as the desktop session.
  services.xserver.enable = true;
  services.displayManager.plasma-login-manager.enable = true;
  services.displayManager.defaultSession = "niri";
  programs.niri.enable = true;

  # Niri's default config launches Waybar and binds fuzzel and swaylock.
  # Alacritty is already installed by the desktop package profile.
  environment.systemPackages = with pkgs; [
    fuzzel
    swaylock
    waybar
    xwayland-satellite
  ];
  security.pam.services.swaylock = {};

  home-manager.sharedModules = [ {
    services.mako.enable = true;
    services.polkit-gnome.enable = true;
  } ];

  # Configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS for printing
  services.printing.enable = true;
}
