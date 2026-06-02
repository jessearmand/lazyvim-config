## Overview

This is a LazyVim configuration repository that is symlinked to `~/.config/nvim/`. Changes made here are immediately reflected in the active Neovim configuration.

## Lua Formatting

Use StyLua for Lua files:
```bash
stylua lua/
```

Configuration (from `stylua.toml`): 2-space indentation, 120 column width.

## Architecture

### LazyVim Plugin System

LazyVim uses a declarative plugin configuration pattern. Each file in `lua/plugins/` returns a Lua table that lazy.nvim merges into the plugin spec.

**Plugin override pattern:**
```lua
return {
    "plugin/name",
    opts = {
        -- These merge with the plugin's default opts
    },
}
```

### Key Configuration Files

| File | Purpose |
|------|---------|
| `lazyvim.json` | Enabled LazyVim extras (lang support, features) |
| `lua/config/options.lua` | Vim options, LSP server choices |
| `lua/config/keymaps.lua` | Custom keybindings |
| `lua/config/autocmds.lua` | Auto commands |
| `lua/plugins/*.lua` | Plugin configurations |

### Formatter/Linter Architecture

- **Formatting**: `conform.nvim` with Biome for JS/TS/JSON, Prettier for HTML, StyLua for Lua, xmllint for XML
- **Diagnostics**: LSP servers (jsonls for JSON, rust-analyzer for Rust, ty for Python type checking, ruff for Python linting/formatting)
- **Pattern**: LSP handles diagnostics, external formatters handle formatting to avoid conflicts. `lua_ls` formatting is disabled (StyLua owns it); `pylsp` is disabled (replaced by ty + ruff)

Example in `lspconfig.lua`:
```lua
jsonls = {
    settings = {
        json = {
            validate = { enable = true },   -- LSP does diagnostics
            format = { enable = false },    -- Biome does formatting
        },
    },
},
```

### Enabled Extras

From `lazyvim.json`: mini-surround, fzf, typescript (+biome), json, python, rust, yaml

### Custom Plugins

- `night-owl.nvim`: Colorscheme (loaded at startup, `priority = 1000`)
- `rg.nvim`: Ripgrep integration (`:Rg`, `:Rgf`, `:Rgp`, `:Rgfp` commands)
- `which-key.nvim`: Keymap hints (`<leader>?` for buffer-local keymaps)
- `fff.nvim`: Fuzzy file finder + live grep, replacing the default `fzf-lua` find/grep bindings. Owns `<leader>/`, `<leader><space>`, `<leader>ff`/`fF`/`fg`, `<leader>sg`/`sG`/`sw`/`sW` (Root Dir vs cwd variants; `sw`/`sW` also work in visual mode on the selection). See `lua/plugins/fff.lua`.
- `venv-selector.nvim`: **disabled** (unnecessary with ty + ruff)

## Symlink Structure

This repository is the source of truth. Files are symlinked from `~/.config/nvim/`:
- Root: `init.lua`, `lazyvim.json`, `.neoconf.json`, `stylua.toml`
- `lua/config/`: All config files
- `lua/plugins/`: All plugin files

Files NOT symlinked (kept local): `lazy-lock.json`, files with API keys
