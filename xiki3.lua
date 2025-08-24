local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

-- Настройки по умолчанию
_G.ESPEnabled = false
_G.BoxESP = false
_G.NameTags = false
_G.Tracers = false
_G.SkeletonESP = false
_G.AimbotEnabled = false
_G.AimbotKey = Enum.UserInputType.MouseButton2
_G.AimbotTeamCheck = true
_G.AimbotFOV = 100
_G.AimbotSmoothness = 1
_G.Platform = "PC"

-- ESP объекты
local ESPObjects = {}

function GetEnemies()
    local enemies = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
            if _G.AimbotTeamCheck then
                if player.Team ~= LocalPlayer.Team then
                    table.insert(enemies, player)
                end
            else
                table.insert(enemies, player)
            end
        end
    end
    return enemies
end

function CreateBoxESP(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Удаляем старый ESP если есть
    if ESPObjects[player] and ESPObjects[player].Box then
        ESPObjects[player].Box:Destroy()
    end

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Filled = false
    box.ZIndex = 2

    ESPObjects[player] = ESPObjects[player] or {}
    ESPObjects[player].Box = box
    
    return box
end

function CreateNameTag(player)
    if not player.Character then return end
    
    local character = player.Character
    local head = character:FindFirstChild("Head")
    if not head then return end

    if ESPObjects[player] and ESPObjects[player].NameTag then
        ESPObjects[player].NameTag:Destroy()
    end

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Text = player.Name
    nameTag.Font = 2

    ESPObjects[player] = ESPObjects[player] or {}
    ESPObjects[player].NameTag = nameTag
    
    return nameTag
end

function CreateTracer(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    if ESPObjects[player] and ESPObjects[player].Tracer then
        ESPObjects[player].Tracer:Destroy()
    end

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(0, 255, 0)
    tracer.Thickness = 1

    ESPObjects[player] = ESPObjects[player] or {}
    ESPObjects[player].Tracer = tracer
    
    return tracer
end

function CreateSkeletonESP(player)
    if not player.Character then return end
    
    local character = player.Character
    
    -- Удаляем старый скелет если есть
    if ESPObjects[player] and ESPObjects[player].Skeleton then
        for _, line in pairs(ESPObjects[player].Skeleton) do
            line:Destroy()
        end
    end

    local skeletonLines = {}
    local bones = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightLowerLeg", "RightFoot"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightLowerArm", "RightHand"}
    }

    for _, bone in pairs(bones) do
        local part1 = character:FindFirstChild(bone[1])
        local part2 = character:FindFirstChild(bone[2])
        
        if part1 and part2 then
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = Color3.fromRGB(255, 0, 0)
            line.Thickness = 1
            table.insert(skeletonLines, line)
        end
    end

    ESPObjects[player] = ESPObjects[player] or {}
    ESPObjects[player].Skeleton = skeletonLines
    
    return skeletonLines
end

