return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            javascript = { "biome" },
            typescript = { "biome" },
            javascriptreact = { "biome" },
            typescriptreact = { "biome" },
            json = { "biome" },
            html = { "prettier" },
            fish = {}, -- disable fish_indent if you don't use it
        },
    },
}
