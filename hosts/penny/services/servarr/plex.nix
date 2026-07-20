{ config, ... }:
let
  port = 32400;
in
{

  services.plex = {
    enable = true;
    group = "media";
  };

  reverseProxy.hosts.plex.httpPort = port;

}