function UpdateESP()
    for player, drawings in pairs(ESPObjects) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            -- Игрок вышел или умер, удаляем ESP
            if drawings.Box then drawings.Box:Destroy() end
            if drawings.NameTag then drawings.NameTag:Destroy() end
            if drawings.Tracer then drawings.Tracer:Destroy() end
            if drawings.Skeleton then
                for _, line in pairs(drawings.Skeleton) do
                    line:Destroy()
                end
            end
            ESPObjects[player] = nil
            return
        end

        local character = player.Character
        local humanoidRootPart = character.HumanoidRootPart
        local head = character:FindFirstChild("Head")

        if humanoidRootPart and head then
            local position, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if onScreen then
                -- Box ESP
                if _G.BoxESP and drawings.Box then
                    local scaleFactor = 1 / (position.Z * math.tan(math.rad(Camera.FieldOfView / 2)) * 2) * 1000
                    local width = 3 * scaleFactor
                    local height = 6 * scaleFactor
                    
                    drawings.Box.Size = Vector2.new(width, height)
                    drawings.Box.Position = Vector2.new(position.X - width/2, position.Y - height/2)
                    drawings.Box.Visible = true
                elseif drawings.Box then
                    drawings.Box.Visible = false
                end

                -- Name Tag
                if _G.NameTags and drawings.NameTag then
                    local headPosition = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
                    drawings.NameTag.Position = Vector2.new(headPosition.X, headPosition.Y)
                    drawings.NameTag.Visible = true
                elseif drawings.NameTag then
                    drawings.NameTag.Visible = false
                end

                -- Tracers
                if _G.Tracers and drawings.Tracer then
                    drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    drawings.Tracer.To = Vector2.new(position.X, position.Y)
                    drawings.Tracer.Visible = true
                elseif drawings.Tracer then
                    drawings.Tracer.Visible = false
                end

                -- Skeleton ESP
                if _G.SkeletonESP and drawings.Skeleton then
                    local boneIndex = 1
                    local bones = {
                        {"Head", "UpperTorso"},
                        {"UpperTorso", "LowerTorso"},
                        {"LowerTorso", "LeftUpperLeg"},
                        {"LowerTorso", "RightUpperLeg"},
                        {"LeftUpperLeg", "LeftLowerLeg"},
                        {"RightUpperLeg", "RightLowerLeg"},
                        {"LeftLowerLeg", "LeftFoot"},
                        {"RightLowerLeg", "RightFoot"},
                        {"UpperTorso", "LeftUpperArm"},
                        {"UpperTorso", "RightUpperArm"},
                        {"LeftUpperArm", "LeftLowerArm"},
                        {"RightUpperArm", "RightLowerArm"},
                        {"LeftLowerArm", "LeftHand"},
                        {"RightLowerArm", "RightHand"}
                    }

                    for i, bone in pairs(bones) do
                        local part1 = character:FindFirstChild(bone[1])
                        local part2 = character:FindFirstChild(bone[2])
                        
                        if part1 and part2 and drawings.Skeleton[i] then
                            local pos1 = Camera:WorldToViewportPoint(part1.Position)
                            local pos2 = Camera:WorldToViewportPoint(part2.Position)
                            
                            if pos1.Z > 0 and pos2.Z > 0 then
                                drawings.Skeleton[i].From = Vector2.new(pos1.X, pos1.Y)
                                drawings.Skeleton[i].To = Vector2.new(pos2.X, pos2.Y)
                                drawings.Skeleton[i].Visible = true
                            else
                                drawings.Skeleton[i].Visible = false
                            end
                        elseif drawings.Skeleton[i] then
                            drawings.Skeleton[i].Visible = false
                        end
                    end
                elseif drawings.Skeleton then
                    for _, line in pairs(drawings.Skeleton) do
                        line.Visible = false
                    end
                end
            else
                -- Игрок не на экране, скрываем ESP
                if drawings.Box then drawings.Box.Visible = false end
                if drawings.NameTag then drawings.NameTag.Visible = false end
                if drawings.Tracer then drawings.Tracer.Visible = false end
                if drawings.Skeleton then
                    for _, line in pairs(drawings.Skeleton) do
                        line.Visible = false
                    end
                end
            end
        end
    end
end

function RemoveESP()
    for player, drawings in pairs(ESPObjects) do
        if drawings.Box then drawings.Box:Destroy() end
        if drawings.NameTag then drawings.NameTag:Destroy() end
        if drawings.Tracer then drawings.Tracer:Destroy() end
        if drawings.Skeleton then
            for _, line in pairs(drawings.Skeleton) do
                line:Destroy()
            end
        end
    end
    ESPObjects = {}
end

function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.AimbotFOV
    
    for _, player in pairs(GetEnemies()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local screenPoint, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Создание интерфейса
local Window = Rayfield:CreateWindow({
    Name = "XikiStudio | Rivals",
    LoadingTitle = "XikiStudio загружается...",
    LoadingSubtitle = "Специально для Rivals",
    ConfigurationSaving = {Enabled = true, FolderName = "XikiStudio", FileName = "RivalsConfig"},
    KeySystem = false,
})

local MainTab = Window:CreateTab("Главная", 13014546637)
local ESPTab = Window:CreateTab("ESP", 13014547629)
local AimbotTab = Window:CreateTab("Aimbot", 13014548637)
local SettingsTab = Window:CreateTab("Настройки", 13014549637)

MainTab:CreateButton({
    Name = "Перезагрузить интерфейс",
    Callback = function()
        Rayfield:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/rivals/main.lua"))()
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
        RemoveESP()
    end
})

ESPTab:CreateToggle({
    Name = "Включить ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        _G.ESPEnabled = Value
        if not Value then
            RemoveESP()
        end
    end
})

ESPTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESP",
    Callback = function(Value)
        _G.BoxESP = Value
        if not Value then
            for player, drawings in pairs(ESPObjects) do
                if drawings.Box then
                    drawings.Box.Visible = false
                end
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Name Tags",
    CurrentValue = false,
    Flag = "NameTags",
    Callback = function(Value)
        _G.NameTags = Value
        if not Value then
            for player, drawings in pairs(ESPObjects) do
                if drawings.NameTag then
                    drawings.NameTag.Visible = false
                end
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Flag = "Tracers",
    Callback = function(Value)
        _G.Tracers = Value
        if not Value then
            for player, drawings in pairs(ESPObjects) do
                if drawings.Tracer then
                    drawings.Tracer.Visible = false
                end
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Skeleton ESP",
    CurrentValue = false,
    Flag = "SkeletonESP",
    Callback = function(Value)
        _G.SkeletonESP = Value
        if not Value then
            for player, drawings in pairs(ESPObjects) do
                if drawings.Skeleton then
                    for _, line in pairs(drawings.Skeleton) do
                        line.Visible = false
                    end
                end
            end
        end
    end
})

