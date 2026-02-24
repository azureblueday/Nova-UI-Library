local lib = {}
local ActiveToggles = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local IconModule = {
	Material = {
		["home"] = "http://www.roblox.com/asset/?id=6026568195";
		["home_filled"] = "rbxassetid://9080449299";
		["settings"] = "http://www.roblox.com/asset/?id=6031280882";
		["search"] = "http://www.roblox.com/asset/?id=6031154871";
		["dashboard"] = "http://www.roblox.com/asset/?id=6022668883";
		["code"] = "http://www.roblox.com/asset/?id=6022668955";
		["build"] = "http://www.roblox.com/asset/?id=6023426938";
		["extension"] = "http://www.roblox.com/asset/?id=6023565892";
		["explore"] = "http://www.roblox.com/asset/?id=6023426941";
		["analytics"] = "http://www.roblox.com/asset/?id=6022668884";
		["info"] = "http://www.roblox.com/asset/?id=6026568227";
		["list"] = "http://www.roblox.com/asset/?id=6026568229";
		["favorite"] = "http://www.roblox.com/asset/?id=6023426974";
		["star"] = "http://www.roblox.com/asset/?id=6031068423";
		["lock"] = "http://www.roblox.com/asset/?id=6026568224";
		["visibility"] = "http://www.roblox.com/asset/?id=6031075931";
		["person"] = "http://www.roblox.com/asset/?id=6034287594";
		["shield"] = "http://www.roblox.com/asset/?id=6035078889";
		["bolt"] = "http://www.roblox.com/asset/?id=6035047381";
		["flag"] = "http://www.roblox.com/asset/?id=6035053279";
		["gamepad"] = "http://www.roblox.com/asset/?id=6034789879";
		["sports_esports"] = "http://www.roblox.com/asset/?id=6034227061";
		["lightbulb"] = "http://www.roblox.com/asset/?id=6026568247";
		["fingerprint"] = "http://www.roblox.com/asset/?id=6023565895";
		["bug_report"] = "http://www.roblox.com/asset/?id=6022852107";
		["speed"] = "http://www.roblox.com/asset/?id=6026681578";
		["category"] = "http://www.roblox.com/asset/?id=6034767621";
		["layers"] = "http://www.roblox.com/asset/?id=6034687957";
		["power_settings_new"] = "http://www.roblox.com/asset/?id=6031260781";
		["whatshot"] = "http://www.roblox.com/asset/?id=6034287525";
		["tune"] = "http://www.roblox.com/asset/?id=6031734877";
		["palette"] = "http://www.roblox.com/asset/?id=6034316009";
		["sparkle"] = "http://www.roblox.com/asset/?id=4483362748";
	}
}
lib.Icons = IconModule

