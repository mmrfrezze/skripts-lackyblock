local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

_G.AutoFarm = false
_G.AutoQuest = false
_G.Noclip = false
_G.AutoCollectFruits = false
_G.FruitESP = false
_G.PlayerESP = false
_G.BringFruits = false
_G.WalkOnWater = false
_G.InfiniteStamina = false
_G.AutoSell = false
_G.AutoRaid = false
_G.AutoMelee = false
_G.AutoSword = false
_G.AutoDefense = false

local Window = Rayfield:CreateWindow({
    Name = "XikiStudio v1.0",
    LoadingTitle = "XikiStudio загружается...",
    LoadingSubtitle = "by xikibamboni",
    ConfigurationSaving = {Enabled = true, FolderName = "XikiStudio", FileName = "Config"},
    KeySystem = false,
})

local MainTab = Window:CreateTab("Главная", 13014546637)
local PlayerTab = Window:CreateTab("Игрок", 13014547629)
local FarmTab = Window:CreateTab("Фарминг", 13014548637)
local FruitTab = Window:CreateTab("Фрукты", 13014549637)
local TeleportTab = Window:CreateTab("Телепорты", 13014550637)
local CombatTab = Window:CreateTab("Бой", 13014551637)
local InfoTab = Window:CreateTab("Информация", 13014552637)

function FindNearestNPC()
    local closestNPC = nil
    local shortestDistance = math.huge
    for _, npc in pairs(Workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and npc:FindFirstChild("HumanoidRootPart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestNPC = npc
            end
        end
    end
    return closestNPC
end

function FindQuestNPC()
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Head") and npc.Name:find("Quest") then
            return npc
        end
    end
    return nil
end

function CompleteQuest()
    local questNPC = FindQuestNPC()
    if questNPC and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = questNPC.Head.CFrame + Vector3.new(0, 3, 0)
        wait(1)
        fireproximityprompt(questNPC.Head.ProximityPrompt)
    end
end

function FindFruits()
    local fruits = {}
    for _, fruit in pairs(Workspace:GetChildren()) do
        if fruit:FindFirstChild("Handle") and fruit:IsA("Tool") then
            table.insert(fruits, fruit)
        end
    end
    return fruits
end

function CreateESP(object, color, name)
    local highlight = Instance.new("Highlight")
    highlight.Name = "XikiESP"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = object
    highlight.Adornee = object
    if name then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "XikiBillboard"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Parent = object
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Parent = billboard
    end
end

function RemoveESP()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "XikiESP" or obj.Name == "XikiBillboard" then
            obj:Destroy()
        end
    end
end

function TeleportToIsland(islandName)
    local islands = {
        ["Старый мир"] = CFrame.new(100, 50, 100),
        ["Пиратская деревня"] = CFrame.new(200, 50, 200),
        ["Пустыня"] = CFrame.new(300, 50, 300),
        ["Ледяной остров"] = CFrame.new(400, 50, 400),
        ["Военный форт"] = CFrame.new(500, 50, 500),
        ["Остров обезьян"] = CFrame.new(600, 50, 600),
        ["Средний мир"] = CFrame.new(700, 50, 700),
        ["Небесный остров"] = CFrame.new(800, 50, 800),
        ["Подводный город"] = CFrame.new(900, 50, 900),
        ["Фабрика"] = CFrame.new(1000, 50, 1000),
        ["Царство духов"] = CFrame.new(1100, 50, 1100),
        ["Новый мир"] = CFrame.new(1200, 50, 1200),
        ["Зо"] = CFrame.new(1300, 50, 1300)
    }
    if islands[islandName] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = islands[islandName]
    end
end

function TeleportToBoss(bossName)
    local bosses = {
        ["Горбуччи"] = CFrame.new(150, 50, 150),
        ["Лейтенант"] = CFrame.new(250, 50, 250),
        ["Капитан"] = CFrame.new(350, 50, 350),
        ["Смокер"] = CFrame.new(450, 50, 450),
        ["Зоро"] = CFrame.new(550, 50, 550),
        ["Дон-Крейн"] = CFrame.new(650, 50, 650),
        ["Арлон"] = CFrame.new(750, 50, 750),
        ["Диабло"] = CFrame.new(850, 50, 850),
        ["Скайхо"] = CFrame.new(950, 50, 950),
        ["Адмирал"] = CFrame.new(1050, 50, 1050)
    }
    if bosses[bossName] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = bosses[bossName]
    end
end

MainTab:CreateButton({
    Name = "Перезагрузить интерфейс",
    Callback = function()
        Rayfield:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mmrfrezze/skripts-lackyblock/main/xiki2.lua"))()
    end
})

MainTab:CreateKeybind({
    Name = "Переключить интерфейс",
    CurrentKeybind = "Insert",
    HoldToInteract = false,
    Callback = function(Keybind)
        Rayfield:Toggle()
    end
})

MainTab:CreateButton({
    Name = "Удалить интерфейс",
    Callback = function()
        Rayfield:Destroy()
    end
})

local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "Скорость передвижения",
    Range = {16, 250},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "Сила прыжка",
    Range = {50, 250},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Бесконечная энергия",
    CurrentValue = false,
    Flag = "InfiniteEnergy",
    Callback = function(Value)
        _G.InfiniteStamina = Value
        while _G.InfiniteStamina and task.wait() do
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetAttribute("Energy", 100)
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Режим бога",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        if Value then
            while Rayfield.Flags["GodMode"] and task.wait() do
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Ноклип",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        _G.Noclip = Value
    end
})