AimbotTab:CreateToggle({
    Name = "Включить Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(Value)
        _G.AimbotEnabled = Value
    end
})

AimbotTab:CreateToggle({
    Name = "Проверка команды",
    CurrentValue = true,
    Flag = "AimbotTeamCheck",
    Callback = function(Value)
        _G.AimbotTeamCheck = Value
    end
})

AimbotTab:CreateSlider({
    Name = "FOV Aimbot",
    Range = {50, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 100,
    Flag = "AimbotFOV",
    Callback = function(Value)
        _G.AimbotFOV = Value
    end
})

AimbotTab:CreateSlider({
    Name = "Плавность аима",
    Range = {1, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "AimbotSmoothness",
    Callback = function(Value)
        _G.AimbotSmoothness = Value
    end
})

AimbotTab:CreateKeybind({
    Name = "Клавиша Aimbot",
    CurrentKeybind = "MouseButton2",
    HoldToInteract = true,
    Callback = function(Keybind)
        _G.AimbotKey = Keybind
    end
})

SettingsTab:CreateDropdown({
    Name = "Платформа",
    Options = {"PC", "Phone", "VR", "PlayStation", "Xbox", "None"},
    CurrentOption = "PC",
    Flag = "Platform",
    Callback = function(Option)
        _G.Platform = Option
    end
})

SettingsTab:CreateButton({
    Name = "Скопировать Discord",
    Callback = function()
        setclipboard("https://discord.gg/H3525BkxTC")
        Rayfield:Notify({Title = "Discord", Content = "Ссылка скопирована!", Duration = 3})
    end
})

SettingsTab:CreateButton({
    Name = "Скопировать YouTube",
    Callback = function()
        setclipboard("https://www.youtube.com/@xikibamboni-ghost")
        Rayfield:Notify({Title = "YouTube", Content = "Ссылка скопирована!", Duration = 3})
    end
})

-- Основной цикл ESP
RunService.RenderStepped:Connect(function()
    if _G.ESPEnabled then
        -- Создаем ESP для новых игроков
        for _, player in pairs(GetEnemies()) do
            if player.Character and not ESPObjects[player] then
                if _G.BoxESP then CreateBoxESP(player) end
                if _G.NameTags then CreateNameTag(player) end
                if _G.Tracers then CreateTracer(player) end
                if _G.SkeletonESP then CreateSkeletonESP(player) end
            end
        end
        
        -- Обновляем ESP
        UpdateESP()
    else
        -- Скрываем ESP если отключено
        for player, drawings in pairs(ESPObjects) do
            if drawings.Box then drawings.Box.Visible = false end
            if drawings.NameTag then drawings.NameTag.Visible = false end
            if drawings.Tracer then drawings.Tracer.Visible = false end
            if drawings.Skeleton then
                for _, line in pairs(drawings.Skeleton) do
                    line.Visible = false
                end
            end
        end
    end
end)

-- Aimbot
local aimbotConnection
aimbotConnection = RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled and UserInputService:IsMouseButtonPressed(_G.AimbotKey) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local cameraPosition = Camera.CFrame.Position
            local headPosition = head.Position
            
            -- Плавное наведение
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(cameraPosition, headPosition)
            local smoothness = math.max(1, _G.AimbotSmoothness)
            
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / smoothness)
        end
    end
end)

Rayfield:Notify({
    Title = "XikiStudio загружен!",
    Content = "Успешно внедрен для Rivals. Удачного использования!",
    Duration = 5,
})
