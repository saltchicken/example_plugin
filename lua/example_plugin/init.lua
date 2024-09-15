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

M.send_post_request = function(text, callback)
	local Job = require("plenary.job")
	print("Iam the text: ", text)
	local prompt_string = '{"model": "llama3.1", "prompt": "' .. text .. '", "stream": false}'
	print("Prompt STring", prompt_string)
	Job:new({
		command = "curl",
		args = {
			"-X",
			"POST",
			"http://localhost:11434/api/generate",
			"-d",
			prompt_string,
			"-H",
			"Content-Type: application/json",
		},
		on_exit = function(j, return_val)
			if return_val == 0 then
				local result = table.concat(j:result(), "\n")
				callback(result)
			else
				print("POST request failed!")
				callback(nil, "Error: POST failed")
			end
		end,
	}):start()
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

function print_table(tbl)
	for key, value in pairs(tbl) do
		if type(value) == "table" then
			print("Table", key)
			for k, v in pairs(value) do
				print("      ", k, "---", v)
			end
		else
			print(key, "---", value)
		end
	end
end

custom_source.complete = function(self, request, callback)
	-- for key, value in pairs(request) do
	-- 	print(key, "---", value)
	-- end
	-- print_table(request)
	M.send_post_request(request.context.cursor_line, function(response, error)
		if error then
			print(error)
		else
			print("Response String ----- ", type(response))
			print("Response String ----- ", response)
			local decoded_table = vim.fn.json_decode(response)
			local items = {
				{
					label = "FirstSucess",
					kind = cmp.lsp.CompletionItemKind.Text,
					documentation = "Here is some documentation",
					insertText = response,
				},
			}
			callback({
				items = items,
				isIncomplete = true,
			})
		end
	end)
end

-- Register the custom source in `cmp`
cmp.register_source("custom_source", custom_source.new())

return M
