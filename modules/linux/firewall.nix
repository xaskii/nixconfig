{ config, lib, ... }:

lib.mkIf config.isDesktop {
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [
      80
      443
      58703
    ];
    allowedUDPPorts = [
      58703
    ];
  };

  networking.nftables = {
    enable = true;
    tables.mullvad_exclusions = {
      family = "inet";
      content = ''
        set cf_tunnel_v4 {
          type ipv4_addr;
          elements = {
            198.41.192.167,
            198.41.192.67,
            198.41.192.57,
            198.41.192.107,
            198.41.192.27,
            198.41.192.7,
            198.41.192.227,
            198.41.192.47,
            198.41.192.37,
            198.41.192.77,
            198.41.200.13,
            198.41.200.193,
            198.41.200.33,
            198.41.200.233,
            198.41.200.53,
            198.41.200.63,
            198.41.200.113,
            198.41.200.73,
            198.41.200.43,
            198.41.200.23
          };
        }

        set cf_tunnel_v6 {
          type ipv6_addr;
          elements = {
            2606:4700:a0::1,
            2606:4700:a0::2,
            2606:4700:a0::3,
            2606:4700:a0::4,
            2606:4700:a0::5,
            2606:4700:a0::6,
            2606:4700:a0::7,
            2606:4700:a0::8,
            2606:4700:a0::9,
            2606:4700:a0::10,
            2606:4700:a8::1,
            2606:4700:a8::2,
            2606:4700:a8::3,
            2606:4700:a8::4,
            2606:4700:a8::5,
            2606:4700:a8::6,
            2606:4700:a8::7,
            2606:4700:a8::8,
            2606:4700:a8::9,
            2606:4700:a8::10
          };
        }

        chain output {
          type route hook output priority -100; policy accept;

          ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          ip daddr @cf_tunnel_v4 meta l4proto { tcp, udp } th dport 7844 \
            ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          ip6 daddr @cf_tunnel_v6 meta l4proto { tcp, udp } th dport 7844 \
            ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        }

        chain input {
          type filter hook input priority -100; policy accept;

          ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        }
      '';
    };
  };
}
