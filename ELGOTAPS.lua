local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

print("e elgo Loading intro...")

-- Detect Da Hood
local success, gameInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
local isDaHood = success and string.find(string.lower(gameInfo.Name or ""), "da hood") ~= nil
local targetPartName = isDaHood and "Torso" or "Head"

-- ==== INTRO WITH KEY SYSTEM ====
local introGui = Instance.new("ScreenGui")
introGui.Name = "elgoIntro"
introGui.ResetOnSpawn = false
introGui.IgnoreGuiInset = true
introGui.Parent = game.CoreGui

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.new(0, 0, 0)
overlay.BackgroundTransparency = 0.6
overlay.Parent = introGui

local introSound = Instance.new("Sound")
introSound.SoundId = "rbxassetid://1838666492"
introSound.Volume = 0.7
introSound.Looped = true
introSound.Parent = overlay
introSound:Play()

-- Code rain
local particles = {}
for i = 1, 200 do
    local label = Instance.new("TextLabel")
    local randomText = ""
    for _ = 1, math.random(8, 25) do
        randomText = randomText .. string.char(math.random(33, 126))
    end
    label.Text = randomText
    label.TextColor3 = Color3.new(0, 1, 0.4)
    label.TextTransparency = 1
    label.Font = Enum.Font.Code
    label.TextSize = math.random(12, 18)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 300, 0, 40)
    label.Position = UDim2.new(math.random(), 0, math.random(-0.3, 0), 0)
    label.Rotation = math.random(-45, 45)
    label.Parent = overlay
    
    table.insert(particles, {label = label, speed = math.random(30, 100)/100, fadeSpeed = math.random(5, 15)/100})
end

RunService.Heartbeat:Connect(function(dt)
    if overlay.Parent then
        for _, p in ipairs(particles) do
            p.label.Position = p.label.Position + UDim2.new(math.random(-0.01, 0.01), 0, p.speed * dt, 0)
            p.label.TextTransparency = math.max(0.3, p.label.TextTransparency - p.fadeSpeed * dt)
            if p.label.Position.Y.Scale > 1.2 then
                p.label.Position = UDim2.new(math.random(), 0, math.random(-0.3, -0.1), 0)
                p.label.TextTransparency = 1
                local newText = ""
                for _ = 1, math.random(8, 25) do newText = newText .. string.char(math.random(33, 126)) end
                p.label.Text = newText
            end
        end
    end
end)

spawn(function()
    for i = 1, 0.3, -0.02 do
        for _, p in ipairs(particles) do p.label.TextTransparency = i end
        task.wait(0.02)
    end
end)

local mainText = Instance.new("TextLabel")
mainText.Size = UDim2.new(0.8, 0, 0.3, 0)
mainText.Position = UDim2.new(0.1, 0, 0.3, 0)
mainText.BackgroundTransparency = 1
mainText.Text = ""
mainText.TextColor3 = Color3.new(0, 0.7, 1)
mainText.TextScaled = true
mainText.Font = Enum.Font.GothamBlack
mainText.Parent = overlay

spawn(function()
    task.wait(0.8)
    local fullText = "ELGO"
    for i = 1, #fullText do
        mainText.Text = string.sub(fullText, 1, i)
        task.wait(0.3)
    end
    for i = 1, 12 do
        mainText.TextColor3 = Color3.new(1, 0, 0)
        mainText.Position = mainText.Position + UDim2.new(math.random(-0.01, 0.01), 0, math.random(-0.01, 0.01), 0)
        task.wait(0.05)
        mainText.TextColor3 = Color3.new(0, 0.7, 1)
        mainText.Position = UDim2.new(0.1, 0, 0.3, 0)
        task.wait(0.05)
    end
end)

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.4, 0, 0.08, 0)
keyBox.Position = UDim2.new(0.3, 0, 0.6, 0)
keyBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
keyBox.BackgroundTransparency = 0.4
keyBox.TextColor3 = Color3.new(0, 1, 0.6)
keyBox.PlaceholderText = "Enter Key..."
keyBox.Text = ""
keyBox.TextScaled = true
keyBox.Font = Enum.Font.Code
keyBox.Visible = false
keyBox.Parent = overlay

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.4, 0, 0.08, 0)
statusText.Position = UDim2.new(0.3, 0, 0.7, 0)
statusText.BackgroundTransparency = 1
statusText.Text = ""
statusText.TextColor3 = Color3.new(1, 0, 0)
statusText.TextScaled = true
statusText.Font = Enum.Font.Gotham
statusText.Parent = overlay

