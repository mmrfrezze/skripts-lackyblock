-- Xiki Skripts GUI Loader
-- Авторы: Xiki
-- Предназначение: Красивое появление меню при запуске

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Создание ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XikiSkriptsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Фон (полупрозрачный)
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
background.BackgroundTransparency = 1
background.Parent = screenGui

-- Главная панель меню
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 400, 0, 300)
menuFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BackgroundTransparency = 1
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui

-- Название
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Xiki Skripts"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = menuFrame

-- Функция плавного появления
local function fadeInUI()
    local bgTween = TweenService:Create(background, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
    local menuTween = TweenService:Create(menuFrame, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0})

    bgTween:Play()
    menuTween:Play()
end

-- Функция запуска анимации появления
fadeInUI()
