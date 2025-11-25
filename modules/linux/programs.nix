{ ... }:

{
  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.zoxide.enable = true;
  programs.nix-ld.enable = true;
  programs.steam.enable = true;
  programs.kdeconnect.enable = true;

  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "lkbebcjgcmobigpeffafkodonchffocl;https://gitflic.ru/project/magnolia1234/bpc_updates/blob/raw?file=updates.xml"
  ];

  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;

  documentation.man = {
    generateCaches = false; # speeds up rebuilds
  };
}
