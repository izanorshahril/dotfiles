-- Neovim Configuration
-- Inspired by Kun Chen's Agentic Dev Environment ("L8 Principal's Agentic Dev Environment From Scratch")
-- Optimized for Windows 11 & Neovim 0.10+

-- 1. General Options
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8

-- Indentation (2 spaces)
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Windows PowerShell Shell Config for internal terminal / jobs
if vim.fn.has("win32") == 1 then
  local powershell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  vim.o.shell = powershell
  vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end

-- 2. Bootstrap lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Plugins Specification
require("lazy").setup({
  -- Colorscheme: Rosé Pine Moon
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
        dim_nc_background = true,
        disable_background = false,
        disable_float_background = false,
        styles = {
          bold = true,
          italic = false, -- Italics disabled to match terminal aesthetics
          transparency = false,
        },
      })
      vim.cmd("colorscheme rose-pine-moon")
    end,
  },

  -- Icons (for Hack Nerd Font)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Statusline (Lualine styled with Rose Pine)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "rose-pine",
        component_separators = "|",
        section_separators = "",
        globalstatus = true,
      },
    },
  },

  -- File Navigation: Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })

      -- Keybindings
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
      vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "Recent Files" })
    end,
  },

  -- Buffer-based File Explorer (Oil.nvim)
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })
    end,
  },

  -- Sidebar Explorer (nvim-tree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          relativenumber = true,
        },
        git = { enable = true },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
    end,
  },

  -- Treesitter (Syntax Highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        ts_configs.setup({
          ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "python", "json", "markdown", "rust", "toml" },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- Keybinding helper (which-key)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto Pairs & Comments
  { "windwp/nvim-autopairs", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },

  -- LSP & Autocompletion (Mason + LSPConfig + nvim-cmp)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      -- Mason Setup
      require("mason").setup()
      local mason_lsp = require("mason-lspconfig")
      local servers = { "lua_ls", "ts_ls", "pyright" }

      mason_lsp.setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      -- CMP Setup
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
      })

      -- LSP Keymaps on Attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(event)
          local nmap = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          nmap("K", vim.lsp.buf.hover, "Hover Documentation")
          nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        end,
      })

      -- LSP Server Setup (Neovim 0.11+ native API)
      for _, server in ipairs(servers) do
        vim.lsp.config[server] = {
          capabilities = capabilities,
        }
        vim.lsp.enable(server)
      end
    end,
  },
})

-- 4. General Keymaps
-- Window Navigation (Ctrl + h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate Down Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate Up Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate Right Window" })

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quick Save & Quit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
