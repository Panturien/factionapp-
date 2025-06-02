Installation
1.Install the sql

2.Please add this to the LB-Phone config.

Config.CustomApps = { ["factionapp"] = { -- Unique identifier (must match the resource name) name = "Faction App", -- App name in the phone description = "Manage your faction, send messages, and set MOTDs.", -- Description developer = "Name Here", -- OPTIONAL: Developer name defaultApp = true, -- Automatically installed (no download required) game = false, -- Not a game, but a tool icon = "https://cfx-nui-" .. GetCurrentResourceName() .. "/ui/icon.png", -- Path to the app icon ui = "factionapp/ui/index.html", -- Path to the UI (if you have a custom HTML UI) price = 0, -- Free landscape = false, -- Portrait mode keepOpen = true, -- App stays open (important for NUI interactions) onUse = function() -- Client-side function when opening -- Optional: Add logic here, e.g., load data --print("Faction App opened!") end, onServerUse = function(source) -- Server-side function when opening -- Optional: Server logic (e.g., check permissions) --print("Player " .. source .. " opened the Faction App.") end } }
