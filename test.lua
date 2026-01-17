
local VoidUI = {}
VoidUI.__index = VoidUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Mobile Detection
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local IS_MOBILE = IsMobile()
local SCALE_FACTOR = IS_MOBILE and 0.7 or 1

-- Theme
local Theme = {
    Background = Color3.fromRGB(12, 12, 14),
    Surface = Color3.fromRGB(18, 18, 22),
    SurfaceHover = Color3.fromRGB(24, 24, 30),
    Border = Color3.fromRGB(32, 32, 40),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentDark = Color3.fromRGB(108, 33, 186),
    AccentGlow = Color3.fromRGB(158, 63, 246),
    TextPrimary = Color3.fromRGB(245, 245, 250),
    TextSecondary = Color3.fromRGB(140, 140, 160),
    TextMuted = Color3.fromRGB(80, 80, 100),
    Success = Color3.fromRGB(46, 204, 113),
    Error = Color3.fromRGB(231, 76, 60),
    AnimationSpeed = 0.2,
    EasingStyle = Enum.EasingStyle.Quart,
    Font = Enum.Font.GothamBold,
    FontMedium = Enum.Font.GothamMedium,
    FontRegular = Enum.Font.Gotham,
    CornerRadius = UDim.new(0, 8),
    CornerRadiusSmall = UDim.new(0, 4),
    CornerRadiusLarge = UDim.new(0, 12),
    ElementHeight = 36,
}


-- Utilities
local function Scale(v) return math.floor(v * SCALE_FACTOR) end

local function Tween(obj, props, dur, style)
    local ti = TweenInfo.new(dur or Theme.AnimationSpeed, style or Theme.EasingStyle, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, ti, props)
    t:Play()
    return t
end

local function CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or Theme.CornerRadius
    c.Parent = parent
    return c
end

local function CreateStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function CreatePadding(parent, padding)
    local p = Instance.new("UIPadding")
    local val = padding or 12
    p.PaddingTop = UDim.new(0, val)
    p.PaddingBottom = UDim.new(0, val)
    p.PaddingLeft = UDim.new(0, val)
    p.PaddingRight = UDim.new(0, val)
    p.Parent = parent
    return p
end

local function Ripple(btn)
    local r = Instance.new("Frame")
    r.BackgroundColor3 = Theme.Accent
    r.BackgroundTransparency = 0.7
    r.BorderSizePixel = 0
    r.ZIndex = btn.ZIndex + 1
    r.AnchorPoint = Vector2.new(0.5, 0.5)
    local mouse = UserInputService:GetMouseLocation()
    local rel = mouse - btn.AbsolutePosition
    r.Position = UDim2.new(0, rel.X, 0, rel.Y - 36)
    r.Size = UDim2.new(0, 0, 0, 0)
    CreateCorner(r, UDim.new(1, 0))
    r.Parent = btn
    local maxSize = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
    Tween(r, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.4)
    task.delay(0.4, function() r:Destroy() end)
end

-- File System
local FS = {}
function FS.Ok() return isfolder and isfile and writefile and readfile and makefolder and listfiles end
function FS.EnsureFolder(p) if FS.Ok() and not isfolder(p) then makefolder(p) end end
function FS.Write(p, c) if FS.Ok() then writefile(p, c) return true end return false end
function FS.Read(p) if FS.Ok() and isfile(p) then return readfile(p) end return nil end
function FS.List(f) if FS.Ok() and isfolder(f) then return listfiles(f) end return {} end

