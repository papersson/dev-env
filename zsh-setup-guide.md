# Zsh with Powerlevel10k Setup Guide

## Quick Start

1. **Run the bootstrap script:**
   ```bash
   chmod +x wsl-bootstrap.sh
   ./wsl-bootstrap.sh
   ```

2. **Configure Windows Terminal for the fonts:**
   - Open Windows Terminal
   - Press `Ctrl+,` to open settings
   - Navigate to: Profiles → Ubuntu → Appearance
   - Change the font to: **MesloLGS NF**
   - Save settings

3. **Restart your terminal or run:**
   ```bash
   exec zsh
   ```

4. **Configure Powerlevel10k:**
   ```bash
   p10k configure
   ```

## Powerlevel10k Configuration Wizard

When you run `p10k configure`, you'll go through an interactive setup:

### Recommended Choices:

1. **Diamond, Lock, Debian Icons** - If they look good, select Yes
2. **Prompt Style** - Choose "Rainbow" or "Classic" (Rainbow is colorful)
3. **Character Set** - Unicode
4. **Prompt Flow** - One line (cleaner) or Two lines (more info)
5. **Prompt Spacing** - Compact
6. **Icons** - Many icons (looks great with Nerd Fonts)
7. **Prompt Flow** - Concise
8. **Transient Prompt** - Yes (cleaner history)
9. **Instant Prompt** - Yes (faster startup)

## Key Features Included

### 1. **Plugins Installed:**
- `zsh-autosuggestions` - Shows command suggestions as you type
- `zsh-syntax-highlighting` - Highlights commands with colors
- `zsh-completions` - Better tab completions
- Various utility plugins (git, docker, npm, etc.)

### 2. **Keyboard Shortcuts:**
- `Ctrl+R` - Search command history with fzf
- `Ctrl+T` - Find files with fzf
- `Alt+C` - Change directory with fzf
- `Tab` - Autocomplete
- `→` - Accept autosuggestion

### 3. **Useful Aliases:**
```bash
# Navigation
ll      # Detailed list
..      # Go up one directory
...     # Go up two directories

# Modern replacements
cat     # Uses bat (syntax highlighting)
find    # Uses fd (faster, better)
top     # Uses btop (better interface)

# Git shortcuts
gs      # git status
ga      # git add
gc      # git commit
gp      # git push
glog    # Pretty git log
```

## Customization

### Change Theme Elements

Edit `~/.p10k.zsh` to customize:
- Which segments appear (git, time, etc.)
- Colors and icons
- Prompt layout

### Add Custom Aliases

Edit `~/.zshrc` and add after the existing aliases:
```bash
# Your custom aliases
alias myproject="cd ~/projects/myproject"
alias dc="docker-compose"
```

### Change Plugins

Edit `~/.zshrc` and modify the plugins array:
```bash
plugins=(
    git
    zsh-autosuggestions
    # Add more plugins here
)
```

## Troubleshooting

### Fonts Not Displaying Correctly

1. Make sure you're using Windows Terminal (not WSL terminal)
2. Verify MesloLGS NF font is selected in Terminal settings
3. Try different font sizes (10-12pt usually works best)

### Slow Startup

Run this to optimize:
```bash
# Compile zsh files
zcompile ~/.zshrc
zcompile ~/.p10k.zsh
```

### Reset Configuration

To reconfigure from scratch:
```bash
p10k configure
```

## Tips

1. **Use `z` command** - Jump to frequently used directories:
   ```bash
   z proj  # Jumps to ~/projects if you've been there before
   ```

2. **Command history** - Use `!!` for last command, `!$` for last argument

3. **Globbing** - Powerful pattern matching:
   ```bash
   ls **/*.js  # Find all JS files recursively
   ```

4. **Auto-cd** - Just type directory name without `cd`:
   ```bash
   ~/projects  # Same as cd ~/projects
   ```

Enjoy your new powerful shell setup!