-- local function main()
-- 	print("Hello World")
-- end
--
-- local function setup()
-- 	local augroup = vim.api.nvim_create_augroup("ExamplePlugin", { clear = true })
-- 	vim.api.nvim_create_autocmd(
-- 		"VimEnter",
-- 		-- { group = augroup, desc = "An example plugin", once = true, callback = main }
-- 		{
-- 			group = augroup,
-- 			desc = "Test function",
-- 			once = true,
-- 			callback = function()
-- 				vim.api.nvim_create_user_command("TestingCommand", function(opts)
-- 					print("Working with " .. opts.args .. "!")
-- 				end, { nargs = 1 })
-- 			end,
-- 		}
-- 	)
-- end

-- local cmp = require("cmp")
--
-- local function setup()
-- 	require("example_plugin.cmp_source").setup()
-- end
local cmp = require("cmp")

local custom_source = {}

-- Define the source metadata
custom_source.new = function()
	local self = setmetatable({}, { __index = custom_source })
	return self
end

-- Register this source in `nvim-cmp`
custom_source.get_metadata = function()
	return {
		-- Source name
		name = "custom_source",
		-- Set it to support text insertion
		insertText = true,
	}
end

-- This function defines the behavior of the completion source
custom_source.complete = function(self, request, callback)
	-- Define custom completion items
	print(request)
	local items = {
		{
			label = "print",
			kind = cmp.lsp.CompletionItemKind.Function,
			documentation = "Prints a message to the console",
			insertText = 'print("Custom Output: ")',
		},
		{
			label = "custom_func",
			kind = cmp.lsp.CompletionItemKind.Function,
			documentation = "This is a custom function with extra output",
			insertText = "custom_func(arg)",
		},
		{
			label = "my_var",
			kind = cmp.lsp.CompletionItemKind.Variable,
			documentation = "Custom variable with additional context",
			insertText = "my_var = 42 -- Custom assignment",
		},
	}

	-- Return the completion items as the result
	callback({
		items = items,
		isIncomplete = false,
	})
end

-- Register the custom source in `cmp`
cmp.register_source("custom_source", custom_source.new())

-- Expose a setup function to initialize the plugin
local M = {}

M.setup = function()
	-- Optionally, set custom configurations here
	-- print("Custom NVim-CMP plugin loaded")
end

return M
