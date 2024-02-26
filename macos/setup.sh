#!/bin/bash

# Force script to quit if any command returns a non zero code.
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
sudo -v

# Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
echo "Checking if Homebrew is already installed...";

# Checks if Homebrew is installed
# Credit: https://gist.github.com/codeinthehole/26b37efa67041e1307db
if test ! $(which brew); then
  echo "Installing Homebrew...";
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Homebrew installed, try to upgrade...";
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts
brew update
brew analytics off

echo ""
echo "Softwares"

# JDK tools (java, groovy, etc...)
# echo "Installing jdk tooling (sdkman, java, gradle)"
# if ! command -v sdk &> /dev/null
# then
#   curl -s "https://get.sdkman.io" | bash
#   sed -i '' -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $HOME/.sdkman/etc/config
#   source "$HOME/.sdkman/bin/sdkman-init.sh"
#   sdk install java 11.0.14.1-jbr < /dev/null
#   sdk install gradle < /dev/null
# else
#   echo "Already installed, skipping"
# fi
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
  "ffmpeg"    # media encoder (https://ffmpeg.org/)
  "scrcpy"    # allow to display you android screen on your computer, usefull when doing demo (https://github.com/Genymobile/scrcpy)
  "htop"      # processus viewer
  "eza"       # nicer alternative to ls (https://github.com/ogham/exa)
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
  "iterm2"                 # Replacement for the default Terminal.app
  "google-chrome"          # My main browser
  "firefox"                # Alternative browser, usefull for testing browsers compatibility
  "slack"                  # Main communication tool
  "discord"                #
  "insomnia"               #
  "rectangle"              # Tool used to make window management easier
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
  "shottr"                 # Replacement of the default screen capture tool for macos
)
installWithBrew brewCasks[@] installedBrewPackages[@] true

echo "Homebrew cleanup"
brew cleanup -s
brew doctor

echo ""
echo "#############################"
echo "# Setting global mac configs"
echo "# Heavily inspired from https://github.com/stefanjudis/dotfiles/blob/primary/scripts/mac.sh"
echo "#############################"
echo ""

echo "Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "

echo 'Disable Personalized advertisements and identifier collection'
defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
defaults write com.apple.AdLib forceLimitAdTracking -bool true

echo "Keep spaces arrangement - do not reorder spaces based on usage"
defaults write com.apple.dock "mru-spaces" -bool "false"

echo "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "show hidden files by default"
defaults write com.apple.Finder AppleShowAllFiles -bool true

echo "only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo "show the ~/Library folder in Finder"
chflags nohidden ~/Library

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Use current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Show Path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool true

echo "Show Status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1

echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "Repeats the key as long as it is held down"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "disabling smart quotes and dashes..."
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "Set date display in menu bar"
defaults write com.apple.menuextra.clock "DateFormat" "EEE MMM d  H.mm"

echo "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Stop iTunes from responding to the keyboard media keys"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

echo "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo 'Disable Internet based spell correction'
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

echo "Remove delay when taking a screenshot"
defaults write com.apple.screencapture show-thumbnail -bool false

echo 'Disable "Ask Siri"'
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false

echo 'Disable Siri voice feedback'
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3

echo 'Disable Siri services (Siri and assistantd)'
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
sudo launchctl disable 'system/com.apple.assistantd'
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"
sudo launchctl disable 'system/com.apple.Siri.agent'
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
    >&2 echo 'This script requires SIP to be disabled. Read more: https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi

echo 'Disable "Do you want to enable Siri?" pop-up'
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True

echo 'Hide Siri from menu bar'
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0

echo 'Hide Siri from status menu'
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true

echo 'Opt-out from Siri data collection'
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

echo "Store screenshots in /tmp"
defaults write com.apple.screencapture location /tmp

echo "Hide 'recent applications' from dock"
defaults write com.apple.dock show-recents -bool false

echo "Set smaller dock icon size"
defaults write com.apple.dock tilesize -int 34

echo "Position the dock to the left"
defaults write com.apple.dock orientation -string left

echo "Show bluetooth and other in the menubar"
defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/Displays.menu" "/System/Library/CoreServices/Menu Extras/Volume.menu"

echo "Disable CMD+space for spotlight (because I prefer to use it for Raycast)"
/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c "Set AppleSymbolicHotKeys:64:enabled false"

echo "Always show scrollbars"
defaults write -g AppleShowScrollBars -string "Always"

echo "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo 'Disable Microsoft Office diagnostics data sending'
defaults write com.microsoft.office DiagnosticDataTypePreference -string ZeroDiagnosticData

echo 'Disable Homebrew user behavior analytics'
command='export HOMEBREW_NO_ANALYTICS=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"
do
    touch "$profile_file"
    if ! grep -q "$command" "${profile_file}"; then
        echo "$command" >> "$profile_file"
        echo "[$profile_file] Configured"
    else
        echo "[$profile_file] No need for any action, already configured"
    fi
done

echo 'Disable Firefox telemetry'
# Enable Firefox policies so the telemetry can be configured.
sudo defaults write /Library/Preferences/org.mozilla.firefox EnterprisePoliciesEnabled -bool TRUE
# Disable sending usage data
sudo defaults write /Library/Preferences/org.mozilla.firefox DisableTelemetry -bool TRUE

echo 'Disable remote login (incoming SSH and SFTP connections)'
echo 'yes' | sudo systemsetup -setremotelogin off

echo 'Disable insecure TFTP service'
sudo launchctl disable 'system/com.apple.tftpd'

echo 'Disable insecure telnet protocol'
sudo launchctl disable system/com.apple.telnetd

echo 'Disables signing in as Guest from the login screen'
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

echo 'Disables Guest access to file shares over AF'
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

echo 'Disables Guest access to file shares over SMB'
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

echo "***"
echo "* iTerm2 Config"
echo "***"
echo "Don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# echo "Set red accent and highlight color"
# # more info https://github.com/yuhonas/osx-colors/blob/main/src/color_utils.py
# defaults write -g AppleAccentColor -string 0
# defaults write -g AppleHighlightColor -string "1.000000 0.733333 0.721569 Red"


echo "Update Apple developer utils"
softwareupdate --all --install --force

killall SystemUIServer
killall "Dock"
