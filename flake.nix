{
  description = "MacBook Air M1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            # Text editors
            neovim
            vscode

            # Cloud
            google-cloud-sdk
            terraform

            # Development
            nodejs_22
            pnpm
            python3
            nixfmt-rfc-style
            shfmt
            lua

            # Tools
            jq

            # alternative
            eza # ls
            bat # cat
            tldr # man
            most # less
            gping # ping
            btop # htop

            # Internet
            browsh
            speedtest-cli

            # Crypto
            cointop
          ];

          homebrew = {
            enable = true;
            taps = [
              "koekeishiya/formulae"
              "FelixKratz/formulae"
              "homebrew/services"
              "koekeishiya/formulae"
            ];
            brews = [
              # Tools
              "mas"

              # Terminal customization
              "oh-my-posh"
              "zsh-fast-syntax-highlighting"

              # sketchybar dependencies
              "switchaudio-osx"

              # Development
              "docker-compose"

              # taps koekeishiya/formulae
              "yabai"

              # taps FelixKratz/formulae
              {
                name = "sketchybar";
                start_service = true;
              }
              {
                name = "borders";
                start_service = true;
              }
            ];
            casks = [
              # sketchybar dependencies
              "sf-symbols"

              # Messaging
              "telegram"

              # Entertainment
              "steam"
              "tidal"

              # Browser
              "arc"
              "zen-browser"

              # Productivity
              "raycast"
              "unnaturalscrollwheels"
              "shottr"
              "alt-tab"

              # Tools
              "chatgpt"
              "protonvpn"
              "the-unarchiver"
              "remote-desktop-manager"
              "obs"
	            # "random-mouse-clicker"

              # Development
              "wezterm"
              "warp"
              "amazon-q"
              "docker"
              "orbstack"
            ];
            masApps = {
              # "8BitDo-Ultimate-Software" = 1532713768;
            };
            onActivation = {
              cleanup = "zap";
              # autoUpdate = true;
              # upgrade = true;
            };
          };

          fonts.packages = [
            (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
            pkgs.sketchybar-app-font
          ];

          home-manager.backupFileExtension = "backup";
          nix.configureBuildUsers = true;
          nix.useDaemon = true;
          users.users.frog.home = "/Users/frog";

          system = {
            defaults = {
              dock = {
                autohide = true;
                persistent-apps = [
                  "/System/Applications/Launchpad.app"
                  "/System/Applications/System Settings.app"
                  "/Applications/Tidal.app"
                  "/Applications/Arc.app"
                  "${pkgs.vscode}/Applications/Visual Studio Code.app"
                  "/Applications/OrbStack.app"
                  "/Applications/WezTerm.app"
                  "/Applications/Warp.app"
                ];
                tilesize = 40;
                magnification = false;
                # largesize = 64;
              };
              finder = {
                AppleShowAllExtensions = true;
                FXPreferredViewStyle = "Nlsv";
                ShowPathbar = true;
              };
              loginwindow.GuestEnabled = false;
            };
            startup.chime = false;
          };

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;
          programs.zsh.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."Frog" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "frog";

              # Optional: Declarative tap management
              # taps = {
              #   "homebrew/homebrew-core" = homebrew-core;
              #   "homebrew/homebrew-cask" = homebrew-cask;
              #   "homebrew/homebrew-bundle" = homebrew-bundle;
              # };

              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              # mutableTaps = false;
            };
          }

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.frog = import ./home.nix;
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Frog".pkgs;
    };
}