task.delay(3, function()
    if keyBox.Parent then
        keyBox.Visible = true
        keyBox:CaptureFocus()
    end
end)

-- NEW KEY SYSTEM
local correctKey = "6EEY"
local attempts = 0
local maxAttempts = 2
local keyAccepted = false
local timeout = 7200  -- 2 hours in seconds

-- Auto-accept after 2 hours even if no key entered
task.spawn(function()
    task.wait(timeout)
    if not keyAccepted then
        keyAccepted = true
        statusText.Text = "Timeout - Access Granted"
        statusText.TextColor3 = Color3.new(0, 1, 0)
        task.wait(1.5)
        introSound:Stop()
        TweenService:Create(overlay, TweenInfo.new(1.8), {BackgroundTransparency = 1}):Play()
        for _, p in ipairs(particles) do
            TweenService:Create(p.label, TweenInfo.new(1.8), {TextTransparency = 1}):Play()
        end
        TweenService:Create(mainText, TweenInfo.new(1.8), {TextTransparency = 1}):Play()
        TweenService:Create(keyBox, TweenInfo.new(1.8), {TextTransparency = 1}):Play()
        TweenService:Create(statusText, TweenInfo.new(1.8), {TextTransparency = 1}):Play()
        task.delay(1.8, function()
            introGui:Destroy()
        end)
    end
end)

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and not keyAccepted then
        attempts = attempts + 1
        local input = keyBox.Text:upper():gsub("%s+$", "")  -- uppercase & trim trailing spaces

        if input == correctKey:upper() then
            statusText.Text = "Access Accepted"
            statusText.TextColor3 = Color3.new(0, 1, 0)
            keyAccepted = true
            
            task.wait(1.2)
            introSound:Stop()
            
            TweenService:Create(overlay, TweenInfo.new(1.8), {BackgroundTransparency = 1}):Play()
            for _, p in ipairs(particles) do
                TweenService:Create(p.label, TweenInfo.new(1.8), {TextTransparency = 1}):Play()
            end
            TweenService:Create(mainText, TweenInfo.new(1.8), {TextTransparency = 1}):Play()
            TweenService:Create(keyBox, TweenInfo.new(1.8), {TextTransparency = 1}):Play()
            TweenService:Create(statusText, TweenInfo.new(1.8), {TextTransparency = 1}):Play()
            
            task.delay(1.8, function()
                introGui:Destroy()
            end)
        else
            if attempts >= maxAttempts then
                statusText.Text = "Too many wrong attempts. Shutting down..."
                statusText.TextColor3 = Color3.new(1, 0, 0)
                task.wait(2)
                introGui:Destroy()
                error("elgo key failed - script terminated")
                return
            else
                statusText.Text = "Invalid Key (" .. (maxAttempts - attempts) .. " try left)"
                keyBox.Text = ""
                task.wait(1.5)
                statusText.Text = ""
                if keyBox.Parent then keyBox:CaptureFocus() end
            end
        end
    end
end)

-- Wait for key acceptance or timeout
repeat task.wait() until keyAccepted
task.wait(1.8)
repeat task.wait() until not introGui.Parent

print("Intro fully finished - Loading elgo...")

-- ==== WAIT FOR PLAYERGUI ====
local playerGui = player:WaitForChild("PlayerGui")

-- ==== SNOW ====
local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")

local snowPart = Instance.new("Part")
snowPart.Name = "elgoSnowPart"
snowPart.Size = Vector3.new(100, 1, 100)
snowPart.Transparency = 1
snowPart.CanCollide = false
snowPart.Anchored = true
snowPart.Parent = workspace

