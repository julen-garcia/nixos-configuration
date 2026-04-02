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