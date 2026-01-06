--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                    NOVA UI LIBRARY v2.0                       ║
    ║              Modern Dark Theme with Subtle Accents            ║
    ║                                                               ║
    ║  Features:                                                    ║
    ║  • Tabs with Material Icons                                   ║
    ║  • Toggles, Sliders, Dropdowns                               ║
    ║  • Color Picker, Keybind Picker                              ║
    ║  • Text Input, Buttons                                        ║
    ║  • Smooth Animations                                          ║
    ║  • Config Save/Load System                                    ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local NovaUI = {}
NovaUI.__index = NovaUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ============================================
-- ICON MODULE (Material Icons)
-- ============================================
local Icons = {
    ["home"] = "http://www.roblox.com/asset/?id=6026568195",
    ["settings"] = "http://www.roblox.com/asset/?id=6031280882",
    ["person"] = "http://www.roblox.com/asset/?id=6034287594",
    ["target"] = "http://www.roblox.com/asset/?id=6026568265",
    ["visibility"] = "http://www.roblox.com/asset/?id=6031075931",
    ["visibility_off"] = "http://www.roblox.com/asset/?id=6031075929",
    ["shield"] = "http://www.roblox.com/asset/?id=6035078889",
    ["bolt"] = "http://www.roblox.com/asset/?id=6035047381",
    ["games"] = "http://www.roblox.com/asset/?id=6026660074",
    ["code"] = "http://www.roblox.com/asset/?id=6022668955",
    ["palette"] = "http://www.roblox.com/asset/?id=6034316009",
    ["save"] = "http://www.roblox.com/asset/?id=6035067857",
    ["folder"] = "http://www.roblox.com/asset/?id=6031302932",
    ["close"] = "http://www.roblox.com/asset/?id=6031094678",
    ["check"] = "http://www.roblox.com/asset/?id=6031094667",
    ["chevron_down"] = "http://www.roblox.com/asset/?id=6031094680",
    ["chevron_right"] = "http://www.roblox.com/asset/?id=6031094680",
    ["keyboard"] = "http://www.roblox.com/asset/?id=6034818398",
    ["search"] = "http://www.roblox.com/asset/?id=6031154871",
    ["star"] = "http://www.roblox.com/asset/?id=6031068423",
    ["favorite"] = "http://www.roblox.com/asset/?id=6023426974",
    ["lock"] = "http://www.roblox.com/asset/?id=6026568224",
    ["lock_open"] = "http://www.roblox.com/asset/?id=6026568220",
    ["refresh"] = "http://www.roblox.com/asset/?id=6031097226",
    ["add"] = "http://www.roblox.com/asset/?id=6035047377",
    ["remove"] = "http://www.roblox.com/asset/?id=6035067836",
    ["edit"] = "http://www.roblox.com/asset/?id=6034328955",
    ["delete"] = "http://www.roblox.com/asset/?id=6022668885",
    ["info"] = "http://www.roblox.com/asset/?id=6026568227",
    ["warning"] = "http://www.roblox.com/asset/?id=6031071053",
    ["error"] = "http://www.roblox.com/asset/?id=6031071057",
    ["notifications"] = "http://www.roblox.com/asset/?id=6034308946",
    ["speed"] = "http://www.roblox.com/asset/?id=6026681578",
    ["timer"] = "http://www.roblox.com/asset/?id=6031754564",
    ["flight"] = "http://www.roblox.com/asset/?id=6034744030",
    ["sports"] = "http://www.roblox.com/asset/?id=6034230647",
    ["dashboard"] = "http://www.roblox.com/asset/?id=6022668883",
    ["analytics"] = "http://www.roblox.com/asset/?id=6022668884",
    ["build"] = "http://www.roblox.com/asset/?id=6023426938",
    ["extension"] = "http://www.roblox.com/asset/?id=6023565892",
    ["explore"] = "http://www.roblox.com/asset/?id=6023426941",
    ["bug_report"] = "http://www.roblox.com/asset/?id=6022852107",
    ["memory"] = "http://www.roblox.com/asset/?id=6034837807",
    ["wifi"] = "http://www.roblox.com/asset/?id=6034461626",
    ["bluetooth"] = "http://www.roblox.com/asset/?id=6034983880",
    ["brightness"] = "http://www.roblox.com/asset/?id=6034989541",
    ["volume"] = "http://www.roblox.com/asset/?id=6026671224",
    ["camera"] = "http://www.roblox.com/asset/?id=6031572312",
    ["videocam"] = "http://www.roblox.com/asset/?id=6026671213",
    ["mic"] = "http://www.roblox.com/asset/?id=6026660078",
    ["headset"] = "http://www.roblox.com/asset/?id=6034789880",
    ["mouse"] = "http://www.roblox.com/asset/?id=6034837797",
    ["gamepad"] = "http://www.roblox.com/asset/?id=6034789879",
    ["sparkle"] = "http://www.roblox.com/asset/?id=4483362748",
}

-- ============================================
-- THEME CONFIGURATION - MODERN SLEEK
-- ============================================
local Theme = {
    -- Main Colors - Darker, more neutral
    Background = Color3.fromRGB(12, 12, 15),
    Secondary = Color3.fromRGB(18, 18, 22),
    Tertiary = Color3.fromRGB(24, 24, 28),
    
    -- Accent Colors - Subtle blue-gray with minimal purple
    Accent = Color3.fromRGB(100, 110, 140),
    AccentDark = Color3.fromRGB(80, 88, 115),
    AccentLight = Color3.fromRGB(130, 145, 180),
    AccentGlow = Color3.fromRGB(110, 125, 160),
    
    -- Text Colors - Higher contrast
    TextPrimary = Color3.fromRGB(240, 242, 245),
    TextSecondary = Color3.fromRGB(160, 165, 175),
    TextMuted = Color3.fromRGB(100, 105, 115),
    
    -- State Colors
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(234, 179, 8),
    Error = Color3.fromRGB(239, 68, 68),
    
    -- Border & Stroke - More subtle
    Border = Color3.fromRGB(35, 35, 42),
    BorderAccent = Color3.fromRGB(90, 100, 130),
    
    -- Misc
    Shadow = Color3.fromRGB(0, 0, 0),
    Transparent = Color3.fromRGB(0, 0, 0),
}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local Utility = {}

function Utility.Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

