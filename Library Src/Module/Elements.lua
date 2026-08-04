-- Elements.lua
-- ขึ้นกับ: Components.lua
-- เรียกใช้แบบ: local Elements, ElementsTable = loadstring(game:HttpGet(ElementsURL))(Components, Library)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()

local Components, Library = ...
assert(Components, "Elements.lua: ต้องส่ง Components เข้ามาเป็นพารามิเตอร์ตัวแรก (จาก Components.lua)")
assert(Library, "Elements.lua: ต้องส่ง Library เข้ามาเป็นพารามิเตอร์ที่สอง (จาก Creator.lua)")

local Creator = Components.Creator
local Flipper = Creator.Flipper
local GetStyleProperty = Creator.GetStyleProperty
local NewCorner = Creator.NewCorner
local NewStroke = Creator.NewStroke

local ElementsTable = {}
local AddSignal = Creator.AddSignal

-- ElementsTable.Button ถูกลบออก — ใช้ ActionButton แทน
ElementsTable.Toggle = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Toggle"

	function Element:New(Idx, Config)
		assert(Config.Title, "Toggle - Missing Title")

		local Toggle = {
			Value = Config.Default or false,
			Callback = Config.Callback or function(Value) end,
			Type = "Toggle",
		}

		local ToggleFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		ToggleFrame.DescLabel.Size = UDim2.new(1, -54, 0, 14)

		Toggle.SetTitle = ToggleFrame.SetTitle
		Toggle.SetDesc = ToggleFrame.SetDesc
		Toggle.Visible = ToggleFrame.Visible
		Toggle.Elements = ToggleFrame

		-- pill bg (track)
		local ToggleTrack = New("Frame", {
			Size = UDim2.fromOffset(44, 24),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Parent = ToggleFrame.Frame,
			BackgroundTransparency = 0.88,
			ThemeTag = { BackgroundColor3 = "InElementBorder" },
		}, {
			NewCorner("PillCorner"),
		})

		local ToggleBorder = New("UIStroke", {
			Transparency = 0.4,
			Thickness = GetStyleProperty("BorderThickness"),
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = { Color = "ToggleSlider" },
		})
		ToggleBorder.Parent = ToggleTrack

		-- filled pill (accent layer)
		local ToggleSlider = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Parent = ToggleTrack,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			NewCorner("PillCorner"),
		})

		-- circle knob
		local ToggleCircle = New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.new(0, 4, 0.5, 0),
			BackgroundTransparency = 0.1,
			Parent = ToggleTrack,
			ThemeTag = { BackgroundColor3 = "ToggleSlider" },
		}, {
			NewCorner("PillCorner"),
			New("UIAspectRatioConstraint", { AspectRatio = 1 }),
		})

		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
			Func(Toggle.Value)
		end

		function Toggle:SetValue(Value)
			Value = not not Value
			Toggle.Value = Value

			local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			-- knob เลื่อน
			TweenService:Create(ToggleCircle, ti, {
				Position = UDim2.new(0, Toggle.Value and 24 or 4, 0.5, 0),
				Size     = UDim2.fromOffset(Toggle.Value and 17 or 16, Toggle.Value and 17 or 16),
			}):Play()
			-- accent fill fade in/out
			TweenService:Create(ToggleSlider, ti, {
				BackgroundTransparency = Toggle.Value and 0.35 or 1,
			}):Play()
			-- track border สี
			Creator.OverrideTag(ToggleBorder, { Color = Toggle.Value and "Accent" or "ToggleSlider" })
			TweenService:Create(ToggleBorder, ti, {
				Transparency = Toggle.Value and 0.55 or 0.4,
			}):Play()
			-- knob สี
			Creator.OverrideTag(ToggleCircle, { BackgroundColor3 = Toggle.Value and "ToggleToggled" or "ToggleSlider" })

			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
		end

		function Toggle:Destroy()
			ToggleFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(ToggleFrame.Frame.MouseButton1Click, function()
			Toggle:SetValue(not Toggle.Value)
		end)

		Toggle:SetValue(Toggle.Value)

		Library.Options[Idx] = Toggle
		return Toggle
	end

	return Element
