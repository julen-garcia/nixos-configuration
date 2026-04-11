{ config, ... }:
{
  # Import the needed secrets
  sops = {
    secrets = {
      "ntfy/julen-password" = {
        sopsFile = ../secrets.yaml;
      };
      "ntfy/penny-password" = {
        sopsFile = ../secrets.yaml;
      };
      "ntfy/penny-zfs-token" = {
        sopsFile = ../secrets.yaml;
      };
    };
    templates."ntfy-secrets.env" = {
      content = ''
        NTFY_AUTH_USERS="julen:${config.sops.placeholder."ntfy/julen-password"}:admin,penny:${config.sops.placeholder."ntfy/penny-password"}:user"
        NTFY_AUTH_TOKENS="penny:${config.sops.placeholder."ntfy/penny-zfs-token"}:penny-zfs"
      '';
    };
  };

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.junaga.com";
      listen-http = ":34567";
      behind-proxy = true;
      auth-default-access = "deny-all";
      enable-login = true;
      auth-access = [
        "penny:penny:rw"
      ];
    };
    environmentFile = config.sops.templates."ntfy-secrets.env".path;
  };

  reverseProxy.hosts.ntfy.httpPort = 34567;

}