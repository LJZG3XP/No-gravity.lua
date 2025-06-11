-- Configuración de colores personalizados
local Colors = {
    Primary = Color3.fromRGB(0, 0, 0),
    Hover = Color3.fromRGB(30, 30, 30),
    Pressed = Color3.fromRGB(15, 15, 15),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(50, 50, 50),
}

-- Configuración del GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrippingGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Crear marco de fondo semi-transparente (ahora es el elemento arrastrable)
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Name = "Background"
backgroundFrame.Size = UDim2.new(0.3, 0, 0.15, 0)
backgroundFrame.Position = UDim2.new(0.35, 0, 0.425, 0)
backgroundFrame.BackgroundColor3 = Colors.Primary
backgroundFrame.BackgroundTransparency = 0.35
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Active = true
backgroundFrame.Draggable = true  -- Hacemos el fondo arrastrable en lugar del botón
backgroundFrame.Selectable = true
backgroundFrame.Parent = screenGui

-- Añadir esquinas redondeadas al fondo
local backgroundCorner = Instance.new("UICorner")
backgroundCorner.CornerRadius = UDim.new(0.08, 0)
backgroundCorner.Parent = backgroundFrame

-- Crear botón principal (ya no es arrastrable)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.9, 0, 0.7, 0)
toggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleButton.Text = "Zero Gravity (OFF)"
toggleButton.Font = Enum.Font.SourceSansSemibold
toggleButton.TextColor3 = Colors.Text
toggleButton.BackgroundColor3 = Colors.Primary
toggleButton.BackgroundTransparency = 0.25
toggleButton.TextScaled = true
toggleButton.Active = true
toggleButton.Parent = backgroundFrame

-- Resto del código permanece igual...
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0.15, 0)
buttonCorner.Parent = toggleButton

local buttonBorder = Instance.new("UIStroke")
buttonBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
buttonBorder.Color = Colors.Border
buttonBorder.Thickness = 2
buttonBorder.Parent = toggleButton

-- Efectos visuales adicionales
local function updateButtonAppearance(isPressed, isHovering)
    if isPressed then
        toggleButton.BackgroundColor3 = Colors.Pressed
        toggleButton.BackgroundTransparency = 0.15
    elseif isHovering then
        toggleButton.BackgroundColor3 = Colors.Hover
        toggleButton.BackgroundTransparency = 0.1
    else
        toggleButton.BackgroundColor3 = Colors.Primary
        toggleButton.BackgroundTransparency = 0.25
    end
end

toggleButton.MouseEnter:Connect(function()
    updateButtonAppearance(false, true)
end)

toggleButton.MouseLeave:Connect(function()
    updateButtonAppearance(false, false)
end)

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateButtonAppearance(true, true)
    end
end)

toggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateButtonAppearance(false, true)
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
        
        task.spawn(function()
            for i = 1, 3 do
                toggleButton.BackgroundColor3 = Colors.Hover
                toggleButton.BackgroundTransparency = 0.1
                task.wait(0.1)
                toggleButton.BackgroundColor3 = Colors.Primary
                toggleButton.BackgroundTransparency = 0.25
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
        
        task.spawn(function()
            for i = 1, 2 do
                toggleButton.BackgroundColor3 = Colors.Pressed
                toggleButton.BackgroundTransparency = 0.15
                task.wait(0.15)
                toggleButton.BackgroundColor3 = Colors.Primary
                toggleButton.BackgroundTransparency = 0.25
                task.wait(0.15)
            end
        end)
    end
end

toggleButton.MouseButton1Click:Connect(toggleTrip)

player.CharacterAdded:Connect(function()
    isTripping = false
    game.Workspace.Gravity = workspaceGravity
    toggleButton.Text = "Zero Gravity (OFF)"
    toggleButton.BackgroundColor3 = Colors.Primary
    toggleButton.BackgroundTransparency = 0.25
end)

player.PlayerRemoving:Connect(function()
    screenGui:Destroy()
end)
