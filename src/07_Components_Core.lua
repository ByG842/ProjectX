local Components = {
	Assets = {
		Close = "rbxassetid://9886659671",
		Min = "rbxassetid://9886659276",
		Max = "rbxassetid://9886659406",
		Restore = "rbxassetid://9886659001",
	},
}

Components.Element = (function()
	local New = Creator.New
	local Spring = Flipper.Spring.new
	return function(Title, Desc, Parent, Hover, Options)
		local Element = {}
		local Options = Options or {}

		Element.TitleLabel = New("TextLabel", {
			FontFace = GetStyleProperty("FontMedium"),
			Text = Title,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = GetStyleProperty("TextSizeMd"),
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Element.Header = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 5),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		})

		if Options and Options.Icon then
			local iconImage = Options.Icon
			pcall(function()
				if Library and Library.GetIcon then
					local resolved = Library:GetIcon(Options.Icon)
					if resolved then iconImage = resolved end
				end
			end)
			Element.IconImage = New("ImageLabel", {
				Image = iconImage,
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			})
			Element.IconImage.Parent = Element.Header
		end
		Element.TitleLabel.Parent = Element.Header
		Element.DescLabel = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
			Text = Desc,
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = GetStyleProperty("TextSizeMd"),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		local LabelHolderPadding = New("UIPadding", {
			PaddingBottom = UDim.new(0, 13),
			PaddingTop = UDim.new(0, 13),
		})

		Element.LabelHolder = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -28, 0, 0),
		}, {
			New("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
			LabelHolderPadding,
			Element.Header,
			Element.DescLabel,
		})

		Element.Border = New("UIStroke", {
			Transparency = 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(0, 0, 0),
			ThemeTag = {
				Color = "ElementBorder",
			},
		})

		Element.Frame = New("TextButton", {
			Visible = Options.Visible and Options.Visible or true,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 0.89,
			BackgroundColor3 = Color3.fromRGB(130, 130, 130),
			Parent = Parent,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = "",
			LayoutOrder = 7,
			ThemeTag = {
				BackgroundColor3 = "Element",
				BackgroundTransparency = "ElementTransparency",
			},
		}, {
			NewCorner("ElementCorner"),
			Element.Border,
			Element.LabelHolder,
		})

		function Element:SetTitle(Set)
			Element.TitleLabel.Text = Set
			local hasTitle = (Set ~= nil and Set ~= "")
			Element.Header.Visible = hasTitle
			if not hasTitle then
				if Element.IconImage then
					if not Element.DescRow then
						Element.DescRow = New("Frame", {
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 14),
							LayoutOrder = 2,
						}, {
							New("UIListLayout", {
								Padding = UDim.new(0, 5),
								FillDirection = Enum.FillDirection.Horizontal,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							}),
						})
						Element.DescRow.Parent = Element.LabelHolder
					end
					if not Element.DescIconImage then
						Element.DescIconImage = New("ImageLabel", {
							Image = Element.IconImage.Image,
							Size = UDim2.fromOffset(16, 16),
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							ThemeTag = {
								ImageColor3 = "Text",
							},
						})
						Element.DescIconImage.Parent = Element.DescRow
					else
						Element.DescIconImage.Image = Element.IconImage.Image
						Element.DescIconImage.Parent = Element.DescRow
					end
					Element.DescLabel.Parent = Element.DescRow
					Element.DescLabel.LayoutOrder = 2
					Element.DescLabel.Size = UDim2.new(1, -24, 0, 14)
				else
					if Element.DescRow then
						Element.DescRow:Destroy()
						Element.DescRow = nil
						Element.DescIconImage = nil
					end
					Element.DescLabel.Parent = Element.LabelHolder
					Element.DescLabel.LayoutOrder = 2
					Element.DescLabel.Size = UDim2.new(1, 0, 0, 14)
				end
			else
				if Element.DescRow then
					Element.DescRow:Destroy()
					Element.DescRow = nil
					Element.DescIconImage = nil
				end
				Element.DescLabel.Parent = Element.LabelHolder
				Element.DescLabel.LayoutOrder = 2
				Element.DescLabel.Size = UDim2.new(1, 0, 0, 14)
			end
			if Library.Window and Library.Window.AllElements and Library.Window.AllElements[Element.Frame] then
				Library.Window.AllElements[Element.Frame].title = Set
			elseif Library.Windows and #Library.Windows > 0 then
				local currentWindow = Library.Windows[#Library.Windows]
				if currentWindow and currentWindow.AllElements and currentWindow.AllElements[Element.Frame] then
					currentWindow.AllElements[Element.Frame].title = Set
				end
			end
		end
		function Element:Visible(Bool)
			Element.Frame.Visible = Bool
		end
		function Element:SetDesc(Set)
			if Set == nil then
				Set = ""
			end
			if Set == "" then
				Element.DescLabel.Visible = false
			else
				Element.DescLabel.Visible = true
			end
			Element.DescLabel.Text = Set
			if Library.Window and Library.Window.AllElements and Library.Window.AllElements[Element.Frame] then
				Library.Window.AllElements[Element.Frame].description = Set
			elseif Library.Windows and #Library.Windows > 0 then
				local currentWindow = Library.Windows[#Library.Windows]
				if currentWindow and currentWindow.AllElements and currentWindow.AllElements[Element.Frame] then
					currentWindow.AllElements[Element.Frame].description = Set
				end
			end
		end
		function Element:GetTitle()
			return Element.TitleLabel.Text
		end
		function Element:GetDesc()
			return Element.DescLabel.Text
		end
		function Element:Destroy()
			Element.Frame:Destroy()
		end
		Element.Header.Visible = not (Title == nil or Title == "")
		Element:SetTitle(Title or "")
		Element:SetDesc(Desc)
		if Library.Window and Library.Window.RegisterElement then
			Library.Window.RegisterElement(Element.Frame, Title, "Element", Desc)
		elseif Library.Windows and #Library.Windows > 0 then
			local currentWindow = Library.Windows[#Library.Windows]
			if currentWindow and currentWindow.RegisterElement then
				currentWindow.RegisterElement(Element.Frame, Title, "Element", Desc)
			end
		end
		if Hover then
			local Themes = Library.Themes
			local Motor, SetTransparency = Creator.SpringMotor(
				Creator.GetThemeProperty("ElementTransparency"),
				Element.Frame,
				"BackgroundTransparency",
				false,
				true
			)
			Creator.AddSignal(Element.Frame.MouseEnter, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
			end)
			Creator.AddSignal(Element.Frame.MouseLeave, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
			end)
			Creator.AddSignal(Element.Frame.MouseButton1Down, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency") + Creator.GetThemeProperty("HoverChange"))
			end)
			Creator.AddSignal(Element.Frame.MouseButton1Up, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
			end)
		end
		return Element
	end
end)()
Components.Section = (function()
	local New = Creator.New
	return function(Title, Parent, Icon)
		local Section = {}

		-- padding รอบ elements ข้างใน card
		local CARD_PAD_H  = 8   -- padding ซ้ายขวาภายใน card
		local CARD_PAD_V  = 6   -- padding บนล่างภายใน card
		local HEADER_H    = 28  -- ความสูง header row
		local GAP_TOP     = 6   -- ระยะห่างระหว่าง section card กับของข้างบน
		Section.Layout = New("UIListLayout", {
			Padding = UDim.new(0, 4),
		})

		-- Container ที่อยู่ใน card (มี padding)
		Section.Container = New("Frame", {
			Size = UDim2.new(1, -(CARD_PAD_H * 2), 0, 0),
			Position = UDim2.fromOffset(CARD_PAD_H, HEADER_H + CARD_PAD_V),
			BackgroundTransparency = 1,
		}, {
			Section.Layout,
		})

		-- accent bar ซ้ายของ header
		local AccentLine = New("Frame", {
			Size = UDim2.new(0, 3, 0, 14),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundTransparency = 0,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			NewCorner("PillCorner"),
		})

		-- header row
		local SectionHeader = New("Frame", {
			Size = UDim2.new(1, 0, 0, HEADER_H),
			Position = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			Active = true, -- ✅ Frame ธรรมดาไม่รับ input ถ้าไม่เปิด Active (บั๊กเดียวกับ resize handle ที่เจอไปแล้ว)
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 7),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
			}),
			AccentLine,
			Icon and New("ImageLabel", {
				Image = Icon,
				Size = UDim2.fromOffset(14, 14),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				ThemeTag = { ImageColor3 = "SubText" },
			}) or nil,
			New("TextLabel", {
				RichText = true,
				Text = Title,
				TextTransparency = 0,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				TextSize = GetStyleProperty("TextSizeMd"),
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				Size = UDim2.fromScale(0, 1),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				ThemeTag = { TextColor3 = "Text" },
			}),
		})

		-- 📁 Collapse/expand chevron — คลิกหัว section เพื่อพับ/กาง
		local CollapseChevron = New("ImageLabel", {
			Image = "rbxassetid://10709790948", -- lucide-chevron-down
			Size = UDim2.fromOffset(13, 13),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Rotation = 0,
			ThemeTag = { ImageColor3 = "SubText" },
		})
		CollapseChevron.Parent = SectionHeader

		-- เส้นขีดคั่น header กับ content
		local HeaderDivider = New("Frame", {
			Size = UDim2.new(1, -16, 0, 1),
			Position = UDim2.new(0, 8, 0, HEADER_H),
			BackgroundTransparency = 0.7,
			ThemeTag = { BackgroundColor3 = "InElementBorder" },
		})

		-- Card wrapper — มีขอบ + bg จาง ๆ
		local CardFrame = New("Frame", {
			BackgroundTransparency = 0.93,
			Size = UDim2.new(1, 0, 0, HEADER_H + CARD_PAD_V),
			LayoutOrder = 7,
			ClipsDescendants = true, -- ✅ กัน content โผล่ล้นออกมาตอนอนิเมชัน collapse/expand
			Parent = Parent,
			ThemeTag = { BackgroundColor3 = "Element" },
		}, {
			NewCorner("ElementCorner"),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 0.55,
				Thickness = GetStyleProperty("BorderThickness"),
				ThemeTag = { Color = "InElementBorder" },
			}),
			SectionHeader,
			HeaderDivider,
			Section.Container,
		})

		-- gap ด้านบนของแต่ละ section card
		Section.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, HEADER_H + CARD_PAD_V + GAP_TOP),
			LayoutOrder = 7,
			Parent = Parent,
		}, {
			New("UIPadding", {
				PaddingTop = UDim.new(0, GAP_TOP),
			}),
			CardFrame,
		})

		-- Section.Root ชี้ไปที่ CardFrame เพื่อให้ layout คำนวณถูก
		Section._CardFrame = CardFrame
		Section.Collapsed = false
		local lastContentH = 0
		Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			local contentH = Section.Layout.AbsoluteContentSize.Y
			lastContentH = contentH
			Section.Container.Size = UDim2.new(1, -(CARD_PAD_H * 2), 0, contentH)
			if not Section.Collapsed then
				local totalCardH = HEADER_H + CARD_PAD_V + contentH + CARD_PAD_V
				CardFrame.Size = UDim2.new(1, 0, 0, totalCardH)
				Section.Root.Size = UDim2.new(1, 0, 0, totalCardH + GAP_TOP)
			end
		end)
		function Section:SetCollapsed(Collapsed)
			Section.Collapsed = Collapsed
			HeaderDivider.Visible = not Collapsed
			local targetCardH = Collapsed and HEADER_H or (HEADER_H + CARD_PAD_V + lastContentH + CARD_PAD_V)
			local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			TweenService:Create(CardFrame, ti, { Size = UDim2.new(1, 0, 0, targetCardH) }):Play()
			TweenService:Create(Section.Root, ti, { Size = UDim2.new(1, 0, 0, targetCardH + GAP_TOP) }):Play()
			TweenService:Create(CollapseChevron, ti, { Rotation = Collapsed and -90 or 0 }):Play()
			if Collapsed then
				task.delay(0.22, function()
					if Section.Collapsed then Section.Container.Visible = false end
				end)
			else
				Section.Container.Visible = true
			end
		end
		Creator.AddSignal(SectionHeader.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Section:SetCollapsed(not Section.Collapsed)
			end
		end)
		if Library.Window and Library.Window.RegisterElement then
			Library.Window.RegisterElement(Section.Root, Title, "Section")
		elseif Library.Windows and #Library.Windows > 0 then
			local currentWindow = Library.Windows[#Library.Windows]
			if currentWindow and currentWindow.RegisterElement then
				currentWindow.RegisterElement(Section.Root, Title, "Section")
			end
		end
		return Section
	end
end)()
Components.Tab = (function()
	local New = Creator.New
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local Components = Components
	local TabModule = {
		Window = nil,
		Tabs = {},
		Containers = {},
		SelectedTab = 0,
		TabCount = 0,
		AnimationTask = nil,
		CurrentAnimationTab = 0,
	}

	function TabModule:Init(Window)
		TabModule.Window = Window
		return TabModule
	end
	function TabModule:GetCurrentTabPos()
		local TabHolderPos = TabModule.Window.TabHolder.AbsolutePosition.Y
		local TabPos = TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y
		return TabPos - TabHolderPos
	end
	function TabModule:New(Title, Icon, Parent)
		local Window = TabModule.Window
		local Elements = Library.Elements
		TabModule.TabCount = TabModule.TabCount + 1
		local TabIndex = TabModule.TabCount
		local Tab = {
			Selected = false,
			Name = Title,
			Type = "Tab",
		}

		if not fischbypass then
			if Library:GetIcon(Icon) then
				Icon = Library:GetIcon(Icon)
			end
			if Icon == "" or nil then
				Icon = nil
			end
		end
		Tab.Frame = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundTransparency = 0.92,
			Parent = Parent,
			ZIndex = 10,
			LayoutOrder = TabIndex * 10, -- ✅ FIX: เดิมไม่ตั้งค่าเลย ทำให้ UIListLayout (SortOrder=LayoutOrder default) fallback ไปเรียงตามชื่อ Instance แทนลำดับที่เรียกจริง
			ThemeTag = {
				BackgroundColor3 = "Tab",
			},
		}, {
			NewCorner("ElementCorner"),
			New("TextLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = not fischbypass and Icon and UDim2.new(0, 32, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
				Text = Title,
				RichText = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0,
				FontFace = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeSm"),
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				Size = UDim2.new(1, -12, 1, 0),
				BackgroundTransparency = 1,
				ZIndex = 11,
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
			New("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(0, 9, 0.5, 0),
				BackgroundTransparency = 1,
				Image = Icon and Icon or nil,
				ZIndex = 11,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			}),
		})

		local ContainerLayout = New("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Tab.ContainerAnim = New("CanvasGroup", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Parent = Window.ContainerHolder,
			Visible = false,
			Position = UDim2.fromOffset(0, 0),
		})

		Tab.ContainerFrame = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Parent = Tab.ContainerAnim,
			Visible = true,
			BottomImage = "rbxassetid://6889812791",
			MidImage = "rbxassetid://6889812721",
			TopImage = "rbxassetid://6276641225",
			ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
			ScrollBarImageTransparency = 0.95,
			ScrollBarThickness = 3,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = true,
		}, {
			ContainerLayout,
			New("UIPadding", {
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 1),
				PaddingTop = UDim.new(0, 1),
				PaddingBottom = UDim.new(0, 1),
			}),
		})

		Tab.ContainerXMotor = Flipper.SingleMotor.new(0)
		Tab.ContainerTransparencyMotor = Flipper.SingleMotor.new(0)
		Tab.ContainerXMotor:onStep(function(Value)
			if Tab.ContainerAnim and Tab.ContainerAnim.Parent then
				Tab.ContainerAnim.Position = UDim2.fromOffset(Value, 0)
			end
		end)
		Tab.ContainerTransparencyMotor:onStep(function(Value)
			if Tab.ContainerAnim and Tab.ContainerAnim.Parent then
				Tab.ContainerAnim.GroupTransparency = Value
			end
		end)
		Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
		end)
		Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(0.92, Tab.Frame, "BackgroundTransparency")
		Creator.AddSignal(Tab.Frame.MouseEnter, function()
			Tab.SetTransparency(Tab.Selected and 0.85 or 0.87)
		end)
		Creator.AddSignal(Tab.Frame.MouseLeave, function()
			Tab.SetTransparency(Tab.Selected and 0.89 or 0.92)
		end)
		Creator.AddSignal(Tab.Frame.MouseButton1Down, function()
			Tab.SetTransparency(0.92)
		end)
		Creator.AddSignal(Tab.Frame.MouseButton1Up, function()
			Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
		end)
		Creator.AddSignal(Tab.Frame.MouseButton1Click, function()
			TabModule:SelectTab(TabIndex)
		end)
		TabModule.Containers[TabIndex] = Tab.ContainerAnim
		TabModule.Tabs[TabIndex] = Tab
		Tab.Container = Tab.ContainerFrame
		Tab.ScrollFrame = Tab.Container
		Tab.SubTabs = {}
		Tab.SubTabContainers = {}
		Tab.SelectedSubTab = 0
		Tab.SubTabCount = 0
		Tab.SubTabHolder = nil
		function Tab:AddSubTab(Title, Icon)
			self.SubTabCount = self.SubTabCount + 1
			local SubTabIndex = self.SubTabCount
			if not self.SubTabHolder then
				local SubTabListLayout = New("UIListLayout", {
					Padding = UDim.new(0, 6),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				})

				self.SubTabHolder = New("ScrollingFrame", {
					Size = UDim2.new(1, -20, 0, 40),
					Position = UDim2.fromOffset(1, 8),
					BackgroundTransparency = 1,
					Parent = self.ContainerFrame,
					ScrollingDirection = Enum.ScrollingDirection.X,
					ScrollBarThickness = 0,
					ScrollBarImageTransparency = 1,
					ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
					CanvasSize = UDim2.fromScale(0, 1),
					BorderSizePixel = 0,
				}, {
					SubTabListLayout,
					New("UIPadding", {
						PaddingLeft = UDim.new(0, 0),
						PaddingRight = UDim.new(0, 0),
						PaddingTop = UDim.new(0, 0),
						PaddingBottom = UDim.new(0, 0),
					}),
				})

				Creator.AddSignal(SubTabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					self.SubTabHolder.CanvasSize = UDim2.new(0, SubTabListLayout.AbsoluteContentSize.X, 0, 40)
				end)
				local SubTabContainerHolder = New("Frame", {
					Size = UDim2.new(1, -11, 1, -56),
					Position = UDim2.fromOffset(1, 48),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Parent = self.ContainerFrame,
				})

				self.SubTabContainerHolder = SubTabContainerHolder
			end
			local SubTabIcon = Icon
			if not fischbypass then
				if Library:GetIcon(Icon) then
					SubTabIcon = Library:GetIcon(Icon)
				end
				if SubTabIcon == "" or nil then
					SubTabIcon = nil
				end
			end
			local SubTabButton = New("TextButton", {
				Size = UDim2.new(0, 0, 0, 32),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 0.92,
				Parent = self.SubTabHolder,
				Text = "",
				ThemeTag = {
					BackgroundColor3 = "Tab",
				},
			}, {
				NewCorner("SmallCorner"),
				New("UIStroke", {
					Transparency = 1,
					Thickness = GetStyleProperty("BorderThickness"),
					ThemeTag = {
						Color = "Accent",
					},
				}),
				New("UIListLayout", {
					Padding = UDim.new(0, 6),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
					PaddingTop = UDim.new(0, 6),
					PaddingBottom = UDim.new(0, 6),
				}),
				SubTabIcon and New("ImageLabel", {
					Size = UDim2.fromOffset(16, 16),
					BackgroundTransparency = 1,
					Image = SubTabIcon,
					LayoutOrder = 1,
					ThemeTag = {
						ImageColor3 = "Text",
					},
				}) or nil,
				New("TextLabel", {
					Text = Title,
					RichText = true,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextTransparency = 0,
					FontFace = GetStyleProperty("FontRegular"),
					TextSize = GetStyleProperty("TextSizeSm"),
					TextXAlignment = "Left",
					TextYAlignment = "Center",
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					ThemeTag = {
						TextColor3 = "Text",
					},
				}),
			})

			local SubTabContainerAnim = New("CanvasGroup", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				GroupTransparency = 0,
				Parent = self.SubTabContainerHolder,
				Visible = false,
				Position = UDim2.fromOffset(0, 0),
			})

			local SubTabContainer = New("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Parent = SubTabContainerAnim,
				Visible = true,
				BottomImage = "rbxassetid://6889812791",
				MidImage = "rbxassetid://6889812721",
				TopImage = "rbxassetid://6276641225",
				ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
				ScrollBarImageTransparency = 0.95,
				ScrollBarThickness = 3,
				BorderSizePixel = 0,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = true,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				New("UIPadding", {
					PaddingRight = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 1),
					PaddingTop = UDim.new(0, 1),
					PaddingBottom = UDim.new(0, 1),
				}),
			})

			local SubTabLayout = SubTabContainer:FindFirstChild("UIListLayout")
			Creator.AddSignal(SubTabLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				SubTabContainer.CanvasSize = UDim2.new(0, 0, 0, SubTabLayout.AbsoluteContentSize.Y + 2)
			end)
			local SubTabXMotor = Flipper.SingleMotor.new(0)
			local SubTabTransparencyMotor = Flipper.SingleMotor.new(0)
			SubTabXMotor:onStep(function(Value)
				if SubTabContainerAnim and SubTabContainerAnim.Parent then
					SubTabContainerAnim.Position = UDim2.fromOffset(Value, 0)
				end
			end)
			SubTabTransparencyMotor:onStep(function(Value)
				if SubTabContainerAnim and SubTabContainerAnim.Parent then
					SubTabContainerAnim.GroupTransparency = Value
				end
			end)
			local SubTabMotor, SubTabSetTransparency = Creator.SpringMotor(0.92, SubTabButton, "BackgroundTransparency")
			local SubTabStroke = SubTabButton:FindFirstChild("UIStroke")
			local function UpdateSubTabAppearance()
				if self.SelectedSubTab == SubTabIndex then
					SubTabSetTransparency(0.75)
					if SubTabStroke then
						SubTabStroke.Transparency = 0
					end
				else
					SubTabSetTransparency(0.92)
					if SubTabStroke then
						SubTabStroke.Transparency = 1
					end
				end
			end
			Creator.AddSignal(SubTabButton.MouseEnter, function()
				if self.SelectedSubTab ~= SubTabIndex then
					SubTabSetTransparency(0.87)
				end
			end)
			Creator.AddSignal(SubTabButton.MouseLeave, function()
				UpdateSubTabAppearance()
			end)
			Creator.AddSignal(SubTabButton.MouseButton1Down, function()
				SubTabSetTransparency(0.92)
			end)
			Creator.AddSignal(SubTabButton.MouseButton1Up, function()
				UpdateSubTabAppearance()
			end)
			UpdateSubTabAppearance()
			Creator.AddSignal(SubTabButton.MouseButton1Click, function()
				self:SelectSubTab(SubTabIndex)
			end)
			local SubTab = {
				Type = "SubTab",
				Name = Title,
				Button = SubTabButton,
				Container = SubTabContainer,
				ScrollFrame = SubTabContainer,
				ContainerAnim = SubTabContainerAnim,
				XMotor = SubTabXMotor,
				TransparencyMotor = SubTabTransparencyMotor,
				SetTransparency = SubTabSetTransparency,
				Selected = false,
			}

			self.SubTabs[SubTabIndex] = SubTab
			self.SubTabContainers[SubTabIndex] = SubTabContainerAnim
			if self.SubTabCount == 1 then
				self:SelectSubTab(SubTabIndex)
			end
			function SubTab:AddSection(SectionTitle, SectionIcon)
				local Section = { Type = "Section" }

				local Icon = SectionIcon
				if not fischbypass then
					if Library:GetIcon(Icon) then
						Icon = Library:GetIcon(Icon)
					end
					if Icon == "" or nil then
						Icon = nil
					end
				end
				local SectionFrame = Components.Section(SectionTitle, SubTab.Container, Icon)
				Section.Container = SectionFrame.Container
				Section.ScrollFrame = SubTab.Container
				setmetatable(Section, Elements)
				return Section
			end
			setmetatable(SubTab, Elements)
			return SubTab
		end
		function Tab:SelectSubTab(SubTabIndex)
			if self.SelectedSubTab == SubTabIndex then
				return
			end
			local PreviousSubTab = self.SelectedSubTab
			local Direction = (PreviousSubTab > 0 and SubTabIndex > PreviousSubTab) and 1 or -1
			if PreviousSubTab == 0 then
				Direction = 0
			end
			local ContainerSize = self.SubTabContainerHolder and self.SubTabContainerHolder.AbsoluteSize.X or 500
			local SlideDistance = math.min(ContainerSize * 0.15, 60)
			self.SelectedSubTab = SubTabIndex
			for idx, SubTabObj in next, self.SubTabs do
				SubTabObj.Selected = (idx == SubTabIndex)
				local SubTabStroke = SubTabObj.Button:FindFirstChild("UIStroke")
				if idx == SubTabIndex then
					SubTabObj.SetTransparency(0.75)
					if SubTabStroke then
						SubTabStroke.Transparency = 0
					end
				else
					SubTabObj.SetTransparency(0.92)
					if SubTabStroke then
						SubTabStroke.Transparency = 1
					end
				end
			end
			if PreviousSubTab > 0 and PreviousSubTab ~= SubTabIndex and self.SubTabs[PreviousSubTab] and self.SubTabs[SubTabIndex] then
				local OldContainer = self.SubTabs[PreviousSubTab].ContainerAnim
				local NewContainer = self.SubTabs[SubTabIndex].ContainerAnim
				local OldSubTab = self.SubTabs[PreviousSubTab]
				local NewSubTab = self.SubTabs[SubTabIndex]
				for idx, Container in next, self.SubTabContainers do
					if Container and idx ~= PreviousSubTab and idx ~= SubTabIndex then
						Container.Visible = false
						Container.Position = UDim2.fromOffset(0, 0)
						Container.GroupTransparency = 0
						if self.SubTabs[idx] then
							pcall(function()
								self.SubTabs[idx].XMotor:setGoal(Instant(0))
								self.SubTabs[idx].TransparencyMotor:setGoal(Instant(0))
							end)
						end
					end
				end
				OldContainer.Visible = true
				OldContainer.Position = UDim2.fromOffset(0, 0)
				OldContainer.GroupTransparency = 0
				pcall(function()
					OldSubTab.XMotor:setGoal(Instant(0))
					OldSubTab.TransparencyMotor:setGoal(Instant(0))
				end)
				NewContainer.Visible = true
				NewContainer.Position = UDim2.fromOffset(Direction * SlideDistance, 0)
				NewContainer.GroupTransparency = 1
				pcall(function()
					NewSubTab.XMotor:setGoal(Instant(Direction * SlideDistance))
					NewSubTab.TransparencyMotor:setGoal(Instant(1))
				end)
				task.wait()
				pcall(function()
					OldSubTab.XMotor:setGoal(Spring(-Direction * SlideDistance, { frequency = 4, dampingRatio = 0.7 }))
					OldSubTab.TransparencyMotor:setGoal(Spring(1, { frequency = 4, dampingRatio = 0.7 }))
				end)
				pcall(function()
					NewSubTab.XMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
					NewSubTab.TransparencyMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
				end)
				task.spawn(function()
					task.wait(0.5)
					if self.SelectedSubTab == SubTabIndex and self.SubTabs[PreviousSubTab] then
						local OldContainer = self.SubTabs[PreviousSubTab].ContainerAnim
						local OldSubTab = self.SubTabs[PreviousSubTab]
						if OldContainer and OldContainer.Parent then
							OldContainer.Visible = false
							OldContainer.Position = UDim2.fromOffset(0, 0)
							OldContainer.GroupTransparency = 0
						end
						if OldSubTab and OldSubTab.XMotor and OldSubTab.TransparencyMotor then
							pcall(function()
								OldSubTab.XMotor:setGoal(Instant(0))
								OldSubTab.TransparencyMotor:setGoal(Instant(0))
							end)
						end
					end
				end)
			else
				for idx, Container in next, self.SubTabContainers do
					if Container then
						Container.Visible = (idx == SubTabIndex)
						Container.Position = UDim2.fromOffset(0, 0)
						Container.GroupTransparency = 0
						if self.SubTabs[idx] then
							pcall(function()
								self.SubTabs[idx].XMotor:setGoal(Instant(0))
								self.SubTabs[idx].TransparencyMotor:setGoal(Instant(0))
							end)
						end
					end
				end
			end
		end
		function Tab:AddSection(SectionTitle, SectionIcon)
			if self.SelectedSubTab > 0 and self.SubTabs[self.SelectedSubTab] then
				return self.SubTabs[self.SelectedSubTab]:AddSection(SectionTitle, SectionIcon)
			end
			local Section = { Type = "Section" }

			local Icon = SectionIcon
			if not fischbypass then
				if Library:GetIcon(Icon) then
					Icon = Library:GetIcon(Icon)
				end
				if Icon == "" or nil then
					Icon = nil
				end
			end
			local SectionFrame = Components.Section(SectionTitle, Tab.Container, Icon)
			Section.Container = SectionFrame.Container
			Section.ScrollFrame = Tab.Container
			setmetatable(Section, Elements)
			return Section
		end
		setmetatable(Tab, Elements)
		return Tab
	end
	function TabModule:SelectTab(Tab)
		if TabModule.SelectedTab == Tab then
			return
		end
		if TabModule.AnimationTask then
			task.cancel(TabModule.AnimationTask)
			TabModule.AnimationTask = nil
		end
		local Window = TabModule.Window
		local PreviousTab = TabModule.SelectedTab
		local Direction = (PreviousTab > 0 and Tab > PreviousTab) and 1 or -1
		if PreviousTab == 0 then
			Direction = 0
		end
		local ContainerSize = Window.ContainerHolder and Window.ContainerHolder.AbsoluteSize.X or (Window.ContainerCanvas and Window.ContainerCanvas.AbsoluteSize.X or 500)
		local SlideDistance = math.min(ContainerSize * 0.15, 60)
		TabModule.SelectedTab = Tab
		TabModule.CurrentAnimationTab = Tab
		for _, TabObject in next, TabModule.Tabs do
			TabObject.SetTransparency(0.92)
			TabObject.Selected = false
		end
		TabModule.Tabs[Tab].SetTransparency(0.89)
		TabModule.Tabs[Tab].Selected = true
		Window.TabDisplay.Text = TabModule.Tabs[Tab].Name
		Window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), { frequency = 6 }))
		if PreviousTab > 0 and PreviousTab ~= Tab and TabModule.Tabs[PreviousTab] and TabModule.Tabs[Tab] then
			local OldContainer = TabModule.Tabs[PreviousTab].ContainerAnim
			local NewContainer = TabModule.Tabs[Tab].ContainerAnim
			local OldTab = TabModule.Tabs[PreviousTab]
			local NewTab = TabModule.Tabs[Tab]
			if not OldContainer or not NewContainer or not OldTab.ContainerXMotor or not OldTab.ContainerTransparencyMotor or not NewTab.ContainerXMotor or not NewTab.ContainerTransparencyMotor then
				for idx, Container in next, TabModule.Containers do
					if Container then
						Container.Visible = (idx == Tab)
						Container.Position = UDim2.fromOffset(0, 0)
						Container.GroupTransparency = 0
					end
				end
				return
			end
			for idx, Container in next, TabModule.Containers do
				if Container and idx ~= PreviousTab and idx ~= Tab then
					Container.Visible = false
					Container.Position = UDim2.fromOffset(0, 0)
					Container.GroupTransparency = 0
					if TabModule.Tabs[idx] and TabModule.Tabs[idx].ContainerXMotor and TabModule.Tabs[idx].ContainerTransparencyMotor then
						pcall(function()
							TabModule.Tabs[idx].ContainerXMotor:setGoal(Instant(0))
							TabModule.Tabs[idx].ContainerTransparencyMotor:setGoal(Instant(0))
						end)
					end
				end
			end
			OldContainer.Visible = true
			OldContainer.Position = UDim2.fromOffset(0, 0)
			OldContainer.GroupTransparency = 0
			pcall(function()
				OldTab.ContainerXMotor:setGoal(Instant(0))
				OldTab.ContainerTransparencyMotor:setGoal(Instant(0))
			end)
			NewContainer.Visible = true
			NewContainer.Position = UDim2.fromOffset(Direction * SlideDistance, 0)
			NewContainer.GroupTransparency = 1
			pcall(function()
				NewTab.ContainerXMotor:setGoal(Instant(Direction * SlideDistance))
				NewTab.ContainerTransparencyMotor:setGoal(Instant(1))
			end)
			task.wait()
			pcall(function()
				OldTab.ContainerXMotor:setGoal(Spring(-Direction * SlideDistance, { frequency = 4, dampingRatio = 0.7 }))
				OldTab.ContainerTransparencyMotor:setGoal(Spring(1, { frequency = 4, dampingRatio = 0.7 }))
			end)
			pcall(function()
				NewTab.ContainerXMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
				NewTab.ContainerTransparencyMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
			end)
			TabModule.AnimationTask = task.spawn(function()
				task.wait(0.5)
				if TabModule.CurrentAnimationTab == Tab and TabModule.Tabs[PreviousTab] then
					local OldContainer = TabModule.Tabs[PreviousTab].ContainerAnim
					local OldTab = TabModule.Tabs[PreviousTab]
					if OldContainer and OldContainer.Parent then
						OldContainer.Visible = false
						OldContainer.Position = UDim2.fromOffset(0, 0)
						OldContainer.GroupTransparency = 0
					end
					if OldTab and OldTab.ContainerXMotor and OldTab.ContainerTransparencyMotor then
						pcall(function()
							OldTab.ContainerXMotor:setGoal(Instant(0))
							OldTab.ContainerTransparencyMotor:setGoal(Instant(0))
						end)
					end
					TabModule.AnimationTask = nil
				end
			end)
		else
			for idx, Container in next, TabModule.Containers do
				if Container then
					Container.Visible = (idx == Tab)
					Container.Position = UDim2.fromOffset(0, 0)
					Container.GroupTransparency = 0
					if TabModule.Tabs[idx] and TabModule.Tabs[idx].ContainerXMotor and TabModule.Tabs[idx].ContainerTransparencyMotor then
						pcall(function()
							TabModule.Tabs[idx].ContainerXMotor:setGoal(Instant(0))
							TabModule.Tabs[idx].ContainerTransparencyMotor:setGoal(Instant(0))
						end)
					end
				end
			end
		end
	end
	return TabModule
