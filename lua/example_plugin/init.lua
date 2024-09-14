local function main()
	print("Hello World")
end

local function setup()
	local augroup = vim.api.nvim_create_augroup("ExamplePlugin", { clear = true })
	vim.api.nvim_create_autocmd(
		"VimEnter",
		{ group = augroup, desc = "An example plugin", once = true, callback = main }
	)

	vim.api.nvim_create_user_command("TestCommand", function()
		print("TestCommand executed")
	end, {})
end

return { setup = setup }
