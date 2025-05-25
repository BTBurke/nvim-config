--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/neoterm.lua
-- Description: Floating terminal configs
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
return {
  {'akinsho/toggleterm.nvim', version = "*", opts = {
      shell = '/usr/bin/elvish',
      shade_terminals = true,
      winbar = {
      enabled= false,
      name_formatter = function (term)
        if term.direction == "tab" then
            return term.name
        end
      end,
    }
    }
  }
}
