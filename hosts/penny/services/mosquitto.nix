{ config, pkgs, ... }:

let
  tlsPort = 8883;
  port = 1883;
  domain = "mqtt";
  baseDomain = "junaga.com";

  certDir = config.security.acme.certs."${domain}.${baseDomain}".directory;

in
{

  # Import the needed secrets
  sops = {
    secrets = {
      "cloudflare-api-token" = {
        sopsFile = ../secrets.yaml;
      };
      "mqtt/mosquitto-password" = {
        sopsFile = ../secrets.yaml;
      };
    };
    templates."acme-secrets.env" = {
      content = ''
        CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare-api-token"}
        CLOUDFLARE_PROPAGATION_TIMEOUT=600
        CLOUDFLARE_POLLING_INTERVAL=10
      '';
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "junaga@junaga.com";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      environmentFile = config.sops.templates."acme-secrets.env".path;
    };
  };

  # Allow Mosquitto to read the TLS private key
  users.groups.acme.members = [ "mosquitto" ];
  security.acme.certs."${domain}.${baseDomain}" = {
    reloadServices = [
      "mosquitto"
    ];
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = port;
        address = "0.0.0.0";
        settings = {
          allow_anonymous = false;
        };
        users.mosquitto = {
          acl = [
            "readwrite #"
          ];
          passwordFile = config.sops.secrets."mqtt/mosquitto-password".path;
        };
      }
      {
        port = tlsPort;

        settings = {
          allow_anonymous = false;

          certfile = "${certDir}/cert.pem";
          keyfile = "${certDir}/key.pem";
          cafile = "${certDir}/chain.pem";

          tls_version = "tlsv1.2";
        };

        users.mosquitto = {
          acl = [
            "readwrite #"
          ];
          passwordFile = config.sops.secrets."mqtt/mosquitto-password".path;
        };
      }
    ];
  };

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ port tlsPort ];

  };
}

