{ config, lib, ... }:

lib.mkIf (config.networking.hostName == "unagi") {
  services.soju = {
    enable = true;
    hostName = "soju.internal.xaskii.com";
    listen = [ "irc+insecure://100.75.147.105:6667" ];
  };

  systemd.services.soju = {
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 6667 ];
}
