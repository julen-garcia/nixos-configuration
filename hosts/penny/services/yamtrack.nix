{ config, pkgs, ... }:
let
  data-directory = "/var/lib/yamtrack";
  port = 5003;
in {
  # Import the needed secrets
  sops = {
    secrets = {
      "yamtrack/secret" = {
        sopsFile = ../secrets.yaml;
      };
    };
    templates."yamtrack-secrets.env" = {
      content = ''
        SECRET=${config.sops.placeholder."yamtrack/secret"}
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d ${data-directory}/db 0755 root root -"
    "d ${data-directory}/redis 0755 root root -"
  ];

  virtualisation.oci-containers.containers = {
    redis = {
      image = "docker.io/library/redis:8-alpine";

      volumes = [
        "${data-directory}/redis:/data"
      ];

      extraOptions = [
        "--network=yamtrack"
        "--name=yamtrack-redis"
      ];
    };

    yamtrack = {
      image = "ghcr.io/fuzzygrim/yamtrack";

      dependsOn = [ "redis" ];

      environmentFiles = [ 
        config.sops.templates."yamtrack-secrets.env".path
      ];

      environment = {
        TZ = "Europe/Madrid";
        REDIS_URL = "redis://redis:6379";
        URLS = "https://yamtrack.junaga.com";
      };

      volumes = [
        "${data-directory}/db:/yamtrack/db"
      ];

      ports = [
      "${toString port}:8000"
      ];

      extraOptions = [
        "--network=yamtrack"
        "--name=yamtrack"
      ];
    };
  };

  reverseProxy.hosts.yamtrack.httpPort = port;

  # Create a Podman network equivalent to the Compose network
  systemd.services.podman-network-yamtrack = {
    description = "Create Podman network yamtrack";
    after = [ "podman.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.podman}/bin/podman network exists yamtrack || \
      ${pkgs.podman}/bin/podman network create yamtrack
    '';
  };

  systemd.services."podman-redis".after = [
    "podman-network-yamtrack.service"
  ];

  systemd.services."podman-yamtrack".after = [
    "podman-network-yamtrack.service"
  ];

}