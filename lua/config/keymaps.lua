--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: config/keymaps.lua
-- Description: Key mapping configs

local wk = require("which-key")
wk.register({
  f = {
    name = "file", -- optional group name
    f = { "<cmd>Telescope find_files<cr>", "Find file" },
    b = { "<cmd>Telescope buffers<cr>", "Find buffer"},
    r = { "<cmd>Telescope oldfiles<cr>", "Open recent file" },
    g = { "<cmd>Telescope live_grep", "Find in files"},
    n = { "New File" },
  },

}, { prefix = "<leader>" })

-- Fast saving with <leader> and s



-- vim.keymap.set("n", "<leader>s", ":w<CR>", {})
-- Move around splits
-- vim.keymap.set("n", "<leader>wh", "<C-w>h", {})
-- vim.keymap.set("n", "<leader>wj", "<C-w>j", {})
-- vim.keymap.set("n", "<leader>wk", "<C-w>k", {})
-- vim.keymap.set("n", "<leader>wl", "<C-w>l", {})

-- Reload configuration without restart nvim
-- vim.keymap.set("n", "<leader>r", ":so %<CR>", {})

-- Telescope
-- <leader> is a space now
--local builtin = require("telescope.builtin")
--vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
--vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
--vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
--vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- NvimTree
-- vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", {}) -- open/close
-- vim.keymap.set("n", "<leader>nr", ":NvimTreeRefresh<CR>", {}) -- refresh
-- vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<CR>", {}) -- search file

-- Terminal
-- vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", {})
-- vim.keymap.set("n", "<leader>tx", ":NeotermExit<CR>", {})

-- function _G.set_terminal_keymaps()
--  local opts = {buffer = 0}
--  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
--  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
--  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
--  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
--  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
--  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
--  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
-- end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
