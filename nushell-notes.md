Below is a recommended structure for your `shells/nu` directory and a **popular, best-practice** Nushell configuration you can adapt. It’ll give you:

* **Modular startup files** (`env.nu`, `config.nu`, `login.nu`) for clarity and faster reloads ([nushell.sh][1])
* An **`autoload/`** folder to break out aliases, prompts, and custom commands ([nushell.sh][2])
* **Starship integration** via `env.nu` so your prompt is consistent ([nushell.sh][3])
* A sample **`aliases.nu`** and **`prompt.nu`** drawn from community configs

---

## 1. Directory layout

```
shells/
└─ nu/
   ├─ env.nu           # minimal, environment-only settings
   ├─ config.nu        # core settings, imports, custom commands
   ├─ login.nu         # login-only tasks (e.g. notifications)
   └─ autoload/        # optional: modules loaded after config.nu
      ├─ aliases.nu    # your most-used aliases
      ├─ prompt.nu     # custom prompt definitions
      └─ ….nu          # other modular snippets
```

* **`env.nu`** runs *first* and should only set environment variables (editor, PATH tweaks, Starship) ([nushell.sh][1])
* **`config.nu`** is your main file: overrides defaults, loads `autoload/*.nu`, defines custom commands ([nushell.sh][1])
* **`login.nu`** runs only for login shells (e.g. `atui notifications`, session checks) ([nushell.sh][1])
* Files in **`autoload/`** are loaded automatically after `config.nu` to keep things tidy ([nushell.sh][1])

---

## 2. `env.nu` (environment setup)

```nu
# shells/nu/env.nu

# Tell Nushell which editor to use
$env.EDITOR = "code"                                   # VS Code as default editor :contentReference[oaicite:8]{index=8}

# Starship prompt integration
$env.STARSHIP_SHELL = "nu"                             # needed for correct prompt :contentReference[oaicite:9]{index=9}
def nu_repl_prompt [] { starship prompt }              # invoke starship each prompt
$config.prompt = nu_repl_prompt                        # set as Nushell prompt :contentReference[oaicite:10]{index=10}

# Extend PATH for user-local binaries
$env.PATH += [ $env.HOME + "/.cargo/bin" ]             # e.g., Rust tooling :contentReference[oaicite:11]{index=11}

# Optional: set pager
$env.PAGER = "less --RAW-CONTROL-CHARS"                # for long outputs
```

---

## 3. `config.nu` (core configuration)

```nu
# shells/nu/config.nu

# 1. Load core settings (color/theme)
config set nu_config.theme "gruvbox"                    # if using a theme plugin 

# 2. Import modular snippets
source-env ./autoload/aliases.nu                        # custom aliases
source-env ./autoload/prompt.nu                         # additional prompt tweaks

# 3. Define quick custom commands
def cfind [pattern] { ls | where name =~ $pattern }    # simple fuzzy find

# 4. Enable plugins via 'use'
# (requires plugin manager or manual installation)
# e.g. use path-to-plugin.nu

# 5. Pretty-print tables
config set table-mode "infinite"                        # table scrolling style
config set table-grid true                              # grid borders
```

---

## 4. `autoload/aliases.nu` (popular examples)

```nu
# shells/nu/autoload/aliases.nu

# Common Git shortcuts
alias gco = git checkout
alias gst = git status
alias ga  = git add
alias gc  = git commit

# Directory navigation
alias .. = cd ..
alias ... = cd ../..

# Quick HTTP server
alias serve = { python3 -m http.server }
```

> These patterns follow conventions from the [awesome-nu](https://github.com/nushell/awesome-nu) list ([github.com][4])

---

## 5. `autoload/prompt.nu` (extended prompt logic)

```nu
# shells/nu/autoload/prompt.nu

# Show Git branch in prompt
def git_branch_prompt [] {
  if (git rev-parse --abbrev-ref HEAD | get stdout).strip != "" {
    echo -n " (" + (git rev-parse --abbrev-ref HEAD | get stdout).strip + ")"
  }
}

# Combine Starship + branch info
def custom_prompt [] {
  starship prompt | echo -n ($it + (git_branch_prompt))
}
$config.prompt = custom_prompt
```

> Inspired by community examples on GitHub and Reddit ([reddit.com][5])

---

## 6. `login.nu` (login-only tasks)

```nu
# shells/nu/login.nu

# Show a welcome message once per day
if ($env.CMD_DURATION_MS | into int) == 0 {
  echo "👋 Welcome back, $env.USER — today is $(date now)" 
}

# Check for updates
def check_updates [] { nu plugin list | where status != "Up to date" }
if (check_updates | count) > 0 {
  echo "⚠️  Some plugins need updating! Run 'nu plugin update'"
}
```

---

## 7. Notes on paths & loading order

1. **Order of execution** (Nushell Book):

   1. `env.nu` ([nushell.sh][1])
   2. `config.nu` ([nushell.sh][1])
   3. `*.nu` in `$nu.vendor-autoload-dirs` (for packaged modules) ([nushell.sh][1])
   4. `*.nu` in `$nu.user-autoload-dirs` (`autoload/` here) ([nushell.sh][1])
   5. `login.nu` for login shells ([nushell.sh][1])

2. **Use `source-env`** to import files *without* polluting your global namespace ([nushell.sh][2])

3. **Keep modular**: split large configs across `autoload/` to speed up startup and simplify edits ([nushell.sh][2])

---

### Getting started

1. Copy this structure into `~/dev-env/shells/nu/`.
2. Run `home-manager switch --flake ~/dev-env#patrik` to link your dotfiles.
3. Open a new Ghostty/tmux pane: you’ll land in **Nushell** with your full custom setup.

With this in place, every time you enter your `dev-env` or log in, Nushell will be configured exactly the same way—no more manual edits!

[1]: https://www.nushell.sh/book/configuration.html?utm_source=chatgpt.com "Configuration - Nushell"
[2]: https://www.nushell.sh/book/custom_commands.html?utm_source=chatgpt.com "Custom Commands - Nushell"
[3]: https://www.nushell.sh/book/3rdpartyprompts.html?utm_source=chatgpt.com "How to Configure 3rd Party Prompts - Nushell"
[4]: https://github.com/nushell/awesome-nu?utm_source=chatgpt.com "nushell/awesome-nu - GitHub"
[5]: https://www.reddit.com/r/Nushell/comments/1d7vsls/is_there_a_better_way_to_migrate_config_from_zsh/?utm_source=chatgpt.com "Is there a better way to migrate config from zsh to nu? : r/Nushell"
