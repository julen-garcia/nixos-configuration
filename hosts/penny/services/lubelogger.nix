{ lib, config, pkgs, ... }:
let
  version = "v1.6.3";
  dataPath = "/var/lib/lubelogger";
  port = 5001;
  user = "lubelogger";
  containerService = "podman-lubelogger";
  backupPath = "/zstorage/internal-backups/lubelogger/";
in {

  users.groups.${user} = {};
  users.users.${user} = {
    group = "${user}";
    isSystemUser = true;
  };

  systemd.tmpfiles.rules = [
    "d ${dataPath}/data 0750 ${user} ${user}"
    "d ${dataPath}/keys 0750 ${user} ${user}"
    "d ${backupPath} 0750 ${user} ${user}"
  ];

  virtualisation.oci-containers.containers.lubelogger = {
    image = "ghcr.io/hargata/lubelogger:${version}";
    ports = [
      "${toString port}:8080"
    ];

    volumes = [
      "${dataPath}/data:/App/data"
      "${dataPath}/keys:/root/.aspnet/DataProtection-Keys"
    ];

    environment = {
      PUID = toString config.users.users.${user}.uid;
      PGID = toString config.users.groups.${user}.gid;
      LC_ALL = "es_ES";
      LANG = "es_ES";
    };
  };

  reverseProxy.hosts.lubelogger-penny.httpPort = port;

}
