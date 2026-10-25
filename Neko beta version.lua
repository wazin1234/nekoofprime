-- ============================================================================
-- NEKO HUB V1 | THE RAKE ULTIMATE COMPLETE EDITION (NOCLIP + SPEED SLIDER 60)
-- ============================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local ParentGui = CoreGui

--------------------------------------------------------------------------------
-- UNIVERSAL DRAGGABLE HELPER
--------------------------------------------------------------------------------
local function makeDraggable(guiFrame, dragHandle)
    dragHandle = dragHandle or guiFrame
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--------------------------------------------------------------------------------
-- KEYS & AUTHENTICATION SCREEN (NEKO HUB V1)
--------------------------------------------------------------------------------
local ADMIN_USERNAME = "puraCLCNZ2"

local VALID_KEYS_LOOKUP = {
    ["Neko2026"] = true
}

local isAdmin = (LocalPlayer.Name:lower() == ADMIN_USERNAME:lower())

local LoadScreenGui = Instance.new("ScreenGui", ParentGui)
LoadScreenGui.Name = "NekoHubLoading"
LoadScreenGui.ResetOnSpawn = false
LoadScreenGui.DisplayOrder = 999

local LoadFrame = Instance.new("Frame", LoadScreenGui)
LoadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoadFrame.Size = UDim2.new(0, 440, 0, 250)
LoadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(26, 20, 24)
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 14)
local LoadStroke = Instance.new("UIStroke", LoadFrame)
LoadStroke.Thickness = 2.5
LoadStroke.Color = Color3.fromRGB(255, 182, 193)

makeDraggable(LoadFrame)

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1, 0, 0, 40)
LoadTitle.Position = UDim2.new(0, 0, 0, 6)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "🌸 NEKO HUB V1 — AUTHENTICATION 🌸"
LoadTitle.TextColor3 = Color3.fromRGB(255, 182, 193)
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextSize = 12

local StatusLabel = Instance.new("TextLabel", LoadFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 24)
StatusLabel.Position = UDim2.new(0, 0, 0.32, 0)
StatusLabel.BackgroundTransparency = 1

-- Corrección del operador ternario para Luau (if-else clásico)
if isAdmin then
    StatusLabel.Text = "👑 Welcome Admin: " .. ADMIN_USERNAME
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
else
    StatusLabel.Text = "Enter Key..."
    StatusLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
end

StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

local KeyInputBox = Instance.new("TextBox", LoadFrame)
KeyInputBox.Size = UDim2.new(0.88, 0, 0, 38)
KeyInputBox.Position = UDim2.new(0.06, 0, 0.45, 0)
KeyInputBox.BackgroundColor3 = Color3.fromRGB(38, 28, 34)
KeyInputBox.PlaceholderText = "Enter Key..."
KeyInputBox.Text = ""
KeyInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInputBox.PlaceholderColor3 = Color3.fromRGB(180, 160, 170)
KeyInputBox.Font = Enum.Font.GothamBold
KeyInputBox.TextSize = 11
KeyInputBox.ClearTextOnFocus = false
Instance.new("UICorner", KeyInputBox).CornerRadius = UDim.new(0, 8)

local SubmitKeyBtn = Instance.new("TextButton", LoadFrame)
SubmitKeyBtn.Size = UDim2.new(0.88, 0, 0, 38)
SubmitKeyBtn.Position = UDim2.new(0.06, 0, 0.72, 0)
SubmitKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
SubmitKeyBtn.Text = "🚀 VERIFY KEY & LAUNCH"
SubmitKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitKeyBtn.Font = Enum.Font.GothamBold
SubmitKeyBtn.TextSize = 11
Instance.new("UICorner", SubmitKeyBtn).CornerRadius = UDim.new(0, 8)

local authenticated = false

if isAdmin then
    LoadScreenGui:Destroy()
    authenticated = true
else
    SubmitKeyBtn.Activated:Connect(function()
        if VALID_KEYS_LOOKUP[KeyInputBox.Text:gsub("%s+", "")] then
            LoadScreenGui:Destroy()
            authenticated = true
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
            StatusLabel.Text = "❌ INVALID KEY!"
        end
    end)
    repeat task.wait(0.1) until authenticated
end

--------------------------------------------------------------------------------
-- MAIN HUB CLEANUP & SETUP
--------------------------------------------------------------------------------
if getgenv().NekoHubCleanup then pcall(getgenv().NekoHubCleanup) end

local Features = {
    Fly = false, InfJump = false, FullBright = false,
    AutoAttack = false, BringBoss = false, 
    AutoPickup = false, TriggerBot = false, AutoKill = false,
    Noclip = false, AutoInteract = false, AutoMiscSouls = false, 
    PlayerESP = false, RakeESP = false, InfReach = false, AIBattle = false,
    BringSpawnables = false, AutoCandyTP = false, WalkSpeedBoost = false,
    ContinuousFire = false, AutoEscape = false
}

local InfReachDistance = 25
local CustomWalkSpeedVal = 16

local Connections, Tasks = {}, {}
local OrigLighting = {Ambient = Lighting.Ambient, Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows}

