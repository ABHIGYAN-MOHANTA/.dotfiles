
hs.hotkey.bind({ "cmd", "alt" }, ";", function()
	hs.task.new("/usr/bin/open", nil, { "-na", "Alacritty" }):start()
end)

-- Toggle macOS Desktop Icons
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function()
  local current = hs.execute("defaults read com.apple.finder CreateDesktop"):gsub("%s+", "")
  local newValue = (current == "true") and "false" or "true"
  hs.execute("defaults write com.apple.finder CreateDesktop " .. newValue)
  hs.execute("killall Finder")  -- Restart Finder to apply change
  hs.alert.show("Desktop icons: " .. (newValue == "true" and "Visible" or "Hidden"))
end)

hs.hotkey.bind({"cmd"}, "b", function()
  hs.task.new("/usr/bin/open", nil, { "-na", "Google Chrome" }):start()
end)

-- Pomodoro Timer for Hammerspoon
-- Toggle with Cmd+Alt+.

local pomodoro = {}

-- Configuration with Alacritty-inspired colors
pomodoro.config = {
    workTime = 25 * 60,
    breakTime = 5 * 60,
    longBreakTime = 15 * 60,
    width = 340,
    height = 220,
    colors = {
        bg = { red = 0.05, green = 0.08, blue = 0.12, alpha = 0.97 },
        border = { red = 0.15, green = 0.35, blue = 0.45, alpha = 0.8 },
        accentCyan = { red = 0.2, green = 0.8, blue = 0.9, alpha = 1.0 },
        accentBlue = { red = 0.3, green = 0.5, blue = 0.9, alpha = 1.0 },
        accentPurple = { red = 0.55, green = 0.4, blue = 0.85, alpha = 1.0 },
        accentOrange = { red = 0.95, green = 0.6, blue = 0.3, alpha = 1.0 },
        accentRed = { red = 0.9, green = 0.35, blue = 0.4, alpha = 1.0 },
        textPrimary = { red = 0.85, green = 0.95, blue = 1.0, alpha = 1.0 },
        textSecondary = { red = 0.5, green = 0.7, blue = 0.8, alpha = 1.0 },
        textDim = { red = 0.35, green = 0.45, blue = 0.55, alpha = 1.0 },
    }
}

-- State
pomodoro.state = {
    timeRemaining = pomodoro.config.workTime,
    isRunning = false,
    isBreak = false,
    timer = nil,
    canvas = nil,
    isVisible = false,
    sessions = 0,
}

-- Format time as MM:SS
function pomodoro.formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", mins, secs)
end

