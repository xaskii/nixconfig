{ config, lib, ... }:

{
  programs.zoxide.enable = true;
  programs.mosh.enable = true;
  programs.nix-ld.enable = true;

  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;

  documentation.man = {
    generateCaches = false; # speeds up rebuilds
  };
} // lib.mkIf config.isDesktop {
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.kdeconnect.enable = true;

  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "lkbebcjgcmobigpeffafkodonchffocl;https://gitflic.ru/project/magnolia1234/bpc_updates/blob/raw?file=updates.xml"
  ];
}