PlayerTab:CreateToggle({
    Name = "Полёт",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NickelHUBB/RobloxScript/main/Fly.lua"))()
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Хождение по воде",
    CurrentValue = false,
    Flag = "WalkOnWater",
    Callback = function(Value)
        _G.WalkOnWater = Value
        if Value then
            local part = Instance.new("Part")
            part.Size = Vector3.new(100, 5, 100)
            part.Transparency = 0.5
            part.BrickColor = BrickColor.new("Cyan")
            part.Anchored = true
            part.CanCollide = true
            part.Name = "XikiWaterWalk"
            part.Parent = Workspace
            
            while _G.WalkOnWater and task.wait() do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)
                end
            end
        else
            if Workspace:FindFirstChild("XikiWaterWalk") then
                Workspace.XikiWaterWalk:Destroy()
            end
        end
    end
})

FarmTab:CreateToggle({
    Name = "Авто-фарм NPC",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        _G.AutoFarm = Value
        while _G.AutoFarm and task.wait() do
            pcall(function()
                local target = FindNearestNPC()
                if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local targetPos = target.HumanoidRootPart.Position
                    local farmHeight = 15
                    
                    hrp.CFrame = CFrame.new(targetPos.X, targetPos.Y + farmHeight, targetPos.Z)
                    
                    VirtualInputManager:SendKeyEvent(true, "X", false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, "X", false, game)
                    VirtualInputManager:SendKeyEvent(true, "C", false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, "C", false, game)
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Авто-квесты",
    CurrentValue = false,
    Flag = "AutoQuest",
    Callback = function(Value)
        _G.AutoQuest = Value
        while _G.AutoQuest and task.wait(3) do
            pcall(function()
                CompleteQuest()
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Авто-продажа",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        _G.AutoSell = Value
        while _G.AutoSell and task.wait(5) do
            pcall(function()
                local sellNPC = Workspace:FindFirstChild("Blackbeard") or Workspace:FindFirstChild("SellNPC")
                if sellNPC and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = sellNPC:FindFirstChild("Head").CFrame + Vector3.new(0, 3, 0)
                    wait(1)
                    fireproximityprompt(sellNPC.Head.ProximityPrompt)
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Авто-рейд",
    CurrentValue = false,
    Flag = "AutoRaid",
    Callback = function(Value)
        _G.AutoRaid = Value
        while _G.AutoRaid and task.wait(5) do
            pcall(function()
                local raidNPC = Workspace:FindFirstChild("Raids")
                if raidNPC and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = raidNPC:FindFirstChild("Head").CFrame + Vector3.new(0, 3, 0)
                    wait(1)
                    fireproximityprompt(raidNPC.Head.ProximityPrompt)
                end
            end)
        end
    end
})

FruitTab:CreateToggle({
    Name = "ESP фруктов",
    CurrentValue = false,
    Flag = "FruitESP",
    Callback = function(Value)
        _G.FruitESP = Value
        if Value then
            while _G.FruitESP and task.wait(1) do
                RemoveESP()
                pcall(function()
                    for _, fruit in pairs(FindFruits()) do
                        CreateESP(fruit, Color3.fromRGB(255, 0, 0), fruit.Name)
                    end
                end)
            end
        else
            RemoveESP()
        end
    end
})

FruitTab:CreateToggle({
    Name = "ESP игроков",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        _G.PlayerESP = Value
        if Value then
            while _G.PlayerESP and task.wait(2) do
                RemoveESP()
                pcall(function()
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            CreateESP(player.Character, Color3.fromRGB(0, 0, 255), player.Name)
                        end
                    end
                end)
            end
        else
            RemoveESP()
        end
    end
})

FruitTab:CreateToggle({
    Name = "Авто-сбор фруктов",
    CurrentValue = false,
    Flag = "AutoCollectFruits",
    Callback = function(Value)
        _G.AutoCollectFruits = Value
        while _G.AutoCollectFruits and task.wait(0.5) do
            pcall(function()
                for _, fruit in pairs(FindFruits()) do
                    if fruit:FindFirstChild("Handle") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - fruit.Handle.Position).Magnitude
                        if distance < 20 then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, fruit.Handle, 0)
                            task.wait()
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, fruit.Handle, 1)
                        end
                    end
                end
            end)
        end
    end
})

