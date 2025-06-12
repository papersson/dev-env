{
  description = "Reproducible Dev Box (WSL)";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url      = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url       = "github:misterio77/nix-colors";
    ghostty-hm.url       = "github:clo4/ghostty-hm-module";   # unofficial module  :contentReference[oaicite:5]{index=5}
    direnv.url           = "github:nix-community/nix-direnv"; # use_flake helper  :contentReference[oaicite:6]{index=6}
    ghostty.url          = "github:ghostty-org/ghostty";      # official ghostty flake
  };

  outputs = { self, nixpkgs, flake-utils, home-manager
            , nix-colors, ghostty-hm, ghostty, direnv, ... }:
    let
      # No need to define colors here, we'll use colorScheme in the module
    in
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      ### 1. On-demand dev shell (nix develop)
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_20               # Node 20 LTS
          pnpm                    # modern package manager
          fnm                     # fast node manager  :contentReference[oaicite:7]{index=7}
          python312
          uv                      # lightning-fast pip replacement  :contentReference[oaicite:8]{index=8}
          tailwindcss
          git fzf ripgrep
        ];
      };
    }) // {
      ### 2. Full user environment with Home-Manager
      homeConfigurations."patrik" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit nix-colors ghostty-hm ghostty; };
        modules = [

          ### Core tool set
          ({ config, pkgs, nix-colors, ghostty, ... }: {
            ### Combine all imports at the top
            imports = [ 
              ghostty-hm.homeModules.default 
              nix-colors.homeManagerModules.default
            ];

            programs.nushell = {
              enable = true;
              # Optional: point to your own config.nu
              extraConfig = if builtins.pathExists ./shells/nu/config.nu 
                then builtins.readFile ./shells/nu/config.nu 
                else "";
            };

            programs.starship = {
              enable = true;
              settings = {
                add_newline = false;
                palette = "gruvbox_dark";
              };
            };

            programs.atuin.enable   = true;   # better history  :contentReference[oaicite:9]{index=9}
            programs.zoxide.enable = true;   # smarter cd
            programs.direnv.enable = true;
            programs.direnv.nix-direnv.enable = true;  # use_flake  :contentReference[oaicite:10]{index=10}

            programs.tmux = {
              enable = true;
              extraConfig = if builtins.pathExists ./dotfiles/tmux/.tmux.conf
                then builtins.readFile ./dotfiles/tmux/.tmux.conf
                else "";
            };

            ### Ghostty (GUI terminal on Linux side)
            programs.ghostty = {
              enable = true;
              settings = {
                background-opacity = 0.9;
                background-blur-radius = 20;
                window-theme = "dark";
                theme = "GruvboxDark";
                window-padding-x = 10;
                window-padding-y = 10;
                cursor-style = "block";
                cursor-color = "#ffffff";
                mouse-hide-while-typing = true;
                copy-on-select = true;
                keybind = [
                  "ctrl+h=goto_split:left"
                  "ctrl+j=goto_split:bottom"
                  "ctrl+k=goto_split:top"
                  "ctrl+l=goto_split:right"
                  "shift+enter=text:\\n"
                ];
              };
            };

            ### Neovim with LazyVim config
            programs.neovim = {
              enable = true;
              viAlias = true;
              vimAlias = true;
              withNodeJs = true;
              withPython3 = true;
            };
            
            # Link LazyVim config
            home.file.".config/nvim" = {
              source = ./dotfiles/nvim;
              recursive = true;
            };

            ### Global packages (CLI + dev)
            home.packages = with pkgs; [
              atuin zoxide starship
              nodejs_20 pnpm fnm tailwindcss
              python312 uv
              git gh fzf ripgrep delta
              du-dust htop bottom
            ] ++ [
              ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];

            ### Theming with nix-colors → Starship + Ghostty + tmux
            colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

            ### Home Manager settings
            home.username = "patrik";
            home.homeDirectory = "/home/patrik";
            home.stateVersion = "24.05";  # Please read the comment before changing.
            # Don't include home-manager in the profile to avoid conflicts
            # programs.home-manager.enable = true;
          })

        ];
      };
    };
}