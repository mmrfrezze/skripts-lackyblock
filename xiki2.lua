-- Базовые сервисы
local cam = workspace.Camera
local plrs = game.Players
local plr = plrs.LocalPlayer
local replic = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

-- Переменные
local as_dlb, as_slb, as_rlb, as_dimlb, as_glb
local whitelistEn, infJump, aura
local auraRadius = 50

-- Лучшие мечи
local bestSwords = {
    "ChartreusePeriastron","IvoryPeriastron","SpectralSword","CrimsonPeriastron",
    "SpecOmegaBiograftEnergySword","DualSpecGammaBiograftEnergySword","RainbowPeriastron",
    "Illumina","DaggerOfShatteredDimensions","SpecZetaBiograftEnergySword",
    "SpecGammaBiograftEnergySword","Magician'sCloak","Ice Dragon Slaying Sword",
    "FireSword","CrescendoTheSoulStealer","FangOfTsuchigumo"
}

-- Функции
local function kill(target)
    local pHRP = target.Character.HumanoidRootPart
    local lastCF = plr.Character.HumanoidRootPart.CFrame
    for i = 1, 3 do
        plr.Character.HumanoidRootPart.CFrame = pHRP.CFrame * CFrame.new(0, 0, 1.1)
        task.wait()
    end
    task.wait(0.7)
    plr.Character.HumanoidRootPart.CFrame = lastCF
end

local function equipBest()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        for _, sword in pairs(bestSwords) do
            if tool.Name == sword then
                tool.Parent = plr.Character
            end
        end
    end
end

local function spawnBlock(event)
    replic[event]:FireServer(1)
end

-- Создание UI через Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🟣 Xiki Skripts | Lucky Block BG",
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

-- Вкладки
local CharTab = Window:CreateTab("Character", 4483362458)
local LuckyTab = Window:CreateTab("Lucky Blocks", 4483362458)
local TimeTab = Window:CreateTab("Clock Time", 4483362458)
local AdvTab = Window:CreateTab("Advanced", 4483362458)

-- Character Tab
CharTab:CreateSection("Movement")
CharTab:CreateSlider({Name="Walk Speed", Range={0,100}, Increment=1, CurrentValue=16, Callback=function(v) plr.Character.Humanoid.WalkSpeed=v end})
CharTab:CreateButton({Name="Reset Walk Speed", Callback=function() plr.Character.Humanoid.WalkSpeed=16 end})
CharTab:CreateSlider({Name="Jump Power", Range={0,1000}, Increment=1, CurrentValue=50, Callback=function(v) plr.Character.Humanoid.JumpPower=v end})
CharTab:CreateButton({Name="Reset Jump Power", Callback=function() plr.Character.Humanoid.JumpPower=50 end})
CharTab:CreateToggle({Name="Infinite Jumps", CurrentValue=false, Callback=function(v) 
    infJump=v 
    if v then 
        uis.JumpRequest:Connect(function() 
            if infJump then plr.Character.Humanoid:ChangeState("Jumping") end 
        end) 
    end 
end})

CharTab:CreateSection("Environment")
CharTab:CreateSlider({Name="Gravity", Range={0,1000}, Increment=1, CurrentValue=196, Callback=function(v) workspace.Gravity=v end})
CharTab:CreateButton({Name="Reset Gravity", Callback=function() workspace.Gravity=196 end})
CharTab:CreateSlider({Name="Field of View", Range={1,120}, Increment=1, CurrentValue=70, Callback=function(v) cam.FieldOfView=v end})
CharTab:CreateButton({Name="Reset FOV", Callback=function() cam.FieldOfView=70 end})

-- Lucky Blocks Tab
local blocks = {
    {Name="Default Lucky Block 🟩", Event="SpawnLuckyBlock", Var="as_dlb"},
    {Name="Super Lucky Block 🟦", Event="SpawnSuperBlock", Var="as_slb"},
    {Name="Diamond Lucky Block 💎", Event="SpawnDiamondBlock", Var="as_dimlb"},
    {Name="Rainbow Lucky Block 🌈", Event="SpawnRainbowBlock", Var="as_rlb"},
    {Name="Galaxy Lucky Block 🌌", Event="SpawnGalaxyBlock", Var="as_glb"}
}

for _, block in pairs(blocks) do
    LuckyTab:CreateSection(block.Name)
    LuckyTab:CreateButton({Name="Spawn", Callback=function() spawnBlock(block.Event) end})
    LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v)
        _G[block.Var] = v
        while _G[block.Var] do task.wait(0.1) spawnBlock(block.Event) end
    end})
end

-- Clock Time Tab
TimeTab:CreateButton({Name="Night", Callback=function() game.Lighting.ClockTime=0 end})
TimeTab:CreateButton({Name="Day", Callback=function() game.Lighting.ClockTime=12 end})
TimeTab:CreateButton({Name="Evening", Callback=function() game.Lighting.ClockTime=18 end})
TimeTab:CreateButton({Name="Morning", Callback=function() game.Lighting.ClockTime=6 end})

-- Advanced Tab
AdvTab:CreateSection("Weapons")
AdvTab:CreateButton({Name="Equip All Tools", Callback=function() for _, tool in pairs(plr.Backpack:GetChildren()) do tool.Parent=plr.Character task.wait() end end})
AdvTab:CreateButton({Name="Insane Damage (Best Swords)", Callback=function() equipBest() end})

AdvTab:CreateSection("Combat")
AdvTab:CreateButton({Name="Kill All", Callback=function()
    equipBest()
    for _, p in pairs(plrs:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Health>0 and p.Character.Humanoid.Health>0 then
                if not whitelistEn or not plr:IsFriendsWith(p.UserId) then
                    kill(p)
                end
            end
        end
    end
end})

AdvTab:CreateToggle({Name="Kill Aura", CurrentValue=false, Callback=function(v)
    if v then
        equipBest()
        aura = coroutine.create(function()
            while v do
                pcall(function()
                    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, p in pairs(plrs:GetPlayers()) do
                            if p~=plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                if (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude <= auraRadius then
                                    if p.Character.Humanoid.Health>0 then
                                        if not whitelistEn or not plr:IsFriendsWith(p.UserId) then
                                            kill(p)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
        coroutine.resume(aura)
    elseif aura then
        coroutine.close(aura)
        aura=nil
    end
end})

AdvTab:CreateSection("Teleportation")
AdvTab:CreateDropdown({Name="Teleport to Player", Options=function()
    local opts = {}
    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= plr then table.insert(opts,p.Name) end
    end
    return opts
end, Callback=function(v)
    local target = plrs:FindFirstChild(v)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end})

AdvTab:CreateButton({Name="Teleport All to Me", Callback=function()
    for _, p in pairs(plrs:GetPlayers()) do
        if p~=plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end
    end
end})

AdvTab:CreateSection("Options")
AdvTab:CreateToggle({Name="Whitelist Friends", CurrentValue=false, Callback=function(v) whitelistEn=v end})
