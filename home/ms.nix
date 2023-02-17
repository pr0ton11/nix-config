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
  
  programs.go.enable = true;
  
  # See https://github.com/NixOS/nixpkgs/blob/b21240601d07108a391e5767c6d1d3b47bd7ff6f/nixos/modules/programs/chromium.nix
  programs.chromium = {
    enable = true;
  };
  
  home.packages = with pkgs; [
    maven  # HFTM Java Development
    ansible
    ansible-lint
    sshpass
    kubectl
    krew
    sshpass
    plex-media-player
    gnomeExtensions.tray-icons-reloaded
    gnome3.gnome-tweaks
    gnumake
  ];

}
