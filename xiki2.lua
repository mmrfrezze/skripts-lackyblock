local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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
_G.FarmHeight = 15
_G.AttackDistance = 20
_G.AutoDodge = false
_G.InfiniteJump = false
_G.SpinBot = false
_G.NoFog = false
_G.FullBright = false
_G.AutoAbility = false
_G.AnchorTarget = false
_G.HitSound = false
_G.CustomFOV = false
_G.FOVValue = 70
_G.AuraRange = 20
_G.AuraActive = false
_G.FlyPlatform = nil
_G.Flying = false
_G.FlySpeed = 50
_G.TrailEnabled = false
_G.TargetESP = false
_G.ChineseHat = false
_G.JumpCircle = false
_G.ClientColor = Color3.fromRGB(255, 0, 0)

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

function mouse1click()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

function FlyToTarget(target, height)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    local targetPos = target.HumanoidRootPart.Position
    local flyPos = Vector3.new(targetPos.X, targetPos.Y + height, targetPos.Z)
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local tween = TweenService:Create(
            LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(0.5, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(flyPos)}
        )
        tween:Play()
        tween.Completed:Wait()
        
        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPos).Magnitude
        if distance <= _G.AttackDistance then
            mouse1click()
        end
    end
end

function CreateFlyPlatform()
    if _G.FlyPlatform then _G.FlyPlatform:Destroy() end
    
    _G.FlyPlatform = Instance.new("Part")
    _G.FlyPlatform.Size = Vector3.new(4, 0.5, 4)
    _G.FlyPlatform.Transparency = 1
    _G.FlyPlatform.Anchored = true
    _G.FlyPlatform.CanCollide = true
    _G.FlyPlatform.Name = "XikiFlyPlatform"
    _G.FlyPlatform.Parent = Workspace
    
    return _G.FlyPlatform
end

function StartFlying()
    _G.Flying = true
    local platform = CreateFlyPlatform()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
    
    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if not _G.Flying or not LocalPlayer.Character then
            flyConnection:Disconnect()
            return
        end
        
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camera = Workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * _G.FlySpeed
        end
        
        bodyVelocity.Velocity = moveDirection
        platform.CFrame = hrp.CFrame * CFrame.new(0, -3, 0)
    end)
end

function StopFlying()
    _G.Flying = false
    if _G.FlyPlatform then
        _G.FlyPlatform:Destroy()
        _G.FlyPlatform = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bodyVelocity = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

function CreateTrail()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local trail = Instance.new("Trail")
        trail.Name = "XikiTrail"
        trail.Attachment0 = Instance.new("Attachment")
        trail.Attachment0.Parent = LocalPlayer.Character.HumanoidRootPart
        trail.Attachment0.Position = Vector3.new(0, 0, 0)
        trail.Attachment1 = Instance.new("Attachment")
        trail.Attachment1.Parent = LocalPlayer.Character.HumanoidRootPart
        trail.Attachment1.Position = Vector3.new(0, 1, 0)
        trail.Color = ColorSequence.new(_G.ClientColor)
        trail.LightEmission = 1
        trail.Transparency = NumberSequence.new(0.5)
        trail.Lifetime = 0.5
        trail.Parent = LocalPlayer.Character.HumanoidRootPart
    end
end

function RemoveTrail()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
            if obj.Name == "XikiTrail" then
                obj:Destroy()
            end
        end
    end
end

