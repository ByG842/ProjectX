local Creator = {
	Registry = {},
	Signals = {},
	TransparencyMotors = {},
	DefaultProperties = {
		ScreenGui = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		},
		Frame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ScrollingFrame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ScrollBarImageColor3 = Color3.new(0, 0, 0),
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			TextSize = GetStyleProperty("TextSizeLg"),
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = GetStyleProperty("TextSizeLg"),
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = GetStyleProperty("TextSizeLg"),
		},
		ImageLabel = {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ImageButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
		},
		CanvasGroup = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
	},
}

local function ApplyCustomProps(Object, Props)
	if Props.ThemeTag then
		Creator.AddThemeObject(Object, Props.ThemeTag)
	end
end

function Creator.AddSignal(Signal, Function)
	local Connected = Signal:Connect(Function)
	table.insert(Creator.Signals, Connected)
	return Connected
end

function Creator.Disconnect()
	for Idx = #Creator.Signals, 1, -1 do
		local Connection = table.remove(Creator.Signals, Idx)
		if Connection.Disconnect then
			Connection:Disconnect()
		end
	end
end

Creator.Themes = Themes
Creator.Theme = Creator.Theme or "Dark"
function Creator.UpdateTheme()
	-- sync Creator.Theme กับ Library.Theme เสมอ
	if Library and Library.Theme and Creator.Themes[Library.Theme] then
		Creator.Theme = Library.Theme
	end
	if not Creator.Themes[Creator.Theme] then
		Creator.Theme = "Dark"
	end
	for Instance, Object in next, Creator.Registry do
		for Property, ColorIdx in next, Object.Properties do
			local themeValue = Creator.GetThemeProperty(ColorIdx)
			if themeValue then
				Instance[Property] = themeValue
			end
		end
	end
	local transparency = Creator.GetThemeProperty("ElementTransparency")
	if transparency then
		for _, Motor in next, Creator.TransparencyMotors do
			Motor:setGoal(Flipper.Instant.new(transparency))
		end
	end
end

local function lerpColor(a, b, t)
	return Color3.new(
		a.R + (b.R - a.R) * t,
		a.G + (b.G - a.G) * t,
		a.B + (b.B - a.B) * t
	)
end

function Creator.UpdateThemeAnimated(duration)
	duration = duration or 0.45
	if Library and Library.Theme and Creator.Themes[Library.Theme] then
		Creator.Theme = Library.Theme
	end
	if not Creator.Themes[Creator.Theme] then
		Creator.Theme = "Dark"
	end
	local snapshots = {}
	for Instance, Object in next, Creator.Registry do
		snapshots[Instance] = {}
		for Property, ColorIdx in next, Object.Properties do
			local ok, current = pcall(function() return Instance[Property] end)
			if ok then
				local target = Creator.GetThemeProperty(ColorIdx)
				if target ~= nil then
					if typeof(current) == "Color3" and typeof(target) == "Color3" then
						snapshots[Instance][Property] = { from = current, to = target }
					else
						pcall(function() Instance[Property] = target end)
					end
				end
			end
		end
	end
	local transparency = Creator.GetThemeProperty("ElementTransparency")
	if transparency then
		for _, Motor in next, Creator.TransparencyMotors do
			Motor:setGoal(Flipper.Instant.new(transparency))
		end
	end
	local elapsed = 0
	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		elapsed = elapsed + dt
		local t = math.min(elapsed / duration, 1)
		local ease = t < 0.5 and (4 * t * t * t) or (1 - (-2 * t + 2)^3 / 2)
		for Instance, props in next, snapshots do
			if Instance and Instance.Parent then
				for Property, data in next, props do
					local ok = pcall(function()
						Instance[Property] = lerpColor(data.from, data.to, ease)
					end)
					if not ok then snapshots[Instance][Property] = nil end
				end
			end
		end
		if t >= 1 then
			connection:Disconnect()
			for Instance, props in next, snapshots do
				for Property, data in next, props do
					pcall(function() Instance[Property] = data.to end)
				end
			end
		end
	end)
end

function Creator.AddThemeObject(Object, Properties)
	local Idx = #Creator.Registry + 1
	local Data = {
		Object = Object,
		Properties = Properties,
		Idx = Idx,
	}

	Creator.Registry[Object] = Data
	Creator.UpdateTheme()
	return Object
end

function Creator.OverrideTag(Object, Properties)
	Creator.Registry[Object].Properties = Properties
	Creator.UpdateTheme()