end)()
Components.Button = (function()
	local New = Creator.New
	local Spring = Flipper.Spring.new
	-- IsPrimary: ปุ่มหลัก (เช่น "ยืนยัน") ได้สีเน้น Accent แบบ flat, ปุ่มรอง (เช่น "ยกเลิก") เป็นปุ่ม ghost โปร่งใส เน้นตัวอักษรล้วนๆ
	return function(Theme, Parent, DialogCheck, IsPrimary)
		DialogCheck = DialogCheck or false
		local Button = {}

		local BaseBgTransparency     = IsPrimary and 0.85 or 1     -- secondary โปร่งใสสนิท ไม่มีกล่องให้เห็น
		local HoverOverlayRest       = 1
		local HoverOverlayHover      = IsPrimary and 0.75 or 0.9
		local BaseStrokeTransparency = 1                            -- ไม่มีเส้นขอบตอนพัก ความมินิมอลไม่พึ่งเส้นกรอบ
		local HoverStrokeTransparency = IsPrimary and 1 or 0.55      -- secondary ได้เส้นขอบบางๆ โผล่มาตอน hover เท่านั้น

		Button.Title = New("TextLabel", {
			FontFace = GetStyleProperty(IsPrimary and "FontSemiBold" or "FontMedium"),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = GetStyleProperty("TextSizeMd"),
			TextTransparency = 1, -- ซ่อนไว้ก่อน รอ PlayIn() ค่อยเฟดเข้า
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ThemeTag = {
				TextColor3 = IsPrimary and "Text" or "SubText",
			},
		})

		Button.HoverFrame = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ThemeTag = {
				BackgroundColor3 = IsPrimary and "Accent" or "Hover",
			},
		}, {
			NewCorner("ElementCorner"),
		})

		local Stroke = New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 1,
			Transparency = 1, -- ซ่อนไว้ก่อน
			ThemeTag = {
				Color = IsPrimary and "Accent" or "DialogButtonBorder",
			},
		})

		Button.Frame = New("TextButton", {
			Size = UDim2.new(0, 0, 0, 38),
			Parent = Parent,
			BackgroundTransparency = 1, -- ซ่อนไว้ก่อน รอ PlayIn() ค่อยเฟดเข้าแบบ stagger
			ThemeTag = {
				BackgroundColor3 = IsPrimary and "Accent" or "DialogButton",
			},
		}, {
			NewCorner("ElementCorner"),
			Stroke,
			Button.HoverFrame,
			Button.Title,
		})

		local BgMotor, SetBg = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency", DialogCheck, false, { frequency = 6 })
		local StrokeMotor, SetStroke = Creator.SpringMotor(1, Stroke, "Transparency", DialogCheck, false, { frequency = 6 })
		local TextMotor, SetText = Creator.SpringMotor(1, Button.Title, "TextTransparency", DialogCheck, false, { frequency = 6 })
		local HoverMotor, SetHoverOverlay = Creator.SpringMotor(1, Button.HoverFrame, "BackgroundTransparency", DialogCheck)

		-- ✨ เล่นอนิเมชั่นเฟดเข้าแบบหน่วงเวลาได้ (ไล่ทีละปุ่ม) เรียกจาก Dialog:Open()
		function Button:PlayIn(delay)
			task.delay(delay or 0, function()
				if not (Button.Frame and Button.Frame.Parent) then return end
				SetBg(BaseBgTransparency)
				SetStroke(BaseStrokeTransparency)
				SetText(0)
			end)
		end

		Creator.AddSignal(Button.Frame.MouseEnter, function()
			SetHoverOverlay(HoverOverlayHover)
			SetStroke(HoverStrokeTransparency)
		end)
		Creator.AddSignal(Button.Frame.MouseLeave, function()
			SetHoverOverlay(HoverOverlayRest)
			SetStroke(BaseStrokeTransparency)
		end)
		Creator.AddSignal(Button.Frame.MouseButton1Down, function()
			SetHoverOverlay(HoverOverlayRest)
		end)
		Creator.AddSignal(Button.Frame.MouseButton1Up, function()
			SetHoverOverlay(HoverOverlayHover)
		end)
		return Button
	end