getgenv().NekoHubCleanup = function()
    for _, conn in pairs(Connections) do if conn then conn:Disconnect() end end
    for _, taskRef in pairs(Tasks) do if taskRef then pcall(task.cancel, taskRef) end end
    table.clear(Connections); table.clear(Tasks)
    if Features.FullBright then
        Lighting.Ambient = OrigLighting.Ambient
        Lighting.Brightness = OrigLighting.Brightness
        Lighting.ClockTime = OrigLighting.ClockTime
        Lighting.GlobalShadows = OrigLighting.GlobalShadows
    end
    if ParentGui:FindFirstChild("NekoHubMainGui") then ParentGui.NekoHubMainGui:Destroy() end
    if ParentGui:FindFirstChild("NekoHubPlayerHPGui") then ParentGui.NekoHubPlayerHPGui:Destroy() end
end

local OFF_GRAD = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 30, 40)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 20, 25))})
local ON_GRAD  = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 182, 193)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 105, 180))})

local function safeBindClick(btn, cb) btn.Activated:Connect(function() pcall(cb) end) end

local cachedRake, cachedPart = nil, nil
local lastRakeCheck = 0
local function findTheRakeModel()
    if tick() - lastRakeCheck > 1.5 or not cachedRake or not cachedRake.Parent then
        cachedRake, cachedPart = nil, nil
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                local lowerName = obj.Name:lower()
                local isRakeName = false
                if obj.Name == "THE_RAKE" or string.match(lowerName, "rake") or string.match(lowerName, "rakoof") then
                    isRakeName = true
                end
                
                if isRakeName then
                    local p = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
                    if p then
                        cachedRake, cachedPart = obj, p
                        break
                    end
                end
            end
        end
        if not cachedRake then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    local lowerName = obj.Name:lower()
                    local isRakeName = false
                    if obj.Name == "THE_RAKE" or string.match(lowerName, "rake") or string.match(lowerName, "rakoof") then
                        isRakeName = true
                    end
                    
                    if isRakeName then
                        local p = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
                        if p then
                            cachedRake, cachedPart = obj, p
                            break
                        end
                    end
                end
            end
        end
        lastRakeCheck = tick()
    end
    return cachedRake, cachedPart
end

--------------------------------------------------------------------------------
-- MAIN GUI CREATION
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", ParentGui)
ScreenGui.Name = "NekoHubMainGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100

local ToggleIcon = Instance.new("TextButton", ScreenGui)
ToggleIcon.Size = UDim2.new(0, 48, 0, 48)
ToggleIcon.Position = UDim2.new(0, 15, 0.3, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(35, 20, 30)
ToggleIcon.Text = "🌸"
ToggleIcon.TextSize = 24
ToggleIcon.ZIndex = 200
ToggleIcon.Active = true
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", ToggleIcon).Color = Color3.fromRGB(255, 182, 193)
makeDraggable(ToggleIcon)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 720, 0, 480)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(26, 20, 24)
MainFrame.ClipsDescendants = false
MainFrame.Active = true
MainFrame.ZIndex = 10
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 182, 193)
makeDraggable(MainFrame)

Connections.KeybindToggle = UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 22, 30)
TitleBar.ZIndex = 11
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(0.7, 0, 1, 0); TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.BackgroundTransparency = 1; TitleText.Text = "🌸 NEKO HUB V1 (Right Ctrl to Hide)"
TitleText.TextColor3 = Color3.fromRGB(255, 182, 193); TitleText.Font = Enum.Font.GothamBold; TitleText.TextSize = 12
TitleText.ZIndex = 12

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26); CloseBtn.Position = UDim2.new(1, -38, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.ZIndex = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

safeBindClick(CloseBtn, function() MainFrame.Visible = false end)
safeBindClick(ToggleIcon, function() MainFrame.Visible = not MainFrame.Visible end)

--------------------------------------------------------------------------------
-- SIDEBAR TABS SYSTEM
--------------------------------------------------------------------------------
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, -55)
Sidebar.Position = UDim2.new(0, 15, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.ZIndex = 11

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 6)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -200, 1, -60)
ContentArea.Position = UDim2.new(0, 185, 0, 50)
ContentArea.BackgroundColor3 = Color3.fromRGB(32, 24, 30)
ContentArea.ZIndex = 11
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", ContentArea).Color = Color3.fromRGB(255, 182, 193)

local TabFrames = {}
local TabButtons = {}

local function createTab(name, icon, order)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(35, 22, 30)
    btn.Text = "   " .. icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(255, 182, 193)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.ZIndex = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(100, 70, 90)

    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.new(0, 8, 0, 8)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 182, 193)
    page.Visible = false
    page.ZIndex = 13

    local pageList = Instance.new("UIListLayout", page)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Padding = UDim.new(0, 8)

    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageList.AbsoluteContentSize.Y + 10)
    end)

    TabFrames[name] = page
    TabButtons[name] = btn

    btn.Activated:Connect(function()
        for tName, tPage in pairs(TabFrames) do
            tPage.Visible = (tName == name)
            local tBtn = TabButtons[tName]
            if tName == name then
                tBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
                tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                tBtn.BackgroundColor3 = Color3.fromRGB(35, 22, 30)
                tBtn.TextColor3 = Color3.fromRGB(255, 182, 193)
            end
        end
    end)

    return page
