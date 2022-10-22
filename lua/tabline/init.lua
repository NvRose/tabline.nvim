local cfg = {}

local default = {
	devicons = true,
	padding = 3,
	custom_titles = {
		{ filetype = 'TelescopePrompt', title = 'telescope' }
	},
	custom_devicons_filetypes = {
		{ filetype = 'TelescopePrompt', extension = 'telescope' }
	}
}

local run = function()
	local s = ''
	local next
	local tab = require('tab')

	for i = 1, vim.fn.tabpagenr('$'), 1 do
		-- Make tabs clickable
		s = s .. '%' .. i .. 'T' .. tab(i, cfg)
	end

	return s
end

return {
	run = run,
	setup = function(config)
		cfg = config
			and vim.tbl_deep_extend('force', default, config)
			or default

		vim.opt.tal = '%!v:lua.require\'tabline\'.run()'
	end
}
