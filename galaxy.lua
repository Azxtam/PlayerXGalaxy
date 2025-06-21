-- 🌌 Player X Galaxy V1.8

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local buyGearStock = gameEvents:WaitForChild("BuyGearStock")
local buySeedStock = gameEvents:WaitForChild("BuySeedStock")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- 🛡️ Anti-AFK
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	wait(1)
	VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- 🖼️ สร้าง UI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkModeUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- ✨ หัว UI
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌌 Player X Galaxy V1.8"
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ❌ ปุ่มปิด
local closeButton = Instance.new("TextButton")
closeButton.Parent = mainFrame
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)
closeButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)

-- 🧲 Drag mainFrame
local draggingMain, dragInputMain, dragStartMain, startPosMain
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMain = true
		dragStartMain = input.Position
		startPosMain = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then draggingMain = false end
		end)
	end
end)
mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInputMain = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if draggingMain and input == dragInputMain then
		local delta = input.Position - dragStartMain
		mainFrame.Position = UDim2.new(
			startPosMain.X.Scale, startPosMain.X.Offset + delta.X,
			startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y
		)
	end
end)

-- 🔘 ปุ่ม Tab
local mainTabButton = Instance.new("TextButton")
mainTabButton.Size = UDim2.new(0, 90, 0, 30)
mainTabButton.Position = UDim2.new(0, 10, 0, 50)
mainTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainTabButton.Text = "Main"
mainTabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
mainTabButton.Font = Enum.Font.Gotham
mainTabButton.TextSize = 16
mainTabButton.Parent = mainFrame
Instance.new("UICorner", mainTabButton).CornerRadius = UDim.new(0, 6)

-- 📦 Main Tab Frame
local mainTabFrame = Instance.new("Frame")
mainTabFrame.Size = UDim2.new(1, -20, 1, -100)
mainTabFrame.Position = UDim2.new(0, 10, 0, 90)
mainTabFrame.BackgroundTransparency = 1
mainTabFrame.Parent = mainFrame
mainTabFrame.Visible = true

-- 🌱 Auto Seed
local autoSeed = false
local seeds = {
	"Feijoa", "Banana", "Avocado", "Green Apple", "Watermelon",
	"Cauliflower", "Loquat", "Prickly Pear", "Bell Pepper",
	"Kiwi", "Pineapple", "Sugar Apple"
}
local autoSeedBtn = Instance.new("TextButton")
autoSeedBtn.Size = UDim2.new(0, 200, 0, 40)
autoSeedBtn.Position = UDim2.new(0.5, -100, 0, 50)
autoSeedBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
autoSeedBtn.Text = "Auto Seed: OFF"
autoSeedBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
autoSeedBtn.Font = Enum.Font.GothamBold
autoSeedBtn.TextSize = 18
autoSeedBtn.Parent = mainTabFrame
Instance.new("UICorner", autoSeedBtn).CornerRadius = UDim.new(0, 8)

autoSeedBtn.MouseButton1Click:Connect(function()
	autoSeed = not autoSeed
	autoSeedBtn.Text = "Auto Seed: " .. (autoSeed and "ON" or "OFF")
	if autoSeed then
		task.spawn(function()
			while autoSeed do
				for _, seed in ipairs(seeds) do
					if not autoSeed then break end
					buySeedStock:FireServer(seed)
					wait(1)
				end
				wait(5)
			end
		end)
	end
end)

-- 🛠️ Auto Gear
local autoGear = false
local gears = {
	"Watering Can", "Basic Sprinkler", "Advanced Sprinkler",
	"Godly Sprinkler", "Tanning Mirror", "Master Sprinkler", "Friendship Pot"
}
local autoGearBtn = Instance.new("TextButton")
autoGearBtn.Size = UDim2.new(0, 200, 0, 40)
autoGearBtn.Position = UDim2.new(0.5, -100, 0, 100)
autoGearBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
autoGearBtn.Text = "Auto Gear: OFF"
autoGearBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
autoGearBtn.Font = Enum.Font.GothamBold
autoGearBtn.TextSize = 18
autoGearBtn.Parent = mainTabFrame
Instance.new("UICorner", autoGearBtn).CornerRadius = UDim.new(0, 8)

autoGearBtn.MouseButton1Click:Connect(function()
	autoGear = not autoGear
	autoGearBtn.Text = "Auto Gear: " .. (autoGear and "ON" or "OFF")
	if autoGear then
		task.spawn(function()
			while autoGear do
				for _, gear in ipairs(gears) do
					if not autoGear then break end
					buyGearStock:FireServer(gear)
					wait(1)
				end
				wait(5)
			end
		end)
	end
end)

-- 🌙 ปุ่ม Toggle UI (ดวงจันทร์ + ลากได้)
pcall(function() local old = playerGui:FindFirstChild("ToggleButton") if old then old:Destroy() end end)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.Image = "rbxassetid://6031094663"
toggleButton.ScaleType = Enum.ScaleType.Fit
toggleButton.ZIndex = 10
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 12)
toggleButton.Parent = playerGui

local dragging, dragInput, dragStart, startPos
toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = toggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
toggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		toggleButton.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
toggleButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = not screenGui.Enabled
end).new(0.5, -100, 0, 100)
autoGearButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
autoGearButton.Text = "Auto Gear: OFF"
autoGearButton.TextColor3 = Color3.fromRGB(220, 220, 220)
autoGearButton.Font = Enum.Font.GothamBold
autoGearButton.TextSize = 18
autoGearButton.Parent = mainTabFrame
Instance.new("UICorner", autoGearButton).CornerRadius = UDim.new(0, 8)

autoGearButton.MouseButton1Click:Connect(function()
	autoGear = not autoGear
	autoGearButton.Text = "Auto Gear: " .. (autoGear and "ON" or "OFF")

	if autoGear then
		task.spawn(function()
			while autoGear do
				for _, gearName in ipairs(gears) do
					if not autoGear then break end
					buyGearStock:FireServer(gearName)
					task.wait(1)
				end
			end
		end)
	end
end)

-- Show Main Tab
mainTabFrame.Visible = true
mainTabButton.MouseButton1Click:Connect(function()
	mainTabFrame.Visible = true
end)

-- Toggle Button (Moon Icon) พร้อมลากได้ (ปุ่มเปิด/ปิด UI)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = playerGui
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.Image = "rbxassetid://6031094663"  -- รูปดวงจันทร์
toggleButton.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 12)

local draggingToggle = false
local dragInputToggle
local dragStartToggle
local startPosToggle

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = toggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputToggle = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingToggle and input == dragInputToggle then
        local delta = input.Position - dragStartToggle
        toggleButton.Position = UDim2.new(
            startPosToggle.X.Scale,
            startPosToggle.X.Offset + delta.X,
            startPosToggle.Y.Scale,
            startPosToggle.Y.Offset + delta.Y
        )
    end
end)

toggleButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = not screenGui.Enabled
end)
