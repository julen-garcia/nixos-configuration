# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    # NOTE: 'nixos' is the default hostname set by the installer
    let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
	pkgs = import nixpkgs { inherit system; };
	inherit (self) outputs;
    in {	

     # NixOS configurations
      # Available through 'nixos-rebuild switch --flake .#hostname'
      nixosConfigurations = {
        test = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          modules = [
./common.nix
./configuration.nix
          ];
        };

homeConfigurations = {
        "julen@test" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            ./home.nix
          ];
        };
  };
};
};
}
