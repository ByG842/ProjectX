--[[
	Gz UI Library — restructured
	----------------------------------------------------------------
	Full structural/visual rewrite. Public API is kept compatible with
	the previous (Fluent-derived) version: Library:CreateWindow, Window:AddTab,
	Tab:AddSection, Section:AddToggle/AddSlider/... etc. still work the same way,
	so existing scripts built against the old Gz.lua do not need to change.

	What changed structurally (see chat for full rundown):
	  - Left "icon rail" navigation replaces the old labeled sidebar list.
	  - Sections render as flat grouped rows with hairline dividers,
	    not nested bordered "cards".
	  - New slimmer header, relocated search, redesigned dialog/notification.
	  - Theme token set simplified (~12 fields instead of ~30).
	  - Removed dead code: unused 3D acrylic blur path, duplicated Icons
	    table, Minecraft pixel-style variant + fischbypass special-casing,
	    tiled noise-texture panels (replaced by a plain gradient+hairline
	    surface — lighter and flatter).
]]

local Lighting            = game:GetService("Lighting")
local RunService          = game:GetService("RunService")
local Players              = game:GetService("Players")
local LocalPlayer          = Players.LocalPlayer
local UserInputService     = game:GetService("UserInputService")
local TweenService         = game:GetService("TweenService")
local TextService           = game:GetService("TextService")
local RenderStepped         = RunService.RenderStepped
local Camera                = workspace.CurrentCamera
local Mouse                 = LocalPlayer:GetMouse()
local HttpService           = game:GetService("HttpService")

local Mobile = not RunService:IsStudio()
	and table.find({ Enum.Platform.IOS, Enum.Platform.Android }, UserInputService:GetPlatform()) ~= nil

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

-- ============================================================
-- Design tokens
-- ============================================================
-- Themes only declare a handful of "anchor" colors; everything else
-- (rail background, dividers, hover tint) is derived from Surface at
-- load time by Lighten(), so the palette stays consistent and adding
-- a new theme only means picking 8 colors, not 30.

local function Lighten(c, amount)
	local a = amount / 255
	return Color3.new(
		math.clamp(c.R + a, 0, 1),
		math.clamp(c.G + a, 0, 1),
		math.clamp(c.B + a, 0, 1)
	)
end

local Themes = {
	Names = { "Dark", "Darker", "AMOLED", "Aqua", "Amethyst", "Rose", "Midnight", "Ocean", "Emerald", "Sapphire" },

	Dark = {
		Name = "Dark", Accent = Color3.fromRGB(200, 200, 200),
		Surface = Color3.fromRGB(18, 18, 18), SurfaceBorder = Color3.fromRGB(45, 45, 45),
		InputBg = Color3.fromRGB(38, 38, 38), InputBorder = Color3.fromRGB(55, 55, 55),
		ToggleKnobOff = Color3.fromRGB(80, 80, 80), ToggleKnobOn = Color3.fromRGB(12, 12, 12),
		Text = Color3.fromRGB(230, 230, 230), SubText = Color3.fromRGB(140, 140, 140),
	},
	Darker = {
		Name = "Darker", Accent = Color3.fromRGB(170, 170, 170),
		Surface = Color3.fromRGB(8, 8, 8), SurfaceBorder = Color3.fromRGB(35, 35, 35),
		InputBg = Color3.fromRGB(22, 22, 22), InputBorder = Color3.fromRGB(38, 38, 38),
		ToggleKnobOff = Color3.fromRGB(55, 55, 55), ToggleKnobOn = Color3.fromRGB(5, 5, 5),
		Text = Color3.fromRGB(220, 220, 220), SubText = Color3.fromRGB(120, 120, 120),
	},
	AMOLED = {
		Name = "AMOLED", Accent = Color3.fromRGB(210, 215, 255),
		Surface = Color3.fromRGB(0, 0, 0), SurfaceBorder = Color3.fromRGB(24, 24, 28),
		InputBg = Color3.fromRGB(16, 16, 20), InputBorder = Color3.fromRGB(38, 38, 48),
		ToggleKnobOff = Color3.fromRGB(45, 45, 58), ToggleKnobOn = Color3.fromRGB(6, 6, 8),
		Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(158, 162, 188),
	},
	Aqua = {
		Name = "Aqua", Accent = Color3.fromRGB(38, 166, 178),
		Surface = Color3.fromRGB(18, 54, 61), SurfaceBorder = Color3.fromRGB(80, 118, 130),
		InputBg = Color3.fromRGB(66, 130, 160), InputBorder = Color3.fromRGB(75, 109, 110),
		ToggleKnobOff = Color3.fromRGB(100, 152, 160), ToggleKnobOn = Color3.fromRGB(25, 70, 95),
		Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170),
	},
	Amethyst = {
		Name = "Amethyst", Accent = Color3.fromRGB(126, 44, 182),
		Surface = Color3.fromRGB(40, 12, 71), SurfaceBorder = Color3.fromRGB(85, 45, 120),
		InputBg = Color3.fromRGB(115, 55, 150), InputBorder = Color3.fromRGB(85, 45, 110),
		ToggleKnobOff = Color3.fromRGB(135, 65, 160), ToggleKnobOn = Color3.fromRGB(59, 30, 79),
		Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(190, 175, 200),
	},
	Rose = {
		Name = "Rose", Accent = Color3.fromRGB(219, 48, 123),
		Surface = Color3.fromRGB(35, 25, 30), SurfaceBorder = Color3.fromRGB(145, 35, 75),
		InputBg = Color3.fromRGB(170, 60, 90), InputBorder = Color3.fromRGB(120, 50, 70),
		ToggleKnobOff = Color3.fromRGB(190, 75, 105), ToggleKnobOn = Color3.fromRGB(45, 15, 25),
		Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170),
	},
	Midnight = {
		Name = "Midnight", Accent = Color3.fromRGB(52, 50, 178),
		Surface = Color3.fromRGB(20, 20, 20), SurfaceBorder = Color3.fromRGB(83, 83, 130),
		InputBg = Color3.fromRGB(111, 108, 160), InputBorder = Color3.fromRGB(85, 83, 110),
		ToggleKnobOff = Color3.fromRGB(120, 117, 160), ToggleKnobOn = Color3.fromRGB(30, 12, 68),
		Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170),
	},
	Ocean = {
		Name = "Ocean", Accent = Color3.fromRGB(0, 141, 255),
		Surface = Color3.fromRGB(20, 25, 40), SurfaceBorder = Color3.fromRGB(40, 60, 100),
		InputBg = Color3.fromRGB(60, 80, 140), InputBorder = Color3.fromRGB(50, 60, 100),
		ToggleKnobOff = Color3.fromRGB(80, 100, 170), ToggleKnobOn = Color3.fromRGB(11, 35, 67),
		Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170),
	},
	Emerald = {
		Name = "Emerald", Accent = Color3.fromRGB(0, 168, 107),
		Surface = Color3.fromRGB(20, 35, 30), SurfaceBorder = Color3.fromRGB(30, 100, 80),
		InputBg = Color3.fromRGB(40, 120, 95), InputBorder = Color3.fromRGB(35, 85, 70),
		ToggleKnobOff = Color3.fromRGB(45, 130, 100), ToggleKnobOn = Color3.fromRGB(15, 40, 30),
		Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170),
	},
	Sapphire = {
		Name = "Sapphire", Accent = Color3.fromRGB(0, 105, 255),
		Surface = Color3.fromRGB(24, 30, 85), SurfaceBorder = Color3.fromRGB(25, 80, 150),
		InputBg = Color3.fromRGB(42, 98, 176), InputBorder = Color3.fromRGB(27, 65, 126),
		ToggleKnobOff = Color3.fromRGB(50, 140, 210), ToggleKnobOn = Color3.fromRGB(20, 50, 80),
		Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170),
	},
}

for themeName, theme in pairs(Themes) do
	if type(theme) == "table" and theme.Surface ~= nil then
		theme.SurfaceAlt = Lighten(theme.Surface, 9)
		theme.Divider    = Lighten(theme.Surface, 22)
		theme.RowHover   = Lighten(theme.Surface, 16)
	end
end

-- Static layout / type tokens (single design language — no per-theme style
-- variant switching like the old Minecraft pixel-style mode).
local Tokens = {
	Corner = {
		xs = UDim.new(0, 4),
		sm = UDim.new(0, 6),
		md = UDim.new(0, 10),
		lg = UDim.new(0, 16),
		pill = UDim.new(1, 0),
	},
	Border = 1,
	Font = {
		regular  = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
		medium   = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
		semibold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
		bold     = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
	},
	Text = {
		xs = 11, sm = 12, md = 13, lg = 14, title = 19, icon = 17,
	},
	Rail = { Width = 56 },
	Header = { Height = 44 },
	ContentHeader = { Height = 46 },
	Row = { MinHeight = 46, PadX = 16 },
	Group = { HeaderHeight = 26, Gap = 18 },
}

local CurrentTheme = "Dark"
-- ============================================================
-- Signal / Motion engine (Flipper-style spring motors)
-- Unrelated to visual layout — ported as-is, it's solid plumbing.
-- ============================================================
local function isMotor(value)
	local motorType = tostring(value):match("^Motor%((.+)%)$")
	return motorType ~= nil
end

local Connection = {}
Connection.__index = Connection
function Connection.new(signal, handler)
	return setmetatable({ signal = signal, connected = true, _handler = handler }, Connection)
end
function Connection:disconnect()
	if self.connected then
		self.connected = false
		for index, connection in pairs(self.signal._connections) do
			if connection == self then
				table.remove(self.signal._connections, index)
				return
			end
		end
	end
end

local Signal = {}
Signal.__index = Signal
function Signal.new()
	return setmetatable({ _connections = {}, _threads = {} }, Signal)
end
function Signal:fire(...)
	for _, connection in pairs(self._connections) do
		connection._handler(...)
	end
	for _, thread in pairs(self._threads) do
		coroutine.resume(thread, ...)
	end
	self._threads = {}
end
function Signal:connect(handler)
	local connection = Connection.new(self, handler)
	table.insert(self._connections, connection)
	return connection
end
function Signal:wait()
	table.insert(self._threads, coroutine.running())
	return coroutine.yield()
end

local Instant = {}
Instant.__index = Instant
function Instant.new(targetValue)
	return setmetatable({ _targetValue = targetValue }, Instant)
end
function Instant:step()
	return { complete = true, value = self._targetValue }
end

local VELOCITY_THRESHOLD = 0.001
local POSITION_THRESHOLD = 0.001
local EPS = 0.0001
local Spring = {}
Spring.__index = Spring
function Spring.new(targetValue, options)
	assert(targetValue, "Missing argument #1: targetValue")
	options = options or {}
	return setmetatable({
		_targetValue = targetValue,
		_frequency = options.frequency or 4,
		_dampingRatio = options.dampingRatio or 1,
	}, Spring)
end
function Spring:step(state, dt)
	local d = self._dampingRatio
	local f = self._frequency * 2 * math.pi
	local g = self._targetValue
	local p0 = state.value
	local v0 = state.velocity or 0
	local offset = p0 - g
	local decay = math.exp(-d * f * dt)
	local p1, v1
	if d == 1 then
		p1 = (offset * (1 + f * dt) + v0 * dt) * decay + g
		v1 = (v0 * (1 - f * dt) - offset * (f * f * dt)) * decay
	elseif d < 1 then
		local c = math.sqrt(1 - d * d)
		local i = math.cos(f * c * dt)
		local j = math.sin(f * c * dt)
		local z = (c > EPS) and (j / c) or (function()
			local a = dt * f
			return a + ((a * a) * (c * c) * (c * c) / 20 - c * c) * (a * a * a) / 6
		end)()
		local y = (f * c > EPS) and (j / (f * c)) or (function()
			local b = f * c
			return dt + ((dt * dt) * (b * b) * (b * b) / 20 - b * b) * (dt * dt * dt) / 6
		end)()
		p1 = (offset * (i + d * z) + v0 * y) * decay + g
		v1 = (v0 * (i - z * d) - offset * (z * f)) * decay
	else
		local c = math.sqrt(d * d - 1)
		local r1 = -f * (d - c)
		local r2 = -f * (d + c)
		local co2 = (v0 - offset * r1) / (2 * f * c)
		local co1 = offset - co2
		local e1 = co1 * math.exp(r1 * dt)
		local e2 = co2 * math.exp(r2 * dt)
		p1 = e1 + e2 + g
		v1 = e1 * r1 + e2 * r2
	end
	local complete = math.abs(v1) < VELOCITY_THRESHOLD and math.abs(p1 - g) < POSITION_THRESHOLD
	return { complete = complete, value = complete and g or p1, velocity = v1 }
end

local noop = function() end
local BaseMotor = {}
BaseMotor.__index = BaseMotor
function BaseMotor.new()
	return setmetatable({ _onStep = Signal.new(), _onStart = Signal.new(), _onComplete = Signal.new() }, BaseMotor)
end
function BaseMotor:onStep(handler) return self._onStep:connect(handler) end
function BaseMotor:onStart(handler) return self._onStart:connect(handler) end
function BaseMotor:onComplete(handler) return self._onComplete:connect(handler) end
function BaseMotor:start()
	if not self._connection then
		self._connection = RunService.RenderStepped:Connect(function(dt) self:step(dt) end)
	end
end
function BaseMotor:stop()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end
BaseMotor.destroy = BaseMotor.stop
BaseMotor.step = noop
BaseMotor.getValue = noop
BaseMotor.setGoal = noop
function BaseMotor:__tostring() return "Motor" end

local SingleMotor = setmetatable({}, BaseMotor)
SingleMotor.__index = SingleMotor
function SingleMotor.new(initialValue, useImplicitConnections)
	assert(typeof(initialValue) == "number", "initialValue must be a number!")
	local self = setmetatable(BaseMotor.new(), SingleMotor)
	self._useImplicitConnections = (useImplicitConnections ~= nil) and useImplicitConnections or true
	self._goal = nil
	self._state = { complete = true, value = initialValue }
	return self
end
function SingleMotor:step(deltaTime)
	if self._state.complete then return true end
	local newState = self._goal:step(self._state, deltaTime)
	self._state = newState
	self._onStep:fire(newState.value)
	if newState.complete then
		if self._useImplicitConnections then self:stop() end
		self._onComplete:fire()
	end
	return newState.complete
end
function SingleMotor:getValue() return self._state.value end
function SingleMotor:setGoal(goal)
	self._state.complete = false
	self._goal = goal
	self._onStart:fire()
	if self._useImplicitConnections then self:start() end
end
function SingleMotor:__tostring() return "Motor(Single)" end

local GroupMotor = setmetatable({}, BaseMotor)
GroupMotor.__index = GroupMotor
local function toMotor(value)
	if isMotor(value) then return value end
	local valueType = typeof(value)
	if valueType == "number" then return SingleMotor.new(value, false) end
	if valueType == "table" then return GroupMotor.new(value, false) end
	error(("Unable to convert to motor; type %s is unsupported"):format(valueType), 2)
end
function GroupMotor.new(initialValues, useImplicitConnections)
	assert(typeof(initialValues) == "table", "initialValues must be a table!")
	local self = setmetatable(BaseMotor.new(), GroupMotor)
	self._useImplicitConnections = (useImplicitConnections ~= nil) and useImplicitConnections or true
	self._complete = true
	self._motors = {}
	for key, value in pairs(initialValues) do
		self._motors[key] = toMotor(value)
	end
	return self
end
function GroupMotor:step(deltaTime)
	if self._complete then return true end
	local allComplete = true
	for _, motor in pairs(self._motors) do
		if not motor:step(deltaTime) then allComplete = false end
	end
	self._onStep:fire(self:getValue())
	if allComplete then
		if self._useImplicitConnections then self:stop() end
		self._complete = true
		self._onComplete:fire()
	end
	return allComplete
end
function GroupMotor:setGoal(goals)
	self._complete = false
	self._onStart:fire()
	for key, goal in pairs(goals) do
		local motor = assert(self._motors[key], ("Unknown motor for key %s"):format(key))
		motor:setGoal(goal)
	end
	if self._useImplicitConnections then self:start() end
end
function GroupMotor:getValue()
	local values = {}
	for key, motor in pairs(self._motors) do values[key] = motor:getValue() end
	return values
end
function GroupMotor:__tostring() return "Motor(Group)" end

local Flipper = {
	SingleMotor = SingleMotor, GroupMotor = GroupMotor,
	Instant = Instant, Spring = Spring, isMotor = isMotor,
}

-- ============================================================
-- Library base table (declared early: Creator's theme functions
-- close over it, same as before).
-- ============================================================
local Library = {
	Version = "3.0.0",
	OpenFrames = {},
	Options = {},
	Themes = Themes.Names,
	Windows = {},
	Window = nil,
	Unloaded = false,
	DialogOpen = false,
	Transparency = true,
	MinimizeKeybind = nil,
	MinimizeKey = Enum.KeyCode.RightControl,
	BrandLogo = "rbxassetid://121299517968919",
}

-- ============================================================
-- Creator — instance factory + live theme registry
-- ============================================================
local Creator = {
	Registry = {},
	Signals = {},
	TransparencyMotors = {},
	DefaultProperties = {
		ScreenGui = { ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
		Frame = { BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0 },
		ScrollingFrame = {
			BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0),
			ScrollBarImageColor3 = Color3.new(0, 0, 0),
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans, Text = "", TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1, TextSize = Tokens.Text.lg,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false, Font = Enum.Font.SourceSans, Text = "",
			TextColor3 = Color3.new(0, 0, 0), TextSize = Tokens.Text.lg,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false, Font = Enum.Font.SourceSans, Text = "",
			TextColor3 = Color3.new(0, 0, 0), TextSize = Tokens.Text.lg,
		},
		ImageLabel = { BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0 },
		ImageButton = { BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0), AutoButtonColor = false },
		CanvasGroup = { BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0 },
	},
}

function Creator.AddSignal(signal, fn)
	local connected = signal:Connect(fn)
	table.insert(Creator.Signals, connected)
	return connected
end

function Creator.Disconnect()
	for i = #Creator.Signals, 1, -1 do
		local connection = table.remove(Creator.Signals, i)
		if connection.Disconnect then connection:Disconnect() end
	end
end

Creator.Themes = Themes
Creator.Theme = "Dark"

function Creator.UpdateTheme()
	if Library.Theme and Creator.Themes[Library.Theme] then
		Creator.Theme = Library.Theme
	end
	if not Creator.Themes[Creator.Theme] then Creator.Theme = "Dark" end
	for instance, object in next, Creator.Registry do
		for property, key in next, object.Properties do
			local value = Creator.GetThemeProperty(key)
			if value ~= nil then instance[property] = value end
		end
	end
end

local function lerpColor(a, b, t)
	return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end

function Creator.UpdateThemeAnimated(duration)
	duration = duration or 0.35
	if Library.Theme and Creator.Themes[Library.Theme] then Creator.Theme = Library.Theme end
	if not Creator.Themes[Creator.Theme] then Creator.Theme = "Dark" end
	local snapshots = {}
	for instance, object in next, Creator.Registry do
		snapshots[instance] = {}
		for property, key in next, object.Properties do
			local ok, current = pcall(function() return instance[property] end)
			if ok then
				local target = Creator.GetThemeProperty(key)
				if target ~= nil then
					if typeof(current) == "Color3" and typeof(target) == "Color3" then
						snapshots[instance][property] = { from = current, to = target }
					else
						pcall(function() instance[property] = target end)
					end
				end
			end
		end
	end
	local elapsed = 0
	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		elapsed = elapsed + dt
		local t = math.min(elapsed / duration, 1)
		local ease = t < 0.5 and (4 * t * t * t) or (1 - (-2 * t + 2) ^ 3 / 2)
		for instance, props in next, snapshots do
			if instance and instance.Parent then
				for property, data in next, props do
					local ok = pcall(function() instance[property] = lerpColor(data.from, data.to, ease) end)
					if not ok then snapshots[instance][property] = nil end
				end
			end
		end
		if t >= 1 then
			connection:Disconnect()
			for instance, props in next, snapshots do
				for property, data in next, props do
					pcall(function() instance[property] = data.to end)
				end
			end
		end
	end)
end

function Creator.AddThemeObject(object, properties)
	Creator.Registry[object] = { Object = object, Properties = properties }
	Creator.UpdateTheme()
	return object
end

function Creator.OverrideTag(object, properties)
	if Creator.Registry[object] then
		Creator.Registry[object].Properties = properties
		Creator.UpdateTheme()
	end
end

function Creator.GetThemeProperty(key)
	if key == "Accent" and Library.CustomAccentColor then
		return Library.CustomAccentColor
	end
	if key == "AccentGradient" then
		local accent = Library.CustomAccentColor or (Themes[Library.Theme] and Themes[Library.Theme].Accent) or Themes.Dark.Accent
		local light = Color3.new(accent.R + (1 - accent.R) * 0.4, accent.G + (1 - accent.G) * 0.4, accent.B + (1 - accent.B) * 0.4)
		return ColorSequence.new(light, accent)
	end
	local theme = Themes[Library.Theme]
	if theme and theme[key] ~= nil then return theme[key] end
	return Themes.Dark[key]
end

-- ============================================================
-- MiniMessage-style rich text ( <b>, <#ff0000>, <gradient:...>, named
-- colors, <br> ) — a nice independent text feature, kept as-is since
-- it has nothing to do with layout.
-- ============================================================
local MiniMessageColors = {
	black="#000000", dark_blue="#0000AA", dark_green="#00AA00", dark_aqua="#00AAAA",
	dark_red="#AA0000", dark_purple="#AA00AA", gold="#FFAA00", gray="#AAAAAA", grey="#AAAAAA",
	dark_gray="#555555", dark_grey="#555555", blue="#5555FF", green="#55FF55", aqua="#55FFFF",
	cyan="#55FFFF", red="#FF5555", light_purple="#FF55FF", magenta="#FF55FF", yellow="#FFFF55",
	white="#FFFFFF", reset="#FFFFFF", orange="#FFAA00", pink="#FF55FF", lime="#55FF55", brown="#AA5500",
}

local function MiniMessageToRichText(text)
	if type(text) ~= "string" or text == "" or not text:match("<[^>]+>") then return text end
	local result = text
	result = result:gsub("<br%s*/?>", "\n"):gsub("<nl>", "\n"):gsub("<newline>", "\n")
	result = result:gsub("<reset>", "</font></b></i></u></s>")
	result = result:gsub("<obfuscated>(.-)</obfuscated>", "%1"):gsub("<obfuscated>", ""):gsub("</obfuscated>", "")

	local function hexToRgb(hex)
		hex = hex:gsub("#", "")
		return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
	end
	local function rgbToHex(r, g, b) return string.format("#%02X%02X%02X", math.floor(r), math.floor(g), math.floor(b)) end
	local function interpolateColor(c1, c2, t)
		local r1, g1, b1 = hexToRgb(c1)
		local r2, g2, b2 = hexToRgb(c2)
		return rgbToHex(r1 + (r2 - r1) * t, g1 + (g2 - g1) * t, b1 + (b2 - b1) * t)
	end

	for _ = 1, 10 do
		local newResult = result:gsub("<gradient:([^>]+)>(.-)</gradient>", function(colorsStr, content)
			local colors = {}
			for m in colorsStr:gmatch("(#%x%x%x%x%x%x)") do table.insert(colors, m) end
			if #colors == 0 then for m in colorsStr:gmatch("(%x%x%x%x%x%x)") do table.insert(colors, "#" .. m) end end
			if #colors < 2 then
				if #colors == 1 then return '<font color="' .. colors[1] .. '">' .. content .. '</font>' end
				return content
			end
			local cleanText = content:gsub("<[^>]+>", "")
			local textLength = #cleanText
			if textLength == 0 then return content end
			if textLength == 1 then return '<font color="' .. colors[1] .. '">' .. content .. '</font>' end
			local out = ""
			for i = 1, textLength do
				local t = (i - 1) / (textLength - 1)
				local segments = #colors - 1
				local segSize = 1 / segments
				local segIdx = math.min(math.floor(t / segSize), segments - 1)
				local segT = (segSize > 0) and ((t - segIdx * segSize) / segSize) or 0
				local c = interpolateColor(colors[segIdx + 1], colors[math.min(segIdx + 2, #colors)], segT)
				out = out .. '<font color="' .. c .. '">' .. cleanText:sub(i, i) .. '</font>'
			end
			return out
		end)
		if newResult == result then break end
		result = newResult
	end

	result = result:gsub("<color:(#%x%x%x%x%x%x)>(.-)</color>", '<font color="%1">%2</font>')
	result = result:gsub("<color:(#%x%x%x%x%x%x)>", '<font color="%1">')
	result = result:gsub("<color:(%x%x%x%x%x%x)>(.-)</color>", function(h, c) return '<font color="#' .. h .. '">' .. c .. '</font>' end)
	result = result:gsub("<color:(%x%x%x%x%x%x)>", function(h) return '<font color="#' .. h .. '">' end)
	result = result:gsub("</color>", "</font>")
	result = result:gsub("<(#%x%x%x%x%x%x)>(.-)</#%x%x%x%x%x%x>", '<font color="%1">%2</font>')
	result = result:gsub("<(#%x%x%x%x%x%x)>", '<font color="%1">')
	result = result:gsub("</(#%x%x%x%x%x%x)>", "</font>")

	local names = {}
	for name in pairs(MiniMessageColors) do table.insert(names, name) end
	table.sort(names, function(a, b) return #a > #b end)
	for _, name in ipairs(names) do
		local hex = MiniMessageColors[name]
		result = result:gsub("<" .. name .. ">(.-)</" .. name .. ">", '<font color="' .. hex .. '">%1</font>')
		result = result:gsub("<" .. name .. ">", '<font color="' .. hex .. '">')
		result = result:gsub("</" .. name .. ">", "</font>")
	end

	result = result:gsub("<bold>(.-)</bold>", "<b>%1</b>"):gsub("<bold>", "<b>"):gsub("</bold>", "</b>")
	result = result:gsub("<italic>(.-)</italic>", "<i>%1</i>"):gsub("<italic>", "<i>"):gsub("</italic>", "</i>")
	result = result:gsub("<underlined?>(.-)</underlined?>", "<u>%1</u>"):gsub("<underlined?>", "<u>"):gsub("</underlined?>", "</u>")
	result = result:gsub("<strikethrough>(.-)</strikethrough>", "<s>%1</s>"):gsub("<strike>(.-)</strike>", "<s>%1</s>")
	result = result:gsub("<strikethrough>", "<s>"):gsub("<strike>", "<s>"):gsub("</strikethrough>", "</s>"):gsub("</strike>", "</s>")
	result = result:gsub('<font color="[^"]+"></font>', "")
	result = result:gsub("</font></font>", "</font>"):gsub("</b></b>", "</b>"):gsub("</i></i>", "</i>"):gsub("</u></u>", "</u>"):gsub("</s></s>", "</s>")
	return result
end

local TextElementConnections = {}
local function setupMiniMessageSupport(object, properties)
	if not (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then return end
	local explicitRichText = properties and properties.RichText ~= nil
	if not explicitRichText then object.RichText = true
	elseif properties.RichText == false then object.RichText = false end
	local lastText = object.Text or ""
	local converting = false
	local function convert(text)
		if type(text) ~= "string" then return text end
		if text:match('<font color="[^"]+">') then return text end
		if text:match("<[^>]+>") then
			local looksLikeMiniMessage = text:match("<%w+>") or text:match("<color:") or text:match("<#%x%x%x%x%x%x>")
				or text:match("<gradient:") or text:match("<reset>") or text:match("</%w+>") or text:match("</color>")
			if looksLikeMiniMessage then
				if not object.RichText then object.RichText = true end
				return MiniMessageToRichText(text)
			end
		end
		return text
	end
	local connection = object:GetPropertyChangedSignal("Text"):Connect(function()
		if converting then return end
		local current = object.Text or ""
		if current ~= lastText then
			local converted = convert(current)
			if converted ~= current then
				converting = true
				object.Text = converted
				lastText = converted
				converting = false
			else
				lastText = current
			end
		end
	end)
	table.insert(TextElementConnections, connection)
	if object.Text then
		local converted = convert(object.Text)
		if converted ~= object.Text then
			object.Text = converted
			lastText = converted
		end
	end
end

-- ============================================================
-- Creator.New — the instance factory every component is built from.
-- ============================================================
function Creator.New(className, properties, children)
	local object = Instance.new(className)
	for prop, value in next, Creator.DefaultProperties[className] or {} do
		object[prop] = value
	end
	local originalText = properties and properties.Text
	local internalKeys = { ThemeTag = true }
	for prop, value in next, properties or {} do
		if not internalKeys[prop] then
			if prop == "Text" and typeof(value) == "EnumItem" then value = value.Name end
			object[prop] = value
		end
	end
	if originalText and type(originalText) == "string" and originalText:match("<[^>]+>") then
		object.Text = MiniMessageToRichText(originalText)
		if properties and properties.RichText == nil then object.RichText = true end
	end
	for _, child in next, children or {} do
		if child then child.Parent = object end
	end
	if properties and properties.ThemeTag then
		Creator.AddThemeObject(object, properties.ThemeTag)
	end
	setupMiniMessageSupport(object, properties)
	return object
end

local New = Creator.New

-- Small layout helpers built on Creator.New (replace the old per-theme
-- "style registry" — there is only one style now, so these are direct).
local function Corner(key) return New("UICorner", { CornerRadius = Tokens.Corner[key or "md"] }) end
local function Stroke(props)
	props = props or {}
	if not props.Thickness then props.Thickness = Tokens.Border end
	return New("UIStroke", props)
end

function Creator.SpringMotor(initial, instance, prop, ignoreDialogCheck, resetOnThemeChange, springParams)
	springParams = springParams or { frequency = 8 }
	local motor = Flipper.SingleMotor.new(initial)
	motor:onStep(function(value) instance[prop] = value end)
	if resetOnThemeChange then table.insert(Creator.TransparencyMotors, motor) end
	local function setValue(value, ignore, overrideParams)
		if not ignoreDialogCheck and not ignore and prop == "BackgroundTransparency" and Library.DialogOpen then
			return
		end
		motor:setGoal(Flipper.Spring.new(value, overrideParams or springParams))
	end
	return motor, setValue
end

Library.Creator = Creator
Library.MiniMessageToRichText = MiniMessageToRichText

local GUI = New("ScreenGui", { Parent = LocalPlayer:WaitForChild("PlayerGui") })
Library.GUI = GUI
ProtectGui(GUI)

function Library:SafeCallback(fn, ...)
	if not fn then return end
	local ok, err = pcall(fn, ...)
	if not ok then
		local _, i = err:find(":%d+: ")
		return Library:Notify({
			Title = "Interface", Content = "Callback error",
			SubContent = i and err:sub(i + 1) or err, Duration = 5,
		})
	end
end

function Library:Round(number, factor)
	if factor == 0 then return math.floor(number) end
	number = tostring(number)
	local dot = number:find("%.")
	return dot and tonumber(number:sub(1, dot + factor)) or number
end

-- ============================================================
-- Components
-- ============================================================
local Components = {
	Assets = {
		Close   = "rbxassetid://9886659671",
		Min     = "rbxassetid://9886659276",
		Max     = "rbxassetid://9886659406",
		Restore = "rbxassetid://9886659001",
	},
}

-- Flat translucent panel: fill + hairline border. Replaces the old
-- "Acrylic" material (tiled noise textures + gradient overlay). Used
-- for the window body, dialogs, and the dropdown/keybind popouts, so
-- they all read as one consistent surface.
function Components.Surface()
	local Surface = {}
	Surface.Fill = New("Frame", {
		Name = "Fill",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 0.12,
		ThemeTag = { BackgroundColor3 = "Surface" },
	}, { Corner("lg") })
	Surface.Frame = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		Surface.Fill,
		New("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, {
			Corner("lg"),
			Stroke({ Transparency = 0.35, ThemeTag = { Color = "SurfaceBorder" } }),
		}),
	})
	return Surface
end

-- Components.Row — a single settings row: icon+title / description on
-- the left, a control on the right, a hairline divider underneath.
-- This replaces the old "translucent bordered card per element" look.
-- The returned table's field names (TitleLabel, DescLabel, LabelHolder,
-- Header, Frame, SetTitle, SetDesc, Visible, GetTitle, GetDesc, Destroy)
-- match the previous version on purpose, so every element implementation
-- below can keep using them unmodified.
-- Small per-parent counter so rows added to the same section stagger
-- their entrance instead of all popping in at once.
local RowStaggerCounters = setmetatable({}, { __mode = "k" })

Components.Element = function(Title, Desc, Parent, Hover, Options)
	Options = Options or {}
	local Row = {}

	Row.TitleLabel = New("TextLabel", {
		FontFace = Tokens.Font.medium,
		Text = Title,
		TextSize = Tokens.Text.md,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		ThemeTag = { TextColor3 = "Text" },
	})

	Row.Header = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 16),
		LayoutOrder = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
	})

	if Options.Icon then
		local iconImage = Options.Icon
		pcall(function()
			if Library.GetIcon then
				local resolved = Library:GetIcon(Options.Icon)
				if resolved then iconImage = resolved end
			end
		end)
		Row.IconImage = New("ImageLabel", {
			Image = iconImage, Size = UDim2.fromOffset(13, 13), Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
			ThemeTag = { ImageColor3 = "Accent" },
		})
		-- A small tinted chip behind the icon instead of a bare white
		-- glyph floating in the title row — gives each row a spot of
		-- color to visually latch onto.
		Row.IconChip = New("Frame", {
			Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 0.82, LayoutOrder = 0,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, { Corner("sm"), Row.IconImage })
		Row.IconChip.Parent = Row.Header
	end
	Row.TitleLabel.Parent = Row.Header

	Row.DescLabel = New("TextLabel", {
		FontFace = Tokens.Font.regular,
		Text = Desc, TextSize = Tokens.Text.sm,
		TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2,
		ThemeTag = { TextColor3 = "SubText" },
	})

	Row.LabelHolder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(Tokens.Row.PadX, 0),
		Size = UDim2.new(1, -(Tokens.Row.PadX + 18), 0, 0),
	}, {
		New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) }),
		New("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12) }),
		Row.Header,
		Row.DescLabel,
	})

	-- Each row carries its own faint resting background + rounded corners
	-- (instead of only appearing on hover), so a list of rows reads as
	-- distinct stacked blocks rather than plain floating text. Small gaps
	-- between rows (Section.Layout's Padding) do the separating instead
	-- of a hairline divider.
	Row.Frame = New("TextButton", {
		Visible = (Options.Visible == nil) or Options.Visible,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 0.95,
		Parent = Parent,
		Text = "",
		LayoutOrder = 1,
		ThemeTag = { BackgroundColor3 = "RowHover" },
	}, {
		Corner("sm"),
		Row.LabelHolder,
	})

	function Row:SetTitle(text)
		Row.TitleLabel.Text = text
		local hasTitle = (text ~= nil and text ~= "")
		Row.Header.Visible = hasTitle
		if not hasTitle and Row.IconImage then
			if not Row.DescRow then
				Row.DescRow = New("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1,
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
				})
				Row.DescRow.Parent = Row.LabelHolder
			end
			if not Row.DescIconChip then
				local descIcon = New("ImageLabel", {
					Image = Row.IconImage.Image, Size = UDim2.fromOffset(13, 13), Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ThemeTag = { ImageColor3 = "Accent" },
				})
				Row.DescIconChip = New("Frame", {
					Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 0.82, LayoutOrder = 0,
					ThemeTag = { BackgroundColor3 = "Accent" },
				}, { Corner("sm"), descIcon })
				Row.DescIconChip.Parent = Row.DescRow
			else
				Row.DescIconChip.Parent = Row.DescRow
			end
			Row.DescLabel.Parent = Row.DescRow
			Row.DescLabel.LayoutOrder = 1
		else
			if Row.DescRow then
				Row.DescRow:Destroy()
				Row.DescRow = nil
				Row.DescIconChip = nil -- the chip Frame was destroyed along with DescRow; drop the stale ref
			end
			Row.DescLabel.Parent = Row.LabelHolder
			Row.DescLabel.LayoutOrder = 2
		end
		local w = Library.Window
		if w and w.AllElements and w.AllElements[Row.Frame] then w.AllElements[Row.Frame].title = text end
	end

	function Row:Visible(bool) Row.Frame.Visible = bool end

	function Row:SetDesc(text)
		text = text or ""
		Row.DescLabel.Visible = (text ~= "")
		Row.DescLabel.Text = text
		local w = Library.Window
		if w and w.AllElements and w.AllElements[Row.Frame] then w.AllElements[Row.Frame].description = text end
	end

	function Row:GetTitle() return Row.TitleLabel.Text end
	function Row:GetDesc() return Row.DescLabel.Text end
	function Row:Destroy() Row.Frame:Destroy() end

	Row.Header.Visible = not (Title == nil or Title == "")
	Row:SetTitle(Title or "")
	Row:SetDesc(Desc)

	local w = Library.Window
	if w and w.RegisterElement then
		w.RegisterElement(Row.Frame, Title, "Element", Desc)
	end

	if Hover then
		local _, setTransparency = Creator.SpringMotor(0.95, Row.Frame, "BackgroundTransparency", false, true)
		Creator.AddSignal(Row.Frame.MouseEnter, function() setTransparency(0.86) end)
		Creator.AddSignal(Row.Frame.MouseLeave, function() setTransparency(0.95) end)
		Creator.AddSignal(Row.Frame.MouseButton1Down, function() setTransparency(0.78) end)
		Creator.AddSignal(Row.Frame.MouseButton1Up, function() setTransparency(0.86) end)
	end

	-- Staggered entrance: each row slides up + fades its background in a
	-- beat after the previous one, instead of every row just popping into
	-- existence with no motion at all.
	do
		RowStaggerCounters[Parent] = (RowStaggerCounters[Parent] or 0) + 1
		local staggerDelay = math.min((RowStaggerCounters[Parent] - 1) * 0.045, 0.4)
		local restingTransparency = Row.Frame.BackgroundTransparency
		Row.Frame.BackgroundTransparency = 1
		Row.LabelHolder.Position = UDim2.fromOffset(Tokens.Row.PadX, 8)
		task.delay(staggerDelay, function()
			if not (Row.Frame and Row.Frame.Parent) then return end
			local ti = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			TweenService:Create(Row.Frame, ti, { BackgroundTransparency = restingTransparency }):Play()
			TweenService:Create(Row.LabelHolder, ti, { Position = UDim2.fromOffset(Tokens.Row.PadX, 0) }):Play()
		end)
	end

	return Row
