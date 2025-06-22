local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Anti-AFK (แบบใหม่)
spawn(function()
	while true do
		wait(math.random(50, 70))
		VirtualUser:CaptureController()
		VirtualUser:ClickButton1(Vector2.new())
	end
end)

player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton1(Vector2.new())
end)

-- UI แบบเดิม
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GalaxyUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainUI"

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🌌 PlayerX Galaxy"
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local function makeButton(text, yPos)
	local btn = Instance.new("TextButton", mainFrame)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.Text = text
	btn.BorderSizePixel = 0
	return btn
end

-- ปุ่มเปิด/ปิด
local seedBtn = makeButton("Start Auto Seed", 40)
local gearBtn = makeButton("Start Auto Gear", 80)
local eggBtn = makeButton("Start Auto Egg", 120)

-- ปุ่มซ่อน UI
local toggleBtn = makeButton("Hide UI", 160)

-- ข้อมูล Gear / Seed / Egg
local gears = {
	"Watering Can", "Basic Sprinkler", "Advanced Sprinkler",
	"Godly Sprinkler", "Tanning Mirror", "Master Sprinkler", "Friendship Pot"
}
local seeds = {
	"Feijoa", "Banana", "Avocado", "Green Apple", "Watermelon", "Cauliflower",
	"Loquat", "Prickly Pear", "Bell Pepper", "Kiwi", "Pineapple", "Sugar Apple"
}
local eggs = {1, 2, 3}

local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local buyGearStock = gameEvents:WaitForChild("BuyGearStock")
local buySeedStock = gameEvents:WaitForChild("BuySeedStock")
local buyPetEgg = gameEvents:WaitForChild("BuyPetEgg")

-- ฟังก์ชันทำงานวนซื้อ
local state = { seed = false, gear = false, egg = false }

local function autoBuy(list, event, flagKey, isIndex)
	while state[flagKey] do
		for _, item in ipairs(list) do
			event:FireServer(isIndex and item or tostring(item))
			wait(0.5)
			if not state[flagKey] then break end
		end
		wait(3)
	end
end

-- ปุ่ม Seed
seedBtn.MouseButton1Click:Connect(function()
	state.seed = not state.seed
	seedBtn.Text = state.seed and "Stop Auto Seed" or "Start Auto Seed"
	seedBtn.BackgroundColor3 = state.seed and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
	if state.seed then spawn(function() autoBuy(seeds, buySeedStock, "seed", false) end) end
end)

-- ปุ่ม Gear
gearBtn.MouseButton1Click:Connect(function()
	state.gear = not state.gear
	gearBtn.Text = state.gear and "Stop Auto Gear" or "Start Auto Gear"
	gearBtn.BackgroundColor3 = state.gear and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
	if state.gear then spawn(function() autoBuy(gears, buyGearStock, "gear", false) end) end
end)

-- ปุ่ม Egg
eggBtn.MouseButton1Click:Connect(function()
	state.egg = not state.egg
	eggBtn.Text = state.egg and "Stop Auto Egg" or "Start Auto Egg"
	eggBtn.BackgroundColor3 = state.egg and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
	if state.egg then spawn(function() autoBuy(eggs, buyPetEgg, "egg", true) end) end
end)

-- ปุ่มซ่อน UI
local uiVisible = true
toggleBtn.MouseButton1Click:Connect(function()
	uiVisible = not uiVisible
	mainFrame.Visible = uiVisible
	toggleBtn.Text = uiVisible and "Hide UI" or "Show UI"
end)

-- ทำให้ UI ขยับได้
local function makeDraggable(gui, dragHandle)
	local dragging, dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(mainFrame, title)
