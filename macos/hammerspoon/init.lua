function getFocusedWindow()
  return hs.window.focusedWindow()
end

local hyper = {
  "cmd", "alt", "ctrl", "shift"
}

hs.hotkey.bind(hyper, "à", function() hs.reload() end)

hs.window.animationDuration = 0

hs.hotkey.bind(hyper, "h", function()
  local win = getFocusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.left50)
end)

hs.hotkey.bind(hyper, "j", function()
  local win = getFocusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.maximized)
end)

hs.hotkey.bind(hyper, "k", function()
  local win = getFocusedWindow()
  if not win then return end
  win:moveToScreen(win:screen():next())
end)

hs.hotkey.bind(hyper, "l", function()
  local win = getFocusedWindow()
  if not win then return end
  win:moveToUnit(hs.layout.right50)
end)

-- Apps shortcuts
local applicationsHotkeys = {
  n = "Google Chrome",
  t = "iTerm",
  e = "Visual Studio Code"
}

for key, app in pairs(applicationsHotkeys) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end

caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("🌞")
  else
    caffeine:setTitle("💤")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

wifiWatcher = nil
homeSSID = "Dexter Jean Guy Du Racel"
lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(25)
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

hs.notify.new({ title="Hammerspoon", informativeText="Config loaded 🎸" }):send()
