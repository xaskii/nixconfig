{
  description = "My unified NixOS and nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix = {
      url = "github:DeterminateSystems/nix-src";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, nix-darwin, ... }: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) attrsToList const groupBy listToAttrs mapAttrs nameValuePair;

    lib' = nixpkgs.lib.extend (const (const nix-darwin.lib));
    lib  = lib'.extend (import ./lib inputs);

    hostsByType = readDir ./hosts
      |> mapAttrs (name: const (import ./hosts/${name} lib))
      |> attrsToList
      |> groupBy ({ value, ... }:
        if value ? class && value.class == "nixos" then
          "nixosConfigurations"
        else
          "darwinConfigurations")
      |> mapAttrs (const listToAttrs);

    # Extract actual configs from the wrapper objects
    extractConfigs = hosts:
      hosts
      |> mapAttrs (name: value: value.config);

    darwinConfigurations = extractConfigs (hostsByType.darwinConfigurations or {});
    nixosConfigurations = extractConfigs (hostsByType.nixosConfigurations or {});

    # Also export top-level host configs for convenience
    hostConfigs = hostsByType.darwinConfigurations or {} // hostsByType.nixosConfigurations or {}
      |> extractConfigs;
  in {
    inherit darwinConfigurations nixosConfigurations inputs lib;
  } // hostConfigs;
}
