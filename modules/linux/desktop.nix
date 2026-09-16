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
  fonts.fontconfig.defaultFonts.sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
  security.pam.services.swaylock = {};

  home-manager.sharedModules = [ {
    gtk = {
      enable = true;
      gtk2.enable = false;
      gtk4.theme = null;
      font = { name = "Noto Sans"; size = 10; package = pkgs.noto-fonts; };
      theme = { name = "Breeze-Dark"; package = pkgs.kdePackages.breeze-gtk; };
      colorScheme = "dark";
      iconTheme = { name = "breeze-dark"; package = pkgs.kdePackages.breeze-icons; };
      cursorTheme = { name = "breeze_cursors"; size = 16; package = pkgs.kdePackages.breeze; };
      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-xft-dpi = 98304;
        gtk-key-theme-name = "Emacs";
        gtk-decoration-layout = "icon:minimize,maximize,close";
        gtk-primary-button-warps-slider = true;
        gtk-sound-theme-name = "ocean";
      };
      gtk4.extraConfig = {
        gtk-theme-name = "Breeze-Dark";
        gtk-xft-dpi = 98304;
        gtk-key-theme-name = "Emacs";
        gtk-decoration-layout = "icon:minimize,maximize,close";
        gtk-primary-button-warps-slider = true;
        gtk-sound-theme-name = "ocean";
      };
    };
    # GTK on Wayland reads these ahead of the settings.ini rendering preferences.
    dconf.settings."org/gnome/desktop/interface" = {
      font-antialiasing = "rgba";
      font-hinting = "slight";
      font-rgba-order = "rgb";
      text-scaling-factor = 1.0;
    };
    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
      kde.settings.kdeglobals = {
        General = {
          ColorScheme = "BreezeDark";
          font = "Noto Sans,10,-1,5,400,0,0,0,0,0";
          menuFont = "Noto Sans,10,-1,5,400,0,0,0,0,0";
          toolBarFont = "Noto Sans,10,-1,5,400,0,0,0,0,0";
          taskbarFont = "Noto Sans,10,-1,5,400,0,0,0,0,0";
        };
        KDE.widgetStyle = "Breeze";
        Icons.Theme = "breeze-dark";
      };
    };
    services.mako.enable = true;
    services.polkit-gnome.enable = true;
    services.swayidle = {
      enable = true;
      systemdTargets = [ "graphical-session.target" ];
      timeouts = [
        {
          timeout = 60;
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
      ];
      events = {
        after-resume = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      };
    };
  } ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;
}
