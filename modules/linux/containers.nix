{ config, pkgs, lib, ... }:

{
  # Only enable on unagi
  config = lib.mkIf (config.networking.hostName == "unagi") {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    age.secrets.gluetun-env.file = ../../secrets/gluetun.env.age;

    virtualisation.oci-containers = {
      backend = "podman";
      containers = {
        gluetun = {
          image = "qmcgaw/gluetun";
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--device=/dev/net/tun:/dev/net/tun"
          ];
          ports = [ "1080:1080" ];
          environmentFiles = [ config.age.secrets.gluetun-env.path ];
          environment = {
            VPN_SERVICE_PROVIDER = "mullvad";
            VPN_TYPE = "wireguard";
            DNS_SERVER = "off";
          };
        };
        socks5 = {
          image = "serjs/go-socks5-proxy";
          dependsOn = [ "gluetun" ];
          extraOptions = [ "--network=container:gluetun" ];
          environment = {
            REQUIRE_AUTH = "false";
            PROXY_LOG = "true";
          };
        };
      };
    };

    # Restart containers when secrets change
    systemd.services.podman-gluetun.restartTriggers = [
      config.age.secrets.gluetun-env.file
    ];
  };
}
