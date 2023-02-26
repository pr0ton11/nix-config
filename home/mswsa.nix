{ config, lib, pkgs, user, ... }:

{
  home.file.".background-image".source = ./wallpaper/mswsa;  # Wallpaper Link
  gtk.cursorTheme.size = 32;  # Scale size with display resolution
  users.users.ms.extraGroups = [ "libvirtd" ];
}
