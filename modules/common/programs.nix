{ pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.direnv.enable = true;
  programs.nix-index.enable = true;
}
