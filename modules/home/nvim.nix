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
      flavour = "gruvbox";   # можно сменить на "catppuccin" и т.п.
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
      web-devicons.enable = true;  # иконки для dashboard и плагинов
      fugitive.enable = true;
      tabnine.enable = true;
      floaterm.enable = true;
      bufferline.enable = true;
      colorizer.enable = true;
      trouble.enable = true;
      autotag.enable = true;
      surround.enable = true;
      
      #Setting btw
      plugins.indent-blankline = {
        enable = true;
        settings.scope.enabled = true;
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
          ts_ls.enable = true;   # TypeScript/JavaScript
          rust_analyzer = {
            enable = true;
            installCargo = false;   # предполагаем, что cargo/rustc уже установлены
            installRustc = false;
          };
        };
      };

      luasnip.enable = true;
      gitsigns.enable = true;

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
            header = asciiLines;         # арт из ./ascii.txt
            packages.enable = false;     # не показывать список плагинов
            project.enable = true;       # показывать недавние проекты
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
      rust-analyzer
      pyright
      typescript-language-server
    ];
  };
}
