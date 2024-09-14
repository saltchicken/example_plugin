local example_plugin = require("example_plugin")

vim.api.nvim_create_user_command("HelloWorld", function()
	print("Did this work?")
	example_plugin.hello()
end, {})
