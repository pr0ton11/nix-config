{ config, pkgs, ...}:

{
  home.username = "ms";
  home.homeDirectory = "/home/ms";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "Marc Singer";
    userEmail = "ms@pr0.tech";
  };
  
  programs.go.enable = true;
  
  # HFTM Java Development
  programs.java = { enable = true; package = pkgs.openjdk19; };
  
  home.packages = [
    pkgs.maven
  ];

}
