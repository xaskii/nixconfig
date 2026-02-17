lib: {
  config = lib.darwinSystem' ({ config, pkgs, ... }: {
    type = "desktop";

    networking.hostName = "four";

    system.primaryUser = "spring";

    users.users.spring = {
      name = "spring";
      home = "/Users/spring";
    };

    nixpkgs.hostPlatform = "aarch64-darwin";
    system.stateVersion = 6;
  });
}
