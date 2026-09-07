{ config, lib, pkgs, ... }:

lib.mkIf config.isDesktop {
  programs.niri.enable = true;
  # Let standalone KDE applications find plugins installed in Nix profiles.
  qt.enable = true;
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
    kdePackages.kio-extras
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    kdePackages.kservice
  ];
  # KService needs a menu to discover applications outside Plasma.
  environment.etc."xdg/menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <Include><All/></Include>
    </Menu>
  '';
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
