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
  programs.chromium.extensions = [];

  programs.command-not-found.enable = false;

  documentation.man = {
    generateCaches = false; # speeds up rebuilds
  };
}
