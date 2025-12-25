return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		"zbirenbaum/copilot.lua",
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	build = "make tiktoken",
	opts = {
		model = "claude-sonnet-4.5",
		window = {
			layout = 'horizontal',
			width = 1,
			height = 0.3,
			title = '🤖 AI Assistant',
		},
		headers = {
			user = '👤 You',
			assistant = '🤖 Copilot',
			tool = '🔧 Tool',
		},
		suggestion = { enabled = true },
		separator = '━━',
		auto_fold = true,
	},
	config = function(_, opts)
		require("CopilotChat").setup(opts)
	end,
	keys = {
		{
			"<leader>ao",
			function()
				vim.cmd("CopilotChatOpen")
			end,
			desc = "CopilotChat - Activate",
		},
		{
			"<leader>ar",
			function()
				vim.cmd("CopilotChatReset")
			end,
			desc = "CopilotChat - Reset",
		},
	},
}
