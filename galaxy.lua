local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Anti-AFK (สลับคลิกซ้ายขวา เว้นเวลารอสุ่ม)
local toggleClick = true
spawn(function()
    while true do
        wait(math.random(50, 70))
        VirtualUser:CaptureController()
        if toggleClick then
            VirtualUser:ClickButton1(Vector2.new())
        else
            VirtualUser:ClickButton2(Vector2.new())
        end
        toggleClick = not toggleClick
    end
end)

player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new())
end)

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AutoBuyGui"

-- สร้าง Frame หลัก
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 280, 0, 230)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0,0)
frame.ClipsDescendants = true

-- Shadow Effect (เบื้องหลัง)
local shadow = Instance.new("Frame", frame)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.AnchorPoint = Vector2.new(0, 0)
shadow.BackgroundTransparency = 0.7
shadow.Name = "Shadow"

local function roundify(guiObject, radius)
    local corner = Instance.new("UICorner", guiObject)
    corner.CornerRadius = UDim.new(0, radius)
end
roundify(frame, 14)
roundify(shadow, 14)

-- ชื่อหัวข้อ
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "🔥 PlayerX Galaxy Auto Buy 🔥"
title.TextColor3 = Color3.fromRGB(255, 180, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.RichText = true
title.AnchorPoint = Vector2.new(0.5, 0)
title.Position = UDim2.new(0.5, 0, 0, 7)
title.TextStrokeColor3 = Color3.new(0,0,0)
title.TextStrokeTransparency = 0.5

-- ฟังก์ชันสร้างปุ่มเท่ๆ พร้อมสถานะเปิด/ปิด และ glow effect
local function createCoolButton(parent, text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 45)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.TextColor3 = Color3.fromRGB(255, 170, 50)
    btn.AutoButtonColor = false
    btn.Parent = parent
    btn.ClipsDescendants = true

    -- มุมโค้ง
    local uicorner = Instance.new("UICorner", btn)
    uicorner.CornerRadius = UDim.new(0, 10)

    -- เงาเรืองแสง (Glow) รอบปุ่ม
    local glow = Instance.new("ImageLabel", btn)
    glow.Size = UDim2.new(1.4, 0, 1.4, 0)
    glow.Position = UDim2.new(-0.2, 0, -0.2, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://3570695787" -- circle gradient blur
    glow.ImageColor3 = Color3.fromRGB(255, 140, 0)
    glow.ImageTransparency = 0.85
    glow.ZIndex = btn.ZIndex - 1

    -- สถานะเปิด/ปิด
    btn._active = false
    function btn:SetActive(active)
        btn._active = active
        if active then
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 140, 0), TextColor3 = Color3.new(0,0,0)}):Play()
            TweenService:Create(glow, TweenInfo.new(0.3), {ImageTransparency = 0.3}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(255, 170, 50)}):Play()
            TweenService:Create(glow, TweenInfo.new(0.3), {ImageTransparency = 0.85}):Play()
        end
    end

    -- เอฟเฟกต์ hover เฉพาะเมื่อปิดอยู่
    btn.MouseEnter:Connect(function()
        if not btn._active then
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 140, 0), TextColor3 = Color3.new(0,0,0)}):Play()
            TweenService:Create(glow, TweenInfo.new(0.3), {ImageTransparency = 0.3}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not btn._active then
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(255, 170, 50)}):Play()
            TweenService:Create(glow, TweenInfo.new(0.3), {ImageTransparency = 0.85}):Play()
        end
    end)

    -- เริ่มต้นสถานะปิด
    btn:SetActive(false)

    return btn
end

local btnSeeds = createCoolButton(frame, "Start Auto Buy Seeds", 65)
local btnGears = createCoolButton(frame, "Start Auto Buy Gears", 120)
local btnEggs = createCoolButton(frame, "Start Auto Buy Pet Eggs", 175)

local toggleUiBtn = Instance.new("TextButton", screenGui)
toggleUiBtn.Size = UDim2.new(0, 120, 0, 35)
toggleUiBtn.Position = UDim2.new(0, 20, 0, 265)
toggleUiBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleUiBtn.TextColor3 = Color3.fromRGB(255, 170, 50)
toggleUiBtn.Font = Enum.Font.GothamBold
toggleUiBtn.TextSize = 20
toggleUiBtn.Text = "Hide UI"
toggleUiBtn.AutoButtonColor = false
roundify(toggleUiBtn, 10)

toggleUiBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleUiBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 140, 0), TextColor3 = Color3.new(0,0,0)}):Play()
end)
toggleUiBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleUiBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(255, 170, 50)}):Play()
end)

-- ข้อมูลซื้อ
local gears = {
    "Watering Can",
    "Basic Sprinkler",
    "Advanced Sprinkler",
    "Godly Sprinkler",
    "Tanning Mirror",
    "Master Sprinkler",
    "Friendship Pot"
}

local seeds = {
    "Feijoa",
    "Banana",
    "Avocado",
    "Green Apple",
    "Watermelon",
    "Cauliflower",
    "Loquat",
    "Prickly Pear",
    "Bell Pepper",
    "Kiwi",
    "Pineapple",
    "Sugar Apple"
}

local petEggIndexes = {1, 2, 3}

local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local buyGearStock = gameEvents:WaitForChild("BuyGearStock")
local buySeedStock = gameEvents:WaitForChild("BuySeedStock")
local buyPetEgg = gameEvents:WaitForChild("BuyPetEgg")

local states = {
    seeds = false,
    gears = false,
    eggs = false
}

local function autoBuyLoop(list, event, isIndex)
    while states[event] do
        for _, item in ipairs(list) do
            if isIndex then
                event:FireServer(item)
            else
                event:FireServer(tostring(item))
            end
            wait(0.5)
            if not states[event] then break end
        end
        wait(5)
    end
end

btnSeeds.MouseButton1Click:Connect(function()
    states.seeds = not states.seeds
    btnSeeds.Text = states.seeds and "Stop Auto Buy Seeds" or "Start Auto Buy Seeds"
    btnSeeds:SetActive(states.seeds)
    if states.seeds then
        spawn(function() autoBuyLoop(seeds, buySeedStock, false) end)
    end
end)

btnGears.MouseButton1Click:Connect(function()
    states.gears = not states.gears
    btnGears.Text = states.gears and "Stop Auto Buy Gears" or "Start Auto Buy Gears"
    btnGears:SetActive(states.gears)
    if states.gears then
        spawn(function() autoBuyLoop(gears, buyGearStock, false) end)
    end
end)

btnEggs.MouseButton1Click:Connect(function()
    states.eggs = not states.eggs
    btnEggs.Text = states.eggs and "Stop Auto Buy Pet Eggs" or "Start Auto Buy Pet Eggs"
    btnEggs:SetActive(states.eggs)
    if states.eggs then
        spawn(function() autoBuyLoop(petEggIndexes, buyPetEgg, true) end)
    end
end)

local uiVisible = true
toggleUiBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    frame.Visible = uiVisible
    toggleUiBtn.Text = uiVisible and "Hide UI" or "Show UI"
end)

-- ฟังก์ชันทำให้ Frame ขยับได้โดยลากเมาส์ (ลากจาก title)
local function makeDraggable(guiObject, dragArea)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        guiObject.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(frame, title)
