return {
  {
  "phelipetls/jsonpath.nvim",
  event = "VeryLazy",
  init = function()
      if vim.fn.exists("+winbar") == 1 then
      vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
      end

      -- send json path to clipboard
      vim.keymap.set("n", "<C-x>", function()
        vim.fn.setreg("+", require("jsonpath").get())
      end, { desc = "copy json path", buffer = true })
   end
  }
}
