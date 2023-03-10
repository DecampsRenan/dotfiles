#!/bin/bash

set -e

clear
echo "  __  __               _____      _               "
echo " |  \/  |             / ____|    | |              "
echo " | \  / | __ _  ___  | (___   ___| |_ _   _ _ __  "
echo " | |\/| |/ _\` |/ __|  \___ \ / _ \ __| | | | '_ \ "
echo " | |  | | (_| | (__   ____) |  __/ |_| |_| | |_) |"
echo " |_|  |_|\__,_|\___| |_____/ \___|\__|\__,_| .__/ "
echo "                                           | |    "
echo "                                           |_|    "
echo "                                                  "
echo "                                                  "

CURRENT_SHELL="$(basename "$SHELL")"

function installWithBrew() {
  local packageList=("${!1}")
  local installedPackages=("${!2}")
  local isCask="${3:-false}"

  for caskName in ${packageList[@]}; do
    if [[ " ${installedPackages[*]} " =~ " ${caskName} " ]]; then
      echo "${caskName} already installed, skipping"
    else
      echo "Installing ${caskName}..."
      if [[ "$isCask" = true ]]; then
        brew install --cask ${caskName}
      else
        brew install ${caskName}
      fi
    fi
  done
}

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
else
  echo "Homebrew is already installed, try to upgrade...";
  brew tap homebrew/cask-drivers
  brew tap homebrew/cask-versions
  brew tap homebrew/cask-fonts
  brew update
fi

echo ""
echo "Softwares"

# JDK tools (java, groovy, etc...)
echo "Installing jdk tooling (sdkman, java, gradle)"
if ! command -v sdk &> /dev/null
then
  curl -s "https://get.sdkman.io" | bash
  sed -i '' -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $HOME/.sdkman/etc/config
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install java 11.0.11.hs-adpt < /dev/null
  sdk install gradle < /dev/null
else
  echo "Already installed, skipping"
fi
installedBrewPackages=($(brew list -1 -q --full-name))

brewFonts=(
  "font-inconsolata"
  "font-fira-code"
)
installWithBrew brewFonts[@] installedBrewPackages[@]

brewCmds=(
  "wget"      # alternative to curl, always nice to have
  "rbenv"     # allow you to manage ruby environments
  "yarn"      # alternative to npm
  "watchman"  # usefull file watcher
  "ffmpeg"    # media encoder
  "scrcpy"    # allow to display you android screen on your computer, usefull when doing demo
  "htop"      # processus viewer
)
installWithBrew brewCmds[@] installedBrewPackages[@]

echo "Install nodejs tooling (fnm, node, npm)"
if ! command -v fnm &> /dev/null
then
  curl -fsSL https://fnm.vercel.app/install | bash
  fnm install --lts
else
  echo "Already installed, skipping"
fi

echo "Install ruby tooling (rbenv, cocoapods)"
if ! command -v pod &> /dev/null
then
  mkdir -p "$HOME/.gem"
  export GEM_HOME="$HOME/.gem"
  gem install cocoapods
else
  echo "Already installed, skipping"
fi

# Softwares needed to be installed from brew --cask
brewCasks=(
  "ngrok"                  # App that allow to make localhost available for everyone
  "android-platform-tools" # Needed if you need to make android apps (also usefull to manage sdk and emulators)
  "visual-studio-code"     # Code editor, the one I always use
  "docker"                 #
  "alacritty"              # Replacement for the default Terminal.app
  "google-chrome"          # My main browser
  "firefox"                #
  "slack"                  #
  "discord"                #
  "insomnia"               #
  "hyperkey"               # Tool I use to set the capslock key to be "cmd+ctrl+option+shift" (usefull for global shortcuts)
  "notion"                 # App to document everything you want
  "1password"              # Password manager
  "karabiner-elements"     # Usefull when you need to replace or add macro on keyboard keys (I use it to replace the capslock key with a macro)
  "spotify"                # To play music :D
  "vlc"                    # Media player with a wide format support
  "the-unarchiver"         # App that can extract a lot of archive format (zip, rar, gzip, etc...s)
  "imageoptim"             # Usefull if you need to optimize images
  "itsycal"                # Small calendar app you can use to replace the default one (come with some nice additional features)
  "ntfstool"               # In order to be able to use ntfs filesystems (if you are working with windows)
  "raycast"                # Replacement of the default cmd-space app launcher
)
installWithBrew brewCasks[@] installedBrewPackages[@] true

echo "Homebrew cleanup"
brew cleanup -s
brew doctor
