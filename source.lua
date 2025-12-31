--{{ Gonna be useful later }}--
local scriptname = "N/A"
local owner = "N/A"
local Discordowner = "N/A"
local investor = "N/A"
local manager = "N/A"
local admin = "N/A"
local ver = "1.0.0"
local discord = "discord.gg/getnova"
local updated = os.date('00/00/0000')
local color1 = Color3.fromRGB(69, 94, 255)
local color2 = Color3.fromRGB(255, 255, 255)
local color3 = Color3.fromRGB(11, 10, 15)
local scriptimage = "rbxassetid://"
--{{ Gonna be useful later }}--

local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService('UserInputService')
local HttpService = game:GetService('HttpService')
local Debris = game:GetService('Debris')
local Utility = {}

local function SafeGetExecutorName()
    local x = ''
    pcall(function()
        x = getexecutorname()
    end)
    return x
end

local Flags = {}
local MAIN_COLOR = color1
local SECONDARY_COLOR = color2
local ACCENT_COLOR = color3
local DURATION = 3.5

local CONFIG = {
    lastUpdated = 'Nov 8, 2025',
    loadingMessages = {
        'Initializing systems...',
        'Loading assets...',
        'Bypassing Anticheat...',
        'Almost ready...',
        'Configuring' .. scriptname,
        'Setting up environment...',
    },
    executorUsed = (function()
        return (identifyexecutor and identifyexecutor()) or 'Unknown'
    end)(),
}

local Utilities = {}

function Utilities.createTween(
    instance,
    properties,
    duration,
    easingStyle,
    easingDirection,
    repeatCount,
    reverses,
    delayTime
)
    local tInfo = TweenInfo.new(
        duration or 1,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out,
        repeatCount or 0,
        reverses or false,
        delayTime or 0
    )
    return TweenService:Create(instance, tInfo, properties)
end

function Utilities.createRoundedFrame(
    name,
    size,
    position,
    bgColor,
    parent,
    anchorPoint,
    cornerRadius
)
    local frame = Instance.new('Frame')
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = bgColor
    frame.BorderSizePixel = 0

    if anchorPoint then
        frame.AnchorPoint = anchorPoint
    end

    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, cornerRadius or 8)
    corner.Parent = frame

    frame.Parent = parent
    return frame
end

function Utilities.createText(
    name,
    text,
    textSize,
    position,
    size,
    textColor,
    parent,
    font,
    anchorPoint
)
    local textLabel = Instance.new('TextLabel')
    textLabel.Name = name
    textLabel.Text = text
    textLabel.TextSize = textSize
    textLabel.Position = position
    textLabel.Size = size
    textLabel.TextColor3 = textColor or SECONDARY_COLOR
    textLabel.Font = font or Enum.Font.GothamSemibold
    textLabel.BackgroundTransparency = 1
    textLabel.TextTransparency = 0

    if anchorPoint then
        textLabel.AnchorPoint = anchorPoint
    end

    textLabel.Parent = parent
    return textLabel
end

local folderName = scriptname
local CurrentConfigName = 'default'
local fileName = 'config.json'

local function SaveConfig()
    if not isfolder(folderName) then
        makefolder(folderName)
    end

    local configToSave = {}
    for _, setting in pairs(Flags) do
        configToSave[setting.Name] = setting.Value
        if setting.Component == 'Toggle' and setting.Keybind then
            configToSave[setting.Name .. '_Key'] = setting.Keybind
        end
    end

    local filePath = folderName .. '/' .. CurrentConfigName .. '.json'
    writefile(filePath, HttpService:JSONEncode(configToSave))
    print('✅ Saved config as', CurrentConfigName)
end

local function LoadConfig()

	if setting.Component == "Toggle" and typeof(setting.Toggle) == "function" then
	    setting:Toggle(val)
	end

    if not CurrentConfigName or CurrentConfigName == '' then
        warn('⚠ No config name selected.')
        return
    end

    local filePath = folderName .. '/' .. CurrentConfigName .. '.json'
    if not isfile(filePath) then
        warn('⚠ Config does not exist:', CurrentConfigName)
        return
    end

    local ok, raw = pcall(readfile, filePath)
    if not ok then
        warn('⚠ Failed to read config:', CurrentConfigName)
        return
    end

    local success, loadedConfig = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not success or typeof(loadedConfig) ~= 'table' then
        warn('⚠ Failed to decode config:', CurrentConfigName)
        return
    end

    for _, setting in pairs(Flags) do
        pcall(function()
            local val = loadedConfig[setting.Name]
            if val ~= nil then
                if setting.Component == 'Toggle' then
                    setting:Toggle(val)
                    local k = loadedConfig[setting.Name .. '_Key']
                    if k then
                        setting.Keybind = k
                        if setting.KeybindUpdate then
                            setting:KeybindUpdate(k)
                        end
                        if
                            setting.ToggleParts and setting.ToggleParts.keybind
                        then
                            setting.ToggleParts.keybind.Text = k
                        end
                    end
                elseif setting.Component == 'Slider' then
                    if setting.SetValue then
                        setting:SetValue(val)
                    else
                        setting.Value = val
                        if setting.SliderParts then
                            local percent = (val - setting.Min)
                                / (setting.Max - setting.Min)
                            percent = math.clamp(percent, 0, 1)
                            Utility.Tween(
                                setting.SliderParts.knob,
                                { Position = UDim2.new(percent, 0, 0.5, 0) },
                                TWEEN_INFO.Fast
                            )
                            Utility.Tween(
                                setting.SliderParts.fill,
                                { Size = UDim2.fromScale(percent, 1) },
                                TWEEN_INFO.Fast
                            )
                            setting.SliderParts.value.Text = tostring(val)
                        end
                        setting.Callback(val)
                    end
                elseif setting.Component == 'Dropdown' then
                    if setting.SetValue then
                        setting:SetValue(val)
                    else
                        setting.Value = val
                        if
                            setting.DropdownParts
                            and setting.DropdownParts.selected
                        then
                            setting.DropdownParts.selected.Text = val
                        end
                        setting.Callback(val)
                    end
                elseif setting.Component == 'TextBox' then
                    setting.Value = val
                    if setting.TextBoxParts and setting.TextBoxParts.input then
                        setting.TextBoxParts.input.Text = val
                    end
                    setting.Callback(val)
                elseif setting.Component == 'ColorPicker' then
                    setting.Value = val
                    if
                        setting.ColorPickerParts
                        and setting.ColorPickerParts.preview
                    then
                        setting.ColorPickerParts.preview.BackgroundColor3 = val
                    end
                    setting.Callback(val)
                end
            end
        end)
    end
    print('✅ Loaded config:', CurrentConfigName)
end

local function RefreshConfigs()
    if not isfolder(folderName) then
        makefolder(folderName)
    end

    local configs = listfiles(folderName)
    local configNames = {}
    for _, file in pairs(configs) do
        if file:sub(-5) == '.json' then
            local configName = file:match('([^/\\]+)%.json$')
            if configName then
                table.insert(configNames, configName)
            end
        end
    end

    if #configNames == 0 then
        Components.Notification({
            Title = 'Config Manager',
            Description = "You don't have any configs saved!",
            Type = 'Error',
            Duration = 3,
        })
        configNames = { 'No saved configs' }
    end

    for _, setting in pairs(Flags) do
        if
            setting.Name == 'Select Config'
            and setting.Component == 'Dropdown'
        then
            setting.Options = configNames
            if setting.DropdownParts and setting.Refresh then
                setting:Refresh(configNames)
                setting.DropdownParts.selected.Text = 'Select Config'
            end
            break
        end
    end
end

local function DeleteConfig()
    if not CurrentConfigName or CurrentConfigName == '' then
        warn('⚠ No config name selected.')
        return
    end

    local filePath = folderName .. '/' .. CurrentConfigName .. '.json'
    if isfile(filePath) then
        delfile(filePath)
        print('🗑️ Deleted config:', CurrentConfigName)
        CurrentConfigName = 'default'
    else
        warn('⚠ Config does not exist:', CurrentConfigName)
    end
end

local TWEEN_INFO = {
    Short = TweenInfo.new(
        0.15,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ),
    Medium = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ),
    Long = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Elastic,
        Enum.EasingDirection.Out
    ),
    Bounce = TweenInfo.new(
        0.8,
        Enum.EasingStyle.Bounce,
        Enum.EasingDirection.Out
    ),
}