-- Main Library
function VoidUI:CreateWindow(config)
    config = config or {}
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Flags = {}
    Window.ConfigFolder = config.ConfigFolder or "VoidUI"
    Window.ConfigPath = Window.ConfigFolder .. "/configs"
    
    FS.EnsureFolder(Window.ConfigFolder)
    FS.EnsureFolder(Window.ConfigPath)
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VoidUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
    if not screenGui.Parent then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    
    local baseW = config.Size and config.Size.X.Offset or 520
    local baseH = config.Size and config.Size.Y.Offset or 380
    local scaledSize = UDim2.new(0, Scale(baseW), 0, Scale(baseH))
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Size = scaledSize
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    CreateCorner(mainFrame, Theme.CornerRadiusSmall)
    CreateStroke(mainFrame, Theme.Border, 1)
    
    local shadow = Instance.new("ImageLabel")
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, Scale(44))
    titleBar.Parent = mainFrame
    CreateCorner(titleBar, Theme.CornerRadiusSmall)
    
    local titleBarFix = Instance.new("Frame")
    titleBarFix.BackgroundColor3 = Theme.Surface
    titleBarFix.BorderSizePixel = 0
    titleBarFix.Size = UDim2.new(1, 0, 0, 12)
    titleBarFix.Position = UDim2.new(0, 0, 1, -12)
    titleBarFix.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, Scale(16), 0, 0)
    titleText.Font = Theme.Font
    titleText.Text = config.Title or "VOID UI"
    titleText.TextColor3 = Theme.TextPrimary
    titleText.TextSize = Scale(14)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local accentLine = Instance.new("Frame")
    accentLine.BackgroundColor3 = Theme.Accent
    accentLine.BorderSizePixel = 0
    accentLine.Size = UDim2.new(0, Scale(40), 0, 2)
    accentLine.Position = UDim2.new(0, Scale(16), 1, -2)
    accentLine.Parent = titleBar
    CreateCorner(accentLine, UDim.new(1, 0))
    
    local controls = Instance.new("Frame")
    controls.BackgroundTransparency = 1
    controls.Size = UDim2.new(0, Scale(80), 0, Scale(44))
    controls.Position = UDim2.new(1, Scale(-80), 0, 0)
    controls.Parent = titleBar
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.BackgroundColor3 = Theme.SurfaceHover
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Size = UDim2.new(0, Scale(32), 0, Scale(32))
    minimizeBtn.Position = UDim2.new(0, Scale(5), 0.5, Scale(-16))
    minimizeBtn.Font = Theme.Font
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Theme.TextSecondary
    minimizeBtn.TextSize = Scale(20)
    minimizeBtn.Parent = controls
    CreateCorner(minimizeBtn, Theme.CornerRadiusSmall)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundColor3 = Theme.Error
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel = 0
    closeBtn.Size = UDim2.new(0, Scale(32), 0, Scale(32))
    closeBtn.Position = UDim2.new(0, Scale(42), 0.5, Scale(-16))
    closeBtn.Font = Theme.Font
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.TextSize = Scale(20)
    closeBtn.Parent = controls
    CreateCorner(closeBtn, Theme.CornerRadiusSmall)
    
    minimizeBtn.MouseEnter:Connect(function() Tween(minimizeBtn, {BackgroundTransparency = 0.5}, 0.15) end)
    minimizeBtn.MouseLeave:Connect(function() Tween(minimizeBtn, {BackgroundTransparency = 1}, 0.15) end)
    closeBtn.MouseEnter:Connect(function() Tween(closeBtn, {BackgroundTransparency = 0.3, TextColor3 = Theme.TextPrimary}, 0.15) end)
    closeBtn.MouseLeave:Connect(function() Tween(closeBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextSecondary}, 0.15) end)
    
    local tabContainer = Instance.new("Frame")
    tabContainer.BackgroundColor3 = Theme.Surface
    tabContainer.BorderSizePixel = 0
    tabContainer.Size = UDim2.new(0, Scale(140), 1, Scale(-54))
    tabContainer.Position = UDim2.new(0, 0, 0, Scale(48))
    tabContainer.Parent = mainFrame
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, Scale(4))
    tabList.Parent = tabContainer
    CreatePadding(tabContainer, Scale(8))
    
    local contentContainer = Instance.new("Frame")
    contentContainer.BackgroundTransparency = 1
    contentContainer.Size = UDim2.new(1, Scale(-148), 1, Scale(-54))
    contentContainer.Position = UDim2.new(0, Scale(144), 0, Scale(48))
    contentContainer.ClipsDescendants = true
    contentContainer.Parent = mainFrame
    
    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local isOpen, isVisible = true, true
    local originalSize = scaledSize
    
    minimizeBtn.MouseButton1Click:Connect(function()
        if isOpen then
            Tween(mainFrame, {Size = UDim2.new(0, originalSize.X.Offset, 0, Scale(44))}, 0.25)
        else
            Tween(mainFrame, {Size = originalSize}, 0.25)
        end
        isOpen = not isOpen
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Window:Toggle(false)
    end)
    
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    Tween(mainFrame, {Size = originalSize, BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Back)
    
    -- Mobile Toggle Button
    local mobileToggle = nil
    if IS_MOBILE then
        mobileToggle = Instance.new("ImageButton")
        mobileToggle.Name = "MobileToggle"
        mobileToggle.BackgroundColor3 = Theme.Accent
        mobileToggle.Size = UDim2.new(0, 50, 0, 50)
        mobileToggle.Position = UDim2.new(0, 15, 0.5, -25)
        mobileToggle.Image = "rbxassetid://114439996739424"
        mobileToggle.ImageColor3 = Theme.TextPrimary
        mobileToggle.ScaleType = Enum.ScaleType.Fit
        mobileToggle.Parent = screenGui
        CreateCorner(mobileToggle, UDim.new(0, 25))
        
        local mobileShadow = Instance.new("ImageLabel")
        mobileShadow.BackgroundTransparency = 1
        mobileShadow.Image = "rbxassetid://5554236805"
        mobileShadow.ImageColor3 = Color3.new(0, 0, 0)
        mobileShadow.ImageTransparency = 0.7
        mobileShadow.ScaleType = Enum.ScaleType.Slice
        mobileShadow.SliceCenter = Rect.new(23, 23, 277, 277)
        mobileShadow.Size = UDim2.new(1, 20, 1, 20)
        mobileShadow.Position = UDim2.new(0, -10, 0, -10)
        mobileShadow.ZIndex = -1
        mobileShadow.Parent = mobileToggle
        
        local mobileDragging, mobileDragStart, mobileStartPos = false, nil, nil
        mobileToggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                mobileDragging = true
                mobileDragStart = input.Position
                mobileStartPos = mobileToggle.Position
            end
        end)
        mobileToggle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                if mobileDragging then
                    local delta = input.Position - mobileDragStart
                    if delta.Magnitude < 10 then
                        Window:Toggle(not isVisible)
                    end
                end
                mobileDragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if mobileDragging and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - mobileDragStart
                if delta.Magnitude > 10 then
                    mobileToggle.Position = UDim2.new(mobileStartPos.X.Scale, mobileStartPos.X.Offset + delta.X, mobileStartPos.Y.Scale, mobileStartPos.Y.Offset + delta.Y)
                end
            end
        end)
    end
    
    -- CreateTab
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local Tab = {}
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabConfig.Name or "Tab"
        tabBtn.BackgroundColor3 = Theme.SurfaceHover
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Size = UDim2.new(1, 0, 0, Scale(38))
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabContainer
        CreateCorner(tabBtn, Theme.CornerRadiusSmall)
        
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.BackgroundTransparency = 1
        tabIcon.Size = UDim2.new(0, Scale(18), 0, Scale(18))
        tabIcon.Position = UDim2.new(0, Scale(10), 0.5, Scale(-9))
        tabIcon.Image = tabConfig.Icon or ""
        tabIcon.ImageColor3 = Theme.TextSecondary
        tabIcon.Parent = tabBtn
        
        local tabLabel = Instance.new("TextLabel")
        tabLabel.BackgroundTransparency = 1
        tabLabel.Size = UDim2.new(1, Scale(-40), 1, 0)
        tabLabel.Position = UDim2.new(0, Scale(34), 0, 0)
        tabLabel.Font = Theme.FontMedium
        tabLabel.Text = tabConfig.Name or "Tab"
        tabLabel.TextColor3 = Theme.TextSecondary
        tabLabel.TextSize = Scale(12)
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn
        
        local tabIndicator = Instance.new("Frame")
        tabIndicator.BackgroundColor3 = Theme.Accent
        tabIndicator.BorderSizePixel = 0
        tabIndicator.Size = UDim2.new(0, 4, 0, 0)
        tabIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        tabIndicator.AnchorPoint = Vector2.new(0, 0.5)
        tabIndicator.Parent = tabBtn
        CreateCorner(tabIndicator, UDim.new(1, 0))
        
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = tabConfig.Name or "TabContent"
        contentFrame.BackgroundTransparency = 1
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollBarThickness = 3
        contentFrame.ScrollBarImageColor3 = Theme.Accent
        contentFrame.Visible = false
        contentFrame.Parent = contentContainer
        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, Scale(8))
        contentList.Parent = contentFrame
        CreatePadding(contentFrame, Scale(6))
        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + Scale(20))
        end)
        
        local function SelectTab()
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundTransparency = 1}, 0.15)
                Tween(tab.Label, {TextColor3 = Theme.TextSecondary}, 0.15)
                Tween(tab.Icon, {ImageColor3 = Theme.TextSecondary}, 0.15)
                Tween(tab.Indicator, {Size = UDim2.new(0, 4, 0, 0)}, 0.15)
                tab.Content.Visible = false
            end
            Tween(tabBtn, {BackgroundTransparency = 0.7}, 0.15)
            Tween(tabLabel, {TextColor3 = Theme.TextPrimary}, 0.15)
            Tween(tabIcon, {ImageColor3 = Theme.Accent}, 0.15)
            Tween(tabIndicator, {Size = UDim2.new(0, 4, 0, Scale(22))}, 0.2, Enum.EasingStyle.Back)
            contentFrame.Visible = true
            Window.ActiveTab = Tab
        end
        
        tabBtn.MouseButton1Click:Connect(SelectTab)
        tabBtn.MouseEnter:Connect(function() if Window.ActiveTab ~= Tab then Tween(tabBtn, {BackgroundTransparency = 0.85}, 0.1) end end)
        tabBtn.MouseLeave:Connect(function() if Window.ActiveTab ~= Tab then Tween(tabBtn, {BackgroundTransparency = 1}, 0.1) end end)
        
        Tab.Button = tabBtn
        Tab.Label = tabLabel
        Tab.Icon = tabIcon
        Tab.Indicator = tabIndicator
        Tab.Content = contentFrame
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then SelectTab() end
        
        -- Toggle (More Rounded)
        function Tab:CreateToggle(cfg)
            cfg = cfg or {}
            local value = cfg.Default or false
            local container = Instance.new("Frame")
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))
            container.Parent = contentFrame
            CreateCorner(container, Theme.CornerRadius)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, Scale(-70), 1, 0)
            label.Position = UDim2.new(0, Scale(14), 0, 0)
            label.Font = Theme.FontMedium
            label.Text = cfg.Name or "Toggle"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = Scale(12)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.BackgroundColor3 = Theme.Background
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(0, Scale(46), 0, Scale(26))
            toggleFrame.Position = UDim2.new(1, Scale(-58), 0.5, Scale(-13))
            toggleFrame.Parent = container
            CreateCorner(toggleFrame, UDim.new(1, 0))
            CreateStroke(toggleFrame, Theme.Border, 1)
            
            local toggleKnob = Instance.new("Frame")
            toggleKnob.BackgroundColor3 = Theme.TextMuted
            toggleKnob.BorderSizePixel = 0
            toggleKnob.Size = UDim2.new(0, Scale(20), 0, Scale(20))
            toggleKnob.Position = UDim2.new(0, Scale(3), 0.5, Scale(-10))
            toggleKnob.Parent = toggleFrame
            CreateCorner(toggleKnob, UDim.new(1, 0))
            
            local function Update()
                if value then
                    Tween(toggleKnob, {Position = UDim2.new(0, Scale(23), 0.5, Scale(-10)), BackgroundColor3 = Theme.TextPrimary}, 0.2, Enum.EasingStyle.Back)
                    Tween(toggleFrame, {BackgroundColor3 = Theme.Accent}, 0.2)
                else
                    Tween(toggleKnob, {Position = UDim2.new(0, Scale(3), 0.5, Scale(-10)), BackgroundColor3 = Theme.TextMuted}, 0.2, Enum.EasingStyle.Back)
                    Tween(toggleFrame, {BackgroundColor3 = Theme.Background}, 0.2)
                end
            end
            Update()
            
            local clickBtn = Instance.new("TextButton")
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.Text = ""
            clickBtn.Parent = container
            clickBtn.MouseButton1Click:Connect(function()
                value = not value
                Update()
                if cfg.Callback then cfg.Callback(value) end
            end)
            
            container.MouseEnter:Connect(function() Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1) end)
            container.MouseLeave:Connect(function() Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1) end)
            
            local Toggle = {}
            function Toggle:Set(v) value = v Update() end
            function Toggle:Get() return value end
            if cfg.Flag then Window.Flags[cfg.Flag] = Toggle end
            return Toggle
        end
        
        -- Slider (More Rounded)
        function Tab:CreateSlider(cfg)
            cfg = cfg or {}
            local min, max = cfg.Min or 0, cfg.Max or 100
            local increment = cfg.Increment or 0.1
            local value = cfg.Default or min
            local container = Instance.new("Frame")
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Scale(48))
            container.Parent = contentFrame
            CreateCorner(container, Theme.CornerRadius)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, Scale(-60), 0, Scale(20))
            label.Position = UDim2.new(0, Scale(12), 0, Scale(6))
            label.Font = Theme.FontRegular
            label.Text = cfg.Name or "Slider"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = Scale(11)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.BackgroundTransparency = 1
            valueLabel.Size = UDim2.new(0, Scale(50), 0, Scale(20))
            valueLabel.Position = UDim2.new(1, Scale(-58), 0, Scale(6))
            valueLabel.Font = Theme.FontRegular
            valueLabel.Text = string.format("%.1f", value)
            valueLabel.TextColor3 = Theme.Accent
            valueLabel.TextSize = Scale(11)
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = container
            
            local track = Instance.new("Frame")
            track.BackgroundColor3 = Theme.Background
            track.BorderSizePixel = 0
            track.Size = UDim2.new(1, Scale(-24), 0, Scale(4))
            track.Position = UDim2.new(0, Scale(12), 1, Scale(-16))
            track.Parent = container
            CreateCorner(track, UDim.new(1, 0))
            
            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = Theme.Accent
            fill.BorderSizePixel = 0
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            fill.Parent = track
            CreateCorner(fill, UDim.new(1, 0))
            
            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = Theme.TextPrimary
            knob.BorderSizePixel = 0
            knob.Size = UDim2.new(0, Scale(12), 0, Scale(12))
            knob.Position = UDim2.new((value - min) / (max - min), Scale(-6), 0.5, Scale(-6))
            knob.Parent = track
            CreateCorner(knob, UDim.new(1, 0))
            
            local draggingSlider = false
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local rawValue = min + (max - min) * pos
                value = math.floor(rawValue / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                local displayPos = (value - min) / (max - min)
                fill.Size = UDim2.new(displayPos, 0, 1, 0)
                knob.Position = UDim2.new(displayPos, Scale(-6), 0.5, Scale(-6))
                valueLabel.Text = string.format("%.1f", value)
                if cfg.Callback then cfg.Callback(value) end
            end
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    UpdateSlider(input)
                end
            end)
            track.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            container.MouseEnter:Connect(function() Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1) end)
            container.MouseLeave:Connect(function() Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1) end)
            
            local Slider = {}
            function Slider:Set(v)
                value = math.clamp(v, min, max)
                local pos = (value - min) / (max - min)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                knob.Position = UDim2.new(pos, Scale(-6), 0.5, Scale(-6))
                valueLabel.Text = string.format("%.1f", value)
            end
            function Slider:Get() return value end
            if cfg.Flag then Window.Flags[cfg.Flag] = Slider end
            return Slider
        end
        
        -- Dropdown
        function Tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local options = cfg.Options or {}
            local selected = cfg.Default or (options[1] or "Select...")
            local isDropdownOpen = false
            
            local container = Instance.new("Frame")
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))
            container.ClipsDescendants = true
            container.Parent = contentFrame
            CreateCorner(container, Theme.CornerRadius)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(0.5, Scale(-12), 0, Scale(Theme.ElementHeight))
            label.Position = UDim2.new(0, Scale(14), 0, 0)
            label.Font = Theme.FontMedium
            label.Text = cfg.Name or "Dropdown"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = Scale(12)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local selectedLabel = Instance.new("TextLabel")
            selectedLabel.BackgroundTransparency = 1
            selectedLabel.Size = UDim2.new(0.5, Scale(-30), 0, Scale(Theme.ElementHeight))
            selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            selectedLabel.Font = Theme.FontMedium
            selectedLabel.Text = selected
            selectedLabel.TextColor3 = Theme.Accent
            selectedLabel.TextSize = Scale(12)
            selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            selectedLabel.Parent = container
            
            local arrow = Instance.new("TextLabel")
            arrow.BackgroundTransparency = 1
            arrow.Size = UDim2.new(0, Scale(20), 0, Scale(Theme.ElementHeight))
            arrow.Position = UDim2.new(1, Scale(-24), 0, 0)
            arrow.Font = Theme.Font
            arrow.Text = "▼"
            arrow.TextColor3 = Theme.TextSecondary
            arrow.TextSize = Scale(10)
            arrow.Parent = container
            
            local optionContainer = Instance.new("Frame")
            optionContainer.BackgroundTransparency = 1
            optionContainer.Size = UDim2.new(1, 0, 0, #options * Scale(30))
            optionContainer.Position = UDim2.new(0, 0, 0, Scale(Theme.ElementHeight + 4))
            optionContainer.Parent = container
            local optionList = Instance.new("UIListLayout")
            optionList.SortOrder = Enum.SortOrder.LayoutOrder
            optionList.Padding = UDim.new(0, Scale(2))
            optionList.Parent = optionContainer
            
            local function BuildOptions()
                for _, child in pairs(optionContainer:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, option in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.BackgroundColor3 = Theme.Background
                    optBtn.BackgroundTransparency = 1
                    optBtn.BorderSizePixel = 0
                    optBtn.Size = UDim2.new(1, Scale(-16), 0, Scale(28))
                    optBtn.Font = Theme.FontRegular
                    optBtn.Text = option
                    optBtn.TextColor3 = Theme.TextSecondary
                    optBtn.TextSize = Scale(11)
                    optBtn.Parent = optionContainer
                    CreateCorner(optBtn, Theme.CornerRadiusSmall)
                    optBtn.MouseEnter:Connect(function() Tween(optBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.TextPrimary}, 0.1) end)
                    optBtn.MouseLeave:Connect(function() Tween(optBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextSecondary}, 0.1) end)
                    optBtn.MouseButton1Click:Connect(function()
                        selected = option
                        selectedLabel.Text = option
                        isDropdownOpen = false
                        Tween(container, {Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))}, 0.2)
                        Tween(arrow, {Rotation = 0}, 0.2)
                        if cfg.Callback then cfg.Callback(option) end
                    end)
                end
                optionContainer.Size = UDim2.new(1, 0, 0, #options * Scale(30))
            end
            BuildOptions()
            
            local clickBtn = Instance.new("TextButton")
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))
            clickBtn.Text = ""
            clickBtn.Parent = container
            clickBtn.MouseButton1Click:Connect(function()
                isDropdownOpen = not isDropdownOpen
                if isDropdownOpen then
                    Tween(container, {Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight + 8) + #options * Scale(30))}, 0.25, Enum.EasingStyle.Back)
                    Tween(arrow, {Rotation = 180}, 0.2)
                else
                    Tween(container, {Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))}, 0.2)
                    Tween(arrow, {Rotation = 0}, 0.2)
                end
            end)
            
            container.MouseEnter:Connect(function() Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1) end)
            container.MouseLeave:Connect(function() Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1) end)
            
            local Dropdown = {}
            function Dropdown:Set(v) selected = v selectedLabel.Text = v end
            function Dropdown:Get() return selected end
            function Dropdown:Refresh(newOptions)
                options = newOptions
                BuildOptions()
                if isDropdownOpen then
                    container.Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight + 8) + #options * Scale(30))
                end
            end
            if cfg.Flag then Window.Flags[cfg.Flag] = Dropdown end
            return Dropdown
        end
        
        -- Input
        function Tab:CreateInput(cfg)
            cfg = cfg or {}
            local container = Instance.new("Frame")
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Scale(58))
            container.Parent = contentFrame
            CreateCorner(container, Theme.CornerRadius)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, Scale(-24), 0, Scale(20))
            label.Position = UDim2.new(0, Scale(14), 0, Scale(6))
            label.Font = Theme.FontMedium
            label.Text = cfg.Name or "Input"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = Scale(12)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local inputFrame = Instance.new("Frame")
            inputFrame.BackgroundColor3 = Theme.Background
            inputFrame.BorderSizePixel = 0
            inputFrame.Size = UDim2.new(1, Scale(-28), 0, Scale(26))
            inputFrame.Position = UDim2.new(0, Scale(14), 0, Scale(28))
            inputFrame.Parent = container
            CreateCorner(inputFrame, UDim.new(1, 0))
            local inputStroke = CreateStroke(inputFrame, Theme.Border, 1)
            
            local textBox = Instance.new("TextBox")
            textBox.BackgroundTransparency = 1
            textBox.Size = UDim2.new(1, Scale(-14), 1, 0)
            textBox.Position = UDim2.new(0, Scale(10), 0, 0)
            textBox.Font = Theme.FontRegular
            textBox.Text = cfg.Default or ""
            textBox.PlaceholderText = cfg.Placeholder or "Enter text..."
            textBox.PlaceholderColor3 = Theme.TextMuted
            textBox.TextColor3 = Theme.TextPrimary
            textBox.TextSize = Scale(11)
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.ClearTextOnFocus = false
            textBox.Parent = inputFrame
            
            textBox.Focused:Connect(function() Tween(inputStroke, {Color = Theme.Accent}, 0.15) end)
            textBox.FocusLost:Connect(function(enter)
                Tween(inputStroke, {Color = Theme.Border}, 0.15)
                if cfg.Callback then cfg.Callback(textBox.Text, enter) end
            end)
            
            container.MouseEnter:Connect(function() Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1) end)
            container.MouseLeave:Connect(function() Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1) end)
            
            local Input = {}
            function Input:Set(t) textBox.Text = t end
            function Input:Get() return textBox.Text end
            if cfg.Flag then Window.Flags[cfg.Flag] = Input end
            return Input
        end
        
        -- Button
        function Tab:CreateButton(cfg)
            cfg = cfg or {}
            local btn = Instance.new("TextButton")
            btn.BackgroundColor3 = Theme.Accent
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))
            btn.Font = Theme.FontMedium
            btn.Text = cfg.Name or "Button"
            btn.TextColor3 = Theme.TextPrimary
            btn.TextSize = Scale(12)
            btn.AutoButtonColor = false
            btn.ClipsDescendants = true
            btn.Parent = contentFrame
            CreateCorner(btn, Theme.CornerRadius)
            btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Theme.AccentGlow}, 0.15) end)
            btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15) end)
            btn.MouseButton1Click:Connect(function() Ripple(btn) if cfg.Callback then cfg.Callback() end end)
            return btn
        end
        
        -- ColorPicker
        function Tab:CreateColorPicker(cfg)
            cfg = cfg or {}
            local currentColor = cfg.Default or Color3.fromRGB(138, 43, 226)
            local isColorOpen = false
            
            local container = Instance.new("Frame")
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))
            container.ClipsDescendants = true
            container.Parent = contentFrame
            CreateCorner(container, Theme.CornerRadius)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, Scale(-60), 0, Scale(Theme.ElementHeight))
            label.Position = UDim2.new(0, Scale(14), 0, 0)
            label.Font = Theme.FontMedium
            label.Text = cfg.Name or "Color"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = Scale(12)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local colorPreview = Instance.new("Frame")
            colorPreview.BackgroundColor3 = currentColor
            colorPreview.BorderSizePixel = 0
            colorPreview.Size = UDim2.new(0, Scale(26), 0, Scale(26))
            colorPreview.Position = UDim2.new(1, Scale(-40), 0.5, Scale(-13))
            colorPreview.Parent = container
            CreateCorner(colorPreview, Theme.CornerRadiusSmall)
            CreateStroke(colorPreview, Theme.Border, 1)
            
            local pickerPanel = Instance.new("Frame")
            pickerPanel.BackgroundTransparency = 1
            pickerPanel.Size = UDim2.new(1, Scale(-28), 0, Scale(120))
            pickerPanel.Position = UDim2.new(0, Scale(14), 0, Scale(Theme.ElementHeight + 8))
            pickerPanel.Parent = container
            
            local svPicker = Instance.new("ImageLabel")
            svPicker.BackgroundColor3 = currentColor
            svPicker.BorderSizePixel = 0
            svPicker.Size = UDim2.new(1, Scale(-32), 1, 0)
            svPicker.Image = "rbxassetid://4155801252"
            svPicker.Parent = pickerPanel
            CreateCorner(svPicker, Theme.CornerRadiusSmall)
            
            local svCursor = Instance.new("Frame")
            svCursor.BackgroundColor3 = Color3.new(1, 1, 1)
            svCursor.BorderSizePixel = 0
            svCursor.Size = UDim2.new(0, Scale(12), 0, Scale(12))
            svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
            svCursor.Position = UDim2.new(1, 0, 0, 0)
            svCursor.Parent = svPicker
            CreateCorner(svCursor, UDim.new(1, 0))
            CreateStroke(svCursor, Color3.new(0, 0, 0), 2)
            
            local hueSlider = Instance.new("Frame")
            hueSlider.BorderSizePixel = 0
            hueSlider.Size = UDim2.new(0, Scale(22), 1, 0)
            hueSlider.Position = UDim2.new(1, Scale(-22), 0, 0)
            hueSlider.Parent = pickerPanel
            CreateCorner(hueSlider, UDim.new(1, 0))
            
            local hueGradient = Instance.new("UIGradient")
            hueGradient.Rotation = 90
            hueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
            hueGradient.Parent = hueSlider
            
            local hueCursor = Instance.new("Frame")
            hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
            hueCursor.BorderSizePixel = 0
            hueCursor.Size = UDim2.new(1, 6, 0, Scale(8))
            hueCursor.Position = UDim2.new(0, -3, 0, 0)
            hueCursor.Parent = hueSlider
            CreateCorner(hueCursor, UDim.new(1, 0))
            CreateStroke(hueCursor, Color3.new(0, 0, 0), 1)
            
            local h, s, v = currentColor:ToHSV()
            
            local function UpdateColor()
                currentColor = Color3.fromHSV(h, s, v)
                colorPreview.BackgroundColor3 = currentColor
                svPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                hueCursor.Position = UDim2.new(0, -3, h, Scale(-4))
                if cfg.Callback then cfg.Callback(currentColor) end
            end
            UpdateColor()
            
            local svDragging, hueDragging = false, false
            
            svPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = true
                end
            end)
            svPicker.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = false
                end
            end)
            
            hueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                end
            end)
            hueSlider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    if svDragging then
                        local relX = math.clamp((input.Position.X - svPicker.AbsolutePosition.X) / svPicker.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - svPicker.AbsolutePosition.Y) / svPicker.AbsoluteSize.Y, 0, 1)
                        s, v = relX, 1 - relY
                        UpdateColor()
                    elseif hueDragging then
                        h = math.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end
            end)
            
            local clickBtn = Instance.new("TextButton")
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))
            clickBtn.Text = ""
            clickBtn.Parent = container
            clickBtn.MouseButton1Click:Connect(function()
                isColorOpen = not isColorOpen
                if isColorOpen then
                    Tween(container, {Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight + 136))}, 0.25, Enum.EasingStyle.Back)
                else
                    Tween(container, {Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))}, 0.2)
                end
            end)
            
            container.MouseEnter:Connect(function() Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1) end)
            container.MouseLeave:Connect(function() Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1) end)
            
            local ColorPicker = {}
            function ColorPicker:Set(color)
                currentColor = color
                h, s, v = color:ToHSV()
                UpdateColor()
            end
            function ColorPicker:Get() return currentColor end
            if cfg.Flag then Window.Flags[cfg.Flag] = ColorPicker end
            return ColorPicker
        end
        
        -- Keybind
        function Tab:CreateKeybind(cfg)
            cfg = cfg or {}
            local currentKey = cfg.Default or Enum.KeyCode.Unknown
            local listening = false
            
            local container = Instance.new("Frame")
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Scale(Theme.ElementHeight))
            container.Parent = contentFrame
            CreateCorner(container, Theme.CornerRadius)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, Scale(-80), 1, 0)
            label.Position = UDim2.new(0, Scale(14), 0, 0)
            label.Font = Theme.FontMedium
            label.Text = cfg.Name or "Keybind"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = Scale(12)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.BackgroundColor3 = Theme.Background
            keyBtn.BorderSizePixel = 0
            keyBtn.Size = UDim2.new(0, Scale(60), 0, Scale(26))
            keyBtn.Position = UDim2.new(1, Scale(-72), 0.5, Scale(-13))
            keyBtn.Font = Theme.FontMedium
            keyBtn.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
            keyBtn.TextColor3 = Theme.Accent
            keyBtn.TextSize = Scale(11)
            keyBtn.AutoButtonColor = false
            keyBtn.Parent = container
            CreateCorner(keyBtn, UDim.new(1, 0))
            CreateStroke(keyBtn, Theme.Border, 1)
            
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, {BackgroundColor3 = Theme.AccentDark}, 0.15)
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    keyBtn.Text = currentKey.Name
                    Tween(keyBtn, {BackgroundColor3 = Theme.Background}, 0.15)
                    if cfg.Callback then cfg.Callback(currentKey) end
                elseif not listening and input.KeyCode == currentKey then
                    if cfg.OnPress then cfg.OnPress() end
                end
            end)
            
            container.MouseEnter:Connect(function() Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1) end)
            container.MouseLeave:Connect(function() Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1) end)
            
            local Keybind = {}
            function Keybind:Set(key) currentKey = key keyBtn.Text = key.Name end
            function Keybind:Get() return currentKey end
            if cfg.Flag then Window.Flags[cfg.Flag] = Keybind end
            return Keybind
        end
        
        -- Section
        function Tab:CreateSection(title)
            local section = Instance.new("Frame")
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(1, 0, 0, Scale(28))
            section.Parent = contentFrame
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Size = UDim2.new(1, 0, 0, Scale(20))
            sectionLabel.Position = UDim2.new(0, 0, 0, Scale(8))
            sectionLabel.Font = Theme.Font
            sectionLabel.Text = string.upper(title or "SECTION")
            sectionLabel.TextColor3 = Theme.Accent
            sectionLabel.TextSize = Scale(10)
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = section
            local line = Instance.new("Frame")
            line.BackgroundColor3 = Theme.Border
            line.BorderSizePixel = 0
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 1, -1)
            line.Parent = section
            return section
        end
        
        -- Label
        function Tab:CreateLabel(text)
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0, Scale(24))
            label.Font = Theme.FontMedium
            label.Text = text or "Label"
            label.TextColor3 = Theme.TextSecondary
            label.TextSize = Scale(11)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = contentFrame
            local Label = {}
            function Label:Set(t) label.Text = t end
            return Label
        end
        
        return Tab
    end
    
    -- Config System
    function Window:SaveConfig(name)
        if not FS.Ok() then
            Window:Notify({Title = "Error", Content = "File system not supported!", Duration = 3})
            return false
        end
        local cfg = {}
        for flag, el in pairs(Window.Flags) do
            local v = el:Get()
            if typeof(v) == "Color3" then
                cfg[flag] = {Type = "Color3", R = v.R, G = v.G, B = v.B}
            elseif typeof(v) == "EnumItem" then
                cfg[flag] = {Type = "EnumItem", EnumType = tostring(v.EnumType), Name = v.Name}
            else
                cfg[flag] = {Type = typeof(v), Value = v}
            end
        end
        FS.Write(Window.ConfigPath .. "/" .. name .. ".json", HttpService:JSONEncode(cfg))
        Window:Notify({Title = "Config Saved", Content = "Saved: " .. name, Duration = 2})
        return true
    end
    
    function Window:LoadConfig(name)
        if not FS.Ok() then
            Window:Notify({Title = "Error", Content = "File system not supported!", Duration = 3})
            return false
        end
        local content = FS.Read(Window.ConfigPath .. "/" .. name .. ".json")
        if not content then
            Window:Notify({Title = "Error", Content = "Config not found!", Duration = 3})
            return false
        end
        local ok, cfg = pcall(function() return HttpService:JSONDecode(content) end)
        if not ok then
            Window:Notify({Title = "Error", Content = "Failed to parse config!", Duration = 3})
            return false
        end
        for flag, data in pairs(cfg) do
            if Window.Flags[flag] then
                if data.Type == "Color3" then
                    Window.Flags[flag]:Set(Color3.new(data.R, data.G, data.B))
                elseif data.Type == "EnumItem" then
                    local enumType = Enum[data.EnumType:gsub("Enum.", "")]
                    if enumType then Window.Flags[flag]:Set(enumType[data.Name]) end
                else
                    Window.Flags[flag]:Set(data.Value)
                end
            end
        end
        Window:Notify({Title = "Config Loaded", Content = "Loaded: " .. name, Duration = 2})
        return true
    end
    
    function Window:GetConfigs()
        local configs = {}
        for _, file in pairs(FS.List(Window.ConfigPath)) do
            local name = file:match("([^/\\]+)%.json$")
            if name then table.insert(configs, name) end
        end
        return configs
    end
    
    function Window:BuildConfigSection(Tab)
        Tab:CreateSection("Configuration")
        local nameInput = Tab:CreateInput({Name = "Config Name", Placeholder = "Enter name...", Default = "default"})
        local dropdown = Tab:CreateDropdown({Name = "Select Config", Options = Window:GetConfigs(), Default = "Select..."})
        Tab:CreateButton({Name = "Save Config", Callback = function()
            local name = nameInput:Get()
            if name and name ~= "" then
                Window:SaveConfig(name)
                dropdown:Refresh(Window:GetConfigs())
            end
        end})
        Tab:CreateButton({Name = "Load Config", Callback = function()
            local sel = dropdown:Get()
            if sel and sel ~= "Select..." then Window:LoadConfig(sel) end
        end})
        Tab:CreateButton({Name = "Refresh Configs", Callback = function()
            dropdown:Refresh(Window:GetConfigs())
            Window:Notify({Title = "Refreshed", Content = "Config list updated", Duration = 2})
        end})
        return {NameInput = nameInput, Dropdown = dropdown}
    end
    
    -- Notifications
    function Window:Notify(cfg)
        cfg = cfg or {}
        local notif = Instance.new("Frame")
        notif.BackgroundColor3 = Theme.Surface
        notif.BorderSizePixel = 0
        notif.Size = UDim2.new(0, Scale(280), 0, Scale(70))
        notif.Position = UDim2.new(1, Scale(300), 1, Scale(-90))
        notif.Parent = screenGui
        CreateCorner(notif, Theme.CornerRadius)
        CreateStroke(notif, Theme.Accent, 1)
        
        local accentBar = Instance.new("Frame")
        accentBar.BackgroundColor3 = Theme.Accent
        accentBar.BorderSizePixel = 0
        accentBar.Size = UDim2.new(0, 4, 1, Scale(-12))
        accentBar.Position = UDim2.new(0, Scale(6), 0, Scale(6))
        accentBar.Parent = notif
        CreateCorner(accentBar, UDim.new(1, 0))
        
        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, Scale(-24), 0, Scale(22))
        title.Position = UDim2.new(0, Scale(20), 0, Scale(8))
        title.Font = Theme.Font
        title.Text = cfg.Title or "Notification"
        title.TextColor3 = Theme.TextPrimary
        title.TextSize = Scale(13)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = notif
        
        local content = Instance.new("TextLabel")
        content.BackgroundTransparency = 1
        content.Size = UDim2.new(1, Scale(-24), 0, Scale(36))
        content.Position = UDim2.new(0, Scale(20), 0, Scale(28))
        content.Font = Theme.FontRegular
        content.Text = cfg.Content or ""
        content.TextColor3 = Theme.TextSecondary
        content.TextSize = Scale(11)
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.TextYAlignment = Enum.TextYAlignment.Top
        content.TextWrapped = true
        content.Parent = notif
        
        Tween(notif, {Position = UDim2.new(1, Scale(-295), 1, Scale(-90))}, 0.35, Enum.EasingStyle.Back)
        task.delay(cfg.Duration or 4, function()
            Tween(notif, {Position = UDim2.new(1, Scale(300), 1, Scale(-90)), BackgroundTransparency = 1}, 0.3)
            task.delay(0.3, function() notif:Destroy() end)
        end)
    end
    
    -- Toggle Window
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then Window:Toggle(not isVisible) end
    end)
    
    function Window:Toggle(state)
        if state == nil then state = not isVisible end
        isVisible = state
        if state then
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.BackgroundTransparency = 1
            Tween(mainFrame, {Size = originalSize, BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Back)
            isOpen = true
        else
            Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.25)
            task.delay(0.25, function() mainFrame.Visible = false end)
        end
    end
    
    function Window:IsVisible() return isVisible end
    function Window:Destroy()
        Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function() screenGui:Destroy() end)
    end
    
    return Window
end

function VoidUI:SetTheme(t) for k, v in pairs(t) do if Theme[k] then Theme[k] = v end end end
function VoidUI:GetTheme() return Theme end
function VoidUI:IsMobile() return IS_MOBILE end

return VoidUI
