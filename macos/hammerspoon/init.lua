function getFocusedWindow()
  return hs.window.focusedWindow()
end





hyper = {
  "cmd", "alt", "ctrl", "shift"
}

hs.hotkey.bind(hyper, "à", function() hs.reload() end)

require "./config/roundedCorners"
require "./config/windows"
require "./config/apps"
require "./config/caffeine"
require "./config/wifi"

-- Watch the dotfile dir to detect file changes
-- and notify the user to push its changes
function notifyUserForConfigChanges()
  hs.notify.new({
    title="Dotfile config",
    informativeText="You have updated your dotfile. Do not forget to push your changes !"
  }):send()
end
local dotfileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/Documents/dev/perso/dotfiles", notifyUserForConfigChanges):start()

hs.notify.new({ title="Hammerspoon", informativeText="Config loaded 🎸" }):send()
