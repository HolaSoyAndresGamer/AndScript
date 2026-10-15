local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local isInvisible = false

    local b = Instance.new("TextButton", parentContainer)
    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Invisibilidad: OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    local function setTransparency(char, transparency)
        for _, desc in ipairs(char:GetDescendants()) do
            if desc:IsA("BasePart") then
                -- Ocultamos las partes del cuerpo, pero evitamos que afecte la raíz de colisión principal si prefieres
                desc.Transparency = transparency
                desc.CastShadow = (transparency == 0) -- Quita la sombra si es invisible
            elseif desc:IsA("Accessory") then
                local handle = desc:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = transparency
                    handle.CastShadow = (transparency == 0)
                end
            end
        end
        -- Ocultar la cara si tiene
        local head = char:FindFirstChild("Head")
        if head then
            local face = head:FindFirstChildOfClass("Decal")
            if face then
                face.Transparency = transparency
            end
        end
    end

    b.MouseButton1Click:Connect(function()
        isInvisible = not isInvisible
        local char = LocalPlayer.Character
        
        if isInvisible then
            b.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            b.Text = "Invisibilidad: ON"
            if char then
                setTransparency(char, 1)
            end
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            b.Text = "Invisibilidad: OFF"
            if char then
                setTransparency(char, 0)
            end
        end
    end)

    -- Por si mueres y reapareces, mantener o restablecer el estado si lo deseas
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        if isInvisible then
            task.wait(0.5) -- Esperar a que cargue bien el personaje
            setTransparency(newChar, 1)
        end
    end)
end
