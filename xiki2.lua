-- FruitXploit v2.1 для Blox Fruits
-- Автор: Ваше имя
-- Для использования требуется исполнитель (Krnl, Synapse X и т.д.)

-- Проверка что игра загрузилась
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Проверка что мы в Blox Fruits (ID миров игры)
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.Players.LocalPlayer.PlaceId ~= 7449423635 then
    game:GetService("Players").LocalPlayer:Kick("❌ Этот скрипт работает только в Blox Fruits!")
    return
end

-- Загрузка библиотек
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Глобальные переменные
_G.AutoFarm = false
_G.AutoQuest = false
_G.Noclip = false
_G.AutoCollectFruits = false
_G.FruitESP = false
_G.PlayerESP = false
_G.BringFruits = false

-- Создание основного окна
local Window = Rayfield:CreateWindow({
    Name = "🍉 FruitXploit v2.1",
    LoadingTitle = "Загрузка FruitXploit...",
    LoadingSubtitle = "by Ваше имя",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FruitXploit",
        FileName = "Config"
    },
    KeySystem = false, -- Set to true to use key system
    KeySettings = {
        Title = "Система ключей",
        Subtitle = "Введите ключ",
        Note = "Присоединитесь к дискорд-серверу для получения ключа",
        FileName = "FruitXKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"KEY_12345"}
    }
})

-- Создание вкладок
local MainTab = Window:CreateTab("Главная", 13014546637)
local PlayerTab = Window:CreateTab("Игрок", 13014547629)
local FarmTab = Window:CreateTab("Фарминг", 13014548637)
local FruitTab = Window:CreateTab("Фрукты", 13014549637)
local TeleportTab = Window:CreateTab("Телепорты", 13014550637)
local InfoTab = Window:CreateTab("Информация", 13014551637)

-- Функция для поиска NPC
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

-- Функция для поиска фруктов
function FindFruits()
    local fruits = {}
    for _, fruit in pairs(Workspace:GetChildren()) do
        if fruit:FindFirstChild("Handle") and fruit:IsA("Tool") then
            table.insert(fruits, fruit)
        end
    end
    return fruits
end

-- Функция для ESP
function CreateESP(object, color, name)
    local highlight = Instance.new("Highlight")
    highlight.Name = "FruitXploitESP"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = object
    highlight.Adornee = object
    
    if name then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "FruitXploitBillboard"
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

-- Удаление ESP
function RemoveESP()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "FruitXploitESP" or obj.Name == "FruitXploitBillboard" then
            obj:Destroy()
        end
    end
end

-- Главная вкладка
local MainSection = MainTab:CreateSection("Основные настройки")

MainTab:CreateButton({
    Name = "Перезагрузить интерфейс",
    Callback = function()
        Rayfield:Destroy()
        loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
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

-- Вкладка игрока
local PlayerSection = PlayerTab:CreateSection("Изменение персонажа")

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
        if Value then
            while Rayfield.Flags["InfiniteEnergy"] and task.wait() do
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:SetAttribute("Energy", 100)
                    end
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NickelHUBB/RobloxScript/main/Fly.lua"))()
    end
})

-- Вкладка фарминга
local FarmSection = FarmTab:CreateSection("Авто-фарминг")

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
                    -- Телепортация к NPC
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                    
                    -- Атака
                    VirtualInputManager:SendKeyEvent(true, "X", false, game)
                    task.wait(0.2)
                    VirtualInputManager:SendKeyEvent(false, "X", false, game)
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
        
        while _G.AutoQuest and task.wait(1) do
            pcall(function()
                -- Здесь должен быть код для автоматического взятия квестов
                -- Это сложная часть, требующая анализа игры
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Аура убийства мобов",
    CurrentValue = false,
    Flag = "MobAura",
    Callback = function(Value)
        if Value then
            while Rayfield.Flags["MobAura"] and task.wait(0.3) do
                pcall(function()
                    for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                            if distance < 50 then
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

-- Вкладка фруктов
local FruitSection = FruitTab:CreateSection("Фрукты")

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

-- Вкладка телепортов
local IslandSection = TeleportTab:CreateSection("Острова")

local islands = {
    "Старый мир",
    "Пиратская деревня",
    "Пустыня",
    "Ледяной остров",
    "Военный форт",
    "Остров обезьян",
    "Средний мир",
    "Небесный остров",
    "Подводный город",
    "Фабрика",
    "Царство духов",
    "Новый мир",
    "Зо"
}

local IslandDropdown = TeleportTab:CreateDropdown({
    Name = "Телепорт на остров",
    Options = islands,
    CurrentOption = "Старый мир",
    Flag = "IslandDropdown",
    Callback = function(Option)
        -- Здесь должен быть код телепортации на выбранный остров
        Rayfield:Notify({
            Title = "Телепортация",
            Content = "Телепортация на " .. Option,
            Duration = 3,
            Image = 13014546637
        })
    end
})

local BossSection = TeleportTab:CreateSection("Боссы")

local bosses = {
    "Горбуччи",
    "Лейтенант",
    "Капитан",
    "Смокер",
    "Зоро",
    "Дон-Крейн",
    "Арлон",
    "Диабло",
    "Скайхо",
    "Адмирал"
}

local BossDropdown = TeleportTab:CreateDropdown({
    Name = "Телепорт к боссу",
    Options = bosses,
    CurrentOption = "Горбуччи",
    Flag = "BossDropdown",
    Callback = function(Option)
        -- Здесь должен быть код телепортации к выбранному боссу
        Rayfield:Notify({
            Title = "Телепортация",
            Content = "Телепортация к " .. Option,
            Duration = 3,
            Image = 13014546637
        })
    end
})

-- Вкладка информации
InfoTab:CreateSection("Информация")

InfoTab:CreateLabel("FruitXploit v2.1")
InfoTab:CreateLabel("Создано для Blox Fruits")
InfoTab:CreateLabel("Используйте на свой страх и риск!")

InfoTab:CreateButton({
    Name = "Скопировать Discord",
    Callback = function()
        setclipboard("https://discord.gg/example")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Ссылка скопирована в буфер обмена!",
            Duration = 3,
            Image = 13014546637
        })
    end
})

InfoTab:CreateButton({
    Name = "Скопировать Telegram",
    Callback = function()
        setclipboard("https://t.me/example")
        Rayfield:Notify({
            Title = "Telegram",
            Content = "Ссылка скопирована в буфер обмена!",
            Duration = 3,
            Image = 13014546637
        })
    end
})

-- Обработка событий
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if Rayfield.Flags["WalkSpeed"] then
        character.Humanoid.WalkSpeed = Rayfield.Flags["WalkSpeed"].CurrentValue
    end
    if Rayfield.Flags["JumpPower"] then
        character.Humanoid.JumpPower = Rayfield.Flags["JumpPower"].CurrentValue
    end
end)

-- Ноклип цикл
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "FruitXploit загружен!",
    Content = "Успешно внедрен. Удачного использования!",
    Duration = 5,
    Image = 13014546637
})
