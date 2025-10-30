{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ../../modules/hardware/yubikey.nix
    ../common/global
    ../common/users/julen
    ../../modules/tailscale.nix
    ../../modules/kde.nix
    ../../modules/quiet-boot.nix
  ];

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

  # Use latest kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "sheldon"; # Define your hostname.

  # # Enable Wake On Lan
  # networking.interfaces.enp5s0.wakeOnLan.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
