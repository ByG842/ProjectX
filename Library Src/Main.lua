local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local httpService = game:GetService("HttpService")

local Mobile = not RunService:IsStudio() and table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform()) ~= nil

local fischbypass = false

if game.GameId == 5750914919 then
	fischbypass = true
end

local RenderStepped = RunService.RenderStepped

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

-- ====== ใส่ URL ของแต่ละไฟล์ตรงนี้ (โฮสต์บน GitHub raw / Pastebin ฯลฯ) ======
local BASE_URL = "https://raw.githubusercontent.com/USERNAME/REPO/main/"

local function fetch(path)
	return loadstring(game:HttpGet(BASE_URL .. path))
end

local Icons = fetch("Icons.lua")()
local Themes, StyleThemes = fetch("Themes.lua")()
local Creator, Library = fetch("Creator.lua")(Themes, StyleThemes)
local Components = fetch("Components.lua")(Creator, Library, Mobile)
local Elements, ElementsTable = fetch("Elements.lua")(Components, Library)
local SaveManager, InterfaceManager = fetch("Managers.lua")(Library, Mobile)

local New = Creator.New

function Library:GetIcon(Name)
	if Name ~= nil and Icons["lucide-" .. Name] then
		return Icons["lucide-" .. Name]
	end
	return nil
end

Library.CreateWindow = function(self, Config)

	assert(Config.Title, "Window - Missing Title")

	if Library.Window then

		print("You cannot create more than one window.")

		return

	end

	Library.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.RightControl

	Library.UseAcrylic = Config.Acrylic or false

	Library.Acrylic = Config.Acrylic or false

	Library.Theme = Config.Theme or "Dark"

	local userProvidedBackgroundImage = (Config.BackgroundImage ~= nil)

	if Config.BackgroundImage == nil then
		if Config.Theme == "Minecraft" then
			Config.BackgroundImage = "rbxassetid://127892835920326"
		else
			Config.BackgroundImage = "rbxassetid://13196113628"
		end
	end

	if Config.BackgroundTransparency == nil then
		Config.BackgroundTransparency = 0.5
	end

	if Config.BackgroundImageTransparency == nil and Config.Theme == "Minecraft" then
		Config.BackgroundImageTransparency = 0.08 -- เท็กซ์เจอร์ชัด/ทึบกว่าเดิม
	end

	if Config.Acrylic then

		Acrylic.init()

	end

	local Icon = Config.Icon

	if not fischbypass then 

		if Library:GetIcon(Icon) then

			Icon = Library:GetIcon(Icon)

		end

		if Icon == "" or Icon == nil then

			Icon = nil

		end

	end

	local Window = Components.Window({
		Parent = GUI,

		Size = Config.Size,

		Title = Config.Title,

		Icon = Icon,

		Image = Config.Image,

		Theme = Config.Theme,

		ManagedBackgroundImage = not userProvidedBackgroundImage,

		BackgroundImage = Config.BackgroundImage,

		BackgroundTransparency = Config.BackgroundTransparency,

		BackgroundImageTransparency = Config.BackgroundImageTransparency,

		SubTitle = Config.SubTitle,

		Discord = Config.Discord,

		TabWidth = Config.TabWidth,

		DropdownsOutsideWindow = Config.DropdownsOutsideWindow,

		Search = Config.Search,

		UserInfoTitle = Config.UserInfoTitle,

		UserInfo = Config.UserInfo,

		UserInfoTop = Config.UserInfoTop,

		UserInfoSubtitle = Config.UserInfoSubtitle,

		UserInfoSubtitleColor = Config.UserInfoSubtitleColor,
	})

	Library.Window = Window

	table.insert(Library.Windows, Window)

	InterfaceManager:SetTheme(Config.Theme)

	Library:SetTheme(Config.Theme, true)

	return Window

end