-- Update the display
function pomodoro.updateDisplay()
    if not pomodoro.state.canvas then return end
    
    local canvas = pomodoro.state.canvas
    local c = pomodoro.config.colors
    
    -- Calculate progress
    local totalTime = pomodoro.state.isBreak and pomodoro.config.breakTime or pomodoro.config.workTime
    local progress = 1 - (pomodoro.state.timeRemaining / totalTime)
    
    canvas:replaceElements({
        -- Main background
        {
            type = "rectangle",
            action = "fill",
            fillColor = c.bg,
            roundedRectRadii = { xRadius = 16, yRadius = 16 },
        },
        -- Accent border with glow effect
        {
            type = "rectangle",
            action = "stroke",
            strokeColor = c.border,
            strokeWidth = 2,
            roundedRectRadii = { xRadius = 16, yRadius = 16 },
        },
        -- Inner accent line
        {
            type = "rectangle",
            action = "stroke",
            strokeColor = { red = 0.1, green = 0.25, blue = 0.35, alpha = 0.5 },
            strokeWidth = 1,
            roundedRectRadii = { xRadius = 14, yRadius = 14 },
            frame = { x = 2, y = 2, w = pomodoro.config.width - 4, h = pomodoro.config.height - 4 },
        },
        -- Progress bar background
        {
            type = "rectangle",
            action = "fill",
            fillColor = { red = 0.1, green = 0.15, blue = 0.2, alpha = 0.6 },
            roundedRectRadii = { xRadius = 6, yRadius = 6 },
            frame = { x = 20, y = 15, w = pomodoro.config.width - 40, h = 8 },
        },
        -- Progress bar fill
        {
            type = "rectangle",
            action = "fill",
            fillColor = pomodoro.state.isBreak and c.accentPurple or c.accentCyan,
            roundedRectRadii = { xRadius = 6, yRadius = 6 },
            frame = { x = 20, y = 15, w = (pomodoro.config.width - 40) * progress, h = 8 },
        },
        -- Timer display with larger font
        {
            type = "text",
            text = pomodoro.formatTime(pomodoro.state.timeRemaining),
            textSize = 56,
            textColor = c.textPrimary,
            textAlignment = "center",
            frame = { x = 0, y = 35, w = pomodoro.config.width, h = 70 },
        },
        -- Status text with icon
        {
            type = "text",
            text = (pomodoro.state.isBreak and "◉ BREAK TIME" or "◉ FOCUS TIME") .. " | Session " .. pomodoro.state.sessions,
            textSize = 13,
            textColor = c.textSecondary,
            textAlignment = "center",
            frame = { x = 0, y = 105, w = pomodoro.config.width, h = 20 },
        },
        -- Divider line
        {
            type = "rectangle",
            action = "fill",
            fillColor = { red = 0.15, green = 0.25, blue = 0.35, alpha = 0.4 },
            frame = { x = 30, y = 130, w = pomodoro.config.width - 60, h = 1 },
        },
        -- Start/Pause button
        {
            type = "rectangle",
            action = "fill",
            fillColor = pomodoro.state.isRunning and c.accentOrange or c.accentCyan,
            roundedRectRadii = { xRadius = 8, yRadius = 8 },
            frame = { x = 20, y = 145, w = 70, h = 38 },
            trackMouseDown = true,
            id = "startButton",
        },
        {
            type = "text",
            text = pomodoro.state.isRunning and "⏸ Pause" or "▶ Start",
            textSize = 12,
            textColor = { red = 0.05, green = 0.08, blue = 0.12, alpha = 1.0 },
            textAlignment = "center",
            frame = { x = 20, y = 155, w = 70, h = 20 },
        },
        -- Reset button
        {
            type = "rectangle",
            action = "fill",
            fillColor = c.accentRed,
            roundedRectRadii = { xRadius = 8, yRadius = 8 },
            frame = { x = 100, y = 145, w = 70, h = 38 },
            trackMouseDown = true,
            id = "resetButton",
        },
        {
            type = "text",
            text = "↻ Reset",
            textSize = 12,
            textColor = { red = 0.05, green = 0.08, blue = 0.12, alpha = 1.0 },
            textAlignment = "center",
            frame = { x = 100, y = 155, w = 70, h = 20 },
        },
        -- Break button
        {
            type = "rectangle",
            action = "fill",
            fillColor = c.accentBlue,
            roundedRectRadii = { xRadius = 8, yRadius = 8 },
            frame = { x = 180, y = 145, w = 70, h = 38 },
            trackMouseDown = true,
            id = "breakButton",
        },
        {
            type = "text",
            text = "☕ Break",
            textSize = 12,
            textColor = { red = 0.05, green = 0.08, blue = 0.12, alpha = 1.0 },
            textAlignment = "center",
            frame = { x = 180, y = 155, w = 70, h = 20 },
        },
        -- Long Break button
        {
            type = "rectangle",
            action = "fill",
            fillColor = c.accentPurple,
            roundedRectRadii = { xRadius = 8, yRadius = 8 },
            frame = { x = 260, y = 145, w = 60, h = 38 },
            trackMouseDown = true,
            id = "longBreakButton",
        },
        {
            type = "text",
            text = "⏳ Long",
            textSize = 11,
            textColor = { red = 0.05, green = 0.08, blue = 0.12, alpha = 1.0 },
            textAlignment = "center",
            frame = { x = 260, y = 155, w = 60, h = 20 },
        },
        -- Footer info
        {
            type = "text",
            text = "Cmd+Alt+. to toggle",
            textSize = 9,
            textColor = c.textDim,
            textAlignment = "center",
            frame = { x = 0, y = 195, w = pomodoro.config.width, h = 15 },
        },
    })
