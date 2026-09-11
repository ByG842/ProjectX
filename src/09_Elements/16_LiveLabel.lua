ElementsTable.LiveLabel = (function()
	local Element = {}
	Element.__index = Element
	Element.__type  = "LiveLabel"
	Element.NoIdx   = false
	local TypeColors = {
		default = Color3.fromRGB(165, 168, 185),
		info    = Color3.fromRGB(96,  200, 255),
		success = Color3.fromRGB(80,  215, 130),
		warning = Color3.fromRGB(255, 195,  60),
		error   = Color3.fromRGB(255,  80,  80),
	}

	local TypeBg = {
		default = Color3.fromRGB(80,  82,  95),
		info    = Color3.fromRGB(20,  70,  110),
		success = Color3.fromRGB(15,  75,  45),
		warning = Color3.fromRGB(90,  65,  10),
		error   = Color3.fromRGB(90,  20,  20),
	}

	function Element:New(Idx, Config)
		Config      = Config or {}
		Config.Text = Config.Text or ""
		Config.Type = Config.Type or "default"
		local New = Creator.New
		local LL = {
			Value = Config.Text,
			Type  = "LiveLabel",
			_type = Config.Type,
		}

		local LLFrame = Components.Element(Config.Title or "", Config.Description, self.Container, false, Config)
		LL.SetTitle = LLFrame.SetTitle
		LL.SetDesc  = LLFrame.SetDesc
		LL.Visible  = LLFrame.Visible
		LL.Elements = LLFrame

		-- ── Pill วางชิดขวา AutomaticSize X ──────────────────────
		-- ความกว้าง max ครึ่งหนึ่งของ frame เพื่อไม่ทับ title
		local Pill = New("Frame", {
			AutomaticSize          = Enum.AutomaticSize.XY,
			AnchorPoint            = Vector2.new(1, 0.5),
			Position               = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 0.72,
			BackgroundColor3       = TypeBg[Config.Type] or TypeBg.default,
			Parent                 = LLFrame.Frame,
		}, {
			NewCorner("SmallCorner"),
			New("UIStroke", { Transparency = 0.55, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = TypeColors[Config.Type] or TypeColors.default, Thickness = GetStyleProperty("BorderThickness") }),
			New("UIPadding", {
				PaddingLeft   = UDim.new(0, 7),
				PaddingRight  = UDim.new(0, 7),
				PaddingTop    = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
			}),
			-- จำกัดความกว้างสูงสุดไม่ให้ทับ title
			New("UISizeConstraint", {
				MaxSize = Vector2.new(200, math.huge),
			}),
		})

		-- ── Text ข้างใน Pill ─────────────────────────────────────
		local ValueLabel = New("TextLabel", {
			FontFace               = GetStyleProperty("FontMedium"),
			Text                   = Config.Text,
			TextColor3             = TypeColors[Config.Type] or TypeColors.default,
			TextSize = GetStyleProperty("TextSizeSm"),
			TextXAlignment         = Enum.TextXAlignment.Right,
			TextYAlignment         = Enum.TextYAlignment.Center,
			TextWrapped            = true,
			RichText               = true,
			AutomaticSize          = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			-- กว้างเต็ม Pill (padding จัดการระยะห่างแล้ว)
			Size                   = UDim2.new(1, 0, 0, 0),
			Parent                 = Pill,
		})

		-- ซ่อน Pill ตอนที่ text ว่าง
		Pill.Visible = Config.Text ~= ""

		-- ── ให้ frame หลักขยายตาม Pill เมื่อ text หลายบรรทัด ───
		-- ใช้ AbsoluteSize ของ Pill drive ความสูง frame
		local BASE_H = 44  -- ความสูงปกติของ element row (px)
		local MIN_H  = BASE_H
		local function syncFrameHeight()
			local pillH  = Pill.AbsoluteSize.Y
			local target = math.max(MIN_H, pillH + 16)
			if math.abs(LLFrame.Frame.Size.Y.Offset - target) > 1 then
				TweenService:Create(
					LLFrame.Frame,
					TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Size = UDim2.new(1, 0, 0, target) }
				):Play()
				-- จัด Pill ให้อยู่กึ่งกลาง Y ตามความสูงใหม่
				Pill.Position = UDim2.new(1, -10, 0.5, 0)
			end
		end
		Creator.AddSignal(Pill:GetPropertyChangedSignal("AbsoluteSize"), syncFrameHeight)

		-- ── API ──────────────────────────────────────────────────
		local PillStroke = Pill:FindFirstChildOfClass("UIStroke")
		function LL:SetText(text)
			self.Value      = text or ""
			ValueLabel.Text = self.Value
			Pill.Visible    = self.Value ~= ""
			Library:SafeCallback(LL.Changed, self.Value)
		end
		function LL:SetType(t)
			self._type = t or "default"
			local col  = TypeColors[self._type] or TypeColors.default
			local bg   = TypeBg[self._type]     or TypeBg.default
			local ti   = TweenInfo.new(0.15)
			TweenService:Create(ValueLabel, ti, { TextColor3 = col }):Play()
			TweenService:Create(Pill,       ti, { BackgroundColor3 = bg }):Play()
			if PillStroke then
				TweenService:Create(PillStroke, ti, { Color = col }):Play()
			end
		end
		function LL:SetColor(color)
			ValueLabel.TextColor3 = color
			if PillStroke then PillStroke.Color = color end
		end
		function LL:OnChanged(Func) LL.Changed = Func Func(LL.Value) end
		function LL:Destroy()
			LLFrame.Frame:Destroy()
			if Idx then Library.Options[Idx] = nil end
		end
		LL:SetType(Config.Type)
		if Idx then Library.Options[Idx] = LL end
		return LL
	end
	return Element
end)()
