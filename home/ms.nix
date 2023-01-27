{ config, pkgs, ...}:

{
  home.username = "ms";
  home.homeDirectory = "/home/ms";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
  
  programs.go.enable = true;
  programs.java = { enable = true; package = pkgs.openjdk17; };

}
