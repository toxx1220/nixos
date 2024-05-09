{
  description = "A very basic flake";

  # Inputs: Sources for packages specified in outputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        # profile 
        nixos = lib.nixosSystem {
          inerhit system;
          modules = [ ./configuration.nix ];
        }
      }
    };
}
