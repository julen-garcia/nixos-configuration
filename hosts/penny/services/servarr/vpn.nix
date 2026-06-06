{ config, ... }:
let
  vars = {
    config-path = "/var/lib/gluetun";
    version = "v3.41.0";
  };
in {
  # Import the needed secrets
  sops = {
    secrets = {
      "servarr-gluetun/vpn-service-provider" = {
        sopsFile = ../../secrets.yaml;
      };
      "servarr-gluetun/vpn-type" = {
        sopsFile = ../../secrets.yaml;
      };
      "servarr-gluetun/wireguard-private-key" = {
        sopsFile = ../../secrets.yaml;
      };
    };
    templates."servarr-vpn-secrets.env" = {
      content = ''
        VPN_SERVICE_PROVIDER=${config.sops.placeholder."servarr-gluetun/vpn-service-provider"}
        VPN_TYPE=${config.sops.placeholder."servarr-gluetun/vpn-type"}
        WIREGUARD_PRIVATE_KEY=${config.sops.placeholder."servarr-gluetun/wireguard-private-key"}
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d ${vars.config-path} 0750 root root -"
  ];

  virtualisation.oci-containers.containers.servarr-vpn = {
    image = "qmcgaw/gluetun:${vars.version}";

    extraOptions = [
        "--cap-add=net_admin"
    ];

    devices = [
      "/dev/net/tun:/dev/net/tun"
    ];

    volumes = [
      "${vars.config-path}:/gluetun"
    ];

    environment = {
      DOT_PROVIDERS = "cloudflare";
      HEALTH_TIMEOUT = "60s";
      TZ = "Europe/Madrid";
      FREE_ONLY = "on";
      OPENVPN_CIPHERS = "AES-256-GCM";
    };

    environmentFiles = [
      config.sops.templates."servarr-vpn-secrets.env".path
    ];
  };
}
