{ config, lib, pkgs, self, ... }:

{
  environment.systemPackages = [
    pkgs.bubblewrap
    pkgs.man-pages
    pkgs.tcpdump
    pkgs.perf
    pkgs.wireguard-tools
    pkgs.socat
  ] ++ lib.optionals config.isDesktop [
    pkgs.sbctl
    pkgs.efibootmgr
  ];

  home-manager.sharedModules = [
    {
      home.packages = lib.optionals config.isDesktop [
        pkgs.llvmPackages.libcxxClang

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
        pkgs.mullvad-browser

        # media
        pkgs.mpv
        pkgs.haruna
        self.packages.${pkgs.stdenv.hostPlatform.system}.jellyfin
        pkgs.qbittorrent-nox
        pkgs.transmission_4

        # development
        pkgs.rust-jemalloc-sys
        pkgs.rustPlatform.bindgenHook
      ];
    }
  ];
}