local snowEmitter = Instance.new("ParticleEmitter")
snowEmitter.Parent = snowPart
snowEmitter.Texture = "rbxassetid://293009449"
snowEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1))
snowEmitter.LightEmission = 0.3
snowEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 1.2)})
snowEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 0.5)})
snowEmitter.Lifetime = NumberRange.new(8, 12)
snowEmitter.Rate = 80
snowEmitter.Speed = NumberRange.new(4, 8)
snowEmitter.VelocitySpread = 30
snowEmitter.Acceleration = Vector3.new(0, -2, 0)
snowEmitter.RotSpeed = NumberRange.new(-30, 30)
snowEmitter.Rotation = NumberRange.new(0, 360)
snowEmitter.Enabled = true

RunService.Heartbeat:Connect(function()
    if humanoidRootPart and humanoidRootPart.Parent then
        snowPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 50, 0)
    end
end)

player.CharacterAdded:Connect(function(char)
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ==== VARIABLES ====
local aimlockEnabled = false
local lockedPlayer = nil
local prediction = 0.135
local customSpeed = 150
local defaultWalkSpeed = 16
local minSpeed = 16
local maxSpeed = 1000
local speedEnabled = false
local bodyVelocity, bodyGyro, speedConnection

-- ==== GUIs ====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "elgoUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Lock GUI
local lockFrame = Instance.new("Frame")
lockFrame.Size = UDim2.new(0, 160, 0, 80)
lockFrame.Position = UDim2.new(1, -175, 0, 100)
lockFrame.BackgroundColor3 = Color3.new(0, 0, 0)
lockFrame.BackgroundTransparency = 0.5
lockFrame.Active = true
lockFrame.Draggable = true
lockFrame.Parent = screenGui

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 12)
lockCorner.Parent = lockFrame

local lockIcon = Instance.new("TextButton")
lockIcon.Size = UDim2.new(0.3, 0, 0.8, 0)
lockIcon.Position = UDim2.new(0.65, 0, 0.1, 0)
lockIcon.BackgroundTransparency = 1
lockIcon.Text = "e"
lockIcon.TextColor3 = Color3.new(0, 0.7, 1)
lockIcon.TextScaled = true
lockIcon.Font = Enum.Font.GothamBlack
lockIcon.Parent = lockFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "elgo"
titleLabel.TextColor3 = Color3.new(0, 0.7, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = lockFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.6, 0, 0.4, 0)
statusLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.new(0, 1, 0)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = lockFrame

-- Marco Speed GUI
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0, 150, 0, 80)
speedFrame.Position = UDim2.new(1, -165, 0, 200)
speedFrame.BackgroundColor3 = Color3.new(0, 0, 0)
speedFrame.BackgroundTransparency = 0.5
speedFrame.Active = true
speedFrame.Draggable = true
speedFrame.Parent = screenGui

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 12)
speedCorner.Parent = speedFrame

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, 0, 0.35, 0)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "Marco Speed"
speedTitle.TextColor3 = Color3.new(0, 0.7, 1)
speedTitle.TextScaled = true
speedTitle.Font = Enum.Font.GothamBold
speedTitle.Parent = speedFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.8, 0, 0.3, 0)
speedBox.Position = UDim2.new(0.1, 0, 0.3, 0)
speedBox.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.PlaceholderText = "16-1000"
speedBox.Text = tostring(customSpeed)
speedBox.TextScaled = true
speedBox.Font = Enum.Font.Gotham
speedBox.ClearTextOnFocus = false
speedBox.Parent = speedFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0.25, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
toggleButton.Text = "Off"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = speedFrame

-- Prediction GUI
local predictionFrame = Instance.new("Frame")
predictionFrame.Size = UDim2.new(0, 150, 0, 80)
predictionFrame.Position = UDim2.new(1, -165, 0, 300)
predictionFrame.BackgroundColor3 = Color3.new(0, 0, 0)
predictionFrame.BackgroundTransparency = 0.5
predictionFrame.Active = true
predictionFrame.Draggable = true
predictionFrame.Parent = screenGui

