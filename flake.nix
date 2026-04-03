{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };



  outputs = inputs@ { self, nixpkgs, home-manager, plasma-manager, firefox-addons, sops-nix, ... }: 
  let
    makeNixosConfig = { hostname, users, system ? "x86_64-linux" }: 
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/${hostname}
        (import ./modules/home-manager-config.nix {
          inherit hostname users;
        })
      ];
    };
  in {

    overlays = import ./overlays {inherit inputs;}; #TODO: ver que es esto

    # NixOS configurations
    # Available through 'nixos-rebuild switch --flake .#hostname'
    nixosConfigurations = {
      sheldon = makeNixosConfig {
        hostname = "sheldon";
        users = ["julen"];
      };

      penny = makeNixosConfig {
        hostname = "penny";
        users = ["julen"];
      };
    };
  };
}
