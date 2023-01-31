{ config, lib, pkgs, user, ... }:

{
  home.file.".background-image".source = ./wallpaper/mswst;  # Wallpaper Link
  gtk.cursorTheme.size = 16;  # Scale size with display resolution
}