local FONTS = {
    Regular = Enum.Font.Gotham,
    Medium = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold,
    Black = Enum.Font.GothamBlack,
    SemiBold = Enum.Font.GothamSemibold,
}

local THEMES = {
    Dark = {
        Primary = {
            Default = Color3.fromRGB(18, 18, 24),
            Light = Color3.fromRGB(24, 24, 32),
            Dark = Color3.fromRGB(15, 15, 20),
        },
        Secondary = {
            Default = Color3.fromRGB(28, 28, 36),
            Light = Color3.fromRGB(35, 35, 45),
            Dark = Color3.fromRGB(22, 22, 28),
        },
        Text = {
            Primary = Color3.fromRGB(240, 240, 255),
            Secondary = Color3.fromRGB(186, 185, 189),
            Tertiary = Color3.fromRGB(130, 130, 140),
        },
        Border = {
            Default = Color3.fromRGB(40, 40, 50),
            Light = Color3.fromRGB(11, 10, 15),
            Dark = Color3.fromRGB(30, 30, 40),
        },
        Background = {
            Default = Color3.fromRGB(18, 18, 24),
            Light = Color3.fromRGB(24, 24, 32),
            Dark = Color3.fromRGB(15, 15, 20),
            Overlay = Color3.fromRGB(0, 0, 0),
        },
    },
}

local CurrentTheme = THEMES.Dark
local ColorAccent = Color3.fromRGB(146, 36, 242)

local Utility = {}

function Utility.Create(className, properties, children)
    local instance = Instance.new(className)

    for property, value in pairs(properties or {}) do
        instance[property] = value
    end

    for _, child in pairs(children or {}) do
        if child then
            child.Parent = instance
        end
    end

    return instance
end

function Utility.Tween(instance, properties, tweenInfo)
    local tween = TweenService:Create(
        instance,
        tweenInfo or TWEEN_INFO.Short,
        properties
    )
    tween:Play()
    return tween
end

function Utility.Ripple(button, rippleColor)
    local ripple = Utility.Create('Frame', {
        Name = 'Ripple',
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = rippleColor or Color3.fromRGB(1, 1, 1),
        BackgroundTransparency = 0.8,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0, 0),
        ZIndex = button.ZIndex + 1,
    })

    local corner = Utility.Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
    })
    corner.Parent = ripple

    ripple.Parent = button

    local targetSize = UDim2.fromScale(1.5, 1.5)
    Utility.Tween(ripple, {
        Size = targetSize,
        BackgroundTransparency = 1,
    }, TWEEN_INFO.Medium)

    Debris:AddItem(ripple, 0.5)
end

function Utility.Shadow(parent, elevation)
    local shadow = Utility.Create('ImageLabel', {
        Name = 'Shadow',
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://1316045217',
        ImageColor3 = CurrentTheme.Background.Overlay,
        ImageTransparency = 0.9,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, elevation * 2, 1, elevation * 2),
        ZIndex = parent.ZIndex - 1,
    })

    shadow.Parent = parent
    return shadow
end

function Utility.Stroke(parent, properties)
    local stroke = Utility.Create('UIStroke', {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = properties.Color or CurrentTheme.Border.Default,
        Thickness = properties.Thickness or 1,
        Transparency = properties.Transparency or 0,
    })

    stroke.Parent = parent
    return stroke
end

function Utility.Corner(parent, radius)
    local corner = Utility.Create('UICorner', {
        CornerRadius = UDim.new(0, radius or 8),
    })

    corner.Parent = parent
    return corner
end

function Utility.List(parent, properties)
    local list = Utility.Create('UIListLayout', {
        Padding = UDim.new(0, properties.Padding or 0),
        FillDirection = properties.Direction or Enum.FillDirection.Vertical,
        HorizontalAlignment = properties.HorizontalAlignment
            or Enum.HorizontalAlignment.Left,
        VerticalAlignment = properties.VerticalAlignment
            or Enum.VerticalAlignment.Top,
        SortOrder = properties.SortOrder or Enum.SortOrder.LayoutOrder,
    })

    list.Parent = parent
    return list
end

function Utility.Padding(parent, padding)
    local isTable = typeof(padding) == 'table'
    local uiPadding = Utility.Create('UIPadding', {
        PaddingTop = UDim.new(
            0,
            isTable and (padding.Top or padding.Y or 0) or padding or 0
        ),
        PaddingBottom = UDim.new(
            0,
            isTable and (padding.Bottom or padding.Y or 0) or padding or 0
        ),
        PaddingLeft = UDim.new(
            0,
            isTable and (padding.Left or padding.X or 0) or padding or 0
        ),
        PaddingRight = UDim.new(
            0,
            isTable and (padding.Right or padding.X or 0) or padding or 0
        ),
    })

    uiPadding.Parent = parent
    return uiPadding
end

local Components = {}
Components._initialized = false

function Components.Window(properties)
    local window = Utility.Create("ScreenGui", {
        Name = properties.Name or "UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    if syn and syn.protect_gui then
        syn.protect_gui(window)
        window.Parent = game:GetService("CoreGui")
    elseif gethui then
        window.Parent = gethui()
    else
        window.Parent = game:GetService("CoreGui")
    end

    local isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").MouseEnabled
    local defaultWidth = isMobile and 533 or 800
    local defaultHeight = isMobile and 333 or 500

    local main = Utility.Create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(8, 7, 8),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(defaultWidth, defaultHeight),
        ClipsDescendants = true
    })

    Utility.Corner(main, 12)
    Utility.Shadow(main, 6)
    Utility.Stroke(main, { Color = Color3.fromRGB(11, 10, 15) })

    main.Parent = window
    return window, main, isMobile
end

function Components.Titlebar(parent, properties)
    local titlebar = Utility.Create("Frame", {
        Name = "Titlebar",
        BackgroundColor3 = Color3.fromRGB(8, 7, 8),
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = 5
    })

    Utility.Corner(titlebar)
    Utility.Stroke(titlebar, { Color = Color3.fromRGB(11, 10, 15) })

    local title = Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Font = FONTS.Bold,
        Position = UDim2.fromOffset(15, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Text = properties.Title or "Window",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    title.Parent = titlebar

    local searchContainer = Utility.Create("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 220, 0, 28),
        ZIndex = 6
    })

    local searchBox = Utility.Create("TextBox", {
        Name = "SearchBox",
        BackgroundColor3 = Color3.fromRGB(11, 10, 15),
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Font = FONTS.Regular,
        Text = "",
        PlaceholderText = "      Search...",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    })
    Utility.Corner(searchBox, 6)

    local searchIcon = Utility.Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = 'rbxassetid://96060641709608',
        ImageColor3 = Color3.fromRGB(84, 84, 84),
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.fromOffset(185, 5),
        ZIndex = 7
    })

    searchIcon.Parent = searchBox
    searchBox.Parent = searchContainer
    searchContainer.Parent = titlebar

    local controls = Utility.Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -100, 0, 0),
        Size = UDim2.new(0, 100, 1, 0),
        ZIndex = 6
    })
    controls.Parent = titlebar

    local closeBtn = Utility.Create("TextButton", {
        Name = "Close",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
        Text = "×",
        TextColor3 = Color3.fromRGB(146, 36, 242),
        TextSize = 22,
        Font = FONTS.Bold,
        ZIndex = 6
    })
    closeBtn.Parent = controls

    local minimizeBtn = Utility.Create("ImageButton", {
        Name = "Minimize",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
        Image = "rbxassetid://6031104681",
        ImageColor3 = Color3.fromRGB(76, 76, 77),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 6
    })
    minimizeBtn.Parent = controls

    local shrinkBtn = Utility.Create("TextButton", {
        Name = "Shrink",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -90, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
        Text = "-",
        TextColor3 = Color3.fromRGB(76, 76, 77),
        TextSize = 22,
        Font = FONTS.Bold,
        ZIndex = 6
    })
    shrinkBtn.Parent = controls

    closeBtn.MouseButton1Click:Connect(function()
        Utility.Tween(parent, {Size = UDim2.fromOffset(0, 0)}, TWEEN_INFO.Medium)
        task.wait(0.3)
        parent.Parent:Destroy()
    end)

    local minimized = false
    local originalSize = parent.Size
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            originalSize = parent.Size
            Utility.Tween(parent, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)}, TWEEN_INFO.Medium)
        else
            Utility.Tween(parent, {Size = originalSize}, TWEEN_INFO.Medium)
        end
    end)

    local shrunk = false
    shrinkBtn.MouseButton1Click:Connect(function()
        shrunk = not shrunk
        Utility.Tween(parent, {
            Size = shrunk and UDim2.new(0, 600, 0, 400) or UDim2.new(0, 800, 0, 500)
        }, TWEEN_INFO.Medium)
    end)

    local dragging = false
    local dragStart, startPos

    titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        for _, setting in pairs(Flags) do
            if setting.ToggleParts and setting.ToggleParts.switch then
                setting.ToggleParts.switch.Parent.Visible = query == "" or setting.Name:lower():find(query)
            elseif setting.SliderParts and setting.SliderParts.fill then
                setting.SliderParts.fill.Parent.Parent.Visible = query == "" or setting.Name:lower():find(query)
            elseif setting.DropdownParts and setting.DropdownParts.selected then
                setting.DropdownParts.selected.Parent.Parent.Visible = query == "" or setting.Name:lower():find(query)
            elseif setting.ButtonParts and setting.ButtonParts.button then
                setting.ButtonParts.button.Parent.Parent.Visible = query == "" or setting.Name:lower():find(query)
            elseif setting.KeybindParts and setting.KeybindParts.button then
                setting.KeybindParts.button.Parent.Parent.Visible = query == "" or setting.Name:lower():find(query)
            elseif setting.TextBoxParts and setting.TextBoxParts.inputHover then
                setting.TextBoxParts.inputHover.Parent.Parent.Visible = query == "" or setting.Name:lower():find(query)
            elseif setting.ColorPickerParts and setting.ColorPickerParts.preview then
                setting.ColorPickerParts.preview.Parent.Parent.Parent.Visible = query == "" or setting.Name:lower():find(query)
            end
        end
    end)

    titlebar.Parent = parent

    return titlebar
