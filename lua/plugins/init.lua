return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  --TODO Help me tod do the dishes
  -- These are some examples, uncomment them if you want to see them work!

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"

      local lspconfig = require "lspconfig"
      local function on_attach(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help, opts)
      end

      local lsp_flags = {
        debounce_text_changes = 150,
      }

      -- Go language server setup
      lspconfig.gopls.setup {
        on_attach = on_attach,
        flags = lsp_flags,
      }

      -- Prisma language server setup
      lspconfig.prismals.setup {
        on_attach = on_attach,
        flags = lsp_flags,
      }

      -- Tailwindcss language server setup
      lspconfig.tailwindcss.setup {
        on_attach = on_attach,
        flags = lsp_flags,
      }
    end,
  },
  --
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "tailwindcss-language-server",
        "typescript-language-server",
        "gopls",
        "eslint-lsp",
      },
    },
  },
  --
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "prisma",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "proto",
        "scss",
        "yaml",
      },
      autotags = {
        enable = true,
      },
    },
  },
  --
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  --
  ----Check chatgpt to change this for typescript
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require "null-ls"
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.stylua, -- Lua formatter
          null_ls.builtins.formatting.prettier, -- Prettier for formatting
          null_ls.builtins.formatting.prettierd, -- Prettierd for formatting
          null_ls.builtins.diagnostics.eslint_d, -- ESLint for diagnostics
          null_ls.builtins.formatting.eslint_d, -- ESLint for formatting
          null_ls.builtins.code_actions.eslint_d, -- ESLint for code actions
          null_ls.builtins.formatting.deno,
        },
      }

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
  },
  --
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup {
        term_colors = true,
        styles = {
          comments = "italic",
          conditionals = "italic",
          loops = "italic",
          functions = "italic",
          keywords = "italic",
          strings = "NONE",
          variables = "NONE",
          numbers = "NONE",
          booleans = "NONE",
          properties = "NONE",
          tyoes = "NONE",
          operators = "NONE",
        },
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = "italic",
              hints = "italic",
              warnings = "italic",
              information = "italic",
            },
            underlines = {
              errors = "italic",
              hints = "italic",
              warnings = "italic",
              information = "italic",
            },
          },
          lsp_trouble = true,
          cmp = true,
          lsp_saga = true,
          gitgutter = true,
          gitsigns = true,
          telescope = true,
          nvimtree = {
            enabled = true,
            show_root = true,
            transparent_panel = true,
          },
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          dashborad = true,
          bufferline = true,
          markdown = true,
          lightspeed = true,
          ts_rainbow = true,
          hop = true,
          notify = true,
          telekasten = true,
          symbols_outline = true,
        },
      }

      vim.cmd "colorscheme catppuccin"
    end,
  },
  --
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  --
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  --
  {
    "hrsh7th/nvim-cmp",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.3",
      },
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "windwp/nvim-ts-autotag",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local lspkind = require "lspkind"

      require("nvim-autopairs").setup()

      -- Integrate nvim-autopairs with cmp
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert {
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
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
          ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- scroll up preview
          ["<C-d>"] = cmp.mapping.scroll_docs(4), -- scroll down preview
          ["<C-Space>"] = cmp.mapping.complete {}, -- show completion suggestions
          ["<C-c>"] = cmp.mapping.abort(), -- close completion window
          ["<CR>"] = cmp.mapping.confirm { select = true }, -- select suggestion
        },
        -- sources for autocompletion
        sources = cmp.config.sources {
          { name = "nvim_lsp" }, -- lsp
          { name = "buffer", max_item_count = 5 }, -- text within current buffer
          { name = "path", max_item_count = 3 }, -- file system paths
          { name = "luasnip", max_item_count = 3 }, -- snippets
        },
        -- Enable pictogram icons for lsp/autocompletion
        formatting = {
          expandable_indicator = true,
          format = lspkind.cmp_format {
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = {
              Copilot = "",
            },
          },
        },
        experimental = {
          ghost_text = true,
        },
      }
    end,
  },
  --
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = { "BufEnter" },
    config = function()
      -- Turn on LSP, formatting, and linting status and progress information
      require("fidget").setup {
        text = {
          spinner = "dots_negative",
        },
      }
    end,
  },

  --#region
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup()
    end,
  },
  --#region
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufEnter",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "lazy",
          "mason",
          "notify",
          "oil",
        },
      },
    },
    main = "ibl",
  },
  --#region

  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup {
        disable_when_zoomed = true,
      }
    end,
  },

  {
    "dmmulroy/tsc.nvim",
    lazy = true,
    ft = { "typescript", "typescriptreact" },
    config = function()
      require("tsc").setup {
        auto_open_qflist = true,
        pretty_errors = false,
      }
    end,
  },

  {
    "szw/vim-maximizer",
  },

  {
    "gelguy/wilder.nvim",
    keys = {
      ":",
      "/",
      "?",
    },
    dependencies = {
      "catppuccin/nvim",
    },
    config = function()
      local wilder = require "wilder"
      local macchiato = require("catppuccin.palettes").get_palette "macchiato"

      -- Create a highlight group for the popup menu
      local text_highlight = wilder.make_hl("WilderText", { { a = 1 }, { a = 1 }, { foreground = macchiato.text } })
      local mauve_highlight = wilder.make_hl("WilderMauve", { { a = 1 }, { a = 1 }, { foreground = macchiato.mauve } })

      -- Enable wilder when pressing :, / or ?
      wilder.setup { modes = { ":", "/", "?" } }

      -- Enable fuzzy matching for commands and buffers
      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.cmdline_pipeline {
            fuzzy = 1,
          },
          wilder.vim_search_pipeline {
            fuzzy = 1,
          }
        ),
      })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
          highlighter = wilder.basic_highlighter(),
          highlights = {
            default = text_highlight,
            border = mauve_highlight,
            accent = mauve_highlight,
          },
          pumblend = 5,
          min_width = "100%",
          min_height = "25%",
          max_height = "25%",
          border = "rounded",
          left = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar() },
        })
      )
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    dependencies = { "nvim-ts-autotag" },
    opts = {
      -- Defaults
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = false, -- Auto close on trailing </
    },
    -- Also override individual filetype configs, these take priority.
    -- Empty by default, useful if one of the "opts" global settings
    -- doesn't work well in a specific filetype
    per_filetype = {
      ["html"] = {
        enable_close = false,
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },

      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" }),

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" }),

      -- You can also specify a list of valid jump keywords

      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next { keywords = { "ERROR", "WARNING" } }
      end, { desc = "Next error/warning todo comment" }),
    },
  },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "ellisonleao/carbon-now.nvim",
    lazy = true,
    cmd = "CarbonNow",
    opts = {},
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    config = function()
      require("symbols-outline").setup {
        symbols = {
          File = { icon = "", hl = "@text.uri" },
          Module = { icon = "", hl = "@namespace" },
          Namespace = { icon = "", hl = "@namespace" },
          Package = { icon = "", hl = "@namespace" },
          Class = { icon = "", hl = "@type" },
          Method = { icon = "ƒ", hl = "@method" },
          Property = { icon = "", hl = "@method" },
          Field = { icon = "", hl = "@field" },
          Constructor = { icon = "", hl = "@constructor" },
          Enum = { icon = "", hl = "@type" },
          Interface = { icon = "", hl = "@type" },
          Function = { icon = "", hl = "@function" },
          Variable = { icon = "", hl = "@constant" },
          Constant = { icon = "", hl = "@constant" },
          String = { icon = "", hl = "@string" },
          Number = { icon = "#", hl = "@number" },
          Boolean = { icon = "", hl = "@boolean" },
          Array = { icon = "", hl = "@constant" },
          Object = { icon = "", hl = "@type" },
          Key = { icon = "", hl = "@type" },
          Null = { icon = "", hl = "@type" },
          EnumMember = { icon = "", hl = "@field" },
          Struct = { icon = "", hl = "@type" },
          Event = { icon = "", hl = "@type" },
          Operator = { icon = "", hl = "@operator" },
          TypeParameter = { icon = "", hl = "@parameter" },
          Component = { icon = "", hl = "@function" },
          Fragment = { icon = "", hl = "@constant" },
        },
      }
    end,
  },

  {
    dir = "~/Code/personal/ts-error-translator.nvim",
    enabled = false,
    -- branch = "pr18",
    config = function()
      require("ts-error-translator").setup()
    end,
  },
}
