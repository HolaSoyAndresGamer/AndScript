-- [[ Delta Hub - Menú Principal Personalizado ]] --
local CoreGui = game:GetService("CoreGui")

-- 1. Crear la GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyPersonalHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. Botón para Abrir/Cerrar el Menú (Flotante)
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
OpenButton.Position = UDim2.new(0.05, 0, 0.15, 0)
OpenButton.Size = UDim2.new(0, 120, 0, 40)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Text = "⚙️ Delta Hub"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 16
OpenButton.Active = true
OpenButton.Draggable = true

-- Esquinas redondeadas para el botón principal
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 8)
UICornerBtn.Parent = OpenButton

-- 3. Ventana Principal del Menú (Contenedor)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Visible = false -- Empieza oculto
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerFrame = Instance.new("UICorner")
UICornerFrame.CornerRadius = UDim.new(0, 10)
UICornerFrame.Parent = MainFrame

-- Título del Menú
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Mis Scripts Guardados"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 10)
UICornerTitle.Parent = TitleLabel

-- 4. Contenedor de Botones (Layout automático)
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -55)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
ScrollingFrame.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Función auxiliar para crear botones dentro del menú fácilmente
local function addMenuButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingFrame
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- Abrir / Cerrar menú con el botón principal
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- AQUÍ AGREGAS TUS SCRIPTS COMO FUNCIONES
-- ==========================================

addMenuButton("Imán Dual: Activar", function()
    print("Aquí iría la lógica de tu Imán ON")
end)

addMenuButton("Imán Dual: Lanzar", function()
    print("Aquí iría la lógica de Lanzar")
end)

addMenuButton("Huracán de Escombros", function()
    print("Aquí iría tu script de huracán")
end)

addMenuButton("Cerrar / Borrar Todo", function()
    ScreenGui:Destroy()
    print("¡Menú cerrado y limpiado de la GUI!")
end)

print("¡Menu Hub personalizado cargado con éxito!")
