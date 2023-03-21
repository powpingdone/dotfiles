return {
  -- more pretty
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },

  -- "better completetion"
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert({
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      })
    end,
  },

  -- edge
  { "sainnhe/edge" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "edge",
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufNewFile", "BufEnter" },
    servers = {
      jsonls = {
        meson = false,
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufNewFile", "BufEnter" },

    -- debug specific
    {
      "mfussenegger/nvim-dap",
      event = "VeryLazy",
      dependencies = {
        {
          "theHamsta/nvim-dap-virtual-text",
          config = true,
        },
      },
      config = function()
        vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })
        require("dap").defaults.fallback.terminal_win_cmd = "enew"
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "dap-repl",
          callback = function()
            require("dap.ext.autocompl").attach()
          end,
        })
        require("which-key").register({
          ["<leader>db"] = { name = "+breakpoints" },
          ["<leader>ds"] = { name = "+steps" },
          ["<leader>dv"] = { name = "+views" },
        })
      end,
      keys = {
        {
          "<leader>dbc",
          '<CMD>lua require("dap").set_breakpoint(vim.ui.input("Breakpoint condition: "))<CR>',
          desc = "conditional breakpoint",
        },
        {
          "<leader>dbl",
          '<CMD>lua require("dap").set_breakpoint(nil, nil, vim.ui.input("Log point message: "))<CR>',
          desc = "logpoint",
        },
        { "<leader>dbr", '<CMD>lua require("dap.breakpoints").clear()<CR>', desc = "remove all" },
        { "<leader>dbs", "<CMD>Telescope dap list_breakpoints<CR>", desc = "show all" },
        { "<leader>dbt", '<CMD>lua require("dap").toggle_breakpoint()<CR>', desc = "toggle breakpoint" },
        { "<leader>dc", '<CMD>lua require("dap").continue()<CR>', desc = "continue" },
        {
          "<leader>de",
          '<CMD>lua require("dap.ui.widgets").hover(nil, { border = "none" })<CR>',
          desc = "expression",
          mode = { "n", "v" },
        },
        { "<leader>dp", '<CMD>lua require("dap").pause()<CR>', desc = "pause" },
        { "<leader>dr", "<CMD>Telescope dap configurations<CR>", desc = "run" },
        { "<leader>dsb", '<CMD>lua require("dap").step_back()<CR>', desc = "step back" },
        { "<leader>dsc", '<CMD>lua require("dap").run_to_cursor()<CR>', desc = "step to cursor" },
        { "<leader>dsi", '<CMD>lua require("dap").step_into()<CR>', desc = "step into" },
        { "<leader>dso", '<CMD>lua require("dap").step_over()<CR>', desc = "step over" },
        { "<leader>dsx", '<CMD>lua require("dap").step_out()<CR>', desc = "step out" },
        { "<leader>dx", '<CMD>lua require("dap").terminate()<CR>', desc = "terminate" },
        {
          "<leader>dvf",
          '<CMD>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames, { border = "none" })<CR>',
          desc = "show frames",
        },
        {
          "<leader>dvs",
          '<CMD>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes, { border = "none" })<CR>',
          desc = "show scopes",
        },
        {
          "<leader>dvt",
          '<CMD>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").threads, { border = "none" })<CR>',
          desc = "show threads",
        },
      },
    },
    {
      "folke/which-key.nvim",
      opts = function()
        require("which-key").register({
          ["<leader>d"] = { name = "+debug", mode = { "n", "v" } },
        })
      end,
    },

    -- symbols
    {
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
      config = function()
        local icons = require("lazyvim.config").icons
        require("symbols-outline").setup({
          symbols = {
            File = { icon = icons.kinds.File, hl = "TSURI" },
            Module = { icon = icons.kinds.Module, hl = "TSNamespace" },
            Namespace = { icon = icons.kinds.Namespace, hl = "TSNamespace" },
            Package = { icon = icons.kinds.Package, hl = "TSNamespace" },
            Class = { icon = icons.kinds.Class, hl = "TSType" },
            Method = { icon = icons.kinds.Method, hl = "TSMethod" },
            Property = { icon = icons.kinds.Property, hl = "TSMethod" },
            Field = { icon = icons.kinds.Field, hl = "TSField" },
            Constructor = { icon = icons.kinds.Constructor, hl = "TSConstructor" },
            Enum = { icon = icons.kinds.Enum, hl = "TSType" },
            Interface = { icon = icons.kinds.Interface, hl = "TSType" },
            Function = { icon = icons.kinds.Function, hl = "TSFunction" },
            Variable = { icon = icons.kinds.Variable, hl = "TSConstant" },
            Constant = { icon = icons.kinds.Constant, hl = "TSConstant" },
            String = { icon = icons.kinds.String, hl = "TSString" },
            Number = { icon = icons.kinds.Number, hl = "TSNumber" },
            Boolean = { icon = icons.kinds.Boolean, hl = "TSBoolean" },
            Array = { icon = icons.kinds.Array, hl = "TSConstant" },
            Object = { icon = icons.kinds.Object, hl = "TSType" },
            Key = { icon = icons.kinds.Key, hl = "TSType" },
            Null = { icon = icons.kinds.Null, hl = "TSType" },
            EnumMember = { icon = icons.kinds.EnumMember, hl = "TSField" },
            Struct = { icon = icons.kinds.Struct, hl = "TSType" },
            Event = { icon = icons.kinds.Event, hl = "TSType" },
            Operator = { icon = icons.kinds.Operator, hl = "TSOperator" },
            TypeParameter = { icon = icons.kinds.TypeParameter, hl = "TSParameter" },
          },
        })
      end,
    },

    -- uncomment and add tools to ensure_installed below
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "lua-language-server",
        },
      },
    },

    -- add zen-mode
    {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      config = true,
      keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    },

    -- rust specific -- extend auto completion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        {
          "Saecki/crates.nvim",
          event = { "BufRead Cargo.toml" },
          config = true,
        },
      },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        local cmp = require("cmp")
        opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
          { name = "crates" },
        }))
      end,
    },

    -- add rust to treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, { "rust", "toml" })
      end,
    },

    -- correctly setup mason lsp / dap extensions
    {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, { "codelldb", "rust-analyzer", "taplo" })
      end,
    },

    -- correctly setup lspconfig
    {
      "neovim/nvim-lspconfig",
      dependencies = { "simrat39/rust-tools.nvim" },
      opts = {
        -- make sure mason installs the server
        setup = {
          rust_analyzer = function(_, opts)
            require("lazyvim.util").on_attach(function(client, buffer)
              -- stylua: ignore
              if client.name == "rust_analyzer" then
                vim.keymap.set("n", "K", "<CMD>RustHoverActions<CR>", { buffer = buffer })
              end
            end)
            local mason_registry = require("mason-registry")
            -- rust tools configuration for debugging support
            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
                or extension_path .. "lldb/lib/liblldb.so"
            local rust_tools_opts = vim.tbl_deep_extend("force", opts, {
              dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
              },
              tools = {
                hover_actions = {
                  auto_focus = false,
                  border = "none",
                },
                inlay_hints = {
                  auto = false,
                  show_parameter_hints = true,
                },
              },
              server = {
                settings = {
                  ["rust-analyzer"] = {
                    cargo = {
                      features = "all",
                    },
                    -- Add clippy lints for Rust.
                    checkOnSave = true,
                    check = {
                      command = "clippy",
                      features = "all",
                    },
                    procMacro = {
                      enable = true,
                    },
                    rustfmt = {
                      extraArgs = { "-q" },
                      overrideCommand = "/cargo/bin/genemichaels",
                    },
                  },
                },
              },
            })
            require("rust-tools").setup(rust_tools_opts)
            return true
          end,
          taplo = function(_, opts)
            local function show_documentation()
              if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                require("crates").show_popup()
              else
                vim.lsp.buf.hover()
              end
            end

            require("lazyvim.util").on_attach(function(client, buffer)
              -- stylua: ignore
              if client.name == "taplo" then
                vim.keymap.set("n", "K", show_documentation, { buffer = buffer })
              end
            end)
            return false -- make sure the base implementation calls taplo.setup
          end,
        },
      },
    },
  }
}
