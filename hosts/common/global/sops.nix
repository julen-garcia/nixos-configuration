{ inputs, pkgs, ... }:

{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = [
    pkgs.age
    pkgs.ssh-to-age
    pkgs.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/persist/sops/age/keys.txt"
  };
}

