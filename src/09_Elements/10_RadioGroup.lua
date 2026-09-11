ElementsTable.RadioGroup = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "RadioGroup"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "RadioGroup - Missing Title")
		assert(Config.Options, "RadioGroup - Missing Options table")

		-- [ จุดที่เพิ่ม 1 ] เช็คว่าเปิดโหมด Multi หรือไม่
		local IsMulti = Config.Multi or false
		local Radio = {
			Options = Config.Options,
			Type = "RadioGroup",
			IsMulti = IsMulti,
			Callback = Config.Callback or function() end,
		}

		-- [ จุดที่เพิ่ม 2 ] จัดการค่าเริ่มต้น (Default) ให้รองรับทั้งแบบ Single และ Multi
		if IsMulti then
			Radio.Value = {} -- เก็บเป็น Dictionary ภายในเพื่อง่ายต่อการเปิด/ปิด
			if type(Config.Default) == "table" then
				for _, v in pairs(Config.Default) do
					Radio.Value[v] = true
				end
			elseif Config.Default ~= nil then
				Radio.Value[Config.Default] = true
			end
		else
			Radio.Value = Config.Default or Config.Options[1]
		end
		local RGFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		Radio.SetTitle = RGFrame.SetTitle
		Radio.SetDesc = RGFrame.SetDesc
		Radio.Visible = RGFrame.Visible
		Radio.Elements = RGFrame

		-- [ จุดที่เพิ่ม ] รายการเยอะ (>6) ให้ auto ขึ้น 2 คอลัมน์แทนที่จะยาวลงเป็นเส้นเดียว
		-- override ได้ผ่าน Config.Columns (1 = บังคับคอลัมน์เดียว, 2 = บังคับสองคอลัมน์)
		local ColumnCount = Config.Columns or (#Config.Options > 6 and 2 or 1)
		local RowHeight = 28

		local OptionsHolder = New("Frame", {
			Size = UDim2.new(1, -20, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Parent = RGFrame.LabelHolder,
			LayoutOrder = 3,
		}, {
			(ColumnCount > 1) and New("UIGridLayout", {
				CellSize = UDim2.new(1 / ColumnCount, -4, 0, RowHeight),
				CellPadding = UDim2.new(0, 8, 0, 6),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
			}) or New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
			New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 6) }),
		})

		local Buttons = {}

		-- [ จุดที่เพิ่ม 3 ] ฟังก์ชันตัวช่วยดึงค่าเพื่อส่งออกไปที่ Callback (จะได้ตารางสวยๆ)
		local function GetCallbackValue()
			if not IsMulti then return Radio.Value end
			local selected = {}
			for _, opt in ipairs(Radio.Options) do -- เรียงลำดับตาม Options เดิม
				if Radio.Value[opt] then
					table.insert(selected, opt)
				end
			end
			return selected
		end

		-- [ จุดที่เพิ่ม 4 ] อัปเดต UI ให้สอดคล้องกับโหมด (Single เช็คค่าตรงๆ / Multi เช็คใน Table)
		local function UpdateRadio()
			for _, btn in pairs(Buttons) do
				local isSelected = false
				if IsMulti then
					isSelected = Radio.Value[btn.Value] == true
				else
					isSelected = (btn.Value == Radio.Value)
				end
				btn.Selected = isSelected
				local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				TweenService:Create(btn.Outer, ti, {
					BackgroundTransparency = isSelected and 0 or 0.92,
					Size = isSelected and UDim2.fromOffset(18, 18) or UDim2.fromOffset(16, 16),
				}):Play()
				TweenService:Create(btn.OuterStroke, ti, {
					Transparency = isSelected and 1 or 0.55,
				}):Play()
				TweenService:Create(btn.Inner, ti, {
					BackgroundTransparency = isSelected and 0 or 1,
					Size = isSelected and UDim2.fromOffset(9, 9) or UDim2.fromOffset(5, 5),
				}):Play()
				TweenService:Create(btn.Stroke, ti, {
					Transparency = isSelected and 0.4 or 1,
				}):Play()
				btn.SetCardTransparency(btn.Hovering and 0.8 or (isSelected and 0.85 or 0.94))
			end
		end
		for _, opt in ipairs(Config.Options) do
			-- [ จุดที่เพิ่ม ] Row ตอนนี้เป็น "card" มีพื้นหลัง/ขอบบาง ๆ แทนที่จะโปร่งใสล้วน
			-- ดูมีเนื้อหามากขึ้น ไม่โล่ง แถมมี hover feedback ให้ด้วย
			local Row = New("TextButton", {
				Size = UDim2.new(1, 0, 0, RowHeight),
				BackgroundTransparency = 0.94,
				Text = "",
				Parent = OptionsHolder,
				ThemeTag = { BackgroundColor3 = "Element" },
			}, {
				NewCorner("TinyCorner"),
				New("UIStroke", { Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "Accent" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
				New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 8),
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
			})
			local Stroke = Row:FindFirstChildOfClass("UIStroke")

			-- [ จุดที่ปรับ ] เปลี่ยนจากวงกลม (PillCorner) เป็นสี่เหลี่ยมมนเล็ก (TinyCorner)
			-- และให้เส้นขอบจางลงเมื่อ "เลือกอยู่" (กลายเป็นแท่งทึบแทน) จะได้ไม่รู้สึกหนาตลอดเวลา
			local Outer = New("Frame", {
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 0.92,
				Parent = Row,
				ThemeTag = { BackgroundColor3 = "Accent" },
			}, {
				NewCorner("TinyCorner"),
				New("UIAspectRatioConstraint", { AspectRatio = 1 }),
				New("UIStroke", { Thickness = 1.2, Transparency = 0.55, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "Accent" } }),
			})
			local OuterStroke = Outer:FindFirstChildOfClass("UIStroke")

			local Inner = New("Frame", {
				Size = UDim2.fromOffset(4, 4),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Parent = Outer,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				NewCorner("TinyCorner"),
			})

			New("TextLabel", {
				Text = tostring(opt),
				FontFace = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeMd"),
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -24, 1, 0),
				Parent = Row,
				ThemeTag = { TextColor3 = "Text" },
			})

			local RowMotor, SetCardTransparency = Creator.SpringMotor(0.94, Row, "BackgroundTransparency")

			local BtnData = { Value = opt, Outer = Outer, Inner = Inner, Stroke = Stroke, OuterStroke = OuterStroke, SetCardTransparency = SetCardTransparency, Hovering = false, Selected = false }
			table.insert(Buttons, BtnData)

			Creator.AddSignal(Row.MouseEnter, function()
				BtnData.Hovering = true
				SetCardTransparency(0.8)
			end)
			Creator.AddSignal(Row.MouseLeave, function()
				BtnData.Hovering = false
				SetCardTransparency(BtnData.Selected and 0.85 or 0.94)
			end)

			-- [ จุดที่เพิ่ม 5 ] ลอจิกเวลากดปุ่ม ให้รองรับ Multi Toggle
			Creator.AddSignal(Row.MouseButton1Click, function()
				if IsMulti then
					if Radio.Value[opt] then
						Radio.Value[opt] = nil -- ถ้าเปิดอยู่ให้ปิด
					else
						Radio.Value[opt] = true -- ถ้าปิดอยู่ให้เปิด
					end
				else
					Radio.Value = opt
				end
				UpdateRadio()
				local retVal = GetCallbackValue()
				Library:SafeCallback(Radio.Callback, retVal)
				Library:SafeCallback(Radio.Changed, retVal)
			end)
		end

		-- [ จุดที่เพิ่ม 6 ] รองรับคำสั่ง SetValue ผ่านสคริปต์
		function Radio:SetValue(val)
			if IsMulti then
				Radio.Value = {}
				if type(val) == "table" then
					for _, v in pairs(val) do
						Radio.Value[v] = true
					end
				elseif val ~= nil then
					Radio.Value[val] = true
				end
			else
				Radio.Value = val
			end
			UpdateRadio()
			local retVal = GetCallbackValue()
			Library:SafeCallback(self.Callback, retVal)
			Library:SafeCallback(self.Changed, retVal)
		end
		function Radio:OnChanged(Func)
			Radio.Changed = Func
			Func(GetCallbackValue())
		end
		function Radio:Destroy()
			RGFrame.Frame:Destroy()
			if Idx then Library.Options[Idx] = nil end
		end
		UpdateRadio()
		if Idx then Library.Options[Idx] = Radio end
		return Radio
	end
	return Element
end)()