function Utility.Tween(instance, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.2, easingStyle or Enum.EasingStyle.Quart, easingDirection or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

function Utility.Ripple(button, x, y)
    local ripple = Utility.Create("Frame", {
        Name = "Ripple",
        Parent = button,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 10,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Utility.Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

function Utility.MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility.Tween(frame, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.05)
        end
    end)
end

-- ============================================
-- CONFIG SYSTEM
-- ============================================
local ConfigSystem = {}
ConfigSystem.Configs = {}
ConfigSystem.CurrentConfig = "default"
ConfigSystem.SaveFolder = "NovaUI"

function ConfigSystem:GetSavePath()
    return self.SaveFolder .. "/" .. self.CurrentConfig .. ".json"
end

function ConfigSystem:GetAllConfigs()
    local configs = {}
    if isfolder and listfiles then
        if isfolder(self.SaveFolder) then
            for _, file in ipairs(listfiles(self.SaveFolder)) do
                local name = file:match("([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end
    end
    if #configs == 0 then
        table.insert(configs, "default")
    end
    return configs
end

function ConfigSystem:Save(configName)
    configName = configName or self.CurrentConfig
    local data = HttpService:JSONEncode(self.Configs)
    
    if writefile then
        if not isfolder(self.SaveFolder) then
            makefolder(self.SaveFolder)
        end
        writefile(self.SaveFolder .. "/" .. configName .. ".json", data)
        return true
    end
    return false
end

function ConfigSystem:Load(configName)
    configName = configName or self.CurrentConfig
    
    if readfile and isfile then
        local path = self.SaveFolder .. "/" .. configName .. ".json"
        if isfile(path) then
            local data = readfile(path)
            self.Configs = HttpService:JSONDecode(data)
            self.CurrentConfig = configName
            return true
        end
    end
    return false
end

function ConfigSystem:Delete(configName)
    if delfile and isfile then
        local path = self.SaveFolder .. "/" .. configName .. ".json"
        if isfile(path) then
            delfile(path)
            return true
        end
    end
    return false
end

function ConfigSystem:Set(category, key, value)
    if not self.Configs[category] then
        self.Configs[category] = {}
    end
    self.Configs[category][key] = value
end

function ConfigSystem:Get(category, key, default)
    if self.Configs[category] and self.Configs[category][key] ~= nil then
        return self.Configs[category][key]
    end
    return default
end

-- ============================================
-- MAIN LIBRARY
-- ============================================
function NovaUI.new(title, configName)
    local self = setmetatable({}, NovaUI)
    
    self.Title = title or "Nova UI"
    self.ConfigName = configName or "default"
    self.Tabs = {}
    self.CurrentTab = nil
    self.Minimized = false
    self.Flags = {}
    self.Visible = true
    
    -- Detect if mobile
    self.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    ConfigSystem.CurrentConfig = self.ConfigName
    ConfigSystem:Load()
    
    self:CreateGui()
    self:CreateToggleSystem()
    
    return self
end

function NovaUI:CreateGui()
    -- Destroy existing GUI
    if game.CoreGui:FindFirstChild("NovaUI") then
        game.CoreGui:FindFirstChild("NovaUI"):Destroy()
    end
    
    -- Main ScreenGui
    self.ScreenGui = Utility.Create("ScreenGui", {
        Name = "NovaUI",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Main Window
    self.MainFrame = Utility.Create("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
        }),
    })
    
    -- Subtle Drop Shadow
    local shadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Parent = self.MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
    })
    
    -- Title Bar
    self.TitleBar = Utility.Create("Frame", {
        Name = "TitleBar",
        Parent = self.MainFrame,
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
    })
    
    -- Title Bar Bottom Cover
    Utility.Create("Frame", {
        Name = "BottomCover",
        Parent = self.TitleBar,
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -8),
        Size = UDim2.new(1, 0, 0, 8),
    })
    
    -- Logo - subtle accent
    local logo = Utility.Create("ImageLabel", {
        Name = "Logo",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0.5, -10),
        Size = UDim2.new(0, 20, 0, 20),
        Image = Icons.sparkle,
        ImageColor3 = Theme.AccentLight,
    })
    
    -- Title Text
    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 0),
        Size = UDim2.new(0, 150, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Minimal Version Badge
    local versionBadge = Utility.Create("Frame", {
        Name = "VersionBadge",
        Parent = self.TitleBar,
        BackgroundColor3 = Theme.Tertiary,
        Position = UDim2.new(0, 100, 0.5, -9),
        Size = UDim2.new(0, 32, 0, 18),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility.Create("UIStroke", {
            Color = Theme.Border,
            Thickness = 1,
        }),
        Utility.Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = "v2",
            TextColor3 = Theme.TextSecondary,
            TextSize = 10,
        }),
    })
    
    -- Window Controls
    local controls = Utility.Create("Frame", {
        Name = "Controls",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -65, 0, 0),
        Size = UDim2.new(0, 55, 1, 0),
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 4),
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),
    })
    
    -- Minimize Button
    local minimizeBtn = self:CreateControlButton(controls, "rbxassetid://6031097229", function()
        self:ToggleMinimize()
    end)
    
    -- Close Button
    local closeBtn = self:CreateControlButton(controls, Icons.close, function()
        self:Destroy()
    end, Theme.Error)
    
    -- Make window draggable
    Utility.MakeDraggable(self.MainFrame, self.TitleBar)
    
    -- Tab Container (Left Side) - Slimmer
    self.TabContainer = Utility.Create("Frame", {
        Name = "TabContainer",
        Parent = self.MainFrame,
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 120, 1, -40),
    })
    
    self.TabList = Utility.Create("ScrollingFrame", {
        Name = "TabList",
        Parent = self.TabContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -20),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, {
        Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 4),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
        }),
    })
    
    -- Minimal Tab Indicator
    self.TabIndicator = Utility.Create("Frame", {
        Name = "TabIndicator",
        Parent = self.TabContainer,
        BackgroundColor3 = Theme.AccentLight,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(0, 2, 0, 34),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 1)}),
    })
    
    -- Content Container
    self.ContentContainer = Utility.Create("Frame", {
        Name = "ContentContainer",
        Parent = self.MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 130, 0, 50),
        Size = UDim2.new(1, -140, 1, -60),
        ClipsDescendants = true,
    })
    
    -- Notification Container
    self.NotificationContainer = Utility.Create("Frame", {
        Name = "Notifications",
        Parent = self.ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -320, 0, 10),
        Size = UDim2.new(0, 300, 1, -20),
    }, {
        Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Top,
        }),
    })
    
    -- Opening Animation
    self.MainFrame.Size = UDim2.new(0, 600, 0, 0)
    self.MainFrame.BackgroundTransparency = 1
    
    task.delay(0.1, function()
        Utility.Tween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back)
    end)
end

