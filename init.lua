local fn = vim.fn
local cfg = {}

local default = {
	devicons = true,
	padding = 3,
	custom_titles = {
		{ filetype = "TelescopePrompt", title = "telescope" },
	},
	custom_devicons_filetypes = {
		{ filetype = "TelescopePrompt", extension = "telescope" },
	},
}

local title = function(bufnr, custom)
	local f = fn.bufname(bufnr)
	local ft = fn.getbufvar(bufnr, "&filetype")

	for _, i in ipairs(custom) do
		if i.filetype == ft then
			return i.title
		end
	end

	return vim.fn.fnamemodify(f, ":t")
end

local devicon = function(bufnr, custom)
	local ft = fn.getbufvar(bufnr, "&filetype")
	local devicons = require("nvim-web-devicons")

	local icon = devicons.get_icon_by_filetype(ft)
	if icon then
		return icon .. " "
	else
		return ""
	end
end

local tab = function(index, config)
	local winnr = fn.tabpagewinnr(index)
	local bufnr = fn.tabpagebuflist(index)[winnr]
	local bufname = fn.bufname(bufnr)

	local selected = fn.tabpagenr() == index
	local modified = vim.fn.getbufvar(bufnr, "&modified") == 1

	return (selected and "%#TabLineSel#" or "%#TabLine#")
		.. (modified and "%#TabLineModified#" or "")
		.. string.rep(" ", config.padding)
		.. (config.devicons and devicon(bufnr, config.custom_devicons_filetypes) or "")
		.. title(bufnr, config.custom_titles)
		.. string.rep(" ", config.padding)
end

local run = function()
	local s = ""

	for i = 1, vim.fn.tabpagenr("$"), 1 do
		s = s .. "%" .. i .. "T" .. tab(i, cfg)
	end

	s = s .. "%#TabLineFill#"

	return s
end

return {
	run = run,
	setup = function(config)
		cfg = config and vim.tbl_deep_extend("force", default, config) or default

		vim.opt.tabline = '%!v:lua.require("NvRose.base.tabline").run()'
	end,
}
