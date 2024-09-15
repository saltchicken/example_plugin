local cmp = require("cmp")

local M = {}

function M.setup()
	cmp.register_source("my_source", M.new())
end

function M.new()
	local self = setmetatable({}, { __index = M })
	return self
end

function M:complete(params, callback)
	local items = {
		{ label = "Hello", kind = cmp.lsp.CompletionItemKind.Text },
		{ label = "World", kind = cmp.lsp.CompletionItemKind.Text },
	}
	callback({ items = items, isIncomplete = false })
end

return M
