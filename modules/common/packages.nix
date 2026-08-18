{ config, lib, pkgs, ... }:

let
  userPackages = [
    # editors
    pkgs.vim
    pkgs.neovim
    pkgs.nvimpager

    # system monitoring
    pkgs.htop
    pkgs.btop

    # version control
    pkgs.git
    pkgs.git-lfs
    pkgs.jujutsu
    pkgs.difftastic
    pkgs.mergiraf
    pkgs.lazygit
    pkgs.delta
    pkgs.gh

    # shell tools
    pkgs.wget
    pkgs.fish
    pkgs.nushell
    pkgs.bash
    pkgs.zsh-completions
    pkgs.zsh-vi-mode
    pkgs.carapace # for nushell
    # inshellisense
    pkgs.atuin
    pkgs.uv
    pkgs.python313
    pkgs.uutils-coreutils

    # search & navigation
    pkgs.ripgrep
    pkgs.vivid
    pkgs.tlrc
    pkgs.stow
    pkgs.fzf
    pkgs.fd
    pkgs.zoxide

    # file management
    pkgs.zip
    pkgs.unzip
    pkgs._7zz
    pkgs.rsync
    pkgs.rclone
    pkgs.duf
    pkgs.eza
    pkgs.dua
    pkgs.yazi

    # network tools
    pkgs.aria2
    pkgs.bandwhich
    pkgs.curl
    pkgs.curlie
    pkgs.curl-impersonate
    pkgs.dig
    pkgs.doggo
    pkgs.mtr
    pkgs.whois
    pkgs.xh
    pkgs.gnupg
    pkgs.mkcert

    # data processing
    pkgs.jq
    pkgs.htmlq

    # multiplexers
    pkgs.tmux
    pkgs.zellij

    # media
    pkgs.imagemagick
    pkgs.exiftool
    pkgs.bat
    pkgs.ffmpeg

    # system tools
    pkgs.coreutils
    pkgs.file
    pkgs.lsof
    pkgs.watchman
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.stylua
    pkgs.taplo
    pkgs.tex-fmt

    # nix tools
    pkgs.agenix
    pkgs.nh
    pkgs.nil
    pkgs.nixfmt
    pkgs.statix

    # misc
    pkgs.just
    pkgs.fastfetch
    pkgs.helix
    pkgs.lolcat
    pkgs.parallel
  ] ++ lib.optionals config.isDesktop [
    # development toolchain
    pkgs.clang-tools
    pkgs.lld
    pkgs.bun
    pkgs.go
    pkgs.bear
    pkgs.nodejs
    pkgs.cmake
    pkgs.deno
    pkgs.gnumake
    pkgs.ninja
    pkgs.niv
    pkgs.ruff
    pkgs.rustup
    pkgs.cargo-audit
    pkgs.cargo-binstall
    pkgs.cargo-nextest
    pkgs.zig

    # pkgs.devenv
    pkgs.docker
    pkgs.pnpm
    pkgs.qbittorrent
    pkgs.weechat
  ];
in
{
  # Keep a small recovery toolset available to root and system services.
  environment.systemPackages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.vim
    pkgs.git
    pkgs.jujutsu
    pkgs.ripgrep
    pkgs.curl
    pkgs.jq
    pkgs.file
    pkgs.lsof
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin userPackages;

  home-manager.sharedModules = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    { home.packages = userPackages; }
  ];
}
