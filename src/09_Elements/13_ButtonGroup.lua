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