end)()
ElementsTable.Dropdown = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Dropdown"
	local New = Creator.New

	function Element:New(Idx, Config)

		local windowDropdownsOutside = false
		if Library.Window and Library.Window.DropdownsOutsideWindow ~= nil then
			windowDropdownsOutside = Library.Window.DropdownsOutsideWindow
		elseif Library.Windows and #Library.Windows > 0 then
			for i = #Library.Windows, 1, -1 do
				local window = Library.Windows[i]
				if window and window.DropdownsOutsideWindow ~= nil then
					windowDropdownsOutside = window.DropdownsOutsideWindow
					break
				end
			end
		end
		
		local Dropdown = {
			Values = Config.Values,
			Value = Config.Default,
			Multi = Config.Multi,
			Buttons = {},
			Opened = false,
			Type = "Dropdown",
			Callback = Config.Callback or function() end,
			Search = (Config.Search == nil) and true or Config.Search,
			KeepSearch = Config.KeepSearch == true,
			OpenToRight = windowDropdownsOutside
		}

		if Dropdown.Multi and Config.AllowNull then
			Dropdown.Value = {}
		end

		local DropdownFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		DropdownFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)

		Dropdown.SetTitle = DropdownFrame.SetTitle
		Dropdown.SetDesc = DropdownFrame.SetDesc
		Dropdown.Visible = DropdownFrame.Visible
		Dropdown.Elements = DropdownFrame
		
		local container = self.Container

		local DropdownDisplay = New("TextLabel", {
			FontFace = GetStyleProperty("FontRegular"),
			Text = "",
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = GetStyleProperty("TextSizeLg"),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0.5, 0),
			Position = UDim2.new(0, 8, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local initialRotation = 180
		local openRotation = windowDropdownsOutside and -90 or 0
		local closeRotation = 180

		local DropdownIco = New("ImageLabel", {
			Image = "rbxassetid://10709790948",
			Size = UDim2.fromOffset(16, 16),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			BackgroundTransparency = 1,
			Rotation = initialRotation,
			ThemeTag = {
				ImageColor3 = "SubText",
			},
		})

		local DropdownInner = New("TextButton", {
			Size = UDim2.fromOffset(160, 32),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88,
			Parent = DropdownFrame.Frame,
			ThemeTag = {
				BackgroundColor3 = "DropdownFrame",
			},
		}, {
			NewCorner("ElementCorner"),
			New("UIStroke", {
				Transparency = 0.45,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "InElementBorder",
				},
			}),
			DropdownIco,
			DropdownDisplay,
		})

		local DropdownListLayout = New("UIListLayout", {
			Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		local DropdownScrollFrame = New("ScrollingFrame", {
			Size = UDim2.new(1, -5, 1, -10),
			Position = UDim2.fromOffset(5, 5),
			BackgroundTransparency = 1,
			BottomImage = "rbxassetid://6889812791",
			MidImage = "rbxassetid://6889812721",
			TopImage = "rbxassetid://6276641225",
			ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
			ScrollBarImageTransparency = 0.75,
			ScrollBarThickness = 5,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
		}, {
			DropdownListLayout,
		})

		local SearchBar
		local SearchBox
		if Dropdown.Search then
			SearchBar = New("Frame", {
				Size = UDim2.new(1, -10, 0, 28),
				Position = UDim2.fromOffset(5, 5),
				BackgroundTransparency = 0.7,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				ThemeTag = { BackgroundColor3 = "Element" },
				ZIndex = 24,
			}, {
				NewCorner("TinyCorner"),
			})

			SearchBox = New("TextBox", {
				FontFace = GetStyleProperty("FontMedium"),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextSize = GetStyleProperty("TextSizeMd"),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -36, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				PlaceholderText = "Search...",
				PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
				ClearTextOnFocus = false,
				Text = "",
				Parent = SearchBar,
				ThemeTag = {
					TextColor3 = "Text",
					PlaceholderColor3 = "SubText",
				},
				ZIndex = 24,
			})

			local SearchIcon = New("ImageLabel", {
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(1, -13, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://10734943674",
				Parent = SearchBar,
				ImageTransparency = 0.3,
				ZIndex = 25,
				ThemeTag = {
					ImageColor3 = "SubText",
				},
			})

			DropdownScrollFrame.Position = UDim2.fromOffset(5, 38)
			DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -43)

			local filterToken = 0
			local function ApplyFilter()
				filterToken = filterToken + 1
				local myToken = filterToken
				task.spawn(function()
					task.wait(0.01)
					if myToken ~= filterToken then return end
					local text = (SearchBox.Text or ""):lower()
					for _, element in next, DropdownScrollFrame:GetChildren() do
						if not element:IsA("UIListLayout") then
							local value = element:FindFirstChild("ButtonLabel") and element.ButtonLabel.Text or ""
							element.Visible = text == "" or value:lower():find(text, 1, true) ~= nil
						end
					end
					task.wait()
					RecalculateCanvasSize()
					task.wait()
					RecalculateListSize()
					task.wait()
					RecalculateListPosition()
				end)
			end

			Creator.AddSignal(SearchBox:GetPropertyChangedSignal("Text"), ApplyFilter)
		end

		local DropdownHolderFrame = New("Frame", {
			Size = UDim2.fromScale(1, 0.6),
			ThemeTag = {
				BackgroundColor3 = "DropdownHolder",
			},
		}, {
			SearchBar,
			DropdownScrollFrame,
			NewCorner("SmallCorner"),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "DropdownBorder",
				},
			}),
			New("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=5554236805",
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(23, 23, 277, 277),
				Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
				Position = UDim2.fromOffset(-15, -15),
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				ImageTransparency = 0.1,
			}),
		})

		local DropdownHolderCanvas = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(170, 300),
			Parent = Library.GUI,
			Visible = false,
		}, {
			DropdownHolderFrame,
			New("UISizeConstraint", {
				MinSize = Vector2.new(170, 0),
			}),
		})
		table.insert(Library.OpenFrames, DropdownHolderCanvas)

		local windowRoot = nil
		if Library.Window and Library.Window.Root then
			windowRoot = Library.Window.Root
		elseif Library.Windows and #Library.Windows > 0 then
			for i = #Library.Windows, 1, -1 do
				local window = Library.Windows[i]
				if window and window.Root then
					windowRoot = window.Root
					break
				end
			end
		end
		
		if not windowRoot and container then
			local parent = container.Parent
			while parent do
				if parent:IsA("Frame") then
					if parent:FindFirstChild("ContainerCanvas") or (parent.Name and parent:FindFirstChild("TitleBar")) then
						windowRoot = parent
						break
					end
				end
				if parent:IsA("ScreenGui") then
					break
				end
				parent = parent.Parent
			end
		end

		local function RecalculateListPosition()
			if not DropdownHolderCanvas or not DropdownInner then return end
			
			local dropdownX = DropdownInner.AbsolutePosition.X
			local dropdownY = DropdownInner.AbsolutePosition.Y
			local dropdownWidth = DropdownInner.AbsoluteSize.X
			local dropdownHeight = DropdownInner.AbsoluteSize.Y
			local canvasWidth = DropdownHolderCanvas.AbsoluteSize.X
			local canvasHeight = DropdownHolderCanvas.AbsoluteSize.Y
			local viewportHeight = Camera.ViewportSize.Y
			local viewportWidth = Camera.ViewportSize.X
			
			if not windowRoot then
				if Library.Window and Library.Window.Root then
					windowRoot = Library.Window.Root
				elseif Library.Windows and #Library.Windows > 0 then
					for i = #Library.Windows, 1, -1 do
						local window = Library.Windows[i]
						if window and window.Root then
							windowRoot = window.Root
							break
						end
					end
				end
				
				if not windowRoot and container then
					local parent = container.Parent
					while parent do
						if parent:IsA("Frame") then
							if parent:FindFirstChild("ContainerCanvas") or (parent.Name and parent:FindFirstChild("TitleBar")) then
								windowRoot = parent
								break
							end
						end
						if parent:IsA("ScreenGui") then
							break
						end
						parent = parent.Parent
					end
				end
			end
			
			local targetX = dropdownX - 1
			local useFixedY = false
			
			if windowRoot then
				local windowX = windowRoot.AbsolutePosition.X
				local windowWidth = windowRoot.AbsoluteSize.X
				local windowRight = windowX + windowWidth
				
				if Dropdown.OpenToRight then
					targetX = windowRight + 5
					if Dropdown.SavedY == nil then
						Dropdown.SavedY = dropdownY
					end
					useFixedY = true
				else
					local canvasRight = dropdownX + canvasWidth - 1
					if canvasRight > windowRight then
						targetX = math.max(windowX + 5, windowRight - canvasWidth - 5)
					end
					Dropdown.SavedY = nil
				end
			else
				local canvasRight = dropdownX + canvasWidth - 1
				if canvasRight > viewportWidth then
					if Dropdown.OpenToRight then
						targetX = viewportWidth + 5
						if Dropdown.SavedY == nil then
							Dropdown.SavedY = dropdownY
						end
						useFixedY = true
					else
						targetX = math.max(5, viewportWidth - canvasWidth - 5)
					end
					Dropdown.SavedY = nil
				end
			end
			
			local targetY
			if useFixedY and windowRoot then
				local windowY = windowRoot.AbsolutePosition.Y
				local windowHeight = windowRoot.AbsoluteSize.Y
				local windowCenterY = windowY + windowHeight / 2
				targetY = windowCenterY - canvasHeight / 2
				
				local windowTop = windowY
				local windowBottom = windowY + windowHeight
				local viewportTop = 0
				local viewportBottom = viewportHeight
				
				if targetY + canvasHeight > viewportBottom then
					targetY = viewportBottom - canvasHeight - 5
				end
				if targetY < viewportTop then
					targetY = viewportTop + 5
				end
				
				if targetY + canvasHeight > windowBottom then
					targetY = windowBottom - canvasHeight - 5
				end
				if targetY < windowTop then
					targetY = windowTop + 5
				end
			elseif useFixedY and Dropdown.SavedY then
				targetY = Dropdown.SavedY
				
				local spaceBelow = viewportHeight - (Dropdown.SavedY + dropdownHeight)
				local spaceAbove = Dropdown.SavedY
				
				if canvasHeight > spaceBelow and canvasHeight <= spaceAbove then
					targetY = Dropdown.SavedY - canvasHeight - 5
				elseif canvasHeight > spaceBelow and canvasHeight > spaceAbove then
					if spaceBelow > spaceAbove then
						targetY = Dropdown.SavedY + dropdownHeight + 5
					else
						targetY = math.max(5, Dropdown.SavedY - canvasHeight - 5)
					end
				else
					targetY = Dropdown.SavedY + dropdownHeight + 5
				end
			else
				local spaceBelow = viewportHeight - (dropdownY + dropdownHeight)
				local spaceAbove = dropdownY
				
				if canvasHeight <= spaceBelow then
					targetY = dropdownY + dropdownHeight + 5
				elseif canvasHeight <= spaceAbove then
					targetY = dropdownY - canvasHeight - 5
				else
					if spaceBelow > spaceAbove then
						targetY = dropdownY + dropdownHeight + 5
					else
						targetY = math.max(5, dropdownY - canvasHeight - 5)
					end
				end
			end
			
			DropdownHolderCanvas.Position = UDim2.fromOffset(targetX, targetY)
		end

		local ListSizeX = 0
		local function RecalculateListSize()
			if not DropdownHolderCanvas or not DropdownHolderFrame then return end
			
			local visibleCount = 0
			for _, element in next, DropdownScrollFrame:GetChildren() do
				if not element:IsA("UIListLayout") and element.Visible then
					visibleCount = visibleCount + 1
				end
			end
			
			local itemHeight = 32
			local padding = 3
			local searchHeight = Dropdown.Search and 38 or 0
			local innerMargins = 10
			local estimatedContent = (visibleCount > 0) and (visibleCount * itemHeight + (visibleCount - 1) * padding + innerMargins + searchHeight) or (innerMargins + searchHeight)
			local maxHeight = 392
			local targetHeight = math.min(estimatedContent, maxHeight)
			
			local canvasWidth = math.max(170, ListSizeX > 0 and (ListSizeX + 20) or 170)
			DropdownHolderCanvas.Size = UDim2.fromOffset(canvasWidth, targetHeight)
			
			local many = visibleCount > 10
			DropdownHolderFrame.Size = UDim2.fromScale(1, many and (targetHeight / math.max(targetHeight, 1)) or 1)
		end

		local function RecalculateCanvasSize()
			DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
		end

		RecalculateListPosition()
		RecalculateListSize()
		RecalculateCanvasSize()

		if Dropdown.OpenToRight then
			if windowRoot then
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsolutePosition"), function()
					if Dropdown.Opened then
						Dropdown.SavedY = nil
						RecalculateListPosition()
					end
				end)
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsoluteSize"), function()
					if Dropdown.Opened then
						RecalculateListPosition()
					end
				end)
			end
		else
			Creator.AddSignal(DropdownInner:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition)
			if windowRoot then
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsolutePosition"), function()
					if Dropdown.Opened then
						RecalculateListPosition()
					end
				end)
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsoluteSize"), function()
					if Dropdown.Opened then
						RecalculateListPosition()
					end
				end)
			end
		end
		Creator.AddSignal(DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			RecalculateCanvasSize()
			task.wait()
			RecalculateListSize()
			task.wait()
			RecalculateListPosition()
		end)

		Creator.AddSignal(DropdownInner.MouseButton1Click, function()
			if Dropdown.Opened then
				Dropdown:Close()
			else
				Dropdown:Open()
			end
		end)

		Creator.AddSignal(DropdownInner.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.Touch then
				if Dropdown.Opened then
					Dropdown:Close()
				else
					Dropdown:Open()
				end
			end
		end)

		Creator.AddSignal(DropdownDisplay:GetPropertyChangedSignal("Text"), function()
			for _, Element in next, DropdownScrollFrame:GetChildren() do
				if not Element:IsA("UIListLayout") then
					Element.Visible = true
				end
			end
			RecalculateListPosition()
			RecalculateListSize()
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				local mousePos = Input.UserInputType == Enum.UserInputType.MouseButton1 and Vector2.new(Mouse.X, Mouse.Y) or Input.Position
				local AbsPos, AbsSize = DropdownHolderFrame.AbsolutePosition, DropdownHolderFrame.AbsoluteSize
				local innerAbsPos, innerAbsSize = DropdownInner.AbsolutePosition, DropdownInner.AbsoluteSize
				
				local clickedInsideDropdown = mousePos.X >= AbsPos.X and mousePos.X <= AbsPos.X + AbsSize.X and mousePos.Y >= AbsPos.Y and mousePos.Y <= AbsPos.Y + AbsSize.Y
				local clickedInsideInner = mousePos.X >= innerAbsPos.X and mousePos.X <= innerAbsPos.X + innerAbsSize.X and mousePos.Y >= innerAbsPos.Y and mousePos.Y <= innerAbsPos.Y + innerAbsSize.Y
				
				if not clickedInsideDropdown and not clickedInsideInner then
					Dropdown:Close()
				end
			end
		end)

		local ScrollFrame = self.ScrollFrame
		function Dropdown:Open()
			if Dropdown.Opened then
				return
			end
			Dropdown.Opened = true
			if Dropdown.OpenToRight then
				Dropdown.SavedY = nil
			end
			for _, frame in ipairs(Library.OpenFrames) do
				if frame ~= DropdownHolderCanvas and frame.Visible then
					frame.Visible = false
				end
			end
			if SearchBox and not Dropdown.KeepSearch then
				SearchBox.Text = ""
			end
			DropdownHolderCanvas.Visible = true
			RecalculateListPosition()
			RecalculateListSize()
			RecalculateCanvasSize()
			task.wait()
			TweenService:Create(
				DropdownHolderFrame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Size = UDim2.fromScale(1, 1) }
			):Play()
			TweenService:Create(
				DropdownIco,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Rotation = openRotation }
			):Play()
		end

		function Dropdown:Close()
			Dropdown.Opened = false
			if Dropdown.OpenToRight then
				Dropdown.SavedY = nil
			end
			DropdownHolderFrame.Size = UDim2.fromScale(1, 1)
			DropdownHolderCanvas.Visible = false
			TweenService:Create(
				DropdownIco,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Rotation = closeRotation }
			):Play()
			Dropdown:Display()
			for _, element in next, DropdownScrollFrame:GetChildren() do
				if not element:IsA("UIListLayout") then
					element.Visible = true
				end
			end
		end

		function Dropdown:Display()
			local Values = Dropdown.Values
			local Str = ""

			if Config.Multi then
				for Idx, Value in next, Values do
					if Dropdown.Value[Value] then
						Str = Str .. Value .. ", "
					end
				end
				Str = Str:sub(1, #Str - 2)
			else
				Str = Dropdown.Value or ""
			end

			DropdownDisplay.Text = (Str == "" and "--" or Str)
		end

		function Dropdown:GetActiveValues()
			if Config.Multi then
				local T = {}

				for Value, Bool in next, Dropdown.Value do
					table.insert(T, Value)
				end

				return T
			else
				return Dropdown.Value and 1 or 0
			end
		end

		function Dropdown:SetActiveValues(Value)
			Dropdown.Value = Value

			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)

			Dropdown:BuildDropdownList()
		end

		function Dropdown:BuildDropdownList()
			local Values = Dropdown.Values
			local Buttons = {}

			for _, Element in next, DropdownScrollFrame:GetChildren() do
				if not Element:IsA("UIListLayout") then
					Element:Destroy()
				end
			end

			local layoutOrder = 0
			local hasRenderedItem = false

			for _, Value in ipairs(Values) do
				layoutOrder = layoutOrder + 1

				local Table = {}

				local ButtonSelector = New("Frame", {
					Size = UDim2.fromOffset(4, 14),
					BackgroundColor3 = Color3.fromRGB(76, 194, 255),
					Position = UDim2.fromOffset(-1, 16),
					AnchorPoint = Vector2.new(0, 0.5),
					ThemeTag = {
						BackgroundColor3 = "Accent",
					},
				}, {
					NewCorner("TinyCorner"),
				})

				local ButtonLabel = New("TextLabel", {
					FontFace = GetStyleProperty("FontMedium"),
					Text = Value,
					TextColor3 = Color3.fromRGB(200, 200, 200),
					TextSize = GetStyleProperty("TextSizeMd"),
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromOffset(10, 0),
					Name = "ButtonLabel",
					ThemeTag = {
						TextColor3 = "Text",
					},
				})

				local Button = New("TextButton", {
					Size = UDim2.new(1, -5, 0, 32),
					BackgroundTransparency = 1,
					ZIndex = 23,
					Text = "",
					Parent = DropdownScrollFrame,
					LayoutOrder = layoutOrder,
					ThemeTag = {
						BackgroundColor3 = "DropdownOption",
					},
				}, {
					ButtonSelector,
					ButtonLabel,
					NewCorner("SmallCorner"),
					New("UIStroke", {
						Transparency = 1,
						Thickness = GetStyleProperty("BorderThickness"),
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = { Color = "Accent" },
					}),
				})

				local Selected

				if Config.Multi then
					Selected = Dropdown.Value[Value]
				else
					Selected = Dropdown.Value == Value
				end

				local BackMotor, SetBackTransparency = Creator.SpringMotor(1, Button, "BackgroundTransparency")
				local SelMotor, SetSelTransparency = Creator.SpringMotor(1, ButtonSelector, "BackgroundTransparency")
				local SelectorSizeMotor = Flipper.SingleMotor.new(6)

				SelectorSizeMotor:onStep(function(value)
					ButtonSelector.Size = UDim2.new(0, 4, 0, value)
				end)

				Creator.AddSignal(Button.MouseEnter, function()
					SetBackTransparency(Selected and 0.85 or 0.89)
				end)
				Creator.AddSignal(Button.MouseLeave, function()
					SetBackTransparency(Selected and 0.89 or 1)
				end)
				Creator.AddSignal(Button.MouseButton1Down, function()
					SetBackTransparency(0.92)
				end)
				Creator.AddSignal(Button.MouseButton1Up, function()
					SetBackTransparency(Selected and 0.85 or 0.89)
				end)

				function Table:UpdateButton()
					if Config.Multi then
						Selected = Dropdown.Value[Value]
						if Selected then
							SetBackTransparency(0.89)
						end
					else
						Selected = Dropdown.Value == Value
						SetBackTransparency(Selected and 0.89 or 1)
					end

					SelectorSizeMotor:setGoal(Flipper.Spring.new(Selected and 14 or 6, { frequency = 6 }))
					SetSelTransparency(Selected and 0 or 1)
				end

				AddSignal(Button.Activated, function()
					local Try = not Selected

					if Dropdown:GetActiveValues() == 1 and not Try and not Config.AllowNull then
					else
						if Config.Multi then
							Selected = Try
							Dropdown.Value[Value] = Selected and true or nil
						else
							Selected = Try
							Dropdown.Value = Selected and Value or nil

							for _, OtherButton in next, Buttons do
								OtherButton:UpdateButton()
							end
						end

						Table:UpdateButton()
						Dropdown:Display()
						Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
						Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
					end
				end)

				Table:UpdateButton()
				Dropdown:Display()

				Buttons[Button] = Table
				hasRenderedItem = true
			end

			ListSizeX = 0
			for Button, Table in next, Buttons do
				if Button.ButtonLabel then
					local textSize = Button.ButtonLabel.TextBounds.X
					if textSize > ListSizeX then
						ListSizeX = textSize
					end
				end
			end
			ListSizeX = math.max(150, ListSizeX + 40)

			RecalculateCanvasSize()
			RecalculateListSize()
		end

		function Dropdown:SetValues(NewValues)
			if NewValues then
				Dropdown.Values = NewValues
			end

			Dropdown:BuildDropdownList()
		end

		function Dropdown:OnChanged(Func)
			Dropdown.Changed = Func
			Func(Dropdown.Value)
		end

		function Dropdown:SetValue(Val)
			if Dropdown.Multi then
				local nTable = {}

				for Value, Bool in next, Val do
					if table.find(Dropdown.Values, Value) then
						nTable[Value] = true
					end
				end

				Dropdown.Value = nTable
			else
				if not Val then
					Dropdown.Value = nil
				elseif table.find(Dropdown.Values, Val) then
					Dropdown.Value = Val
				end
			end

			Dropdown:BuildDropdownList()

			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end

		function Dropdown:Destroy()
			DropdownFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Dropdown:BuildDropdownList()
		Dropdown:Display()

		local Defaults = {}

		if type(Config.Default) == "string" then
			local Idx = table.find(Dropdown.Values, Config.Default)
			if Idx then
				table.insert(Defaults, Idx)
			end
		elseif type(Config.Default) == "table" then
			for _, Value in next, Config.Default do
				local Idx = table.find(Dropdown.Values, Value)
				if Idx then
					table.insert(Defaults, Idx)
				end
			end
		elseif type(Config.Default) == "number" and Dropdown.Values[Config.Default] ~= nil then
			table.insert(Defaults, Config.Default)
		end

		if next(Defaults) then
			for i = 1, #Defaults do
				local Index = Defaults[i]
				if Config.Multi then
					Dropdown.Value[Dropdown.Values[Index]] = true
				else
					Dropdown.Value = Dropdown.Values[Index]
				end

				if not Config.Multi then
					break
				end
			end

			Dropdown:BuildDropdownList()
			Dropdown:Display()
		end

		Library.Options[Idx] = Dropdown
		return Dropdown
	end

	return Element
