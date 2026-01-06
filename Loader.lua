local StarterGui = game:GetService("StarterGui")

-- Configuration: [ID] = "GitHub Raw Link"
local gameScripts = {
    [7498898979]     = "https://raw.githubusercontent.com/aserbadawy-cloud/Midas93939/refs/heads/main/Premium.lua", -- Added your new ID
    [9098443082]      = "https://raw.githubusercontent.com/User/Repo/main/script2.lua"
}

-- Function to show an on-screen notification
local function notify(title, text)
    local success = false
    local retryCount = 0
    -- Try to send the notification until the game is loaded enough to show it
    repeat
        success = pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title;
                Text = text;
                Duration = 7;
            })
        end)
        if not success then 
            task.wait(0.5) 
            retryCount = retryCount + 1
        end
    until success or retryCount > 10
end

-- Check both PlaceId and GameId to bypass "hidden" place issues
local currentPlaceId = game.PlaceId
local currentUniverseId = game.GameId

local scriptToLoad = gameScripts[currentPlaceId] or gameScripts[currentUniverseId]

if scriptToLoad then
    notify("System", "Supported Game Detected! Loading...")
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptToLoad))()
    end)

    if not success then
        notify("Error", "Failed to execute. Check F9 console.")
        warn("Loadstring Error: " .. tostring(result))
    end
else
    -- If it fails, this message helps you find the ID to add to the script
    notify("Not Configured", "Place: " .. tostring(currentPlaceId) .. " | Uni: " .. tostring(currentUniverseId))
end
