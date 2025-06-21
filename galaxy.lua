-- PlayerXGalaxy.lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- 🛡️ Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local BuySeedStock = GameEvents:FindFirstChild("BuySeedStock")
local BuyGearStock = GameEvents:FindFirstChild("BuyGearStock")

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PlayerXGalaxyCuteUI"
gui.ResetOnSpawn = false

local function roundify(frame, radius)
    local uicorner = Instance.new("UICorner", frame)
    uicorner.CornerRadius = UDim.new(0, radius or 12)
    return uicorner
end

-- Toggle UI Button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 130, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "🌸 เปิด/ปิด UI"
toggleBtn.TextColor3 = Color3.fromRGB(80, 60, 90)
toggleBtn.Font = Enum.Font.FredokaOne
toggleBtn.TextSize = 18
toggleBtn.AutoButtonColor = false
roundify(toggleBtn, 18)

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 420, 0, 300)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 228, 241)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
roundify(mainFrame, 25)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
header.BorderSizePixel = 0
roundify(header, 25)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌸 Player x Galaxy V1.6"
title.Font = Enum.Font.FredokaOne
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(120, 40, 80)
title.TextStrokeTransparency = 0.4
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Tab Buttons
local tabButtonsFrame = Instance.new("Frame", mainFrame)
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 50)
tabButtonsFrame.BackgroundTransparency = 1

