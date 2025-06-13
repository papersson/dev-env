#!/bin/bash

# WSL Development Environment Bootstrap Script
# This script installs core development tools, Claude Code, and configures zsh with Powerlevel10k

set -eo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

print_section() {
    echo
    echo -e "${BLUE}=== $1 ===${NC}"
    echo
}

# Check if running in WSL
check_wsl() {
    if ! grep -qi microsoft /proc/version; then
        print_error "This script is designed for WSL. Please run it in a WSL environment."
        exit 1
    fi
    print_success "Running in WSL environment"
}

# Update system packages
update_system() {
    print_section "System Update"
    print_info "Updating package lists..."
    sudo apt-get update -qq
    print_info "Upgrading packages..."
    sudo apt-get upgrade -y -qq
    print_success "System updated"
}

# Install essential build tools
install_essentials() {
    print_section "Essential Tools"
    
    local essentials=(
        "build-essential"
        "curl"
        "wget"
        "git"
        "software-properties-common"
        "apt-transport-https"
        "ca-certificates"
        "gnupg"
        "lsb-release"
        "unzip"
        "zip"
        "tar"
        "gzip"
        "bzip2"
        "xz-utils"
        "file"
        "make"
        "gcc"
        "g++"
        "libssl-dev"
        "libffi-dev"
        "python3-dev"
        "python3-pip"
        "python3-venv"
    )
    
    print_info "Installing essential packages..."
    sudo apt-get install -y "${essentials[@]}" > /dev/null 2>&1
    print_success "Essential tools installed"
}

# Install modern CLI tools
install_cli_tools() {
    print_section "Modern CLI Tools"
    
    # Ripgrep (better grep)
    if ! command -v rg &> /dev/null; then
        print_info "Installing ripgrep..."
        curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
        sudo dpkg -i ripgrep_14.1.0-1_amd64.deb
        rm ripgrep_14.1.0-1_amd64.deb
        print_success "ripgrep installed"
    else
        print_success "ripgrep already installed"
    fi
    
    # fd (better find)
    if ! command -v fd &> /dev/null; then
        print_info "Installing fd..."
        curl -LO https://github.com/sharkdp/fd/releases/download/v9.0.0/fd_9.0.0_amd64.deb
        sudo dpkg -i fd_9.0.0_amd64.deb
        rm fd_9.0.0_amd64.deb
        print_success "fd installed"
    else
        print_success "fd already installed"
    fi
    
    # bat (better cat)
    if ! command -v bat &> /dev/null; then
        print_info "Installing bat..."
        curl -LO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb
        sudo dpkg -i bat_0.24.0_amd64.deb
        rm bat_0.24.0_amd64.deb
        print_success "bat installed"
    else
        print_success "bat already installed"
    fi
    
    # fzf (fuzzy finder)
    if ! command -v fzf &> /dev/null; then
        print_info "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-fish
        print_success "fzf installed"
    else
        print_success "fzf already installed"
    fi
    
    # Other tools via apt
    local cli_tools=(
        "jq"
        "htop"
        "btop"
        "tmux"
        "neovim"
        "tree"
        "ncdu"
        "tldr"
        "httpie"
    )
    
    print_info "Installing additional CLI tools..."
    sudo apt-get install -y "${cli_tools[@]}" > /dev/null 2>&1
    print_success "CLI tools installed"
}

# Install Node.js via nvm
install_nodejs() {
    print_section "Node.js Setup"
    
    # Install nvm
    if [ ! -d "$HOME/.nvm" ]; then
        print_info "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        
        # Load nvm
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        print_success "nvm installed"
    else
        print_success "nvm already installed"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    
    # Install latest LTS Node.js
    print_info "Installing Node.js LTS..."
    # Temporarily disable strict mode for nvm commands
    set +eo pipefail
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    set -eo pipefail
    print_success "Node.js LTS installed"
}

# Install Claude Code
install_claude_code() {
    print_section "Claude Code"
    
    # Ensure npm is available
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if ! command -v npm &> /dev/null; then
        print_error "npm not found. Please check Node.js installation."
        return 1
    fi
    
    # Install Claude Code
    if ! command -v claude-code &> /dev/null; then
        print_info "Installing Claude Code..."
        # Temporarily disable exit on error for npm install
        set +e
        npm install -g @anthropic-ai/claude-code
        if [ $? -eq 0 ]; then
            print_success "Claude Code installed"
        else
            print_error "Failed to install Claude Code - you may need to install it manually later"
        fi
        set -e
    else
        print_success "Claude Code already installed"
    fi
}

# Install zsh and Oh My Zsh
install_zsh() {
    print_section "Zsh Setup"
    
    # Install zsh
    if ! command -v zsh &> /dev/null; then
        print_info "Installing zsh..."
        sudo apt-get install -y zsh > /dev/null 2>&1
        print_success "zsh installed"
    else
        print_success "zsh already installed"
    fi
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed"
    else
        print_success "Oh My Zsh already installed"
    fi
}