end

-- Components.Section — a "group": a small muted header, then its rows,
-- no bordered card box around it (that box is what made every previous
-- version, Fluent included, look the same). Collapsible, same as before.
Components.Section = function(Title, Parent, Icon)
	local Section = {}
	-- Small gap between rows: now that each row carries its own rounded
	-- background, a gap reads as the separator instead of a hairline.
	Section.Layout = New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3) })

	Section.Container = New("Frame", {
		Size = UDim2.new(1, -8, 0, 0),
		Position = UDim2.fromOffset(4, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
	}, { Section.Layout, New("UIPadding", { PaddingBottom = UDim.new(0, 6) }) })

	local Chevron = New("ImageLabel", {
		Image = "rbxassetid://10709790948",
		Size = UDim2.fromOffset(12, 12),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -Tokens.Row.PadX, 0.5, 0),
		BackgroundTransparency = 1,
		ThemeTag = { ImageColor3 = "SubText" },
	})

	local Header = New("TextButton", {
		Size = UDim2.new(1, 0, 0, Tokens.Group.HeaderHeight),
		BackgroundTransparency = 1,
		Text = "",
		Active = true,
	}, {
		New("UIPadding", { PaddingLeft = UDim.new(0, Tokens.Row.PadX) }),
		New("UIListLayout", {
			Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		Icon and New("ImageLabel", {
			Image = Icon, Size = UDim2.fromOffset(13, 13), BackgroundTransparency = 1, LayoutOrder = 1,
			ThemeTag = { ImageColor3 = "Accent" },
		}) or nil,
		New("TextLabel", {
			RichText = true, Text = Title, FontFace = Tokens.Font.semibold,
			TextSize = Tokens.Text.sm, TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1),
			BackgroundTransparency = 1, LayoutOrder = 2,
			ThemeTag = { TextColor3 = "SubText" },
		}),
		Chevron,
	})

	-- The card: a visibly distinct, rounded, softly-bordered panel that
	-- holds the header + rows, so a section reads as one grouped block
	-- instead of plain text floating in space. This is the direct
	-- response to "no framing, nothing separates one thing from another".
	local CardLayout = New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder })
	local CardStroke = Stroke({ Transparency = 0.55, ThemeTag = { Color = "SurfaceBorder" } })
	local Card = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, ThemeTag = { BackgroundColor3 = "SurfaceAlt" },
	}, {
		Corner("lg"), CardStroke,
		CardLayout, Header, Section.Container,
	})
	-- Fade the card panel in rather than having it pop into existence.
	do
		CardStroke.Transparency = 1
		task.delay(0.03, function()
			if not Card.Parent then return end
			local ti = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			TweenService:Create(Card, ti, { BackgroundTransparency = 0.55 }):Play()
			TweenService:Create(CardStroke, ti, { Transparency = 0.55 }):Play()
		end)
	end

	Section.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Tokens.Group.HeaderHeight),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 7,
		Parent = Parent,
	}, {
		New("UIPadding", { PaddingTop = UDim.new(0, Tokens.Group.Gap) }),
		New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
		Card,
	})

	Section.Collapsed = false

	function Section:SetCollapsed(collapsed)
		Section.Collapsed = collapsed
		local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		TweenService:Create(Chevron, ti, { Rotation = collapsed and -90 or 0 }):Play()
		if collapsed then
			Card.AutomaticSize = Enum.AutomaticSize.None
			TweenService:Create(Card, ti, { Size = UDim2.new(1, 0, 0, Tokens.Group.HeaderHeight) }):Play()
			task.delay(0.22, function()
				if Section.Collapsed then Section.Container.Visible = false end
			end)
		else
			Section.Container.Visible = true
			task.defer(function() Card.AutomaticSize = Enum.AutomaticSize.Y end)
		end
	end
	Creator.AddSignal(Header.MouseButton1Click, function() Section:SetCollapsed(not Section.Collapsed) end)

	local w = Library.Window
	if w and w.RegisterElement then w.RegisterElement(Section.Root, Title, "Section") end

	return Section
end

-- Small ghost/pill button used in dialogs. (Theme param from the old
-- version was unused dead code — dropped.)
Components.Button = function(Parent, IsPrimary)
	local Button = {}
	local baseBg    = IsPrimary and 0.85 or 1
	local hoverBg   = IsPrimary and 0.68 or 0.92
	local baseStroke  = 1
	local hoverStroke = IsPrimary and 1 or 0.4

	Button.Title = New("TextLabel", {
		FontFace = IsPrimary and Tokens.Font.semibold or Tokens.Font.medium,
		TextSize = Tokens.Text.md, TextTransparency = 1, TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.fromScale(1, 1),
		ThemeTag = { TextColor3 = IsPrimary and "Text" or "SubText" },
	})
	local BtnStroke = Stroke({ Transparency = 1, ThemeTag = { Color = IsPrimary and "Accent" or "InputBorder" } })
	Button.Frame = New("TextButton", {
		Size = UDim2.new(0, 0, 0, 38), Parent = Parent, BackgroundTransparency = 1,
		ThemeTag = { BackgroundColor3 = IsPrimary and "Accent" or "RowHover" },
	}, { Corner("sm"), BtnStroke, Button.Title })

	local _, SetBg = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency", true, false, { frequency = 6 })
	local _, SetStroke = Creator.SpringMotor(1, BtnStroke, "Transparency", true, false, { frequency = 6 })
	local _, SetText = Creator.SpringMotor(1, Button.Title, "TextTransparency", true, false, { frequency = 6 })

	function Button:PlayIn(delay)
		task.delay(delay or 0, function()
			if not (Button.Frame and Button.Frame.Parent) then return end
			SetBg(baseBg); SetStroke(baseStroke); SetText(0)
		end)
	end
	Creator.AddSignal(Button.Frame.MouseEnter, function() SetBg(hoverBg); SetStroke(hoverStroke) end)
	Creator.AddSignal(Button.Frame.MouseLeave, function() SetBg(baseBg); SetStroke(baseStroke) end)
	Creator.AddSignal(Button.Frame.MouseButton1Down, function() SetBg(math.min(1, hoverBg + 0.1)) end)
	Creator.AddSignal(Button.Frame.MouseButton1Up, function() SetBg(hoverBg) end)
	return Button
end

-- Generic text input with an animated focus underline. Used by the
-- Input element and the colorpicker dialog's hex/RGB fields.
Components.Textbox = function(Parent)
	local Textbox = {}
	Textbox.Input = New("TextBox", {
		FontFace = Tokens.Font.regular, TextSize = Tokens.Text.md,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
		AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(10, 0),
		ThemeTag = { TextColor3 = "Text", PlaceholderColor3 = "SubText" },
	})
	Textbox.Container = New("Frame", {
		BackgroundTransparency = 1, ClipsDescendants = true,
		Position = UDim2.new(0, 6, 0, 0), Size = UDim2.new(1, -12, 1, 0),
	}, { Textbox.Input })
	Textbox.Indicator = New("Frame", {
		Size = UDim2.new(1, -4, 0, 1), Position = UDim2.new(0, 2, 1, 0), AnchorPoint = Vector2.new(0, 1),
		ThemeTag = { BackgroundColor3 = "InputBorder" },
	})
	Textbox.Stroke = Stroke({ Transparency = 0.5, ThemeTag = { Color = "InputBorder" } })
	Textbox.Frame = New("Frame", {
		Size = UDim2.new(0, 0, 0, 32), Parent = Parent,
		ThemeTag = { BackgroundColor3 = "InputBg" },
	}, { Corner("sm"), Textbox.Stroke, Textbox.Indicator, Textbox.Container })

	local BaseStrokeTransparency = 0.5
	local _, SetStrokeTransparency = Creator.SpringMotor(BaseStrokeTransparency, Textbox.Stroke, "Transparency", true, false, { frequency = 8 })
	local _, SetIndicatorAlpha = Creator.SpringMotor(0, Textbox.Indicator, "BackgroundTransparency", true, false, { frequency = 8 })
	Textbox.SetStrokeTransparency = SetStrokeTransparency
	Textbox.BaseStrokeTransparency = BaseStrokeTransparency

	local function Update()
		local PADDING = 2
		local reveal = Textbox.Container.AbsoluteSize.X
		if not Textbox.Input:IsFocused() or Textbox.Input.TextBounds.X <= reveal - 2 * PADDING then
			Textbox.Input.Position = UDim2.new(0, PADDING, 0, 0)
		else
			local cursor = Textbox.Input.CursorPosition
			if cursor ~= -1 then
				local subtext = string.sub(Textbox.Input.Text, 1, cursor - 1)
				local width = TextService:GetTextSize(subtext, Textbox.Input.TextSize, Textbox.Input.Font, Vector2.new(math.huge, math.huge)).X
				local cursorPos = Textbox.Input.Position.X.Offset + width
				if cursorPos < PADDING then
					Textbox.Input.Position = UDim2.fromOffset(PADDING - width, 0)
				elseif cursorPos > reveal - PADDING - 1 then
					Textbox.Input.Position = UDim2.fromOffset(reveal - width - PADDING - 1, 0)
				end
			end
		end
	end
	task.spawn(Update)
	Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Update)
	Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), Update)
	Creator.AddSignal(Textbox.Input.Focused, function()
		Update()
		TweenService:Create(Textbox.Indicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, -2, 0, 2), Position = UDim2.new(0, 1, 1, 0),
		}):Play()
		SetStrokeTransparency(0.1)
		Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = "Accent" })
		Creator.OverrideTag(Textbox.Stroke, { Color = "Accent" })
	end)
	Creator.AddSignal(Textbox.Input.FocusLost, function()
		Update()
		TweenService:Create(Textbox.Indicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, -4, 0, 1), Position = UDim2.new(0, 2, 1, 0),
		}):Play()
		SetStrokeTransparency(BaseStrokeTransparency)
		Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = "InputBorder" })
		Creator.OverrideTag(Textbox.Stroke, { Color = "InputBorder" })
	end)
	return Textbox
end

-- Slim 44px header: icon + title/subtitle on the left, window controls
-- on the right. (Old version used a 52px bar with an accent-filled
-- logo chip; this drops the chip for a plain tinted icon and tightens
-- the height.)
Components.TitleBar = function(Config)
	local TitleBar = {}
	local AddSignal = Creator.AddSignal

	local function CtrlButton(icon, parent, callback)
		local Button = { Callback = callback or function() end }
		Button.Frame = New("TextButton", {
			Size = UDim2.fromOffset(28, 28), BackgroundTransparency = 1, Parent = parent, Text = "",
			ThemeTag = { BackgroundColor3 = "RowHover" },
		}, {
			Corner("sm"),
			New("ImageLabel", {
				Name = "Icon", Image = icon, Size = UDim2.fromOffset(13, 13), Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
				ThemeTag = { ImageColor3 = "SubText" },
			}),
		})
		local _, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")
		AddSignal(Button.Frame.MouseEnter, function() SetTransparency(0.88) end)
		AddSignal(Button.Frame.MouseLeave, function() SetTransparency(1, true) end)
		AddSignal(Button.Frame.MouseButton1Down, function() SetTransparency(0.78) end)
		AddSignal(Button.Frame.MouseButton1Up, function() SetTransparency(0.88) end)
		AddSignal(Button.Frame.MouseButton1Click, function() Button.Callback() end)
		function Button.SetCallback(fn) Button.Callback = fn end
		return Button
	end

	TitleBar.Frame = New("Frame", {
		Size = UDim2.new(1, 0, 0, Tokens.Header.Height),
		BackgroundTransparency = 1, Active = true, Parent = Config.Parent,
	}, {
		New("Frame", {
			Name = "LeftSection", Size = UDim2.new(1, -140, 1, 0), BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			New("UIPadding", { PaddingLeft = UDim.new(0, 14) }),
			Config.Icon and New("ImageLabel", {
				Image = (Config.Icon == true) and Library.BrandLogo or Config.Icon,
				Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, LayoutOrder = 1,
				ThemeTag = { ImageColor3 = "Accent" },
			}) or nil,
			New("Frame", {
				Name = "TextStack", Size = UDim2.fromScale(0, 1), AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1, LayoutOrder = Config.Icon and 2 or 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
				New("TextLabel", {
					RichText = true, Text = Config.Title, FontFace = Tokens.Font.semibold,
					TextSize = Tokens.Text.md, TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.fromScale(0, 0), AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1, LayoutOrder = 1, ThemeTag = { TextColor3 = "Text" },
				}),
				(Config.SubTitle or Config.Discord) and New("Frame", {
					Name = "SubTitleRow", Size = UDim2.fromScale(0, 0), AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1, LayoutOrder = 2,
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
					Config.SubTitle and New("TextLabel", {
						Name = "SubTitleText", RichText = true, Text = Config.SubTitle, TextTransparency = 0.45,
						FontFace = Tokens.Font.regular, TextSize = Tokens.Text.xs, TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.fromScale(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1,
						LayoutOrder = 1, ThemeTag = { TextColor3 = "Text" },
					}) or nil,
					(Config.SubTitle and Config.Discord) and New("TextLabel", {
						Text = "•", TextTransparency = 0.65, FontFace = Tokens.Font.regular, TextSize = Tokens.Text.xs,
						Size = UDim2.fromScale(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1,
						LayoutOrder = 2, ThemeTag = { TextColor3 = "SubText" },
					}) or nil,
					Config.Discord and New("TextButton", {
						Name = "DiscordLabel", Text = Config.DiscordLabel or Config.Discord, AutoButtonColor = false,
						FontFace = Tokens.Font.regular, TextSize = Tokens.Text.xs, TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = Color3.fromRGB(88, 160, 255), Size = UDim2.fromScale(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, LayoutOrder = 3,
					}) or nil,
					Config.Discord and New("ImageButton", {
						Name = "DiscordCopyIcon", Image = Library:GetIcon("copy"), Size = UDim2.fromOffset(12, 12),
						BackgroundTransparency = 1, LayoutOrder = 4, ImageColor3 = Color3.fromRGB(88, 160, 255),
					}) or nil,
				}) or nil,
			}),
		}),
		New("Frame", {
			Name = "RightSection", Size = UDim2.new(0, 120, 1, 0), AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -8, 0, 0), BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 4), FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),
		}),
	})

	local rightSection = TitleBar.Frame.RightSection
	if Config.Discord then
		local subRow = TitleBar.Frame.LeftSection.TextStack:FindFirstChild("SubTitleRow")
		local discordLabel = subRow and subRow:FindFirstChild("DiscordLabel")
		local discordIcon = subRow and subRow:FindFirstChild("DiscordCopyIcon")
		local function CopyDiscordLink()
			pcall(function()
				if setclipboard then setclipboard(Config.Discord) elseif toclipboard then toclipboard(Config.Discord) end
			end)
			if discordIcon then
				discordIcon.Image = Library:GetIcon("clipboard-check")
				task.delay(1.2, function()
					if discordIcon and discordIcon.Parent then discordIcon.Image = Library:GetIcon("copy") end
				end)
			end
			Library:Notify({ Title = "Discord", Content = "Copied the Discord link to your clipboard.", Duration = 3 })
		end
		if discordLabel then AddSignal(discordLabel.MouseButton1Click, CopyDiscordLink) end
		if discordIcon then AddSignal(discordIcon.MouseButton1Click, CopyDiscordLink) end
	end

	TitleBar.MinButton = CtrlButton(Components.Assets.Min, rightSection, function() Library.Window:Minimize() end)
	TitleBar.MaxButton = CtrlButton(Components.Assets.Max, rightSection, function() Config.Window.Maximize(not Config.Window.Maximized) end)
	TitleBar.CloseButton = CtrlButton(Components.Assets.Close, rightSection, function()
		Library.Window:Dialog({
			Title = "Close", Content = "Are you sure you want to unload the interface?",
			Buttons = { { Title = "Yes", Callback = function() Library:Destroy() end }, { Title = "No" } },
		})
	end)
	return TitleBar
end

Components.Dialog = (function()
	local Dialog = { Window = nil }
	function Dialog:Init(Window) Dialog.Window = Window; return Dialog end

	function Dialog:Create()
		local NewDialog = { Buttons = 0, ButtonList = {} }

		NewDialog.TintFrame = New("TextButton", {
			Text = "", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1, Parent = Dialog.Window.Root,
		}, { Corner("lg") })
		local _, TintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true, false, { frequency = 5.5 })

		NewDialog.ButtonHolder = New("Frame", {
			Size = UDim2.new(1, -56, 1, -32), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 12), FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})
		NewDialog.ButtonHolderFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 76), Position = UDim2.new(0, 0, 1, -76), BackgroundTransparency = 1,
		}, {
			New("Frame", {
				Size = UDim2.new(1, -56, 0, 1), Position = UDim2.fromScale(0.5, 0), AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 0.4, ThemeTag = { BackgroundColor3 = "Divider" },
			}),
			NewDialog.ButtonHolder,
		})

		NewDialog.AccentLine = New("Frame", {
			Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 0.25, BorderSizePixel = 0,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		})

		NewDialog.CloseX = New("TextButton", {
			Text = "×", FontFace = Tokens.Font.medium, TextSize = Tokens.Text.lg, TextTransparency = 0.35,
			AutoButtonColor = false, Size = UDim2.fromOffset(26, 26), AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -14, 0, 14), BackgroundTransparency = 1,
			ThemeTag = { TextColor3 = "SubText", BackgroundColor3 = "RowHover" },
		}, { Corner("pill") })
		local _, SetCloseXBg = Creator.SpringMotor(1, NewDialog.CloseX, "BackgroundTransparency", true)
		local _, SetCloseXText = Creator.SpringMotor(0.35, NewDialog.CloseX, "TextTransparency", true)
		Creator.AddSignal(NewDialog.CloseX.MouseEnter, function() SetCloseXBg(0.9); SetCloseXText(0) end)
		Creator.AddSignal(NewDialog.CloseX.MouseLeave, function() SetCloseXBg(1); SetCloseXText(0.35) end)

		NewDialog.Title = New("TextLabel", {
			FontFace = Tokens.Font.semibold, Text = "Dialog", TextSize = Tokens.Text.title,
			TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = true,
			Size = UDim2.new(1, -56, 0, 28), Position = UDim2.fromOffset(28, 40), BackgroundTransparency = 1,
			ThemeTag = { TextColor3 = "Text" },
		})

		NewDialog.Scale = New("UIScale", { Scale = 1 })
		local _, Scale = Creator.SpringMotor(1.04, NewDialog.Scale, "Scale", false, false, { frequency = 3.8, dampingRatio = 0.9 })

		NewDialog.SurfaceMat = Components.Surface()

		NewDialog.Root = New("CanvasGroup", {
			Size = UDim2.fromOffset(340, 200), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			GroupTransparency = 1, BackgroundTransparency = 1, Parent = NewDialog.TintFrame,
		}, {
			NewDialog.SurfaceMat.Frame, Corner("lg"), NewDialog.Scale,
			NewDialog.AccentLine, NewDialog.Title, NewDialog.ButtonHolderFrame, NewDialog.CloseX,
		})

		local _, RootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency", false, false, { frequency = 5 })
		function NewDialog:Open()
			Library.DialogOpen = true
			NewDialog.Scale.Scale = 1.04
			TintTransparency(0.85)
			RootTransparency(0)
			Scale(1)
			for i, Btn in ipairs(NewDialog.ButtonList) do
				Btn:PlayIn(0.08 + (i - 1) * 0.05)
			end
		end
		function NewDialog:Close()
			Library.DialogOpen = false
			TintTransparency(1)
			RootTransparency(1)
			Scale(1.02)
			task.wait(0.15)
			NewDialog.TintFrame:Destroy()
		end
		Creator.AddSignal(NewDialog.CloseX.MouseButton1Click, function() pcall(function() NewDialog:Close() end) end)

		function NewDialog:SetIcon(Glyph)
			if Glyph and NewDialog.Title then NewDialog.Title.Text = Glyph .. "  " .. NewDialog.Title.Text end
		end

		function NewDialog:Button(Title, Callback, IsPrimary)
			NewDialog.Buttons = NewDialog.Buttons + 1
			Title = Title or "Button"
			Callback = Callback or function() end
			local Button = Components.Button(NewDialog.ButtonHolder, IsPrimary == true)
			Button.Title.Text = Title
			for _, Btn in next, NewDialog.ButtonHolder:GetChildren() do
				if Btn:IsA("TextButton") then
					Btn.Size = UDim2.new(1 / NewDialog.Buttons, -(((NewDialog.Buttons - 1) * 12) / NewDialog.Buttons), 0, 38)
				end
			end
			Creator.AddSignal(Button.Frame.MouseButton1Click, function()
				Library:SafeCallback(Callback)
				pcall(function() NewDialog:Close() end)
			end)
			table.insert(NewDialog.ButtonList, Button)
			return Button
		end
		return NewDialog
	end
	return Dialog
end)()

-- Toast, bottom-right. (Dropped ~150 lines of Minecraft-texture /
-- pixel-bevel special-casing that lived here before — dead weight
-- once the pixel-style variant was removed.)
Components.Notification = (function()
	local Spring = Flipper.Spring.new
	local TypeColors = {
		info = Color3.fromRGB(96, 205, 255), success = Color3.fromRGB(80, 220, 120),
		warning = Color3.fromRGB(255, 200, 60), error = Color3.fromRGB(255, 80, 80),
		default = Color3.fromRGB(160, 120, 255),
	}
	local TypeIcons = { info = "ℹ️", success = "✅", warning = "⚠️", error = "❌", default = "🔔" }
	local Notification = {}

	function Notification:Init(GUI)
		Library.ActiveNotifications = Library.ActiveNotifications or {}
		Notification.Holder = New("Frame", {
			Position = UDim2.new(1, -20, 1, -20), Size = UDim2.new(0, 320, 1, -20),
			AnchorPoint = Vector2.new(1, 1), BackgroundTransparency = 1, Parent = GUI,
		}, {
			New("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 10),
			}),
		})
	end

	function Notification:New(Config)
		Config.Title = Config.Title or "Notification"
		Config.Content = Config.Content or ""
		Config.SubContent = Config.SubContent or ""
		Config.Type = Config.Type or "default"
		local accentColor = TypeColors[Config.Type] or Creator.GetThemeProperty("Accent") or TypeColors.default
		local iconText = Config.Icon or TypeIcons[Config.Type] or TypeIcons.default
		local NewNotification = { Closed = false }

		NewNotification.SurfaceMat = Components.Surface()

		local IconChip = New("Frame", {
			Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(14, 12),
			BackgroundColor3 = accentColor, BackgroundTransparency = 0.82,
		}, {
			Corner("md"),
			New("TextLabel", {
				Text = iconText, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
				TextSize = Tokens.Text.icon, TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
			}),
		})

		NewNotification.Title = New("TextLabel", {
			Position = UDim2.new(0, 54, 0, 12), Text = Config.Title, RichText = true,
			TextSize = Tokens.Text.md, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
			Size = UDim2.new(1, -80, 0, 16), TextWrapped = true, BackgroundTransparency = 1,
			FontFace = Tokens.Font.bold, TextColor3 = accentColor,
		})

		NewNotification.ContentLabel = New("TextLabel", {
			FontFace = Tokens.Font.medium, Text = Config.Content, TextSize = Tokens.Text.sm,
			TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, TextWrapped = true,
			Visible = Config.Content ~= "", ThemeTag = { TextColor3 = "Text" },
		})
		NewNotification.SubContentLabel = New("TextLabel", {
			FontFace = Tokens.Font.medium, Text = Config.SubContent, TextSize = Tokens.Text.xs,
			TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, TextWrapped = true,
			Visible = Config.SubContent ~= "", ThemeTag = { TextColor3 = "SubText" },
		})
		NewNotification.LabelHolder = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
			Position = UDim2.new(0, 54, 0, 32), Size = UDim2.new(1, -68, 0, 0),
		}, {
			New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) }),
			NewNotification.ContentLabel, NewNotification.SubContentLabel,
		})

		NewNotification.CloseButton = New("TextButton", {
			Text = "", Position = UDim2.new(1, -10, 0, 10), Size = UDim2.fromOffset(18, 18),
			AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1,
			ThemeTag = { BackgroundColor3 = "RowHover" },
		}, {
			Corner("pill"),
			New("ImageLabel", {
				Image = Components.Assets.Close, Size = UDim2.fromOffset(9, 9), Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ThemeTag = { ImageColor3 = "SubText" },
			}),
		})
		local _, SetCloseBg = Creator.SpringMotor(1, NewNotification.CloseButton, "BackgroundTransparency", true)
		Creator.AddSignal(NewNotification.CloseButton.MouseEnter, function() SetCloseBg(0.85) end)
		Creator.AddSignal(NewNotification.CloseButton.MouseLeave, function() SetCloseBg(1) end)

		local ProgressTrack = New("Frame", {
			Size = UDim2.new(1, -16, 0, 2), Position = UDim2.new(0, 8, 1, -6),
			BackgroundTransparency = 0.7, BorderSizePixel = 0, ThemeTag = { BackgroundColor3 = "Divider" },
		}, { Corner("pill") })
		local ProgressFill = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = accentColor, BorderSizePixel = 0, Parent = ProgressTrack,
		}, { Corner("pill") })

		NewNotification.RootStroke = Stroke({ Transparency = 0.55, Color = accentColor })

		NewNotification.Root = New("Frame", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromScale(1, 0),
		}, {
			NewNotification.SurfaceMat.Frame, Corner("lg"), NewNotification.RootStroke,
			IconChip, NewNotification.Title, NewNotification.CloseButton, NewNotification.LabelHolder, ProgressTrack,
		})

		NewNotification.Holder = New("Frame", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 200), Parent = Notification.Holder,
		}, { NewNotification.Root })

		local RootMotor = Flipper.GroupMotor.new({ Scale = 1, Offset = 70 })
		RootMotor:onStep(function(v) NewNotification.Root.Position = UDim2.new(v.Scale, v.Offset, 0, 0) end)
		Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function() NewNotification:Close() end)

		function NewNotification:Open()
			local contentH = NewNotification.LabelHolder.AbsoluteSize.Y
			local totalH = math.max(56, 36 + contentH + 14) + 10
			NewNotification.Holder.Size = UDim2.new(1, 0, 0, totalH)
			RootMotor:setGoal({ Scale = Spring(0, { frequency = 6 }), Offset = Spring(0, { frequency = 6 }) })
			if Config.Duration and Config.Duration > 0 then
				local steps = Config.Duration * 20
				task.spawn(function()
					for i = 1, steps do
						if NewNotification.Closed then break end
						local pct = 1 - (i / steps)
						TweenService:Create(ProgressFill, TweenInfo.new(1 / 20, Enum.EasingStyle.Linear), { Size = UDim2.new(pct, 0, 1, 0) }):Play()
						task.wait(1 / 20)
					end
				end)
			else
				ProgressTrack.Visible = false
			end
		end
		function NewNotification:Close()
			if NewNotification.Closed then return end
			NewNotification.Closed = true
			for i, notif in pairs(Library.ActiveNotifications or {}) do
				if notif == NewNotification then table.remove(Library.ActiveNotifications, i); break end
			end
			task.spawn(function()
				RootMotor:setGoal({ Scale = Spring(1, { frequency = 6 }), Offset = Spring(70, { frequency = 6 }) })
				task.wait(0.35)
				NewNotification.Holder:Destroy()
			end)
		end
		table.insert(Library.ActiveNotifications, NewNotification)
		NewNotification:Open()
		if Config.Duration then task.delay(Config.Duration, function() NewNotification:Close() end) end
		return NewNotification
	end
	return Notification
end)()
Components.Notification:Init(GUI)

