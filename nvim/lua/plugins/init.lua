-- Basic plugins configuration
return {
  -- Colorscheme (using gruvbox like your old config)
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = false,
      })
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        copilot_node_command = vim.fn.expand("~/.nvm/versions/node/v22.14.0/bin/node"),
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          xml = false,
          fish = true,
        },
      })
      -- Schedule setup to ensure proper initialization
      vim.schedule(function()
        vim.cmd("Copilot setup")
      end)
    end,
  },

  -- Windsurf (Codeium) AI code completion
  {
    "Exafunction/windsurf.nvim",
    enabled = false, -- Set to true to enable, false to disable
    event = "VeryLazy", -- Or "BufReadPre", "BufNewFile"
    config = function()
      -- Placeholder for Windsurf/Codeium setup
      -- You will likely need to run an authentication command provided by the plugin
      -- e.g., :WindsurfAuth or :CodeiumAuth
      -- require("windsurf").setup({
      --   -- any specific config options from the plugin's documentation
      -- })
      vim.notify("Windsurf (Codeium) plugin added. Set 'enabled = true' and run authentication if needed.", vim.log.levels.INFO)
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      local insert_mappings = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }
      if actions.to_fuzzy_refine then
        insert_mappings["<C-f>"] = actions.to_fuzzy_refine
      end

      telescope.setup({
        defaults = {
          layout_strategy = 'vertical',
          layout_config = {
            vertical = { width = 0.9 }
          },
          mappings = { i = insert_mappings },
          preview = {
            treesitter = true
          },
          -- Use gruvbox colors
          color_devicons = true,
          set_env = { COLORTERM = "truecolor" },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false,
          },
          live_grep = {
          },
          buffers = {
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      pcall(telescope.load_extension, 'fzf')

      -- Key mappings for Telescope
      vim.keymap.set('n', '<C-s>', '<cmd>Telescope find_files<cr>', { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>f', '<cmd>Telescope find_files<cr>', { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>s', function()
        builtin.live_grep({ prompt_title = 'FZF Live Grep' })
      end, { desc = 'Telescope fzf live grep' })
      vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Telescope global grep' })
      vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Telescope buffer fuzzy find' })
      vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Telescope help tags' })
      vim.keymap.set('n', '<leader>:', '<cmd>Telescope command_history<cr>', { desc = 'Telescope command history' })
    end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable('make') == 1
    end,
  },

  -- Treesitter for syntax highlighting (must load at startup)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 900,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
          "python", "javascript", "typescript", "html", "css", "json", "yaml", "bash"
        },
        auto_install = true,
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        indent = { enable = true },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright" },
        handlers = {
          function(server_name)
            vim.lsp.enable(server_name)
          end,
          ["lua_ls"] = function()
            vim.lsp.config("lua_ls", {
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
            vim.lsp.enable("lua_ls")
          end,
        },
      })
    end,
  },

  -- Hop for motions (replaces EasyMotion)
  {
    "phaazon/hop.nvim",
    branch = "v2", -- Recommended for latest features
    event = "VeryLazy", -- Load when idle, or you could use `keys` to load on first use
    config = function()
      require("hop").setup() -- Initialize hop with default settings

      -- Set custom highlight colors for jump targets (all pink)
      vim.api.nvim_set_hl(0, "HopNextKey", { fg = "#ff007f", bold = true })
      vim.api.nvim_set_hl(0, "HopNextKey1", { fg = "#ff007f", bold = true })
      vim.api.nvim_set_hl(0, "HopNextKey2", { fg = "#ff007f", bold = true })
      vim.api.nvim_set_hl(0, "HopUnmatched", { fg = "#999999", bold = false })

      -- Store hop module for easier access
      local hop = require("hop")

      -- Normal mode: H then HopWord
      -- This function first moves the cursor to the top of the window (H)
      -- then initiates a word hop.
      local function h_then_hop_words_normal()
        vim.cmd('normal! H') -- Execute H in normal mode, non-recursively and silently
        hop.hint_words()     -- Trigger hop for words
      end
      vim.keymap.set('n', ';', h_then_hop_words_normal, { noremap = true, silent = true, desc = "Hop: H + Word (Normal)" })

      -- Visual and Operator-pending modes: HopWord
      -- In these modes, we just want to hop to a word directly.
      vim.keymap.set({'v', 'o'}, ';', function() hop.hint_words() end, { noremap = true, silent = true, desc = "Hop: Word (Visual/Operator)" })

      -- You can add more hop mappings here if you like. For example:
      -- To hop to any line:
      -- vim.keymap.set('n', '<leader>hl', function() hop.hint_lines() end, { noremap = true, silent = true, desc = "Hop: Line" })
      -- To hop to words after the cursor:
      -- vim.keymap.set('n', '<leader>hw', function() hop.hint_words({ direction = require('hop.hint').HintDirection.AFTER_CURSOR }) end, { noremap = true, silent = true, desc = "Hop: Word After Cursor" })
    end,
  },

  -- Auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },

  -- Which-key shows available keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },

  -- Commenting support
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require('Comment').setup()
    end
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.keymap.set('n', '<leader>gc', '<cmd>Git commit -v -q -- %<cr>', { desc = 'Git commit current file' })
      vim.keymap.set('n', '<leader>gp', '<cmd>Git push<cr>', { desc = 'Git push' })
    end
  },

  -- Vimwiki for note taking
  {
    "vimwiki/vimwiki",
    event = "VeryLazy",
    config = function()
      -- We'll use the existing vimwiki_list configuration from init.lua
      -- Add any additional vimwiki configuration here if needed
    end
  },
}
