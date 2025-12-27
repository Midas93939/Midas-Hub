local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local folders = workspace:WaitForChild("GAMEFOLDERS", 10)
local customersFolder = folders:WaitForChild("Customers"):WaitForChild("Alive")
local npcFolder = folders:WaitForChild("NPCs")
local swatFolder = npcFolder
local theifFolder = npcFolder
local meleeEvent = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("MeleeHitEvent")

local isRunning = false
local attackSpeed = 0.1
local selectedTargets = {["None"] = true} 

local targetList = {
    "None", "Cop", "SWAT", "Poor Customer", "Normal Customer", 
    "Thief", "Rich Customer", "Gold Customer", "Diamond Customer", 
    "Special Customer", "Void Customer", "Rainbow Customer"
}

local Window = WindUI:CreateWindow({
    Title = "Midas Hub",
    Author = "Normal Edition",
    Folder = "Midas Hub",
    Icon = "rbxassetid://71502652708228",
    Transparency = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac", 
    },
    OpenButton = {
        Enabled = true,
        Draggable = true,
        Title = "Midas Hub",
        CornerRadius = UDim.new(1, 0),
        Color = ColorSequence.new(Color3.fromHex("#0195FF"), Color3.fromHex("#9500FF"))
    }
})

local function runAttack()
    while isRunning do
        if selectedTargets["None"] then 
            task.wait(0.5)
            continue 
        end

        for name, enabled in pairs(selectedTargets) do
            if not isRunning or selectedTargets["None"] then break end
            if not enabled then continue end

          
            if name == "SWAT" and swatFolder then
                for _, swat in pairs(swatFolder:GetChildren()) do
                    if swat:FindFirstChild("HeadHitbox") then
                        meleeEvent:FireServer(
                            swat.HeadHitbox, 
                            swat.HeadHitbox.Position, 
                            Vector3.new(0.338, -0.005, 0.940), 
                            20
                        )
                    end
                end

           elseif name == "Thief" then
                for _, npc in pairs(npcFolder:GetChildren()) do
                    if npc.Name == "Thief" and npc:FindFirstChild("Head") then
                        meleeEvent:FireServer(npc.HeadHitbox, npc.HeadHitbox.Position, Vector3.new(0.53, 0, -0.84), 20)
                    end
                end

            elseif name == "Cop" then
                for _, npc in pairs(npcFolder:GetChildren()) do
                    if npc.Name == "Cop" and npc:FindFirstChild("HeadHitbox") then
                        meleeEvent:FireServer(npc.HeadHitbox, npc.HeadHitbox.Position, Vector3.new(0.53, 0, -0.84), 20)
                    end
                end
           
            else
                for _, customer in pairs(customersFolder:GetChildren()) do
                    if customer.Name == name and customer:FindFirstChild("HumanoidRootPart") then
                        meleeEvent:FireServer(customer.HumanoidRootPart, customer.HumanoidRootPart.Position, Vector3.new(0, 0, 0), 20)
                    end
                end
            end
        end
        task.wait(attackSpeed)
    end
end

local MainTab = Window:Tab({ Title = "Farming", Icon = "solar:home-2-bold" })
local BuyTab = Window:Tab({ Title = "Buy", Icon = "solar:cart-large-2-bold" })
local HacksTab = Window:Tab({ Title = "Hacks", Icon = "solar:code-bold" })
local HelpTab = Window:Tab({ Title = "Info", Icon = "solar:help-bold" })
MainTab:Section({ Title = "Master Control" })

MainTab:Toggle({
    Title = "Enable Auto-Farm",
    Value = false,
    Callback = function(state)
        isRunning = state
        if isRunning then task.spawn(runAttack) end
    end
})

MainTab:Slider({
    Title = "Attack Delay",
    Value = {Min = 0.05, Max = 5, Default = 0.05},
    Callback = function(val) attackSpeed = val end
})

