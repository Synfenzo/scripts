local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("One Fruit", "DarkTheme")
local Tab = Window:NewTab("Main")

local AutoTrainSection = Tab:NewSection("Auto Train")
local FruitsSection = Tab:NewSection("Fruits")

local player = game.Players.LocalPlayer
local humanoid = player.Character.Humanoid

local function fireproximityprompt(Obj, Amount, Skip)
	if Obj.ClassName == "ProximityPrompt" then 
		Amount = Amount or 1
		local PromptTime = Obj.HoldDuration
		if Skip then 
			Obj.HoldDuration = 0
		end
		for i = 1, Amount do 
			Obj:InputHoldBegin()
			if not Skip then 
				wait(Obj.HoldDuration)
			end
			Obj:InputHoldEnd()
		end
		Obj.HoldDuration = PromptTime
	else 
		error("userdata<ProximityPrompt> expected")
	end
end

-- Define global variables to store the toggle states
getgenv().ToggleStrengthState = false
getgenv().ToggleDefenseState = false
getgenv().ToggleFruitState = false

getgenv().ToggleAutoFruitState = false

-- Create the toggles 
local autoStrengthToggle = AutoTrainSection:NewToggle("Auto Train Stength", "", function(state)
	getgenv().ToggleStrengthState = state
end)

local autoDefenceToggle = AutoTrainSection:NewToggle("Auto Train Defense", "", function(state)
	getgenv().ToggleDefenseState = state
end)

local autoFruitToggle = AutoTrainSection:NewToggle("Auto Train Fruit", "", function(state)
	getgenv().ToggleFruitState = state
end)

local autoFruitPickupToggle = FruitsSection:NewToggle("Auto Pick Up Fruits", "", function(state)
	getgenv().ToggleAutoFruitState = state
end)

-- Use RenderStepped to continuously check the toggle states
game:GetService("RunService").RenderStepped:Connect(function()
	
	task.spawn(function()
		if getgenv().ToggleStrengthState then

			local toolName = "Combat"

			if player.Backpack:FindFirstChild(toolName) then
				humanoid:EquipTool(player.Backpack:FindFirstChild(toolName))
			elseif not player.Character:FindFirstChild(toolName) then
				return
			end

			local args = {
				[1] = {
					[1] = {
						[1] = "\4",
						[2] = "Combat",
						[3] = 2,
						[4] = false,
						[5] = player.Character:WaitForChild(toolName),
						[6] = "Melee"
					}
				}
			}

			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
		end
	end)

	task.spawn(function()
		if getgenv().ToggleDefenseState then

			local toolName = "Defence"

			if player.Backpack:FindFirstChild(toolName) then
				humanoid:EquipTool(player.Backpack:FindFirstChild(toolName))
			elseif not player.Character:FindFirstChild(toolName) then
				return
			end

			local args = {
				[1] = {
					[1] = {
						[1] = "\4",
						[2] = "Defence",
						[3] = player.Character:WaitForChild(toolName),
						[4] = "Defence"
					}
				}
			}

			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
		end
	end)
	
	task.spawn(function()
		if getgenv().ToggleFruitState then

			local toolName
			
			for i, fruit in pairs(player.Backpack:GetChildren()) do
				if fruit:GetAttribute("Type") == "Fruit" then
					toolName = fruit.Name
				end
			end
			
			for i, fruit in pairs(player.Character:GetChildren()) do
				if fruit:GetAttribute("Type") == "Fruit" then
					toolName = fruit.Name
				end
			end
			
			if not toolName then
				return
			end

			if player.Backpack:FindFirstChild(toolName) then
				humanoid:EquipTool(player.Backpack:FindFirstChild(toolName))
			elseif not player.Character:FindFirstChild(toolName) then
				return
			end

			local args = {
				[1] = {
					[1] = {
						[1] = "\4",
						[2] = "Combat",
						[3] = 3,
						[4] = false,
						[5] = player.Character:WaitForChild(toolName),
						[6] = "Fruit"
					}
				}
			}

			game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

		end
	end)
end)

task.spawn(function()
	while wait() do
		if getgenv().ToggleAutoFruitState then

			local originalPosition = player.Character.HumanoidRootPart.CFrame

			for i, fruit in pairs(workspace:GetChildren()) do
				if fruit:IsA("Tool") then
					player.Character:PivotTo(fruit.Handle.CFrame)
					wait(1)
					player.Character:PivotTo(originalPosition)
				elseif fruit:FindFirstChild("Eat") then
					player.Character:PivotTo(fruit.PrimaryPart.CFrame)
					wait(1)
					fireproximityprompt(fruit:FindFirstChild("Eat"), 1, true)
					wait(1)
					player.Character:PivotTo(originalPosition)
				end
			end
		end
	end
end)