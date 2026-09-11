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
			Size = UDim2.fromOffset(12, 12),
			ThemeTag = { BackgroundColor3 = "Element" },
		}, {
			NewCorner("PillCorner"),
			New("UIAspectRatioConstraint", { AspectRatio = 1 }),
			New("UIStroke", {
				Thickness = 1.75,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = { Color = "Accent" },
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
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		}, {
			NewCorner("PillCorner"),
			New("UIGradient", {
				ThemeTag = { Color = "AccentGradient" },
			}),
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
			Position = UDim2.new(1, 0, 0, -10),
			AnchorPoint = Vector2.new(1, 1),
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
			Position = UDim2.new(1, 0, 0, -10),
			AnchorPoint = Vector2.new(1, 1),
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
			Size = UDim2.new(1, 0, 0, 6),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 10),
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
			SliderDot.Position = UDim2.new((self.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 0.5, 0)
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
