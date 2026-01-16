{
  description = "The ultimate Homelab flake for different VMs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    defaultSystem = "x86_64-linux";
    admin = "pim";

    mkHost = {
      name,
      system ? defaultSystem,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit name;
          inherit admin;
        };
        modules = [
          ./modules/common/default.nix
          ./modules/${name}/default.nix
        ];
      };
  in {
    nixosConfigurations = {
      pihole = mkHost {name = "pihole";};
    };
  };
}
