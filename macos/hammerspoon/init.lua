-- defines the global trigger for all actions
hyper = {
  "cmd",
  "alt",
  "ctrl",
  "shift"
}

-- Reload hammerspoon config
hs.hotkey.bind(hyper, "à", function()
  hs.notify.new({
    title="Hammerspoon",
    informativeText="Config loaded 🚀"
  }):send()

  hs.reload()
end)

require "./config/windows"
require "./config/apps"
require "./config/caffeine"
require "./config/wifi"
require "./config/keyboard"
require "./config/spotify"
-- require "./config/slack-status"
