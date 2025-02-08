local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

local utils = require("neotest-gtest.utils")
local lib = require("neotest.lib")


require("neotest-gtest").setup({
  -- fun(string) -> string: takes a file path as string and returns its project root
  -- directory
  -- neotest.lib.files.match_root_pattern() is a convenient factory for these functions:
  -- it returns a function that returns true if the directory contains any entries
  -- with matching names
  root = lib.files.match_root_pattern(
    "compile_commands.json",
    "compile_flags.txt",
    "WORKSPACE",
    ".clangd",
    "init.lua",
    "init.vim",
    "build",
    ".git"
  ),
  -- which debug adapter to use? dap.adapters.<this debug_adapter> must be defined.
  debug_adapter = "codelldb",
  -- fun(string) -> bool: takes a file path as string and returns true if it contains
  -- tests
  is_test_file = function(file)
    -- by default, returns true if the file stem starts with test_ or ends with _test
    -- the extension must be cpp/cppm/cc/cxx/c++
  end,
  -- How many old test results to keep on disk (stored in stdpath('data')/neotest-gtest/runs)
  history_size = 3,
  -- To prevent large projects from freezing your computer, there's some throttling
  -- for -- parsing test files. Decrease if your parsing is slow and you have a
  -- monster PC.
  parsing_throttle_ms = 10,
  -- set configure to a normal mode key which will run :ConfigureGtest (suggested:
  -- "C", nil by default)
  mappings = { configure = nil },
  summary_view = {
    -- How long should the header be in tests short summary?
    -- ________TestNamespace.TestName___________ <- this is the header
    header_length = 80,
    -- Your shell's colors, if the default ones don't work.
    shell_palette = {
      passed = "\27[32m",
      skipped = "\27[33m",
      failed = "\27[31m",
      stop = "\27[0m",
      bold = "\27[1m",
    },
  },
  -- What extra args should ALWAYS be sent to google test?
  -- if you want to send them for one given invocation only,
  -- send them to `neotest.run({extra_args = ...})`
  -- see :h neotest.RunArgs for details
  extra_args = {},
  -- see :h neotest.Config.discovery. Best to keep this as-is and set
  -- per-project settings in neotest instead.
  filter_dir = function(name, rel_path, root)
    -- see :h neotest.Config.discovery for defaults
  end,
})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "jedi_language_server", "clangd" },
  automatic_installation = false,
})
