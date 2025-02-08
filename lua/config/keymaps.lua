-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local function cmd(command)
  return table.concat({ "<Cmd>", command, "<CR>" })
end

vim.keymap.set("n", "<leader>pp", cmd("TmuxNavigateLeft"))
vim.keymap.set("n", "<leader>tt", cmd("terminal"))
vim.api.nvim_set_keymap("t", "<C-space>", "<C-\\><C-n>:CFloatTerm<CR>", { noremap = true, silent = true })
