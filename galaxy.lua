-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ตัวแปรและบริการที่ใช้
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local buyGearStock = gameEvents:WaitForChild("BuyGearStock")
local buySeedStock = gameEvents:WaitForChild("BuySeedStock")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PlayerXGalaxyUI"
screenGui.ResetOnSpawn = false

-- ปุ่มเปิด/ปิด UI (เล็ก ๆ ด้านข้าง)
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0.5, -20)
toggleButton.Text = "🛒"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 24
Instance.new("UICorner", toggleButton)

-- หน้าต่างหลัก UI
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 320, 0, 160)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = true
mainFrame.Active = true
Instance.new("UICorner", mainFrame)

-- ชื่อหัวข้อใหญ่
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 Galaxy Main"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 26

-- ปุ่ม Auto Seed
local autoSeedBtn = Instance.new("TextButton", mainFrame)
autoSeedBtn.Size = UDim2.new(0.9, 0, 0, 45)
autoSeedBtn.Position = UDim2.new(0.05, 0, 0, 50)
autoSeedBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- สีฟ้า
autoSeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoSeedBtn.Font = Enum.Font.GothamBold
autoSeedBtn.TextSize = 20
autoSeedBtn.Text = "🔁 Auto Seed [OFF]"
Instance.new("UICorner", autoSeedBtn)

-- ปุ่ม Auto Gear
local autoGearBtn = Instance.new("TextButton", mainFrame)
autoGearBtn.Size = UDim2.new(0.9, 0, 0, 45)
autoGearBtn.Position = UDim2.new(0.05, 0, 0, 105)
autoGearBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 70) -- สีแดง
autoGearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGearBtn.Font = Enum.Font.GothamBold
autoGearBtn.TextSize = 20
autoGearBtn.Text = "🔁 Auto Gear [OFF]"
Instance.new("UICorner", autoGearBtn)

-- ตัวแปรสถานะ Auto Seed / Gear
local autoSeed = false
local autoGear = false

-- รายการเมล็ดและเกียร์
local seedList = {
    "Feijoa", "Banana", "Avocado", "Green Apple", "Watermelon",
    "Cauliflower", "Loquat", "Prickly Pear", "Bell Pepper", "Kiwi",
    "Pineapple", "Sugar Apple"
}

local gearList = {
    "Watering Can", "Basic Sprinkler", "Advanced Sprinkler",
    "Godly Sprinkler", "Tanning Mirror", "Master Sprinkler", "Friendship Pot"
}

-- สั่งซื้อเมล็ดพันธุ์แบบออโต้
autoSeedBtn.MouseButton1Click:Connect(function()
    autoSeed = not autoSeed
    autoSeedBtn.Text = "🔁 Auto Seed " .. (autoSeed and "[ON]" or "[OFF]")

    if autoSeed then
        task.spawn(function()
            while autoSeed do
                for _, seedName in ipairs(seedList) do
                    buySeedStock:FireServer(seedName)
                    wait(1)
                end
                wait(5)
            end
        end)
    end
end)

-- สั่งซื้อเกียร์แบบออโต้
autoGearBtn.MouseButton1Click:Connect(function()
    autoGear = not autoGear
    autoGearBtn.Text = "🔁 Auto Gear " .. (autoGear and "[ON]" or "[OFF]")

    if autoGear then
        task.spawn(function()
            while autoGear do
                for _, gearName in ipairs(gearList) do
                    buyGearStock:FireServer(gearName)
                    wait(1)
                end
                wait(5)
            end
        end)
    end
end)

-- ปุ่มเปิด/ปิด UI หลัก
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ฟังก์ชันช่วยลาก UI รองรับเมาส์และมือถือ
local UserInputService = game:GetService("UserInputService")

local function enableDrag(guiObject)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        if dragging and input then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - guiObject.AbsoluteSize.X),
                startPos.Y.Scale,
                math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - guiObject.AbsoluteSize.Y)
            )
        end
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
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

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput then
            update(input)
        end
    end)
end

-- เปิดระบบลากสำหรับ mainFrame และ toggleButton
enableDrag(mainFrame)
enableDrag(toggleButton)
