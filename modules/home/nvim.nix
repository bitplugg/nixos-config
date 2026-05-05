{ config, inputs, pkgs, ... }:
let
  nixvim = inputs.nixvim.legacyPackages.${pkgs.system};

  # Читаем ASCII-арт из соседнего файла и разбиваем на список строк
  asciiLines = builtins.filter
    (line: line != "")
    (builtins.splitString "\n" (builtins.readFile ./ascii.txt));
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
      flavour = "gruvbox";   # можно сменить на другой
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      mouse = "a";
      undofile = true;
      cmdheight = 0;          # убираем стандартную строку команд
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
      web-devicons.enable = true;    # обязательно явно включить

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
          nil_ls.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
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

      # Стартовый экран с артом из внешнего файла
      dashboard = {
        enable = true;
        settings = {
          config = {
            header = asciiLines;          # ← берём из переменной
            packages.enable = false;
            project.enable = true;
          };
          theme = "hyper";
        };
      };
    };

    extraPackages = with pkgs; [
      nil
      alejandra
      stylua
      rust-analyzer
      pyright
      typescript-language-server
    ];
  };
}