end

-- Create Tabs
local InfoPage   = createTab("Info", "ℹ️", 1)
local MainPage   = createTab("Main", "🌸", 2)
local AutoPage   = createTab("Auto", "🔄", 3)
local GunPage    = createTab("Gun", "🔫", 4)
local PlayerPage = createTab("Player", "🏃", 5)

-- Default Active Tab
TabButtons["Main"].BackgroundColor3 = Color3.fromRGB(255, 105, 180)
TabButtons["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)
TabFrames["Main"].Visible = true

local function CreatePageBtn(parentPage, text, order)
    local btn = Instance.new("TextButton", parentPage)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 22, 30); btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.LayoutOrder = order; btn.ZIndex = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local grad = Instance.new("UIGradient", btn); grad.Color = OFF_GRAD; grad.Rotation = 90
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 1; stroke.Color = Color3.fromRGB(100, 70, 90)
    return btn, stroke, grad
end

--------------------------------------------------------------------------------
-- COMPACT HEALTH GUI
--------------------------------------------------------------------------------
local HealthGui = Instance.new("ScreenGui", ParentGui)
HealthGui.Name = "NekoHubPlayerHPGui"
local HealthFrame = Instance.new("Frame", HealthGui)
HealthFrame.Size = UDim2.new(0, 180, 0, 40); HealthFrame.Position = UDim2.new(0.02, 0, 0.25, 0)
HealthFrame.BackgroundColor3 = Color3.fromRGB(26, 20, 24); makeDraggable(HealthFrame)
Instance.new("UICorner", HealthFrame); Instance.new("UIStroke", HealthFrame).Color = Color3.fromRGB(255, 182, 193)

local HPText = Instance.new("TextLabel", HealthFrame)
HPText.Size = UDim2.new(1, 0, 1, 0); HPText.BackgroundTransparency = 1
HPText.TextColor3 = Color3.fromRGB(255, 255, 255); HPText.Font = Enum.Font.GothamBold; HPText.TextSize = 10

Connections.HPTracker = RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        HPText.Text = string.format("💚 HP: %d / %d", math.floor(hum.Health), math.floor(hum.MaxHealth))
    end
end)

--------------------------------------------------------------------------------
-- 1. INFO TAB CONTENT
--------------------------------------------------------------------------------
local InfoCard = Instance.new("Frame", InfoPage)
InfoCard.Size = UDim2.new(1, 0, 0, 120)
InfoCard.BackgroundColor3 = Color3.fromRGB(38, 28, 34)
InfoCard.ZIndex = 14
Instance.new("UICorner", InfoCard).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", InfoCard).Color = Color3.fromRGB(255, 182, 193)

local InfoLabel = Instance.new("TextLabel", InfoCard)
InfoLabel.Size = UDim2.new(1, -20, 1, -20)
InfoLabel.Position = UDim2.new(0, 10, 0, 10)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "🌸 NEKO HUB V1\n\nOwner: puraCLCNZ2\nUser: " .. LocalPlayer.Name .. "\nStatus: Admin Authorized"
InfoLabel.TextColor3 = Color3.fromRGB(255, 182, 193)
InfoLabel.Font = Enum.Font.GothamMedium
InfoLabel.TextSize = 11
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.ZIndex = 15

--------------------------------------------------------------------------------
-- 2. MAIN TAB CONTENT (CON AUTO KILL LOOP)
--------------------------------------------------------------------------------
local AIBattleBtn, AIBattleS, AIBattleG = CreatePageBtn(MainPage, "⚔️ Battle AI Orbit: OFF", 2)
local BringBossBtn, BringS, BringG = CreatePageBtn(MainPage, "🧲 Bring Boss: OFF", 3)
local AttackBtn, AttS, AttG = CreatePageBtn(MainPage, "⚔️ Fast Spam Clicker: OFF", 4)
local TrigBtn, TrigS, TrigG = CreatePageBtn(MainPage, "🎯 Trigger Bot: OFF", 5)
local InfReachBtn, ReachS, ReachG = CreatePageBtn(MainPage, "📏 INF REACH: OFF", 6)
local AutoKillBtn, AutoKillS, AutoKillG = CreatePageBtn(MainPage, "⚡ Auto Kill Loop: OFF", 7)

safeBindClick(AutoKillBtn, function()
    Features.AutoKill = not Features.AutoKill
    AutoKillBtn.Text = Features.AutoKill and "⚡ Auto Kill Loop: ON" or "⚡ Auto Kill Loop: OFF"
    AutoKillG.Color = Features.AutoKill and ON_GRAD or OFF_GRAD
end)

