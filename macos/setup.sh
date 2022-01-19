#!/bin/bash

set -e

echo "Asking you to log with sudo, so subsequent sudo calls can be automated"
sudo echo ""

echo "Checking if Xcode Command Line tools are installed...";
# Checks if path to command line tools exist
# Credit: https://apple.stackexchange.com/questions/219507/best-way-to-check-in-bash-if-command-line-tools-are-installed
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
  test -d "${xpath}" && test -x "${xpath}" ; then
  echo "Xcode Command Line tools are already installed, skipping";
else
  echo "Installing Xcode Command Line Tools...";
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" --verbose;
fi

echo ""
echo "Display full path and all files in Finder"
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
killall Finder

echo "Set a faster keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 6

echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 25

echo ""
echo "Checking if Homebrew is already installed...";

# Checks if Homebrew is installed
# Credit: https://gist.github.com/codeinthehole/26b37efa67041e1307db
if test ! $(which brew); then
  echo "Installing Homebrew...";
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
  brew tap homebrew/cask-drivers
  brew tap homebrew/cask-versions
  brew install wget
else
  echo "Homebrew is already installed, skipping";
fi

echo "Install ruby tooling (rbenv, cocoapods)"
brew install rbenv
mkdir -p "$HOME/.gem"
export GEM_HOME="$HOME/.gem"
gem install cocoapods

# Softwares needed to be installed from brew --cask
brewCasks=(
  "ngrok"
  "intellij-idea"
  "android-studio"
  "visual-studio-code"
  "docker"
  "iterm2"
  "google-chrome"
  "firefox"
  "fork"
  "slack"
  "insomnia"
  "notion"
  "1password"
  "karabiner-elements"
  "spotify"
  "vlc"
  "the-unarchiver"
  "imageoptim"
  "itsycal"
  "ntfstool"
  "raycast"
)

installedCasks=($(brew list -1 -q --casks))

echo ""
echo "Install softwares"

# JDK tools (java, groovy, etc...)
curl -s "https://get.sdkman.io" | bash
sed -i '' -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $HOME/.sdkman/etc/config
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 11.0.11.hs-adpt < /dev/null
sdk install gradle < /dev/null

# Node tools (n, npm node, yarn)
if ! command -v n &> /dev/null
then
  curl -L "https://git.io/n-install" | bash -s -- -y
fi
brew install yarn


for caskName in ${brewCasks[@]}; do
  if [[ " ${installedCasks[*]} " =~ " ${caskName} " ]]; then
    echo "${caskName} already installed, skipping"
  else
    echo "Installing ${caskName}..."
    brew install --cask ${caskName}
  fi
done

if test ! -z $USE_CONFIG
then
  brew install --cask karabiner-elements
  brew install --cask spotify
  brew install --cask vlc
fi

echo "Homebrew cleanup"
brew cleanup -s
brew doctor

if test ! -z $USE_CONFIG
then
  # symlink config files
  ln -sf "$DOTFILES_FOLDER/macos/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
fi
