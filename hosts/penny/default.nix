{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./disko-config.nix
    ../common/global
    ../common/users/julen
    ../../modules/containers.nix
    ../../modules/zfs.nix
    ../../modules/server.nix
    ../../modules/tailscale.nix
    ../../modules/quiet-boot.nix

    ./services/samba.nix
    ./services/caddy.nix
    ./services/vaultwarden.nix
    ./services/healthchecks.nix
    ./services/ntfy.nix
    ./services/postfix.nix
    ./services/pocket-id.nix
    ./services/actual-budget.nix
    ./services/lubelogger.nix
    ./services/immich.nix
    ./services/homer.nix
    ./services/donetick.nix
    ./services/backups.nix
  ];

  # Import the needed secrets
  sops.secrets = {
    "ntfy/penny-zfs-token" = {
      sopsFile = ./secrets.yaml;
    };
  };

  # Create a swap file for hibernation.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB
    }
  ];
  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS related options
  zfs = {
    enable = true;
    ntfy = {
      enable = true;
      topic = "penny";
      tokenFile = config.sops.secrets."ntfy/penny-zfs-token".path;
    };
  };
  boot.zfs.extraPools = [ "zstorage" ];


  # Use latest kernel available
  #boot.kernelPackages = pkgs.linuxPackages_latest;

    # Networking
  networking = {
    useDHCP = true;
    useNetworkd = true;
    hostName = "penny";
    domain = "junaga.com";
    hostId = "061b8a2f";
  };
  systemd.network.wait-online.enable = true;

  services.tailscale.useRoutingFeatures = "server";

  # # Enable Wake On Lan
  # networking.interfaces.enp5s0.wakeOnLan.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
