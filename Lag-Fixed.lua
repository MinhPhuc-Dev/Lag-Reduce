local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")

-- UI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 180)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local function createButton(name, posY)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Instance.new("UICorner", btn)
    return btn
end

local autoClickBtn = createButton("🖱️ Auto Click: OFF", 10)
local hitboxBtn = createButton("🎯 Hitbox: OFF", 60)
local fpsBoostBtn = createButton("⚡ Boost FPS: OFF", 110)

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

local function setHitbox(state)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    if state then
                        part.Size = Vector3.new(7, 9, 7)
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
end

hitboxBtn.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    hitboxBtn.Text = hitboxEnabled and "✅ Hitbox Boosted" or "🎯 Hitbox: OFF"
    setHitbox(hitboxEnabled)
end)

-- Boost FPS
local fpsBoosted = false

local function boostVisuals(state)
    for _, obj in pairs(game:GetDescendants()) do
        pcall(function()
            if state then
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                elseif obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
                    obj.Enabled = false
                end
            end
        end)
    end

    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = not state
    Lighting.FogEnd = state and 1000000 or 1000
    Lighting.Brightness = state and 1 or 3
end

fpsBoostBtn.MouseButton1Click:Connect(function()
    fpsBoosted = not fpsBoosted
    fpsBoostBtn.Text = fpsBoosted and "✅ Boosted FPS" or "⚡ Boost FPS: OFF"
    boostVisuals(fpsBoosted)
end)

-- Tự động bật cả 3 khi load
task.wait(1)

autoClicking = true
autoClickBtn.Text = "🖱️ Auto Click: ON"
task.spawn(function()
    while autoClicking do
        mouse1click()
        wait(clickDelay)
    end
end)

hitboxEnabled = true
hitboxBtn.Text = "✅ Hitbox Boosted"
setHitbox(true)

fpsBoosted = true
fpsBoostBtn.Text = "✅ Boosted FPS"
boostVisuals(true)