# Install Powerlevel10k theme
install_powerlevel10k() {
    print_section "Powerlevel10k Theme"
    
    # Install required fonts
    print_info "Installing Nerd Fonts (MesloLGS)..."
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    
    # Download MesloLGS NF fonts
    local fonts=(
        "MesloLGS%20NF%20Regular.ttf"
        "MesloLGS%20NF%20Bold.ttf"
        "MesloLGS%20NF%20Italic.ttf"
        "MesloLGS%20NF%20Bold%20Italic.ttf"
    )
    
    for font in "${fonts[@]}"; do
        if [ ! -f "${font//%20/ }" ]; then
            wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/${font}"
        fi
    done
    
    # Update font cache
    fc-cache -f ~/.local/share/fonts
    cd - > /dev/null
    print_success "Nerd Fonts installed"
    
    # Clone Powerlevel10k
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        print_info "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        print_success "Powerlevel10k installed"
    else
        print_success "Powerlevel10k already installed"
    fi
}

# Configure zsh with plugins and theme
configure_zsh() {
    print_section "Zsh Configuration"
    
    # Install zsh plugins
    print_info "Installing zsh plugins..."
    
    # zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    # zsh-completions
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
    fi
    
    print_success "Zsh plugins installed"
    
    # Backup existing .zshrc
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
        print_info "Backed up existing .zshrc"
    fi
    
    # Create new .zshrc with Powerlevel10k
    cat > ~/.zshrc << 'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    docker
    docker-compose
    npm
    node
    python
    pip
    tmux
    fzf
    sudo
    command-not-found
    colored-man-pages
    extract
)

# Load completions
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# User configuration

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Modern CLI aliases
alias cat="bat"
alias find="fd"
alias ps="procs"
alias du="dust"
alias df="duf"
alias top="btop"

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# WSL specific
export BROWSER="wslview"

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
    
    print_success "Zsh configured"
}

# Install Docker
install_docker() {
    print_section "Docker Setup"
    
    if ! command -v docker &> /dev/null; then
        print_info "Installing Docker..."
        
        # Add Docker's official GPG key
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        
        # Add repository
        echo \
          "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Install Docker
        sudo apt-get update -qq
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
        
        # Add user to docker group
        sudo usermod -aG docker $USER
        
        print_success "Docker installed (logout/login required for group changes)"
    else
        print_success "Docker already installed"
    fi
}

# Install additional development tools
install_dev_tools() {
    print_section "Development Tools"
    
    # Python tools
    print_info "Installing Python development tools..."
    pip3 install --user pipx
    ~/.local/bin/pipx ensurepath
    ~/.local/bin/pipx install poetry
    ~/.local/bin/pipx install black
    ~/.local/bin/pipx install flake8
    ~/.local/bin/pipx install mypy
    print_success "Python tools installed"
    
    # Install VS Code (if not already installed)
    if ! command -v code &> /dev/null; then
        print_info "Installing Visual Studio Code..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt-get update -qq
        sudo apt-get install -y code > /dev/null 2>&1
        print_success "VS Code installed"
    else
        print_success "VS Code already installed"
    fi
}

# WSL specific optimizations
configure_wsl() {
    print_section "WSL Optimizations"
    
    # Create WSL config if it doesn't exist
    if [ ! -f /etc/wsl.conf ]; then
        print_info "Creating WSL configuration..."
        sudo tee /etc/wsl.conf > /dev/null << 'EOF'
[boot]
systemd=true

[automount]
enabled=true
options="metadata,umask=22,fmask=11"
mountFsTab=false

[network]
generateResolvConf=true

[interop]
enabled=true
appendWindowsPath=true
EOF
        print_success "WSL configured"
    else
        print_success "WSL already configured"
    fi
}

# Main installation flow
main() {
    echo "🚀 WSL Development Environment Bootstrap"
    echo "========================================"
    echo
    
    check_wsl
    update_system
    install_essentials
    install_cli_tools
    install_nodejs
    install_claude_code
    install_zsh
    install_powerlevel10k
    configure_zsh
    install_docker
    install_dev_tools
    configure_wsl
    
    # Set zsh as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_info "Setting zsh as default shell..."
        sudo chsh -s $(which zsh) $USER
    fi
    
    echo
    echo "========================================"
    print_success "Bootstrap complete!"
    echo
    print_info "Important next steps:"
    echo "  1. Install the MesloLGS NF font in Windows Terminal:"
    echo "     - Open Windows Terminal Settings (Ctrl+,)"
    echo "     - Go to Profiles > Ubuntu > Appearance"
    echo "     - Change font to 'MesloLGS NF'"
    echo
    echo "  2. Restart WSL or run: exec zsh"
    echo
    echo "  3. Configure Powerlevel10k by running: p10k configure"
    echo
    echo "  4. Configure git:"
    echo "     git config --global user.name 'Your Name'"
    echo "     git config --global user.email 'your@email.com'"
    echo
    echo "  5. Test Claude Code: claude-code --help"
    echo
    print_info "For Docker to work without sudo, logout and login again."
    echo
}

# Run main function
main