-- =========================
-- BASIC EDITOR SETTINGS
-- =========================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.signcolumn = "yes"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess:append("c")

vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.confirm = true

-- =========================
-- DIAGNOSTICS
-- =========================

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
  desc = "Previous diagnostic",
})

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
  desc = "Next diagnostic",
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
  desc = "Show diagnostic",
})

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
  desc = "Diagnostics list",
})

-- =========================
-- GENERAL KEYMAPS
-- =========================

vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", {
  desc = "Trigger completion",
})

vim.keymap.set("n", "<leader>w", ":write<CR>", {
  desc = "Save file",
})

vim.keymap.set("n", "<leader>x", ":bdelete<CR>", {
  desc = "Close buffer",
})

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", {
  desc = "Clear search highlight",
})

vim.keymap.set("n", "]q", ":cnext<CR>", {
  desc = "Next quickfix item",
})

vim.keymap.set("n", "[q", ":cprev<CR>", {
  desc = "Previous quickfix item",
})

-- =========================
-- LSP ATTACH KEYMAPS
-- =========================

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      buffer = bufnr,
      desc = "Go to definition",
    })

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
      buffer = bufnr,
      desc = "Go to declaration",
    })

    vim.keymap.set("n", "gr", vim.lsp.buf.references, {
      buffer = bufnr,
      desc = "References",
    })

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {
      buffer = bufnr,
      desc = "Hover documentation",
    })

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
      buffer = bufnr,
      desc = "Rename symbol",
    })

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
      buffer = bufnr,
      desc = "Code action",
    })

    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({
        bufnr = bufnr,
        timeout_ms = 2000,
      })
    end, {
      buffer = bufnr,
      desc = "Format file",
    })
  end,
})

-- =========================
-- RUST LSP: rust-analyzer
-- =========================

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",

  callback = function()
    if vim.lsp.get_clients({
      name = "rust-analyzer",
      bufnr = 0,
    })[1] then
      return
    end

    local root_file = vim.fs.find({
      "Cargo.toml",
      ".git",
    }, {
      upward = true,
    })[1]

    local root_dir = root_file
        and vim.fs.dirname(root_file)
        or vim.loop.cwd()

    vim.lsp.start({
      name = "rust-analyzer",
      cmd = {
        "rust-analyzer",
      },
      root_dir = root_dir,
    })
  end,
})

-- =========================
-- FORMAT RUST ON SAVE
-- =========================

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",

  callback = function()
    vim.lsp.buf.format({
      timeout_ms = 2000,
    })
  end,
})