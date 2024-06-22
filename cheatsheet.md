# Nix Env
- `nix-env -iA` nixos.pkg: Installiert package in lokalem Profil
- `nix-env -q`: Listet installierte Packages auf
- `nix-env --uninstall pkg`

# Rebuild
- `nixos-rebuild switch`: switches version in grub
- `nixos-rebuild switch --upgrade`: upgrades packages

# Home Manager
Allows for user environment package management.
Has more options.
Can manage dotfiles.
[manual](https://github.com/nix-community/home-manager/)

# Flakes
- specify code dependencies and pkg versions declaratively (saves states in flake.lock)
- build multiple configs in one Flake (e.g. desktop, laptop, vms, ..)
- `nix flake update` updates flake.lock: *system will always use versions from .lock*   
- `nixos-rebuild switch --flake .# or .#host`

# Checksum
- `nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/46397778ef1f73414b03ed553a3368f0e7e33c2f.tar.gz`