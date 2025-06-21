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
toggleBtn.Size = UDim2.new(0, 170, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "🌸 เปิด/ปิด UI"
toggleBtn.TextColor3 = Color3.fromRGB(80, 60, 90)
toggleBtn.Font = Enum.Font.FredokaOne
toggleBtn.TextSize = 20
toggleBtn.AutoButtonColor = false
roundify(toggleBtn, 20)

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 570, 0, 360)
mainFrame.Position = UDim2.new(0.5, -285, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 228, 241)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
roundify(mainFrame, 25)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
header.BorderSizePixel = 0
roundify(header, 25)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌸 Player x Galaxy V1.6"
title.Font = Enum.Font.FredokaOne
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(120, 40, 80)
title.TextStrokeTransparency = 0.4
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Tab Buttons
local tabButtonsFrame = Instance.new("Frame", mainFrame)
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 45)
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 60)
tabButtonsFrame.BackgroundTransparency = 1

local function createTabButton(name, parent, xOffset)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.Position = UDim2.new(0, xOffset or 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(140, 50, 90)
    btn.AutoButtonColor = false
    roundify(btn, 18)
    return btn
end

local mainTabBtn = createTabButton("Main", tabButtonsFrame, 0)

-- Tab Content Frames
local tabContentFrame = Instance.new("Frame", mainFrame)
tabContentFrame.Size = UDim2.new(1, -40, 1, -120)
tabContentFrame.Position = UDim2.new(0, 20, 0, 110)
tabContentFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
tabContentFrame.BorderSizePixel = 0
roundify(tabContentFrame, 20)

-- Main Tab Content
local mainTabContent = Instance.new("Frame", tabContentFrame)
mainTabContent.Size = UDim2.new(1, 0, 1, 0)
mainTabContent.BackgroundTransparency = 1

local mainLabel = Instance.new("TextLabel", mainTabContent)
mainLabel.Size = UDim2.new(1, 0, 0, 30)
mainLabel.Position = UDim2.new(0, 0, 0, 0)
mainLabel.BackgroundTransparency = 1
mainLabel.Text = "ยินดีต้อนรับสู่แท็บ Main! 💖"
mainLabel.Font = Enum.Font.FredokaOne
mainLabel.TextSize = 20
mainLabel.TextColor3 = Color3.fromRGB(140, 50, 90)
mainLabel.TextStrokeTransparency = 0.4
mainLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

-- Create Toggle Buttons Function
local function createToggleButton(parent, posY, label)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(0, 180, 0, 45)
    toggle.Position = UDim2.new(0, 10, 0, posY)
    toggle.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    toggle.BorderSizePixel = 0
    toggle.TextColor3 = Color3.fromRGB(140, 50, 90)
    toggle.Font = Enum.Font.FredokaOne
    toggle.TextSize = 18
    toggle.AutoButtonColor = false
    roundify(toggle, 18)
    toggle.Text = "❌ " .. label .. ": OFF"
    return toggle
end

-- Auto Seed
local seeds = {"Sugar Apple","Ember Lily","Beanstalk","Cacao","Pepper","Mushroom","Grape"}
local isAutoSeedOn = false
local autoSeedCoroutine
local function buySeedsLoop()
    while isAutoSeedOn do
        for _, seed in ipairs(seeds) do
            if not isAutoSeedOn then break end
            if BuySeedStock then BuySeedStock:FireServer(seed) end
            wait(0.5)
        end
        wait(1)
    end
end

local autoSeedToggle = createToggleButton(mainTabContent, 60, "Auto Seed 🌱")
autoSeedToggle.MouseButton1Click:Connect(function()
    isAutoSeedOn = not isAutoSeedOn
    if isAutoSeedOn then
        autoSeedToggle.Text = "✅ Auto Seed 🌱: ON"
        autoSeedToggle.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        autoSeedCoroutine = coroutine.create(buySeedsLoop)
        coroutine.resume(autoSeedCoroutine)
    else
        autoSeedToggle.Text = "❌ Auto Seed 🌱: OFF"
        autoSeedToggle.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    end
end)

-- Auto Sprinkler
local gears = {"Basic Sprinkler","Advanced Sprinkler","Godly Sprinkler","Lightning Rod","Master Sprinkler"}
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

local autoSprinklerToggle = createToggleButton(mainTabContent, 120, "Auto Sprinkler 🚿🌩️")
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

-- Label ร้านค้า
local shopLabel = Instance.new("TextLabel", mainTabContent)
shopLabel.Size = UDim2.new(1, -20, 0, 30)
shopLabel.Position = UDim2.new(0, 10, 0, 190)
shopLabel.BackgroundTransparency = 1
shopLabel.Text = "🛒 ร้านค้า"
shopLabel.Font = Enum.Font.FredokaOne
shopLabel.TextSize = 24
shopLabel.TextColor3 = Color3.fromRGB(140, 50, 90)
shopLabel.TextStrokeTransparency = 0.4
shopLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
shopLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่ม Seed Shop
local seedShopBtn = Instance.new("TextButton", mainTabContent)
seedShopBtn.Size = UDim2.new(0, 180, 0, 45)
seedShopBtn.Position = UDim2.new(0, 10, 0, 230)
seedShopBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
seedShopBtn.BorderSizePixel = 0
seedShopBtn.Text = "เปิด Seed Shop 🌱"
seedShopBtn.TextColor3 = Color3.fromRGB(140, 50, 90)
seedShopBtn.Font = Enum.Font.FredokaOne
seedShopBtn.TextSize = 20
seedShopBtn.AutoButtonColor = false
roundify(seedShopBtn, 18)

-- ปุ่ม Gear Shop
local gearShopBtn = Instance.new("TextButton", mainTabContent)
gearShopBtn.Size = UDim2.new(0, 180, 0, 45)
gearShopBtn.Position = UDim2.new(0, 10, 0, 285)
gearShopBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
gearShopBtn.BorderSizePixel = 0
gearShopBtn.Text = "เปิด Gear Shop ⚙️"
gearShopBtn.TextColor3 = Color3.fromRGB(140, 50, 90)
gearShopBtn.Font = Enum.Font.FredokaOne
gearShopBtn.TextSize = 20
gearShopBtn.AutoButtonColor = false
roundify(gearShopBtn, 18)

local playerGui = player:WaitForChild("PlayerGui")
local seedShopGui = playerGui:WaitForChild("Seed_Shop")
local gearShopGui = playerGui:WaitForChild("Gear_Shop")

-- ฟังก์ชัน Toggle เปิด/ปิด Seed Shop
seedShopBtn.MouseButton1Click:Connect(function()
    if seedShopGui.Enabled then
        seedShopGui.Enabled = false
        seedShopBtn.Text = "เปิด Seed Shop 🌱"
    else
        seedShopGui.Enabled = true
        seedShopBtn.Text = "ปิด Seed Shop 🌱"
        -- ปิด Gear Shop ถ้าเปิดอยู่
        if gearShopGui.Enabled then
            gearShopGui.Enabled = false
            gearShopBtn.Text = "เปิด Gear Shop ⚙️"
        end
    end
end)

-- ฟังก์ชัน Toggle เปิด/ปิด Gear Shop
gearShopBtn.MouseButton1Click:Connect(function()
    if gearShopGui.Enabled then
        gearShopGui.Enabled = false
        gearShopBtn.Text = "เปิด Gear Shop ⚙️"
    else
        gearShopGui.Enabled = true
        gearShopBtn.Text = "ปิด Gear Shop ⚙️"
        -- ปิด Seed Shop ถ้าเปิดอยู่
        if seedShopGui.Enabled then
            seedShopGui.Enabled = false
            seedShopBtn.Text = "เปิด Seed Shop 🌱"
        end
    end
end)

-- Close Button
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0,32,0,32)
closeBtn.Position = UDim2.new(1,-42,0,10)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,120,140)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.TextSize = 20
closeBtn.BorderSizePixel = 0
roundify(closeBtn, 10)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- Tab Switching (เฉพาะ Main)
local function showTab(name)
    for _, frame in ipairs(tabContentFrame:GetChildren()) do
        if frame:IsA("Frame") then frame.Visible = false end
    end
    if name == "Main" then mainTabContent.Visible = true end
end

mainTabBtn.MouseButton1Click:Connect(function() showTab("Main") end)
toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

-- Show default
showTab("Main")
