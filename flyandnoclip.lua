-- [[ Delta Hub - Módulo Fly & Noclip Multiplataforma (Actualizado Táctil) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local isFlying, isNoclipActive = false, false
local flySpeed, flyConn, noclipConn = 50, nil, nil

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name, Gui.ResetOnSpawn = "FlyNoclipGui", false

local Frame = Instance.new("Frame", Gui)
Frame.BackgroundColor3, Frame.BackgroundTransparency = Color3.fromRGB(20, 20, 30), 0.2
Frame.Position, Frame.Size = UDim2.new(0.02, 0, 0.4, 0), UDim2.new(0, 150, 0, 110)
Frame.Active, Frame.Draggable = true, true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Layout = Instance.new("UIListLayout", Frame)
Layout.SortOrder, Layout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 6)
Layout.HorizontalAlignment, Layout.VerticalAlignment = Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center

local function makeBtn(text)
    local b = Instance.new("TextButton", Frame)
    b.BackgroundColor3, b.Size = Color3.fromRGB(200, 50, 50), UDim2.new(0, 135, 0, 40)
    b.Font, b.Text, b.TextColor3, b.TextSize = Enum.Font.SourceSansBold, text, Color3.fromRGB(255, 255, 255), 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local FlyBtn, NoclipBtn = makeBtn("Fly: OFF"), makeBtn("Noclip: OFF")

FlyBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if isFlying then
        FlyBtn.BackgroundColor3, FlyBtn.Text = Color3.fromRGB(50, 200, 50), "Fly: ON"
        if root and hum then
            hum.PlatformStand = true
            local bg = Instance.new("BodyGyro", root)
            bg.Name, bg.MaxTorque = "DFG", Vector3.new(9e9, 9e9, 9e9)
            local bv = Instance.new("BodyVelocity", root)
            bv.Name, bv.MaxForce = "DFV", Vector3.new(9e9, 9e9, 9e9)
            
            flyConn = RunService.RenderStepped:Connect(function()
                local md = Vector3.new()
                local cf = Camera.CFrame
                
                -- Soporte para Teclado (PC)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then md += cf.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then md -= cf.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then md -= cf.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then md += cf.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then md -= Vector3.new(0, 1, 0) end
                
                -- Soporte Táctil (Móvil/Delta): Si el monigote se mueve con el joystick o la dirección del humanoide
                if hum.MoveDirection.Magnitude > 0 then
                    md = md + (cf.LookVector * hum.MoveDirection.Z + cf.RightVector * hum.MoveDirection.X)
                end
                
                bv.Velocity = md.Unit * flySpeed * (md.Magnitude > 0 and 1 or 0)
                bg.CFrame = cf
            end)
        end
    else
        FlyBtn.BackgroundColor3, FlyBtn.Text = Color3.fromRGB(200, 50, 50), "Fly: OFF"
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if char then
            if hum then hum.PlatformStand = false end
            if root then
                if root:FindFirstChild("DFG") then root.DFG:Destroy() end
                if root:FindFirstChild("DFV") then root.DFV:Destroy() end
            end
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
