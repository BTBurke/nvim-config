--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/lsp.lua
-- Description: LSP setup and config
return {{
    -- Mason
    "williamboman/mason.nvim",
    cmd = {"Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog"},
    opts = {
        PATH = "prepend",
        ui = {
            icons = {
                package_pending = " ",
                package_installed = "󰄳 ",
                package_uninstalled = " 󰚌"
            },

            keymaps = {
                toggle_server_expand = "<CR>",
                install_server = "i",
                update_server = "u",
                check_server_version = "c",
                update_all_servers = "U",
                check_outdated_servers = "C",
                uninstall_server = "X",
                cancel_installation = "<C-c>"
            }
        },

        max_concurrent_installers = 10
    },
    config = function(_, opts)
        require("mason").setup(opts)
    end
}, {
    -- LSP - Quickstart configs for Nvim LSP
    "neovim/nvim-lspconfig",
    event = {"BufReadPre", "BufNewFile"},
    lazy = true,
    dependencies = { -- Mason
    -- Portable package manager for Neovim that runs everywhere Neovim runs.
    -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
    {"williamboman/mason.nvim"}, {"williamboman/mason-lspconfig.nvim"}, -- Autocomplete
    -- A completion plugin for neovim coded in Lua.
    {
        "hrsh7th/nvim-cmp",
        dependencies = {"L3MON4D3/LuaSnip", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "hrsh7th/cmp-buffer",
                        "saadparwaiz1/cmp_luasnip"}
    }},
    opts = {
        -- Automatically format on save
        autoformat = true,
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
            formatting_options = nil,
            timeout_ms = nil
        },
        -- LSP Server Settings
        servers = {
            jsonls = {},
            dockerls = {},
            bashls = {},
            gopls = {},
            vimls = {},
            yamlls = {},
            ts_ls = {},
            gleam = {},
            templ = {},
            cssls = {},
        },
        -- you can do any additional lsp server setup here
        -- return true if you don"t want this server to be setup with lspconfig
        setup = {
            gleam = function(_, opts)
              require("lspconfig").gleam.setup({})
            end
            -- example to setup with typescript.nvim
            -- tsserver = function(_, opts)
            --   require("typescript").setup({ server = opts })
            --   return true
            -- end,
            -- Specify * to use this function as a fallback for any server
            -- ["*"] = function(server, opts) end,
        }
    },
    config = function(_, opts)
        local servers = opts.servers
        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

        local function setup(server)
            local server_opts = vim.tbl_deep_extend("force", {
                capabilities = vim.deepcopy(capabilities)
            }, servers[server] or {})

            if opts.setup[server] then
                if opts.setup[server](server, server_opts) then
                    return
                end
            elseif opts.setup["*"] then
                if opts.setup["*"](server, server_opts) then
                    return
                end
            end
            require("lspconfig")[server].setup(server_opts)
        end

        -- temp fix for lspconfig rename
        -- https://github.com/neovim/nvim-lspconfig/pull/2439
--        local mappings = require("mason-lspconfig.mappings.server")
  --      if not mappings.lspconfig_to_package.lua_ls then
    --        mappings.lspconfig_to_package.lua_ls = "lua-language-server"
      --      mappings.package_to_lspconfig["lua-language-server"] = "lua_ls"
        -- end

        local mlsp = require("mason-lspconfig")
        local available = mlsp.get_available_servers()

        local ensure_installed = {} ---@type string[]
        for server, server_opts in pairs(servers) do
            if server_opts then
                server_opts = server_opts == true and {} or server_opts
                -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                if server_opts.mason == false or not vim.tbl_contains(available, server) then
                    setup(server)
                else
                    ensure_installed[#ensure_installed + 1] = server
                end
            end
        end

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
            automatic_installation = true
        })
--        require("mason-lspconfig").setup_handlers({setup})
    end
}, {
    -- load luasnips + cmp related in insert mode only
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {{
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = {
            history = true,
            updateevents = "TextChanged,TextChangedI"
        },
        config = function(_, opts)
            require("luasnip").config.set_config(opts)

            -- vscode format
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load {
                paths = vim.g.vscode_snippets_path or ""
            }

            -- snipmate format
            require("luasnip.loaders.from_snipmate").load()
            require("luasnip.loaders.from_snipmate").lazy_load {
                paths = vim.g.snipmate_snippets_path or ""
            }

            -- lua format
            require("luasnip.loaders.from_lua").load()
            require("luasnip.loaders.from_lua").lazy_load {
                paths = vim.g.lua_snippets_path or ""
            }

            vim.api.nvim_create_autocmd("InsertLeave", {
                callback = function()
                    if require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] and
                        not require("luasnip").session.jump_active then
                        require("luasnip").unlink_current()
                    end
                end
            })
        end
    },
      {"saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path"}
    }, -- cmp sources plugins
    opts = function()
        local cmp = require "cmp"

        local function border(hl_name)
            return {{"╭", hl_name}, {"─", hl_name}, {"╮", hl_name}, {"│", hl_name}, {"╯", hl_name},
                    {"─", hl_name}, {"╰", hl_name}, {"│", hl_name}}
        end

        local options = {
            completion = {
                autocomplete = false,
                completeopt = "menu,menuone",
                winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
                border = border "CmpDocBorder",
            },

            window = {
                completion = {
                    autocomplete = false,
                    winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
                    scrollbar = false
                },
                documentation = {
                    border = border "CmpDocBorder",
                    winhighlight = "Normal:CmpDoc"
                }
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end
            },
            mapping = {
                -- completion is only activated manually with Ctrl-Space
                -- up/down to page through options, tab/enter to select
                ["<Down>"] = cmp.mapping.select_next_item(),
                ["<Up>"] = cmp.mapping.select_prev_item(),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-esc"] = cmp.mapping.close(),
                ["<Tab>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true
                },
                ["<CR>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true
                },
            },
            sources = {{
                name = "nvim_lsp"
            },{
                name = "buffer"
            }},
        }

        return options
    end,
    config = function(_, opts)
        require("cmp").setup(opts)
    end
}}
