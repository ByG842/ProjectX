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
