-- Xiki Skripts Custom GUI
-- Авторы: Xiki
-- Появление меню с плавной анимацией и секциями

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XikiSkriptsCustomGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Фон
local background = Instance.new("Frame")
background.Size = UDim2.new(1,0,1,0)
background.BackgroundColor3 = Color3.fromRGB(15,15,15)
background.BackgroundTransparency = 1
background.Parent = screenGui

-- Главная панель
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0,450,0,350)
menuFrame.Position = UDim2.new(0.5,-225,0.5,-175)
menuFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
menuFrame.BackgroundTransparency = 1
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui
menuFrame.ClipsDescendants = true

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,60)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "🟣 Xiki Skripts"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = menuFrame

-- Секции меню (пример)
local function createSection(name, yPos)
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -20, 0, 30)
    sectionLabel.Position = UDim2.new(0, 10, 0, yPos)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = name
    sectionLabel.TextColor3 = Color3.fromRGB(180,180,180)
    sectionLabel.Font = Enum.Font.GothamSemibold
    sectionLabel.TextSize = 20
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = menuFrame
    return sectionLabel
end

createSection("Character", 70)
createSection("Lucky Blocks", 120)
createSection("Clock Time", 170)
createSection("Advanced", 220)

-- Функция плавного появления
local function fadeInUI()
    local bgTween = TweenService:Create(background, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6})
    local menuTween = TweenService:Create(menuFrame, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    bgTween:Play()
    menuTween:Play()
end

-- Анимация запуска
fadeInUI()
