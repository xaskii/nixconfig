{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
