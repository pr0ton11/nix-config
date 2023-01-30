{ config, lib, pkgs, user, ... }:

{
  home.file.".config/wall".source = ./wallpaper/mswsa;
}
