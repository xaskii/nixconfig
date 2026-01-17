lib: {
  config = lib.darwinSystem' ({ config, pkgs, ... }: {
    type = "desktop";

    networking.hostName = "four";

    system.primaryUser = "spring";

    users.users.spring = {
      name = "spring";
      home = "/Users/spring";
    };

    home-manager.users.spring = {
      programs.nushell.enable = true;

      home = {
        stateVersion = "25.05";
        homeDirectory = config.users.users.spring.home;
      };
    };

    nixpkgs.hostPlatform = "aarch64-darwin";
    system.stateVersion = 6;
  });
}
