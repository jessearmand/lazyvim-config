return {
    "saghen/blink.cmp",
    event = "InsertEnter",
    opts = {
        enabled = function()
            return not vim.tbl_contains({ "lua", "markdown" }, vim.bo.filetype)
        end,
    },
}
