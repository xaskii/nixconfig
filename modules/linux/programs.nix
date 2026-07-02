{ pkgs, config, lib, ... }:

lib.merge
  {
    programs.zoxide.enable = true;
    programs.mosh.enable = true;
    programs.nix-ld.enable = true;
    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;

    documentation.man = {
      cache.enable = false; # speeds up rebuilds
    };
    documentation.dev.enable = true;
  }
  (lib.mkIf config.isDesktop {
    programs.firefox.enable = true;
    programs.steam.enable = true;
    programs.kdeconnect.enable = true;

    programs.chromium.enable = true;
    programs.chromium.extensions = [
      "lkbebcjgcmobigpeffafkodonchffocl;https://gitflic.ru/project/magnolia1234/bpc_updates/blob/raw?file=updates.xml"
    ];
  })
