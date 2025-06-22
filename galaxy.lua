local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- UI สร้างใหม่ (กะทัดรัด)
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "GalaxyUICompact"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Position = UDim2.new(0.7, 0, 0.2, 0) -- ขยับไปมุมขวาบนเล็กน้อย
mainFrame.Size = UDim2.new(0, 220, 0, 220) -- กะทัดรัด
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "🌌 PlayerXGalaxy Compact"
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- ปุ่มเปิด/ปิด UI
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Position = UDim2.new(0, 10, 0, 10) -- มุมซ้ายบน
toggleBtn.Size = UDim2.new(0, 80, 0, 25)
toggleBtn.Text = "Hide UI"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
toggleBtn.AutoButtonColor = true

local uiVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    mainFrame.Visible = uiVisible
    if uiVisible then
        toggleBtn.Text = "Hide UI"
    else
        toggleBtn.Text = "Show UI"
    end
end)

-- รายการข้อมูล
local seedList = {
    "Feijoa", "Banana", "Avocado", "Green Apple", "Watermelon", "Cauliflower",
    "Loquat", "Prickly Pear", "Bell Pepper", "Kiwi", "Pineapple", "Sugar Apple"
}
local gearList = {
    "Watering Can", "Basic Sprinkler", "Advanced Sprinkler",
    "Master Sprinkler", "Tanning Mirror", "Godly Sprinkler"
}
local eggList = {
    "Common Egg", "Uncommon Egg", "Rare Egg", "Night Egg",
    "Rare Summer Egg", "Common Summer Egg", "Paradise Summer Egg",
    "Legendary Egg", "Bug Egg", "Mythical Egg"
}

local function createDropdown(parent, posY, labelText, itemList, onSelect)
    local dropdown = Instance.new("TextButton", parent)
    dropdown.Position = UDim2.new(0.05, 0, posY, 0)
    dropdown.Size = UDim2.new(0.9, 0, 0, 25)
    dropdown.Text = labelText .. ": " .. itemList[1]
    dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdown.TextColor3 = Color3.fromRGB(220, 220, 220)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 14

    local toggle = false
    local selectedItem = itemList[1]

    dropdown.MouseButton1Click:Connect(function()
        toggle = not toggle
        if toggle then
            for i, item in ipairs(itemList) do
                local btn = Instance.new("TextButton", parent)
                btn.Position = UDim2.new(0.05, 0, posY + (i * 0.07), 0)
                btn.Size = UDim2.new(0.9, 0, 0, 20)
                btn.Text = item
                btn.Name = labelText .. "_Item_" .. i
                btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 13
                btn.MouseButton1Click:Connect(function()
                    selectedItem = item
                    dropdown.Text = labelText .. ": " .. item
                    for _, c in ipairs(parent:GetChildren()) do
                        if c.Name:match("^" .. labelText .. "_Item_%d+") then
                            c:Destroy()
                        end
                    end
                    toggle = false
                    onSelect(item)
                end)
            end
        else
            for _, c in ipairs(parent:GetChildren()) do
                if c.Name:match("^" .. labelText .. "_Item_%d+") then
                    c:Destroy()
                end
            end
        end
    end)

    return dropdown, function() return selectedItem end
end

-- ตัวแปรเก็บค่าเลือก และสถานะ Auto
local selectedSeed = seedList[1]
local selectedGear = gearList[1]
local selectedEgg = eggList[1]

local autoSeed = false
local autoGear = false
local autoEgg = false

-- สร้าง Dropdown
local seedDropdown, _ = createDropdown(mainFrame, 0.12, "Seed", seedList, function(val) selectedSeed = val end)
local gearDropdown, _ = createDropdown(mainFrame, 0.38, "Gear", gearList, function(val) selectedGear = val end)
local eggDropdown, _ = createDropdown(mainFrame, 0.64, "Egg", eggList, function(val) selectedEgg = val end)

-- ปุ่ม Auto Seed
local seedBtn = Instance.new("TextButton", mainFrame)
seedBtn.Position = UDim2.new(0.05, 0, 0.30, 0)
seedBtn.Size = UDim2.new(0.9, 0, 0, 25)
seedBtn.Text = "✅ Auto Seed OFF"
seedBtn.Font = Enum.Font.Gotham
seedBtn.TextSize = 14
seedBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
seedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
seedBtn.MouseButton1Click:Connect(function()
    autoSeed = not autoSeed
    seedBtn.Text = autoSeed and "🛑 Auto Seed ON" or "✅ Auto Seed OFF"
end)

-- ปุ่ม Auto Gear
local gearBtn = Instance.new("TextButton", mainFrame)
gearBtn.Position = UDim2.new(0.05, 0, 0.56, 0)
gearBtn.Size = UDim2.new(0.9, 0, 0, 25)
gearBtn.Text = "✅ Auto Gear OFF"
gearBtn.Font = Enum.Font.Gotham
gearBtn.TextSize = 14
gearBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
gearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
gearBtn.MouseButton1Click:Connect(function()
    autoGear = not autoGear
    gearBtn.Text = autoGear and "🛑 Auto Gear ON" or "✅ Auto Gear OFF"
end)

-- ปุ่ม Auto Egg
local eggBtn = Instance.new("TextButton", mainFrame)
eggBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
eggBtn.Size = UDim2.new(0.9, 0, 0, 25)
eggBtn.Text = "✅ Auto Egg OFF"
eggBtn.Font = Enum.Font.Gotham
eggBtn.TextSize = 14
eggBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
eggBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
eggBtn.MouseButton1Click:Connect(function()
    autoEgg = not autoEgg
    eggBtn.Text = autoEgg and "🛑 Auto Egg ON" or "✅ Auto Egg OFF"
end)

-- ระบบลากหน้าต่างแบบละเอียด รองรับเมาส์และมือถือ
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Loop ซื้ออัตโนมัติ
task.spawn(function()
    while true do
        if autoSeed then
            ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(selectedSeed)
        end
        if autoGear then
            ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(selectedGear)
        end
        if autoEgg then
            ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyEggStock"):FireServer(selectedEgg)
        end
        wait(1)
    end
end)
