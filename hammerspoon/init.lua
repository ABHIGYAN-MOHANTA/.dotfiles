hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "]", function()
	hs.notify.new({ title = "Abhigyan Mohanta", informativeText = "Intention!" }):send()
end)

hs.hotkey.bind({ "cmd", "alt" }, ";", function()
	hs.task.new("/usr/bin/open", nil, { "-na", "Alacritty" }):start()
end)

hs.loadSpoon("AClock")
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
  spoon.AClock:toggleShow()
end)

hs.loadSpoon("Cherry")
hs.hotkey.bind({"cmd", "alt", "ctrl"}, ".", function()
  spoon.Cherry:start()
end)


-- Toggle macOS Desktop Icons
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function()
  local current = hs.execute("defaults read com.apple.finder CreateDesktop"):gsub("%s+", "")
  local newValue = (current == "true") and "false" or "true"
  hs.execute("defaults write com.apple.finder CreateDesktop " .. newValue)
  hs.execute("killall Finder")  -- Restart Finder to apply change
  hs.alert.show("Desktop icons: " .. (newValue == "true" and "Visible" or "Hidden"))
end)
