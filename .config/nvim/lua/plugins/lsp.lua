return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"j-hui/fidget.nvim",
		"chrisgrieser/nvim-lsp-endhints",
		"zbirenbaum/copilot-cmp"
	},
	opts = {
	   setup = {
		  rust_analyzer = function()
			 return true
		  end,
	   },
	},
	config = function ()
		vim.opt.signcolumn = 'yes'
		vim.o.winborder = 'single'
		vim.diagnostic.enable(false)
		vim.lsp.inlay_hint.enable(true)
		vim.diagnostic.config({
			virtual_lines = true,
			virtual_text = true,
		})


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

				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
				vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
				vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
			end,
		})


		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities
					}
				end,
        ['bashls'] = function()
          local lspconfig = require("lspconfig")
          lspconfig.bashls.setup {
            cmd = {'bash-language-server', 'start'},
            filetypes = {'zsh', 'bash', 'sh'},
						capabilities = capabilities
          }
        end,
				["rust_analyzer"] = function() end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								telemetry = {
									enable = false
								},
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								}
							}
						},
						on_init = function(client)
							local join = vim.fs.joinpath
							local path = client.workspace_folders[1].name
							if vim.uv.fs_stat(join(path, '.luarc.json'))
								or vim.uv.fs_stat(join(path, '.luarc.jsonc'))
							then
								return
							end

							local runtime_path = vim.split(package.path, ';')
							table.insert(runtime_path, join('lua', '?.lua'))
							table.insert(runtime_path, join('lua', '?', 'init.lua'))

							local nvim_settings = {
								runtime = {
									version = 'LuaJIT',
									path = runtime_path
								},
								diagnostics = {
									globals = {'vim'}
								},
								workspace = {
									checkThirdParty = false,
									library = {
										vim.env.VIMRUNTIME,
										vim.fn.stdpath('config'),
									},
								},
							}

							client.config.settings.Lua = vim.tbl_deep_extend(
								'force',
								client.config.settings.Lua,
								nvim_settings
							)
						end
					})
				end,
			}
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		local luasnip = require("luasnip")
		require("copilot_cmp").setup()

		local has_words_before = function()
		  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
		  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					--require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					vim.snippet.expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				["<C-Space>"] = cmp.mapping.complete(),
				['<`-j>'] = cmp.mapping.scroll_docs(-4),
				['<`-k>'] = cmp.mapping.scroll_docs(4),
				['<C-a>'] = cmp.mapping(function(fallback)
					 if cmp.visible() then
						 if luasnip.expandable() then
							 luasnip.expand()
						 else
							 cmp.confirm({ select = true,
							 })
						 end
					 else
						 fallback()
					 end
				 end),
				 ["<Tab>"] = vim.schedule_wrap(function(fallback)
					if cmp.visible() and has_words_before() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					elseif luasnip.locally_jumpable(1) then
						luasnip.jump(1)
					else
						fallback()
					end
				 end),
				 ["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				 end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = 'path' },							  -- file paths
				{ name = 'luasnip' },						   -- file paths
				{ name = 'nvim_lsp', keyword_length = 3 },	  -- from language server
				{ name = 'nvim_lsp_signature_help'},			-- display function signatures with current parameter emphasized
				{ name = 'nvim_lua', keyword_length = 2},	   -- complete neovim's Lua runtime API such vim.lsp.*
				{ name = 'buffer', keyword_length = 2 },		-- source current buffer
				{ name = 'calc'},							   -- source for math calculation
				{ name = 'copilot'},							   -- source for math calculation
			}),
			window = {
				documentation = cmp.config.window.bordered({
					winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,NormalFloat:Normal',
				}),
				completion = cmp.config.window.bordered({
					winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,NormalFloat:Normal',
				}),
			},
			formatting = {
				fields = {'menu', 'abbr', 'kind'},
				format = function(entry, item)
					local menu_icon ={
						nvim_lsp = 'λ',
						luasnip = '⋗',
						buffer = 'Ω',
						path = '🖫',
						copilot = " "
					}
					--item.kind = string.format('%s %s', kind_icons[item.kind], item.kind)
					item.menu = menu_icon[entry.source.name]
					return item
				end,
			},
		})

		vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
		vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

		local endhints = require("lsp-endhints")
		endhints.enable()
		endhints.setup {
			icons = {
				type = "-> ",
				parameter = "<= ",
				offspec = "<= ", -- hint kind not defined in official LSP spec
				unknown = "? ", -- hint kind is nil
			},
			label = {
				truncateAtChars = 50,
				padding = 1,
				marginLeft = 0,
				sameKindSeparator = ", ",
			},
			extmark = {
				priority = 50,
			},
			autoEnableHints = true,
		}

		vim.keymap.set('n', '<leader>h', function(bufnr)
			if vim.lsp.inlay_hint.is_enabled() then
				print("Inlay Hitnts OFF")
			else
				print("Inlay Hitnts ON")
			end
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), bufnr)
		end, { silent = true, noremap = true })

		vim.keymap.set('n', '<leader>d', function()
			if vim.diagnostic.is_enabled() then
				print("Diagnostics OFF")
			else
				print("Diagnostics ON")
			end
			vim.diagnostic.enable(not vim.diagnostic.is_enabled())
		end, { silent = true, noremap = true })
	end
}


