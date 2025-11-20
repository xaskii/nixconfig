lib: {
  config = lib.darwinSystem' ({ config, pkgs, ... }: {
    # Set primary user configuration
    system.primaryUser = "spring";

    # Configure hostname
    networking.hostName = "four";

    nixpkgs.hostPlatform = "aarch64-darwin";
    system.stateVersion = 6;
  });
}
