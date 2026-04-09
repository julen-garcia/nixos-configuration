{ config, ... }:
{
  imports = [
    ../../../modules/myservices/reverse-proxy.nix
  ];

  # Import the needed secrets
  sops = {
    secrets = {
      cloudflare-email = {
        sopsFile = ../secrets.yaml;
      };
      cloudflare-api-token = {
        sopsFile = ../secrets.yaml;
      };
    };
    templates."caddy-secrets.env" = {
      content = ''
        CF_EMAIL="${config.sops.placeholder.cloudflare-email}"
        CF_API_TOKEN="${config.sops.placeholder.cloudflare-api-token}"
      '';
      owner = config.reverseProxy.user;
    };
  };

  reverseProxy = {
    enable = true;
    baseDomain = "junaga.com";
    environmentFile = config.sops.templates."caddy-secrets.env".path;
    hosts = {
      router = {
        ip = "10.2.1.1";
        httpsPort = 443;
      };
    };
  };
}
