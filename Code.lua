
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()


local folders = workspace:WaitForChild("GAMEFOLDERS", 10)
local customersFolder = folders:WaitForChild("Customers"):WaitForChild("Alive")
local npcFolder = folders:WaitForChild("NPCs")
local meleeEvent = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("MeleeHitEvent")


local isRunning = false
local attackSpeed = 0.1
local targetNames = {
    ["Poor Customer"] = true, ["Normal Customer"] = true, ["Rich Customer"] = true,
    ["Gold Customer"] = true, ["Diamond Customer"] = true, ["Special Customer"] = true
}


local Window = WindUI:CreateWindow({
    Title = "Midas Hub",
    Author = "by Midas93939",
    Folder = "MidasMacConfig",
    Icon = "solar:folder-2-bold-duotone",
    Transparency = true, -- Adds that clean Mac-like glass feel
    
    
    Topbar = {
        Height = 44,
        ButtonsType = "Mac", -- Changes minimize/close buttons to Mac dots
    },
    
    OpenButton = {
        Enabled = true,
        Draggable = true,
        Title = "Open Midas Hub",
        CornerRadius = UDim.new(1, 0), -- Circular Mac-style button
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))
    }
})


local function runAttack()
    while isRunning do
        
        for _, npc in pairs(npcFolder:GetChildren()) do
            if not isRunning then break end
            if npc.Name == "Cop" and npc:FindFirstChild("HeadHitbox") then
                local hitbox = npc.HeadHitbox
                -- Using your specific args for the Cop hit
                meleeEvent:FireServer(
                    hitbox, 
                    hitbox.Position, 
                    Vector3.new(0.533, 0, -0.845), 
                    20
                )
            end
        end

        
        for _, customer in pairs(customersFolder:GetChildren()) do
            if not isRunning then break end
            if targetNames[customer.Name] and customer:FindFirstChild("HumanoidRootPart") then
                local root = customer.HumanoidRootPart
                meleeEvent:FireServer(
                    root, 
                    root.Position, 
                    Vector3.new(0, 0, 0), 
                    20
                )
            end
        end
        task.wait(attackSpeed)
    end
end


local MainTab = Window:Tab({ 
    Title = "Farming", 
    Icon = "solar:home-2-bold",
    Border = true 
})

MainTab:Section({ Title = "Combat Controls" })

MainTab:Toggle({
    Title = "Auto-Farm Enabled",
    Desc = "Target all Cops and Customers",
    Value = false,
    Callback = function(state)
        isRunning = state
        if isRunning then 
            task.spawn(runAttack) 
            WindUI:Notify({ Title = "Midas Hub", Content = "Farm Started", Type = "Success" })
        end
    end
})

MainTab:Slider({
    Title = "Attack Delay (Seconds)",
    Value = {Min = 0.05, Max = 5, Default = 0.1},
    Callback = function(val) attackSpeed = val end
})

local OtherTab = Window:Tab({ 
    Title = "Other", 
    Icon = "solar:info-square-bold",
    Border = true 
})

OtherTab:Button({
    Title = "Destroy UI",
    Justify = "Center",
    Callback = function() Window:Destroy() end
})
