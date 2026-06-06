{ config, ... }:
{

  services.sonarr = {
    enable = true;
    group = "media";
  };

  reverseProxy.hosts.sonarr.httpPort = config.services.sonarr.settings.server.port;

}