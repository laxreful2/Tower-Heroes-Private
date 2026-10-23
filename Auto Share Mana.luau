repeat
	task.wait()
until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local GAME_ID = 4870839149
local Players_In_Server = {}
local Player_To_Donate = nil
local Mana_To_Donate = nil
local Donate_Connection


if game.PlaceId ~= GAME_ID then
	WindUI:Notify({
		Title = "Not Correct Place",
		Content = "Please Join A  Game Before Executing This",
		Duration = 3,
	})
	return
end
local Remote = game:GetService("ReplicatedStorage").Events.ManaShare
local PlayerMana = Players.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Mana")

local function RefreshPlayersTable()
	Players_In_Server = {}
	for _, v in Players:GetChildren() do
		if v.Name == Players.LocalPlayer.Name then
			continue
		end
		table.insert(Players_In_Server, v.Name)
	end
end

RefreshPlayersTable()

local Window = WindUI:CreateWindow({
	Title = "Mana Auto Share",
	Icon = "door-open", 
	Author = "by Ripper", 
    ToggleKey = Enum.KeyCode.RightControl
})

local Tab = Window:Tab({
	Title = "Main",
	Icon = "house", -- optional
})

local Dropdown = Tab:Dropdown({
	Title = "Select Player To Donate",
	Values = Players_In_Server,
	Callback = function(selected)
		Player_To_Donate = selected
	end,
})


Tab:Input({
	Title = "Amount Of Mana To Donate At The Time",
	Callback = function(text)
		Mana_To_Donate = tonumber(text)
	end,
})

local Toggle
Toggle = Tab:Toggle({
	Title = "Start Donating",
	Callback = function(state)
		if not state then
			if Donate_Connection then
				Donate_Connection:Disconnect()
			end
			return
		end

		if state then
			if not Mana_To_Donate or typeof(Mana_To_Donate) ~= "number" then
				WindUI:Notify({
					Title = "No Amount Of Mana Chosed",
					Content = "Please Choose The Amount of Mana To Give Before Toggling This On",
					Duration = 3,
				})
				Toggle:Set(false)
				return
			end

			if not Player_To_Donate then
				WindUI:Notify({
					Title = "No Player Choosed",
					Content = "Please Choose A Player To Who Give Mana",
					Duration = 3,
				})
				Toggle:Set(false)
				return
			end

			Donate_Connection = RunService.Heartbeat:Connect(function()
				if PlayerMana.Value < Mana_To_Donate then
					return
				end
				Remote:FireServer(Player_To_Donate, Mana_To_Donate, true)
			end)
		end
	end,
})

Players.PlayerRemoving:Connect(function()
	RefreshPlayersTable()
	Dropdown:Refresh(Players_In_Server)
end)

Players.PlayerAdded:Connect(function()
	RefreshPlayersTable()
	Dropdown:Refresh(Players_In_Server)
end)


