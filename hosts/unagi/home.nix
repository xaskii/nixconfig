{ ... }:

{
  home-manager.users.spring = {
    home = {
      stateVersion = "24.11";
      homeDirectory = "/home/spring";
    };

    programs = {
      home-manager.enable = true;
      nushell.enable = true;
    };
  };
}
