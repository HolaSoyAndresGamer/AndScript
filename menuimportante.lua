-- [[ AndScript Hub - Cargador Maestro ]] --
local CoreGui = game:GetService("CoreGui")

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name, Gui.ResetOnSpawn = "AndScriptMasterHub", false

local Frame = Instance.new("Frame", Gui)
Frame.BackgroundColor3, Frame.BackgroundTransparency = Color3.fromRGB(20, 20, 30), 0.3
Frame.Position, Frame.Size = UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0, 180, 0, 260)
Frame.Active, Frame.Draggable = true, true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Layout = Instance.new("UIListLayout", Frame)
Layout.SortOrder, Layout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center

-- URL base de tu repositorio (Asegúrate de que tus archivos estén directamente en la raíz de este repositorio)
local baseURL = "https://raw.githubusercontent.com/HolaSoyAndresGamer/AndScript/main/"

local function loadModule(fileName)
    local url = baseURL .. fileName
    local success, res = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local fn, err = loadstring(res)
        if fn then
            local s, e = pcall(fn)
            if s and type(e) == "function" then
                local successCall, errCall = pcall(function()
                    e(Frame)
                end)
                if not successCall then
                    warn("Error al ejecutar la función del módulo " .. fileName .. ": " .. tostring(errCall))
                end
            else
                warn("El módulo " .. fileName .. " no devolvió una función válida: " .. tostring(e))
            end
        else
            warn("Error de sintaxis al compilar " .. fileName .. ": " .. tostring(err))
        end
    else
        warn("No se pudo descargar de GitHub (Error de red/URL): " .. fileName .. " -> " .. tostring(res))
    end
end

-- Cargamos los módulos individuales
loadModule("fly.lua")
loadModule("noclip.lua")
loadModule("magnet.lua")
loadModule("brute.lua")
