{
  description = "Xavi's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      lix-module,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            vim
            neovim
            nvimpager
            htop
            ffmpeg
            btop
            git
            wget

            ripgrep
            vivid
            gh
            neovim
            tlrc
            stow
            fzf
            fd
            ruff
            duf
            jq
            curlie
            xh
            eza
            bandwhich
            just
            biome
            fastfetch
            zoxide
            imagemagick
            bat

            # tuis
            dua
            lazygit
            delta
            yazi

            nil
            nixfmt-rfc-style
          ];

          nixpkgs.config.allowUnfree = true;

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          # yeah idk idgaf
          users.users."spring".uid = 501;
          users.users."spring".shell = pkgs.fish;
          users.knownUsers = [ "spring" ];


          programs.zsh.enable = true;
          programs.fish.enable = true;
          programs.nix-index.enable = true; # fixes the random error with wrong commands

          nix.optimise.automatic = true;
          security.pam.services.sudo_local.touchIdAuth = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#life
      # if you break some bullshit
      # nix run nix-darwin/master#darwin-rebuild -- switch
      darwinConfigurations."life" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          lix-module.nixosModules.default
        ];
      };
    };
}
