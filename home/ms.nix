{ self, config, pkgs, ...}:

{
  home.username = "ms";
  home.homeDirectory = "/home/ms";

  home.stateVersion = "22.11";

  dconf.settings = {
    "org/gnome/desktop/background" = {
        "picture-uri" = "file:///home/ms/.background-image";
    };
    "org/gnome/desktop/screensaver" = {
        "picture-uri" = "file:///home/ms/.background-image";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "trayIconsReloaded@selfmade.pl"
      ];
    };
  };

  gtk = {
    enable = true;
    # Cursor theme
    # https://github.com/keeferrourke/capitaine-cursors
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;  # Supports 3rd pary icons (like Lutris)
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "Marc Singer";
    userEmail = "ms@pr0.tech";
    extraConfig = {
     init = {
       defaultBranch = "main";
      };
    };
  };
  
  programs.go = {
    enable = true;
    package = pkgs.go_1_20;
    goPath = "go";
    goBin = "go/bin";
    goPrivate = [ "git.pr0.tech/ms" ];
  };

  programs.htop = {
    enable = true;
    settings = {
      tree_view = true;
      show_cpu_frequency = true;
      show_cpu_usage = true;
      show_program_path = false;
    };
  };

  home.packages = with pkgs; [
    ansible
    ansible-lint
    kubectl
    krew
    sshpass
    plex-media-player
    gnomeExtensions.tray-icons-reloaded
    gnome3.gnome-tweaks
    texstudio
    texlive.combined.scheme-full
    neofetch
    s3cmd
    android-studio
    nodejs
  ];

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "$HOME/.krew/bin"
  ];

  # Update configuration of Alacritty
  xdg.configFile."alacritty/alacritty.yml".text = ''
    ${builtins.readFile ./alacritty.yml}
  '';

}
