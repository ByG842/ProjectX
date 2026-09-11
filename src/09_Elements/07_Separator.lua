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