end)()
ElementsTable.Paragraph = (function()
	local Paragraph = {}
	Paragraph.__index = Paragraph
	Paragraph.__type = "Paragraph"
	Paragraph.NoIdx = true

	function Paragraph:New(Config)
		Config.Content = Config.Content or ""

		local Paragraph = Components.Element(Config.Title, Config.Content, Paragraph.Container, false, Config)
		Paragraph.Frame.BackgroundTransparency = 0.90
		Paragraph.Border.Transparency = 0.50

		Paragraph.SetTitle = Paragraph.SetTitle
		Paragraph.SetDesc = Paragraph.SetDesc
		Paragraph.Visible = Paragraph.Visible
		Paragraph.Elements = Paragraph

		return Paragraph
	end

	return Paragraph
end)()
ElementsTable.Slider = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Slider"

	function Element:New(Idx, Config)
		assert(Config.Title,                        "Slider - Missing Title.")
		assert(Config.Default   ~= nil,             "Slider - Missing default value.")
		assert(Config.Min       ~= nil,             "Slider - Missing minimum value.")
		assert(Config.Max       ~= nil,             "Slider - Missing maximum value.")
		-- Rounding เป็น optional — ถ้าไม่ส่งมาก็ default เป็น 0
		Config.Rounding = Config.Rounding ~= nil and Config.Rounding or 0

		local Slider = {
			Value = nil,
			Min = Config.Min,
			Max = Config.Max,
			Rounding = Config.Rounding,
			Callback = Config.Callback or function(Value) end,
			Type = "Slider",
		}

		local Dragging = false

		local SliderFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		SliderFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)

		Slider.Elements = SliderFrame
		Slider.SetTitle = SliderFrame.SetTitle
		Slider.SetDesc = SliderFrame.SetDesc
		Slider.Visible = SliderFrame.Visible

		local SliderDot = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(13, 13),
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			NewCorner("PillCorner"),
			New("UIAspectRatioConstraint", { AspectRatio = 1 }),
			New("UIStroke", {
				Transparency = 0.55,
				Thickness = GetStyleProperty("BorderThickness"),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = { Color = "AcrylicMain" },
			}),
		})

		local SliderRail = New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(6, 0),
			Size = UDim2.new(1, -12, 1, 0),
		}, {
			SliderDot,
		})

		local SliderFill = New("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			ThemeTag = {
				BackgroundColor3 = "Accent",
			},
		}, {
			NewCorner("PillCorner"),
		})

		local SliderDisplay = New("TextLabel", {
			FontFace = GetStyleProperty("FontMedium"),
			Text = "Value",
			TextSize = GetStyleProperty("TextSizeXs"),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 100, 0, 14),
			Position = UDim2.new(0, -4, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		local SliderInput = New("TextBox", {
			FontFace = GetStyleProperty("FontMedium"),
			Text = "",
			TextSize = GetStyleProperty("TextSizeXs"),
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.8,
			Size = UDim2.new(0, 0, 0, 14),
			Position = UDim2.new(0, -4, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			PlaceholderText = "Value",
			ClearTextOnFocus = false,
			Visible = true,
			TextWrapped = false,
			TextTransparency = 1,
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "SubText",
				BackgroundColor3 = "Element",
			},
		}, {
			NewCorner("TinyCorner"),
			New("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 1, Thickness = GetStyleProperty("BorderThickness") }),
		})

		local SliderInner = New("Frame", {
			Size = UDim2.new(1, 0, 0, 7),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 0.45,
			Parent = SliderFrame.Frame,
			ThemeTag = {
				BackgroundColor3 = "SliderRail",
			},
		}, {
			NewCorner("PillCorner"),
			New("UISizeConstraint", {
				MaxSize = Vector2.new(150, math.huge),
			}),
			SliderDisplay,
			SliderInput,
			SliderFill,
			SliderRail,
		})

		local isHovering = false
		local inputVisible = false
		local currentWidthTween = nil

		local function calculateInputWidth(text)
			local textSize = game:GetService("TextService"):GetTextSize(
				text or "0",
				12,
				Enum.Font.SourceSans,
				Vector2.new(1000, 14)
			)
			local padding = 8
			local minWidth = 25
			local maxWidth = 80
			return math.max(minWidth, math.min(maxWidth, textSize.X + padding))
		end

		local function updateInputWidth(text, animate)
			if currentWidthTween then
				currentWidthTween:Cancel()
				currentWidthTween = nil
			end

			local targetWidth = calculateInputWidth(text)
			local currentWidth = SliderInput.Size.X.Offset

			if animate and math.abs(targetWidth - currentWidth) > 0.5 then
				currentWidthTween = TweenService:Create(SliderInput, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, targetWidth, 0, 14)
				})
				currentWidthTween:Play()
				currentWidthTween.Completed:Connect(function()
					currentWidthTween = nil
				end)
			else
				SliderInput.Size = UDim2.new(0, targetWidth, 0, 14)
			end
		end

		Creator.AddSignal(SliderFrame.Frame.MouseEnter, function()
			isHovering = true
			if not SliderInput:IsFocused() then
				SliderDisplay.Visible = false
				SliderInput.Text = tostring(Slider.Value)

				updateInputWidth(tostring(Slider.Value), false)
				inputVisible = true

				local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

				TweenService:Create(SliderInput, tweenInfo, {
					TextTransparency = 0,
					BackgroundTransparency = 0.8
				}):Play()

				TweenService:Create(SliderInput.UIStroke, tweenInfo, {
					Transparency = 0.7
				}):Play()
			end
		end)

		Creator.AddSignal(SliderFrame.Frame.MouseLeave, function()
			isHovering = false
			if not SliderInput:IsFocused() and inputVisible then
				local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

				TweenService:Create(SliderInput, tweenInfo, {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play()

				TweenService:Create(SliderInput.UIStroke, tweenInfo, {
					Transparency = 1
				}):Play()

				task.wait(0.2)
				SliderDisplay.Visible = true
				inputVisible = false
			end
		end)

		Creator.AddSignal(SliderInput.Changed, function(property)
			if property == "Text" then
				local text = SliderInput.Text
				local cleanText = text:gsub("[^%d%.%-]", "")
				if cleanText:find("%-") and cleanText:find("%-") ~= 1 then
					cleanText = cleanText:gsub("%-", "")
				end
				local dotCount = 0
				cleanText = cleanText:gsub("%.", function()
					dotCount = dotCount + 1
					return dotCount == 1 and "." or ""
				end)

				if cleanText ~= text then
					SliderInput.Text = cleanText
					return
				end

				if inputVisible or SliderInput:IsFocused() then
					updateInputWidth(cleanText, true)
				end
			end
		end)

		Creator.AddSignal(SliderInput.FocusLost, function(enterPressed)
			local inputValue = tonumber(SliderInput.Text)
			if inputValue then
				Slider:SetValue(inputValue)
			else
				SliderInput.Text = tostring(Slider.Value)
				updateInputWidth(tostring(Slider.Value), true)
			end

			if not isHovering then
				local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

				TweenService:Create(SliderInput, tweenInfo, {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play()

				TweenService:Create(SliderInput.UIStroke, tweenInfo, {
					Transparency = 1
				}):Play()

				task.wait(0.2)
				SliderDisplay.Visible = true
				inputVisible = false
			end
		end)

		Creator.AddSignal(SliderInput.Focused, function()
			SliderInput.Text = tostring(Slider.Value)
			updateInputWidth(tostring(Slider.Value), false)
		end)

		Creator.AddSignal(SliderInput.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = false
			end
		end)

		Creator.AddSignal(SliderDot.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
			end
		end)

		Creator.AddSignal(SliderDot.InputEnded, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = false
			end
		end)

		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if Dragging then
				local position = nil
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					position = Input.Position
				elseif Input.UserInputType == Enum.UserInputType.Touch then
					position = Input.Position
				end

				if position then
					local SizeScale = math.clamp((position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
					Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
				end
			end
		end)

		Creator.AddSignal(SliderRail.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				local SizeScale = math.clamp((Input.Position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
				Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
			end
		end)

		Creator.AddSignal(SliderRail.InputEnded, function(Input)
			if Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = false
			end
		end)

		function Slider:OnChanged(Func)
			Slider.Changed = Func
			Func(Slider.Value)
		end

		function Slider:SetValue(Value)
			self.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Rounding)
			SliderDot.Position = UDim2.new((self.Value - Slider.Min) / (Slider.Max - Slider.Min), -7, 0.5, 0)
			SliderFill.Size = UDim2.fromScale((self.Value - Slider.Min) / (Slider.Max - Slider.Min), 1)
			SliderDisplay.Text = tostring(self.Value)

			if inputVisible or SliderInput:IsFocused() then
				SliderInput.Text = tostring(self.Value)
				updateInputWidth(tostring(self.Value), not SliderInput:IsFocused())
			end
			if not inputVisible and not SliderInput:IsFocused() then
				SliderInput.Text = tostring(self.Value)
			end

			Library:SafeCallback(Slider.Callback, self.Value)
			Library:SafeCallback(Slider.Changed, self.Value)
		end

		function Slider:Destroy()
			SliderFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Slider:SetValue(Config.Default)

		Library.Options[Idx] = Slider
		return Slider
	end

	return Element
end)()
ElementsTable.Keybind = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Keybind"

	function Element:New(Idx, Config)
		assert(Config.Title, "KeyBind - Missing Title")
		assert(Config.Default, "KeyBind - Missing default value.")

		-- แปลง EnumItem → string ตั้งแต่ต้น
		local defaultKey = typeof(Config.Default) == "EnumItem" and Config.Default.Name or tostring(Config.Default)

		local Keybind = {
			Value = defaultKey,
			Toggled = false,
			Mode = Config.Mode or "Toggle",
			Type = "Keybind",
			Callback = Config.Callback or function(Value) end,
			ChangedCallback = Config.ChangedCallback or function(New) end,
		}

		local Picking = false

		local KeybindFrame = Components.Element(Config.Title, Config.Description, self.Container, true)

		Keybind.SetTitle = KeybindFrame.SetTitle
		Keybind.SetDesc = KeybindFrame.SetDesc
		Keybind.Visible = KeybindFrame.Visible
		Keybind.Elements = KeybindFrame

		local KeybindDisplayLabel = New("TextLabel", {
			FontFace = GetStyleProperty("FontRegular"),
			Text = defaultKey,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = GetStyleProperty("TextSizeMd"),
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(0, 0, 0, 14),
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local KeybindDisplayFrame = New("TextButton", {
			Size = UDim2.fromOffset(0, 32),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88,
			Parent = KeybindFrame.Frame,
			AutomaticSize = Enum.AutomaticSize.X,
			ThemeTag = {
				BackgroundColor3 = "Keybind",
			},
		}, {
			NewCorner("ElementCorner"),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIStroke", {
				Transparency = 0.45,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "InElementBorder",
				},
			}),
			KeybindDisplayLabel,
		})

		function Keybind:GetState()
			if UserInputService:GetFocusedTextBox() and Keybind.Mode ~= "Always" then
				return false
			end

			if Keybind.Mode == "Always" then
				return true
			elseif Keybind.Mode == "Hold" then
				if Keybind.Value == "None" then
					return false
				end

				local Key = Keybind.Value

				if Key == "MouseLeft" or Key == "MouseRight" then
					return Key == "MouseLeft" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						or Key == "MouseRight"
						and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
				else
					return UserInputService:IsKeyDown(Enum.KeyCode[Keybind.Value])
				end
			else
				return Keybind.Toggled
			end
		end

		function Keybind:SetValue(Key, Mode)
			Key = Key or Keybind.Key
			Mode = Mode or Keybind.Mode

			-- แปลง EnumItem → string ก่อน assign
			if typeof(Key) == "EnumItem" then Key = Key.Name end
			KeybindDisplayLabel.Text = tostring(Key)
			Keybind.Value = Key
			Keybind.Mode = Mode
		end

		function Keybind:OnClick(Callback)
			Keybind.Clicked = Callback
		end

		function Keybind:OnChanged(Callback)
			Keybind.Changed = Callback
			Callback(Keybind.Value)
		end

		function Keybind:DoClick()
			Library:SafeCallback(Keybind.Callback, Keybind.Toggled)
			Library:SafeCallback(Keybind.Clicked, Keybind.Toggled)
		end

		function Keybind:Destroy()
			KeybindFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(KeybindDisplayFrame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Picking = true
				KeybindDisplayLabel.Text = "..."

				wait(0.2)

				local Event
				Event = UserInputService.InputBegan:Connect(function(Input)
					local Key

					if Input.UserInputType == Enum.UserInputType.Keyboard then
						Key = Input.KeyCode.Name
					elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Key = "MouseLeft"
					elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
						Key = "MouseRight"
					end

					local EndedEvent
					EndedEvent = UserInputService.InputEnded:Connect(function(Input)
						if
							Input.KeyCode.Name == Key
							or Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1
							or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
						then
							Picking = false

							KeybindDisplayLabel.Text = Key
							Keybind.Value = Key

							Library:SafeCallback(Keybind.ChangedCallback, Input.KeyCode or Input.UserInputType)
							Library:SafeCallback(Keybind.Changed, Input.KeyCode or Input.UserInputType)

							Event:Disconnect()
							EndedEvent:Disconnect()
						end
					end)
				end)
			end
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if not Picking and not UserInputService:GetFocusedTextBox() then
				if Keybind.Mode == "Toggle" then
					local Key = Keybind.Value

					if Key == "MouseLeft" or Key == "MouseRight" then
						if
							Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1
							or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
						then
							Keybind.Toggled = not Keybind.Toggled
							Keybind:DoClick()
						end
					elseif Input.UserInputType == Enum.UserInputType.Keyboard then
						if Input.KeyCode.Name == Key then
							Keybind.Toggled = not Keybind.Toggled
							Keybind:DoClick()
						end
					end
				end
			end
		end)

		Library.Options[Idx] = Keybind
		return Keybind
	end

	return Element
end)()
ElementsTable.Colorpicker = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Colorpicker"

	function Element:New(Idx, Config)
		assert(Config.Title, "Colorpicker - Missing Title")
		assert(Config.Default, "AddColorPicker: Missing default value.")

		local Colorpicker = {
			Value = Config.Default,
			Transparency = Config.Transparency or 0,
			Type = "Colorpicker",
			Title = type(Config.Title) == "string" and Config.Title or "Colorpicker",
			Callback = Config.Callback or function(Color) end,
		}

		function Colorpicker:SetHSVFromRGB(Color)
			local H, S, V = Color3.toHSV(Color)
			Colorpicker.Hue = H
			Colorpicker.Sat = S
			Colorpicker.Vib = V
		end

		Colorpicker:SetHSVFromRGB(Colorpicker.Value)

		local ColorpickerFrame = Components.Element(Config.Title, Config.Description, self.Container, true)

		Colorpicker.SetTitle = ColorpickerFrame.SetTitle
		Colorpicker.SetDesc = ColorpickerFrame.SetDesc
		Colorpicker.Visible = ColorpickerFrame.Visible
		Colorpicker.Elements = ColorpickerFrame

		local DisplayFrameColor = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Colorpicker.Value,
			Parent = ColorpickerFrame.Frame,
		}, {
			NewCorner("TinyCorner"),
		})

		local DisplayFrame = New("ImageLabel", {
			Size = UDim2.fromOffset(26, 26),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Parent = ColorpickerFrame.Frame,
			Image = "http://www.roblox.com/asset/?id=14204231522",
			ImageTransparency = 0.45,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(40, 40),
		}, {
			NewCorner("TinyCorner"),
			DisplayFrameColor,
		})

		local function CreateColorDialog()
			local Dialog = Components.Dialog:Create()
			Dialog.Title.Text = Colorpicker.Title
			Dialog.Root.Size = UDim2.fromOffset(430, 330)

			local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
			local Transparency = Colorpicker.Transparency

			local function CreateInput()
				local Box = Components.Textbox()
				Box.Frame.Parent = Dialog.Root
				Box.Frame.Size = UDim2.new(0, 90, 0, 32)

				return Box
			end

			local function CreateInputLabel(Text, Pos)
				return New("TextLabel", {
					FontFace = GetStyleProperty("FontMedium"),
					Text = Text,
					TextColor3 = Color3.fromRGB(240, 240, 240),
					TextSize = GetStyleProperty("TextSizeMd"),
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 32),
					Position = Pos,
					BackgroundTransparency = 1,
					Parent = Dialog.Root,
					ThemeTag = {
						TextColor3 = "Text",
					},
				})
			end

			local function GetRGB()
				local Value = Color3.fromHSV(Hue, Sat, Vib)
				return { R = math.floor(Value.r * 255), G = math.floor(Value.g * 255), B = math.floor(Value.b * 255) }
			end

			local SatCursor = New("ImageLabel", {
				Size = UDim2.new(0, 18, 0, 18),
				ScaleType = Enum.ScaleType.Fit,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=4805639000",
			})

			local SatVibMap = New("ImageLabel", {
				Size = UDim2.fromOffset(180, 160),
				Position = UDim2.fromOffset(20, 55),
				Image = "rbxassetid://4155801252",
				BackgroundColor3 = Colorpicker.Value,
				BackgroundTransparency = 0,
				Parent = Dialog.Root,
			}, {
				NewCorner("TinyCorner"),
				SatCursor,
			})

			local OldColorFrame = New("Frame", {
				BackgroundColor3 = Colorpicker.Value,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = Colorpicker.Transparency,
			}, {
				NewCorner("TinyCorner"),
			})
			local OldColorFrameChecker = New("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=14204231522",
				ImageTransparency = 0.45,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(40, 40),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(112, 220),
				Size = UDim2.fromOffset(88, 24),
				Parent = Dialog.Root,
			}, {
				NewCorner("TinyCorner"),
				New("UIStroke", { Transparency = 0.75, Thickness = GetStyleProperty("BorderThickness") }),
				OldColorFrame,
			})

			local DialogDisplayFrame = New("Frame", {
				BackgroundColor3 = Colorpicker.Value,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 0,
			}, {
				NewCorner("TinyCorner"),
			})

			local DialogDisplayFrameChecker = New("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=14204231522",
				ImageTransparency = 0.45,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(40, 40),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(20, 220),
				Size = UDim2.fromOffset(88, 24),
				Parent = Dialog.Root,
			}, {
				NewCorner("TinyCorner"),
				New("UIStroke", { Transparency = 0.75, Thickness = GetStyleProperty("BorderThickness") }),
				DialogDisplayFrame,
			})

			local SequenceTable = {}

			for Color = 0, 1, 0.1 do
				table.insert(SequenceTable, ColorSequenceKeypoint.new(Color, Color3.fromHSV(Color, 1, 1)))
			end

			local HueSliderGradient = New("UIGradient", {
				Color = ColorSequence.new(SequenceTable),
				Rotation = 90,
			})

			local HueDragHolder = New("Frame", {
				Size = UDim2.new(1, 0, 1, -10),
				Position = UDim2.fromOffset(0, 5),
				BackgroundTransparency = 1,
			})

			local HueDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(14, 14),
				Image = "http://www.roblox.com/asset/?id=12266946128",
				Parent = HueDragHolder,
				ThemeTag = {
					ImageColor3 = "DialogInput",
				},
			})

			local HueSlider = New("Frame", {
				Size = UDim2.fromOffset(12, 190),
				Position = UDim2.fromOffset(210, 55),
				Parent = Dialog.Root,
			}, {
				NewCorner("PillCorner"),
				HueSliderGradient,
				HueDragHolder,
			})

			local HexInput = CreateInput()
			HexInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 55)
			CreateInputLabel("Hex", UDim2.fromOffset(Config.Transparency and 360 or 340, 55))

			local RedInput = CreateInput()
			RedInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 95)
			CreateInputLabel("Red", UDim2.fromOffset(Config.Transparency and 360 or 340, 95))

			local GreenInput = CreateInput()
			GreenInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 135)
			CreateInputLabel("Green", UDim2.fromOffset(Config.Transparency and 360 or 340, 135))

			local BlueInput = CreateInput()
			BlueInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 175)
			CreateInputLabel("Blue", UDim2.fromOffset(Config.Transparency and 360 or 340, 175))

			local AlphaInput
			if Config.Transparency then
				AlphaInput = CreateInput()
				AlphaInput.Frame.Position = UDim2.fromOffset(260, 215)
				CreateInputLabel("Alpha", UDim2.fromOffset(360, 215))
			end

			local TransparencySlider, TransparencyDrag, TransparencyColor
			if Config.Transparency then
				local TransparencyDragHolder = New("Frame", {
					Size = UDim2.new(1, 0, 1, -10),
					Position = UDim2.fromOffset(0, 5),
					BackgroundTransparency = 1,
				})

				TransparencyDrag = New("ImageLabel", {
					Size = UDim2.fromOffset(14, 14),
					Image = "http://www.roblox.com/asset/?id=12266946128",
					Parent = TransparencyDragHolder,
					ThemeTag = {
						ImageColor3 = "DialogInput",
					},
				})

				TransparencyColor = New("Frame", {
					Size = UDim2.fromScale(1, 1),
				}, {
					New("UIGradient", {
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(1, 1),
						}),
						Rotation = 270,
					}),
					NewCorner("PillCorner"),
				})

				TransparencySlider = New("Frame", {
					Size = UDim2.fromOffset(12, 190),
					Position = UDim2.fromOffset(230, 55),
					Parent = Dialog.Root,
					BackgroundTransparency = 1,
				}, {
					NewCorner("PillCorner"),
					New("ImageLabel", {
						Image = "http://www.roblox.com/asset/?id=14204231522",
						ImageTransparency = 0.45,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = UDim2.fromOffset(40, 40),
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						Parent = Dialog.Root,
					}, {
						NewCorner("PillCorner"),
					}),
					TransparencyColor,
					TransparencyDragHolder,
				})
			end

			local function Display()
				SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
				HueDrag.Position = UDim2.new(0, -1, Hue, -6)
				SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)
				DialogDisplayFrame.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)

				HexInput.Input.Text = "#" .. Color3.fromHSV(Hue, Sat, Vib):ToHex()
				RedInput.Input.Text = GetRGB()["R"]
				GreenInput.Input.Text = GetRGB()["G"]
				BlueInput.Input.Text = GetRGB()["B"]

				if Config.Transparency then
					TransparencyColor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
					DialogDisplayFrame.BackgroundTransparency = Transparency
					TransparencyDrag.Position = UDim2.new(0, -1, 1 - Transparency, -6)
					AlphaInput.Input.Text = Library:Round((1 - Transparency) * 100, 0) .. "%"
				end
			end

			Creator.AddSignal(HexInput.Input.FocusLost, function(Enter)
				if Enter then
					local Success, Result = pcall(Color3.fromHex, HexInput.Input.Text)
					if Success and typeof(Result) == "Color3" then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
				Display()
			end)

			Creator.AddSignal(RedInput.Input.FocusLost, function(Enter)
				if Enter then
					local CurrentColor = GetRGB()
					local Success, Result = pcall(Color3.fromRGB, RedInput.Input.Text, CurrentColor["G"], CurrentColor["B"])
					if Success and typeof(Result) == "Color3" then
						if tonumber(RedInput.Input.Text) <= 255 then
							Hue, Sat, Vib = Color3.toHSV(Result)
						end
					end
				end
				Display()
			end)

			Creator.AddSignal(GreenInput.Input.FocusLost, function(Enter)
				if Enter then
					local CurrentColor = GetRGB()
					local Success, Result =
						pcall(Color3.fromRGB, CurrentColor["R"], GreenInput.Input.Text, CurrentColor["B"])
					if Success and typeof(Result) == "Color3" then
						if tonumber(GreenInput.Input.Text) <= 255 then
							Hue, Sat, Vib = Color3.toHSV(Result)
						end
					end
				end
				Display()
			end)

			Creator.AddSignal(BlueInput.Input.FocusLost, function(Enter)
				if Enter then
					local CurrentColor = GetRGB()
					local Success, Result =
						pcall(Color3.fromRGB, CurrentColor["R"], CurrentColor["G"], BlueInput.Input.Text)
					if Success and typeof(Result) == "Color3" then
						if tonumber(BlueInput.Input.Text) <= 255 then
							Hue, Sat, Vib = Color3.toHSV(Result)
						end
					end
				end
				Display()
			end)

			if Config.Transparency then
				Creator.AddSignal(AlphaInput.Input.FocusLost, function(Enter)
					if Enter then
						pcall(function()
							local Value = tonumber(AlphaInput.Input.Text)
							if Value >= 0 and Value <= 100 then
								Transparency = 1 - Value * 0.01
							end
						end)
					end
					Display()
				end)
			end

			Creator.AddSignal(SatVibMap.InputBegan, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinX = SatVibMap.AbsolutePosition.X
						local MaxX = MinX + SatVibMap.AbsoluteSize.X
						local MouseX = math.clamp(Mouse.X, MinX, MaxX)

						local MinY = SatVibMap.AbsolutePosition.Y
						local MaxY = MinY + SatVibMap.AbsoluteSize.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

						Sat = (MouseX - MinX) / (MaxX - MinX)
						Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			Creator.AddSignal(HueSlider.InputBegan, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinY = HueSlider.AbsolutePosition.Y
						local MaxY = MinY + HueSlider.AbsoluteSize.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

						Hue = ((MouseY - MinY) / (MaxY - MinY))
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			if Config.Transparency then
				Creator.AddSignal(TransparencySlider.InputBegan, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local MinY = TransparencySlider.AbsolutePosition.Y
							local MaxY = MinY + TransparencySlider.AbsoluteSize.Y
							local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

							Transparency = 1 - ((MouseY - MinY) / (MaxY - MinY))
							Display()

							RenderStepped:Wait()
						end
					end
				end)
			end

			Display()

			Dialog:Button("Done", function()
				Colorpicker:SetValue({ Hue, Sat, Vib }, Transparency)
			end)
			Dialog:Button("Cancel")
			Dialog:Open()
		end

		function Colorpicker:Display()
			Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)

			DisplayFrameColor.BackgroundColor3 = Colorpicker.Value
			DisplayFrameColor.BackgroundTransparency = Colorpicker.Transparency

			Element.Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
			Element.Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
		end

		function Colorpicker:SetValue(HSV, Transparency)
			local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

			Colorpicker.Transparency = Transparency or 0
			Colorpicker:SetHSVFromRGB(Color)
			Colorpicker:Display()
		end

		function Colorpicker:SetValueRGB(Color, Transparency)
			Colorpicker.Transparency = Transparency or 0
			Colorpicker:SetHSVFromRGB(Color)
			Colorpicker:Display()
		end

		function Colorpicker:OnChanged(Func)
			Colorpicker.Changed = Func
			Func(Colorpicker.Value)
		end

		function Colorpicker:Destroy()
			ColorpickerFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(ColorpickerFrame.Frame.MouseButton1Click, function()
			CreateColorDialog()
		end)

		Creator.AddSignal(ColorpickerFrame.Frame.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.Touch then
				CreateColorDialog()
			end
		end)

		Colorpicker:Display()

		Library.Options[Idx] = Colorpicker
		return Colorpicker
	end

	return Element
end)()
ElementsTable.Input = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Input"

	function Element:New(Idx, Config)
		assert(Config.Title, "Input - Missing Title")
		Config.Callback = Config.Callback or function() end

		local Input = {
			Value = Config.Default or "",
			Numeric = Config.Numeric or false,
			Finished = Config.Finished or false,
			Callback = Config.Callback or function(Value) end,
			Type = "Input",
		}

		local InputFrame = Components.Element(Config.Title, Config.Description, self.Container, false)

		Input.SetTitle = InputFrame.SetTitle
		Input.SetDesc = InputFrame.SetDesc
		Input.Visible = InputFrame.Visible
		Input.Elements = InputFrame

		local Textbox = Components.Textbox(InputFrame.Frame, true)
		Textbox.Frame.Position = UDim2.new(1, -10, 0.5, 0)
		Textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
		Textbox.Frame.Size = UDim2.fromOffset(160, 32)
		Textbox.Input.Text = Config.Default or ""
		Textbox.Input.PlaceholderText = Config.Placeholder or ""

		local Box = Textbox.Input

		function Input:SetValue(Text)
			if Config.MaxLength and #Text > Config.MaxLength then
				Text = Text:sub(1, Config.MaxLength)
			end

			if Input.Numeric then
				if (not tonumber(Text)) and Text:len() > 0 then
					Text = Input.Value
				end
			end

			Input.Value = Text
			Box.Text = Text

			Library:SafeCallback(Input.Callback, Input.Value)
			Library:SafeCallback(Input.Changed, Input.Value)
		end

		if Input.Finished then
			AddSignal(Box.FocusLost, function(enter)
				if not enter then
					return
				end
				Input:SetValue(Box.Text)
			end)
		else
			AddSignal(Box:GetPropertyChangedSignal("Text"), function()
				Input:SetValue(Box.Text)
			end)
		end

		function Input:OnChanged(Func)
			Input.Changed = Func
			Func(Input.Value)
		end

		function Input:Destroy()
			InputFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Library.Options[Idx] = Input
		return Input
	end

	return Element
