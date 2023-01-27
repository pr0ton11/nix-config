{ config, pkgs, ... }:

{
  imports =
    [
      # <home-manager/nixos>
    ];


  # Kernel configuration
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  # Bootloader configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.fsIdentifier = "uuid";
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Networking
  networking.useDHCP = false;  # Deprecated (do not set true)
  networking.enableIPv6 = true;
  networking.firewall.enable = false;

  # Services
  services.cron.enable = true;
  services.flatpak.enable = true;

  # Time
  time.timeZone = "Europe/Zurich";

  # Locale
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC="de_CH.UTF-8";
      LC_TIME="de_CH.UTF-8";
      LC_COLLATE="de_CH.UTF-8";
      LC_MONETARY="de_CH.UTF-8";
      LC_PAPER="de_CH.UTF-8";
      LC_NAME="de_CH.UTF-8";
      LC_ADDRESS="de_CH.UTF-8";
      LC_TELEPHONE="de_CH.UTF-8";
      LC_MEASUREMENT="de_CH.UTF-8";
      LC_IDENTIFICATION="de_CH.UTF-8";
    };
  };
  console = {
    font = "ter-i14b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "de_CH-latin1";
  };

  # Shell
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      update = "sudo nixos-rebuild switch";
      config = "sudo nano /etc/nixos/configuration.nix";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  # User
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
  users.users.ms = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    description = "Marc Singer";
    hashedPassword = "$6$yOQEG.YLfts8U/p3$rLRCN4difqTaYPP9oIvFs4klCIAw2aq3EFKUvfV4671qfuW8p90m7CaPepg6WE9u5CiEHklui/WXO66.U3LCm/";
    shell = pkgs.zsh;
  };
  users.users.root = {
    hashedPassword = "$6$kxw9xpgsVJ.wYAjj$J2KpWo3N5ncJtEAbUt1X.D6nu/cdTiEOG7GlXAzimV1C1SV4lOsnqYfj1QS.HmZWoDADYkEIRwYRPzvfa1uNU.";
    shell = pkgs.zsh;
  };
  # Environment
  environment.variables = {
    TERMINAL = "alacritty";
    EDITOR = "nano";
    VISUAL = "nano";
    KUBE_EDITOR = "nano";
    NIXOS_OZONE_WL = "1";  # VSCode Wayland Support
  };
    
  # Packages
  nixpkgs.config.allowUnfree = true;  # Allow non-free packages  
  environment.systemPackages = with pkgs; [
    alacritty
    curl
    firefox-wayland
    git
    gnome3.adwaita-icon-theme  # Supports 3rd pary icons (like Lutris)
    vscode
  ];


  # Disable X11
  # environment.noXlibs = true;  # Does not work atm, to many dependencies

  # Setup Gnome
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    videoDrivers = [ "amdgpu" ];
    displayManager.gdm.wayland = true;
    libinput.enable = true;
    layout = "de,ch";
    dpi = 96;
    excludePackages = [ pkgs.xterm ];
  };
  programs.dconf.enable = true;  # Gnome configuration

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    epiphany
    tali
    iagno
    hitori
    atomix
  ]);

  # Font Packages
  fonts.fonts = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    corefonts
    libertine
    sudo-font
    caladea
    source-code-pro
  ];

  # Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    #config.pipewire = {}  # Configuration for Pipewire can be set here
  };

  # Optimization
  nix =  {
    settings.auto-optimise-store = true;
    gc = {  # Garbage collector
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
  system.autoUpgrade = {  # System Upgrade
    enable = true;
    allowReboot = true;
    flake = "github:pr0ton11/nix-config";
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "-L"
    ];
    dates = "daily";
  };

  # Docker
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = true;
    };
  };

  # Configuration version
  system.stateVersion = "22.11";

}
