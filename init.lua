local fn = vim.fn
local cfg = {}

local default = {
	custom_titles = {
		{ filetype = "TelescopePrompt", title = "telescope" },
	},
	custom_devicons_filetypes = {
		{ filetype = "TelescopePrompt", extension = "telescope" },
	},
}

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

local function get_cols()
	local f = assert(io.popen("tput cols", "r"))
	local cols = f:read("a")
	f:close()

	return tonumber(cols)
end

local get_title = function(bufnr, custom)
	local f = fn.bufname(bufnr)
	local ft = fn.getbufvar(bufnr, "&filetype")

	for _, i in ipairs(custom) do
		if i.filetype == ft then
			return i.title
		end
	end

	local title = devicon(bufnr) .. fn.fnamemodify(f, ":t")
	local title_len = string.len(title)
	local win_width = get_cols()

	local padding = math.floor(((win_width / fn.tabpagenr("$") - title_len) + 0.5) / 2) + 1

	return string.rep(" ", padding) .. title .. string.rep(" ", padding)
end

local tab = function(index, config)
	local winnr = fn.tabpagewinnr(index)
	local bufnr = fn.tabpagebuflist(index)[winnr]

	local selected = fn.tabpagenr() == index
	local modified = fn.getbufvar(bufnr, "&modified") == 1

	return (selected and "%#TabLineSel#" or "%#TabLine#")
		.. (modified and "%#TabLineModified#" or "")
		.. get_title(bufnr, config.custom_titles)
end

local run = function()
	local s = ""

	for i = 1, fn.tabpagenr("$"), 1 do
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
		vim.cmd("redrawtabline")
	end,
}
