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