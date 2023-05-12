local lsp_lines = require("lsp_lines")

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
    virtual_text = false,
})

vim.keymap.set(
  "",
  "<Leader>l",
  lsp_lines.toggle,
  { desc = "Toggle lsp_lines" }
)
