local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...)
	return Elements[Key](...)
end

for _, ElementComponent in pairs(ElementsTable) do
	Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.ScrollFrame = self.ScrollFrame
		ElementComponent.Library = Library

		-- NoIdx dispatcher: เผื่อกรณีมี element ในอนาคตที่ไม่ใช้ Idx (ตอนนี้ไม่มี element ไหนตั้งค่านี้แล้ว)
		if ElementComponent.NoIdx then
			return ElementComponent:New(Idx)
		end
		return ElementComponent:New(Idx, Config)
	end
end

-- [ จุดที่แก้ ] ย้าย AddTab/AddSharedTab มาไว้ตรงนี้ (บน Elements metatable ที่ใช้ร่วมกันทุก container)
-- แทนที่จะแปะไว้บนตัว Section ที่ Components.Section(...) คืนกลับมาโดยตรง — เพราะ SubTab:AddSection /
-- Tab:AddSection จริงๆ แล้วไม่ได้ return ตัว SectionFrame นั้นตรงๆ แต่สร้าง wrapper table ใหม่
-- (local Section = { Type = "Section" }) แล้วก็อปแค่ .Container/.ScrollFrame มาใส่ ก่อน setmetatable(Elements)
-- แปะ method ไว้บน SectionFrame ตรงๆ เลยไม่ติดมากับ wrapper ที่ผู้ใช้ได้จริง ทำให้เรียก :AddTab() แล้ว
-- ขึ้น "attempt to call missing method" เพราะ wrapper ไม่มี method นี้อยู่เลย — ย้ายมาไว้บน Elements
-- ตรงนี้แทน รับประกันว่าใช้ได้กับทุก object ที่ setmetatable(Elements) ไว้ (Section/SubTab/Tab/Accordion)
Elements.AddTab = function(self, TabTitle, TabIcon)
	self.SectionTabs = self.SectionTabs or {}
	self.SharedGroups = self.SharedGroups or {}
	self.SelectedSectionTab = self.SelectedSectionTab or 0
	self.SectionTabCount = (self.SectionTabCount or 0) + 1
	local Index = self.SectionTabCount

	-- สร้างแถบแท็บ + เส้นคั่น + ที่เก็บเนื้อหาแค่ครั้งแรกที่เรียก AddTab (ครั้งต่อๆ ไปใช้ของเดิมที่มีอยู่)
	-- [ จุดที่แก้ ] ไฟนอล — กลับไปเป็นกล่องแยกแต่ละปุ่มเหมือนตอนแรก (ไม่ใช่แท่งเดียวรวมแบบ segmented bar
	-- ที่ทำรอบที่แล้ว) แต่ปรับขนาด/มุมมนให้พอดีกว่าเดิม ไม่เล็ก/จางเกินไป
	if not self.SectionTabStrip then
		self.SectionTabStrip = Creator.New("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Parent = self.Container,
		}, {
			Creator.New("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		})
		-- เส้นคั่นระหว่างแถบแท็บกับเนื้อหาด้านล่าง (ยังเก็บไว้เหมือนรอบที่แล้ว ไม่มีใครบ่นจุดนี้)
		self.SectionTabDivider = Creator.New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundTransparency = 0.75,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Parent = self.Container,
			ThemeTag = { BackgroundColor3 = "InElementBorder" },
		})
		self.SectionTabContentHolder = Creator.New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Parent = self.Container,
		})
	end

	-- ฟังก์ชันคำนวณ layout กลาง สร้างครั้งเดียวต่อ container ใช้ร่วมกันทั้ง AddTab และ AddSharedTab
	-- คำนวณตำแหน่ง/ความสูงของ "บล็อกที่ควรโชว์ตอนนี้" เอง แบบตรงๆ ไม่พึ่ง UIListLayout จัดการให้
	-- เพราะ block ที่ควรโชว์พร้อมกัน (tab ที่เลือก + shared group ที่ตรง) ไม่ได้เรียงกันตายตัว
	if not self._RecalcSectionTabLayout then
		self._RecalcSectionTabLayout = function()
			local y = 0
			local activeTab = self.SectionTabs[self.SelectedSectionTab]
			if activeTab then
				activeTab.Container.Position = UDim2.new(0, 0, 0, y)
				y = y + activeTab.Layout.AbsoluteContentSize.Y
			end
			for _, g in ipairs(self.SharedGroups) do
				if table.find(g.Tabs, self.SelectedSectionTab) then
					if y > 0 then y = y + 4 end -- ช่องว่างเล็กๆ คั่นระหว่างบล็อก
					g.Container.Position = UDim2.new(0, 0, 0, y)
					g.Container.Visible = true
					y = y + g.Layout.AbsoluteContentSize.Y
				else
					g.Container.Visible = false
				end
			end
			-- [ จุดที่แก้ ] เผื่อระยะขอบล่างอีก 6px หลังเนื้อหา ไม่ให้ element สุดท้ายในแท็บติดกับของ
			-- ถัดไปใน Section (เช่น element อื่นหลัง AddTab หรือขอบล่างของการ์ด) มากเกินไป
			if y > 0 then y = y + 6 end
			self.SectionTabContentHolder.Size = UDim2.new(1, 0, 0, y)
		end
	end

	local resolvedIcon = TabIcon
	if not fischbypass then
		if Library:GetIcon(TabIcon) then resolvedIcon = Library:GetIcon(TabIcon) end
		if resolvedIcon == "" or resolvedIcon == nil then resolvedIcon = nil end
	end

	-- [ จุดที่แก้ ] ดีไซน์กล่องใหม่ทั้งหมด — ปุ่มไม่มีพื้นหลัง/กรอบ/มุมมนของตัวเองแล้ว (แถบรวมด้านบน
	-- ดูแลเรื่องนั้นให้หมด) เหลือแค่พื้นที่โปร่งใสที่ไล่ความทึบขึ้นตอน hover/active + เส้นคั่นบางๆ ระหว่างปุ่ม
	local TabLabel = Creator.New("TextLabel", {
		Text = TabTitle,
		FontFace = GetStyleProperty("FontMedium"),
		TextSize = GetStyleProperty("TextSizeXs"),
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 14),
		BackgroundTransparency = 1,
		ThemeTag = { TextColor3 = "SubText" },
	})
	local TabIconImg = resolvedIcon and Creator.New("ImageLabel", {
		Image = resolvedIcon,
		Size = UDim2.fromOffset(13, 13),
		BackgroundTransparency = 1,
		ThemeTag = { ImageColor3 = "SubText" },
	}) or nil
	-- [ จุดที่แก้ ] บั๊กเดิม: TabRow ไม่ได้ตั้ง Position/AnchorPoint เลย เลยลอยชิดขอบบนซ้ายของปุ่มตรงๆ
	-- (แทนที่จะอยู่กึ่งกลาง) พอความสูงปุ่ม (32) มากกว่าความสูงแถว (~14-16) ตัวหนังสือเลยดูเลื่อนขึ้นด้านบน
	-- ใส่ Position = (0, 0.5) + AnchorPoint (0, 0.5) ให้แถวลอยกึ่งกลางแนวตั้งจริงๆ ไม่ว่าปุ่มจะสูงเท่าไหร่
	local TabRow = Creator.New("Frame", {
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
	}, {
		Creator.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 5),
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		TabIconImg,
		TabLabel,
	})
	local TabButton = Creator.New("TextButton", {
		Text = "",
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 30),
		BackgroundTransparency = 0.78,
		Parent = self.SectionTabStrip,
		ThemeTag = { BackgroundColor3 = "Element" },
	}, {
		-- [ จุดที่แก้ ] ไฟนอล — มุมมนแบบสี่เหลี่ยมพอดีๆ (offset คงที่ 8px) ไม่เล็ก/ไม่รี ใช้ ElementCorner
		-- ที่เป็นสไตล์เดียวกับปุ่มอื่นในไลบรารีอยู่แล้ว
		NewCorner("ElementCorner"),
		Creator.New("UIStroke", {
			Transparency = 0.55,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = { Color = "InElementBorder" },
		}),
		Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
		TabRow,
	})
	local _, SetTabBg = Creator.SpringMotor(0.78, TabButton, "BackgroundTransparency", true, false, { frequency = 8 })

	local TabContentLayout = Creator.New("UIListLayout", { Padding = UDim.new(0, 4) })
	local TabContainer = Creator.New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = (Index == 1),
		Parent = self.SectionTabContentHolder,
	}, {
		TabContentLayout,
	})

	Creator.AddSignal(TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if self.SelectedSectionTab == Index then
			self._RecalcSectionTabLayout()
		end
	end)

	self.SectionTabs[Index] = { Button = TabButton, Container = TabContainer, SetBg = SetTabBg, Layout = TabContentLayout, Label = TabLabel, Icon = TabIconImg }

	-- [ จุดที่แก้ ] ปรับความทึบทุก state ให้เข้มขึ้นทั้งหมด (rest 0.7, hover 0.55, active 0.4) เดิม
	-- (rest 0.85, active 0.75) จางเกินไปจนแยกไม่ออกว่าปุ่มไหน active อยู่
	-- [ จุดที่เพิ่ม ] แท็บที่ active เปลี่ยนสีตัวหนังสือ/ไอคอนเป็นสี Accent ด้วย (เดิมสีเดียวกันหมดทุกแท็บ
	-- ต่างกันแค่พื้นหลัง/กรอบจางๆ ทำให้ดูไม่ค่อยชัดว่าอันไหน active อยู่จริงๆ)
	-- [ จุดที่แก้ ] แต่ละปุ่มมีกล่อง/กรอบของตัวเองแล้ว (ไฟนอล) ปรับความทึบให้เหมาะกับ base 0.78:
	-- พัก 0.78, hover 0.62, active 0.45
	local function UpdateSectionTabAppearance()
		for i, t in ipairs(self.SectionTabs) do
			local active = (i == self.SelectedSectionTab)
			t.Container.Visible = active
			t.SetBg(active and 0.45 or 0.78)
			Creator.OverrideTag(t.Label, { TextColor3 = active and "Accent" or "SubText" })
			if t.Icon then
				Creator.OverrideTag(t.Icon, { ImageColor3 = active and "Accent" or "SubText" })
			end
		end
		self._RecalcSectionTabLayout()
	end
	Creator.AddSignal(TabButton.MouseEnter, function()
		if Index ~= self.SelectedSectionTab then SetTabBg(0.62) end
	end)
	Creator.AddSignal(TabButton.MouseLeave, function()
		if Index ~= self.SelectedSectionTab then SetTabBg(0.78) end
	end)
	Creator.AddSignal(TabButton.MouseButton1Click, function()
		if self.SelectedSectionTab == Index then return end
		self.SelectedSectionTab = Index
		UpdateSectionTabAppearance()
	end)

	if self.SelectedSectionTab == 0 then self.SelectedSectionTab = Index end
	UpdateSectionTabAppearance()

	-- SectionTab ผูก Elements metatable เหมือนกัน เลยเรียก :AddToggle / :AddSlider ฯลฯ ต่อได้ปกติ
	-- (ไม่มี :AddSection ซ้อนต่อ เพราะเป็น container ใบสุดท้าย ไม่ควร nest ลึกไปกว่านี้)
	local SectionTab = { Type = "SectionTab", Container = TabContainer, _Index = Index }
	setmetatable(SectionTab, Elements)
	return SectionTab
