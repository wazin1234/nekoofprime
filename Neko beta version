local Players = game:GetService("Players") local Workspace = game:GetService("Workspace") local UserInputService = game:GetService("UserInputService") local ReplicatedStorage = game:GetService("ReplicatedStorage") local CoreGui = game:GetService("CoreGui") local HttpService = game:GetService("HttpService") local LocalPlayer = Players.LocalPlayer local ParentGui = CoreGui local KeyAuthApp = { Name = "NekohubBeta", OwnerId = "dazLHq43i6", Secret = "78220d4480121d87f17c3c07b620d9c2e2b86642831e8de9d3aefde8e9f83b50", Version = "1.0", LinkvertiseUrl = "https://direct-link.net/10346194/Q7lCnn2A2euA" } local authenticated = false
if
LocalPlayer.Name:lower() == "puraclcnz2"
then
  print("👑 [NEKO ADMIN] ¡Bienvenido puraCLCNZ2! Acceso concedido sin Key.") authenticated = true
end

if
not authenticated
then
  
  if
  ParentGui:FindFirstChild("NekoKeyGui")
  then
    ParentGui.NekoKeyGui:Destroy()
  end
  local KeyGui = Instance.new("ScreenGui", ParentGui) KeyGui.Name = "NekoKeyGui" KeyGui.ResetOnSpawn = false KeyGui.DisplayOrder = 999 local KeyFrame = Instance.new("Frame", KeyGui) KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5) KeyFrame.Size = UDim2.new(0, 380, 0, 230) KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0) KeyFrame.BackgroundColor3 = Color3.fromRGB(28, 15, 22) KeyFrame.Active = true Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12) local Stroke = Instance.new("UIStroke", KeyFrame) Stroke.Thickness = 2 Stroke.Color = Color3.fromRGB(255, 105, 180) local Title = Instance.new("TextLabel", KeyFrame) Title.Size = UDim2.new(1, 0, 0, 40) Title.BackgroundTransparency = 1 Title.Text = "🌸 NEKO PINK — KEY SYSTEM" Title.TextColor3 = Color3.fromRGB(255, 182, 193) Title.Font = Enum.Font.GothamBold Title.TextSize = 13 local KeyInput = Instance.new("TextBox", KeyFrame) KeyInput.Size = UDim2.new(0.85, 0, 0, 36) KeyInput.Position = UDim2.new(0.075, 0, 0.28, 0) KeyInput.BackgroundColor3 = Color3.fromRGB(45, 20, 32) KeyInput.PlaceholderText = "Ingresa tu Key de KeyAuth..." KeyInput.Text = "" KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255) KeyInput.PlaceholderColor3 = Color3.fromRGB(180, 140, 160) KeyInput.Font = Enum.Font.Gotham KeyInput.TextSize = 11 Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8) local VerifyBtn = Instance.new("TextButton", KeyFrame) VerifyBtn.Size = UDim2.new(0.4, 0, 0, 34) VerifyBtn.Position = UDim2.new(0.075, 0, 0.52, 0) VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) VerifyBtn.Text = "🔑 Verificar Key" VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255) VerifyBtn.Font = Enum.Font.GothamBold VerifyBtn.TextSize = 11 Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8) local GetKeyBtn = Instance.new("TextButton", KeyFrame) GetKeyBtn.Size = UDim2.new(0.4, 0, 0, 34) GetKeyBtn.Position = UDim2.new(0.525, 0, 0.52, 0) GetKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 25, 40) GetKeyBtn.Text = "🔗 Obtener Key" GetKeyBtn.TextColor3 = Color3.fromRGB(255, 182, 193) GetKeyBtn.Font = Enum.Font.GothamBold GetKeyBtn.TextSize = 11 Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8) local getStroke = Instance.new("UIStroke", GetKeyBtn) getStroke.Color = Color3.fromRGB(255, 105, 180) local Status = Instance.new("TextLabel", KeyFrame) Status.Size = UDim2.new(1, 0, 0, 24) Status.Position = UDim2.new(0, 0, 0.78, 0) Status.BackgroundTransparency = 1 Status.Text = "Estado: Esperando Key..." Status.TextColor3 = Color3.fromRGB(200, 200, 200) Status.Font = Enum.Font.Gotham Status.TextSize = 10 GetKeyBtn.Activated:Connect(
  function
    ()
    if
    setclipboard
    then
      setclipboard(KeyAuthApp.LinkvertiseUrl) Status.Text = "✅ ¡Enlace copiado al portapapeles!" Status.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
      Status.Text = "❌ Tu ejecutor no soporta setclipboard" Status.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    
  end
  ) VerifyBtn.Activated:Connect(
  function
    () local userKey = KeyInput.Text:gsub("%s+", "")
    if
    userKey == ""
    then
      Status.Text = "❌ Escribe una Key válida." Status.TextColor3 = Color3.fromRGB(255, 80, 80) return
    end
    Status.Text = "⏳ Validando con KeyAuth..." Status.TextColor3 = Color3.fromRGB(255, 255, 100) local req = (syn and syn.request) or (http and http.request) or request or http_request
    if
    req
    then
      local success, response = pcall(
      function
        () return req({ Url = string.format("https://keyauth.win/api/1.2/?type=license&key=%s&mask=&hwid=&name=%s&ownerid=%s", userKey, KeyAuthApp.Name, KeyAuthApp.OwnerId), Method = "GET" })
      end
      )
      if
      success and response and response.Body
      then
        local data = HttpService:JSONDecode(response.Body)
        if
        data.success
        then
          Status.Text = "✅ Key Correcta. Cargando..." Status.TextColor3 = Color3.fromRGB(100, 255, 100) task.wait(1) KeyGui:Destroy() authenticated = true
        else
          Status.Text = "❌ Key inválida o expirada." Status.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
        
      else
        Status.Text = "❌ Error de conexión con KeyAuth." Status.TextColor3 = Color3.fromRGB(255, 80, 80)
      end
      
    else
      Status.Text = "❌ Ejecutor no compatible con HTTP." Status.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    
  end
  )
  repeat
    task.wait(0.2)
  until
  authenticated
