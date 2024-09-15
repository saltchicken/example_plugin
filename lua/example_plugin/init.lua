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

local M = {}

M.setup = function()
	-- Optionally, set custom configurations here
	-- print("Custom NVim-CMP plugin loaded")
end

M.send_post_request = function(callback)
	local Job = require("plenary.job")
	-- print(vim.fn.json_encode(data))
	Job:new({
		command = "curl",
		args = {
			"-X",
			"POST",
			"http://localhost:11434/api/generate",
			"-d",
			'{"model": "llama3.1", "prompt": "What was my last question?", "stream": false}',
			"-H",
			"Content-Type: application/json",
		},
		on_exit = function(j, return_val)
			if return_val == 0 then
				-- print("POST request successful!")
				-- return table.concat(j:result(), "\n")
				local result = table.concat(j:result(), "\n")
				callback(result)
			else
				print("POST request failed!")
				-- print(table.concat(j:stderr_result(), "\n"))
				callback(nil, "Error: POST failed")
			end
		end,
	}):start()
end

M.printTable = function(tbl, indent)
	if not indent then
		indent = 0
	end
	local indent_str = string.rep(" ", indent)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			print(indent_str .. tostring(k) .. ": {")
			printTable(v, indent + 4)
			print(indent_str .. "}")
		else
			print(indent_str .. tostring(k) .. ": " .. tostring(v))
		end
	end
end

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

custom_source.complete = function(self, request, callback)
	-- Simulate an asynchronous operation
	-- for key, value in pairs(request) do
	-- 	print(key)
	-- 	print(value)
	-- end
	-- print(request.name)
	-- for key, value in pairs(request.context) do
	-- 	print(key, value)
	-- end
	M.print_table(request.context, 0)
	M.send_post_request(function(response, error)
		if error then
			print(error)
		else
			-- print("Response: ", response)
			local items = {
				{
					label = "FirstSucess",
					kind = cmp.lsp.CompletionItemKind.Text,
					documentation = "Here is some documentation",
					insertText = response,
				},
			}
			callback(items)
		end
	end)
	-- vim.defer_fn(function()
	-- 	local items = {
	-- 		{
	-- 			label = "HelloWorld",
	-- 			kind = cmp.lsp.CompletionItemKind.Text,
	-- 			-- You can include additional fields here
	-- 		},
	-- 	}
	-- 	callback(items)
	-- end, 5000) -- Simulate a delay of 500ms (0.5 seconds)
end
-- This function defines the behavior of the completion source
-- custom_source.complete = function(self, request, callback)
-- 	-- Define custom completion items
-- 	local items = {
-- 		{
-- 			label = "print",
-- 			kind = cmp.lsp.CompletionItemKind.Function,
-- 			documentation = "Prints a message to the console",
-- 			insertText = 'print("Custom Output: ")',
-- 		},
-- 		{
-- 			label = "custom_func",
-- 			kind = cmp.lsp.CompletionItemKind.Function,
-- 			documentation = "This is a custom function with extra output",
-- 			insertText = "custom_func(arg)",
-- 		},
-- 		{
-- 			label = "my_var",
-- 			kind = cmp.lsp.CompletionItemKind.Variable,
-- 			documentation = "Custom variable with additional context",
-- 			insertText = "my_var = 42 -- Custom assignment",
-- 		},
-- 	}
--
-- 	-- Return the completion items as the result
-- 	callback({
-- 		items = items,
-- 		isIncomplete = false,
-- 	})
-- end

-- Register the custom source in `cmp`
cmp.register_source("custom_source", custom_source.new())

-- Expose a setup function to initialize the plugin

return M
