function getFocusedWindow()
  return hs.window.focusedWindow()
end

hyper = {
  "cmd", "alt", "ctrl", "shift"
}

hs.hotkey.bind(hyper, "à", function() hs.reload() end)

require "./config/windows"
require "./config/apps"
require "./config/caffeine"
require "./config/wifi"

hs.notify.new({ title="Hammerspoon", informativeText="Config loaded 🎸" }):send()
