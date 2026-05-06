{ config, inputs, pkgs, ... }:
let
  nixvim = inputs.nixvim.legacyPackages.${pkgs.system};
  lib = pkgs.lib;
  asciiRaw = builtins.readFile ./ascii.txt;
  asciiLines = builtins.filter
    (line: line != "")
    (lib.strings.splitString "\n" asciiRaw);
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.gruvbox = {
      enable = true;
      flavour = "gruvbox";
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      mouse = "a";
      undofile = true;
      cmdheight = 0;          # скрываем обычную строку команд
    };

    keymaps = [
      { mode = [ "n" "v" ]; key = "<Space>"; action = "<Nop>"; options.silent = true; }
      { mode = "n"; key = "<leader>e"; action = ":Neotree toggle<CR>"; options.desc = "Toggle file explorer"; }
      { mode = "n"; key = "<leader>ff"; action = ":Telescope find_files<CR>"; options.desc = "Find files"; }
      { mode = "n"; key = "<leader>fg"; action = ":Telescope live_grep<CR>"; options.desc = "Live grep"; }
    ];

    plugins = {
      neo-tree.enable = true;
      telescope.enable = true;
      lualine.enable = true;
      treesitter.enable = true;
      nvim-autopairs.enable = true;
      comment.enable = true;
      which-key.enable = true;
      web-devicons.enable = true;
      gitsigns.enable = true;
      fugitive.enable = true;
      luasnip.enable = true;
      tabnine.enable = true;          # если хочешь, можно заменить на copilot
      floaterm.enable = true;         # ← плавающий терминал

      surround.enable = true;         # vim-surround
      bufferline.enable = true;       # табы для буферов

      indent-blankline = {
        enable = true;
        settings.scope.enabled = true;
      };

      colorizer.enable = true;
      undotree.enable = true;
      trouble.enable = true;
      autotag.enable = true;

      markdown-preview = {
        enable = true;
        settings.browser = "firefox";
      };

      cmp = {
        enable = true;
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
      };

      lsp = {
        enable = true;
        servers = {
          lua_ls.enable = true;
          nil_ls.enable = true;   # Nix LSP
          pyright.enable = true;
          ts_ls.enable = true;    # TypeScript/JavaScript
          # rust_analyzer больше не нужен — им управляет rustaceanvim
        };
      };
      vim.g.mapleader = "alt";

      # Rustaceanvim заменяет отдельный rust-analyzer
      rustaceanvim = {
        enable = true;
        settings = {
          server = {
            settings = {
              "rust-analyzer" = {
                checkOnSave = true;
                check = { command = "clippy"; };
              };
            };
          };
        };
      };

      crates.enable = true;         # управление зависимостями Cargo.toml

      # Плавающая командная строка
      noice = {
        enable = true;
        settings = {
          cmdline.view = "cmdline_popup";
          messages.view = "cmdline_popup";
        };
      };

      # Стартовый экран с ASCII-артом и быстрыми клавишами
      dashboard = {
        enable = true;
        settings = {
          config = {
            header = asciiLines;
            packages.enable = false;
            project.enable = true;
            shortcut = [
              {
                icon = "🔍  ";
                desc = "Find File";
                action = "Telescope find_files";
                key = "f";
              }
              {
                icon = "⚙️  ";
                desc = "Edit Config";
                action = "edit $HOME/nixos-config/modules/home/nvim.nix";
                key = "c";
              }
              {
                icon = "🎨 ";
                desc = "Colorscheme";
                action = "Telescope colorscheme";
                key = "t";
              }
              {
                icon = "🏠 ";
                desc = "Home Dir";
                action = "Telescope find_files cwd=$HOME";
                key = "h";
              }
              {
                icon = "⏻ ";
                desc = "Exit";
                action = "quit";
                key = "h";
              }
            ];
          };
          theme = "hyper";
        };
      };
    };

    extraPackages = with pkgs; [
      nil           # Nix LSP
      alejandra     # Nix форматтер
      stylua        # Lua форматтер
      rust-analyzer # всё ещё нужен для rustaceanvim
      pyright
      typescript-language-server
      nodejs        # для markdown-preview
      python3Packages.debugpy # для nvim-dap-python (если добавишь dap)
    ];
  };
}
