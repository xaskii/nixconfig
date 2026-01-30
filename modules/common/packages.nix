{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # editors
    vim
    neovim
    nvimpager

    # system monitoring
    htop
    btop

    # version control
    git
    git-lfs
    jujutsu
    difftastic
    mergiraf
    lazygit
    delta
    gh

    # shell tools
    wget
    fish
    nushell
    bash
    zsh-completions
    zsh-vi-mode
    starship
    carapace # for nushell
    # inshellisense
    atuin
    uv
    python313

    # search & navigation
    ripgrep
    vivid
    tlrc
    stow
    skim
    fzf
    fd
    zoxide

    # file management
    zip
    unzip
    _7zz
    rsync
    rclone
    duf
    eza
    dua
    yazi
    ranger

    # network tools
    aria2
    bandwhich
    curl
    curlie
    curl-impersonate
    dig
    doggo
    mtr
    whois
    xh
    gnupg
    mkcert

    # data processing
    jq
    htmlq

    # multiplexers
    tmux
    zellij

    # media
    imagemagick
    exiftool
    bat
    ffmpeg

    # system tools
    coreutils
    file
    lsof
    watchman
    shellcheck
    shfmt
    stylua
    taplo
    tex-fmt

    # nix tools
    agenix
    nh
    nil
    nixfmt
    statix

    # misc
    just
    fastfetch
    helix
    lolcat
    parallel
  ] ++ lib.optionals config.isDesktop (with pkgs; [
    # development toolchain
    clang-tools
    lld
    bun
    go
    bear
    nodejs
    biome
    cmake
    deno
    gnumake
    mise
    ninja
    niv
    ruff
    rustup
    cargo-audit
    cargo-binstall
    cargo-nextest
    bacon
    zig

    devenv
    docker
    pnpm
    qbittorrent
    weechat
  ]);
}
