{ config, pkgs, ... }:
let
  vars = {
    homeassistant = {
      version = "2026.4";
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
      devices = ["/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_a68e70185c5aee11a3358cdc8ffcc75d-if00-port0:/dev/ttyUSB0"];
      extraOptions = [
        "--network=host"
      ];
    };

    nut-upsd = {
      environment = {
        USER = "nut";
        SERIAL = "0B2143N07825";
	PORT = "auto";
      };
      environmentFiles = [
        config.sops.templates."nut-upsd-secrets.env".path
      ];
      image = "instantlinux/nut-upsd:${vars.nut-upsd.version}";
      devices = ["/dev/bus/usb/003/002:/dev/bus/usb/003/002"];
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
