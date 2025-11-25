{ ... }:

{
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    interfaces."enp13s0".allowedTCPPorts = [
      8080
      1080
    ];
    interfaces."tailscale0".allowedTCPPorts = [
      8080
      1080
    ];
    allowedTCPPorts = [
      80
      443
      55334
    ];
    allowedUDPPorts = [
      55334
    ];
  };

  networking.nftables = {
    enable = true;
    tables.mullvad_tailscale = {
      family = "inet";
      content = ''
        chain output {
          type route hook output priority -100; policy accept;
          ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        }

        chain input {
          type filter hook input priority -100; policy accept;
          ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        }
      '';
    };
  };
}