local predCorner = Instance.new("UICorner")
predCorner.CornerRadius = UDim.new(0, 12)
predCorner.Parent = predictionFrame

local predTitle = Instance.new("TextLabel")
predTitle.Size = UDim2.new(1, 0, 0.35, 0)
predTitle.BackgroundTransparency = 1
predTitle.Text = "Prediction"
predTitle.TextColor3 = Color3.new(0, 0.7, 1)
predTitle.TextScaled = true
predTitle.Font = Enum.Font.GothamBold
predTitle.Parent = predictionFrame

local predBox = Instance.new("TextBox")
predBox.Size = UDim2.new(0.8, 0, 0.3, 0)
predBox.Position = UDim2.new(0.1, 0, 0.3, 0)
predBox.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
predBox.TextColor3 = Color3.new(1, 1, 1)
predBox.PlaceholderText = "Value"
predBox.Text = tostring(prediction)
predBox.TextScaled = true
predBox.Font = Enum.Font.Gotham
predBox.ClearTextOnFocus = false
predBox.Parent = predictionFrame

local predStatus = Instance.new("TextLabel")
predStatus.Size = UDim2.new(0.8, 0, 0.25, 0)
predStatus.Position = UDim2.new(0.1, 0, 0.7, 0)
predStatus.BackgroundTransparency = 1
predStatus.Text = "Current: " .. prediction
predStatus.TextColor3 = Color3.new(1, 1, 1)
predStatus.TextScaled = true
predStatus.Font = Enum.Font.GothamBold
predStatus.Parent = predictionFrame

predBox.FocusLost:Connect(function(enter)
    if enter then
        local val = tonumber(predBox.Text)
        if val then
            prediction = val
            predStatus.Text = "Current: " .. prediction
        else
            predBox.Text = tostring(prediction)
        end
    end
end)

-- Marco Speed logic
local function cleanupSpeed()
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
    end
end

local function startSpeed()
    cleanupSpeed()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(50000, 0, 50000)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.P = 3000
    bodyVelocity.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyGyro.P = 5000
    bodyGyro.D = 800
    bodyGyro.Parent = root

    speedConnection = RunService.Heartbeat:Connect(function()
        if hum.Health <= 0 then return end
        local dir = hum.MoveDirection
        if dir.Magnitude > 0 then
            bodyVelocity.Velocity = dir * customSpeed
            bodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + dir)
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        local n = tonumber(speedBox.Text)
        if n and n >= minSpeed and n <= maxSpeed then customSpeed = n end
        toggleButton.Text = "On"
        toggleButton.BackgroundColor3 = Color3.new(0,1,0)
        startSpeed()
    else
        toggleButton.Text = "Off"
        toggleButton.BackgroundColor3 = Color3.new(1,0,0)
        cleanupSpeed()
    end
end)

speedBox.FocusLost:Connect(function(enter)
    if enter then
        local n = tonumber(speedBox.Text)
        if n and n >= minSpeed and n <= maxSpeed then
            customSpeed = n
            if speedEnabled then startSpeed() end
        else
            speedBox.Text = tostring(customSpeed)
        end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if speedEnabled then startSpeed() end
end)

-- Aimlock toggle
lockIcon.MouseButton1Click:Connect(function()
    aimlockEnabled = not aimlockEnabled
    if aimlockEnabled then
        lockIcon.TextColor3 = Color3.new(0,1,0)
        statusLabel.Text = "Active 🔍"
        statusLabel.TextColor3 = Color3.new(1,0,0)
    else
        lockIcon.TextColor3 = Color3.new(0,0.7,1)
        statusLabel.Text = "Off"
        statusLabel.TextColor3 = Color3.new(1,1,1)
        lockedPlayer = nil
        if _G.lockName then _G.lockName:Remove() _G.lockName = nil end
        if _G.healthBG then _G.healthBG:Remove() _G.healthBG = nil end
        if _G.healthFG then _G.healthFG:Remove() _G.healthFG = nil end
    end
end)

