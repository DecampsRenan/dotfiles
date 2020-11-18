-- Update keyboard layout according to the one I'm currently using

local log = hs.logger.new('keyboard','debug')
log.i('Initializing')

externalKeyboardId = 6973
externaleKeyboardName = "Corsair Gaming K55 RGB Keyboard"

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local usbDevices = hs.usb.attachedDevices()
for i in pairs(usbDevices) do
  if
    usbDevices[i].productName == externaleKeyboardName and
    usbDevices[i].productID == externalKeyboardId
  then
    hs.notify
      .new({ title="Keyboard layout", informativeText="Using PC Config for " .. externaleKeyboardName .. " Device" })
      :send()
      hs.keycodes.setLayout("French - PC")
  end
end

local usbWatcher = nil

function usbDeviceCallback(data)
    if (data["productName"] == externaleKeyboardName) then
        if (data["eventType"] == "added") then
          hs.keycodes.setLayout("French - PC")
          hs.notify
            .new({ title="Keyboard layout", informativeText="Using external keyboard" })
            :send()
        elseif (data["eventType"] == "removed") then
          hs.keycodes.setLayout("French")
          hs.notify
            .new({ title="Keyboard layout", informativeText="Using default keyboard" })
            :send()
        end
    end
end

usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()
