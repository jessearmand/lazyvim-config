-- wrapping.nvim detects soft vs hard wrapping in prose files.
--
-- Its heuristic compares the average line length against 'textwidth', and a
-- 'textwidth' of 0 makes every file look hard-wrapped. A buffer-local
-- 'textwidth' that differs from the global value is read as "set deliberately"
-- and also forces hard mode. So the 80 must be the *global* value, and code
-- buffers opt out locally instead.

-- Prose filetypes: the plugin's own default allowlist. Single source for the
-- lazy-load trigger, the plugin's allowlist, and the code exception below.
local text_filetypes = {
  "asciidoc",
  "gitcommit",
  "help",
  "latex",
  "mail",
  "markdown",
  "rst",
  "tex",
  "text",
  "typst",
}

local TEXT_WIDTH = 80

local function is_text_filetype(ft)
  return vim.tbl_contains(text_filetypes, ft)
end

-- Code (and every other non-prose filetype) gets no automatic line breaks.
-- Scheduled so it runs after ftplugins, some of which set their own width
-- (e.g. Rust sets textwidth=99).
local function disable_textwidth_for_code(args)
  if is_text_filetype(args.match) then
    return
  end
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].filetype == args.match then
      vim.bo[args.buf].textwidth = 0
    end
  end)
end

return {
  {
    "andrewferrier/wrapping.nvim",
    -- Load automatically for prose; for any other buffer, load on first use of
    -- a command or keymap so they stay available everywhere.
    ft = text_filetypes,
    cmd = { "SoftWrapMode", "HardWrapMode", "ToggleWrapMode", "WrappingOpenLog" },
    keys = {
      { "[ow", desc = "Soft wrap mode" },
      { "]ow", desc = "Hard wrap mode" },
      { "yow", desc = "Toggle wrap mode" },
    },
    init = function()
      vim.o.textwidth = TEXT_WIDTH
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_textwidth_code", { clear = true }),
        callback = disable_textwidth_for_code,
      })
    end,
    opts = {
      auto_set_mode_filetype_allowlist = text_filetypes,
    },
  },
}
