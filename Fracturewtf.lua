-- ============================================================================
-- FRACTURE GUI | SYSTEM, TEST, HBE, 0.2s TELEPORT, TEAM CHECK & LOBBY IGNORE
-- ============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local ParentGui = CoreGui

--------------------------------------------------------------------------------
-- FUNCIÓN DE BÚSQUEDA DE CONTENEDOR DE PERSONAJES
--------------------------------------------------------------------------------
local function GetCharParent()
    local Charparent
    repeat task.wait() until LocalPlayer.Character
    for _, char in pairs(Workspace:GetDescendants()) do
        if string.find(char.Name, LocalPlayer.Name) and char:FindFirstChild("Humanoid") then
            Charparent = char.Parent
            break
        end
    end
    return Charparent or Workspace
end

local CHAR_PARENT = GetCharParent()

--------------------------------------------------------------------------------
-- DRAGGABLE HELPER (SOLO DESDE LA BARRA SUPERIOR)
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
-- LIMPIEZA PREVIA
--------------------------------------------------------------------------------
if ParentGui:FindFirstChild("FractureGui") then
    ParentGui.FractureGui:Destroy()
end

--------------------------------------------------------------------------------
-- ESTRUCTURA PRINCIPAL DE LA GUI
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", ParentGui)
ScreenGui.Name = "FractureGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 480, 0, 390)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(110, 60, 150)

--------------------------------------------------------------------------------
-- BARRA SUPERIOR (ZONA DE ARRASTRE)
--------------------------------------------------------------------------------
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundTransparency = 1

local TitleText = Instance.new("TextLabel", TopBar)
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "fracture.wtf [3000 Max Range + 0.2s TP]"
TitleText.TextColor3 = Color3.fromRGB(180, 180, 190)
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 12
TitleText.TextXAlignment = Enum.TextXAlignment.Left

makeDraggable(MainFrame, TopBar)

--------------------------------------------------------------------------------
-- NAVEGACIÓN (SYSTEM Y TEST)
--------------------------------------------------------------------------------
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 28)
TabBar.Position = UDim2.new(0, 10, 0, 32)
TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 4)

local TabBarLayout = Instance.new("UIListLayout", TabBar)
TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local PagesContainer = Instance.new("Frame", MainFrame)
PagesContainer.Size = UDim2.new(1, -20, 1, -76)
PagesContainer.Position = UDim2.new(0, 10, 0, 68)
PagesContainer.BackgroundTransparency = 1

local Pages = {}
local TabButtons = {}

local function createTab(name, order)
    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(0.5, 0, 1, 0)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(140, 140, 150)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 11
    TabBtn.LayoutOrder = order

    local Page = Instance.new("Frame", PagesContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    TabBtn.Activated:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabButtons) do b.TextColor3 = Color3.fromRGB(140, 140, 150) end
        
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(220, 160, 255)
    end)

    Pages[name] = Page
    TabButtons[name] = TabBtn

    if order == 1 then
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(220, 160, 255)
    end

    return Page
end

local TabSystem = createTab("System", 1)
local TabTest = createTab("Test", 2)

--------------------------------------------------------------------------------
-- GROUPBOX
--------------------------------------------------------------------------------
local function createGroupBox(parent, title, size, position)
    local Box = Instance.new("Frame", parent)
    Box.Size = size
    Box.Position = position
    Box.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Color = Color3.fromRGB(60, 45, 80)
    Stroke.Thickness = 1

    local Label = Instance.new("TextLabel", Box)
    Label.Size = UDim2.new(1, -10, 0, 18)
    Label.Position = UDim2.new(0, 8, 0, -8)
    Label.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Label.Text = "  " .. title .. "  "
    Label.TextColor3 = Color3.fromRGB(180, 140, 220)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Container = Instance.new("ScrollingFrame", Box)
    Container.Size = UDim2.new(1, -12, 1, -20)
    Container.Position = UDim2.new(0, 6, 0, 14)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)

    local Layout = Instance.new("UIListLayout", Container)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)

    return Container
end

--------------------------------------------------------------------------------
-- COMPONENTES (TOGGLE, SLIDER, BOTÓN)
--------------------------------------------------------------------------------
local function addToggle(parent, text, callback)
    local ToggleBtn = Instance.new("TextButton", parent)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 22)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = text
    ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    ToggleBtn.Font = Enum.Font.Gotham
    ToggleBtn.TextSize = 11
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local BoxIndicator = Instance.new("Frame", ToggleBtn)
    BoxIndicator.Size = UDim2.new(0, 12, 0, 12)
    BoxIndicator.Position = UDim2.new(1, -14, 0.5, -6)
    BoxIndicator.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Instance.new("UICorner", BoxIndicator).CornerRadius = UDim.new(0, 2)
    
    local IndStroke = Instance.new("UIStroke", BoxIndicator)
    IndStroke.Color = Color3.fromRGB(80, 60, 110)

    local state = false
    ToggleBtn.Activated:Connect(function()
        state = not state
        BoxIndicator.BackgroundColor3 = state and Color3.fromRGB(140, 70, 200) or Color3.fromRGB(30, 30, 38)
        pcall(callback, state)
    end)