function Library:CreateMinimizer(Config)
	Config = Config or {}
	if self.Minimizer and self.Minimizer.Parent then
		return self.Minimizer
	end

	local parentGui = Library.GUI or GUI
	if parentGui then parentGui.DisplayOrder = 1000 end
	local isMobile = Mobile and true or false

	local iconAsset = "rbxassetid://10734897102"
	if type(Config.Icon) == "string" and Config.Icon ~= "" then
		pcall(function()
			local resolved = Library:GetIcon(Config.Icon)
			if resolved then
				iconAsset = resolved
			elseif string.match(Config.Icon, "^rbxassetid://%d+$") then
				iconAsset = Config.Icon
			end
		end)
	end

	local useAcrylic = (Config.Acrylic == true)
	local draggableWhole = (Config.Draggable == true)

	local holder
	local function createButton(isDesktop)
		return New("TextButton", {
			Name = "MinimizeButton",
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1, -- ลบพื้นหลังออก 100%
			AutoButtonColor = false,
		}, {
			New("ImageLabel", {
				Name = "Icon",
				Image = iconAsset,
				Size = UDim2.new(0.85, 0, 0.85, 0), -- ขนาดรูป
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				-- ถ้าไอคอนมีพื้นหลังติดมาด้วย บรรทัดนี้จะทำให้พื้นหลังถูกตัดขอบ
				ClipsDescendants = true, 
				ThemeTag = {
					ImageColor3 = "Text",
				},
			}, {
				New("UIAspectRatioConstraint", { AspectRatio = 1, AspectType = Enum.AspectType.FitWithinMaxSize }),
				
				-- [เพิ่มตรงนี้] ทำให้ขอบของไอคอนมนขึ้น
				-- ถ้าอยากให้กลมดิ๊กเป็นวงกลมเลย ให้แก้เป็น UDim.new(1, 0)
				-- ถ้าอยากให้มนน้อยลง ให้แก้เป็น UDim.new(0.15, 0)
				New("UICorner", { CornerRadius = UDim.new(0.25, 0) }) 
			}),
		})
	end

	if isMobile then
		holder = New("Frame", {
			Name = "FluentMinimizer",
			Parent = parentGui,
			Size = Config.Size or UDim2.fromOffset(40, 40),
			Position = Config.Position or UDim2.new(0.45, 0, 0.025, 0),
			BackgroundTransparency = 1,
			ZIndex = 999999999,
			Visible = (Config.Visible ~= false),
		})
	else
		holder = New("Frame", {
			Name = "FluentMinimizer",
			Parent = parentGui,
			Size = Config.Size or UDim2.fromOffset(40, 40),
			Position = Config.Position or UDim2.new(0, 300, 0, 20),
			BackgroundTransparency = 1,
			ZIndex = 999999999,
			Visible = (Config.Visible ~= false),
		})
	end

	-- ปิดระบบ Acrylic ไปเลยถ้าพื้นหลังใสแล้ว จะได้ไม่กินสเปค
	if useAcrylic then
		pcall(function()
			-- เราจะไม่สร้าง AcrylicPaint แล้ว เพื่อให้ปุ่มดูใส 100% ลอยๆ จริงๆ
		end)
	end

	local btnInstance = createButton(not isMobile)
	btnInstance.Parent = holder
	btnInstance.ZIndex = (holder.ZIndex or 0) + 1

	local button = holder:FindFirstChildOfClass("TextButton")
	if button then
		local isDragging = false
		local dragStart, dragOffset

		if draggableWhole then
			Creator.AddSignal(button.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					isDragging = true
					local pos = Input.Position
					dragStart = Vector2.new(pos.X, pos.Y)
					dragOffset = holder.Position
					local conn
					conn = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							isDragging = false
							dragStart = nil
							dragOffset = nil
							conn:Disconnect()
						end
					end)
				end
			end)

			Creator.AddSignal(RunService.Heartbeat, function()
				if isDragging and dragStart and dragOffset and holder and holder.Parent then
					local mouse = LocalPlayer:GetMouse()
					local current = Vector2.new(mouse.X, mouse.Y)
					local delta = current - dragStart
					local newX = dragOffset.X.Offset + delta.X
					local newY = dragOffset.Y.Offset + delta.Y
					local viewport = workspace.Camera.ViewportSize
					local size = holder.AbsoluteSize
					if newX < 0 then newX = 0 end
					if newY < 0 then newY = 0 end
					if newX > viewport.X - size.X then newX = viewport.X - size.X end
					if newY > viewport.Y - size.Y then newY = viewport.Y - size.Y end
					holder.Position = UDim2.new(0, newX, 0, newY)
				end
			end)
		end

		AddSignal(button.MouseButton1Click, function()
			task.wait(0.1)
			if not isDragging and Library.Window then
				Library.Window:Minimize()
			end
		end)
	end

	self.Minimizer = holder
	return holder
end