function NovaUI:CreateControlButton(parent, icon, callback, hoverColor)
    local btn = Utility.Create("TextButton", {
        Name = "ControlButton",
        Parent = parent,
        BackgroundColor3 = Theme.Tertiary,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 22, 0, 22),
        Text = "",
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -7, 0.5, -7),
            Size = UDim2.new(0, 14, 0, 14),
            Image = icon,
            ImageColor3 = Theme.TextSecondary,
        }),
    })
    
    btn.MouseEnter:Connect(function()
        Utility.Tween(btn, {BackgroundTransparency = 0}, 0.2)
        Utility.Tween(btn.Icon, {ImageColor3 = hoverColor or Theme.TextPrimary}, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        Utility.Tween(btn, {BackgroundTransparency = 1}, 0.2)
        Utility.Tween(btn.Icon, {ImageColor3 = Theme.TextSecondary}, 0.2)
    end)
    
    btn.MouseButton1Click:Connect(function()
        Utility.Ripple(btn, Mouse.X, Mouse.Y)
        if callback then callback() end
    end)
    
    return btn
end

function NovaUI:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        Utility.Tween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 40)}, 0.3)
    else
        Utility.Tween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.3, Enum.EasingStyle.Back)
    end
end

function NovaUI:Toggle()
    self.Visible = not self.Visible
    
    if self.Visible then
        self.MainFrame.Visible = true
        self.MainFrame.BackgroundTransparency = 1
        self.MainFrame.Size = UDim2.new(0, 600, 0, 0)
        Utility.Tween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Back)
    else
        Utility.Tween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 0), BackgroundTransparency = 1}, 0.2)
        task.delay(0.2, function()
            if not self.Visible then
                self.MainFrame.Visible = false
            end
        end)
    end
end

function NovaUI:CreateToggleSystem()
    if self.IsMobile then
        -- Mobile Toggle Button - more subtle
        self.MobileToggle = Utility.Create("TextButton", {
            Name = "MobileToggle",
            Parent = self.ScreenGui,
            BackgroundColor3 = Theme.Secondary,
            Position = UDim2.new(0, 10, 0.5, -25),
            Size = UDim2.new(0, 50, 0, 50),
            Text = "",
            ZIndex = 1000,
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Utility.Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -12, 0.5, -12),
                Size = UDim2.new(0, 24, 0, 24),
                Image = Icons.sparkle,
                ImageColor3 = Theme.AccentLight,
                ZIndex = 1001,
            }),
            Utility.Create("UIStroke", {
                Color = Theme.Border,
                Thickness = 2,
            }),
        })
        
        -- Make mobile button draggable
        local dragging = false
        local dragStart, startPos
        
        self.MobileToggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = self.MobileToggle.Position
            end
        end)
        
        self.MobileToggle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
                self.MobileToggle.Position = newPos
            end
        end)
        
        -- Toggle UI on tap
        local touchStart = 0
        local touchStartPos = Vector2.new()
        
        self.MobileToggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touchStart = tick()
                touchStartPos = input.Position
            end
        end)
        
        self.MobileToggle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                local touchDuration = tick() - touchStart
                local touchDelta = (input.Position - touchStartPos).Magnitude
                
                if touchDuration < 0.3 and touchDelta < 10 then
                    self:Toggle()
                    
                    Utility.Tween(self.MobileToggle, {Size = UDim2.new(0, 45, 0, 45)}, 0.1)
                    task.delay(0.1, function()
                        Utility.Tween(self.MobileToggle, {Size = UDim2.new(0, 50, 0, 50)}, 0.1)
                    end)
                end
            end
        end)
    else
        -- PC Keybind (Left Control to toggle)
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == Enum.KeyCode.LeftControl then
                self:Toggle()
            end
        end)
    end
end

-- ============================================
-- TAB SYSTEM
-- ============================================
function NovaUI:CreateTab(name, icon)
    local tab = {
        Name = name,
        Icon = icon or Icons.home,
        Elements = {},
        Container = nil,
        Button = nil,
    }
    
    -- Sleeker Tab Button
    tab.Button = Utility.Create("TextButton", {
        Name = name .. "Tab",
        Parent = self.TabList,
        BackgroundColor3 = Theme.Tertiary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Text = "",
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
    })
    
    -- Icon
    local tabIcon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Parent = tab.Button,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = tab.Icon,
        ImageColor3 = Theme.TextMuted,
    })
    
    -- Tab Name Label
    local tabLabel = Utility.Create("TextLabel", {
        Name = "Label",
        Parent = tab.Button,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -35, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = Theme.TextMuted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    
    -- Tab Content Container
    tab.Container = Utility.Create("ScrollingFrame", {
        Name = name .. "Content",
        Parent = self.ContentContainer,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, {
        Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
        Utility.Create("UIPadding", {
            PaddingRight = UDim.new(0, 10),
        }),
    })
    
    -- Tab Button Events
    tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Utility.Tween(tab.Button, {BackgroundTransparency = 0.8}, 0.2)
            Utility.Tween(tabIcon, {ImageColor3 = Theme.TextSecondary}, 0.2)
            Utility.Tween(tabLabel, {TextColor3 = Theme.TextSecondary}, 0.2)
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Utility.Tween(tab.Button, {BackgroundTransparency = 1}, 0.2)
            Utility.Tween(tabIcon, {ImageColor3 = Theme.TextMuted}, 0.2)
            Utility.Tween(tabLabel, {TextColor3 = Theme.TextMuted}, 0.2)
        end
    end)
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    -- Select first tab automatically
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function NovaUI:SelectTab(tab)
    -- Deselect previous tab
    if self.CurrentTab then
        self.CurrentTab.Container.Visible = false
        Utility.Tween(self.CurrentTab.Button, {BackgroundTransparency = 1}, 0.2)
        Utility.Tween(self.CurrentTab.Button.Icon, {ImageColor3 = Theme.TextMuted}, 0.2)
        Utility.Tween(self.CurrentTab.Button.Label, {TextColor3 = Theme.TextMuted}, 0.2)
    end
    
    -- Select new tab
    self.CurrentTab = tab
    tab.Container.Visible = true
    Utility.Tween(tab.Button, {BackgroundTransparency = 0.9}, 0.2)
    Utility.Tween(tab.Button.Icon, {ImageColor3 = Theme.AccentLight}, 0.2)
    Utility.Tween(tab.Button.Label, {TextColor3 = Theme.TextPrimary}, 0.2)
    
    -- Move indicator
    local buttonPos = tab.Button.AbsolutePosition.Y - self.TabContainer.AbsolutePosition.Y
    Utility.Tween(self.TabIndicator, {Position = UDim2.new(0, 0, 0, buttonPos)}, 0.3, Enum.EasingStyle.Back)
end

-- ============================================
-- SECTION
-- ============================================
function NovaUI:CreateSection(tab, name)
    local section = {
        Name = name,
        Container = nil,
    }
    
    section.Container = Utility.Create("Frame", {
        Name = name .. "Section",
        Parent = tab.Container,
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility.Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
    })
    
    -- Section Header
    local header = Utility.Create("Frame", {
        Name = "Header",
        Parent = section.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 32),
    }, {
        Utility.Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = name,
            TextColor3 = Theme.TextPrimary,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
    })
    
    -- Content
    section.Content = Utility.Create("Frame", {
        Name = "Content",
        Parent = section.Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 32),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, {
        Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
        Utility.Create("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
        }),
    })
    
    return section