end)()

ElementsTable.MiniBar = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "MiniBar"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "MiniBar - Missing Title")
		Config.Min     = Config.Min     or 0
		Config.Max     = Config.Max     or 100
		Config.Default = Config.Default or 0
		Config.Color   = Config.Color   or nil

		local Bar = {
			Value    = Config.Default,
			Min      = Config.Min,
			Max      = Config.Max,
			Type     = "MiniBar",
			Callback = Config.Callback or function() end,
		}

		local BarFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		Bar.SetTitle = BarFrame.SetTitle
		Bar.SetDesc  = BarFrame.SetDesc
		Bar.Visible  = BarFrame.Visible
		Bar.Elements = BarFrame

		-- Label เปอร์เซ็นต์ ชิดขวาสุด
		local PctLabel = New("TextLabel", {
			Text             = "0%",
			FontFace         = GetStyleProperty("FontMedium"),
			TextSize = GetStyleProperty("TextSizeSm"),
			AnchorPoint      = Vector2.new(1, 0.5),
			Position         = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 1,
			Size             = UDim2.fromOffset(36, 16),
			TextXAlignment   = Enum.TextXAlignment.Right,
			Parent           = BarFrame.Frame,
			ThemeTag         = { TextColor3 = "SubText" },
		})

		-- Track อยู่ซ้ายของ label เหมือน Slider
		local Track = New("Frame", {
			AnchorPoint          = Vector2.new(1, 0.5),
			Position             = UDim2.new(1, -50, 0.5, 0),
			Size                 = UDim2.new(1, 0, 0, 6),
			BackgroundTransparency = 0.5,
			Parent               = BarFrame.Frame,
			ThemeTag             = { BackgroundColor3 = "SliderRail" },
		}, {
			NewCorner("PillCorner"),
			New("UISizeConstraint", { MaxSize = Vector2.new(150, math.huge) }),
		})

		-- Fill bar
		local Fill = New("Frame", {
			Size             = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Config.Color or Color3.fromRGB(96, 205, 255),
			Parent           = Track,
			ThemeTag         = Config.Color and {} or { BackgroundColor3 = "Accent" },
		}, {
			NewCorner("PillCorner"),
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.1),
					NumberSequenceKeypoint.new(0.6, 0),
					NumberSequenceKeypoint.new(1, 0.15),
				}),
			}),
		})

		function Bar:SetValue(Value)
			Value = math.clamp(Value, self.Min, self.Max)
			self.Value = Value
			local pct = (Value - self.Min) / math.max(self.Max - self.Min, 1)
			TweenService:Create(Fill, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(pct, 0, 1, 0)
			}):Play()
			PctLabel.Text = math.floor(pct * 100) .. "%"
			Library:SafeCallback(Bar.Callback, Value)
			Library:SafeCallback(Bar.Changed,  Value)
		end

		function Bar:OnChanged(Func) Bar.Changed = Func Func(Bar.Value) end
		function Bar:Destroy() BarFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		Bar:SetValue(Config.Default)
		if Idx then Library.Options[Idx] = Bar end
		return Bar
	end
	return Element
