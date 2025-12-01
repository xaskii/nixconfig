{ pkgs, ... }:

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
    jujutsu
    lazygit
    delta
    gh

    # shell tools
    wget
    fish
    nushell
    starship
    carapace # for nushell
    inshellisense

    # development toolchain
    nodejs
    python313
    bun
    gnumake
    ruff
    uv
    biome
    mise
    bear
    cmake
    rustup
    niv

    # search & navigation
    ripgrep
    vivid
    tlrc
    stow
    skim
    fzf
    fd
    zoxide

    devenv

    # file management
    zip
    unzip
    _7zz
    duf
    eza
    dua
    yazi

    # network tools
    curlie
    xh
    doggo
    bandwhich
    aria2
    dig
    whois
    curl-impersonate-chrome

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
    file
    lsof
    watchman

    # nix tools
    nh
    nil
    nixfmt-rfc-style

    # misc
    just
    fastfetch
    docker
    qbittorrent
  ];
}
