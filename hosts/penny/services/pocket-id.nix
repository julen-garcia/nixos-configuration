{ config, ... }:
let
  data-directory = "/var/lib/pocketid";
in {
  # Import the needed secrets
  sops = {
    secrets = {
      "pocket-id/encryption-key" = {
        sopsFile = ../secrets.yaml;
        owner = config.services.pocket-id.user;
        group = config.services.pocket-id.group;
      };
    };
    templates."pocket-id-secrets.env" = {
      content = ''
        ENCRYPTION_KEY=${config.sops.placeholder."pocket-id/encryption-key"}
      '';
    };
  };

  users.groups.pocket-id = {};
  users.users.pocket-id = {
    group = "pocket-id";
    isSystemUser = true;
  };

  systemd.tmpfiles.rules = [
    "d ${data-directory} 0750 pocket-id pocket-id"
  ];

  virtualisation.oci-containers.containers.pocket-id = {
    image = "ghcr.io/pocket-id/pocket-id:v2";

    ports = [
      "1411:1411"
    ];

    volumes = [
      "${data-directory}:/app/data"
    ];

    environmentFiles = [ 
      config.sops.templates."pocket-id-secrets.env".path
    ];

    environment = {
      PUID = toString config.users.users.pocket-id.uid;
      PGID = toString config.users.groups.pocket-id.gid; 
      TRUST_PROXY = "true";
      APP_URL = "https://pocketid.junaga.com";
      ANALYTICS_DISABLED = "true";
      SMTP_HOST = "127.0.0.1";
      SMTP_PORT = "25";
      SMTP_FROM = "pocketid@junaga.com";
    };
  };

  reverseProxy.hosts.pocketid.httpPort = 1411;
}

