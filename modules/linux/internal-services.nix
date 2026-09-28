{
  config,
  pkgs,
  ...
}:

let
  tailscaleBoundService = {
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
  };
in
{
  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;

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
          100.75.147.105 media.internal.xaskii.com
          100.75.147.105 qbit.internal.xaskii.com
          100.75.147.105 soju.internal.xaskii.com
          fallthrough
        }
        forward . 1.1.1.1 1.0.0.1
        errors
      }
    '';
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-tubXIDCJnO2mvdnPlZclwDhNGaeeYLSt7lnni3+pXDo=";
    };
    environmentFile = config.age.secrets.cloudflare-caddy-env.path;

    virtualHosts."jellyfin.internal.xaskii.com".extraConfig = ''
      bind 100.75.147.105
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
      reverse_proxy 127.0.0.1:8096
    '';

    virtualHosts."media.internal.xaskii.com".extraConfig = ''
      bind 100.75.147.105
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }

      handle /sonarr* {
        reverse_proxy 127.0.0.1:8989
      }

      handle /radarr* {
        reverse_proxy 127.0.0.1:7878
      }

      handle /prowlarr* {
        reverse_proxy 127.0.0.1:9696
      }

      handle {
        reverse_proxy 127.0.0.1:5055
      }
    '';

    virtualHosts."qbit.internal.xaskii.com".extraConfig = ''
      bind 100.75.147.105
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
      reverse_proxy 127.0.0.1:8080
    '';
  };

  systemd.services = {
    coredns = tailscaleBoundService;
    caddy = tailscaleBoundService;
  };
}
