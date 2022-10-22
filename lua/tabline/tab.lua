local fn = vim.fn

local title = function(bufnr, custom)
	local f = fn.bufname(bufnr)
	local bt = fn.getbufvar(bufnr, '&buftype')
	local ft = fn.getbufvar(bufnr, '&filetype')

	for _, i in ipairs(custom) do
		if i.filetype == ft then
			return i.title
		end
	end

	return fn.pathshorten(fn.fnamemodify(f, ':p:~:t'))
end

local devicon = function(bufname, bufnr, custom)
	local extension = fn.expand('#'..bufnr..':e')
	local devicon = require('nvim-web-devicons').get_icon

	for _, i in ipairs(custom) do
		if i.filetype == extension then
			local icon, color = devicon(i.extension)
			if icon then icon = icon .. ' ' end
			return icon
		end
	end

	local icon, color = devicon(bufname, extension)
	if icon then icon = icon .. ' ' end
	return icon
end

return function(index, config)
	local winnr = fn.tabpagewinnr(index)
	local bufnr = fn.tabpagebuflist(index)[winnr]
	local bufname = fn.bufname(bufnr)

	local selected = fn.tabpagenr() == index
	local modified = vim.fn.getbufvar(bufnr, '&modified') == 1

	return (selected and '%#TabLineSel#' or '%#TabLine#')
		.. (modified and '%#TabLineModified#' or '')
		.. string.rep(' ', config.padding)
		.. (config.devicons
			and devicon(bufname, bufnr, config.custom_devicons_filetypes)
			or '')
		.. title(bufnr, config.custom_titles)
		.. string.rep(' ', config.padding)
end
