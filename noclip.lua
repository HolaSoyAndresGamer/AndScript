-- [[ AndScript Hub - Módulo Noclip ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local isNoclipActive = false
    local noclipConn = nil

    local b = Instance.new("TextButton", parentContainer)
    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Noclip: OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        isNoclipActive = not isNoclipActive
        if isNoclipActive then
            b.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            b.Text = "Noclip: ON"
            noclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            b.Text = "Noclip: OFF"
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanCollide = true end
                end
            end
        end
    end)
end