local function createTabButton(name, parent, xOffset)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 110, 1, 0)
    btn.Position = UDim2.new(0, xOffset or 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(140, 50, 90)
    btn.AutoButtonColor = false
    roundify(btn, 16)
    return btn
end

local mainTabBtn = createTabButton("Main", tabButtonsFrame, 0)
local settingTabBtn = createTabButton("Setting", tabButtonsFrame, 110)

-- Tab Content Frames
local tabContentFrame = Instance.new("Frame", mainFrame)
tabContentFrame.Size = UDim2.new(1, -30, 1, -110)
tabContentFrame.Position = UDim2.new(0, 15, 0, 95)
tabContentFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
tabContentFrame.BorderSizePixel = 0
roundify(tabContentFrame, 20)

-- Main Tab Content (ScrollingFrame)
local mainTabContent = Instance.new("ScrollingFrame", tabContentFrame)
mainTabContent.Size = UDim2.new(1, 0, 1, 0)
mainTabContent.CanvasSize = UDim2.new(0, 0, 0, 600)
mainTabContent.ScrollBarThickness = 8
mainTabContent.ScrollingDirection = Enum.ScrollingDirection.Y
mainTabContent.BackgroundTransparency = 1
mainTabContent.BorderSizePixel = 0
mainTabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
mainTabContent.ClipsDescendants = true
mainTabContent.Visible = true
roundify(mainTabContent, 20)

local layout = Instance.new("UIListLayout", mainTabContent)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Main Welcome Label
local mainLabel = Instance.new("TextLabel", mainTabContent)
mainLabel.Size = UDim2.new(1, 0, 0, 30)
mainLabel.BackgroundTransparency = 1
mainLabel.Text = "ยินดีต้อนรับสู่แท็บ Main! 💖"
mainLabel.Font = Enum.Font.FredokaOne
mainLabel.TextSize = 18
mainLabel.TextColor3 = Color3.fromRGB(140, 50, 90)
mainLabel.TextStrokeTransparency = 0.4
mainLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
mainLabel.LayoutOrder = 1

-- Create Toggle Buttons Function
local function createToggleButton(parent, label, order)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(0, 150, 0, 40)
    toggle.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    toggle.BorderSizePixel = 0
    toggle.TextColor3 = Color3.fromRGB(140, 50, 90)
    toggle.Font = Enum.Font.FredokaOne
    toggle.TextSize = 16
    toggle.AutoButtonColor = false
    roundify(toggle, 16)
    toggle.Text = "❌ " .. label .. ": OFF"
    toggle.LayoutOrder = order
    return toggle
end

-- Auto Seed
local seeds = {
    "Sugar Apple",
    "Ember Lily",
    "Beanstalk",
    "Cacao",
    "Pepper",
    "Mushroom",
    "Grape",
    "Banana",
    "Avocado",
    "Green Apple",
    "Cauliflower",
    "Loquat",
    "Kiwi",
    "Pineapple",
    "Prickly pear",
    "Bell pepper"
}

local activeSeeds = {}

for i, seedName in ipairs(seeds) do
    local toggle = createToggleButton(mainTabContent, seedName, 10 + i)
    toggle.Text = "❌ " .. seedName .. ": OFF"

    toggle.MouseButton1Click:Connect(function()
        if activeSeeds[seedName] then
            activeSeeds[seedName] = nil
            toggle.Text = "❌ " .. seedName .. ": OFF"
            toggle.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
        else
            activeSeeds[seedName] = true
            toggle.Text = "✅ " .. seedName .. ": ON"
            toggle.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        end
    end)
end

task.spawn(function()
    while true do
        for seed, isOn in pairs(activeSeeds) do
            if isOn and BuySeedStock then
                BuySeedStock:FireServer(seed)
            end
            wait(0.3)
        end
        wait(1)
    end
end)

-- Auto Sprinkler
local gears = {
    "Basic Sprinkler",
    "Advanced Sprinkler",
    "Godly Sprinkler",
    "Lightning Rod",
    "Master Sprinkler",
    "Watering can",
    "Tanning Mirror"
}

local isAutoSprinklerOn = false
local autoSprinklerCoroutine

local function buySprinklersLoop()
    while isAutoSprinklerOn do
        for _, gear in ipairs(gears) do
            if not isAutoSprinklerOn then break end
            if BuyGearStock then BuyGearStock:FireServer(gear) end
            wait(0.5)
        end
        wait(1)
    end
end

local autoSprinklerToggle = createToggleButton(mainTabContent, "Auto Sprinkler 🚿🌩️", 30)
autoSprinklerToggle.MouseButton1Click:Connect(function()
    isAutoSprinklerOn = not isAutoSprinklerOn
    if isAutoSprinklerOn then
        autoSprinklerToggle.Text = "✅ Auto Sprinkler 🚿🌩️: ON"
        autoSprinklerToggle.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        autoSprinklerCoroutine = coroutine.create(buySprinklersLoop)
        coroutine.resume(autoSprinklerCoroutine)
    else
        autoSprinklerToggle.Text = "❌ Auto Sprinkler 🚿🌩️: OFF"
        autoSprinklerToggle.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    end
end)

-- ร้านค้า Label
local shopLabel = Instance.new("TextLabel", mainTabContent)
shopLabel.Size = UDim2.new(1, -20, 0, 30)
shopLabel.BackgroundTransparency = 1
shopLabel.Text = "🛒 ร้านค้า"
shopLabel.Font = Enum.Font.FredokaOne
shopLabel.TextSize = 20
shopLabel.TextColor3 = Color3.fromRGB(140, 50, 90)
shopLabel.TextStrokeTransparency = 0.4
shopLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
shopLabel.TextXAlignment = Enum.TextXAlignment.Left
shopLabel.LayoutOrder = 31

-- ปุ่ม Seed Shop
local seedShopBtn = Instance.new("TextButton", mainTabContent)
seedShopBtn.Size = UDim2.new(0, 150, 0, 40)
seedShopBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
seedShopBtn.BorderSizePixel = 0
seedShopBtn.Text = "เปิด Seed Shop 🌱"
seedShopBtn.TextColor3 = Color3.fromRGB(140, 50, 90)
seedShopBtn.Font = Enum.Font.FredokaOne
seedShopBtn.TextSize = 18
seedShopBtn.AutoButtonColor = false
roundify(seedShopBtn, 16)
seedShopBtn.LayoutOrder = 32

-- ปุ่ม Gear Shop
local gearShopBtn = Instance.new("TextButton", mainTabContent)
gearShopBtn.Size = UDim2.new(0, 150, 0, 40)
gearShopBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
gearShopBtn.BorderSizePixel = 0
gearShopBtn.Text = "เปิด Gear Shop ⚙️"
gearShopBtn.TextColor3 = Color3.fromRGB(140, 50, 90)
gearShopBtn.Font = Enum.Font.FredokaOne
gearShopBtn.TextSize = 18
gearShopBtn.AutoButtonColor = false
roundify(gearShopBtn, 16)
gearShopBtn.LayoutOrder = 33

local playerGui = player:WaitForChild("PlayerGui")
local seedShopGui = playerGui:WaitForChild("Seed_Shop")
local gearShopGui = playerGui:WaitForChild("Gear_Shop")

seedShopBtn.MouseButton1Click:Connect(function()
    seedShopGui.Enabled = not seedShopGui.Enabled
    seedShopBtn.Text = seedShopGui.Enabled and "ปิด Seed Shop 🌱" or "เปิด Seed Shop 🌱"
    if seedShopGui.Enabled and gearShopGui.Enabled then
        gearShopGui.Enabled = false
        gearShopBtn.Text = "เปิด Gear Shop ⚙️"
    end
end)

gearShopBtn.MouseButton1Click:Connect(function()
    gearShopGui.Enabled = not gearShopGui.Enabled
    gearShopBtn.Text = gearShopGui.Enabled and "ปิด Gear Shop ⚙️" or "เปิด Gear Shop ⚙️"
    if gearShopGui.Enabled and seedShopGui.Enabled then
        seedShopGui.Enabled = false
        seedShopBtn.Text = "เปิด Seed Shop 🌱"
    end
end)

-- Close button
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-38,0,10)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,120,140)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
roundify(closeBtn, 10)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Tab Switching
local function showTab(name)
    for _, frame in ipairs(tabContentFrame:GetChildren()) do
        if frame:IsA("Frame") or frame:IsA("ScrollingFrame") then
            frame.Visible = false
        end
    end
    if name == "Main" then
        mainTabContent.Visible = true
    elseif name == "Setting" then
        settingTabContent.Visible = true
    end
