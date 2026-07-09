#!/usr/bin/env bash

# Exit immediately if a command fails, except during the package installation check
set -e

echo "Installing essential packages..."

PACKAGES=(git zsh bat xxd btop 7zip neovim)

# Disable 'set -e' temporarily to handle the dnf error manually
set +e
sudo dnf install -y "${PACKAGES[@]}"
DNF_STATUS=$?
set -e

if [ $DNF_STATUS -ne 0 ]; then
    echo "An error occurred during package installation."
    
    read -p "Wanna continue? [y/n]: " -n 1 ans
    echo "" # Add a newline after read
    
    case "${ans,,}" in
        y)
            if ! command -v zsh &> /dev/null; then
                echo "Error: zsh is not installed. Exiting..."
                exit 1
            fi
            ;;
        *)
            echo "Exiting..."
            exit 1
            ;;
    esac
fi

# Define custom directory for Oh My Zsh components
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install Oh My Zsh non-interactively
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    OMZ_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
    sh -c "$(curl -fsSL $OMZ_URL)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Cloning Powerlevel10k theme..."
    git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "Powerlevel10k is already installed."
fi

# Install external Zsh plugins
echo "Installing Zsh plugins..."

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Change default shell to zsh safely
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

echo "-----------------"
echo "Done. Please restart your terminal or run 'zsh'."
