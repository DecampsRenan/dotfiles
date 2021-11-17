#!/bin/bash

echo "Checking if Xcode Command Line tools are installed...";
# Checks if path to command line tools exist
# Credit: https://apple.stackexchange.com/questions/219507/best-way-to-check-in-bash-if-command-line-tools-are-installed
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
  test -d "${xpath}" && test -x "${xpath}" ; then
  echo "Xcode Command Line tools are already installed..."; echo;
else
  echo "Installing Xcode Command Line Tools..."; echo;
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" --verbose;
fi

echo "Display full path and all files in Finder"
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
killall Finder

echo "Set a faster keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 6

echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 25

echo "Checking if Homebrew is already installed...";

# Checks if Homebrew is installed
# Credit: https://gist.github.com/codeinthehole/26b37efa67041e1307db
if test ! $(which brew); then
  echo "Installing Homebrew...";
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew tap homebrew/cask-drivers
  brew tap homebrew/cask-versions
  brew install wget
else
  echo "Homebrew is already installed...";
fi

echo "Install languages"
brew install ruby
curl -s "https://get.sdkman.io" | bash

echo "Install devtools"
brew install gradle
brew install --cask ngrok

echo "Install apps"
brew install --cask android-studio
brew install --cask visual-studio-code
brew install --cask docker
brew install --cask iterm2
brew install --cask google-chrome
brew install --cask firefox
brew install --cask fork
brew install --cask slack
brew install --cask insomnia
brew install --cask notion
brew install --cask 1password

if test ! -z $USE_CONFIG
then
  brew install --cask karabiner-elements
  brew install --cask spotify
  brew install --cask vlc
fi

echo "Homebrew cleanup"
brew cleanup -s
brew doctor

echo "XCode cocoapods"
sudo gem install cocoapods

if test ! -z $USE_CONFIG
then
  # symlink config files
  ln -sf "$DOTFILES_FOLDER/macos/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
  ln -sf "$DOTFILES_FOLDER/macos/vim" "$HOME/.vim"
fi