MainTab:Section({ Title = "Target Selection" })
local TargetDropdown
TargetDropdown = MainTab:Dropdown({
    Title = "Choose Targets",
    Multi = true,
    Values = targetList,
    Callback = function(options)
        local selectedNone = false
        for _, val in pairs(options) do
            if (type(val) == "table" and val.Title == "None") or val == "None" then
                selectedNone = true; break
            end
        end

        if selectedNone then
            selectedTargets = {["None"] = true}
            TargetDropdown:Set({"None"}) 
        else
            selectedTargets = {}
            for _, val in pairs(options) do
                local name = type(val) == "table" and val.Title or val
                selectedTargets[name] = true
            end
        end
    end
})

BuyTab:Section({ Title = "Gun" })

BuyTab:Button({ 
    Title = "Buy Revolver", 
    Justify = "Center", 
    Callback = function() 
        local args = {
	"Revolver"
}
game:GetService("ReplicatedStorage"):WaitForChild("Network.Blackmarket_BuyGunRequest"):FireServer(unpack(args))
    end 
})

BuyTab:Button({ 
    Title = "Buy Rifle", 
    Justify = "Center", 
    Callback = function() 
        local args = {
	"Rifle"
}
game:GetService("ReplicatedStorage"):WaitForChild("Network.Blackmarket_BuyGunRequest"):FireServer(unpack(args))
    end 
})

BuyTab:Button({ 
    Title = "Buy Shotgun", 
    Justify = "Center", 
    Callback = function() 
        local args = {
	"Shotgun"
}
game:GetService("ReplicatedStorage"):WaitForChild("Network.Blackmarket_BuyGunRequest"):FireServer(unpack(args))
    end 
})

BuyTab:Section({ Title = "Ammo" })

BuyTab:Button({ 
    Title = "Buy 6 Ammo", 
    Justify = "Center", 
    Callback = function() 
        local args = {
	"Pack of 6"
}
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Blackmarket_BuyAmmoRequest"):FireServer(unpack(args))
    end 
})

BuyTab:Button({ 
    Title = "Buy 12 Ammo", 
    Justify = "Center", 
    Callback = function() 
        local args = {
	"Pack of 12"
}
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Blackmarket_BuyAmmoRequest"):FireServer(unpack(args))
    end 
})

BuyTab:Button({ 
    Title = "Buy 24 Ammo", 
    Justify = "Center", 
    Callback = function() 
        local args = {
	"Pack of 24"
}
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Blackmarket_BuyAmmoRequest"):FireServer(unpack(args))
    end 
})

HacksTab:Section({ Title = "Inf defense" })

HacksTab:Button({ Title = "Inf Turret", Justify = "Center", Callback = function() WindUI:Notify({ Title = "Midas Hub", Content = "This function requires Midas Hub Premuim", Type = "Success", Duration = 3 }) end })

-- --- Help Tab ---

HelpTab:Section({ Title = "What’s New" })
HelpTab:Paragraph({ 
    Title = "Updates", 
    Desc = "1. Added SWAT, Thief, Void Customer, Rainbow Customer" 
})

HelpTab:Section({ Title = "What’s Upcoming" })
HelpTab:Paragraph({ 
    Title = "Upcoming Updates", 
    Desc = "1.Auto Make Burger May or May not come.\n2. Auto Buy will come" 
})


HelpTab:Section({ Title = "Information" })
HelpTab:Paragraph({ 
    Title = "Upcoming Updates", 
    Desc = "1. Use the dropdown to select specific NPCs.\n2. Selecting 'None' resets your selection.\n3. Adjust speed and toggle the Master Switch." 
})

HelpTab:Section({ Title = "Troubleshooting" })
HelpTab:Paragraph({ 
    Title = "Not Attacking?", 
    Desc = "Ensure 'None' is unchecked and the toggle is ON. If the game updates, the folder paths might change." 
})
HelpTab:Paragraph({ 
    Title = "UI Lag", 
    Desc = "If the UI is slow, increase the Attack Delay to reduce the loop frequency." 
})

HelpTab:Section({ Title = "Credits" })
HelpTab:Paragraph({ Title = "Developer", Desc = "Midas93939" })


HelpTab:Section({ Title = "Danger Zone" })
HelpTab:Button({ 
    Title = "Close & Destroy UI", 
    Justify = "Center", 
    Callback = function() 
        Window:Destroy() 
    end 
})
