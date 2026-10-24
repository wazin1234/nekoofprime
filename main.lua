-- ============================================================================
-- NEKOOF VERSION | YELLOW EDITION (FIXED MOVEMENT SLIDER & DRAG LOGIC)
-- ============================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local ParentGui = CoreGui

-- Limpieza de instancias anteriores
if getgenv().NekoofCleanup then pcall(getgenv().NekoofCleanup) end

local Connections, Tasks = {}, {}
getgenv().NekoofCleanup = function()
    for _, conn in pairs(Connections) do if conn then conn:Disconnect() end end
    for _, taskRef in pairs(Tasks) do if taskRef then pcall(task.cancel, taskRef) end end
    table.clear(Connections); table.clear(Tasks)
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("NekoofCustomESP") then obj.NekoofCustomESP:Destroy() end
        if obj:FindFirstChild("NekoofCustomLabel") then obj.NekoofCustomLabel:Destroy() end
    end

    if ParentGui:FindFirstChild("NekoofMainGui") then ParentGui.NekoofMainGui:Destroy() end
    if ParentGui:FindFirstChild("NekoofKeyGui") then ParentGui.NekoofKeyGui:Destroy() end
    if ParentGui:FindFirstChild("NekoofSaveHostNotice") then ParentGui.NekoofSaveHostNotice:Destroy() end
end

--------------------------------------------------------------------------------
-- DRAGGABLE HELPER
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
-- 1. KEY SYSTEM (LLAVE: nekoofprime)
--------------------------------------------------------------------------------
local KeyGui = Instance.new("ScreenGui", ParentGui)
KeyGui.Name = "NekoofKeyGui"
KeyGui.ResetOnSpawn = false
KeyGui.DisplayOrder = 200

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.Size = UDim2.new(0, 380, 0, 210)
KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 24, 18)
KeyFrame.Active = true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 14)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Color3.fromRGB(255, 215, 0)
KeyStroke.Thickness = 2
makeDraggable(KeyFrame)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, -20, 0, 30)
KeyTitle.Position = UDim2.new(0, 10, 0, 10)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "🔑 NEKOOF SYSTEM AUTHENTICATION"
KeyTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 13

local KeyTextBeta = Instance.new("TextLabel", KeyFrame)
KeyTextBeta.Size = UDim2.new(1, -20, 0, 28)
KeyTextBeta.Position = UDim2.new(0, 10, 0, 42)
KeyTextBeta.BackgroundTransparency = 1
KeyTextBeta.Text = "This thing is still in beta, anything that happens is at your own risk."
KeyTextBeta.TextColor3 = Color3.fromRGB(255, 100, 100)
KeyTextBeta.Font = Enum.Font.GothamMedium
KeyTextBeta.TextSize = 10
KeyTextBeta.TextWrapped = true

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(1, -40, 0, 36)
KeyInput.Position = UDim2.new(0, 20, 0, 80)
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextSize = 12
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", KeyInput).Color = Color3.fromRGB(100, 90, 40)

local SubmitKeyBtn = Instance.new("TextButton", KeyFrame)
SubmitKeyBtn.Size = UDim2.new(1, -40, 0, 36)
SubmitKeyBtn.Position = UDim2.new(0, 20, 0, 130)
SubmitKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
SubmitKeyBtn.Text = "VERIFY KEY"
SubmitKeyBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
SubmitKeyBtn.Font = Enum.Font.GothamBold
SubmitKeyBtn.TextSize = 12
Instance.new("UICorner", SubmitKeyBtn).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel", KeyFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 175)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 10

--------------------------------------------------------------------------------
-- MAIN GUI CREATION
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", ParentGui)
ScreenGui.Name = "NekoofMainGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100
ScreenGui.Enabled = false

local ToggleIcon = Instance.new("TextButton", ScreenGui)
ToggleIcon.Size = UDim2.new(0, 48, 0, 48)
ToggleIcon.Position = UDim2.new(0, 15, 0.3, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(35, 30, 15)
ToggleIcon.Text = "🐥"
ToggleIcon.TextSize = 24
ToggleIcon.ZIndex = 200
ToggleIcon.Active = true
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", ToggleIcon).Color = Color3.fromRGB(255, 215, 0)
makeDraggable(ToggleIcon)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 520, 0, 460)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 24, 18)
MainFrame.ClipsDescendants = false
MainFrame.Active = true
MainFrame.ZIndex = 10
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 215, 0)
MainStroke.Thickness = 2
makeDraggable(MainFrame)