end

function Components.Sidebar(parent)
    local sidebar = Utility.Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Color3.fromRGB(8, 7, 8),
        Position = UDim2.fromOffset(0, 40),
        Size = UDim2.new(0, 200, 1, -40)
    })
    Utility.Stroke(sidebar, { Color = Color3.fromRGB(55, 55, 55) })

    local container = Utility.Create("ScrollingFrame", {
        Name = "Container",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        CanvasSize = UDim2.fromScale(0, 0),
        ScrollBarThickness = 0
    })
    Utility.List(container, { Padding = 8 })
    Utility.Padding(container, 12)
    container.Parent = sidebar
    sidebar.Parent = parent

    local function makeDraggable(frame, dragTarget)
        local dragging, dragStart, startPos

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = dragTarget.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                dragTarget.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    makeDraggable(sidebar, parent)

    return sidebar, container
end

Components._tabs = {}

local DEFAULT_TWEEN = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local DEFAULT_TWEEN_ELASTIC = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

function Components.Tab(props)
    local tab = Utility.Create("TextButton", {
        Name = props.Name .. "Tab",
        BackgroundColor3 = Color3.fromRGB(7, 7, 7),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Text = "",
        AutoButtonColor = false,
    })
    Utility.Corner(tab, 6)

    local activeBar = Utility.Create("Frame", {
        Name = "ActiveBar",
        Size = UDim2.new(0, 0, 1, -8),
        Position = UDim2.new(0, 2, 0, 4),
        BackgroundColor3 = ColorAccent,
        Visible = true
    })
    Utility.Corner(activeBar, 2)
    activeBar.Parent = tab

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = props.Icon,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromOffset(10, 8),
        Size = UDim2.fromOffset(20, 20),
        Rotation = 0
    })
    icon.Parent = tab

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Font = FONTS.Regular,
        Position = UDim2.fromOffset(40, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Text = props.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = tab

    table.insert(Components._tabs, tab)

    tab.MouseEnter:Connect(function()
        if not Components._activeTab or Components._activeTab ~= tab then
            TweenService:Create(tab, DEFAULT_TWEEN, {
                BackgroundColor3 = Color3.fromRGB(50, 51, 55)
            }):Play()
        end
    end)

    tab.MouseLeave:Connect(function()
        if not Components._activeTab or Components._activeTab ~= tab then
            TweenService:Create(tab, DEFAULT_TWEEN, {
                BackgroundColor3 = Color3.fromRGB(29, 29, 31)
            }):Play()
        end
    end)

    tab.MouseButton1Click:Connect(function()
        for _, t in pairs(Components._tabs) do
            Components.SetActiveTab(t, t == tab)
        end
        Components._activeTab = tab
        if props.OnActivated then
            props.OnActivated(tab)
        end
    end)

    return tab
end

function Components.UpdateTabColors()
    for _, tab in pairs(Components._tabs) do
        local activeBar = tab:FindFirstChild("ActiveBar")
        local icon      = tab:FindFirstChild("Icon")
        local isActive  = (tab == Components._activeTab)

        if activeBar then
            activeBar.BackgroundColor3 = color1
        end
        if icon then
            icon.ImageColor3 = isActive and ColorAccent or Color3.fromRGB(255, 255, 255)
        end
    end
end

function Components.SetActiveTab(tab, state)
    local bar   = tab:FindFirstChild("ActiveBar")
    local label = tab:FindFirstChild("Label")
    local icon  = tab:FindFirstChild("Icon")

    if not Components._initialized then
        tab.BackgroundColor3      = state and UDim2.new(0,4,1,-8) or UDim2.new(0,0,1,-8)
        bar.Size                  = state and UDim2.new(0,4,1,-8) or UDim2.new(0,0,1,-8)
        label.TextColor3          = state and color1
        icon.ImageColor3          = state and ColorAccent or Color3.fromRGB(255, 255, 255)
        icon.Rotation             = state and 10 or 0

        Components._activeTab = tab
        return
    end

    local tweenInfo = DEFAULT_TWEEN_ELASTIC
    TweenService:Create(tab, tweenInfo, {
        BackgroundColor3 = state and Color3.fromRGB(35,36,40) or Color3.fromRGB(45,46,50),
    }):Play()
    TweenService:Create(bar, tweenInfo, {
        Size = state and UDim2.new(0,4,1,-8) or UDim2.new(0,0,1,-8)
    }):Play()
    TweenService:Create(label, tweenInfo, {
        TextColor3 = state and Color3.fromRGB(1,1,1) or Color3.fromRGB(255, 255, 255)
    }):Play()
    TweenService:Create(icon, tweenInfo, {
        ImageColor3 = state and ColorAccent or Color3.fromRGB(255, 255, 255),
        Rotation    = state and 10 or 0
    }):Play()

    Components._activeTab = tab
end

function Components.Content(parent)
    local content = Utility.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(200, 50),
        Size = UDim2.new(1, -200, 1, -50)
    })

    local container = Utility.Create("ScrollingFrame", {
        Name = "Container",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0
    })

    Utility.List(container, { Padding = 12 })
    Utility.Padding(container, 20)

    container.Parent = content
    content.Parent = parent

    return content, container
end

