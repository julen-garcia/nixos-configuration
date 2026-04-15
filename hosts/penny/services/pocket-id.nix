{ config, pkgs, ... }:
let
  version = "v2";
  data-directory = "/var/lib/pocketid";
  port = 1411;
  containerService = "podman-pocket-id";
  backupPath = "/zstorage/internal-backups/pocket-id/";
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
    "d ${backupPath} 0750 pocket-id pocket-id"
  ];

  virtualisation.oci-containers.containers.pocket-id = {
    image = "ghcr.io/pocket-id/pocket-id:${version}";

    ports = [
      "${toString port}:${toString port}"
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

  reverseProxy.hosts.pocketid.httpPort = port;

  systemd.services.pocket-id-backup = {
    description = "Backup pocket-id with service stop/start";

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      set -euo pipefail

      cleanup() {
        echo "Restarting service..."
        systemctl start ${containerService}.service
      }

      trap cleanup EXIT

      echo "Stopping service..."
      systemctl stop ${containerService}.service
      sleep 10s

      echo "Running backup..."
      mkdir -p ${backupPath}
      ${pkgs.rsync}/bin/rsync -a --delete ${data-directory}/ ${backupPath}

      echo "Backup done."
    '';
  };

  systemd.timers.pocket-id-backup = {
    description = "Periodic pocket-id backup";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Unit = "pocket-id-backup.service";
    };
  };
}


