{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix.url = "github:danth/stylix";

    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    osu-nixos = {
      url = "github:notgne2/osu-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-apple-silicon, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; overlays = [ inputs.osu-nixos.overlay ]; };
    in
    {
      nixosConfigurations.blade = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            currentConfig = "blade";
          };
          modules = [
            ./hosts/blade/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };

      nixosConfigurations.breach = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            currentConfig = "breach";
          };
          modules = [
            ./hosts/breach/configuration.nix
            inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.default
          ];
        };
      
      nixosConfigurations.lune = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            currentConfig = "lune";
          };
          modules = [
            ./hosts/lune/configuration.nix
          ];
        };

      nixosConfigurations.crash = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            currentConfig = "crash";
          };
          modules = [
            ./hosts/crash/configuration.nix
            inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.default
          ];
        };

      nixosConfigurations.osaka = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            currentConfig = "osaka";
          };
          modules = [
            ./hosts/osaka/configuration.nix
            inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.default
          ];
        };
    };
}
