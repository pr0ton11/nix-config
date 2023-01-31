{ config, pkgs, lib, ... }:

let
   nix-config-switch = pkgs.writeShellScriptBin "switch" (builtins.readFile ./switch);
in
{
  imports = [];

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
      config = "sudo nano $FLAKE_DIR/configuration.nix";
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
    extraGroups = [ "wheel" "networkmanager" "docker" ];
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
    HOSTNAME = config.networking.hostName;
    FLAKE_DIR = "/home/ms/Sources/nix-config";
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
    vscode
    python3
    nix-config-switch  # Switch script to update the system automatically
    stubby  # DNS Server
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
    layout = "ch";
    dpi = 96;
    excludePackages = [ pkgs.xterm ];
  };
  programs.dconf.enable = true;  # Gnome configuration

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    geary
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
  
  # XDG integration
  xdg = {
    portal = {
      enable = true;
    };
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

  # DNS
  networking = {
    # Disables non predefined nameservers
    # DNSSec with stamps is defined in /hardware
    nameservers = [ "127.0.0.1" "::1" ];
    networkmanager.dns = "none";
  };

  services.stubby = {
    enable = true;
    settings = {
      resulution_type = GETDNS_RESOLUTION_STUB;
      round_robin_upstreams = 1;
      upstream_recursive_servers = [
        { address_data = "45.90.28.0"; tls_auth_name = "ce4514.dns.nextdns.io"; }
        { address_data = "2a07:a8c0::0"; tls_auth_name = "ce4514.dns.nextdns.io"; }
        { address_data = "45.90.30.0"; tls_auth_name = "ce4514.dns.nextdns.io"; }
        { address_data =  "2a07:a8c1::0"; tls_auth_name = "ce4514.dns.nextdns.io"; }
      ];
    };
  };

  # Configuration version
  system.stateVersion = "22.11";

}
