{ config, ... }:
let
  port = 32400;
in
{

  services.plex = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  reverseProxy.hosts.plex.httpPort = port;

}
