local plrs = game.Players
local plr = plrs.LocalPlayer
local uis = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

local infJump = false
local auraActive = false
local auraRadius = 50

-- Infinite Jump
uis.JumpRequest:Connect(function()
    if infJump then
        plr.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- Equip first tool
local function equipFirstTool()
    local backpack = plr.Backpack
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = plr.Character
            return tool
        end
    end
end

-- Kill one NPC
local function killNPC(npc)
    if not npc or not npc.Parent then return end
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    local humanoid = npc:FindFirstChild("Humanoid")
    if not hrp or not humanoid or humanoid.Health <= 0 then return end

    local lastCF = plr.Character.HumanoidRootPart.CFrame
    local tool = equipFirstTool()
    if not tool then return end

    -- Подлет над NPC (2 блока выше)
    plr.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0,2,0)
    task.wait(0.1)

    -- Атака
    tool:Activate()
    task.wait(0.1)

    -- Возврат
    plr.Character.HumanoidRootPart.CFrame = lastCF
end

-- Kill Aura (по очереди)
local function startAura()
    while auraActive do
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- находим первого NPC в радиусе
            for _, npc in pairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    if npc.Humanoid.Health > 0 then
                        if (hrp.Position - npc.HumanoidRootPart.Position).Magnitude <= auraRadius then
                            killNPC(npc)
                            break -- после убийства одного, идём к следующему циклу
                        end
                    end
                end
            end
        end
        task.wait(0.3) -- пауза перед следующей атакой
    end
end

-- Toggle Aura
local function toggleAura(state)
    auraActive = state
    if state then
        coroutine.wrap(startAura)()
    end
end

-- Teleport to Player
local function teleportToPlayer(targetName)
    local target = plrs:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end

-- Example Usage:
-- infJump = true
-- toggleAura(true)
-- teleportToPlayer("PlayerName")