function Components.Section(properties)
    local section = Utility.Create("Frame", {
        Name = (properties.Name or "Unnamed") .. "Section",
        BackgroundColor3 = Color3.fromRGB(21, 21, 23),
        BackgroundTransparency = 0.2,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })

    Utility.Corner(section, 10)
    local stroke = Utility.Stroke(section, {
        Color = Color3.fromRGB(55, 55, 55),
        Thickness = 1,
        Transparency = 0
    })

    local hover = Utility.Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = true
    })

    Utility.Corner(hover, 10)
    hover.Parent = section

    section.MouseEnter:Connect(function()
        Utility.Tween(section, {
            BackgroundColor3 = Color3.fromRGB(21, 21, 23),
            BackgroundTransparency = 0.15
        }, TWEEN_INFO.Fast)
        Utility.Tween(stroke, {
            Transparency = 0.2
        }, TWEEN_INFO.Fast)
    end)

    section.MouseLeave:Connect(function()
        Utility.Tween(section, {
            BackgroundColor3 = Color3.fromRGB(21, 21, 23),
            BackgroundTransparency = 0.2
        }, TWEEN_INFO.Fast)
        Utility.Tween(stroke, {
            Transparency = 0
        }, TWEEN_INFO.Fast)
    end)

    local header = Utility.Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        LayoutOrder = 0
    })

    local title = Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Font = FONTS.Bold,
        Position = UDim2.fromOffset(15, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Text = properties.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local container = Utility.Create("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 40),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })

    Utility.List(container, { Padding = 10 })
    Utility.Padding(container, { Top = 0, Bottom = 12, Left = 12, Right = 12 })

    title.Parent = header
    header.Parent = section
    container.Parent = section

    return section, container
end

function Components.Toggle(properties)
    local Settings = {
        Name = properties.Name or "Toggle",
        Value = properties.Enabled or false,
        Default = properties.Enabled or false,
        Keybind = properties.Keybind or "None",
        Callback = properties.Callback or function() end,
        Component = "Toggle"
    }

    local toggle = Utility.Create("Frame", {
        Name = properties.Name .. "Toggle",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 44),
        ClipsDescendants = true
    })

    Utility.Corner(toggle, 10)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Font = FONTS.Medium,
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -120, 1, 0),
        Text = properties.Name,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local keybind = Utility.Create("TextLabel", {
        Name = "Keybind",
        BackgroundColor3 = Color3.fromRGB(25, 25, 26),
        BackgroundTransparency = 0.7,
        Position = UDim2.new(1, -110, 0.5, -10),
        Size = UDim2.fromOffset(50, 20),
        Text = Settings.Keybind,
        TextColor3 = CurrentTheme.Text.Secondary,
        TextSize = 12,
        Font = FONTS.SemiBold,
        ZIndex = 2
    })

    Utility.Corner(keybind, 6)

    local switch = Utility.Create("Frame", {
        Name = "Switch",
        BackgroundColor3 = Settings.Value and ColorAccent or CurrentTheme.Primary.Light,
        Position = UDim2.new(1, -54, 0.5, -10),
        Size = UDim2.fromOffset(38, 20),
        ZIndex = 2
    })

    Utility.Corner(switch, 10)

    local knob = Utility.Create("Frame", {
        Name = "Knob",
        BackgroundColor3 = CurrentTheme.Text.Primary,
        Position = Settings.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        ZIndex = 3
    })

    Utility.Corner(knob, 8)

    local hover = Utility.Create("Frame", {
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 1
    })

    Utility.Corner(hover, 10)

    local ripple = Utility.Create("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.7,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 0),
        ZIndex = 1,
        Visible = false
    })

    Utility.Corner(ripple, 100)

    local listeningForKey = false

    function Settings:Toggle(value)
        if value ~= nil then
            Settings.Value = value
        else
            Settings.Value = not Settings.Value
        end

        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.Size = UDim2.fromOffset(0, 0)
        ripple.Visible = true

        Utility.Tween(ripple, {
            Size = UDim2.fromOffset(toggle.AbsoluteSize.X * 1.5, toggle.AbsoluteSize.X * 1.5),
            BackgroundTransparency = 1
        }, TWEEN_INFO.Medium)

        Utility.Tween(knob, {
            Position = Settings.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }, TWEEN_INFO.Bounce)

        Utility.Tween(switch, {
            BackgroundColor3 = Settings.Value and ColorAccent or CurrentTheme.Primary.Light
        }, TWEEN_INFO.Short)

        Settings.Callback(Settings.Value)

        task.delay(0.5, function()
            ripple.Visible = false
        end)
    end

    function Settings:UpdateAccent()
        switch.BackgroundColor3 = Settings.Value and ColorAccent or CurrentTheme.Primary.Light
        ripple.BackgroundColor3 = ColorAccent
        hover.BackgroundColor3 = ColorAccent
        keybind.TextColor3 = listeningForKey and ColorAccent or CurrentTheme.Text.Secondary
    end

    keybind.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            listeningForKey = true
            keybind.Text = "..."
            keybind.TextColor3 = ColorAccent
        end
    end)

    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if listeningForKey then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                Settings.Keybind = input.KeyCode.Name
                keybind.Text = input.KeyCode.Name
                keybind.TextColor3 = CurrentTheme.Text.Secondary
                listeningForKey = false
            end
        elseif input.KeyCode.Name == Settings.Keybind then
            Settings:Toggle()
        end
    end)

    toggle.MouseEnter:Connect(function()
        Utility.Tween(hover, {
            BackgroundTransparency = 0.8
        }, TWEEN_INFO.Fast)
        hover.Visible = true

        Utility.Tween(keybind, {
            BackgroundTransparency = 0.5,
            TextColor3 = CurrentTheme.Text.Primary
        }, TWEEN_INFO.Fast)
    end)

    toggle.MouseLeave:Connect(function()
        Utility.Tween(hover, {
            BackgroundTransparency = 0.9
        }, TWEEN_INFO.Fast)
        hover.Visible = false

        Utility.Tween(keybind, {
            BackgroundTransparency = 0.7,
            TextColor3 = CurrentTheme.Text.Secondary
        }, TWEEN_INFO.Fast)
    end)

    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Settings:Toggle()
        end
    end)

    ripple.Parent = toggle
    hover.Parent = toggle
    knob.Parent = switch
    switch.Parent = toggle
    keybind.Parent = toggle
    label.Parent = toggle

    Settings.ToggleParts = {
        switch = switch,
        ripple = ripple,
        hover = hover,
        knob = knob,
        keybind = keybind
    }
    
    function Settings:KeybindUpdate(newKey)
        if newKey then
            Settings.Keybind = newKey
            keybind.Text = newKey
        end
    end
    
    if not Flags then
        Flags = {}
    end
    table.insert(Flags, Settings)
    
    return toggle, Settings
end

function Components.Slider(properties)
    local Settings = {
        Name = properties.Name or "Slider",
        Value = properties.Value or 0,
        Min = properties.Min or 0,
        Max = properties.Max or 100,
        Callback = properties.Callback or function() end,
        Component = "Slider"
    }

    local slider = Utility.Create("Frame", {
        Name = Settings.Name .. "Slider",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 56),
        ClipsDescendants = true
    })

    Utility.Corner(slider, 10)

    local hover = Utility.Create("Frame", {
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 1,
        Parent = slider
    })

    Utility.Corner(hover, 10)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Font = FONTS.Medium,
        Position = UDim2.fromOffset(16, 8),
        Size = UDim2.new(1, -90, 0, 20),
        Text = Settings.Name,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = slider
    })

    local value = Utility.Create("TextBox", {
        Name = "Value",
        BackgroundTransparency = 1,
        Font = FONTS.SemiBold,
        Position = UDim2.new(1, -70, 0, 8),
        Size = UDim2.fromOffset(54, 20),
        Text = tostring(Settings.Value),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Right,
        ClearTextOnFocus = false,
        TextEditable = true,
        Parent = slider
    })

    local track = Utility.Create("Frame", {
        Name = "Track",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        Position = UDim2.new(0, 16, 0, 38),
        Size = UDim2.new(1, -32, 0, 2),
        Parent = slider
    })

    local fill = Utility.Create("Frame", {
        Name = "Fill",
        BackgroundColor3 = ColorAccent,
        Size = UDim2.fromScale((Settings.Value - Settings.Min) / (Settings.Max - Settings.Min), 1),
        Parent = track
    })

    local knob = Utility.Create("Frame", {
        Name = "Knob",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = CurrentTheme.Text.Primary,
        Position = UDim2.new((Settings.Value - Settings.Min) / (Settings.Max - Settings.Min), 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 12),
        Parent = track
    })

    Utility.Corner(knob, 100)

    local dragging = false

    local function round1(x)
        return tonumber(string.format("%.1f", x))
    end

    local function update(percent)
        local raw = Settings.Min + (Settings.Max - Settings.Min) * percent
        local newVal = round1(raw)

        Utility.Tween(knob, { Position = UDim2.new(percent, 0, 0.5, 0) }, TWEEN_INFO.Fast)
        Utility.Tween(fill, { Size = UDim2.fromScale(percent, 1) }, TWEEN_INFO.Fast)

        value.Text = tostring(newVal)
        Settings.Value = newVal

        if Settings.Callback then
            Settings.Callback(newVal)
        end
    end

    function Settings:SetValue(newValue)
        if typeof(newValue) == "number" then
            Settings.Value = newValue
            local percent = (newValue - Settings.Min) / (Settings.Max - Settings.Min)
            percent = math.clamp(percent, 0, 1)
            
            Utility.Tween(knob, { Position = UDim2.new(percent, 0, 0.5, 0) }, TWEEN_INFO.Fast)
            Utility.Tween(fill, { Size = UDim2.fromScale(percent, 1) }, TWEEN_INFO.Fast)
            value.Text = tostring(newValue)

            if Settings.Callback then
                Settings.Callback(newValue)
            end
        end
    end

    value.FocusLost:Connect(function()
        local num = tonumber(value.Text)
            if num then
                local clamped = math.clamp(num, Settings.Min, Settings.Max)
                local percent = (clamped - Settings.Min) / (Settings.Max - Settings.Min)
                update(percent)
            else
            value.Text = tostring(Settings.Value)
        end
    end)

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            update(percent)
        end
    end)

    slider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            update(percent)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    slider.MouseEnter:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.8 }, TWEEN_INFO.Fast)
        hover.Visible = true
    end)

    slider.MouseLeave:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.9 }, TWEEN_INFO.Fast)
        hover.Visible = false
    end)

    Settings.SliderParts = {
        fill = fill,
        knob = knob,
        value = value,
        hover = hover
    }

    if not Flags then
        Flags = {}
    end
    table.insert(Flags, Settings)

    return slider, Settings
