Components.Window = (function()
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New = Creator.New
	return function(Config)
		local Window = {
			Minimized = false,
			Maximized = false,
			Size = Config.Size,
			CurrentPos = 0,
			TabWidth = 0,
			Position = UDim2.fromOffset(0, 0),
			DropdownsOutsideWindow = Config.DropdownsOutsideWindow == true,
			ManagedBackgroundImage = Config.ManagedBackgroundImage == true,
		}

		Library.Window = Window
		local Dragging, DragInput, MousePos, StartPos = false
		local Resizing, ResizePos = false
		local MinimizeNotif = false
		Window.AcrylicPaint = Acrylic.AcrylicPaint()
		local function CenterWindow()
			local vp = Camera.ViewportSize
			local x = math.max(0, (vp.X - Window.Size.X.Offset) / 2)
			local y = math.max(0, (vp.Y - Window.Size.Y.Offset) / 2)
			Window.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
			if Window.Root then
				Window.Root.Position = Window.Position
			end
		end
		Window.TabWidth = Config.TabWidth or 170
		local Selector = New("Frame", {
			Size = UDim2.fromOffset(3, 0),
			BackgroundColor3 = Color3.fromRGB(76, 194, 255),
			Position = UDim2.fromOffset(0, (Window.TabHolderTop or 45) + 0),
			AnchorPoint = Vector2.new(0, 0.5),
			ZIndex = 1,
			ThemeTag = {
				BackgroundColor3 = "Accent",
			},
		}, {
			NewCorner("ElementCorner"),
		})

		local ResizeGripIcon = New("ImageLabel", {
			Name = "ResizeGrip",
			Image = "rbxassetid://10734898934", -- lucide-move-diagonal-2 (ลูกศรเฉียง บอกว่าลากปรับขนาดได้)
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.new(1, -6, 1, -6), -- ตรงมุมพอดี (เผื่อ 6px กันโดนโค้งขอบหน้าต่างบัง)
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			ImageColor3 = Color3.fromRGB(255, 255, 255), -- สีขาวคงที่ ไม่ตามธีม
			ImageTransparency = Mobile and 0.35 or 1, -- มือถือ: โชว์ค้างไว้เสมอ (ไม่มี hover) | เดสก์ท็อป: ซ่อนไว้ก่อน โผล่ตอนชี้
			ZIndex = 21,
		})

		local ResizeStartFrame = New("Frame", {
			Size = UDim2.fromOffset(24, 24),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -24, 1, -24), -- ✅ FIX: เมื่อก่อนใช้ 1,-2 ทำให้กล่องยื่นล้นออกนอกขอบหน้าต่างด้านล่าง ไอคอนเลยลอยไปอยู่นอกหน้าต่าง
			ZIndex = 20,
			Active = true, -- ✅ FIX: Frame ธรรมดาไม่รับ InputBegan ถ้าไม่เปิด Active (ต่างจาก TextButton/ImageButton ที่ active อยู่แล้ว) — นี่คือสาเหตุที่ลากมุมแล้วไม่ resize
		}, {
			ResizeGripIcon,
		})

		if not Mobile then
			local function OnResizeHoverEnter()
				ResizeGripIcon.ImageTransparency = 0
			end
			local function OnResizeHoverLeave()
				ResizeGripIcon.ImageTransparency = 1
			end
			Creator.AddSignal(ResizeStartFrame.MouseEnter, OnResizeHoverEnter)
			Creator.AddSignal(ResizeStartFrame.MouseLeave, OnResizeHoverLeave)
			Creator.AddSignal(ResizeGripIcon.MouseEnter, OnResizeHoverEnter)
			Creator.AddSignal(ResizeGripIcon.MouseLeave, OnResizeHoverLeave)
		end
		local SearchElements = {}
		local AllElements = {}

		local function UpdateElementVisibility(searchTerm)
			if not searchTerm then searchTerm = "" end
			local function normalizeText(text)
				if not text then return "" end
				text = tostring(text)
				text = string.gsub(text, "^%s+", "")
				text = string.gsub(text, "%s+$", "")
				text = string.gsub(text, "%s+", " ")
				return string.lower(text)
			end

			-- 🔍 Search highlight: ห่อคำที่ match ด้วย <font>/<b> (escape ตัวอักษรพิเศษกันโค้ด rich text พัง)
			local function escapeRichText(s)
				s = string.gsub(s, "&", "&amp;")
				s = string.gsub(s, "<", "&lt;")
				s = string.gsub(s, ">", "&gt;")
				s = string.gsub(s, "\"", "&quot;")
				return s
			end
			local function highlightMatch(original, query)
				if query == "" or original == "" then
					return nil -- ไม่ต้อง highlight, ให้ผู้เรียกใช้ plain text แทน
				end
				local lowerOriginal = string.lower(original)
				local lowerQuery = string.lower(query)
				local startIdx = string.find(lowerOriginal, lowerQuery, 1, true)
				if not startIdx then
					return nil
				end
				local endIdx = startIdx + #query - 1
				local before = escapeRichText(string.sub(original, 1, startIdx - 1))
				local matchText = escapeRichText(string.sub(original, startIdx, endIdx))
				local after = escapeRichText(string.sub(original, endIdx + 1))
				return before .. '<font color="#FFD866"><b>' .. matchText .. '</b></font>' .. after
			end
			local function applyHighlight(label, plainText, query)
				if not label then return end
				if query ~= "" then
					-- ใช้แค่คำแรกของ query สำหรับ highlight (คำค้นหาแบบหลายคำจะ highlight คำแรกที่เจอ)
					local firstWord = string.match(query, "%S+") or query
					local highlighted = highlightMatch(plainText, firstWord)
					if highlighted then
						label.RichText = true
						label.Text = highlighted
						return
					end
				end
				label.RichText = false
				label.Text = plainText
			end
			local function getElementValues(elementFrame)
				local values = {}

				local function addText(text)
					if text and text ~= "" then
						table.insert(values, tostring(text))
					end
				end
				local function findTextInDescendants(obj)
					if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
						addText(obj.Text)
					end
					for _, child in pairs(obj:GetChildren()) do
						findTextInDescendants(child)
					end
				end
				findTextInDescendants(elementFrame)
				return values
			end
			local function checkMatch(text, query)
				if query == "" then
					return true
				end
				local normalizedText = normalizeText(text)
				if normalizedText == "" then
					return false
				end
				local queryLower = normalizeText(query)
				if queryLower == "" then
					return true
				end
				if string.find(queryLower, "%s", 1) then
					local words = {}
					for word in string.gmatch(queryLower, "%S+") do
						if #word > 0 then
							table.insert(words, word)
						end
					end
					if #words == 0 then
						return true
					end
					for _, word in ipairs(words) do
						if not string.find(normalizedText, word, 1, true) then
							return false
						end
					end
					return true
				else
					return string.find(normalizedText, queryLower, 1, true) ~= nil
				end
			end
			local normalizedQuery = normalizeText(searchTerm)
			local matchedSectionFrames = {}
			local elementsInMatchedSections = {}

			for element, data in pairs(AllElements) do
				if element and element.Parent then
					if data.type == "Section" then
						local title = tostring(data.title or "")
						if normalizedQuery ~= "" and checkMatch(title, normalizedQuery) then
							matchedSectionFrames[element] = true
							if element:FindFirstChild("Container") then
								local container = element:FindFirstChild("Container")
								for _, child in pairs(container:GetChildren()) do
									if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
										elementsInMatchedSections[child] = true
									end
								end
							end
						end
					end
				end
			end
			for element, data in pairs(AllElements) do
				if element and element.Parent then
					if normalizedQuery == "" then
						element.Visible = true
						applyHighlight(data.titleLabel, data.title, "")
						applyHighlight(data.descLabel, data.description, "")
					else
						local title = tostring(data.title or "")
						local desc = tostring(data.description or "")
						local matchesTitle = checkMatch(title, normalizedQuery)
						local matchesDesc = checkMatch(desc, normalizedQuery)
						local matchesValues = false
						local elementValues = getElementValues(element)
						for _, value in ipairs(elementValues) do
							if checkMatch(value, normalizedQuery) then
								matchesValues = true
								break
							end
						end
						local matchesSection = elementsInMatchedSections[element] == true
						if not matchesSection and data.section then
							for sectionFrame, _ in pairs(matchedSectionFrames) do
								if data.section == sectionFrame then
									matchesSection = true
									break
								end
							end
						end
						element.Visible = matchesTitle or matchesDesc or matchesValues or matchesSection
						applyHighlight(data.titleLabel, data.title, matchesTitle and normalizedQuery or "")
						applyHighlight(data.descLabel, data.description, matchesDesc and normalizedQuery or "")
					end
				end
			end
			local searchTermForClosure = searchTerm
			task.spawn(function()
				task.wait(0.05)
				if not Window or not Window.ContainerHolder then return end
				for _, tabContainer in pairs(Window.ContainerHolder:GetChildren()) do
					if tabContainer:IsA("ScrollingFrame") then
						local containerLayout = tabContainer:FindFirstChild("UIListLayout")
						if containerLayout then
							local containerPadding = tabContainer:FindFirstChild("UIPadding")
							local paddingTop = containerPadding and containerPadding.PaddingTop.Offset or 1
							local paddingBottom = containerPadding and containerPadding.PaddingBottom.Offset or 1
							local contentSize = containerLayout.AbsoluteContentSize.Y + paddingTop + paddingBottom
							tabContainer.CanvasSize = UDim2.new(0, 0, 0, math.max(0, contentSize))
						end
						for _, section in pairs(tabContainer:GetChildren()) do
							if section:IsA("Frame") and section.Name ~= "UIPadding" then
								local sectionContainer = section:FindFirstChild("Container")
								if sectionContainer and sectionContainer:IsA("Frame") then
									local containerLayout = sectionContainer:FindFirstChild("UIListLayout")
									if containerLayout then
										local hasVisibleChild = false
										for _, element in pairs(sectionContainer:GetChildren()) do
											if not element:IsA("UIListLayout") and element.Visible then
												hasVisibleChild = true
												break
											end
										end
										if searchTermForClosure == "" or hasVisibleChild then
											section.Visible = true
											local containerPadding = sectionContainer:FindFirstChild("UIPadding")
											local containerPaddingTop = containerPadding and containerPadding.PaddingTop.Offset or 0
											local containerPaddingBottom = containerPadding and containerPadding.PaddingBottom.Offset or 0
											local containerContentSize = containerLayout.AbsoluteContentSize.Y + containerPaddingTop + containerPaddingBottom
											sectionContainer.Size = UDim2.new(1, 0, 0, math.max(0, containerContentSize))
										else
											section.Visible = false
											sectionContainer.Size = UDim2.new(1, 0, 0, 0)
										end
									end
								end
								local sectionLayout = section:FindFirstChild("UIListLayout")
								if sectionLayout then
									local sectionPadding = section:FindFirstChild("UIPadding")
									local sectionPaddingTop = sectionPadding and sectionPadding.PaddingTop.Offset or 0
									local sectionPaddingBottom = sectionPadding and sectionPadding.PaddingBottom.Offset or 0
									local sectionContentSize = sectionLayout.AbsoluteContentSize.Y + sectionPaddingTop + sectionPaddingBottom
									section.Size = UDim2.new(1, 0, 0, math.max(0, sectionContentSize + 25))
								end
							end
						end
					end
				end
			end)
		end
		local function RegisterElement(elementFrame, title, elementType, description)
			if elementFrame then
				local sectionFrame = nil
				local parent = elementFrame.Parent
				while parent do
					if parent:FindFirstChild("Container") then
						local sectionRoot = parent
						local sectionContainer = parent:FindFirstChild("Container")
						if sectionContainer and elementFrame.Parent == sectionContainer then
							sectionFrame = sectionRoot
							break
						end
					end
					parent = parent.Parent
				end

				-- 🔍 หา TitleLabel/DescLabel จริง (2 ตัวแรกตามโครงสร้าง Components.Element) ไว้ใช้ไฮไลต์คำค้นหา
				local titleLabelRef, descLabelRef = nil, nil
				local function scanForLabels(obj)
					for _, child in ipairs(obj:GetChildren()) do
						if titleLabelRef and descLabelRef then return end
						if child:IsA("TextLabel") then
							if not titleLabelRef then
								titleLabelRef = child
							elseif not descLabelRef then
								descLabelRef = child
							end
						end
						scanForLabels(child)
						if titleLabelRef and descLabelRef then return end
					end
				end
				pcall(scanForLabels, elementFrame)
				AllElements[elementFrame] = {
					title = tostring(title or ""),
					type = elementType or "Element",
					description = tostring(description or ""),
					section = sectionFrame,
					titleLabel = titleLabelRef,
					descLabel = descLabelRef,
				}
			end
		end
		Window.ShowSearch = (Config.Search == nil) and true or (Config.Search and true or false)
		local ImageAsset = Config.Image
		local hasImage = ImageAsset and type(ImageAsset) == "string" and ImageAsset ~= ""
		local imageSize = Window.TabWidth - 24
		local topOffset = 0
		local ImageFrame = hasImage and New("ImageLabel", {
			Size = UDim2.new(0, imageSize, 0, imageSize),
			Position = UDim2.new(0.5, 0, 0, topOffset),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Image = ImageAsset,
			ZIndex = 5,
			Visible = true,
		}, {
			NewCorner("SmallCorner"),
		}) or nil
		Window.HasImage = hasImage
		Window.ImageFrame = ImageFrame
		Window.ImageSize = imageSize
		Window.TopOffset = topOffset
		local searchOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
		local searchHeight = 28
		local tabHolderTop
		if hasImage then
			if Window.ShowSearch then
				tabHolderTop = imageSize + 10 + topOffset + searchHeight + 6
			else
				tabHolderTop = imageSize + 10 + topOffset
			end
		else
			if Window.ShowSearch then
				tabHolderTop = topOffset + searchHeight + 6
			else
				tabHolderTop = 45
			end
		end
		Window.TabHolderTop = tabHolderTop
		Window.TabHolder = New("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -(tabHolderTop + 6)),
			Position = UDim2.new(0, 0, 0, tabHolderTop),
			BackgroundTransparency = 1,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = 0,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 4),
			}),
		})

		-- 🔧 recompute + re-apply TabHolder's top offset/size from the window's current
		-- live state (image, search bar, user-info). Pass an explicit top to force a value,
		-- or call with no args to have it recompute from Window.ShowSearch/HasImage/UserInfo*.
		function Window:UpdateTabHolderLayout(explicitTop)
			local topOffset = Window.TopOffset or 0
			local hasImage = Window.HasImage
			local imageSize = Window.ImageSize or 0
			local searchHeight = 28
			local imageOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
			local userInfoHeight = Window.UserInfoHeight
			local newTop = explicitTop
			if not newTop then
				if userInfoHeight and Window.UserInfoTop then
					newTop = userInfoHeight + 6 + imageOffset + (Window.ShowSearch and (searchHeight + 6) or 0)
				elseif hasImage then
					newTop = Window.ShowSearch and (imageSize + 10 + topOffset + searchHeight + 6) or (imageSize + 10 + topOffset)
				else
					newTop = Window.ShowSearch and (topOffset + searchHeight + 6) or 45
				end
			end
			Window.TabHolderTop = newTop
			Window.TabHolder.Position = UDim2.new(0, 0, 0, newTop)
			if userInfoHeight and Window.UserInfoTop then
				Window.TabHolder.Size = UDim2.new(1, 0, 1, -(newTop + 6 + userInfoHeight))
			else
				Window.TabHolder.Size = UDim2.new(1, 0, 1, -(newTop + 6))
			end
		end
		local SearchFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.new(0, 0, 0, searchOffset),
			BackgroundTransparency = 0.7,
			ZIndex = 10,
			Visible = Window.ShowSearch,
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			ThemeTag = {
				BackgroundColor3 = "Element",
			},
		}, {
			NewCorner("TinyCorner"),
		})

		local SearchInput = New("TextBox", {
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
			Parent = SearchFrame,
			ThemeTag = {
				TextColor3 = "Text",
				PlaceholderColor3 = "SubText",
			},
		})

		local SearchIcon = New("ImageLabel", {
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.new(1, -13, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "rbxassetid://10734943674",
			Parent = SearchFrame,
			ImageTransparency = 0.3,
			ThemeTag = {
				ImageColor3 = "SubText",
			},
		})

		local SearchTextbox = {
			Input = SearchInput,
			Frame = SearchFrame,
		}

		Creator.AddSignal(SearchTextbox.Input:GetPropertyChangedSignal("Text"), function()
			local searchText = SearchTextbox.Input.Text or ""
			UpdateElementVisibility(searchText)
		end)
		Creator.AddSignal(SearchTextbox.Input.FocusLost, function(enterPressed)
		end)
		Creator.AddSignal(UserInputService.InputBegan, function(input, gameProcessed)
			if gameProcessed then return end
			if input.KeyCode == Enum.KeyCode.Escape and SearchTextbox.Input:IsFocused() then
				SearchTextbox.Input.Text = ""
				SearchTextbox.Input:ReleaseFocus()
			end
		end)
		Window.SearchElements = SearchElements
		Window.AllElements = AllElements
		Window.RegisterElement = RegisterElement
		Window.UpdateElementVisibility = UpdateElementVisibility
		local imageSize = Window.TabWidth - 24
		local topOffset = Window.TopOffset or 25
		local imageOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
		local searchHeight = 28
		local totalOffset = (Window.ShowSearch and searchHeight or 0) + imageOffset
		local SidebarCollapseButton = New("TextButton", {
			Name = "SidebarCollapseToggle",
			Text = "«",
			FontFace = GetStyleProperty("FontBold"),
			TextSize = 14,
			Size = UDim2.fromOffset(22, 22),
			Position = UDim2.new(0, 12, 1, -30),
			BackgroundTransparency = 0.85,
			AutoButtonColor = false,
			ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "SubText" },
		}, {
			NewCorner("TinyCorner"),
		})

		local TabFrame = New("Frame", {
			Size = UDim2.new(0, Window.TabWidth, 1, Window.ShowSearch and -63 or -31),
			Position = UDim2.new(0, 12, 0, Window.ShowSearch and 54 or 19),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, {
			ImageFrame,
			SearchFrame,
			Window.TabHolder,
			Selector,
			SidebarCollapseButton,
		})

		Window.TabFrame = TabFrame
		Window.TabDisplay = New("TextLabel", {
			RichText = true,
			Text = "Tab",
			TextTransparency = 0,
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextSize = GetStyleProperty("TextSizeTitle"),
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 28),
			Position = UDim2.fromOffset(Window.TabWidth + 26, 56),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Window.ContainerHolder = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		})

		Window.ContainerAnim = New("CanvasGroup", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		})

		Window.ContainerCanvas = New("Frame", {
			Size = UDim2.new(1, -Window.TabWidth - 32, 1, -102),
			Position = UDim2.fromOffset(Window.TabWidth + 26, 90),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, {
			Window.ContainerAnim,
			Window.ContainerHolder
		})

		-- 📐 Sidebar collapse to icons — ย่อแถบแท็บเหลือแค่ไอคอน (แบบ VS Code) กดปุ่ม « / » toggle
		Window.TabWidthExpanded = Window.TabWidth
		Window.SidebarCollapsed = false
		local function ApplySidebarWidth(width)
			TabFrame.Size = UDim2.new(0, width, TabFrame.Size.Y.Scale, TabFrame.Size.Y.Offset)
			Window.TabDisplay.Position = UDim2.fromOffset(width + 26, Window.TabDisplay.Position.Y.Offset)
			Window.ContainerCanvas.Size = UDim2.new(1, -width - 32, Window.ContainerCanvas.Size.Y.Scale, Window.ContainerCanvas.Size.Y.Offset)
			Window.ContainerCanvas.Position = UDim2.fromOffset(width + 26, Window.ContainerCanvas.Position.Y.Offset)
		end
		function Window:SetSidebarCollapsed(Collapsed, Animate)
			Window.SidebarCollapsed = Collapsed
			local targetWidth = Collapsed and 54 or Window.TabWidthExpanded
			if Animate == false then
				Window.TabWidth = targetWidth
				ApplySidebarWidth(targetWidth)
			else
				local proxy = Instance.new("NumberValue")
				proxy.Value = Window.TabWidth
				local tw = TweenService:Create(proxy, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Value = targetWidth })
				local conn
				conn = proxy:GetPropertyChangedSignal("Value"):Connect(function()
					Window.TabWidth = proxy.Value
					ApplySidebarWidth(proxy.Value)
				end)
				tw.Completed:Connect(function()
					if conn then conn:Disconnect() end
					proxy:Destroy()
					Window.TabWidth = targetWidth
					ApplySidebarWidth(targetWidth)
				end)
				tw:Play()
			end

			-- ซ่อน/โชว์ label ข้อความของปุ่มแท็บแต่ละอัน + จัดไอคอนให้อยู่กึ่งกลางตอนย่อ
			if Window.TabHolder then
				for _, tabBtn in ipairs(Window.TabHolder:GetChildren()) do
					if tabBtn:IsA("GuiObject") then
						local label = tabBtn:FindFirstChildWhichIsA("TextLabel", true)
						local icon = tabBtn:FindFirstChildWhichIsA("ImageLabel", true)
						if label then
							label.Visible = not Collapsed -- ✅ ซ่อนจริง (ไม่ใช่แค่โปร่งใส) กัน layout เพี้ยน
						end
						if icon then
							local ti = TweenInfo.new(0.15)
							if Collapsed then
								TweenService:Create(icon, ti, {
									Position = UDim2.new(0.5, 0, 0.5, 0),
								}):Play()
								icon.AnchorPoint = Vector2.new(0.5, 0.5)
							else
								icon.AnchorPoint = Vector2.new(0, 0.5)
								TweenService:Create(icon, ti, {
									Position = UDim2.new(0, 9, 0.5, 0),
								}):Play()
							end
						end
					end
				end
			end

			-- ✅ ซ่อนช่องค้นหาตอนย่อ (54px แคบเกินจะพิมพ์ได้จริง เดิมทับกับไอคอนค้นหา)
			if SearchFrame then
				if Collapsed then
					SearchFrame.Visible = false
				else
					SearchFrame.Visible = Window.ShowSearch
				end
			end
			SidebarCollapseButton.Text = Collapsed and "»" or "«"
		end
		Creator.AddSignal(SidebarCollapseButton.MouseButton1Click, function()
			Window:SetSidebarCollapsed(not Window.SidebarCollapsed)
		end)
		local backgroundTransparency = Config.BackgroundTransparency
		if backgroundTransparency == nil then
			backgroundTransparency = 0.5
		end
		Window.BackgroundTransparency = backgroundTransparency
		local backgroundImageTransparency = Config.BackgroundImageTransparency
		if backgroundImageTransparency == nil then
			backgroundImageTransparency = backgroundTransparency
		end
		Window.BackgroundImageTransparency = backgroundImageTransparency
		local rootChildren = {}

		if Config.BackgroundImage then
			local isTiledBG = Config.BackgroundImageTile == true
			local BackgroundImageFrame = New("ImageLabel", {
				Name = "BackgroundImage",
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 1,
				Image = Config.BackgroundImage,
				ImageTransparency = math.max(0, math.min(1, backgroundImageTransparency)),
				ZIndex = 0,
				ScaleType = isTiledBG and Enum.ScaleType.Tile or Enum.ScaleType.Stretch,
				TileSize = isTiledBG and (Config.BackgroundImageTileSize or UDim2.fromOffset(64, 64)) or nil,
			}, {
				NewCorner("ElementCorner"),
			})
			Window.BackgroundImage = BackgroundImageFrame
			table.insert(rootChildren, BackgroundImageFrame)
			if Window.AcrylicPaint and Window.AcrylicPaint.Frame then
				if backgroundImageTransparency <= 0.1 then
					Window.AcrylicPaint.Frame.BackgroundTransparency = 1
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 1
					end
					local function makeTransparent(obj)
						if obj:IsA("Frame") then
							obj.BackgroundTransparency = 1
						elseif obj:IsA("ImageLabel") then
							obj.ImageTransparency = 1
						end
						for _, child in ipairs(obj:GetChildren()) do
							if not child:IsA("UICorner") and not child:IsA("UIGradient") and not child:IsA("UIStroke") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
								makeTransparent(child)
							end
						end
					end
					makeTransparent(Window.AcrylicPaint.Frame)
				elseif backgroundImageTransparency < 0.3 then
					Window.AcrylicPaint.Frame.BackgroundTransparency = 0.99
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 0.99
					end
				else
					Window.AcrylicPaint.Frame.BackgroundTransparency = 0.98
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 0.98
					end
				end
			end
		end
		table.insert(rootChildren, Window.AcrylicPaint.Frame)
		table.insert(rootChildren, Window.TabDisplay)
		table.insert(rootChildren, Window.ContainerCanvas)
		table.insert(rootChildren, TabFrame)
		table.insert(rootChildren, ResizeStartFrame)

		-- 🎬 ห่อ Window.Root ด้วย CanvasGroup โปร่งใสเต็มจอ เพื่อทำ fade ทั้งก้อนตอนพับ/คลี่หน้าต่าง
		-- (Window.Root เดิมเป็น Frame ธรรมดา ไม่มี GroupTransparency ให้ fade ได้ตรงๆ)
		Window.RootWrapper = New("CanvasGroup", {
			Name = "RootAnimWrapper",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Parent = Config.Parent,
		})

		Window.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size = Window.Size,
			Position = Window.Position,
			Parent = Window.RootWrapper,
		}, rootChildren)

		-- 🎬 UIScale สำหรับอนิเมชันย่อ/ขยายตอนกดพับหน้าต่าง (genie-style shrink)
		Window.RootScale = New("UIScale", { Scale = 1 })
		Window.RootScale.Parent = Window.Root
		local RootScaleMotor, SetRootScale = Creator.SpringMotor(1, Window.RootScale, "Scale")
		Window.RootScaleMotor = RootScaleMotor
		Window.SetRootScale = SetRootScale
		local RootFadeMotor, SetRootFade = Creator.SpringMotor(0, Window.RootWrapper, "GroupTransparency")
		Window.RootFadeMotor = RootFadeMotor
		Window.SetRootFade = SetRootFade
		CenterWindow()
		Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), function()
			CenterWindow()
		end)
		Window.TitleBar = Components.TitleBar({
			Title = Config.Title,
			SubTitle = Config.SubTitle,
			Icon = Config.Icon,
			Discord = Config.Discord,
			Parent = Window.Root,
			Window = Window,
			UserInfoTitle = Config.UserInfoTitle,
			UserInfo = Config.UserInfo,
			UserInfoSubtitle = Config.UserInfoSubtitle,
			UserInfoSubtitleColor = Config.UserInfoSubtitleColor,
		})

		if Config.UserInfo then
			local function parseColor(value)
				if typeof(value) == "Color3" then return value end
				return Themes[Library.Theme].SubText or Color3.fromRGB(170,170,170)
			end
			local userInfoHeight = 56
			Window.UserInfoHeight = userInfoHeight
			Window.UserInfoTop = Config.UserInfoTop
			local UserInfoSection = New("Frame", {
				Name = "UserInfoSection",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, userInfoHeight),
				Position = Config.UserInfoTop and UDim2.fromOffset(0, 0) or UDim2.new(0, 0, 1, -(userInfoHeight + 2)),
				ZIndex = 15,
				Parent = TabFrame,
			})

			New("Frame", {
				Name = "UserInfoSeparator",
				BackgroundTransparency = 0.5,
				Size = UDim2.new(1, 0, 0, 1),
				Position = Config.UserInfoTop and UDim2.fromOffset(0, userInfoHeight + 4) or UDim2.new(0, 0, 1, -(userInfoHeight + 4)),
				ZIndex = 15,
				Parent = TabFrame,
				ThemeTag = {
					BackgroundColor3 = "TitleBarLine",
				},
			})

			local avatarSize = 28
			local Avatar = New("ImageLabel", {
				Name = "Avatar",
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(avatarSize, avatarSize),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Image = "rbxassetid://0",
				Parent = UserInfoSection,
			}, {
				NewCorner("PillCorner"),
				New("UIStroke", { Transparency = 0.7, Thickness = GetStyleProperty("BorderThickness"), ThemeTag = { Color = "ElementBorder" } }),
			})

			pcall(function()
				local Players = game:GetService("Players")
				local content, isReady = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				if isReady and content then
					Avatar.Image = content
				end
			end)
			local titleText = tostring((Config.UserInfoTitle ~= nil and Config.UserInfoTitle) or (LocalPlayer.Name or "User"))
			local subtitleText = (Config.UserInfoSubtitle ~= nil) and tostring(Config.UserInfoSubtitle) or ""
			New("TextLabel", {
				Name = "UserName",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				FontFace = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeMd"),
				Text = titleText,
				Size = UDim2.new(1, -avatarSize - 12, 0.5, 0),
				Position = UDim2.new(0, avatarSize + 12, 0, -2),
				Parent = UserInfoSection,
				ThemeTag = { TextColor3 = "Text" },
			})

			New("TextLabel", {
				Name = "UserSubtitle",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				FontFace = GetStyleProperty("FontRegular"),
				TextSize = GetStyleProperty("TextSizeSm"),
				TextTransparency = 0.2,
				Text = subtitleText,
				TextColor3 = parseColor(Config.UserInfoSubtitleColor),
				Size = UDim2.new(1, -avatarSize - 12, 0.5, 0),
				Position = UDim2.new(0, avatarSize + 12, 0.5, 2),
				Parent = UserInfoSection,
			})

			if Config.UserInfoTop then
				local topOffset = Window.TopOffset or 0
				local imageOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
				TabFrame.Position = UDim2.new(0, 12, 0, 39)
				TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, -(31 + imageOffset + userInfoHeight))
				local searchOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
				SearchFrame.Position = UDim2.new(0, 0, 0, userInfoHeight + 6 + searchOffset)
				if ImageFrame then
					ImageFrame.Position = UDim2.new(0.5, 0, 0, userInfoHeight + topOffset)
				end
				local newTabHolderTop = userInfoHeight + 6 + (hasImage and (imageSize + 10 + topOffset) or topOffset) + (Window.ShowSearch and (searchHeight + 6) or 0)
				Window.TabHolderTop = newTabHolderTop
				Window.TabHolder.Position = UDim2.new(0, 0, 0, newTabHolderTop)
				Window.TabHolder.Size = UDim2.new(1, 0, 1, -(newTabHolderTop + 6 + userInfoHeight))
				if Window.UpdateTabHolderLayout then
					Window:UpdateTabHolderLayout(newTabHolderTop)
				end
			else
				Window.TabHolder.Size = UDim2.new(1, 0, 1, -(tabHolderTop + 6 + userInfoHeight))
				if Window.UpdateTabHolderLayout then
					Window:UpdateTabHolderLayout(tabHolderTop)
				end
			end
		end
		if Library.UseAcrylic and Window.AcrylicPaint and Window.AcrylicPaint.AddParent then
			Window.AcrylicPaint.AddParent(Window.Root)
		end
		local SizeMotor = Flipper.GroupMotor.new({
			X = Window.Size.X.Offset,
			Y = Window.Size.Y.Offset,
		})

		local PosMotor = Flipper.GroupMotor.new({
			X = Window.Position.X.Offset,
			Y = Window.Position.Y.Offset,
		})

		_G.CDDrag = 0
		Window.SelectorPosMotor = Flipper.SingleMotor.new(17)
		Window.SelectorSizeMotor = Flipper.SingleMotor.new(0)
		Window.ContainerBackMotor = Flipper.SingleMotor.new(0)
		Window.ContainerPosMotor = Flipper.SingleMotor.new(94)
		Window.ContainerXMotor = Flipper.SingleMotor.new(0)
		SizeMotor:onStep(function(values)
			task.wait(_G.CDDrag / 10)
			Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
			task.spawn(function()
				task.wait(0.01)
				if Window.UpdateTabHolderLayout then
					Window:UpdateTabHolderLayout()
				end
			end)
		end)
		PosMotor:onStep(function(values)
			task.wait(_G.CDDrag / 10)
			Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
		end)
		local LastValue = 0
		local LastTime = 0
		Window.SelectorPosMotor:onStep(function(Value)
			local base = Window.TabHolderTop or 45
			local verticalInset = 16
			local selectorY = base + Value + verticalInset
			local searchOffset = Window.HasImage and (Window.ImageSize + Window.TopOffset + 10) or Window.TopOffset
			local searchTop = searchOffset
			local searchBottom = searchTop + 28
			if Window.HasImage and Window.ImageSize then
				local imageBottom = Window.ImageSize + Window.TopOffset + 10
				if selectorY < imageBottom then
					Selector.Visible = false
					return
				end
			end
			if Window.ShowSearch then
				if selectorY >= searchTop and selectorY <= searchBottom then
					Selector.Visible = false
					return
				end
			end
			if Window.UserInfoHeight then
				local tabFrameSize = Window.TabFrame and Window.TabFrame.Size.Y.Offset or 0
				local userInfoTop = Window.UserInfoTop and 0 or (tabFrameSize - Window.UserInfoHeight - 2)
				local userInfoBottom = userInfoTop + Window.UserInfoHeight
				if selectorY >= userInfoTop and selectorY <= userInfoBottom then
					Selector.Visible = false
					return
				end
			end
			Selector.Visible = true
			Selector.Position = UDim2.new(0, 0, 0, selectorY)
			local Now = tick()
			local DeltaTime = Now - LastTime
			if LastValue ~= nil then
				Window.SelectorSizeMotor:setGoal(Spring((math.abs(Value - LastValue) / (DeltaTime * 60)) + 16))
				LastValue = Value
			end
			LastTime = Now
		end)
		Window.SelectorSizeMotor:onStep(function(Value)
			Selector.Size = UDim2.new(0, 4, 0, Value)
		end)
		Window.ContainerBackMotor:onStep(function(Value)
			Window.ContainerAnim.GroupTransparency = Value
		end)
		local ContainerXValue = 0
		local ContainerYValue = 94
		local function UpdateContainerPosition()
			if Window.ContainerAnim then
				Window.ContainerAnim.Position = UDim2.fromOffset(ContainerXValue, ContainerYValue)
			end
		end
		Window.ContainerPosMotor:onStep(function(Value)
			ContainerYValue = Value
			UpdateContainerPosition()
		end)
		Window.ContainerXMotor:onStep(function(Value)
			ContainerXValue = Value
			UpdateContainerPosition()
		end)
		local OldSizeX
		local OldSizeY
		Window.Maximize = function(Value, NoPos, Instant)
			Window.Maximized = Value
			Window.TitleBar.MaxButton.Frame.Icon.Image = Value and Components.Assets.Restore or Components.Assets.Max
			if Value then
				OldSizeX = Window.Size.X.Offset
				OldSizeY = Window.Size.Y.Offset
			end
			local SizeX = Value and Camera.ViewportSize.X or OldSizeX
			local SizeY = Value and Camera.ViewportSize.Y or OldSizeY
			SizeMotor:setGoal({
				X = Flipper[Instant and "Instant" or "Spring"].new(SizeX, { frequency = 6 }),
				Y = Flipper[Instant and "Instant" or "Spring"].new(SizeY, { frequency = 6 }),
			})
			Window.Size = UDim2.fromOffset(SizeX, SizeY)
			if not NoPos then
				PosMotor:setGoal({
					X = Spring(Value and 0 or Window.Position.X.Offset, { frequency = 6 }),
					Y = Spring(Value and 0 or Window.Position.Y.Offset, { frequency = 6 }),
				})
			end
		end
		Creator.AddSignal(Window.TitleBar.Frame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				MousePos = Input.Position
				StartPos = Window.Root.Position
				if Window.Maximized then
					StartPos = UDim2.fromOffset(
						Mouse.X - (Mouse.X * ((OldSizeX - 100) / Window.Root.AbsoluteSize.X)),
						Mouse.Y - (Mouse.Y * (OldSizeY / Window.Root.AbsoluteSize.Y))
					)
				end
				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseMovement
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = Input
			end
		end)
		Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Resizing = true
				ResizePos = Input.Position
			end
		end)
		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				Window.Position = UDim2.fromOffset(StartPos.X.Offset + Delta.X, StartPos.Y.Offset + Delta.Y)
				PosMotor:setGoal({
					X = Instant(Window.Position.X.Offset),
					Y = Instant(Window.Position.Y.Offset),
				})

				if Window.Maximized then
					Window.Maximize(false, true, true)
				end
			end
			if
				(Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
				and Resizing
			then
				-- ✅ FIX: คำนวณ delta จาก frame ก่อนหน้า ไม่ใช่จาก ResizePos เดิม
				-- ป้องกัน delta สะสม ทำให้ resize กระโดดตอน drag เร็ว
				local Delta = Input.Position - ResizePos
				ResizePos = Input.Position -- อัปเดตทุก frame
				local currentW = SizeMotor:getValue().X
				local currentH = SizeMotor:getValue().Y
				local TargetSizeClamped = Vector2.new(
					math.clamp(currentW + Delta.X, 470, 2048),
					math.clamp(currentH + Delta.Y, 380, 2048)
				)
				SizeMotor:setGoal({
					X = Flipper.Instant.new(TargetSizeClamped.X),
					Y = Flipper.Instant.new(TargetSizeClamped.Y),
				})

				-- ✅ sync Window.Size แบบ live เพื่อให้ layout อื่นๆ ที่อ้าง Window.Size ถูกต้อง
				Window.Size = UDim2.fromOffset(TargetSizeClamped.X, TargetSizeClamped.Y)
			end
		end)
		Creator.AddSignal(UserInputService.InputEnded, function(Input)
			if Resizing == true or Input.UserInputType == Enum.UserInputType.Touch then
				Resizing = false
				Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
			end
		end)
		Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			if Window.TabHolder and Window.TabHolder.UIListLayout then
				local padding = Window.TabHolder:FindFirstChild("UIPadding")
				local paddingTop = padding and padding.PaddingTop.Offset or 6
				local paddingBottom = padding and padding.PaddingBottom.Offset or 6
				local contentSize = Window.TabHolder.UIListLayout.AbsoluteContentSize.Y + paddingTop + paddingBottom
				if contentSize > 0 then
					Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, contentSize)
				end
			end
		end)
		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if
				type(Library.MinimizeKeybind) == "table"
				and Library.MinimizeKeybind.Type == "Keybind"
				and not UserInputService:GetFocusedTextBox()
			then
				if Input.KeyCode.Name == Library.MinimizeKeybind.Value then
					Window:Minimize()
				end
			elseif Input.KeyCode == Library.MinimizeKey and not UserInputService:GetFocusedTextBox() then
				Window:Minimize()
			end
		end)
		function Window:ToggleSearch()
			Window.ShowSearch = not Window.ShowSearch
			SearchFrame.Visible = Window.ShowSearch
			local topOffset = Window.TopOffset or 25
			local searchOffset = Window.HasImage and (Window.ImageSize + 10 + topOffset) or topOffset
			SearchFrame.Position = UDim2.new(0, 0, 0, searchOffset)
			local imageOffset = Window.HasImage and (Window.ImageSize + 10 + topOffset) or topOffset
			local searchHeight = 28
			local totalOffset = (Window.ShowSearch and searchHeight or 0) + imageOffset
			TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, -(totalOffset + 31))
			if Window.UpdateTabHolderLayout then
				Window:UpdateTabHolderLayout()
			end
		end
		function Window:Minimize()
			Window.Minimized = not Window.Minimized
			for _, Option in next, Library.Options do
				if Option and Option.Type == "Dropdown" and Option.Opened then
					pcall(function()
						Option:Close()
					end)
				end
			end

			-- 🎬 อนิเมชันย่อ/ขยายหน้าต่าง: scale + fade พร้อมกัน สปริงนุ่มๆ ไม่กระเด้ง
			local SmoothSpringParams = { frequency = 4.5, dampingRatio = 1 } -- dampingRatio 1 = ไม่มี overshoot, glide เนียนๆ
			if Window.Minimized then
				if Window.RootScaleMotor then
					Window.RootScaleMotor:setGoal(Spring(0.8, SmoothSpringParams))
				end
				if Window.RootFadeMotor then
					Window.RootFadeMotor:setGoal(Spring(1, SmoothSpringParams))
				end
				task.delay(0.22, function()
					if Window.Minimized then
						Window.Root.Visible = false
					end
				end)
			else
				Window.Root.Visible = true
				if Window.RootScale then
					Window.RootScale.Scale = 0.8
				end
				if Window.RootWrapper then
					Window.RootWrapper.GroupTransparency = 1
				end
				if Window.RootScaleMotor then
					Window.RootScaleMotor:setGoal(Spring(1, SmoothSpringParams))
				end
				if Window.RootFadeMotor then
					Window.RootFadeMotor:setGoal(Spring(0, SmoothSpringParams))
				end
			end

			-- 🔘 ปุ่มมินิไซ — โผล่มาตอนพับหน้าต่างเท่านั้น ไม่โผล่ค้างตั้งแต่แรก
			if Library.SetMinimizerVisible then
				Library.SetMinimizerVisible(Window.Minimized, true)
			end
			if not MinimizeNotif then
				MinimizeNotif = true
				local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
				if not Mobile then Library:Notify({
					Title = "Interface",
					Content = "Press " .. Key .. " to toggle the interface.",
					Duration = 6
					})
				else
					Library:Notify({
						Title = "Interface",
						Content = "Tap to the button to toggle the interface.",
						Duration = 6
					})
				end
			end
			if not RunService:IsStudio() and Library.Minimizer then
				pcall(function()
					if Mobile then
						local mobileButton = Library.Minimizer:FindFirstChild("TextButton")
						if mobileButton then
							local imageLabel = mobileButton:FindFirstChild("ImageLabel")
							if imageLabel then
								imageLabel.Image = Window.Minimized and "rbxassetid://10734896384" or "rbxassetid://10734897102"
							end
						end
					else
						local desktopButton = Library.Minimizer:FindFirstChild("TextButton")
						if desktopButton then
							local imageLabel = desktopButton:FindFirstChild("ImageLabel")
							if imageLabel then
								imageLabel.Image = Window.Minimized and "rbxassetid://10734896384" or "rbxassetid://10734897102"
							end
						end
					end
				end)
			end
		end
		function Window:Destroy()
			if Library.UseAcrylic then
				Window.AcrylicPaint.Model:Destroy()
			end
			Window.Root:Destroy()
		end
		function Window:SetBackgroundImage(imageUrl, imageTransparency)
			if not Window.BackgroundImage then
				local imgTransparency = imageTransparency or Window.BackgroundImageTransparency or Window.BackgroundTransparency or 0.5
				local BackgroundImageFrame = New("ImageLabel", {
					Name = "BackgroundImage",
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromOffset(0, 0),
					BackgroundTransparency = 1,
					Image = imageUrl,
					ImageTransparency = math.max(0, math.min(1, imgTransparency)),
					ZIndex = 0,
					ScaleType = Enum.ScaleType.Stretch,
					Parent = Window.Root,
				}, {
					NewCorner("ElementCorner"),
				})
				Window.BackgroundImage = BackgroundImageFrame
				if imageTransparency ~= nil then
					Window.BackgroundImageTransparency = imageTransparency
				end
			else
				Window.BackgroundImage.Image = imageUrl
				Window.BackgroundImage.ScaleType = Enum.ScaleType.Stretch
				if imageTransparency ~= nil then
					Window.BackgroundImageTransparency = imageTransparency
					Window.BackgroundImage.ImageTransparency = math.max(0, math.min(1, imageTransparency))
				end
			end
		end
		function Window:SetBackgroundTransparency(transparency)
			transparency = transparency or 0.5
			Window.BackgroundTransparency = transparency
		end
		function Window:SetBackgroundImageTransparency(transparency)
			transparency = transparency or 0.5
			Window.BackgroundImageTransparency = transparency
			if Window.BackgroundImage then
				Window.BackgroundImage.ImageTransparency = math.max(0, math.min(1, transparency))
			end
			if Window.AcrylicPaint and Window.AcrylicPaint.Frame then
				if transparency <= 0.1 then
					Window.AcrylicPaint.Frame.BackgroundTransparency = 1
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 1
					end
					local function makeTransparent(obj)
						if obj:IsA("Frame") then
							obj.BackgroundTransparency = 1
						elseif obj:IsA("ImageLabel") then
							obj.ImageTransparency = 1
						end
						for _, child in ipairs(obj:GetChildren()) do
							if not child:IsA("UICorner") and not child:IsA("UIGradient") and not child:IsA("UIStroke") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
								makeTransparent(child)
							end
						end
					end
					makeTransparent(Window.AcrylicPaint.Frame)
				elseif transparency < 0.3 then
					Window.AcrylicPaint.Frame.BackgroundTransparency = 0.99
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 0.99
					end
				else
					Window.AcrylicPaint.Frame.BackgroundTransparency = 0.98
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 0.98
					end
				end
			end
		end
		local DialogModule = Components.Dialog:Init(Window)
		function Window:Dialog(Config)
			local Dialog = DialogModule:Create()
			Dialog.Title.Text = Config.Title
			if Config.Icon then
				Dialog:SetIcon(Config.Icon)
			end
			local ContentHolder = New("ScrollingFrame", {
				BackgroundTransparency = 1,
				ScrollBarImageTransparency = 0.7,
				ScrollBarThickness = 4,
				BottomImage = "rbxassetid://6889812791",
				MidImage = "rbxassetid://6889812721",
				TopImage = "rbxassetid://6276641225",
				Position = UDim2.fromOffset(28, 84),
				Size = UDim2.new(1, -56, 1, -160),
				CanvasSize = UDim2.fromOffset(0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Parent = Dialog.Root,
			})

			-- [ จุดที่แก้ ] เอา TextColor3 hardcode ทิ้งเหมือนกัน ให้ ThemeTag = "SubText" ควบคุมสีจริงๆ
			local Content = New("TextLabel", {
				FontFace = GetStyleProperty("FontRegular"), -- น้ำหนักเบา อ่านสบาย ตัดกับหัวข้อตัวหนา ให้ลำดับชั้นชัดแบบ editorial
				Text = Config.Content,
				TextSize = GetStyleProperty("TextSizeLg"),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Top,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextWrapped = true,
				Size = UDim2.new(1, -8, 0, 0),
				BackgroundTransparency = 1,
				Parent = ContentHolder,
				ThemeTag = { TextColor3 = "SubText" },
			})

			New("UISizeConstraint", {
				MinSize = Vector2.new(340, 200),
				MaxSize = Vector2.new(620, math.huge),
				Parent = Dialog.Root,
			})

			local maxWidth = math.min(620, Window.Size.X.Offset - 120)
			local baseWidth = math.max(340, math.min(maxWidth, Content.TextBounds.X + 56))
			Dialog.Root.Size = UDim2.fromOffset(baseWidth, 200)
			ContentHolder.Size = UDim2.new(1, -56, 1, -160)
			task.defer(function()
				local contentHeight = Content.TextBounds.Y
				local desired = math.clamp(contentHeight + 160, 200, 460)
				Dialog.Root.Size = UDim2.fromOffset(baseWidth, desired)
				ContentHolder.CanvasSize = UDim2.fromOffset(0, contentHeight)
			end)
			for i, Button in next, Config.Buttons do
				Dialog:Button(Button.Title, Button.Callback, i == 1)
			end
			Dialog:Open()
		end
		local TabModule = Components.Tab:Init(Window)
		function Window:AddTab(TabConfig)
			local tab = TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder)
			-- ✅ ออโต้เลือกแท็บแรกให้เองทันทีหลังสร้างเสร็จ
			-- เดิม: ต้องรอผู้ใช้กดแท็บเองก่อน เนื้อหาถึงจะโชว์ (Container ถูก Visible = false ไว้ตั้งแต่แรก)
			-- ใช้ task.defer + flag กันไม่ให้ AddTab หลายครั้งติดกันสั่ง SelectTab ซ้อนกันจนไปเลือกแท็บท้ายแทนแท็บแรก
			if TabModule.SelectedTab == 0 and not TabModule.PendingAutoSelect then
				TabModule.PendingAutoSelect = true
				local FirstTabIndex = TabModule.TabCount
				task.defer(function()
					TabModule.PendingAutoSelect = nil
					if TabModule.SelectedTab == 0 then
						TabModule:SelectTab(FirstTabIndex)
					end
				end)
			end
			return tab
		end
		function Window:SelectTab(Tab)
			TabModule:SelectTab(Tab)
		end
		Creator.AddSignal(Window.TabHolder:GetPropertyChangedSignal("CanvasPosition"), function()
			LastValue = TabModule:GetCurrentTabPos() + 16
			LastTime = 0
			Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
		end)

		-- 🎬 ================= WINDOW ENTRANCE ANIMATION =================
		-- ทำให้ส่วนประกอบต่างๆของหน้าต่าง (พื้นหลัง / แถบหัวข้อ / แถบแท็บ / พื้นที่เนื้อหา ฯลฯ)
		-- ค่อยๆเลื่อน+เฟดเข้ามาประกอบกันเป็นหน้าต่างจากหลายทิศทาง แบบช้าๆหน่วงๆ (1.8 วินาที)
		do
			local ENTRANCE_DURATION = 1.8
			local ENTRANCE_EASING_STYLE = Enum.EasingStyle.Quint -- โค้งหน่วงช้าๆ สมูทตอนเข้าที่
			local ENTRANCE_EASING_DIR = Enum.EasingDirection.Out

			-- เก็บค่า transparency เดิมของ instance หนึ่งตัว แล้ว "ซ่อน" ไว้ก่อนเริ่มอนิเมชัน
			-- คืนค่าเป็น table ของ {propertyName = originalValue} เอาไว้ tween กลับทีหลัง
			local function CaptureAndHide(obj)
				local props = {}

				local ok1 = pcall(function() return obj.BackgroundTransparency end)
				if ok1 and (obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ImageButton") or obj:IsA("ScrollingFrame") or obj:IsA("TextBox") or obj:IsA("CanvasGroup")) then
					props.BackgroundTransparency = obj.BackgroundTransparency
				end
				if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
					props.TextTransparency = obj.TextTransparency
				end
				if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
					props.ImageTransparency = obj.ImageTransparency
				end
				if obj:IsA("UIStroke") then
					props.Transparency = obj.Transparency
				end
				if next(props) then
					for propName, value in pairs(props) do
						pcall(function() obj[propName] = 1 end)
					end
					return props
				end
				return nil
			end

			-- เลื่อน+เฟด instance (และลูกๆทั้งหมด) เข้ามาจากทิศทางที่กำหนด (offsetX, offsetY เป็นพิกเซล)
			-- delaySec = หน่วงเวลาก่อนเริ่ม เพื่อให้แต่ละชิ้นส่วนทยอยเข้ามาไม่พร้อมกัน
			local function EntranceAnimate(root, offsetX, offsetY, delaySec)
				if not root then return end
				local originalPosition = root.Position
				local transparencyTargets = {}
				local rootProps = CaptureAndHide(root)
				if rootProps then
					transparencyTargets[root] = rootProps
				end
				for _, descendant in ipairs(root:GetDescendants()) do
					local props = CaptureAndHide(descendant)
					if props then
						transparencyTargets[descendant] = props
					end
				end
				root.Position = UDim2.new(
					originalPosition.X.Scale, originalPosition.X.Offset + offsetX,
					originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY
				)
				task.delay(delaySec, function()
					if not root or not root.Parent then return end
					local ti = TweenInfo.new(ENTRANCE_DURATION, ENTRANCE_EASING_STYLE, ENTRANCE_EASING_DIR)
					TweenService:Create(root, ti, { Position = originalPosition }):Play()
					for obj, props in pairs(transparencyTargets) do
						if obj and obj ~= root and obj.Parent then
							TweenService:Create(obj, ti, props):Play()
						end
					end
				end)
			end

			-- พื้นหลัง Acrylic — เฟดเข้าอย่างเดียว (เป็นฉากหลัง ไม่ต้องเลื่อน)
			if Window.AcrylicPaint and Window.AcrylicPaint.Frame then
				EntranceAnimate(Window.AcrylicPaint.Frame, 0, 0, 0)
			end

			-- แถบหัวข้อด้านบน (Title bar) — เลื่อนลงมาจากด้านบน
			if Window.TitleBar and Window.TitleBar.Frame then
				EntranceAnimate(Window.TitleBar.Frame, 0, -40, 0.05)
			end

			-- แถบแท็บด้านข้าง (Sidebar) — เลื่อนเข้ามาจากด้านซ้าย
			EntranceAnimate(TabFrame, -60, 0, 0.15)

			-- หัวข้อแท็บปัจจุบัน — เลื่อนลงมาจากด้านบน
			EntranceAnimate(Window.TabDisplay, 0, -30, 0.3)

			-- พื้นที่เนื้อหาหลัก (Container) — เลื่อนเข้ามาจากด้านขวา
			EntranceAnimate(Window.ContainerCanvas, 60, 0, 0.35)

			-- ปุ่มปรับขนาดมุมล่างขวา — เลื่อนขึ้นมาจากด้านล่าง
			EntranceAnimate(ResizeStartFrame, 0, 40, 0.5)
		end
		-- 🎬 ================================================================

		return Window
	end
end)()
