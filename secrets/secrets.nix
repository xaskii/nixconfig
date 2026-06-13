let
  # User keys (from hosts/unagi/default.nix)
  xaskii = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7ISHEtrXPczITdF5vOOJGSqmsTBG7nkRccQJzgolhG";
  spring-four = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEDheq2VO1MROtfrod8szRaqaTrWX1A5riZOuzgD1zu spring@four";
  spring-unagi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeVqIvJE7cjJMTY2fop2fA/kSSm/ZcaIepfXz4R8QX7 spring@unagi";

  users = [ xaskii spring-four spring-unagi ];


  unagi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAymxmBgCPxytxwjo9Ui2kEX+j1yVLidj455S4P1BuRc";
  systems = [ unagi ];
in {
  "gluetun.env.age".publicKeys = users ++ systems;
  "cloudflared-home.json.age".publicKeys = users ++ systems;
  "cloudflare-caddy.env.age".publicKeys = users ++ systems;
}
