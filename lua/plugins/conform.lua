return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- JS/TS/JSON are handled by oxfmt, appended by the typescript.oxc extra.
      -- Do not set them here: a table override replaces the extra's list.
      lua = { "stylua" },
      -- Resolved from the project's node_modules; skipped when absent.
      html = { "prettier" },
      xml = { "xmllint" },
      fish = {}, -- disable fish_indent if you don't use it
    },
  },
}
