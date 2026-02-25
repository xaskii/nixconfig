{ config, lib, pkgs, ... }:

lib.mkIf config.isDesktop {
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.adwaita-fonts
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
      pkgs.noto-fonts-cjk-sans
      pkgs.iosevka-bin
      pkgs.jetbrains-mono
    ];
    fontconfig = {
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      useEmbeddedBitmaps = true; # for emojis on firefox
      defaultFonts = {
        sansSerif = [ "Adwaita Sans" "Noto Sans CJK SC" ];
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        monospace = [ "JetBrains Mono" "Noto Sans Mono CJK SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
