# Personal nixos configuration

## Updating the system

The included ``` update ``` script updates the flakes software, automatically commits the changes and to your repository and switches to the new version of the flake (with ``` update boot ``` you don't switch automatically but instead on next boot).
Please make sure to change ``` FLAKE_DIR ``` in configuration.nix to the path of this repository (otherwise running update in your term does not work)

## Install this flake on a new computer

* Boot nixOS, and setup network connectivity, disks
* Mount disks to /mnt according to your disk setup (see hardware/ for more information)
* Run ``` mkdir -p /mnt/etc/nixos && nix-shell -p nixUnstable git ```
* Clone this repository to /mnt/etc/nixos
* Set your hostname with ``` export hostname=msws* ```
* Run ``` nixos-install --flake /mnt/etc/nixos/#$hostname --impure ```
