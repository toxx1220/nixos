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
