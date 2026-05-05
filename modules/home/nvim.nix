{ config, inputs, pkgs, ... }:
let
  nixvim = inputs.nixvim.legacyPackages.${pkgs.system};
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Цветовая схема (можно выбрать любую, например catppuccin)
    colorschemes.gruvbox = {
      enable = true;
      flavour = "gruvbox"; # latte, frappe, macchiato, mocha
    };

    # Базовая настройка редактора
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      mouse = "a";
      undofile = true;
    };

    # Клавиши
    keymaps = [
      { mode = [ "n" "v" ]; key = "<Space>"; action = "<Nop>"; options.silent = true; }
      { mode = "n"; key = "<leader>e"; action = ":Neotree toggle<CR>"; options.desc = "Toggle file explorer"; }
      { mode = "n"; key = "<leader>ff"; action = ":Telescope find_files<CR>"; options.desc = "Find files"; }
      { mode = "n"; key = "<leader>fg"; action = ":Telescope live_grep<CR>"; options.desc = "Live grep"; }
    ];

    # Активация стандартных плагинов "как в современных IDE"
    plugins = {
      # Проводник файлов
      neo-tree.enable = true;

      # Fuzzy finder
      telescope.enable = true;

      # Статус-бар
      lualine.enable = true;

      # Подсветка синтаксиса на основе Tree-sitter
      treesitter.enable = true;

      # Автоматические пары скобок/кавычек
      nvim-autopairs.enable = true;

      # Комментирование (gcc)
      comment.enable = true;

      # Управление окнами и табами через which-key
      which-key.enable = true;
      plugins.web-devicons.enable = true;

      # Автодополнение и LSP
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
          rust_analyzer.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;   # TypeScript/JavaScript
	};
	rust_analyzer = {
    	    enable = true;
    	    installCargo = false;   # если cargo уже стоит отдельно
            installRustc = false;   # если rustc уже стоит отдельно
	};
      };
      # Сниппеты
      luasnip.enable = true;

      # Git-интеграция
      gitsigns.enable = true;
    };

    # Внешние пакеты (форматтеры, линтеры, дополнительные серверы)
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
