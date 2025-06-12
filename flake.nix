{
  description = "Reproducible Dev Box (WSL)";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url      = "github:numtide/flake-utils";
    home-manager.url     = "github:nix-community/home-manager";
    nixvim.url           = "github:nix-community/nixvim";
    nix-colors.url       = "github:misterio77/nix-colors";
    ghostty-hm.url       = "github:clo4/ghostty-hm-module";   # unofficial module  :contentReference[oaicite:5]{index=5}
    direnv.url           = "github:nix-community/nix-direnv"; # use_flake helper  :contentReference[oaicite:6]{index=6}
  };

  outputs = { self, nixpkgs, flake-utils, home-manager
            , nixvim, nix-colors, ghostty-hm, direnv, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      colors = nix-colors.lib.colors."gruvbox-dark-medium";
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

      ### 2. Full user environment with Home-Manager
      homeConfigurations."patrik" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit nixvim colors ghostty-hm; };
        modules = [

          ### Core tool set
          ({ config, pkgs, ... }: {
            programs.nushell = {
              enable = true;
              # Optional: point to your own config.nu
              extraConfig = builtins.readFile ./shells/nu/config.nu or "";
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
              extraConfig = builtins.readFile ./dotfiles/tmux/.tmux.conf;
            };

            ### Ghostty (GUI terminal on Linux side)
            imports = [ ghostty-hm.homeModules.default ];
            programs.ghostty = {
              enable = true;
              settings = builtins.readFile ./dotfiles/ghostty/config;
            };

            ### Neovim via nixvim + your LazyVim tree
            imports = [ nixvim.homeManagerModules.nixvim ];
            programs.nixvim = {
              enable = true;
              vimAlias = true;
              # Load plugins from your repo instead of rebuilding from Nix
              extraLuaFiles = ./dotfiles/nvim;
            };

            ### Global packages (CLI + dev)
            home.packages = with pkgs; [
              atuin zoxide starship
              nodejs_20 pnpm fnm tailwindcss
              python312 uv
              git gh fzf ripgrep delta
              du-dust htop bottom
            ];

            ### Theming with nix-colors → Starship + Ghostty + tmux
            colorscheme = colors;
          })

        ];
      };
    });
}
