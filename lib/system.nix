inputs: self: super: let
  inherit (self) attrValues filter getAttrFromPath hasAttrByPath collectNix;

  modulesCommon = collectNix ../modules/common;
  modulesLinux  = collectNix ../modules/linux;
  modulesDarwin = collectNix ../modules/darwin;

  collectInputs = let
    inputs' = attrValues inputs;
  in path: map (getAttrFromPath path) (filter (hasAttrByPath path) inputs');

  inputHomeModules   = collectInputs [ "homeModules"   "default" ];
  inputModulesLinux  = collectInputs [ "nixosModules"  "default" ];
  inputModulesDarwin = collectInputs [ "darwinModules" "default" ];

  inputOverlays = collectInputs [ "overlays" "default" ];
  lixOverlay = final: prev: {
    inherit (prev.lixPackageSets.stable)
      nixpkgs-review
      nix-eval-jobs
      nix-fast-build
      colmena;
  };

  overlayModule = {
    nixpkgs.overlays = inputOverlays ++ [ lixOverlay ];
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
