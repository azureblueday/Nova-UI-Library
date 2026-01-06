# 📚 NOVA UI LIBRARY v2.0 - COMPLETE DOCUMENTATION

## Dark Theme Roblox UI Library with Purple Accents

---

# 📋 TABLE OF CONTENTS

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Getting Started](#getting-started)
4. [Creating a Window](#creating-a-window)
5. [Creating Tabs](#creating-tabs)
6. [Creating Sections](#creating-sections)
7. [UI Components](#ui-components)
   - [Toggle](#toggle)
   - [Slider](#slider)
   - [Dropdown](#dropdown)
   - [Text Input](#text-input)
   - [Keybind Picker](#keybind-picker)
   - [Color Picker](#color-picker)
   - [Button](#button)
   - [Label](#label)
8. [Notification System](#notification-system)
9. [Config System](#config-system)
10. [Available Icons](#available-icons)
11. [Theme Customization](#theme-customization)
12. [Utility Functions](#utility-functions)
13. [Complete Example](#complete-example)
14. [Tips & Best Practices](#tips--best-practices)
15. [Troubleshooting](#troubleshooting)

---

# 📖 INTRODUCTION

Nova UI Library is a feature-rich, dark-themed Roblox UI library designed for creating 
professional exploit/script GUIs. It features:

- 🎨 Modern dark theme with purple accents
- 📑 Tab-based navigation with Material icons
- 🔄 Smooth animations throughout
- 💾 Built-in config save/load system
- 🔔 Notification system
- 🖱️ Draggable & minimizable window
- ⌨️ Keybind support
- 🎨 Full color picker
- 📱 Clean, responsive design

---

# 📥 INSTALLATION

## Method 1: LoadString (Recommended for Executors)

```lua
local NovaUI = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
```

## Method 2: Local Require (For Studio Testing)

```lua
local NovaUI = require(game.ReplicatedStorage.NovaUILibrary)
```

## Method 3: Direct Script

Copy the entire NovaUILibrary.lua content into your script before using it.

---

# 🚀 GETTING STARTED

Here's the basic structure of a Nova UI script:

```lua
-- 1. Load the library
local NovaUI = loadstring(game:HttpGet("URL"))()

-- 2. Create a window
local Window = NovaUI.new("Window Title", "config_name")

-- 3. Create tabs
local Tab = Window:CreateTab("Tab Name", NovaUI.Icons.home)

-- 4. Create sections within tabs
local Section = Window:CreateSection(Tab, "Section Name")

-- 5. Add UI components to sections
Window:CreateToggle(Section, "Toggle Name", false, function(value)
    print("Toggle:", value)
end, "flag_name")

-- Done! Your UI is ready.
```

---

# 🪟 CREATING A WINDOW

## Syntax

```lua
local Window = NovaUI.new(title, configName)
```

## Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `title` | string | The title shown in the window header | "Nova UI" |
| `configName` | string | Name for the config file (without extension) | "default" |

## Example

```lua
local Window = NovaUI.new("My Script Hub", "myscript_config")
```

## Window Methods

| Method | Description |
|--------|-------------|
| `Window:CreateTab(name, icon)` | Creates a new tab |
| `Window:CreateSection(tab, name)` | Creates a section in a tab |
| `Window:Notify(title, message, type, duration)` | Shows a notification |
| `Window:Destroy()` | Closes and destroys the UI |

---

# 📑 CREATING TABS

Tabs are the main navigation elements in your UI. Each tab can contain multiple sections.

## Syntax

```lua
local Tab = Window:CreateTab(name, icon)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | string | Display name of the tab (shown in tooltip) |
| `icon` | string | Icon URL from NovaUI.Icons |

## Example

```lua
-- Using built-in icons
local HomeTab = Window:CreateTab("Home", NovaUI.Icons.home)
local CombatTab = Window:CreateTab("Combat", NovaUI.Icons.target)
local VisualsTab = Window:CreateTab("Visuals", NovaUI.Icons.visibility)
local MiscTab = Window:CreateTab("Misc", NovaUI.Icons.extension)
local SettingsTab = Window:CreateTab("Settings", NovaUI.Icons.settings)
```

## Notes

- The first tab created is automatically selected
- Tabs appear in the order they are created
- Hovering over a tab shows its name in a tooltip
- A purple indicator shows the currently active tab

---

# 📦 CREATING SECTIONS

Sections are containers that group related UI elements within a tab.

## Syntax

```lua
local Section = Window:CreateSection(tab, name)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `tab` | table | The tab object to add the section to |
| `name` | string | Title of the section |

## Example

```lua
local MainTab = Window:CreateTab("Main", NovaUI.Icons.home)

local FeaturesSection = Window:CreateSection(MainTab, "Features")
local SettingsSection = Window:CreateSection(MainTab, "Settings")
local InfoSection = Window:CreateSection(MainTab, "Information")
```

## Notes

- Sections automatically resize to fit their content
- Sections are scrollable when content exceeds the visible area
- You can have unlimited sections per tab

---

# 🎛️ UI COMPONENTS

## TOGGLE

A switch that can be turned on or off.

### Syntax

```lua
local Toggle = Window:CreateToggle(section, name, default, callback, flag)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `section` | table | The section to add this toggle to |
| `name` | string | Display name of the toggle |
| `default` | boolean | Initial state (true/false) |
| `callback` | function | Function called when toggle changes |
| `flag` | string | Unique identifier for config saving |

### Example

```lua
local GodMode = Window:CreateToggle(Section, "God Mode", false, function(value)
    if value then
        -- Enable god mode
        print("God mode enabled!")
    else
        -- Disable god mode
        print("God mode disabled!")
    end
end, "godmode_toggle")

-- Programmatically change the toggle
GodMode:Set(true)  -- Enable
GodMode:Set(false) -- Disable
```

### Methods

| Method | Description |
|--------|-------------|
| `Toggle:Set(value)` | Sets the toggle state programmatically |

---

## SLIDER

A draggable slider for selecting numeric values.

### Syntax

```lua
local Slider = Window:CreateSlider(section, name, min, max, default, callback, flag)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `section` | table | The section to add this slider to |
| `name` | string | Display name of the slider |
| `min` | number | Minimum value |
| `max` | number | Maximum value |
| `default` | number | Initial value |
| `callback` | function | Function called when value changes |
| `flag` | string | Unique identifier for config saving |

### Example

```lua
local SpeedSlider = Window:CreateSlider(Section, "Walk Speed", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end, "walkspeed_slider")

-- Programmatically change the value
SpeedSlider:Set(100)
```

### Methods

| Method | Description |
|--------|-------------|
| `Slider:Set(value)` | Sets the slider value programmatically |

### Notes

- Values are automatically clamped between min and max
- Values are rounded to whole numbers
- The current value is displayed next to the slider

---

## DROPDOWN

A selection menu with multiple options.

### Syntax

```lua
local Dropdown = Window:CreateDropdown(section, name, options, default, callback, flag)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `section` | table | The section to add this dropdown to |
| `name` | string | Display name of the dropdown |
| `options` | table | Array of option strings |
| `default` | string | Initially selected option |
| `callback` | function | Function called when selection changes |
| `flag` | string | Unique identifier for config saving |

### Example

```lua
local TeamDropdown = Window:CreateDropdown(Section, "Select Team", 
    {"Red Team", "Blue Team", "Green Team", "Yellow Team"}, 
    "Red Team", 
    function(selected)
        print("Selected team:", selected)
    end, 
    "team_dropdown"
)

-- Programmatically change the selection
TeamDropdown:Set("Blue Team")
```

### Methods

| Method | Description |
|--------|-------------|
| `Dropdown:Set(value)` | Sets the selected option programmatically |

### Notes

- Click the dropdown to expand/collapse the options list
- The dropdown automatically closes when an option is selected
- Options are displayed in the order provided

---

## TEXT INPUT

A text field for entering custom text.

### Syntax

```lua
local TextInput = Window:CreateTextInput(section, name, placeholder, default, callback, flag)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `section` | table | The section to add this input to |
| `name` | string | Display name/label |
| `placeholder` | string | Placeholder text when empty |
| `default` | string | Initial text value |
| `callback` | function | Function called when text is submitted |
| `flag` | string | Unique identifier for config saving |

### Example

```lua
local UsernameInput = Window:CreateTextInput(Section, "Target Player", 
    "Enter username...", 
    "", 
    function(text)
        print("Targeting player:", text)
    end, 
    "target_input"
)

-- Programmatically change the text
UsernameInput:Set("PlayerName")
```

### Methods

| Method | Description |
|--------|-------------|
| `TextInput:Set(value)` | Sets the text value programmatically |

### Notes

- The callback is triggered when the user presses Enter or clicks away
- The border glows purple when the input is focused

---

## KEYBIND PICKER

Allows users to set a custom hotkey.

### Syntax

```lua
local Keybind = Window:CreateKeybind(section, name, default, callback, flag)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `section` | table | The section to add this keybind to |
| `name` | string | Display name of the keybind |
| `default` | Enum.KeyCode | Default key |
| `callback` | function | Function called when the key is pressed |
| `flag` | string | Unique identifier for config saving |

### Example

```lua
local FlyKeybind = Window:CreateKeybind(Section, "Toggle Fly", 
    Enum.KeyCode.F, 
    function(key)
        print("Fly toggled! Key:", key.Name)
        -- Toggle fly logic here
    end, 
    "fly_keybind"
)

-- Programmatically change the keybind
FlyKeybind:Set(Enum.KeyCode.G)
```

### Methods

| Method | Description |
|--------|-------------|
| `Keybind:Set(keyCode)` | Sets the keybind programmatically |

### How to Use

1. Click the keybind button
2. The button will show "..."
3. Press any key to set it
4. Click elsewhere to cancel

### Common KeyCodes

```lua
Enum.KeyCode.F           -- F key
Enum.KeyCode.G           -- G key
Enum.KeyCode.LeftControl -- Left Ctrl
Enum.KeyCode.LeftShift   -- Left Shift
Enum.KeyCode.LeftAlt     -- Left Alt
Enum.KeyCode.RightShift  -- Right Shift
Enum.KeyCode.Tab         -- Tab key
Enum.KeyCode.Q           -- Q key
Enum.KeyCode.E           -- E key
```

---

## COLOR PICKER

A full-featured color selection tool.

### Syntax

```lua
local ColorPicker = Window:CreateColorPicker(section, name, default, callback, flag)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `section` | table | The section to add this color picker to |
| `name` | string | Display name |
| `default` | Color3 | Default color |
| `callback` | function | Function called when color changes |
| `flag` | string | Unique identifier for config saving |

### Example

```lua
local ESPColor = Window:CreateColorPicker(Section, "ESP Color", 
    Color3.fromRGB(138, 43, 226), -- Purple
    function(color)
        print("New color:", color)
        -- Apply color to ESP
    end, 
    "esp_color"
)

-- Programmatically change the color
ESPColor:Set(Color3.fromRGB(255, 0, 0)) -- Red
```

### Methods

| Method | Description |
|--------|-------------|
| `ColorPicker:Set(color)` | Sets the color programmatically |

### Features

- **Saturation/Value Picker**: Large square area for selecting saturation and brightness
- **Hue Slider**: Vertical bar for selecting the hue
- **RGB Input**: Direct input field for R, G, B values (format: "255, 128, 0")
- **Color Preview**: Shows the currently selected color

### Notes

- Click the color picker header to expand/collapse
- Colors are saved as RGB values in the config

---

## BUTTON

A clickable button that triggers an action.

### Syntax

```lua
local Button = Window:CreateButton(section, name, callback)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `section` | table | The section to add this button to |
| `name` | string | Button text |
| `callback` | function | Function called when button is clicked |

### Example

```lua
Window:CreateButton(Section, "Kill All Enemies", function()
    -- Your kill all logic here
    Window:Notify("Success", "All enemies eliminated!", "success")
end)

Window:CreateButton(Section, "Reset Character", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

Window:CreateButton(Section, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)
```

### Notes

- Buttons have a ripple animation when clicked
- Buttons have a press animation (slight shrink)
- The entire button is the accent purple color

---

## LABEL

A simple text display element.

### Syntax

```lua
local Label = Window:CreateLabel(section, text)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `section` | table | The section to add this label to |
| `text` | string | The text to display |

### Example

```lua
Window:CreateLabel(Section, "Welcome to My Script!")
Window:CreateLabel(Section, "Version 1.0.0")
Window:CreateLabel(Section, "Made by YourName")
Window:CreateLabel(Section, "───────────────────") -- Separator
```

### Notes

- Labels are styled with muted text color
- Useful for descriptions, credits, or separating groups of elements

---

# 🔔 NOTIFICATION SYSTEM

Display toast-style notifications to provide feedback to users.

## Syntax

```lua
Window:Notify(title, message, type, duration)
```

## Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `title` | string | Notification title | Required |
| `message` | string | Notification message | Required |
| `type` | string | "success", "warning", "error", or "info" | "info" |
| `duration` | number | How long to show (seconds) | 3 |

## Examples

```lua
-- Success notification (green)
Window:Notify("Success!", "Feature enabled successfully.", "success", 3)

-- Warning notification (yellow)
Window:Notify("Warning!", "This feature may cause lag.", "warning", 4)

-- Error notification (red)
Window:Notify("Error!", "Failed to execute script.", "error", 5)

-- Info notification (purple)
Window:Notify("Info", "Press F to toggle fly mode.", "info", 3)
```

## Notification Types

| Type | Color | Icon | Use Case |
|------|-------|------|----------|
| `success` | Green | Checkmark | Successful actions |
| `warning` | Yellow | Warning triangle | Cautionary messages |
| `error` | Red | X circle | Failed actions |
| `info` | Purple | Info circle | General information |

---

# 💾 CONFIG SYSTEM

Nova UI has a built-in configuration system that automatically saves and loads user settings.

## How It Works

1. When you provide a `flag` parameter to a component, its value is tracked
2. Values are automatically loaded when the UI initializes
3. Values persist between game sessions (when using an executor with file system access)

## Automatic Saving

Every component with a `flag` parameter automatically saves its value when changed.

## Manual Save/Load

```lua
-- Save current config
NovaUI.ConfigSystem:Save("my_config")

-- Load a config
NovaUI.ConfigSystem:Load("my_config")

-- Get a specific value
local value = NovaUI.ConfigSystem:Get("category", "key", defaultValue)

-- Set a specific value
NovaUI.ConfigSystem:Set("category", "key", value)
```

## Config File Location

Configs are saved to: `NovaUI/[config_name].json`

## Example: Config Buttons

```lua
local ConfigSection = Window:CreateSection(SettingsTab, "Configuration")

Window:CreateButton(ConfigSection, "Save Config", function()
    NovaUI.ConfigSystem:Save()
    Window:Notify("Saved", "Configuration saved!", "success")
end)

Window:CreateButton(ConfigSection, "Load Config", function()
    NovaUI.ConfigSystem:Load()
    Window:Notify("Loaded", "Configuration loaded!", "success")
end)

Window:CreateButton(ConfigSection, "Reset Config", function()
    NovaUI.ConfigSystem.Configs = {}
    NovaUI.ConfigSystem:Save()
    Window:Notify("Reset", "Configuration reset to defaults!", "warning")
end)
```

## Notes

- Config saving requires an executor with `writefile` and `readfile` functions
- If these functions aren't available, configs are stored in memory only
- Each flag should be unique across your entire UI

---

# 🎨 AVAILABLE ICONS

Nova UI includes a curated set of Material Design icons. Access them via `NovaUI.Icons`.

## Common Icons

```lua
NovaUI.Icons.home           -- Home icon
NovaUI.Icons.settings       -- Gear/settings icon
NovaUI.Icons.person         -- Person icon
NovaUI.Icons.target         -- Crosshair/target icon
NovaUI.Icons.visibility     -- Eye icon (visible)
NovaUI.Icons.visibility_off -- Eye with line (hidden)
NovaUI.Icons.shield         -- Shield icon
NovaUI.Icons.bolt           -- Lightning bolt
NovaUI.Icons.games          -- Game controller
NovaUI.Icons.code           -- Code brackets
NovaUI.Icons.palette        -- Paint palette
NovaUI.Icons.save           -- Save/floppy disk
NovaUI.Icons.folder         -- Folder icon
NovaUI.Icons.close          -- X/close icon
NovaUI.Icons.check          -- Checkmark
NovaUI.Icons.chevron_down   -- Down arrow
NovaUI.Icons.keyboard       -- Keyboard
NovaUI.Icons.search         -- Magnifying glass
NovaUI.Icons.star           -- Star
NovaUI.Icons.favorite       -- Heart
NovaUI.Icons.lock           -- Locked padlock
NovaUI.Icons.lock_open      -- Unlocked padlock
NovaUI.Icons.refresh        -- Refresh arrows
NovaUI.Icons.add            -- Plus sign
NovaUI.Icons.remove         -- Minus sign
NovaUI.Icons.edit           -- Pencil
NovaUI.Icons.delete         -- Trash can
NovaUI.Icons.info           -- Info circle
NovaUI.Icons.warning        -- Warning triangle
NovaUI.Icons.error          -- Error circle
NovaUI.Icons.notifications  -- Bell
NovaUI.Icons.speed          -- Speedometer
NovaUI.Icons.timer          -- Timer/clock
NovaUI.Icons.flight         -- Airplane
NovaUI.Icons.sports         -- Sports ball
NovaUI.Icons.dashboard      -- Dashboard
NovaUI.Icons.analytics      -- Chart
NovaUI.Icons.build          -- Wrench
NovaUI.Icons.extension      -- Puzzle piece
NovaUI.Icons.explore        -- Compass
NovaUI.Icons.bug_report     -- Bug
NovaUI.Icons.sparkle        -- Sparkle effect
```

## Using Custom Icons

You can also use icons directly from the provided icon module:

```lua
-- Direct Roblox asset ID
local customIcon = "http://www.roblox.com/asset/?id=6026568195"
local Tab = Window:CreateTab("Custom", customIcon)
```

---

# 🎨 THEME CUSTOMIZATION

The theme colors are defined in `NovaUI.Theme`. While direct modification isn't recommended,
here's the color structure for reference:

```lua
local Theme = {
    -- Main Colors
    Background = Color3.fromRGB(15, 15, 20),      -- Main background
    Secondary = Color3.fromRGB(22, 22, 30),       -- Secondary panels
    Tertiary = Color3.fromRGB(30, 30, 40),        -- Element backgrounds
    
    -- Accent Colors (Purple)
    Accent = Color3.fromRGB(138, 43, 226),        -- Main accent
    AccentDark = Color3.fromRGB(108, 33, 196),    -- Darker accent
    AccentLight = Color3.fromRGB(168, 73, 255),   -- Lighter accent
    AccentGlow = Color3.fromRGB(168, 85, 247),    -- Glow effect
    
    -- Text Colors
    TextPrimary = Color3.fromRGB(255, 255, 255),  -- Main text
    TextSecondary = Color3.fromRGB(180, 180, 190),-- Secondary text
    TextMuted = Color3.fromRGB(120, 120, 130),    -- Muted/disabled text
    
    -- State Colors
    Success = Color3.fromRGB(34, 197, 94),        -- Green
    Warning = Color3.fromRGB(234, 179, 8),        -- Yellow
    Error = Color3.fromRGB(239, 68, 68),          -- Red
    
    -- Border & Stroke
    Border = Color3.fromRGB(50, 50, 65),          -- Default borders
    BorderAccent = Color3.fromRGB(138, 43, 226),  -- Accent borders
}
```

---

# 🔧 UTILITY FUNCTIONS

Nova UI exposes some utility functions for advanced usage.

## Creating UI Elements

```lua
local element = NovaUI.Utility.Create("Frame", {
    Name = "MyFrame",
    BackgroundColor3 = Color3.new(1, 0, 0),
    Size = UDim2.new(0, 100, 0, 100),
}, {
    -- Children go here
    NovaUI.Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)})
})
element.Parent = someParent
```

## Tweening

```lua
-- Tween any property
NovaUI.Utility.Tween(instance, {
    BackgroundColor3 = Color3.new(1, 0, 0),
    Size = UDim2.new(0, 200, 0, 200),
}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
```

## Ripple Effect

```lua
-- Add ripple effect to any button
NovaUI.Utility.Ripple(button, mouseX, mouseY)
```

## Make Draggable

```lua
-- Make any frame draggable
NovaUI.Utility.MakeDraggable(frame, handleFrame)
```

---

# 📝 COMPLETE EXAMPLE

Here's a full example script demonstrating all features:

```lua
-- ═══════════════════════════════════════════════════════════════
--                    COMPLETE NOVA UI EXAMPLE
-- ═══════════════════════════════════════════════════════════════

-- Load the library
local NovaUI = loadstring(game:HttpGet("YOUR_URL"))()

-- Create the main window
local Window = NovaUI.new("Ultimate Hub", "ultimate_config")

-- ═══════════════════════════════════════════════════════════════
--                         HOME TAB
-- ═══════════════════════════════════════════════════════════════
local HomeTab = Window:CreateTab("Home", NovaUI.Icons.home)

local InfoSection = Window:CreateSection(HomeTab, "Information")
Window:CreateLabel(InfoSection, "Welcome to Ultimate Hub!")
Window:CreateLabel(InfoSection, "Version: 2.0.0")
Window:CreateLabel(InfoSection, "Created with Nova UI Library")

Window:CreateButton(InfoSection, "Join Discord", function()
    setclipboard("https://discord.gg/example")
    Window:Notify("Copied!", "Discord link copied to clipboard.", "success")
end)

-- ═══════════════════════════════════════════════════════════════
--                        COMBAT TAB
-- ═══════════════════════════════════════════════════════════════
local CombatTab = Window:CreateTab("Combat", NovaUI.Icons.target)

local AimbotSection = Window:CreateSection(CombatTab, "Aimbot")

Window:CreateToggle(AimbotSection, "Enable Aimbot", false, function(value)
    _G.AimbotEnabled = value
end, "aimbot_enabled")

Window:CreateSlider(AimbotSection, "FOV Size", 30, 500, 150, function(value)
    _G.AimbotFOV = value
end, "aimbot_fov")

Window:CreateSlider(AimbotSection, "Smoothness", 1, 50, 10, function(value)
    _G.AimbotSmooth = value
end, "aimbot_smooth")

Window:CreateDropdown(AimbotSection, "Target Part", {
    "Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"
}, "Head", function(value)
    _G.AimbotPart = value
end, "aimbot_part")

Window:CreateKeybind(AimbotSection, "Aimbot Key", Enum.KeyCode.Q, function()
    _G.AimbotEnabled = not _G.AimbotEnabled
end, "aimbot_key")

-- ═══════════════════════════════════════════════════════════════
--                        VISUALS TAB
-- ═══════════════════════════════════════════════════════════════
local VisualsTab = Window:CreateTab("Visuals", NovaUI.Icons.visibility)

local ESPSection = Window:CreateSection(VisualsTab, "ESP")

Window:CreateToggle(ESPSection, "Enable ESP", false, function(value)
    _G.ESPEnabled = value
end, "esp_enabled")

Window:CreateToggle(ESPSection, "Box ESP", true, function(value)
    _G.BoxESP = value
end, "esp_box")

Window:CreateToggle(ESPSection, "Name ESP", true, function(value)
    _G.NameESP = value
end, "esp_name")

Window:CreateToggle(ESPSection, "Health Bar", false, function(value)
    _G.HealthESP = value
end, "esp_health")

Window:CreateToggle(ESPSection, "Tracers", false, function(value)
    _G.TracerESP = value
end, "esp_tracers")

local ColorSection = Window:CreateSection(VisualsTab, "Colors")

Window:CreateColorPicker(ColorSection, "Enemy Color", Color3.fromRGB(255, 0, 0), function(color)
    _G.EnemyColor = color
end, "esp_enemy_color")

Window:CreateColorPicker(ColorSection, "Team Color", Color3.fromRGB(0, 255, 0), function(color)
    _G.TeamColor = color
end, "esp_team_color")

-- ═══════════════════════════════════════════════════════════════
--                         MISC TAB
-- ═══════════════════════════════════════════════════════════════
local MiscTab = Window:CreateTab("Misc", NovaUI.Icons.extension)

local MovementSection = Window:CreateSection(MiscTab, "Movement")

Window:CreateSlider(MovementSection, "Walk Speed", 16, 200, 16, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end, "misc_speed")

Window:CreateSlider(MovementSection, "Jump Power", 50, 300, 50, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end, "misc_jump")

Window:CreateToggle(MovementSection, "Infinite Jump", false, function(value)
    _G.InfJump = value
end, "misc_infjump")

Window:CreateToggle(MovementSection, "Noclip", false, function(value)
    _G.Noclip = value
end, "misc_noclip")

local TeleportSection = Window:CreateSection(MiscTab, "Teleport")

Window:CreateTextInput(TeleportSection, "Player Name", "Enter username...", "", function(text)
    _G.TeleportTarget = text
end, "misc_tp_target")

Window:CreateButton(TeleportSection, "Teleport to Player", function()
    local target = game.Players:FindFirstChild(_G.TeleportTarget)
    if target and target.Character then
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(
            target.Character:GetPrimaryPartCFrame()
        )
        Window:Notify("Teleported", "Teleported to " .. target.Name, "success")
    else
        Window:Notify("Error", "Player not found!", "error")
    end
end)

-- ═══════════════════════════════════════════════════════════════
--                       SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════
local SettingsTab = Window:CreateTab("Settings", NovaUI.Icons.settings)

local UISection = Window:CreateSection(SettingsTab, "UI Settings")

Window:CreateKeybind(UISection, "Toggle UI", Enum.KeyCode.RightShift, function()
    Window.ScreenGui.Enabled = not Window.ScreenGui.Enabled
end, "settings_toggle")

local ConfigSection = Window:CreateSection(SettingsTab, "Configuration")

Window:CreateButton(ConfigSection, "Save Config", function()
    NovaUI.ConfigSystem:Save()
    Window:Notify("Saved", "Configuration saved successfully!", "success")
end)

Window:CreateButton(ConfigSection, "Load Config", function()
    NovaUI.ConfigSystem:Load()
    Window:Notify("Loaded", "Configuration loaded successfully!", "success")
end)

Window:CreateButton(ConfigSection, "Destroy UI", function()
    Window:Destroy()
end)

-- ═══════════════════════════════════════════════════════════════
--                      INITIALIZATION
-- ═══════════════════════════════════════════════════════════════

-- Show welcome notification
Window:Notify("Welcome!", "Ultimate Hub loaded successfully!", "success", 5)

-- Print to console
print("Ultimate Hub loaded!")
```

---

# 💡 TIPS & BEST PRACTICES

## 1. Use Meaningful Flags

```lua
-- Good: Descriptive and unique
Window:CreateToggle(Section, "Aimbot", false, callback, "combat_aimbot_enabled")

-- Bad: Vague or could conflict
Window:CreateToggle(Section, "Aimbot", false, callback, "toggle1")
```

## 2. Organize with Sections

Group related features together:

```lua
local AimbotSection = Window:CreateSection(CombatTab, "Aimbot")
-- Aimbot toggles, sliders, etc.

local SilentAimSection = Window:CreateSection(CombatTab, "Silent Aim")
-- Silent aim features

local TriggerBotSection = Window:CreateSection(CombatTab, "Trigger Bot")
-- Trigger bot features
```

## 3. Provide User Feedback

```lua
Window:CreateButton(Section, "Execute", function()
    Window:Notify("Processing", "Please wait...", "info")
    
    -- Do something
    local success = pcall(function()
        -- Your code here
    end)
    
    if success then
        Window:Notify("Success", "Action completed!", "success")
    else
        Window:Notify("Error", "Something went wrong!", "error")
    end
end)
```

## 4. Use Global Variables for State

```lua
_G.Settings = {
    Aimbot = false,
    FOV = 150,
    TargetPart = "Head"
}

Window:CreateToggle(Section, "Aimbot", _G.Settings.Aimbot, function(value)
    _G.Settings.Aimbot = value
end, "aimbot")
```

## 5. Handle Errors Gracefully

```lua
Window:CreateButton(Section, "Teleport", function()
    pcall(function()
        -- Potentially risky code
    end)
end)
```

---

# ❓ TROUBLESHOOTING

## UI Not Appearing

1. Check if the script executed without errors
2. Ensure you're using a compatible executor
3. Try adding `wait(1)` at the start of your script
4. Check if another UI with the same name exists

## Config Not Saving

1. Verify your executor supports `writefile` and `readfile`
2. Check if the flag parameter is provided
3. Ensure the config name doesn't contain invalid characters

## Keybinds Not Working

1. Make sure you're not clicking inside a TextBox
2. Check if `gameProcessed` is being respected
3. Verify the KeyCode is valid

## Animations Laggy

1. Reduce the number of active tweens
2. Avoid creating too many UI elements
3. Consider using simpler animations

## Elements Not Fitting

1. Sections automatically resize, give them time
2. Check if AutomaticCanvasSize is working
3. Ensure parent containers are properly sized

---

# 📄 LICENSE & CREDITS

Nova UI Library is free to use and modify for personal projects.

**Credits:**
- Material Icons by Google
- Inspired by various Roblox UI libraries
- Created for the Roblox scripting community

---

# 📞 SUPPORT

If you encounter issues or have suggestions:

1. Check this documentation thoroughly
2. Review the example scripts
3. Test in a minimal script to isolate issues
4. Report bugs with detailed reproduction steps

---

**Happy Scripting! 🚀**