SubmitKeyBtn.Activated:Connect(function()
    if KeyInput.Text == "nekoofprime" then
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        StatusLabel.Text = "✓ Key Approved! Loading Suite..."
        task.wait(0.6)
        KeyGui:Destroy()
        ScreenGui.Enabled = true
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "X Invalid Key! Please try again."
    end
end)

Connections.KeybindToggle = UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl and ScreenGui.Enabled then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Barra de Título
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
TitleBar.ZIndex = 11
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(0, 320, 1, 0)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🐥 NEKOOF VERSION — MODULAR SUITE"
TitleText.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 12

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.Activated:Connect(function() MainFrame.Visible = false end)
ToggleIcon.Activated:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

--------------------------------------------------------------------------------
-- SIDEBAR & TABS
--------------------------------------------------------------------------------
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 130, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.ZIndex = 11

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 6)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -155, 1, -60)
ContentArea.Position = UDim2.new(0, 145, 0, 50)
ContentArea.BackgroundColor3 = Color3.fromRGB(30, 28, 22)
ContentArea.ZIndex = 11
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", ContentArea).Color = Color3.fromRGB(255, 215, 0)

local TabFrames = {}
local TabButtons = {}

local function createTab(name, icon, order)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
    btn.Text = " " .. icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.ZIndex = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(100, 90, 40)

    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, -12, 1, -12)
    page.Position = UDim2.new(0, 6, 0, 6)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
    page.Visible = false
    page.ZIndex = 13

    local pageList = Instance.new("UIListLayout", page)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Padding = UDim.new(0, 6)

    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageList.AbsoluteContentSize.Y + 12)
    end)

    TabFrames[name] = page
    TabButtons[name] = btn

    btn.Activated:Connect(function()
        for tName, tPage in pairs(TabFrames) do
            tPage.Visible = (tName == name)
            local tBtn = TabButtons[tName]
            if tName == name then
                tBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                tBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
            else
                tBtn.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
                tBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
            end
        end
    end)

    return page
end

local ESPPage      = createTab("ESP Modules", "👁️", 1)
local BetaPage     = createTab("Beta Test", "🧪", 2)
local MovementPage = createTab("Movimiento", "🏃", 3)

TabButtons["ESP Modules"].BackgroundColor3 = Color3.fromRGB(255, 215, 0)
TabButtons["ESP Modules"].TextColor3 = Color3.fromRGB(20, 20, 20)
TabFrames["ESP Modules"].Visible = true

--------------------------------------------------------------------------------
-- SISTEMA HIGHLIGHT Y LABELS
--------------------------------------------------------------------------------
local function applyESP(target, iconStr, customName, customColor)
    customColor = customColor or Color3.fromRGB(255, 215, 0)
    
    local hl = target:FindFirstChild("NekoofCustomESP")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "NekoofCustomESP"
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.25
        hl.Parent = target
    end
    hl.FillColor = customColor

    local mainPart = target:IsA("BasePart") and target or (target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart"))
    if mainPart then
        local bb = target:FindFirstChild("NekoofCustomLabel")
        if not bb then
            bb = Instance.new("BillboardGui")
            bb.Name = "NekoofCustomLabel"
            bb.Size = UDim2.new(0, 180, 0, 26)
            bb.AlwaysOnTop = true
            bb.Adornee = mainPart
            bb.StudsOffset = Vector3.new(0, 2.2, 0)

            local txt = Instance.new("TextLabel", bb)
            txt.Name = "Text"
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 11
            txt.TextStrokeTransparency = 0.2
            bb.Parent = target
        end
        
        local txtLabel = bb:FindFirstChild("Text")
        if txtLabel then
            txtLabel.TextColor3 = customColor
            txtLabel.Text = (iconStr or "📍") .. " " .. (customName or target.Name) .. " [0m]"
        end
    end
end

local function removeESP(target)
    if not target then return end
    if target:FindFirstChild("NekoofCustomESP") then target.NekoofCustomESP:Destroy() end
    if target:FindFirstChild("NekoofCustomLabel") then target.NekoofCustomLabel:Destroy() end
end

--------------------------------------------------------------------------------
-- BOTONES E INTERRUPTORES MODULARES (1x1)
--------------------------------------------------------------------------------
local OFF_GRAD = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 40, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 15))})
local ON_GRAD  = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 100)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 205, 0))})

local function CreateToggleBtn(parentPage, text, order)
    local btn = Instance.new("TextButton", parentPage)
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.LayoutOrder = order
    btn.ZIndex = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local grad = Instance.new("UIGradient", btn); grad.Color = OFF_GRAD; grad.Rotation = 90
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 1; stroke.Color = Color3.fromRGB(100, 90, 40)
    return btn, stroke, grad
end

