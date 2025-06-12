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