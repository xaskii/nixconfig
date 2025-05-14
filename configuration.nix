{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    nvimpager
    htop
    ffmpeg
    btop
    git
    wget

    # toolchain stuff, slowly migrating over
    nodejs

    ripgrep
    vivid
    gh
    neovim
    tlrc
    stow
    fzf
    fd
    ruff
    duf
    jq
    curlie
    xh
    eza
    bandwhich
    just
    biome
    fastfetch
    zoxide
    imagemagick
    exiftool
    bat

    # tuis
    dua
    lazygit
    delta
    yazi
    tmux
    zellij

    nil
    nixfmt-rfc-style
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # yeah idk idgaf
  users.users."spring".uid = 501;
  users.users."spring".shell = pkgs.fish;
  users.knownUsers = [ "spring" ];

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.nix-index.enable = true; # fixes the random error with wrong commands

  nix.optimise.automatic = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = config.rev or config.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