end

local function addSlider(parent, text, min, max, default, callback)
    local Holder = Instance.new("Frame", parent)
    Holder.Size = UDim2.new(1, 0, 0, 38)
    Holder.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Holder)
    Label.Size = UDim2.new(1, 0, 0, 14)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(160, 160, 170)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel", Holder)
    ValueLabel.Size = UDim2.new(1, 0, 0, 14)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default) .. "/" .. tostring(max)
    ValueLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextSize = 10
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local SliderBar = Instance.new("Frame", Holder)
    SliderBar.Size = UDim2.new(1, 0, 0, 6)
    SliderBar.Position = UDim2.new(0, 0, 0, 22)
    SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 3)

    local SliderFill = Instance.new("Frame", SliderBar)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(140, 70, 200)
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 3)

    local value = default
    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        ValueLabel.Text = tostring(value) .. "/" .. tostring(max)
        pcall(callback, value)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

local function addButton(parent, text, callback)
    local Button = Instance.new("TextButton", parent)
    Button.Size = UDim2.new(1, 0, 0, 28)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(220, 220, 230)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 11
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 3)

    local Stroke = Instance.new("UIStroke", Button)
    Stroke.Color = Color3.fromRGB(70, 50, 95)

    Button.Activated:Connect(function()
        pcall(callback)
    end)
end

--------------------------------------------------------------------------------
-- CONFIGURACIÓN DE PESTAÑAS (SYSTEM Y TEST)
--------------------------------------------------------------------------------
local SystemBox = createGroupBox(TabSystem, "Combat Settings", UDim2.new(0.48, 0, 0.95, 0), UDim2.new(0, 0, 0, 10))
local TestBox = createGroupBox(TabTest, "Utilities", UDim2.new(0.48, 0, 0.95, 0), UDim2.new(0, 0, 0, 10))

getgenv().HBE = false
getgenv().FastKillUnder = false
getgenv().SpacedTeleport = false
getgenv().TeamCheck = true

local HITBOX_SIZE = 12
local HITBOX_TRANSPARENCY = 0.8
local HITBOX_COLOUR = Color3.fromRGB(255, 0, 0)
local verticalOffset = -27
local MAX_ARENA_DISTANCE = 3000

-- Plataforma Anti-Void automática
local antiVoidPart = Instance.new("Part")
antiVoidPart.Name = "FractureAntiVoid"
antiVoidPart.Size = Vector3.new(150, 3, 150)
antiVoidPart.Anchored = true
antiVoidPart.CanCollide = true
antiVoidPart.Transparency = 1
antiVoidPart.Parent = Workspace
antiVoidPart.CFrame = CFrame.new(0, -10000, 0)

-- Controles System
addToggle(SystemBox, "Hitbox Expander", function(state)
    getgenv().HBE = state
end)

addToggle(SystemBox, "Fast Kill (Bajo el Mapa)", function(state)
    getgenv().FastKillUnder = state
end)

addToggle(SystemBox, "Teleport Back (0.2s)", function(state)
    getgenv().SpacedTeleport = state
end)

addToggle(SystemBox, "Team Check", function(state)
    getgenv().TeamCheck = state
end)

addSlider(SystemBox, "Expand Size", 0, 40, 12, function(value)
    HITBOX_SIZE = math.max(value, 2)
end)

addSlider(SystemBox, "Transparency", 0, 100, 80, function(value)
    HITBOX_TRANSPARENCY = value / 100
end)

-- Slider de Distancia Máxima (Por defecto 3,000 studs)
addSlider(SystemBox, "Max Range (Distance)", 100, 3000, 3000, function(value)
    MAX_ARENA_DISTANCE = value
end)

-- Controles Test
addButton(TestBox, "Subir Altura (+5)", function()
    verticalOffset = verticalOffset + 5
end)

addButton(TestBox, "Bajar Altura (-5)", function()
    verticalOffset = verticalOffset - 5
end)

addButton(TestBox, "Destroy GUI", function()
    getgenv().HBE = false
    getgenv().FastKillUnder = false
    getgenv().SpacedTeleport = false
    if antiVoidPart then antiVoidPart:Destroy() end
    if CHAR_PARENT then
        for _, char in ipairs(CHAR_PARENT:GetChildren()) do
            local box = char:FindFirstChild("TargetHitbox")
            if box then box:Destroy() end
        end
    end
    ScreenGui:Destroy()
end)

--------------------------------------------------------------------------------
-- FUNCIONES AUXILIARES (LOBBY Y EQUIPO)
--------------------------------------------------------------------------------
local function isInLobby(char)
    if not char then
        return true
    end
    local lobbyFolder = Workspace:FindFirstChild("Lobby")
    if lobbyFolder then
        if char:IsDescendantOf(lobbyFolder) then
            return true
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum:IsDescendantOf(lobbyFolder) then
            return true
        end
    end
    return false
