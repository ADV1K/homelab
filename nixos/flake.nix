{
  description = "My NixOS Server Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs: {
    nixosConfigurations.capybara = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        disko.nixosModules.disko
        ./hosts/capybara/disko.nix
        ./hosts/capybara/configuration.nix
        ./hosts/capybara/hardware-configuration.nix
        # ./modules/core.nix
        # ./modules/users.nix
        # ./modules/networking.nix
        # ./modules/containers.nix
        # ./modules/updates.nix
        # ./modules/shell.nix
      ];
    };
  };
}