-- ESP
local function updateLockedESP()
    if not aimlockEnabled or not lockedPlayer or not lockedPlayer.Character then
        if _G.lockName then _G.lockName.Visible = false end
        if _G.healthBG then _G.healthBG.Visible = false end
        if _G.healthFG then _G.healthFG.Visible = false end
        return
    end

    local char = lockedPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not head or not hum then return end

    local headPos, onScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

    if onScreen then
        local height = math.abs(headPos.Y - legPos.Y)

        if not _G.lockName then
            _G.lockName = Drawing.new("Text")
            _G.lockName.Font = 3
            _G.lockName.Color = Color3.new(1,1,1)
            _G.lockName.Outline = true
            _G.lockName.OutlineColor = Color3.new(0,0,0)
            _G.lockName.Center = true
        end
        local display = lockedPlayer.DisplayName or lockedPlayer.Name
        _G.lockName.Text = display .. " @" .. lockedPlayer.Name
        _G.lockName.Size = math.clamp(height / 5, 12, 20)
        _G.lockName.Position = Vector2.new((headPos.X + legPos.X)/2, headPos.Y - _G.lockName.Size - 5)
        _G.lockName.Visible = true

        local health = hum.Health / hum.MaxHealth
        local barHeight = height * 1.2
        local barWidth = 6
        local barX = headPos.X - height * 0.4
        local barBottomY = legPos.Y + 10

        if not _G.healthBG then
            _G.healthBG = Drawing.new("Square")
            _G.healthBG.Filled = true
            _G.healthBG.Color = Color3.new(0,0,0)
            _G.healthBG.Transparency = 0.6
        end
        if not _G.healthFG then
            _G.healthFG = Drawing.new("Square")
            _G.healthFG.Filled = true
        end

        _G.healthBG.Size = Vector2.new(barWidth + 2, barHeight + 2)
        _G.healthBG.Position = Vector2.new(barX - 1, barBottomY - barHeight - 1)

        _G.healthFG.Size = Vector2.new(barWidth, barHeight * health)
        _G.healthFG.Position = Vector2.new(barX, barBottomY - (barHeight * health))
        _G.healthFG.Color = Color3.fromHSV(math.clamp(health / 3, 0, 0.333), 1, 1)

        _G.healthBG.Visible = true
        _G.healthFG.Visible = true
    else
        if _G.lockName then _G.lockName.Visible = false end
        if _G.healthBG then _G.healthBG.Visible = false end
        if _G.healthFG then _G.healthFG.Visible = false end
    end
end

-- === BOT SUPPORT + PLAYER FALLBACK ===
local Workspace = game:GetService("Workspace")

local oldGetClosest = nil
local function getClosest()
    local botsFolder = Workspace:FindFirstChild("Bots")
    local closest = nil
    local shortest = math.huge
    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    -- First: check bots
    if botsFolder then
        for _, bot in pairs(botsFolder:GetChildren()) do
            if bot:IsA("Model") and bot:FindFirstChild(targetPartName) and bot:FindFirstChild("HumanoidRootPart") then
                local part = bot[targetPartName]
                local pos, onScreen = camera:WorldToScreenPoint(part.Position)
                if onScreen and pos.Z > 0 then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest and dist < 400 then
                        shortest = dist
                        closest = { Character = bot, Name = bot.Name, DisplayName = bot.Name }
                    end
                end
            end
        end
    end

    -- If no bot found, fall back to players
    if not closest then
        for _, p in Players:GetPlayers() do
            if p ~= player and p.Character and p.Character:FindFirstChild(targetPartName) then
                local part = p.Character[targetPartName]
                local pos, onScreen = camera:WorldToScreenPoint(part.Position)
                if onScreen and pos.Z > 0 then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest and dist < 400 then
                        shortest = dist
                        closest = p
                    end
                end
            end
        end
    end

    return closest
end

