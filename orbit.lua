local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(parentContainer)
    local isOrbitActive = false
    local orbitConn = nil

    local b = Instance.new("TextButton", parentContainer)
    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Font = Enum.Font.SourceSansBold
    b.Text = "Imán Órbita: OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        isOrbitActive = not isOrbitActive
        getgenv().AndScriptMagnetActive = isOrbitActive

        if isOrbitActive then
            b.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            b.Text = "Imán Órbita: ON"
            
            local angle = 0
            orbitConn = RunService.Heartbeat:Connect(function(dt)
                -- Si se presiona el botón de lanzar externo, se apaga solo
                if not getgenv().AndScriptMagnetActive then
                    isOrbitActive = false
                    b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    b.Text = "Imán Órbita: OFF"
                    if orbitConn then orbitConn:Disconnect() orbitConn = nil end
                    return
                end

                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    angle = angle + (dt * 3) -- Velocidad a la que giran las cosas
                    local radius = 12 -- Distancia de separación (radio de la órbita en studs)
                    
                    -- Recopilar piezas cercanas
                    local parts = {}
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj.Anchored and obj.Parent ~= char and not obj:IsDescendantOf(char) then
                            local dist = (obj.Position - root.Position).Magnitude
                            if dist < 25 then
                                table.insert(parts, obj)
                            end
                        end
                    end

                    -- Distribuir las piezas uniformemente en el círculo orbital
                    local totalParts = #parts
                    if totalParts > 0 then
                        for i, obj in ipairs(parts) do
                            local objAngle = angle + ((i / totalParts) * (math.pi * 2))
                            -- Posición exacta en la órbita (X y Z circulares, Y elevado un poco para que floten)
                            local targetPos = root.Position + Vector3.new(math.cos(objAngle) * radius, 3, math.sin(objAngle) * radius)
                            
                            -- Empujar la pieza hacia su punto asignado en la órbita con velocidad fluida
                            local dir = targetPos - obj.Position
                            obj.Velocity = dir * 12 + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end)
        else
            b.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            b.Text = "Imán Órbita: OFF"
            if orbitConn then orbitConn:Disconnect() orbitConn = nil end
        end
    end)
end
