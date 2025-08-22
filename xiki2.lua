local cam = workspace.Camera
local plrs = game.Players
local plr = plrs.LocalPlayer
local uis = game:GetService("UserInputService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🟣 Xiki | Lucky Block BG",
    LoadingTitle = "Xiki UI",
    LoadingSubtitle = "Modern & Clean Design",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Xiki UI",
        FileName = "LuckyBlock"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

local CharTab = Window:CreateTab("Character", 4483362458)
local LuckyTab = Window:CreateTab("Lucky Blocks", 4483362458)
local TimeTab = Window:CreateTab("Clock Time", 4483362458)
local AdvTab = Window:CreateTab("Advanced", 4483362458)

-- Character Tab
CharTab:CreateSection("Movement")
CharTab:CreateSlider({Name="Walk Speed", Range={0,100}, Increment=1, CurrentValue=16, Tooltip="Изменяет скорость передвижения", Callback=function(v) end})
CharTab:CreateButton({Name="Reset Walk Speed", Callback=function() end})
CharTab:CreateSlider({Name="Jump Power", Range={0,1000}, Increment=1, CurrentValue=50, Tooltip="Изменяет силу прыжка", Callback=function(v) end})
CharTab:CreateButton({Name="Reset Jump Power", Callback=function() end})
CharTab:CreateToggle({Name="Infinite Jumps", CurrentValue=false, Tooltip="Позволяет прыгать бесконечно", Callback=function(v) end})

CharTab:CreateSection("Environment")
CharTab:CreateSlider({Name="Gravity", Range={0,1000}, Increment=1, CurrentValue=196, Tooltip="Меняет силу гравитации", Callback=function(v) end})
CharTab:CreateButton({Name="Reset Gravity", Callback=function() end})
CharTab:CreateSlider({Name="Field of View", Range={1,120}, Increment=1, CurrentValue=70, Tooltip="Меняет FOV камеры", Callback=function(v) end})
CharTab:CreateButton({Name="Reset FOV", Callback=function() end})

-- Lucky Blocks Tab
LuckyTab:CreateSection("Default Lucky Block 🟩")
LuckyTab:CreateButton({Name="Spawn", Callback=function() end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) end})

LuckyTab:CreateSection("Super Lucky Block 🟦")
LuckyTab:CreateButton({Name="Spawn", Callback=function() end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) end})

LuckyTab:CreateSection("Diamond Lucky Block 💎")
LuckyTab:CreateButton({Name="Spawn", Callback=function() end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) end})

LuckyTab:CreateSection("Rainbow Lucky Block 🌈")
LuckyTab:CreateButton({Name="Spawn", Callback=function() end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) end})

LuckyTab:CreateSection("Galaxy Lucky Block 🌌")
LuckyTab:CreateButton({Name="Spawn", Callback=function() end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) end})

-- Clock Time Tab
TimeTab:CreateButton({Name="Night", Callback=function() end})
TimeTab:CreateButton({Name="Day", Callback=function() end})
TimeTab:CreateButton({Name="Evening", Callback=function() end})
TimeTab:CreateButton({Name="Morning", Callback=function() end})

-- Advanced Tab
AdvTab:CreateSection("Weapons")
AdvTab:CreateButton({Name="Equip All Tools", Callback=function() end})
AdvTab:CreateButton({Name="Insane Damage (Best Swords)", Callback=function() end})

AdvTab:CreateSection("Combat")
AdvTab:CreateButton({Name="Kill All", Callback=function() end})
AdvTab:CreateToggle({Name="Kill Aura", CurrentValue=false, Callback=function(v) end})

AdvTab:CreateSection("Teleportation")
AdvTab:CreateDropdown({Name="Teleport to Player", Options=function() return {} end, Callback=function(v) end})
AdvTab:CreateButton({Name="Teleport All to Me", Callback=function() end})

AdvTab:CreateSection("Options")
AdvTab:CreateToggle({Name="Whitelist Friends", CurrentValue=false, Callback=function(v) end})
