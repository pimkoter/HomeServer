{
  description = "The ultimate Homelab flake for different VM's";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs}: let
    mkHost = {
      name,
      system ? "x86_64-linux",
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit name;
          admin = "pim";
        };
        modules = [
          ./modules/${name}/default.nix
          ./modules/common/default.nix
        ];
      };
  in {
    nixosConfigurations = {
      pihole = mkHost {
        name = "pihole";
      };
    };
  };
}
