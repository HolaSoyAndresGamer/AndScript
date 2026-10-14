-- [[ AndScript Hub - Cargador Maestro (Menú Principal) ]] --
local CoreGui = game:GetService("CoreGui")

-- 1. Crear la Interfaz Principal del Hub
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name, Gui.ResetOnSpawn = "AndScriptMasterHub", false

local Frame = Instance.new("Frame", Gui)
Frame.BackgroundColor3, Frame.BackgroundTransparency = Color3.fromRGB(20, 20, 30), 0.3
Frame.Position, Frame.Size = UDim2.new(0.02, 0, 0.4, 0), UDim2.new(0, 160, 0, 240)
Frame.Active, Frame.Draggable = true, true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Layout = Instance.new("UIListLayout", Frame)
Layout.SortOrder, Layout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center

-- 2. URL base de tu repositorio en GitHub (¡Cambia tu usuario y repositorio aquí!)
local baseURL = "https://raw.githubusercontent.com/HolaSoyAndresGamer/AndScript/main/"

-- 3. Función para descargar y montar cada módulo automáticamente
local function loadModule(fileName)
    local success, moduleFunc = pcall(function()
        return loadstring(game:HttpGet(baseURL .. fileName))()
    end)
    
    if success and type(moduleFunc) == "function" then
        -- Le pasamos el Frame (el contenedor) para que dibuje su propio botón
        pcall(function()
            moduleFunc(Frame)
        end)
    else
        warn("No se pudo cargar el módulo: " .. fileName)
    end
end

-- 4. Cargar todos tus archivos independientes con una sola línea por archivo
loadModule("fly.lua")
loadModule("noclip.lua")
loadModule("magnet.lua")
loadModule("brute.lua")
