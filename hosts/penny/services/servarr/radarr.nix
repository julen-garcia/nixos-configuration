{ config, ... }:
{

  services.radarr = {
    enable = true;
    group = "media";
  };

  reverseProxy.hosts.radarr.httpPort = config.services.radarr.settings.server.port;

}