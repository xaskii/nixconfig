inputs: self: super: let
  inherit (self) attrValues filter getAttrFromPath hasAttrByPath collectNix;

  modulesCommon = collectNix ../modules/common;
  modulesLinux  = collectNix ../modules/linux;
  modulesDarwin = collectNix ../modules/darwin;

  collectInputs = let
    inputs' = attrValues inputs;
  in path: inputs'
    |> filter (hasAttrByPath path)
    |> map (getAttrFromPath path);

  inputHomeModules   = collectInputs [ "homeModules"   "default" ];
  inputModulesLinux  = collectInputs [ "nixosModules"  "default" ];
  inputModulesDarwin = collectInputs [ "darwinModules" "default" ];

  inputOverlays = collectInputs [ "overlays" "default" ];

  # Fix lowdown patches that fail with current nixpkgs
  # The nix overlay adds broken patches to lowdown, so we strip all patches
  lowdownFixOverlay = final: prev: {
    lowdown = prev.lowdown.overrideAttrs (old: {
      patches = [];
    });
  };

  # Compat shim for Determinate nix-src expecting rust_1_89 on newer nixpkgs.
  determinateRustCompat = final: prev: {
    rust_1_89 = prev.rust_1_92 or prev.rust_1_90 or prev.rust;
  };

  overlayModule = {
    nixpkgs.overlays = inputOverlays ++ [ determinateRustCompat lowdownFixOverlay ];
  };

  specialArgs = inputs // {
    inherit inputs;

    lib  = self;
  };
in {
  nixosSystem' = module: super.nixosSystem {
    inherit specialArgs;

    modules = [
      module
      overlayModule

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = inputHomeModules;
      }

      inputs.agenix.nixosModules.default
    ] ++ modulesCommon
      ++ modulesLinux
      ++ inputModulesLinux;
  };

  darwinSystem' = module: super.darwinSystem {
    inherit specialArgs;

    modules = [
      module
      overlayModule

      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = inputHomeModules;
      }
    ] ++ modulesCommon
      ++ modulesDarwin
      ++ inputModulesDarwin;
  };
}