end)()

ElementsTable.Separator = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Separator"

	function Element:New(Idx, Config)
                Config = Config or {}  
		Config.Label = Config.Label or ""
		local Sep = { Type = "Separator" }

		local Root = New("Frame", {
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			Parent = self.Container,
			LayoutOrder = 7,
		})

		if Config.Label ~= "" then
			New("TextLabel", {
				Text = Config.Label,
				FontFace = GetStyleProperty("FontSemiBold"),
				TextSize = GetStyleProperty("TextSizeXs"),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 14),
				AutomaticSize = Enum.AutomaticSize.X,
				Parent = Root,
				ThemeTag = { TextColor3 = "SubText" },
			})
		end

		local lineL = New("Frame", {
			Size = UDim2.new(0.5, Config.Label ~= "" and -10 or 0, 0, 1),
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			Parent = Root,
			BackgroundTransparency = 0.6,
			ThemeTag = { BackgroundColor3 = "TitleBarLine" },
		}, { New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }) }) })

		local lineR = New("Frame", {
			Size = UDim2.new(0.5, Config.Label ~= "" and -10 or 0, 0, 1),
			Position = UDim2.fromScale(1, 0.5),
			AnchorPoint = Vector2.new(1, 0.5),
			Parent = Root,
			BackgroundTransparency = 0.6,
			ThemeTag = { BackgroundColor3 = "TitleBarLine" },
		}, { New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) }) })

		function Sep:Destroy() Root:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = Sep end
		return Sep
	end
	return Element
end)()

ElementsTable.Alert = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Alert"

	local AlertColors = {
		info    = { bg = Color3.fromRGB(30, 80, 160),    icon = "rbxassetid://10723415903" },
		success = { bg = Color3.fromRGB(30, 130, 80),    icon = "rbxassetid://10709751939" },
		warning = { bg = Color3.fromRGB(160, 110, 20),   icon = "rbxassetid://10709753149" },
		error   = { bg = Color3.fromRGB(160, 35, 35),    icon = "rbxassetid://10709752996" },
	}

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Alert - Missing Title")
		Config.Type = Config.Type or "info"
		Config.Content = Config.Content or ""

		local Alert = { Type = "Alert" }
		local style = AlertColors[Config.Type] or AlertColors.info

		local Root = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = style.bg,
			BackgroundTransparency = 0.75,
			Parent = self.Container,
			LayoutOrder = 7,
		}, {
			NewCorner("SmallCorner"),
			New("UIStroke", { Color = style.bg, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
			New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) }),
			New("UIListLayout", { Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Top }),
			New("ImageLabel", {
				Image = style.icon,
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				LayoutOrder = 1,
			}),
			New("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -22, 0, 0),
				LayoutOrder = 2,
			}, {
				New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
				New("TextLabel", {
					Text = Config.Title,
					FontFace = GetStyleProperty("FontBold"),
					TextSize = GetStyleProperty("TextSizeMd"),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 16),
					LayoutOrder = 1,
				}),
				New("TextLabel", {
					Text = Config.Content,
					FontFace = GetStyleProperty("FontMedium"),
					TextSize = GetStyleProperty("TextSizeSm"),
					TextColor3 = Color3.fromRGB(220, 220, 220),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 2,
					Visible = Config.Content ~= "",
				}),
			}),
		})

		function Alert:Destroy() Root:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = Alert end
		return Alert
	end
	return Element
end)()

ElementsTable.Checkbox = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Checkbox"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Checkbox - Missing Title")

		local Checkbox = {
			Value = Config.Default or false,
			Type = "Checkbox",
			Callback = Config.Callback or function() end,
		}

		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		Checkbox.SetTitle = CBFrame.SetTitle
		Checkbox.SetDesc = CBFrame.SetDesc
		Checkbox.Visible = CBFrame.Visible
		Checkbox.Elements = CBFrame

		local CheckBg = New("Frame", {
			Size = UDim2.fromOffset(20, 20),
			Position = UDim2.new(1, -12, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88,
			Parent = CBFrame.Frame,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			NewCorner("SmallCorner"),
			New("UIStroke", {
				Transparency = 0.35,
				Thickness = GetStyleProperty("BorderThickness"),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = { Color = "Accent" },
			}),
		})

		local CheckMark = New("ImageLabel", {
			Image = "rbxassetid://10734966248",
			Size = UDim2.fromOffset(11, 11),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ImageTransparency = 1,
			Parent = CheckBg,
		})

		local function UpdateVisual(val)
			local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			TweenService:Create(CheckBg, ti, {
				BackgroundTransparency = val and 0.05 or 0.88,
			}):Play()
			TweenService:Create(CheckMark, ti, {
				ImageTransparency = val and 0 or 1,
				Size = val and UDim2.fromOffset(13, 13) or UDim2.fromOffset(7, 7),
			}):Play()
		end

		Creator.AddSignal(CBFrame.Frame.MouseButton1Click, function()
			Checkbox.Value = not Checkbox.Value
			UpdateVisual(Checkbox.Value)
			Library:SafeCallback(Checkbox.Callback, Checkbox.Value)
			Library:SafeCallback(Checkbox.Changed, Checkbox.Value)
		end)

		function Checkbox:SetValue(val)
			self.Value = val
			UpdateVisual(val)
			Library:SafeCallback(self.Callback, val)
			Library:SafeCallback(self.Changed, val)
		end
		function Checkbox:OnChanged(Func) Checkbox.Changed = Func Func(Checkbox.Value) end
		function Checkbox:Destroy() CBFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		UpdateVisual(Config.Default or false)
		if Idx then Library.Options[Idx] = Checkbox end
		return Checkbox
	end
	return Element
end)()

