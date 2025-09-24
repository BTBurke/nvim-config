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
wk.add({
    { "<leader>f", group = "file" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find in files" },
    { "<leader>fn", desc = "New File" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open recent file" },
    { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc= "Toggle file tree"},
    { "<leader>l", group = "language" },
    { "<leader>ld", "<cmd>GoDoc<cr>", desc = "Show Go doc" },
    { "<leader>lf", "<cmd>GoTest -f<cr>", desc = "Go test (current file)" },
    { "<leader>ln", "<cmd>GoTest -n<cr>", desc = "Go test (nearest testfunc)" },
    { "<leader>lo", "<cmd>GoAlt!<cr>", desc = "Open matching impl/test file" },
    { "<leader>ls", "<cmd>GoTestSum<cr>", desc = "Go test summary" },
    { "<leader>lt", "<cmd>GoTest -v<cr>", desc = "Go test (current pkg)" },
    { "<leader>t", group = "terminal" },
    { "<leader>tb", "<cmd>lua _gitbug_toggle()<cr>", desc = "Open git bug in termui" },
    { "<leader>tc", "<cmd>lua _claude_toggle()<cr>", desc = "Open Claude code in termui" },
    { "<leader>tt", "<cmd>ToggleTerm direction=tab name='terminal'<cr>", desc = "Toggle terminal" },
    { "<leader>w", group = "window" },
    { "<leader>wh", "<cmd>wincmd h<cr>", desc = "Move to left" },
    { "<leader>wj", "<cmd>wincmd j<cr>", desc = "Move to below" },
    { "<leader>wk", "<cmd>wincmd k<cr>", desc = "Move to above" },
    { "<leader>wl", "<cmd>wincmd l<cr>", desc = "Move to right" },
  })

-- NvimTree
-- vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", {}) -- open/close
-- vim.keymap.set("n", "<leader>nr", ":NvimTreeRefresh<CR>", {}) -- refresh
-- vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<CR>", {}) -- search file

-- for code actions
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true })

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

local claude = Terminal:new({
  cmd = "claude",
  dir = "git_dir",
  hidden = true,
  display_name = "Claude",
  direction = "tab",
  terminal = "/usr/bin/fish",
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})

function _claude_toggle()
  claude:toggle()
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