end

function Creator.GetThemeProperty(Property)
	if Property == "Accent" and Library.CustomAccentColor then
		return Library.CustomAccentColor
	end
	if Property == "AccentGradient" then
		local accent = Library.CustomAccentColor or (Themes[Library.Theme] and Themes[Library.Theme].Accent) or Themes["Dark"].Accent
		local light = Color3.new(
			accent.R + (1 - accent.R) * 0.4,
			accent.G + (1 - accent.G) * 0.4,
			accent.B + (1 - accent.B) * 0.4
		)
		return ColorSequence.new(light, accent)
	end
	local theme = Themes[Library.Theme]
	if theme and theme[Property] ~= nil then
		return theme[Property]
	end
	return Themes["Dark"][Property]
end

local MiniMessageColors = {
	["black"] = "#000000",
	["dark_blue"] = "#0000AA",
	["dark_green"] = "#00AA00",
	["dark_aqua"] = "#00AAAA",
	["dark_red"] = "#AA0000",
	["dark_purple"] = "#AA00AA",
	["gold"] = "#FFAA00",
	["gray"] = "#AAAAAA",
	["grey"] = "#AAAAAA",
	["dark_gray"] = "#555555",
	["dark_grey"] = "#555555",
	["blue"] = "#5555FF",
	["green"] = "#55FF55",
	["aqua"] = "#55FFFF",
	["cyan"] = "#55FFFF",
	["red"] = "#FF5555",
	["light_purple"] = "#FF55FF",
	["magenta"] = "#FF55FF",
	["yellow"] = "#FFFF55",
	["white"] = "#FFFFFF",
	["reset"] = "#FFFFFF",
	["orange"] = "#FFAA00",
	["pink"] = "#FF55FF",
	["lime"] = "#55FF55",
	["brown"] = "#AA5500",
}