ElementsTable.RadioGroup = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "RadioGroup"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "RadioGroup - Missing Title")
		assert(Config.Options, "RadioGroup - Missing Options table")

		-- [ จุดที่เพิ่ม 1 ] เช็คว่าเปิดโหมด Multi หรือไม่
		local IsMulti = Config.Multi or false

		local Radio = {
			Options = Config.Options,
			Type = "RadioGroup",
			IsMulti = IsMulti,
			Callback = Config.Callback or function() end,
		}

		-- [ จุดที่เพิ่ม 2 ] จัดการค่าเริ่มต้น (Default) ให้รองรับทั้งแบบ Single และ Multi
		if IsMulti then
			Radio.Value = {} -- เก็บเป็น Dictionary ภายในเพื่อง่ายต่อการเปิด/ปิด
			if type(Config.Default) == "table" then
				for _, v in pairs(Config.Default) do
					Radio.Value[v] = true
				end
			elseif Config.Default ~= nil then
				Radio.Value[Config.Default] = true
			end
		else
			Radio.Value = Config.Default or Config.Options[1]
		end

		local RGFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		Radio.SetTitle = RGFrame.SetTitle
		Radio.SetDesc = RGFrame.SetDesc
		Radio.Visible = RGFrame.Visible
		Radio.Elements = RGFrame

		local OptionsHolder = New("Frame", {
			Size = UDim2.new(1, -20, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Parent = RGFrame.LabelHolder,
			LayoutOrder = 3,
		}, {
			New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
			New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 6) }),
		})

		local Buttons = {}

		-- [ จุดที่เพิ่ม 3 ] ฟังก์ชันตัวช่วยดึงค่าเพื่อส่งออกไปที่ Callback (จะได้ตารางสวยๆ)
		local function GetCallbackValue()
			if not IsMulti then return Radio.Value end
			local selected = {}
			for _, opt in ipairs(Radio.Options) do -- เรียงลำดับตาม Options เดิม
				if Radio.Value[opt] then
					table.insert(selected, opt)
				end
			end
			return selected
		end

		-- [ จุดที่เพิ่ม 4 ] อัปเดต UI ให้สอดคล้องกับโหมด (Single เช็คค่าตรงๆ / Multi เช็คใน Table)
		local function UpdateRadio()
			for _, btn in pairs(Buttons) do
				local isSelected = false
				if IsMulti then
					isSelected = Radio.Value[btn.Value] == true
				else
					isSelected = (btn.Value == Radio.Value)
				end

				local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				TweenService:Create(btn.Outer, ti, {
					BackgroundTransparency = isSelected and 0.05 or 0.88,
					Size = isSelected and UDim2.fromOffset(18, 18) or UDim2.fromOffset(16, 16),
				}):Play()
				TweenService:Create(btn.Inner, ti, {
					BackgroundTransparency = isSelected and 0 or 1,
					Size = isSelected and UDim2.fromOffset(9, 9) or UDim2.fromOffset(5, 5),
				}):Play()
			end
		end

		for _, opt in ipairs(Config.Options) do
			local Row = New("TextButton", {
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = 1,
				Text = "",
				Parent = OptionsHolder,
			}, {
				New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 8),
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
			})

			-- (เพิ่มเติม: ถ้าเป็น Multi จะเปลี่ยนปุ่มเป็นสี่เหลี่ยมแบบ Checkbox แทนวงกลมก็ได้นะ ลองแก้ CornerRadius ดู)
			local Outer = New("Frame", {
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 0.9,
				Parent = Row,
				ThemeTag = { BackgroundColor3 = "Accent" },
			}, {
				NewCorner("PillCorner"),
				New("UIAspectRatioConstraint", { AspectRatio = 1 }),
				New("UIStroke", { Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "Accent" } }),
			})

			local Inner = New("Frame", {
				Size = UDim2.fromOffset(4, 4),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Parent = Outer,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				NewCorner("PillCorner"),
			})

			New("TextLabel", {
				Text = tostring(opt),
				FontFace = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeMd"),
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -24, 1, 0),
				Parent = Row,
				ThemeTag = { TextColor3 = "Text" },
			})

			local BtnData = { Value = opt, Outer = Outer, Inner = Inner }
			table.insert(Buttons, BtnData)

			-- [ จุดที่เพิ่ม 5 ] ลอจิกเวลากดปุ่ม ให้รองรับ Multi Toggle
			Creator.AddSignal(Row.MouseButton1Click, function()
				if IsMulti then
					if Radio.Value[opt] then
						Radio.Value[opt] = nil -- ถ้าเปิดอยู่ให้ปิด
					else
						Radio.Value[opt] = true -- ถ้าปิดอยู่ให้เปิด
					end
				else
					Radio.Value = opt
				end

				UpdateRadio()
				local retVal = GetCallbackValue()
				Library:SafeCallback(Radio.Callback, retVal)
				Library:SafeCallback(Radio.Changed, retVal)
			end)
		end

		-- [ จุดที่เพิ่ม 6 ] รองรับคำสั่ง SetValue ผ่านสคริปต์
		function Radio:SetValue(val)
			if IsMulti then
				Radio.Value = {}
				if type(val) == "table" then
					for _, v in pairs(val) do
						Radio.Value[v] = true
					end
				elseif val ~= nil then
					Radio.Value[val] = true
				end
			else
				Radio.Value = val
			end
			UpdateRadio()
			local retVal = GetCallbackValue()
			Library:SafeCallback(self.Callback, retVal)
			Library:SafeCallback(self.Changed, retVal)
		end

		function Radio:OnChanged(Func) 
			Radio.Changed = Func 
			Func(GetCallbackValue()) 
		end

		function Radio:Destroy() 
			RGFrame.Frame:Destroy() 
			if Idx then Library.Options[Idx] = nil end 
		end

		UpdateRadio()
		if Idx then Library.Options[Idx] = Radio end
		return Radio
	end
	return Element
end)()

ElementsTable.NumberInput = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "NumberInput"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "NumberInput - Missing Title")
		Config.Default = Config.Default or 0
		Config.Step = Config.Step or 1
		Config.Min = Config.Min or -math.huge
		Config.Max = Config.Max or math.huge

		local NI = {
			Value = Config.Default,
			Step = Config.Step,
			Min = Config.Min,
			Max = Config.Max,
			Type = "NumberInput",
			Callback = Config.Callback or function() end,
		}

		local NIFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		NI.SetTitle = NIFrame.SetTitle
		NI.SetDesc = NIFrame.SetDesc
		NI.Visible = NIFrame.Visible
		NI.Elements = NIFrame

		local Holder = New("Frame", {
			Size = UDim2.fromOffset(110, 30),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.9,
			Parent = NIFrame.Frame,
			ThemeTag = { BackgroundColor3 = "Element" },
		}, {
			NewCorner("SmallCorner"),
			New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
		})

		local makeBtn = function(txt, side)
			return New("TextButton", {
				Text = txt,
				FontFace = GetStyleProperty("FontBold"),
				TextSize = GetStyleProperty("TextSizeIcon"),
				Size = UDim2.fromOffset(28, 28),
				Position = side == "L" and UDim2.fromOffset(1, 1) or UDim2.new(1, -29, 0, 1),
				BackgroundTransparency = 1,
				Parent = Holder,
				ThemeTag = { TextColor3 = "Text" },
			})
		end

		local MinusBtn = makeBtn("−", "L")
		local PlusBtn  = makeBtn("+", "R")

		local ValBox = New("TextBox", {
			Text = tostring(Config.Default),
			FontFace = GetStyleProperty("FontMedium"),
			TextSize = GetStyleProperty("TextSizeMd"),
			Size = UDim2.new(1, -58, 1, 0),
			Position = UDim2.fromOffset(30, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = Holder,
			ThemeTag = { TextColor3 = "Text" },
		})

		local function set(v)
			v = math.clamp(Library:Round(v, 0), NI.Min, NI.Max)
			NI.Value = v
			ValBox.Text = tostring(v)
			Library:SafeCallback(NI.Callback, v)
			Library:SafeCallback(NI.Changed, v)
		end

		Creator.AddSignal(MinusBtn.MouseButton1Click, function() set(NI.Value - NI.Step) end)
		Creator.AddSignal(PlusBtn.MouseButton1Click,  function() set(NI.Value + NI.Step) end)
		Creator.AddSignal(ValBox.FocusLost, function()
			local n = tonumber(ValBox.Text)
			if n then set(n) else ValBox.Text = tostring(NI.Value) end
		end)

		-- Hold to repeat
		for _, btn in ipairs({ {MinusBtn, -1}, {PlusBtn, 1} }) do
			local b, dir = btn[1], btn[2]
			Creator.AddSignal(b.MouseButton1Down, function()
				task.delay(0.5, function()
					while b:IsDescendantOf(game) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						set(NI.Value + NI.Step * dir)
						task.wait(0.08)
					end
				end)
			end)
		end

		function NI:SetValue(v) set(v) end
		function NI:OnChanged(Func) NI.Changed = Func Func(NI.Value) end
		function NI:Destroy() NIFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		if Idx then Library.Options[Idx] = NI end
		return NI
	end
	return Element
end)()

ElementsTable.ActionButton = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "ActionButton"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "ActionButton - Missing Title")
		Config.CopyText  = Config.CopyText  or ""
		-- ข้อความบนปุ่มปรับแต่งได้
		local idleLabel    = Config.ButtonText        or "Copy"
		local copiedLabel  = Config.CopiedText        or "✓ Copied"
		local resetDelay   = Config.ResetDelay        or 1.5
		local btnWidth     = Config.ButtonWidth       or 68
		local btnHeight    = Config.ButtonHeight      or 26

		local CB = { Type = "ActionButton", Value = Config.CopyText }

		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		CB.SetTitle  = CBFrame.SetTitle
		CB.SetDesc   = CBFrame.SetDesc
		CB.Visible   = CBFrame.Visible
		CB.Elements  = CBFrame

		-- ── ปุ่มเรียบ — แค่ข้อความ ไม่มีไอคอน ──────────────────────────
		local CopyBtn = New("TextButton", {
			Text                   = idleLabel,
			FontFace               = GetStyleProperty("FontMedium"),
			TextSize = GetStyleProperty("TextSizeSm"),
			Size                   = UDim2.fromOffset(btnWidth, btnHeight),
			Position               = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint            = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.85,
			AutoButtonColor        = false,
			Parent                 = CBFrame.Frame,
			ThemeTag               = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
		}, {
			NewCorner("TinyCorner"),
			New("UIStroke", {
				Transparency    = 0.5,
				Thickness       = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag        = { Color = "Accent" },
			}),
		})

		-- hover / press spring
		local CopyMotor, SetCopyT = Creator.SpringMotor(0.85, CopyBtn, "BackgroundTransparency")
		Creator.AddSignal(CopyBtn.MouseEnter,       function() SetCopyT(0.72) end)
		Creator.AddSignal(CopyBtn.MouseLeave,       function() SetCopyT(0.85) end)
		Creator.AddSignal(CopyBtn.MouseButton1Down, function() SetCopyT(0.60) end)
		Creator.AddSignal(CopyBtn.MouseButton1Up,   function() SetCopyT(0.72) end)

		Creator.AddSignal(CopyBtn.MouseButton1Click, function()
			pcall(function()
				if setclipboard then    setclipboard(CB.Value)
				elseif toclipboard then toclipboard(CB.Value) end
			end)
			-- feedback: เปลี่ยนข้อความชั่วคราว
			CopyBtn.Text = copiedLabel
			task.delay(resetDelay, function()
				if CopyBtn and CopyBtn.Parent then
					CopyBtn.Text = idleLabel
				end
			end)
			Library:SafeCallback(Config.Callback, CB.Value)
		end)

		-- ── API ─────────────────────────────────────────────────────────
		function CB:SetCopyText(t)  self.Value = t end
		function CB:SetButtonText(idle, copied)
			idleLabel   = idle   or idleLabel
			copiedLabel = copied or copiedLabel
			if CopyBtn and CopyBtn.Parent then CopyBtn.Text = idleLabel end
		end
		function CB:Destroy()
			CBFrame.Frame:Destroy()
			if Idx then Library.Options[Idx] = nil end
		end

		if Idx then Library.Options[Idx] = CB end
		return CB
	end
	return Element
end)()

ElementsTable.QuickActions = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "QuickActions"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "QuickActions - Missing Title")
		assert(Config.Actions, "QuickActions - Missing Actions table")

		local QA = { Type = "QuickActions" }
		local QAFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		QA.SetTitle = QAFrame.SetTitle
		QA.SetDesc  = QAFrame.SetDesc
		QA.Visible  = QAFrame.Visible
		QA.Elements = QAFrame

		local ActionsHolder = New("Frame", {
			Size = UDim2.fromOffset(0, 30),
			AutomaticSize = Enum.AutomaticSize.X,
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent = QAFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 4),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),
		})

		for _, action in ipairs(Config.Actions) do
			local iconImg = action.Icon and Library:GetIcon(action.Icon) or action.Image or ""

			local Btn = New("TextButton", {
				Size = UDim2.fromOffset(30, 30),
				BackgroundTransparency = 0.88,
				Text = action.Icon and "" or (action.Text or ""),
				FontFace = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeXs"),
				Parent = ActionsHolder,
				ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" },
			}, {
				NewCorner("SmallCorner"),
				New("UIStroke", { Transparency = 0.6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
				iconImg ~= "" and New("ImageLabel", {
					Image = iconImg,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ThemeTag = { ImageColor3 = "Text" },
				}) or nil,
			})

			local Motor, SetT = Creator.SpringMotor(0.88, Btn, "BackgroundTransparency")
			Creator.AddSignal(Btn.MouseEnter, function() SetT(0.75) end)
			Creator.AddSignal(Btn.MouseLeave, function() SetT(0.88) end)
			Creator.AddSignal(Btn.MouseButton1Down, function() SetT(0.95) end)
			Creator.AddSignal(Btn.MouseButton1Up, function() SetT(0.75) end)
			Creator.AddSignal(Btn.MouseButton1Click, function()
				Library:SafeCallback(action.Callback)
			end)
		end

		function QA:Destroy() QAFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = QA end
		return QA
	end
	return Element
end)()

ElementsTable.ButtonGroup = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "ButtonGroup"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "ButtonGroup - Missing Title")
		assert(Config.Buttons, "ButtonGroup - Missing Buttons")

		local BG = { Type = "ButtonGroup" }
		local BGFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		BG.SetTitle = BGFrame.SetTitle
		BG.SetDesc  = BGFrame.SetDesc
		BG.Visible  = BGFrame.Visible
		BG.Elements = BGFrame

		local BtnRow = New("Frame", {
			Size = UDim2.fromOffset(0, 28),
			AutomaticSize = Enum.AutomaticSize.X,
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent = BGFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 0),
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		})

		for i, btn in ipairs(Config.Buttons) do
			local isFirst = i == 1
			local isLast  = i == #Config.Buttons

			local B = New("TextButton", {
				Text = btn.Text or "Button",
				FontFace = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeSm"),
				Size = UDim2.fromOffset(0, 28),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 0.85,
				Parent = BtnRow,
				ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" },
			}, {
				New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
			})

			local Motor, SetT = Creator.SpringMotor(0.85, B, "BackgroundTransparency")
			Creator.AddSignal(B.MouseEnter, function() SetT(0.72) end)
			Creator.AddSignal(B.MouseLeave, function() SetT(0.85) end)
			Creator.AddSignal(B.MouseButton1Down, function() SetT(0.95) end)
			Creator.AddSignal(B.MouseButton1Up, function() SetT(0.72) end)
			Creator.AddSignal(B.MouseButton1Click, function()
				Library:SafeCallback(btn.Callback)
			end)
		end

		function BG:Destroy() BGFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = BG end
		return BG
	end
	return Element
end)()

