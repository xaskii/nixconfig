{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.iproute2mac
    pkgs.colima
    pkgs.swiftlint
  ];
}