end
local
function
  verifySecurity()
  if
  not authenticated and LocalPlayer.Name:lower() ~= "puraclcnz2"
  then
    pcall(
    function
      () LocalPlayer:Kick("🌸 [NEKO SECURITY] Manipulación detectada. Acceso denegado.")
    end
    ) error("Security violation detected.")
  end
  
end
verifySecurity() local
function
  makeDraggable(guiFrame, dragHandle) dragHandle = dragHandle or guiFrame local dragging, dragInput, dragStart, startPos = false, nil, nil, nil dragHandle.InputBegan:Connect(
  function
    (input)
    if
    input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
    then
      dragging = true dragStart = input.Position startPos = guiFrame.Position input.Changed:Connect(
      function
        ()
        if
        input.UserInputState == Enum.UserInputState.End
        then
          dragging = false
        end
        
      end
      )
    end
    
  end
  ) dragHandle.InputChanged:Connect(
  function
    (input)
    if
    input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
    then
      dragInput = input
    end
    
  end
  ) UserInputService.InputChanged:Connect(
  function
    (input)
    if
    input == dragInput and dragging
    then
      local delta = input.Position - dragStart guiFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
  end
  )
end

if
ParentGui:FindFirstChild("NekoPinkGui")
then
  ParentGui.NekoPinkGui:Destroy()
