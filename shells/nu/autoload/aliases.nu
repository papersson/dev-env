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