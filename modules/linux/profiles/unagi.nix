{
  imports = [
    ../containers.nix
    ../ebpf-tools.nix
    ../internal-services.nix
    ../media-stack.nix
    ../soju.nix
  ];

  services.rex.loginServer = {
    enable = true;
    accounts.spring.principals = [ "tailscale:xavisimpson04@gmail.com" ];
    defaults."tailscale:xavisimpson04@gmail.com" = "spring";
    tailscaleServe = {
      enable = true;
      # Port 443 is already used by Caddy on the tailnet address.
      httpsPort = 7297;
    };
  };
}