end
local ScreenGui = Instance.new("ScreenGui", ParentGui) ScreenGui.Name = "NekoPinkGui" ScreenGui.ResetOnSpawn = false ScreenGui.DisplayOrder = 999 local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) MainFrame.Size = UDim2.new(0, 440, 0, 310) MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) MainFrame.BackgroundColor3 = Color3.fromRGB(28, 15, 22) MainFrame.Active = true Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12) local MainStroke = Instance.new("UIStroke", MainFrame) MainStroke.Thickness = 2 MainStroke.Color = Color3.fromRGB(255, 105, 180) makeDraggable(MainFrame) local TitleBar = Instance.new("Frame", MainFrame) TitleBar.Size = UDim2.new(1, 0, 0, 38) TitleBar.BackgroundColor3 = Color3.fromRGB(45, 20, 32) Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12) local TitleText = Instance.new("TextLabel", TitleBar) TitleText.Size = UDim2.new(1, -40, 1, 0) TitleText.Position = UDim2.new(0, 15, 0, 0) TitleText.BackgroundTransparency = 1 TitleText.Text = "🌸 NEKO PINK EDITION — HUB" TitleText.TextColor3 = Color3.fromRGB(255, 182, 193) TitleText.Font = Enum.Font.GothamBold TitleText.TextSize = 13 TitleText.TextXAlignment = Enum.TextXAlignment.Left local CloseBtn = Instance.new("TextButton", TitleBar) CloseBtn.Size = UDim2.new(0, 24, 0, 24) CloseBtn.Position = UDim2.new(1, -30, 0.5, -12) CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 80) CloseBtn.Text = "X" CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255) CloseBtn.Font = Enum.Font.GothamBold CloseBtn.TextSize = 11 Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6) CloseBtn.Activated:Connect(
function
  () ScreenGui:Destroy()
end
) local TabBar = Instance.new("Frame", MainFrame) TabBar.Size = UDim2.new(0, 120, 1, -48) TabBar.Position = UDim2.new(0, 8, 0, 42) TabBar.BackgroundColor3 = Color3.fromRGB(38, 18, 28) Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8) local TabList = Instance.new("UIListLayout", TabBar) TabList.SortOrder = Enum.SortOrder.LayoutOrder TabList.Padding = UDim.new(0, 6) local ContainerArea = Instance.new("Frame", MainFrame) ContainerArea.Size = UDim2.new(1, -142, 1, -48) ContainerArea.Position = UDim2.new(0, 134, 0, 42) ContainerArea.BackgroundTransparency = 1 local tabs = {} local
function
  createTab(name, order) local tabBtn = Instance.new("TextButton", TabBar) tabBtn.Size = UDim2.new(1, -8, 0, 36) tabBtn.Position = UDim2.new(0, 4, 0, 0) tabBtn.BackgroundColor3 = Color3.fromRGB(50, 22, 36) tabBtn.Text = name tabBtn.TextColor3 = Color3.fromRGB(255, 182, 193) tabBtn.Font = Enum.Font.GothamBold tabBtn.TextSize = 11 tabBtn.LayoutOrder = order Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6) local tabFrame = Instance.new("ScrollingFrame", ContainerArea) tabFrame.Size = UDim2.new(1, 0, 1, 0) tabFrame.BackgroundTransparency = 1 tabFrame.CanvasSize = UDim2.new(0, 0, 0, 250) tabFrame.ScrollBarThickness = 3 tabFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180) tabFrame.Visible = false local listLayout = Instance.new("UIListLayout", tabFrame) listLayout.SortOrder = Enum.SortOrder.LayoutOrder listLayout.Padding = UDim.new(0, 8) tabBtn.Activated:Connect(
  function
    ()
    for
    _, t in pairs(tabs)
    do
      t.Frame.Visible = false t.Button.BackgroundColor3 = Color3.fromRGB(50, 22, 36) t.Button.TextColor3 = Color3.fromRGB(255, 182, 193)
    end
    tabFrame.Visible = true tabBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
  end
  ) tabs[name] = {Button = tabBtn, Frame = tabFrame} return tabFrame
