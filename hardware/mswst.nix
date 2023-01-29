{ config, lib, modulesPath, pkgs,  ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [  ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [];

  # cryptsetup -c aes-xts-plain64 -s 512 -h sha512 -i 2000 -y --pbkdf pbkdf2 luksFormat /dev/nvme0n1p3
  boot.initrd.luks.devices."sys0" = { device = "/dev/disk/by-uuid/17ab0b12-23e9-409e-b2d4-6f8525d8a43b"; allowDiscards = true; };

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
    { device = "/dev/disk/by-uuid/96bbf76c-983b-4a23-8ba6-465f970817f5";
      fsType = "ext4";
      options = [ "noatime" "discard" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/3CFB-10F0";
      fsType = "vfat";
      options = [ "noatime" "discard" ];
    };

  swapDevices = [ ]; # Disables SWAP

  # Enable Firmware Upgrades
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  
  # Basic networking configuration
  networking.hostName = "mswst";
  networking.wireless.enable = true;
  networking.wireless.wifi.backend = "iwd";
  networking.networkmanager.enable = true;
}