local function MiniMessageToRichText(text)
	if type(text) ~= "string" or text == "" then
		return text
	end
	if not text:match("<[^>]+>") then
		return text
	end
	local result = text
	result = result:gsub("<br>", "\n")
	result = result:gsub("<br/>", "\n")
	result = result:gsub("<br />", "\n")
	result = result:gsub("<nl>", "\n")
	result = result:gsub("<newline>", "\n")
	result = result:gsub("<reset>", "</font></b></i></u></s>")
	result = result:gsub("<obfuscated>(.-)</obfuscated>", "%1")
	result = result:gsub("<obfuscated>", "")
	result = result:gsub("</obfuscated>", "")
	local function hexToRgb(hex)
		hex = hex:gsub("#", "")
		local r = tonumber("0x" .. hex:sub(1, 2))
		local g = tonumber("0x" .. hex:sub(3, 4))
		local b = tonumber("0x" .. hex:sub(5, 6))
		return r, g, b
	end
	local function rgbToHex(r, g, b)
		return string.format("#%02X%02X%02X", math.floor(r), math.floor(g), math.floor(b))
	end
	local function interpolateColor(color1Hex, color2Hex, t)
		local r1, g1, b1 = hexToRgb(color1Hex)
		local r2, g2, b2 = hexToRgb(color2Hex)
		local r = r1 + (r2 - r1) * t
		local g = g1 + (g2 - g1) * t
		local b = b1 + (b2 - b1) * t
		return rgbToHex(r, g, b)
	end
	for i = 1, 10 do
		local newResult = result:gsub("<gradient:([^>]+)>(.-)</gradient>", function(colorsStr, content)
			local colors = {}

			for colorMatch in colorsStr:gmatch("(#%x%x%x%x%x%x)") do
				table.insert(colors, colorMatch)
			end
			if #colors == 0 then
				for colorMatch in colorsStr:gmatch("(%x%x%x%x%x%x)") do
					table.insert(colors, "#" .. colorMatch)
				end
			end
			if #colors < 2 then
				if #colors == 1 then
					return '<font color="' .. colors[1] .. '">' .. content .. '</font>'
				else
					return content
				end
			end
			local cleanText = content:gsub("<[^>]+>", "")
			local textLength = #cleanText
			if textLength == 0 then
				return content
			end
			if textLength == 1 then
				return '<font color="' .. colors[1] .. '">' .. content .. '</font>'
			end
			local parts = {}
			local pos = 1
			local charIndex = 0
			while pos <= #content do
				if content:sub(pos, pos) == "<" then
					local tagEnd = content:find(">", pos)
					if tagEnd then
						local tag = content:sub(pos, tagEnd)
						table.insert(parts, {type = "tag", value = tag})
						pos = tagEnd + 1
					else
						table.insert(parts, {type = "char", value = content:sub(pos, pos), index = charIndex})
						charIndex = charIndex + 1
						pos = pos + 1
					end
				else
					local char = content:sub(pos, pos)
					table.insert(parts, {type = "char", value = char, index = charIndex})
					charIndex = charIndex + 1
					pos = pos + 1
				end
			end
			local function getGradientColor(t)
				t = math.max(0, math.min(1, t))
				if #colors == 2 then
					return interpolateColor(colors[1], colors[2], t)
				end
				local numSegments = #colors - 1
				local segmentSize = 1 / numSegments
				local segmentIndex = math.floor(t / segmentSize)
				if segmentIndex >= numSegments then
					segmentIndex = numSegments - 1
					t = 1.0
				end
				local segmentStart = segmentIndex * segmentSize
				local segmentEnd = (segmentIndex + 1) * segmentSize
				local segmentT = 0
				if segmentEnd > segmentStart then
					segmentT = (t - segmentStart) / (segmentEnd - segmentStart)
				else
					segmentT = (t >= segmentEnd) and 1.0 or 0.0
				end
				segmentT = math.max(0, math.min(1, segmentT))
				local color1Index = segmentIndex + 1
				local color2Index = segmentIndex + 2
				if color1Index < 1 then color1Index = 1 end
				if color2Index > #colors then color2Index = #colors end
				if color1Index > #colors then color1Index = #colors end
				return interpolateColor(colors[color1Index], colors[color2Index], segmentT)
			end
			local gradientText = ""
			local currentSegment = ""
			local currentColor = nil
			local segments = {}

			for _, part in ipairs(parts) do
				if part.type == "tag" then
					if currentSegment ~= "" and currentColor ~= nil then
						table.insert(segments, {text = currentSegment, color = currentColor})
						currentSegment = ""
						currentColor = nil
					end
					table.insert(segments, {text = part.value, color = nil})
				else
					local t = part.index / (textLength - 1)
					if textLength == 1 then t = 0 end
					local charColor = getGradientColor(t)
					if currentColor == charColor then
						currentSegment = currentSegment .. part.value
					else
						if currentSegment ~= "" and currentColor ~= nil then
							table.insert(segments, {text = currentSegment, color = currentColor})
						end
						currentSegment = part.value
						currentColor = charColor
					end
				end
			end
			if currentSegment ~= "" and currentColor ~= nil then
				table.insert(segments, {text = currentSegment, color = currentColor})
			end
			local hasTextSegments = false
			for _, segment in ipairs(segments) do
				if segment.text and segment.text ~= "" then
					hasTextSegments = true
					break
				end
			end
			if not hasTextSegments and textLength > 0 then
				local fallbackText = ""
				for i = 1, textLength do
					local t = (i - 1) / (textLength - 1)
					if textLength == 1 then t = 0 end
					local charColor = getGradientColor(t)
					local char = cleanText:sub(i, i)
					fallbackText = fallbackText .. '<font color="' .. charColor .. '">' .. char .. '</font>'
				end
				return fallbackText
			end
			for _, segment in ipairs(segments) do
				if segment.color and segment.text and segment.text ~= "" then
					gradientText = gradientText .. '<font color="' .. segment.color .. '">' .. segment.text .. '</font>'
				elseif segment.text then
					gradientText = gradientText .. segment.text
				end
			end
			if gradientText == "" or gradientText == nil or not gradientText:match('<font color=') then
				local fallbackText = ""
				for i = 1, textLength do
					local t = (i - 1) / (textLength - 1)
					if textLength == 1 then t = 0 end
					local charColor = getGradientColor(t)
					local char = cleanText:sub(i, i)
					fallbackText = fallbackText .. '<font color="' .. charColor .. '">' .. char .. '</font>'
				end
				return fallbackText
			end
			return gradientText
		end)
		if newResult == result then
			break
		end
		result = newResult
	end
	result = result:gsub("<color:(#%x%x%x%x%x%x)>(.-)</color>", '<font color="%1">%2</font>')
	result = result:gsub("<color:(#%x%x%x%x%x%x)>", '<font color="%1">')
	result = result:gsub("<color:(%x%x%x%x%x%x)>(.-)</color>", function(hex, content)
		return '<font color="#' .. hex .. '">' .. content .. '</font>'
	end)
	result = result:gsub("<color:(%x%x%x%x%x%x)>", function(hex)
		return '<font color="#' .. hex .. '">'
	end)
	result = result:gsub("</color>", "</font>")
	result = result:gsub("<(#%x%x%x%x%x%x)>(.-)</#%x%x%x%x%x%x>", '<font color="%1">%2</font>')
	result = result:gsub("<(#%x%x%x%x%x%x)>", '<font color="%1">')
	result = result:gsub("</(#%x%x%x%x%x%x)>", "</font>")
	local colorNames = {}
	for colorName, _ in pairs(MiniMessageColors) do
		table.insert(colorNames, colorName)
	end
	table.sort(colorNames, function(a, b) return #a > #b end)
	for _, colorName in ipairs(colorNames) do
		local hexColor = MiniMessageColors[colorName]
		result = result:gsub("<" .. colorName .. ">(.-)</" .. colorName .. ">", '<font color="' .. hexColor .. '">%1</font>')
		result = result:gsub("<" .. colorName .. ">", '<font color="' .. hexColor .. '">')
		result = result:gsub("</" .. colorName .. ">", "</font>")
	end
	result = result:gsub("<bold>(.-)</bold>", "<b>%1</b>")
	result = result:gsub("<bold>", "<b>")
	result = result:gsub("</bold>", "</b>")
	result = result:gsub("<italic>(.-)</italic>", "<i>%1</i>")
	result = result:gsub("<italic>", "<i>")
	result = result:gsub("</italic>", "</i>")
	result = result:gsub("<underline>(.-)</underline>", "<u>%1</u>")
	result = result:gsub("<underlined>(.-)</underlined>", "<u>%1</u>")
	result = result:gsub("<underline>", "<u>")
	result = result:gsub("<underlined>", "<u>")
	result = result:gsub("</underline>", "</u>")
	result = result:gsub("</underlined>", "</u>")
	result = result:gsub("<strikethrough>(.-)</strikethrough>", "<s>%1</s>")
	result = result:gsub("<strike>(.-)</strike>", "<s>%1</s>")
	result = result:gsub("<strikethrough>", "<s>")
	result = result:gsub("<strike>", "<s>")
	result = result:gsub("</strikethrough>", "</s>")
	result = result:gsub("</strike>", "</s>")
	result = result:gsub('<font color="[^"]+"></font>', "")
	result = result:gsub("</font></font>", "</font>")
	result = result:gsub("</b></b>", "</b>")
	result = result:gsub("</i></i>", "</i>")
	result = result:gsub("</u></u>", "</u>")
	result = result:gsub("</s></s>", "</s>")
	return result
end

local TextElements = {}
local TextElementConnections = {}

local function setupMiniMessageSupport(object, properties)
	if not (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
		return
	end
	local richTextExplicitlySet = properties and properties.RichText ~= nil
	if not richTextExplicitlySet then
		object.RichText = true
	elseif properties.RichText == false then
		object.RichText = false
	end
	local lastText = object.Text or ""
	local isConverting = false
	local function convertTextIfNeeded(text)
		if not text or type(text) ~= "string" then
			return text
		end
		local hasRichTextTags = text:match('<font color="[^"]+">')
		if hasRichTextTags then
			return text
		end
		if text:match("<[^>]+>") then
		local hasMiniMessagePattern =
			text:match("<%w+>") or
			text:match("<color:") or
			text:match("<#[%x%x%x%x%x%x]>") or
			text:match("<gradient:") or
			text:match("<reset>") or
			text:match("<obfuscated>") or
			text:match("</%w+>") or
			text:match("</color>")
			if hasMiniMessagePattern then
				if not object.RichText then
					object.RichText = true
				end
				return MiniMessageToRichText(text)
			end
		end
		return text
	end
	local connection = object:GetPropertyChangedSignal("Text"):Connect(function()
		if isConverting then
			return
		end
		local currentText = object.Text or ""
		if currentText ~= lastText then
			local converted = convertTextIfNeeded(currentText)
			if converted ~= currentText then
				isConverting = true
				object.Text = converted
				lastText = converted
				isConverting = false
			else
				lastText = currentText
			end
		end
	end)
	table.insert(TextElementConnections, connection)
	TextElements[object] = true
	if object.Text then
		local converted = convertTextIfNeeded(object.Text)
		if converted ~= object.Text then
			object.Text = converted
			lastText = converted
		end
	end
end

function Creator.New(Name, Properties, Children)
	local Object = Instance.new(Name)
	for Name, Value in next, Creator.DefaultProperties[Name] or {} do
		Object[Name] = Value
	end
	local originalText = Properties and Properties.Text

	-- ✅ internal keys ที่ไม่ใช่ property จริงของ Roblox
	local _internalKeys = { ThemeTag=true, _StyleKey=true, _SizeKey=true, _FontKey=true, _NoStyleRegister=true }

	for Name, Value in next, Properties or {} do
		if not _internalKeys[Name] then
			-- แปลง EnumItem → string อัตโนมัติเมื่อ assign ให้ property Text
			if Name == "Text" and typeof(Value) == "EnumItem" then
				Value = Value.Name
			end
			Object[Name] = Value
		end
	end
	if originalText and type(originalText) == "string" and originalText:match("<[^>]+>") then
		Object.Text = MiniMessageToRichText(originalText)
		if Properties and Properties.RichText == nil then
			Object.RichText = true
		end
	end
	for _, Child in next, Children or {} do
		if Child then Child.Parent = Object end
	end
	ApplyCustomProps(Object, Properties)
	setupMiniMessageSupport(Object, Properties)

	-- ✅ FIX: Auto-register ทุก object ที่สร้างผ่าน Creator.New เข้า StyleRegistry
	-- ทำให้ ApplyStyle("Minecraft") ควบคุม corner/stroke/font ได้ทั้งหมด
	-- skip ถ้ามี _NoStyleRegister = true (สำหรับ object พิเศษที่ไม่ต้องการ override)
	local noReg = Properties and Properties._NoStyleRegister
	if not noReg then
		if Name == "UICorner" then
			local styleKey = (Properties and Properties._StyleKey) or "ElementCorner"
			RegisterCorner(Object, styleKey)
		elseif Name == "UIStroke" then
			RegisterStroke(Object)
		elseif Name == "TextLabel" or Name == "TextButton" or Name == "TextBox" then
			local sizeKey = (Properties and Properties._SizeKey) or "TextSizeLg"
			local fontKey = (Properties and Properties._FontKey) or "FontMedium"
			RegisterText(Object, sizeKey, fontKey)
		end
	end
	return Object
end

function Creator.SpringMotor(Initial, Instance, Prop, IgnoreDialogCheck, ResetOnThemeChange, SpringParams)
	IgnoreDialogCheck = IgnoreDialogCheck or false
	ResetOnThemeChange = ResetOnThemeChange or false
	-- [ จุดที่เพิ่ม ] เปิดให้ผู้เรียกกำหนด frequency/dampingRatio เองได้ต่อ motor
	-- ค่า default ยังคง { frequency = 8 } เท่าเดิมทุกจุดที่ไม่ได้ส่งมา ไม่กระทบ element อื่น
	SpringParams = SpringParams or { frequency = 8 }
	local Motor = Flipper.SingleMotor.new(Initial)
	Motor:onStep(function(value)
		Instance[Prop] = value
	end)
	if ResetOnThemeChange then
		table.insert(Creator.TransparencyMotors, Motor)
	end
	local function SetValue(Value, Ignore, OverrideParams)
		Ignore = Ignore or false
		if not IgnoreDialogCheck then
			if not Ignore then
				if Prop == "BackgroundTransparency" and Library.DialogOpen then
					return
				end
			end
		end
		Motor:setGoal(Flipper.Spring.new(Value, OverrideParams or SpringParams))
	end
	return Motor, SetValue
end

Library.Creator = Creator
Library.MiniMessageToRichText = MiniMessageToRichText
local New = Creator.New
local GUI = New("ScreenGui", {
	Parent = LocalPlayer:WaitForChild("PlayerGui"),
})
Library.GUI = GUI
ProtectGui(GUI)
function Library:SafeCallback(Function, ...)
	if not Function then
		return
	end
	local Success, Event = pcall(Function, ...)
	if not Success then
		local _, i = Event:find(":%d+: ")
		if not i then
			return Library:Notify({
				Title = "Interface",
				Content = "Callback error",
				SubContent = Event,
				Duration = 5,
			})
		end
		return Library:Notify({
			Title = "Interface",
			Content = "Callback error",
			SubContent = Event:sub(i + 1),
			Duration = 5,
		})
	end
end--?
function Library:Round(Number, Factor)
	if Factor == 0 then
		return math.floor(Number)
	end
	Number = tostring(Number)
	return Number:find("%.") and tonumber(Number:sub(1, Number:find("%.") + Factor)) or Number
end

