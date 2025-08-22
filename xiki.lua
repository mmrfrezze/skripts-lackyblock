-- Основные сервисы
local cam = workspace.Camera
local plrs = game.Players
local plr = plrs.LocalPlayer
local replic = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Переменные
local as_dlb, as_slb, as_rlb, as_dimlb, as_glb
local whitelistEn, infJump, aura
local auraRadius = 50

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

-- Rayfield GUI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Xiki Skript | Lucky Block Battleground",
    LoadingTitle = "Xiki Skript",
    LoadingSubtitle = "это будущее",
    ConfigurationSaving = {Enabled = true, FolderName = "XikiHub", FileName = "LuckyBlock"},
    Discord = {Enabled = false},
    KeySystem = false
})

-- Анимация при запуске
do
    local introText = Instance.new("TextLabel")
    introText.Size = UDim2.new(0,400,0,50)
    introText.Position = UDim2.new(0.5, -200, 0.4, 0)
    introText.BackgroundTransparency = 1
    introText.TextScaled = true
    introText.Font = Enum.Font.GothamBold
    introText.TextColor3 = Color3.fromRGB(180,0,255)
    introText.Text = "Xiki Skript"
    introText.Parent = game.CoreGui

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, -1, true)
    local goal = {TextStrokeTransparency = 0}
    local tween = TweenService:Create(introText, tweenInfo, goal)
    tween:Play()

    task.delay(3, function()
        introText:Destroy()
    end)
end

-- Вкладки
local CharTab = Window:CreateTab("Character", 4483362458)
local LuckyTab = Window:CreateTab("Lucky Blocks", 4483362458)
local ScriptTab = Window:CreateTab("Scripts", 4483362458)
local TimeTab = Window:CreateTab("Clock Time", 4483362458)
local AdvTab = Window:CreateTab("Advanced", 4483362458)

-- Character Tab
CharTab:CreateSlider({Name="Walk Speed", Range={0,100}, Increment=1, CurrentValue=16, Callback=function(v) plr.Character.Humanoid.WalkSpeed=v end})
CharTab:CreateButton({Name="Reset Walk Speed", Callback=function() plr.Character.Humanoid.WalkSpeed=16 end})
CharTab:CreateSlider({Name="Jump Power", Range={0,1000}, Increment=1, CurrentValue=50, Callback=function(v) plr.Character.Humanoid.JumpPower=v end})
CharTab:CreateButton({Name="Reset Jump Power", Callback=function() plr.Character.Humanoid.JumpPower=50 end})
CharTab:CreateToggle({Name="Infinite Jumps", CurrentValue=false, Callback=function(v)
    infJump=v
    if v then
        uis.JumpRequest:Connect(function()
            if infJump then
                plr.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end})
CharTab:CreateSlider({Name="Gravity", Range={0,1000}, Increment=1, CurrentValue=196, Callback=function(v) workspace.Gravity=v end})
CharTab:CreateButton({Name="Reset Gravity", Callback=function() workspace.Gravity=196 end})
CharTab:CreateSlider({Name="Field of View", Range={1,120}, Increment=1, CurrentValue=70, Callback=function(v) cam.FieldOfView=v end})
CharTab:CreateButton({Name="Reset FOV", Callback=function() cam.FieldOfView=70 end})

-- Lucky Blocks Tab
LuckyTab:CreateSection("Default Lucky Block")
LuckyTab:CreateButton({Name="Spawn", Callback=function() spawnBlock("SpawnLuckyBlock") end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) as_dlb=v; while as_dlb do task.wait(0.1) spawnBlock("SpawnLuckyBlock") end end})

LuckyTab:CreateSection("Super Lucky Block")
LuckyTab:CreateButton({Name="Spawn", Callback=function() spawnBlock("SpawnSuperBlock") end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) as_slb=v; while as_slb do task.wait(0.1) spawnBlock("SpawnSuperBlock") end end})

LuckyTab:CreateSection("Diamond Lucky Block")
LuckyTab:CreateButton({Name="Spawn", Callback=function() spawnBlock("SpawnDiamondBlock") end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) as_dimlb=v; while as_dimlb do task.wait(0.1) spawnBlock("SpawnDiamondBlock") end end})

LuckyTab:CreateSection("Rainbow Lucky Block")
LuckyTab:CreateButton({Name="Spawn", Callback=function() spawnBlock("SpawnRainbowBlock") end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) as_rlb=v; while as_rlb do task.wait(0.1) spawnBlock("SpawnRainbowBlock") end end})

LuckyTab:CreateSection("Galaxy Lucky Block")
LuckyTab:CreateButton({Name="Spawn", Callback=function() spawnBlock("SpawnGalaxyBlock") end})
LuckyTab:CreateToggle({Name="Auto Spawn", CurrentValue=false, Callback=function(v) as_glb=v; while as_glb do task.wait(0.1) spawnBlock("SpawnGalaxyBlock") end end})

-- Scripts Tab
ScriptTab:CreateButton({Name="Infinite Yield FE", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end})
ScriptTab:CreateButton({Name="System Broken", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))() end})
ScriptTab:CreateButton({Name="DEX Explorer", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end})
ScriptTab:CreateButton({Name="Path & Float (Xiki)", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/universal_scripts/refs/heads/main/ONLY-PC_pathing"))() end})
ScriptTab:CreateButton({Name="Xiki’s Github (more scripts)", Callback=function() setclipboard("https://github.com/m1kp0") end})

-- Clock Time Tab
TimeTab:CreateButton({Name="Night", Callback=function() game.Lighting.ClockTime=0 end})
TimeTab:CreateButton({Name="Day", Callback=function() game.Lighting.ClockTime=12 end})
TimeTab:CreateButton({Name="Evening", Callback=function() game.Lighting.ClockTime=18 end})
TimeTab:CreateButton({Name="Morning", Callback=function() game.Lighting.ClockTime=6 end})

-- Advanced Tab
AdvTab:CreateButton({Name="Equip All Tools", Callback=function() for _,tool in pairs(plr.Backpack:GetChildren()) do tool.Parent=plr.Character task.wait() end end})
AdvTab:CreateButton({Name="Insane Damage (Best Swords)", Callback=function() equipBest() end})

AdvTab:CreateButton({Name="Kill All", Callback=function()
    equipBest()
    for _,p in pairs(plrs:GetPlayers()) do
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
                        for _,p in pairs(plrs:GetPlayers()) do
                            if p~=plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                if (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude<=auraRadius then
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

AdvTab:CreateToggle({Name="Whitelist Friends", CurrentValue=false, Callback=function(v) whitelistEn=v end})