end

function Components.Dropdown(properties)
    local Settings = {
        Name = properties.Name or "Dropdown",
        Options = properties.Options or {},
        Value = properties.Selected or properties.Options[1] or "Select",
        Callback = properties.Callback or function() end,
        Component = "Dropdown"
    }

    local dropdown = Utility.Create("Frame", {
        Name = Settings.Name .. "Dropdown",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 44),
        ClipsDescendants = true
    })

    Utility.Corner(dropdown, 10)

    local header = Utility.Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 44),
        Parent = dropdown
    })

    local hover = Utility.Create("Frame", {
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = header
    })

    Utility.Corner(hover, 10)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Font = FONTS.Medium,
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -70, 1, 0),
        Text = Settings.Name,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    local selected = Utility.Create("TextLabel", {
        Name = "Selected",
        BackgroundTransparency = 1,
        Font = FONTS.SemiBold,
        Position = UDim2.new(1, -160, 0, 0),
        Size = UDim2.fromOffset(110, 44),
        Text = Settings.Value,
        TextColor3 = ColorAccent,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = header
    })

    local arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072706663",
        ImageColor3 = ColorAccent,
        Position = UDim2.new(1, -32, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        Rotation = 0,
        Parent = header
    })

    local container = Utility.Create("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 44),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = dropdown
    })

    Utility.List(container, { Padding = 6 })
    Utility.Padding(container, { Top = 6, Bottom = 10, Left = 10, Right = 10 })

    local expanded = false
    local optionHeight = 0

    local function createOption(name)
        local option = Utility.Create("TextButton", {
            Name = name .. "Option",
            BackgroundColor3 = CurrentTheme.Primary.Light,
            BackgroundTransparency = 0.6,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 5
        })

        Utility.Corner(option, 8)

        local optionHover = Utility.Create("Frame", {
            BackgroundColor3 = ColorAccent,
            BackgroundTransparency = 0.9,
            Size = UDim2.fromScale(1, 1),
            Visible = false,
            ZIndex = 5,
            Parent = option
        })

        Utility.Corner(optionHover, 8)

        local text = Utility.Create("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Font = FONTS.Regular,
            Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Text = name,
            TextColor3 = selected.Text == name and ColorAccent or CurrentTheme.Text.Secondary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
            Parent = option
        })

        local indicator = Utility.Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = ColorAccent,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 3, 1, 0),
            Visible = selected.Text == name,
            ZIndex = 6,
            Parent = option
        })

        Utility.Corner(indicator, 2)

        option.MouseEnter:Connect(function()
            Utility.Tween(optionHover, { BackgroundTransparency = 0.8 }, TWEEN_INFO.Fast)
            optionHover.Visible = true
            Utility.Tween(text, { Position = UDim2.fromOffset(16, 0) }, TWEEN_INFO.Fast)
        end)

        option.MouseLeave:Connect(function()
            Utility.Tween(optionHover, { BackgroundTransparency = 0.9 }, TWEEN_INFO.Fast)
            optionHover.Visible = false
            Utility.Tween(text, { Position = UDim2.fromOffset(12, 0) }, TWEEN_INFO.Fast)
        end)

        option.MouseButton1Click:Connect(function()
            Utility.Tween(selected, {
                TextSize = 17,
                TextColor3 = Color3.fromRGB(
                    math.min(ColorAccent.R * 1.2, 1),
                    math.min(ColorAccent.G * 1.2, 1),
                    math.min(ColorAccent.B * 1.2, 1)
                )
            }, TWEEN_INFO.Fast)
        
            task.delay(0.1, function()
                selected.Text = name
                Settings.Value = name
                Utility.Tween(selected, {
                    TextSize = 15,
                    TextColor3 = ColorAccent
                }, TWEEN_INFO.Fast)
            end)
        
            for _, child in pairs(container:GetChildren()) do
                if child:IsA("TextButton") then
                    local childText = child:FindFirstChild("Text")
                    local childIndicator = child:FindFirstChild("Indicator")
                    if childText and childIndicator then
                        childIndicator.Visible = (child.Name == name .. "Option")
                        Utility.Tween(childText, {
                            TextColor3 = child.Name == name .. "Option" and ColorAccent or CurrentTheme.Text.Secondary
                        }, TWEEN_INFO.Fast)
                    end
                end
            end
        
            expanded = false
        
            Utility.Tween(dropdown, { Size = UDim2.new(1, 0, 0, 44) }, TWEEN_INFO.Medium)
            Utility.Tween(arrow, { Rotation = 0 }, TWEEN_INFO.Medium)
        
            if Settings.Callback then
                Settings.Callback(name)
            end
        end)

        option.Parent = container

        optionHeight = optionHeight + option.Size.Y.Offset + 6
    end

    for _, optionName in pairs(Settings.Options) do
        createOption(optionName)
    end

    header.MouseEnter:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.8 }, TWEEN_INFO.Fast)
        hover.Visible = true
        Utility.Tween(arrow, { Position = UDim2.new(1, -30, 0.5, -8) }, TWEEN_INFO.Fast)
    end)

    header.MouseLeave:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.9 }, TWEEN_INFO.Fast)
        hover.Visible = false
        Utility.Tween(arrow, { Position = UDim2.new(1, -32, 0.5, -8) }, TWEEN_INFO.Fast)
    end)

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            expanded = not expanded

            local ripple = Utility.Create("Frame", {
                Name = "Ripple",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = ColorAccent,
                BackgroundTransparency = 0.7,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(0, 0),
                ZIndex = 2,
                Parent = header
            })

            Utility.Corner(ripple, 100)

            Utility.Tween(ripple, {
                Size = UDim2.fromOffset(dropdown.AbsoluteSize.X * 1.5, dropdown.AbsoluteSize.X * 1.5),
                BackgroundTransparency = 1
            }, TWEEN_INFO.Medium)

            Utility.Tween(dropdown, {
                Size = UDim2.new(1, 0, 0, expanded and (44 + optionHeight) or 44)
            }, TWEEN_INFO.Medium)

            Utility.Tween(arrow, {
                Rotation = expanded and 180 or 0
            }, TWEEN_INFO.Medium)

            task.delay(0.5, function()
                ripple:Destroy()
            end)
        end
    end)

    function Settings:SetValue(value)
        if table.find(Settings.Options, value) then
            Settings.Value = value
            selected.Text = value
            
            for _, child in pairs(container:GetChildren()) do
                if child:IsA("TextButton") then
                    local childText = child:FindFirstChild("Text")
                    local childIndicator = child:FindFirstChild("Indicator")
                    if childText and childIndicator then
                        childIndicator.Visible = (child.Name == value .. "Option")
                        childText.TextColor3 = child.Name == value .. "Option" and ColorAccent or CurrentTheme.Text.Secondary
                    end
                end
            end
            
            if Settings.Callback then
                Settings.Callback(value)
            end
        end
    end

    Settings.DropdownParts = {
        selected = selected,
        arrow = arrow,
        hover = hover,
        container = container
    }

    if not Flags then
        Flags = {}
    end
    table.insert(Flags, Settings)

    return dropdown, Settings
end