--------------------------------------------------------------------------------
-- ESTADOS Y BOTONES DE LA TAB 'ESP MODULES'
--------------------------------------------------------------------------------
local States = {
    Coin    = false,
    Coffee  = false,
    Burger  = false,
    Chips   = false,
    Fish    = false,
    Flare   = false,
    Slushie = false,
    Taco    = false,
    Closets = false,
    Loot    = false,
    Jose    = false,
    Rakoof  = false,
    Scrap   = false
}

local function clearFolderESP(folderPath)
    pcall(function()
        if folderPath then
            if type(folderPath) == "table" or typeof(folderPath) == "Instance" then
                if folderPath:IsA("Instance") then
                    for _, item in ipairs(folderPath:GetChildren()) do removeESP(item) end
                    removeESP(folderPath)
                end
            end
        end
    end)
end

local CoinBtn, _, CoinG       = CreateToggleBtn(ESPPage, "🪙 Coin Givers ESP: OFF", 1)
local CoffeeBtn, _, CoffeeG   = CreateToggleBtn(ESPPage, "☕ Coffee Givers ESP: OFF", 2)
local BurgerBtn, _, BurgerG   = CreateToggleBtn(ESPPage, "🍔 Burger Givers ESP: OFF", 3)
local ChipsBtn, _, ChipsG     = CreateToggleBtn(ESPPage, "🍟 Chips Givers ESP: OFF", 4)
local FishBtn, _, FishG       = CreateToggleBtn(ESPPage, "🐟 Fish Givers ESP: OFF", 5)
local FlareBtn, _, FlareG     = CreateToggleBtn(ESPPage, "🔦 Flare Givers ESP: OFF", 6)
local SlushieBtn, _, SlushieG = CreateToggleBtn(ESPPage, "🥤 Slushie Givers ESP: OFF", 7)
local TacoBtn, _, TacoG       = CreateToggleBtn(ESPPage, "🌮 Taco Givers ESP: OFF", 8)
local ClosetBtn, _, ClosetG   = CreateToggleBtn(ESPPage, "🚪 Closets ESP (11): OFF", 9)
local LootBtn, _, LootG       = CreateToggleBtn(ESPPage, "📦 Lootables ESP (27): OFF", 10)
local JoseBtn, _, JoseG       = CreateToggleBtn(ESPPage, "🦆 Jose Ducks ESP: OFF", 11)
local RakoofBtn, _, RakoofG   = CreateToggleBtn(ESPPage, "🦝 Rakoof NPC ESP: OFF", 12)
local ScrapBtn, _, ScrapG     = CreateToggleBtn(ESPPage, "⚙️ Scrap Metal ESP: OFF", 13)

local function bindModule(btn, grad, key, name, folderGet)
    btn.Activated:Connect(function()
        States[key] = not States[key]
        btn.Text = name .. (States[key] and ": ON" or ": OFF")
        grad.Color = States[key] and ON_GRAD or OFF_GRAD

        if not States[key] then
            clearFolderESP(folderGet())
        end
    end)
end

local givers = function() return Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("Givers") end

bindModule(CoinBtn, CoinG, "Coin", "🪙 Coin Givers ESP", function() return givers() and givers():FindFirstChild("Coin") end)
bindModule(CoffeeBtn, CoffeeG, "Coffee", "☕ Coffee Givers ESP", function() return givers() and givers():FindFirstChild("Coffee") end)
bindModule(BurgerBtn, BurgerG, "Burger", "🍔 Burger Givers ESP", function() return givers() and givers():FindFirstChild("Burger") end)
bindModule(ChipsBtn, ChipsG, "Chips", "🍟 Chips Givers ESP", function() return givers() and givers():FindFirstChild("Chips") end)
bindModule(FishBtn, FishG, "Fish", "🐟 Fish Givers ESP", function() return givers() and givers():FindFirstChild("Fish") end)
bindModule(FlareBtn, FlareG, "Flare", "🔦 Flare Givers ESP", function() return givers() and givers():FindFirstChild("Flare") end)
bindModule(SlushieBtn, SlushieG, "Slushie", "🥤 Slushie Givers ESP", function() return givers() and givers():FindFirstChild("Slushie") end)
bindModule(TacoBtn, TacoG, "Taco", "🌮 Taco Givers ESP", function() return givers() and givers():FindFirstChild("Taco") end)

bindModule(ClosetBtn, ClosetG, "Closets", "🚪 Closets ESP", function() return Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("Closets") end)
bindModule(LootBtn, LootG, "Loot", "📦 Lootables ESP", function() return Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("Lootable") end)
bindModule(JoseBtn, JoseG, "Jose", "🦆 Jose Ducks ESP", function() return Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("Jose") end)
bindModule(RakoofBtn, RakoofG, "Rakoof", "🦝 Rakoof NPC ESP", function() return Workspace:FindFirstChild("RakoofNPC") end)
bindModule(ScrapBtn, ScrapG, "Scrap", "⚙️ Scrap Metal ESP", function() return Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("ScrapMetals") end)