end)()
Components.Dialog = (function()
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New = Creator.New
	local Dialog = {
		Window = nil,
	}

	function Dialog:Init(Window)
		Dialog.Window = Window
		return Dialog
	end
	function Dialog:Create()
		local NewDialog = {
			Buttons = 0,
			ButtonList = {}, -- เก็บ ref ปุ่มทั้งหมดไว้เล่นอนิเมชั่น stagger ตอนเปิด
		}

		-- ── พื้นหลังมืดครอบทั้งหน้าต่าง ──────────────────────────────────
		-- [ จุดที่แก้ ] ผู้ใช้บอกว่ามืดไป ลด opacity ลง (ตอนเปิดเดี๋ยวนี้ TintTransparency(0.85) แทน 0.75)
		-- ด้านล่าง เห็นหน้าต่างข้างหลังจางๆ ได้มากขึ้น ไม่ทึบจนบังหมด
		NewDialog.TintFrame = New("TextButton", {
			Text = "",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			Parent = Dialog.Window.Root,
		}, {
			NewCorner("ElementCorner"),
		})

		local TintMotor, TintTransparency =
			Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true, false, { frequency = 5.5 })

		-- ── แถบปุ่มด้านล่าง — โปร่งใส ซึมเข้ากับตัวการ์ดเดียวกัน ไม่มีแถบสีคั่น ──
		NewDialog.ButtonHolder = New("Frame", {
			Size = UDim2.new(1, -56, 1, -32),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})

		NewDialog.ButtonHolderFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 76),
			Position = UDim2.new(0, 0, 1, -76),
			BackgroundTransparency = 1,
		}, {
			New("Frame", {
				Size = UDim2.new(1, -56, 0, 1),
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 0.4,
				ThemeTag = {
					BackgroundColor3 = "DialogHolderLine",
				},
			}),
			NewDialog.ButtonHolder,
		})

		-- ── เส้นเน้นสี Accent บางๆ ที่ขอบบนสุด — จางที่ขอบ เข้มตรงกลาง แทนแท่งสีทึบตรงๆ
		-- [ จุดที่แก้ ] ของเดิมเป็นแท่งสีทึบเต็มแถบ ดูแข็ง/บล็อกเกินไปเมื่อเทียบกับความมินิมอลของ UI หลัก
		-- เปลี่ยนเป็นเส้น glow บางๆ ที่จางหายที่ปลายทั้งสองข้าง ให้ความรู้สึกหรูขึ้นแบบเนียนเข้ากับพื้นหลัง acrylic
		NewDialog.AccentLine = New("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 0.25,
			BorderSizePixel = 0,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		})

		-- ── ปุ่มปิด (×) มุมขวาบน — เล็ก บาง แทบไม่เด่น จนกว่าจะเอาเมาส์ไปชี้ ─────
		NewDialog.CloseX = New("TextButton", {
			Text = "×",
			FontFace = GetStyleProperty("FontMedium"),
			TextSize = GetStyleProperty("TextSizeLg"),
			_SizeKey = "TextSizeLg",
			_FontKey = "FontMedium",
			TextTransparency = 0.35,
			AutoButtonColor = false,
			Size = UDim2.fromOffset(26, 26),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -14, 0, 14),
			BackgroundTransparency = 1,
			ThemeTag = { TextColor3 = "SubText", BackgroundColor3 = "Hover" },
		}, {
			NewCorner("PillCorner"),
		})
		local CloseXMotor, SetCloseXBg =
			Creator.SpringMotor(1, NewDialog.CloseX, "BackgroundTransparency", true)
		local CloseXTextMotor, SetCloseXText =
			Creator.SpringMotor(0.35, NewDialog.CloseX, "TextTransparency", true)
		Creator.AddSignal(NewDialog.CloseX.MouseEnter, function()
			SetCloseXBg(0.9)
			SetCloseXText(0)
		end)
		Creator.AddSignal(NewDialog.CloseX.MouseLeave, function()
			SetCloseXBg(1)
			SetCloseXText(0.35)
		end)

		-- ── หัวข้อ — ตัวหนา กึ่งกลาง มีพื้นที่หายใจรอบตัวเยอะๆ ─────────────────
		-- [ จุดที่แก้ ] เอา TextColor3 ที่ hardcode สีขาวทิ้ง เพราะมี ThemeTag ควบคุมอยู่แล้ว
		-- การ hardcode ทับแบบนี้ทำให้ Title ไม่เปลี่ยนสีตามธีมเลย (บั๊ก ไม่ตรงกับที่ตั้งใจ)
		NewDialog.Title = New("TextLabel", {
			FontFace = GetStyleProperty("FontSemiBold"),
			Text = "Dialog",
			TextSize = GetStyleProperty("TextSizeTitle"),
			_SizeKey = "TextSizeTitle",
			_FontKey = "FontSemiBold",
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = true,
			Size = UDim2.new(1, -56, 0, 28),
			Position = UDim2.fromOffset(28, 40),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		NewDialog.Scale = New("UIScale", {
			Scale = 1,
		})

		-- โทนการเด้งที่นุ่มนวลขึ้น (dampingRatio ใกล้ 1 มากขึ้น) ให้ความรู้สึกสุขุม หรูหรา
		-- แทนที่จะเด้งเว่อร์แบบสนุกสนาน — เข้ากับธีม "Minimal เรียบหรู"
		local ScaleMotor, Scale =
			Creator.SpringMotor(1.04, NewDialog.Scale, "Scale", false, false, { frequency = 3.8, dampingRatio = 0.9 })

		-- [ จุดที่แก้ ] ให้ Dialog ใช้ "วัสดุ" เดียวกับพื้นหลังหน้าต่างหลักเป๊ะๆ (Acrylic.AcrylicPaint())
		-- แทนที่จะเป็นสีพื้นทึบ ("Dialog" theme color) เดี่ยวๆ เพราะงั้นก่อนหน้านี้ Dialog ถึงดูเป็น
		-- "กล่องลอยแยก" จากหน้าต่างข้างหลัง ทั้งที่ควรจะรู้สึกเหมือนเป็นชิ้นเดียวกัน — วัสดุนี้มีทั้ง noise
		-- texture, gradient, border ให้ในตัวเลย เหมือนที่ตัวหน้าต่างหลัก (Window.AcrylicPaint) ใช้อยู่แล้ว
		NewDialog.AcrylicPaint = Acrylic.AcrylicPaint()
		-- ซ่อนภาพเงานุ่ม (soft-shadow) ตอนธีม Minecraft เพราะมันมีมุมมนมาในรูปเลย ขัดกับสไตล์บล็อกเหลี่ยม
		-- (เอาแพทเทิร์นเดียวกับที่ Notification component ใช้อยู่แล้ว)
		for _, child in ipairs(NewDialog.AcrylicPaint.Frame:GetChildren()) do
			if child:IsA("ImageLabel") and child.Image == "rbxassetid://8992230677" then
				child.Visible = (Library.Theme ~= "Minecraft")
				break
			end
		end

		NewDialog.Root = New("CanvasGroup", {
			Size = UDim2.fromOffset(340, 200),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			GroupTransparency = 1,
			BackgroundTransparency = 1, -- ไม่มีสีพื้นของตัวเอง ให้ AcrylicPaint ด้านล่างเป็นพื้นหลังแทนทั้งหมด
			Parent = NewDialog.TintFrame,
		}, {
			NewDialog.AcrylicPaint.Frame,
			NewCorner("WindowCorner"),
			NewDialog.Scale,
			NewDialog.AccentLine,
			NewDialog.Title,
			NewDialog.ButtonHolderFrame,
			NewDialog.CloseX,
		})

		local RootMotor, RootTransparency =
			Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency", false, false, { frequency = 5 })
		function NewDialog:Open()
			Library.DialogOpen = true
			NewDialog.Scale.Scale = 1.04
			TintTransparency(0.85)
			RootTransparency(0)
			Scale(1)
			-- ปุ่มไล่เฟดเข้าทีละตัวเบาๆ จากซ้ายไปขวา (ช้าลง นุ่มนวลขึ้น ไม่กระตุก)
			for i, Btn in ipairs(NewDialog.ButtonList) do
				Btn:PlayIn(0.08 + (i - 1) * 0.05)
			end
		end
		function NewDialog:Close()
			Library.DialogOpen = false
			TintTransparency(1)
			RootTransparency(1)
			Scale(1.02)
			-- [ จุดที่แก้ ] เอา pcall destroy UIStroke ทิ้ง เพราะ Root ไม่มี UIStroke ลูกตรงๆ แล้ว
			-- (เส้นขอบย้ายไปอยู่ใน NewDialog.AcrylicPaint.Frame แทน ไม่ต้อง destroy อะไรตรงนี้)
			task.wait(0.15)
			NewDialog.TintFrame:Destroy()
		end
		Creator.AddSignal(NewDialog.CloseX.MouseButton1Click, function()
			pcall(function() NewDialog:Close() end)
		end)
		-- เผื่ออยากใส่สัญลักษณ์เล็กๆ นำหน้าหัวข้อ (ไม่บังคับ) — ค่าเริ่มต้นไม่มีไอคอนเลย เพื่อความมินิมอล
		function NewDialog:SetIcon(Glyph)
			if Glyph and NewDialog.Title then
				NewDialog.Title.Text = Glyph .. "  " .. NewDialog.Title.Text
			end
		end
		function NewDialog:Button(Title, Callback, IsPrimary)
			NewDialog.Buttons = NewDialog.Buttons + 1
			Title = Title or "Button"
			Callback = Callback or function() end
			local Button = Components.Button("", NewDialog.ButtonHolder, true, IsPrimary == true)
			Button.Title.Text = Title
			for _, Btn in next, NewDialog.ButtonHolder:GetChildren() do
				if Btn:IsA("TextButton") then
					Btn.Size =
						UDim2.new(1 / NewDialog.Buttons, -(((NewDialog.Buttons - 1) * 12) / NewDialog.Buttons), 0, 38)
				end
			end
			Creator.AddSignal(Button.Frame.MouseButton1Click, function()
				Library:SafeCallback(Callback)
				pcall(function()
					NewDialog:Close()
				end)
			end)
			table.insert(NewDialog.ButtonList, Button)
			return Button
		end
		return NewDialog
	end
	return Dialog
end)()
Components.Notification = (function()
	local Spring  = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New     = Creator.New
	local TypeColors = {
		info    = Color3.fromRGB(96,  205, 255),  -- ฟ้า
		success = Color3.fromRGB(80,  220, 120),  -- เขียว
		warning = Color3.fromRGB(255, 200,  60),  -- เหลือง
		error   = Color3.fromRGB(255,  80,  80),  -- แดง
		default = Color3.fromRGB(160, 120, 255),  -- ม่วง (default)
	}

	local TypeIcons = {
		info    = "ℹ️",
		success = "✅",
		warning = "⚠️",
		error   = "❌",
		default = "🔔",
	}

	local Notification = {}

	function Notification:Init(GUI)
		Library.ActiveNotifications = Library.ActiveNotifications or {}

		-- Holder อยู่มุมล่างขวา
		Notification.Holder = New("Frame", {
			Position = UDim2.new(1, -20, 1, -20),
			Size     = UDim2.new(0, 320, 1, -20),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Parent   = GUI,
		}, {
			New("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder           = Enum.SortOrder.LayoutOrder,
				VerticalAlignment   = Enum.VerticalAlignment.Bottom,
				Padding             = UDim.new(0, 10),
			}),
		})
	end
	function Notification:New(Config)
		Config.Title      = Config.Title      or "Notification"
		Config.Content    = Config.Content    or ""
		Config.SubContent = Config.SubContent or ""
		Config.Duration   = Config.Duration   or nil
		-- Type: "info" | "success" | "warning" | "error" | "default"
		Config.Type       = Config.Type       or "default"
		local accentColor = TypeColors[Config.Type]
		if not accentColor then
			-- ไม่ใช่ type สี fixed (info/success/warning/error) → ใช้สี Accent ของธีมปัจจุบันแทน
			accentColor = Creator.GetThemeProperty("Accent") or TypeColors.default
		end
		local iconText    = Config.Icon or TypeIcons[Config.Type] or TypeIcons.default
		local NewNotification = { Closed = false }

		NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()

		-- 🖼️ AcrylicPaint มี ImageLabel เงา/glow แบบ soft-shadow (มุมมนมาในรูปเลย ไม่ใช่ UICorner)
		-- อยู่เบื้องหลัง panel เสมอ ต้องซ่อนตอนธีม Minecraft ไม่งั้นต่อให้มุม UICorner = 0 ก็จะยังดูมนอยู่ดี
		for _, child in ipairs(NewNotification.AcrylicPaint.Frame:GetChildren()) do
			if child:IsA("ImageLabel") and child.Image == "rbxassetid://8992230677" then
				NewNotification.MCShadowGlow = child
				break
			end
		end
		local TypeBar = New("Frame", {
			Size             = UDim2.new(0, 3, 1, -16),
			Position         = UDim2.new(0, 8, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundColor3 = accentColor,
			BorderSizePixel  = 0,
		}, {
			NewCorner("PillCorner"),
		})

		-- 🌑 Plaque มืดโปร่งแสงระหว่างเท็กซ์เจอร์กับตัวหนังสือ (สไตล์กล่อง GUI ของ Minecraft) กันตัวหนังสืออ่านยาก
		NewNotification.MCTextPlaqueCorner = NewCorner("WindowCorner")
		NewNotification.MCTextPlaque = New("Frame", {
			Size                    = UDim2.new(1, 0, 1, 0),
			BackgroundColor3        = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency  = 0.42,
			BorderSizePixel         = 0,
			Visible                 = (Library.Theme == "Minecraft"),
			_NoStyleRegister        = true,
		}, {
			NewNotification.MCTextPlaqueCorner,
		})

		local IconLabel = New("TextLabel", {
			Text             = iconText,
			FontFace         = GetStyleProperty("FontMedium"),
			TextSize = GetStyleProperty("TextSizeIcon"),
			Size             = UDim2.fromOffset(28, 28),
			Position         = UDim2.new(0, 18, 0, 10),
			BackgroundTransparency = 1,
			TextXAlignment   = Enum.TextXAlignment.Center,
			TextYAlignment   = Enum.TextYAlignment.Center,
			RichText         = false,
			_SizeKey         = "TextSizeIcon",
			_FontKey         = "FontMedium",
		})

		NewNotification.Title = New("TextLabel", {
			Position         = UDim2.new(0, 52, 0, 10),
			Text             = Config.Title,
			RichText         = true,
			TextSize = GetStyleProperty("TextSizeMd"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			TextYAlignment   = Enum.TextYAlignment.Center,
			Size             = UDim2.new(1, -80, 0, 16),
			TextWrapped      = true,
			BackgroundTransparency = 1,
			FontFace         = GetStyleProperty("FontBold"),
			TextColor3       = accentColor,
			_SizeKey         = "TextSizeMd",
			_FontKey         = "FontBold",
		})

		NewNotification.ContentLabel = New("TextLabel", {
			FontFace         = GetStyleProperty("FontMedium"),
			Text             = Config.Content,
			TextSize = GetStyleProperty("TextSizeSm"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			AutomaticSize    = Enum.AutomaticSize.Y,
			Size             = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextWrapped      = true,
			ThemeTag         = { TextColor3 = "Text" },
			_SizeKey         = "TextSizeSm",
			_FontKey         = "FontMedium",
		})

		NewNotification.SubContentLabel = New("TextLabel", {
			FontFace         = GetStyleProperty("FontMedium"),
			Text             = Config.SubContent,
			TextSize = GetStyleProperty("TextSizeXs"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			AutomaticSize    = Enum.AutomaticSize.Y,
			Size             = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextWrapped      = true,
			ThemeTag         = { TextColor3 = "SubText" },
			_SizeKey         = "TextSizeXs",
			_FontKey         = "FontMedium",
		})

		NewNotification.LabelHolder = New("Frame", {
			AutomaticSize    = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position         = UDim2.new(0, 52, 0, 30),
			Size             = UDim2.new(1, -68, 0, 0),
		}, {
			New("UIListLayout", {
				SortOrder         = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding           = UDim.new(0, 2),
			}),
			NewNotification.ContentLabel,
			NewNotification.SubContentLabel,
		})

		NewNotification.CloseButton = New("TextButton", {
			Text             = "",
			Position         = UDim2.new(1, -10, 0, 10),
			Size             = UDim2.fromOffset(18, 18),
			AnchorPoint      = Vector2.new(1, 0),
			BackgroundTransparency = 0.75,
			BackgroundColor3 = Color3.fromRGB(60, 55, 80),
			BorderSizePixel  = 0,
		}, {
			NewCorner("PillCorner"),
			New("ImageLabel", {
				Image       = "rbxassetid://9886659671",
				Size        = UDim2.fromOffset(10, 10),
				Position    = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(200, 190, 220),
			}),
		})

		local ProgressTrack = New("Frame", {
			Size             = UDim2.new(1, -16, 0, 2),
			Position         = UDim2.new(0, 8, 1, -6),
			BackgroundTransparency = 0.7,
			BorderSizePixel  = 0,
			ThemeTag         = { BackgroundColor3 = "Element" },
		}, {
			NewCorner("PillCorner"),
		})

		local ProgressFill = New("Frame", {
			Size             = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = accentColor,
			BorderSizePixel  = 0,
			Parent           = ProgressTrack,
		}, {
			NewCorner("PillCorner"),
		})

		-- 🧱 Minecraft texture — เท็กซ์เจอร์ dirt/stone ตัวเดียวกับพื้นหลังวินโดว์ ปูซ้ำ (tile) ให้ดูเป็นพิกเซล
		-- แสดงเฉพาะตอนธีมปัจจุบันเป็น Minecraft เท่านั้น ส่วนตอนสลับธีมจะถูกอัปเดตใน Library:SetTheme
		NewNotification.MCTextureCorner = NewCorner("WindowCorner")
		NewNotification.MCTexture = New("ImageLabel", {
			Image                  = "rbxassetid://127892835920326",
			ScaleType               = Enum.ScaleType.Tile,
			TileSize                = UDim2.new(0, 48, 1, 0), -- ปูซ้ำแค่แนวนอน แนวตั้งยืดเต็มพอดี 1 ชุด กันหญ้า/ดินซ้อนกันหลายแถบ
			Size                    = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency  = 1,
			ImageTransparency       = 0.12,
			ClipsDescendants        = true,
			Visible                 = (Library.Theme == "Minecraft"),
			_NoStyleRegister        = true,
		}, {
			NewNotification.MCTextureCorner,
		})

		-- 🖼️ Pixel bevel — กรอบเหลี่ยมชั้นในสีอ่อน ให้ดูเป็นแผงกระดาน Minecraft (นอกดำ/ในสว่าง)
		NewNotification.MCBevelStroke = New("UIStroke", {
			ApplyStrokeMode  = Enum.ApplyStrokeMode.Border,
			Color            = Color3.fromRGB(255, 255, 255),
			Transparency     = 0.78,
			Thickness        = 1,
			LineJoinMode     = Enum.LineJoinMode.Miter,
			_NoStyleRegister = true,
		})
		NewNotification.MCBevel = New("Frame", {
			Size                    = UDim2.new(1, -6, 1, -6),
			Position                = UDim2.fromOffset(3, 3),
			BackgroundTransparency  = 1,
			BorderSizePixel         = 0,
			Visible                 = (Library.Theme == "Minecraft"),
			_NoStyleRegister        = true,
		}, {
			NewNotification.MCBevelStroke,
		})

		NewNotification.BackgroundCorner = NewCorner("WindowCorner")
		local BackgroundFrame = New("Frame", {
			Size             = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 0.90,
			BorderSizePixel  = 0,
			ThemeTag         = { BackgroundColor3 = "AcrylicMain" },
		}, {
			NewNotification.BackgroundCorner,
		})

		NewNotification.RootStroke = New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = accentColor, Thickness = GetStyleProperty("BorderThickness"), LineJoinMode = Enum.LineJoinMode.Round })

		NewNotification.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, 0, 1, 0),
			Position         = UDim2.fromScale(1, 0),
		}, {
			NewNotification.AcrylicPaint.Frame,
			BackgroundFrame,
			NewNotification.MCTexture,
			-- Border
			NewNotification.RootStroke,
			NewNotification.MCBevel,
			NewNotification.MCTextPlaque,
			TypeBar,
			IconLabel,
			NewNotification.Title,
			NewNotification.CloseButton,
			NewNotification.LabelHolder,
			ProgressTrack,
		})

		-- เก็บ ref ตัวหนังสือทั้งหมดไว้ให้ RefreshStyle บังคับ sync ฟอนต์/ขนาดตรงๆ ไม่พึ่ง timing ของ StyleRegistry
		NewNotification.TextRefs = {
			{ obj = IconLabel,                          sizeKey = "TextSizeIcon", fontKey = "FontMedium" },
			{ obj = NewNotification.Title,               sizeKey = "TextSizeMd",   fontKey = "FontBold"   },
			{ obj = NewNotification.ContentLabel,        sizeKey = "TextSizeSm",   fontKey = "FontMedium" },
			{ obj = NewNotification.SubContentLabel,     sizeKey = "TextSizeXs",   fontKey = "FontMedium" },
		}

		-- 🔄 บังคับ sync เท็กซ์เจอร์ / มุมเหลี่ยม / ฟอนต์ / เงา ให้ตรงธีมปัจจุบันเสมอ ไม่ว่าจะเรียกตอนไหนก็ตาม
		function NewNotification:RefreshStyle()
			local isMinecraft = (Library.Theme == "Minecraft")
			if NewNotification.MCTexture then NewNotification.MCTexture.Visible = isMinecraft end
			if NewNotification.MCBevel then NewNotification.MCBevel.Visible = isMinecraft end
			if NewNotification.MCTextPlaque then NewNotification.MCTextPlaque.Visible = isMinecraft end
			if NewNotification.MCShadowGlow then NewNotification.MCShadowGlow.Visible = not isMinecraft end
			if NewNotification.BackgroundCorner then
				NewNotification.BackgroundCorner.CornerRadius = GetStyleProperty("WindowCorner")
			end
			if NewNotification.MCTextureCorner then
				NewNotification.MCTextureCorner.CornerRadius = GetStyleProperty("WindowCorner")
			end
			if NewNotification.MCTextPlaqueCorner then
				NewNotification.MCTextPlaqueCorner.CornerRadius = GetStyleProperty("WindowCorner")
			end
			if NewNotification.RootStroke then
				NewNotification.RootStroke.Thickness = GetStyleProperty("BorderThickness")
				-- UIStroke ปัดมุมกลมของตัวเองเสมอ (ไม่สนใจ UICorner) ต้องบังคับ Miter ตอนธีมเหลี่ยม
				NewNotification.RootStroke.LineJoinMode = isMinecraft and Enum.LineJoinMode.Miter or Enum.LineJoinMode.Round
			end
			if NewNotification.MCBevelStroke then
				NewNotification.MCBevelStroke.LineJoinMode = Enum.LineJoinMode.Miter
			end
			for _, entry in ipairs(NewNotification.TextRefs) do
				if entry.obj then
					entry.obj.TextSize = GetStyleProperty(entry.sizeKey)
					entry.obj.FontFace = GetStyleProperty(entry.fontKey)
				end
			end
		end
		NewNotification:RefreshStyle()

		-- ซ่อนถ้าไม่มีข้อความ
		if Config.Content    == "" then NewNotification.ContentLabel.Visible    = false end
		if Config.SubContent == "" then NewNotification.SubContentLabel.Visible = false end
		NewNotification.Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, 0, 0, 200),
			Parent           = Notification.Holder,
		}, {
			NewNotification.Root,
		})

		local RootMotor = Flipper.GroupMotor.new({ Scale = 1, Offset = 70 })
		RootMotor:onStep(function(v)
			NewNotification.Root.Position = UDim2.new(v.Scale, v.Offset, 0, 0)
		end)
		Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
			NewNotification:Close()
		end)
		function NewNotification:ApplyTransparency()
			if Library.Theme == "Glass" and Library.UseAcrylic then
				local Value = Library.NotificationTransparency or 1
				local t = math.min(0.85 + Value * 0.08, 0.97)
				local bt = math.min(0.8 + Value * 0.1, 0.95)
				if NewNotification.AcrylicPaint and NewNotification.AcrylicPaint.Model then
					NewNotification.AcrylicPaint.Model.Transparency = t
				end
				if NewNotification.AcrylicPaint and NewNotification.AcrylicPaint.Frame
					and NewNotification.AcrylicPaint.Frame.Background then
					NewNotification.AcrylicPaint.Frame.Background.BackgroundTransparency = bt
				end
			end
		end
		function NewNotification:Open()
			NewNotification:RefreshStyle()
			local contentH = NewNotification.LabelHolder.AbsoluteSize.Y
			local totalH   = math.max(56, 36 + contentH + 14) + 10
			NewNotification.Holder.Size = UDim2.new(1, 0, 0, totalH)
			RootMotor:setGoal({
				Scale  = Spring(0, { frequency = 6 }),
				Offset = Spring(0, { frequency = 6 }),
			})

			task.defer(function()
				task.wait(0.08)
				NewNotification:ApplyTransparency()
			end)

			-- Progress bar animation
			if Config.Duration and Config.Duration > 0 then
				local steps    = Config.Duration * 20
				local stepSize = 1 / steps
				task.spawn(function()
					for i = 1, steps do
						if NewNotification.Closed then break end
						local pct = 1 - (i * stepSize)
						TweenService:Create(ProgressFill,
							TweenInfo.new(1 / 20, Enum.EasingStyle.Linear),
							{ Size = UDim2.new(pct, 0, 1, 0) }
						):Play()
						task.wait(1 / 20)
					end
				end)
			else
				ProgressTrack.Visible = false
			end
		end
		function NewNotification:Close()
			if not NewNotification.Closed then
				NewNotification.Closed = true
				for i, notif in pairs(Library.ActiveNotifications or {}) do
					if notif == NewNotification then
						table.remove(Library.ActiveNotifications, i)
						break
					end
				end
				task.spawn(function()
					RootMotor:setGoal({
						Scale  = Spring(1, { frequency = 6 }),
						Offset = Spring(70, { frequency = 6 }),
					})
					task.wait(0.35)
					if Library.UseAcrylic and NewNotification.AcrylicPaint
						and NewNotification.AcrylicPaint.Model then
						NewNotification.AcrylicPaint.Model:Destroy()
					end
					NewNotification.Holder:Destroy()
				end)
			end
		end
		table.insert(Library.ActiveNotifications, NewNotification)
		NewNotification:Open()
		if Config.Duration then
			task.delay(Config.Duration, function()
				NewNotification:Close()
			end)
		end
		return NewNotification
	end
	return Notification
