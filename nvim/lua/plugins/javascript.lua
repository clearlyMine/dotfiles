return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed,
        { "eslint-lsp", "prettierd", "tailwindcss-language-server", "typescript-language-server" })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      -- return require "custom.configs.null-ls"
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local null_ls = require("null-ls")

      local opts = {
        sources = {
          null_ls.builtins.formatting.prettierd,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      }

      return opts
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

}