-- Components.Tab — top-level navigation. This is the component most
-- responsible for the new structure: instead of a labeled sidebar list
-- (Fluent's signature look), tabs are icon-only buttons in a slim rail,
-- with a floating tooltip on hover and a Discord-style accent pill that
-- glides to the active icon. Sub-tabs (pills inside a tab's content)
-- keep the same slide-transition behavior as before, just restyled.
Components.Tab = (function()
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local Components = Components
	local TabModule = {
		Window = nil, Tabs = {}, Containers = {}, SelectedTab = 0, TabCount = 0,
		AnimationTask = nil, CurrentAnimationTab = 0,
	}

	function TabModule:Init(Window) TabModule.Window = Window; return TabModule end
	function TabModule:GetCurrentTabPos()
		local holderPos = TabModule.Window.TabHolder.AbsolutePosition.Y
		local tabPos = TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y
		return tabPos - holderPos
	end

	-- One shared tooltip, reused by every rail icon.
	local Tooltip
	local function GetTooltip()
		if Tooltip then return Tooltip end
		Tooltip = New("Frame", {
			Name = "RailTooltip", BackgroundTransparency = 0, Visible = false, ZIndex = 1000,
			AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 28), Parent = Library.GUI,
			ThemeTag = { BackgroundColor3 = "Surface" },
		}, {
			Corner("sm"), Stroke({ Transparency = 0.4, ThemeTag = { Color = "SurfaceBorder" } }),
			New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
			New("TextLabel", {
				Name = "Label", FontFace = Tokens.Font.medium, TextSize = Tokens.Text.sm,
				Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
				ThemeTag = { TextColor3 = "Text" },
			}),
		})
		return Tooltip
	end
	local function ShowTooltip(button, text)
		local tip = GetTooltip()
		tip.Label.Text = text
		local pos = button.AbsolutePosition
		local size = button.AbsoluteSize
		tip.Position = UDim2.fromOffset(pos.X + size.X + 8, pos.Y + size.Y / 2 - 14)
		tip.Visible = true
	end
	local function HideTooltip() if Tooltip then Tooltip.Visible = false end end

	function TabModule:New(Title, Icon, Parent)
		local Window = TabModule.Window
		local Elements = Library.Elements
		TabModule.TabCount = TabModule.TabCount + 1
		local TabIndex = TabModule.TabCount
		local Tab = { Selected = false, Name = Title, Type = "Tab" }

		local resolvedIcon = Library:GetIcon(Icon)
		if resolvedIcon and resolvedIcon ~= "" then Icon = resolvedIcon end

		Tab.IconImage = New("ImageLabel", {
			Size = UDim2.fromOffset(18, 18), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1, Image = Icon or "", ThemeTag = { ImageColor3 = "SubText" },
		})
		Tab.Frame = New("TextButton", {
			Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1, Parent = Parent, Text = "",
			LayoutOrder = TabIndex, ThemeTag = { BackgroundColor3 = "Accent" },
		}, { Corner("md"), Tab.IconImage })

		Tab.ContainerAnim = New("CanvasGroup", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, GroupTransparency = 0,
			Parent = Window.ContainerHolder, Visible = false, Position = UDim2.fromOffset(0, 0),
		})
		local ContainerLayout = New("UIListLayout", { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder })
		Tab.ContainerFrame = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = Tab.ContainerAnim, Visible = true,
			ScrollBarImageTransparency = 0.7, ScrollBarThickness = 3, BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
			ThemeTag = { ScrollBarImageColor3 = "SubText" },
		}, {
			ContainerLayout,
			New("UIPadding", {
				PaddingRight = UDim.new(0, 12), PaddingLeft = UDim.new(0, 4),
				PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 16),
			}),
		})

		Tab.ContainerXMotor = Flipper.SingleMotor.new(0)
		Tab.ContainerTransparencyMotor = Flipper.SingleMotor.new(0)
		Tab.ContainerXMotor:onStep(function(v) if Tab.ContainerAnim.Parent then Tab.ContainerAnim.Position = UDim2.fromOffset(v, 0) end end)
		Tab.ContainerTransparencyMotor:onStep(function(v) if Tab.ContainerAnim.Parent then Tab.ContainerAnim.GroupTransparency = v end end)
		Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
		end)

		local _, SetBg = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")
		local function ApplyRailState()
			if Tab.Selected then
				SetBg(0.85)
				Creator.OverrideTag(Tab.IconImage, { ImageColor3 = "Accent" })
			else
				SetBg(1)
				Creator.OverrideTag(Tab.IconImage, { ImageColor3 = "SubText" })
			end
		end
		Creator.AddSignal(Tab.Frame.MouseEnter, function()
			if not Tab.Selected then SetBg(0.92) end
			ShowTooltip(Tab.Frame, Title)
		end)
		Creator.AddSignal(Tab.Frame.MouseLeave, function() ApplyRailState(); HideTooltip() end)
		Creator.AddSignal(Tab.Frame.MouseButton1Down, function() SetBg(0.8) end)
		Creator.AddSignal(Tab.Frame.MouseButton1Up, function() if not Tab.Selected then SetBg(0.92) end end)
		Creator.AddSignal(Tab.Frame.MouseButton1Click, function() TabModule:SelectTab(TabIndex) end)
		Tab.ApplyRailState = ApplyRailState

		TabModule.Containers[TabIndex] = Tab.ContainerAnim
		TabModule.Tabs[TabIndex] = Tab
		Tab.Container = Tab.ContainerFrame
		Tab.ScrollFrame = Tab.Container
		Tab.SubTabs, Tab.SubTabContainers, Tab.SelectedSubTab, Tab.SubTabCount, Tab.SubTabHolder = {}, {}, 0, 0, nil

		function Tab:AddSubTab(SubTitle, SubIcon)
			self.SubTabCount = self.SubTabCount + 1
			local SubTabIndex = self.SubTabCount
			if not self.SubTabHolder then
				local SubTabListLayout = New("UIListLayout", {
					Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
				})
				self.SubTabHolder = New("ScrollingFrame", {
					Size = UDim2.new(1, -8, 0, 36), Position = UDim2.fromOffset(4, 4), BackgroundTransparency = 1,
					Parent = self.ContainerFrame, ScrollingDirection = Enum.ScrollingDirection.X,
					ScrollBarThickness = 0, CanvasSize = UDim2.fromScale(0, 1), BorderSizePixel = 0,
				}, { SubTabListLayout })
				Creator.AddSignal(SubTabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					self.SubTabHolder.CanvasSize = UDim2.new(0, SubTabListLayout.AbsoluteContentSize.X, 0, 36)
				end)
				self.SubTabContainerHolder = New("Frame", {
					Size = UDim2.new(1, -8, 1, -48), Position = UDim2.fromOffset(4, 44),
					BackgroundTransparency = 1, ClipsDescendants = true, Parent = self.ContainerFrame,
				})
			end
			local subIcon = Library:GetIcon(SubIcon)
			if subIcon and subIcon ~= "" then SubIcon = subIcon else SubIcon = nil end

			local SubStroke = Stroke({ Transparency = 1, ThemeTag = { Color = "Accent" } })
			local SubTabButton = New("TextButton", {
				Size = UDim2.new(0, 0, 0, 30), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
				Parent = self.SubTabHolder, Text = "", ThemeTag = { BackgroundColor3 = "Accent" },
			}, {
				Corner("sm"), SubStroke,
				New("UIListLayout", {
					Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
					PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
				}),
				SubIcon and New("ImageLabel", {
					Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, Image = SubIcon, LayoutOrder = 1,
					ThemeTag = { ImageColor3 = "Text" },
				}) or nil,
				New("TextLabel", {
					Text = SubTitle, RichText = true, FontFace = Tokens.Font.medium, TextSize = Tokens.Text.sm,
					TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
					Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
					LayoutOrder = 2, ThemeTag = { TextColor3 = "Text" },
				}),
			})

			local SubTabContainerAnim = New("CanvasGroup", {
				Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, GroupTransparency = 0,
				Parent = self.SubTabContainerHolder, Visible = false, Position = UDim2.fromOffset(0, 0),
			})
			local SubTabContainer = New("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = SubTabContainerAnim, Visible = true,
				ScrollBarImageTransparency = 0.7, ScrollBarThickness = 3, BorderSizePixel = 0,
				CanvasSize = UDim2.fromScale(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
				ThemeTag = { ScrollBarImageColor3 = "SubText" },
			}, {
				New("UIListLayout", { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder }),
				New("UIPadding", { PaddingRight = UDim.new(0, 10), PaddingLeft = UDim.new(0, 1), PaddingBottom = UDim.new(0, 16) }),
			})
			local SubTabLayout = SubTabContainer.UIListLayout
			Creator.AddSignal(SubTabLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				SubTabContainer.CanvasSize = UDim2.new(0, 0, 0, SubTabLayout.AbsoluteContentSize.Y + 2)
			end)

			local SubTabXMotor = Flipper.SingleMotor.new(0)
			local SubTabTransparencyMotor = Flipper.SingleMotor.new(0)
			SubTabXMotor:onStep(function(v) if SubTabContainerAnim.Parent then SubTabContainerAnim.Position = UDim2.fromOffset(v, 0) end end)
			SubTabTransparencyMotor:onStep(function(v) if SubTabContainerAnim.Parent then SubTabContainerAnim.GroupTransparency = v end end)
			local _, SubSetBg = Creator.SpringMotor(1, SubTabButton, "BackgroundTransparency")
			local function UpdateSubTabAppearance()
				if self.SelectedSubTab == SubTabIndex then SubSetBg(0.85); SubStroke.Transparency = 0.4
				else SubSetBg(1); SubStroke.Transparency = 1 end
			end
			Creator.AddSignal(SubTabButton.MouseEnter, function() if self.SelectedSubTab ~= SubTabIndex then SubSetBg(0.92) end end)
			Creator.AddSignal(SubTabButton.MouseLeave, UpdateSubTabAppearance)
			Creator.AddSignal(SubTabButton.MouseButton1Down, function() SubSetBg(0.8) end)
			Creator.AddSignal(SubTabButton.MouseButton1Up, UpdateSubTabAppearance)
			UpdateSubTabAppearance()
			Creator.AddSignal(SubTabButton.MouseButton1Click, function() self:SelectSubTab(SubTabIndex) end)

			local SubTab = {
				Type = "SubTab", Name = SubTitle, Button = SubTabButton, Container = SubTabContainer,
				ScrollFrame = SubTabContainer, ContainerAnim = SubTabContainerAnim,
				XMotor = SubTabXMotor, TransparencyMotor = SubTabTransparencyMotor, SetTransparency = SubSetBg, Selected = false,
			}
			self.SubTabs[SubTabIndex] = SubTab
			self.SubTabContainers[SubTabIndex] = SubTabContainerAnim
			if self.SubTabCount == 1 then self:SelectSubTab(SubTabIndex) end

			function SubTab:AddSection(SectionTitle, SectionIcon)
				local Section = { Type = "Section" }
				local icon = Library:GetIcon(SectionIcon)
				local SectionFrame = Components.Section(SectionTitle, SubTab.Container, (icon ~= "" and icon) or nil)
				Section.Container = SectionFrame.Container
				Section.ScrollFrame = SubTab.Container
				setmetatable(Section, Elements)
				return Section
			end
			setmetatable(SubTab, Elements)
			return SubTab
		end

		function Tab:SelectSubTab(SubTabIndex)
			if self.SelectedSubTab == SubTabIndex then return end
			local PreviousSubTab = self.SelectedSubTab
			local Direction = (PreviousSubTab > 0 and SubTabIndex > PreviousSubTab) and 1 or -1
			if PreviousSubTab == 0 then Direction = 0 end
			local ContainerSize = self.SubTabContainerHolder and self.SubTabContainerHolder.AbsoluteSize.X or 500
			local SlideDistance = math.min(ContainerSize * 0.15, 60)
			self.SelectedSubTab = SubTabIndex
			for idx, SubTabObj in next, self.SubTabs do
				SubTabObj.Selected = (idx == SubTabIndex)
				if idx == SubTabIndex then SubTabObj.SetTransparency(0.85) else SubTabObj.SetTransparency(1) end
				local stroke = SubTabObj.Button:FindFirstChildOfClass("UIStroke")
				if stroke then stroke.Transparency = (idx == SubTabIndex) and 0.4 or 1 end
			end
			if PreviousSubTab > 0 and PreviousSubTab ~= SubTabIndex and self.SubTabs[PreviousSubTab] then
				local OldSubTab, NewSubTab = self.SubTabs[PreviousSubTab], self.SubTabs[SubTabIndex]
				for idx, Container in next, self.SubTabContainers do
					if Container and idx ~= PreviousSubTab and idx ~= SubTabIndex then
						Container.Visible = false; Container.Position = UDim2.fromOffset(0, 0); Container.GroupTransparency = 0
						if self.SubTabs[idx] then
							pcall(function() self.SubTabs[idx].XMotor:setGoal(Instant(0)); self.SubTabs[idx].TransparencyMotor:setGoal(Instant(0)) end)
						end
					end
				end
				OldSubTab.ContainerAnim.Visible = true; OldSubTab.ContainerAnim.Position = UDim2.fromOffset(0, 0); OldSubTab.ContainerAnim.GroupTransparency = 0
				pcall(function() OldSubTab.XMotor:setGoal(Instant(0)); OldSubTab.TransparencyMotor:setGoal(Instant(0)) end)
				NewSubTab.ContainerAnim.Visible = true
				NewSubTab.ContainerAnim.Position = UDim2.fromOffset(Direction * SlideDistance, 0)
				NewSubTab.ContainerAnim.GroupTransparency = 1
				pcall(function() NewSubTab.XMotor:setGoal(Instant(Direction * SlideDistance)); NewSubTab.TransparencyMotor:setGoal(Instant(1)) end)
				task.wait()
				pcall(function()
					OldSubTab.XMotor:setGoal(Spring(-Direction * SlideDistance, { frequency = 4, dampingRatio = 0.7 }))
					OldSubTab.TransparencyMotor:setGoal(Spring(1, { frequency = 4, dampingRatio = 0.7 }))
					NewSubTab.XMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
					NewSubTab.TransparencyMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
				end)
				task.spawn(function()
					task.wait(0.5)
					if self.SelectedSubTab == SubTabIndex and self.SubTabs[PreviousSubTab] then
						local oc = self.SubTabs[PreviousSubTab].ContainerAnim
						if oc and oc.Parent then oc.Visible = false; oc.Position = UDim2.fromOffset(0, 0); oc.GroupTransparency = 0 end
						pcall(function() OldSubTab.XMotor:setGoal(Instant(0)); OldSubTab.TransparencyMotor:setGoal(Instant(0)) end)
					end
				end)
			else
				for idx, Container in next, self.SubTabContainers do
					if Container then
						Container.Visible = (idx == SubTabIndex); Container.Position = UDim2.fromOffset(0, 0); Container.GroupTransparency = 0
						if self.SubTabs[idx] then pcall(function() self.SubTabs[idx].XMotor:setGoal(Instant(0)); self.SubTabs[idx].TransparencyMotor:setGoal(Instant(0)) end) end
					end
				end
			end
		end

		function Tab:AddSection(SectionTitle, SectionIcon)
			if self.SelectedSubTab > 0 and self.SubTabs[self.SelectedSubTab] then
				return self.SubTabs[self.SelectedSubTab]:AddSection(SectionTitle, SectionIcon)
			end
			local Section = { Type = "Section" }
			local icon = Library:GetIcon(SectionIcon)
			local SectionFrame = Components.Section(SectionTitle, Tab.Container, (icon ~= "" and icon) or nil)
			Section.Container = SectionFrame.Container
			Section.ScrollFrame = Tab.Container
			setmetatable(Section, Elements)
			return Section
		end
		setmetatable(Tab, Elements)
		return Tab
	end

	function TabModule:SelectTab(Tab)
		if TabModule.SelectedTab == Tab then return end
		if TabModule.AnimationTask then task.cancel(TabModule.AnimationTask); TabModule.AnimationTask = nil end
		local Window = TabModule.Window
		local PreviousTab = TabModule.SelectedTab
		local Direction = (PreviousTab > 0 and Tab > PreviousTab) and 1 or -1
		if PreviousTab == 0 then Direction = 0 end
		local ContainerSize = Window.ContainerCanvas and Window.ContainerCanvas.AbsoluteSize.X or 500
		local SlideDistance = math.min(ContainerSize * 0.15, 60)
		TabModule.SelectedTab = Tab
		TabModule.CurrentAnimationTab = Tab
		for _, TabObject in next, TabModule.Tabs do TabObject.Selected = false; TabObject.ApplyRailState() end
		TabModule.Tabs[Tab].Selected = true
		TabModule.Tabs[Tab].ApplyRailState()
		Window.ContentTitle.Text = TabModule.Tabs[Tab].Name
		Window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), { frequency = 6 }))
		if PreviousTab > 0 and PreviousTab ~= Tab and TabModule.Tabs[PreviousTab] then
			local OldTab, NewTab = TabModule.Tabs[PreviousTab], TabModule.Tabs[Tab]
			for idx, Container in next, TabModule.Containers do
				if Container and idx ~= PreviousTab and idx ~= Tab then
					Container.Visible = false; Container.Position = UDim2.fromOffset(0, 0); Container.GroupTransparency = 0
					if TabModule.Tabs[idx] then
						pcall(function() TabModule.Tabs[idx].ContainerXMotor:setGoal(Instant(0)); TabModule.Tabs[idx].ContainerTransparencyMotor:setGoal(Instant(0)) end)
					end
				end
			end
			OldTab.ContainerAnim.Visible = true; OldTab.ContainerAnim.Position = UDim2.fromOffset(0, 0); OldTab.ContainerAnim.GroupTransparency = 0
			pcall(function() OldTab.ContainerXMotor:setGoal(Instant(0)); OldTab.ContainerTransparencyMotor:setGoal(Instant(0)) end)
			NewTab.ContainerAnim.Visible = true
			NewTab.ContainerAnim.Position = UDim2.fromOffset(Direction * SlideDistance, 0)
			NewTab.ContainerAnim.GroupTransparency = 1
			pcall(function() NewTab.ContainerXMotor:setGoal(Instant(Direction * SlideDistance)); NewTab.ContainerTransparencyMotor:setGoal(Instant(1)) end)
			task.wait()
			pcall(function()
				OldTab.ContainerXMotor:setGoal(Spring(-Direction * SlideDistance, { frequency = 4, dampingRatio = 0.7 }))
				OldTab.ContainerTransparencyMotor:setGoal(Spring(1, { frequency = 4, dampingRatio = 0.7 }))
				NewTab.ContainerXMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
				NewTab.ContainerTransparencyMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
			end)
			TabModule.AnimationTask = task.spawn(function()
				task.wait(0.5)
				if TabModule.CurrentAnimationTab == Tab and TabModule.Tabs[PreviousTab] then
					local oc = TabModule.Tabs[PreviousTab].ContainerAnim
					if oc and oc.Parent then oc.Visible = false; oc.Position = UDim2.fromOffset(0, 0); oc.GroupTransparency = 0 end
					pcall(function() OldTab.ContainerXMotor:setGoal(Instant(0)); OldTab.ContainerTransparencyMotor:setGoal(Instant(0)) end)
					TabModule.AnimationTask = nil
				end
			end)
		else
			for idx, Container in next, TabModule.Containers do
				if Container then
					Container.Visible = (idx == Tab); Container.Position = UDim2.fromOffset(0, 0); Container.GroupTransparency = 0
					if TabModule.Tabs[idx] then pcall(function() TabModule.Tabs[idx].ContainerXMotor:setGoal(Instant(0)); TabModule.Tabs[idx].ContainerTransparencyMotor:setGoal(Instant(0)) end) end
				end
			end
		end
	end
	return TabModule
end)()

-- ============================================================
-- Components.Window — the shell. This is the main structural change:
-- an icon rail (left) + a content header (tab title + search) replace
-- the old labeled-sidebar-plus-cards skeleton. Drag/resize/minimize/
-- maximize/entrance-animation are ported, adapted to the new tree.
-- (Also dropped: Window.ContainerAnim/ContainerBackMotor/ContainerPosMotor/
-- ContainerXMotor, motors that were wired up but never had :setGoal()
-- called anywhere — dead code — and the _G.CDDrag always-zero throttle.)
-- ============================================================
Components.Window = function(Config)
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local RAIL_W, HEADER_H, CH_H, DIV = Tokens.Rail.Width, Tokens.Header.Height, Tokens.ContentHeader.Height, 1

	local Window = {
		Minimized = false, Maximized = false, Size = Config.Size or UDim2.fromOffset(820, 540),
		Position = UDim2.fromOffset(0, 0),
		DropdownsOutsideWindow = Config.DropdownsOutsideWindow == true,
	}
	Library.Window = Window
	local Dragging, DragInput, MousePos, StartPos = false
	local Resizing, ResizePos = false
	local MinimizeNotif = false

	local function CenterWindow()
		local vp = Camera.ViewportSize
		local x = math.max(0, (vp.X - Window.Size.X.Offset) / 2)
		local y = math.max(0, (vp.Y - Window.Size.Y.Offset) / 2)
		Window.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
		if Window.Root then Window.Root.Position = Window.Position end
	end

	Window.SurfaceMat = Components.Surface()

	local ResizeGripIcon = New("ImageLabel", {
		Name = "ResizeGrip", Image = "rbxassetid://10734898934", Size = UDim2.fromOffset(16, 16),
		Position = UDim2.new(1, -6, 1, -6), AnchorPoint = Vector2.new(1, 1), BackgroundTransparency = 1,
		ImageColor3 = Color3.fromRGB(255, 255, 255), ImageTransparency = Mobile and 0.35 or 1, ZIndex = 21,
	})
	local ResizeStartFrame = New("Frame", {
		Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, Position = UDim2.new(1, -24, 1, -24),
		ZIndex = 20, Active = true,
	}, { ResizeGripIcon })
	if not Mobile then
		local function Enter() ResizeGripIcon.ImageTransparency = 0 end
		local function Leave() ResizeGripIcon.ImageTransparency = 1 end
		Creator.AddSignal(ResizeStartFrame.MouseEnter, Enter)
		Creator.AddSignal(ResizeStartFrame.MouseLeave, Leave)
		Creator.AddSignal(ResizeGripIcon.MouseEnter, Enter)
		Creator.AddSignal(ResizeGripIcon.MouseLeave, Leave)
	end

	-- ── Icon rail ──────────────────────────────────────────────
	local Selector = New("Frame", {
		Size = UDim2.fromOffset(3, 22), Position = UDim2.fromOffset(0, 20), AnchorPoint = Vector2.new(0, 0.5),
		ThemeTag = { BackgroundColor3 = "Accent" },
	}, { Corner("pill") })

	Window.TabHolder = New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -8), Position = UDim2.fromOffset(0, 8),
		BackgroundTransparency = 1, ScrollBarImageTransparency = 1, ScrollBarThickness = 0,
		BorderSizePixel = 0, CanvasSize = UDim2.fromScale(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		New("UIListLayout", { Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center }),
		New("UIPadding", { PaddingTop = UDim.new(0, 4) }),
	})

	-- Floating rounded panel, inset on every side so it never touches the
	-- window's own rounded corners (avoids a square-corner-poking-past-a
	-- round-corner glitch) while still giving the rail a visibly distinct
	-- "dock" background instead of sitting flush/invisible against the
	-- window fill.
	local RailPanel = New("Frame", {
		Size = UDim2.new(1, -12, 1, -12), Position = UDim2.fromOffset(6, 6),
		BackgroundTransparency = 0.35, ThemeTag = { BackgroundColor3 = "SurfaceAlt" },
	}, { Corner("lg"), Stroke({ Transparency = 0.6, ThemeTag = { Color = "SurfaceBorder" } }) })

	Window.Rail = New("Frame", {
		Size = UDim2.new(0, RAIL_W, 1, -(HEADER_H + DIV)), Position = UDim2.fromOffset(0, HEADER_H + DIV),
		BackgroundTransparency = 1,
	}, { RailPanel, Window.TabHolder, Selector })

	local RailDivider = New("Frame", {
		Size = UDim2.new(0, 1, 1, -(HEADER_H + DIV)), Position = UDim2.fromOffset(RAIL_W, HEADER_H + DIV),
		BackgroundTransparency = 0.5, ThemeTag = { BackgroundColor3 = "Divider" },
	})
	local HeaderDivider = New("Frame", {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, HEADER_H),
		BackgroundTransparency = 0.5, ThemeTag = { BackgroundColor3 = "Divider" },
	})

	-- Optional small avatar pinned to the bottom of the rail (replaces
	-- the old text-heavy "UserInfo" panel, which doesn't fit a 56px rail).
	if Config.UserInfo then
		local avatarSize = 30
		local Avatar = New("ImageLabel", {
			Size = UDim2.fromOffset(avatarSize, avatarSize), Position = UDim2.new(0.5, 0, 1, -14),
			AnchorPoint = Vector2.new(0.5, 1), Image = "rbxassetid://0", Parent = Window.Rail,
		}, { Corner("pill"), Stroke({ Transparency = 0.6, ThemeTag = { Color = "SurfaceBorder" } }) })
		pcall(function()
			local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			if isReady and content then Avatar.Image = content end
		end)
		local avTip
		local titleText = tostring(Config.UserInfoTitle or LocalPlayer.Name or "User")
		local subText = Config.UserInfoSubtitle and tostring(Config.UserInfoSubtitle) or nil
		Creator.AddSignal(Avatar.MouseEnter, function()
			avTip = New("Frame", {
				AutomaticSize = Enum.AutomaticSize.XY, Position = UDim2.fromOffset(RAIL_W + 8, 0),
				AnchorPoint = Vector2.new(0, 1), Position2 = nil, ZIndex = 1000, Parent = Window.Root,
				ThemeTag = { BackgroundColor3 = "Surface" },
			}, {
				Corner("sm"), Stroke({ Transparency = 0.4, ThemeTag = { Color = "SurfaceBorder" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) }),
				New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
				New("TextLabel", {
					Text = titleText, FontFace = Tokens.Font.medium, TextSize = Tokens.Text.sm,
					AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1,
					ThemeTag = { TextColor3 = "Text" },
				}),
				subText and New("TextLabel", {
					Text = subText, FontFace = Tokens.Font.regular, TextSize = Tokens.Text.xs,
					AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1,
					ThemeTag = { TextColor3 = "SubText" },
				}) or nil,
			})
			local abs = Avatar.AbsolutePosition
			avTip.Position = UDim2.fromOffset(RAIL_W + 8, abs.Y - Window.Root.AbsolutePosition.Y + avatarSize)
		end)
		Creator.AddSignal(Avatar.MouseLeave, function() if avTip then avTip:Destroy(); avTip = nil end end)
	end

	-- ── Content header: current tab title + search ──────────────
	Window.ContentTitle = New("TextLabel", {
		RichText = true, Text = "", FontFace = Tokens.Font.semibold, TextSize = Tokens.Text.title,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
		Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.fromOffset(18, 0), BackgroundTransparency = 1,
		ThemeTag = { TextColor3 = "Text" },
	})

	Window.ShowSearch = (Config.Search == nil) and true or (Config.Search and true or false)
	local SearchFrame = New("Frame", {
		Size = UDim2.new(0, 200, 0, 30), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -18, 0.5, 0),
		Visible = Window.ShowSearch, ThemeTag = { BackgroundColor3 = "InputBg" },
	}, {
		Corner("sm"), Stroke({ Transparency = 0.6, ThemeTag = { Color = "InputBorder" } }),
		New("ImageLabel", {
			Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(10, 0.5 * 30 - 7),
			BackgroundTransparency = 1, Image = "rbxassetid://10734943674", ImageTransparency = 0.3,
			ThemeTag = { ImageColor3 = "SubText" },
		}),
	})
	local SearchInput = New("TextBox", {
		FontFace = Tokens.Font.regular, TextSize = Tokens.Text.sm, TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center, BackgroundTransparency = 1, Size = UDim2.new(1, -34, 1, 0),
		Position = UDim2.fromOffset(30, 0), PlaceholderText = "Search...", ClearTextOnFocus = false, Text = "",
		Parent = SearchFrame, ThemeTag = { TextColor3 = "Text", PlaceholderColor3 = "SubText" },
	})

	Window.ContentHeader = New("Frame", {
		Size = UDim2.new(1, -(RAIL_W + DIV), 0, CH_H), Position = UDim2.fromOffset(RAIL_W + DIV, HEADER_H + DIV),
		BackgroundTransparency = 1,
	}, { Window.ContentTitle, SearchFrame })

	local ContentHeaderDivider = New("Frame", {
		Size = UDim2.new(1, -(RAIL_W + DIV), 0, 1), Position = UDim2.fromOffset(RAIL_W + DIV, HEADER_H + DIV + CH_H),
		BackgroundTransparency = 0.5, ThemeTag = { BackgroundColor3 = "Divider" },
	})

	Window.ContainerHolder = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true })
	local topOffset = HEADER_H + DIV + CH_H + DIV
	Window.ContainerCanvas = New("Frame", {
		Size = UDim2.new(1, -(RAIL_W + DIV), 1, -topOffset), Position = UDim2.fromOffset(RAIL_W + DIV, topOffset),
		BackgroundTransparency = 1, ClipsDescendants = true,
	}, { Window.ContainerHolder })

	Creator.AddSignal(SearchInput:GetPropertyChangedSignal("Text"), function()
		Window.UpdateElementVisibility(SearchInput.Text or "")
	end)
	Creator.AddSignal(UserInputService.InputBegan, function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Escape and SearchInput:IsFocused() then
			SearchInput.Text = ""
			SearchInput:ReleaseFocus()
		end
	end)

	-- ── Search / element registry (generic tree walk — unrelated to
	-- rail-vs-sidebar, ported with one fix: the old version tried to
	-- resize each tab's canvas by walking Window.ContainerHolder's direct
	-- children expecting ScrollingFrames, but those children are actually
	-- CanvasGroups (the ScrollingFrame is one level deeper), so that pass
	-- silently did nothing — Section/Row sizes already auto-recompute via
	-- their own UIListLayout signals, so it's dropped instead of fixed.)
	local AllElements = {}
	local function RegisterElement(elementFrame, title, elementType, description)
		if not elementFrame then return end
		local sectionFrame = nil
		local parent = elementFrame.Parent
		while parent do
			local container = parent:FindFirstChild("Container")
			if container and elementFrame.Parent == container then sectionFrame = parent; break end
			parent = parent.Parent
		end
		local titleLabelRef, descLabelRef = nil, nil
		local function scan(obj)
			for _, child in ipairs(obj:GetChildren()) do
				if titleLabelRef and descLabelRef then return end
				if child:IsA("TextLabel") then
					if not titleLabelRef then titleLabelRef = child else descLabelRef = descLabelRef or child end
				end
				scan(child)
				if titleLabelRef and descLabelRef then return end
			end
		end
		pcall(scan, elementFrame)
		AllElements[elementFrame] = {
			title = tostring(title or ""), type = elementType or "Element", description = tostring(description or ""),
			section = sectionFrame, titleLabel = titleLabelRef, descLabel = descLabelRef,
		}
	end

	function Window.UpdateElementVisibility(searchTerm)
		searchTerm = searchTerm or ""
		local function normalize(text)
			text = tostring(text or "")
			text = text:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
			return text:lower()
		end
		local function escapeRT(s) return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;")) end
		local function highlight(original, query)
			if query == "" or original == "" then return nil end
			local lo, lq = original:lower(), query:lower()
			local s = lo:find(lq, 1, true)
			if not s then return nil end
			local e = s + #query - 1
			return escapeRT(original:sub(1, s - 1)) .. '<font color="#FFD866"><b>' .. escapeRT(original:sub(s, e)) .. "</b></font>" .. escapeRT(original:sub(e + 1))
		end
		local function applyHighlight(label, plainText, query)
			if not label then return end
			if query ~= "" then
				local firstWord = query:match("%S+") or query
				local h = highlight(plainText, firstWord)
				if h then label.RichText = true; label.Text = h; return end
			end
			label.RichText = false
			label.Text = plainText
		end
		local function elementValues(frame)
			local values = {}
			local function findText(obj)
				if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
					if obj.Text and obj.Text ~= "" then table.insert(values, tostring(obj.Text)) end
				end
				for _, child in pairs(obj:GetChildren()) do findText(child) end
			end
			findText(frame)
			return values
		end
		local function checkMatch(text, query)
			if query == "" then return true end
			local nt = normalize(text)
			if nt == "" then return false end
			if query:find("%s") then
				for word in query:gmatch("%S+") do
					if not nt:find(word, 1, true) then return false end
				end
				return true
			end
			return nt:find(query, 1, true) ~= nil
		end
		local normalizedQuery = normalize(searchTerm)
		local matchedSections, elementsInMatchedSections = {}, {}
		for element, data in pairs(AllElements) do
			if element and element.Parent and data.type == "Section" and normalizedQuery ~= "" and checkMatch(data.title, normalizedQuery) then
				matchedSections[element] = true
				local container = element:FindFirstChild("Container")
				if container then
					for _, child in pairs(container:GetChildren()) do
						if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then elementsInMatchedSections[child] = true end
					end
				end
			end
		end
		for element, data in pairs(AllElements) do
			if element and element.Parent then
				if normalizedQuery == "" then
					element.Visible = true
					applyHighlight(data.titleLabel, data.title, "")
					applyHighlight(data.descLabel, data.description, "")
				else
					local matchesTitle = checkMatch(data.title, normalizedQuery)
					local matchesDesc = checkMatch(data.description, normalizedQuery)
					local matchesValues = false
					for _, v in ipairs(elementValues(element)) do
						if checkMatch(v, normalizedQuery) then matchesValues = true; break end
					end
					local matchesSection = elementsInMatchedSections[element] == true or (data.section and matchedSections[data.section])
					element.Visible = matchesTitle or matchesDesc or matchesValues or matchesSection
					applyHighlight(data.titleLabel, data.title, matchesTitle and normalizedQuery or "")
					applyHighlight(data.descLabel, data.description, matchesDesc and normalizedQuery or "")
				end
			end
		end
	end
	Window.AllElements = AllElements
	Window.RegisterElement = RegisterElement

	-- ── Background image (optional; no auto-assigned default anymore —
	-- the old version silently attached a stock image behind every
	-- window unless you passed your own, which was a surprising default) ──
	local rootChildren = { Window.SurfaceMat.Frame }
	local backgroundTransparency = Config.BackgroundTransparency or 0.5
	Window.BackgroundTransparency = backgroundTransparency
	Window.BackgroundImageTransparency = Config.BackgroundImageTransparency or backgroundTransparency
	if Config.BackgroundImage then
		Window.BackgroundImage = New("ImageLabel", {
			Name = "BackgroundImage", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 0,
			Image = Config.BackgroundImage, ImageTransparency = math.clamp(Window.BackgroundImageTransparency, 0, 1),
			ScaleType = Enum.ScaleType.Stretch,
		}, { Corner("lg") })
		table.insert(rootChildren, 1, Window.BackgroundImage)
	end
	table.insert(rootChildren, HeaderDivider)
	table.insert(rootChildren, Window.Rail)
	table.insert(rootChildren, RailDivider)
	table.insert(rootChildren, Window.ContentHeader)
	table.insert(rootChildren, ContentHeaderDivider)
	table.insert(rootChildren, Window.ContainerCanvas)
	table.insert(rootChildren, ResizeStartFrame)

	Window.RootWrapper = New("CanvasGroup", {
		Name = "RootAnimWrapper", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		GroupTransparency = 0, Parent = Config.Parent,
	})
	Window.Root = New("Frame", {
		BackgroundTransparency = 1, Size = Window.Size, Position = Window.Position, Parent = Window.RootWrapper,
	}, rootChildren)

	Window.RootScale = New("UIScale", { Scale = 1, Parent = Window.Root })
	local RootScaleMotor, SetRootScale = Creator.SpringMotor(1, Window.RootScale, "Scale")
	Window.RootScaleMotor, Window.SetRootScale = RootScaleMotor, SetRootScale
	local RootFadeMotor, SetRootFade = Creator.SpringMotor(0, Window.RootWrapper, "GroupTransparency")
	Window.RootFadeMotor, Window.SetRootFade = RootFadeMotor, SetRootFade

	CenterWindow()
	Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), CenterWindow)

	Window.TitleBar = Components.TitleBar({
		Title = Config.Title, SubTitle = Config.SubTitle, Icon = Config.Icon, Discord = Config.Discord,
		Parent = Window.Root, Window = Window,
	})
	Window.TitleBar.Frame.ZIndex = 5

	local SizeMotor = Flipper.GroupMotor.new({ X = Window.Size.X.Offset, Y = Window.Size.Y.Offset })
	local PosMotor = Flipper.GroupMotor.new({ X = Window.Position.X.Offset, Y = Window.Position.Y.Offset })
	SizeMotor:onStep(function(v) Window.Root.Size = UDim2.new(0, v.X, 0, v.Y) end)
	PosMotor:onStep(function(v) Window.Root.Position = UDim2.new(0, v.X, 0, v.Y) end)

	-- +28 = TabHolder's own offset inside the rail (8) + half a rail
	-- button's height (20), since Selector is center-anchored.
	Window.SelectorPosMotor = Flipper.SingleMotor.new(20)
	Window.SelectorPosMotor:onStep(function(value) Selector.Position = UDim2.fromOffset(0, value + 28) end)

	local OldSizeX, OldSizeY
	Window.Maximize = function(value, noPos, instant)
		Window.Maximized = value
		Window.TitleBar.MaxButton.Frame.Icon.Image = value and Components.Assets.Restore or Components.Assets.Max
		if value then OldSizeX, OldSizeY = Window.Size.X.Offset, Window.Size.Y.Offset end
		local sizeX = value and Camera.ViewportSize.X or OldSizeX
		local sizeY = value and Camera.ViewportSize.Y or OldSizeY
		SizeMotor:setGoal({
			X = Flipper[instant and "Instant" or "Spring"].new(sizeX, { frequency = 6 }),
			Y = Flipper[instant and "Instant" or "Spring"].new(sizeY, { frequency = 6 }),
		})
		Window.Size = UDim2.fromOffset(sizeX, sizeY)
		if not noPos then
			PosMotor:setGoal({
				X = Spring(value and 0 or Window.Position.X.Offset, { frequency = 6 }),
				Y = Spring(value and 0 or Window.Position.Y.Offset, { frequency = 6 }),
			})
		end
	end

	Creator.AddSignal(Window.TitleBar.Frame.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			MousePos = input.Position
			StartPos = Window.Root.Position
			if Window.Maximized then
				StartPos = UDim2.fromOffset(
					Mouse.X - (Mouse.X * ((OldSizeX - 100) / Window.Root.AbsoluteSize.X)),
					Mouse.Y - (Mouse.Y * (OldSizeY / Window.Root.AbsoluteSize.Y))
				)
			end
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
		end
	end)
	Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)
	Creator.AddSignal(ResizeStartFrame.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Resizing = true
			ResizePos = input.Position
		end
	end)
	Creator.AddSignal(UserInputService.InputChanged, function(input)
		if input == DragInput and Dragging then
			local delta = input.Position - MousePos
			Window.Position = UDim2.fromOffset(StartPos.X.Offset + delta.X, StartPos.Y.Offset + delta.Y)
			PosMotor:setGoal({ X = Instant(Window.Position.X.Offset), Y = Instant(Window.Position.Y.Offset) })
			if Window.Maximized then Window.Maximize(false, true, true) end
		end
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and Resizing then
			local delta = input.Position - ResizePos
			ResizePos = input.Position
			local currentW, currentH = SizeMotor:getValue().X, SizeMotor:getValue().Y
			local target = Vector2.new(math.clamp(currentW + delta.X, 480, 2048), math.clamp(currentH + delta.Y, 360, 2048))
			SizeMotor:setGoal({ X = Instant(target.X), Y = Instant(target.Y) })
			Window.Size = UDim2.fromOffset(target.X, target.Y)
		end
	end)
	Creator.AddSignal(UserInputService.InputEnded, function(input)
		if Resizing or input.UserInputType == Enum.UserInputType.Touch then
			Resizing = false
			Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
		end
	end)
	Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		local contentSize = Window.TabHolder.UIListLayout.AbsoluteContentSize.Y + 8
		if contentSize > 0 then Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, contentSize) end
	end)
	Creator.AddSignal(UserInputService.InputBegan, function(input)
		if UserInputService:GetFocusedTextBox() then return end
		if type(Library.MinimizeKeybind) == "table" and Library.MinimizeKeybind.Type == "Keybind" then
			if input.KeyCode.Name == Library.MinimizeKeybind.Value then Window:Minimize() end
		elseif input.KeyCode == Library.MinimizeKey then
			Window:Minimize()
		end
	end)

	function Window:ToggleSearch()
		Window.ShowSearch = not Window.ShowSearch
		SearchFrame.Visible = Window.ShowSearch
	end

	function Window:Minimize()
		Window.Minimized = not Window.Minimized
		for _, option in next, Library.Options do
			if option and option.Type == "Dropdown" and option.Opened then pcall(function() option:Close() end) end
		end
		local smooth = { frequency = 4.5, dampingRatio = 1 }
		if Window.Minimized then
			SetRootScale(0.8, false, smooth)
			SetRootFade(1, false, smooth)
			task.delay(0.22, function() if Window.Minimized then Window.Root.Visible = false end end)
		else
			Window.Root.Visible = true
			Window.RootScale.Scale = 0.8
			Window.RootWrapper.GroupTransparency = 1
			SetRootScale(1, false, smooth)
			SetRootFade(0, false, smooth)
		end
		if Library.SetMinimizerVisible then Library.SetMinimizerVisible(Window.Minimized, true) end
		if not MinimizeNotif then
			MinimizeNotif = true
			local key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
			Library:Notify({
				Title = "Interface",
				Content = Mobile and "Tap the button to toggle the interface." or ("Press " .. key .. " to toggle the interface."),
				Duration = 6,
			})
		end
		if not RunService:IsStudio() and Library.Minimizer then
			pcall(function()
				local btn = Library.Minimizer:FindFirstChild("TextButton")
				local img = btn and btn:FindFirstChild("ImageLabel")
				if img then img.Image = Window.Minimized and "rbxassetid://10734896384" or "rbxassetid://10734897102" end
			end)
		end
	end

	function Window:Destroy() Window.Root:Destroy() end

	function Window:SetBackgroundImage(imageUrl, imageTransparency)
		local t = imageTransparency or Window.BackgroundImageTransparency or 0.5
		if not Window.BackgroundImage then
			Window.BackgroundImage = New("ImageLabel", {
				Name = "BackgroundImage", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 0,
				Image = imageUrl, ImageTransparency = math.clamp(t, 0, 1), ScaleType = Enum.ScaleType.Stretch,
				Parent = Window.Root,
			}, { Corner("lg") })
		else
			Window.BackgroundImage.Image = imageUrl
			Window.BackgroundImage.ImageTransparency = math.clamp(t, 0, 1)
		end
		Window.BackgroundImageTransparency = t
	end
	function Window:SetBackgroundTransparency(transparency) Window.BackgroundTransparency = transparency or 0.5 end
	function Window:SetBackgroundImageTransparency(transparency)
		transparency = transparency or 0.5
		Window.BackgroundImageTransparency = transparency
		if Window.BackgroundImage then Window.BackgroundImage.ImageTransparency = math.clamp(transparency, 0, 1) end
	end

	local DialogModule = Components.Dialog:Init(Window)
	function Window:Dialog(Config)
		local Dialog = DialogModule:Create()
		Dialog.Title.Text = Config.Title
		if Config.Icon then Dialog:SetIcon(Config.Icon) end
		local ContentHolder = New("ScrollingFrame", {
			BackgroundTransparency = 1, ScrollBarImageTransparency = 0.7, ScrollBarThickness = 4,
			Position = UDim2.fromOffset(28, 84), Size = UDim2.new(1, -56, 1, -160),
			CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = Dialog.Root,
		})
		local Content = New("TextLabel", {
			FontFace = Tokens.Font.regular, Text = Config.Content, TextSize = Tokens.Text.lg,
			TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, Size = UDim2.new(1, -8, 0, 0),
			BackgroundTransparency = 1, Parent = ContentHolder, ThemeTag = { TextColor3 = "SubText" },
		})
		New("UISizeConstraint", { MinSize = Vector2.new(340, 200), MaxSize = Vector2.new(620, math.huge), Parent = Dialog.Root })
		local maxWidth = math.min(620, Window.Size.X.Offset - 120)
		local baseWidth = math.max(340, math.min(maxWidth, Content.TextBounds.X + 56))
		Dialog.Root.Size = UDim2.fromOffset(baseWidth, 200)
		task.defer(function()
			local desired = math.clamp(Content.TextBounds.Y + 160, 200, 460)
			Dialog.Root.Size = UDim2.fromOffset(baseWidth, desired)
			ContentHolder.CanvasSize = UDim2.fromOffset(0, Content.TextBounds.Y)
		end)
		for i, button in next, Config.Buttons do Dialog:Button(button.Title, button.Callback, i == 1) end
		Dialog:Open()
	end

	local TabModule = Components.Tab:Init(Window)
	function Window:AddTab(TabConfig)
		local tab = TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder)
		if TabModule.SelectedTab == 0 and not TabModule.PendingAutoSelect then
			TabModule.PendingAutoSelect = true
			local firstIndex = TabModule.TabCount
			task.defer(function()
				TabModule.PendingAutoSelect = nil
				if TabModule.SelectedTab == 0 then TabModule:SelectTab(firstIndex) end
			end)
		end
		return tab
	end
	function Window:SelectTab(tab) TabModule:SelectTab(tab) end

	-- ── Entrance animation ──────────────────────────────────────
	do
		local DURATION, STYLE, DIR = 1.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out
		local function CaptureAndHide(obj)
			local props = {}
			local ok = pcall(function() return obj.BackgroundTransparency end)
			if ok and (obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ImageButton") or obj:IsA("ScrollingFrame") or obj:IsA("TextBox") or obj:IsA("CanvasGroup")) then
				props.BackgroundTransparency = obj.BackgroundTransparency
			end
			if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then props.TextTransparency = obj.TextTransparency end
			if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then props.ImageTransparency = obj.ImageTransparency end
			if obj:IsA("UIStroke") then props.Transparency = obj.Transparency end
			if next(props) then
				for name in pairs(props) do pcall(function() obj[name] = 1 end) end
				return props
			end
			return nil
		end
		local function EntranceAnimate(root, offsetX, offsetY, delaySec)
			if not root then return end
			local originalPosition = root.Position
			local targets = {}
			local rootProps = CaptureAndHide(root)
			if rootProps then targets[root] = rootProps end
			for _, d in ipairs(root:GetDescendants()) do
				local p = CaptureAndHide(d)
				if p then targets[d] = p end
			end
			root.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset + offsetX, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY)
			task.delay(delaySec, function()
				if not root.Parent then return end
				local ti = TweenInfo.new(DURATION, STYLE, DIR)
				TweenService:Create(root, ti, { Position = originalPosition }):Play()
				for obj, props in pairs(targets) do
					if obj ~= root and obj.Parent then TweenService:Create(obj, ti, props):Play() end
				end
			end)
		end
		EntranceAnimate(Window.SurfaceMat.Frame, 0, 0, 0)
		EntranceAnimate(Window.TitleBar.Frame, 0, -40, 0.05)
		EntranceAnimate(Window.Rail, -50, 0, 0.15)
		EntranceAnimate(Window.ContentHeader, 0, -20, 0.28)
		EntranceAnimate(Window.ContainerCanvas, 50, 0, 0.32)
		EntranceAnimate(ResizeStartFrame, 0, 40, 0.45)
	end

	return Window