end)()
Components.Textbox = (function()
	local New = Creator.New
	return function(Parent, Acrylic)
		Acrylic = Acrylic or false
		local Textbox = {}

		-- [ จุดที่แก้ ] เอา TextColor3/BackgroundColor3 hardcode ทิ้ง (บั๊กเดียวกับที่เจอในหลายจุด:
		-- ทับ ThemeTag จนตัวหนังสือไม่เปลี่ยนสีตามธีมเลย)
		Textbox.Input = New("TextBox", {
			FontFace = GetStyleProperty("FontRegular"),
			TextSize = GetStyleProperty("TextSizeMd"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromOffset(10, 0),
			ThemeTag = {
				TextColor3 = "Text",
				PlaceholderColor3 = "SubText",
			},
		})

		Textbox.Container = New("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -12, 1, 0),
		}, {
			Textbox.Input,
		})

		Textbox.Indicator = New("Frame", {
			Size = UDim2.new(1, -4, 0, 1),
			Position = UDim2.new(0, 2, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = Acrylic and 0.5 or 0,
			ThemeTag = {
				BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine",
			},
		})

		Textbox.Stroke = New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = Acrylic and 0.45 or 0.55,
			ThemeTag = {
				Color = Acrylic and "InElementBorder" or "DialogButtonBorder",
			},
		})

		Textbox.Frame = New("Frame", {
			Size = UDim2.new(0, 0, 0, 32),
			BackgroundTransparency = Acrylic and 0.88 or 0,
			Parent = Parent,
			ThemeTag = {
				BackgroundColor3 = Acrylic and "Input" or "DialogInput",
			},
		}, {
			NewCorner("ElementCorner"),
			Textbox.Stroke,
			Textbox.Indicator,
			Textbox.Container,
		})

		-- [ จุดที่เพิ่ม ] สปริงคุม stroke ให้ตอน focus กรอบสว่างขึ้นแบบนุ่มนวล (focus ring)
		-- เดิมโฟกัสแล้วมีแค่เส้น indicator ล่างขยับ ไม่มีอะไรบอกว่า "กำลังพิมพ์อยู่" ที่ตัวกรอบเลย
		local BaseStrokeTransparency = Acrylic and 0.45 or 0.55
		local _, SetStrokeTransparency = Creator.SpringMotor(BaseStrokeTransparency, Textbox.Stroke, "Transparency", true, false, { frequency = 8 })
		local _, SetIndicatorAlpha = Creator.SpringMotor(Acrylic and 0.5 or 0, Textbox.Indicator, "BackgroundTransparency", true, false, { frequency = 8 })
		-- [ จุดที่เพิ่ม ] เปิดให้โค้ดข้างนอก (เช่น validation flash ใน Input element) เรียกคืนค่า stroke ได้
		Textbox.SetStrokeTransparency = SetStrokeTransparency
		Textbox.BaseStrokeTransparency = BaseStrokeTransparency

		local function Update()
			local PADDING = 2
			local Reveal = Textbox.Container.AbsoluteSize.X
			if not Textbox.Input:IsFocused() or Textbox.Input.TextBounds.X <= Reveal - 2 * PADDING then
				Textbox.Input.Position = UDim2.new(0, PADDING, 0, 0)
			else
				local Cursor = Textbox.Input.CursorPosition
				if Cursor ~= -1 then
					local subtext = string.sub(Textbox.Input.Text, 1, Cursor - 1)
					local width = TextService:GetTextSize(
						subtext,
						Textbox.Input.TextSize,
						Textbox.Input.Font,
						Vector2.new(math.huge, math.huge)
					).X
					local CurrentCursorPos = Textbox.Input.Position.X.Offset + width
					if CurrentCursorPos < PADDING then
						Textbox.Input.Position = UDim2.fromOffset(PADDING - width, 0)
					elseif CurrentCursorPos > Reveal - PADDING - 1 then
						Textbox.Input.Position = UDim2.fromOffset(Reveal - width - PADDING - 1, 0)
					end
				end
			end
		end
		task.spawn(Update)
		Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Update)
		Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), Update)
		Creator.AddSignal(Textbox.Input.Focused, function()
			Update()
			-- [ จุดที่แก้ ] เปลี่ยนจากสแนปทันทีเป็น tween สั้นๆ ให้เส้นใต้ "โต" ขึ้นมาอย่างนุ่มนวล แทนการกระโดดสั่นๆ
			TweenService:Create(Textbox.Indicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -2, 0, 2),
				Position = UDim2.new(0, 1, 1, 0),
			}):Play()
			SetIndicatorAlpha(0)
			SetStrokeTransparency(0.1)
			Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "InputFocused" or "DialogHolder" })
			Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = "InputIndicatorFocus" })
			Creator.OverrideTag(Textbox.Stroke, { Color = "InputIndicatorFocus" })
		end)
		Creator.AddSignal(Textbox.Input.FocusLost, function()
			Update()
			TweenService:Create(Textbox.Indicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -4, 0, 1),
				Position = UDim2.new(0, 2, 1, 0),
			}):Play()
			SetIndicatorAlpha(Acrylic and 0.5 or 0)
			SetStrokeTransparency(BaseStrokeTransparency)
			Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "Input" or "DialogInput" })
			Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine" })
			Creator.OverrideTag(Textbox.Stroke, { Color = Acrylic and "InElementBorder" or "DialogButtonBorder" })
		end)
		return Textbox
	end