Tasks.AutoKillTask = task.spawn(function()
    while true do
        if Features.AutoKill then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChildOfClass("Tool"))
                local remote = tool and (tool:FindFirstChild("InflictTarget", true) or ReplicatedStorage:FindFirstChild("InflictTarget", true))
                if remote then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not Features.AutoKill then break end
                        if obj:IsA("Model") and obj ~= char then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local part = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                            if hum and part and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                                remote:FireServer(hum, part)
                            end
                        end
                    end
                end
            end)
            task.wait(0.09)
        else
            task.wait(0.2)
        end
    end
end)

--------------------------------------------------------------------------------
-- SLIDER PARA INF REACH
--------------------------------------------------------------------------------
local SliderFrame = Instance.new("Frame", MainPage)
SliderFrame.Size = UDim2.new(1, 0, 0, 55)
SliderFrame.BackgroundColor3 = Color3.fromRGB(38, 28, 34)
SliderFrame.ZIndex = 14
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", SliderFrame).Color = Color3.fromRGB(255, 182, 193)

local SliderLabel = Instance.new("TextLabel", SliderFrame)
SliderLabel.Size = UDim2.new(1, -10, 0, 20)
SliderLabel.Position = UDim2.new(0, 8, 0, 4)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "📏 Inf Reach Distance: 25"
SliderLabel.TextColor3 = Color3.fromRGB(255, 182, 193)
SliderLabel.Font = Enum.Font.GothamBold
SliderLabel.TextSize = 10
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.ZIndex = 15

local SliderBar = Instance.new("Frame", SliderFrame)
SliderBar.Size = UDim2.new(0.92, 0, 0, 10)
SliderBar.Position = UDim2.new(0.04, 0, 0.65, 0)
SliderBar.BackgroundColor3 = Color3.fromRGB(26, 20, 24)
SliderBar.ZIndex = 15
Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 5)

local SliderFill = Instance.new("Frame", SliderBar)
SliderFill.Size = UDim2.new(0.15, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
SliderFill.ZIndex = 16
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 5)

local SliderButton = Instance.new("TextButton", SliderBar)
SliderButton.Size = UDim2.new(1, 0, 1, 0)
SliderButton.BackgroundTransparency = 1
SliderButton.Text = ""
SliderButton.ZIndex = 17

local draggingSlider = false
SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        InfReachDistance = math.floor(10 + (pos * 90))
        SliderLabel.Text = "📏 Inf Reach Distance: " .. InfReachDistance
    end
end)

local angle = 0
safeBindClick(AIBattleBtn, function()
    Features.AIBattle = not Features.AIBattle
    AIBattleBtn.Text = Features.AIBattle and "⚔️ Battle AI Orbit: ON" or "⚔️ Battle AI Orbit: OFF"
    AIBattleG.Color = Features.AIBattle and ON_GRAD or OFF_GRAD
end)
Connections.AIBattleLoop = RunService.RenderStepped:Connect(function(dt)
    if Features.AIBattle then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local _, rakePart = findTheRakeModel()
        if hrp and rakePart then
            angle = angle + (dt * 5)
            local radius = 8
            local offsetX = math.cos(angle) * radius
            local offsetZ = math.sin(angle) * radius
            hrp.CFrame = CFrame.new(rakePart.Position + Vector3.new(offsetX, 3, offsetZ), rakePart.Position)
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
        end
    end
end)

safeBindClick(BringBossBtn, function()
    Features.BringBoss = not Features.BringBoss
    BringBossBtn.Text = Features.BringBoss and "🧲 Bring Boss: ON" or "🧲 Bring Boss: OFF"
    BringG.Color = Features.BringBoss and ON_GRAD or OFF_GRAD
end)
Connections.BringLoop = RunService.Heartbeat:Connect(function()
    if Features.BringBoss then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local _, targetPart = findTheRakeModel()
        if hrp and targetPart then targetPart.CFrame = hrp.CFrame * CFrame.new(0, 0, -3) end
    end
end)

safeBindClick(AttackBtn, function()
    Features.AutoAttack = not Features.AutoAttack
    AttackBtn.Text = Features.AutoAttack and "⚔️ Spam Clicker: ON" or "⚔️ Fast Spam Clicker: OFF"
    AttG.Color = Features.AutoAttack and ON_GRAD or OFF_GRAD
end)
Connections.AttackLoop = RunService.RenderStepped:Connect(function()
    if Features.AutoAttack then
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then pcall(function() tool:Activate() end) end
    end
end)

safeBindClick(TrigBtn, function()
    Features.TriggerBot = not Features.TriggerBot
    TrigBtn.Text = Features.TriggerBot and "🎯 Trigger Bot: ON" or "🎯 Trigger Bot: OFF"
    TrigG.Color = Features.TriggerBot and ON_GRAD or OFF_GRAD
end)
Connections.TrigLoop = RunService.RenderStepped:Connect(function()
    if Features.TriggerBot then
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Target then
            local m = mouse.Target:FindFirstAncestorOfClass("Model")
            if m then
                local isRakeTrig = false
                if m.Name == "THE_RAKE" or string.match(m.Name:lower(), "rake") ~= nil then
                    isRakeTrig = true
                end
                
                if isRakeTrig then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then pcall(function() tool:Activate() end) end
                end
            end
        end
    end
end)

