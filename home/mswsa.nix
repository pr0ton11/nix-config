{ config, lib, pkgs, user, ... }:

{
  home.gtk.cursorTheme = "capitaine-cursors";

  home.file.".config/wall".source = ./wallpaper/mswsa;
  home.file.".background-image".source = ./wallpaper/mswsa;
}
