{ config, lib, pkgs, user, ... }:

{
  gtk = {
    # cursorTheme =  "capitaine-cursors";
    cursorTheme.package = "capitaine-cursors";
    cursorTheme.name = "capitaine-cursors";
    cursorTheme.size = 24;
  };

  home.file.".config/wall".source = ./wallpaper/mswsa;
  home.file.".background-image".source = ./wallpaper/mswsa;
}