--------------------------------------------------------------------------------
-- TAB 'BETA TEST' (SAVE HOST, HEALTH REGEN & FRANK SHOP TP)
--------------------------------------------------------------------------------
local SaveHostActive = false
local SaveHostThreshold = 25
local CooldownTime = 30
local LastTeleportTime = 0

local HealthRegenActive = false
local FrankShopActive = false

local DestroyBtn = Instance.new("TextButton", BetaPage)
DestroyBtn.Size = UDim2.new(1, -8, 0, 32)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
DestroyBtn.Text = "🗑️ DESTROY GUI"
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.Font = Enum.Font.GothamBold
DestroyBtn.TextSize = 10
DestroyBtn.LayoutOrder = 1
DestroyBtn.ZIndex = 14
Instance.new("UICorner", DestroyBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", DestroyBtn).Color = Color3.fromRGB(255, 80, 80)

DestroyBtn.Activated:Connect(function()
    pcall(getgenv().NekoofCleanup)
end)

local SaveHostBtn, _, SaveHostG       = CreateToggleBtn(BetaPage, "🛡️ SAVE HOST (Auto-TP Closet): OFF", 2)
local HealthRegenBtn, _, HealthRegenG = CreateToggleBtn(BetaPage, "🍔 HEALTH REGEN (Anti-Rakoof Food): OFF", 3)
local FrankShopBtn, _, FrankShopG     = CreateToggleBtn(BetaPage, "🏪 TP Frank Shop (Medkits): OFF", 4)

-- Container de Botones de Rango de Vida
local RangeContainer = Instance.new("Frame", BetaPage)
RangeContainer.Size = UDim2.new(1, -8, 0, 92)
RangeContainer.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
RangeContainer.LayoutOrder = 5
RangeContainer.ZIndex = 14
Instance.new("UICorner", RangeContainer).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RangeContainer).Color = Color3.fromRGB(100, 90, 40)

local RangeLabel = Instance.new("TextLabel", RangeContainer)
RangeLabel.Size = UDim2.new(1, -12, 0, 20)
RangeLabel.Position = UDim2.new(0, 6, 0, 4)
RangeLabel.BackgroundTransparency = 1
RangeLabel.Text = "❤️ SELECT HEALTH TRIGGER: [10% - 25%]"
RangeLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
RangeLabel.Font = Enum.Font.GothamBold
RangeLabel.TextSize = 11
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left

local ButtonsFrame = Instance.new("Frame", RangeContainer)
ButtonsFrame.Size = UDim2.new(1, -12, 0, 28)
ButtonsFrame.Position = UDim2.new(0, 6, 0, 26)
ButtonsFrame.BackgroundTransparency = 1

local RangeList = Instance.new("UIListLayout", ButtonsFrame)
RangeList.FillDirection = Enum.FillDirection.Horizontal
RangeList.SortOrder = Enum.SortOrder.LayoutOrder
RangeList.Padding = UDim.new(0, 6)

local RangeButtons = {}

