{ ... }:
{
  imports = [
    ./sonarr.nix
    ./radarr.nix
    ./jackett.nix
    ./vpn.nix
    ./qbittorrent.nix
    ./nixarr.nix
  ];
}