end

local ElementsTable = {}
local AddSignal = Creator.AddSignal

ElementsTable.Toggle = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Toggle"
	function Element:New(Idx, Config)
		assert(Config.Title, "Toggle - Missing Title")
		local Toggle = { Value = Config.Default or false, Callback = Config.Callback or function(v) end, Type = "Toggle" }

		local ToggleFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		ToggleFrame.DescLabel.Size = UDim2.new(1, -54, 0, 14)
		Toggle.SetTitle, Toggle.SetDesc, Toggle.Visible, Toggle.Elements = ToggleFrame.SetTitle, ToggleFrame.SetDesc, ToggleFrame.Visible, ToggleFrame

		local ToggleTrack = New("Frame", {
			Size = UDim2.fromOffset(40, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
			Parent = ToggleFrame.Frame, BackgroundTransparency = 0.88, ThemeTag = { BackgroundColor3 = "InputBorder" },
		}, { Corner("pill") })
		local ToggleBorder = Stroke({ Transparency = 0.4, ThemeTag = { Color = "ToggleKnobOff" } })
		ToggleBorder.Parent = ToggleTrack
		local ToggleSlider = New("Frame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = ToggleTrack, ThemeTag = { BackgroundColor3 = "Accent" },
		}, { Corner("pill") })
		local ToggleCircle = New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(15, 15), Position = UDim2.new(0, 4, 0.5, 0),
			BackgroundTransparency = 0.1, Parent = ToggleTrack, ThemeTag = { BackgroundColor3 = "ToggleKnobOff" },
		}, { Corner("pill"), New("UIAspectRatioConstraint", { AspectRatio = 1 }) })

		function Toggle:OnChanged(fn) Toggle.Changed = fn; fn(Toggle.Value) end
		function Toggle:SetValue(value)
			value = not not value
			Toggle.Value = value
			local ti = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			TweenService:Create(ToggleCircle, ti, {
				Position = UDim2.new(0, value and 21 or 4, 0.5, 0),
				Size = UDim2.fromOffset(value and 16 or 15, value and 16 or 15),
			}):Play()
			TweenService:Create(ToggleSlider, ti, { BackgroundTransparency = value and 0.35 or 1 }):Play()
			Creator.OverrideTag(ToggleBorder, { Color = value and "Accent" or "ToggleKnobOff" })
			TweenService:Create(ToggleBorder, ti, { Transparency = value and 0.55 or 0.4 }):Play()
			Creator.OverrideTag(ToggleCircle, { BackgroundColor3 = value and "ToggleKnobOn" or "ToggleKnobOff" })
			local pulse = ToggleTrack:FindFirstChildOfClass("UIScale")
			if not pulse then pulse = New("UIScale", { Scale = 1 }); pulse.Parent = ToggleTrack end
			pulse.Scale = 0.9
			TweenService:Create(pulse, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
		end
		function Toggle:Destroy() ToggleFrame:Destroy(); Library.Options[Idx] = nil end
		AddSignal(ToggleFrame.Frame.MouseButton1Click, function() Toggle:SetValue(not Toggle.Value) end)
		Toggle:SetValue(Toggle.Value)
		Library.Options[Idx] = Toggle
		return Toggle
	end
	return Element
end)()

ElementsTable.Dropdown = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Dropdown"
	function Element:New(Idx, Config)
		local windowDropdownsOutside = false
		if Library.Window and Library.Window.DropdownsOutsideWindow ~= nil then
			windowDropdownsOutside = Library.Window.DropdownsOutsideWindow
		elseif Library.Windows and #Library.Windows > 0 then
			for i = #Library.Windows, 1, -1 do
				local w = Library.Windows[i]
				if w and w.DropdownsOutsideWindow ~= nil then windowDropdownsOutside = w.DropdownsOutsideWindow; break end
			end
		end
		local Dropdown = {
			Values = Config.Values, Value = Config.Default, Multi = Config.Multi, Buttons = {}, Opened = false,
			Type = "Dropdown", Callback = Config.Callback or function() end,
			Search = (Config.Search == nil) and true or Config.Search, KeepSearch = Config.KeepSearch == true,
			OpenToRight = windowDropdownsOutside,
		}
		if Dropdown.Multi and Config.AllowNull then Dropdown.Value = {} end

		local DropdownFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		DropdownFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)
		Dropdown.SetTitle, Dropdown.SetDesc, Dropdown.Visible, Dropdown.Elements = DropdownFrame.SetTitle, DropdownFrame.SetDesc, DropdownFrame.Visible, DropdownFrame
		local container = self.Container

		local DropdownDisplay = New("TextLabel", {
			FontFace = Tokens.Font.regular, Text = "", TextSize = Tokens.Text.lg, AutomaticSize = Enum.AutomaticSize.Y,
			TextYAlignment = Enum.TextYAlignment.Center, TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0.5, 0), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1, TextTruncate = Enum.TextTruncate.AtEnd, ThemeTag = { TextColor3 = "Text" },
		})
		local initialRotation, openRotation, closeRotation = 180, (windowDropdownsOutside and -90 or 0), 180
		local DropdownIco = New("ImageLabel", {
			Image = "rbxassetid://10709790948", Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0), BackgroundTransparency = 1, Rotation = initialRotation,
			ThemeTag = { ImageColor3 = "SubText" },
		})
		local DropdownInnerStroke = Stroke({ Transparency = 0.45, ThemeTag = { Color = "InputBorder" } })
		local baseStrokeThickness = Tokens.Border
		local DropdownInner = New("TextButton", {
			Size = UDim2.fromOffset(160, 32), Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0, Parent = DropdownFrame.Frame, ThemeTag = { BackgroundColor3 = "InputBg" },
		}, { Corner("sm"), DropdownInnerStroke, DropdownIco, DropdownDisplay })

		local DropdownListLayout = New("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder })
		local DropdownScrollFrame = New("ScrollingFrame", {
			Size = UDim2.new(1, -5, 1, -10), Position = UDim2.fromOffset(5, 5), BackgroundTransparency = 1,
			ScrollBarImageTransparency = 0.75, ScrollBarThickness = 5, BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y, ThemeTag = { ScrollBarImageColor3 = "SubText" },
		}, { DropdownListLayout })

		-- Forward-declared so the search filter (defined next) closes over
		-- the *same* locals these get assigned to further down — the old
		-- version declared them with `local function` after this point,
		-- so the search box's callback silently referenced globals (nil)
		-- and errored quietly every keystroke. Fixed here.
		local RecalculateListPosition, RecalculateListSize, RecalculateCanvasSize

		local SearchBar, SearchBox
		if Dropdown.Search then
			SearchBar = New("Frame", {
				Size = UDim2.new(1, -10, 0, 28), Position = UDim2.fromOffset(5, 5), ZIndex = 24,
				ThemeTag = { BackgroundColor3 = "InputBg" },
			}, { Corner("xs") })
			SearchBox = New("TextBox", {
				FontFace = Tokens.Font.medium, TextSize = Tokens.Text.md, TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center, BackgroundTransparency = 1, Size = UDim2.new(1, -36, 1, 0),
				Position = UDim2.new(0, 8, 0, 0), PlaceholderText = "Search...", ClearTextOnFocus = false, Text = "",
				Parent = SearchBar, ThemeTag = { TextColor3 = "Text", PlaceholderColor3 = "SubText" }, ZIndex = 24,
			})
			New("ImageLabel", {
				Size = UDim2.fromOffset(16, 16), Position = UDim2.new(1, -13, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1, Image = "rbxassetid://10734943674", Parent = SearchBar,
				ImageTransparency = 0.3, ZIndex = 25, ThemeTag = { ImageColor3 = "SubText" },
			})
			DropdownScrollFrame.Position = UDim2.fromOffset(5, 38)
			DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -43)
			local filterToken = 0
			local function ApplyFilter()
				filterToken = filterToken + 1
				local myToken = filterToken
				task.spawn(function()
					task.wait(0.01)
					if myToken ~= filterToken then return end
					local text = (SearchBox.Text or ""):lower()
					for _, element in next, DropdownScrollFrame:GetChildren() do
						if not element:IsA("UIListLayout") then
							local value = element:FindFirstChild("ButtonLabel") and element.ButtonLabel.Text or ""
							element.Visible = text == "" or value:lower():find(text, 1, true) ~= nil
						end
					end
					task.wait(); RecalculateCanvasSize()
					task.wait(); RecalculateListSize()
					task.wait(); RecalculateListPosition()
				end)
			end
			Creator.AddSignal(SearchBox:GetPropertyChangedSignal("Text"), ApplyFilter)
		end

		local DropdownHolderFrame = New("Frame", {
			Size = UDim2.fromScale(1, 0.6), ThemeTag = { BackgroundColor3 = "Surface" },
		}, {
			SearchBar, DropdownScrollFrame, Corner("sm"),
			Stroke({ Thickness = baseStrokeThickness + 0.5, ThemeTag = { Color = "Accent" } }),
		})
		local DropdownHolderCanvas = New("Frame", {
			BackgroundTransparency = 1, Size = UDim2.fromOffset(170, 300), Parent = Library.GUI, Visible = false,
		}, { DropdownHolderFrame, New("UISizeConstraint", { MinSize = Vector2.new(170, 0) }) })
		table.insert(Library.OpenFrames, DropdownHolderCanvas)

		local function FindWindowRoot()
			if Library.Window and Library.Window.Root then return Library.Window.Root end
			if Library.Windows then
				for i = #Library.Windows, 1, -1 do
					local w = Library.Windows[i]
					if w and w.Root then return w.Root end
				end
			end
			return nil
		end
		local windowRoot = FindWindowRoot()

		RecalculateListPosition = function()
			if not DropdownHolderCanvas or not DropdownInner then return end
			local dropdownX, dropdownY = DropdownInner.AbsolutePosition.X, DropdownInner.AbsolutePosition.Y
			local dropdownWidth, dropdownHeight = DropdownInner.AbsoluteSize.X, DropdownInner.AbsoluteSize.Y
			local canvasWidth, canvasHeight = DropdownHolderCanvas.AbsoluteSize.X, DropdownHolderCanvas.AbsoluteSize.Y
			local viewportHeight, viewportWidth = Camera.ViewportSize.Y, Camera.ViewportSize.X
			windowRoot = windowRoot or FindWindowRoot()
			local targetX, useFixedY = dropdownX - 1, false
			if windowRoot then
				local windowX, windowWidth = windowRoot.AbsolutePosition.X, windowRoot.AbsoluteSize.X
				local windowRight = windowX + windowWidth
				if Dropdown.OpenToRight then
					targetX = windowRight + 5
					if Dropdown.SavedY == nil then Dropdown.SavedY = dropdownY end
					useFixedY = true
				else
					local canvasRight = dropdownX + canvasWidth - 1
					if canvasRight > windowRight then targetX = math.max(windowX + 5, windowRight - canvasWidth - 5) end
					Dropdown.SavedY = nil
				end
			else
				local canvasRight = dropdownX + canvasWidth - 1
				if canvasRight > viewportWidth then
					if Dropdown.OpenToRight then
						targetX = viewportWidth + 5
						if Dropdown.SavedY == nil then Dropdown.SavedY = dropdownY end
						useFixedY = true
					else
						targetX = math.max(5, viewportWidth - canvasWidth - 5)
					end
					Dropdown.SavedY = nil
				end
			end
			local targetY
			if useFixedY and windowRoot then
				local windowY, windowHeight = windowRoot.AbsolutePosition.Y, windowRoot.AbsoluteSize.Y
				local windowCenterY = windowY + windowHeight / 2
				targetY = windowCenterY - canvasHeight / 2
				local windowTop, windowBottom = windowY, windowY + windowHeight
				if targetY + canvasHeight > viewportHeight then targetY = viewportHeight - canvasHeight - 5 end
				if targetY < 0 then targetY = 5 end
				if targetY + canvasHeight > windowBottom then targetY = windowBottom - canvasHeight - 5 end
				if targetY < windowTop then targetY = windowTop + 5 end
			elseif useFixedY and Dropdown.SavedY then
				targetY = Dropdown.SavedY
				local spaceBelow = viewportHeight - (Dropdown.SavedY + dropdownHeight)
				local spaceAbove = Dropdown.SavedY
				if canvasHeight > spaceBelow and canvasHeight <= spaceAbove then
					targetY = Dropdown.SavedY - canvasHeight - 5
				elseif canvasHeight > spaceBelow and canvasHeight > spaceAbove then
					targetY = spaceBelow > spaceAbove and (Dropdown.SavedY + dropdownHeight + 5) or math.max(5, Dropdown.SavedY - canvasHeight - 5)
				else
					targetY = Dropdown.SavedY + dropdownHeight + 5
				end
			else
				local spaceBelow = viewportHeight - (dropdownY + dropdownHeight)
				local spaceAbove = dropdownY
				if canvasHeight <= spaceBelow then targetY = dropdownY + dropdownHeight + 5
				elseif canvasHeight <= spaceAbove then targetY = dropdownY - canvasHeight - 5
				else targetY = spaceBelow > spaceAbove and (dropdownY + dropdownHeight + 5) or math.max(5, dropdownY - canvasHeight - 5) end
			end
			DropdownHolderCanvas.Position = UDim2.fromOffset(targetX, targetY)
		end

		local ListSizeX = 0
		RecalculateListSize = function()
			if not DropdownHolderCanvas or not DropdownHolderFrame then return end
			local visibleCount = 0
			for _, element in next, DropdownScrollFrame:GetChildren() do
				if not element:IsA("UIListLayout") and element.Visible then visibleCount = visibleCount + 1 end
			end
			local itemHeight, padding = 32, 3
			local searchHeight = Dropdown.Search and 38 or 0
			local estimatedContent = (visibleCount > 0) and (visibleCount * itemHeight + (visibleCount - 1) * padding + 10 + searchHeight) or (10 + searchHeight)
			local targetHeight = math.min(estimatedContent, 392)
			local canvasWidth = math.max(170, ListSizeX > 0 and (ListSizeX + 20) or 170)
			DropdownHolderCanvas.Size = UDim2.fromOffset(canvasWidth, targetHeight)
			DropdownHolderFrame.Size = UDim2.fromScale(1, 1)
		end
		RecalculateCanvasSize = function()
			DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
		end
		RecalculateListPosition(); RecalculateListSize(); RecalculateCanvasSize()

		if Dropdown.OpenToRight and windowRoot then
			Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsolutePosition"), function()
				if Dropdown.Opened then Dropdown.SavedY = nil; RecalculateListPosition() end
			end)
			Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsoluteSize"), function()
				if Dropdown.Opened then RecalculateListPosition() end
			end)
		else
			Creator.AddSignal(DropdownInner:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition)
			if windowRoot then
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsolutePosition"), function() if Dropdown.Opened then RecalculateListPosition() end end)
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsoluteSize"), function() if Dropdown.Opened then RecalculateListPosition() end end)
			end
		end
		Creator.AddSignal(DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			RecalculateCanvasSize(); task.wait(); RecalculateListSize(); task.wait(); RecalculateListPosition()
		end)
		Creator.AddSignal(DropdownInner.MouseButton1Click, function() if Dropdown.Opened then Dropdown:Close() else Dropdown:Open() end end)
		Creator.AddSignal(DropdownInner.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				if Dropdown.Opened then Dropdown:Close() else Dropdown:Open() end
			end
		end)
		Creator.AddSignal(DropdownDisplay:GetPropertyChangedSignal("Text"), function()
			for _, element in next, DropdownScrollFrame:GetChildren() do
				if not element:IsA("UIListLayout") then element.Visible = true end
			end
			RecalculateListPosition(); RecalculateListSize()
		end)
		Creator.AddSignal(UserInputService.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local mousePos = input.UserInputType == Enum.UserInputType.MouseButton1 and Vector2.new(Mouse.X, Mouse.Y) or input.Position
				local absPos, absSize = DropdownHolderFrame.AbsolutePosition, DropdownHolderFrame.AbsoluteSize
				local iPos, iSize = DropdownInner.AbsolutePosition, DropdownInner.AbsoluteSize
				local insideList = mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y
				local insideInner = mousePos.X >= iPos.X and mousePos.X <= iPos.X + iSize.X and mousePos.Y >= iPos.Y and mousePos.Y <= iPos.Y + iSize.Y
				if not insideList and not insideInner then Dropdown:Close() end
			end
		end)

		function Dropdown:Open()
			if Dropdown.Opened then return end
			Dropdown.Opened = true
			if Dropdown.OpenToRight then Dropdown.SavedY = nil end
			for _, frame in ipairs(Library.OpenFrames) do
				if frame ~= DropdownHolderCanvas and frame.Visible then frame.Visible = false end
			end
			if SearchBox and not Dropdown.KeepSearch then SearchBox.Text = "" end
			DropdownHolderCanvas.Visible = true
			RecalculateListPosition(); RecalculateListSize(); RecalculateCanvasSize()
			task.wait()
			TweenService:Create(DropdownHolderFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.fromScale(1, 1) }):Play()
			TweenService:Create(DropdownIco, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = openRotation }):Play()
			Creator.OverrideTag(DropdownInnerStroke, { Color = "Accent" })
			TweenService:Create(DropdownInnerStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Transparency = 0, Thickness = baseStrokeThickness + 0.5 }):Play()
			local openToken = (Dropdown.OpenToken or 0) + 1
			Dropdown.OpenToken = openToken
			local visibleIndex = 0
			for _, element in ipairs(DropdownScrollFrame:GetChildren()) do
				if not element:IsA("UIListLayout") and element.Visible then
					visibleIndex = visibleIndex + 1
					local delayIdx = visibleIndex
					local scaleObj = element:FindFirstChild("PopScale")
					local label = element:FindFirstChild("ButtonLabel")
					if scaleObj then scaleObj.Scale = 0.8 end
					if label then label.TextTransparency = 1 end
					task.delay((delayIdx - 1) * 0.035, function()
						if Dropdown.OpenToken ~= openToken or not (element and element.Parent) then return end
						if scaleObj then TweenService:Create(scaleObj, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play() end
						if label then TweenService:Create(label, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play() end
					end)
				end
			end
		end
		function Dropdown:Close()
			Dropdown.Opened = false
			Dropdown.OpenToken = (Dropdown.OpenToken or 0) + 1
			if Dropdown.OpenToRight then Dropdown.SavedY = nil end
			DropdownHolderFrame.Size = UDim2.fromScale(1, 1)
			DropdownHolderCanvas.Visible = false
			TweenService:Create(DropdownIco, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = closeRotation }):Play()
			Creator.OverrideTag(DropdownInnerStroke, { Color = "InputBorder" })
			TweenService:Create(DropdownInnerStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Transparency = 0.45, Thickness = baseStrokeThickness }):Play()
			Dropdown:Display()
			for _, element in next, DropdownScrollFrame:GetChildren() do
				if not element:IsA("UIListLayout") then element.Visible = true end
			end
		end
		function Dropdown:Display()
			local Values, Str = Dropdown.Values, ""
			if Config.Multi then
				for _, Value in next, Values do if Dropdown.Value[Value] then Str = Str .. Value .. ", " end end
				Str = Str:sub(1, #Str - 2)
			else
				Str = Dropdown.Value or ""
			end
			DropdownDisplay.Text = (Str == "" and "--" or Str)
		end
		function Dropdown:GetActiveValues()
			if Config.Multi then
				local t = {}
				for Value in next, Dropdown.Value do table.insert(t, Value) end
				return t
			end
			return Dropdown.Value and 1 or 0
		end
		function Dropdown:SetActiveValues(Value)
			Dropdown.Value = Value
			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
			Dropdown:BuildDropdownList()
		end
		function Dropdown:BuildDropdownList()
			local Values, Buttons = Dropdown.Values, {}
			for _, element in next, DropdownScrollFrame:GetChildren() do
				if not element:IsA("UIListLayout") then element:Destroy() end
			end
			local layoutOrder = 0
			for _, Value in ipairs(Values) do
				layoutOrder = layoutOrder + 1
				local Table = {}
				local ButtonSelector = New("Frame", {
					Size = UDim2.fromOffset(4, 14), Position = UDim2.fromOffset(-1, 16), AnchorPoint = Vector2.new(0, 0.5),
					ThemeTag = { BackgroundColor3 = "Accent" },
				}, { Corner("xs") })
				local ButtonLabel = New("TextLabel", {
					FontFace = Tokens.Font.medium, Text = Value, TextSize = Tokens.Text.md,
					TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(10, 0),
					Name = "ButtonLabel", ThemeTag = { TextColor3 = "Text" },
				})
				local Button = New("TextButton", {
					Size = UDim2.new(1, -5, 0, 32), BackgroundTransparency = 1, ZIndex = 23, Text = "",
					Parent = DropdownScrollFrame, LayoutOrder = layoutOrder, ThemeTag = { BackgroundColor3 = "RowHover" },
				}, {
					ButtonSelector, ButtonLabel, Corner("sm"),
					Stroke({ Transparency = 1, ThemeTag = { Color = "Accent" } }),
					New("UIScale", { Scale = 1, Name = "PopScale" }),
				})
				local Selected = Config.Multi and Dropdown.Value[Value] or (Dropdown.Value == Value)
				local _, SetBackTransparency = Creator.SpringMotor(1, Button, "BackgroundTransparency")
				local _, SetSelTransparency = Creator.SpringMotor(1, ButtonSelector, "BackgroundTransparency")
				local SelectorSizeMotor = Flipper.SingleMotor.new(6)
				SelectorSizeMotor:onStep(function(v) ButtonSelector.Size = UDim2.new(0, 4, 0, v) end)
				Creator.AddSignal(Button.MouseEnter, function() SetBackTransparency(Selected and 0.85 or 0.92) end)
				Creator.AddSignal(Button.MouseLeave, function() SetBackTransparency(Selected and 0.89 or 1) end)
				Creator.AddSignal(Button.MouseButton1Down, function() SetBackTransparency(0.8) end)
				Creator.AddSignal(Button.MouseButton1Up, function() SetBackTransparency(Selected and 0.85 or 0.92) end)
				function Table:UpdateButton()
					if Config.Multi then
						Selected = Dropdown.Value[Value]
						if Selected then SetBackTransparency(0.89) end
					else
						Selected = Dropdown.Value == Value
						SetBackTransparency(Selected and 0.89 or 1)
					end
					SelectorSizeMotor:setGoal(Flipper.Spring.new(Selected and 14 or 6, { frequency = 6 }))
					SetSelTransparency(Selected and 0 or 1)
				end
				AddSignal(Button.Activated, function()
					local try = not Selected
					if not (Dropdown:GetActiveValues() == 1 and not try and not Config.AllowNull) then
						if Config.Multi then
							Selected = try
							Dropdown.Value[Value] = Selected and true or nil
						else
							Selected = try
							Dropdown.Value = Selected and Value or nil
							for _, otherTable in next, Buttons do otherTable:UpdateButton() end
						end
						Table:UpdateButton()
						Dropdown:Display()
						Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
						Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
					end
				end)
				Table:UpdateButton()
				Dropdown:Display()
				Buttons[Button] = Table
			end
			ListSizeX = 0
			for button in next, Buttons do
				if button.ButtonLabel then ListSizeX = math.max(ListSizeX, button.ButtonLabel.TextBounds.X) end
			end
			ListSizeX = math.max(150, ListSizeX + 40)
			RecalculateCanvasSize(); RecalculateListSize()
		end
		function Dropdown:SetValues(newValues)
			if newValues then Dropdown.Values = newValues end
			Dropdown:BuildDropdownList()
		end
		function Dropdown:OnChanged(fn) Dropdown.Changed = fn; fn(Dropdown.Value) end
		function Dropdown:SetValue(val)
			if Dropdown.Multi then
				local nTable = {}
				for value in next, val do if table.find(Dropdown.Values, value) then nTable[value] = true end end
				Dropdown.Value = nTable
			else
				if not val then Dropdown.Value = nil
				elseif table.find(Dropdown.Values, val) then Dropdown.Value = val end
			end
			Dropdown:BuildDropdownList()
			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end
		function Dropdown:Destroy() DropdownFrame:Destroy(); Library.Options[Idx] = nil end

		Dropdown:BuildDropdownList()
		Dropdown:Display()
		local Defaults = {}
		if type(Config.Default) == "string" then
			local i = table.find(Dropdown.Values, Config.Default)
			if i then table.insert(Defaults, i) end
		elseif type(Config.Default) == "table" then
			for _, value in next, Config.Default do
				local i = table.find(Dropdown.Values, value)
				if i then table.insert(Defaults, i) end
			end
		elseif type(Config.Default) == "number" and Dropdown.Values[Config.Default] ~= nil then
			table.insert(Defaults, Config.Default)
		end
		if next(Defaults) then
			for i = 1, #Defaults do
				local index = Defaults[i]
				if Config.Multi then Dropdown.Value[Dropdown.Values[index]] = true else Dropdown.Value = Dropdown.Values[index] end
				if not Config.Multi then break end
			end
			Dropdown:BuildDropdownList()
			Dropdown:Display()
		end
		Library.Options[Idx] = Dropdown
		return Dropdown
	end
	return Element
end)()

