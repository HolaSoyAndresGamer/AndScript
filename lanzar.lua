local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local isLanzarActive = false
    local lanzarConn = nil
    local fuerzaLanzamiento = 150 -- Fuerza por defecto

    -- Contenedor horizontal para poner el botón y la cajita lado a lado
    local row = Instance.new("Frame", parentContainer)
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, -10, 0, 40)

    local uiLayout = Instance.new("UIListLayout", row)
    uiLayout.FillDirection = Enum.FillDirection.Horizontal
    uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiLayout.Padding = UDim.new(0, 6)

    -- 1. Botón principal de activación
    local b = Instance.new("TextButton", row)
    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    b.Size = UDim2.new(0.65, 0, 1, 0)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Lanzar: OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    -- 2. Cajita de texto para ajustar el número/fuerza
    local tb = Instance.new("TextBox", row)
    tb.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    tb.Size = UDim2.new(0.32, 0, 1, 0)
    tb.Font = Enum.Font.SourceSansBold
    tb.Text = tostring(fuerzaLanzamiento)
    tb.TextColor3 = Color3.fromRGB(255, 255, 255)
    tb.TextSize = 14
    tb.ClearTextOnFocus = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)

    -- Actualizar la fuerza cuando escribas un número en la cajita
    tb.FocusLost:Connect(function()
        local num = tonumber(tb.Text)
        if num then
            fuerzaLanzamiento = num
        else
            tb.Text = tostring(fuerzaLanzamiento)
        end
    end)

    -- Lógica de empuje / lanzamiento de objetos cercanos
    b.MouseButton1Click:Connect(function()
        isLanzarActive = not isLanzarActive
        if isLanzarActive then
            b.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            b.Text = "Lanzar: ON"
            lanzarConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, p in ipairs(root:GetTouchingParts()) do
                        if p:IsA("BasePart") and not p.Anchored and p.Parent ~= char and not p.IsDescendantOf(char) then
                            p.Velocity = root.CFrame.LookVector * fuerzaLanzamiento + Vector3.new(0, 30, 0)
                        end
                    end
                end
            end)
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            b.Text = "Lanzar: OFF"
            if lanzarConn then lanzarConn:Disconnect() lanzarConn = nil end
        end
    end)
end
