{ ... }:

{
  users.users.spring.linger = true;

  home-manager.users.spring = {
    services.rex.enable = true;

    home = {
      stateVersion = "24.11";
      homeDirectory = "/home/spring";
    };

    programs = {
      home-manager.enable = true;
      nushell.enable = true;
      ssh.enable = true;
      ssh.enableDefaultConfig = false;
    };
  };
}
