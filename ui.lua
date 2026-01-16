--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                         VOID UI                               ║
    ║         Minimalistic UI Library for Roblox                    ║
    ║                     v1.0.0                                    ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    Usage:
    local VoidUI = loadstring(game:HttpGet("YOUR_URL"))()
    
    local Window = VoidUI:CreateWindow({
        Title = "Void UI",
        Size = UDim2.new(0, 500, 0, 400)
    })
    
    local Tab = Window:CreateTab({
        Name = "Main",
        Icon = "rbxassetid://123456789"
    })
    
    Tab:CreateToggle({
        Name = "Enable Feature",
        Default = false,
        Callback = function(value) print(value) end
    })
]]

local VoidUI = {}
VoidUI.__index = VoidUI

-- ═══════════════════════════════════════════════════════════════
-- THEME CONFIGURATION
-- ═══════════════════════════════════════════════════════════════

local Theme = {
    -- Core Colors
    Background = Color3.fromRGB(12, 12, 14),
    Surface = Color3.fromRGB(18, 18, 22),
    SurfaceHover = Color3.fromRGB(24, 24, 30),
    Border = Color3.fromRGB(32, 32, 40),
    
    -- Accent (Purple)
    Accent = Color3.fromRGB(138, 43, 226),
    AccentDark = Color3.fromRGB(108, 33, 186),
    AccentGlow = Color3.fromRGB(158, 63, 246),
    
    -- Text
    TextPrimary = Color3.fromRGB(245, 245, 250),
    TextSecondary = Color3.fromRGB(140, 140, 160),
    TextMuted = Color3.fromRGB(80, 80, 100),
    
    -- States
    Success = Color3.fromRGB(46, 204, 113),
    Warning = Color3.fromRGB(241, 196, 15),
    Error = Color3.fromRGB(231, 76, 60),
    
    -- Animation
    AnimationSpeed = 0.2,
    EasingStyle = Enum.EasingStyle.Quart,
    EasingDirection = Enum.EasingDirection.Out,
    
    -- Typography
    Font = Enum.Font.GothamBold,
    FontMedium = Enum.Font.GothamMedium,
    FontRegular = Enum.Font.Gotham,
    
    -- Sizing
    CornerRadius = UDim.new(0, 4),
    Padding = 12,
    ElementHeight = 36,
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or Theme.AnimationSpeed,
        style or Theme.EasingStyle,
        direction or Theme.EasingDirection
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or Theme.CornerRadius
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreatePadding(parent, padding)
    local uiPadding = Instance.new("UIPadding")
    local p = padding or Theme.Padding
    uiPadding.PaddingTop = UDim.new(0, p)
    uiPadding.PaddingBottom = UDim.new(0, p)
    uiPadding.PaddingLeft = UDim.new(0, p)
    uiPadding.PaddingRight = UDim.new(0, p)
    uiPadding.Parent = parent
    return uiPadding
end

local function Ripple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Theme.Accent
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local mouse = UserInputService:GetMouseLocation()
    local relativePos = mouse - button.AbsolutePosition
    ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y - 36)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    
    CreateCorner(ripple, UDim.new(1, 0))
    ripple.Parent = button
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    Tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.4)
    
    task.delay(0.4, function()
        ripple:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN LIBRARY
-- ═══════════════════════════════════════════════════════════════

function VoidUI:CreateWindow(config)
    config = config or {}
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VoidUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Main Window Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Size = config.Size or UDim2.new(0, 520, 0, 380)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    CreateCorner(mainFrame, UDim.new(0, 6))
    CreateStroke(mainFrame, Theme.Border, 1)
    
    -- Window Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 42)
    titleBar.Parent = mainFrame
    
    CreateCorner(titleBar, UDim.new(0, 6))
    
    -- Fix bottom corners of title bar
    local titleBarFix = Instance.new("Frame")
    titleBarFix.Name = "Fix"
    titleBarFix.BackgroundColor3 = Theme.Surface
    titleBarFix.BorderSizePixel = 0
    titleBarFix.Size = UDim2.new(1, 0, 0, 10)
    titleBarFix.Position = UDim2.new(0, 0, 1, -10)
    titleBarFix.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 16, 0, 0)
    titleText.Font = Theme.Font
    titleText.Text = config.Title or "VOID UI"
    titleText.TextColor3 = Theme.TextPrimary
    titleText.TextSize = 14
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Accent Line
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.BackgroundColor3 = Theme.Accent
    accentLine.BorderSizePixel = 0
    accentLine.Size = UDim2.new(0, 40, 0, 2)
    accentLine.Position = UDim2.new(0, 16, 1, -2)
    accentLine.Parent = titleBar
    
    -- Window Controls
    local controls = Instance.new("Frame")
    controls.Name = "Controls"
    controls.BackgroundTransparency = 1
    controls.Size = UDim2.new(0, 80, 0, 42)
    controls.Position = UDim2.new(1, -80, 0, 0)
    controls.Parent = titleBar
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.BackgroundColor3 = Theme.SurfaceHover
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
    minimizeBtn.Position = UDim2.new(0, 5, 0.5, -16)
    minimizeBtn.Font = Theme.Font
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Theme.TextSecondary
    minimizeBtn.TextSize = 20
    minimizeBtn.Parent = controls
    
    CreateCorner(minimizeBtn, UDim.new(0, 4))
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.BackgroundColor3 = Theme.Error
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel = 0
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(0, 42, 0.5, -16)
    closeBtn.Font = Theme.Font
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.TextSize = 20
    closeBtn.Parent = controls
    
    CreateCorner(closeBtn, UDim.new(0, 4))
    
    -- Button Hover Effects
    minimizeBtn.MouseEnter:Connect(function()
        Tween(minimizeBtn, {BackgroundTransparency = 0.5}, 0.15)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        Tween(minimizeBtn, {BackgroundTransparency = 1}, 0.15)
    end)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.3, TextColor3 = Theme.TextPrimary}, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextSecondary}, 0.15)
    end)
    
    -- Tab Container (Left Side)
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundColor3 = Theme.Surface
    tabContainer.BorderSizePixel = 0
    tabContainer.Size = UDim2.new(0, 140, 1, -52)
    tabContainer.Position = UDim2.new(0, 0, 0, 46)
    tabContainer.Parent = mainFrame
    
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 4)
    tabList.Parent = tabContainer
    
    CreatePadding(tabContainer, 8)
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Size = UDim2.new(1, -148, 1, -52)
    contentContainer.Position = UDim2.new(0, 144, 0, 46)
    contentContainer.ClipsDescendants = true
    contentContainer.Parent = mainFrame
    
    -- Dragging
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Window Toggle
    local isOpen = true
    local originalSize = mainFrame.Size
    
    minimizeBtn.MouseButton1Click:Connect(function()
        if isOpen then
            Tween(mainFrame, {Size = UDim2.new(0, originalSize.X.Offset, 0, 42)}, 0.25)
        else
            Tween(mainFrame, {Size = originalSize}, 0.25)
        end
        isOpen = not isOpen
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function()
            screenGui:Destroy()
        end)
    end)
    
    -- Open Animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    Tween(mainFrame, {Size = originalSize, BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Back)
    
    -- ═══════════════════════════════════════════════════════════
    -- CREATE TAB
    -- ═══════════════════════════════════════════════════════════
    
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabConfig.Name or "Tab"
        tabBtn.BackgroundColor3 = Theme.SurfaceHover
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Size = UDim2.new(1, 0, 0, 36)
        tabBtn.Font = Theme.FontMedium
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabContainer
        
        CreateCorner(tabBtn, UDim.new(0, 4))
        
        -- Tab Icon
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.BackgroundTransparency = 1
        tabIcon.Size = UDim2.new(0, 18, 0, 18)
        tabIcon.Position = UDim2.new(0, 10, 0.5, -9)
        tabIcon.Image = tabConfig.Icon or ""
        tabIcon.ImageColor3 = Theme.TextSecondary
        tabIcon.Parent = tabBtn
        
        -- Tab Label
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "Label"
        tabLabel.BackgroundTransparency = 1
        tabLabel.Size = UDim2.new(1, -40, 1, 0)
        tabLabel.Position = UDim2.new(0, 34, 0, 0)
        tabLabel.Font = Theme.FontMedium
        tabLabel.Text = tabConfig.Name or "Tab"
        tabLabel.TextColor3 = Theme.TextSecondary
        tabLabel.TextSize = 12
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn
        
        -- Tab Indicator
        local tabIndicator = Instance.new("Frame")
        tabIndicator.Name = "Indicator"
        tabIndicator.BackgroundColor3 = Theme.Accent
        tabIndicator.BorderSizePixel = 0
        tabIndicator.Size = UDim2.new(0, 3, 0, 0)
        tabIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        tabIndicator.AnchorPoint = Vector2.new(0, 0.5)
        tabIndicator.Parent = tabBtn
        
        CreateCorner(tabIndicator, UDim.new(0, 2))
        
        -- Tab Content Frame
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
        contentList.Padding = UDim.new(0, 8)
        contentList.Parent = contentFrame
        
        CreatePadding(contentFrame, 6)
        
        -- Auto-resize canvas
        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        local function SelectTab()
            -- Deselect all tabs
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundTransparency = 1}, 0.15)
                Tween(tab.Label, {TextColor3 = Theme.TextSecondary}, 0.15)
                Tween(tab.Icon, {ImageColor3 = Theme.TextSecondary}, 0.15)
                Tween(tab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.15)
                tab.Content.Visible = false
            end
            
            -- Select this tab
            Tween(tabBtn, {BackgroundTransparency = 0.7}, 0.15)
            Tween(tabLabel, {TextColor3 = Theme.TextPrimary}, 0.15)
            Tween(tabIcon, {ImageColor3 = Theme.Accent}, 0.15)
            Tween(tabIndicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.2, Enum.EasingStyle.Back)
            contentFrame.Visible = true
            
            Window.ActiveTab = Tab
        end
        
        tabBtn.MouseButton1Click:Connect(SelectTab)
        
        tabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.85}, 0.1)
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1}, 0.1)
            end
        end)
        
        -- Store references
        Tab.Button = tabBtn
        Tab.Label = tabLabel
        Tab.Icon = tabIcon
        Tab.Indicator = tabIndicator
        Tab.Content = contentFrame
        
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab
        if #Window.Tabs == 1 then
            SelectTab()
        end
        
        -- ═══════════════════════════════════════════════════════
        -- TOGGLE
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local value = toggleConfig.Default or false
            
            local container = Instance.new("Frame")
            container.Name = "Toggle"
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Theme.ElementHeight)
            container.Parent = contentFrame
            
            CreateCorner(container)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Font = Theme.FontMedium
            label.Text = toggleConfig.Name or "Toggle"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "ToggleFrame"
            toggleFrame.BackgroundColor3 = Theme.Background
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(0, 40, 0, 20)
            toggleFrame.Position = UDim2.new(1, -52, 0.5, -10)
            toggleFrame.Parent = container
            
            CreateCorner(toggleFrame, UDim.new(0, 4))
            CreateStroke(toggleFrame, Theme.Border, 1)
            
            local toggleKnob = Instance.new("Frame")
            toggleKnob.Name = "Knob"
            toggleKnob.BackgroundColor3 = Theme.TextMuted
            toggleKnob.BorderSizePixel = 0
            toggleKnob.Size = UDim2.new(0, 16, 0, 16)
            toggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
            toggleKnob.Parent = toggleFrame
            
            CreateCorner(toggleKnob, UDim.new(0, 3))
            
            local function UpdateToggle()
                if value then
                    Tween(toggleKnob, {Position = UDim2.new(0, 22, 0.5, -8), BackgroundColor3 = Theme.Accent}, 0.2)
                    Tween(toggleFrame, {BackgroundColor3 = Theme.AccentDark}, 0.2)
                else
                    Tween(toggleKnob, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Theme.TextMuted}, 0.2)
                    Tween(toggleFrame, {BackgroundColor3 = Theme.Background}, 0.2)
                end
            end
            
            UpdateToggle()
            
            local clickBtn = Instance.new("TextButton")
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.Text = ""
            clickBtn.Parent = container
            
            clickBtn.MouseButton1Click:Connect(function()
                value = not value
                UpdateToggle()
                if toggleConfig.Callback then
                    toggleConfig.Callback(value)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1)
            end)
            
            local Toggle = {}
            function Toggle:Set(newValue)
                value = newValue
                UpdateToggle()
            end
            function Toggle:Get()
                return value
            end
            
            return Toggle
        end
        
        -- ═══════════════════════════════════════════════════════
        -- SLIDER
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local min = sliderConfig.Min or 0
            local max = sliderConfig.Max or 100
            local value = sliderConfig.Default or min
            
            local container = Instance.new("Frame")
            container.Name = "Slider"
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, 52)
            container.Parent = contentFrame
            
            CreateCorner(container)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -60, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 6)
            label.Font = Theme.FontMedium
            label.Text = sliderConfig.Name or "Slider"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.BackgroundTransparency = 1
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -60, 0, 6)
            valueLabel.Font = Theme.FontMedium
            valueLabel.Text = tostring(value)
            valueLabel.TextColor3 = Theme.Accent
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = container
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Name = "Track"
            sliderTrack.BackgroundColor3 = Theme.Background
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Size = UDim2.new(1, -24, 0, 6)
            sliderTrack.Position = UDim2.new(0, 12, 1, -16)
            sliderTrack.Parent = container
            
            CreateCorner(sliderTrack, UDim.new(0, 3))
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "Fill"
            sliderFill.BackgroundColor3 = Theme.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            sliderFill.Parent = sliderTrack
            
            CreateCorner(sliderFill, UDim.new(0, 3))
            
            local sliderKnob = Instance.new("Frame")
            sliderKnob.Name = "Knob"
            sliderKnob.BackgroundColor3 = Theme.TextPrimary
            sliderKnob.BorderSizePixel = 0
            sliderKnob.Size = UDim2.new(0, 14, 0, 14)
            sliderKnob.Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7)
            sliderKnob.Parent = sliderTrack
            
            CreateCorner(sliderKnob, UDim.new(0, 3))
            
            local dragging = false
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos + 0.5)
                
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                sliderKnob.Position = UDim2.new(pos, -7, 0.5, -7)
                valueLabel.Text = tostring(value)
                
                if sliderConfig.Callback then
                    sliderConfig.Callback(value)
                end
            end
            
            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            sliderTrack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1)
            end)
            
            local Slider = {}
            function Slider:Set(newValue)
                value = math.clamp(newValue, min, max)
                local pos = (value - min) / (max - min)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                sliderKnob.Position = UDim2.new(pos, -7, 0.5, -7)
                valueLabel.Text = tostring(value)
            end
            function Slider:Get()
                return value
            end
            
            return Slider
        end
        
        -- ═══════════════════════════════════════════════════════
        -- DROPDOWN
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateDropdown(dropdownConfig)
            dropdownConfig = dropdownConfig or {}
            local options = dropdownConfig.Options or {}
            local selected = dropdownConfig.Default or (options[1] or "Select...")
            local isOpen = false
            
            local container = Instance.new("Frame")
            container.Name = "Dropdown"
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Theme.ElementHeight)
            container.ClipsDescendants = true
            container.Parent = contentFrame
            
            CreateCorner(container)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(0.5, -12, 0, Theme.ElementHeight)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Font = Theme.FontMedium
            label.Text = dropdownConfig.Name or "Dropdown"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local selectedLabel = Instance.new("TextLabel")
            selectedLabel.BackgroundTransparency = 1
            selectedLabel.Size = UDim2.new(0.5, -30, 0, Theme.ElementHeight)
            selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            selectedLabel.Font = Theme.FontMedium
            selectedLabel.Text = selected
            selectedLabel.TextColor3 = Theme.Accent
            selectedLabel.TextSize = 12
            selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            selectedLabel.Parent = container
            
            local arrow = Instance.new("TextLabel")
            arrow.BackgroundTransparency = 1
            arrow.Size = UDim2.new(0, 20, 0, Theme.ElementHeight)
            arrow.Position = UDim2.new(1, -24, 0, 0)
            arrow.Font = Theme.Font
            arrow.Text = "▼"
            arrow.TextColor3 = Theme.TextSecondary
            arrow.TextSize = 10
            arrow.Parent = container
            
            local optionContainer = Instance.new("Frame")
            optionContainer.Name = "Options"
            optionContainer.BackgroundTransparency = 1
            optionContainer.Size = UDim2.new(1, 0, 0, #options * 28)
            optionContainer.Position = UDim2.new(0, 0, 0, Theme.ElementHeight + 4)
            optionContainer.Parent = container
            
            local optionList = Instance.new("UIListLayout")
            optionList.SortOrder = Enum.SortOrder.LayoutOrder
            optionList.Padding = UDim.new(0, 2)
            optionList.Parent = optionContainer
            
            for i, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Name = option
                optBtn.BackgroundColor3 = Theme.Background
                optBtn.BackgroundTransparency = 1
                optBtn.BorderSizePixel = 0
                optBtn.Size = UDim2.new(1, -16, 0, 26)
                optBtn.Font = Theme.FontRegular
                optBtn.Text = option
                optBtn.TextColor3 = Theme.TextSecondary
                optBtn.TextSize = 11
                optBtn.Parent = optionContainer
                
                CreateCorner(optBtn, UDim.new(0, 3))
                
                optBtn.MouseEnter:Connect(function()
                    Tween(optBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.TextPrimary}, 0.1)
                end)
                optBtn.MouseLeave:Connect(function()
                    Tween(optBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextSecondary}, 0.1)
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    selected = option
                    selectedLabel.Text = option
                    isOpen = false
                    Tween(container, {Size = UDim2.new(1, 0, 0, Theme.ElementHeight)}, 0.2)
                    Tween(arrow, {Rotation = 0}, 0.2)
                    if dropdownConfig.Callback then
                        dropdownConfig.Callback(option)
                    end
                end)
            end
            
            CreatePadding(optionContainer, 0)
            
            local clickBtn = Instance.new("TextButton")
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 0, Theme.ElementHeight)
            clickBtn.Text = ""
            clickBtn.Parent = container
            
            clickBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    Tween(container, {Size = UDim2.new(1, 0, 0, Theme.ElementHeight + 8 + #options * 28)}, 0.25, Enum.EasingStyle.Back)
                    Tween(arrow, {Rotation = 180}, 0.2)
                else
                    Tween(container, {Size = UDim2.new(1, 0, 0, Theme.ElementHeight)}, 0.2)
                    Tween(arrow, {Rotation = 0}, 0.2)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1)
            end)
            
            local Dropdown = {}
            function Dropdown:Set(newValue)
                selected = newValue
                selectedLabel.Text = newValue
            end
            function Dropdown:Get()
                return selected
            end
            
            return Dropdown
        end
        
        -- ═══════════════════════════════════════════════════════
        -- TEXT INPUT
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateInput(inputConfig)
            inputConfig = inputConfig or {}
            
            local container = Instance.new("Frame")
            container.Name = "Input"
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, 52)
            container.Parent = contentFrame
            
            CreateCorner(container)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -24, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 4)
            label.Font = Theme.FontMedium
            label.Text = inputConfig.Name or "Input"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local inputFrame = Instance.new("Frame")
            inputFrame.BackgroundColor3 = Theme.Background
            inputFrame.BorderSizePixel = 0
            inputFrame.Size = UDim2.new(1, -24, 0, 22)
            inputFrame.Position = UDim2.new(0, 12, 0, 24)
            inputFrame.Parent = container
            
            CreateCorner(inputFrame, UDim.new(0, 3))
            local inputStroke = CreateStroke(inputFrame, Theme.Border, 1)
            
            local textBox = Instance.new("TextBox")
            textBox.BackgroundTransparency = 1
            textBox.Size = UDim2.new(1, -12, 1, 0)
            textBox.Position = UDim2.new(0, 6, 0, 0)
            textBox.Font = Theme.FontRegular
            textBox.Text = inputConfig.Default or ""
            textBox.PlaceholderText = inputConfig.Placeholder or "Enter text..."
            textBox.PlaceholderColor3 = Theme.TextMuted
            textBox.TextColor3 = Theme.TextPrimary
            textBox.TextSize = 11
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.ClearTextOnFocus = false
            textBox.Parent = inputFrame
            
            textBox.Focused:Connect(function()
                Tween(inputStroke, {Color = Theme.Accent}, 0.15)
            end)
            
            textBox.FocusLost:Connect(function(enterPressed)
                Tween(inputStroke, {Color = Theme.Border}, 0.15)
                if inputConfig.Callback then
                    inputConfig.Callback(textBox.Text, enterPressed)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1)
            end)
            
            local Input = {}
            function Input:Set(text)
                textBox.Text = text
            end
            function Input:Get()
                return textBox.Text
            end
            
            return Input
        end
        
        -- ═══════════════════════════════════════════════════════
        -- BUTTON
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateButton(buttonConfig)
            buttonConfig = buttonConfig or {}
            
            local btn = Instance.new("TextButton")
            btn.Name = "Button"
            btn.BackgroundColor3 = Theme.Accent
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, Theme.ElementHeight)
            btn.Font = Theme.FontMedium
            btn.Text = buttonConfig.Name or "Button"
            btn.TextColor3 = Theme.TextPrimary
            btn.TextSize = 12
            btn.AutoButtonColor = false
            btn.ClipsDescendants = true
            btn.Parent = contentFrame
            
            CreateCorner(btn)
            
            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = Theme.AccentGlow}, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15)
            end)
            
            btn.MouseButton1Click:Connect(function()
                Ripple(btn)
                if buttonConfig.Callback then
                    buttonConfig.Callback()
                end
            end)
            
            return btn
        end
        
        -- ═══════════════════════════════════════════════════════
        -- COLOR PICKER
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateColorPicker(colorConfig)
            colorConfig = colorConfig or {}
            local currentColor = colorConfig.Default or Color3.fromRGB(138, 43, 226)
            local isOpen = false
            
            local container = Instance.new("Frame")
            container.Name = "ColorPicker"
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Theme.ElementHeight)
            container.ClipsDescendants = true
            container.Parent = contentFrame
            
            CreateCorner(container)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -60, 0, Theme.ElementHeight)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Font = Theme.FontMedium
            label.Text = colorConfig.Name or "Color"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local colorPreview = Instance.new("Frame")
            colorPreview.Name = "Preview"
            colorPreview.BackgroundColor3 = currentColor
            colorPreview.BorderSizePixel = 0
            colorPreview.Size = UDim2.new(0, 24, 0, 24)
            colorPreview.Position = UDim2.new(1, -40, 0.5, -12)
            colorPreview.Parent = container
            
            CreateCorner(colorPreview, UDim.new(0, 4))
            CreateStroke(colorPreview, Theme.Border, 1)
            
            -- Color Picker Panel
            local pickerPanel = Instance.new("Frame")
            pickerPanel.Name = "Panel"
            pickerPanel.BackgroundTransparency = 1
            pickerPanel.Size = UDim2.new(1, -24, 0, 120)
            pickerPanel.Position = UDim2.new(0, 12, 0, Theme.ElementHeight + 8)
            pickerPanel.Parent = container
            
            -- Saturation/Value picker
            local svPicker = Instance.new("ImageLabel")
            svPicker.Name = "SVPicker"
            svPicker.BackgroundColor3 = currentColor
            svPicker.BorderSizePixel = 0
            svPicker.Size = UDim2.new(1, -30, 1, 0)
            svPicker.Image = "rbxassetid://4155801252"
            svPicker.Parent = pickerPanel
            
            CreateCorner(svPicker, UDim.new(0, 4))
            
            local svCursor = Instance.new("Frame")
            svCursor.Name = "Cursor"
            svCursor.BackgroundColor3 = Color3.new(1, 1, 1)
            svCursor.BorderSizePixel = 0
            svCursor.Size = UDim2.new(0, 10, 0, 10)
            svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
            svCursor.Position = UDim2.new(1, 0, 0, 0)
            svCursor.Parent = svPicker
            
            CreateCorner(svCursor, UDim.new(1, 0))
            CreateStroke(svCursor, Color3.new(0, 0, 0), 2)
            
            -- Hue slider
            local hueSlider = Instance.new("Frame")
            hueSlider.Name = "HueSlider"
            hueSlider.BorderSizePixel = 0
            hueSlider.Size = UDim2.new(0, 20, 1, 0)
            hueSlider.Position = UDim2.new(1, -20, 0, 0)
            hueSlider.Parent = pickerPanel
            
            CreateCorner(hueSlider, UDim.new(0, 4))
            
            -- Hue gradient
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
            hueCursor.Name = "Cursor"
            hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
            hueCursor.BorderSizePixel = 0
            hueCursor.Size = UDim2.new(1, 4, 0, 6)
            hueCursor.Position = UDim2.new(0, -2, 0, 0)
            hueCursor.Parent = hueSlider
            
            CreateCorner(hueCursor, UDim.new(0, 2))
            CreateStroke(hueCursor, Color3.new(0, 0, 0), 1)
            
            local h, s, v = currentColor:ToHSV()
            
            local function UpdateColor()
                currentColor = Color3.fromHSV(h, s, v)
                colorPreview.BackgroundColor3 = currentColor
                svPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                hueCursor.Position = UDim2.new(0, -2, h, -3)
                
                if colorConfig.Callback then
                    colorConfig.Callback(currentColor)
                end
            end
            
            UpdateColor()
            
            -- SV Picker interaction
            local svDragging = false
            
            svPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = true
                end
            end)
            
            svPicker.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = false
                end
            end)
            
            -- Hue Slider interaction
            local hueDragging = false
            
            hueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = true
                end
            end)
            
            hueSlider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if svDragging then
                        local pos = Vector2.new(input.Position.X, input.Position.Y)
                        local relX = math.clamp((pos.X - svPicker.AbsolutePosition.X) / svPicker.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((pos.Y - svPicker.AbsolutePosition.Y) / svPicker.AbsoluteSize.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        UpdateColor()
                    elseif hueDragging then
                        local relY = math.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                        h = relY
                        UpdateColor()
                    end
                end
            end)
            
            -- Toggle open/close
            local clickBtn = Instance.new("TextButton")
            clickBtn.BackgroundTransparency = 1
            clickBtn.Size = UDim2.new(1, 0, 0, Theme.ElementHeight)
            clickBtn.Text = ""
            clickBtn.Parent = container
            
            clickBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    Tween(container, {Size = UDim2.new(1, 0, 0, Theme.ElementHeight + 136)}, 0.25, Enum.EasingStyle.Back)
                else
                    Tween(container, {Size = UDim2.new(1, 0, 0, Theme.ElementHeight)}, 0.2)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1)
            end)
            
            local ColorPicker = {}
            function ColorPicker:Set(color)
                currentColor = color
                h, s, v = color:ToHSV()
                UpdateColor()
            end
            function ColorPicker:Get()
                return currentColor
            end
            
            return ColorPicker
        end
        
        -- ═══════════════════════════════════════════════════════
        -- LABEL
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateLabel(text)
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0, 24)
            label.Font = Theme.FontMedium
            label.Text = text or "Label"
            label.TextColor3 = Theme.TextSecondary
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = contentFrame
            
            local Label = {}
            function Label:Set(newText)
                label.Text = newText
            end
            
            return Label
        end
        
        -- ═══════════════════════════════════════════════════════
        -- SECTION / DIVIDER
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateSection(title)
            local section = Instance.new("Frame")
            section.Name = "Section"
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(1, 0, 0, 28)
            section.Parent = contentFrame
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Size = UDim2.new(1, 0, 0, 20)
            sectionLabel.Position = UDim2.new(0, 0, 0, 8)
            sectionLabel.Font = Theme.Font
            sectionLabel.Text = string.upper(title or "SECTION")
            sectionLabel.TextColor3 = Theme.Accent
            sectionLabel.TextSize = 10
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
        
        -- ═══════════════════════════════════════════════════════
        -- KEYBIND
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateKeybind(keybindConfig)
            keybindConfig = keybindConfig or {}
            local currentKey = keybindConfig.Default or Enum.KeyCode.Unknown
            local listening = false
            
            local container = Instance.new("Frame")
            container.Name = "Keybind"
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Size = UDim2.new(1, 0, 0, Theme.ElementHeight)
            container.Parent = contentFrame
            
            CreateCorner(container)
            CreateStroke(container, Theme.Border, 1)
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -80, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Font = Theme.FontMedium
            label.Text = keybindConfig.Name or "Keybind"
            label.TextColor3 = Theme.TextPrimary
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Name = "KeyButton"
            keyBtn.BackgroundColor3 = Theme.Background
            keyBtn.BorderSizePixel = 0
            keyBtn.Size = UDim2.new(0, 60, 0, 24)
            keyBtn.Position = UDim2.new(1, -72, 0.5, -12)
            keyBtn.Font = Theme.FontMedium
            keyBtn.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
            keyBtn.TextColor3 = Theme.Accent
            keyBtn.TextSize = 11
            keyBtn.AutoButtonColor = false
            keyBtn.Parent = container
            
            CreateCorner(keyBtn, UDim.new(0, 3))
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
                    
                    if keybindConfig.Callback then
                        keybindConfig.Callback(currentKey)
                    end
                elseif not listening and input.KeyCode == currentKey then
                    if keybindConfig.OnPress then
                        keybindConfig.OnPress()
                    end
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.SurfaceHover}, 0.1)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Surface}, 0.1)
            end)
            
            local Keybind = {}
            function Keybind:Set(key)
                currentKey = key
                keyBtn.Text = key.Name
            end
            function Keybind:Get()
                return currentKey
            end
            
            return Keybind
        end
        
        return Tab
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- NOTIFICATIONS
    -- ═══════════════════════════════════════════════════════════
    
    function Window:Notify(notifyConfig)
        notifyConfig = notifyConfig or {}
        
        local notification = Instance.new("Frame")
        notification.Name = "Notification"
        notification.BackgroundColor3 = Theme.Surface
        notification.BorderSizePixel = 0
        notification.Size = UDim2.new(0, 280, 0, 70)
        notification.Position = UDim2.new(1, 300, 1, -90)
        notification.Parent = screenGui
        
        CreateCorner(notification)
        CreateStroke(notification, Theme.Accent, 1)
        
        local notifShadow = shadow:Clone()
        notifShadow.Parent = notification
        
        local accentBar = Instance.new("Frame")
        accentBar.BackgroundColor3 = Theme.Accent
        accentBar.BorderSizePixel = 0
        accentBar.Size = UDim2.new(0, 3, 1, -8)
        accentBar.Position = UDim2.new(0, 4, 0, 4)
        accentBar.Parent = notification
        
        CreateCorner(accentBar, UDim.new(0, 2))
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.BackgroundTransparency = 1
        titleLabel.Size = UDim2.new(1, -24, 0, 22)
        titleLabel.Position = UDim2.new(0, 16, 0, 8)
        titleLabel.Font = Theme.Font
        titleLabel.Text = notifyConfig.Title or "Notification"
        titleLabel.TextColor3 = Theme.TextPrimary
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notification
        
        local contentLabel = Instance.new("TextLabel")
        contentLabel.BackgroundTransparency = 1
        contentLabel.Size = UDim2.new(1, -24, 0, 36)
        contentLabel.Position = UDim2.new(0, 16, 0, 28)
        contentLabel.Font = Theme.FontRegular
        contentLabel.Text = notifyConfig.Content or ""
        contentLabel.TextColor3 = Theme.TextSecondary
        contentLabel.TextSize = 11
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextYAlignment = Enum.TextYAlignment.Top
        contentLabel.TextWrapped = true
        contentLabel.Parent = notification
        
        -- Animate in
        Tween(notification, {Position = UDim2.new(1, -295, 1, -90)}, 0.35, Enum.EasingStyle.Back)
        
        -- Auto dismiss
        local duration = notifyConfig.Duration or 4
        task.delay(duration, function()
            Tween(notification, {Position = UDim2.new(1, 300, 1, -90), BackgroundTransparency = 1}, 0.3)
            task.delay(0.3, function()
                notification:Destroy()
            end)
        end)
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- WINDOW TOGGLE (Keybind)
    -- ═══════════════════════════════════════════════════════════
    
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then
            if mainFrame.Visible then
                Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.25)
                task.delay(0.25, function()
                    mainFrame.Visible = false
                end)
            else
                mainFrame.Visible = true
                mainFrame.Size = UDim2.new(0, 0, 0, 0)
                mainFrame.BackgroundTransparency = 1
                Tween(mainFrame, {Size = originalSize, BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Back)
            end
        end
    end)
    
    function Window:Toggle(state)
        if state then
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            Tween(mainFrame, {Size = originalSize, BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Back)
        else
            Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.25)
            task.delay(0.25, function()
                mainFrame.Visible = false
            end)
        end
    end
    
    function Window:Destroy()
        Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function()
            screenGui:Destroy()
        end)
    end
    
    return Window
end

-- ═══════════════════════════════════════════════════════════════
-- THEME CUSTOMIZATION
-- ═══════════════════════════════════════════════════════════════

function VoidUI:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        if Theme[key] then
            Theme[key] = value
        end
    end
end

function VoidUI:GetTheme()
    return Theme
end

return VoidUI
