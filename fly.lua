local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

return function(parentContainer)
    local isFlying = false
    local speed = 50
    local flyConn = nil

    local b = Instance.new("TextButton", parentContainer)
    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Fly: OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        isFlying = not isFlying
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if isFlying then
            b.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            b.Text = "Fly: ON"
            if root and hum then
                hum.PlatformStand = true
                local bv = Instance.new("BodyVelocity", root)
                bv.Name, bv.MaxForce = "MainFly_BV", Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
                
                local bg = Instance.new("BodyGyro", root)
                bg.Name, bg.MaxTorque = "MainFly_BG", Vector3.new(math.huge, math.huge, math.huge)
                bg.CFrame = root.CFrame
                
                flyConn = RunService.RenderStepped:Connect(function()
                    if not char or not root.Parent then return end
                    local cam = Camera.CFrame
                    local moveDir = hum.MoveDirection
                    local vel = Vector3.new(0, 0, 0)
                    
                    if moveDir.Magnitude > 0 then
                        local look = cam.LookVector
                        local right = cam.RightVector
                        
                        -- Aplanamos para calcular la dirección del joystick sin errores de división
                        local flatLook = Vector3.new(look.X, 0, look.Z)
                        if flatLook.Magnitude > 0.001 then
                            flatLook = flatLook.Unit
                        else
                            flatLook = Vector3.new(0, 0, -1)
                        end
                        
                        local flatRight = Vector3.new(right.X, 0, right.Z)
                        if flatRight.Magnitude > 0.001 then
                            flatRight = flatRight.Unit
                        else
                            flatRight = Vector3.new(1, 0, 0)
                        end
                        
                        local fwdAmount = moveDir:Dot(flatLook)
                        local rightAmount = moveDir:Dot(flatRight)
                        
                        -- Aplicamos el vector tridimensional completo de la cámara
                        vel = (look * fwdAmount) + (right * rightAmount)
                        if vel.Magnitude > 0 then
                            vel = vel.Unit * speed
                        end
                    else
                        -- Respaldo por teclado si se usa PC
                        local kbMove = Vector3.new(0, 0, 0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then kbMove += cam.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then kbMove -= cam.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then kbMove -= cam.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then kbMove += cam.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then kbMove += Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then kbMove -= Vector3.new(0, 1, 0) end
                        
                        if kbMove.Magnitude > 0 then
                            vel = kbMove.Unit * speed
                        else
                            vel = Vector3.new(0, 0.1, 0)
                        end
                    end
                    
                    bv.Velocity = vel
                    bg.CFrame = cam
                end)
            end
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            b.Text = "Fly: OFF"
            if flyConn then flyConn:Disconnect() flyConn = nil end
            if char then
                if hum then hum.PlatformStand = false end
                if root then
                    if root:FindFirstChild("MainFly_BV") then root.MainFly_BV:Destroy() end
                    if root:FindFirstChild("MainFly_BG") then root.MainFly_BG:Destroy() end
                end
            end
        end
    end)
end