ElementsTable.Slider = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Slider"
	function Element:New(Idx, Config)
		assert(Config.Title, "Slider - Missing Title.")
		assert(Config.Default ~= nil, "Slider - Missing default value.")
		assert(Config.Min ~= nil, "Slider - Missing minimum value.")
		assert(Config.Max ~= nil, "Slider - Missing maximum value.")
		Config.Rounding = Config.Rounding ~= nil and Config.Rounding or 0
		local Slider = {
			Value = nil, Min = Config.Min, Max = Config.Max, Rounding = Config.Rounding,
			Callback = Config.Callback or function(v) end, Type = "Slider",
		}

		local Dragging = false
		local SliderFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		SliderFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)
		Slider.Elements, Slider.SetTitle, Slider.SetDesc, Slider.Visible = SliderFrame, SliderFrame.SetTitle, SliderFrame.SetDesc, SliderFrame.Visible

		local SliderDot = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(12, 12),
			ThemeTag = { BackgroundColor3 = "InputBg" },
		}, {
			Corner("pill"), New("UIAspectRatioConstraint", { AspectRatio = 1 }),
			Stroke({ Thickness = 1.75, ThemeTag = { Color = "Accent" } }),
		})
		local SliderRail = New("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(6, 0), Size = UDim2.new(1, -12, 1, 0) }, { SliderDot })
		local SliderFill = New("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1) }, {
			Corner("pill"), New("UIGradient", { ThemeTag = { Color = "AccentGradient" } }),
		})
		local SliderDisplay = New("TextLabel", {
			FontFace = Tokens.Font.medium, Text = "Value", TextSize = Tokens.Text.xs, TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1, Size = UDim2.new(0, 100, 0, 14),
			Position = UDim2.new(1, 0, 0, -10), AnchorPoint = Vector2.new(1, 1), ThemeTag = { TextColor3 = "SubText" },
		})
		local SliderInputStroke = Stroke({ Transparency = 1 })
		local SliderInput = New("TextBox", {
			FontFace = Tokens.Font.medium, Text = "", TextSize = Tokens.Text.xs, TextXAlignment = Enum.TextXAlignment.Right,
			Size = UDim2.new(0, 0, 0, 14), Position = UDim2.new(1, 0, 0, -10), AnchorPoint = Vector2.new(1, 1),
			PlaceholderText = "Value", ClearTextOnFocus = false, TextWrapped = false, TextTransparency = 1,
			BackgroundTransparency = 1, ThemeTag = { TextColor3 = "SubText", BackgroundColor3 = "InputBg" },
		}, { Corner("xs"), SliderInputStroke })

		local SliderInner = New("Frame", {
			Size = UDim2.new(1, 0, 0, 6), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 10),
			BackgroundTransparency = 0.3, Parent = SliderFrame.Frame, ThemeTag = { BackgroundColor3 = "InputBorder" },
		}, { Corner("pill"), New("UISizeConstraint", { MaxSize = Vector2.new(150, math.huge) }), SliderDisplay, SliderInput, SliderFill, SliderRail })

		local isHovering, inputVisible, currentWidthTween = false, false, nil
		local function calculateInputWidth(text)
			local textSize = TextService:GetTextSize(text or "0", 12, Enum.Font.SourceSans, Vector2.new(1000, 14))
			return math.max(25, math.min(80, textSize.X + 8))
		end
		local function updateInputWidth(text, animate)
			if currentWidthTween then currentWidthTween:Cancel(); currentWidthTween = nil end
			local targetWidth, currentWidth = calculateInputWidth(text), SliderInput.Size.X.Offset
			if animate and math.abs(targetWidth - currentWidth) > 0.5 then
				currentWidthTween = TweenService:Create(SliderInput, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, targetWidth, 0, 14) })
				currentWidthTween:Play()
				currentWidthTween.Completed:Connect(function() currentWidthTween = nil end)
			else
				SliderInput.Size = UDim2.new(0, targetWidth, 0, 14)
			end
		end
		Creator.AddSignal(SliderFrame.Frame.MouseEnter, function()
			isHovering = true
			if not SliderInput:IsFocused() then
				SliderDisplay.Visible = false
				SliderInput.Text = tostring(Slider.Value)
				updateInputWidth(tostring(Slider.Value), false)
				inputVisible = true
				local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				TweenService:Create(SliderInput, ti, { TextTransparency = 0, BackgroundTransparency = 0.75 }):Play()
				TweenService:Create(SliderInputStroke, ti, { Transparency = 0.5 }):Play()
			end
		end)
		Creator.AddSignal(SliderFrame.Frame.MouseLeave, function()
			isHovering = false
			if not SliderInput:IsFocused() and inputVisible then
				local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
				TweenService:Create(SliderInput, ti, { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
				TweenService:Create(SliderInputStroke, ti, { Transparency = 1 }):Play()
				task.wait(0.2)
				SliderDisplay.Visible = true
				inputVisible = false
			end
		end)
		Creator.AddSignal(SliderInput.Changed, function(property)
			if property == "Text" then
				local text = SliderInput.Text
				local cleanText = text:gsub("[^%d%.%-]", "")
				if cleanText:find("%-") and cleanText:find("%-") ~= 1 then cleanText = cleanText:gsub("%-", "") end
				local dotCount = 0
				cleanText = cleanText:gsub("%.", function() dotCount = dotCount + 1; return dotCount == 1 and "." or "" end)
				if cleanText ~= text then SliderInput.Text = cleanText; return end
				if inputVisible or SliderInput:IsFocused() then updateInputWidth(cleanText, true) end
			end
		end)
		Creator.AddSignal(SliderInput.FocusLost, function()
			local inputValue = tonumber(SliderInput.Text)
			if inputValue then Slider:SetValue(inputValue) else SliderInput.Text = tostring(Slider.Value); updateInputWidth(tostring(Slider.Value), true) end
			if not isHovering then
				local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
				TweenService:Create(SliderInput, ti, { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
				TweenService:Create(SliderInputStroke, ti, { Transparency = 1 }):Play()
				task.wait(0.2)
				SliderDisplay.Visible = true
				inputVisible = false
			end
		end)
		Creator.AddSignal(SliderInput.Focused, function()
			SliderInput.Text = tostring(Slider.Value)
			updateInputWidth(tostring(Slider.Value), false)
		end)
		Creator.AddSignal(SliderInput.InputBegan, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
		Creator.AddSignal(SliderDot.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = true end
		end)
		Creator.AddSignal(SliderDot.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
		end)
		Creator.AddSignal(UserInputService.InputChanged, function(input)
			if Dragging then
				local position = (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and input.Position or nil
				if position then
					local scale = math.clamp((position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
					Slider:SetValue(Slider.Min + (Slider.Max - Slider.Min) * scale)
				end
			end
		end)
		Creator.AddSignal(SliderRail.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				local scale = math.clamp((input.Position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
				Slider:SetValue(Slider.Min + (Slider.Max - Slider.Min) * scale)
			end
		end)
		Creator.AddSignal(SliderRail.InputEnded, function(input) if input.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)

		function Slider:OnChanged(fn) Slider.Changed = fn; fn(Slider.Value) end
		function Slider:SetValue(value)
			self.Value = Library:Round(math.clamp(value, Slider.Min, Slider.Max), Slider.Rounding)
			local pct = (self.Value - Slider.Min) / (Slider.Max - Slider.Min)
			SliderDot.Position = UDim2.new(pct, 0, 0.5, 0)
			SliderFill.Size = UDim2.fromScale(pct, 1)
			SliderDisplay.Text = tostring(self.Value)
			if inputVisible or SliderInput:IsFocused() then
				SliderInput.Text = tostring(self.Value)
				updateInputWidth(tostring(self.Value), not SliderInput:IsFocused())
			end
			if not inputVisible and not SliderInput:IsFocused() then SliderInput.Text = tostring(self.Value) end
			Library:SafeCallback(Slider.Callback, self.Value)
			Library:SafeCallback(Slider.Changed, self.Value)
		end
		function Slider:Destroy() SliderFrame:Destroy(); Library.Options[Idx] = nil end
		Slider:SetValue(Config.Default)
		Library.Options[Idx] = Slider
		return Slider
	end
	return Element
end)()

ElementsTable.Keybind = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Keybind"
	function Element:New(Idx, Config)
		assert(Config.Title, "KeyBind - Missing Title")
		assert(Config.Default, "KeyBind - Missing default value.")
		local defaultKey = typeof(Config.Default) == "EnumItem" and Config.Default.Name or tostring(Config.Default)
		local Keybind = {
			Value = defaultKey, Toggled = false, Mode = Config.Mode or "Toggle", Type = "Keybind",
			Callback = Config.Callback or function(v) end, ChangedCallback = Config.ChangedCallback or function(v) end,
		}

		local Picking = false
		local KeybindFrame = Components.Element(Config.Title, Config.Description, self.Container, true)
		Keybind.SetTitle, Keybind.SetDesc, Keybind.Visible, Keybind.Elements = KeybindFrame.SetTitle, KeybindFrame.SetDesc, KeybindFrame.Visible, KeybindFrame

		local KeybindIcon = New("ImageLabel", {
			Image = Library:GetIcon("keyboard"), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
			ImageTransparency = 0.35, ThemeTag = { ImageColor3 = "SubText" },
		})
		local KeybindDisplayLabel = New("TextLabel", {
			FontFace = Tokens.Font.regular, Text = defaultKey, TextTransparency = (defaultKey == "None") and 0.45 or 0,
			TextSize = Tokens.Text.md, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(0, 0, 0, 14),
			AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ThemeTag = { TextColor3 = "Text" },
		})
		local KeybindModeTag = New("TextLabel", {
			FontFace = Tokens.Font.regular, Text = "(" .. (Config.Mode or "Toggle") .. ")",
			Visible = (Config.Mode or "Toggle") ~= "Toggle", TextSize = Tokens.Text.xs, TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(0, 0, 0, 14), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
			TextTransparency = 0.45, ThemeTag = { TextColor3 = "SubText" },
		})
		local KeybindResetBtn = New("ImageButton", {
			Image = Library:GetIcon("x"), Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1,
			ImageTransparency = 1, ImageColor3 = Color3.fromRGB(235, 70, 70),
		})
		local KeybindRow = New("Frame", { Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1 }, {
			New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) }),
			KeybindIcon, KeybindDisplayLabel, KeybindModeTag, KeybindResetBtn,
		})
		local KeybindStroke = Stroke({ Transparency = 0.45, ThemeTag = { Color = "InputBorder" } })
		local KeybindDisplayFrame = New("TextButton", {
			Size = UDim2.fromOffset(0, 32), Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0, Parent = KeybindFrame.Frame, AutomaticSize = Enum.AutomaticSize.X,
			ThemeTag = { BackgroundColor3 = "InputBg" },
		}, { Corner("md"), New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }), KeybindStroke, KeybindRow })

		local Hovering = false
		local _, SetKeybindBg = Creator.SpringMotor(0, KeybindDisplayFrame, "BackgroundTransparency", true, false, { frequency = 8 })
		local _, SetKeybindStroke = Creator.SpringMotor(0.45, KeybindStroke, "Transparency", true, false, { frequency = 8 })
		local _, SetResetAlpha = Creator.SpringMotor(1, KeybindResetBtn, "ImageTransparency", true, false, { frequency = 8 })
		local function RefreshResetVisibility(hovering) SetResetAlpha((hovering and Keybind.Value ~= "None") and 0.35 or 1) end
		Creator.AddSignal(KeybindDisplayFrame.MouseEnter, function()
			Hovering = true
			if not Picking then SetKeybindBg(0.15); SetKeybindStroke(0.15) end
			RefreshResetVisibility(true)
		end)
		Creator.AddSignal(KeybindDisplayFrame.MouseLeave, function()
			Hovering = false
			if not Picking then SetKeybindBg(0); SetKeybindStroke(0.45) end
			RefreshResetVisibility(false)
		end)
		Creator.AddSignal(KeybindResetBtn.MouseButton1Click, function()
			if Keybind.Value == "None" then return end
			Keybind:SetValue("None", Keybind.Mode)
			Library:SafeCallback(Keybind.ChangedCallback, "None")
			Library:SafeCallback(Keybind.Changed, "None")
		end)

		function Keybind:GetState()
			if UserInputService:GetFocusedTextBox() and Keybind.Mode ~= "Always" then return false end
			if Keybind.Mode == "Always" then return true
			elseif Keybind.Mode == "Hold" then
				if Keybind.Value == "None" then return false end
				local Key = Keybind.Value
				if Key == "MouseLeft" or Key == "MouseRight" then
					return (Key == "MouseLeft" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1))
						or (Key == "MouseRight" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))
				else
					return UserInputService:IsKeyDown(Enum.KeyCode[Keybind.Value])
				end
			else
				return Keybind.Toggled
			end
		end
		function Keybind:SetValue(Key, Mode)
			Key = Key or Keybind.Key
			Mode = Mode or Keybind.Mode
			if typeof(Key) == "EnumItem" then Key = Key.Name end
			KeybindDisplayLabel.Text = tostring(Key)
			KeybindDisplayLabel.TextTransparency = (Key == "None") and 0.45 or 0
			KeybindModeTag.Text = "(" .. tostring(Mode) .. ")"
			KeybindModeTag.Visible = tostring(Mode) ~= "Toggle"
			Keybind.Value = Key
			Keybind.Mode = Mode
		end
		function Keybind:OnClick(Callback) Keybind.Clicked = Callback end
		function Keybind:OnChanged(Callback) Keybind.Changed = Callback; Callback(Keybind.Value) end
		function Keybind:DoClick()
			Library:SafeCallback(Keybind.Callback, Keybind.Toggled)
			Library:SafeCallback(Keybind.Clicked, Keybind.Toggled)
		end
		function Keybind:Destroy() KeybindFrame:Destroy(); Library.Options[Idx] = nil end

		Creator.AddSignal(KeybindDisplayFrame.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Picking = true
				KeybindDisplayLabel.Text = "Press a key..."
				KeybindDisplayLabel.TextTransparency = 0
				SetResetAlpha(1)
				Creator.OverrideTag(KeybindStroke, { Color = "Accent" })
				SetKeybindStroke(0.05)
				SetKeybindBg(0.15)
				task.wait(0.2)
				local Event
				Event = UserInputService.InputBegan:Connect(function(pressInput)
					local Key
					if pressInput.UserInputType == Enum.UserInputType.Keyboard then Key = pressInput.KeyCode.Name
					elseif pressInput.UserInputType == Enum.UserInputType.MouseButton1 then Key = "MouseLeft"
					elseif pressInput.UserInputType == Enum.UserInputType.MouseButton2 then Key = "MouseRight" end
					local EndedEvent
					EndedEvent = UserInputService.InputEnded:Connect(function(endInput)
						if endInput.KeyCode.Name == Key
							or (Key == "MouseLeft" and endInput.UserInputType == Enum.UserInputType.MouseButton1)
							or (Key == "MouseRight" and endInput.UserInputType == Enum.UserInputType.MouseButton2) then
							Picking = false
							KeybindDisplayLabel.Text = Key
							KeybindDisplayLabel.TextTransparency = 0
							Keybind.Value = Key
							Creator.OverrideTag(KeybindStroke, { Color = "InputBorder" })
							SetKeybindStroke(Hovering and 0.15 or 0.45)
							SetKeybindBg(Hovering and 0.15 or 0)
							RefreshResetVisibility(Hovering)
							Library:SafeCallback(Keybind.ChangedCallback, endInput.KeyCode or endInput.UserInputType)
							Library:SafeCallback(Keybind.Changed, endInput.KeyCode or endInput.UserInputType)
							Event:Disconnect()
							EndedEvent:Disconnect()
						end
					end)
				end)
			end
		end)
		Creator.AddSignal(UserInputService.InputBegan, function(input)
			if not Picking and not UserInputService:GetFocusedTextBox() then
				if Keybind.Mode == "Toggle" then
					local Key = Keybind.Value
					if Key == "MouseLeft" or Key == "MouseRight" then
						if (Key == "MouseLeft" and input.UserInputType == Enum.UserInputType.MouseButton1)
							or (Key == "MouseRight" and input.UserInputType == Enum.UserInputType.MouseButton2) then
							Keybind.Toggled = not Keybind.Toggled; Keybind:DoClick()
						end
					elseif input.UserInputType == Enum.UserInputType.Keyboard then
						if input.KeyCode.Name == Key then Keybind.Toggled = not Keybind.Toggled; Keybind:DoClick() end
					end
				end
			end
		end)
		Library.Options[Idx] = Keybind
		return Keybind
	end
	return Element
end)()

ElementsTable.Colorpicker = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Colorpicker"
	function Element:New(Idx, Config)
		assert(Config.Title, "Colorpicker - Missing Title")
		assert(Config.Default, "AddColorPicker: Missing default value.")
		-- Config.Transparency doubles as both "show the alpha slider" and
		-- "starting alpha" — normalize a plain boolean (true/false) to a
		-- number/nil so a caller that passes Transparency = true doesn't
		-- end up with a boolean stored as the transparency value.
		if type(Config.Transparency) == "boolean" then Config.Transparency = Config.Transparency and 0 or nil end
		local Colorpicker = {
			Value = Config.Default, Transparency = Config.Transparency or 0, Type = "Colorpicker",
			Title = type(Config.Title) == "string" and Config.Title or "Colorpicker",
			Callback = Config.Callback or function(c) end,
		}
		function Colorpicker:SetHSVFromRGB(Color)
			local H, S, V = Color3.toHSV(Color)
			Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib = H, S, V
		end
		Colorpicker:SetHSVFromRGB(Colorpicker.Value)

		local ColorpickerFrame = Components.Element(Config.Title, Config.Description, self.Container, true)
		Colorpicker.SetTitle, Colorpicker.SetDesc, Colorpicker.Visible, Colorpicker.Elements = ColorpickerFrame.SetTitle, ColorpickerFrame.SetDesc, ColorpickerFrame.Visible, ColorpickerFrame

		local CHECKER_IMG = "http://www.roblox.com/asset/?id=14204231522"
		local DisplayFrameColor = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Colorpicker.Value, Parent = nil }, { Corner("xs") })
		local DisplayFrame = New("ImageLabel", {
			Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
			Parent = ColorpickerFrame.Frame, Image = CHECKER_IMG, ImageTransparency = 0.45,
			ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.fromOffset(40, 40),
		}, { Corner("xs"), DisplayFrameColor })

		local function CreateColorDialog()
			local Dialog = Components.Dialog:Create()
			Dialog.Title.Text = Colorpicker.Title
			Dialog.Root.Size = UDim2.fromOffset(460, 460)
			local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
			local Transparency = Colorpicker.Transparency
			local StartColor, StartTransparency = Colorpicker.Value, Colorpicker.Transparency

			local ROOT_W = 460
			local MAP_X, MAP_Y, MAP_SIZE = 20, 130, 190
			local SLIDER_W, SLIDER_GAP = 16, 14
			local HUE_X = MAP_X + MAP_SIZE + SLIDER_GAP
			local ALPHA_X = HUE_X + SLIDER_W + SLIDER_GAP
			local INPUTS_X = (Config.Transparency and (ALPHA_X + SLIDER_W + SLIDER_GAP)) or (HUE_X + SLIDER_W + SLIDER_GAP)
			local INPUTS_W = ROOT_W - 20 - INPUTS_X
			local function CreateInput()
				local Box = Components.Textbox()
				Box.Frame.Parent = Dialog.Root
				Box.Frame.Size = UDim2.new(0, 90, 0, 32)
				return Box
			end
			local function Caption(Text, Pos, Width)
				return New("TextLabel", {
					FontFace = Tokens.Font.semibold, Text = string.upper(Text), TextSize = Tokens.Text.xs,
					TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(0, Width or 190, 0, 14),
					Position = Pos, BackgroundTransparency = 1, Parent = Dialog.Root, ThemeTag = { TextColor3 = "SubText" },
				})
			end
			local function MakeSwatch(X, Y, W, H, Color, Trans, cornerKey)
				local ColorFrame = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color, BackgroundTransparency = Trans }, { Corner(cornerKey or "sm") })
				local Holder = New("ImageLabel", {
					Image = CHECKER_IMG, ImageTransparency = 0.45, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.fromOffset(40, 40),
					BackgroundTransparency = 1, Size = UDim2.fromOffset(W, H), Position = UDim2.fromOffset(X, Y), Parent = Dialog.Root,
				}, { Corner(cornerKey or "sm"), Stroke({ Transparency = 0.55, ThemeTag = { Color = "SurfaceBorder" } }), ColorFrame })
				return Holder, ColorFrame
			end
			local function GetRGB()
				local v = Color3.fromHSV(Hue, Sat, Vib)
				return { R = math.floor(v.R * 255 + 0.5), G = math.floor(v.G * 255 + 0.5), B = math.floor(v.B * 255 + 0.5) }
			end

			Caption("Current", UDim2.fromOffset(MAP_X, 58))
			Caption("New", UDim2.fromOffset(MAP_X + 210, 58))
			local _, CurrentColorFrame = MakeSwatch(MAP_X, 74, 190, 42, StartColor, StartTransparency)
			local _, NewColorFrame = MakeSwatch(MAP_X + 210, 74, 190, 42, Color3.fromHSV(Hue, Sat, Vib), Transparency)

			local SatCursor = New("ImageLabel", {
				Size = UDim2.fromOffset(20, 20), ScaleType = Enum.ScaleType.Fit, AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1, Image = "http://www.roblox.com/asset/?id=4805639000", ZIndex = 3,
			})
			local SatVibMap = New("ImageLabel", {
				Size = UDim2.fromOffset(MAP_SIZE, MAP_SIZE), Position = UDim2.fromOffset(MAP_X, MAP_Y),
				Image = "rbxassetid://4155801252", BackgroundColor3 = Colorpicker.Value, BackgroundTransparency = 0, Parent = Dialog.Root,
			}, { Corner("sm"), Stroke({ Transparency = 0.55, ThemeTag = { Color = "SurfaceBorder" } }), SatCursor })

			local SequenceTable = {}
			for c = 0, 1, 0.1 do table.insert(SequenceTable, ColorSequenceKeypoint.new(c, Color3.fromHSV(c, 1, 1))) end
			local HueSliderGradient = New("UIGradient", { Color = ColorSequence.new(SequenceTable), Rotation = 90 })
			local HueDragHolder = New("Frame", { Size = UDim2.new(1, 0, 1, -16), Position = UDim2.fromOffset(0, 8), BackgroundTransparency = 1 })
			local HueDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(16, 16), Image = "http://www.roblox.com/asset/?id=12266946128",
				Parent = HueDragHolder, ThemeTag = { ImageColor3 = "Text" },
			})
			local HueSlider = New("Frame", { Size = UDim2.fromOffset(SLIDER_W, MAP_SIZE), Position = UDim2.fromOffset(HUE_X, MAP_Y), Parent = Dialog.Root }, {
				Corner("pill"), Stroke({ Transparency = 0.6, ThemeTag = { Color = "SurfaceBorder" } }), HueSliderGradient, HueDragHolder,
			})

			local TransparencySlider, TransparencyDrag, TransparencyColor
			if Config.Transparency then
				local TransparencyDragHolder = New("Frame", { Size = UDim2.new(1, 0, 1, -16), Position = UDim2.fromOffset(0, 8), BackgroundTransparency = 1 })
				TransparencyDrag = New("ImageLabel", {
					Size = UDim2.fromOffset(16, 16), Image = "http://www.roblox.com/asset/?id=12266946128",
					Parent = TransparencyDragHolder, ThemeTag = { ImageColor3 = "Text" },
				})
				TransparencyColor = New("Frame", { Size = UDim2.fromScale(1, 1) }, {
					New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }), Rotation = 270 }),
					Corner("pill"),
				})
				TransparencySlider = New("Frame", { Size = UDim2.fromOffset(SLIDER_W, MAP_SIZE), Position = UDim2.fromOffset(ALPHA_X, MAP_Y), Parent = Dialog.Root, BackgroundTransparency = 1 }, {
					Corner("pill"), Stroke({ Transparency = 0.6, ThemeTag = { Color = "SurfaceBorder" } }),
					New("ImageLabel", { Image = CHECKER_IMG, ImageTransparency = 0.45, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.fromOffset(40, 40), BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, { Corner("pill") }),
					TransparencyColor, TransparencyDragHolder,
				})
			end

			Caption("Hex", UDim2.fromOffset(INPUTS_X, MAP_Y))
			local HexInput = CreateInput()
			HexInput.Frame.Size = UDim2.new(0, INPUTS_W, 0, 32)
			HexInput.Frame.Position = UDim2.fromOffset(INPUTS_X, MAP_Y + 16)
			Caption("R                    G                    B", UDim2.fromOffset(INPUTS_X, MAP_Y + 56))
			local RGB_GAP = 8
			local RGB_W = (INPUTS_W - RGB_GAP * 2) / 3
			local RedInput = CreateInput(); RedInput.Frame.Size = UDim2.new(0, RGB_W, 0, 32); RedInput.Frame.Position = UDim2.fromOffset(INPUTS_X, MAP_Y + 72)
			local GreenInput = CreateInput(); GreenInput.Frame.Size = UDim2.new(0, RGB_W, 0, 32); GreenInput.Frame.Position = UDim2.fromOffset(INPUTS_X + RGB_W + RGB_GAP, MAP_Y + 72)
			local BlueInput = CreateInput(); BlueInput.Frame.Size = UDim2.new(0, RGB_W, 0, 32); BlueInput.Frame.Position = UDim2.fromOffset(INPUTS_X + (RGB_W + RGB_GAP) * 2, MAP_Y + 72)
			local AlphaInput
			if Config.Transparency then
				Caption("Alpha", UDim2.fromOffset(INPUTS_X, MAP_Y + 112))
				AlphaInput = CreateInput()
				AlphaInput.Frame.Size = UDim2.new(0, INPUTS_W, 0, 32)
				AlphaInput.Frame.Position = UDim2.fromOffset(INPUTS_X, MAP_Y + 128)
			end
			local function Display()
				SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
				HueDrag.Position = UDim2.new(0, -1, Hue, -8)
				SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)
				NewColorFrame.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
				NewColorFrame.BackgroundTransparency = Transparency
				HexInput.Input.Text = "#" .. Color3.fromHSV(Hue, Sat, Vib):ToHex()
				local RGB = GetRGB()
				RedInput.Input.Text = RGB.R
				GreenInput.Input.Text = RGB.G
				BlueInput.Input.Text = RGB.B
				if Config.Transparency then
					TransparencyColor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
					TransparencyDrag.Position = UDim2.new(0, -1, 1 - Transparency, -8)
					AlphaInput.Input.Text = Library:Round((1 - Transparency) * 100, 0) .. "%"
				end
			end
			Creator.AddSignal(HexInput.Input.FocusLost, function(enter)
				if enter then
					local ok, result = pcall(Color3.fromHex, HexInput.Input.Text)
					if ok and typeof(result) == "Color3" then Hue, Sat, Vib = Color3.toHSV(result) end
				end
				Display()
			end)
			Creator.AddSignal(RedInput.Input.FocusLost, function(enter)
				if enter then
					local current = GetRGB()
					local ok, result = pcall(Color3.fromRGB, RedInput.Input.Text, current.G, current.B)
					if ok and typeof(result) == "Color3" and tonumber(RedInput.Input.Text) and tonumber(RedInput.Input.Text) <= 255 then Hue, Sat, Vib = Color3.toHSV(result) end
				end
				Display()
			end)
			Creator.AddSignal(GreenInput.Input.FocusLost, function(enter)
				if enter then
					local current = GetRGB()
					local ok, result = pcall(Color3.fromRGB, current.R, GreenInput.Input.Text, current.B)
					if ok and typeof(result) == "Color3" and tonumber(GreenInput.Input.Text) and tonumber(GreenInput.Input.Text) <= 255 then Hue, Sat, Vib = Color3.toHSV(result) end
				end
				Display()
			end)
			Creator.AddSignal(BlueInput.Input.FocusLost, function(enter)
				if enter then
					local current = GetRGB()
					local ok, result = pcall(Color3.fromRGB, current.R, current.G, BlueInput.Input.Text)
					if ok and typeof(result) == "Color3" and tonumber(BlueInput.Input.Text) and tonumber(BlueInput.Input.Text) <= 255 then Hue, Sat, Vib = Color3.toHSV(result) end
				end
				Display()
			end)
			if Config.Transparency then
				Creator.AddSignal(AlphaInput.Input.FocusLost, function(enter)
					if enter then
						pcall(function()
							local value = tonumber(AlphaInput.Input.Text)
							if value and value >= 0 and value <= 100 then Transparency = 1 - value * 0.01 end
						end)
					end
					Display()
				end)
			end
			Creator.AddSignal(SatVibMap.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local minX, maxX = SatVibMap.AbsolutePosition.X, SatVibMap.AbsolutePosition.X + SatVibMap.AbsoluteSize.X
						local minY, maxY = SatVibMap.AbsolutePosition.Y, SatVibMap.AbsolutePosition.Y + SatVibMap.AbsoluteSize.Y
						local mx, my = math.clamp(Mouse.X, minX, maxX), math.clamp(Mouse.Y, minY, maxY)
						Sat = (mx - minX) / (maxX - minX)
						Vib = 1 - ((my - minY) / (maxY - minY))
						Display()
						RenderStepped:Wait()
					end
				end
			end)
			Creator.AddSignal(HueSlider.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local minY, maxY = HueSlider.AbsolutePosition.Y, HueSlider.AbsolutePosition.Y + HueSlider.AbsoluteSize.Y
						local my = math.clamp(Mouse.Y, minY, maxY)
						Hue = (my - minY) / (maxY - minY)
						Display()
						RenderStepped:Wait()
					end
				end
			end)
			if Config.Transparency then
				Creator.AddSignal(TransparencySlider.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local minY, maxY = TransparencySlider.AbsolutePosition.Y, TransparencySlider.AbsolutePosition.Y + TransparencySlider.AbsoluteSize.Y
							local my = math.clamp(Mouse.Y, minY, maxY)
							Transparency = 1 - ((my - minY) / (maxY - minY))
							Display()
							RenderStepped:Wait()
						end
					end
				end)
			end

			local PRESETS = {
				Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 70, 70), Color3.fromRGB(255, 150, 60),
				Color3.fromRGB(255, 225, 70), Color3.fromRGB(90, 220, 120), Color3.fromRGB(70, 190, 255), Color3.fromRGB(90, 120, 255),
				Color3.fromRGB(180, 110, 255), Color3.fromRGB(255, 110, 190),
			}
			Caption("Presets", UDim2.fromOffset(MAP_X, MAP_Y + MAP_SIZE + 16))
			local PresetHolder = New("Frame", {
				Size = UDim2.new(1, -40, 0, 28), Position = UDim2.fromOffset(MAP_X, MAP_Y + MAP_SIZE + 32), BackgroundTransparency = 1, Parent = Dialog.Root,
			}, { New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }) })
			for _, presetColor in ipairs(PRESETS) do
				local swatchStroke = Stroke({ Transparency = 0.5, ThemeTag = { Color = "SurfaceBorder" } })
				local Swatch = New("TextButton", { Text = "", Size = UDim2.fromOffset(28, 28), BackgroundColor3 = presetColor, Parent = PresetHolder }, { Corner("pill"), swatchStroke })
				Creator.AddSignal(Swatch.MouseEnter, function() swatchStroke.Transparency = 0; swatchStroke.Thickness = 2 end)
				Creator.AddSignal(Swatch.MouseLeave, function() swatchStroke.Transparency = 0.5; swatchStroke.Thickness = Tokens.Border end)
				Creator.AddSignal(Swatch.MouseButton1Click, function() Hue, Sat, Vib = Color3.toHSV(presetColor); Display() end)
			end
			Display()
			Dialog:Button("Done", function() Colorpicker:SetValue({ Hue, Sat, Vib }, Transparency) end, true)
			Dialog:Button("Cancel")
			Dialog:Open()
		end
		function Colorpicker:Display()
			Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)
			DisplayFrameColor.BackgroundColor3 = Colorpicker.Value
			DisplayFrameColor.BackgroundTransparency = Colorpicker.Transparency
			Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
			Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
		end
		function Colorpicker:SetValue(HSV, transparency)
			local color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
			Colorpicker.Transparency = transparency or 0
			Colorpicker:SetHSVFromRGB(color)
			Colorpicker:Display()
		end
		function Colorpicker:SetValueRGB(color, transparency)
			Colorpicker.Transparency = transparency or 0
			Colorpicker:SetHSVFromRGB(color)
			Colorpicker:Display()
		end
		function Colorpicker:OnChanged(fn) Colorpicker.Changed = fn; fn(Colorpicker.Value) end
		function Colorpicker:Destroy() ColorpickerFrame:Destroy(); Library.Options[Idx] = nil end
		Creator.AddSignal(ColorpickerFrame.Frame.MouseButton1Click, CreateColorDialog)
		Creator.AddSignal(ColorpickerFrame.Frame.InputBegan, function(input) if input.UserInputType == Enum.UserInputType.Touch then CreateColorDialog() end end)
		Colorpicker:Display()
		Library.Options[Idx] = Colorpicker
		return Colorpicker
	end
	return Element
end)()

ElementsTable.Input = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Input"
	function Element:New(Idx, Config)
		assert(Config.Title, "Input - Missing Title")
		Config.Callback = Config.Callback or function() end
		local Input = { Value = Config.Default or "", Numeric = Config.Numeric or false, Finished = Config.Finished or false, Callback = Config.Callback, Type = "Input" }

		local InputFrame = Components.Element(Config.Title, Config.Description, self.Container, false)
		Input.SetTitle, Input.SetDesc, Input.Visible, Input.Elements = InputFrame.SetTitle, InputFrame.SetDesc, InputFrame.Visible, InputFrame
		local Textbox = Components.Textbox(InputFrame.Frame)
		Textbox.Frame.Position = UDim2.new(1, -10, 0.5, 0)
		Textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
		Textbox.Frame.Size = UDim2.fromOffset(160, 32)
		Textbox.Input.Text = Config.Default or ""
		Textbox.Input.PlaceholderText = Config.Placeholder or ""
		local Box = Textbox.Input

		local ClearBtn = New("ImageButton", {
			Image = Library:GetIcon("x"), Size = UDim2.fromOffset(12, 12), Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, ImageTransparency = 1,
			ImageColor3 = Color3.fromRGB(235, 70, 70), Parent = Textbox.Frame,
		})
		Textbox.Container.Size = UDim2.new(1, -30, 1, 0)
		local _, SetClearAlpha = Creator.SpringMotor(1, ClearBtn, "ImageTransparency", true, false, { frequency = 8 })
		local function RefreshClearBtn(hovering) SetClearAlpha((hovering and Box.Text ~= "") and 0.35 or 1) end
		Creator.AddSignal(Textbox.Frame.MouseEnter, function() RefreshClearBtn(true) end)
		Creator.AddSignal(Textbox.Frame.MouseLeave, function() RefreshClearBtn(false) end)
		Creator.AddSignal(ClearBtn.MouseButton1Click, function() Input:SetValue("") end)

		local function FlashInvalid()
			task.spawn(function()
				local origPos = Textbox.Frame.Position
				for _, amp in ipairs({ 6, -5, 4, -3, 2, 0 }) do
					TweenService:Create(Textbox.Frame, TweenInfo.new(0.035, Enum.EasingStyle.Sine), {
						Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + amp, origPos.Y.Scale, origPos.Y.Offset),
					}):Play()
					task.wait(0.035)
				end
				Textbox.Frame.Position = origPos
			end)
			TweenService:Create(Textbox.Stroke, TweenInfo.new(0.1), { Color = Color3.fromRGB(235, 70, 70), Transparency = 0.15 }):Play()
			task.delay(0.6, function()
				if Textbox.Stroke and Textbox.Stroke.Parent then
					Creator.OverrideTag(Textbox.Stroke, { Color = "InputBorder" })
					if Textbox.SetStrokeTransparency and Textbox.BaseStrokeTransparency then
						Textbox.SetStrokeTransparency(Textbox.BaseStrokeTransparency)
					end
				end
			end)
		end
		function Input:SetValue(Text)
			local wasInvalid = false
			if Config.MaxLength and #Text > Config.MaxLength then Text = Text:sub(1, Config.MaxLength); wasInvalid = true end
			if Input.Numeric then
				if (not tonumber(Text)) and Text:len() > 0 then Text = Input.Value; wasInvalid = true end
			end
			if wasInvalid then FlashInvalid() end
			Input.Value = Text
			Box.Text = Text
			Library:SafeCallback(Input.Callback, Input.Value)
			Library:SafeCallback(Input.Changed, Input.Value)
		end
		if Input.Finished then
			AddSignal(Box.FocusLost, function(enter) if enter then Input:SetValue(Box.Text) end end)
		else
			AddSignal(Box:GetPropertyChangedSignal("Text"), function() Input:SetValue(Box.Text) end)
		end
		function Input:OnChanged(fn) Input.Changed = fn; fn(Input.Value) end
		function Input:Destroy() InputFrame:Destroy(); Library.Options[Idx] = nil end
		Library.Options[Idx] = Input
		return Input
	end
	return Element
end)()

ElementsTable.Separator = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Separator"
	function Element:New(Idx, Config)
		Config = Config or {}
		Config.Label = Config.Label or ""
		local Sep = { Type = "Separator" }
		local Root = New("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Parent = self.Container, LayoutOrder = 7 })
		if Config.Label ~= "" then
			New("TextLabel", {
				Text = Config.Label, FontFace = Tokens.Font.semibold, TextSize = Tokens.Text.xs,
				Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 14), AutomaticSize = Enum.AutomaticSize.X, Parent = Root, ThemeTag = { TextColor3 = "SubText" },
			})
		end
		New("Frame", {
			Size = UDim2.new(0.5, Config.Label ~= "" and -10 or 0, 0, 1), Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5), Parent = Root, BackgroundTransparency = 0.6, ThemeTag = { BackgroundColor3 = "Divider" },
		}, { New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }) }) })
		New("Frame", {
			Size = UDim2.new(0.5, Config.Label ~= "" and -10 or 0, 0, 1), Position = UDim2.fromScale(1, 0.5),
			AnchorPoint = Vector2.new(1, 0.5), Parent = Root, BackgroundTransparency = 0.6, ThemeTag = { BackgroundColor3 = "Divider" },
		}, { New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) }) })
		function Sep:Destroy() Root:Destroy(); if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = Sep end
		return Sep
	end
	return Element
end)()

ElementsTable.Alert = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Alert"
	local AlertColors = {
		info = { bg = Color3.fromRGB(30, 80, 160), icon = "rbxassetid://10723415903" },
		success = { bg = Color3.fromRGB(30, 130, 80), icon = "rbxassetid://10709751939" },
		warning = { bg = Color3.fromRGB(160, 110, 20), icon = "rbxassetid://10709753149" },
		error = { bg = Color3.fromRGB(160, 35, 35), icon = "rbxassetid://10709752996" },
	}
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Alert - Missing Title")
		Config.Type = Config.Type or "info"
		Config.Content = Config.Content or ""
		local Alert = { Type = "Alert" }
		local style = AlertColors[Config.Type] or AlertColors.info
		local Root = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = style.bg,
			BackgroundTransparency = 0.75, Parent = self.Container, LayoutOrder = 7,
		}, {
			Corner("sm"), Stroke({ Color = style.bg, Transparency = 0.3 }),
			New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) }),
			New("UIListLayout", { Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Top }),
			New("ImageLabel", { Image = style.icon, Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, ImageColor3 = Color3.new(1, 1, 1), LayoutOrder = 1 }),
			New("Frame", { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, -22, 0, 0), LayoutOrder = 2 }, {
				New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
				New("TextLabel", {
					Text = Config.Title, FontFace = Tokens.Font.bold, TextSize = Tokens.Text.md, TextColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1,
				}),
				New("TextLabel", {
					Text = Config.Content, FontFace = Tokens.Font.medium, TextSize = Tokens.Text.sm, TextColor3 = Color3.fromRGB(220, 220, 220),
					BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 2, Visible = Config.Content ~= "",
				}),
			}),
		})
		function Alert:Destroy() Root:Destroy(); if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = Alert end
		return Alert
	end
	return Element
