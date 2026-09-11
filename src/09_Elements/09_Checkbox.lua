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
			local popTi = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out) -- 🎬 micro-animation: pop เด้งนิดๆ ตอนติ๊กถูก
			TweenService:Create(CheckBg, ti, {
				BackgroundTransparency = val and 0.05 or 0.88,
			}):Play()
			TweenService:Create(CheckMark, popTi, {
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