end
local CombateTab = createTab("⚔️ Combate", 1) local UtilidadesTab = createTab("📦 Utilidades", 2) tabs["⚔️ Combate"].Frame.Visible = true tabs["⚔️ Combate"].Button.BackgroundColor3 = Color3.fromRGB(255, 105, 180) tabs["⚔️ Combate"].Button.TextColor3 = Color3.fromRGB(255, 255, 255) local
function
  createButton(parent, text, callback) local btn = Instance.new("TextButton", parent) btn.Size = UDim2.new(1, -6, 0, 38) btn.BackgroundColor3 = Color3.fromRGB(55, 25, 40) btn.Text = text btn.TextColor3 = Color3.fromRGB(255, 192, 203) btn.Font = Enum.Font.GothamBold btn.TextSize = 11 Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8) local stroke = Instance.new("UIStroke", btn) stroke.Color = Color3.fromRGB(255, 105, 180) stroke.Thickness = 1 btn.Activated:Connect(
  function
    () verifySecurity() pcall(callback)
  end
  ) return btn
end
local TurboKillActive = false local turboBtn = createButton(CombateTab, "⚡ Turbo Auto-Kill (0.8s): OFF",
function
  () TurboKillActive = not TurboKillActive turboBtn.Text = TurboKillActive and "⚡ Turbo Auto-Kill (0.8s): ON" or "⚡ Turbo Auto-Kill (0.8s): OFF" turboBtn.BackgroundColor3 = TurboKillActive and Color3.fromRGB(180, 40, 100) or Color3.fromRGB(55, 25, 40)
  if
  TurboKillActive
  then
    task.spawn(
    function
      ()
      while
      TurboKillActive
      do
        verifySecurity() pcall(
        function
          () local char = LocalPlayer.Character local tool = char and char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool") local remote = tool and (tool:FindFirstChild("InflictTarget", true) or ReplicatedStorage:FindFirstChild("InflictTarget", true))
          if
          remote
          then
            
            for
            _, obj in ipairs(Workspace:GetChildren())
            do
              
              if
              not TurboKillActive
              then
                break
              end
              
              if
              obj:IsA("Model") and obj ~= char
              then
                local hum = obj:FindFirstChildOfClass("Humanoid") local part = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if
                hum and part and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj)
                then
                  remote:FireServer(hum, part) remote:FireServer(hum, part)
                end
                
              end
              
            end
            
          end
          
        end
        ) task.wait(0.8)
      end
      
    end
    )
  end
  
end
) local InfReachActive = false local reachBtn = createButton(CombateTab, "📏 Infinite Reach: OFF",
function
  () InfReachActive = not InfReachActive reachBtn.Text = InfReachActive and "📏 Infinite Reach: ON" or "📏 Infinite Reach: OFF" reachBtn.BackgroundColor3 = InfReachActive and Color3.fromRGB(180, 40, 100) or Color3.fromRGB(55, 25, 40)
  if
  InfReachActive
  then
    task.spawn(
    function
      ()
      while
      InfReachActive
      do
        verifySecurity() pcall(
        function
          () local char = LocalPlayer.Character local tool = char and char:FindFirstChildOfClass("Tool")
          if
          tool
          then
            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part")
            if
            handle
            then
              handle.Size = Vector3.new(60, 60, 60) handle.Transparency = 0.8 handle.CanCollide = false
            end
            
          end
          
        end
        ) task.wait(0.5)
      end
      
    end
    )
  else
    pcall(
    function
      () local char = LocalPlayer.Character local tool = char and char:FindFirstChildOfClass("Tool")
      if
      tool
      then
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part")
        if
        handle
        then
          handle.Size = Vector3.new(1, 1, 1) handle.Transparency = 0
        end
        
      end
      
    end
    )
  end
  
end
) local EspActive = false local espObjects = {} local
function
  removeEsp()
  for
  _, box in pairs(espObjects)
  do
    
    if
    box
    then
      box:Destroy()
    end
    
  end
  espObjects = {}
