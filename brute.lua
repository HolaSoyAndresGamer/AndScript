-- [[ AndScript Hub - Módulo Fuerza Bruta ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local isBruteActive = false
    local bruteConn = nil

    local b = Instance.new("TextButton", parentContainer)
    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Fuerza Bruta: OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        isBruteActive = not isBruteActive
        if isBruteActive then
            b.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            b.Text = "Fuerza Bruta: ON"
            bruteConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if root and hum then
                    hum.WalkSpeed = 32
                    hum.JumpPower = 100
                    for _, p in ipairs(root:GetTouchingParts()) do
                        if p:IsA("BasePart") and not p.Anchored then
                            p.Velocity = root.CFrame.LookVector * 150 + Vector3.new(0, 50, 0)
                        end
                    end
                end
            end)
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            b.Text = "Fuerza Bruta: OFF"
            if bruteConn then bruteConn:Disconnect() bruteConn = nil end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
                hum.JumpPower = 50
            end
        end
    end)
end

