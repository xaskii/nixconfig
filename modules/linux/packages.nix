{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.clang
    pkgs.clang-tools
    pkgs.bandwhich
    pkgs.tcpdump
    pkgs.llvmPackages.libcxxClang
  ] ++ lib.optionals config.isDesktop [
    # terminal tools
    pkgs.nvtopPackages.nvidia
    pkgs.wl-clipboard

    # terminals
    pkgs.kitty
    pkgs.ghostty
    pkgs.alacritty

    # gui apps
    pkgs.google-chrome
    pkgs.spotify
    pkgs.vesktop
    pkgs.discord
    pkgs.brave
    pkgs.vscode-fhs
    pkgs.code-cursor-fhs
    pkgs.mullvad-browser

    # media
    pkgs.mpv
    pkgs.jellyfin
    pkgs.qbittorrent
    pkgs.qbittorrent-nox
    pkgs.transmission_4

    # development
    pkgs.sbctl
    pkgs.rust-jemalloc-sys
    pkgs.rustPlatform.bindgenHook
    pkgs.cargo-nextest

    # system monitoring (nvidia specific)
    pkgs.btop-cuda
  ];
}
