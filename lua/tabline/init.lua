M = {}

M.get_item = function(group, item, index, modified)
    local active = index == vim.fn.tabpagenr()
    if modified then
        group = group .. 'Modified'
    end
    if active then
        group = group .. 'Sel'
    end

    return '%#' .. group .. '# ' .. item .. ' %*'
end

M.get_tabname = function(bufname, index)
    local title = vim.fn.gettabvar(index, 'TablineTitle')
    if title ~= vim.NIL and title ~= '' then
        return title
    end
    return vim.fn.fnamemodify(bufname, ':t')
end

M.run = function()
	local s = ''

	for i = 1, vim.fn.tabpagenr('$') do
		local winnr = vim.fn.tabpagewinnr(i)
		local bufnr = vim.fn.tabpagebuflist(i)[winnr]
		local bufname = vim.fn.bufname(bufnr)
		local tabname = M.get_tabname(bufname, i)

		s = s .. '%' .. i .. 'T'

		local tabline_items = {
		  	M.get_item('Tab', tabname, i)
		}

		if tabname ~= "" then
			s = s .. table.concat(tabline_items)
		end
	end

	return s
end

M.setup = function()
	vim.opt.tal = '%!v:lua.require("tabline").run()'
end

return M
