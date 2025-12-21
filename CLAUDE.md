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

- **Formatting**: `conform.nvim` with Biome for JS/TS/JSON, Prettier for HTML
- **Diagnostics**: LSP servers (jsonls for JSON, rust-analyzer for Rust, pylsp for Python)
- **Pattern**: LSP handles diagnostics, external formatters handle formatting to avoid conflicts

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

### Enabled Language Extras

From `lazyvim.json`: json, python, rust, typescript, yaml

### Custom Plugins

- `nvim-aider`: AI coding assistant integration (`<leader>a` prefix)
- `night-owl.nvim`: Colorscheme
- `rg.nvim`: Ripgrep integration (`:Rg` commands)
- `blink.cmp`: Completion (disabled for lua/markdown filetypes)

## Symlink Structure

This repository is the source of truth. Files are symlinked from `~/.config/nvim/`:
- Root: `init.lua`, `lazyvim.json`, `.neoconf.json`, `stylua.toml`
- `lua/config/`: All config files
- `lua/plugins/`: All plugin files

Files NOT symlinked (kept local): `lazy-lock.json`, files with API keys
