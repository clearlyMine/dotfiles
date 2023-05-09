require('catppuccin').setup({
    -- disable_background = true
        color_overrides = {
            mocha = {
                base = "#1e1f29",
            },
        }
})

require('tokyonight').setup({
      theme = "night",
      on_colors = function(colors)
         colors.bg = "#1e1f29"
      end
})

function ColorMyPencils(color)
	color = color or "tokyonight-night"
	vim.cmd.colorscheme(color)

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils()
