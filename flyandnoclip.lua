-- [[ Delta Hub - Fly & Noclip Pro (Estabilidad Total en Móvil) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local isFlying, isNoclipActive = false, false
local flySpeed, flyConn, noclipConn = 50, nil, nil
local movingUp, movingDown = false, false

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name, Gui.ResetOnSpawn = "FlyNoclipGui", false

-- Menú Principal Fly / Noclip
local Frame = Instance.new("Frame", Gui)
Frame.BackgroundColor3, Frame.BackgroundTransparency = Color3.fromRGB(20, 20, 30), 0.2
Frame.Position, Frame.Size = UDim2.new(0.02, 0, 0.4, 0), UDim2.new(0, 150, 0, 110)
Frame.Active, Frame.Draggable = true, true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Layout = Instance.new("UIListLayout", Frame)
Layout.SortOrder, Layout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 6)
Layout.HorizontalAlignment, Layout.VerticalAlignment = Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center

local function makeBtn(text, parent)
    local b = Instance.new("TextButton", parent)
    b.BackgroundColor3, b.Size = Color3.fromRGB(200, 50, 50), UDim2.new(0, 135, 0, 40)
    b.Font, b.Text, b.TextColor3, b.TextSize = Enum.Font.SourceSansBold, text, Color3.fromRGB(255, 255, 255), 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local FlyBtn = makeBtn("Fly: OFF", Frame)
local NoclipBtn = makeBtn("Noclip: OFF", Frame)

-- Botones flotantes de Subir y Bajar (aparecen solo al volar)
local UpDownFrame = Instance.new("Frame", Gui)
UpDownFrame.BackgroundTransparency = 1
UpDownFrame.Position = UDim2.new(0.85, 0, 0.4, 0)
UpDownFrame.Size = UDim2.new(0, 60, 0, 120)
UpDownFrame.Visible = false

local UpDownLayout = Instance.new("UIListLayout", UpDownFrame)
UpDownLayout.SortOrder, UpDownLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 10)
UpDownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UpBtn = Instance.new("TextButton", UpDownFrame)
UpBtn.BackgroundColor3, UpBtn.Size = Color3.fromRGB(50, 150, 250), UDim2.new(0, 55, 0, 50)
UpBtn.Font, UpBtn.Text, UpBtn.TextColor3, UpBtn.TextSize = Enum.Font.SourceSansBold, "⬆️", Color3.fromRGB(255, 255, 255), 20
Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(0, 8)

local DownBtn = Instance.new("TextButton", UpDownFrame)
DownBtn.BackgroundColor3, DownBtn.Size = Color3.fromRGB(50, 150, 250), UDim2.new(0, 55, 0, 50)
DownBtn.Font, DownBtn.Text, DownBtn.TextColor3, DownBtn.TextSize = Enum.Font.SourceSansBold, "⬇️", Color3.fromRGB(255, 255, 255), 20
Instance.new("UICorner", DownBtn).CornerRadius = UDim.new(0, 8)

UpBtn.MouseButton1Down:Connect(function() movingUp = true end)
UpBtn.MouseButton1Up:Connect(function() movingUp = false end)
DownBtn.MouseButton1Down:Connect(function() movingDown = true end)
DownBtn.MouseButton1Up:Connect(function() movingDown = false end)

FlyBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if isFlying then
        FlyBtn.BackgroundColor3, FlyBtn.Text = Color3.fromRGB(50, 200, 50), "Fly: ON"
        UpDownFrame.Visible = true
        
        if root and hum then
            hum.PlatformStand = true
            
            -- Sistema de vuelo por CFrame (Mucho más estable en móviles que las físicas)
            flyConn = RunService.RenderStepped:Connect(function(dt)
                if not char or not root.Parent then return end
                
                local moveDir = Vector3.new(0, 0, 0)
                local camCF = Camera.CFrame
                
                -- Movimiento con el joystick del juego en pantalla
                if hum.MoveDirection.Magnitude > 0 then
                    moveDir = moveDir + (camCF.LookVector * hum.MoveDirection.Z + camCF.RightVector * hum.MoveDirection.X)
                end
                
                -- Controles de teclado (por si acaso juegas en PC)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                
                -- Altura con botones táctiles o teclado
                local ySpeed = 0
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) or movingUp then ySpeed = ySpeed + flySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or movingDown then ySpeed = ySpeed - flySpeed end
                
                local finalVelocity = Vector3.new(0, 0, 0)
                if moveDir.Magnitude > 0 then
                    finalVelocity = moveDir.Unit * flySpeed
                end
                
                root.CFrame = root.CFrame + ((finalVelocity + Vector3.new(0, ySpeed, 0)) * dt)
                root.Velocity = Vector3.new(0, 0, 0) -- Anula la gravedad por completo
            end)
        end
    else
        FlyBtn.BackgroundColor3, FlyBtn.Text = Color3.fromRGB(200, 50, 50), "Fly: OFF"
        UpDownFrame.Visible = false
        movingUp, movingDown = false, false
        
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if char then
            if hum then hum.PlatformStand = false end
            if root then root.Velocity = Vector3.new(0, 0, 0) end
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    isNoclipActive = not isNoclipActive
    if isNoclipActive then
        NoclipBtn.BackgroundColor3, NoclipBtn.Text = Color3.fromRGB(50, 200, 50), "Noclip: ON"
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        NoclipBtn.BackgroundColor3, NoclipBtn.Text = Color3.fromRGB(200, 50, 50), "Noclip: OFF"
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanCollide = true end
            end
        end
    end
end)
