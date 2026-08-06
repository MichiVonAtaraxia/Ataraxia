local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ataraxia Voxlblade Esp",
    Icon = 130335438575425, 
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
local espBool, hpBool = true, false
local espDistance = 5000
local espSize = 15
local espFont = Drawing.Fonts.Monospace
local espColor = Color3.fromRGB(255, 255, 255)
local espOutlineColor = Color3.fromRGB(0, 0, 0)
local camera = workspace.CurrentCamera
local runSer = game:GetService("RunService")

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

            -- Comprehensive multi-part type safety validation
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

-- Rayfield UI Elements
local MainTab = Window:CreateTab("Main", nil)

local espToggle = MainTab:CreateToggle({
    Name = "Toggle ESP",
    CurrentValue = true,
    Flag = "ToggleESP",
    Callback = function(Value) espBool = Value end,
})

local hpToggle = MainTab:CreateToggle({
    Name = "Mob HP",
    CurrentValue = false,
    Flag = "MobHP",
    Callback = function(Value) hpBool = Value end,
})


local CustomizeSection = MainTab:CreateSection("Customise")

local ESPDistanceSlider = MainTab:CreateSlider({
    Name = "Max ESP Distance",
    Range = {0, 5000},
    Increment = 100,
    Suffix = "m",
    CurrentValue = 400,
    Flag = "ESPDistance",
    Callback = function(Value) espDistance = Value end,
})

local ESPSizeSlider = MainTab:CreateSlider({
    Name = "Text Size",
    Range = {1, 50},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 15,
    Flag = "ESPSize",
    Callback = function(Value) espSize = Value end,
})

local ESPFontDropdown = MainTab:CreateDropdown({
    Name = "Font",
    Options = { "UI", "System", "Plex", "Monospace" },
    CurrentOption = { "Monospace" },
    MultipleOptions = false,
    Flag = "ESPFont",
    Callback = function(Options)
        -- Verified Fix: Cleanly extracts first table element string value from selection array
        local selected = Options[1]
        if selected == "UI" then espFont = Drawing.Fonts.UI
        elseif selected == "System" then espFont = Drawing.Fonts.System
        elseif selected == "Plex" then espFont = Drawing.Fonts.Plex
        elseif selected == "Monospace" then espFont = Drawing.Fonts.Monospace end
    end,
})

local ESPColorPicker = MainTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPColor",
    Callback = function(Value) espColor = Value end
})

local ESPOutlineColorPicker = MainTab:CreateColorPicker({
    Name = "ESP Outline Color",
    Color = Color3.fromRGB(0, 0, 0),
    Flag = "ESPOutlineColor",
    Callback = function(Value) espOutlineColor = Value end
})

-- Runtime Execution
for _, v in ipairs(workspace.NPCS:GetChildren()) do
    espDraw(v)
end

workspace.NPCS.ChildAdded:Connect(function(v)
    espDraw(v)
end)
