{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    nvimpager
    htop
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
    skim
    fd
    ruff
    duf
    jq
    htmlq
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
    bear
    cmake
    watchman
    doggo
    mise

    # tuis
    dua
    lazygit
    delta
    yazi
    tmux
    zellij

    nh # this is really fucking good wth
    nil
    nixfmt-rfc-style

    # (ffmpeg-full.override { withUnfree = true; })
    # ((ffmpeg-full.override { withUnfree = true; }).overrideAttrs (_: { doCheck = false; }))
    ffmpeg-full
    # ffmpeg

    # first gui app
    qbittorrent
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  # yeah idk idgaf
  users.users."spring".uid = 501;
  users.users."spring".shell = pkgs.fish;
  users.knownUsers = [ "spring" ];

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.nix-index.enable = true; # fixes the random error with wrong commands

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  system.primaryUser = "spring";
  system.defaults.screencapture.type = "jpeg";
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = config.rev or config.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
