{ lib, config, pkgs, ... }:
let
  version = "v26.4.2";
  dataPath = "/var/lib/homer";
  port = 5002;
  user = "homer";
  yamlFormat = pkgs.formats.yaml {};
  myConfig = {
    title = "Casa";
    subtitle = "Sope";
    icon = "fa-solid fa-server";

    header = true;
    footer = false;

    theme = "default";

    colors = {
      light = {
        highlight-primary = "#3367d6";
        highlight-secondary = "#4285f4";
        highlight-hover = "#5a95f5";
        background = "#f5f5f5";
        card-background = "#ffffff";
        text = "#363636";
        text-header = "#ffffff";
        text-title = "#303030";
        text-subtitle = "#424242";
        card-shadow = "rgba(0, 0, 0, 0.1)";
        link = "#3273dc";
        link-hover = "#363636";
      };
      dark = {
        highlight-primary = "#3367d6";
        highlight-secondary = "#4285f4";
        highlight-hover = "#5a95f5";
        background = "#131313";
        card-background = "#2b2b2b";
        text = "#eaeaea";
        text-header = "#ffffff";
        text-title = "#fafafa";
        text-subtitle = "#f5f5f5";
        card-shadow = "rgba(0, 0, 0, 0.4)";
        link = "#3273dc";
        link-hover = "#ffdd57";
      };
    };

    services = [
      {
        name = "Applications";
        icon = "fas fa-cloud";
        items = [
          {
            name = "Vaultwarden";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/bitwarden.svg";
            subtitle = "";
            tag = "service";
            url = "https://bitwarden.junaga.com/";
          }
          {
            name = "LubeLogger";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/lubelogger.png";
            subtitle = "";
            tag = "service";
            url = "https://lubelogger-penny.junaga.com";
          }
          {
            name = "Actual budget";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/actual-budget.svg";
            tag = "service";
            url = "https://actual.junaga.com/";
          }
          {
            name = "My Weights";
            icon = "fa-solid fa-weight-scale";
            subtitle = "";
            tag = "service";
            url = "https://my-weights-webserver.junaga.com/myWeightsPlots";
          }
          {
            name = "Home Assistant";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/home-assistant.svg";
            subtitle = "";
            tag = "service";
            url = "https://casa.junaga.com";
          }
          {
            name = "DoneTick";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/donetick.svg";
            subtitle = "";
            tag = "service";
            url = "https://donetick.junaga.com/";
          }
          {
            name = "Immich";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/immich.svg";
            subtitle = "";
            tag = "service";
            url = "https://fotos.junaga.com/";
          }
          {
            name = "RSS";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/feedly.svg";
            tag = "web";
            url = "https://feedly.com/";
          }
        ];
      }
      {
        name = "Network";
        icon = "fa-solid fa-network-wired";
        items = [
          {
            name = "Pi-hole";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/pi-hole.svg";
            url = "https://junaga.com:444/admin";
          }
          {
            name = "UCG Sope";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/ubiquiti-unifi.svg";
            url = "https://router.junaga.com";
          }
        ];
      }
      {
        name = "Monitoring";
        icon = "fa-solid fa-eye";
        items = [
          {
            name = "Gatus";
            logo = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/gatus.svg";
            url = "https://gatus.junaga.com";
            slug = "monitoring";
            type = "Gatus";
          }
          {
            name = "Healthcheck.io";
            logo = "https://raw.githubusercontent.com/healthchecks/healthchecks/refs/heads/master/stuff/favicon.svg";
            url = "https://healthchecks.io/accounts/login/";
          }
        ];
      }
      {
        name = "Media";
        icon = "fa-solid fa-play";
        items = [
          {
            name = "Radarr";
            logo = "https://raw.githubusercontent.com/Radarr/Radarr/refs/heads/develop/Logo/Radarr.svg";
            url = "https://radarr.junaga.com";
          }
          {
            name = "Sonarr";
            logo = "https://raw.githubusercontent.com/Sonarr/Sonarr/refs/heads/v5-develop/Logo/Sonarr.svg";
            url = "https://sonarr.junaga.com";
          }
          {
            name = "qBitTorrent";
            logo = "https://raw.githubusercontent.com/qbittorrent/qBittorrent/refs/heads/master/src/icons/qbittorrent-tray.svg";
            url = "https://qbittorrent.junaga.com";
          }
          {
            name = "jackett";
            logo = "https://raw.githubusercontent.com/Jackett/Jackett/refs/heads/master/src/Jackett.Common/Content/jacket_medium.png";
            url = "https://jackett.junaga.com";
          }
        ];
      }
      {
        name = "Torrent";
        icon = null;
        items = [
          {
            name = "Darkpeers";
            icon = "fa-solid fa-crow";
            url = "https://darkpeers.org/";
          }
        ];
      }
    ];
  };
  configFile = yamlFormat.generate "config.yml" myConfig;
in {

  users.groups.${user} = {};
  users.users.${user} = {
    group = "${user}";
    isSystemUser = true;
  };

  system.activationScripts.myappConfig = ''
    mkdir -p ${dataPath}
    chown root:root ${dataPath}
    cp ${configFile} ${dataPath}/config.yml
    chown root:root ${dataPath}/config.yml
    '';

  virtualisation.oci-containers.containers.homer = {
    image = "b4bz/homer:${version}";
    ports = [
      "${toString port}:8080"
    ];

    volumes = [
      "${dataPath}:/www/assets"
    ];

    user = "${toString config.users.users.${user}.uid}:${toString config.users.groups.${user}.gid}";

    environment = {
      INIT_ASSETS = "1";
    };
  };

  reverseProxy.hosts.homer.httpPort = port;

}