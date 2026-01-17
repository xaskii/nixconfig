{ config, lib, pkgs, ... }:

{
  environment.systemPackages = lib.optionals config.isDesktop (with pkgs; [
    # terminal tools
    bandwhich
    nvtopPackages.nvidia
    tcpdump
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
    mpv
    vscode-fhs
    code-cursor-fhs
    mullvad-browser

    # media
    jellyfin
    qbittorrent
    qbittorrent-nox
    transmission_4

    # development
    sbctl
    rust-jemalloc-sys
    rustPlatform.bindgenHook
    cargo-nextest

    # toolchain (macOS has these built-in)
    gcc
    llvmPackages.libcxxClang
    clang-tools

    # system monitoring (nvidia specific)
    btop-cuda
  ]);
}
