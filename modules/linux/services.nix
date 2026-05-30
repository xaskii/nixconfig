{
  config,
  lib,
  pkgs,
  ...
}:

lib.merge
  {
    age.secrets.cloudflare-tunnel-home = {
      file = ../../secrets/cloudflared-home.json.age;
      mode = "0400";
    };
    services.cloudflared = {
      enable = true;
      tunnels."be1dcf24-b86d-4e91-b671-312f2b85e5e1" = {
        credentialsFile = config.age.secrets.cloudflare-tunnel-home.path;
        warp-routing.enabled = true;
        default = "http_status:404";
      };
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  }
  (
    lib.mkIf config.isDesktop {
      services.jellyfin = {
        enable = true;
        user = "spring";
        openFirewall = true;
      };

      services.flatpak.enable = true;
      services.udev.packages = [
        pkgs.wooting-udev-rules
      ];
    }
  )