function CreateTargetESP(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    local ghost1 = Instance.new("Part")
    ghost1.Name = "XikiGhost1"
    ghost1.Size = Vector3.new(1.5, 1.5, 1.5) -- Уменьшен размер
    ghost1.Shape = Enum.PartType.Ball
    ghost1.Material = Enum.Material.Neon
    ghost1.BrickColor = BrickColor.new(_G.ClientColor)
    ghost1.Transparency = 0.2
    ghost1.Anchored = true
    ghost1.CanCollide = false
    ghost1.Parent = Workspace
    
    local ghost2 = Instance.new("Part")
    ghost2.Name = "XikiGhost2"
    ghost2.Size = Vector3.new(1.5, 1.5, 1.5) -- Уменьшен размер
    ghost2.Shape = Enum.PartType.Ball
    ghost2.Material = Enum.Material.Neon
    ghost2.BrickColor = BrickColor.new(_G.ClientColor)
    ghost2.Transparency = 0.2
    ghost2.Anchored = true
    ghost2.CanCollide = false
    ghost2.Parent = Workspace
    
    -- Следы для призраков
    local trail1 = Instance.new("Trail")
    trail1.Attachment0 = Instance.new("Attachment")
    trail1.Attachment0.Parent = ghost1
    trail1.Attachment1 = Instance.new("Attachment")
    trail1.Attachment1.Parent = ghost1
    trail1.Attachment1.Position = Vector3.new(0, 0.5, 0)
    trail1.Color = ColorSequence.new(_G.ClientColor)
    trail1.LightEmission = 1
    trail1.Transparency = NumberSequence.new(0.7)
    trail1.Lifetime = 0.3
    trail1.Parent = ghost1
    
    local trail2 = Instance.new("Trail")
    trail2.Attachment0 = Instance.new("Attachment")
    trail2.Attachment0.Parent = ghost2
    trail2.Attachment1 = Instance.new("Attachment")
    trail2.Attachment1.Parent = ghost2
    trail2.Attachment1.Position = Vector3.new(0, 0.5, 0)
    trail2.Color = ColorSequence.new(_G.ClientColor)
    trail2.LightEmission = 1
    trail2.Transparency = NumberSequence.new(0.7)
    trail2.Lifetime = 0.3
    trail2.Parent = ghost2
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not _G.TargetESP or not target or not target:FindFirstChild("HumanoidRootPart") then
            ghost1:Destroy()
            ghost2:Destroy()
            connection:Disconnect()
            return
        end
        
        local pos = target.HumanoidRootPart.Position
        local time = tick() * 3 -- Увеличена скорость вращения в 3 раза
        
        -- Увеличена дистанция от цели (5 вместо 3)
        ghost1.CFrame = CFrame.new(pos + Vector3.new(math.sin(time * 2) * 5, 3, math.cos(time * 2) * 5))
        ghost2.CFrame = CFrame.new(pos + Vector3.new(math.cos(time * 2) * 5, 3, math.sin(time * 2) * 5))
    end)
end

function RemoveTargetESP()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "XikiGhost1" or obj.Name == "XikiGhost2" then
            obj:Destroy()
        end
    end
end

function CreateChineseHat()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        -- Основа шляпы
        local hatBase = Instance.new("Part")
        hatBase.Name = "XikiChineseHatBase"
        hatBase.Size = Vector3.new(3, 0.2, 3)
        hatBase.Shape = Enum.PartType.Cylinder
        hatBase.Material = Enum.Material.Neon
        hatBase.BrickColor = BrickColor.new(_G.ClientColor)
        hatBase.Transparency = 0.3
        hatBase.Anchored = false
        hatBase.CanCollide = false
        
        -- Конус шляпы
        local hatCone = Instance.new("Part")
        hatCone.Name = "XikiChineseHatCone"
        hatCone.Size = Vector3.new(2, 1.5, 2)
        hatCone.Shape = Enum.PartType.Cylinder
        hatCone.Material = Enum.Material.Neon
        hatCone.BrickColor = BrickColor.new(_G.ClientColor)
        hatCone.Transparency = 0.3
        hatCone.Anchored = false
        hatCone.CanCollide = false
        
        -- Верхушка шляпы
        local hatTop = Instance.new("Part")
        hatTop.Name = "XikiChineseHatTop"
        hatTop.Size = Vector3.new(0.5, 0.5, 0.5)
        hatTop.Shape = Enum.PartType.Ball
        hatTop.Material = Enum.Material.Neon
        hatTop.BrickColor = BrickColor.new(_G.ClientColor)
        hatTop.Transparency = 0.2
        hatTop.Anchored = false
        hatTop.CanCollide = false
        
        -- Крепление основы
        local weldBase = Instance.new("Weld")
        weldBase.Part0 = LocalPlayer.Character.Head
        weldBase.Part1 = hatBase
        weldBase.C0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(0, 0, math.rad(90))
        weldBase.Parent = hatBase
        
        -- Крепление конуса
        local weldCone = Instance.new("Weld")
        weldCone.Part0 = hatBase
        weldCone.Part1 = hatCone
        weldCone.C0 = CFrame.new(0, -0.8, 0)
        weldCone.Parent = hatCone
        
        -- Крепление верхушки
        local weldTop = Instance.new("Weld")
        weldTop.Part0 = hatCone
        weldTop.Part1 = hatTop
        weldTop.C0 = CFrame.new(0, -1.2, 0)
        weldTop.Parent = hatTop
        
        hatBase.Parent = LocalPlayer.Character
        hatCone.Parent = LocalPlayer.Character
        hatTop.Parent = LocalPlayer.Character
        
        -- Свечение
        local pointLight = Instance.new("PointLight")
        pointLight.Name = "XikiHatLight"
        pointLight.Color = _G.ClientColor
        pointLight.Brightness = 2
        pointLight.Range = 5
        pointLight.Parent = hatTop
    end