-- Main loop with bot support
RunService.RenderStepped:Connect(function()
    if aimlockEnabled then
        if not lockedPlayer or not lockedPlayer.Character or not lockedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            lockedPlayer = getClosest()
        end
        if lockedPlayer and lockedPlayer.Character and lockedPlayer.Character:FindFirstChild(targetPartName) then
            local part = lockedPlayer.Character[targetPartName]
            local predPos = part.Position + part.AssemblyLinearVelocity * prediction
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, predPos)
            
            local name = lockedPlayer.Name
            if lockedPlayer.Character.Parent == Workspace:FindFirstChild("Bots") then
                name = "[BOT] " .. name
            end
            statusLabel.Text = "Locked: " .. name
        else
            statusLabel.Text = "Searching..."
        end
    else
        lockedPlayer = nil
    end
    updateLockedESP()
end)

Players.PlayerRemoving:Connect(function(p)
    if p == lockedPlayer then
        lockedPlayer = nil
        if _G.lockName then _G.lockName:Remove() _G.lockName = nil end
        if _G.healthBG then _G.healthBG:Remove() _G.healthBG = nil end
        if _G.healthFG then _G.healthFG:Remove() _G.healthFG = nil end
    end
end)

-- 6EEY animation
-- FULL FIXED Hybrid Animation Changer: Zombie Pack (80) + Oldschool Jump/Fall (667)
-- Uses OFFICIAL Roblox IDs from Creator Docs + verified working Oldschool
-- Preloads to prevent blocky defaults! 🧟‍♂️✨
-- LocalScript in StarterPlayer > StarterCharacterScripts

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local player = Players.LocalPlayer

-- OFFICIAL Zombie Pack IDs (bundle 80) + Oldschool Jump/Fall
local zombieIdle1 = "rbxassetid://616158929"
local zombieIdle2 = "rbxassetid://616160636"
local zombieWalk = "rbxassetid://616168032"
local zombieRun = "rbxassetid://616163682"
local zombieClimb = "rbxassetid://616156119"
local zombieSwim = "rbxassetid://616165109"
local zombieSwimIdle = "rbxassetid://616166655"

local oldschoolJump = "rbxassetid://5319841935"  -- Verified working
local oldschoolFall = "rbxassetid://5319839762" -- Verified working

-- PRELOAD ALL to fix loading issues
local preloadList = {
    zombieIdle1, zombieIdle2, zombieWalk, zombieRun, zombieClimb,
    zombieSwim, zombieSwimIdle, oldschoolJump, oldschoolFall
}
ContentProvider:PreloadAsync(preloadList)
print("✅ Preloaded Zombie + Oldschool Jump/Fall animations!")

local function applyAnimations(character)
    local humanoid = character:WaitForChild("Humanoid")
    local animateScript = character:WaitForChild("Animate")
    
    -- Disable, set, re-enable
    animateScript.Disabled = true
    task.wait(0.2)  -- Brief pause for safety
    
    local animate = character.Animate
    
    -- Zombie for everything EXCEPT jump/fall
    animate.idle.Animation1.AnimationId = zombieIdle1
    animate.idle.Animation2.AnimationId = zombieIdle2
    animate.walk.WalkAnim.AnimationId = zombieWalk
    animate.run.RunAnim.AnimationId = zombieRun
    animate.climb.ClimbAnim.AnimationId = zombieClimb
    animate.swim.Swim.AnimationId = zombieSwim
    animate.swimidle.SwimIdle.AnimationId = zombieSwimIdle
    
    -- Oldschool ONLY for jump & fall
    animate.jump.JumpAnim.AnimationId = oldschoolJump
    animate.fall.FallAnim.AnimationId = oldschoolFall
    
    animateScript.Disabled = false
    
    print("✅ Zombie animations applied! Test: walk, run, jump, fall.")
end

-- Apply on spawn/respawn
if player.Character then
    applyAnimations(player.Character)
end
player.CharacterAdded:Connect(applyAnimations)

print("e elgo FULLY LOADED - Bots supported - Key: 6EEY e")
