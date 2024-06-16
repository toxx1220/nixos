{
  description = "A very basic flake";

  # Inputs: Sources for packages specified in outputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      system-info = {
        username = "toxx";
        hostname = "nixos";
        system = "x86_64-linux";
      };
      system = "${system-info.system}";
      inherit nixpkgs-stable;
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
    in
    {
      nixosConfigurations = {
        # profile 
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit pkgsStable inputs system-info;
              };
              home-manager.users.toxx = {
                imports = [ ./home.nix ];
              };
            }
          ];
          specialArgs = {
            inherit pkgsStable inputs system-info;
          };
        };
      };
    };
}
