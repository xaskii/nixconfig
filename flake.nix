{
  description = "my nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix.url = "github:DeterminateSystems/nix-src";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix,
      ...
    }:
    {
      darwinConfigurations."four" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ nix.overlays.default ]; }
          ./configuration.nix
        ];
      };
    };
}