function Components.Keybind(properties)
    local Settings = {
        Name = properties.Name or "Keybind",
        Key = properties.Key or "None",
        Value = properties.Key or "None",
        Callback = properties.Callback or function() end,
        Component = "Keybind"
    }

    local keybind = Utility.Create("Frame", {
        Name = Settings.Name .. "Keybind",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 44),
        ClipsDescendants = true
    })

    Utility.Corner(keybind, 10)

    local hover = Utility.Create("Frame", {
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = keybind
    })

    Utility.Corner(hover, 10)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Font = FONTS.Medium,
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -115, 1, 0),
        Text = Settings.Name,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = keybind
    })

    local button = Utility.Create("TextButton", {
        Name = "Button",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        Position = UDim2.new(1, -100, 0.5, -15),
        Size = UDim2.fromOffset(85, 30),
        Text = Settings.Key,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 14,
        Font = FONTS.Medium,
        AutoButtonColor = false,
        Parent = keybind
    })

    Utility.Corner(button, 8)

    local buttonHover = Utility.Create("Frame", {
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = button
    })

    Utility.Corner(buttonHover, 8)

    local listening = false

    keybind.MouseEnter:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.8 }, TWEEN_INFO.Fast)
        hover.Visible = true
    end)

    keybind.MouseLeave:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.9 }, TWEEN_INFO.Fast)
        hover.Visible = false
    end)

    button.MouseEnter:Connect(function()
        Utility.Tween(buttonHover, { BackgroundTransparency = 0.8 }, TWEEN_INFO.Fast)
        buttonHover.Visible = true
        Utility.Tween(button, { Size = UDim2.fromOffset(87, 32), Position = UDim2.new(1, -101, 0.5, -16) }, TWEEN_INFO.Fast)
    end)

    button.MouseLeave:Connect(function()
        Utility.Tween(buttonHover, { BackgroundTransparency = 0.9 }, TWEEN_INFO.Fast)
        buttonHover.Visible = false
        Utility.Tween(button, { Size = UDim2.fromOffset(85, 30), Position = UDim2.new(1, -100, 0.5, -15) }, TWEEN_INFO.Fast)
    end)

    button.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true

        local ripple = Utility.Create("Frame", {
            Name = "Ripple",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = ColorAccent,
            BackgroundTransparency = 0.7,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(0, 0),
            ZIndex = 2,
            Parent = button
        })

        Utility.Corner(ripple, 100)

        Utility.Tween(ripple, {
            Size = UDim2.fromOffset(button.AbsoluteSize.X * 1.5, button.AbsoluteSize.X * 1.5),
            BackgroundTransparency = 1
        }, TWEEN_INFO.Medium)

        button.Text = "..."

        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = input.KeyCode.Name
                button.Text = keyName
                Settings.Key = keyName
                Settings.Value = keyName
                if Settings.Callback then
                    Settings.Callback(input.KeyCode)
                end
                listening = false
                connection:Disconnect()
            end
        end)

        task.delay(0.5, function()
            ripple:Destroy()
        end)
    end)

    function Settings:SetValue(newKey)
        if typeof(newKey) == "string" then
            Settings.Key = newKey
            Settings.Value = newKey
            button.Text = newKey
        end
    end

    Settings.KeybindParts = {
        hover = hover,
        buttonHover = buttonHover,
        button = button
    }

    if not Flags then Flags = {} end
    table.insert(Flags, Settings)

    return keybind, Settings
end

function Components.ColorPicker(properties)
    local Settings = {
        Name = properties.Name or "ColorPicker",
        Color = properties.Color or Color3.fromRGB(1, 1, 1),
        Callback = properties.Callback or function() end,
        Component = "ColorPicker"
    }

    local colorPicker = Utility.Create("Frame", {
        Name = Settings.Name .. "ColorPicker",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 44),
        ClipsDescendants = true
    })

    Utility.Corner(colorPicker, 10)

    local header = Utility.Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 44),
        Parent = colorPicker
    })

    local hover = Utility.Create("Frame", {
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = header
    })

    Utility.Corner(hover, 10)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Font = FONTS.Medium,
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -115, 1, 0),
        Text = Settings.Name,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    local preview = Utility.Create("Frame", {
        Name = "Preview",
        BackgroundColor3 = Settings.Color,
        Position = UDim2.new(1, -100, 0.5, -15),
        Size = UDim2.fromOffset(85, 30),
        Parent = header
    })

    Utility.Corner(preview, 8)

    local container = Utility.Create("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 44),
        Size = UDim2.new(1, 0, 0, 120),
        Parent = colorPicker
    })

    Utility.Padding(container, 12)

    local saturation = Utility.Create("ImageLabel", {
        Name = "Saturation",
        BackgroundColor3 = Settings.Color,
        Size = UDim2.new(1, -60, 1, 0),
        Image = "rbxassetid://4155801252",
        Parent = container
    })

    Utility.Corner(saturation, 8)

    local saturationPicker = Utility.Create("Frame", {
        Name = "Picker",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(1, 1, 1),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.fromOffset(12, 12),
        Parent = saturation
    })

    Utility.Corner(saturationPicker, 100)

    local hue = Utility.Create("ImageLabel", {
        Name = "Hue",
        BackgroundColor3 = Color3.fromRGB(1, 1, 1),
        Position = UDim2.new(1, -48, 0, 0),
        Size = UDim2.new(0, 16, 1, 0),
        Image = "rbxassetid://252684207",
        Parent = container
    })

    Utility.Corner(hue, 8)

    local huePicker = Utility.Create("Frame", {
        Name = "Picker",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(1, 1, 1),
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromOffset(18, 10),
        Parent = hue
    })

    Utility.Corner(huePicker, 100)

    local rgb = Utility.Create("Frame", {
        Name = "RGB",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -24, 0, 0),
        Size = UDim2.new(0, 16, 1, 0),
        Parent = container
    })

    Utility.List(rgb, { Padding = 8 })

    local function createRGBInput(name, value)
        local input = Utility.Create("TextBox", {
            Name = name,
            BackgroundColor3 = CurrentTheme.Primary.Light,
            Size = UDim2.new(1, 0, 0, 16),
            Text = value,
            TextColor3 = CurrentTheme.Text.Primary,
            TextSize = 12,
            Font = FONTS.Medium,
            PlaceholderText = name
        })
        Utility.Corner(input, 4)
        return input
    end

    local r = createRGBInput("R", "255")
    local g = createRGBInput("G", "255")
    local b = createRGBInput("B", "255")

    r.Parent = rgb
    g.Parent = rgb
    b.Parent = rgb

    local draggingSaturation, draggingHue = false, false
    local color = Settings.Color
    local hueValue = 0
    local expanded = false

    local function updateColor()
        local h, s, v = color:ToHSV()
        saturation.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        preview.BackgroundColor3 = color
        r.Text = math.floor(color.R * 255)
        g.Text = math.floor(color.G * 255)
        b.Text = math.floor(color.B * 255)
        if Settings.Callback then
            Settings.Callback(color)
        end
    end

    local function handleRGBInput(input, component)
        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local value = tonumber(input.Text)
                if value then
                    value = math.clamp(value, 0, 255)
                    local newColor = Color3.fromRGB(
                        component == "R" and value / 255 or color.R,
                        component == "G" and value / 255 or color.G,
                        component == "B" and value / 255 or color.B
                    )
                    color = newColor
                    updateColor()
                end
            end
        end)
    end

    handleRGBInput(r, "R")
    handleRGBInput(g, "G")
    handleRGBInput(b, "B")

    colorPicker.MouseEnter:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.8 }, TWEEN_INFO.Fast)
        hover.Visible = true
    end)

    colorPicker.MouseLeave:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.9 }, TWEEN_INFO.Fast)
        hover.Visible = false
    end)

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            expanded = not expanded
            local ripple = Utility.Create("Frame", {
                Name = "Ripple",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = ColorAccent,
                BackgroundTransparency = 0.7,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(0, 0),
                ZIndex = 2,
                Parent = header
            })
            Utility.Corner(ripple, 100)
            Utility.Tween(ripple, { Size = UDim2.fromOffset(colorPicker.AbsoluteSize.X * 1.5, colorPicker.AbsoluteSize.X * 1.5), BackgroundTransparency = 1 }, TWEEN_INFO.Medium)
            Utility.Tween(colorPicker, { Size = UDim2.new(1, 0, 0, expanded and 164 or 44) }, TWEEN_INFO.Medium)
            task.delay(0.5, function() ripple:Destroy() end)
        end
    end)

    saturation.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSaturation = true
            local percentage = Vector2.new(
                math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1),
                math.clamp((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y, 0, 1)
            )
            Utility.Tween(saturationPicker, { Position = UDim2.fromScale(percentage.X, percentage.Y) }, TWEEN_INFO.Fast)
            color = Color3.fromHSV(hueValue, percentage.X, 1 - percentage.Y)
            updateColor()
        end
    end)

    hue.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            local percentage = math.clamp((input.Position.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
            Utility.Tween(huePicker, { Position = UDim2.fromScale(0.5, percentage) }, TWEEN_INFO.Fast)
            hueValue = 1 - percentage
            color = Color3.fromHSV(hueValue, 1, 1)
            updateColor()
        end
    end)

    saturation.InputChanged:Connect(function(input)
        if draggingSaturation and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percentage = Vector2.new(
                math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1),
                math.clamp((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y, 0, 1)
            )
            Utility.Tween(saturationPicker, { Position = UDim2.fromScale(percentage.X, percentage.Y) }, TWEEN_INFO.Fast)
            color = Color3.fromHSV(hueValue, percentage.X, 1 - percentage.Y)
            updateColor()
        end
    end)

    hue.InputChanged:Connect(function(input)
        if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percentage = math.clamp((input.Position.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
            Utility.Tween(huePicker, { Position = UDim2.fromScale(0.5, percentage) }, TWEEN_INFO.Fast)
            hueValue = 1 - percentage
            color = Color3.fromHSV(hueValue, 1, 1)
            updateColor()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSaturation = false
            draggingHue = false
        end
    end)

    Settings.ColorPickerParts = {
        hover = hover,
        preview = preview
    }

    if not Flags then Flags = {} end
    table.insert(Flags, Settings)

    return colorPicker, Settings
end

function Components.TextBox(properties)
    local Settings = {
        Name = properties.Name or "TextBox",
        Value = properties.Value or "",
        Placeholder = properties.Placeholder or "Enter text...",
        Callback = properties.Callback or function() end,
        Component = "TextBox"
    }

    local textbox = Utility.Create("Frame", {
        Name = Settings.Name .. "TextBox",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 44),
        ClipsDescendants = true
    })

    Utility.Corner(textbox, 10)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Font = FONTS.Medium,
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -115, 1, 0),
        Text = Settings.Name,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = textbox
    })

    local input = Utility.Create("TextBox", {
        Name = "Input",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        Position = UDim2.new(1, -100, 0.5, -15),
        Size = UDim2.fromOffset(85, 30),
        Text = Settings.Value,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 14,
        Font = FONTS.Medium,
        PlaceholderText = Settings.Placeholder,
        PlaceholderColor3 = CurrentTheme.Text.Secondary,
        ClearTextOnFocus = false,
        Parent = textbox
    })

    Utility.Corner(input, 8)

    local hover = Utility.Create("Frame", {
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = textbox
    })

    Utility.Corner(hover, 10)

    local inputHover = Utility.Create("Frame", {
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = input
    })

    Utility.Corner(inputHover, 8)

    textbox.MouseEnter:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.8 }, TWEEN_INFO.Fast)
        hover.Visible = true
    end)

    textbox.MouseLeave:Connect(function()
        Utility.Tween(hover, { BackgroundTransparency = 0.9 }, TWEEN_INFO.Fast)
        hover.Visible = false
    end)

    input.MouseEnter:Connect(function()
        Utility.Tween(inputHover, { BackgroundTransparency = 0.8 }, TWEEN_INFO.Fast)
        inputHover.Visible = true
        Utility.Tween(input, {
            Size = UDim2.fromOffset(87, 32),
            Position = UDim2.new(1, -101, 0.5, -16)
        }, TWEEN_INFO.Fast)
    end)

    input.MouseLeave:Connect(function()
        Utility.Tween(inputHover, { BackgroundTransparency = 0.9 }, TWEEN_INFO.Fast)
        inputHover.Visible = false
        if not input:IsFocused() then
            Utility.Tween(input, {
                Size = UDim2.fromOffset(85, 30),
                Position = UDim2.new(1, -100, 0.5, -15)
            }, TWEEN_INFO.Fast)
        end
    end)

    input.Focused:Connect(function()
        Utility.Tween(input, {
            Size = UDim2.fromOffset(87, 32),
            Position = UDim2.new(1, -101, 0.5, -16),
            TextSize = 15
        }, TWEEN_INFO.Fast)
    end)

    input.FocusLost:Connect(function(enterPressed)
        Utility.Tween(input, {
            Size = UDim2.fromOffset(85, 30),
            Position = UDim2.new(1, -100, 0.5, -15),
            TextSize = 14
        }, TWEEN_INFO.Fast)
        if enterPressed and Settings.Callback then
            local ripple = Utility.Create("Frame", {
                Name = "Ripple",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = ColorAccent,
                BackgroundTransparency = 0.7,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(0, 0),
                ZIndex = 2,
                Parent = input
            })
            Utility.Corner(ripple, 100)
            Utility.Tween(ripple, {
                Size = UDim2.fromOffset(input.AbsoluteSize.X * 1.5, input.AbsoluteSize.X * 1.5),
                BackgroundTransparency = 1
            }, TWEEN_INFO.Medium)
            Settings.Callback(input.Text)
            task.delay(0.5, function()
                ripple:Destroy()
            end)
        end
    end)

    Settings.TextBoxParts = {
        hover = hover,
        inputHover = inputHover
    }

    if not Flags then Flags = {} end
    table.insert(Flags, Settings)

    return textbox, Settings