end)()

ElementsTable.Checkbox = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Checkbox"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Checkbox - Missing Title")
		local Checkbox = { Value = Config.Default or false, Type = "Checkbox", Callback = Config.Callback or function() end }
		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		Checkbox.SetTitle, Checkbox.SetDesc, Checkbox.Visible, Checkbox.Elements = CBFrame.SetTitle, CBFrame.SetDesc, CBFrame.Visible, CBFrame
		local CheckBg = New("Frame", {
			Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -12, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88, Parent = CBFrame.Frame, ThemeTag = { BackgroundColor3 = "Accent" },
		}, { Corner("sm"), Stroke({ Transparency = 0.35, ThemeTag = { Color = "Accent" } }) })
		local CheckMark = New("ImageLabel", {
			Image = "rbxassetid://10734966248", Size = UDim2.fromOffset(11, 11), Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 1, Parent = CheckBg,
		})
		local function UpdateVisual(val)
			local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			local popTi = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			TweenService:Create(CheckBg, ti, { BackgroundTransparency = val and 0.05 or 0.88 }):Play()
			TweenService:Create(CheckMark, popTi, { ImageTransparency = val and 0 or 1, Size = val and UDim2.fromOffset(13, 13) or UDim2.fromOffset(7, 7) }):Play()
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
		function Checkbox:OnChanged(fn) Checkbox.Changed = fn; fn(Checkbox.Value) end
		function Checkbox:Destroy() CBFrame.Frame:Destroy(); if Idx then Library.Options[Idx] = nil end end
		UpdateVisual(Config.Default or false)
		if Idx then Library.Options[Idx] = Checkbox end
		return Checkbox
	end
	return Element
end)()

ElementsTable.RadioGroup = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "RadioGroup"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "RadioGroup - Missing Title")
		assert(Config.Options, "RadioGroup - Missing Options table")
		local IsMulti = Config.Multi or false
		local Radio = { Options = Config.Options, Type = "RadioGroup", IsMulti = IsMulti, Callback = Config.Callback or function() end }
		if IsMulti then
			Radio.Value = {}
			if type(Config.Default) == "table" then for _, v in pairs(Config.Default) do Radio.Value[v] = true end
			elseif Config.Default ~= nil then Radio.Value[Config.Default] = true end
		else
			Radio.Value = Config.Default or Config.Options[1]
		end
		local RGFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		Radio.SetTitle, Radio.SetDesc, Radio.Visible, Radio.Elements = RGFrame.SetTitle, RGFrame.SetDesc, RGFrame.Visible, RGFrame

		local ColumnCount = Config.Columns or (#Config.Options > 6 and 2 or 1)
		local RowHeight = 28
		local OptionsHolder = New("Frame", {
			Size = UDim2.new(1, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1, Parent = RGFrame.LabelHolder, LayoutOrder = 3,
		}, {
			(ColumnCount > 1) and New("UIGridLayout", {
				CellSize = UDim2.new(1 / ColumnCount, -4, 0, RowHeight), CellPadding = UDim2.new(0, 8, 0, 6),
				FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Left,
			}) or New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
			New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 6) }),
		})

		local Buttons = {}
		local function GetCallbackValue()
			if not IsMulti then return Radio.Value end
			local selected = {}
			for _, opt in ipairs(Radio.Options) do if Radio.Value[opt] then table.insert(selected, opt) end end
			return selected
		end
		local function UpdateRadio()
			for _, btn in pairs(Buttons) do
				local isSelected = IsMulti and (Radio.Value[btn.Value] == true) or (btn.Value == Radio.Value)
				btn.Selected = isSelected
				local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				TweenService:Create(btn.Outer, ti, { BackgroundTransparency = isSelected and 0 or 0.92, Size = isSelected and UDim2.fromOffset(18, 18) or UDim2.fromOffset(16, 16) }):Play()
				TweenService:Create(btn.OuterStroke, ti, { Transparency = isSelected and 1 or 0.55 }):Play()
				TweenService:Create(btn.Inner, ti, { BackgroundTransparency = isSelected and 0 or 1, Size = isSelected and UDim2.fromOffset(9, 9) or UDim2.fromOffset(5, 5) }):Play()
				TweenService:Create(btn.Stroke, ti, { Transparency = isSelected and 0.4 or 1 }):Play()
				btn.SetCardTransparency(btn.Hovering and 0.8 or (isSelected and 0.85 or 0.94))
			end
		end
		for _, opt in ipairs(Config.Options) do
			local Row = New("TextButton", {
				Size = UDim2.new(1, 0, 0, RowHeight), BackgroundTransparency = 0.94, Text = "", Parent = OptionsHolder,
				ThemeTag = { BackgroundColor3 = "InputBg" },
			}, {
				Corner("xs"), Stroke({ Transparency = 1, ThemeTag = { Color = "Accent" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
				New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Center }),
			})
			local RowStroke = Row:FindFirstChildOfClass("UIStroke")
			local Outer = New("Frame", { Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 0.92, Parent = Row, ThemeTag = { BackgroundColor3 = "Accent" } }, {
				Corner("xs"), New("UIAspectRatioConstraint", { AspectRatio = 1 }), Stroke({ Thickness = 1.2, Transparency = 0.55, ThemeTag = { Color = "Accent" } }),
			})
			local OuterStroke = Outer:FindFirstChildOfClass("UIStroke")
			local Inner = New("Frame", {
				Size = UDim2.fromOffset(4, 4), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1, Parent = Outer, BackgroundColor3 = Color3.new(1, 1, 1),
			}, { Corner("xs") })
			New("TextLabel", {
				Text = tostring(opt), FontFace = Tokens.Font.medium, TextSize = Tokens.Text.md, TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1, Size = UDim2.new(1, -24, 1, 0), Parent = Row, ThemeTag = { TextColor3 = "Text" },
			})
			local _, SetCardTransparency = Creator.SpringMotor(0.94, Row, "BackgroundTransparency")
			local BtnData = { Value = opt, Outer = Outer, Inner = Inner, Stroke = RowStroke, OuterStroke = OuterStroke, SetCardTransparency = SetCardTransparency, Hovering = false, Selected = false }
			table.insert(Buttons, BtnData)
			Creator.AddSignal(Row.MouseEnter, function() BtnData.Hovering = true; SetCardTransparency(0.8) end)
			Creator.AddSignal(Row.MouseLeave, function() BtnData.Hovering = false; SetCardTransparency(BtnData.Selected and 0.85 or 0.94) end)
			Creator.AddSignal(Row.MouseButton1Click, function()
				if IsMulti then
					if Radio.Value[opt] then Radio.Value[opt] = nil else Radio.Value[opt] = true end
				else
					Radio.Value = opt
				end
				UpdateRadio()
				local retVal = GetCallbackValue()
				Library:SafeCallback(Radio.Callback, retVal)
				Library:SafeCallback(Radio.Changed, retVal)
			end)
		end
		function Radio:SetValue(val)
			if IsMulti then
				Radio.Value = {}
				if type(val) == "table" then for _, v in pairs(val) do Radio.Value[v] = true end
				elseif val ~= nil then Radio.Value[val] = true end
			else
				Radio.Value = val
			end
			UpdateRadio()
			local retVal = GetCallbackValue()
			Library:SafeCallback(self.Callback, retVal)
			Library:SafeCallback(self.Changed, retVal)
		end
		function Radio:OnChanged(fn) Radio.Changed = fn; fn(GetCallbackValue()) end
		function Radio:Destroy() RGFrame.Frame:Destroy(); if Idx then Library.Options[Idx] = nil end end
		UpdateRadio()
		if Idx then Library.Options[Idx] = Radio end
		return Radio
	end
	return Element
end)()

ElementsTable.ActionButton = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "ActionButton"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "ActionButton - Missing Title")
		Config.CopyText = Config.CopyText or ""
		local idleLabel, copiedLabel = Config.ButtonText or "Copy", Config.CopiedText or "✓ Copied"
		local resetDelay = Config.ResetDelay or 1.5
		local btnWidth, btnHeight = Config.ButtonWidth or 68, Config.ButtonHeight or 26
		local confirmEnabled = Config.Confirm == true
		local confirmTitle = Config.ConfirmTitle or "ยืนยันการทำงาน"
		local confirmText = Config.ConfirmText or Config.ConfirmContent or ("คุณต้องการทำรายการ \"" .. tostring(Config.Title) .. "\" หรือไม่?")
		local confirmYesText = Config.ConfirmYesText or Config.ConfirmButtonText or "ยืนยัน"
		local confirmNoText = Config.ConfirmNoText or Config.CancelButtonText or "ยกเลิก"
		local dialogBusy = false

		local CB = { Type = "ActionButton", Value = Config.CopyText }
		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		CB.SetTitle, CB.SetDesc, CB.Visible, CB.Elements = CBFrame.SetTitle, CBFrame.SetDesc, CBFrame.Visible, CBFrame

		local CopyBtn = New("TextButton", {
			Text = idleLabel, FontFace = Tokens.Font.medium, TextSize = Tokens.Text.sm, Size = UDim2.fromOffset(btnWidth, btnHeight),
			Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 0.85,
			AutoButtonColor = false, Parent = CBFrame.Frame, ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
		}, { Corner("xs"), Stroke({ Transparency = 0.5, ThemeTag = { Color = "Accent" } }) })
		local _, SetCopyT = Creator.SpringMotor(0.85, CopyBtn, "BackgroundTransparency")
		Creator.AddSignal(CopyBtn.MouseEnter, function() SetCopyT(0.72) end)
		Creator.AddSignal(CopyBtn.MouseLeave, function() SetCopyT(0.85) end)
		Creator.AddSignal(CopyBtn.MouseButton1Down, function() SetCopyT(0.6) end)
		Creator.AddSignal(CopyBtn.MouseButton1Up, function() SetCopyT(0.72) end)

		local function RunAction()
			pcall(function() if setclipboard then setclipboard(CB.Value) elseif toclipboard then toclipboard(CB.Value) end end)
			CopyBtn.Text = copiedLabel
			task.delay(resetDelay, function() if CopyBtn and CopyBtn.Parent then CopyBtn.Text = idleLabel end end)
			Library:SafeCallback(Config.Callback, CB.Value)
		end
		Creator.AddSignal(CopyBtn.MouseButton1Click, function()
			if not confirmEnabled then RunAction(); return end
			if dialogBusy then return end
			dialogBusy = true
			if Library.Window and Library.Window.Dialog then
				Library.Window:Dialog({
					Title = confirmTitle, Content = confirmText,
					Buttons = {
						{ Title = confirmYesText, Callback = function() dialogBusy = false; RunAction(); Library:SafeCallback(Config.OnConfirm, CB.Value) end },
						{ Title = confirmNoText, Callback = function() dialogBusy = false; Library:SafeCallback(Config.OnCancel, CB.Value) end },
					},
				})
			else
				dialogBusy = false
				RunAction()
			end
		end)
		function CB:SetCopyText(t) self.Value = t end
		function CB:SetButtonText(idle, copied)
			idleLabel, copiedLabel = idle or idleLabel, copied or copiedLabel
			if CopyBtn and CopyBtn.Parent then CopyBtn.Text = idleLabel end
		end
		function CB:SetConfirm(enabled) confirmEnabled = enabled == true end
		function CB:SetConfirmText(title, text, yesText, noText)
			confirmTitle, confirmText, confirmYesText, confirmNoText = title or confirmTitle, text or confirmText, yesText or confirmYesText, noText or confirmNoText
		end
		function CB:Destroy() CBFrame.Frame:Destroy(); if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = CB end
		return CB
	end
	return Element
end)()

ElementsTable.QuickActions = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "QuickActions"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "QuickActions - Missing Title")
		assert(Config.Actions, "QuickActions - Missing Actions table")
		local QA = { Type = "QuickActions" }
		local QAFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		QA.SetTitle, QA.SetDesc, QA.Visible, QA.Elements = QAFrame.SetTitle, QAFrame.SetDesc, QAFrame.Visible, QAFrame
		local ActionsHolder = New("Frame", {
			Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Parent = QAFrame.Frame,
		}, { New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = Enum.HorizontalAlignment.Right }) })
		for _, action in ipairs(Config.Actions) do
			local iconImg = action.Icon and Library:GetIcon(action.Icon) or action.Image or ""
			local Btn = New("TextButton", {
				Size = UDim2.fromOffset(30, 30), BackgroundTransparency = 0, Text = action.Icon and "" or (action.Text or ""),
				FontFace = Tokens.Font.medium, TextSize = Tokens.Text.xs, Parent = ActionsHolder,
				ThemeTag = { BackgroundColor3 = "InputBg", TextColor3 = "Text" },
			}, {
				Corner("sm"), Stroke({ Transparency = 0.6, ThemeTag = { Color = "InputBorder" } }),
				iconImg ~= "" and New("ImageLabel", {
					Image = iconImg, Size = UDim2.fromOffset(14, 14), Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ThemeTag = { ImageColor3 = "Text" },
				}) or nil,
			})
			local _, SetT = Creator.SpringMotor(0, Btn, "BackgroundTransparency")
			Creator.AddSignal(Btn.MouseEnter, function() SetT(0.13) end)
			Creator.AddSignal(Btn.MouseLeave, function() SetT(0) end)
			Creator.AddSignal(Btn.MouseButton1Down, function() SetT(0.25) end)
			Creator.AddSignal(Btn.MouseButton1Up, function() SetT(0.13) end)
			Creator.AddSignal(Btn.MouseButton1Click, function() Library:SafeCallback(action.Callback) end)
		end
		function QA:Destroy() QAFrame.Frame:Destroy(); if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = QA end
		return QA
	end
	return Element
end)()

ElementsTable.ButtonGroup = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "ButtonGroup"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "ButtonGroup - Missing Title")
		assert(Config.Buttons, "ButtonGroup - Missing Buttons")
		local BG = { Type = "ButtonGroup" }
		local BGFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		BG.SetTitle, BG.SetDesc, BG.Visible, BG.Elements = BGFrame.SetTitle, BGFrame.SetDesc, BGFrame.Visible, BGFrame
		local BtnRow = New("Frame", {
			Size = UDim2.fromOffset(0, 28), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Parent = BGFrame.Frame,
		}, { New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Center }) })
		for _, btn in ipairs(Config.Buttons) do
			local B = New("TextButton", {
				Text = btn.Text or "Button", FontFace = Tokens.Font.medium, TextSize = Tokens.Text.sm, Size = UDim2.fromOffset(0, 28),
				AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 0, Parent = BtnRow,
				ThemeTag = { BackgroundColor3 = "InputBg", TextColor3 = "Text" },
			}, {
				Corner("sm"), Stroke({ Transparency = 0.5, ThemeTag = { Color = "InputBorder" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
			})
			local _, SetT = Creator.SpringMotor(0, B, "BackgroundTransparency")
			Creator.AddSignal(B.MouseEnter, function() SetT(0.15) end)
			Creator.AddSignal(B.MouseLeave, function() SetT(0) end)
			Creator.AddSignal(B.MouseButton1Down, function() SetT(0.3) end)
			Creator.AddSignal(B.MouseButton1Up, function() SetT(0.15) end)
			Creator.AddSignal(B.MouseButton1Click, function() Library:SafeCallback(btn.Callback) end)
		end
		function BG:Destroy() BGFrame.Frame:Destroy(); if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = BG end
		return BG
	end
	return Element
end)()

ElementsTable.Chip = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Chip"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Chip - Missing Title")
		Config.Items = Config.Items or {}
		Config.Multi = Config.Multi ~= false
		local CH = { Type = "Chip", Value = Config.Default and table.clone(Config.Default) or {}, Callback = Config.Callback or function() end }
		local CHFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		CH.SetTitle, CH.SetDesc, CH.Visible, CH.Elements = CHFrame.SetTitle, CHFrame.SetDesc, CHFrame.Visible, CHFrame
		local ChipRow = New("Frame", {
			Size = UDim2.new(1, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1, Parent = CHFrame.LabelHolder, LayoutOrder = 3,
		}, { New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), Wraps = true }), New("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) }) })
		local ChipBtns = {}
		local function updateChip(item, data)
			local active = table.find(CH.Value, item) ~= nil
			data.SetBg(active and 0.05 or 0)
			data.SetText(active and 0 or 0.4)
			data.SetStroke(active and 0.1 or 0.6)
		end
		for _, item in ipairs(Config.Items) do
			local chip = New("TextButton", {
				Text = tostring(item), FontFace = Tokens.Font.medium, TextSize = Tokens.Text.sm, Size = UDim2.fromOffset(0, 28),
				AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 0, TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center, Parent = ChipRow, ThemeTag = { BackgroundColor3 = "InputBg", TextColor3 = "Text" },
			}, {
				Corner("sm"), Stroke({ Transparency = 0.6, ThemeTag = { Color = "InputBorder" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
			})
			local stroke = chip:FindFirstChildOfClass("UIStroke")
			local SmoothSpring = { frequency = 7, dampingRatio = 1 }
			local _, SetBg = Creator.SpringMotor(0, chip, "BackgroundTransparency", true, false, SmoothSpring)
			local _, SetText = Creator.SpringMotor(0.4, chip, "TextTransparency", true, false, SmoothSpring)
			local _, SetStroke = Creator.SpringMotor(0.6, stroke, "Transparency", true, false, SmoothSpring)
			local data = { Instance = chip, SetBg = SetBg, SetText = SetText, SetStroke = SetStroke }
			ChipBtns[item] = data
			updateChip(item, data)
			Creator.AddSignal(chip.MouseButton1Click, function()
				local idx = table.find(CH.Value, item)
				if idx then table.remove(CH.Value, idx)
				else
					if not Config.Multi then CH.Value = {} end
					table.insert(CH.Value, item)
				end
				for it, d in pairs(ChipBtns) do updateChip(it, d) end
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
		function CH:OnChanged(fn) CH.Changed = fn; fn(CH.Value) end
		function CH:Destroy() CHFrame.Frame:Destroy(); if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = CH end
		return CH
	end
	return Element
end)()

ElementsTable.Stepper = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Stepper"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Stepper - Missing Title")
		Config.Default = Config.Default or 0
		Config.Step = Config.Step or 1
		Config.Min = Config.Min or -math.huge
		Config.Max = Config.Max or math.huge
		Config.Mode = Config.Mode or "Full"
		Config.Suffix = Config.Suffix or ""
		local ST = { Value = Config.Default, Step = Config.Step, Min = Config.Min, Max = Config.Max, Type = "Stepper", Callback = Config.Callback or function() end }
		local STFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		ST.SetTitle, ST.SetDesc, ST.Visible, ST.Elements = STFrame.SetTitle, STFrame.SetDesc, STFrame.Visible, STFrame
		local isFull = Config.Mode == "Full"

		local Row = New("Frame", {
			Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Parent = STFrame.Frame,
		}, { New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 16) }) })

		local ValueDisplay = New(isFull and "TextBox" or "TextLabel", {
			Text = tostring(Config.Default) .. Config.Suffix, FontFace = Tokens.Font.medium, TextSize = Tokens.Text.lg,
			Size = UDim2.fromOffset(isFull and 50 or 42, 34), BackgroundTransparency = 0, TextXAlignment = Enum.TextXAlignment.Right,
			LayoutOrder = 1, Parent = Row, ThemeTag = { TextColor3 = "Text", BackgroundColor3 = "InputBg" },
		}, { Corner("sm"), New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }) })

		local BtnColumn = New("Frame", {
			Size = UDim2.fromOffset(34, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 2, Parent = Row,
		}, { New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 7) }) })

		local function makeArrowBtn(icon, lo)
			local BtnStroke = Stroke({ Transparency = 0.5, ThemeTag = { Color = "InputBorder" } })
			local Btn = New("TextButton", {
				Text = "", Size = UDim2.fromOffset(34, 19), BackgroundTransparency = 1, AutoButtonColor = false,
				LayoutOrder = lo, Parent = BtnColumn, ThemeTag = { BackgroundColor3 = "InputBg" },
			}, {
				Corner("xs"), BtnStroke,
				New("ImageLabel", { Image = icon, Size = UDim2.fromOffset(13, 13), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, ThemeTag = { ImageColor3 = "Text" } }),
			})
			local _, SetT = Creator.SpringMotor(1, Btn, "BackgroundTransparency")
			Creator.AddSignal(Btn.MouseEnter, function() SetT(0.85) end)
			Creator.AddSignal(Btn.MouseLeave, function() SetT(1) end)
			Creator.AddSignal(Btn.MouseButton1Down, function() SetT(0.72) end)
			Creator.AddSignal(Btn.MouseButton1Up, function() SetT(0.85) end)
			return Btn
		end
		local UpBtn = makeArrowBtn(Library:GetIcon("chevron-up"), 1)
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
				for _, amp in ipairs({ 5, -4, 3, -2, 0 }) do
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
			TweenService:Create(UpBtn, TweenInfo.new(0.1), { BackgroundTransparency = v >= ST.Max and 0.95 or 1 }):Play()
			TweenService:Create(DownBtn, TweenInfo.new(0.1), { BackgroundTransparency = v <= ST.Min and 0.95 or 1 }):Play()
			Library:SafeCallback(ST.Callback, v)
			Library:SafeCallback(ST.Changed, v)
		end
		Creator.AddSignal(UpBtn.MouseButton1Click, function() set(ST.Value + ST.Step) end)
		Creator.AddSignal(DownBtn.MouseButton1Click, function() set(ST.Value - ST.Step) end)
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
				if not n then ValueDisplay.Text = tostring(ST.Value) .. Config.Suffix; FlashInvalid()
				elseif n < ST.Min or n > ST.Max then set(n); FlashInvalid()
				else set(n) end
			end)
		end
		function ST:SetValue(v) set(v) end
		function ST:OnChanged(fn) ST.Changed = fn; fn(ST.Value) end
		function ST:Destroy() STFrame.Frame:Destroy(); if Idx then Library.Options[Idx] = nil end end
		set(Config.Default)
		if Idx then Library.Options[Idx] = ST end
		return ST
	end
	return Element
end)()

ElementsTable.LiveLabel = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "LiveLabel"
	local TypeColors = {
		default = Color3.fromRGB(165, 168, 185), info = Color3.fromRGB(96, 200, 255), success = Color3.fromRGB(80, 215, 130),
		warning = Color3.fromRGB(255, 195, 60), error = Color3.fromRGB(255, 80, 80),
	}
	local TypeBg = {
		default = Color3.fromRGB(80, 82, 95), info = Color3.fromRGB(20, 70, 110), success = Color3.fromRGB(15, 75, 45),
		warning = Color3.fromRGB(90, 65, 10), error = Color3.fromRGB(90, 20, 20),
	}
	function Element:New(Idx, Config)
		Config = Config or {}
		Config.Text = Config.Text or ""
		Config.Type = Config.Type or "default"
		local LL = { Value = Config.Text, Type = "LiveLabel", _type = Config.Type }
		local LLFrame = Components.Element(Config.Title or "", Config.Description, self.Container, false, Config)
		LL.SetTitle, LL.SetDesc, LL.Visible, LL.Elements = LLFrame.SetTitle, LLFrame.SetDesc, LLFrame.Visible, LLFrame

		local Pill = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 0.72, BackgroundColor3 = TypeBg[Config.Type] or TypeBg.default, Parent = LLFrame.Frame,
		}, {
			Corner("sm"), Stroke({ Transparency = 0.55, Color = TypeColors[Config.Type] or TypeColors.default }),
			New("UIPadding", { PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4) }),
			New("UISizeConstraint", { MaxSize = Vector2.new(200, math.huge) }),
		})
		local ValueLabel = New("TextLabel", {
			FontFace = Tokens.Font.medium, Text = Config.Text, TextColor3 = TypeColors[Config.Type] or TypeColors.default,
			TextSize = Tokens.Text.sm, TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true, RichText = true, AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0), Parent = Pill,
		})
		-- (No manual height-sync tween here: unlike the old fixed-height row,
		-- this Row's Frame is AutomaticSize.Y already, so it naturally grows
		-- to fit a taller pill without fighting AutomaticSize.)
		Pill.Visible = Config.Text ~= ""

		local PillStroke = Pill:FindFirstChildOfClass("UIStroke")
		function LL:SetText(text)
			self.Value = text or ""
			ValueLabel.Text = self.Value
			Pill.Visible = self.Value ~= ""
			Library:SafeCallback(LL.Changed, self.Value)
		end
		function LL:SetType(t)
			self._type = t or "default"
			local col, bg = TypeColors[self._type] or TypeColors.default, TypeBg[self._type] or TypeBg.default
			local ti = TweenInfo.new(0.15)
			TweenService:Create(ValueLabel, ti, { TextColor3 = col }):Play()
			TweenService:Create(Pill, ti, { BackgroundColor3 = bg }):Play()
			if PillStroke then TweenService:Create(PillStroke, ti, { Color = col }):Play() end
		end
		function LL:SetColor(color)
			ValueLabel.TextColor3 = color
			if PillStroke then PillStroke.Color = color end
		end
		function LL:OnChanged(fn) LL.Changed = fn; fn(LL.Value) end
		function LL:Destroy() LLFrame.Frame:Destroy(); if Idx then Library.Options[Idx] = nil end end
		LL:SetType(Config.Type)
		if Idx then Library.Options[Idx] = LL end
		return LL
	end
	return Element
end)()