end

function RemoveChineseHat()
    if LocalPlayer.Character then
        for _, obj in pairs(LocalPlayer.Character:GetChildren()) do
            if obj.Name == "XikiChineseHatBase" or obj.Name == "XikiChineseHatCone" or obj.Name == "XikiChineseHatTop" then
                obj:Destroy()
            end
        end
    end
end

function CreateJumpCircle()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local circle = Instance.new("Part")
        circle.Name = "XikiJumpCircle"
        circle.Size = Vector3.new(5, 0.1, 5)
        circle.Shape = Enum.PartType.Cylinder
        circle.Material = Enum.Material.Neon
        circle.BrickColor = BrickColor.new(_G.ClientColor)
        circle.Transparency = 0.7
        circle.Anchored = true
        circle.CanCollide = false
        circle.Parent = Workspace
        
        local tween = TweenService:Create(
            circle,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = Vector3.new(8, 0.1, 8), Transparency = 1}
        )
        tween:Play()
        
        tween.Completed:Connect(function()
            circle:Destroy()
        end)
    end
end

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
local VisualTab = Window:CreateTab("Визуал", 13014552637)
local InfoTab = Window:CreateTab("Информация", 13014553637)

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
    Name = "Полёт (WSAD+Space+Shift)",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        if Value then
            StartFlying()
        else
            StopFlying()
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

PlayerTab:CreateToggle({
    Name = "Бесконечный прыжок",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        _G.InfiniteJump = Value
        if Value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Скорость полета",
    Range = {20, 200},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        _G.FlySpeed = Value
    end
})

local FarmHeightSlider = FarmTab:CreateSlider({
    Name = "Высота фарма",
    Range = {5, 50},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 15,
    Flag = "FarmHeight",
    Callback = function(Value)
        _G.FarmHeight = Value
    end
})