-- ═══════════════════════════════════════════════
-- CREATE WINDOW
-- ═══════════════════════════════════════════════
function lib:CreateWindow(cfg)
	if type(cfg) == "string" then cfg = {Title = cfg} end
	local Title = cfg.Title or "Window"
	local Subtitle = cfg.Subtitle or ""
	local WinSize = cfg.Size or UDim2.new(0, 640, 0, 360)
	local HeaderHeight = 38

	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	if isMobile then WinSize = cfg.MobileSize or UDim2.new(0, 420, 0, 260) end
	local miniSize = isMobile and UDim2.new(0, 420, 0, HeaderHeight) or UDim2.new(0, WinSize.X.Offset, 0, HeaderHeight)
	local mobileOffset = isMobile and UDim2.new(0.05, 0, 0.03, 0) or UDim2.new(0.26, 0, 0.18, 0)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PurpleUI_"..Title
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 999999999
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = screenGui
	Main.BackgroundTransparency = 1
	Main.BorderSizePixel = 0
	Main.Position = mobileOffset
	Main.Size = WinSize

	if isMobile then
		local scale = Instance.new("UIScale")
		scale.Scale = 0.7
		scale.Parent = Main
	end

	-- SIDEBAR
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = Main
	Sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Sidebar.BorderSizePixel = 0
	Sidebar.Size = UDim2.new(0, 52, 1, 0)
	Sidebar.ZIndex = 2

	Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

	local SidebarGrad = Instance.new("UIGradient", Sidebar)
	SidebarGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 8, 22)),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(18, 12, 32)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(14, 10, 26)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 7, 18))
	}
	SidebarGrad.Rotation = 180

	local SidebarStroke = Instance.new("UIStroke", Sidebar)
	SidebarStroke.Thickness = 1.8
	local SSG = Instance.new("UIGradient", SidebarStroke)
	SSG.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 12, 55)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 35, 150)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 12, 55))
	}
	SSG.Rotation = 90

	local BrandIcon = Instance.new("ImageLabel")
	BrandIcon.Parent = Sidebar
	BrandIcon.BackgroundTransparency = 1
	BrandIcon.AnchorPoint = Vector2.new(0.5, 0)
	BrandIcon.Position = UDim2.new(0.5, 0, 0, 10)
	BrandIcon.Size = UDim2.new(0, 28, 0, 28)
	BrandIcon.Image = "rbxassetid://114439996739424"
	BrandIcon.ImageColor3 = Color3.fromRGB(160, 90, 255)
	BrandIcon.ZIndex = 3

	local NavScroll = Instance.new("ScrollingFrame")
	NavScroll.Parent = Sidebar
	NavScroll.BackgroundTransparency = 1
	NavScroll.Position = UDim2.new(0, 0, 0, 48)
	NavScroll.Size = UDim2.new(1, 0, 1, -48)
	NavScroll.ScrollBarThickness = 0
	NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	NavScroll.ScrollingEnabled = true
	NavScroll.ZIndex = 3
	NavScroll.BorderSizePixel = 0

	local NavLayout = Instance.new("UIListLayout", NavScroll)
	NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NavLayout.Padding = UDim.new(0, 6)
	Instance.new("UIPadding", NavScroll).PaddingTop = UDim.new(0, 4)

	-- HEADER
	local Header = Instance.new("Frame")
	Header.Name = "Header"
	Header.Parent = Main
	Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Header.BorderSizePixel = 0
	Header.Position = UDim2.new(0, 60, 0, 0)
	Header.Size = UDim2.new(1, -60, 0, HeaderHeight)

	Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

	local HG = Instance.new("UIGradient", Header)
	HG.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 10, 24)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 14, 36)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 8, 20))
	}
	HG.Rotation = 90

	local HS = Instance.new("UIStroke", Header)
	HS.Thickness = 1.8
	local HSG = Instance.new("UIGradient", HS)
	HSG.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 15, 70)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 40, 160)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 15, 70))
	}

	local TitleLabel = Instance.new("TextLabel", Header)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, -75, 0, Subtitle ~= "" and 20 or HeaderHeight)
	TitleLabel.Position = UDim2.new(0, 12, 0, Subtitle ~= "" and 2 or 0)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = Title
	TitleLabel.TextColor3 = Color3.fromRGB(180, 140, 255)
	TitleLabel.TextSize = Subtitle ~= "" and 14 or 16
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	if Subtitle ~= "" then
		local Sub = Instance.new("TextLabel", Header)
		Sub.BackgroundTransparency = 1
		Sub.Size = UDim2.new(1, -75, 0, 14)
		Sub.Position = UDim2.new(0, 12, 0, 21)
		Sub.Font = Enum.Font.Gotham
		Sub.Text = Subtitle
		Sub.TextColor3 = Color3.fromRGB(120, 90, 180)
		Sub.TextSize = 11
		Sub.TextXAlignment = Enum.TextXAlignment.Left
	end

	local CloseBtn = Instance.new("TextButton", Header)
	CloseBtn.Name = "Close"
	CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	CloseBtn.BackgroundTransparency = 0.85
	CloseBtn.Position = UDim2.new(1, -34, 0.5, -10)
	CloseBtn.Size = UDim2.new(0, 20, 0, 20)
	CloseBtn.Text = "X"
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
	CloseBtn.TextSize = 12
	CloseBtn.AutoButtonColor = false
	CloseBtn.ZIndex = 10
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

	local MinBtn = Instance.new("TextButton", Header)
	MinBtn.Name = "Minimize"
	MinBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
	MinBtn.BackgroundTransparency = 0.85
	MinBtn.Position = UDim2.new(1, -60, 0.5, -10)
	MinBtn.Size = UDim2.new(0, 20, 0, 20)
	MinBtn.Text = "-"
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextColor3 = Color3.fromRGB(180, 140, 255)
	MinBtn.TextSize = 16
	MinBtn.AutoButtonColor = false
	MinBtn.ZIndex = 10
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

	-- BODY
	local Body = Instance.new("Frame")
	Body.Name = "Body"
	Body.Parent = Main
	Body.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Body.BorderSizePixel = 0
	Body.Position = UDim2.new(0, 60, 0, HeaderHeight + 6)
	Body.Size = UDim2.new(1, -60, 1, -(HeaderHeight + 6))

	Instance.new("UICorner", Body).CornerRadius = UDim.new(0, 10)

	local BG = Instance.new("UIGradient", Body)
	BG.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 6, 14)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(14, 11, 26)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 8, 18))
	}
	BG.Rotation = 135

	local BS = Instance.new("UIStroke", Body)
	BS.Thickness = 1.8
	local BSG = Instance.new("UIGradient", BS)
	BSG.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 12, 55)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 30, 130)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 12, 55))
	}
	BSG.Rotation = 90

	-- WINDOW CONTROLS
	local bodyVisible = true
	local uiVisible = true

	local function doMinimize()
		bodyVisible = not bodyVisible
		if bodyVisible then
			Body.Visible = true
			Sidebar.Visible = true
			TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = WinSize}):Play()
			MinBtn.Text = "-"
		else
			TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = miniSize}):Play()
			MinBtn.Text = "+"
			task.delay(0.35, function()
				if not bodyVisible then Body.Visible = false; Sidebar.Visible = false end
			end)
		end
	end

	local function toggleUI()
		uiVisible = not uiVisible
		if uiVisible then
			bodyVisible = true
			Body.Visible = true
			Sidebar.Visible = true
			MinBtn.Text = "-"
			Main.Size = WinSize
			Main.Visible = true
		else
			Main.Visible = false
		end
	end

	local minDB = false
	MinBtn.MouseButton1Click:Connect(function()
		if minDB then return end; minDB = true
		doMinimize()
		task.delay(0.4, function() minDB = false end)
	end)

	local closeDB = false
	CloseBtn.MouseButton1Click:Connect(function()
		if closeDB then return end; closeDB = true
		toggleUI()
		task.delay(0.35, function() closeDB = false end)
	end)

	CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play() end)
	CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play() end)
	MinBtn.MouseEnter:Connect(function() TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play() end)
	MinBtn.MouseLeave:Connect(function() TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play() end)

	-- Drag
	local dragging, dragInput, dragStart, startPos
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local p = input.Position
			local cA, cS = CloseBtn.AbsolutePosition, CloseBtn.AbsoluteSize
			local mA, mS = MinBtn.AbsolutePosition, MinBtn.AbsoluteSize
			if p.X >= cA.X and p.X <= cA.X+cS.X and p.Y >= cA.Y and p.Y <= cA.Y+cS.Y then return end
			if p.X >= mA.X and p.X <= mA.X+mS.X and p.Y >= mA.Y and p.Y <= mA.Y+mS.Y then return end
			dragging = true; dragStart = input.Position; startPos = Main.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	Header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local d = input.Position - dragStart
			TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)}):Play()
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if not gp and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftControl then toggleUI() end
	end)

	if isMobile then
		local mt = Instance.new("ImageButton")
		mt.Parent = screenGui; mt.BackgroundColor3 = Color3.fromRGB(20,14,35); mt.BackgroundTransparency = 0.3
		mt.Position = UDim2.new(0,8,0.45,0); mt.Size = UDim2.new(0,32,0,32); mt.Image = "rbxassetid://114439996739424"; mt.AutoButtonColor = false
		Instance.new("UICorner", mt).CornerRadius = UDim.new(1,0)
		local mts = Instance.new("UIStroke", mt); mts.Color = Color3.fromRGB(80,40,140); mts.Thickness = 1.2
		mt.MouseButton1Click:Connect(toggleUI)
	end

	-- TAB SYSTEM
	local Tabs = {}
	local isFirstTab = true

	function lib:CreateTab(name, icon)
		local resolvedIcon
		if type(icon) == "string" and IconModule.Material[icon] then resolvedIcon = IconModule.Material[icon]
		elseif type(icon) == "number" then resolvedIcon = "rbxassetid://" .. icon
		else resolvedIcon = icon or "" end

		local TabBtn = Instance.new("ImageButton")
		TabBtn.Name = name; TabBtn.Parent = NavScroll
		TabBtn.BackgroundColor3 = Color3.fromRGB(255,255,255); TabBtn.BackgroundTransparency = 1
		TabBtn.Size = UDim2.new(0,38,0,38); TabBtn.AutoButtonColor = false; TabBtn.Image = ""; TabBtn.ZIndex = 4

		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
		local TG = Instance.new("UIGradient", TabBtn)
		TG.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(50,20,90)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30,12,55))}
		TG.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.92), NumberSequenceKeypoint.new(1, 0.6)}

		local TS = Instance.new("UIStroke", TabBtn); TS.Thickness = 1.2; TS.Transparency = 1
		local TSG = Instance.new("UIGradient", TS)
		TSG.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(120,60,220)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80,30,160))}

		local TI = Instance.new("ImageLabel", TabBtn)
		TI.BackgroundTransparency = 1; TI.AnchorPoint = Vector2.new(0.5,0.5)
		TI.Position = UDim2.new(0.5,0,0.5,0); TI.Size = UDim2.new(0,22,0,22)
		TI.Image = resolvedIcon; TI.ImageColor3 = Color3.fromRGB(160,100,255); TI.ImageTransparency = 0.5; TI.ZIndex = 5

		local TabItems = Instance.new("ScrollingFrame")
		TabItems.Name = name.."_Items"; TabItems.Parent = Body
		TabItems.BackgroundTransparency = 1; TabItems.Size = UDim2.new(1,0,1,0)
		TabItems.CanvasSize = UDim2.new(0,0,0,0); TabItems.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabItems.ScrollBarThickness = 2; TabItems.ScrollBarImageColor3 = Color3.fromRGB(80,40,140)
		TabItems.BorderSizePixel = 0; TabItems.Visible = false
		TabItems.ClipsDescendants = true

		local IL = Instance.new("UIListLayout", TabItems)
		IL.HorizontalAlignment = Enum.HorizontalAlignment.Center
		IL.SortOrder = Enum.SortOrder.LayoutOrder; IL.Padding = UDim.new(0,6)
		local IP = Instance.new("UIPadding", TabItems)
		IP.PaddingTop = UDim.new(0,5); IP.PaddingBottom = UDim.new(0,10)

		Tabs[TabBtn] = {Items = TabItems, Stroke = TS, Icon = TI, Btn = TabBtn}

		local function selectTab()
			for _, el in pairs(Tabs) do
				local sel = (el.Btn == TabBtn)
				el.Items.Visible = sel
				el.Icon.ImageTransparency = sel and 0 or 0.5
				el.Icon.ImageColor3 = sel and Color3.fromRGB(200,140,255) or Color3.fromRGB(160,100,255)
				el.Stroke.Transparency = sel and 0 or 1
				el.Btn.BackgroundTransparency = sel and 0 or 1
			end
		end

		local tDB = false
		TabBtn.MouseButton1Click:Connect(function()
			if tDB then return end; tDB = true; selectTab(); task.delay(0.2, function() tDB = false end)
		end)

		if isFirstTab then isFirstTab = false; task.defer(selectTab) end
		return TabItems
	end

	-- BUTTON
	function lib:CreateButton(title, parent, tip, callback)
		local Btn = Instance.new("TextButton")
		Btn.Name = "Btn_"..title; Btn.Parent = parent
		Btn.BackgroundColor3 = Color3.fromRGB(255,255,255); Btn.BorderSizePixel = 0
		Btn.Size = UDim2.new(0.97,0,0,36); Btn.Text = ""; Btn.AutoButtonColor = false
		Btn.ClipsDescendants = true

		Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
		local g = Instance.new("UIGradient", Btn)
		g.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(16,12,28)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(22,16,38)),ColorSequenceKeypoint.new(1,Color3.fromRGB(14,10,24))}
		g.Rotation = 45
		local s = Instance.new("UIStroke", Btn); s.Thickness = 1.2
		local sg = Instance.new("UIGradient", s)
		sg.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(35,18,60)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(100,50,180)),ColorSequenceKeypoint.new(1,Color3.fromRGB(35,18,60))}

		local t = Instance.new("TextLabel", Btn)
		t.BackgroundTransparency=1; t.Position=UDim2.new(0,14,0,0); t.Size=UDim2.new(1,-28,1,0)
		t.Font=Enum.Font.GothamMedium; t.Text=title; t.TextColor3=Color3.fromRGB(200,170,255)
		t.TextSize=14; t.TextTransparency=0.25; t.TextXAlignment=Enum.TextXAlignment.Left

		local r = Instance.new("Frame", Btn)
		r.BackgroundColor3=Color3.fromRGB(120,60,220); r.BackgroundTransparency=1; r.Size=UDim2.new(1,0,1,0)
		Instance.new("UICorner", r).CornerRadius = UDim.new(0,8)

		local db = false
		Btn.MouseButton1Click:Connect(function()
			if db then return end; db = true
			if callback then callback() end
			r.BackgroundTransparency = 0.85
			TweenService:Create(r,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
			task.delay(0.2, function() db = false end)
		end)
	end

	-- SEPARATOR
	function lib:CreateLine(parent)
		local h = Instance.new("Frame"); h.Name="Sep"; h.Parent=parent; h.BackgroundTransparency=1; h.Size=UDim2.new(0.97,0,0,8)
		local l = Instance.new("Frame", h)
		l.BackgroundColor3=Color3.fromRGB(255,255,255); l.BorderSizePixel=0
		l.AnchorPoint=Vector2.new(0.5,0.5); l.Position=UDim2.new(0.5,0,0.5,0); l.Size=UDim2.new(0.85,0,0,1)
		local lg = Instance.new("UIGradient", l)
		lg.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(20,10,35)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(100,50,180)),ColorSequenceKeypoint.new(1,Color3.fromRGB(20,10,35))}
	end

	-- TOGGLE
	function lib:CreateToggle(title, parent, default, tip, callback)
		local state = default
		local Toggle = Instance.new("TextButton")
		Toggle.Name = "Tog_"..title; Toggle.Parent = parent
		Toggle.BackgroundColor3 = Color3.fromRGB(255,255,255); Toggle.BorderSizePixel = 0
		Toggle.Size = UDim2.new(0.97,0,0,36); Toggle.Text = ""; Toggle.AutoButtonColor = false
		Toggle.ClipsDescendants = true

		Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,8)
		local tg = Instance.new("UIGradient", Toggle)
		tg.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(16,12,28)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(22,16,38)),ColorSequenceKeypoint.new(1,Color3.fromRGB(14,10,24))}
		tg.Rotation = 45
		local ts = Instance.new("UIStroke", Toggle); ts.Thickness = 1.2
		local tsg = Instance.new("UIGradient", ts)
		tsg.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(35,18,60)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(100,50,180)),ColorSequenceKeypoint.new(1,Color3.fromRGB(35,18,60))}

		local tl = Instance.new("TextLabel", Toggle)
		tl.BackgroundTransparency=1; tl.Position=UDim2.new(0,14,0,0); tl.Size=UDim2.new(0,320,1,0)
		tl.Font=Enum.Font.GothamMedium; tl.Text=title; tl.TextColor3=Color3.fromRGB(200,170,255)
		tl.TextSize=14; tl.TextTransparency=0.5; tl.TextXAlignment=Enum.TextXAlignment.Left

		local Track = Instance.new("Frame", Toggle)
		Track.BackgroundColor3=Color3.fromRGB(25,18,40); Track.Position=UDim2.new(1,-56,0.5,-9); Track.Size=UDim2.new(0,38,0,18)
		Instance.new("UICorner", Track).CornerRadius = UDim.new(1,0)
		local TrackStroke = Instance.new("UIStroke", Track); TrackStroke.Color=Color3.fromRGB(50,25,80); TrackStroke.Thickness=1.2

		local Knob = Instance.new("Frame", Track)
		Knob.BackgroundColor3=Color3.fromRGB(60,30,100); Knob.Position=UDim2.new(0,3,0.5,-6); Knob.Size=UDim2.new(0,12,0,12)
		Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)
		local KnobGlow = Instance.new("UIStroke", Knob); KnobGlow.Color=Color3.fromRGB(60,30,100); KnobGlow.Thickness=1.5

		local function applyVisual(on)
			local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
			if on then
				TweenService:Create(Knob,ti,{Position=UDim2.new(1,-15,0.5,-6),BackgroundColor3=Color3.fromRGB(140,80,240)}):Play()
				TweenService:Create(KnobGlow,ti,{Color=Color3.fromRGB(140,80,240)}):Play()
				TweenService:Create(TrackStroke,ti,{Color=Color3.fromRGB(120,60,220)}):Play()
				TweenService:Create(tl,ti,{TextTransparency=0}):Play()
				TweenService:Create(tsg,ti,{Rotation=180}):Play()
			else
				TweenService:Create(Knob,ti,{Position=UDim2.new(0,3,0.5,-6),BackgroundColor3=Color3.fromRGB(60,30,100)}):Play()
				TweenService:Create(KnobGlow,ti,{Color=Color3.fromRGB(60,30,100)}):Play()
				TweenService:Create(TrackStroke,ti,{Color=Color3.fromRGB(50,25,80)}):Play()
				TweenService:Create(tl,ti,{TextTransparency=0.5}):Play()
				TweenService:Create(tsg,ti,{Rotation=0}):Play()
			end
		end

		local toggleAPI = {}
		function toggleAPI:Set(v) state=v; applyVisual(state); callback(state) end
		function toggleAPI:Get() return state end

		local db = false
		Toggle.MouseButton1Click:Connect(function()
			if db then return end; db = true
			toggleAPI:Set(not state)
			task.delay(0.15, function() db = false end)
		end)

		applyVisual(state)
		ActiveToggles[title] = toggleAPI
		return toggleAPI
	end

	-- INPUT
	function lib:CreateInput(title, parent, tip, callback)
		local Input = Instance.new("TextButton")
		Input.Name="Inp_"..title; Input.Parent=parent
		Input.BackgroundColor3=Color3.fromRGB(255,255,255); Input.BorderSizePixel=0
		Input.Size=UDim2.new(0.97,0,0,36); Input.Text=""; Input.AutoButtonColor=false
		Input.ClipsDescendants = true

		Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
		local g = Instance.new("UIGradient", Input)
		g.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(16,12,28)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(22,16,38)),ColorSequenceKeypoint.new(1,Color3.fromRGB(14,10,24))}
		g.Rotation=45
		local s = Instance.new("UIStroke", Input); s.Thickness=1.2
		local sg = Instance.new("UIGradient", s)
		sg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(35,18,60)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(100,50,180)),ColorSequenceKeypoint.new(1,Color3.fromRGB(35,18,60))}

		local tl = Instance.new("TextLabel", Input)
		tl.BackgroundTransparency=1; tl.Position=UDim2.new(0,14,0,0); tl.Size=UDim2.new(0,280,1,0)
		tl.Font=Enum.Font.GothamMedium; tl.Text=title; tl.TextColor3=Color3.fromRGB(200,170,255)
		tl.TextSize=14; tl.TextTransparency=0.3; tl.TextXAlignment=Enum.TextXAlignment.Left

		local bf = Instance.new("Frame", Input)
		bf.BackgroundTransparency=1; bf.Position=UDim2.new(1,-90,0.5,-11); bf.Size=UDim2.new(0,74,0,22)
		Instance.new("UICorner", bf).CornerRadius = UDim.new(0,6)
		local bfs = Instance.new("UIStroke", bf); bfs.Color=Color3.fromRGB(60,30,100); bfs.Thickness=1.2

		local Box = Instance.new("TextBox", bf)
		Box.BackgroundTransparency=1; Box.Size=UDim2.new(1,0,1,0)
		Box.Font=Enum.Font.GothamMedium; Box.PlaceholderText="..."; Box.PlaceholderColor3=Color3.fromRGB(80,50,130)
		Box.Text=""; Box.TextColor3=Color3.fromRGB(180,140,255); Box.TextSize=13; Box.ClearTextOnFocus=false

		Box.FocusLost:Connect(function(enter) if enter then callback(Box.Text) end end)
	end

	-- DROPDOWN
	function lib:CreateDropdown(title, parent, options, tooltip, callback)
		local Drop = Instance.new("TextButton")
		Drop.Name="Drop_"..title; Drop.Parent=parent
		Drop.BackgroundColor3=Color3.fromRGB(255,255,255); Drop.BorderSizePixel=0
		Drop.Size=UDim2.new(0.97,0,0,36); Drop.Text=""; Drop.AutoButtonColor=false; Drop.ZIndex=3

		Instance.new("UICorner", Drop).CornerRadius = UDim.new(0,8)
		local g = Instance.new("UIGradient", Drop)
		g.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(16,12,28)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(22,16,38)),ColorSequenceKeypoint.new(1,Color3.fromRGB(14,10,24))}
		g.Rotation=45
		local ds = Instance.new("UIStroke", Drop); ds.Thickness=1.2
		local dsg = Instance.new("UIGradient", ds)
		dsg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(35,18,60)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(100,50,180)),ColorSequenceKeypoint.new(1,Color3.fromRGB(35,18,60))}

		local tl = Instance.new("TextLabel", Drop)
		tl.BackgroundTransparency=1; tl.Position=UDim2.new(0,14,0,0); tl.Size=UDim2.new(0,300,1,0)
		tl.Font=Enum.Font.GothamMedium; tl.Text=title; tl.TextColor3=Color3.fromRGB(200,170,255)
		tl.TextSize=14; tl.TextTransparency=0.3; tl.TextXAlignment=Enum.TextXAlignment.Left

		local sel = Instance.new("TextLabel", Drop)
		sel.BackgroundTransparency=1; sel.Position=UDim2.new(1,-80,0,0); sel.Size=UDim2.new(0,65,1,0)
		sel.Font=Enum.Font.GothamMedium; sel.Text=options[1]; sel.TextColor3=Color3.fromRGB(160,100,255)
		sel.TextSize=13; sel.TextTransparency=0.3

		-- Popup parented to Body so it isn't clipped by the row
		local of = Instance.new("Frame", Body)
		of.BackgroundColor3=Color3.fromRGB(14,10,24); of.Size=UDim2.new(0,80,0,0)
		of.Visible=false; of.AutomaticSize=Enum.AutomaticSize.Y; of.ZIndex=20
		Instance.new("UICorner", of).CornerRadius = UDim.new(0,8)
		local ofs = Instance.new("UIStroke", of); ofs.Color=Color3.fromRGB(60,30,100); ofs.Thickness=1.2
		local ofl = Instance.new("UIListLayout", of)
		ofl.HorizontalAlignment=Enum.HorizontalAlignment.Center; ofl.SortOrder=Enum.SortOrder.LayoutOrder; ofl.Padding=UDim.new(0,4)
		local ofp = Instance.new("UIPadding", of); ofp.PaddingBottom=UDim.new(0,6); ofp.PaddingTop=UDim.new(0,6)

		for _, opt in ipairs(options) do
			local ob = Instance.new("TextButton", of)
			ob.BackgroundTransparency=1; ob.Size=UDim2.new(0,70,0,18)
			ob.Font=Enum.Font.GothamMedium; ob.Text=opt; ob.TextColor3=Color3.fromRGB(180,140,255)
			ob.TextSize=13; ob.TextTransparency=0.2; ob.ZIndex=21
			ob.MouseButton1Click:Connect(function() sel.Text=opt; of.Visible=false; callback(opt) end)
		end

		local function updatePopupPosition()
			local abs = Drop.AbsolutePosition
			local bodyAbs = Body.AbsolutePosition
			of.Position = UDim2.new(0, abs.X - bodyAbs.X + Drop.AbsoluteSize.X - 90, 0, abs.Y - bodyAbs.Y + Drop.AbsoluteSize.Y + 4)
		end

		local db = false
		Drop.MouseButton1Click:Connect(function()
			if db then return end; db=true
			updatePopupPosition()
			of.Visible=not of.Visible
			task.delay(0.15, function() db=false end)
		end)
	end

	-- SLIDER
	function lib:CreateSlider(title, parent, min, max, default, prefix, tip, callback)
		local Sld = Instance.new("TextButton")
		Sld.Name="Sld_"..title; Sld.Parent=parent
		Sld.BackgroundColor3=Color3.fromRGB(255,255,255); Sld.BorderSizePixel=0
		Sld.Size=UDim2.new(0.97,0,0,36); Sld.Text=""; Sld.AutoButtonColor=false
		Sld.ClipsDescendants = true

		Instance.new("UICorner", Sld).CornerRadius = UDim.new(0,8)
		local g = Instance.new("UIGradient", Sld)
		g.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(16,12,28)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(22,16,38)),ColorSequenceKeypoint.new(1,Color3.fromRGB(14,10,24))}
		g.Rotation=45
		local ss = Instance.new("UIStroke", Sld); ss.Thickness=1.2
		local ssg = Instance.new("UIGradient", ss)
		ssg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(35,18,60)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(100,50,180)),ColorSequenceKeypoint.new(1,Color3.fromRGB(35,18,60))}

		local tl = Instance.new("TextLabel", Sld)
		tl.BackgroundTransparency=1; tl.Position=UDim2.new(0,14,0,0); tl.Size=UDim2.new(0,140,1,0)
		tl.Font=Enum.Font.GothamMedium; tl.Text=title; tl.TextColor3=Color3.fromRGB(200,170,255)
		tl.TextSize=14; tl.TextTransparency=0.3; tl.TextXAlignment=Enum.TextXAlignment.Left

		local vl = Instance.new("TextBox", Sld)
		vl.BackgroundTransparency=1; vl.Position=UDim2.new(1,-65,0,0); vl.Size=UDim2.new(0,50,1,0)
		vl.Font=Enum.Font.GothamMedium; vl.Text=default.." "..prefix; vl.TextColor3=Color3.fromRGB(160,100,255)
		vl.TextSize=13; vl.TextTransparency=0.3

		local tb = Instance.new("Frame", Sld)
		tb.BackgroundColor3=Color3.fromRGB(25,18,40); tb.Position=UDim2.new(0,150,0.5,-3); tb.Size=UDim2.new(0,160,0,6)
		Instance.new("UICorner", tb).CornerRadius = UDim.new(1,0)

		local tf = Instance.new("Frame", tb)
		tf.BackgroundColor3=Color3.fromRGB(255,255,255); tf.Size=UDim2.new(0,0,1,0)
		Instance.new("UICorner", tf).CornerRadius = UDim.new(1,0)
		local fg = Instance.new("UIGradient", tf)
		fg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(80,30,160)),ColorSequenceKeypoint.new(1,Color3.fromRGB(160,80,255))}

		local h = Instance.new("Frame", tf)
		h.BackgroundColor3=Color3.fromRGB(140,80,240); h.AnchorPoint=Vector2.new(0.5,0.5)
		h.Position=UDim2.new(1,0,0.5,0); h.Size=UDim2.new(0,12,0,12)
		Instance.new("UICorner", h).CornerRadius = UDim.new(1,0)
		local hg = Instance.new("UIStroke", h); hg.Color=Color3.fromRGB(120,60,220); hg.Thickness=2

		local cur = default
		local isDrag = false

		local function upd()
			local pct = math.clamp((cur-min)/(max-min),0,1)
			vl.Text = string.format("%.1f %s", cur, prefix)
			TweenService:Create(tf,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Size=UDim2.new(pct,0,1,0)}):Play()
			callback(cur)
		end

		Sld.MouseButton1Down:Connect(function() isDrag = true end)
		UserInputService.InputChanged:Connect(function(input)
			if not isDrag then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local pct = math.clamp((input.Position.X - tb.AbsolutePosition.X) / tb.AbsoluteSize.X, 0, 1)
				cur = math.round((min + pct*(max-min))*10)/10
				upd()
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDrag = false end
		end)
		vl.FocusLost:Connect(function()
			local n = tonumber(vl.Text)
			if n then cur = math.clamp(n,min,max); upd() end
		end)
		upd()
	end

	return lib
end

-- TOGGLE HELPERS
function lib:GetToggle(name) return ActiveToggles[name] end
function lib:SetToggle(name, state) local t = ActiveToggles[name]; if t then t:Set(state) end end

function lib:ListenToggle(nameA, nameB)
	local function hook(src, dst)
		local t = ActiveToggles[src]
		if not t then return end
		t._linkedOff = t._linkedOff or {}
		table.insert(t._linkedOff, dst)
		if not t._hooked then
			t._hooked = true
			local baseSet = t.Set
			t.Set = function(self, newState)
				baseSet(self, newState)
				if newState == true then
					for _, other in ipairs(self._linkedOff) do
						local o = ActiveToggles[other]
						if o and o:Get() == true then o:Set(false) end
					end
				end
			end
		end
	end
	hook(nameA, nameB); hook(nameB, nameA)
end

function lib:LinkToggles(names)
	for i, a in ipairs(names) do
		for j, b in ipairs(names) do
			if i ~= j then lib:ListenToggle(a, b) end
		end
	end
end

return lib
