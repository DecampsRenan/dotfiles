-- defines the global trigger for all actions
hyper = {
  "cmd",
  "alt",
  "ctrl",
  "shift"
}

hs.hotkey.bind(hyper, "à", function() hs.reload() end)

-- Lock computer
hs.hotkey.bind(hyper, "up", function() hs.spotify.playpause() end)

require "./config/windows"
require "./config/apps"
require "./config/caffeine"
require "./config/wifi"
require "./config/keyboard"
require "./config/spotify"
require "./config/slack-status"

hs.notify
  .new({
    title="Hammerspoon",
    informativeText="Config loaded 🚀"
  })
  :send()
