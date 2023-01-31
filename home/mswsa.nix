{ config, lib, pkgs, user, ... }:

{
  home.misc.gtk = {
    cursorTheme =  "capitaine-cursors";
    cursorTheme.package = pkgs.gnome-capitaine-cursors;
  };

  home.file.".config/wall".source = ./wallpaper/mswsa;
  home.file.".background-image".source = ./wallpaper/mswsa;
}
