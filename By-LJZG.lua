-- Configuración de colores personalizados
local Colors = {
    Primary = Color3.new(0, 0, 0, 0.65), -- Negro semi-transparente
    Hover = Color3.new(0.1, 0.1, 0.1, 0.75), -- Negro más oscuro al pasar el mouse
    Pressed = Color3.new(0.05, 0.05, 0.05, 0.85), -- Negro más oscuro al presionar
    Text = Color3.new(1, 1, 1, 1), -- Blanco para el texto
    Border = Color3.new(0.1, 0.1, 0.1, 0.7), -- Borde negro semi-transparente
}

-- Configuración del GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrippingGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Crear botón principal
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.25, 0, 0.09, 0) -- Botón más cuadrado
toggleButton.Position = UDim2.new(0.37, 0, 0.45, 0)
toggleButton.Text = "Zero Gravity (OFF)"
toggleButton.Font = Enum.Font.SourceSansSemibold
toggleButton.TextColor3 = Colors.Text
toggleButton.BackgroundColor3 = Colors.Primary
toggleButton.TextScaled = true
toggleButton.Draggable = true
toggleButton.Active = true
toggleButton.Parent = screenGui

-- Efectos visuales adicionales
local function updateButtonAppearance(isPressed)
    if isPressed then
        toggleButton.BackgroundColor3 = Colors.Pressed
    else
        toggleButton.BackgroundColor3 = Colors.Primary
    end
end

local connection
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateButtonAppearance(true)
    end
end)

toggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateButtonAppearance(false)
    end
end)

-- Función principal de toggle
local isTripping = false
local workspaceGravity = game.Workspace.Gravity

local function toggleTrip()
    isTripping = not isTripping
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if isTripping then
        toggleButton.Text = "Zero Gravity (ON)"
        game.Workspace.Gravity = 0
        
        -- Efecto visual al activar
        task.spawn(function()
            for i = 1, 3 do
                toggleButton.BackgroundColor3 = Colors.Hover
                task.wait(0.1)
                toggleButton.BackgroundColor3 = Colors.Primary
                task.wait(0.1)
            end
        end)
        
        while isTripping and humanoid do
            humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
            task.wait(0.1)
        end
    else
        toggleButton.Text = "Zero Gravity (OFF)"
        game.Workspace.Gravity = workspaceGravity
        
        -- Efecto visual al desactivar
        task.spawn(function()
            for i = 1, 2 do
                toggleButton.BackgroundColor3 = Colors.Pressed
                task.wait(0.15)
                toggleButton.BackgroundColor3 = Colors.Primary
                task.wait(0.15)
            end
        end)
    end
end

-- Conectar eventos
connection = toggleButton.MouseButton1Click:Connect(toggleTrip)

-- Manejo de respawn
player.CharacterAdded:Connect(function()
    isTripping = false
    game.Workspace.Gravity = workspaceGravity
    toggleButton.Text = "Zero Gravity (OFF)"
    toggleButton.BackgroundColor3 = Colors.Primary
end)

-- Limpieza cuando el jugador sale
player.PlayerRemoving:Connect(function()
    if connection then
        connection:Disconnect()
    end
    screenGui:Destroy()
end)
