# Hardware specific configuration for mswsa
# Personal AMD Workstation

{ config, lib, modulesPath, pkgs,  ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "amd_iommu=on"
    "pcie_aspm=off"
    "amdgpu.ppfeaturemask=0xffd3fff"  # Specific for the AMD Radeon RX 7900 XTX
  ];

  # cryptsetup -c aes-xts-plain64 -s 512 -h sha512 -i 2000 -y --pbkdf pbkdf2 luksFormat /dev/nvme0n1p3
  boot.initrd.luks.devices."sys0" = { device = "/dev/disk/by-uuid/17ab0b12-23e9-409e-b2d4-6f8525d8a43b"; allowDiscards = true; };
  # cryptsetup -c aes-xts-plain64 -s 512 -h sha512 -i 2000 -y --pbkdf pbkdf2 luksFormat /dev/nvme1n1p2
  boot.initrd.luks.devices."sys1" = { device = "/dev/disk/by-uuid/42de1a00-21d3-4a82-95ac-5c923a8038b2"; allowDiscards = true; };

  # mkfs.btrfs -L root -d single -m raid1 /dev/mapper/sys0 /dev/mapper/sys1
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
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  
  # Enable openGL and vulkan
  hardware.opengl.package = (pkgs.mesa.override {
    llvmPackages = pkgs.llvmPackages_15;
    enableOpenCL = false;
  }).drivers;
  hardware.opengl.extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
  ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.steam-hardware.enable = true;  # Enable steam udev profiles for controllers

  # Lutris installation
  # Flatpak lutris does not work
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraLibraries =  pkgs: [
        # List library dependencies here
      ];
    })
  ];

  # Basic networking configuration
  networking.hostName = "mswsa";
  networking.wireless.enable = false;
  networking.interfaces.enp7s0.useDHCP = true;

  # Wireguard connection to pr0
  systemd.services.wg-quick-pr0.wantedBy = lib.mkForce [ ];  # Remove autostart from interfaces
  networking.wg-quick.interfaces = {
    pr0 = {
      address = [ "10.113.64.2/24" "2001:1680:6003:64::2/64" ];
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
