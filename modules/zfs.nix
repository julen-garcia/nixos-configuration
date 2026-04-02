{ lib, config, pkgs, ... }:

{

  options.zfs = {
    enable = lib.mkEnableOption "Enable zfs support";

    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = "Secrets environment file";
    };

  };

  config = lib.mkIf config.zfs.enable {

    systemd.services.zfs-zed = lib.mkIf config.zfs.ntfy.enable {
      preStart = ''
        sed -i '/^ZED_NTFY_ACCESS_TOKEN=/d' ${zedRc}
        echo "ZED_NTFY_ACCESS_TOKEN=$(cat ${config.zfs.ntfy.tokenFile})" >> ${zedRc}
      '';
    };

    environment.systemPackages = [
      pkgs.mailutils
    ];

    boot = {
      supportedFilesystems = [ "zfs" ];
      zfs = {
        devNodes = "/dev/disk/by-id";
        forceImportRoot = false;
      };
    };

    services.zfs = {
      autoScrub = {
        enable = true;
        interval = "Mon *-*-* 22:00:00";
      };
    };
  };
}