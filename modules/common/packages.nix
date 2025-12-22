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
    starship
    carapace # for nushell
    # inshellisense
    atuin

    # development toolchain
    # clang-tools
    # clang
    # lld
    bun
    go
    uv
    python313
    bear
    nodejs
    biome
    cmake
    deno
    gh
    gnumake
    mise
    ninja
    niv
    ruff
    rustup
    zig


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
    rsync
    rclone
    duf
    eza
    dua
    yazi

    # network tools
    aria2
    bandwhich
    curl
    curlie
    curl-impersonate-chrome
    dig
    doggo
    mtr
    whois
    xh

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
    statix

    # misc
    just
    fastfetch
    docker
    qbittorrent
  ];
}
