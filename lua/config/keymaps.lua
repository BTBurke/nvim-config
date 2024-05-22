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
  l = {
    name = "language",
    t = { "<cmd>GoTest -v<cr>", "Go test (current pkg)"},
    f = { "<cmd>GoTest -f<cr>", "Go test (current file)"},
    n = { "<cmd>GoTest -n<cr>", "Go test (nearest testfunc)"},
    s = { "<cmd>GoTestSum<cr>", "Go test summary"},
    o = { "<cmd>GoAlt!<cr>", "Open matching impl/test file"},
    d = { "<cmd>GoDoc<cr>", "Show Go doc"},
  },
  t = {
    name = "terminal",
    t = { "<cmd>ToggleTerm<cr>", "Toggle terminal"},
    b = { "<cmd>lua _gitbug_toggle()<cr>", "Open git bug in termui"},
  },
  w = {
    name = "window",
    h = {"<cmd>wincmd h<cr>", "Move to left"},
    j = {"<cmd>wincmd j<cr>", "Move to below"},
    k = {"<cmd>wincmd k<cr>", "Move to above"},
    l = {"<cmd>wincmd l<cr>", "Move to right"},
  }
}, { prefix = "<leader>" })

-- NvimTree
-- vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", {}) -- open/close
-- vim.keymap.set("n", "<leader>nr", ":NvimTreeRefresh<CR>", {}) -- refresh
-- vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<CR>", {}) -- search file


local Terminal  = require('toggleterm.terminal').Terminal
-- run git bug in a floating terminal window. Overrides editor to use nano because
-- nvim in nvim window is a pain
local gitbug = Terminal:new({
  cmd = "EDITOR=/usr/bin/nano git bug termui",
  dir = "git_dir",
  hidden = true,
  display_name = "Issues",
  direction = "float",
  float_opts = {
    border = "double"
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})

function _gitbug_toggle()
  gitbug:toggle()
end

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  vim.keymap.set('t', '<C-q>', [[<Cmd>q<cr>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