local AttackDistanceSlider = FarmTab:CreateSlider({
    Name = "Дистанция атаки",
    Range = {10, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 20,
    Flag = "AttackDistance",
    Callback = function(Value)
        _G.AttackDistance = Value
    end
})

FarmTab:CreateToggle({
    Name = "Авто-фарм NPC",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        _G.AutoFarm = Value
        while _G.AutoFarm and task.wait(0.1) do
            pcall(function()
                local target = FindNearestNPC()
                if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    FlyToTarget(target, _G.FarmHeight)
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

local AuraRangeSlider = CombatTab:CreateSlider({
    Name = "Дистанция ауры",
    Range = {10, 50},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 20,
    Flag = "AuraRange",
    Callback = function(Value)
        _G.AuraRange = Value
    end
})

CombatTab:CreateToggle({
    Name = "Аура атаки",
    CurrentValue = false,
    Flag = "AttackAura",
    Callback = function(Value)
        _G.AuraActive = Value
        while _G.AuraActive and task.wait(0.1) do
            pcall(function()
                for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                    if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                        if distance <= _G.AuraRange then
                            mouse1click()
                        end
                    end
                end
            end)
        end
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

CombatTab:CreateToggle({
    Name = "Авто-уворот",
    CurrentValue = false,
    Flag = "AutoDodge",
    Callback = function(Value)
        _G.AutoDodge = Value
        while _G.AutoDodge and task.wait() do
            pcall(function()
                for _, projectile in pairs(Workspace:GetChildren()) do
                    if projectile:FindFirstChild("Velocity") and (projectile.Name == "Projectile" or projectile:IsA("BasePart")) then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - projectile.Position).Magnitude
                        if distance < 10 then
                            VirtualInputManager:SendKeyEvent(true, "Q", false, game)
                            task.wait(0.1)
                            VirtualInputManager:SendKeyEvent(false, "Q", false, game)
                        end
                    end
                end
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Авто-способности",
    CurrentValue = false,
    Flag = "AutoAbility",
    Callback = function(Value)
        _G.AutoAbility = Value
        while _G.AutoAbility and task.wait(1) do
            VirtualInputManager:SendKeyEvent(true, "F", false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "F", false, game)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Закрепить цель",
    CurrentValue = false,
    Flag = "AnchorTarget",
    Callback = function(Value)
        _G.AnchorTarget = Value
        while _G.AnchorTarget and task.wait() do
            pcall(function()
                local target = FindNearestNPC()
                if target and target:FindFirstChild("HumanoidRootPart") then
                    target.HumanoidRootPart.Anchored = true
                end
            end)
        end
    end
})

VisualTab:CreateToggle({
    Name = "Убрать туман",
    CurrentValue = false,
    Flag = "NoFog",
    Callback = function(Value)
        _G.NoFog = Value
        if Value then
            game:GetService("Lighting").FogEnd = 1000000
        else
            game:GetService("Lighting").FogEnd = 1000
        end
    end
})

VisualTab:CreateToggle({
    Name = "Полная яркость",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = function(Value)
        _G.FullBright = Value
        if Value then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Brightness = 2
        else
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Brightness = 1
        end
    end
})

VisualTab:CreateToggle({
    Name = "Звук попадания",
    CurrentValue = false,
    Flag = "HitSound",
    Callback = function(Value)
        _G.HitSound = Value
    end
})

local FOVSlider = VisualTab:CreateSlider({
    Name = "Поле зрения",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value)
        _G.FOVValue = Value
        if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") then
            local camera = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Camera")
            if camera then
                camera.FieldOfView = _G.FOVValue
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Спин-бот",
    CurrentValue = false,
    Flag = "SpinBot",
    Callback = function(Value)
        _G.SpinBot = Value
        while _G.SpinBot and task.wait() do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Трейл",
    CurrentValue = false,
    Flag = "Trail",
    Callback = function(Value)
        _G.TrailEnabled = Value
        if Value then
            CreateTrail()
        else
            RemoveTrail()
        end
    end
})

VisualTab:CreateToggle({
    Name = "Таргет ESP",
    CurrentValue = false,
    Flag = "TargetESP",
    Callback = function(Value)
        _G.TargetESP = Value
        if Value then
            while _G.TargetESP and task.wait(0.1) do
                local target = FindNearestNPC()
                if target then
                    RemoveTargetESP()
                    CreateTargetESP(target)
                end
            end
        else
            RemoveTargetESP()
        end
    end
})

VisualTab:CreateToggle({
    Name = "Китайская шляпа",
    CurrentValue = false,
    Flag = "ChineseHat",
    Callback = function(Value)
        _G.ChineseHat = Value
        if Value then
            CreateChineseHat()
        else
            RemoveChineseHat()
        end
    end
})

VisualTab:CreateToggle({
    Name = "Круг при прыжке",
    CurrentValue = false,
    Flag = "JumpCircle",
    Callback = function(Value)
        _G.JumpCircle = Value
        if Value then
            LocalPlayer.CharacterAdded:Connect(function(character)
                character:WaitForChild("Humanoid").Jumping:Connect(function()
                    if _G.JumpCircle then
                        CreateJumpCircle()
                    end
                end)
            end)
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "Цвет клиента",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ClientColor",
    Callback = function(Value)
        _G.ClientColor = Value
        if _G.TrailEnabled then
            RemoveTrail()
            CreateTrail()
        end
        if _G.ChineseHat then
            RemoveChineseHat()
            CreateChineseHat()
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
    if _G.TrailEnabled then
        CreateTrail()
    end
    if _G.ChineseHat then
        CreateChineseHat()
    end
    if _G.JumpCircle then
        character.Humanoid.Jumping:Connect(function()
            if _G.JumpCircle then
                CreateJumpCircle()
            end
        end)
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
