# Hardware specific configuration for mswsm
# Personal Thinkpad X1 Nano
{ config, lib, modulesPath, pkgs,  ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [  ];
  boot.kernelModules = [ "kvm-intel" "acpi_call" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  boot.kernelParams = [];

  # cryptsetup -c aes-xts-plain64 -s 512 -h sha512 -i 2000 -y --pbkdf pbkdf2 luksFormat /dev/nvme0n1p3
  boot.initrd.luks.devices."sys0" = { device = "/dev/disk/by-uuid/667a096b-2eee-4369-b070-51f4127a1919"; allowDiscards = true; };

  # mkfs.btrfs -L root /dev/mapper/sys0
  # mount and create subvolumes
  # unmount root volume again
  # mount everything to /mnt
  fileSystems."/" =
    { device = "/dev/mapper/sys0";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "discard" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/sys0";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" "discard" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/sys0";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "discard" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/e0a2c341-357b-4016-ac53-2179eb0806d3";
      fsType = "ext4";
      options = [ "noatime" "discard" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/E11B-00AC";
      fsType = "vfat";
      options = [ "noatime" "discard" ];
    };

  swapDevices = [ ]; # Disables SWAP

  # Enable openGL and vulcan 
  hardware.opengl.package = (pkgs.mesa).drivers;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
      intel-media-driver
  ];


  # Enable Firmware Upgrades
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  
  # Power Management
  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # services.throttled.enable = lib.mkDefault true;
  
  # Basic networking configuration
  networking.hostName = "mswst";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;  # Easier management for a notebook with WiFi

  systemd.services.wg-quick-pr0.wantedBy = lib.mkForce [ ];  # Remove autostart from interface
  networking.wg-quick.interfaces = {
    pr0 = {
      address = [ "10.113.64.3/24" "2001:1680:6003:64::3/64" ];
      privateKeyFile = "/home/ms/.wireguard.pk";
      peers = [
        {
          publicKey = "wt4YLrF3A8Iu25OxqWWgr17bnxK/U4qomIOVpwq88lY=";
          allowedIPs = [ "10.113.48.0/24" "10.113.50.0/24" "10.113.64.0/24" "::/0" ];
          endpoint = "vpn4.pr0.guru:52420";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
