-- [[ Delta Hub - Fly & Noclip Multiplataforma (PC / Móvil) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local isFlying = false
local isNoclipActive = false
local flySpeed = 50

local flyConnection = nil
local noclipConnection = nil

-- Crear GUI flotante para Fly y Noclip
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyNoclipGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Contenedor principal para los botones
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Position = UDim2.new(0.02, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 150, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- === BOTÓN FLY ===
local FlyButton = Instance.new("TextButton")
FlyButton.Parent = MainFrame
FlyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
FlyButton.Size = UDim2.new(0, 135, 0, 40)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.Text = "Fly: OFF"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 14

local CornerFly = Instance.new("UICorner")
CornerFly.CornerRadius = UDim.new(0, 6)
CornerFly.Parent = FlyButton

-- === BOTÓN NOCLIP ===
local NoclipButton = Instance.new("TextButton")
NoclipButton.Parent = MainFrame
NoclipButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
NoclipButton.Size = UDim2.new(0, 135, 0, 40)
NoclipButton.Font = Enum.Font.SourceSansBold
NoclipButton.Text = "Noclip: OFF"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.TextSize = 14

local CornerNoclip = Instance.new("UICorner")
CornerNoclip.CornerRadius = UDim.new(0, 6)
CornerNoclip.Parent = NoclipButton

-- ==================== LÓGICA DE FLY ====================
FlyButton.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if isFlying then
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        FlyButton.Text = "Fly: ON"
        
        if rootPart and humanoid then
            humanoid.PlatformStand = true
            
            -- Crear BodyVelocity y BodyGyro para suspender en el aire
            local bg = Instance.new("BodyGyro")
            bg.Name = "DeltaFlyGyro"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = rootPart.CFrame
            bg.Parent = rootPart
            
            local bv = Instance.new("BodyVelocity")
            bv.Name = "DeltaFlyVelocity"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = rootPart
            
            flyConnection = RunService.RenderStepped:Connect(function()
                if not character or not rootPart.Parent then return end
                
                local camCFrame = Camera.CFrame
                local moveDirection = Vector3.new(0, 0, 0)
                
                -- Control por Teclado (PC)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camCFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camCFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camCFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camCFrame.RightVector
                end
                -- Subir / Bajar en PC con Space / LeftControl
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                -- Aplicar movimiento si se presiona algo, sino mantener posición flotando
                bv.Velocity = moveDirection * flySpeed
                bg.CFrame = camCFrame
            end)
        end
    else
        FlyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        FlyButton.Text = "Fly: OFF"
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid then humanoid.PlatformStand = false end
            if rootPart then
                if rootPart:FindFirstChild("DeltaFlyGyro") then rootPart.DeltaFlyGyro:Destroy() end
                if rootPart:FindFirstChild("DeltaFlyVelocity") then rootPart.DeltaFlyVelocity:Destroy() end
            end
        end
    end
end)

-- ==================== LÓGICA DE NOCLIP ====================
NoclipButton.MouseButton1Click:Connect(function()
    isNoclipActive = not isNoclipActive
    
    if isNoclipActive then
        NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        NoclipButton.Text = "Noclip: ON"
        
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        NoclipButton.Text = "Noclip: OFF"
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

print("¡Fly y Noclip Multiplataforma cargados con éxito!")