local function createRangeBtn(text, thresholdVal, order)
    local rBtn = Instance.new("TextButton", ButtonsFrame)
    rBtn.Size = UDim2.new(0.315, 0, 1, 0)
    rBtn.BackgroundColor3 = (thresholdVal == SaveHostThreshold) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(25, 22, 14)
    rBtn.Text = text
    rBtn.TextColor3 = (thresholdVal == SaveHostThreshold) and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 215, 0)
    rBtn.Font = Enum.Font.GothamBold
    rBtn.TextSize = 10
    rBtn.LayoutOrder = order
    rBtn.ZIndex = 15
    Instance.new("UICorner", rBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", rBtn).Color = Color3.fromRGB(100, 90, 40)

    rBtn.Activated:Connect(function()
        SaveHostThreshold = thresholdVal
        RangeLabel.Text = "❤️ SELECT HEALTH TRIGGER: [" .. text .. "]"
        for val, button in pairs(RangeButtons) do
            if val == thresholdVal then
                button.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                button.TextColor3 = Color3.fromRGB(20, 20, 20)
            else
                button.BackgroundColor3 = Color3.fromRGB(25, 22, 14)
                button.TextColor3 = Color3.fromRGB(255, 215, 0)
            end
        end
    end)

    RangeButtons[thresholdVal] = rBtn
end

createRangeBtn("10% - 25%", 25, 1)
createRangeBtn("30% - 45%", 45, 2)
createRangeBtn("50% MAX", 50, 3)

local CooldownLabel = Instance.new("TextLabel", RangeContainer)
CooldownLabel.Size = UDim2.new(1, -12, 0, 24)
CooldownLabel.Position = UDim2.new(0, 6, 0, 60)
CooldownLabel.BackgroundColor3 = Color3.fromRGB(20, 18, 12)
CooldownLabel.Text = "⏳ COOLDOWN: READY (30s)"
CooldownLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
CooldownLabel.Font = Enum.Font.GothamBold
CooldownLabel.TextSize = 11
CooldownLabel.ZIndex = 15
Instance.new("UICorner", CooldownLabel).CornerRadius = UDim.new(0, 4)

-- TEXTO DE ADVERTENCIA EN INGLÉS (BETA NOTES)
local BetaNoteBox = Instance.new("Frame", BetaPage)
BetaNoteBox.Size = UDim2.new(1, -8, 0, 45)
BetaNoteBox.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
BetaNoteBox.LayoutOrder = 6
BetaNoteBox.ZIndex = 14
Instance.new("UICorner", BetaNoteBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", BetaNoteBox).Color = Color3.fromRGB(100, 90, 40)

local BetaNoteText = Instance.new("TextLabel", BetaNoteBox)
BetaNoteText.Size = UDim2.new(1, -12, 1, 0)
BetaNoteText.Position = UDim2.new(0, 6, 0, 0)
BetaNoteText.BackgroundTransparency = 1
BetaNoteText.Text = "Note: Shop teleport only works during daytime! Save Host may not save you from fall damage!"
BetaNoteText.TextColor3 = Color3.fromRGB(255, 180, 80)
BetaNoteText.Font = Enum.Font.GothamMedium
BetaNoteText.TextSize = 10
BetaNoteText.TextWrapped = true
BetaNoteText.ZIndex = 15

SaveHostBtn.Activated:Connect(function()
    SaveHostActive = not SaveHostActive
    SaveHostBtn.Text = SaveHostActive and "🛡️ SAVE HOST (Auto-TP Closet): ON" or "🛡️ SAVE HOST (Auto-TP Closet): OFF"
    SaveHostG.Color = SaveHostActive and ON_GRAD or OFF_GRAD
end)

--------------------------------------------------------------------------------
-- TAB 'MOVIMIENTO' (SLIDER CORREGIDO CON NÚMERO Y INTERACCIÓN)
--------------------------------------------------------------------------------
local SpeedActive = false
local TargetWalkSpeed = 36

local SpeedToggleBtn, _, SpeedG = CreateToggleBtn(MovementPage, "⚡ Custom WalkSpeed: OFF", 1)

local SpeedSliderFrame = Instance.new("Frame", MovementPage)
SpeedSliderFrame.Size = UDim2.new(1, -8, 0, 65)
SpeedSliderFrame.BackgroundColor3 = Color3.fromRGB(35, 32, 20)
SpeedSliderFrame.LayoutOrder = 2
SpeedSliderFrame.ZIndex = 14
Instance.new("UICorner", SpeedSliderFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", SpeedSliderFrame).Color = Color3.fromRGB(100, 90, 40)

local SpeedSliderLabel = Instance.new("TextLabel", SpeedSliderFrame)
SpeedSliderLabel.Size = UDim2.new(1, -16, 0, 22)
SpeedSliderLabel.Position = UDim2.new(0, 8, 0, 6)
SpeedSliderLabel.BackgroundTransparency = 1
SpeedSliderLabel.Text = "🏃 WalkSpeed: 36"
SpeedSliderLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
SpeedSliderLabel.Font = Enum.Font.GothamBold
SpeedSliderLabel.TextSize = 12
SpeedSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedSliderLabel.ZIndex = 15

local SpeedTrackBtn = Instance.new("TextButton", SpeedSliderFrame)
SpeedTrackBtn.Size = UDim2.new(1, -16, 0, 18)
SpeedTrackBtn.Position = UDim2.new(0, 8, 0, 36)
SpeedTrackBtn.BackgroundColor3 = Color3.fromRGB(20, 18, 12)
SpeedTrackBtn.Text = ""
SpeedTrackBtn.AutoButtonColor = false
SpeedTrackBtn.ZIndex = 15
Instance.new("UICorner", SpeedTrackBtn).CornerRadius = UDim.new(0, 6)

local SpeedFill = Instance.new("Frame", SpeedTrackBtn)
SpeedFill.Size = UDim2.new(0, 0, 1, 0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
SpeedFill.ZIndex = 16
Instance.new("UICorner", SpeedFill).CornerRadius = UDim.new(0, 6)

local SpeedValueText = Instance.new("TextLabel", SpeedTrackBtn)
SpeedValueText.Size = UDim2.new(1, 0, 1, 0)
SpeedValueText.BackgroundTransparency = 1
SpeedValueText.Text = "36"
SpeedValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValueText.Font = Enum.Font.GothamBold
SpeedValueText.TextSize = 10
SpeedValueText.ZIndex = 17

local isDraggingSpeed = false

local function setWalkSpeedVal(val)
    val = math.clamp(math.floor(val), 36, 60)
    TargetWalkSpeed = val
    local percent = (val - 36) / (60 - 36)
    SpeedFill.Size = UDim2.new(percent, 0, 1, 0)
    SpeedSliderLabel.Text = "🏃 WalkSpeed: " .. val
    SpeedValueText.Text = tostring(val)
end

local function updateSpeedFromInput(input)
    local trackWidth = SpeedTrackBtn.AbsoluteSize.X
    if trackWidth > 0 then
        local relativeX = math.clamp(input.Position.X - SpeedTrackBtn.AbsolutePosition.X, 0, trackWidth)
        local percent = relativeX / trackWidth
        setWalkSpeedVal(36 + (percent * (60 - 36)))
    end
end

SpeedTrackBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSpeed = true
        updateSpeedFromInput(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSpeed = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeedFromInput(input)
    end
end)

setWalkSpeedVal(36)

SpeedToggleBtn.Activated:Connect(function()
    SpeedActive = not SpeedActive
    SpeedToggleBtn.Text = SpeedActive and "⚡ Custom WalkSpeed: ON" or "⚡ Custom WalkSpeed: OFF"
    SpeedG.Color = SpeedActive and ON_GRAD or OFF_GRAD

    if not SpeedActive then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end
end)

Connections.SpeedLoop = RunService.RenderStepped:Connect(function()
    if SpeedActive then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.WalkSpeed = TargetWalkSpeed
            end
        end)
    end
end)

--------------------------------------------------------------------------------
-- FRANK SHOP TELEPORT (INSTANT SINGLE TP)
--------------------------------------------------------------------------------
FrankShopBtn.Activated:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local locs = Workspace:FindFirstChild("LocationsFolder")
        local shop = locs and locs:FindFirstChild("Shop")
        local frank = shop and shop:FindFirstChild("Frank_ShopMan")

        if hrp and frank then
            local targetPart = frank:IsA("BasePart") and frank or (frank.PrimaryPart or frank:FindFirstChildWhichIsA("BasePart", true))
            if targetPart then
                hrp.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end)

    FrankShopActive = false
    FrankShopBtn.Text = "🏪 TP Frank Shop (Medkits): OFF"
    FrankShopG.Color = OFF_GRAD
end)

--------------------------------------------------------------------------------
-- AVISO SUPERIOR EN ROJO
--------------------------------------------------------------------------------
local function showNoticeScreen()
    local oldNotice = ParentGui:FindFirstChild("NekoofSaveHostNotice")
    if oldNotice then oldNotice:Destroy() end

    local noticeGui = Instance.new("ScreenGui", ParentGui)
    noticeGui.Name = "NekoofSaveHostNotice"
    noticeGui.DisplayOrder = 10000

    local noticeFrame = Instance.new("Frame", noticeGui)
    noticeFrame.AnchorPoint = Vector2.new(0.5, 0)
    noticeFrame.Size = UDim2.new(0, 380, 0, 34)
    noticeFrame.Position = UDim2.new(0.5, 0, 0, 15)
    noticeFrame.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    noticeFrame.ZIndex = 10001
    Instance.new("UICorner", noticeFrame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", noticeFrame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2

    local txt = Instance.new("TextLabel", noticeFrame)
    txt.Size = UDim2.new(1, -10, 1, 0)
    txt.Position = UDim2.new(0, 5, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "⚠️ SAVE HOST ACTIVATED - DON'T MOVE!"
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    txt.TextStrokeTransparency = 0.3
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.ZIndex = 10002

    task.delay(5, function()
        if noticeGui then noticeGui:Destroy() end
    end)
end

--------------------------------------------------------------------------------
-- HELPER: OBTENER POSICIÓN DE RAKOOF
--------------------------------------------------------------------------------
local function getRakoofPosition()
    local rakoof = Workspace:FindFirstChild("RakoofNPC")
    if rakoof then
        local part = rakoof:IsA("BasePart") and rakoof or (rakoof.PrimaryPart or rakoof:FindFirstChildWhichIsA("BasePart", true))
        if part then return part.Position end
    end
    return nil
end

--------------------------------------------------------------------------------
-- SAVE HOST INTELIGENTE
--------------------------------------------------------------------------------
local function getFarthestClosetFromRakoof(playerPos)
    local filter = Workspace:FindFirstChild("Filter")
    local closetsFolder = filter and filter:FindFirstChild("Closets")
    if not closetsFolder then return nil end

    local referencePos = getRakoofPosition() or playerPos
    local farthestCloset = nil
    local maxDist = -1

    for _, closet in ipairs(closetsFolder:GetChildren()) do
        local part = closet:IsA("BasePart") and closet or (closet.PrimaryPart or closet:FindFirstChildWhichIsA("BasePart", true))
        if part then
            local dist = (referencePos - part.Position).Magnitude
            if dist > maxDist then
                maxDist = dist
                farthestCloset = closet
            end
        end
    end

    return farthestCloset
end

local function checkAndTriggerSaveHost()
    if not SaveHostActive then return end
    local now = tick()
    if (now - LastTeleportTime) < CooldownTime then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    if not (hrp and hum) then return end

    local currentHealth = hum.Health
    local maxHealth = hum.MaxHealth
    local healthPct = (currentHealth / maxHealth) * 100

    if healthPct <= SaveHostThreshold then
        pcall(function()
            local farthestCloset = getFarthestClosetFromRakoof(hrp.Position)
            if farthestCloset then
                local targetPart = farthestCloset:IsA("BasePart") and farthestCloset or (farthestCloset.PrimaryPart or farthestCloset:FindFirstChildWhichIsA("BasePart", true))
                if targetPart then
                    LastTeleportTime = tick()

                    SaveHostActive = false
                    SaveHostBtn.Text = "🛡️ SAVE HOST (Auto-TP Closet): OFF"
                    SaveHostG.Color = OFF_GRAD

                    hrp.CFrame = targetPart.CFrame * CFrame.new(0, 3.5, 0)
                    showNoticeScreen()

                    task.delay(0.15, function()
                        if hrp and targetPart then
                            hrp.CFrame = targetPart.CFrame * CFrame.new(0, 4.2, 0)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                        end
                    end)
                end
            end
        end)
    end
end

--------------------------------------------------------------------------------
-- HEALTH REGEN INTELIGENTE
--------------------------------------------------------------------------------
HealthRegenBtn.Activated:Connect(function()
    HealthRegenActive = not HealthRegenActive
    HealthRegenBtn.Text = HealthRegenActive and "🍔 HEALTH REGEN (Anti-Rakoof Food): ON" or "🍔 HEALTH REGEN (Anti-Rakoof Food): OFF"
    HealthRegenG.Color = HealthRegenActive and ON_GRAD or OFF_GRAD
end)

Tasks.HealthRegenTask = task.spawn(function()
    while true do
        task.wait(3)
        if HealthRegenActive then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildWhichIsA("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                if hum and hrp then
                    if hum.Health > 49 then
                        HealthRegenActive = false
                        HealthRegenBtn.Text = "🍔 HEALTH REGEN (Anti-Rakoof Food): OFF"
                        HealthRegenG.Color = OFF_GRAD
                        return
                    end

                    local filter = Workspace:FindFirstChild("Filter")
                    local giversFolder = filter and filter:FindFirstChild("Givers")
                    if giversFolder then
                        local foodGivers = {}
                        local burgerF = giversFolder:FindFirstChild("Burger")
                        local tacoF = giversFolder:FindFirstChild("Taco")

                        if burgerF then for _, v in ipairs(burgerF:GetChildren()) do table.insert(foodGivers, v) end end
                        if tacoF then for _, v in ipairs(tacoF:GetChildren()) do table.insert(foodGivers, v) end end

                        if #foodGivers > 0 then
                            local referencePos = getRakoofPosition() or hrp.Position
                            
                            table.sort(foodGivers, function(a, b)
                                local partA = a:IsA("BasePart") and a or (a.PrimaryPart or a:FindFirstChildWhichIsA("BasePart", true))
                                local partB = b:IsA("BasePart") and b or (b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart", true))
                                if partA and partB then
                                    return (referencePos - partA.Position).Magnitude > (referencePos - partB.Position).Magnitude
                                end
                                return false
                            end)

                            local safeGiver = foodGivers[math.random(1, math.min(3, #foodGivers))]
                            local targetPart = safeGiver:IsA("BasePart") and safeGiver or (safeGiver.PrimaryPart or safeGiver:FindFirstChildWhichIsA("BasePart", true))
                            
                            if targetPart then
                                hrp.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Listener de daño
local function attachHealthListener(character)
    if not character then return end
    local hum = character:WaitForChild("Humanoid", 3)
    if hum then
        Connections.HealthChangedConn = hum.HealthChanged:Connect(function()
            checkAndTriggerSaveHost()
        end)
    end
end

if LocalPlayer.Character then attachHealthListener(LocalPlayer.Character) end
Connections.CharAddedConn = LocalPlayer.CharacterAdded:Connect(attachHealthListener)

-- Actualización UI Cooldown
Connections.CooldownUIUpdate = RunService.RenderStepped:Connect(function()
    local elapsed = tick() - LastTeleportTime
    if elapsed < CooldownTime then
        local remaining = math.ceil(CooldownTime - elapsed)
        CooldownLabel.Text = "⏳ COOLDOWN: " .. remaining .. "s"
        CooldownLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
    else
        CooldownLabel.Text = "⏳ COOLDOWN: READY (30s)"
        CooldownLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

--------------------------------------------------------------------------------
-- BUCLE PRINCIPAL DE ESCANEO ESP
--------------------------------------------------------------------------------
Tasks.ScannerTask = task.spawn(function()
    while true do
        task.wait(0.25)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            local filter = Workspace:FindFirstChild("Filter")
            if filter then
                local giversFolder = filter:FindFirstChild("Givers")
                if giversFolder then
                    local categories = {"Coin", "Coffee", "Burger", "Chips", "Fish", "Flare", "Slushie", "Taco"}
                    for _, cat in ipairs(categories) do
                        if States[cat] then
                            local folder = giversFolder:FindFirstChild(cat)
                            if folder then
                                for idx, item in ipairs(folder:GetChildren()) do
                                    applyESP(item, "🎁", cat .. " #" .. idx, Color3.fromRGB(255, 223, 0))
                                end
                            end
                        end
                    end
                end

                if States.Closets then
                    local closetsFolder = filter:FindFirstChild("Closets")
                    if closetsFolder then
                        for idx, closet in ipairs(closetsFolder:GetChildren()) do
                            applyESP(closet, "🚪", "Closet #" .. idx, Color3.fromRGB(100, 200, 255))
                        end
                    end
                end

                if States.Loot then
                    local lootFolder = filter:FindFirstChild("Lootable")
                    if lootFolder then
                        for idx, loot in ipairs(lootFolder:GetChildren()) do
                            applyESP(loot, "📦", "Lootable #" .. idx, Color3.fromRGB(50, 255, 100))
                        end
                    end
                end

                if States.Jose then
                    local joseFolder = filter:FindFirstChild("Jose")
                    if joseFolder then
                        for _, duck in ipairs(joseFolder:GetChildren()) do
                            applyESP(duck, "🦆", duck.Name, Color3.fromRGB(255, 215, 0))
                        end
                    end
                end

                if States.Scrap then
                    local scrapFolder = filter:FindFirstChild("ScrapMetals")
                    if scrapFolder then
                        for idx, scrap in ipairs(scrapFolder:GetChildren()) do
                            local trigger = scrap:FindFirstChild("TriggerPart")
                            local scrapType = "Scrap"
                            local color = Color3.fromRGB(200, 200, 200)

                            if trigger then
                                local sz = trigger.Size.Y
                                if sz >= 3.5 then
                                    scrapType = "High Scrap"
                                    color = Color3.fromRGB(255, 120, 0)
                                elseif sz >= 2 then
                                    scrapType = "Medium Scrap"
                                    color = Color3.fromRGB(255, 200, 50)
                                else
                                    scrapType = "Small Scrap"
                                    color = Color3.fromRGB(180, 150, 100)
                                end
                            end

                            applyESP(scrap, "⚙️", scrapType .. " #" .. idx, color)
                        end
                    end
                end
            end

            if States.Rakoof then
                local rakoof = Workspace:FindFirstChild("RakoofNPC")
                if rakoof then
                    applyESP(rakoof, "🦝", "Rakoof NPC", Color3.fromRGB(180, 100, 255))
                end
            end
        end
    end
end)

-- Actualización continua de distancias
Connections.DistanceLoop = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        local label = obj:FindFirstChild("NekoofCustomLabel")
        if label and label:FindFirstChild("Text") then
            local mainPart = obj:IsA("BasePart") and obj or (obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
            if mainPart then
                local dist = math.floor((hrp.Position - mainPart.Position).Magnitude)
                local currentText = label.Text.Text:gsub("%s*%[%d+m%]$", "")
                label.Text.Text = currentText .. " [" .. dist .. "m]"
            end
        end
    end
end)

print("🐥 Nekoof Version (WalkSpeed Slider Fixed) cargada con éxito!")
