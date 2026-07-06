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
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, nix-darwin, ... }: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) attrsToList const groupBy listToAttrs mapAttrs nameValuePair;

    lib' = nixpkgs.lib.extend (const (const nix-darwin.lib));
    lib  = lib'.extend (import ./lib inputs);

    hostsByType =
      mapAttrs (const listToAttrs)
        (groupBy ({ value, ... }:
          if value ? class && value.class == "nixos" then
            "nixosConfigurations"
          else
            "darwinConfigurations")
          (attrsToList
            (mapAttrs (name: const (import ./hosts/${name} lib))
              (readDir ./hosts))));

    # Extract actual configs from the wrapper objects
    extractConfigs = mapAttrs (name: value: value.config);

    darwinConfigurations = extractConfigs (hostsByType.darwinConfigurations or {});
    nixosConfigurations = extractConfigs (hostsByType.nixosConfigurations or {});

    # Also export top-level host configs for convenience
    hostConfigs = extractConfigs (hostsByType.darwinConfigurations or {} // hostsByType.nixosConfigurations or {});
  in {
    inherit darwinConfigurations nixosConfigurations inputs lib;
  } // hostConfigs;
}
