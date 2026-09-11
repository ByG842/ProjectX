function Library:SetTheme(Value, Instant)
	if Library.Window and (table.find(Library.Themes, Value) or Themes[Value]) then
		Library.Theme = Value

		-- auto-apply style ที่ผูกอยู่กับ theme นี้
		local theme = Themes[Value]
		local styleName = (theme and theme.StyleOverride) or "Default"
		ApplyStyle(styleName)

		-- ถ้า background image เป็นแบบ auto (ไม่ได้ระบุเอง) ให้สลับตาม theme ด้วย
		local Window = Library.Window
		local isMinecraft = (Value == "Minecraft")
		if Window and Window.ManagedBackgroundImage and Window.BackgroundImage then
			local newImage = isMinecraft and "rbxassetid://127892835920326" or "rbxassetid://13196113628"
			Window.BackgroundImage.Image = newImage
			Window.BackgroundImage.ScaleType = Enum.ScaleType.Stretch
			Window.BackgroundImage.ImageTransparency = isMinecraft and 0.08 or (Window.BackgroundTransparency or 0.5)
		end

		-- 🧱 อัปเดต notification ที่เปิดค้างอยู่ให้เท็กซ์เจอร์/มุมเหลี่ยม/ฟอนต์/เงา sync ตามธีมที่สลับทันที
		if Library.ActiveNotifications then
			for _, notif in pairs(Library.ActiveNotifications) do
				if notif.RefreshStyle then notif:RefreshStyle() end
			end
		end

		-- คง cap ความโปร่งใสของ overlay ไว้ (กันบังเท็กซ์เจอร์หมด) แต่ไม่ยัดค่า 3 ทับของผู้ใช้เอง
		-- cap (min 0.35) ถูกจัดการอยู่แล้วใน SetWindowTransparency ตอน Library.Theme == "Minecraft"
		-- แค่ re-apply ค่าปัจจุบันของผู้ใช้ ไม่ force เป็น 3
		Library:SetWindowTransparency(Library.WindowTransparencyValue or (InterfaceManager and InterfaceManager.Settings and InterfaceManager.Settings.WindowTransparency) or 1.5)
		if Instant then
			Creator.UpdateTheme()
		else
			Creator.UpdateThemeAnimated(0.45)
		end
	end
end

-- เปลี่ยน style โดยไม่เปลี่ยนสี (ใช้เองได้)
function Library:SetStyle(styleName)
	if StyleThemes[styleName] then
		ApplyStyle(styleName)
	end
end

-- 🎨 ปรับสี Accent (ปุ่ม/highlight) แยกจากธีมหลัก โดยพื้นหลัง/mood ยังคงธีมเดิม
function Library:SetAccentColor(Color, Instant)
	Library.CustomAccentColor = Color
	if Instant then
		Creator.UpdateTheme()
	else
		Creator.UpdateThemeAnimated(0.3)
	end
end

-- ล้าง custom accent กลับไปใช้สี Accent เริ่มต้นของธีมปัจจุบัน
function Library:ResetAccentColor(Instant)
	Library.CustomAccentColor = nil
	if Instant then
		Creator.UpdateTheme()
	else
		Creator.UpdateThemeAnimated(0.3)
	end
end

-- 🗂️ Preset/Profile สลับด่วน — snapshot ค่า element ทั้งหมดไว้ในหน่วยความจำ สลับกลับได้ทันทีโดยไม่ต้องเข้าไปหน้า config
Library.Presets = Library.Presets or {}

function Library:SavePreset(Name)
	local snapshot = {}
	for idx, obj in pairs(Library.Options) do
		if obj and obj.Value ~= nil then
			local v = obj.Value
			if typeof(v) == "Color3" then
				snapshot[idx] = { __color3 = true, r = v.R, g = v.G, b = v.B }
			elseif typeof(v) == "EnumItem" then
				snapshot[idx] = { __enumName = v.Name }
			elseif type(v) == "table" then
				local copy = {}
				for k, vv in pairs(v) do copy[k] = vv end
				snapshot[idx] = copy
			else
				snapshot[idx] = v
			end
		end
	end
	Library.Presets[Name] = snapshot
	return snapshot
end

function Library:LoadPreset(Name)
	local snapshot = Library.Presets[Name]
	if not snapshot then return false end
	for idx, v in pairs(snapshot) do
		local obj = Library.Options[idx]
		if obj and obj.SetValue then
			local restored = v
			if type(v) == "table" and v.__color3 then
				restored = Color3.new(v.r, v.g, v.b)
			elseif type(v) == "table" and v.__enumName then
				restored = v.__enumName
			end
			pcall(function() obj:SetValue(restored) end)
		end
	end
	return true
end

function Library:DeletePreset(Name)
	Library.Presets[Name] = nil
end

function Library:GetPresetNames()
	local names = {}
	for name in pairs(Library.Presets) do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function Library:Destroy()
	if Library.Window then
		Library.Unloaded = true
		if Library.UseAcrylic then
			if Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Model then
				Library.Window.AcrylicPaint.Model:Destroy()
			end
		end
		Creator.Disconnect()
		Library.GUI:Destroy()
	end
end

function Library:ToggleAcrylic(Value)
	if Library.Window then
		if Library.UseAcrylic then
			Library.Acrylic = Value
			if Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Model then
				Library.Window.AcrylicPaint.Model.Transparency = Value and 0.95 or 1
			end
		end
	end
end

function Library:ToggleTransparency(Value)
	if Library.Window then
		Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = Value and 0.35 or 0
	end
end

function Library:SetWindowTransparency(Value)
	if not Library.Window then return end
	Value = math.clamp(Value or 1, 0, 3)

	-- คำนวณ background transparency จาก slider (0=โปร่งใสมาก, 3=ทึบ)
	-- Value 0 → transparency 0.95 (แทบมองไม่เห็น), Value 1.5 → 0.45 (default), Value 3 → 0 (ทึบสนิท)
	local bgTransparency = math.clamp(1 - (Value / 3.2), 0, 0.98)

	-- ธีม Minecraft: ไม่ให้ overlay ทึบจนบังเท็กซ์เจอร์หมด ต่อให้ลากไปสุด (Value = 3)
	if Library.Theme == "Minecraft" then
		bgTransparency = math.max(bgTransparency, 0.35)
	end

	-- ควบคุม AcrylicPaint.Frame.Background (ใช้ได้ทั้ง Acrylic และ non-Acrylic)
	local paint = Library.Window.AcrylicPaint
	if paint and paint.Frame then
		local bg = paint.Frame:FindFirstChild("Background")
		if bg then
			bg.BackgroundTransparency = bgTransparency
		end
		-- ถ้า Acrylic mode ปรับ blur model ด้วย
		if Library.UseAcrylic and paint.Model then
			local modelTransparency = math.clamp(0.94 + (Value * 0.02), 0.94, 0.99)
			paint.Model.Transparency = modelTransparency
		end
	end
	Library.WindowTransparencyValue = Value
end

function Library:Notify(Config)
	return NotificationModule:New(Config)
end
