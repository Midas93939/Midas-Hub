local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local folders = workspace:WaitForChild("GAMEFOLDERS", 10)
local customersFolder = folders:WaitForChild("Customers"):WaitForChild("Alive")
local npcFolder = folders:WaitForChild("NPCs")
local meleeEvent = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("MeleeHitEvent")

local isRunning = false
local attackSpeed = 0.1
local selectedTargets = {["None"] = true} 

local targetList = {
    "None", "Cop", "Poor Customer", "Normal Customer", 
    "Rich Customer", "Gold Customer", "Diamond Customer", "Special Customer"
}


local Window = WindUI:CreateWindow({
    Title = "Midas Hub",
    Author = "By Midas93939",
    Folder = "Midas Hub",
    Icon = "solar:folder-2-bold-duotone",
    Transparency = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac", 
    },
    OpenButton = {
        Enabled = true,
        Draggable = true,
        Title = "Open Midas Hub",
        CornerRadius = UDim.new(1, 0),
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))
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

            if name == "Cop" then
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
local HelpTab = Window:Tab({ Title = "Help", Icon = "solar:help-bold" })


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

HelpTab:Section({ Title = "Instructions" })
HelpTab:Paragraph({ 
    Title = "Usage Guide", 
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
