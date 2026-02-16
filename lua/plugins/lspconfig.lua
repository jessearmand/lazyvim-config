return {
  "neovim/nvim-lspconfig",
  opts = {
    formatting = {
      disabled = {
        "lua_ls",
      },
    },
    servers = {
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
