# shells/nu/env.nu

# Tell Nushell which editor to use
$env.EDITOR = "code"                                   # VS Code as default editor

# Starship prompt integration
$env.STARSHIP_SHELL = "nu"                             # needed for correct prompt
def nu_repl_prompt [] { starship prompt }              # invoke starship each prompt
$config.prompt = nu_repl_prompt                        # set as Nushell prompt

# Extend PATH for user-local binaries
$env.PATH += [ $env.HOME + "/.cargo/bin" ]             # e.g., Rust tooling

# Optional: set pager
$env.PAGER = "less --RAW-CONTROL-CHARS"                # for long outputs