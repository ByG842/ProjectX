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
