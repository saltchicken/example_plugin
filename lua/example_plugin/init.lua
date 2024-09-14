local function main()
	print("Hello World")
end

local function setup()
	local augroup = vim.api.nvim_create_augroup("ExamplePlugin", { clear = true })
	vim.api.nvim_create_autocmd(
		"VimEnter",
		{ group = augroup, desc = "An example plugin", once = true, callback = main }
	)
end
