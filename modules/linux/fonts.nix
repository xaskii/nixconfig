{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      iosevka-bin
      jetbrains-mono
    ];
    fontconfig.useEmbeddedBitmaps = true; # for emojis on firefox
  };
}