function Library:SetTheme(Value, Instant)

	if Library.Window and (table.find(Library.Themes, Value) or Themes[Value]) then

		Library.Theme = Value

		-- auto-apply style ที่ผูกอยู่กับ theme นี้
		local theme = Themes[Value]
		local styleName = (theme and theme.StyleOverride) or "Default"
		ApplyStyle(styleName)

		-- ถ้า background image เป็นแบบ auto (ไม่ได้ระบุเอง) ให้สลับตาม theme ด้วย
		local Window = Library.Window
		local isMinecraft = (Value == "Minecraft")
		if Window and Window.ManagedBackgroundImage and Window.BackgroundImage then
			local newImage = isMinecraft and "rbxassetid://127892835920326" or "rbxassetid://13196113628"
			Window.BackgroundImage.Image = newImage
			Window.BackgroundImage.ScaleType = Enum.ScaleType.Stretch
			Window.BackgroundImage.ImageTransparency = isMinecraft and 0.08 or (Window.BackgroundTransparency or 0.5)
		end

		-- 🧱 อัปเดต notification ที่เปิดค้างอยู่ให้เท็กซ์เจอร์/มุมเหลี่ยม/ฟอนต์/เงา sync ตามธีมที่สลับทันที
		if Library.ActiveNotifications then
			for _, notif in pairs(Library.ActiveNotifications) do
				if notif.RefreshStyle then notif:RefreshStyle() end
			end
		end

		-- คง cap ความโปร่งใสของ overlay ไว้ (กันบังเท็กซ์เจอร์หมด) แต่ไม่ยัดค่า 3 ทับของผู้ใช้เอง
		-- cap (min 0.35) ถูกจัดการอยู่แล้วใน SetWindowTransparency ตอน Library.Theme == "Minecraft"
		-- แค่ re-apply ค่าปัจจุบันของผู้ใช้ ไม่ force เป็น 3
		Library:SetWindowTransparency(Library.WindowTransparencyValue or (InterfaceManager and InterfaceManager.Settings and InterfaceManager.Settings.WindowTransparency) or 1.5)

		if Instant then
			Creator.UpdateTheme()
		else
			Creator.UpdateThemeAnimated(0.45)
		end

	end

end

-- เปลี่ยน style โดยไม่เปลี่ยนสี (ใช้เองได้)
function Library:SetStyle(styleName)
	if StyleThemes[styleName] then
		ApplyStyle(styleName)
	end
end

function Library:Destroy()

	if Library.Window then

		Library.Unloaded = true

		if Library.UseAcrylic then

			Library.Window.AcrylicPaint.Model:Destroy()

		end

		Creator.Disconnect()

		Library.GUI:Destroy()

	end

end

function Library:ToggleAcrylic(Value)

	if Library.Window then

		if Library.UseAcrylic then

			Library.Acrylic = Value

			if Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Model then

				Library.Window.AcrylicPaint.Model.Transparency = Value and 0.95 or 1

			end

		end

	end

end

function Library:ToggleTransparency(Value)

	if Library.Window then

		Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = Value and 0.35 or 0

	end

end

function Library:SetWindowTransparency(Value)

	if not Library.Window then return end

	Value = math.clamp(Value or 1, 0, 3)

	-- คำนวณ background transparency จาก slider (0=โปร่งใสมาก, 3=ทึบ)
	-- Value 0 → transparency 0.95 (แทบมองไม่เห็น), Value 1.5 → 0.45 (default), Value 3 → 0 (ทึบสนิท)
	local bgTransparency = math.clamp(1 - (Value / 3.2), 0, 0.98)

	-- ธีม Minecraft: ไม่ให้ overlay ทึบจนบังเท็กซ์เจอร์หมด ต่อให้ลากไปสุด (Value = 3)
	if Library.Theme == "Minecraft" then
		bgTransparency = math.max(bgTransparency, 0.35)
	end

	-- ควบคุม AcrylicPaint.Frame.Background (ใช้ได้ทั้ง Acrylic และ non-Acrylic)
	local paint = Library.Window.AcrylicPaint
	if paint and paint.Frame then
		local bg = paint.Frame:FindFirstChild("Background")
		if bg then
			bg.BackgroundTransparency = bgTransparency
		end
		-- ถ้า Acrylic mode ปรับ blur model ด้วย
		if Library.UseAcrylic and paint.Model then
			local modelTransparency = math.clamp(0.94 + (Value * 0.02), 0.94, 0.99)
			paint.Model.Transparency = modelTransparency
		end
	end

	Library.WindowTransparencyValue = Value

end

function Library:Notify(Config)

	return NotificationModule:New(Config)

end

if getgenv then

	getgenv().Fluent = Library

else

	Fluent = Library

end

local MinimizeButton = New("TextButton", {
	BackgroundColor3 = Color3.fromRGB(25, 25, 30),

	Size = UDim2.new(1, 0, 1, 0),

	BorderSizePixel = 0,

	BackgroundTransparency = 0.05, 
}, {
	New("UICorner", {
		CornerRadius = UDim.new(0, 14),
	}),

	New("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),

			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
		},

		Rotation = 45,
	}),

	New("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,

		Color = Color3.fromRGB(100, 150, 255),

		Transparency = 0.6, Thickness = GetStyleProperty("BorderThickness") }),

	New("Frame", {
		BackgroundColor3 = Color3.fromRGB(100, 150, 255),

		BackgroundTransparency = 0.9,

		Size = UDim2.new(1, -6, 1, -6),

		Position = UDim2.new(0, 3, 0, 3),

		BorderSizePixel = 0,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 11),
		}),
	}),

	New("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),

		BackgroundTransparency = 0.94,

		Size = UDim2.new(0.7, 0, 0.3, 0),

		Position = UDim2.new(0.15, 0, 0.1, 0),

		BorderSizePixel = 0,
	}, {
		NewCorner("ElementCorner"),
	}),

	New("ImageLabel", {
		Image = "rbxassetid://10734897102",

		Size = UDim2.new(0.8, 0, 0.8, 0),

		Position = UDim2.new(0.5, 0, 0.5, 0),

		AnchorPoint = Vector2.new(0.5, 0.5),

		BackgroundTransparency = 1,

		ImageColor3 = Color3.fromRGB(255, 255, 255),

		ImageTransparency = 0.1,
	}, {
		New("UIAspectRatioConstraint", {
			AspectRatio = 1,

			AspectType = Enum.AspectType.FitWithinMaxSize,
		})
	})
})

