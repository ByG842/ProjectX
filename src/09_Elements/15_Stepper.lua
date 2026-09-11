
-- END OF 30 NEW ELEMENTS


-- ═══════════════════════════════════════════════════════════════════════
-- Stepper — รวม NumberInput + CounterButton เดิมเป็นตัวเดียว
--   Mode = "Full"    → ตัวเลขแตะพิมพ์ได้ตรงๆ (แทน AddNumberInput)
--   Mode = "Compact" → ตัวเลขอ่านอย่างเดียว กะทัดรัดกว่า (แทน AddCounterButton)
-- หน้าตา: label ชิดขวา + ปุ่ม chevron ขึ้น/ลง ซ้อนกันแนวตั้ง มีช่องว่างคั่นกลาง
-- (ไม่ติดกัน) แต่ละปุ่มมีกรอบบางมุมมนเล็กๆ พื้นหลังโปร่งใส จางขึ้นตอน hover
-- ═══════════════════════════════════════════════════════════════════════
ElementsTable.Stepper = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Stepper"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Stepper - Missing Title")
		Config.Default = Config.Default or 0
		Config.Step    = Config.Step    or 1
		Config.Min     = Config.Min     or -math.huge
		Config.Max     = Config.Max     or math.huge
		Config.Mode    = Config.Mode    or "Full" -- "Full" | "Compact"
		Config.Suffix  = Config.Suffix  or ""
		local ST = {
			Value    = Config.Default,
			Step     = Config.Step,
			Min      = Config.Min,
			Max      = Config.Max,
			Type     = "Stepper",
			Callback = Config.Callback or function() end,
		}

		local STFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		ST.SetTitle = STFrame.SetTitle
		ST.SetDesc  = STFrame.SetDesc
		ST.Visible  = STFrame.Visible
		ST.Elements = STFrame
		local isFull = Config.Mode == "Full"

		-- ── แถวขวา: [ตัวเลข] ── gap ── [คอลัมน์ปุ่ม +/-] ─────────────────────
		-- ✅ FIX: ใช้ AutomaticSize ทั้ง Row และ BtnColumn แทนความสูงคงที่
		-- (เดิม fix เป็น 30px แต่ปุ่ม 2 อันรวม gap สูงจริง ~26px ก็ยังพอไหว
		--  แต่ถ้า config เปลี่ยนขนาดปุ่ม/gap ในอนาคตจะ "ล้นขอบ" ได้อีก
		--  จึงให้ frame คำนวณขนาดจากเนื้อหาจริงเสมอ กันปัญหาซ้ำ)
		local Row = New("Frame", {
			Size                   = UDim2.fromOffset(0, 0),
			AutomaticSize          = Enum.AutomaticSize.XY,
			Position               = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint            = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent                 = STFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection     = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder         = Enum.SortOrder.LayoutOrder,
				Padding           = UDim.new(0, 16),
			}),
		})

		-- ค่าตัวเลข: TextBox ถ้า Full (พิมพ์ตรงได้), TextLabel ถ้า Compact
		local ValueDisplay
		if isFull then
			ValueDisplay = New("TextBox", {
				Text                   = tostring(Config.Default) .. Config.Suffix,
				FontFace               = GetStyleProperty("FontMedium"),
				TextSize               = GetStyleProperty("TextSizeLg"),
				Size                   = UDim2.fromOffset(50, 34),
				BackgroundTransparency = 0.9,
				TextXAlignment         = Enum.TextXAlignment.Right,
				LayoutOrder            = 1,
				Parent                 = Row,
				ThemeTag               = { TextColor3 = "Text", BackgroundColor3 = "Element" },
			}, {
				NewCorner("SmallCorner"),
				New("UIPadding", {
					PaddingLeft  = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
				}),
			})
		else
			ValueDisplay = New("TextLabel", {
				Text                   = tostring(Config.Default) .. Config.Suffix,
				FontFace               = GetStyleProperty("FontMedium"),
				TextSize               = GetStyleProperty("TextSizeLg"),
				Size                   = UDim2.fromOffset(42, 34),
				BackgroundTransparency = 0.9,
				TextXAlignment         = Enum.TextXAlignment.Right,
				LayoutOrder            = 1,
				Parent                 = Row,
				ThemeTag               = { TextColor3 = "Text", BackgroundColor3 = "Element" },
			}, {
				NewCorner("SmallCorner"),
				New("UIPadding", {
					PaddingLeft  = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
				}),
			})
		end

		-- คอลัมน์ปุ่ม chevron ขึ้น/ลง — เว้นช่องว่างตรงกลาง ไม่ติดกัน
		local BtnColumn = New("Frame", {
			Size                   = UDim2.fromOffset(34, 0),
			AutomaticSize          = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder            = 2,
			Parent                 = Row,
		}, {
			New("UIListLayout", {
				FillDirection       = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder           = Enum.SortOrder.LayoutOrder,
				Padding             = UDim.new(0, 7), -- ← ช่องว่างระหว่างปุ่มบน/ล่าง (เผื่อกดผิดบนมือถือ)
			}),
		})

		local function makeArrowBtn(icon, lo)
			local BtnStroke = New("UIStroke", {
				Transparency    = 0.5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag        = { Color = "InElementBorder" },
			})
			local Btn = New("TextButton", {
				Text                   = "",
				Size                   = UDim2.fromOffset(34, 19),
				BackgroundTransparency = 1,
				AutoButtonColor        = false,
				LayoutOrder            = lo,
				Parent                 = BtnColumn,
				ThemeTag               = { BackgroundColor3 = "Element" },
			}, {
				NewCorner("TinyCorner"),
				BtnStroke,
				New("ImageLabel", {
					Image                  = icon,
					Size                   = UDim2.fromOffset(13, 13),
					AnchorPoint            = Vector2.new(0.5, 0.5),
					Position               = UDim2.new(0.5, 0, 0.5, 0),
					BackgroundTransparency = 1,
					ThemeTag               = { ImageColor3 = "Text" },
				}),
			})

			-- โปร่งใสตอนปกติ จางขึ้นตอน hover เท่านั้น
			local Motor, SetT = Creator.SpringMotor(1, Btn, "BackgroundTransparency")
			Creator.AddSignal(Btn.MouseEnter, function() SetT(0.85) end)
			Creator.AddSignal(Btn.MouseLeave, function() SetT(1) end)
			Creator.AddSignal(Btn.MouseButton1Down, function() SetT(0.72) end)
			Creator.AddSignal(Btn.MouseButton1Up, function() SetT(0.85) end)
			return Btn
		end
		local UpBtn   = makeArrowBtn(Library:GetIcon("chevron-up"), 1)
		local DownBtn = makeArrowBtn(Library:GetIcon("chevron-down"), 2)
		local function CleanFloat(v, step)
			local stepStr = tostring(step)
			local dot = stepStr:find("%.")
			local decimals = dot and (#stepStr - dot) or 0
			if decimals > 6 then decimals = 6 end
			return tonumber(string.format("%." .. decimals .. "f", v))
		end
		local function FlashInvalid()
			if not isFull then return end
			task.spawn(function()
				local origPos = ValueDisplay.Position
				local amplitudes = { 5, -4, 3, -2, 0 }
				for _, amp in ipairs(amplitudes) do
					TweenService:Create(ValueDisplay, TweenInfo.new(0.03, Enum.EasingStyle.Sine), {
						Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + amp, origPos.Y.Scale, origPos.Y.Offset),
					}):Play()
					task.wait(0.03)
				end
				ValueDisplay.Position = origPos
			end)
		end
		local function set(v)
			v = math.clamp(CleanFloat(v, ST.Step), ST.Min, ST.Max)
			ST.Value = v
			ValueDisplay.Text = tostring(v) .. Config.Suffix
			-- dim ปุ่มตอนถึงขีดจำกัด
			TweenService:Create(UpBtn,   TweenInfo.new(0.1), { BackgroundTransparency = v >= ST.Max and 0.95 or 1 }):Play()
			TweenService:Create(DownBtn, TweenInfo.new(0.1), { BackgroundTransparency = v <= ST.Min and 0.95 or 1 }):Play()
			Library:SafeCallback(ST.Callback, v)
			Library:SafeCallback(ST.Changed, v)
		end
		Creator.AddSignal(UpBtn.MouseButton1Click,   function() set(ST.Value + ST.Step) end)
		Creator.AddSignal(DownBtn.MouseButton1Click, function() set(ST.Value - ST.Step) end)

		-- กดค้างเพื่อเร่งความเร็ว
		for _, pair in ipairs({ { UpBtn, 1 }, { DownBtn, -1 } }) do
			local btn, dir = pair[1], pair[2]
			Creator.AddSignal(btn.MouseButton1Down, function()
				task.delay(0.4, function()
					while btn:IsDescendantOf(game) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						set(ST.Value + ST.Step * dir)
						task.wait(0.07)
					end
				end)
			end)
		end
		if isFull then
			Creator.AddSignal(ValueDisplay.FocusLost, function()
				local raw = ValueDisplay.Text:gsub(Config.Suffix .. "$", "")
				local n = tonumber(raw)
				if not n then
					ValueDisplay.Text = tostring(ST.Value) .. Config.Suffix
					FlashInvalid()
				elseif n < ST.Min or n > ST.Max then
					set(n)
					FlashInvalid()
				else
					set(n)
				end
			end)
		end
		function ST:SetValue(v) set(v) end
		function ST:OnChanged(Func) ST.Changed = Func Func(ST.Value) end
		function ST:Destroy() STFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
		set(Config.Default)
		if Idx then Library.Options[Idx] = ST end
		return ST
	end
	return Element
end)()
