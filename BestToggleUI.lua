local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game:GetService("Players").LocalPlayer

local function CreateToggleButton()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ToggleFluentUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = Player:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Name = "ZToggle"
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(1, -80, 0.5, -100) -- ✅ Lado direito da tela
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = "E"
    btn.TextColor3 = Color3.fromRGB(0, 0, 205)
    btn.Font = Enum.Font.GrenzeGotisch
    btn.TextScaled = true
    btn.TextStrokeTransparency = 0.3
    btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    btn.AutoButtonColor = true
    btn.ZIndex = 999
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 40)
    corner.Parent = btn

    -- 👉 Ao clicar, simula tecla LeftControl (abrir/fechar UI)
    btn.MouseButton1Click:Connect(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)

    -- Arrastável com movimentação firme
    local dragging, dragStart, startPos = false

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local delta = UIS:GetMouseLocation() - dragStart
            btn.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + math.floor(delta.X * 0.4),
                startPos.Y.Scale,
                startPos.Y.Offset + math.floor(delta.Y * 0.4)
            )
        end
    end)
end

CreateToggleButton()