end

local function isTeammate(char)
    if not getgenv().TeamCheck or not char then
        return false
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChild("TeammateIconPart") then
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- FUNCIÓN PARA VALIDAR ENEMIGO (FILTRO DE ARENA, LOBBY Y EQUIPO)
--------------------------------------------------------------------------------
local function isValidDuelEnemy(player, char, myRoot)
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
        return false
    end

    if isInLobby(char) then
        return false
    end

    if isTeammate(char) then
        return false
    end

    local hrp = char.HumanoidRootPart

    if char.Humanoid.Health <= 0 then
        return false
    end

    if char:FindFirstChildOfClass("ForceField") then
        return false
    end

    local dist = (myRoot.Position - hrp.Position).Magnitude
    if dist > MAX_ARENA_DISTANCE then
        return false
    end

    local hasWeapon = char:FindFirstChildOfClass("Tool") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChildOfClass("Tool"))
    if not hasWeapon then
        return false
    end

    return true
end

--------------------------------------------------------------------------------
-- BUCLES DE EJECUCIÓN (HBE Y FAST KILL)
--------------------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if not ScreenGui.Parent then return end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    -- 1. Hitbox Expander (ignora y limpia cualquier personaje/humanoid en workspace.Lobby)
    if getgenv().HBE and CHAR_PARENT and myRoot then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = CHAR_PARENT:FindFirstChild(player.Name)
                if char then
                    if isInLobby(char) or isTeammate(char) or not isValidDuelEnemy(player, char, myRoot) then
                        local existingBox = char:FindFirstChild("TargetHitbox")
                        if existingBox then
                            existingBox:Destroy()
                        end
                    else
                        local hrp = char.HumanoidRootPart
                        local targetHitbox = char:FindFirstChild("TargetHitbox")

                        if not targetHitbox then
                            targetHitbox = Instance.new("Part")
                            targetHitbox.Name = "TargetHitbox"
                            targetHitbox.CastShadow = true
                            targetHitbox.Locked = false
                            targetHitbox.Anchored = true
                            targetHitbox.CanCollide = false
                            targetHitbox.CanQuery = true
                            targetHitbox.CanTouch = false
                            targetHitbox.Massless = true
                            targetHitbox.Material = Enum.Material.SmoothPlastic
                            targetHitbox.Parent = char
                        end

                        targetHitbox.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
                        targetHitbox.Transparency = HITBOX_TRANSPARENCY
                        targetHitbox.Color = HITBOX_COLOUR
                        targetHitbox.CFrame = hrp.CFrame
                    end
                end
            end
        end
    else
        if CHAR_PARENT then
            for _, char in ipairs(CHAR_PARENT:GetChildren()) do
                local box = char:FindFirstChild("TargetHitbox")
                if box then box:Destroy() end
            end
        end
    end

    -- 2. Fast Kill: Bajo el Mapa
    if getgenv().FastKillUnder and myRoot then
        local pos = myRoot.Position
        myRoot.CFrame = CFrame.new(pos.X, pos.Y + verticalOffset - (pos.Y - pos.Y), pos.Z)
        antiVoidPart.CFrame = CFrame.new(myRoot.Position.X, myRoot.Position.Y - 3, myRoot.Position.Z)
    else
        antiVoidPart.CFrame = CFrame.new(0, -10000, 0)
    end
end)

--------------------------------------------------------------------------------
-- BUCLE DE TELETRANSPORTE ESPACIADO A LA ESPALDA (0.2s)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.2) do
        if ScreenGui.Parent and getgenv().SpacedTeleport then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

            if myRoot then
                local myHasWeapon = myChar:FindFirstChildOfClass("Tool") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChildOfClass("Tool"))
                if myHasWeapon and not myChar:FindFirstChildOfClass("ForceField") then
                    local closestTarget = nil
                    local shortestDistance = MAX_ARENA_DISTANCE

                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local char = (CHAR_PARENT and CHAR_PARENT:FindFirstChild(player.Name)) or (Workspace:FindFirstChild(player.Name))
                            if isValidDuelEnemy(player, char, myRoot) then
                                local hrp = char.HumanoidRootPart
                                local dist = (myRoot.Position - hrp.Position).Magnitude
                                if dist < shortestDistance then
                                    shortestDistance = dist
                                    closestTarget = hrp
                                end
                            end
                        end
                    end

                    if closestTarget then
                        myRoot.CFrame = closestTarget.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- TECLA PARA OCULTAR (LEFT CONTROL)
--------------------------------------------------------------------------------
local isHidden = false
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        isHidden = not isHidden
        MainFrame.Visible = not isHidden
    end
end)

print("[FRACTURE GUI] 💜 Distancia máxima por defecto en 3,000 studs lista.")
