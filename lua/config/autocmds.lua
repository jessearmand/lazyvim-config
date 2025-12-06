-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable spell checking for git commit messages (keep wrap enabled)
-- LazyVim enables spell check via lazyvim_wrap_spell augroup for:
-- text, plaintex, typst, gitcommit, markdown
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit" },
    -- Alternative: uncomment additional filetypes to disable spell for them too
    -- pattern = { "gitcommit", "markdown" },
    -- pattern = { "gitcommit", "markdown", "text" },
    -- pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },  -- all
    callback = function()
        vim.opt_local.spell = false
    end,
})

-- Alternative: Delete the entire augroup and recreate with only wrap (no spell)
-- Uncomment the following block if you want to disable spell for ALL filetypes
-- that LazyVim enables it for, while keeping the wrap behavior:
--
-- vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- vim.api.nvim_create_autocmd("FileType", {
--     group = vim.api.nvim_create_augroup("lazyvim_user_wrap", { clear = true }),
--     pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
--     callback = function()
--         vim.opt_local.wrap = true
--         -- spell intentionally omitted
--     end,
-- })