end

mainTabBtn.MouseButton1Click:Connect(function() showTab("Main") end)
settingTabBtn.MouseButton1Click:Connect(function() showTab("Setting") end)
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Setting Tab Content (ScrollingFrame)
local settingTabContent = Instance.new("ScrollingFrame", tabContentFrame)
settingTabContent.Size = UDim2.new(1, 0, 1, 0)
settingTabContent.CanvasSize = UDim2.new(0, 0, 0, 200)
settingTabContent.ScrollBarThickness = 8
settingTabContent.ScrollingDirection = Enum.ScrollingDirection.Y
settingTabContent.BackgroundTransparency = 1
settingTabContent.BorderSizePixel = 0
settingTabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
settingTabContent.ClipsDescendants = true
settingTabContent.Visible = false
roundify(settingTabContent, 20)

-- Theme Colors Table
local themes = {
    Pink = {
        MainFrame = Color3.fromRGB(255, 228, 241),
        Header = Color3.fromRGB(255, 182, 193),
        Button = Color3.fromRGB(255, 182, 193),
        Text = Color3.fromRGB(140, 50, 90)
    },
    Blue = {
        MainFrame = Color3.fromRGB(210, 230, 255),
        Header = Color3.fromRGB(100, 150, 255),
        Button = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(20, 40, 90)
    },
    Green = {
        MainFrame = Color3.fromRGB(220, 255, 220),
        Header = Color3.fromRGB(120, 200, 120),
        Button = Color3.fromRGB(120, 200, 120),
        Text = Color3.fromRGB(40, 80, 40)
    },
    Black = {
        MainFrame = Color3.fromRGB(34, 34, 34),
        Header = Color3.fromRGB(0, 0, 0),
        Button = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Function to apply theme colors
local function applyTheme(themeName)
    local theme = themes[themeName]
    if not theme then return end

    mainFrame.BackgroundColor3 = theme.MainFrame
    header.BackgroundColor3 = theme.Header

    toggleBtn.BackgroundColor3 = theme.Button
    toggleBtn.TextColor3 = theme.Text

    for _, btn in ipairs(tabButtonsFrame:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = theme.Button
            btn.TextColor3 = theme.Text
        end
    end

    for _, child in ipairs(mainTabContent:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = theme.Button
            child.TextColor3 = theme.Text
        elseif child:IsA("TextLabel") then
            child.TextColor3 = theme.Text
        end
    end

    for _, child in ipairs(settingTabContent:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = theme.Button
            child.TextColor3 = theme.Text
        elseif child:IsA("TextLabel") then
            child.TextColor3 = theme.Text
        end
    end

    closeBtn.BackgroundColor3 = theme.Button
    closeBtn.TextColor3 = theme.Text

    seedShopBtn.BackgroundColor3 = theme.Button
    seedShopBtn.TextColor3 = theme.Text

    gearShopBtn.BackgroundColor3 = theme.Button
    gearShopBtn.TextColor3 = theme.Text
end

-- Setting Title
local settingTitle = Instance.new("TextLabel", settingTabContent)
settingTitle.Size = UDim2.new(1, 0, 0, 30
