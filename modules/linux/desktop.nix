{ config, lib, pkgs, ... }:

lib.mkIf config.isDesktop {
  programs.niri.enable = true;
  services.displayManager.defaultSession = "niri";
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command =
      "${lib.getExe pkgs.tuigreet} --time --remember --cmd ${pkgs.niri}/bin/niri-session";
  };

  environment.systemPackages = with pkgs; [
    fuzzel
    swaylock
    waybar
    xwayland-satellite
  ];
  fonts.packages = [ pkgs.font-awesome ];
  security.pam.services.swaylock = {};

  home-manager.sharedModules = [ {
    services.mako.enable = true;
    services.polkit-gnome.enable = true;
  } ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;
}
