-- [[ AndScript Hub - Módulo Fly ]] --
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
                    
                    if moveDir.Magnitude > 0 then
                        local hVel = moveDir * speed
                        local camLookFlat = Vector3.new(cam.LookVector.X, 0, cam.LookVector.Z).Unit
                        local forwardBackwardAmount = moveDir:Dot(camLookFlat)
                        local yVel = cam.LookVector.Y * math.abs(forwardBackwardAmount) * speed
                        bv.Velocity = Vector3.new(hVel.X, yVel, hVel.Z)
                    else
                        local kbMove = Vector3.new(0, 0, 0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then kbMove += cam.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then kbMove -= cam.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then kbMove -= cam.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then kbMove += cam.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then kbMove += Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then kbMove -= Vector3.new(0, 1, 0) end
                        
                        if kbMove.Magnitude > 0 then
                            bv.Velocity = kbMove.Unit * speed
                        else
                            bv.Velocity = Vector3.new(0, 0.1, 0)
                        end
                    end
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