end
local espBtn = createButton(UtilidadesTab, "👁️ ESP Entities: OFF",
function
  () EspActive = not EspActive espBtn.Text = EspActive and "👁️ ESP Entities: ON" or "👁️ ESP Entities: OFF" espBtn.BackgroundColor3 = EspActive and Color3.fromRGB(180, 40, 100) or Color3.fromRGB(55, 25, 40)
  if
  not EspActive
  then
    removeEsp()
  else
    task.spawn(
    function
      ()
      while
      EspActive
      do
        verifySecurity() pcall(
        function
          () removeEsp() local char = LocalPlayer.Character
          for
          _, obj in ipairs(Workspace:GetChildren())
          do
            
            if
            obj:IsA("Model") and obj ~= char and not Players:GetPlayerFromCharacter(obj)
            then
              local hum = obj:FindFirstChildOfClass("Humanoid") local part = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
              if
              hum and part and hum.Health > 0
              then
                local highlight = Instance.new("Highlight", obj) highlight.FillColor = Color3.fromRGB(255, 105, 180) highlight.OutlineColor = Color3.fromRGB(255, 255, 255) highlight.FillTransparency = 0.5 table.insert(espObjects, highlight)
              end
              
            end
            
          end
          
        end
        ) task.wait(2)
      end
      removeEsp()
    end
    )
  end
  
end
) local AutoCandyActive = false local candyBtn = createButton(UtilidadesTab, "🍬 Auto Pick-Up Candy: OFF",
function
  () AutoCandyActive = not AutoCandyActive candyBtn.Text = AutoCandyActive and "🍬 Auto Pick-Up Candy: ON" or "🍬 Auto Pick-Up Candy: OFF" candyBtn.BackgroundColor3 = AutoCandyActive and Color3.fromRGB(180, 40, 100) or Color3.fromRGB(55, 25, 40)
  if
  AutoCandyActive
  then
    task.spawn(
    function
      ()
      while
      AutoCandyActive
      do
        verifySecurity() pcall(
        function
          () local char = LocalPlayer.Character local hrp = char and char:FindFirstChild("HumanoidRootPart")
          if
          hrp
          then
            
            for
            _, obj in ipairs(Workspace:GetDescendants())
            do
              
              if
              obj:IsA("BasePart") and (string.match(obj.Name:lower(), "candy") or string.match(obj.Name:lower(), "dulce"))
              then
                
                if
                (hrp.Position - obj.Position).Magnitude <= 50
                then
                  firetouchinterest(hrp, obj, 0) firetouchinterest(hrp, obj, 1)
                end
                
              end
              
            end
            
          end
          
        end
        ) task.wait(0.3)
      end
      
    end
    )
  end
  
end
) local AutoPickupActive = false local pickupBtn = createButton(UtilidadesTab, "🪙 Auto Pick-Up Normal: OFF",
function
  () AutoPickupActive = not AutoPickupActive pickupBtn.Text = AutoPickupActive and "🪙 Auto Pick-Up Normal: ON" or "🪙 Auto Pick-Up Normal: OFF" pickupBtn.BackgroundColor3 = AutoPickupActive and Color3.fromRGB(180, 40, 100) or Color3.fromRGB(55, 25, 40)
  if
  AutoPickupActive
  then
    task.spawn(
    function
      ()
      while
      AutoPickupActive
      do
        verifySecurity() pcall(
        function
          () local char = LocalPlayer.Character local hrp = char and char:FindFirstChild("HumanoidRootPart")
          if
          hrp
          then
            
            for
            _, obj in ipairs(Workspace:GetDescendants())
            do
              
              if
              obj:IsA("BasePart") and (string.match(obj.Name:lower(), "coin") or string.match(obj.Name:lower(), "item") or string.match(obj.Name:lower(), "drop") or string.match(obj.Name:lower(), "cash"))
              then
                
                if
                (hrp.Position - obj.Position).Magnitude <= 50
                then
                  firetouchinterest(hrp, obj, 0) firetouchinterest(hrp, obj, 1)
                end
                
              end
              
            end
            
          end
          
        end
        ) task.wait(0.3)
      end
      
    end
    )
  end
  
end
) print("[NEKO PINK] 🌸 NekohubBeta blindado y listo para distribución segura.")
