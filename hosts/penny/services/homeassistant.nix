{ config, pkgs, ... }:
let
  vars = {
    homeassistant = {
      version = "2026.2";
      port = 8123;
    };
    nut-upsd = {
      version = "latest";
      port = 3493;
    };
  };
in
{
  # Import the needed secrets
  sops = {
    secrets = {
      "nut-upsd/api-user" = {
        sopsFile = ../secrets.yaml;
      };
      "nut-upsd/api-password" = {
        sopsFile = ../secrets.yaml;
      };
    };
    templates."nut-upsd-secrets.env" = {
      content = ''
        API_USER=${config.sops.placeholder."nut-upsd/api-user"}
        API_PASSWORD=${config.sops.placeholder."nut-upsd/api-password"}
      '';
    };
  };

  virtualisation.oci-containers.containers = {
    homeassistant = {
      volumes = [ 
        "homeassistant:/config" 
        "/zstorage/internal-backups/home-assistant:/config/backups"
      ];
      environment = {
        TZ = "Europe/Madrid";
        PUID = "1000";
        PGID = "1000";
        UMASK = "007";
        PACKAGES = "iputils";
      };
      image = "ghcr.io/home-assistant/home-assistant:${vars.homeassistant.version}";
      extraOptions = [
        "--network=host"
      ];
    };

    nut-upsd = {
      environment = {
        USER = "nut";
        SERIAL = "0B2143N07825";
      };
      environmentFiles = [
        config.sops.templates."nut-upsd-secrets.env".path
      ];
      image = "instantlinux/nut-upsd:${vars.nut-upsd.version}";
      ports = [ 
        "${toString vars.nut-upsd.port}:${toString vars.nut-upsd.port}"
      ];
    };

  };


  reverseProxy.hosts = {
    casa.httpPort = 8123;
  };

  # backup-offsite-landabarri.job.home-assistant = {
  #   paths = [
  #     "/zstorage/backups/home-assistant"
  #   ];
  # };
}
