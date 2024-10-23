{ inputs, lib, config, pkgs, ... }:

{
# Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

 environment.systemPackages = with pkgs; [
    home-manager
  ];
  }


