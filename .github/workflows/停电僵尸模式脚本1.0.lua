local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ChinaQY/-/Main/UI"))()

OrionLib:MakeNotification({
    Name = "罗华涛专用外挂",
    Content = "正在查看白名单",
    Time = 2.5
})

local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://4590662766"
Sound.Parent = game:GetService("SoundService")
Sound.Volume = 5
Sound:Play()
Sound.Ended:Wait()
Sound:Destroy()

local function applyHighlight(instance, color)
    if not instance:IsA("Model") and not instance:IsA("BasePart") then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ColoredHighlight"
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Parent = instance
end

local Window = OrionLib:MakeWindow({
    Name = "华强北中心",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "欠别中心",
    ConfigFolder = "华强北中心"
})

local Tab = Window:MakeTab({
    Name = "公告",
    Icon = "rbxassetid://109745273423370",
    PremiumOnly = false
})

Tab:AddLabel("罗华涛我操你妈")
Tab:AddLabel("此脚本是罗建豪做的")
Tab:AddLabel("欠别版")

local Tab = Window:MakeTab({
    Name = "华强北",
    Icon = "rbxassetid://109745273423370",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "华涛rage bot（不推荐用）",
    Callback = function()
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")

        local combatUI = Instance.new("ScreenGui")
        combatUI.Name = "CombatUIController"
        combatUI.ResetOnSpawn = false

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 150, 0, 60)
        frame.Position = UDim2.new(0.5, -75, 0.8, -30)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BackgroundTransparency = 0.3
        frame.Active = true
        frame.Draggable = true
        frame.Selectable = true
        frame.Parent = combatUI

        local uICorner = Instance.new("UICorner")
        uICorner.CornerRadius = UDim.new(0.3, 0)
        uICorner.Parent = frame

        local statusText = Instance.new("TextLabel")
        statusText.Size = UDim2.new(1, 0, 1, 0)
        statusText.BackgroundTransparency = 1
        statusText.Text = "DISABLED"
        statusText.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusText.Font = Enum.Font.GothamBold
        statusText.TextSize = 18
        statusText.Parent = frame

        combatUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

        local running = false
        local currentTarget = nil
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local function findValidNPCs()
            local npcs = {}
            local customFolder = workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild("Custom")
            
            if customFolder then
                for _, npc in ipairs(customFolder:GetChildren()) do
                    if npc:IsA("Model") and npc.PrimaryPart then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            table.insert(npcs, {
                                model = npc,
                                humanoid = humanoid,
                                primaryPart = npc.PrimaryPart,
                                distance = (humanoidRootPart.Position - npc.PrimaryPart.Position).Magnitude
                            })
                        end
                    end
                end
            end
            
            table.sort(npcs, function(a, b) return a.distance < b.distance end)
            return npcs
        end

        local function reloadLoop()
            while running do
                game:GetService("ReplicatedStorage"):WaitForChild("GunStorage"):WaitForChild("Events"):WaitForChild("Reload"):InvokeServer()
                task.wait(0.01)
            end
        end

        local function executeAttack(target)
            if not target or not target.primaryPart then return false end
            
            local shootArgs = {
                target.primaryPart.Position,
                target.primaryPart.CFrame,
                1, 1, 3305, 8619
            }
            game:GetService("ReplicatedStorage"):WaitForChild("GunStorage"):WaitForChild("Events"):WaitForChild("Shoot"):FireServer(unpack(shootArgs))
            
            task.wait(0.000001)
            
            local hitPart = target.model:FindFirstChild("Head") or target.model:FindFirstChild("Right Leg") or target.primaryPart
            local hitArgs = { hitPart, 8619 }
            game:GetService("ReplicatedStorage"):WaitForChild("GunStorage"):WaitForChild("Events"):WaitForChild("Hit"):FireServer(unpack(hitArgs))
            
            if target.humanoid.Health <= 0 then
                return false
            end
            
            return true
        end

        local function combatLoop()
            while running do
                if not currentTarget then
                    local npcs = findValidNPCs()
                    currentTarget = #npcs > 0 and npcs[1] or nil
                end
                
                if currentTarget then
                    if not executeAttack(currentTarget) then
                        currentTarget = nil
                    end
                else
                    task.wait(0.5)
                end
            end
        end

        local function toggleCombat()
            running = not running
            statusText.Text = running and "ENABLED" or "DISABLED"
            statusText.TextColor3 = running and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
            
            if running then
                task.spawn(reloadLoop)
                task.spawn(combatLoop)
            else
                currentTarget = nil
            end
        end

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                toggleCombat()
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == Enum.KeyCode.H and not gameProcessed then
                toggleCombat()
            end
        end)
    end
})

