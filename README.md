# Personal dotfiles

**⚠️ MAKE SURE TO CHECK WHICH TOOLS WILL BE INSTALLED FIRST ⚠️**

## Setup (macOS)

The whole setup is declared in [`mise.toml`](mise.toml) and applied by
[`mise bootstrap`](https://mise.jdx.dev/bootstrap.html). Homebrew is not needed:
mise installs formulae and casks itself.

Install mise, then bootstrap from this repository:

```bash
curl https://mise.run | sh
~/.local/bin/mise bootstrap --from https://github.com/DecampsRenan/dotfiles.git --dry-run
~/.local/bin/mise bootstrap --from https://github.com/DecampsRenan/dotfiles.git
```

To apply new commits later:

```bash
mise bootstrap --from https://github.com/DecampsRenan/dotfiles.git --update
```

## What it sets up

- Apps, fonts and command line tools: `[bootstrap.packages]` in `mise.toml`
- Global runtimes (Java, Gradle, Ruby, CocoaPods, Node.js): `macos/bootstrap.sh`
- fish as login shell, with mise activated in it
- macOS preferences (Dock, Finder, keyboard, trackpad, privacy, Siri…):
  `[bootstrap.settings.macos]` in `mise.toml`
- System settings that need `sudo` (guest account, remote login, telemetry…):
  `macos/bootstrap.sh`, run as the `bootstrap` task
