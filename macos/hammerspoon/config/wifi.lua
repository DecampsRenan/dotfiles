wifiWatcher = nil

local homeSSID = hs.settings.get("homeSSID")

-- if hammerspoon haven't already store homeSSID
if not homeSSID then
  local _, homeSSID = hs.dialog.textPrompt("Wifi notifier", "Please provide your usual network SSID")
  hs.settings.set("homeSSID", homeSSID)
end

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

function wifiStatusCallback()
  net = hs.wifi.currentNetwork()
  if net==nil then
      hs.notify.show("You lost Wi-Fi connection","","","")
  else
      hs.notify.show("Connected to Wi-Fi network","",net,"")
  end
end

wifiwatcher = hs.wifi.watcher.new(wifiStatusCallback)
wifiwatcher:start()
