{ self, config, pkgs, ...}:

{
  home.username = "ms";
  home.homeDirectory = "/home/ms";

  home.stateVersion = "22.11";

  dconf.settings = {
    "org/gnome/desktop/background" = {
        "picture-uri" = "/home/ms/.background-image";
    };
    "org/gnome/desktop/screensaver" = {
        "picture-uri" = "/home/ms/.background-image";
    };
  };

  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "Marc Singer";
    userEmail = "ms@pr0.tech";
  };
  
  programs.go.enable = true;
  
  # See https://github.com/NixOS/nixpkgs/blob/b21240601d07108a391e5767c6d1d3b47bd7ff6f/nixos/modules/programs/chromium.nix
  programs.chromium = {
    enable = true;
  };
  
  # HFTM Java Development
  programs.java = { enable = true; package = pkgs.openjdk19; };
  
  home.packages = with pkgs; [
    maven  # HFTM Java Development
    ansible
    sshpass
    kubectl
    krew
    sshpass
    plex-media-player
  ];

}
