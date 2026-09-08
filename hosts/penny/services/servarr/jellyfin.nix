{ inputs, config, ... }:
{
  imports = [
    inputs.jellarr.nixosModules.default
  ];

  sops = {
    secrets = {
      "jellyfin/jellar-api-key" = {
        sopsFile = ../../secrets.yaml;
      };
      "jellyfin/julen-password" = {
        sopsFile = ../../secrets.yaml;
        owner = config.services.jellarr.user;
        group = config.services.jellarr.group;
      };
      "jellyfin/casa-password" = {
        sopsFile = ../../secrets.yaml;
        owner = config.services.jellarr.user;
        group = config.services.jellarr.group;
      };
    };
    templates.jellarr-env = {
      content = ''
        JELLARR_API_KEY=${config.sops.placeholder."jellyfin/jellar-api-key"}
      '';
      owner = config.services.jellarr.user;
      group = config.services.jellarr.group;
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.jellarr = {
    enable = true;
    user = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
    environmentFile = config.sops.templates.jellarr-env.path;
    bootstrap = {
      enable = true;
      apiKeyFile = config.sops.secrets."jellyfin/jellar-api-key".path;
    };
    config = {
      version = 1;
      base_url = "https://jellyfin.junaga.com";
      startup.completeStartupWizard = true;
      system = {
        enableMetrics = true;
        trickplayOptions = {
          enableHwAcceleration = true;
          enableHwEncoding = true;
        };
      };
      encoding = {
        enableHardwareEncoding = true;
        hardwareAccelerationType = "qsv";
        qsvDevice = "/dev/dri/by-path/pci-0000:00:02.0-render";
        hardwareDecodingCodecs = [
          "h264"
          "hevc"
          "mpeg2video"
          "vc1"
          "vp9"
          "av1"
        ];
        enableDecodingColorDepth10Hevc = true;
        enableDecodingColorDepth10Vp9 = true;
        enableDecodingColorDepth10HevcRext = true;
        enableDecodingColorDepth12HevcRext = true;
        allowHevcEncoding = false;
        allowAv1Encoding = false;
      };
      library = {
        virtualFolders = [
          {
            name = "Peliculas";
            collectionType = "movies";
            libraryOptions.pathInfos = [
              {
                path = "/zstorage/media/movies";
              }
            ];
          }
          {
            name = "Series";
            collectionType = "tvshows";
            libraryOptions.pathInfos = [
              {
                path = "/zstorage/media/series";
              }
            ];
          }
        ];
      };
      users = [
        {
          name = "julen";
          policy.isAdministrator = true;
          passwordFile = config.sops.secrets."jellyfin/julen-password".path;
        }
        {
          name = "casa";
          passwordFile = config.sops.secrets."jellyfin/casa-password".path;
        }
      ];
    };
  };

  # Add jellyfin user to render and media group
  users.users.${config.services.jellyfin.user}.extraGroups = [
    "render"
    "media"
  ];

  reverseProxy.hosts.jellyfin.httpPort = 8096;
}