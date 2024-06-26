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
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
    };
}
