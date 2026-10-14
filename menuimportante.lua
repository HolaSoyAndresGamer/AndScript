-- [[ Delta Hub Maestro - menuimportante.lua ]] --
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CloudHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Botón flotante para abrir el menú principal
local OpenButton = Instance.new("TextButton")
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
OpenButton.Position = UDim2.new(0.05, 0, 0.15, 0)
OpenButton.Size = UDim2.new(0, 130, 0, 40)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Text = "☁️ AndScript Hub"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 16
OpenButton.Active = true
OpenButton.Draggable = true

local CornerOpen = Instance.new("UICorner")
CornerOpen.CornerRadius = UDim.new(0, 8)
CornerOpen.Parent = OpenButton

-- Ventana principal del menú
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local CornerMain = Instance.new("UICorner")
CornerMain.CornerRadius = UDim.new(0, 8)
CornerMain.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Botón dentro del menú que descarga y ejecuta tu flyandnoclip.lua desde la nube
local FlyScriptButton = Instance.new("TextButton")
FlyScriptButton.Parent = MainFrame
FlyScriptButton.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
FlyScriptButton.Size = UDim2.new(0, 180, 0, 35)
FlyScriptButton.Font = Enum.Font.SourceSansBold
FlyScriptButton.Text = "Cargar Fly & Noclip"
FlyScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyScriptButton.TextSize = 14

local CornerFlyBtn = Instance.new("UICorner")
CornerFlyBtn.CornerRadius = UDim.new(0, 6)
CornerFlyBtn.Parent = FlyScriptButton

FlyScriptButton.MouseButton1Click:Connect(function()
    local rawUrl = "https://raw.githubusercontent.com/HolaSoyAndresgGamer/AndScript/refs/heads/main/flyandnoclip.lua"
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(rawUrl))()
    end)
    
    if success then
        print("¡Fly y Noclip cargados desde la nube con éxito!")
    else
        warn("Error al cargar: " + tostring(err))
    end
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
