{ config, lib, ... }:

lib.mkIf (config.networking.hostName == "unagi") {
  users.groups.media = { };

  users.users.spring.extraGroups = [ "media" ];

  systemd.tmpfiles.settings."10-media-stack" =
    let
      mediaDirectory = {
        user = "spring";
        group = "media";
        mode = "2775";
      };
    in
    {
      "/srv".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/srv/media".d = mediaDirectory;
      "/srv/media/torrents".d = mediaDirectory;
      "/srv/media/torrents/incomplete".d = mediaDirectory;
      "/srv/media/torrents/movies".d = mediaDirectory;
      "/srv/media/torrents/tv".d = mediaDirectory;
      "/srv/media/library".d = mediaDirectory;
      "/srv/media/library/movies".d = mediaDirectory;
      "/srv/media/library/tv".d = mediaDirectory;
      "/srv/media/library/anime".d = mediaDirectory;
    };

  services.seerr = {
    enable = true;
    port = 5055;
    openFirewall = false;
  };

  systemd.services.seerr.environment = {
    HOST = "127.0.0.1";
    HOSTNAME = "127.0.0.1";
  };

  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = false;
    settings = {
      server = {
        port = 8989;
        bindaddress = "127.0.0.1";
        urlbase = "/sonarr";
      };
      log.analyticsEnabled = false;
      update = {
        mechanism = "external";
        automatically = false;
      };
    };
  };

  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = false;
    settings = {
      server = {
        port = 7878;
        bindaddress = "127.0.0.1";
        urlbase = "/radarr";
      };
      log.analyticsEnabled = false;
      update = {
        mechanism = "external";
        automatically = false;
      };
    };
  };

  services.prowlarr = {
    enable = true;
    openFirewall = false;
    settings = {
      server = {
        port = 9696;
        bindaddress = "127.0.0.1";
        urlbase = "/prowlarr";
      };
      log.analyticsEnabled = false;
      update = {
        mechanism = "external";
        automatically = false;
      };
    };
  };
}