end

-- Start the timer
function pomodoro.start()
    if pomodoro.state.timer then
        pomodoro.state.timer:stop()
    end
    
    pomodoro.state.isRunning = true
    pomodoro.state.timer = hs.timer.doEvery(1, function()
        pomodoro.state.timeRemaining = pomodoro.state.timeRemaining - 1
        
        if pomodoro.state.timeRemaining <= 0 then
            pomodoro.pause()
            if not pomodoro.state.isBreak then
                pomodoro.state.sessions = pomodoro.state.sessions + 1
            end
            hs.alert.show(pomodoro.state.isBreak and "⏰ Break finished!" or "⏰ Work session finished!")
            hs.sound.getByName("Ping"):play()
        end
        
        pomodoro.updateDisplay()
    end)
    pomodoro.updateDisplay()
end

-- Pause the timer
function pomodoro.pause()
    if pomodoro.state.timer then
        pomodoro.state.timer:stop()
    end
    pomodoro.state.isRunning = false
    pomodoro.updateDisplay()
end

-- Reset to work time
function pomodoro.reset()
    pomodoro.pause()
    pomodoro.state.isBreak = false
    pomodoro.state.timeRemaining = pomodoro.config.workTime
    pomodoro.updateDisplay()
end

-- Start break
function pomodoro.startBreak()
    pomodoro.pause()
    pomodoro.state.isBreak = true
    pomodoro.state.timeRemaining = pomodoro.config.breakTime
    pomodoro.updateDisplay()
end

-- Start long break
function pomodoro.startLongBreak()
    pomodoro.pause()
    pomodoro.state.isBreak = true
    pomodoro.state.timeRemaining = pomodoro.config.longBreakTime
    pomodoro.updateDisplay()
end

-- Handle mouse clicks
function pomodoro.handleClick(canvas, event, id)
    if event == "mouseDown" then
        if id == "startButton" then
            if pomodoro.state.isRunning then
                pomodoro.pause()
            else
                pomodoro.start()
            end
        elseif id == "resetButton" then
            pomodoro.reset()
        elseif id == "breakButton" then
            pomodoro.startBreak()
        elseif id == "longBreakButton" then
            pomodoro.startLongBreak()
        end
    end
end

-- Create the canvas
function pomodoro.createCanvas()
    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    
    local x = frame.w - pomodoro.config.width - 50
    local y = 50
    
    pomodoro.state.canvas = hs.canvas.new({
        x = x,
        y = y,
        w = pomodoro.config.width,
        h = pomodoro.config.height
    })
    
    pomodoro.state.canvas:level("floating")
    pomodoro.state.canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    pomodoro.state.canvas:mouseCallback(pomodoro.handleClick)
    
    pomodoro.updateDisplay()
end

-- Toggle visibility
function pomodoro.toggle()
    if not pomodoro.state.canvas then
        pomodoro.createCanvas()
    end
    
    if pomodoro.state.isVisible then
        pomodoro.state.canvas:hide()
        pomodoro.state.isVisible = false
    else
        pomodoro.state.canvas:show()
        pomodoro.state.isVisible = true
    end
end

-- Initialize
pomodoro.createCanvas()

-- Bind hotkey: Cmd+Alt+.
hs.hotkey.bind({"cmd", "alt"}, ".", function()
    pomodoro.toggle()
end)

return pomodoro