Tab:AddButton({
    Name = "近战杀戮光环（新）",
    Callback = function()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local running = false
local combatConnection = nil
local checkConnection = nil

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("Head")

local currentTarget = {
    npc = nil,
    part = nil,
    humanoid = nil,
    distance = math.huge
}

local function hasLivingNPCs()
    local customFolder = workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild("Custom")
    if not customFolder then return false end
    
    for _, npc in ipairs(customFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                return true
            end
        end
    end
    return false
end

local function findNearestNPC()
    local closest = {
        npc = nil,
        part = nil,
        humanoid = nil,
        distance = math.huge
    }

    local customFolder = workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild("Custom")
    if not customFolder then return closest end

    for _, npc in ipairs(customFolder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            local rootPart = npc:FindFirstChild("Head") or npc.PrimaryPart
            
            if humanoid and humanoid.Health > 0 and rootPart then
                local distance = (humanoidRootPart.Position - rootPart.Position).Magnitude
                if distance < closest.distance and distance < 50 then
                    closest = {
                        npc = npc,
                        part = rootPart,
                        humanoid = humanoid,
                        distance = distance
                    }
                end
            end
        end
    end

    return closest
end

local function executeAttack()
    if not running then return end
    
    game:GetService("ReplicatedStorage").MeleeStorage.Events.Swing:InvokeServer()

    if currentTarget.part then
        local hitArgs = {
            currentTarget.part,
            currentTarget.part.Position
        }
        game:GetService("ReplicatedStorage").MeleeStorage.Events.Hit:FireServer(unpack(hitArgs))
    end
end

local function startCombat()
    if combatConnection then combatConnection:Disconnect() end
    
    combatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not running then return end
        
        currentTarget = findNearestNPC()
        executeAttack()
        task.wait(0.0000001)
    end)
end

local function monitorNPCs()
    if checkConnection then checkConnection:Disconnect() end
    
    checkConnection = RunService.Heartbeat:Connect(function()
        if not running and hasLivingNPCs() then
            running = true
            startCombat()
        end
        
        if running and not hasLivingNPCs() then
            running = false
        end
    end)
end

monitorNPCs()
end
})

Tab:AddButton({
    Name = "仅支持电脑医疗兵自动回血弓弩（K快捷键）",
    Callback = function()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local running = false

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local playerTargets = {}
local currentTarget = nil
local lastReloadTime = 0
local RELOAD_INTERVAL = 10
local MAX_DISTANCE = 1000
local HEALTH_THRESHOLD = 70
local hasEquipped = false

local function equipCrossbow()
    if hasEquipped then return end
    
    local args = {
        player:WaitForChild("PlayerGui"):WaitForChild("Backpack"):WaitForChild("Crossbow")
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Events")
                  :WaitForChild("Items")
                  :WaitForChild("Equip")
                  :FireServer(unpack(args))
    hasEquipped = true
end

local function executeReloadSequence()
    game:GetService("ReplicatedStorage"):WaitForChild("GunStorage")
                  :WaitForChild("Events")
                  :WaitForChild("Reload")
                  :InvokeServer()
    game:GetService("ReplicatedStorage"):WaitForChild("GunStorage")
                  :WaitForChild("Events")
                  :WaitForChild("Reload")
                  :InvokeServer()
    local args = {"MagIn"}
    game:GetService("ReplicatedStorage"):WaitForChild("GunStorage")
                  :WaitForChild("Events")
                  :WaitForChild("Action")
                  :FireServer(unpack(args))
    lastReloadTime = os.time()
end

local function findNearestPlayer()
    local closest = {
        target = nil,
        distance = math.huge,
        data = nil
    }

    for _, data in ipairs(playerTargets) do
        if data.character and data.character.PrimaryPart and data.humanoid.Health < HEALTH_THRESHOLD then
            local distance = (humanoidRootPart.Position - data.character.PrimaryPart.Position).Magnitude
            if distance < closest.distance and distance <= MAX_DISTANCE then
                closest = {
                    target = data.player,
                    distance = distance,
                    data = data
                }
            end
        end
    end

    return closest.distance <= MAX_DISTANCE and closest or nil
end

local function refreshPlayerTargets()
    playerTargets = {}
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local humanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(playerTargets, {
                    player = otherPlayer,
                    character = otherPlayer.Character,
                    humanoid = humanoid,
                    lastHealth = humanoid.Health
                })
            end
        end
    end
end

local function isTargetValid(target)
    return target and 
           target.character and 
           target.character.PrimaryPart and
           target.humanoid and 
           target.humanoid.Health > 0
end

local function executeAttack()
    currentTarget = findNearestPlayer()
    if not currentTarget then
        refreshPlayerTargets()
        return
    end

    local shootArgs = {
        currentTarget.data.character.PrimaryPart.Position,
        currentTarget.data.character.PrimaryPart.CFrame,
        1, 1, 9999999, 99999999
    }
    game:GetService("ReplicatedStorage").GunStorage.Events.Shoot:FireServer(unpack(shootArgs))

    local hitPart = currentTarget.data.character:FindFirstChild("Head") or currentTarget.data.character.PrimaryPart
    local hitArgs = { hitPart, 99999999 }
    game:GetService("ReplicatedStorage").GunStorage.Events.Hit:FireServer(unpack(hitArgs))
    
    executeReloadSequence()
end

local function startAttackLoop()
    equipCrossbow()
    hasEquipped = false
    
    local connection
    local lastAttack = 0
    
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not running then 
            connection:Disconnect()
            return 
        end
        
        for i = #playerTargets, 1, -1 do
            if not isTargetValid(playerTargets[i]) then
                table.remove(playerTargets, i)
            end
        end

        lastAttack = lastAttack + deltaTime
        if lastAttack >= 0.001 then
            lastAttack = 0
            executeAttack()
        end
    end)
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        running = not running
        if running then
            if #playerTargets == 0 then refreshPlayerTargets() end
            startAttackLoop()
        end
    end
end)

Players.PlayerAdded:Connect(function()
    if running then refreshPlayerTargets() end
end)

Players.PlayerRemoving:Connect(function()
    if running then refreshPlayerTargets() end
end)

refreshPlayerTargets()
    end
})