safeBindClick(InfReachBtn, function()
    Features.InfReach = not Features.InfReach
    InfReachBtn.Text = Features.InfReach and "📏 INF REACH: ON" or "📏 INF REACH: OFF"
    ReachG.Color = Features.InfReach and ON_GRAD or OFF_GRAD
end)

Tasks.InfReachTask = task.spawn(function()
    while true do
        if Features.InfReach then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                local handle = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart"))
                local _, rakePart = findTheRakeModel()
                
                if handle and rakePart then
                    if (handle.Position - rakePart.Position).Magnitude < InfReachDistance then
                        local fti = firetouchinterest
                        if typeof(fti) == "function" then
                            pcall(function()
                                fti(rakePart, handle, 0)
                                fti(rakePart, handle, 1)
                            end)
                        end
                        tool:Activate()
                    end
                end
            end)
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end)

--------------------------------------------------------------------------------
-- 3. AUTO TAB CONTENT
--------------------------------------------------------------------------------
local AutoPickupBtn, AutoPickupS, AutoPickupG = CreatePageBtn(AutoPage, "🌀 Auto Pick-Up (Drops): OFF", 1)
local CandyTpBtn, CandyS, CandyG = CreatePageBtn(AutoPage, "🌀 Bring Candy To Me: OFF", 2)
local MiscSoulsBtn, MiscSS, MiscSG = CreatePageBtn(AutoPage, "👻 Soul Farm: OFF", 3)
local BringSpawnablesBtn, SpawnS, SpawnG = CreatePageBtn(AutoPage, "🎯 Turrets/Spawnables -> Rake: OFF", 4)
local CooldownBtn, CooldownS, CooldownG = CreatePageBtn(AutoPage, "⚡ Bypass de Cooldown: OFF", 5)

safeBindClick(AutoPickupBtn, function()
    Features.AutoPickup = not Features.AutoPickup
    AutoPickupBtn.Text = Features.AutoPickup and "🌀 Auto Pick-Up (Drops): ON" or "🌀 Auto Pick-Up (Drops): OFF"
    AutoPickupG.Color = Features.AutoPickup and ON_GRAD or OFF_GRAD
end)
Tasks.AutoPickupTask = task.spawn(function()
    while true do
        if Features.AutoPickup then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dropsFolder = Workspace:FindFirstChild("Drops") or Workspace:FindFirstChild("drops")
                    if dropsFolder then
                        for _, obj in ipairs(dropsFolder:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local fti = firetouchinterest
                                if typeof(fti) == "function" then
                                    pcall(function()
                                        fti(hrp, obj, 0)
                                        fti(hrp, obj, 1)
                                    end)
                                end
                            elseif obj:IsA("ProximityPrompt") then
                                pcall(function() fireproximityprompt(obj) end)
                            end
                        end
                    end
                end
            end)
            task.wait(0.05)
        else
            task.wait(0.5)
        end
    end
end)

safeBindClick(CandyTpBtn, function()
    Features.AutoCandyTP = not Features.AutoCandyTP
    CandyTpBtn.Text = Features.AutoCandyTP and "🌀 Bring Candy To Me: ON" or "🌀 Bring Candy To Me: OFF"
    CandyG.Color = Features.AutoCandyTP and ON_GRAD or OFF_GRAD
end)
Connections.CandyLoop = RunService.Heartbeat:Connect(function()
    if Features.AutoCandyTP then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                local n = obj.Name:lower()
                local isCandyMatch = false
                if string.match(n, "candy") or string.match(n, "bucket") or string.match(n, "soul") then
                    isCandyMatch = true
                end

                if isCandyMatch then
                    if obj:IsA("BasePart") then
                        obj.CFrame = hrp.CFrame
                    elseif obj:IsA("Model") and obj.PrimaryPart then
                        obj:SetPrimaryPartCFrame(hrp.CFrame)
                    end
                end
            end
        end
    end
end)

safeBindClick(MiscSoulsBtn, function()
    Features.AutoMiscSouls = not Features.AutoMiscSouls
    MiscSoulsBtn.Text = Features.AutoMiscSouls and "👻 Soul Farm: ON" or "👻 Auto Farm Souls: OFF"
    MiscSG.Color = Features.AutoMiscSouls and ON_GRAD or OFF_GRAD
end)
Tasks.SoulTask = task.spawn(function()
    while true do
        if Features.AutoMiscSouls then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local miscFolder = Workspace:FindFirstChild("Misc") or Workspace:FindFirstChild("misc")
                if hrp and miscFolder then
                    for _, obj in ipairs(miscFolder:GetDescendants()) do
                        if not Features.AutoMiscSouls then break end
                        if string.match(obj.Name:lower(), "soul") then
                            if obj:IsA("BasePart") then
                                obj.CFrame = hrp.CFrame
                            elseif obj:IsA("Model") and obj.PrimaryPart then
                                obj.PrimaryPart.CFrame = hrp.CFrame
                            end
                        end
                    end
                end
            end)
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end)

