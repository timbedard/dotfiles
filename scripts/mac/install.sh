#!/bin/bash

# Note: This script requires that the following be done before running:
# 1. Install Xcode.
# 2. Install Command Line Tools.
# 3. Accept the CLT agreement.

# Things this script does not install:
# - Magnet

# Homebrew
if test ! "$(which brew)"; then
    echo "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update recipes
echo "Updating Homebrew..."
brew update

echo "Installing packages..."
PACKAGES=(
    autoconf
    awscli
    ctags
    direnv
    exa
    fasd
    fzf
    git
    hub
    lua
    neovim
    python@2
    python3
    ranger
    ripgrep
    ruby
    shellcheck
    the_silver_searcher
    tree
    zsh
    zsh-completions
)
brew install "${PACKAGES[@]}"

echo "Cleaning up..."
brew cleanup

echo "Installing Cask..."
brew tap caskroom/cask
brew tap caskroom/versions

echo "Installing Cask apps..."
CASKS=(
    alfred
    firefox-developer-edition
    insomnia
    iterm2
    sequel-pro
    slack
    virtualbox
)
brew cask install "${CASKS[@]}"

echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-sourcecodepro-nerd-font
)
brew cask install "${FONTS[@]}"

echo "Installing Oh My Zsh..."
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

echo "Installing zsh-users/zsh-completions..."
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# echo "Installing zsh-nvm..."
# git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

echo "Installing fzf shell extensions..."
/usr/local/opt/fzf/install

echo "Installion complete."