end

-- ============================================
-- TOGGLE
-- ============================================
function NovaUI:CreateToggle(section, name, default, callback, flag)
    local toggle = {
        Name = name,
        Value = default or false,
        Callback = callback,
        Flag = flag,
    }
    
    -- Load saved value
    if flag then
        toggle.Value = ConfigSystem:Get("toggles", flag, default)
        self.Flags[flag] = toggle
    end
    
    local container = Utility.Create("Frame", {
        Name = name .. "Toggle",
        Parent = section.Content,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 36),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
    })
    
    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -65, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local toggleBtn = Utility.Create("TextButton", {
        Name = "ToggleButton",
        Parent = container,
        BackgroundColor3 = toggle.Value and Theme.Accent or Theme.Border,
        Position = UDim2.new(1, -50, 0.5, -9),
        Size = UDim2.new(0, 40, 0, 18),
        Text = "",
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
    })
    
    local toggleCircle = Utility.Create("Frame", {
        Name = "Circle",
        Parent = toggleBtn,
        BackgroundColor3 = Theme.TextPrimary,
        Position = toggle.Value and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        Size = UDim2.new(0, 14, 0, 14),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
    })
    
    local function updateToggle()
        Utility.Tween(toggleBtn, {BackgroundColor3 = toggle.Value and Theme.Accent or Theme.Border}, 0.2)
        Utility.Tween(toggleCircle, {Position = toggle.Value and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2, Enum.EasingStyle.Back)
        
        if flag then
            ConfigSystem:Set("toggles", flag, toggle.Value)
        end
        
        if callback then
            callback(toggle.Value)
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        updateToggle()
    end)
    
    -- Hover effect
    container.MouseEnter:Connect(function()
        Utility.Tween(container, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
    end)
    
    container.MouseLeave:Connect(function()
        Utility.Tween(container, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
    
    function toggle:Set(value)
        toggle.Value = value
        updateToggle()
    end
    
    -- Initial callback
    if callback then callback(toggle.Value) end
    
    return toggle
end

-- ============================================
-- SLIDER
-- ============================================
function NovaUI:CreateSlider(section, name, min, max, default, callback, flag)
    local slider = {
        Name = name,
        Min = min or 0,
        Max = max or 100,
        Value = default or min,
        Callback = callback,
        Flag = flag,
    }
    
    -- Load saved value
    if flag then
        slider.Value = ConfigSystem:Get("sliders", flag, default)
        self.Flags[flag] = slider
    end
    
    local container = Utility.Create("Frame", {
        Name = name .. "Slider",
        Parent = section.Content,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 48),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
    })
    
    local topRow = Utility.Create("Frame", {
        Name = "TopRow",
        Parent = container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
    })
    
    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Parent = topRow,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local valueLabel = Utility.Create("TextLabel", {
        Name = "Value",
        Parent = topRow,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -50, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = tostring(slider.Value),
        TextColor3 = Theme.AccentLight,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    local sliderTrack = Utility.Create("Frame", {
        Name = "Track",
        Parent = container,
        BackgroundColor3 = Theme.Border,
        Position = UDim2.new(0, 10, 0, 30),
        Size = UDim2.new(1, -20, 0, 4),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
    })
    
    local sliderFill = Utility.Create("Frame", {
        Name = "Fill",
        Parent = sliderTrack,
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
    })
    
    local sliderKnob = Utility.Create("Frame", {
        Name = "Knob",
        Parent = sliderFill,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 12, 0, 12),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
    })
    
    local function updateSlider(value)
        value = math.clamp(value, slider.Min, slider.Max)
        value = math.floor(value)
        slider.Value = value
        
        local percent = (value - slider.Min) / (slider.Max - slider.Min)
        Utility.Tween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
        valueLabel.Text = tostring(value)
        
        if flag then
            ConfigSystem:Set("sliders", flag, value)
        end
        
        if callback then
            callback(value)
        end
    end
    
    local dragging = false
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percent = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            updateSlider(slider.Min + (slider.Max - slider.Min) * percent)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            updateSlider(slider.Min + (slider.Max - slider.Min) * percent)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Hover effects
    container.MouseEnter:Connect(function()
        Utility.Tween(container, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
        Utility.Tween(sliderKnob, {Size = UDim2.new(0, 16, 0, 16)}, 0.2)
    end)
    
    container.MouseLeave:Connect(function()
        Utility.Tween(container, {BackgroundColor3 = Theme.Tertiary}, 0.2)
        Utility.Tween(sliderKnob, {Size = UDim2.new(0, 12, 0, 12)}, 0.2)
    end)
    
    function slider:Set(value)
        updateSlider(value)
    end
    
    return slider
end

-- ============================================
-- DROPDOWN
-- ============================================
function NovaUI:CreateDropdown(section, name, options, default, callback, flag)
    local dropdown = {
        Name = name,
        Options = options or {},
        Value = default or options[1],
        Callback = callback,
        Flag = flag,
        Open = false,
    }
    
    -- Load saved value
    if flag then
        dropdown.Value = ConfigSystem:Get("dropdowns", flag, default)
        self.Flags[flag] = dropdown
    end
    
    local container = Utility.Create("Frame", {
        Name = name .. "Dropdown",
        Parent = section.Content,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 36),
        ClipsDescendants = true,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
    })
    
    local header = Utility.Create("TextButton", {
        Name = "Header",
        Parent = container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Text = "",
    })
    
    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local selectedLabel = Utility.Create("TextLabel", {
        Name = "Selected",
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, -30, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = dropdown.Value or "Select...",
        TextColor3 = Theme.AccentLight,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    local arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -22, 0.5, -5),
        Size = UDim2.new(0, 10, 0, 10),
        Image = Icons.chevron_down,
        ImageColor3 = Theme.TextMuted,
        Rotation = 0,
    })
    
    local optionsContainer = Utility.Create("Frame", {
        Name = "Options",
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 36),
        Size = UDim2.new(1, 0, 0, #options * 28),
    }, {
        Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 2),
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
        }),
    })
    
    for _, option in ipairs(options) do
        local optionBtn = Utility.Create("TextButton", {
            Name = option,
            Parent = optionsContainer,
            BackgroundColor3 = Theme.Border,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 26),
            Font = Enum.Font.GothamMedium,
            Text = option,
            TextColor3 = option == dropdown.Value and Theme.AccentLight or Theme.TextSecondary,
            TextSize = 11,
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        })
        
        optionBtn.MouseEnter:Connect(function()
            Utility.Tween(optionBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.TextPrimary}, 0.2)
        end)
        
        optionBtn.MouseLeave:Connect(function()
            Utility.Tween(optionBtn, {BackgroundTransparency = 1, TextColor3 = option == dropdown.Value and Theme.AccentLight or Theme.TextSecondary}, 0.2)
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            dropdown.Value = option
            selectedLabel.Text = option
            
            -- Update all option colors
            for _, btn in ipairs(optionsContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = btn.Name == option and Theme.AccentLight or Theme.TextSecondary
                end
            end
            
            if flag then
                ConfigSystem:Set("dropdowns", flag, option)
            end
            
            if callback then
                callback(option)
            end
            
            -- Close dropdown
            dropdown.Open = false
            Utility.Tween(container, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
            Utility.Tween(arrow, {Rotation = 0}, 0.2)
        end)
    end
    
    header.MouseButton1Click:Connect(function()
        dropdown.Open = not dropdown.Open
        
        if dropdown.Open then
            Utility.Tween(container, {Size = UDim2.new(1, 0, 0, 36 + #options * 28 + 8)}, 0.2)
            Utility.Tween(arrow, {Rotation = 180}, 0.2)
        else
            Utility.Tween(container, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
            Utility.Tween(arrow, {Rotation = 0}, 0.2)
        end
    end)
    
    function dropdown:Set(value)
        dropdown.Value = value
        selectedLabel.Text = value
        
        for _, btn in ipairs(optionsContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.TextColor3 = btn.Name == value and Theme.AccentLight or Theme.TextSecondary
            end
        end
        
        if callback then callback(value) end
    end
    
    dropdown.Container = container
    dropdown.OptionsContainer = optionsContainer
    
    return dropdown
end


-- ============================================
-- TEXT INPUT
-- ============================================
function NovaUI:CreateTextInput(section, name, placeholder, default, callback, flag)
    local textinput = {
        Name = name,
        Value = default or "",
        Callback = callback,
        Flag = flag,
    }
    
    -- Load saved value
    if flag then
        textinput.Value = ConfigSystem:Get("textinputs", flag, default)
        self.Flags[flag] = textinput
    end
    
    local container = Utility.Create("Frame", {
        Name = name .. "TextInput",
        Parent = section.Content,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 38),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
    })
    
    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.4, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local inputFrame = Utility.Create("Frame", {
        Name = "InputFrame",
        Parent = container,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.4, 5, 0.5, -13),
        Size = UDim2.new(0.6, -15, 0, 26),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility.Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
    })
    
    local input = Utility.Create("TextBox", {
        Name = "Input",
        Parent = inputFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamMedium,
        PlaceholderText = placeholder or "Enter text...",
        PlaceholderColor3 = Theme.TextMuted,
        Text = textinput.Value,
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
    })
    
    input.Focused:Connect(function()
        Utility.Tween(inputFrame.UIStroke, {Color = Theme.Accent}, 0.2)
    end)
    
    input.FocusLost:Connect(function(enterPressed)
        Utility.Tween(inputFrame.UIStroke, {Color = Theme.Border}, 0.2)
        textinput.Value = input.Text
        
        if flag then
            ConfigSystem:Set("textinputs", flag, input.Text)
        end
        
        if callback then
            callback(input.Text)
        end
    end)
    
    function textinput:Set(value)
        textinput.Value = value
        input.Text = value
        if callback then callback(value) end
    end
    
    return textinput
end

-- ============================================
-- KEYBIND PICKER
-- ============================================
function NovaUI:CreateKeybind(section, name, default, callback, flag)
    local keybind = {
        Name = name,
        Value = default or Enum.KeyCode.Unknown,
        Callback = callback,
        Flag = flag,
        Listening = false,
    }
    
    -- Load saved value
    if flag then
        local savedKey = ConfigSystem:Get("keybinds", flag, nil)
        if savedKey then
            keybind.Value = Enum.KeyCode[savedKey] or default
        end
        self.Flags[flag] = keybind
    end
    
    local container = Utility.Create("Frame", {
        Name = name .. "Keybind",
        Parent = section.Content,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 38),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
    })
    
    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local keyBtn = Utility.Create("TextButton", {
        Name = "KeyButton",
        Parent = container,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(1, -90, 0.5, -13),
        Size = UDim2.new(0, 80, 0, 26),
        Font = Enum.Font.GothamBold,
        Text = keybind.Value.Name or "None",
        TextColor3 = Theme.AccentLight,
        TextSize = 11,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility.Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
        Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 5, 0.5, -6),
            Size = UDim2.new(0, 12, 0, 12),
            Image = Icons.keyboard,
            ImageColor3 = Theme.TextMuted,
        }),
    })
    
    keyBtn.MouseButton1Click:Connect(function()
        keybind.Listening = true
        keyBtn.Text = "..."
        Utility.Tween(keyBtn.UIStroke, {Color = Theme.Accent}, 0.2)
        Utility.Tween(keyBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if keybind.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keybind.Value = input.KeyCode
                keybind.Listening = false
                keyBtn.Text = input.KeyCode.Name
                Utility.Tween(keyBtn.UIStroke, {Color = Theme.Border}, 0.2)
                Utility.Tween(keyBtn, {BackgroundColor3 = Theme.Background}, 0.2)
                
                if flag then
                    ConfigSystem:Set("keybinds", flag, input.KeyCode.Name)
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                keybind.Listening = false
                keyBtn.Text = keybind.Value.Name or "None"
                Utility.Tween(keyBtn.UIStroke, {Color = Theme.Border}, 0.2)
                Utility.Tween(keyBtn, {BackgroundColor3 = Theme.Background}, 0.2)
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keybind.Value then
            if callback then
                callback(keybind.Value)
            end
        end
    end)
    
    function keybind:Set(key)
        keybind.Value = key
        keyBtn.Text = key.Name
    end
    
    return keybind
end

-- ============================================
-- COLOR PICKER
-- ============================================
function NovaUI:CreateColorPicker(section, name, default, callback, flag)
    local colorpicker = {
        Name = name,
        Value = default or Color3.fromRGB(138, 43, 226),
        Callback = callback,
        Flag = flag,
        Open = false,
    }
    
    -- Load saved value
    if flag then
        local savedColor = ConfigSystem:Get("colors", flag, nil)
        if savedColor then
            colorpicker.Value = Color3.fromRGB(savedColor.R, savedColor.G, savedColor.B)
        end
        self.Flags[flag] = colorpicker
    end
    
    local container = Utility.Create("Frame", {
        Name = name .. "ColorPicker",
        Parent = section.Content,
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 38),
        ClipsDescendants = true,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
    })
    
    local header = Utility.Create("TextButton", {
        Name = "Header",
        Parent = container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 38),
        Text = "",
    })
    
    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local colorPreview = Utility.Create("Frame", {
        Name = "Preview",
        Parent = header,
        BackgroundColor3 = colorpicker.Value,
        Position = UDim2.new(1, -55, 0.5, -10),
        Size = UDim2.new(0, 45, 0, 20),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility.Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
    })
    
    local pickerContainer = Utility.Create("Frame", {
        Name = "Picker",
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 45),
        Size = UDim2.new(1, -20, 0, 120),
    })
    
    -- Saturation/Value Picker
    local svPicker = Utility.Create("ImageButton", {
        Name = "SVPicker",
        Parent = pickerContainer,
        BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        Size = UDim2.new(1, -30, 0, 90),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
    })
    
    -- White to Color gradient (horizontal - saturation)
    local saturationGradient = Utility.Create("Frame", {
        Name = "SaturationGradient",
        Parent = svPicker,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility.Create("UIGradient", {
            Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Rotation = 0,
        }),
    })
    
    -- Black overlay (vertical - value)
    local darkOverlay = Utility.Create("Frame", {
        Name = "DarkOverlay",
        Parent = svPicker,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility.Create("UIGradient", {
            Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            }),
            Rotation = 90,
        }),
    })
    
    local svCursor = Utility.Create("Frame", {
        Name = "Cursor",
        Parent = svPicker,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 12, 0, 12),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility.Create("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 2}),
    })
    
    -- Hue Slider
    local huePicker = Utility.Create("ImageButton", {
        Name = "HuePicker",
        Parent = pickerContainer,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.new(1, -20, 0, 0),
        Size = UDim2.new(0, 15, 0, 90),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
            }),
            Rotation = 90,
        }),
    })
    
    local hueCursor = Utility.Create("Frame", {
        Name = "Cursor",
        Parent = huePicker,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 4, 0, 6),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 3)}),
        Utility.Create("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 1}),
    })
    
    -- RGB Input
    local rgbInput = Utility.Create("TextBox", {
        Name = "RGBInput",
        Parent = pickerContainer,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0, 0, 0, 95),
        Size = UDim2.new(1, -30, 0, 22),
        Font = Enum.Font.GothamMedium,
        PlaceholderText = "R, G, B",
        Text = string.format("%d, %d, %d", math.floor(colorpicker.Value.R * 255 + 0.5), math.floor(colorpicker.Value.G * 255 + 0.5), math.floor(colorpicker.Value.B * 255 + 0.5)),
        TextColor3 = Theme.TextPrimary,
        TextSize = 11,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
    })
    
    local h, s, v = Color3.toHSV(colorpicker.Value)
    
    local function updateColor()
        local newColor = Color3.fromHSV(h, s, v)
        colorpicker.Value = newColor
        colorPreview.BackgroundColor3 = newColor
        svPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        rgbInput.Text = string.format("%d, %d, %d", math.floor(newColor.R * 255 + 0.5), math.floor(newColor.G * 255 + 0.5), math.floor(newColor.B * 255 + 0.5))
        
        if flag then
            ConfigSystem:Set("colors", flag, {R = math.floor(newColor.R * 255 + 0.5), G = math.floor(newColor.G * 255 + 0.5), B = math.floor(newColor.B * 255 + 0.5)})
        end
        
        if callback then
            callback(newColor)
        end
    end
    
    -- SV Picker interaction
    local svDragging = false
    
    svPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if svDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - svPicker.AbsolutePosition.X) / svPicker.AbsoluteSize.X, 0, 1)
            local relativeY = math.clamp((input.Position.Y - svPicker.AbsolutePosition.Y) / svPicker.AbsoluteSize.Y, 0, 1)
            
            s = relativeX
            v = 1 - relativeY
            
            svCursor.Position = UDim2.new(relativeX, 0, relativeY, 0)
            updateColor()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = false
        end
    end)
    
    -- Hue Picker interaction
    local hueDragging = false
    
    huePicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeY = math.clamp((input.Position.Y - huePicker.AbsolutePosition.Y) / huePicker.AbsoluteSize.Y, 0, 1)
            
            h = relativeY
            hueCursor.Position = UDim2.new(0.5, 0, relativeY, 0)
            updateColor()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
        end
    end)
    
    -- RGB Input
    rgbInput.FocusLost:Connect(function()
        local parts = rgbInput.Text:split(",")
        if #parts == 3 then
            local r = tonumber(parts[1]:match("%d+")) or 0
            local g = tonumber(parts[2]:match("%d+")) or 0
            local b = tonumber(parts[3]:match("%d+")) or 0
            
            r = math.clamp(r, 0, 255) / 255
            g = math.clamp(g, 0, 255) / 255
            b = math.clamp(b, 0, 255) / 255
            
            h, s, v = Color3.toHSV(Color3.new(r, g, b))
            svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
            hueCursor.Position = UDim2.new(0.5, 0, h, 0)
            updateColor()
        end
    end)
    
    -- Toggle picker
    header.MouseButton1Click:Connect(function()
        colorpicker.Open = not colorpicker.Open
        
        if colorpicker.Open then
            Utility.Tween(container, {Size = UDim2.new(1, 0, 0, 175)}, 0.2)
        else
            Utility.Tween(container, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
        end
    end)
    
    function colorpicker:Set(color)
        colorpicker.Value = color
        h, s, v = Color3.toHSV(color)
        svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
        hueCursor.Position = UDim2.new(0.5, 0, h, 0)
        updateColor()
    end
    
    return colorpicker
end

-- ============================================
-- BUTTON
-- ============================================
function NovaUI:CreateButton(section, name, callback)
    local button = {
        Name = name,
        Callback = callback,
    }
    
    local container = Utility.Create("TextButton", {
        Name = name .. "Button",
        Parent = section.Content,
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(1, 0, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
    })
    
    container.MouseEnter:Connect(function()
        Utility.Tween(container, {BackgroundColor3 = Theme.AccentLight}, 0.2)
    end)
    
    container.MouseLeave:Connect(function()
        Utility.Tween(container, {BackgroundColor3 = Theme.Accent}, 0.2)
    end)
    
    container.MouseButton1Click:Connect(function()
        Utility.Ripple(container, Mouse.X, Mouse.Y)
        
        -- Press animation
        Utility.Tween(container, {Size = UDim2.new(1, -4, 0, 33)}, 0.1)
        task.delay(0.1, function()
            Utility.Tween(container, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
        end)
        
        if callback then
            callback()
        end
    end)
    
    return button
end

-- ============================================
-- LABEL
-- ============================================
function NovaUI:CreateLabel(section, text)
    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Parent = section.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = text,
        TextColor3 = Theme.TextMuted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    return label
end

-- ============================================
-- BUILD CONFIG (Auto Config Management Section)
-- ============================================
function NovaUI:BuildConfig(tab)
    local Window = self
    local configSection = self:CreateSection(tab, "Configuration")
    
    local selectedConfig = ConfigSystem.CurrentConfig
    local configList = ConfigSystem:GetAllConfigs()
    
    -- Config Name Input
    local configNameInput = ""
    local nameInput = self:CreateTextInput(configSection, "Config Name", "Enter config name...", "", function(value)
        configNameInput = value
    end)
    
    -- Config Dropdown
    local configDropdown
    configDropdown = self:CreateDropdown(configSection, "Select Config", configList, selectedConfig, function(value)
        selectedConfig = value
    end)
    
    -- Refresh function to update dropdown
    local function refreshConfigs()
        configList = ConfigSystem:GetAllConfigs()
        
        -- Rebuild dropdown options
        local optionsContainer = configDropdown.Container:FindFirstChild("Options", true)
        if optionsContainer then
            for _, child in ipairs(optionsContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            for _, option in ipairs(configList) do
                local optionBtn = Utility.Create("TextButton", {
                    Name = option,
                    Parent = optionsContainer,
                    BackgroundColor3 = Theme.Border,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28),
                    Font = Enum.Font.GothamMedium,
                    Text = option,
                    TextColor3 = option == selectedConfig and Theme.AccentLight or Theme.TextSecondary,
                    TextSize = 12,
                }, {
                    Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                })
                
                optionBtn.MouseEnter:Connect(function()
                    Utility.Tween(optionBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.TextPrimary}, 0.2)
                end)
                
                optionBtn.MouseLeave:Connect(function()
                    Utility.Tween(optionBtn, {BackgroundTransparency = 1, TextColor3 = option == selectedConfig and Theme.AccentLight or Theme.TextSecondary}, 0.2)
                end)
                
                optionBtn.MouseButton1Click:Connect(function()
                    selectedConfig = option
                    configDropdown.Value = option
                    
                    local header = configDropdown.Container:FindFirstChild("Header")
                    if header then
                        local selectedLabel = header:FindFirstChild("Selected")
                        if selectedLabel then
                            selectedLabel.Text = option
                        end
                    end
                    
                    for _, btn in ipairs(optionsContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.TextColor3 = btn.Name == option and Theme.AccentLight or Theme.TextSecondary
                        end
                    end
                    
                    configDropdown.Open = false
                    Utility.Tween(configDropdown.Container, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
                    local arrow = header:FindFirstChild("Arrow")
                    if arrow then
                        Utility.Tween(arrow, {Rotation = 0}, 0.2)
                    end
                end)
            end
            
            -- Update container size when opened
            local optionsCount = #configList
            configDropdown.Container:GetPropertyChangedSignal("Size"):Connect(function()
                -- Size is managed by the dropdown open/close
            end)
        end
        
        Window:Notify("Refreshed", "Config list refreshed!", "info", 2)
    end
    
    -- Create New Config Button
    self:CreateButton(configSection, "Create New Config", function()
        if configNameInput == "" or configNameInput:match("^%s*$") then
            Window:Notify("Error", "Please enter a config name!", "error", 3)
            return
        end
        
        -- Check if config already exists
        for _, cfg in ipairs(configList) do
            if cfg:lower() == configNameInput:lower() then
                Window:Notify("Error", "Config '" .. configNameInput .. "' already exists!", "error", 3)
                return
            end
        end
        
        -- Save current settings to new config
        ConfigSystem.CurrentConfig = configNameInput
        if ConfigSystem:Save(configNameInput) then
            selectedConfig = configNameInput
            Window:Notify("Success", "Config '" .. configNameInput .. "' created!", "success", 3)
            refreshConfigs()
            
            -- Update dropdown selection
            local header = configDropdown.Container:FindFirstChild("Header")
            if header then
                local selectedLabel = header:FindFirstChild("Selected")
                if selectedLabel then
                    selectedLabel.Text = configNameInput
                end
            end
        else
            Window:Notify("Error", "Failed to create config! (No file system access)", "error", 3)
        end
    end)
    
    -- Save Config Button
    self:CreateButton(configSection, "Save Config", function()
        local saveConfigName = selectedConfig
        
        -- If user typed a name, use that instead
        if configNameInput ~= "" and not configNameInput:match("^%s*$") then
            saveConfigName = configNameInput
        end
        
        ConfigSystem.CurrentConfig = saveConfigName
        if ConfigSystem:Save(saveConfigName) then
            selectedConfig = saveConfigName
            Window:Notify("Saved", "Config '" .. saveConfigName .. "' saved successfully!", "success", 3)
            refreshConfigs()
            
            -- Update dropdown selection
            local header = configDropdown.Container:FindFirstChild("Header")
            if header then
                local selectedLabel = header:FindFirstChild("Selected")
                if selectedLabel then
                    selectedLabel.Text = saveConfigName
                end
            end
        else
            Window:Notify("Error", "Failed to save config! (No file system access)", "error", 3)
        end
    end)
    
    -- Load Config Button
    self:CreateButton(configSection, "Load Config", function()
        if ConfigSystem:Load(selectedConfig) then
            Window:Notify("Loaded", "Config '" .. selectedConfig .. "' loaded! Refresh UI to apply all settings.", "success", 3)
            
            -- Update all flagged elements with loaded values
            for flag, element in pairs(Window.Flags) do
                if element.Set then
                    local category = nil
                    local value = nil
                    
                    -- Determine category based on element type
                    if ConfigSystem.Configs.toggles and ConfigSystem.Configs.toggles[flag] ~= nil then
                        value = ConfigSystem.Configs.toggles[flag]
                    elseif ConfigSystem.Configs.sliders and ConfigSystem.Configs.sliders[flag] ~= nil then
                        value = ConfigSystem.Configs.sliders[flag]
                    elseif ConfigSystem.Configs.dropdowns and ConfigSystem.Configs.dropdowns[flag] ~= nil then
                        value = ConfigSystem.Configs.dropdowns[flag]
                    elseif ConfigSystem.Configs.textinputs and ConfigSystem.Configs.textinputs[flag] ~= nil then
                        value = ConfigSystem.Configs.textinputs[flag]
                    elseif ConfigSystem.Configs.keybinds and ConfigSystem.Configs.keybinds[flag] ~= nil then
                        value = Enum.KeyCode[ConfigSystem.Configs.keybinds[flag]]
                    elseif ConfigSystem.Configs.colors and ConfigSystem.Configs.colors[flag] ~= nil then
                        local c = ConfigSystem.Configs.colors[flag]
                        value = Color3.fromRGB(c.R, c.G, c.B)
                    end
                    
                    if value ~= nil then
                        pcall(function()
                            element:Set(value)
                        end)
                    end
                end
            end
        else
            Window:Notify("Error", "Failed to load config '" .. selectedConfig .. "'!", "error", 3)
        end
    end)
    
    -- Refresh Configs Button
    self:CreateButton(configSection, "Refresh Configs", function()
        refreshConfigs()
    end)
    
    -- Delete Config Button
    self:CreateButton(configSection, "Delete Config", function()
        if selectedConfig == "default" then
            Window:Notify("Error", "Cannot delete the default config!", "error", 3)
            return
        end
        
        if ConfigSystem:Delete(selectedConfig) then
            Window:Notify("Deleted", "Config '" .. selectedConfig .. "' deleted!", "warning", 3)
            selectedConfig = "default"
            ConfigSystem.CurrentConfig = "default"
            refreshConfigs()
            
            -- Update dropdown selection
            local header = configDropdown.Container:FindFirstChild("Header")
            if header then
                local selectedLabel = header:FindFirstChild("Selected")
                if selectedLabel then
                    selectedLabel.Text = "default"
                end
            end
        else
            Window:Notify("Error", "Failed to delete config! (No file system access)", "error", 3)
        end
    end)
    
    -- Auto-load on start if config exists
    task.spawn(function()
        task.wait(0.5)
        if ConfigSystem:Load(selectedConfig) then
            -- Silently load, update elements
            for flag, element in pairs(Window.Flags) do
                if element.Set then
                    local value = nil
                    
                    if ConfigSystem.Configs.toggles and ConfigSystem.Configs.toggles[flag] ~= nil then
                        value = ConfigSystem.Configs.toggles[flag]
                    elseif ConfigSystem.Configs.sliders and ConfigSystem.Configs.sliders[flag] ~= nil then
                        value = ConfigSystem.Configs.sliders[flag]
                    elseif ConfigSystem.Configs.dropdowns and ConfigSystem.Configs.dropdowns[flag] ~= nil then
                        value = ConfigSystem.Configs.dropdowns[flag]
                    elseif ConfigSystem.Configs.textinputs and ConfigSystem.Configs.textinputs[flag] ~= nil then
                        value = ConfigSystem.Configs.textinputs[flag]
                    elseif ConfigSystem.Configs.keybinds and ConfigSystem.Configs.keybinds[flag] ~= nil then
                        value = Enum.KeyCode[ConfigSystem.Configs.keybinds[flag]]
                    elseif ConfigSystem.Configs.colors and ConfigSystem.Configs.colors[flag] ~= nil then
                        local c = ConfigSystem.Configs.colors[flag]
                        value = Color3.fromRGB(c.R, c.G, c.B)
                    end
                    
                    if value ~= nil then
                        pcall(function()
                            element:Set(value)
                        end)
                    end
                end
            end
        end
    end)
    
    return configSection
end

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
function NovaUI:Notify(title, message, notifType, duration)
    local colors = {
        success = Theme.Success,
        warning = Theme.Warning,
        error = Theme.Error,
        info = Theme.Accent,
    }
    
    local icons = {
        success = Icons.check,
        warning = Icons.warning,
        error = Icons.error,
        info = Icons.info,
    }
    
    local color = colors[notifType] or Theme.Accent
    local icon = icons[notifType] or Icons.info
    duration = duration or 3
    
    local notification = Utility.Create("Frame", {
        Name = "Notification",
        Parent = self.NotificationContainer,
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 70),
        ClipsDescendants = true,
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        Utility.Create("UIStroke", {Color = color, Thickness = 1, Transparency = 0.5}),
    })
    
    -- Accent bar
    local accentBar = Utility.Create("Frame", {
        Name = "AccentBar",
        Parent = notification,
        BackgroundColor3 = color,
        Size = UDim2.new(0, 4, 1, 0),
    })
    
    -- Icon
    local iconFrame = Utility.Create("Frame", {
        Name = "IconFrame",
        Parent = notification,
        BackgroundColor3 = color,
        BackgroundTransparency = 0.8,
        Position = UDim2.new(0, 15, 0.5, -15),
        Size = UDim2.new(0, 30, 0, 30),
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -8, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = icon,
            ImageColor3 = color,
        }),
    })
    
    -- Title
    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Parent = notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55, 0, 12),
        Size = UDim2.new(1, -70, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Message
    local messageLabel = Utility.Create("TextLabel", {
        Name = "Message",
        Parent = notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55, 0, 32),
        Size = UDim2.new(1, -70, 0, 30),
        Font = Enum.Font.GothamMedium,
        Text = message,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
    })
    
    -- Progress bar
    local progressBar = Utility.Create("Frame", {
        Name = "Progress",
        Parent = notification,
        BackgroundColor3 = color,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
    })
    
    -- Animations
    notification.Position = UDim2.new(1, 50, 0, 0)
    Utility.Tween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
    
    -- Progress animation
    Utility.Tween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration)
    
    task.delay(duration, function()
        Utility.Tween(notification, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function()
            notification:Destroy()
        end)
    end)
end

-- ============================================
-- DESTROY
-- ============================================
function NovaUI:Destroy()
    -- Save config before closing
    ConfigSystem:Save()
    
    -- Closing animation
    Utility.Tween(self.MainFrame, {Size = UDim2.new(0, 600, 0, 0), BackgroundTransparency = 1}, 0.3)
    
    if self.MobileToggle then
        Utility.Tween(self.MobileToggle, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
    end
    
    task.delay(0.3, function()
        self.ScreenGui:Destroy()
    end)
end

-- ============================================
-- EXPORT ICONS FOR EXTERNAL USE
-- ============================================
NovaUI.Icons = Icons
NovaUI.Theme = Theme
NovaUI.Utility = Utility
NovaUI.ConfigSystem = ConfigSystem

return NovaUI
