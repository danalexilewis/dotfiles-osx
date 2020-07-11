-- https://wezfurlong.org/wezterm/

local wezterm = require 'wezterm';

-- =>
return {
  color_scheme = "Dracula",
  font = wezterm.font("FiraCode Nerd Font"),
  font_size = 12.0,
  enable_scroll_bar = true,
  window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
  },
  color_schemes = {
    -- https://github.com/dracula/dracula-theme
    -- Background 	#282a36
    -- Current Line 	#44475a
    -- Selection 	#44475a
    -- Foreground 	#f8f8f2
    -- Comment 		#6272a4
    -- Cyan 		#8be9fd
    -- Green 		#50fa7b
    -- Orange 		#ffb86c
    -- Pink 		#ff79c6
    -- Purple 		#bd93f9
    -- Red 		#ff5555
    -- Yellow 		#f1fa8c
    ["Dracula"] = {
      foreground = "#f8f8f2",
      background = "#282a36",
      cursor_bg = "#44475a",
      cursor_fg = "#ff79c6",
      cursor_border = "#50fa7b",
      selection_bg = "#44475a",
      selection_fg = "#f8f8f2",
      scrollbar_thumb = "#bd93f9",
      ansi = {
        "#000000", -- white
        "#ff5555", -- red
        "#50fa7b", -- reen
        "#f1fa8c", -- yellow
        "#bd93f9", -- purple
        "#ff79c6", -- pink
        "#8be9fd", -- cyan
        "#bbbbbb", -- grey (not in dracula)
      },
     brights = {"#555555","#ff5555","#50fa7b","#f1fa8c","#bd93f9","#ff79c6","#8be9fd","#ffffff"},
    }
  },
}g
