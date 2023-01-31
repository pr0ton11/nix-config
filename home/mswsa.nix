{ config, lib, pkgs, user, ... }:

{
  home.file.".background-image".source = ./wallpaper/mswsa;  # Wallpaper Link
  gtk.cursorTheme.size = 24;  # Scale size with display resolution
}