FruitTab:CreateToggle({
    Name = "Призыв всех фруктов",
    CurrentValue = false,
    Flag = "BringFruits",
    Callback = function(Value)
        _G.BringFruits = Value
        while _G.BringFruits and task.wait(0.5) do
            pcall(function()
                for _, fruit in pairs(FindFruits()) do
                    if fruit:FindFirstChild("Handle") then
                        fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    end
                end
            end)
        end
    end
})

local islands = {"Старый мир", "Пиратская деревня", "Пустыня", "Ледяной остров", "Военный форт", "Остров обезьян", "Средний мир", "Небесный остров", "Подводный город", "Фабрика", "Царство духов", "Новый мир", "Зо"}
TeleportTab:CreateDropdown({
    Name = "Телепорт на остров",
    Options = islands,
    CurrentOption = "Старый мир",
    Flag = "IslandDropdown",
    Callback = function(Option)
        TeleportToIsland(Option)
        Rayfield:Notify({Title = "Телепортация", Content = "Телепортация на " .. Option, Duration = 3})
    end
})

local bosses = {"Горбуччи", "Лейтенант", "Капитан", "Смокер", "Зоро", "Дон-Крейн", "Арлон", "Диабло", "Скайхо", "Адмирал"}
TeleportTab:CreateDropdown({
    Name = "Телепорт к боссу",
    Options = bosses,
    CurrentOption = "Горбуччи",
    Flag = "BossDropdown",
    Callback = function(Option)
        TeleportToBoss(Option)
        Rayfield:Notify({Title = "Телепортация", Content = "Телепортация к " .. Option, Duration = 3})
    end
})

CombatTab:CreateToggle({
    Name = "Авто-атака (Мело)",
    CurrentValue = false,
    Flag = "AutoMelee",
    Callback = function(Value)
        _G.AutoMelee = Value
        while _G.AutoMelee and task.wait(0.2) do
            VirtualInputManager:SendKeyEvent(true, "X", false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "X", false, game)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Авто-атака (Меч)",
    CurrentValue = false,
    Flag = "AutoSword",
    Callback = function(Value)
        _G.AutoSword = Value
        while _G.AutoSword and task.wait(0.3) do
            VirtualInputManager:SendKeyEvent(true, "Z", false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "Z", false, game)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Авто-защита",
    CurrentValue = false,
    Flag = "AutoDefense",
    Callback = function(Value)
        _G.AutoDefense = Value
        while _G.AutoDefense and task.wait(0.5) do
            VirtualInputManager:SendKeyEvent(true, "V", false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "V", false, game)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Аура убийства",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        if Value then
            while Rayfield.Flags["KillAura"] and task.wait(0.3) do
                pcall(function()
                    for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                            if distance < 30 then
                                VirtualInputManager:SendKeyEvent(true, "X", false, game)
                                task.wait(0.1)
                                VirtualInputManager:SendKeyEvent(false, "X", false, game)
                            end
                        end
                    end
                end)
            end
        end
    end
})

InfoTab:CreateLabel("XikiStudio v1.0")
InfoTab:CreateLabel("by xikibamboni")
InfoTab:CreateLabel("Используйте на свой страх и риск!")

InfoTab:CreateButton({
    Name = "Скопировать YouTube",
    Callback = function()
        setclipboard("https://www.youtube.com/@xikibamboni-ghost")
        Rayfield:Notify({Title = "YouTube", Content = "Ссылка скопирована!", Duration = 3})
    end
})

InfoTab:CreateButton({
    Name = "Скопировать Discord",
    Callback = function()
        setclipboard("https://discord.gg/H3525BkxTC")
        Rayfield:Notify({Title = "Discord", Content = "Ссылка скопирована!", Duration = 3})
    end
})

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if Rayfield.Flags["WalkSpeed"] then
        character.Humanoid.WalkSpeed = Rayfield.Flags["WalkSpeed"].CurrentValue
    end
    if Rayfield.Flags["JumpPower"] then
        character.Humanoid.JumpPower = Rayfield.Flags["JumpPower"].CurrentValue
    end
end)

RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

Rayfield:Notify({
    Title = "XikiStudio загружен!",
    Content = "Успешно внедрен. Удачного использования!",
    Duration = 5,
})
