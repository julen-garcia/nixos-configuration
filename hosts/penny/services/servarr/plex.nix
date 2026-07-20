{ config, ... }:
{

  services.plex = {
    enable = true;
    group = "media";
  };

  reverseProxy.hosts.plex.httpPort = config.services.plex.settings.server.port;

}