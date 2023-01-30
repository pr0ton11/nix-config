{
  description = "NixOS configuration for my personal setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;  # Allow nonfree packages to be installed
      };
      lib = nixpkgs.lib;
      inherit self;
    in {
      nixosConfigurations = {
        mswsa = lib.nixosSystem {
          inherit system;
          inherit self;
          modules = [
	    ./hardware/mswsa.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ms = {
                imports = [
                  ./home/ms.nix
                ];
              };
            }
          ];
        };
        mswsm = lib.nixosSystem {
          inherit system;
          inherit self;
          modules = [
	    ./hardware/mswsm.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ms = {
                imports = [
                  ./home/ms.nix
                ];
              };
            }
          ];
        };
        mswst = lib.nixosSystem {
          inherit system;
          inherit self;
          modules = [
	    ./hardware/mswst.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ms = {
                imports = [
                  ./home/ms.nix
                ];
              };
            }
          ];
        };
      };
  };
}
