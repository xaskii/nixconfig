{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.bpftools
    pkgs.bpftrace
  ];
}
