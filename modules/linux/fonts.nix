{ config, lib, pkgs, ... }:

lib.mkIf config.isDesktop {
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
      pkgs.noto-fonts-cjk-sans
      pkgs.iosevka-bin
      pkgs.jetbrains-mono
    ];
    fontconfig.useEmbeddedBitmaps = true; # for emojis on firefox
  };
}
