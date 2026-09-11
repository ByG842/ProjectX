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

		local DropdownInnerStroke = New("UIStroke", {
			Transparency = 0.45,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "InElementBorder",
			},
		})

		local baseStrokeThickness = GetStyleProperty("BorderThickness")
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
			DropdownInnerStroke,
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
		local DropdownGlow = New("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=5554236805",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(23, 23, 277, 277),
			Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
			Position = UDim2.fromOffset(-15, -15),
			ImageTransparency = 1,
			ThemeTag = {
				ImageColor3 = "Accent",
			},
		})

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
				Thickness = baseStrokeThickness + 0.5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "Accent",
				},
			}),
			DropdownGlow,
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

			-- ขอบเรืองสี Accent ตอนเปิด (ทั้งกล่องปิดและ panel)
			Creator.OverrideTag(DropdownInnerStroke, { Color = "Accent" })
			TweenService:Create(
				DropdownInnerStroke,
				TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Transparency = 0, Thickness = baseStrokeThickness + 0.5 }
			):Play()
			TweenService:Create(
				DropdownGlow,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ ImageTransparency = 0.55 }
			):Play()

			-- อนิเมชันรายการเด้งเข้ามาทีละอัน
			local openToken = (Dropdown.OpenToken or 0) + 1
			Dropdown.OpenToken = openToken
			local visibleIndex = 0
			for _, element in ipairs(DropdownScrollFrame:GetChildren()) do
				if not element:IsA("UIListLayout") and element.Visible then
					visibleIndex = visibleIndex + 1
					local delayIdx = visibleIndex
					local scaleObj = element:FindFirstChild("PopScale")
					local label = element:FindFirstChild("ButtonLabel")
					if scaleObj then scaleObj.Scale = 0.8 end
					if label then label.TextTransparency = 1 end
					task.delay((delayIdx - 1) * 0.035, function()
						if Dropdown.OpenToken ~= openToken then return end
						if not (element and element.Parent) then return end
						if scaleObj then
							TweenService:Create(
								scaleObj,
								TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
								{ Scale = 1 }
							):Play()
						end
						if label then
							TweenService:Create(
								label,
								TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
								{ TextTransparency = 0 }
							):Play()
						end
					end)
				end
			end
		end
		function Dropdown:Close()
			Dropdown.Opened = false
			Dropdown.OpenToken = (Dropdown.OpenToken or 0) + 1
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
			Creator.OverrideTag(DropdownInnerStroke, { Color = "InElementBorder" })
			TweenService:Create(
				DropdownInnerStroke,
				TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Transparency = 0.45, Thickness = baseStrokeThickness }
			):Play()
			DropdownGlow.ImageTransparency = 1
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
					New("UIScale", { Scale = 1, Name = "PopScale" }),
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
