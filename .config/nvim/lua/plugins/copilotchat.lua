return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		"zbirenbaum/copilot.lua", -- or
		"nvim-lua/plenary.nvim", -- for curl, log and async functions
	},
	event = "VeryLazy",
	build = "make tiktoken", -- Only on MacOS or Linux
	opts = {
		model = "gpt-5.1",
		window = {
			layout = 'horizontal',
			width = 1, -- Fixed width in columns
			height = 0.3, -- Fixed height in rows
			title = '🤖 AI Assistant',
		},
		headers = {
			user = '👤 You',
			assistant = '🤖 Copilot',
			tool = '🔧 Tool',
		},
		suggestion = { enabled = true },
		separator = '━━',
		auto_fold = true, -- Automatically folds non-assistant messages
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
