{ lib, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [ { xdg.enable = true; } ];
  };
}