end

-- [ จุดที่เพิ่ม ] Elements:AddSharedTab — พื้นที่ element ที่โผล่ "ร่วมกัน" ในแท็บที่ระบุ (2 แท็บขึ้นไป)
-- โดยไม่ต้องสร้าง element ซ้ำหลายชุด ใช้แบบนี้:
--   local Shared = Section:AddSharedTab({ Tab1, Tab2 }) -- ส่ง handle ที่ได้จาก AddTab เข้าไป
--   Shared:AddToggle("SomeKey", { Title = "..." })
Elements.AddSharedTab = function(self, Tabs)
	assert(type(Tabs) == "table" and #Tabs >= 2, "AddSharedTab - ต้องส่ง handle จาก AddTab อย่างน้อย 2 อันเป็น array")
	self.SharedGroups = self.SharedGroups or {}
	self.SectionTabs  = self.SectionTabs or {}
	assert(self._RecalcSectionTabLayout, "AddSharedTab - ต้องเรียก :AddTab อย่างน้อย 1 ครั้งก่อน")

	local TabIndices = {}
	for _, t in ipairs(Tabs) do
		assert(type(t) == "table" and t._Index, "AddSharedTab - แต่ละตัวใน list ต้องเป็น handle ที่ได้จาก :AddTab เท่านั้น")
		table.insert(TabIndices, t._Index)
	end

	local GroupLayout = Creator.New("UIListLayout", { Padding = UDim.new(0, 4) })
	local GroupContainer = Creator.New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false, -- Recalc ด้านล่างจะเป็นคนตัดสินใจโชว์/ซ่อนจริง
		Parent = self.SectionTabContentHolder,
	}, {
		GroupLayout,
	})

	local Group = { Container = GroupContainer, Layout = GroupLayout, Tabs = TabIndices }
	table.insert(self.SharedGroups, Group)

	Creator.AddSignal(GroupLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if table.find(TabIndices, self.SelectedSectionTab) then
			self._RecalcSectionTabLayout()
		end
	end)

	self._RecalcSectionTabLayout() -- เผื่อแท็บที่เลือกอยู่ตอนนี้ตรงกับลิสต์อยู่แล้วตั้งแต่แรก

	local SharedTab = { Type = "SectionSharedTab", Container = GroupContainer }
	setmetatable(SharedTab, Elements)
	return SharedTab
end

Library.Elements = Elements
if RunService:IsStudio() then
	makefolder = function(...) return ... end;
	makefile = function(...) return ... end;
	isfile = function(...) return ... end;
	isfolder = function(...) return ... end;
	readfile = function(...) return ... end;
	writefile = function(...) return ... end;
	listfiles = function (...) return {...} end;
end

