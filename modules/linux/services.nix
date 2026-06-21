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
  (
    lib.mkIf (config.networking.hostName == "unagi") {
      age.secrets.cloudflare-caddy-env = {
        file = ../../secrets/cloudflare-caddy.env.age;
        mode = "0400";
      };

      services.coredns = {
        enable = true;
        config = ''
          internal.xaskii.com:53 {
            bind 100.75.147.105
            hosts {
              100.75.147.105 jellyfin.internal.xaskii.com
              100.75.147.105 qbit.internal.xaskii.com
              100.75.147.105 soju.internal.xaskii.com
            }
            errors
          }
        '';
      };

      services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
          hash = "sha256-i7OoxiHJ4Stfp7SnxOryLAXS6w5+PJCnEydOakhFYcE=";
        };
        environmentFile = config.age.secrets.cloudflare-caddy-env.path;

        virtualHosts."jellyfin.internal.xaskii.com".extraConfig = ''
          bind 100.75.147.105
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
          reverse_proxy 127.0.0.1:8096
        '';

        virtualHosts."qbit.internal.xaskii.com".extraConfig = ''
          bind 100.75.147.105
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
          reverse_proxy 127.0.0.1:8080 {
            header_up Host {upstream_hostport}
          }
        '';
      };

      systemd.services = {
        coredns = {
          after = [ "tailscaled.service" ];
          wants = [ "tailscaled.service" ];
        };
        caddy = {
          after = [ "tailscaled.service" ];
          wants = [ "tailscaled.service" ];
        };
      };
    }
  )