-- ============================================================
-- Icon set (lucide-icons re-hosted as Roblox assets). Pure data —
-- unrelated to the redesign. The old file declared this whole table
-- TWICE (an 830-line copy-paste duplicate); kept once here.
-- ============================================================
local Icons = {
	["lucide-accessibility"] = "rbxassetid://10709751939",
	["lucide-activity"] = "rbxassetid://10709752035",
	["lucide-air-vent"] = "rbxassetid://10709752131",
	["lucide-airplay"] = "rbxassetid://10709752254",
	["lucide-alarm-check"] = "rbxassetid://10709752405",
	["lucide-alarm-clock"] = "rbxassetid://10709752630",
	["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
	["lucide-alarm-minus"] = "rbxassetid://10709752732",
	["lucide-alarm-plus"] = "rbxassetid://10709752825",
	["lucide-album"] = "rbxassetid://10709752906",
	["lucide-alert-circle"] = "rbxassetid://10709752996",
	["lucide-alert-octagon"] = "rbxassetid://10709753064",
	["lucide-alert-triangle"] = "rbxassetid://10709753149",
	["lucide-align-center"] = "rbxassetid://10709753570",
	["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
	["lucide-align-center-vertical"] = "rbxassetid://10709753421",
	["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
	["lucide-align-end-vertical"] = "rbxassetid://10709753808",
	["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
	["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
	["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
	["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
	["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
	["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
	["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
	["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
	["lucide-align-justify"] = "rbxassetid://10709759610",
	["lucide-align-left"] = "rbxassetid://10709759764",
	["lucide-align-right"] = "rbxassetid://10709759895",
	["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
	["lucide-align-start-vertical"] = "rbxassetid://10709760244",
	["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
	["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
	["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
	["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
	["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
	["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
	["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
	["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
	["lucide-anchor"] = "rbxassetid://10709761530",
	["lucide-angry"] = "rbxassetid://10709761629",
	["lucide-annoyed"] = "rbxassetid://10709761722",
	["lucide-aperture"] = "rbxassetid://10709761813",
	["lucide-apple"] = "rbxassetid://10709761889",
	["lucide-archive"] = "rbxassetid://10709762233",
	["lucide-archive-restore"] = "rbxassetid://10709762058",
	["lucide-armchair"] = "rbxassetid://10709762327",
	["lucide-anvil"] = "rbxassetid://77943964625400",
	["lucide-arrow-big-down"] = "rbxassetid://10747796644",
	["lucide-arrow-big-left"] = "rbxassetid://10709762574",
	["lucide-arrow-big-right"] = "rbxassetid://10709762727",
	["lucide-arrow-big-up"] = "rbxassetid://10709762879",
	["lucide-arrow-down"] = "rbxassetid://10709767827",
	["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
	["lucide-arrow-down-left"] = "rbxassetid://10709767656",
	["lucide-arrow-down-right"] = "rbxassetid://10709767750",
	["lucide-arrow-left"] = "rbxassetid://10709768114",
	["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
	["lucide-arrow-left-right"] = "rbxassetid://10709768019",
	["lucide-arrow-right"] = "rbxassetid://10709768347",
	["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
	["lucide-arrow-up"] = "rbxassetid://10709768939",
	["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
	["lucide-arrow-up-down"] = "rbxassetid://10709768538",
	["lucide-arrow-up-left"] = "rbxassetid://10709768661",
	["lucide-arrow-up-right"] = "rbxassetid://10709768787",
	["lucide-asterisk"] = "rbxassetid://10709769095",
	["lucide-at-sign"] = "rbxassetid://10709769286",
	["lucide-award"] = "rbxassetid://10709769406",
	["lucide-axe"] = "rbxassetid://10709769508",
	["lucide-axis-3d"] = "rbxassetid://10709769598",
	["lucide-baby"] = "rbxassetid://10709769732",
	["lucide-backpack"] = "rbxassetid://10709769841",
	["lucide-baggage-claim"] = "rbxassetid://10709769935",
	["lucide-banana"] = "rbxassetid://10709770005",
	["lucide-banknote"] = "rbxassetid://10709770178",
	["lucide-bar-chart"] = "rbxassetid://10709773755",
	["lucide-bar-chart-2"] = "rbxassetid://10709770317",
	["lucide-bar-chart-3"] = "rbxassetid://10709770431",
	["lucide-bar-chart-4"] = "rbxassetid://10709770560",
	["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
	["lucide-barcode"] = "rbxassetid://10747360675",
	["lucide-baseline"] = "rbxassetid://10709773863",
	["lucide-bath"] = "rbxassetid://10709773963",
	["lucide-battery"] = "rbxassetid://10709774640",
	["lucide-battery-charging"] = "rbxassetid://10709774068",
	["lucide-battery-full"] = "rbxassetid://10709774206",
	["lucide-battery-low"] = "rbxassetid://10709774370",
	["lucide-battery-medium"] = "rbxassetid://10709774513",
	["lucide-beaker"] = "rbxassetid://10709774756",
	["lucide-bed"] = "rbxassetid://10709775036",
	["lucide-bed-double"] = "rbxassetid://10709774864",
	["lucide-bed-single"] = "rbxassetid://10709774968",
	["lucide-beer"] = "rbxassetid://10709775167",
	["lucide-bell"] = "rbxassetid://10709775704",
	["lucide-bell-minus"] = "rbxassetid://10709775241",
	["lucide-bell-off"] = "rbxassetid://10709775320",
	["lucide-bell-plus"] = "rbxassetid://10709775448",
	["lucide-bell-ring"] = "rbxassetid://10709775560",
	["lucide-bike"] = "rbxassetid://10709775894",
	["lucide-binary"] = "rbxassetid://10709776050",
	["lucide-bitcoin"] = "rbxassetid://10709776126",
	["lucide-bluetooth"] = "rbxassetid://10709776655",
	["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
	["lucide-bluetooth-off"] = "rbxassetid://10709776344",
	["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
	["lucide-bold"] = "rbxassetid://10747813908",
	["lucide-bomb"] = "rbxassetid://10709781460",
	["lucide-bone"] = "rbxassetid://10709781605",
	["lucide-book"] = "rbxassetid://10709781824",
	["lucide-book-open"] = "rbxassetid://10709781717",
	["lucide-bookmark"] = "rbxassetid://10709782154",
	["lucide-bookmark-minus"] = "rbxassetid://10709781919",
	["lucide-bookmark-plus"] = "rbxassetid://10709782044",
	["lucide-bot"] = "rbxassetid://10709782230",
	["lucide-box"] = "rbxassetid://10709782497",
	["lucide-box-select"] = "rbxassetid://10709782342",
	["lucide-boxes"] = "rbxassetid://10709782582",
	["lucide-briefcase"] = "rbxassetid://10709782662",
	["lucide-brush"] = "rbxassetid://10709782758",
	["lucide-bug"] = "rbxassetid://10709782845",
	["lucide-building"] = "rbxassetid://10709783051",
	["lucide-building-2"] = "rbxassetid://10709782939",
	["lucide-bus"] = "rbxassetid://10709783137",
	["lucide-cake"] = "rbxassetid://10709783217",
	["lucide-calculator"] = "rbxassetid://10709783311",
	["lucide-calendar"] = "rbxassetid://10709789505",
	["lucide-calendar-check"] = "rbxassetid://10709783474",
	["lucide-calendar-check-2"] = "rbxassetid://10709783392",
	["lucide-calendar-clock"] = "rbxassetid://10709783577",
	["lucide-calendar-days"] = "rbxassetid://10709783673",
	["lucide-calendar-heart"] = "rbxassetid://10709783835",
	["lucide-calendar-minus"] = "rbxassetid://10709783959",
	["lucide-calendar-off"] = "rbxassetid://10709788784",
	["lucide-calendar-plus"] = "rbxassetid://10709788937",
	["lucide-calendar-range"] = "rbxassetid://10709789053",
	["lucide-calendar-search"] = "rbxassetid://10709789200",
	["lucide-calendar-x"] = "rbxassetid://10709789407",
	["lucide-calendar-x-2"] = "rbxassetid://10709789329",
	["lucide-camera"] = "rbxassetid://10709789686",
	["lucide-camera-off"] = "rbxassetid://10747822677",
	["lucide-car"] = "rbxassetid://10709789810",
	["lucide-carrot"] = "rbxassetid://10709789960",
	["lucide-cast"] = "rbxassetid://10709790097",
	["lucide-charge"] = "rbxassetid://10709790202",
	["lucide-check"] = "rbxassetid://10709790644",
	["lucide-check-circle"] = "rbxassetid://10709790387",
	["lucide-check-circle-2"] = "rbxassetid://10709790298",
	["lucide-check-square"] = "rbxassetid://10709790537",
	["lucide-chef-hat"] = "rbxassetid://10709790757",
	["lucide-cherry"] = "rbxassetid://10709790875",
	["lucide-chevron-down"] = "rbxassetid://10709790948",
	["lucide-chevron-first"] = "rbxassetid://10709791015",
	["lucide-chevron-last"] = "rbxassetid://10709791130",
	["lucide-chevron-left"] = "rbxassetid://10709791281",
	["lucide-chevron-right"] = "rbxassetid://10709791437",
	["lucide-chevron-up"] = "rbxassetid://10709791523",
	["lucide-chevrons-down"] = "rbxassetid://10709796864",
	["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
	["lucide-chevrons-left"] = "rbxassetid://10709797151",
	["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
	["lucide-chevrons-right"] = "rbxassetid://10709797382",
	["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
	["lucide-chevrons-up"] = "rbxassetid://10709797622",
	["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
	["lucide-chrome"] = "rbxassetid://10709797725",
	["lucide-circle"] = "rbxassetid://10709798174",
	["lucide-circle-dot"] = "rbxassetid://10709797837",
	["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
	["lucide-circle-slashed"] = "rbxassetid://10709798100",
	["lucide-citrus"] = "rbxassetid://10709798276",
	["lucide-clapperboard"] = "rbxassetid://10709798350",
	["lucide-clipboard"] = "rbxassetid://10709799288",
	["lucide-clipboard-check"] = "rbxassetid://10709798443",
	["lucide-clipboard-copy"] = "rbxassetid://10709798574",
	["lucide-clipboard-edit"] = "rbxassetid://10709798682",
	["lucide-clipboard-list"] = "rbxassetid://10709798792",
	["lucide-clipboard-signature"] = "rbxassetid://10709798890",
	["lucide-clipboard-type"] = "rbxassetid://10709798999",
	["lucide-clipboard-x"] = "rbxassetid://10709799124",
	["lucide-clock"] = "rbxassetid://10709805144",
	["lucide-clock-1"] = "rbxassetid://10709799535",
	["lucide-clock-10"] = "rbxassetid://10709799718",
	["lucide-clock-11"] = "rbxassetid://10709799818",
	["lucide-clock-12"] = "rbxassetid://10709799962",
	["lucide-clock-2"] = "rbxassetid://10709803876",
	["lucide-clock-3"] = "rbxassetid://10709803989",
	["lucide-clock-4"] = "rbxassetid://10709804164",
	["lucide-clock-5"] = "rbxassetid://10709804291",
	["lucide-clock-6"] = "rbxassetid://10709804435",
	["lucide-clock-7"] = "rbxassetid://10709804599",
	["lucide-clock-8"] = "rbxassetid://10709804784",
	["lucide-clock-9"] = "rbxassetid://10709804996",
	["lucide-cloud"] = "rbxassetid://10709806740",
	["lucide-cloud-cog"] = "rbxassetid://10709805262",
	["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
	["lucide-cloud-fog"] = "rbxassetid://10709805477",
	["lucide-cloud-hail"] = "rbxassetid://10709805596",
	["lucide-cloud-lightning"] = "rbxassetid://10709805727",
	["lucide-cloud-moon"] = "rbxassetid://10709805942",
	["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
	["lucide-cloud-off"] = "rbxassetid://10709806060",
	["lucide-cloud-rain"] = "rbxassetid://10709806277",
	["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
	["lucide-cloud-snow"] = "rbxassetid://10709806374",
	["lucide-cloud-sun"] = "rbxassetid://10709806631",
	["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
	["lucide-cloudy"] = "rbxassetid://10709806859",
	["lucide-clover"] = "rbxassetid://10709806995",
	["lucide-code"] = "rbxassetid://10709810463",
	["lucide-code-2"] = "rbxassetid://10709807111",
	["lucide-codepen"] = "rbxassetid://10709810534",
	["lucide-codesandbox"] = "rbxassetid://10709810676",
	["lucide-coffee"] = "rbxassetid://10709810814",
	["lucide-cog"] = "rbxassetid://10709810948",
	["lucide-coins"] = "rbxassetid://10709811110",
	["lucide-columns"] = "rbxassetid://10709811261",
	["lucide-command"] = "rbxassetid://10709811365",
	["lucide-compass"] = "rbxassetid://10709811445",
	["lucide-component"] = "rbxassetid://10709811595",
	["lucide-concierge-bell"] = "rbxassetid://10709811706",
	["lucide-connection"] = "rbxassetid://10747361219",
	["lucide-contact"] = "rbxassetid://10709811834",
	["lucide-contrast"] = "rbxassetid://10709811939",
	["lucide-cookie"] = "rbxassetid://10709812067",
	["lucide-copy"] = "rbxassetid://10709812159",
	["lucide-copyleft"] = "rbxassetid://10709812251",
	["lucide-copyright"] = "rbxassetid://10709812311",
	["lucide-corner-down-left"] = "rbxassetid://10709812396",
	["lucide-corner-down-right"] = "rbxassetid://10709812485",
	["lucide-corner-left-down"] = "rbxassetid://10709812632",
	["lucide-corner-left-up"] = "rbxassetid://10709812784",
	["lucide-corner-right-down"] = "rbxassetid://10709812939",
	["lucide-corner-right-up"] = "rbxassetid://10709813094",
	["lucide-corner-up-left"] = "rbxassetid://10709813185",
	["lucide-corner-up-right"] = "rbxassetid://10709813281",
	["lucide-cpu"] = "rbxassetid://10709813383",
	["lucide-croissant"] = "rbxassetid://10709818125",
	["lucide-crop"] = "rbxassetid://10709818245",
	["lucide-cross"] = "rbxassetid://10709818399",
	["lucide-crosshair"] = "rbxassetid://10709818534",
	["lucide-crown"] = "rbxassetid://10709818626",
	["lucide-cup-soda"] = "rbxassetid://10709818763",
	["lucide-curly-braces"] = "rbxassetid://10709818847",
	["lucide-currency"] = "rbxassetid://10709818931",
	["lucide-container"] = "rbxassetid://17466205552",
	["lucide-database"] = "rbxassetid://10709818996",
	["lucide-delete"] = "rbxassetid://10709819059",
	["lucide-diamond"] = "rbxassetid://10709819149",
	["lucide-dice-1"] = "rbxassetid://10709819266",
	["lucide-dice-2"] = "rbxassetid://10709819361",
	["lucide-dice-3"] = "rbxassetid://10709819508",
	["lucide-dice-4"] = "rbxassetid://10709819670",
	["lucide-dice-5"] = "rbxassetid://10709819801",
	["lucide-dice-6"] = "rbxassetid://10709819896",
	["lucide-dices"] = "rbxassetid://10723343321",
	["lucide-diff"] = "rbxassetid://10723343416",
	["lucide-disc"] = "rbxassetid://10723343537",
	["lucide-divide"] = "rbxassetid://10723343805",
	["lucide-divide-circle"] = "rbxassetid://10723343636",
	["lucide-divide-square"] = "rbxassetid://10723343737",
	["lucide-dollar-sign"] = "rbxassetid://10723343958",
	["lucide-download"] = "rbxassetid://10723344270",
	["lucide-download-cloud"] = "rbxassetid://10723344088",
	["lucide-door-open"] = "rbxassetid://124179241653522",
	["lucide-droplet"] = "rbxassetid://10723344432",
	["lucide-droplets"] = "rbxassetid://10734883356",
	["lucide-drumstick"] = "rbxassetid://10723344737",
	["lucide-edit"] = "rbxassetid://10734883598",
	["lucide-edit-2"] = "rbxassetid://10723344885",
	["lucide-edit-3"] = "rbxassetid://10723345088",
	["lucide-egg"] = "rbxassetid://10723345518",
	["lucide-egg-fried"] = "rbxassetid://10723345347",
	["lucide-electricity"] = "rbxassetid://10723345749",
	["lucide-electricity-off"] = "rbxassetid://10723345643",
	["lucide-equal"] = "rbxassetid://10723345990",
	["lucide-equal-not"] = "rbxassetid://10723345866",
	["lucide-eraser"] = "rbxassetid://10723346158",
	["lucide-euro"] = "rbxassetid://10723346372",
	["lucide-expand"] = "rbxassetid://10723346553",
	["lucide-external-link"] = "rbxassetid://10723346684",
	["lucide-eye"] = "rbxassetid://10723346959",
	["lucide-eye-off"] = "rbxassetid://10723346871",
	["lucide-factory"] = "rbxassetid://10723347051",
	["lucide-fan"] = "rbxassetid://10723354359",
	["lucide-fast-forward"] = "rbxassetid://10723354521",
	["lucide-feather"] = "rbxassetid://10723354671",
	["lucide-figma"] = "rbxassetid://10723354801",
	["lucide-file"] = "rbxassetid://10723374641",
	["lucide-file-archive"] = "rbxassetid://10723354921",
	["lucide-file-audio"] = "rbxassetid://10723355148",
	["lucide-file-audio-2"] = "rbxassetid://10723355026",
	["lucide-file-axis-3d"] = "rbxassetid://10723355272",
	["lucide-file-badge"] = "rbxassetid://10723355622",
	["lucide-file-badge-2"] = "rbxassetid://10723355451",
	["lucide-file-bar-chart"] = "rbxassetid://10723355887",
	["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
	["lucide-file-box"] = "rbxassetid://10723355989",
	["lucide-file-check"] = "rbxassetid://10723356210",
	["lucide-file-check-2"] = "rbxassetid://10723356100",
	["lucide-file-clock"] = "rbxassetid://10723356329",
	["lucide-file-code"] = "rbxassetid://10723356507",
	["lucide-file-cog"] = "rbxassetid://10723356830",
	["lucide-file-cog-2"] = "rbxassetid://10723356676",
	["lucide-file-diff"] = "rbxassetid://10723357039",
	["lucide-file-digit"] = "rbxassetid://10723357151",
	["lucide-file-down"] = "rbxassetid://10723357322",
	["lucide-file-edit"] = "rbxassetid://10723357495",
	["lucide-file-heart"] = "rbxassetid://10723357637",
	["lucide-file-image"] = "rbxassetid://10723357790",
	["lucide-file-input"] = "rbxassetid://10723357933",
	["lucide-file-json"] = "rbxassetid://10723364435",
	["lucide-file-json-2"] = "rbxassetid://10723364361",
	["lucide-file-key"] = "rbxassetid://10723364605",
	["lucide-file-key-2"] = "rbxassetid://10723364515",
	["lucide-file-line-chart"] = "rbxassetid://10723364725",
	["lucide-file-lock"] = "rbxassetid://10723364957",
	["lucide-file-lock-2"] = "rbxassetid://10723364861",
	["lucide-file-minus"] = "rbxassetid://10723365254",
	["lucide-file-minus-2"] = "rbxassetid://10723365086",
	["lucide-file-output"] = "rbxassetid://10723365457",
	["lucide-file-pie-chart"] = "rbxassetid://10723365598",
	["lucide-file-plus"] = "rbxassetid://10723365877",
	["lucide-file-plus-2"] = "rbxassetid://10723365766",
	["lucide-file-question"] = "rbxassetid://10723365987",
	["lucide-file-scan"] = "rbxassetid://10723366167",
	["lucide-file-search"] = "rbxassetid://10723366550",
	["lucide-file-search-2"] = "rbxassetid://10723366340",
	["lucide-file-signature"] = "rbxassetid://10723366741",
	["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
	["lucide-file-symlink"] = "rbxassetid://10723367098",
	["lucide-file-terminal"] = "rbxassetid://10723367244",
	["lucide-file-text"] = "rbxassetid://10723367380",
	["lucide-file-type"] = "rbxassetid://10723367606",
	["lucide-file-type-2"] = "rbxassetid://10723367509",
	["lucide-file-up"] = "rbxassetid://10723367734",
	["lucide-file-video"] = "rbxassetid://10723373884",
	["lucide-file-video-2"] = "rbxassetid://10723367834",
	["lucide-file-volume"] = "rbxassetid://10723374172",
	["lucide-file-volume-2"] = "rbxassetid://10723374030",
	["lucide-file-warning"] = "rbxassetid://10723374276",
	["lucide-file-x"] = "rbxassetid://10723374544",
	["lucide-file-x-2"] = "rbxassetid://10723374378",
	["lucide-files"] = "rbxassetid://10723374759",
	["lucide-film"] = "rbxassetid://10723374981",
	["lucide-filter"] = "rbxassetid://10723375128",
	["lucide-fingerprint"] = "rbxassetid://10723375250",
	["lucide-flag"] = "rbxassetid://10723375890",
	["lucide-flag-off"] = "rbxassetid://10723375443",
	["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
	["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
	["lucide-flame"] = "rbxassetid://10723376114",
	["lucide-flashlight"] = "rbxassetid://10723376471",
	["lucide-flashlight-off"] = "rbxassetid://10723376365",
	["lucide-flask-conical"] = "rbxassetid://10734883986",
	["lucide-flask-round"] = "rbxassetid://10723376614",
	["lucide-flip-horizontal"] = "rbxassetid://10723376884",
	["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
	["lucide-flip-vertical"] = "rbxassetid://10723377138",
	["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
	["lucide-flower"] = "rbxassetid://10747830374",
	["lucide-flower-2"] = "rbxassetid://10723377305",
	["lucide-focus"] = "rbxassetid://10723377537",
	["lucide-folder"] = "rbxassetid://10723387563",
	["lucide-folder-archive"] = "rbxassetid://10723384478",
	["lucide-folder-check"] = "rbxassetid://10723384605",
	["lucide-folder-clock"] = "rbxassetid://10723384731",
	["lucide-folder-closed"] = "rbxassetid://10723384893",
	["lucide-folder-cog"] = "rbxassetid://10723385213",
	["lucide-folder-cog-2"] = "rbxassetid://10723385036",
	["lucide-folder-down"] = "rbxassetid://10723385338",
	["lucide-folder-edit"] = "rbxassetid://10723385445",
	["lucide-folder-heart"] = "rbxassetid://10723385545",
	["lucide-folder-input"] = "rbxassetid://10723385721",
	["lucide-folder-key"] = "rbxassetid://10723385848",
	["lucide-folder-lock"] = "rbxassetid://10723386005",
	["lucide-folder-minus"] = "rbxassetid://10723386127",
	["lucide-folder-open"] = "rbxassetid://10723386277",
	["lucide-folder-output"] = "rbxassetid://10723386386",
	["lucide-folder-plus"] = "rbxassetid://10723386531",
	["lucide-folder-search"] = "rbxassetid://10723386787",
	["lucide-folder-search-2"] = "rbxassetid://10723386674",
	["lucide-folder-symlink"] = "rbxassetid://10723386930",
	["lucide-folder-tree"] = "rbxassetid://10723387085",
	["lucide-folder-up"] = "rbxassetid://10723387265",
	["lucide-folder-x"] = "rbxassetid://10723387448",
	["lucide-folders"] = "rbxassetid://10723387721",
	["lucide-form-input"] = "rbxassetid://10723387841",
	["lucide-forward"] = "rbxassetid://10723388016",
	["lucide-frame"] = "rbxassetid://10723394389",
	["lucide-framer"] = "rbxassetid://10723394565",
	["lucide-frown"] = "rbxassetid://10723394681",
	["lucide-fuel"] = "rbxassetid://10723394846",
	["lucide-function-square"] = "rbxassetid://10723395041",
	["lucide-gamepad"] = "rbxassetid://10723395457",
	["lucide-gamepad-2"] = "rbxassetid://10723395215",
	["lucide-gauge"] = "rbxassetid://10723395708",
	["lucide-gavel"] = "rbxassetid://10723395896",
	["lucide-gem"] = "rbxassetid://10723396000",
	["lucide-ghost"] = "rbxassetid://10723396107",
	["lucide-gift"] = "rbxassetid://10723396402",
	["lucide-gift-card"] = "rbxassetid://10723396225",
	["lucide-git-branch"] = "rbxassetid://10723396676",
	["lucide-git-branch-plus"] = "rbxassetid://10723396542",
	["lucide-git-commit"] = "rbxassetid://10723396812",
	["lucide-git-compare"] = "rbxassetid://10723396954",
	["lucide-git-fork"] = "rbxassetid://10723397049",
	["lucide-git-merge"] = "rbxassetid://10723397165",
	["lucide-git-pull-request"] = "rbxassetid://10723397431",
	["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
	["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
	["lucide-glass"] = "rbxassetid://10723397788",
	["lucide-glass-2"] = "rbxassetid://10723397529",
	["lucide-glass-water"] = "rbxassetid://10723397678",
	["lucide-glasses"] = "rbxassetid://10723397895",
	["lucide-globe"] = "rbxassetid://10723404337",
	["lucide-globe-2"] = "rbxassetid://10723398002",
	["lucide-grab"] = "rbxassetid://10723404472",
	["lucide-graduation-cap"] = "rbxassetid://10723404691",
	["lucide-grape"] = "rbxassetid://10723404822",
	["lucide-grid"] = "rbxassetid://10723404936",
	["lucide-grip-horizontal"] = "rbxassetid://10723405089",
	["lucide-grip-vertical"] = "rbxassetid://10723405236",
	["lucide-hammer"] = "rbxassetid://10723405360",
	["lucide-hand"] = "rbxassetid://10723405649",
	["lucide-hand-metal"] = "rbxassetid://10723405508",
	["lucide-hard-drive"] = "rbxassetid://10723405749",
	["lucide-hard-hat"] = "rbxassetid://10723405859",
	["lucide-hash"] = "rbxassetid://10723405975",
	["lucide-haze"] = "rbxassetid://10723406078",
	["lucide-headphones"] = "rbxassetid://10723406165",
	["lucide-heart"] = "rbxassetid://10723406885",
	["lucide-heart-crack"] = "rbxassetid://10723406299",
	["lucide-heart-handshake"] = "rbxassetid://10723406480",
	["lucide-heart-off"] = "rbxassetid://10723406662",
	["lucide-heart-pulse"] = "rbxassetid://10723406795",
	["lucide-help-circle"] = "rbxassetid://10723406988",
	["lucide-hexagon"] = "rbxassetid://10723407092",
	["lucide-highlighter"] = "rbxassetid://10723407192",
	["lucide-history"] = "rbxassetid://10723407335",
	["lucide-home"] = "rbxassetid://10723407389",
	["lucide-hourglass"] = "rbxassetid://10723407498",
	["lucide-ice-cream"] = "rbxassetid://10723414308",
	["lucide-image"] = "rbxassetid://10723415040",
	["lucide-image-minus"] = "rbxassetid://10723414487",
	["lucide-image-off"] = "rbxassetid://10723414677",
	["lucide-image-plus"] = "rbxassetid://10723414827",
	["lucide-import"] = "rbxassetid://10723415205",
	["lucide-inbox"] = "rbxassetid://10723415335",
	["lucide-indent"] = "rbxassetid://10723415494",
	["lucide-indian-rupee"] = "rbxassetid://10723415642",
	["lucide-infinity"] = "rbxassetid://10723415766",
	["lucide-info"] = "rbxassetid://10723415903",
	["lucide-inspect"] = "rbxassetid://10723416057",
	["lucide-italic"] = "rbxassetid://10723416195",
	["lucide-japanese-yen"] = "rbxassetid://10723416363",
	["lucide-joystick"] = "rbxassetid://10723416527",
	["lucide-key"] = "rbxassetid://10723416652",
	["lucide-keyboard"] = "rbxassetid://10723416765",
	["lucide-lamp"] = "rbxassetid://10723417513",
	["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
	["lucide-lamp-desk"] = "rbxassetid://10723417016",
	["lucide-lamp-floor"] = "rbxassetid://10723417131",
	["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
	["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
	["lucide-landmark"] = "rbxassetid://10723417608",
	["lucide-languages"] = "rbxassetid://10723417703",
	["lucide-laptop"] = "rbxassetid://10723423881",
	["lucide-laptop-2"] = "rbxassetid://10723417797",
	["lucide-lasso"] = "rbxassetid://10723424235",
	["lucide-lasso-select"] = "rbxassetid://10723424058",
	["lucide-laugh"] = "rbxassetid://10723424372",
	["lucide-layers"] = "rbxassetid://10723424505",
	["lucide-layout"] = "rbxassetid://10723425376",
	["lucide-layout-dashboard"] = "rbxassetid://10723424646",
	["lucide-layout-grid"] = "rbxassetid://10723424838",
	["lucide-layout-list"] = "rbxassetid://10723424963",
	["lucide-layout-template"] = "rbxassetid://10723425187",
	["lucide-leaf"] = "rbxassetid://10723425539",
	["lucide-library"] = "rbxassetid://10723425615",
	["lucide-life-buoy"] = "rbxassetid://10723425685",
	["lucide-lightbulb"] = "rbxassetid://10723425852",
	["lucide-lightbulb-off"] = "rbxassetid://10723425762",
	["lucide-line-chart"] = "rbxassetid://10723426393",
	["lucide-link"] = "rbxassetid://10723426722",
	["lucide-link-2"] = "rbxassetid://10723426595",
	["lucide-link-2-off"] = "rbxassetid://10723426513",
	["lucide-list"] = "rbxassetid://10723433811",
	["lucide-list-checks"] = "rbxassetid://10734884548",
	["lucide-list-end"] = "rbxassetid://10723426886",
	["lucide-list-minus"] = "rbxassetid://10723426986",
	["lucide-list-music"] = "rbxassetid://10723427081",
	["lucide-list-ordered"] = "rbxassetid://10723427199",
	["lucide-list-plus"] = "rbxassetid://10723427334",
	["lucide-list-start"] = "rbxassetid://10723427494",
	["lucide-list-video"] = "rbxassetid://10723427619",
	["lucide-list-todo"] = "rbxassetid://17376008003",
	["lucide-list-x"] = "rbxassetid://10723433655",
	["lucide-loader"] = "rbxassetid://10723434070",
	["lucide-loader-2"] = "rbxassetid://10723433935",
	["lucide-locate"] = "rbxassetid://10723434557",
	["lucide-locate-fixed"] = "rbxassetid://10723434236",
	["lucide-locate-off"] = "rbxassetid://10723434379",
	["lucide-lock"] = "rbxassetid://10723434711",
	["lucide-log-in"] = "rbxassetid://10723434830",
	["lucide-log-out"] = "rbxassetid://10723434906",
	["lucide-luggage"] = "rbxassetid://10723434993",
	["lucide-magnet"] = "rbxassetid://10723435069",
	["lucide-mail"] = "rbxassetid://10734885430",
	["lucide-mail-check"] = "rbxassetid://10723435182",
	["lucide-mail-minus"] = "rbxassetid://10723435261",
	["lucide-mail-open"] = "rbxassetid://10723435342",
	["lucide-mail-plus"] = "rbxassetid://10723435443",
	["lucide-mail-question"] = "rbxassetid://10723435515",
	["lucide-mail-search"] = "rbxassetid://10734884739",
	["lucide-mail-warning"] = "rbxassetid://10734885015",
	["lucide-mail-x"] = "rbxassetid://10734885247",
	["lucide-mails"] = "rbxassetid://10734885614",
	["lucide-map"] = "rbxassetid://10734886202",
	["lucide-map-pin"] = "rbxassetid://10734886004",
	["lucide-map-pin-off"] = "rbxassetid://10734885803",
	["lucide-maximize"] = "rbxassetid://10734886735",
	["lucide-maximize-2"] = "rbxassetid://10734886496",
	["lucide-medal"] = "rbxassetid://10734887072",
	["lucide-megaphone"] = "rbxassetid://10734887454",
	["lucide-megaphone-off"] = "rbxassetid://10734887311",
	["lucide-meh"] = "rbxassetid://10734887603",
	["lucide-menu"] = "rbxassetid://10734887784",
	["lucide-message-circle"] = "rbxassetid://10734888000",
	["lucide-message-square"] = "rbxassetid://10734888228",
	["lucide-mic"] = "rbxassetid://10734888864",
	["lucide-mic-2"] = "rbxassetid://10734888430",
	["lucide-mic-off"] = "rbxassetid://10734888646",
	["lucide-microscope"] = "rbxassetid://10734889106",
	["lucide-microwave"] = "rbxassetid://10734895076",
	["lucide-milestone"] = "rbxassetid://10734895310",
	["lucide-minimize"] = "rbxassetid://10734895698",
	["lucide-minimize-2"] = "rbxassetid://10734895530",
	["lucide-minus"] = "rbxassetid://10734896206",
	["lucide-minus-circle"] = "rbxassetid://10734895856",
	["lucide-minus-square"] = "rbxassetid://10734896029",
	["lucide-monitor"] = "rbxassetid://10734896881",
	["lucide-monitor-off"] = "rbxassetid://10734896360",
	["lucide-monitor-speaker"] = "rbxassetid://10734896512",
	["lucide-moon"] = "rbxassetid://10734897102",
	["lucide-more-horizontal"] = "rbxassetid://10734897250",
	["lucide-more-vertical"] = "rbxassetid://10734897387",
	["lucide-mountain"] = "rbxassetid://10734897956",
	["lucide-mountain-snow"] = "rbxassetid://10734897665",
	["lucide-mouse"] = "rbxassetid://10734898592",
	["lucide-mouse-pointer"] = "rbxassetid://10734898476",
	["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
	["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
	["lucide-move"] = "rbxassetid://10734900011",
	["lucide-move-3d"] = "rbxassetid://10734898756",
	["lucide-move-diagonal"] = "rbxassetid://10734899164",
	["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
	["lucide-move-horizontal"] = "rbxassetid://10734899414",
	["lucide-move-vertical"] = "rbxassetid://10734899821",
	["lucide-music"] = "rbxassetid://10734905958",
	["lucide-music-2"] = "rbxassetid://10734900215",
	["lucide-music-3"] = "rbxassetid://10734905665",
	["lucide-music-4"] = "rbxassetid://10734905823",
	["lucide-navigation"] = "rbxassetid://10734906744",
	["lucide-navigation-2"] = "rbxassetid://10734906332",
	["lucide-navigation-2-off"] = "rbxassetid://10734906144",
	["lucide-navigation-off"] = "rbxassetid://10734906580",
	["lucide-network"] = "rbxassetid://10734906975",
	["lucide-newspaper"] = "rbxassetid://10734907168",
	["lucide-octagon"] = "rbxassetid://10734907361",
	["lucide-option"] = "rbxassetid://10734907649",
	["lucide-outdent"] = "rbxassetid://10734907933",
	["lucide-package"] = "rbxassetid://10734909540",
	["lucide-package-2"] = "rbxassetid://10734908151",
	["lucide-package-check"] = "rbxassetid://10734908384",
	["lucide-package-minus"] = "rbxassetid://10734908626",
	["lucide-package-open"] = "rbxassetid://10734908793",
	["lucide-package-plus"] = "rbxassetid://10734909016",
	["lucide-package-search"] = "rbxassetid://10734909196",
	["lucide-package-x"] = "rbxassetid://10734909375",
	["lucide-paint-bucket"] = "rbxassetid://10734909847",
	["lucide-paintbrush"] = "rbxassetid://10734910187",
	["lucide-paintbrush-2"] = "rbxassetid://10734910030",
	["lucide-palette"] = "rbxassetid://10734910430",
	["lucide-palmtree"] = "rbxassetid://10734910680",
	["lucide-paperclip"] = "rbxassetid://10734910927",
	["lucide-party-popper"] = "rbxassetid://10734918735",
	["lucide-pause"] = "rbxassetid://10734919336",
	["lucide-pause-circle"] = "rbxassetid://10735024209",
	["lucide-pause-octagon"] = "rbxassetid://10734919143",
	["lucide-pen-tool"] = "rbxassetid://10734919503",
	["lucide-pencil"] = "rbxassetid://10734919691",
	["lucide-percent"] = "rbxassetid://10734919919",
	["lucide-person-standing"] = "rbxassetid://10734920149",
	["lucide-phone"] = "rbxassetid://10734921524",
	["lucide-phone-call"] = "rbxassetid://10734920305",
	["lucide-phone-forwarded"] = "rbxassetid://10734920508",
	["lucide-phone-incoming"] = "rbxassetid://10734920694",
	["lucide-phone-missed"] = "rbxassetid://10734920845",
	["lucide-phone-off"] = "rbxassetid://10734921077",
	["lucide-phone-outgoing"] = "rbxassetid://10734921288",
	["lucide-pie-chart"] = "rbxassetid://10734921727",
	["lucide-piggy-bank"] = "rbxassetid://10734921935",
	["lucide-pin"] = "rbxassetid://10734922324",
	["lucide-pin-off"] = "rbxassetid://10734922180",
	["lucide-pipette"] = "rbxassetid://10734922497",
	["lucide-pizza"] = "rbxassetid://10734922774",
	["lucide-plane"] = "rbxassetid://10734922971",
	["lucide-plane-landing"] = "rbxassetid://17376029914",
	["lucide-play"] = "rbxassetid://10734923549",
	["lucide-play-circle"] = "rbxassetid://10734923214",
	["lucide-plus"] = "rbxassetid://10734924532",
	["lucide-plus-circle"] = "rbxassetid://10734923868",
	["lucide-plus-square"] = "rbxassetid://10734924219",
	["lucide-podcast"] = "rbxassetid://10734929553",
	["lucide-pointer"] = "rbxassetid://10734929723",
	["lucide-pound-sterling"] = "rbxassetid://10734929981",
	["lucide-power"] = "rbxassetid://10734930466",
	["lucide-power-off"] = "rbxassetid://10734930257",
	["lucide-printer"] = "rbxassetid://10734930632",
	["lucide-puzzle"] = "rbxassetid://10734930886",
	["lucide-quote"] = "rbxassetid://10734931234",
	["lucide-radio"] = "rbxassetid://10734931596",
	["lucide-radio-receiver"] = "rbxassetid://10734931402",
	["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
	["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
	["lucide-recycle"] = "rbxassetid://10734932295",
	["lucide-redo"] = "rbxassetid://10734932822",
	["lucide-redo-2"] = "rbxassetid://10734932586",
	["lucide-refresh-ccw"] = "rbxassetid://10734933056",
	["lucide-refresh-cw"] = "rbxassetid://10734933222",
	["lucide-refrigerator"] = "rbxassetid://10734933465",
	["lucide-regex"] = "rbxassetid://10734933655",
	["lucide-repeat"] = "rbxassetid://10734933966",
	["lucide-repeat-1"] = "rbxassetid://10734933826",
	["lucide-reply"] = "rbxassetid://10734934252",
	["lucide-reply-all"] = "rbxassetid://10734934132",
	["lucide-rewind"] = "rbxassetid://10734934347",
	["lucide-rocket"] = "rbxassetid://10734934585",
	["lucide-rocking-chair"] = "rbxassetid://10734939942",
	["lucide-rotate-3d"] = "rbxassetid://10734940107",
	["lucide-rotate-ccw"] = "rbxassetid://10734940376",
	["lucide-rotate-cw"] = "rbxassetid://10734940654",
	["lucide-rss"] = "rbxassetid://10734940825",
	["lucide-ruler"] = "rbxassetid://10734941018",
	["lucide-russian-ruble"] = "rbxassetid://10734941199",
	["lucide-sailboat"] = "rbxassetid://10734941354",
	["lucide-save"] = "rbxassetid://10734941499",
	["lucide-scale"] = "rbxassetid://10734941912",
	["lucide-scale-3d"] = "rbxassetid://10734941739",
	["lucide-scaling"] = "rbxassetid://10734942072",
	["lucide-scan"] = "rbxassetid://10734942565",
	["lucide-scan-face"] = "rbxassetid://10734942198",
	["lucide-scan-line"] = "rbxassetid://10734942351",
	["lucide-scissors"] = "rbxassetid://10734942778",
	["lucide-screen-share"] = "rbxassetid://10734943193",
	["lucide-screen-share-off"] = "rbxassetid://10734942967",
	["lucide-scroll"] = "rbxassetid://10734943448",
	["lucide-search"] = "rbxassetid://10734943674",
	["lucide-send"] = "rbxassetid://10734943902",
	["lucide-separator-horizontal"] = "rbxassetid://10734944115",
	["lucide-separator-vertical"] = "rbxassetid://10734944326",
	["lucide-server"] = "rbxassetid://10734949856",
	["lucide-server-cog"] = "rbxassetid://10734944444",
	["lucide-server-crash"] = "rbxassetid://10734944554",
	["lucide-server-off"] = "rbxassetid://10734944668",
	["lucide-settings"] = "rbxassetid://10734950309",
	["lucide-settings-2"] = "rbxassetid://10734950020",
	["lucide-share"] = "rbxassetid://10734950813",
	["lucide-share-2"] = "rbxassetid://10734950553",
	["lucide-sheet"] = "rbxassetid://10734951038",
	["lucide-shield"] = "rbxassetid://10734951847",
	["lucide-shield-alert"] = "rbxassetid://10734951173",
	["lucide-shield-check"] = "rbxassetid://10734951367",
	["lucide-shield-close"] = "rbxassetid://10734951535",
	["lucide-shield-off"] = "rbxassetid://10734951684",
	["lucide-shirt"] = "rbxassetid://10734952036",
	["lucide-shopping-bag"] = "rbxassetid://10734952273",
	["lucide-shopping-cart"] = "rbxassetid://10734952479",
	["lucide-shovel"] = "rbxassetid://10734952773",
	["lucide-shower-head"] = "rbxassetid://10734952942",
	["lucide-shrink"] = "rbxassetid://10734953073",
	["lucide-shrub"] = "rbxassetid://10734953241",
	["lucide-shuffle"] = "rbxassetid://10734953451",
	["lucide-sidebar"] = "rbxassetid://10734954301",
	["lucide-sidebar-close"] = "rbxassetid://10734953715",
	["lucide-sidebar-open"] = "rbxassetid://10734954000",
	["lucide-sigma"] = "rbxassetid://10734954538",
	["lucide-signal"] = "rbxassetid://10734961133",
	["lucide-signal-high"] = "rbxassetid://10734954807",
	["lucide-signal-low"] = "rbxassetid://10734955080",
	["lucide-signal-medium"] = "rbxassetid://10734955336",
	["lucide-signal-zero"] = "rbxassetid://10734960878",
	["lucide-siren"] = "rbxassetid://10734961284",
	["lucide-skip-back"] = "rbxassetid://10734961526",
	["lucide-skip-forward"] = "rbxassetid://10734961809",
	["lucide-skull"] = "rbxassetid://10734962068",
	["lucide-slack"] = "rbxassetid://10734962339",
	["lucide-slash"] = "rbxassetid://10734962600",
	["lucide-slice"] = "rbxassetid://10734963024",
	["lucide-sliders"] = "rbxassetid://10734963400",
	["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
	["lucide-smartphone"] = "rbxassetid://10734963940",
	["lucide-smartphone-charging"] = "rbxassetid://10734963671",
	["lucide-smile"] = "rbxassetid://10734964441",
	["lucide-smile-plus"] = "rbxassetid://10734964188",
	["lucide-snowflake"] = "rbxassetid://10734964600",
	["lucide-sofa"] = "rbxassetid://10734964852",
	["lucide-sort-asc"] = "rbxassetid://10734965115",
	["lucide-sort-desc"] = "rbxassetid://10734965287",
	["lucide-speaker"] = "rbxassetid://10734965419",
	["lucide-sprout"] = "rbxassetid://10734965572",
	["lucide-square"] = "rbxassetid://10734965702",
	["lucide-star"] = "rbxassetid://10734966248",
	["lucide-star-half"] = "rbxassetid://10734965897",
	["lucide-star-off"] = "rbxassetid://10734966097",
	["lucide-stethoscope"] = "rbxassetid://10734966384",
	["lucide-sticker"] = "rbxassetid://10734972234",
	["lucide-sticky-note"] = "rbxassetid://10734972463",
	["lucide-stop-circle"] = "rbxassetid://10734972621",
	["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
	["lucide-stretch-vertical"] = "rbxassetid://10734973130",
	["lucide-strikethrough"] = "rbxassetid://10734973290",
	["lucide-subscript"] = "rbxassetid://10734973457",
	["lucide-sun"] = "rbxassetid://10734974297",
	["lucide-sun-dim"] = "rbxassetid://10734973645",
	["lucide-sun-medium"] = "rbxassetid://10734973778",
	["lucide-sun-moon"] = "rbxassetid://10734973999",
	["lucide-sun-snow"] = "rbxassetid://10734974130",
	["lucide-sunrise"] = "rbxassetid://10734974522",
	["lucide-sunset"] = "rbxassetid://10734974689",
	["lucide-superscript"] = "rbxassetid://10734974850",
	["lucide-swiss-franc"] = "rbxassetid://10734975024",
	["lucide-switch-camera"] = "rbxassetid://10734975214",
	["lucide-sword"] = "rbxassetid://10734975486",
	["lucide-swords"] = "rbxassetid://10734975692",
	["lucide-syringe"] = "rbxassetid://10734975932",
	["lucide-table"] = "rbxassetid://10734976230",
	["lucide-table-2"] = "rbxassetid://10734976097",
	["lucide-tablet"] = "rbxassetid://10734976394",
	["lucide-tag"] = "rbxassetid://10734976528",
	["lucide-tags"] = "rbxassetid://10734976739",
	["lucide-target"] = "rbxassetid://10734977012",
	["lucide-tent"] = "rbxassetid://10734981750",
	["lucide-terminal"] = "rbxassetid://10734982144",
	["lucide-terminal-square"] = "rbxassetid://10734981995",
	["lucide-text-cursor"] = "rbxassetid://10734982395",
	["lucide-text-cursor-input"] = "rbxassetid://10734982297",
	["lucide-thermometer"] = "rbxassetid://10734983134",
	["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
	["lucide-thermometer-sun"] = "rbxassetid://10734982771",
	["lucide-thumbs-down"] = "rbxassetid://10734983359",
	["lucide-thumbs-up"] = "rbxassetid://10734983629",
	["lucide-ticket"] = "rbxassetid://10734983868",
	["lucide-timer"] = "rbxassetid://10734984606",
	["lucide-timer-off"] = "rbxassetid://10734984138",
	["lucide-timer-reset"] = "rbxassetid://10734984355",
	["lucide-toggle-left"] = "rbxassetid://10734984834",
	["lucide-toggle-right"] = "rbxassetid://10734985040",
	["lucide-tornado"] = "rbxassetid://10734985247",
	["lucide-toy-brick"] = "rbxassetid://10747361919",
	["lucide-train"] = "rbxassetid://10747362105",
	["lucide-trash"] = "rbxassetid://10747362393",
	["lucide-trash-2"] = "rbxassetid://10747362241",
	["lucide-tree-deciduous"] = "rbxassetid://10747362534",
	["lucide-tree-pine"] = "rbxassetid://10747362748",
	["lucide-trees"] = "rbxassetid://10747363016",
	["lucide-trending-down"] = "rbxassetid://10747363205",
	["lucide-trending-up"] = "rbxassetid://10747363465",
	["lucide-triangle"] = "rbxassetid://10747363621",
	["lucide-trophy"] = "rbxassetid://10747363809",
	["lucide-truck"] = "rbxassetid://10747364031",
	["lucide-tv"] = "rbxassetid://10747364593",
	["lucide-tv-2"] = "rbxassetid://10747364302",
	["lucide-type"] = "rbxassetid://10747364761",
	["lucide-umbrella"] = "rbxassetid://10747364971",
	["lucide-underline"] = "rbxassetid://10747365191",
	["lucide-undo"] = "rbxassetid://10747365484",
	["lucide-undo-2"] = "rbxassetid://10747365359",
	["lucide-unlink"] = "rbxassetid://10747365771",
	["lucide-unlink-2"] = "rbxassetid://10747397871",
	["lucide-unlock"] = "rbxassetid://10747366027",
	["lucide-upload"] = "rbxassetid://10747366434",
	["lucide-upload-cloud"] = "rbxassetid://10747366266",
	["lucide-usb"] = "rbxassetid://10747366606",
	["lucide-user"] = "rbxassetid://10747373176",
	["lucide-user-check"] = "rbxassetid://10747371901",
	["lucide-user-cog"] = "rbxassetid://10747372167",
	["lucide-user-minus"] = "rbxassetid://10747372346",
	["lucide-user-plus"] = "rbxassetid://10747372702",
	["lucide-user-x"] = "rbxassetid://10747372992",
	["lucide-users"] = "rbxassetid://10747373426",
	["lucide-utensils"] = "rbxassetid://10747373821",
	["lucide-utensils-crossed"] = "rbxassetid://10747373629",
	["lucide-venetian-mask"] = "rbxassetid://10747374003",
	["lucide-verified"] = "rbxassetid://10747374131",
	["lucide-vibrate"] = "rbxassetid://10747374489",
	["lucide-vibrate-off"] = "rbxassetid://10747374269",
	["lucide-video"] = "rbxassetid://10747374938",
	["lucide-video-off"] = "rbxassetid://10747374721",
	["lucide-view"] = "rbxassetid://10747375132",
	["lucide-voicemail"] = "rbxassetid://10747375281",
	["lucide-volume"] = "rbxassetid://10747376008",
	["lucide-volume-1"] = "rbxassetid://10747375450",
	["lucide-volume-2"] = "rbxassetid://10747375679",
	["lucide-volume-x"] = "rbxassetid://10747375880",
	["lucide-wheat"] = "rbxassetid://80877624162595",
	["lucide-wallet"] = "rbxassetid://10747376205",
	["lucide-wand"] = "rbxassetid://10747376565",
	["lucide-wand-2"] = "rbxassetid://10747376349",
	["lucide-watch"] = "rbxassetid://10747376722",
	["lucide-waves"] = "rbxassetid://10747376931",
	["lucide-webcam"] = "rbxassetid://10747381992",
	["lucide-wifi"] = "rbxassetid://10747382504",
	["lucide-wifi-off"] = "rbxassetid://10747382268",
	["lucide-wind"] = "rbxassetid://10747382750",
	["lucide-wrap-text"] = "rbxassetid://10747383065",
	["lucide-wrench"] = "rbxassetid://10747383470",
	["lucide-x"] = "rbxassetid://10747384394",
	["lucide-x-circle"] = "rbxassetid://10747383819",
	["lucide-x-octagon"] = "rbxassetid://10747384037",
	["lucide-x-square"] = "rbxassetid://10747384217",
	["lucide-zoom-in"] = "rbxassetid://10747384552",
	["lucide-zoom-out"] = "rbxassetid://10747384679",
	["lucide-cat"] = "rbxassetid://16935650691",
	["lucide-message-circle-question"] = "rbxassetid://16970049192",
	["lucide-webhook"] = "rbxassetid://17320556264",
	["lucide-dumbbell"] = "rbxassetid://18273453053"
}

function Library:GetIcon(Name)
	if Name == true then return Library.BrandLogo end
	if type(Name) == "string" and Icons["lucide-" .. Name] then return Icons["lucide-" .. Name] end
	return nil
end

-- ============================================================
-- Elements dispatch metatable — every container (Section/Tab/SubTab/
-- SectionTab) gets :AddToggle/:AddSlider/etc. auto-registered from
-- ElementsTable, plus a section-local sub-tab strip (:AddTab) for
-- grouping elements even further within one section.
-- ============================================================
local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...) return Elements[Key](...) end

for _, ElementComponent in pairs(ElementsTable) do
	Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.ScrollFrame = self.ScrollFrame
		ElementComponent.Library = Library
		if ElementComponent.NoIdx then return ElementComponent:New(Idx) end
		return ElementComponent:New(Idx, Config)
	end
end

Elements.AddTab = function(self, TabTitle, TabIcon)
	self.SectionTabs = self.SectionTabs or {}
	self.SharedGroups = self.SharedGroups or {}
	self.SelectedSectionTab = self.SelectedSectionTab or 0
	self.SectionTabCount = (self.SectionTabCount or 0) + 1
	local Index = self.SectionTabCount

	if not self.SectionTabStrip then
		self.SectionTabStrip = Creator.New("Frame", {
			Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = 1, Parent = self.Container,
		}, { Creator.New("UIListLayout", { Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center }) })
		self.SectionTabDivider = Creator.New("Frame", {
			Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 0.75, BorderSizePixel = 0, LayoutOrder = 2,
			Parent = self.Container, ThemeTag = { BackgroundColor3 = "InputBorder" },
		})
		self.SectionTabContentHolder = Creator.New("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, LayoutOrder = 3, Parent = self.Container })
	end

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
					if y > 0 then y = y + 4 end
					g.Container.Position = UDim2.new(0, 0, 0, y)
					g.Container.Visible = true
					y = y + g.Layout.AbsoluteContentSize.Y
				else
					g.Container.Visible = false
				end
			end
			if y > 0 then y = y + 6 end
			self.SectionTabContentHolder.Size = UDim2.new(1, 0, 0, y)
		end
	end

	local resolvedIcon = Library:GetIcon(TabIcon) or TabIcon
	if resolvedIcon == "" then resolvedIcon = nil end

	local TabLabel = Creator.New("TextLabel", {
		Text = TabTitle, FontFace = Tokens.Font.medium, TextSize = Tokens.Text.xs, AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 14), BackgroundTransparency = 1, ThemeTag = { TextColor3 = "SubText" },
	})
	local TabIconImg = resolvedIcon and Creator.New("ImageLabel", {
		Image = resolvedIcon, Size = UDim2.fromOffset(13, 13), BackgroundTransparency = 1, ThemeTag = { ImageColor3 = "SubText" },
	}) or nil
	local TabRow = Creator.New("Frame", {
		Size = UDim2.new(0, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.XY, Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1,
	}, { Creator.New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5), VerticalAlignment = Enum.VerticalAlignment.Center }), TabIconImg, TabLabel })
	local TabButton = Creator.New("TextButton", {
		Text = "", AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 30), BackgroundTransparency = 0.78,
		Parent = self.SectionTabStrip, ThemeTag = { BackgroundColor3 = "InputBg" },
	}, {
		Corner("md"), Stroke({ Transparency = 0.55, ThemeTag = { Color = "InputBorder" } }),
		Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }), TabRow,
	})
	local _, SetTabBg = Creator.SpringMotor(0.78, TabButton, "BackgroundTransparency", true, false, { frequency = 8 })

	local TabContentLayout = Creator.New("UIListLayout", { Padding = UDim.new(0, 4) })
	local TabContainer = Creator.New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
		Visible = (Index == 1), Parent = self.SectionTabContentHolder,
	}, { TabContentLayout })

	Creator.AddSignal(TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if self.SelectedSectionTab == Index then self._RecalcSectionTabLayout() end
	end)

	self.SectionTabs[Index] = { Button = TabButton, Container = TabContainer, SetBg = SetTabBg, Layout = TabContentLayout, Label = TabLabel, Icon = TabIconImg }

	local function UpdateSectionTabAppearance()
		for i, t in ipairs(self.SectionTabs) do
			local active = (i == self.SelectedSectionTab)
			t.Container.Visible = active
			t.SetBg(active and 0.45 or 0.78)
			Creator.OverrideTag(t.Label, { TextColor3 = active and "Accent" or "SubText" })
			if t.Icon then Creator.OverrideTag(t.Icon, { ImageColor3 = active and "Accent" or "SubText" }) end
		end
		self._RecalcSectionTabLayout()
	end
	Creator.AddSignal(TabButton.MouseEnter, function() if Index ~= self.SelectedSectionTab then SetTabBg(0.62) end end)
	Creator.AddSignal(TabButton.MouseLeave, function() if Index ~= self.SelectedSectionTab then SetTabBg(0.78) end end)
	Creator.AddSignal(TabButton.MouseButton1Click, function()
		if self.SelectedSectionTab == Index then return end
		self.SelectedSectionTab = Index
		UpdateSectionTabAppearance()
	end)
	if self.SelectedSectionTab == 0 then self.SelectedSectionTab = Index end
	UpdateSectionTabAppearance()

	local SectionTab = { Type = "SectionTab", Container = TabContainer, _Index = Index }
	setmetatable(SectionTab, Elements)
	return SectionTab
end

Elements.AddSharedTab = function(self, Tabs)
	assert(type(Tabs) == "table" and #Tabs >= 2, "AddSharedTab - needs at least 2 handles returned by :AddTab")
	self.SharedGroups = self.SharedGroups or {}
	self.SectionTabs = self.SectionTabs or {}
	assert(self._RecalcSectionTabLayout, "AddSharedTab - call :AddTab at least once first")
	local TabIndices = {}
	for _, t in ipairs(Tabs) do
		assert(type(t) == "table" and t._Index, "AddSharedTab - each item must be a handle returned by :AddTab")
		table.insert(TabIndices, t._Index)
	end
	local GroupLayout = Creator.New("UIListLayout", { Padding = UDim.new(0, 4) })
	local GroupContainer = Creator.New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
		Visible = false, Parent = self.SectionTabContentHolder,
	}, { GroupLayout })
	local Group = { Container = GroupContainer, Layout = GroupLayout, Tabs = TabIndices }
	table.insert(self.SharedGroups, Group)
	Creator.AddSignal(GroupLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if table.find(TabIndices, self.SelectedSectionTab) then self._RecalcSectionTabLayout() end
	end)
	self._RecalcSectionTabLayout()
	local SharedTab = { Type = "SectionSharedTab", Container = GroupContainer }
	setmetatable(SharedTab, Elements)
	return SharedTab
end

Library.Elements = Elements
if RunService:IsStudio() then
	makefolder = function(...) return ... end
	makefile = function(...) return ... end
	isfile = function(...) return ... end
	isfolder = function(...) return ... end
	readfile = function(...) return ... end
	writefile = function(...) return ... end
	listfiles = function(...) return { ... } end
end

-- ============================================================
-- SaveManager — config save/load to json files. Pure logic, no
-- visual dependency (built entirely on the Elements API above), so
-- ported essentially unchanged.
-- ============================================================
local SaveManager = {}
do
	SaveManager.Folder = "GzSettings"
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) return { type = "Toggle", idx = idx, value = object.Value } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		Slider = {
			Save = function(idx, object) return { type = "Slider", idx = idx, value = tostring(object.Value) } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		Dropdown = {
			Save = function(idx, object) return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		Colorpicker = {
			Save = function(idx, object) return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency) end end,
		},
		Keybind = {
			Save = function(idx, object) return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.key, data.mode) end end,
		},
		LiveLabel = {
			Save = function(idx, object) return { type = "LiveLabel", idx = idx, value = object.Value, ltype = object._type } end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetText(data.value or "")
					SaveManager.Options[idx]:SetType(data.ltype or "default")
				end
			end,
		},
		Input = {
			Save = function(idx, object) return { type = "Input", idx = idx, text = object.Value } end,
			Load = function(idx, data) if SaveManager.Options[idx] and type(data.text) == "string" then SaveManager.Options[idx]:SetValue(data.text) end end,
		},
		Checkbox = {
			Save = function(idx, object) return { type = "Checkbox", idx = idx, value = object.Value } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		RadioGroup = {
			Save = function(idx, object)
				local value = object.Value
				if object.IsMulti then
					local list = {}
					for _, opt in ipairs(object.Options or {}) do if object.Value[opt] then table.insert(list, opt) end end
					value = list
				end
				return { type = "RadioGroup", idx = idx, value = value }
			end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		Stepper = {
			Save = function(idx, object) return { type = "Stepper", idx = idx, value = object.Value } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		Chip = {
			Save = function(idx, object) return { type = "Chip", idx = idx, value = table.concat(object.Value, ",") } end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					local vals = {}
					for v in (data.value or ""):gmatch("[^,]+") do table.insert(vals, v) end
					SaveManager.Options[idx]:SetValue(vals)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list) for _, key in next, list do self.Ignore[key] = true end end
	function SaveManager:SetFolder(folder) self.Folder = folder; self:BuildFolderTree() end
	function SaveManager:Save(name)
		if not name then return false, "no config file is selected" end
		local fullPath = self.Folder .. "/" .. name .. ".json"
		local data = { objects = {} }
		for idx, option in next, SaveManager.Options do
			if self.Parser[option.Type] and not self.Ignore[idx] then table.insert(data.objects, self.Parser[option.Type].Save(idx, option)) end
		end
		local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
		if not success then return false, "failed to encode data" end
		writefile(fullPath, encoded)
		return true
	end
	if not RunService:IsStudio() then
		function SaveManager:Load(name)
			if not name then return false, "no config file is selected" end
			local file = self.Folder .. "/" .. name .. ".json"
			if not isfile(file) then return false, "Create Config Save File" end
			local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
			if not success then return false, "decode error" end
			for _, option in next, decoded.objects do
				if self.Parser[option.type] and not self.Ignore[option.idx] then
					task.spawn(function() self.Parser[option.type].Load(option.idx, option) end)
				end
			end
			return true, decoded
		end
	end
	function SaveManager:IgnoreThemeSettings() self:SetIgnoreIndexes({ "InterfaceTheme", "MenuKeybind" }) end
	function SaveManager:BuildFolderTree()
		local paths = { self.Folder, self.Folder .. "/" }
		for i = 1, #paths do if not isfolder(paths[i]) then makefolder(paths[i]) end end
	end
	function SaveManager:RefreshConfigList()
		local list = listfiles(self.Folder .. "/")
		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == ".json" then
				local pos = file:find(".json", 1, true)
				local start = pos
				local char = file:sub(pos, pos)
				while char ~= "/" and char ~= "\\" and char ~= "" do pos = pos - 1; char = file:sub(pos, pos) end
				if char == "/" or char == "\\" then
					local name = file:sub(pos + 1, start - 1)
					if name ~= "options" then table.insert(out, name) end
				end
			end
		end
		return out
	end
	function SaveManager:SetLibrary(library) self.Library = library; self.Options = library.Options end
	if not RunService:IsStudio() then
		function SaveManager:LoadAutoloadConfig()
			if isfile(self.Folder .. "/autoload.txt") then
				local name = readfile(self.Folder .. "/autoload.txt")
				name = name:match("^%s*(.-)%s*$")
				if not name or name == "" then return end
				local success, err = self:Load(name)
				if not success then
					return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Failed to load autoload config: " .. err, Duration = 7 })
				end
				self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("Auto loaded config %q", name), Duration = 7 })
			end
		end
	end
	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "Must set SaveManager.Library")
		local section = tab
		section:AddInput("SaveManager_ConfigName", { Title = "Config name" })
		section:AddDropdown("SaveManager_ConfigList", { Title = "Config list", Values = self:RefreshConfigList(), AllowNull = true })
		section:AddButtonGroup("SaveManager_NewConfig", {
			Title = "New config", Description = "Type a name above then create",
			Buttons = { { Text = "Create", Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigName.Value
				if name:gsub(" ", "") == "" then
					return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Invalid config name (empty)", Duration = 5 })
				end
				local success, err = self:Save(name)
				if not success then
					return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Failed to save config: " .. err, Duration = 7 })
				end
				self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("Created %q", name), Duration = 5 })
				SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
			end } },
		})
		section:AddButtonGroup("SaveManager_ConfigActions", {
			Title = "Actions", Description = "Select a config from the list first",
			Buttons = {
				{ Text = "Load", Callback = function()
					local name = SaveManager.Options.SaveManager_ConfigList.Value
					local success, err = self:Load(name)
					if not success then
						return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Failed to load: " .. err, Duration = 7 })
					end
					self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("Loaded %q", name), Duration = 5 })
				end },
				{ Text = "Save", Callback = function()
					local name = SaveManager.Options.SaveManager_ConfigList.Value
					local success, err = self:Save(name)
					if not success then
						return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Failed to save: " .. err, Duration = 7 })
					end
					self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("Saved %q", name), Duration = 5 })
				end },
				{ Text = "Delete", Callback = function()
					local name = SaveManager.Options.SaveManager_ConfigList.Value
					if not name or name == "" then
						return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Select a config first", Duration = 5 })
					end
					local path = self.Folder .. "/" .. name .. ".json"
					if not isfile(path) then
						return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("%q not found", name), Duration = 5 })
					end
					local ok = pcall(delfile, path)
					if not ok then
						return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Failed to delete", Duration = 5 })
					end
					if isfile(self.Folder .. "/autoload.txt") then
						local autoName = (readfile(self.Folder .. "/autoload.txt") or ""):match("^%s*(.-)%s*$") or ""
						if autoName == name then pcall(writefile, self.Folder .. "/autoload.txt", "") end
					end
					SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
					SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
					self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("Deleted %q", name), Duration = 5 })
				end },
			},
		})
		local AutoloadButton
		AutoloadButton = section:AddActionButton("SaveManager_AutoloadCopy", {
			Title = "Set as autoload", Description = "Current autoload: none", CopyText = "",
			ButtonText = "Set ★", CopiedText = "✓ Set!", ResetDelay = 1.2, ButtonWidth = 60,
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value
				if not name or name == "" then
					return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Select a config first", Duration = 5 })
				end
				writefile(self.Folder .. "/autoload.txt", name)
				AutoloadButton:SetCopyText(name)
				AutoloadButton:SetDesc("Current autoload: " .. name)
				self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("Set %q as autoload", name), Duration = 5 })
			end,
		})
		section:AddButtonGroup("SaveManager_AutoloadActions", {
			Title = "List & autoload",
			Buttons = {
				{ Text = "Refresh list", Callback = function()
					SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
					SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
				end },
				{ Text = "Clear autoload", Callback = function()
					writefile(self.Folder .. "/autoload.txt", "")
					AutoloadButton:SetDesc("Current autoload: none")
					self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Autoload cleared", Duration = 5 })
				end },
			},
		})
		if isfile(self.Folder .. "/autoload.txt") then
			local name = (readfile(self.Folder .. "/autoload.txt") or ""):match("^%s*(.-)%s*$") or ""
			if name ~= "" then AutoloadButton:SetDesc("Current autoload: " .. name); AutoloadButton:SetCopyText(name) end
		end
		SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
		if not RunService:IsStudio() then
			task.delay(0.5, function()
				if isfile(self.Folder .. "/autoload.txt") then
					local name = (readfile(self.Folder .. "/autoload.txt") or ""):match("^%s*(.-)%s*$") or ""
					if name ~= "" then
						local success, err = self:Load(name)
						if success then
							self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format('Auto loaded config "%s"', name), Duration = 7 })
						else
							self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Failed to auto load: " .. tostring(err), Duration = 7 })
						end
					end
				end
			end)
		end
	end
	if not RunService:IsStudio() then SaveManager:BuildFolderTree() end
end

-- ============================================================
-- InterfaceManager — the built-in Interface/Config settings subtabs.
-- ============================================================
local InterfaceManager = {}
do
	InterfaceManager.Folder = "GzSettings"
	InterfaceManager.Settings = { Transparency = true, MenuKeybind = "M", WindowTransparency = 1.5 }

	function InterfaceManager:SetTheme(name) InterfaceManager.Settings.Theme = name end
	function InterfaceManager:SetFolder(folder) self.Folder = folder; self:BuildFolderTree() end
	function InterfaceManager:SetLibrary(library) self.Library = library end
	function InterfaceManager:BuildFolderTree()
		local paths = {}
		local parts = self.Folder:split("/")
		for idx = 1, #parts do paths[#paths + 1] = table.concat(parts, "/", 1, idx) end
		table.insert(paths, self.Folder)
		table.insert(paths, self.Folder .. "/")
		for i = 1, #paths do if not isfolder(paths[i]) then makefolder(paths[i]) end end
	end
	function InterfaceManager:SaveSettings() writefile(self.Folder .. "/options.json", HttpService:JSONEncode(InterfaceManager.Settings)) end
	function InterfaceManager:LoadSettings()
		local path = self.Folder .. "/options.json"
		if isfile(path) then
			local data = readfile(path)
			local success, decoded
			if not RunService:IsStudio() then success, decoded = pcall(HttpService.JSONDecode, HttpService, data) end
			if success then for i, v in next, decoded do InterfaceManager.Settings[i] = v end end
		end
	end
	function InterfaceManager:BuildInterfaceSection(tab)
		if not self.Library then self:SetLibrary(Library) end
		assert(self.Library, "Must set InterfaceManager.Library")
		local Library = self.Library
		local Settings = InterfaceManager.Settings
		InterfaceManager:LoadSettings()

		local InterfaceSubTab = tab:AddSubTab("Interface", "monitor")
		local ConfigSubTab = tab:AddSubTab("Config", "settings")
		InterfaceManager.InterfaceSubTab, InterfaceManager.ConfigSubTab = InterfaceSubTab, ConfigSubTab
		local section = InterfaceSubTab:AddSection("Interface", "monitor")
		local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
			Title = "Theme", Description = "Changes the interface theme.", Values = Library.Themes, Default = self.Library.Theme,
			Callback = function(Value) Library:SetTheme(Value); Settings.Theme = Value; InterfaceManager:SaveSettings() end,
		})
		InterfaceTheme:SetValue(Settings.Theme)
		local WindowTransparencySlider = section:AddSlider("WindowTransparency", {
			Title = "Window Transparency", Description = "Adjusts the window transparency.",
			Default = Settings.WindowTransparency or 1.5, Min = 0, Max = 3, Rounding = 1,
			Callback = function(Value) Library:SetWindowTransparency(Value); Settings.WindowTransparency = Value; InterfaceManager:SaveSettings() end,
		})
		InterfaceManager.WindowTransparencySlider = WindowTransparencySlider
		task.defer(function() Library:SetWindowTransparency(Settings.WindowTransparency or 1.5) end)

		local customThemeSection = InterfaceSubTab:AddSection("Custom Theme", "palette")
		local defaultAccentColor = Color3.fromRGB(200, 200, 200)
		if Settings.AccentColor and typeof(Settings.AccentColor) == "table" then
			defaultAccentColor = Color3.fromRGB(Settings.AccentColor.r or 200, Settings.AccentColor.g or 200, Settings.AccentColor.b or 200)
		end
		local AccentColorPicker = customThemeSection:AddColorpicker("CustomAccentColor", {
			Title = "Accent Color", Description = "Set a custom accent color without changing the whole theme.", Default = defaultAccentColor,
			Callback = function(Color)
				Library:SetAccentColor(Color)
				Settings.AccentColor = { r = math.floor(Color.R * 255), g = math.floor(Color.G * 255), b = math.floor(Color.B * 255) }
				InterfaceManager:SaveSettings()
			end,
		})
		if Settings.AccentColor and typeof(Settings.AccentColor) == "table" then
			task.defer(function() Library:SetAccentColor(defaultAccentColor, true) end)
		end
		customThemeSection:AddActionButton("ResetAccentColor", {
			Title = "Reset Accent Color", ButtonText = "Reset", CopiedText = "✓ Reset", CopyText = "",
			Callback = function()
				Library:ResetAccentColor()
				Settings.AccentColor = nil
				InterfaceManager:SaveSettings()
				local themeAccent = (Themes[Library.Theme] and Themes[Library.Theme].Accent) or Color3.fromRGB(200, 200, 200)
				AccentColorPicker:SetValueRGB(themeAccent)
			end,
		})
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Library.MinimizeKey.Name or Settings.MenuKeybind })
		MenuKeybind:OnChanged(function() Settings.MenuKeybind = MenuKeybind.Value; InterfaceManager:SaveSettings() end)
		Library.MinimizeKeybind = MenuKeybind

		if SaveManager then
			if not SaveManager.Library then SaveManager:SetLibrary(Library) end
			if not InterfaceManager.ConfigSectionBuilt then
				SaveManager:BuildConfigSection(ConfigSubTab)
				InterfaceManager.ConfigSectionBuilt = true
			end
		end
		return InterfaceSubTab, ConfigSubTab
	end
end

-- ============================================================
-- Library:CreateWindow / CreateMinimizer / theme & accent controls /
-- presets / destroy / notify
-- ============================================================
Library.CreateWindow = function(self, Config)
	assert(Config.Title, "Window - Missing Title")
	if Library.Window then
		print("You cannot create more than one window.")
		return
	end
	Library.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.RightControl
	Library.Theme = Config.Theme or "Dark"
	if Config.BackgroundTransparency == nil then Config.BackgroundTransparency = 0.5 end
	local Icon = Library:GetIcon(Config.Icon) or Config.Icon
	if Icon == "" then Icon = nil end

	local Window = Components.Window({
		Parent = GUI, Size = Config.Size, Title = Config.Title, Icon = Icon,
		BackgroundImage = Config.BackgroundImage, BackgroundTransparency = Config.BackgroundTransparency,
		BackgroundImageTransparency = Config.BackgroundImageTransparency, SubTitle = Config.SubTitle, Discord = Config.Discord,
		DropdownsOutsideWindow = Config.DropdownsOutsideWindow, Search = Config.Search,
		UserInfoTitle = Config.UserInfoTitle, UserInfo = Config.UserInfo, UserInfoSubtitle = Config.UserInfoSubtitle,
	})
	Library.Window = Window
	table.insert(Library.Windows, Window)
	InterfaceManager:SetTheme(Config.Theme)
	Library:SetTheme(Config.Theme, true)
	return Window
end

function Library:CreateMinimizer(Config)
	Config = Config or {}
	if self.Minimizer and self.Minimizer.Parent then return self.Minimizer end
	local parentGui = Library.GUI or GUI
	if parentGui then parentGui.DisplayOrder = 1000 end
	local isMobile = Mobile and true or false
	local iconAsset = "rbxassetid://10734897102"
	if Config.Icon == true then
		iconAsset = Library.BrandLogo
	elseif type(Config.Icon) == "string" and Config.Icon ~= "" then
		pcall(function()
			local resolved = Library:GetIcon(Config.Icon)
			if resolved then iconAsset = resolved
			elseif string.match(Config.Icon, "^rbxassetid://%d+$") then iconAsset = Config.Icon end
		end)
	end
	local draggableWhole = (Config.Draggable == true)
	local function createButton()
		return New("TextButton", { Name = "MinimizeButton", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false }, {
			New("ImageLabel", {
				Name = "Icon", Image = iconAsset, Size = UDim2.fromScale(0.85, 0.85), Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ClipsDescendants = true, ThemeTag = { ImageColor3 = "Text" },
			}, { New("UIAspectRatioConstraint", { AspectRatio = 1, AspectType = Enum.AspectType.FitWithinMaxSize }), Corner("md") }),
		})
	end
	Library.MinimizerAutoShow = (Config.Visible ~= false)
	local holder = New("Frame", {
		Name = "GzMinimizer", Parent = parentGui, Size = Config.Size or UDim2.fromOffset(40, 40),
		Position = Config.Position or (isMobile and UDim2.new(0.45, 0, 0.025, 0) or UDim2.new(0, 300, 0, 20)),
		BackgroundTransparency = 1, ZIndex = 999999999, Visible = false,
	}, {
		New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.05, ThemeTag = { BackgroundColor3 = "Surface" } }, {
			Corner("md"), Stroke({ Transparency = 0.5, ThemeTag = { Color = "SurfaceBorder" } }),
		}),
	})
	local MinimizerScale = New("UIScale", { Scale = 0, Parent = holder })
	local _, SetMinimizerScale = Creator.SpringMotor(0, MinimizerScale, "Scale")
	local minimizerHideToken = 0
	function Library.SetMinimizerVisible(Visible, Animate)
		if not Library.MinimizerAutoShow then return end
		if not holder or not holder.Parent then return end
		minimizerHideToken = minimizerHideToken + 1
		local myToken = minimizerHideToken
		if Visible then
			holder.Visible = true
			if Animate == false then MinimizerScale.Scale = 1 else SetMinimizerScale(1) end
		else
			if Animate == false then
				holder.Visible = false
				MinimizerScale.Scale = 0
			else
				SetMinimizerScale(0)
				task.delay(0.22, function() if myToken == minimizerHideToken then holder.Visible = false end end)
			end
		end
	end
	local btnInstance = createButton()
	btnInstance.Parent = holder
	btnInstance.ZIndex = (holder.ZIndex or 0) + 1
	local button = holder:FindFirstChildOfClass("TextButton")
	if button then
		local isDragging = false
		local dragStart, dragOffset
		if draggableWhole then
			Creator.AddSignal(button.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					isDragging = true
					dragStart = Vector2.new(Input.Position.X, Input.Position.Y)
					dragOffset = holder.Position
					local conn
					conn = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then isDragging = false; dragStart = nil; dragOffset = nil; conn:Disconnect() end
					end)
				end
			end)
			Creator.AddSignal(RunService.Heartbeat, function()
				if isDragging and dragStart and dragOffset and holder and holder.Parent then
					local mouse = LocalPlayer:GetMouse()
					local current = Vector2.new(mouse.X, mouse.Y)
					local delta = current - dragStart
					local newX, newY = dragOffset.X.Offset + delta.X, dragOffset.Y.Offset + delta.Y
					local viewport, size = Camera.ViewportSize, holder.AbsoluteSize
					newX = math.clamp(newX, 0, viewport.X - size.X)
					newY = math.clamp(newY, 0, viewport.Y - size.Y)
					holder.Position = UDim2.fromOffset(newX, newY)
				end
			end)
		end
		Creator.AddSignal(button.MouseButton1Click, function()
			task.wait(0.1)
			if not isDragging and Library.Window then Library.Window:Minimize() end
		end)
	end
	self.Minimizer = holder
	return holder
end

function Library:SetTheme(Value, Instant)
	if Library.Window and (table.find(Library.Themes, Value) or Themes[Value]) then
		Library.Theme = Value
		Library:SetWindowTransparency(Library.WindowTransparencyValue or (InterfaceManager and InterfaceManager.Settings and InterfaceManager.Settings.WindowTransparency) or 1.5)
		if Instant then Creator.UpdateTheme() else Creator.UpdateThemeAnimated(0.45) end
	end
end

-- SetStyle is kept as a harmless no-op for backward compatibility: the
-- old pixel-style variant it used to switch to has been removed as part
-- of the redesign, so there is only one style now.
function Library:SetStyle() end

function Library:SetAccentColor(Color, Instant)
	Library.CustomAccentColor = Color
	if Instant then Creator.UpdateTheme() else Creator.UpdateThemeAnimated(0.3) end
end
function Library:ResetAccentColor(Instant)
	Library.CustomAccentColor = nil
	if Instant then Creator.UpdateTheme() else Creator.UpdateThemeAnimated(0.3) end
end

Library.Presets = Library.Presets or {}
function Library:SavePreset(Name)
	local snapshot = {}
	for idx, obj in pairs(Library.Options) do
		if obj and obj.Value ~= nil then
			local v = obj.Value
			if typeof(v) == "Color3" then snapshot[idx] = { __color3 = true, r = v.R, g = v.G, b = v.B }
			elseif typeof(v) == "EnumItem" then snapshot[idx] = { __enumName = v.Name }
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
			if type(v) == "table" and v.__color3 then restored = Color3.new(v.r, v.g, v.b)
			elseif type(v) == "table" and v.__enumName then restored = v.__enumName end
			pcall(function() obj:SetValue(restored) end)
		end
	end
	return true
end
function Library:DeletePreset(Name) Library.Presets[Name] = nil end
function Library:GetPresetNames()
	local names = {}
	for name in pairs(Library.Presets) do table.insert(names, name) end
	table.sort(names)
	return names
end

function Library:Destroy()
	if Library.Window then
		Library.Unloaded = true
		Creator.Disconnect()
		Library.GUI:Destroy()
	end
end

-- Kept as a no-op for API compatibility: the 3D acrylic blur path this
-- used to drive was already permanently disabled (Library.UseAcrylic was
-- hardcoded to false), so this never did anything either.
function Library:ToggleAcrylic() end

function Library:ToggleTransparency(Value)
	if Library.Window and Library.Window.SurfaceMat then
		Library.Window.SurfaceMat.Fill.BackgroundTransparency = Value and 0.35 or 0.12
	end
end

function Library:SetWindowTransparency(Value)
	if not Library.Window then return end
	Value = math.clamp(Value or 1, 0, 3)
	local bgTransparency = math.clamp(1 - (Value / 3.2), 0, 0.98)
	if Library.Window.SurfaceMat and Library.Window.SurfaceMat.Fill then
		Library.Window.SurfaceMat.Fill.BackgroundTransparency = bgTransparency
	end
	Library.WindowTransparencyValue = Value
end

function Library:Notify(Config) return Components.Notification:New(Config) end

if getgenv then
	getgenv().Gz = Library
	getgenv().Fluent = Library -- kept for scripts written against the old global name
else
	Gz = Library
	Fluent = Library
end

if RunService:IsStudio() then task.wait(0.01) end
return Library, SaveManager, InterfaceManager, Mobile
