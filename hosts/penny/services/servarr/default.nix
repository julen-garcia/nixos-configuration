{ ... }:
{
  imports = [
    ./sonarr.nix
    ./radarr.nix
    ./jackett.nix
    ./vpn.nix
    ./qbittorrent.nix
    ./plex.nix
  ];

    users.groups.media = {
    gid = 169;
    members = [ "julen" ];
  };

  systemd.tmpfiles.rules = [
    "d /zstorage/media 2775 root media - -"
  ];
}