end)()
Components.TitleBar = (function()
	local New = Creator.New
	local AddSignal = Creator.AddSignal
	return function(Config)
		local TitleBar = {}

		-- Window control button (Min/Max/Close)
		local function BarButton(Icon, Pos, Parent, Callback)
			local Button = {
				Callback = Callback or function() end,
			}

			Button.Frame = New("TextButton", {
				Size = UDim2.new(0, 32, 0, 32),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 0.96,
				Parent = Parent,
				Position = Pos,
				Text = "",
				ThemeTag = {
					BackgroundColor3 = "Hover",
				},
			}, {
				NewCorner("ElementCorner"),
				New("ImageLabel", {
					Image = Icon,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Name = "Icon",
					ThemeTag = {
						ImageColor3 = "SubText",
					},
				}),
			})

			local Motor, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")
			AddSignal(Button.Frame.MouseEnter, function()
				SetTransparency(0.88)
			end)
			AddSignal(Button.Frame.MouseLeave, function()
				SetTransparency(1, true)
			end)
			AddSignal(Button.Frame.MouseButton1Down, function()
				SetTransparency(0.80)
			end)
			AddSignal(Button.Frame.MouseButton1Up, function()
				SetTransparency(0.88)
			end)
			AddSignal(Button.Frame.MouseButton1Click, Button.Callback)
			Button.SetCallback = function(Func)
				Button.Callback = Func
			end
			return Button
		end

		-- MAIN TITLEBAR FRAME — height 52px for a premium feel
		TitleBar.Frame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 52),
			BackgroundTransparency = 1,
			Active = true, -- ✅ กัน bug เดียวกับ resize handle: Frame โปร่งใสไม่รับ input ถ้าไม่เปิด Active
			Parent = Config.Parent,
		}, {
			New("Frame", {
				Name = "LeftSection",
				Size = UDim2.new(1, -160, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 10),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 14),
				}),

				-- Logo image (ไม่มีเส้นขอบ, ขอบโค้งนิดเดียว)
				Config.Icon and New("Frame", {
					Name = "LogoFrame",
					Size = UDim2.fromOffset(30, 30),
					BackgroundTransparency = 1, -- 👻 ปรับเป็น 1 ให้พื้นหลังใสสนิท จะได้ไม่มีสี่เหลี่ยมทึบๆ มากวนใจ
					LayoutOrder = 1,
					ThemeTag = {
						BackgroundColor3 = "Accent",
					},
				}, {
					NewCorner("TinyCorner"), -- 📉 ปรับความโค้งจาก 8 เหลือ 4 (โค้งแค่มุมนิดๆ)

					-- ❌ ลบคำสั่ง New("UIStroke") ทิ้งไปเลย เพื่อลบเส้นขอบออก 100%

					New("ImageLabel", {
						Image = (Config.Icon == true) and Library.BrandLogo or Config.Icon,
						Size = UDim2.fromOffset(35, 35), -- 🖼️ ขยายโลโก้ให้ใหญ่ขึ้นอีกนิด (เป็น 26) เพราะไม่มีกรอบแล้ว
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ThemeTag = { ImageColor3 = "Text" },
					}, {
						-- เผื่อรูปโลโก้ของคุณเป็นสี่เหลี่ยมจัตุรัสเป๊ะๆ เลยแถม UICorner ให้รูปมันโค้งตามเฟรมด้วย
						NewCorner("TinyCorner")
					}),
				}) or nil,

				-- Text stack: Title above SubTitle
				New("Frame", {
					Name = "TextStack",
					Size = UDim2.fromScale(0, 1),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					LayoutOrder = Config.Icon and 2 or 1,
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, 1),
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					-- Title (bold, larger)
					New("TextLabel", {
						RichText = true,
						Text = Config.Title,
						FontFace = GetStyleProperty("FontBold"),
						TextSize = GetStyleProperty("TextSizeMd"),
						TextXAlignment = "Left",
						TextYAlignment = "Center",
						Size = UDim2.fromScale(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						ThemeTag = { TextColor3 = "Text" },
					}),

					-- SubTitle row: SubTitle (dim) ต่อด้วย Discord label (สีฟ้า) + ไอคอน copy ถ้ามี Config.Discord
					-- [ จุดที่เพิ่ม ] แยกเป็น Frame แนวนอนแทนที่จะเป็น TextLabel เดี่ยวๆ เพราะต้องแปะ
					-- ปุ่มกด copy (ImageButton) ต่อท้ายได้ ซึ่งทำไม่ได้ถ้ายังเป็น RichText ข้อความเดียว
					(Config.SubTitle or Config.Discord) and New("Frame", {
						Name = "SubTitleRow",
						Size = UDim2.fromScale(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
					}, {
						New("UIListLayout", {
							Padding = UDim.new(0, 6),
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Center,
						}),

						-- SubTitle (smaller, dimmer) — เหมือนเดิมทุกอย่าง แค่ย้ายมาอยู่ในแถวนี้
						Config.SubTitle and New("TextLabel", {
							Name = "SubTitleText",
							RichText = true,
							Text = Config.SubTitle,
							TextTransparency = 0.45,
							FontFace = GetStyleProperty("FontRegular"),
							TextSize = GetStyleProperty("TextSizeXs"),
							TextXAlignment = "Left",
							TextYAlignment = "Center",
							Size = UDim2.fromScale(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							ThemeTag = { TextColor3 = "Text" },
						}) or nil,

						-- [ จุดที่เพิ่ม ] เส้นคั่นบางๆ ระหว่าง SubTitle กับ Discord link (โชว์เฉพาะตอนมีทั้งคู่)
						(Config.SubTitle and Config.Discord) and New("TextLabel", {
							Name = "SubTitleDivider",
							Text = "|",
							TextTransparency = 0.65,
							FontFace = GetStyleProperty("FontRegular"),
							TextSize = GetStyleProperty("TextSizeXs"),
							Size = UDim2.fromScale(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							ThemeTag = { TextColor3 = "SubText" },
						}) or nil,

						-- [ จุดที่แก้ ] โชว์ตัวลิงก์จริงตรงๆ (Config.Discord) แทนคำว่า "ลิ้งดิส" ตายตัว
						-- ยังเปิดให้ override ข้อความที่โชว์ได้ผ่าน Config.DiscordLabel ถ้าอยากได้ label สั้นๆ แทน
						Config.Discord and New("TextButton", {
							Name = "DiscordLabel",
							Text = Config.DiscordLabel or Config.Discord,
							AutoButtonColor = false,
							FontFace = GetStyleProperty("FontRegular"),
							TextSize = GetStyleProperty("TextSizeXs"),
							TextXAlignment = "Left",
							TextYAlignment = "Center",
							TextColor3 = Color3.fromRGB(88, 160, 255), -- สีฟ้า fix ตายตัว ไม่ผูก Theme เพราะอยากให้ดูเป็นลิงก์เสมอทุกธีม
							Size = UDim2.fromScale(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							LayoutOrder = 3,
						}) or nil,

						-- [ จุดที่แก้ ] บั๊ก: Library:GetIcon ต่อ "lucide-" นำหน้าให้เองอยู่แล้ว
						-- เมื่อก่อนส่ง "lucide-copy" เข้าไปเลยกลายเป็นหา "lucide-lucide-copy" ซึ่งไม่มีจริง ไอคอนเลยไม่ขึ้น
						Config.Discord and New("ImageButton", {
							Name = "DiscordCopyIcon",
							Image = Library:GetIcon("copy"),
							Size = UDim2.fromOffset(12, 12),
							BackgroundTransparency = 1,
							LayoutOrder = 4,
							ImageColor3 = Color3.fromRGB(88, 160, 255),
						}) or nil,
					}) or nil,
				}),
			}),

			New("Frame", {
				Name = "RightSection",
				Size = UDim2.new(0, 154, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -6, 0, 0),
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 4),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
				}),
			}),

			-- Bottom separator line
			New("Frame", {
				BackgroundTransparency = 0.55,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, -1),
				ThemeTag = { BackgroundColor3 = "TitleBarLine" },
			}),
		})

		-- Anchor helpers for BarButtons inside RightSection using UIListLayout
		local function RightBarButton(Icon, Parent, Callback)
			local Button = { Callback = Callback or function() end }
			Button.Frame = New("TextButton", {
				Size = UDim2.new(0, 32, 0, 32),
				BackgroundTransparency = 1,
				Parent = Parent,
				Text = "",
				ThemeTag = { BackgroundColor3 = "Hover" },
			}, {
				NewCorner("ElementCorner"),
				New("ImageLabel", {
					Image = Icon,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Name = "Icon",
					ThemeTag = { ImageColor3 = "SubText" },
				}),
			})
			local Motor, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")
			AddSignal(Button.Frame.MouseEnter, function() SetTransparency(0.88) end)
			AddSignal(Button.Frame.MouseLeave, function() SetTransparency(1, true) end)
			AddSignal(Button.Frame.MouseButton1Down, function() SetTransparency(0.80) end)
			AddSignal(Button.Frame.MouseButton1Up, function() SetTransparency(0.88) end)
			AddSignal(Button.Frame.MouseButton1Click, Button.Callback)
			Button.SetCallback = function(Func) Button.Callback = Func end
			return Button
		end
		local rightSection = TitleBar.Frame:FindFirstChild("RightSection")

		-- [ จุดที่เพิ่ม ] ผูก event copy ให้ Discord label + ไอคอน หลังจากสร้าง TitleBar เสร็จแล้ว
		-- (ต้องรอสร้างเสร็จก่อนค่อย FindFirstChild เพราะตอน New(...) ยังไม่มี Instance ให้จับ)
		if Config.Discord then
			local leftSection = TitleBar.Frame:FindFirstChild("LeftSection")
			local textStack   = leftSection and leftSection:FindFirstChild("TextStack")
			local subRow      = textStack and textStack:FindFirstChild("SubTitleRow")
			local discordLabel = subRow and subRow:FindFirstChild("DiscordLabel")
			local discordIcon  = subRow and subRow:FindFirstChild("DiscordCopyIcon")

			local function CopyDiscordLink()
				pcall(function()
					if setclipboard then    setclipboard(Config.Discord)
					elseif toclipboard then toclipboard(Config.Discord) end
				end)
				-- feedback: ไอคอนสลับเป็นเครื่องหมายถูกชั่วคราวแล้วค่อยกลับมาเป็นไอคอน copy
				-- [ จุดที่แก้ ] ตัด "lucide-" นำหน้าออก เพราะ GetIcon ต่อให้เองอยู่แล้ว (บั๊กเดียวกับตอนสร้างไอคอน)
				if discordIcon then
					discordIcon.Image = Library:GetIcon("clipboard-check")
					task.delay(1.2, function()
						if discordIcon and discordIcon.Parent then
							discordIcon.Image = Library:GetIcon("copy")
						end
					end)
				end
				-- [ จุดที่เพิ่ม ] แจ้งเตือนแบบ toast มุมจอด้วย ไม่ใช่แค่ไอคอนสลับเฉยๆ
				Library:Notify({
					Title = "Discord",
					Content = "Copied the Discord link to your clipboard.",
					Duration = 3,
				})
			end
			if discordLabel then AddSignal(discordLabel.MouseButton1Click, CopyDiscordLink) end
			if discordIcon  then AddSignal(discordIcon.MouseButton1Click,  CopyDiscordLink) end
		end

		TitleBar.MinButton = RightBarButton(Components.Assets.Min, rightSection, function()
			Library.Window:Minimize()
		end)
		TitleBar.MaxButton = RightBarButton(Components.Assets.Max, rightSection, function()
			Config.Window.Maximize(not Config.Window.Maximized)
		end)
		TitleBar.CloseButton = RightBarButton(Components.Assets.Close, rightSection, function()
			Library.Window:Dialog({
				Title = "Close",
				Content = "Are you sure you want to unload the interface?",
				Buttons = {
					{ Title = "Yes", Callback = function() Library:Destroy() end },
					{ Title = "No" },
				},
			})
		end)
		return TitleBar
	end
end)()