ElementsTable.Divider = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Divider"

	function Element:New(Idx, Config)
		Config = Config or {}
		local DV = { Type = "Divider" }

		local divH = Config.Height or 1
		local Root = New("Frame", {
			Size = UDim2.new(1, 0, 0, divH + (Config.Label and 20 or 0)),
			BackgroundTransparency = 1,
			Parent = self.Container,
			LayoutOrder = 7,
		})

		local Line = New("Frame", {
			Size = UDim2.new(1, -24, 0, divH),
			Position = UDim2.new(0, 12, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 0.55,
			Parent = Root,
			ThemeTag = { BackgroundColor3 = "InElementBorder" },
		}, {
			NewCorner("PillCorner"),
			-- fade ขอบซ้าย-ขวาเสมอ
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.15, 0),
					NumberSequenceKeypoint.new(0.85, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		})

		if Config.Label and Config.Label ~= "" then
			local LabelBg = New("Frame", {
				Size = UDim2.fromOffset(0, 18),
				AutomaticSize = Enum.AutomaticSize.X,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 0.88,
				Parent = Root,
				ThemeTag = { BackgroundColor3 = "Element" },
			}, {
				NewCorner("PillCorner"),
				New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
				New("TextLabel", {
					Text = Config.Label,
					FontFace = GetStyleProperty("FontMedium"),
					TextSize = GetStyleProperty("TextSizeXs"),
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(0, 18),
					AutomaticSize = Enum.AutomaticSize.X,
					TextXAlignment = Enum.TextXAlignment.Center,
					ThemeTag = { TextColor3 = "SubText" },
				}),
			})
		end

		function DV:Destroy() Root:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = DV end
		return DV
	end
	return Element
end)()

ElementsTable.Chip = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Chip"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Chip - Missing Title")
		Config.Items = Config.Items or {}
		Config.Multi = Config.Multi ~= false

		local CH = {
			Type = "Chip",
			Value = Config.Default and table.clone(Config.Default) or {},
			Callback = Config.Callback or function() end,
		}

		local CHFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		CH.SetTitle = CHFrame.SetTitle
		CH.SetDesc  = CHFrame.SetDesc
		CH.Visible  = CHFrame.Visible
		CH.Elements = CHFrame

		local ChipRow = New("Frame", {
			Size = UDim2.new(1, -20, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Parent = CHFrame.LabelHolder,
			LayoutOrder = 3,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8), -- ลดระยะห่างระหว่างปุ่มนิดนึงให้ดูเป็นกลุ่มก้อน
				Wraps = true,
			}),
			New("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) }),
		})

		local ChipBtns = {}

		-- ฟังก์ชันอัปเดตสถานะปุ่ม (เพิ่ม Animation ให้ตัวหนังสือและขอบ)
		local function updateChip(item, btn)
			local active = table.find(CH.Value, item) ~= nil
			local stroke = btn:FindFirstChildOfClass("UIStroke")

			-- อนิเมชันพื้นหลังและตัวหนังสือ
			TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = active and 0.15 or 0.92, -- กดแล้วสว่าง, ไม่กดจะจางๆ
				TextTransparency = active and 0 or 0.4 -- กดแล้วข้อความชัด 100%, ไม่กดข้อความจะดรอปลงนิดนึง
			}):Play()

			-- อนิเมชันขอบ (Stroke)
			if stroke then
				TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = active and 0.15 or 0.85
				}):Play()
			end
		end

		for _, item in ipairs(Config.Items) do
			local chip = New("TextButton", {
				Text = tostring(item),
				FontFace = GetStyleProperty("FontMedium"), -- เปลี่ยนเป็น Medium ให้อ่านง่ายและคลีนขึ้น
				TextSize = GetStyleProperty("TextSizeSm"), -- ขยายตัวอักษรขึ้นนิดนึง (จาก 11)
				Size = UDim2.fromOffset(0, 28), -- เพิ่มความสูงปุ่มให้อักษรอยู่ตรงกลางสวยๆ
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 0.92,
				TextXAlignment = Enum.TextXAlignment.Center, -- จัดกึ่งกลางแนวนอน
				TextYAlignment = Enum.TextYAlignment.Center, -- จัดกึ่งกลางแนวตั้ง
				Parent = ChipRow,
				ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
			}, {
				NewCorner("PillCorner"), -- ขอบมนแบบเม็ดยา (Pill shape)
				New("UIStroke", { Transparency = 0.85, Thickness = GetStyleProperty("BorderThickness"), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "Accent" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }), -- เพิ่มพื้นที่หายใจซ้ายขวา
			})

			ChipBtns[item] = chip
			updateChip(item, chip)

			Creator.AddSignal(chip.MouseButton1Click, function()
				local idx = table.find(CH.Value, item)
				if idx then
					table.remove(CH.Value, idx)
				else
					if not Config.Multi then CH.Value = {} end
					table.insert(CH.Value, item)
				end
				for it, btn in pairs(ChipBtns) do
					updateChip(it, btn)
				end
				Library:SafeCallback(CH.Callback, CH.Value)
				Library:SafeCallback(CH.Changed, CH.Value)
			end)
		end

		function CH:SetValue(v)
			self.Value = v
			for it, btn in pairs(ChipBtns) do updateChip(it, btn) end
			Library:SafeCallback(self.Callback, v)
			Library:SafeCallback(self.Changed, v)
		end
		function CH:OnChanged(Func) CH.Changed = Func Func(CH.Value) end
		function CH:Destroy() CHFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		if Idx then Library.Options[Idx] = CH end
		return CH
	end
	return Element
end)()

-- END OF 30 NEW ELEMENTS

ElementsTable.StatusIndicator = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "StatusIndicator"

	local StatusColors = {
		online  = Color3.fromRGB(0,  200, 100),
		offline = Color3.fromRGB(120, 120, 120),
		running = Color3.fromRGB(96,  205, 255),
		stopped = Color3.fromRGB(255, 80,  80),
		warning = Color3.fromRGB(255, 200, 50),
	}

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "StatusIndicator - Missing Title")
		Config.Status = Config.Status or "offline"
		Config.Label  = Config.Label  or Config.Status

		local SI = { Type = "StatusIndicator", Status = Config.Status }
		local SIFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		SI.SetTitle = SIFrame.SetTitle
		SI.SetDesc  = SIFrame.SetDesc
		SI.Visible  = SIFrame.Visible
		SI.Elements = SIFrame

		local Holder = New("Frame", {
			Size               = UDim2.fromOffset(0, 22),
			AutomaticSize      = Enum.AutomaticSize.X,
			Position           = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint        = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent             = SIFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection      = Enum.FillDirection.Horizontal,
				Padding            = UDim.new(0, 6),
				VerticalAlignment  = Enum.VerticalAlignment.Center,
			}),
		})

		local Dot = New("Frame", {
			Size               = UDim2.fromOffset(8, 8),
			BackgroundColor3   = StatusColors[Config.Status] or StatusColors.offline,
			Parent             = Holder,
		}, {
			NewCorner("PillCorner"),
			New("UIAspectRatioConstraint", { AspectRatio = 1 }),
		})

		local StatusLabel = New("TextLabel", {
			Text               = Config.Label,
			FontFace           = GetStyleProperty("FontMedium"),
			TextSize = GetStyleProperty("TextSizeSm"),
			BackgroundTransparency = 1,
			Size               = UDim2.fromOffset(0, 14),
			AutomaticSize      = Enum.AutomaticSize.X,
			TextColor3         = StatusColors[Config.Status] or StatusColors.offline,
			Parent             = Holder,
		})

		function SI:SetStatus(status, label)
			self.Status = status
			local col = StatusColors[status] or StatusColors.offline
			Dot.BackgroundColor3 = col
			StatusLabel.TextColor3 = col
			StatusLabel.Text = label or status
			-- pulse animation เมื่อ running
			if status == "running" then
				local function pulse()
					if SI.Status ~= "running" then return end
					TweenService:Create(Dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Size = UDim2.fromOffset(10, 10) }):Play()
					task.delay(0.6, function()
						if SI.Status ~= "running" then return end
						TweenService:Create(Dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Size = UDim2.fromOffset(8, 8) }):Play()
						task.delay(0.6, pulse)
					end)
				end
				pulse()
			else
				Dot.Size = UDim2.fromOffset(8, 8)
			end
		end

		function SI:Destroy() SIFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		SI:SetStatus(Config.Status, Config.Label)
		if Idx then Library.Options[Idx] = SI end
		return SI
	end
	return Element
end)()

ElementsTable.CounterButton = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "CounterButton"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "CounterButton - Missing Title")
		Config.Default = Config.Default or 1
		Config.Min     = Config.Min     or 1
		Config.Max     = Config.Max     or 99
		Config.Step    = Config.Step    or 1

		local CB = {
			Value    = Config.Default,
			Type     = "CounterButton",
			Callback = Config.Callback or function() end,
		}

		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		CB.SetTitle = CBFrame.SetTitle
		CB.SetDesc  = CBFrame.SetDesc
		CB.Visible  = CBFrame.Visible
		CB.Elements = CBFrame

		local Holder = New("Frame", {
			Size               = UDim2.fromOffset(96, 30),
			Position           = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint        = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent             = CBFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection     = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder         = Enum.SortOrder.LayoutOrder,
			}),
		})

		local function makeBtn(txt, lo)
			return New("TextButton", {
				Text               = txt,
				FontFace           = GetStyleProperty("FontBold"),
				TextSize = GetStyleProperty("TextSizeIcon"),
				Size               = UDim2.fromOffset(30, 30),
				BackgroundTransparency = 0.85,
				LayoutOrder        = lo,
				Parent             = Holder,
				ThemeTag           = { BackgroundColor3 = "Element", TextColor3 = "Text" },
			}, {
				NewCorner("SmallCorner"),
				New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
			})
		end

		local MinusBtn = makeBtn("−", 1)
		local ValLabel = New("TextLabel", {
			Text               = tostring(Config.Default),
			FontFace           = GetStyleProperty("FontSemiBold"),
			TextSize = GetStyleProperty("TextSizeMd"),
			Size               = UDim2.fromOffset(36, 30),
			BackgroundTransparency = 1,
			TextXAlignment     = Enum.TextXAlignment.Center,
			LayoutOrder        = 2,
			Parent             = Holder,
			ThemeTag           = { TextColor3 = "Text" },
		})
		local PlusBtn = makeBtn("+", 3)

		local function set(v)
			v = math.clamp(math.floor(v / Config.Step + 0.5) * Config.Step, Config.Min, Config.Max)
			CB.Value = v
			ValLabel.Text = tostring(v)
			-- dim buttons at limit
			TweenService:Create(MinusBtn, TweenInfo.new(0.1), { BackgroundTransparency = v <= Config.Min and 0.95 or 0.85 }):Play()
			TweenService:Create(PlusBtn,  TweenInfo.new(0.1), { BackgroundTransparency = v >= Config.Max and 0.95 or 0.85 }):Play()
			Library:SafeCallback(CB.Callback, v)
			Library:SafeCallback(CB.Changed, v)
		end

		Creator.AddSignal(MinusBtn.MouseButton1Click, function() set(CB.Value - Config.Step) end)
		Creator.AddSignal(PlusBtn.MouseButton1Click,  function() set(CB.Value + Config.Step) end)

		-- hold to repeat
		for _, pair in ipairs({ {MinusBtn, -1}, {PlusBtn, 1} }) do
			local btn, dir = pair[1], pair[2]
			Creator.AddSignal(btn.MouseButton1Down, function()
				task.delay(0.4, function()
					while btn:IsDescendantOf(game) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						set(CB.Value + Config.Step * dir)
						task.wait(0.07)
					end
				end)
			end)
		end

		function CB:SetValue(v) set(v) end
		function CB:OnChanged(Func) CB.Changed = Func Func(CB.Value) end
		function CB:Destroy() CBFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		set(Config.Default)
		if Idx then Library.Options[Idx] = CB end
		return CB
	end
	return Element
end)()

ElementsTable.ToggleGroup = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "ToggleGroup"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title,   "ToggleGroup - Missing Title")
		assert(Config.Options, "ToggleGroup - Missing Options")

		local TG = {
			Value    = Config.Default or Config.Options[1],
			Type     = "ToggleGroup",
			Callback = Config.Callback or function() end,
		}

		local TGFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		TG.SetTitle = TGFrame.SetTitle
		TG.SetDesc  = TGFrame.SetDesc
		TG.Visible  = TGFrame.Visible
		TG.Elements = TGFrame

		local Row = New("Frame", {
			Size               = UDim2.fromOffset(0, 28),
			AutomaticSize      = Enum.AutomaticSize.X,
			Position           = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint        = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88,
			Parent             = TGFrame.Frame,
			ThemeTag           = { BackgroundColor3 = "Element" },
		}, {
			NewCorner("SmallCorner"),
			New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
			New("UIListLayout", {
				FillDirection     = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder         = Enum.SortOrder.LayoutOrder,
			}),
		})

		local Btns = {}

		local function updateBtns(selected)
			for _, b in ipairs(Btns) do
				local active = b.Value == selected
				TweenService:Create(b.Frame, TweenInfo.new(0.15), {
					BackgroundTransparency = active and 0.0 or 1,
				}):Play()
				TweenService:Create(b.Label, TweenInfo.new(0.15), {
					TextColor3 = active and Color3.fromRGB(255,255,255) or Creator.GetThemeProperty("SubText"),
				}):Play()
			end
		end

		for i, opt in ipairs(Config.Options) do
			local Btn = New("TextButton", {
				Text               = "",
				Size               = UDim2.fromOffset(0, 28),
				AutomaticSize      = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				LayoutOrder        = i,
				Parent             = Row,
				ThemeTag           = { BackgroundColor3 = "Accent" },
			}, {
				NewCorner("SmallCorner"),
				New("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
			})

			local Lbl = New("TextLabel", {
				Text               = tostring(opt),
				FontFace           = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeSm"),
				BackgroundTransparency = 1,
				Size               = UDim2.fromScale(1, 1),
				AutomaticSize      = Enum.AutomaticSize.X,
				TextColor3         = Creator.GetThemeProperty("SubText"),
				Parent             = Btn,
			})

			table.insert(Btns, { Frame = Btn, Label = Lbl, Value = opt })

			Creator.AddSignal(Btn.MouseButton1Click, function()
				TG.Value = opt
				updateBtns(opt)
				Library:SafeCallback(TG.Callback, opt)
				Library:SafeCallback(TG.Changed, opt)
			end)
		end

		function TG:SetValue(v)
			self.Value = v
			updateBtns(v)
			Library:SafeCallback(self.Callback, v)
			Library:SafeCallback(self.Changed, v)
		end
		function TG:OnChanged(Func) TG.Changed = Func Func(TG.Value) end
		function TG:Destroy() TGFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		updateBtns(TG.Value)
		if Idx then Library.Options[Idx] = TG end
		return TG
	end
	return Element
end)()

