local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")

-- UI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 12)

local autoClickBtn = Instance.new("TextButton", mainFrame)
autoClickBtn.Size = UDim2.new(1, -20, 0, 40)
autoClickBtn.Position = UDim2.new(0, 10, 0, 10)
autoClickBtn.Text = "🖱️ Auto Click: OFF"
autoClickBtn.TextColor3 = Color3.new(1,1,1)
autoClickBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", autoClickBtn)

local hitboxBtn = Instance.new("TextButton", mainFrame)
hitboxBtn.Size = UDim2.new(1, -20, 0, 40)
hitboxBtn.Position = UDim2.new(0, 10, 0, 60)
hitboxBtn.Text = "🎯 Hitbox: OFF"
hitboxBtn.TextColor3 = Color3.new(1,1,1)
hitboxBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", hitboxBtn)

-- Auto Click
local autoClicking = false
local clickDelay = 0.05

function mouse1click()
    mouse1press()
    wait()
    mouse1release()
end

autoClickBtn.MouseButton1Click:Connect(function()
    autoClicking = not autoClicking
    autoClickBtn.Text = autoClicking and "🖱️ Auto Click: ON" or "🖱️ Auto Click: OFF"

    if autoClicking then
        task.spawn(function()
            while autoClicking do
                mouse1click()
                wait(clickDelay)
            end
        end)
    end
end)

-- Hitbox Boost
local hitboxEnabled = false

hitboxBtn.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    hitboxBtn.Text = hitboxEnabled and "✅ Hitbox Boosted" or "🎯 Hitbox: OFF"

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    if hitboxEnabled then
                        part.Size = Vector3.new(5, 7, 5)
                        part.Transparency = 0.5
                        part.Material = Enum.Material.ForceField
                    else
                        part.Size = Vector3.new(2, 2, 1)
                        part.Transparency = 0
                        part.Material = Enum.Material.Plastic
                    end
                end
            end
        end
    end
end)

-- Boost FPS
function boostVisuals()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function()
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                end
            end)
        end
    end

    for _, light in pairs(game:GetDescendants()) do
        if light:IsA("PointLight") or light:IsA("SurfaceLight") or light:IsA("SpotLight") then
            pcall(function()
                light.Enabled = false
            end)
        end
    end
end

-- Tự động bật khi load script
task.wait(1)

-- Bật Auto Click
autoClicking = true
autoClickBtn.Text = "🖱️ Auto Click: ON"
task.spawn(function()
    while autoClicking do
        mouse1click()
        wait(clickDelay)
    end
end)

-- Bật Hitbox
hitboxEnabled = true
hitboxBtn.Text = "✅ Hitbox Boosted"
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(5, 7, 5)
                part.Transparency = 0.5
                part.Material = Enum.Material.ForceField
            end
        end
    end
end

-- Bật Boost FPS
boostVisuals()
