local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ataraxia Voxlblade Esp",
    Icon = 0, 
    LoadingTitle = "Loading In...",
    LoadingSubtitle = "Made by Ataraxia",
    ShowText = "Rayfield", 
    Theme = "Default", 
    ToggleUIKeybind = "K", 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, 
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AtaraxiaConfig", 
        FileName = "Big Hub"
    },
    Discord = {
        Enabled = false, 
        Invite = "noinvitelink", 
        RememberJoins = true 
    },
    KeySystem = false, 
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided", 
        FileName = "Key", 
        SaveKey = true, 
        GrabKeyFromSite = false, 
        Key = {"Hello"} 
    }
})

-- locals & constants
local plr = game.Players.LocalPlayer
local espBool, hpBool = false, false 
local espDistance = 500 -- FIXED: Initialized actual rendering distance to 500m instead of 5000m
local espSize = 10 
local espFont = Drawing.Fonts.Monospace
local espColor = Color3.fromRGB(255, 255, 255) 
local espOutlineColor = Color3.fromRGB(0, 0, 0) 
local camera = workspace.CurrentCamera
local runSer = game:GetService("RunService")
local userInputSer = game:GetService("UserInputService")
local lightingSer = game:GetService("Lighting")

-- Player feature states
local infJumpActive = false
local loopWSActive = false
local targetWalkSpeed = 16
local antiLagActive = false 

-- Low-spec part conversion asset handler
local function cleanPart(v)
    if antiLagActive then
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end

-- functions
local function espDraw(model)
    local text = Drawing.new("Text")
    text.Visible = false
    text.Transparency = 1
    text.Center = true
    text.Color = espColor
    text.Outline = true
    text.OutlineColor = espOutlineColor
    text.Size = espSize
    text.Font = espFont

    local render
    local removeConnection

    render = runSer.RenderStepped:Connect(function()
        local s, e = pcall(function()
            if not model or not model.Parent then
                text:Remove()
                if render then render:Disconnect() end
                if removeConnection then removeConnection:Disconnect() end
                return
            end

            local plrChar = plr.Character
            if not plrChar then text.Visible = false return end

            local plrHRP = plrChar:FindFirstChild("HumanoidRootPart")
            if not plrHRP then text.Visible = false return end

            local targetPart = model:IsA("BasePart") and model or (model:FindFirstChild("HumanoidRootPart") or model:PrimaryPart() or model:FindFirstChildWhichIsA("BasePart"))
            if not targetPart then text.Visible = false return end
            
            local modelPos = targetPart.Position
            local vector, onScreen = camera:WorldToViewportPoint(modelPos)
            if not onScreen or not espBool then text.Visible = false return end

            if (modelPos - plrHRP.Position).Magnitude > espDistance then text.Visible = false return end

            text.Text = string.gsub(model.Name, "%d+", "")
            text.Visible = true

            if hpBool then
                local maxHP = model:GetAttribute("MAXHP") or 100
                local hp = model:GetAttribute("HP") or 100
                text.Text = text.Text .. " [" .. tostring(math.floor(hp)) .. "/" .. tostring(math.floor(maxHP)) .. "]"
            end

            text.Text = text.Text .. " - " .. tostring(math.floor((plrHRP.Position - modelPos).Magnitude)) .. "m"

            local magical = model:FindFirstChild("MagicalL")
            local bloody = model:FindFirstChild("BloodyL")
            local corrupt = model:FindFirstChild("CorruptL")
            local legendary = model:FindFirstChild("LegendaryL")

            if magical and magical.Enabled then text.Text = text.Text .. "\n" .. "[Magical]" end
            if bloody and bloody.Enabled then text.Text = text.Text .. "\n" .. "[Bloody]" end
            if corrupt and corrupt.Enabled then text.Text = text.Text .. "\n" .. "[Corrupt]" end
            if legendary and legendary.Enabled then text.Text = text.Text .. "\n" .. "[Legendary]" end

            text.Position = Vector2.new(vector.X, vector.Y)
            text.Color = espColor
            text.OutlineColor = espOutlineColor
            text.Size = espSize
            text.Font = espFont
        end)
    end)

    removeConnection = workspace.NPCS.ChildRemoved:Connect(function(v)
        if v == model then
            pcall(function()
                text:Remove()
                if render then render:Disconnect() end
                if removeConnection then removeConnection:Disconnect() end
            end)
        end
    end)
