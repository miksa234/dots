return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"j-hui/fidget.nvim",
    "hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
	opts = {
	   setup = {
		  rust_analyzer = function()
			 return true
		  end,
	   },
	},
	config = function ()
    map = vim.keymap.set
		vim.opt.signcolumn = 'yes'
		vim.lsp.inlay_hint.enable(true)

		local lspconfig_defaults = require('lspconfig').util.default_config
		require("conform").setup({
			formatters_by_ft = { }
		})

		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			'force',
			lspconfig_defaults.capabilities,
			cmp_lsp.default_capabilities()
		)
		lspconfig_defaults.capabilities = capabilities

		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			callback = function(event)
				local opts = {buffer = event.buf}

				map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
				map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
				map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				map({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
				map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
			end,
		})


		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
        "clangd",
        "julials",
        "nginx_language_server",
        "pyright",
        "eslint",
        "rust_analyzer",
        "tailwindcss",
        "vtsls",
        "nil_ls",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities
					}
				end,
        ['eslint'] = function()
          local lspconfig = require("lspconfig")
          lspconfig.eslint.setup({
            cmd = { 'vscode-eslint-language-server', '--stdio' },
              filetypes = {
                'javascript',
                'javascriptreact',
                'javascript.jsx',
                'typescript',
                'typescriptreact',
                'typescript.tsx',
                'vue',
                'svelte',
                'astro',
                'htmlangular',
            },
            workspace_required = true,
          });
        end,
        ['bashls'] = function()
          local lspconfig = require("lspconfig")
          lspconfig.bashls.setup {
            cmd = {'bash-language-server', 'start'},
            filetypes = {'zsh', 'bash', 'sh'},
						capabilities = capabilities
          }
        end,
        ['tailwindcss'] = function()
					local lspconfig = require("lspconfig")
          lspconfig.tailwindcss.setup({
            includeLangauges = {
              javascript = 'js',
              html = 'html',
              typescript = 'ts',
              typescriptreact = 'tsx',
              javascriptreact = 'jsx',
            }
          })
        end,
				["rust_analyzer"] = function() end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                  path ~= vim.fn.stdpath('config')
                  and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                  return
                end
              end

              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                  version = 'LuaJIT',
                  path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                  },
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                  }
                }
              })
            end,
            settings = {
              Lua = {}
            }
					})
				end,
			}
		})
	end
}


