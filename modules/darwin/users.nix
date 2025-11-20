{ pkgs, ... }:

{
  users.users."spring".uid = 501;
  users.users."spring".shell = pkgs.fish;
  users.knownUsers = [ "spring" ];
}
