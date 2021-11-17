# Renan Decamps's dotfiles 

Simple as running the following 😀 :

```bash
# Install softs without config
./install -s

# Only link config files
./install -c
```

If you only want to install softwares without copying the config files (in order to use yours), you can simply
copy/paset the following lines in a terminal:

```bash
# With curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/DecampsRenan/dotfiles/master/macos/setup.sh)"

# With zsh
sh -c "$(wget https://raw.githubusercontent.com/DecampsRenan/dotfiles/master/macos/setup.sh -O -)"
```