end

-- Infinite Jump and Loop Walkspeed
userInputSer.JumpRequest:Connect(function()
    if infJumpActive and plr.Character then
        local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function setupHumanoidSpeed(humanoid)
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if loopWSActive and humanoid.WalkSpeed ~= targetWalkSpeed then
            humanoid.WalkSpeed = targetWalkSpeed
        end
    end)
end

plr.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then setupHumanoidSpeed(hum) end
end)

if plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") then
    setupHumanoidSpeed(plr.Character:FindFirstChildWhichIsA("Humanoid"))
end

runSer.RenderStepped:Connect(function()
    if loopWSActive and plr.Character then
        local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
        if hum and hum.WalkSpeed ~= targetWalkSpeed then
            hum.WalkSpeed = targetWalkSpeed
        end
    end
end)

workspace.DescendantAdded:Connect(cleanPart)

-- RAYFIELD UI INTERFACE SETUP

-- 1. Player Tab
local PlayerTab = Window:CreateTab("Player", nil)

local InfJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value)
        infJumpActive = Value
    end,
})

local LoopWSToggle = PlayerTab:CreateToggle({
    Name = "Loop Walkspeed",
    CurrentValue = false,
    Flag = "LoopWS",
    Callback = function(Value)
        loopWSActive = Value
        if Value and plr.Character then
            local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = targetWalkSpeed end
        end
    end,
})

local WSTextBox = PlayerTab:CreateInput({
    Name = "Walkspeed Value",
    PlaceholderText = "16",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            targetWalkSpeed = num
            if loopWSActive and plr.Character then
                local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
                if hum then hum.WalkSpeed = num end
            end
        end
    end
})

local AntiLagButton = PlayerTab:CreateButton({
    Name = "Toggle Anti-Lag (Plastic)",
    Callback = function()
        antiLagActive = not antiLagActive
        
        if antiLagActive then
            pcall(function()
                for _, v in ipairs(workspace:GetDescendants()) do
                    cleanPart(v)
                end
            end)
        end
        
        Rayfield:Notify({
            Title = "Anti-Lag Status",
            Content = antiLagActive and "Anti-Lag optimization active! All parts are now plastic." or "Anti-Lag background updates paused.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- 2. Mob Esp Tab
local MobEspTab = Window:CreateTab("Mob Esp", nil)

local espToggle = MobEspTab:CreateToggle({
    Name = "Toggle ESP",
    CurrentValue = false, 
    Flag = "ToggleESP",
    Callback = function(Value) espBool = Value end,
})

local hpToggle = MobEspTab:CreateToggle({
    Name = "Mob HP",
    CurrentValue = false,
    Flag = "MobHP",
    Callback = function(Value) hpBool = Value end,
})

-- 3. Customization Tab
local CustomizationTab = Window:CreateTab("Customization", nil)

local ESPDistanceInput = CustomizationTab:CreateInput({
    Name = "Max ESP Distance",
    PlaceholderText = "500", -- Updated placeholder text to match new default intent
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            espDistance = num
        end
    end,
})

local ESPSizeInput = CustomizationTab:CreateInput({
    Name = "Text Size",
    PlaceholderText = "10",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            espSize = num
        end
    end,
})

-- Runtime Execution
for _, v in ipairs(workspace.NPCS:GetChildren()) do
    espDraw(v)
end

workspace.NPCS.ChildAdded:Connect(function(v)
    espDraw(v)
end)

