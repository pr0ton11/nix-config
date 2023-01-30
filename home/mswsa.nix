{ config, lib, pkgs, user, ... }:

{
  home.file.".config/wall".source = ./wallpaper/mswsa;
  home.file.".background-image".source = ./wallpaper/mswsa;
}
