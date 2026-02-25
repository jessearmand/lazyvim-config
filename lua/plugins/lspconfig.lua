return {
  "neovim/nvim-lspconfig",
  opts = {
    formatting = {
      disabled = {
        "lua_ls",
      },
    },
    servers = {
      -- Python: ty for type checking, ruff for linting/formatting
      -- Uses vim.lsp.config() + vim.lsp.enable() (Neovim 0.11+ API)
      ty = {
        settings = {
          ty = {
            -- Per-project config via ty.toml or pyproject.toml is preferred
          },
        },
      },
      -- Disable pylsp — replaced by ty + ruff
      pylsp = { enabled = false },
      lua_ls = {
        Lua = {
          validate = { enable = true },
          format = { enable = false },
        },
      },
      jsonls = {
        settings = {
          json = {
            validate = { enable = true },
            format = { enable = false }, -- biome handles formatting
          },
        },
      },
    },
  },
}
