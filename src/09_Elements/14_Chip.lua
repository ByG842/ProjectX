ElementsTable.Chip = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Chip"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Chip - Missing Title")
		Config.Items = Config.Items or {}
		Config.Multi = Config.Multi ~= false
		local CH = {
			Type = "Chip",
			Value = Config.Default and table.clone(Config.Default) or {},
			Callback = Config.Callback or function() end,
		}

		local CHFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		CH.SetTitle = CHFrame.SetTitle
		CH.SetDesc  = CHFrame.SetDesc
		CH.Visible  = CHFrame.Visible
		CH.Elements = CHFrame
		local ChipRow = New("Frame", {
			Size = UDim2.new(1, -20, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Parent = CHFrame.LabelHolder,
			LayoutOrder = 3,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8), -- ลดระยะห่างระหว่างปุ่มนิดนึงให้ดูเป็นกลุ่มก้อน
				Wraps = true,
			}),
			New("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) }),
		})

		local ChipBtns = {}

		-- [ จุดที่ปรับ ] เปลี่ยนจาก TweenService:Create ทุกครั้งที่กด (สร้าง tween ใหม่ซ้ำๆ)
		-- มาเป็น Creator.SpringMotor ที่สร้าง motor ครั้งเดียวต่อปุ่มแล้ว "เล็ง" เป้าหมายใหม่ทุกครั้ง
		-- เป็น physics-based spring จะไม่มีจังหวะกระตุก/ชนกันของ tween เก่า-ใหม่เวลากดรัวๆ
		-- (เก็บ setter ไว้ใน table ธรรมดา ห้ามแปะใส่ Instance ตรงๆ เพราะ Roblox ไม่ยอมให้ตั้ง property ที่ไม่มีจริง)
		-- [ จุดที่แก้ ] ตัด hover/press/scale-bounce ออกทั้งหมดตามที่ขอ เหลือแค่ไล่สีเปลี่ยนตอนกดเลือก/ไม่เลือก
		-- เท่านั้น ไม่มี state อื่นมาแทรก เลยไม่มีจังหวะกระตุกหรือเด้งเกินเป้าหมาย
		local function updateChip(item, data)
			local active = table.find(CH.Value, item) ~= nil
			data.SetBg(active and 0.05 or 0.92)
			data.SetText(active and 0 or 0.4)
			data.SetStroke(active and 0.1 or 0.85)
		end
		for _, item in ipairs(Config.Items) do
			local chip = New("TextButton", {
				Text = tostring(item),
				FontFace = GetStyleProperty("FontMedium"), -- เปลี่ยนเป็น Medium ให้อ่านง่ายและคลีนขึ้น
				TextSize = GetStyleProperty("TextSizeSm"), -- ขยายตัวอักษรขึ้นนิดนึง (จาก 11)
				Size = UDim2.fromOffset(0, 28), -- เพิ่มความสูงปุ่มให้อักษรอยู่ตรงกลางสวยๆ
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 0.92,
				TextXAlignment = Enum.TextXAlignment.Center, -- จัดกึ่งกลางแนวนอน
				TextYAlignment = Enum.TextYAlignment.Center, -- จัดกึ่งกลางแนวตั้ง
				Parent = ChipRow,
				ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
			}, {
				NewCorner("SmallCorner"), -- [ จุดที่ปรับ ] เปลี่ยนจาก PillCorner (มนเต็มแบบเม็ดยา) เป็นสี่เหลี่ยมมนนิดๆ
				New("UIStroke", { Transparency = 0.85, Thickness = GetStyleProperty("BorderThickness"), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "Accent" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }), -- เพิ่มพื้นที่หายใจซ้ายขวา
			})
			local stroke = chip:FindFirstChildOfClass("UIStroke")

			-- [ จุดที่แก้ ] ใส่ IgnoreDialogCheck = true กันไว้เผื่อมี dialog อื่นเปิดค้างแล้วบัง BackgroundTransparency motor ไม่ให้ขยับ
			-- [ จุดที่ปรับ ] dampingRatio = 1 (critically damped) ตรงๆ ชัดๆ ไม่มีวันเกินเป้าหมาย = ไม่เด้ง
			-- frequency 7 ให้ไล่สีเนียนๆ ไม่เร็วจนกระตุก ไม่ช้าจนหน่วง
			local SmoothSpring = { frequency = 7, dampingRatio = 1 }
			local _, SetBg     = Creator.SpringMotor(0.92, chip, "BackgroundTransparency", true, false, SmoothSpring)
			local _, SetText   = Creator.SpringMotor(0.4,  chip, "TextTransparency", true, false, SmoothSpring)
			local _, SetStroke = Creator.SpringMotor(0.85, stroke, "Transparency", true, false, SmoothSpring)

			local data = { Instance = chip, SetBg = SetBg, SetText = SetText, SetStroke = SetStroke }
			ChipBtns[item] = data
			updateChip(item, data)
			Creator.AddSignal(chip.MouseButton1Click, function()
				local idx = table.find(CH.Value, item)
				if idx then
					table.remove(CH.Value, idx)
				else
					if not Config.Multi then CH.Value = {} end
					table.insert(CH.Value, item)
				end
				for it, d in pairs(ChipBtns) do
					updateChip(it, d)
				end
				Library:SafeCallback(CH.Callback, CH.Value)
				Library:SafeCallback(CH.Changed, CH.Value)
			end)
		end
		function CH:SetValue(v)
			self.Value = v
			for it, d in pairs(ChipBtns) do updateChip(it, d) end
			Library:SafeCallback(self.Callback, v)
			Library:SafeCallback(self.Changed, v)
		end
		function CH:OnChanged(Func) CH.Changed = Func Func(CH.Value) end
		function CH:Destroy() CHFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = CH end
		return CH
	end
	return Element
end)()