end

function Components.Button(properties)
    local Settings = {
        Name = properties.Name or "Button",
        Text = properties.Text or properties.Name,
        Callback = properties.Callback or function() end,
        Component = "Button"
    }

    local container = Utility.Create("Frame", {
        Name = Settings.Name .. "Container",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
        ClipsDescendants = true
    })

    local shadow = Utility.Create("Frame", {
        Name = "Shadow",
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.8,
        Position = UDim2.fromOffset(0, 4),
        Size = UDim2.new(1, 0, 1, -4),
        ZIndex = 1,
        Parent = container
    })

    Utility.Corner(shadow, 12)

    local button = Utility.Create("TextButton", {
        Name = Settings.Name .. "Button",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        BackgroundTransparency = 0.4,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 1, -4),
        Text = "",
        ZIndex = 2,
        Parent = container
    })

    Utility.Corner(button, 12)

    local stroke = Utility.Create("UIStroke", {
        Color = ColorAccent,
        Transparency = 0.6,
        Thickness = 1.5,
        Parent = button
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Font = FONTS.SemiBold,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Text = Settings.Text,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 15,
        ZIndex = 3,
        Parent = button
    })

    local particles = Utility.Create("Frame", {
        Name = "Particles",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 4,
        Parent = button
    })

    local function createParticle()
        local size = math.random(4, 8)
        local particle = Utility.Create("Frame", {
            BackgroundColor3 = ColorAccent,
            BackgroundTransparency = 0.6,
            Position = UDim2.fromScale(math.random(), 1),
            Size = UDim2.fromOffset(size, size),
            ZIndex = 4,
            Parent = particles
        })

        Utility.Corner(particle, 100)
        
        Utility.Tween(particle, {
            Position = UDim2.new(particle.Position.X.Scale, 0, -0.5, 0),
            BackgroundTransparency = 1,
            Rotation = math.random(-180, 180)
        }, TweenInfo.new(1.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out))
        
        task.delay(1.5, function()
            particle:Destroy()
        end)
    end

    button.MouseEnter:Connect(function()
        Utility.Tween(button, {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(1, 0, 1, -2),
            Position = UDim2.fromOffset(0, 2)
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(shadow, {
            BackgroundTransparency = 0.7,
            Size = UDim2.new(1, 0, 1, -2),
            Position = UDim2.fromOffset(0, 2)
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(stroke, {
            Transparency = 0.3,
            Thickness = 2
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(label, {
            TextSize = 16,
            Position = UDim2.fromOffset(0, -1)
        }, TWEEN_INFO.Fast)

        Utility.Tween(shine, {
            Position = UDim2.fromScale(1.2, 0)
        }, TweenInfo.new(0.5, Enum.EasingStyle.Cubic))
    end)

    button.MouseLeave:Connect(function()
        Utility.Tween(button, {
            BackgroundTransparency = 0.4,
            Size = UDim2.new(1, 0, 1, -4),
            Position = UDim2.fromOffset(0, 0)
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(shadow, {
            BackgroundTransparency = 0.8,
            Size = UDim2.new(1, 0, 1, -4),
            Position = UDim2.fromOffset(0, 4)
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(stroke, {
            Transparency = 0.6,
            Thickness = 1.5
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(label, {
            TextSize = 15,
            Position = UDim2.fromOffset(0, 0)
        }, TWEEN_INFO.Fast)
    end)

    button.MouseButton1Down:Connect(function()
        Utility.Tween(button, {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.fromOffset(0, 4)
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(shadow, {
            BackgroundTransparency = 0.9,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.fromOffset(0, 4)
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(label, {
            TextSize = 14,
            Position = UDim2.fromOffset(0, 2)
        }, TWEEN_INFO.Fast)
    end)

    button.MouseButton1Up:Connect(function()
        Utility.Tween(button, {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(1, 0, 1, -2),
            Position = UDim2.fromOffset(0, 2)
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(shadow, {
            BackgroundTransparency = 0.7,
            Size = UDim2.new(1, 0, 1, -2),
            Position = UDim2.fromOffset(0, 2)
        }, TWEEN_INFO.Fast)
        
        Utility.Tween(label, {
            TextSize = 16,
            Position = UDim2.fromOffset(0, -1)
        }, TWEEN_INFO.Fast)
    end)

    button.MouseButton1Click:Connect(function()
        for i = 1, 8 do
            task.spawn(createParticle)
        end

        if Settings.Callback then
            Settings.Callback()
        end
    end)

    Settings.ButtonParts = {
        container = container,
        button = button,
        shadow = shadow,
        label = label
    }

    if not Flags then Flags = {} end
    table.insert(Flags, Settings)

    return container, Settings
end

function Components.Label(properties)
    local label = Utility.Create("Frame", {
        Name = properties.Name .. "Label",
        BackgroundColor3 = CurrentTheme.Primary.Light,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 44),
        ClipsDescendants = true
    })
    
    Utility.Corner(label, 10)
    
    local text = Utility.Create("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Font = FONTS.Medium,
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -32, 1, 0),
        Text = properties.Text or properties.Name,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    
    local glow = Utility.Create("Frame", {
        Name = "Glow",
        BackgroundColor3 = ColorAccent,
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1, 1),
        Visible = false
    })
    
    Utility.Corner(glow, 10)
    
    label.MouseEnter:Connect(function()
        Utility.Tween(glow, {
            BackgroundTransparency = 0.8
        }, TWEEN_INFO.Fast)
        glow.Visible = true
    end)
    
    label.MouseLeave:Connect(function()
        Utility.Tween(glow, {
            BackgroundTransparency = 0.9
        }, TWEEN_INFO.Fast)
        glow.Visible = false
    end)
    
    glow.Parent = label
    text.Parent = label
    
    return label
end

function Components.Notification(properties)
    local Settings = {
        Title = properties.Title or "Notification",
        Description = properties.Description or "",
        Type = properties.Type or "Info",
        Duration = properties.Duration or 3,
        Component = "Notification"
    }

    local TypeColors = {
        Info = {Background = Color3.fromRGB(59,130,246), Icon = "rbxassetid://7733799825"},
        Success = {Background = Color3.fromRGB(34,197,94), Icon = "rbxassetid://7733799812"},
        Warning = {Background = Color3.fromRGB(245,158,11), Icon = "rbxassetid://7733799798"},
        Error = {Background = Color3.fromRGB(146, 36, 242), Icon = "rbxassetid://7733799777"}
    }

    if not getgenv().NotificationContainer then
        getgenv().NotificationContainer = Utility.Create("Frame", {
            Name = "NotificationContainer",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 360, 1, 0),
            Position = UDim2.new(1, 0, 1, -20),
            AnchorPoint = Vector2.new(1, 1),
            AutomaticSize = Enum.AutomaticSize.Y,
            ClipsDescendants = false,
            ZIndex = 999,
            Parent = gethui and gethui() or game:GetService("CoreGui")
        })

        Utility.List(getgenv().NotificationContainer, {
            Padding = UDim.new(0, 30),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    end

    local colorScheme = TypeColors[Settings.Type]

    local notification = Utility.Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = CurrentTheme.Primary.Dark,
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 340, 0, 80),
        Position = UDim2.new(1, 400, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        ClipsDescendants = true,
        Parent = getgenv().NotificationContainer
    })

    Utility.Corner(notification, 8)

    Utility.Create("Frame", {
        BackgroundColor3 = colorScheme.Background,
        Size = UDim2.new(0, 3, 1, 0),
        Parent = notification
    })

    Utility.Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = colorScheme.Icon,
        ImageColor3 = colorScheme.Background,
        Position = UDim2.fromOffset(16, 16),
        Size = UDim2.fromOffset(24, 24),
        Parent = notification
    })

    Utility.Create("TextLabel", {
        Text = Settings.Title,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(52, 10),
        Size = UDim2.new(1, -70, 0, 20),
        Font = FONTS.Bold,
        TextColor3 = CurrentTheme.Text.Primary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })

    Utility.Create("TextLabel", {
        Text = Settings.Description,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(52, 34),
        Size = UDim2.new(1, -70, 0, 36),
        Font = FONTS.Regular,
        TextColor3 = CurrentTheme.Text.Secondary,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })

    local progressBar = Utility.Create("Frame", {
        BackgroundColor3 = colorScheme.Background,
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, 0, 1, -4),
        Size = UDim2.new(1, 0, 0, 4),
        Parent = notification
    })

    Utility.Tween(notification, {Position = UDim2.new(1, 0, 1, 0)}, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
    Utility.Tween(progressBar, {Size = UDim2.new(0, 0, 0, 4)}, TweenInfo.new(Settings.Duration, Enum.EasingStyle.Linear))

    local function close()
        Utility.Tween(notification, {Position = UDim2.new(1, 400, 1, 0)}, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
        task.delay(0.3, function()
            if notification then
                notification:Destroy()
            end
        end)
    end

    task.delay(Settings.Duration, close)

    return notification
end

local Nova = {}

function Nova:CreateWindow(props)
    props = props or {}

    local window, main, isMobile = Components.Window({
        Name = props.Name or "Nova UI"
    })

    Components.Titlebar(main, {
        Title = props.Title or props.Name or "Nova UI"
    })

    local sidebar, sidebarContainer = Components.Sidebar(main)
    local content, contentContainer = Components.Content(main)

    local WindowAPI = {}

    function WindowAPI:CreateTab(name, icon)
        local tabButton = Components.Tab({
            Name = name,
            Icon = icon
        })
        tabButton.Parent = sidebarContainer

        local container = Utility.Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ScrollBarThickness = 4,
            Visible = false
        })

        local list = Utility.List(container, { Padding = 12 })
		Utility.Padding(container, 12)

		list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		    container.CanvasSize = UDim2.new(
		        0,
		        0,
		        0,
		        list.AbsoluteContentSize.Y + 20
		    )
		end)

        container.Parent = contentContainer

        local TabAPI = {}

        function TabAPI:CreateSection(name)
            local section, sectionContainer = Components.Section({
                Name = name
            })
            section.Parent = container

            local SectionAPI = {}

            function SectionAPI:AddToggle(o)
    local toggle, settings = Components.Toggle(o)
    toggle.Parent = sectionContainer
    return settings
end
            function SectionAPI:AddSlider(o)       local e = Components.Slider(o);       e.Parent = sectionContainer; return e end
            function SectionAPI:AddDropdown(o)     local e = Components.Dropdown(o);     e.Parent = sectionContainer; return e end
            function SectionAPI:AddButton(o)       local e = Components.Button(o);       e.Parent = sectionContainer; return e end
            function SectionAPI:AddTextBox(o)      local e = Components.TextBox(o);      e.Parent = sectionContainer; return e end
            function SectionAPI:AddColorPicker(o)  local e = Components.ColorPicker(o);  e.Parent = sectionContainer; return e end
            function SectionAPI:AddKeybind(o)      local e = Components.Keybind(o);      e.Parent = sectionContainer; return e end
            function SectionAPI:AddLabel(o)        local e = Components.Label(o);        e.Parent = sectionContainer; return e end

            return SectionAPI
        end

        tabButton.MouseButton1Click:Connect(function()
            for _, v in ipairs(contentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            container.Visible = true
        end)

        if #contentContainer:GetChildren() == 1 then
		    container.Visible = true
		end



        return TabAPI
    end

    function WindowAPI:Destroy()
        window:Destroy()
    end

    return WindowAPI
end

return Nova
