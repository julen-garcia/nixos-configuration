{ inputs, config, ... }:

{
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  # Fix the GID of the media group
  users.groups.media.gid = 169;

  nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
    mediaDir = "/zstorage/media";
    stateDir = "/data/media/.state/nixarr";
    mediaUsers = [ "julen" "radarr" "sonarr" ];

    vpn = {
      enable = true;
      wgConf = "/data/.secret/vpn/wg.conf";
    };

  };

}
