local plrs = game.Players
local plr = plrs.LocalPlayer
local uis = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

local jumpPower = 50
local auraActive = false
local auraRadius = 50

plr.Character.Humanoid.JumpPower = jumpPower

uis.JumpRequest:Connect(function()
    plr.Character.Humanoid:ChangeState("Jumping")
end)

local function equipFirstTool()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = plr.Character
            return tool
        end
    end
end

local function killNPC(npc)
    if not npc or not npc.Parent then return end
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    local humanoid = npc:FindFirstChild("Humanoid")
    if not hrp or not humanoid or humanoid.Health <= 0 then return end
    local lastCF = plr.Character.HumanoidRootPart.CFrame
    local tool = equipFirstTool()
    if not tool then return end
    plr.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0,2,0)
    task.wait(0.1)
    tool:Activate()
    task.wait(0.1)
    plr.Character.HumanoidRootPart.CFrame = lastCF
end

local function startAura()
    while auraActive do
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, npc in pairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    if npc.Humanoid.Health > 0 and (hrp.Position - npc.HumanoidRootPart.Position).Magnitude <= auraRadius then
                        killNPC(npc)
                        break
                    end
                end
            end
        end
        task.wait(0.3)
    end
end

local function toggleAura(state)
    auraActive = state
    if state then
        coroutine.wrap(startAura)()
    end
end

local function teleportToPlayer(targetName)
    local target = plrs:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🟣 Xiki | Block Fruits",
    LoadingTitle = "Xiki UI",
    LoadingSubtitle = "Minimal & Clean",
    ConfigurationSaving = {Enabled=true, FolderName="Xiki UI", FileName="BlockFruits"},
    Discord={Enabled=false},
    KeySystem=false
})

local CharTab = Window:CreateTab("Character", 4483362458)
local AdvTab = Window:CreateTab("Advanced", 4483362458)

CharTab:CreateSection("Movement")
CharTab:CreateSlider({Name="Jump Power", Range={10,300}, Increment=1, CurrentValue=jumpPower, Callback=function(v)
    jumpPower=v
    plr.Character.Humanoid.JumpPower=v
end})

AdvTab:CreateSection("Combat")
AdvTab:CreateToggle({Name="Kill Aura NPC", CurrentValue=false, Callback=function(v) toggleAura(v) end})
AdvTab:CreateSlider({Name="Aura Radius", Range={5,100}, Increment=1, CurrentValue=auraRadius, Callback=function(v) auraRadius=v end})
AdvTab:CreateDropdown({Name="Teleport to Player", Options=function()
    local opts = {}
    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= plr then table.insert(opts,p.Name) end
    end
    return opts
end, Callback=function(v) teleportToPlayer(v) end})
