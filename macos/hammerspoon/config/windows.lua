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
