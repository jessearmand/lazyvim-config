## Overview

A LazyVim configuration. This repository is the source of truth; the active
Neovim config at `~/.config/nvim/` is symlinked to it, so edits here take effect
on the next Neovim start with no copy step.

Anything not documented below follows stock LazyVim conventions — consult the
upstream docs or read `~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/` rather
than assuming this repo diverges.

## Symlink Structure

`~/.config/nvim` is a **single directory symlink** to this repository:

```
~/.config/nvim -> ~/Develop/lazyvim-config
```

Consequences:

- **Every file in the repo is live.** A new `lua/plugins/foo.lua` is picked up
  on the next Neovim start with no extra step.
- **Neovim's runtime writes land in the working tree.** `lazy-lock.json` is
  rewritten by `:Lazy install`/`update`/`sync`, so its git diff is the real
  record of plugin bumps — review it before committing.
- **There is no machine-local side.** Secrets go in a file that `.gitignore`
  already covers (`.env*`, `secrets.lua`, `*.key`, `*.pem`, `*.token`, …) —
  e.g. `lua/config/secrets.lua`, loaded with `pcall(require, "config.secrets")`
  so a fresh clone without it still starts. Any other name will show up as
  untracked and can be committed by accident.

## Formatting This Repo

```bash
stylua lua/
```

Run before committing. Settings live in `stylua.toml`.

## Conventions and Decisions

These are the choices a reader cannot infer from stock LazyVim:

- **LSP owns diagnostics, external formatters own formatting.** Wherever both
  could act, the LSP's formatting capability is turned off so the two never
  fight over a buffer. Hence `lua_ls` formatting disabled (StyLua owns Lua),
  `jsonls` formatting disabled, and `oxfmt`'s LSP disabled by the oxc extra in
  favour of conform. See `lua/plugins/lspconfig.lua` and `lua/plugins/conform.lua`.
- **Python is ty + ruff**, set via `vim.g.lazyvim_python_lsp` / `lazyvim_python_ruff`
  in `lua/config/options.lua`. `pylsp` is explicitly disabled, and
  `venv-selector.nvim` is disabled in `lua/plugins/init.lua` because it needs an
  `fd` binary and adds nothing on top of ty + ruff.
- **JS/web formatters are a per-project concern.** prettier and biome are
  expected to be devDependencies of the project being edited, never global
  installs. conform.nvim resolves prettier, biome, and oxfmt through
  `util.from_node_modules()`, which walks up from the buffer to
  `node_modules/.bin/` and only falls back to `$PATH` — so a project-local,
  version-pinned binary wins automatically. A formatter conform cannot find is
  skipped, not fatal. Use `bunx`/`npx` for one-offs; do not add global installs
  to make a filetype format.
- **`fff.nvim` replaces fzf-lua for find and grep.** `lua/plugins/fff.lua`
  disables the corresponding fzf-lua keys with `{ key, false }` and rebinds them
  itself — a cross-file interaction that is invisible from either plugin alone.
  It owns `<leader>/`, `<leader><space>`, `<leader>ff`/`fF`/`fg`, and
  `<leader>sg`/`sG`/`sw`/`sW`, each in Root Dir vs cwd variants; `sw`/`sW` also
  work in visual mode against the selection. fzf-lua is still installed and
  still owns everything else.
- **Prose wraps at 80, code never auto-wraps.** `lua/plugins/wrapping.lua` sets
  the *global* `textwidth=80` and then resets it to `0` locally for every
  filetype outside its prose list. This looks backwards, but wrapping.nvim
  needs it: with `textwidth=0` its heuristic detects every file as hard-wrapped,
  and a buffer-local `textwidth` that differs from the global value is read as
  "set deliberately", which also forces hard mode. Add prose filetypes to the
  `text_filetypes` list in that file; it drives the lazy-load trigger, the
  plugin's allowlist, and the code exception together.

## lazy.nvim Gotchas

Behaviours that have already caused confusion here:

- **`enabled = false` deletes the plugin.** `:Lazy clean` treats a disabled
  plugin as orphaned and removes its directory. Turning an extra off and back on
  costs a full reinstall, not just a reload.
- **`lazy-lock.json` is the live lockfile.** Through the directory symlink, the
  committed copy is the one lazy.nvim reads and writes. A spec change that only
  adds one plugin can still produce a diff that bumps many others if `:Lazy
  sync` or the update checker ran in between.
- **`:Lazy sync` is install + clean + *update*.** To apply a spec change without
  bumping every other plugin, use `:Lazy install` and `:Lazy clean` separately.
  This config runs `version = false` with `checker.enabled = true`
  (`lua/config/lazy.lua`), so it is on rolling latest regardless.
- **Table `opts` replace lists; they do not append.** lazy.nvim merges `opts`
  tables with list values *replaced* wholesale. A plugin file here that sets
  `formatters_by_ft.typescript = { "x" }` silently discards anything an extra
  appended via its `opts` function. Extras that use `table.insert` to add a
  formatter lose to a plain table override in `lua/plugins/`.
- **"Not Loaded" in `:Lazy` is normal.** LazyVim defers nearly everything behind
  `event`/`cmd`/`ft`/`keys`. A `keys`-lazy plugin such as `mini.surround`
  registers stub mappings at startup and loads on first press, so its keybindings
  work while the plugin still reports as unloaded. Use `:Lazy profile` to judge
  startup cost, not the loaded flag.

<!-- entire-agent:begin -->
Read .entire/agent-guide.md for this repository's workflow, source inspection, and verification guidance.
@.entire/agent-guide.md
<!-- entire-agent:end -->
