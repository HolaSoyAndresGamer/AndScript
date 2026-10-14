local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local fuerzaLanzamiento = 150 -- Fuerza por defecto

    -- Contenedor horizontal para el botón y la cajita numérica
    local row = Instance.new("Frame", parentContainer)
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, -10, 0, 40)

    local uiLayout = Instance.new("UIListLayout", row)
    uiLayout.FillDirection = Enum.FillDirection.Horizontal
    uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiLayout.Padding = UDim.new(0, 6)

    -- 1. Botón azul de acción (no toggle)
    local b = Instance.new("TextButton", row)
    b.BackgroundColor3 = Color3.fromRGB(50, 120, 220) -- Color azul
    b.Size = UDim2.new(0.65, 0, 1, 0)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Lanzar"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    -- 2. Cajita de texto para ajustar la fuerza
    local tb = Instance.new("TextBox", row)
    tb.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    tb.Size = UDim2.new(0.32, 0, 1, 0)
    tb.Font = Enum.Font.SourceSansBold
    tb.Text = tostring(fuerzaLanzamiento)
    tb.TextColor3 = Color3.fromRGB(255, 255, 255)
    tb.TextSize = 14
    tb.ClearTextOnFocus = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)

    tb.FocusLost:Connect(function()
        local num = tonumber(tb.Text)
        if num then
            fuerzaLanzamiento = num
        else
            tb.Text = tostring(fuerzaLanzamiento)
        end
    end)

    -- Acción al hacer clic en Lanzar
    b.MouseButton1Click:Connect(function()
        -- Efecto visual de clic
        b.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        task.delay(0.15, function()
            if b and b.Parent then
                b.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
            end
        end)

        -- Buscamos el botón del Imán visualmente dentro del contenedor y si está encendido, simulamos su clic o reseteamos su texto/color
        for _, child in ipairs(parentContainer:GetChildren()) do
            if child:IsA("Frame") then
                for _, elem in ipairs(child:GetChildren()) do
                    if elem:IsA("TextButton") and elem.Text:find("Imán: ON") then
                        -- Cambiamos su texto y color de forma directa para reflejar que se apagó
                        elem.Text = "Imán: OFF"
                        elem.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                        
                        -- Intentamos disparar el evento si el ejecutor lo soporta, o dejamos que el ciclo se detenga
                        pcall(function()
                            for _, conn in ipairs(getconnections(elem.MouseButton1Click)) do
                                conn:Fire()
                            end
                        end)
                    end
                end
            end
        end

        -- Lanzar los objetos cercanos
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
end
