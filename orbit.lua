local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local isOrbitActive = false
    local orbitConn = nil
    local radioOrbita = 12 -- Radio por defecto en studs

    -- Contenedor horizontal para poner el botón y la cajita de texto lado a lado
    local row = Instance.new("Frame", parentContainer)
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, -10, 0, 40)

    local uiLayout = Instance.new("UIListLayout", row)
    uiLayout.FillDirection = Enum.FillDirection.Horizontal
    uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiLayout.Padding = UDim.new(0, 6)

    -- 1. Botón principal del Imán Órbita
    local b = Instance.new("TextButton", row)
    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    b.Size = UDim2.new(0.65, 0, 1, 0)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Órbita: OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    -- 2. Cajita de texto para ajustar el radio de distancia
    local tb = Instance.new("TextBox", row)
    tb.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    tb.Size = UDim2.new(0.32, 0, 1, 0)
    tb.Font = Enum.Font.SourceSansBold
    tb.Text = tostring(radioOrbita)
    tb.TextColor3 = Color3.fromRGB(255, 255, 255)
    tb.TextSize = 14
    tb.ClearTextOnFocus = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)

    -- Actualizar el radio cuando escribas un número nuevo y des clic fuera
    tb.FocusLost:Connect(function()
        local num = tonumber(tb.Text)
        if num then
            radioOrbita = num
        else
            tb.Text = tostring(radioOrbita)
        end
    end)

    b.MouseButton1Click:Connect(function()
        isOrbitActive = not isOrbitActive
        getgenv().AndScriptMagnetActive = isOrbitActive

        if isOrbitActive then
            b.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            b.Text = "Órbita: ON"
            
            local angle = 0
            orbitConn = RunService.Heartbeat:Connect(function(dt)
                -- Apagado externo (por ejemplo, si usas el botón de lanzar)
                if not getgenv().AndScriptMagnetActive then
                    isOrbitActive = false
                    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    b.Text = "Órbita: OFF"
                    if orbitConn then orbitConn:Disconnect() orbitConn = nil end
                    return
                end

                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    angle = angle + (dt * 3) -- Velocidad de giro
                    
                    -- Recopilar piezas cercanas (usamos un rango amplio para detectar objetos antes de meterlos al radio)
                    local parts = {}
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj.Anchored and obj.Parent ~= char and not obj:IsDescendantOf(char) then
                            local dist = (obj.Position - root.Position).Magnitude
                            if dist < 35 then
                                table.insert(parts, obj)
                            end
                        end
                    end

                    -- Distribuir las piezas usando el radio personalizable de la cajita
                    local totalParts = #parts
                    if totalParts > 0 then
                        for i, obj in ipairs(parts) do
                            local objAngle = angle + ((i / totalParts) * (math.pi * 2))
                            local targetPos = root.Position + Vector3.new(math.cos(objAngle) * radioOrbita, 3, math.sin(objAngle) * radioOrbita)
                            
                            local dir = targetPos - obj.Position
                            obj.Velocity = dir * 12 + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end)
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            b.Text = "Órbita: OFF"
            if orbitConn then orbitConn:Disconnect() orbitConn = nil end
        end
    end)
end
