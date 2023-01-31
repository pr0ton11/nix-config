# Hardware specific configuration for mswsm
# Personal Thinkpad Carbon X1 Gen 6
{ config, lib, modulesPath, pkgs,  ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [  ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [];

  # cryptsetup -c aes-xts-plain64 -s 512 -h sha512 -i 2000 -y --pbkdf pbkdf2 luksFormat /dev/nvme0n1p3
  boot.initrd.luks.devices."sys0" = { device = "/dev/disk/by-uuid/82d1fa19-75a0-4ff3-84b3-063e9295b4e6"; allowDiscards = true; };

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
    { device = "/dev/disk/by-uuid/449022ce-cabc-4a31-8c51-6321596e70e9";
      fsType = "ext4";
      options = [ "noatime" "discard" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/6D86-FD1F";
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
  services.throttled.enable = lib.mkDefault true;
  
  # Basic networking configuration
  networking.hostName = "mswst";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;  # Easier management for a notebook with WiFi
}
