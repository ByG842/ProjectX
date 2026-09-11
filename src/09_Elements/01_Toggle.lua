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
			local ti = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out) -- 🎬 micro-animation: springy overshoot แทน easing เรียบๆ เดิม
			-- knob เลื่อน (มี overshoot นิดๆ ให้ฟีลนุ่ม)
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

			-- 🎬 track pulse เบาๆ (ขยายแล้วหดกลับ) ให้รู้สึกมี tactile feedback ตอนกด
			local PulseScale = ToggleTrack:FindFirstChildOfClass("UIScale")
			if not PulseScale then
				PulseScale = New("UIScale", { Scale = 1 })
				PulseScale.Parent = ToggleTrack
			end
			PulseScale.Scale = 0.9
			TweenService:Create(PulseScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
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
