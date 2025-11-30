return {
	'mrcjkb/rustaceanvim',
	version = '^6', -- Recommended
	lazy = false, -- This plugin is already lazy
	dependencies = {
		"mason-org/mason-registry",
	},
	config = function()
		vim.g.rustaceanvim = {
			tools = {
				float_win_config = {
					border = "rounded",
				}
			},
			server = {
				on_attach = function(client, bufnr)
					vim.keymap.set(
						"n",
						"<leader>a",
						function()
							vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
							-- or vim.lsp.buf.codeAction() if you don't want grouping.
						end,
						{ silent = true, buffer = bufnr }
					)
					vim.keymap.set(
						"n",
						"K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
						function()
							vim.cmd.RustLsp({'hover', 'actions'})
						end,
						{ silent = true, buffer = bufnr }
					)
				end,
				cmd = function()
				local mason_registry = require('mason-registry')
					if mason_registry.is_installed('rust-analyzer') then
						-- This may need to be tweaked depending on the operating system.
						local ra = mason_registry.get_package('rust-analyzer')
						local ra_filename = ra:get_receipt():get().links.bin['rust-analyzer']
						return { ('%s/%s'):format(ra:get_install_path(), ra_filename or 'rust-analyzer') }
					else
				-- global installation
						return { 'rust-analyzer' }
					end
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					['rust-analyzer'] = {
						diagnostics = {
							enable = true;
						},
						cargo = {
							allFeatures = true,
						},
					},
				},
				settings = {
					['rust-analyzer'] = {
						inlayHints = {
							maxLength = 50,
							renderColons = true,
							bindingModeHints = {
								enable = false,
							},
							chainingHints = {
								enable = true,
							},
							closingBraceHints = {
								enable = true,
								minLines = 50,
							},
							closureCaptureTypeHints = {
								enable = true,
							},
							closureReturnTypeHints = {
								enable = true,
							},
							lifetimeElisionHints = {
								enable = true,
								useParameterNames = false,
							},
							genericParameterHints = {
								const = {
									enable = true,
								},
								lifetime = {
									enable = true,
								},
								type = {
									enable = true,
								},
							},
							parameterHints = {
								enable = true,
							},
							reborrowHints = {
								enable = "never",
							},
							typeHints = {
								enable = true,
								hideClosureInitialization = false,
								hideNamedConstructor = false,
							},
						},
					},
				},
			},
		}

	end
}