Tab:AddButton({
    Name = "改移速",
    Callback = function()
-- This script is made to bypass the mini games that changes the player speed like get +1 speed per second
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Num = Instance.new("TextBox")
local Plus = Instance.new("TextButton")
local Minus = Instance.new("TextButton")

-- 添加关闭按钮
local CloseButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- 添加绿色描边
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 1
UIStroke.Parent = Frame

-- 设置科幻字体
local scifiFont = Enum.Font.SciFi

Num.Size = UDim2.new(0.6, 0, 0.6, 0)
Num.Position = UDim2.new(0.2, 0, 0.3, 0)
Num.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Num.TextColor3 = Color3.fromRGB(255, 0, 0)  -- 绿色字体
Num.TextScaled = true
Num.Font = scifiFont  -- 科幻字体
Num.ClearTextOnFocus = true
Num.Parent = Frame

Plus.Size = UDim2.new(0.2, 0, 0.6, 0)
Plus.Position = UDim2.new(0.8, 0, 0.3, 0)
Plus.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Plus.TextColor3 = Color3.fromRGB(255, 0, 0)  -- 绿色字体
Plus.TextScaled = true
Plus.Font = scifiFont  -- 科幻字体
Plus.Text = "+"
Plus.Parent = Frame

Minus.Size = UDim2.new(0.2, 0, 0.6, 0)
Minus.Position = UDim2.new(0, 0, 0.3, 0)
Minus.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Minus.TextColor3 = Color3.fromRGB(0, 255, 0)  -- 绿色字体
Minus.TextScaled = true
Minus.Font = scifiFont  -- 科幻字体
Minus.Text = "-"
Minus.Parent = Frame

-- 设置关闭按钮
CloseButton.Size = UDim2.new(0.15, 0, 0.2, 0)
CloseButton.Position = UDim2.new(0.85, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Text = "X"
CloseButton.Font = scifiFont  -- 科幻字体
CloseButton.Parent = Frame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local player = game.Players.LocalPlayer
local number
local humanoid
local EditingNum = false

local function UpdateNum()
    Num.Text = tostring(number)
    if humanoid then
        humanoid.WalkSpeed = number
    end
end

local function onCharacterAdded(character)
    humanoid = character:WaitForChild("Humanoid")
    number = humanoid.WalkSpeed
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed ~= number then
            humanoid.WalkSpeed = number
        end
    end)
    UpdateNum()
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
    onCharacterAdded(player.Character)
end

Plus.MouseButton1Click:Connect(function()
    number = number + 1
    UpdateNum()
end)

Minus.MouseButton1Click:Connect(function()
    if number > 0 then
        number = number - 1
        UpdateNum()
    end
end)

Num.Focused:Connect(function()
    EditingNum = true
end)

Num.FocusLost:Connect(function(enterPressed)
    EditingNum = false
    if enterPressed then
        local Value = tonumber(Num.Text)
        if Value and Value > 0 then
            number = Value
            UpdateNum()
        else
            UpdateNum()
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "[Bypass] WalkSpeed Gui",
    Text = "Made By Luojianhao",
    Duration = 12
})

UpdateNum()
    end
})

Tab:AddButton({
    Name = "ESP透视",
    Callback = function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function createHighlight(npc)
    local highlight = Instance.new("Highlight")
    highlight.Name = "NPC_Highlight"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.5
    
    if npc.Name == "Military Scout" then
        highlight.FillColor = Color3.fromRGB(0, 100, 255)
    else
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
    end
    
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = npc
end

local function checkNPCStatus(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local highlight = npc:FindFirstChild("NPC_Highlight")
    
    if humanoid and highlight then
        if npc.Name ~= "Military Scout" then
            if humanoid.Health <= 0 then
                highlight.FillColor = Color3.fromRGB(255, 255, 255)
            else
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end

local function monitorNPCs()
    while true do
        local npcFolder = workspace:FindFirstChild("NPCs")
        if npcFolder then
            local customFolder = npcFolder:FindFirstChild("Custom")
            if customFolder then
                for _, npc in ipairs(customFolder:GetChildren()) do
                    if npc:IsA("Model") then
                        if not npc:FindFirstChild("NPC_Highlight") then
                            createHighlight(npc)
                        end
                        checkNPCStatus(npc)
                    end
                end
            end
        end
        wait(0.5)
    end
end

spawn(monitorNPCs)
    end
})

OrionLib:Init()