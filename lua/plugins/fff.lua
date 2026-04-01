local function base_path(use_root)
  if use_root and _G.LazyVim and LazyVim.root then
    return LazyVim.root()
  end

  return vim.uv.cwd()
end

local function normalize_query(query)
  if type(query) ~= "string" then
    return nil
  end

  query = query:gsub("%s+", " ")
  query = vim.trim(query)

  return query ~= "" and query or nil
end

local function visual_selection()
  local chunks = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
  return normalize_query(table.concat(chunks, " "))
end

local function find_files(use_root)
  return function()
    require("fff").find_files_in_dir(base_path(use_root))
  end
end

local function live_grep(use_root, query_fn)
  return function()
    local opts = { cwd = base_path(use_root) }
    local query = query_fn and query_fn() or nil

    if query then
      opts.query = query
    end

    require("fff").live_grep(opts)
  end
end

return {
  {
    "ibhagwan/fzf-lua",
    optional = true,
    keys = {
      { "<leader>/", false },
      { "<leader><space>", false },
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>fg", false },
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sw", false },
      { "<leader>sW", false },
      { "<leader>sw", false, mode = "x" },
      { "<leader>sW", false, mode = "x" },
    },
  },
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
    end,
    -- if you are using nixos
    -- build = "nix run .#release",
    opts = {
      debug = {
        enabled = true,
        show_scores = true,
      },
      keymaps = {
        move_up = { "<Up>", "<C-p>", "<C-k>" },
        move_down = { "<Down>", "<C-n>", "<C-j>" },
      },
    },
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
    keys = {
      {
        "<leader>/",
        live_grep(true),
        desc = "Grep (Root Dir)",
      },
      {
        "<leader><space>",
        find_files(true),
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>ff",
        find_files(true),
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fF",
        find_files(false),
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fg",
        function()
          require("fff").find_in_git_root()
        end,
        desc = "Find Files (git-files)",
      },
      {
        "<leader>sg",
        live_grep(true),
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sG",
        live_grep(false),
        desc = "Grep (cwd)",
      },
      {
        "<leader>sw",
        live_grep(true, function()
          return normalize_query(vim.fn.expand("<cword>"))
        end),
        desc = "Word (Root Dir)",
      },
      {
        "<leader>sW",
        live_grep(false, function()
          return normalize_query(vim.fn.expand("<cword>"))
        end),
        desc = "Word (cwd)",
      },
      {
        "<leader>sw",
        live_grep(true, visual_selection),
        mode = "x",
        desc = "Selection (Root Dir)",
      },
      {
        "<leader>sW",
        live_grep(false, visual_selection),
        mode = "x",
        desc = "Selection (cwd)",
      },
    },
  },
}
