{ ... }:

{
  # Enable X11 and KDE Plasma
  services.xserver.enable = true;
  # services.gnome.gnome-remote-desktop.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS for printing
  services.printing.enable = true;
}
