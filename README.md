# factionapp
Faction App for LB-Phone  Stay connected with your faction at all times!

This LB-Phone app lets you view your faction, see who's currently online, and take immediate action like calling members or sending SMS texts. You can also post messages for all your faction members to see.

[no logo app has been added yet]



![icon](https://cdn.discordapp.com/attachments/1006228429869424829/1379221910633840751/Screenshot_2025-06-02_232009.png?ex=683f7400&is=683e2280&hm=a244dd6fe4c2cc4921b36fdaaaea4e4b8698b2fca7ce70cd81e005c2d7111444&)
![icon](https://cdn.discordapp.com/attachments/1006228429869424829/1379221911044624635/Screenshot_2025-06-02_232029.png?ex=683f7400&is=683e2280&hm=bbc493971a29421d05e16fa1039a7e8bf80e1b83be85536d44f0de22bb4d4e4a&)


# Installation

1. Install the sql

2.Please add this to the LB-Phone config.

Config.CustomApps = { ["factionapp"] = { -- Unique identifier (must match the resource name) name = "Faction App", -- App name in the phone description = "Manage your faction, send messages, and set MOTDs.", -- Description developer = "Name Here", -- OPTIONAL: Developer name defaultApp = true, -- Automatically installed (no download required) game = false, -- Not a game, but a tool icon = "https://cfx-nui-" .. GetCurrentResourceName() .. "/ui/icon.png", -- Path to the app icon ui = "factionapp/ui/index.html", -- Path to the UI (if you have a custom HTML UI) price = 0, -- Free landscape = false, -- Portrait mode keepOpen = true, -- App stays open (important for NUI interactions) onUse = function() -- Client-side function when opening -- Optional: Add logic here, e.g., load data --print("Faction App opened!") end, onServerUse = function(source) -- Server-side function when opening -- Optional: Server logic (e.g., check permissions) --print("Player " .. source .. " opened the Faction App.") end } }