local MobileMinimizeButton = New("TextButton", {
	BackgroundColor3 = Color3.fromRGB(25, 25, 30),

	Size = UDim2.new(1, 0, 1, 0),

	BorderSizePixel = 0,

	BackgroundTransparency = 0.05,
}, {
	NewCorner("WindowCorner"),

	New("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),

			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
		},

		Rotation = 45,
	}),

	New("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,

		Color = Color3.fromRGB(100, 150, 255),

		Transparency = 0.7, Thickness = GetStyleProperty("BorderThickness") }),

	New("Frame", {
		BackgroundColor3 = Color3.fromRGB(100, 150, 255),

		BackgroundTransparency = 0.92,

		Size = UDim2.new(1, -4, 1, -4),

		Position = UDim2.new(0, 2, 0, 2),

		BorderSizePixel = 0,
	}, {
		NewCorner("ElementCorner"),
	}),

	New("ImageLabel", {
		Image = "rbxassetid://10734897102",

		Size = UDim2.new(0.8, 0, 0.8, 0),

		Position = UDim2.new(0.5, 0, 0.5, 0),

		AnchorPoint = Vector2.new(0.5, 0.5),

		BackgroundTransparency = 1,

		ImageColor3 = Color3.fromRGB(255, 255, 255),

		ImageTransparency = 0.1,
	}, {
		New("UIAspectRatioConstraint", {
			AspectRatio = 1,

			AspectType = Enum.AspectType.FitWithinMaxSize,
		})
	})
})

local Minimizer

local isDragging = false

local dragStart = nil

local dragOffset = nil

Creator.AddSignal(MinimizeButton.InputBegan, function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then

		isDragging = true

		dragStart = Vector2.new(Input.Position.X, Input.Position.Y)

		dragOffset = (Library.Minimizer or Minimizer).Position

		local connection

		connection = Input.Changed:Connect(function()

			if Input.UserInputState == Enum.UserInputState.End then

				isDragging = false

				dragStart = nil

				dragOffset = nil

				connection:Disconnect()

			end

		end)

	end

end)

Creator.AddSignal(MobileMinimizeButton.InputBegan, function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

		isDragging = true

		dragStart = Vector2.new(Input.Position.X, Input.Position.Y)

		dragOffset = (Library.Minimizer or Minimizer).Position

		local connection

		connection = Input.Changed:Connect(function()

			if Input.UserInputState == Enum.UserInputState.End then

				isDragging = false

				dragStart = nil

				dragOffset = nil

				connection:Disconnect()

			end

		end)

	end

end)

Creator.AddSignal(RunService.Heartbeat, function()

	local activeMin = Library.Minimizer or Minimizer

	if isDragging and dragStart and dragOffset and activeMin and activeMin.Parent then

		local currentMousePos = UserInputService:GetMouseLocation()

		local delta = currentMousePos - dragStart

		local newX = dragOffset.X.Offset + delta.X

		local newY = dragOffset.Y.Offset + delta.Y

		local viewportSize = workspace.Camera.ViewportSize

		local minimizerSize = activeMin.AbsoluteSize

		if newX < 0 then newX = 0 end

		if newY < 0 then newY = 0 end

		if newX > viewportSize.X - minimizerSize.X then 

			newX = viewportSize.X - minimizerSize.X 

		end

		if newY > viewportSize.Y - minimizerSize.Y then 

			newY = viewportSize.Y - minimizerSize.Y 

		end

		activeMin.Position = UDim2.new(0, newX, 0, newY)

	end

end)

Creator.AddSignal(MinimizeButton.MouseButton1Click, function()

	task.wait(0.1)

	if not isDragging then

		Library.Window:Minimize()

	end

end)

Creator.AddSignal(MobileMinimizeButton.MouseButton1Click, function()

	task.wait(0.1)

	if not isDragging then

		Library.Window:Minimize()

	end

end)

    

if RunService:IsStudio() then task.wait(0.01) end
return Library, SaveManager, InterfaceManager, Mobile
