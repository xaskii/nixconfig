{ ... }:

{
  networking.firewall.interfaces."enp13s0".allowedTCPPorts = [
    8080
    1080
  ];
}
