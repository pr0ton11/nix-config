{ config, lib, pkgs, user, ... }:

{

  services.syncthing = {
    enable = true;
    user = "ms";
    # dataDir = "/home/ms/Documents";
    # configDir = "/home/ms/.config/syncthing";
  };

  home.file.".background-image".source = ./wallpaper/mswsa;  # Wallpaper Link
  gtk.cursorTheme.size = 32;  # Scale size with display resolution
}
