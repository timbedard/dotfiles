#!/bin/bash

# Things this script does not install:
# - Magnet

# Command Line Tools
xcode-select --install

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
    awscli
    bat  # cat replacement
    # ctags
    diff-so-fancy  # fancy git diff
    direnv
    docker-completions
    docker-compose-completions
    exa  # ls replacement
    fasd  # fast dir nav
    fd  # find replacement
    fish  # shell
    fzf  # fuzzy
    git
    hub  # GitHub tools
    lazydocker  # docker term UI
    neovim
    python@2
    python3
    reattach-to-user-namespace  # fix tmux mac issues
    ripgrep  # awesome grep
    ruby
    shellcheck  # sh linter
    tmux
    zsh
    zsh-completions
)
brew install "${PACKAGES[@]}"

echo "Installing universal-ctags..."
brew install --HEAD universal-ctags/universal-ctags/universal-ctags

echo "Cleaning up..."
brew cleanup

echo "Installing Cask..."
brew tap homebrew/cask
brew tap homebrew/cask-versions

echo "Installing Cask apps..."
CASKS=(
    alfred
    docker
    firefox-developer-edition
    insomnia
    kitty
    tableplus
    virtualbox
)
brew cask install "${CASKS[@]}"

echo "Installing fonts..."
brew tap homebrew/cask-fonts
FONTS=(
    font-hack-nerd-font
    font-hack-nerd-font-mono
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

echo "Configuring git to use diff-so-fancy..."
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

echo "Installing poetry (and completions)..."
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python3
# temporary until 1.0.0 is released.
"$HOME/.poetry/bin/poetry" self:update --preview

# Bash (macOS/Homebrew)
"$HOME/.poetry/bin/poetry" completions bash > $(brew --prefix)/etc/bash_completion.d/poetry.bash-completion

# Fish
"$HOME/.poetry/bin/poetry" completions fish > ~/.config/fish/completions/poetry.fish

# Oh-My-Zsh
mkdir $ZSH/plugins/poetry
"$HOME/.poetry/bin/poetry" completions zsh > $ZSH/plugins/poetry/_poetry

echo "Installing tpm (Tmux Plugin Manager)..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# echo "Installing base16 theme shell script..."
# git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

echo "Installation complete."
