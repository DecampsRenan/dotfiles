# Renan Decamps's dotfiles

Simple as running the following 😀 :

```bash
git clone git@github.com:DecampsRenan/dotfiles.git --depth=1
cd dotfiles && KEYS_REPO="https://github.com/<your-id>/<your-private-repo>.git" ./install.sh

# Install softs without config
./install -s

# Only link config files
./install -c
```

Please note the `https://` url in the KEYS_REPO; this repo **should** be a private
repo that contains .ssh folder; you will be asked to fill your repo login and password
**on your machine**.
