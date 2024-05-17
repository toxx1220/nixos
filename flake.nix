{
  description = "A very basic flake";

  # Inputs: Sources for packages specified in outputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager }:
    let
      inherit nixpkgs-stable;
      system = "x86_64-linux";
      # Unstable
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      # Stable
      pkgsStable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        # profile 
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit pkgsStable;};
              home-manager.users.toxx = {
                imports = [./home.nix];
              };
            }
          ];
        };
      };
    }; 
}