ElementsTable.Accordion = (function()
	local Element = {}
	Element.__index = Element
	Element.__type  = "Accordion"

	function Element:New(Idx, Config)
		Config       = Config or {}
		assert(Config.Title, "Accordion - Missing Title")
		Config.Open  = Config.Open  ~= nil and Config.Open  or false
		Config.Icon  = Config.Icon  -- optional Lucide icon name

		local CORNER      = 8
		local HEADER_H    = 40
		local ANIM_TIME   = 0.22
		local ANIM_STYLE  = Enum.EasingStyle.Quart
		local ANIM_DIR    = Enum.EasingDirection.Out

		local Acc = {
			Type    = "Accordion",
			Opened  = Config.Open,
			Elements = {},
		}

		local Root = New("Frame", {
			Size             = UDim2.new(1, 0, 0, HEADER_H),
			BackgroundTransparency = 0.88,
			ClipsDescendants = true,
			Parent           = self.Container,
			BorderSizePixel  = 0,
			ThemeTag         = { BackgroundColor3 = "Element" },
		}, {
			New("UICorner",  { CornerRadius = UDim.new(0, CORNER) }),
			New("UIStroke",  {
				Transparency    = 0.55,
				Thickness       = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag        = { Color = "InElementBorder" },
			}),
		})

		local AccentBar = New("Frame", {
			Size             = UDim2.new(0, 3, 1, -(CORNER * 2)),
			Position         = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundTransparency = Config.Open and 0 or 1,
			BorderSizePixel  = 0,
			Parent           = Root,
			ThemeTag         = { BackgroundColor3 = "Accent" },
		}, {
			NewCorner("PillCorner"),
		})

		local Header = New("TextButton", {
			Size             = UDim2.new(1, 0, 0, HEADER_H),
			BackgroundTransparency = 1,
			Text             = "",
			Parent           = Root,
		})

		-- Icon ซ้าย (optional)
		local IconImg
		if Config.Icon then
			local iconId = Library:GetIcon(Config.Icon)
			if iconId and iconId ~= "" then
				IconImg = New("ImageLabel", {
					Image            = iconId,
					Size             = UDim2.fromOffset(15, 15),
					Position         = UDim2.new(0, 12, 0.5, 0),
					AnchorPoint      = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					ThemeTag         = { ImageColor3 = Config.Open and "Accent" or "SubText" },
					Parent           = Header,
				})
			end
		end

		local titleX = Config.Icon and IconImg and 34 or 12

		-- Title
		local TitleLabel = New("TextLabel", {
			Text             = Config.Title,
			FontFace         = GetStyleProperty("FontSemiBold"),
			TextSize = GetStyleProperty("TextSizeMd"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			Position         = UDim2.new(0, titleX, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, -titleX - 36, 1, 0),
			Parent           = Header,
			ThemeTag         = { TextColor3 = Config.Open and "Accent" or "Text" },
		})

		-- Chevron (หมุนตาม state)
		local Chevron = New("ImageLabel", {
			Image            = "rbxassetid://10734886735",
			Size             = UDim2.fromOffset(14, 14),
			Position         = UDim2.new(1, -14, 0.5, 0),
			AnchorPoint      = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Rotation         = Config.Open and 180 or 0,
			Parent           = Header,
			ThemeTag         = { ImageColor3 = Config.Open and "Accent" or "SubText" },
		})

		local ContentFrame = New("Frame", {
			Size             = UDim2.new(1, -16, 0, 0),
			AutomaticSize    = Enum.AutomaticSize.Y,
			Position         = UDim2.new(0, 8, 0, HEADER_H + 4),
			BackgroundTransparency = 1,
			Parent           = Root,
		}, {
			New("UIListLayout", {
				Padding       = UDim.new(0, 6),
				SortOrder     = Enum.SortOrder.LayoutOrder,
			}),
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 10),
			}),
		})

		local contentLayout = ContentFrame:FindFirstChildOfClass("UIListLayout")

		local function getContentHeight()
			return contentLayout.AbsoluteContentSize.Y + 14
		end

		local function setOpen(open, instant)
			Acc.Opened = open
			local targetH = open and (HEADER_H + getContentHeight()) or HEADER_H
			local ti = TweenInfo.new(instant and 0 or ANIM_TIME, ANIM_STYLE, ANIM_DIR)

			TweenService:Create(Root,    ti, { Size = UDim2.new(1, 0, 0, targetH) }):Play()
			TweenService:Create(Chevron, ti, { Rotation = open and 180 or 0 }):Play()
			TweenService:Create(AccentBar, ti, { BackgroundTransparency = open and 0 or 1 }):Play()
			TweenService:Create(TitleLabel, ti, {
				TextColor3 = open
					and Creator.GetThemeProperty("Accent")
					or  Creator.GetThemeProperty("Text"),
			}):Play()
			TweenService:Create(Chevron, ti, {
				ImageColor3 = open
					and Creator.GetThemeProperty("Accent")
					or  Creator.GetThemeProperty("SubText"),
			}):Play()
			if IconImg then
				TweenService:Create(IconImg, ti, {
					ImageColor3 = open
						and Creator.GetThemeProperty("Accent")
						or  Creator.GetThemeProperty("SubText"),
				}):Play()
			end
		end

		-- อัปเดตขนาดอัตโนมัติเมื่อ content เปลี่ยน
		Creator.AddSignal(contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			if Acc.Opened then
				Root.Size = UDim2.new(1, 0, 0, HEADER_H + getContentHeight())
			end
		end)

		-- Hover effect บน Header
		Creator.AddSignal(Header.MouseEnter, function()
			if not Acc.Opened then
				TweenService:Create(Root, TweenInfo.new(0.15), {
					BackgroundTransparency = 0.82,
				}):Play()
			end
		end)
		Creator.AddSignal(Header.MouseLeave, function()
			TweenService:Create(Root, TweenInfo.new(0.15), {
				BackgroundTransparency = 0.88,
			}):Play()
		end)

		-- คลิก Header
		Creator.AddSignal(Header.MouseButton1Click, function()
			setOpen(not Acc.Opened)
		end)

		Acc.Container   = ContentFrame
		Acc.ScrollFrame = self.ScrollFrame or ContentFrame
		setmetatable(Acc, Library.Elements)

		function Acc:Open()    setOpen(true)  end
		function Acc:Close()   setOpen(false) end
		function Acc:Toggle()  setOpen(not self.Opened) end
		function Acc:Destroy()
			Root:Destroy()
			if Idx then Library.Options[Idx] = nil end
		end

		-- เปิดตอนเริ่มถ้า Config.Open = true
		if Config.Open then
			task.defer(function()
				setOpen(true, true) -- instant ไม่ animate ตอน init
			end)
		end

		if Idx then Library.Options[Idx] = Acc end
		return Acc
	end

	return Element
end)()

ElementsTable.LiveLabel = (function()
	local Element = {}
	Element.__index = Element
	Element.__type  = "LiveLabel"
	Element.NoIdx   = false

	local TypeColors = {
		default = Color3.fromRGB(165, 168, 185),
		info    = Color3.fromRGB(96,  200, 255),
		success = Color3.fromRGB(80,  215, 130),
		warning = Color3.fromRGB(255, 195,  60),
		error   = Color3.fromRGB(255,  80,  80),
	}

	local TypeBg = {
		default = Color3.fromRGB(80,  82,  95),
		info    = Color3.fromRGB(20,  70,  110),
		success = Color3.fromRGB(15,  75,  45),
		warning = Color3.fromRGB(90,  65,  10),
		error   = Color3.fromRGB(90,  20,  20),
	}

	function Element:New(Idx, Config)
		Config      = Config or {}
		Config.Text = Config.Text or ""
		Config.Type = Config.Type or "default"

		local New = Creator.New

		local LL = {
			Value = Config.Text,
			Type  = "LiveLabel",
			_type = Config.Type,
		}

		local LLFrame = Components.Element(Config.Title or "", Config.Description, self.Container, false, Config)
		LL.SetTitle = LLFrame.SetTitle
		LL.SetDesc  = LLFrame.SetDesc
		LL.Visible  = LLFrame.Visible
		LL.Elements = LLFrame

		-- ── Pill วางชิดขวา AutomaticSize X ──────────────────────
		-- ความกว้าง max ครึ่งหนึ่งของ frame เพื่อไม่ทับ title
		local Pill = New("Frame", {
			AutomaticSize          = Enum.AutomaticSize.XY,
			AnchorPoint            = Vector2.new(1, 0.5),
			Position               = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 0.72,
			BackgroundColor3       = TypeBg[Config.Type] or TypeBg.default,
			Parent                 = LLFrame.Frame,
		}, {
			NewCorner("SmallCorner"),
			New("UIStroke", { Transparency = 0.55, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = TypeColors[Config.Type] or TypeColors.default, Thickness = GetStyleProperty("BorderThickness") }),
			New("UIPadding", {
				PaddingLeft   = UDim.new(0, 7),
				PaddingRight  = UDim.new(0, 7),
				PaddingTop    = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
			}),
			-- จำกัดความกว้างสูงสุดไม่ให้ทับ title
			New("UISizeConstraint", {
				MaxSize = Vector2.new(200, math.huge),
			}),
		})

		-- ── Text ข้างใน Pill ─────────────────────────────────────
		local ValueLabel = New("TextLabel", {
			FontFace               = GetStyleProperty("FontMedium"),
			Text                   = Config.Text,
			TextColor3             = TypeColors[Config.Type] or TypeColors.default,
			TextSize = GetStyleProperty("TextSizeSm"),
			TextXAlignment         = Enum.TextXAlignment.Right,
			TextYAlignment         = Enum.TextYAlignment.Center,
			TextWrapped            = true,
			RichText               = true,
			AutomaticSize          = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			-- กว้างเต็ม Pill (padding จัดการระยะห่างแล้ว)
			Size                   = UDim2.new(1, 0, 0, 0),
			Parent                 = Pill,
		})

		-- ซ่อน Pill ตอนที่ text ว่าง
		Pill.Visible = Config.Text ~= ""

		-- ── ให้ frame หลักขยายตาม Pill เมื่อ text หลายบรรทัด ───
		-- ใช้ AbsoluteSize ของ Pill drive ความสูง frame
		local BASE_H = 44  -- ความสูงปกติของ element row (px)
		local MIN_H  = BASE_H

		local function syncFrameHeight()
			local pillH  = Pill.AbsoluteSize.Y
			local target = math.max(MIN_H, pillH + 16)
			if math.abs(LLFrame.Frame.Size.Y.Offset - target) > 1 then
				TweenService:Create(
					LLFrame.Frame,
					TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Size = UDim2.new(1, 0, 0, target) }
				):Play()
				-- จัด Pill ให้อยู่กึ่งกลาง Y ตามความสูงใหม่
				Pill.Position = UDim2.new(1, -10, 0.5, 0)
			end
		end

		Creator.AddSignal(Pill:GetPropertyChangedSignal("AbsoluteSize"), syncFrameHeight)

		-- ── API ──────────────────────────────────────────────────
		local PillStroke = Pill:FindFirstChildOfClass("UIStroke")

		function LL:SetText(text)
			self.Value      = text or ""
			ValueLabel.Text = self.Value
			Pill.Visible    = self.Value ~= ""
			Library:SafeCallback(LL.Changed, self.Value)
		end

		function LL:SetType(t)
			self._type = t or "default"
			local col  = TypeColors[self._type] or TypeColors.default
			local bg   = TypeBg[self._type]     or TypeBg.default
			local ti   = TweenInfo.new(0.15)
			TweenService:Create(ValueLabel, ti, { TextColor3 = col }):Play()
			TweenService:Create(Pill,       ti, { BackgroundColor3 = bg }):Play()
			if PillStroke then
				TweenService:Create(PillStroke, ti, { Color = col }):Play()
			end
		end

		function LL:SetColor(color)
			ValueLabel.TextColor3 = color
			if PillStroke then PillStroke.Color = color end
		end

		function LL:OnChanged(Func) LL.Changed = Func Func(LL.Value) end

		function LL:Destroy()
			LLFrame.Frame:Destroy()
			if Idx then Library.Options[Idx] = nil end
		end

		LL:SetType(Config.Type)
		if Idx then Library.Options[Idx] = LL end
		return LL
	end

	return Element
end)()

Components.Notification:Init(Creator.GUI)

local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...)
	return Elements[Key](...)
end

for _, ElementComponent in pairs(ElementsTable) do
	Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.ScrollFrame = self.ScrollFrame
		ElementComponent.Library = Library

		-- Button และ Paragraph ใช้ New(Config) ไม่มี Idx
		-- ตรวจ: ถ้า ElementComponent.NoIdx = true ให้ส่ง Idx เป็น Config แทน
		if ElementComponent.NoIdx then
			return ElementComponent:New(Idx)
		end
		return ElementComponent:New(Idx, Config)
	end
end

Library.Elements = Elements

return Elements, ElementsTable
