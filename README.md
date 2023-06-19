# Personal dotfiles 

**⚠️ MAKE SURE TO CHECK WHICH TOOLS WILL BE INSTALLED FIRST ⚠️**

## Setup (MacOS)

### To check first

A default setup for zsh using prezto can be found here: https://github.com/DecampsRenan/prezto-config

If you are ok with the provided tools, you can install them by running one of the following commands:

### Bash / ZSH

With curl

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/DecampsRenan/dotfiles/master/macos/setup.sh)"
```

With wget

```bash
sh -c "$(wget https://raw.githubusercontent.com/DecampsRenan/dotfiles/master/macos/setup.sh -O -)"
```

## Installed softwares

### Tools

- For gui apps, checks the `brewCasks` array in the `macos/setup.sh` file
- For command line apps, checks the `brewCmds` array in the `macos/setup.sh` file
- For fonts, checks the `brewFonts` array in the `macos/setup.sh` file

### Config

- Display full path and all files in Finder
- Set a faster keyboard repeat rate
- Set a shorter delay until key repeat
- update gem install directory to be `$HOME/.gem` (so no need to sudo in order to install packages)
- ec...
