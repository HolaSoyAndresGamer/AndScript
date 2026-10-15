local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local fuerzaLanzamiento = 150

    local row = Instance.new("Frame", parentContainer)
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, -10, 0, 40)

    local uiLayout = Instance.new("UIListLayout", row)
    uiLayout.FillDirection = Enum.FillDirection.Horizontal
    uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiLayout.Padding = UDim.new(0, 6)

    -- Botón de Lanzar (Azul)
    local b = Instance.new("TextButton", row)
    b.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
    b.Size = UDim2.new(0.65, 0, 1, 0)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Lanzar"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    -- Cajita numérica de fuerza
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

    b.MouseButton1Click:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        task.delay(0.15, function()
            if b and b.Parent then
                b.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
            end
        end)

        -- 1. DESACTIVAR EL IMÁN DE VERDAD (Apaga la lógica y la interfaz)
        getgenv().AndScriptMagnetActive = false
        pcall(function()
            for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
                if gui.Name == "AndScriptMasterHub" then
                    for _, desc in ipairs(gui:GetDescendants()) do
                        if desc:IsA("TextButton") and desc.Text:find("Imán") then
                            desc.Text = "Imán: OFF"
                            desc.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                        end
                    end
                end
            end
        end)

        -- 2. LANZAR OBJETOS CERCANOS
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj.Anchored and obj.Parent ~= char and not obj:IsDescendantOf(char) then
                    local dist = (obj.Position - root.Position).Magnitude
                    if dist < 20 then
                        obj.Velocity = root.CFrame.LookVector * fuerzaLanzamiento + Vector3.new(0, 40, 0)
                    end
                end
            end
        end
    end)
end
