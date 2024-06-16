{ config, pkgs, pkgsStable, inputs, system-info, ... }:

let
  user = "${system-info.username}";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    kate
    #uwufetch //todo: disabled due to problems with jdk..
    fastfetch
    viu
    lshw
    meslo-lgs-nf
    spotify
    psst
    vesktop # Discord client
    zsh-powerlevel10k
    signal-desktop
    glibc
    gcc
    python3
    docker
    tree

    thunderbird

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
    
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/toxx/etc/profile.d/hm-session-vars.sh
  #

  # home.sessionVariables = {
  #   # EDITOR = "vi";
  # };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      completionInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      initExtra = ''
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

         # Navigate words with ctrl+arrow keys
         bindkey '^[Oc' forward-word                                     #
         bindkey '^[Od' backward-word                                    #
         bindkey '^[[1;5D' backward-word                                 #
         bindkey '^[[1;5C' forward-word                                  #
         bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
         bindkey '^[[Z' undo                                             # Shift+tab undo last action
        '';
      history = {
        save = 10000;
      };
      profileExtra = ''
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
          # Set environment variables for Wayland session
          export WAYLAND_VARIABLE="value";
          export QT_QPA_PLATFORM="wayland";
          export SDL_VIDEODRIVER=wayland;
          export CLUTTER_BACKEND=wayland ;
          export _JAVA_AWT_WM_NONREPARENTING=1;
          export ELECTRON_OZONE_PLATFORM_HINT="auto";
          export GDK_BACKEND="wayland";
          export MOZ_ENABLE_WAYLAND=1;
        fi
      '';
    };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        mskelton.one-dark-theme     
      ];
    };
    alacritty = {
      enable = true;
    };
    git = {
      enable = true;
      diff-so-fancy.enable = true;
      userEmail = "txx1337@proton.me";
      userName = "toxx";
    };
  };


# This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
