# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  system-info,
  pkgsStable,
  ...
}:
let
  user = "${system-info.username}";
in
{
  imports = [
    ./desktops/plasma.nix
    ./hardware-configuration.nix
    ./nvidia.nix
    ./dev/flutter/settings.nix
  ];

  # Kernel Version
  boot.kernelPackages = pkgsStable.linuxPackages_latest;

  # Auto Upgrade
  system.autoUpgrade = {
    enable = true;
    flake = "/home/${user}/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
      "-L"
    ];
    dates = "10:00";
  };

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.theme = pkgs.nixos-grub2-theme;
  };

  networking.hostName = "${system-info.hostname}";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix = {
    # Flake (will b remove prob)
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";

    # Garbage Collection
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the SSDM for KDE Plasma Environment.
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  programs.dconf.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      micro
      wget
      qalculate-qt
      git
    ];
    shellAliases = {
      update = "sudo nix flake update ~/nixos; sudo nixos-rebuild switch --flake ~/nixos";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
    };
    variables = {
      EDITOR = "micro";
    };
  };
  # Install some  more programs.
  programs = {
    firefox = {
      enable = true;
      policies.ExtensionSettings =
        with builtins;
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        listToAttrs [
          (extension "tree-style-tab" "treestyletab@piro.sakura.ne.jp")
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          (extension "return-youtube-dislikes" "{762f9885-5a13-4abd-9c77-433dcd38b8fd}")
          (extension "darkreader" "addon@darkreader.org")
          (extension "sponsorblock" "sponsorBlocker@ajay.app")
          (extension "fastforwardteam" "addon@fastforward.team")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "tabliss" "extension@tabliss.io")
          (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
        ];
    };
    steam.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
  users.defaultUserShell = pkgs.zsh;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
