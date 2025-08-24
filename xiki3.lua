local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

_G.ESPEnabled = false
_G.BoxESP = false
_G.NameTags = false
_G.SkeletonESP = false
_G.AimbotEnabled = false
_G.AimbotKey = Enum.UserInputType.MouseButton2
_G.AimbotTeamCheck = true
_G.AimbotFOV = 100
_G.Platform = "PC"

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
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "RivalsBoxESP"
        box.Size = Vector3.new(3, 6, 3)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 2
        box.Adornee = player.Character.HumanoidRootPart
        box.Parent = player.Character.HumanoidRootPart
    end
end

function CreateNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "RivalsNameTag"
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character.Head
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextSize = 14
        textLabel.Font = Enum.Font.GothamBold
        textLabel.Parent = billboard
    end
end

function CreateSkeletonESP(player)
    if player.Character then
        local connections = {}
        
        local function createBone(part1, part2)
            if part1 and part2 and part1:IsA("BasePart") and part2:IsA("BasePart") then
                local attachment1 = Instance.new("Attachment")
                attachment1.Parent = part1
                
                local attachment2 = Instance.new("Attachment")
                attachment2.Parent = part2
                
                local beam = Instance.new("Beam")
                beam.Name = "RivalsSkeleton"
                beam.Attachment0 = attachment1
                beam.Attachment1 = attachment2
                beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                beam.Width0 = 0.1
                beam.Width1 = 0.1
                beam.Parent = part1
                
                return {attachment1, attachment2, beam}
            end
            return {}
        end

        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
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
                local part1 = player.Character:FindFirstChild(bone[1])
                local part2 = player.Character:FindFirstChild(bone[2])
                if part1 and part2 then
                    local boneParts = createBone(part1, part2)
                    for _, part in pairs(boneParts) do
                        table.insert(connections, part)
                    end
                end
            end
        end
        
        return connections
    end
    return {}
end

function RemoveESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part.Name == "RivalsBoxESP" or part.Name == "RivalsNameTag" or part.Name == "RivalsSkeleton" then
                    part:Destroy()
                end
            end
        end
    end
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

local Window = Rayfield:CreateWindow({
    Name = "Rivals X",
    LoadingTitle = "Rivals X загружается...",
    LoadingSubtitle = "by xikibamboni",
    ConfigurationSaving = {Enabled = true, FolderName = "RivalsX", FileName = "Config"},
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
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local box = player.Character:FindFirstChild("RivalsBoxESP")
                    if box then box:Destroy() end
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
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local nametag = player.Character:FindFirstChild("RivalsNameTag")
                    if nametag then nametag:Destroy() end
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
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part.Name == "RivalsSkeleton" then
                            part:Destroy()
                        end
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

local AimbotFOVSlider = AimbotTab:CreateSlider({
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

RunService.RenderStepped:Connect(function()
    if _G.ESPEnabled then
        for _, player in pairs(GetEnemies()) do
            if player.Character then
                if _G.BoxESP and not player.Character:FindFirstChild("RivalsBoxESP") then
                    CreateBoxESP(player)
                end
                
                if _G.NameTags and not player.Character:FindFirstChild("RivalsNameTag") then
                    CreateNameTag(player)
                end
                
                if _G.SkeletonESP then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part.Name == "RivalsSkeleton" then
                            part:Destroy()
                        end
                    end
                    CreateSkeletonESP(player)
                end
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if _G.AimbotEnabled and input.UserInputType == _G.AimbotKey then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end)

Rayfield:Notify({
    Title = "Rivals X загружен!",
    Content = "Успешно внедрен. Удачного использования!",
    Duration = 5,
})
