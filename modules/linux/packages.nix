{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # terminal tools
    wl-clipboard
    bandwhich
    nvtopPackages.nvidia

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
  ];
}