safeBindClick(BringSpawnablesBtn, function()
    Features.BringSpawnables = not Features.BringSpawnables
    BringSpawnablesBtn.Text = Features.BringSpawnables and "🎯 Turrets/Spawnables -> Rake: ON" or "🎯 Turrets/Spawnables -> Rake: OFF"
    SpawnG.Color = Features.BringSpawnables and ON_GRAD or OFF_GRAD
end)
Connections.SpawnablesLoop = RunService.Heartbeat:Connect(function()
    if Features.BringSpawnables then
        local _, rakePart = findTheRakeModel()
        if rakePart then
            local spawnablesFolder = Workspace:FindFirstChild("Spawnables") or Workspace:FindFirstChild("spawnables")
            if spawnablesFolder then
                for _, obj in ipairs(spawnablesFolder:GetDescendants()) do
                    if obj:IsA("Model") or obj:IsA("Tool") then
                        local mainPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChild("Base") or obj:FindFirstChildWhichIsA("BasePart")
                        if mainPart then
                            pcall(function()
                                if obj:IsA("Model") and obj.PrimaryPart then
                                    obj:SetPrimaryPartCFrame(rakePart.CFrame)
                                else
                                    mainPart.CFrame = rakePart.CFrame
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

local cooldownBypass = false
safeBindClick(CooldownBtn, function()
    cooldownBypass = not cooldownBypass
    CooldownBtn.Text = cooldownBypass and "⚡ Bypass de Cooldown: ON" or "⚡ Bypass de Cooldown: OFF"
    CooldownG.Color = cooldownBypass and ON_GRAD or OFF_GRAD
end)

task.spawn(function()
    while true do
        task.wait(0.15)
        if cooldownBypass then
            pcall(function()
                local function check(item)
                    if item:IsA("Tool") then
                        local cd = item:FindFirstChild("Cooldown", true)
                        if cd then
                            if cd:IsA("NumberValue") or cd:IsA("IntValue") then cd.Value = 0 end
                            if cd:IsA("BoolValue") then cd.Value = false end
                        end
                    end
                end
                if LocalPlayer.Character then for _, v in ipairs(LocalPlayer.Character:GetChildren()) do check(v) end end
                if LocalPlayer.Backpack then for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do check(v) end end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 4. GUN TAB CONTENT (WEAPON MODS & MEMORY INJECTION)
--------------------------------------------------------------------------------
local InjectMemBtn, InjectMemS, InjectMemG = CreatePageBtn(GunPage, "1. Inyectar Memoria (Bypass Anti-Kick & Balas 9999)", 1)
local ContFireBtn, ContFireS, ContFireG = CreatePageBtn(GunPage, "2. Ráfaga Continua (Sin Vacío): OFF", 2)

safeBindClick(InjectMemBtn, function()
    local successCount = 0
    pcall(function()
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "function" and islclosure(obj) then
                local info = debug.getinfo(obj)
                local isGunScript = false
                if info.source ~= nil and string.match(info.source, "GunScript_Local") ~= nil then
                    isGunScript = true
                end

                if isGunScript then
                    local constants = debug.getconstants(obj)
                    for _, const in pairs(constants) do
                        if const == "Fella tried to Exploit LOOOOL" or const == "VerifyExploit" then
                            hookfunction(obj, function() return end)
                            successCount = successCount + 1
                        end
                    end
                    
                    local upvalues = debug.getupvalues(obj)
                    for _, val in pairs(upvalues) do
                        if type(val) == "table" and rawget(val, "AmmoPerClip") then
                            rawset(val, "AmmoPerClip", 9999)
                            rawset(val, "MaxClip", 9999)
                            rawset(val, "Auto", true)
                            successCount = successCount + 1
                        end
                    end
                end
            end
        end
    end)
    InjectMemBtn.Text = "✅ MEMORIA INYECTADA (" .. successCount .. " hooks)"
    task.delay(2, function() InjectMemBtn.Text = "1. Inyectar Memoria (Bypass Anti-Kick & Balas 9999)" end)
end)

safeBindClick(ContFireBtn, function()
    Features.ContinuousFire = not Features.ContinuousFire
    ContFireBtn.Text = Features.ContinuousFire and "2. Ráfaga Continua (Sin Vacío): ON" or "2. Ráfaga Continua (Sin Vacío): OFF"
    ContFireG.Color = Features.ContinuousFire and ON_GRAD or OFF_GRAD
end)

Connections.ContinuousFireLoop = RunService.RenderStepped:Connect(function()
    if Features.ContinuousFire then
        pcall(function()
            for _, obj in pairs(getgc(true)) do
                if type(obj) == "function" and islclosure(obj) then
                    local info = debug.getinfo(obj)
                    local isGunScript = false
                    if info.source ~= nil and string.match(info.source, "GunScript_Local") ~= nil then
                        isGunScript = true
                    end

                    if isGunScript then
                        local constants = debug.getconstants(obj)
                        for _, const in pairs(constants) do
                            if const == "Fella tried to Exploit LOOOOL" or const == "VerifyExploit" then
                                hookfunction(obj, function() return end)
                            end
                        end
                        
                        local upvalues = debug.getupvalues(obj)
                        for idx, val in pairs(upvalues) do
                            if type(val) == "number" and val < 30 and val >= 0 then
                                debug.setupvalue(obj, idx, 99)
                            end
                            if type(val) == "table" and rawget(val, "AmmoPerClip") then
                                rawset(val, "AmmoPerClip", 9999)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

--------------------------------------------------------------------------------
-- 5. PLAYER TAB CONTENT (WITH NOCLIP & SPEED SLIDER MAX 60)
--------------------------------------------------------------------------------
local FlyBtn, FlyS, FlyG = CreatePageBtn(PlayerPage, "🦅 Fly Hack: OFF", 1)
local InfJumpBtn, InfJS, InfJG = CreatePageBtn(PlayerPage, "🦘 Inf Jump Loop: OFF", 2)
local NoclipBtn, NoclipS, NoclipG = CreatePageBtn(PlayerPage, "👻 Noclip: OFF", 3)
local BrightBtn, BrightS, BrightG = CreatePageBtn(PlayerPage, "💡 Full Bright: OFF", 4)
local ESPBtn, ESPS, ESPG = CreatePageBtn(PlayerPage, "🚨 THE_RAKE ESP: OFF", 5)
local PlayerESPBtn, PESPS, PESPG = CreatePageBtn(PlayerPage, "👁️ Player ESP: OFF", 6)
local InteractBtn, IntS, IntG = CreatePageBtn(PlayerPage, "🦇 Interactuar automáticamente: OFF", 7)
local AutoEscapeBtn, AutoEscS, AutoEscG = CreatePageBtn(PlayerPage, "🚨 Auto Escape (20% HP): OFF", 8)

-- Noclip Logic
safeBindClick(NoclipBtn, function()
    Features.Noclip = not Features.Noclip
    NoclipBtn.Text = Features.Noclip and "👻 Noclip: ON" or "👻 Noclip: OFF"
    NoclipG.Color = Features.Noclip and ON_GRAD or OFF_GRAD
end)

Connections.NoclipLoop = RunService.Stepped:Connect(function()
    if Features.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Sidebar / Slider para Custom WalkSpeed (Límite 60)
local SpeedSliderFrame = Instance.new("Frame", PlayerPage)
SpeedSliderFrame.Size = UDim2.new(1, 0, 0, 55)
SpeedSliderFrame.BackgroundColor3 = Color3.fromRGB(38, 28, 34)
SpeedSliderFrame.ZIndex = 14
SpeedSliderFrame.LayoutOrder = 10
Instance.new("UICorner", SpeedSliderFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", SpeedSliderFrame).Color = Color3.fromRGB(255, 182, 193)

local SpeedSliderLabel = Instance.new("TextLabel", SpeedSliderFrame)
SpeedSliderLabel.Size = UDim2.new(1, -10, 0, 20)
SpeedSliderLabel.Position = UDim2.new(0, 8, 0, 4)
SpeedSliderLabel.BackgroundTransparency = 1
SpeedSliderLabel.Text = "⚡ WalkSpeed (Max 60): 16"
SpeedSliderLabel.TextColor3 = Color3.fromRGB(255, 182, 193)
SpeedSliderLabel.Font = Enum.Font.GothamBold
SpeedSliderLabel.TextSize = 10
SpeedSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedSliderLabel.ZIndex = 15

local SpeedSliderBar = Instance.new("Frame", SpeedSliderFrame)
SpeedSliderBar.Size = UDim2.new(0.92, 0, 0, 10)
SpeedSliderBar.Position = UDim2.new(0.04, 0, 0.65, 0)
SpeedSliderBar.BackgroundColor3 = Color3.fromRGB(26, 20, 24)
SpeedSliderBar.ZIndex = 15
Instance.new("UICorner", SpeedSliderBar).CornerRadius = UDim.new(0, 5)

local SpeedSliderFill = Instance.new("Frame", SpeedSliderBar)
SpeedSliderFill.Size = UDim2.new(0, 0, 1, 0)
SpeedSliderFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
SpeedSliderFill.ZIndex = 16
Instance.new("UICorner", SpeedSliderFill).CornerRadius = UDim.new(0, 5)

local SpeedSliderButton = Instance.new("TextButton", SpeedSliderBar)
SpeedSliderButton.Size = UDim2.new(1, 0, 1, 0)
SpeedSliderButton.BackgroundTransparency = 1
SpeedSliderButton.Text = ""
SpeedSliderButton.ZIndex = 17

local draggingSpeedSlider = false
SpeedSliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeedSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeedSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSpeedSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - SpeedSliderBar.AbsolutePosition.X) / SpeedSliderBar.AbsoluteSize.X, 0, 1)
        SpeedSliderFill.Size = UDim2.new(pos, 0, 1, 0)
        CustomWalkSpeedVal = math.floor(16 + (pos * 44)) -- Desde 16 hasta 60 max
        SpeedSliderLabel.Text = "⚡ WalkSpeed (Max 60): " .. CustomWalkSpeedVal
    end
end)

Connections.SpeedLoop = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = CustomWalkSpeedVal
    end
end)

-- Player Tab Logic (Fly, InfJump, etc.)
local bodyVel, bodyGyro
safeBindClick(FlyBtn, function()
    Features.Fly = not Features.Fly
    FlyBtn.Text = Features.Fly and "🦅 Fly Hack: ON" or "🦅 Fly Hack: OFF"
    FlyG.Color = Features.Fly and ON_GRAD or OFF_GRAD
    if Connections.FlyConn then Connections.FlyConn:Disconnect() Connections.FlyConn = nil end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if Features.Fly then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            bodyVel = Instance.new("BodyVelocity", hrp); bodyVel.MaxForce = Vector3.new(1,1,1)*1e6; bodyVel.Velocity = Vector3.zero
            bodyGyro = Instance.new("BodyGyro", hrp); bodyGyro.MaxTorque = Vector3.new(1,1,1)*1e6; bodyGyro.CFrame = hrp.CFrame
            Connections.FlyConn = RunService.RenderStepped:Connect(function()
                if not Features.Fly or not hrp then return end
                local cam = Workspace.CurrentCamera.CFrame
                bodyGyro.CFrame = cam
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                bodyVel.Velocity = (dir.Magnitude > 0) and (dir.Unit * 50) or Vector3.zero
            end)
        end
    end
end)

safeBindClick(InfJumpBtn, function()
    Features.InfJump = not Features.InfJump
    InfJumpBtn.Text = Features.InfJump and "🦘 Inf Jump: ON" or "🦘 Inf Jump Loop: OFF"
    InfJG.Color = Features.InfJump and ON_GRAD or OFF_GRAD
    if Connections.InfJumpConn then Connections.InfJumpConn:Disconnect() Connections.InfJumpConn = nil end
    if Features.InfJump then
        Connections.InfJumpConn = UserInputService.JumpRequest:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

safeBindClick(BrightBtn, function()
    Features.FullBright = not Features.FullBright
    BrightBtn.Text = Features.FullBright and "💡 Full Bright: ON" or "💡 Full Bright: OFF"
    BrightG.Color = Features.FullBright and ON_GRAD or OFF_GRAD
    if Features.FullBright then
        Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
    else
        Lighting.Ambient = OrigLighting.Ambient; Lighting.Brightness = OrigLighting.Brightness; Lighting.ClockTime = OrigLighting.ClockTime; Lighting.GlobalShadows = OrigLighting.GlobalShadows
    end
end)

safeBindClick(ESPBtn, function()
    Features.RakeESP = not Features.RakeESP
    ESPBtn.Text = Features.RakeESP and "🚨 RAKE ESP: ON" or "🚨 THE_RAKE ESP: OFF"
    ESPG.Color = Features.RakeESP and ON_GRAD or OFF_GRAD
end)
Connections.ESPLoop = RunService.RenderStepped:Connect(function()
    local rakeModel, _ = findTheRakeModel()
    if rakeModel then
        local hl = rakeModel:FindFirstChild("BananaRakeESP")
        if Features.RakeESP and not hl then
            hl = Instance.new("Highlight", rakeModel); hl.Name = "BananaRakeESP"
            hl.FillColor = Color3.fromRGB(255, 0, 0)
        elseif not Features.RakeESP and hl then
            hl:Destroy()
        end
    end
end)

safeBindClick(PlayerESPBtn, function()
    Features.PlayerESP = not Features.PlayerESP
    PlayerESPBtn.Text = Features.PlayerESP and "👁️ Player ESP: ON" or "👁️ Player ESP: OFF"
    PESPG.Color = Features.PlayerESP and ON_GRAD or OFF_GRAD
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("BananaPlayerESP")
            if Features.PlayerESP and not hl then
                hl = Instance.new("Highlight", p.Character); hl.Name = "BananaPlayerESP"
                hl.FillColor = Color3.fromRGB(0, 255, 200)
            elseif not Features.PlayerESP and hl then
                hl:Destroy()
            end
        end
    end
end)

safeBindClick(InteractBtn, function()
    Features.AutoInteract = not Features.AutoInteract
    InteractBtn.Text = Features.AutoInteract and "🦇 Interactuar automáticamente: ON" or "🦇 Interactuar automáticamente: OFF"
    IntG.Color = Features.AutoInteract and ON_GRAD or OFF_GRAD
end)
Connections.IntLoop = RunService.Heartbeat:Connect(function()
    if Features.AutoInteract then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(obj) end) end
        end
    end
end)

-- Auto Escape al 20% de HP
safeBindClick(AutoEscapeBtn, function()
    Features.AutoEscape = not Features.AutoEscape
    AutoEscapeBtn.Text = Features.AutoEscape and "🚨 Auto Escape (20% HP): ON" or "🚨 Auto Escape (20% HP): OFF"
    AutoEscG.Color = Features.AutoEscape and ON_GRAD or OFF_GRAD
end)

Tasks.AutoEscapeTask = task.spawn(function()
    while true do
        if Features.AutoEscape then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local threshold = hum.MaxHealth * 0.20
                    if hum.Health <= threshold then
                        -- Teletransporte de seguridad hacia arriba si la vida es <= 20%
                        hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)
                        task.wait(1)
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)
