local fn = vim.fn

local devicon = function(bufnr)
	local ft = fn.getbufvar(bufnr, "&filetype")
	local devicons = require("nvim-web-devicons")

	local icon = devicons.get_icon_by_filetype(ft)
	if icon then
		return icon .. " "
	else
		return ""
	end
end

local get_title = function(bufnr)
	local f = fn.bufname(bufnr)
	local title = devicon(bufnr) .. fn.fnamemodify(f, ":t")

	local title_len = string.len(title)
	local win_width = vim.api.nvim_win_get_width(0)

	local padding = math.floor(((win_width / fn.tabpagenr("$") - title_len) + 0.5) / 2)

	return string.rep(" ", padding) .. title .. string.rep(" ", padding)
end

local tab = function(index)
	local winnr = fn.tabpagewinnr(index)
	local bufnr = fn.tabpagebuflist(index)[winnr]

	local selected = fn.tabpagenr() == index
	local modified = fn.getbufvar(bufnr, "&modified") == 1

	return (selected and "%#TabLineSel#" or "%#TabLine#")
		.. (modified and "%#TabLineModified#" or "")
		.. get_title(bufnr)
end

local run = function()
	local s = ""

	for i = 1, fn.tabpagenr("$"), 1 do
		s = s .. "%" .. i .. "T" .. tab(i)
	end

	return s
end

return {
	run = run,
	setup = function()
		vim.opt.tabline = '%!v:lua.require("NvRose.base.tabline").run()'
	end,
}
