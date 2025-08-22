local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XikiSkriptsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Фон
local background = Instance.new("Frame")
background.Size = UDim2.new(1,0,1,0)
background.BackgroundColor3 = Color3.fromRGB(20,20,20)
background.BackgroundTransparency = 1
background.Parent = screenGui

-- Панель меню
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0,420,0,320)
menuFrame.Position = UDim2.new(0.5,-210,0.5,-160)
menuFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
menuFrame.BackgroundTransparency = 1
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui
menuFrame.ClipsDescendants = true

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "🟣 Xiki | Lucky Block BG"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = menuFrame

-- Пример секций (визуально, как вкладки)
local function createSection(name, yPos)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1,-20,0,30)
    section.Position = UDim2.new(0,10,0,yPos)
    section.BackgroundTransparency = 1
    section.Text = name
    section.TextColor3 = Color3.fromRGB(180,180,180)
    section.Font = Enum.Font.GothamSemibold
    section.TextSize = 20
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = menuFrame
end

createSection("Character", 70)
createSection("Lucky Blocks", 120)
createSection("Clock Time", 170)
createSection("Advanced", 220)

-- Плавное появление GUI
local function fadeInUI()
    local bgTween = TweenService:Create(background, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
    local menuTween = TweenService:Create(menuFrame, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    bgTween:Play()
    menuTween:Play()
end

fadeInUI()
