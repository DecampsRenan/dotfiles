#!/usr/bin/env bash
# Run by `mise bootstrap` after the packages and settings from mise.toml.
# It runs on every bootstrap: each command must be safe to repeat.
set -euo pipefail

echo "Global tools"
mise use -g node@lts

echo "Asking for sudo once for the following steps"
sudo -v

echo "Disable the boot sound"
sudo nvram SystemAudioVolume=" "

echo "Show ~/Library in Finder"
chflags nohidden ~/Library

echo "Stop Music from responding to the keyboard media keys"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2>/dev/null || true

echo "Disable Siri services"
uid="$(id -u)"
launchctl disable "user/$uid/com.apple.assistantd"
launchctl disable "gui/$uid/com.apple.assistantd"
sudo launchctl disable system/com.apple.assistantd
launchctl disable "user/$uid/com.apple.Siri.agent"
launchctl disable "gui/$uid/com.apple.Siri.agent"
sudo launchctl disable system/com.apple.Siri.agent
if [ "$(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//')" = "enabled" ]; then
  echo >&2 "SIP is enabled: disabling Siri services will not take effect."
  echo >&2 "See https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection"
fi

echo "Disable remote login (incoming SSH and SFTP)"
echo yes | sudo systemsetup -setremotelogin off ||
  echo >&2 "Could not disable remote login: give your terminal Full Disk Access, then run again."

echo "Disable TFTP and telnet"
sudo launchctl disable system/com.apple.tftpd
sudo launchctl disable system/com.apple.telnetd

echo "Disable the guest account and guest access to file shares"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false

echo "Install Apple software updates"
softwareupdate --all --install --force
