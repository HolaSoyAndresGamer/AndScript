-- [[ AndScript Hub - Módulo Imán ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local isMagnetActive = false
    local magnetConn = nil

    local b = Instance.new("TextButton", parentContainer)
    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Imán: OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        isMagnetActive = not isMagnetActive
        if isMagnetActive then
            b.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            b.Text = "Imán: ON"
            magnetConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj.Anchored and obj.Parent ~= char and not obj:IsDescendantOf(char) then
                            local dist = (obj.Position - root.Position).Magnitude
                            if dist < 20 and dist > 2 then
                                obj.Velocity = (root.Position - obj.Position).Unit * 50
                            end
                        end
                    end
                end
            end)
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            b.Text = "Imán: OFF"
            if magnetConn then magnetConn:Disconnect() magnetConn = nil end
        end
    end)
end
