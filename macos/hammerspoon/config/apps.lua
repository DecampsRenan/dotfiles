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
