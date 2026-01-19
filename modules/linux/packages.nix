{ config, lib, pkgs, ... }:

{
  environment.systemPackages = (with pkgs; [
    clang
    clang-tools
    bandwhich
    tcpdump
    llvmPackages.libcxxClang
  ]) ++ lib.optionals config.isDesktop (with pkgs; [
    # terminal tools
    nvtopPackages.nvidia
    wl-clipboard

    # terminals
    kitty
    ghostty
    alacritty

    # gui apps
    google-chrome
    spotify
    vesktop
    discord
    brave
    vscode-fhs
    code-cursor-fhs
    mullvad-browser

    # media
    mpv
    jellyfin
    qbittorrent
    qbittorrent-nox
    transmission_4

    # development
    sbctl
    rust-jemalloc-sys
    rustPlatform.bindgenHook
    cargo-nextest

    # system monitoring (nvidia specific)
    btop-cuda
  ]);
}
