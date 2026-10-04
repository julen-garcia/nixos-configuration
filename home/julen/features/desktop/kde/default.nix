{ inputs, lib, pkgs, ... }:

{

  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ../common
    ./konsole
    ./kate.nix
    ./plasma-settings.nix
    ./register-ssh-key.nix
  ];


  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    jetbrains-mono
  ];

}
