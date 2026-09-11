-- ============================================================
-- 🎨 STYLE THEME SYSTEM
-- ควบคุม shape / font / border ของทุก element แยกจากสี
-- ============================================================
local StyleThemes = {
	Default = {
		-- UICorner
		WindowCorner      = UDim.new(0, 12),
		ElementCorner     = UDim.new(0, 8),
		SmallCorner       = UDim.new(0, 6),
		TinyCorner        = UDim.new(0, 4),
		PillCorner        = UDim.new(1, 0),
		-- UIStroke
		BorderThickness   = 1,
		-- Font (Gotham)
		FontRegular       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
		FontMedium        = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
		FontBold          = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
		FontSemiBold      = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
		-- TextSize
		TextSizeLg        = 14,
		TextSizeMd        = 13,
		TextSizeSm        = 12,
		TextSizeXs        = 11,
		TextSizeTitle     = 22,
		TextSizeIcon      = 18,
		-- Misc
	},
	Minecraft = {
		-- UICorner — เหลี่ยมทุกอัน pixel art style
		WindowCorner      = UDim.new(0, 0),
		ElementCorner     = UDim.new(0, 0),
		SmallCorner       = UDim.new(0, 0),
		TinyCorner        = UDim.new(0, 0),
		PillCorner        = UDim.new(0, 0),
		-- UIStroke — ขอบหนาแบบ pixel
		BorderThickness   = 3,
		-- Font — ฟอนต์พิกเซล Minecraft ที่อัปโหลดเอง (rbxassetid://12187371840)
		FontRegular       = Font.new("rbxassetid://12187371840", Enum.FontWeight.Regular),
		FontMedium        = Font.new("rbxassetid://12187371840", Enum.FontWeight.Regular),
		FontBold          = Font.new("rbxassetid://12187371840", Enum.FontWeight.Bold),
		FontSemiBold      = Font.new("rbxassetid://12187371840", Enum.FontWeight.Regular),
		-- TextSize
		TextSizeLg        = 13,
		TextSizeMd        = 12,
		TextSizeSm        = 11,
		TextSizeXs        = 10,
		TextSizeTitle     = 18,
		TextSizeIcon      = 16,
		-- Misc
	},
}

-- StyleRegistry เก็บ object ที่ต้อง update เมื่อเปลี่ยน style
local StyleRegistry = {
	Corners  = {},   -- { object = UICorner, key = "ElementCorner" }
	Strokes  = {},   -- { object = UIStroke, key = "BorderThickness" }
	Texts    = {},   -- { object = TextLabel/Button/Box, sizeKey, fontKey }
}

local CurrentStyle = "Default"
local function GetStyleProperty(key)
	local theme = Themes[Library and Library.Theme or "Dark"]
	local styleName = (theme and theme.StyleOverride) or "Default"
	local style = StyleThemes[styleName] or StyleThemes.Default
	return style[key]
end

local function RegisterCorner(cornerObj, key)
	table.insert(StyleRegistry.Corners, { object = cornerObj, key = key or "ElementCorner" })
end

local function RegisterStroke(strokeObj)
	table.insert(StyleRegistry.Strokes, { object = strokeObj })
end

local function RegisterText(textObj, sizeKey, fontKey)
	table.insert(StyleRegistry.Texts, {
		object  = textObj,
		sizeKey = sizeKey or "TextSizeMd",
		fontKey = fontKey or "FontMedium",
	})
end

local function ApplyStyle(styleName)
	local style = StyleThemes[styleName] or StyleThemes.Default
	CurrentStyle = styleName
	for _, entry in ipairs(StyleRegistry.Corners) do
		local obj = entry.object
		if obj and obj.Parent then
			pcall(function() obj.CornerRadius = style[entry.key] or style.ElementCorner end)
		end
	end
	for _, entry in ipairs(StyleRegistry.Strokes) do
		local obj = entry.object
		if obj and obj.Parent then
			pcall(function() obj.Thickness = style.BorderThickness end)
		end
	end
	for _, entry in ipairs(StyleRegistry.Texts) do
		local obj = entry.object
		if obj and obj.Parent then
			pcall(function()
				obj.TextSize = style[entry.sizeKey] or style.TextSizeMd
				obj.FontFace = style[entry.fontKey] or style.FontMedium
			end)
		end
	end
end

-- helper สร้าง UICorner + register ไปพร้อมกัน
-- ✅ FIX: ใช้ Creator.New แทน Instance.new ตรงๆ
-- เพื่อให้ hook ใน Creator.New auto-register เข้า StyleRegistry อัตโนมัติ
-- แต่ต้องระวัง infinite loop เพราะ Creator.New ยังไม่ถูกสร้างตอนนี้
-- จึงยังใช้ Instance.new ตรงๆ แต่ register manually เหมือนเดิม
local function NewCorner(key)
	local resolvedKey = key or "ElementCorner"
	local corner = Instance.new("UICorner")
	corner.CornerRadius = GetStyleProperty(resolvedKey)
	RegisterCorner(corner, resolvedKey)
	return corner
end

-- helper สร้าง UIStroke + register ไปพร้อมกัน
local function NewStroke(props)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = GetStyleProperty("BorderThickness")
	if props then
		for k, v in pairs(props) do
			if k ~= "ThemeTag" and k ~= "_StyleKey" then
				pcall(function() stroke[k] = v end)
			end
		end
	end
	RegisterStroke(stroke)
	return stroke, props and props.ThemeTag
end

local Library = {
	Version = "2.0.0",
	OpenFrames = {},
	Options = {},
	Themes = Themes.Names,
	Windows = {},

	Window = nil,
	WindowFrame = nil,
	Unloaded = false,
	Creator = nil,
	DialogOpen = false,
	UseAcrylic = false,
	Acrylic = false,
	Transparency = true,
	MinimizeKeybind = nil,
	MinimizeKey = Enum.KeyCode.RightControl,

	-- 🖼️ โลโก้แบรนด์ default — ใช้ตรงไหนก็ได้ที่รับ Icon โดยใส่ Icon = true แทนพิมพ์ rbxassetid เต็มๆ
	BrandLogo = "rbxassetid://121299517968919",
}

local function isMotor(value)
	local motorType = tostring(value):match("^Motor%((.+)%)$")
	if motorType then
		return true, motorType
	else
		return false
	end
end

