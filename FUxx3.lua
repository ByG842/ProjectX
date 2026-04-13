local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local httpService = game:GetService("HttpService")

local Mobile = not RunService:IsStudio() and table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform()) ~= nil

local fischbypass

if game.GameId == 5750914919 then
	fischbypass = true
end

local RenderStepped = RunService.RenderStepped

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local Themes = {
	Names = {
		"Dark",
		"Darker", 
		"AMOLED",
		"Light",
		"Balloon",
		"SoftCream",
		"Aqua", 
		"Amethyst",
		"Rose",
		"Midnight",
		"Forest",
		"Sunset", 
		"Ocean",
		"Emerald",
		"Sapphire",
		"Cloud",
		"Grape",
		"Bloody",
		"Arctic",
		-- ✨ NEW THEMES
		"Neon",
		"Lavender",
		"Cyberpunk",
		"Sakura",
		"Toxic",
		"Gold",
		"Mint",
		"Volcanic",
		"Galaxy",
		"Coral",
	},
	Dark = {
		Name = "Dark",
		Accent = Color3.fromRGB(105, 215, 255),
		AcrylicMain = Color3.fromRGB(28, 29, 36),
		AcrylicBorder = Color3.fromRGB(55, 57, 68),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(22, 23, 30), Color3.fromRGB(25, 26, 34)),
		AcrylicNoise = 0.93,
		TitleBarLine = Color3.fromRGB(48, 50, 62),
		Tab = Color3.fromRGB(118, 122, 140),
		Element = Color3.fromRGB(95, 98, 115),
		ElementBorder = Color3.fromRGB(22, 23, 30),
		InElementBorder = Color3.fromRGB(58, 61, 74),
		ElementTransparency = 0.88,
		ToggleSlider = Color3.fromRGB(100, 104, 122),
		ToggleToggled = Color3.fromRGB(15, 16, 22),
		SliderRail = Color3.fromRGB(88, 92, 108),
		DropdownFrame = Color3.fromRGB(138, 142, 160),
		DropdownHolder = Color3.fromRGB(32, 33, 42),
		DropdownBorder = Color3.fromRGB(22, 23, 30),
		DropdownOption = Color3.fromRGB(95, 99, 116),
		Keybind = Color3.fromRGB(100, 104, 122),
		Input = Color3.fromRGB(138, 142, 160),
		InputFocused = Color3.fromRGB(12, 13, 18),
		InputIndicator = Color3.fromRGB(125, 130, 150),
		InputIndicatorFocus = Color3.fromRGB(105, 215, 255),
		Dialog = Color3.fromRGB(34, 35, 44),
		DialogHolder = Color3.fromRGB(26, 27, 35),
		DialogHolderLine = Color3.fromRGB(20, 21, 28),
		DialogButton = Color3.fromRGB(36, 37, 46),
		DialogButtonBorder = Color3.fromRGB(60, 63, 76),
		DialogBorder = Color3.fromRGB(52, 55, 68),
		DialogInput = Color3.fromRGB(42, 44, 54),
		DialogInputLine = Color3.fromRGB(138, 142, 160),
		Text = Color3.fromRGB(235, 237, 248),
		SubText = Color3.fromRGB(148, 152, 175),
		Hover = Color3.fromRGB(95, 98, 115),
		HoverChange = 0.08,
	},
	Darker = {
		Name = "Darker",
		Accent = Color3.fromRGB(88, 148, 255),
		AcrylicMain = Color3.fromRGB(14, 15, 20),
		AcrylicBorder = Color3.fromRGB(34, 36, 48),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(10, 11, 16), Color3.fromRGB(13, 14, 19)),
		AcrylicNoise = 0.96,
		TitleBarLine = Color3.fromRGB(36, 38, 52),
		Tab = Color3.fromRGB(72, 76, 98),
		Element = Color3.fromRGB(52, 55, 72),
		ElementBorder = Color3.fromRGB(12, 13, 18),
		InElementBorder = Color3.fromRGB(36, 38, 52),
		ElementTransparency = 0.84,
		ToggleSlider = Color3.fromRGB(60, 64, 84),
		ToggleToggled = Color3.fromRGB(8, 9, 14),
		SliderRail = Color3.fromRGB(52, 56, 74),
		DropdownFrame = Color3.fromRGB(90, 95, 120),
		DropdownHolder = Color3.fromRGB(18, 19, 26),
		DropdownBorder = Color3.fromRGB(12, 13, 18),
		DropdownOption = Color3.fromRGB(58, 62, 80),
		Keybind = Color3.fromRGB(60, 64, 84),
		Input = Color3.fromRGB(90, 95, 120),
		InputFocused = Color3.fromRGB(6, 7, 10),
		InputIndicator = Color3.fromRGB(100, 105, 135),
		InputIndicatorFocus = Color3.fromRGB(88, 148, 255),
		Dialog = Color3.fromRGB(18, 19, 26),
		DialogHolder = Color3.fromRGB(12, 13, 18),
		DialogHolderLine = Color3.fromRGB(10, 10, 14),
		DialogButton = Color3.fromRGB(20, 21, 29),
		DialogButtonBorder = Color3.fromRGB(38, 40, 55),
		DialogBorder = Color3.fromRGB(32, 34, 46),
		DialogInput = Color3.fromRGB(24, 26, 35),
		DialogInputLine = Color3.fromRGB(90, 95, 120),
		Text = Color3.fromRGB(228, 232, 248),
		SubText = Color3.fromRGB(138, 144, 175),
		Hover = Color3.fromRGB(52, 55, 72),
		HoverChange = 0.06,
	},
	AMOLED = {
		Name = "AMOLED",
		Accent = Color3.fromRGB(210, 215, 255),
		AcrylicMain = Color3.fromRGB(0, 0, 0),
		AcrylicBorder = Color3.fromRGB(24, 24, 28),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(2, 2, 5)),
		AcrylicNoise = 1,
		TitleBarLine = Color3.fromRGB(26, 26, 32),
		Tab = Color3.fromRGB(48, 48, 60),
		Element = Color3.fromRGB(16, 16, 20),
		ElementBorder = Color3.fromRGB(0, 0, 0),
		InElementBorder = Color3.fromRGB(38, 38, 48),
		ElementTransparency = 0.95,
		ToggleSlider = Color3.fromRGB(45, 45, 58),
		ToggleToggled = Color3.fromRGB(6, 6, 8),
		SliderRail = Color3.fromRGB(38, 38, 50),
		DropdownFrame = Color3.fromRGB(24, 24, 30),
		DropdownHolder = Color3.fromRGB(0, 0, 0),
		DropdownBorder = Color3.fromRGB(4, 4, 6),
		DropdownOption = Color3.fromRGB(38, 38, 50),
		Keybind = Color3.fromRGB(45, 45, 58),
		Input = Color3.fromRGB(38, 38, 50),
		InputFocused = Color3.fromRGB(0, 0, 0),
		InputIndicator = Color3.fromRGB(65, 65, 82),
		InputIndicatorFocus = Color3.fromRGB(210, 215, 255),
		Dialog = Color3.fromRGB(2, 2, 4),
		DialogHolder = Color3.fromRGB(0, 0, 0),
		DialogHolderLine = Color3.fromRGB(20, 20, 26),
		DialogButton = Color3.fromRGB(12, 12, 16),
		DialogButtonBorder = Color3.fromRGB(34, 34, 44),
		DialogBorder = Color3.fromRGB(28, 28, 36),
		DialogInput = Color3.fromRGB(16, 16, 20),
		DialogInputLine = Color3.fromRGB(64, 64, 82),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(158, 162, 188),
		Hover = Color3.fromRGB(38, 38, 50),
		HoverChange = 0.04
	},
	Light = {
		Name = "Light",
		Accent = Color3.fromRGB(28, 118, 228),
		AcrylicMain = Color3.fromRGB(205, 208, 218),
		AcrylicBorder = Color3.fromRGB(168, 172, 185),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(248, 249, 252), Color3.fromRGB(240, 243, 250)),
		AcrylicNoise = 0.97,
		TitleBarLine = Color3.fromRGB(188, 192, 205),
		Tab = Color3.fromRGB(72, 80, 105),
		Element = Color3.fromRGB(255, 255, 255),
		ElementBorder = Color3.fromRGB(192, 196, 210),
		InElementBorder = Color3.fromRGB(168, 172, 188),
		ElementTransparency = 0.55,
		ToggleSlider = Color3.fromRGB(135, 142, 165),
		ToggleToggled = Color3.fromRGB(255, 255, 255),
		SliderRail = Color3.fromRGB(135, 142, 165),
		DropdownFrame = Color3.fromRGB(202, 206, 218),
		DropdownHolder = Color3.fromRGB(238, 241, 250),
		DropdownBorder = Color3.fromRGB(192, 196, 210),
		DropdownOption = Color3.fromRGB(145, 150, 168),
		Keybind = Color3.fromRGB(128, 134, 158),
		Input = Color3.fromRGB(202, 206, 218),
		InputFocused = Color3.fromRGB(88, 95, 120),
		InputIndicator = Color3.fromRGB(108, 115, 142),
		InputIndicatorFocus = Color3.fromRGB(28, 118, 228),
		Dialog = Color3.fromRGB(255, 255, 255),
		DialogHolder = Color3.fromRGB(240, 243, 250),
		DialogHolderLine = Color3.fromRGB(226, 229, 240),
		DialogButton = Color3.fromRGB(255, 255, 255),
		DialogButtonBorder = Color3.fromRGB(190, 195, 210),
		DialogBorder = Color3.fromRGB(152, 158, 178),
		DialogInput = Color3.fromRGB(248, 250, 255),
		DialogInputLine = Color3.fromRGB(165, 170, 188),
		Text = Color3.fromRGB(14, 18, 38),
		SubText = Color3.fromRGB(68, 75, 105),
		Hover = Color3.fromRGB(115, 122, 150),
		HoverChange = 0.15,
	},
	Balloon = {
		Name = "Balloon",
		Accent = Color3.fromRGB(100, 170, 255),
		AcrylicMain = Color3.fromRGB(189, 224, 255),
		AcrylicBorder = Color3.fromRGB(160, 227, 255),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(240, 250, 255), Color3.fromRGB(210, 235, 250)),
		AcrylicNoise = 1,
		TitleBarLine = Color3.fromRGB(150, 200, 255),
		Tab = Color3.fromRGB(153, 185, 255),
		Element = Color3.fromRGB(160, 200, 255),
		ElementBorder = Color3.fromRGB(130, 170, 230),
		InElementBorder = Color3.fromRGB(120, 174, 240),
		ElementTransparency = 0.80,
		ToggleSlider = Color3.fromRGB(93, 163, 255),
		ToggleToggled = Color3.fromRGB(60, 112, 180),
		SliderRail = Color3.fromRGB(170, 220, 255),
		DropdownFrame = Color3.fromRGB(175, 235, 255),
		DropdownHolder = Color3.fromRGB(200, 220, 240),
		DropdownBorder = Color3.fromRGB(130, 170, 230),
		DropdownOption = Color3.fromRGB(146, 202, 255),
		Keybind = Color3.fromRGB(170, 220, 255),
		Input = Color3.fromRGB(170, 220, 255),
		InputFocused = Color3.fromRGB(75, 95, 140),
		InputIndicator = Color3.fromRGB(190, 250, 255),
		InputIndicatorFocus = Color3.fromRGB(100, 170, 255),
		Dialog = Color3.fromRGB(189, 230, 255),
		DialogHolder = Color3.fromRGB(201, 239, 255),
		DialogHolderLine = Color3.fromRGB(197, 236, 250),
		DialogButton = Color3.fromRGB(219, 252, 255),
		DialogButtonBorder = Color3.fromRGB(160, 200, 255),
		DialogBorder = Color3.fromRGB(175, 220, 255),
		DialogInput = Color3.fromRGB(160, 200, 255),
		DialogInputLine = Color3.fromRGB(185, 230, 255),
		Text = Color3.fromRGB(30, 30, 30),
		SubText = Color3.fromRGB(90, 90, 90),
		Hover = Color3.fromRGB(170, 220, 255),
		HoverChange = 0.03
	},
	SoftCream = {
		Name = "SoftCream",
		Accent = Color3.fromRGB(206, 163, 90),
		AcrylicMain = Color3.fromRGB(255, 245, 220),
		AcrylicBorder = Color3.fromRGB(255, 230, 200),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(255, 245, 220), Color3.fromRGB(255, 235, 210)),
		AcrylicNoise = 0.93,
		TitleBarLine = Color3.fromRGB(255, 220, 190),
		Tab = Color3.fromRGB(199, 165, 112),
		Element = Color3.fromRGB(255, 216, 161),
		ElementBorder = Color3.fromRGB(234, 193, 111),
		InElementBorder = Color3.fromRGB(255, 212, 143),
		ElementTransparency = 0.80,
		ToggleSlider = Color3.fromRGB(214, 175, 97),
		ToggleToggled = Color3.fromRGB(200, 160, 100),
		SliderRail = Color3.fromRGB(255, 220, 190),
		DropdownFrame = Color3.fromRGB(255, 228, 164),
		DropdownHolder = Color3.fromRGB(250, 240, 225),
		DropdownBorder = Color3.fromRGB(255, 210, 180),
		DropdownOption = Color3.fromRGB(255, 190, 115),
		Keybind = Color3.fromRGB(255, 220, 190),
		Input = Color3.fromRGB(255, 220, 190),
		InputFocused = Color3.fromRGB(180, 140, 80),
		InputIndicator = Color3.fromRGB(255, 250, 205),
		InputIndicatorFocus = Color3.fromRGB(255, 236, 158),
		Dialog = Color3.fromRGB(255, 255, 240),
		DialogHolder = Color3.fromRGB(255, 245, 220),
		DialogHolderLine = Color3.fromRGB(255, 240, 210),
		DialogButton = Color3.fromRGB(255, 255, 240),
		DialogButtonBorder = Color3.fromRGB(255, 210, 180),
		DialogBorder = Color3.fromRGB(255, 220, 190),
		DialogInput = Color3.fromRGB(255, 210, 180),
		DialogInputLine = Color3.fromRGB(255, 225, 205),
		Text = Color3.fromRGB(30, 30, 30),
		SubText = Color3.fromRGB(90, 90, 90),
		Hover = Color3.fromRGB(255, 220, 190),
		HoverChange = 0.03
	},
	Aqua = {
		Name = "Aqua",
		Accent = Color3.fromRGB(38, 166, 178),
		AcrylicMain = Color3.fromRGB(18, 54, 61),
		AcrylicBorder = Color3.fromRGB(80, 118, 130),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(41, 101, 139), Color3.fromRGB(11, 132, 128)),
		AcrylicNoise = 0.92,
		TitleBarLine = Color3.fromRGB(68, 135, 136),
		Tab = Color3.fromRGB(126, 175, 180),
		Element = Color3.fromRGB(66, 130, 160),
		ElementBorder = Color3.fromRGB(40, 100, 122),
		InElementBorder = Color3.fromRGB(75, 109, 110),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(100, 152, 160),
		ToggleToggled = Color3.fromRGB(25, 70, 95),
		SliderRail = Color3.fromRGB(115, 150, 160),
		DropdownFrame = Color3.fromRGB(158, 194, 200),
		DropdownHolder = Color3.fromRGB(39, 99, 116),
		DropdownBorder = Color3.fromRGB(33, 119, 120),
		DropdownOption = Color3.fromRGB(121, 152, 160),
		Keybind = Color3.fromRGB(108, 153, 160),
		Input = Color3.fromRGB(112, 156, 160),
		InputFocused = Color3.fromRGB(14, 35, 40),
		InputIndicator = Color3.fromRGB(137, 181, 190),
		Dialog = Color3.fromRGB(27, 113, 130),
		DialogHolder = Color3.fromRGB(33, 99, 109),
		DialogHolderLine = Color3.fromRGB(34, 81, 86),
		DialogButton = Color3.fromRGB(27, 128, 130),
		DialogButtonBorder = Color3.fromRGB(62, 100, 110),
		DialogBorder = Color3.fromRGB(26, 86, 100),
		DialogInput = Color3.fromRGB(36, 107, 105),
		DialogInputLine = Color3.fromRGB(70, 120, 130),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(112, 155, 160),
		HoverChange = 0.04,
	},
	Amethyst = {
		Name = "Amethyst",
		Accent = Color3.fromRGB(126, 44, 182),
		AcrylicMain = Color3.fromRGB(40, 12, 71),
		AcrylicBorder = Color3.fromRGB(85, 45, 120),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(34, 19, 49), Color3.fromRGB(41, 24, 57)),
		AcrylicNoise = 0.92,
		TitleBarLine = Color3.fromRGB(95, 55, 130),
		Tab = Color3.fromRGB(135, 75, 170),
		Element = Color3.fromRGB(115, 55, 150),
		ElementBorder = Color3.fromRGB(60, 35, 85),
		InElementBorder = Color3.fromRGB(85, 45, 110),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(135, 65, 160),
		ToggleToggled = Color3.fromRGB(59, 30, 79),
		SliderRail = Color3.fromRGB(135, 65, 160),
		DropdownFrame = Color3.fromRGB(145, 85, 170),
		DropdownHolder = Color3.fromRGB(50, 30, 70),
		DropdownBorder = Color3.fromRGB(60, 35, 85),
		DropdownOption = Color3.fromRGB(135, 65, 160),
		Keybind = Color3.fromRGB(135, 65, 160),
		Input = Color3.fromRGB(135, 65, 160),
		InputFocused = Color3.fromRGB(25, 15, 35),
		InputIndicator = Color3.fromRGB(155, 85, 180),
		InputIndicatorFocus = Color3.fromRGB(126, 44, 182),
		Dialog = Color3.fromRGB(50, 30, 70),
		DialogHolder = Color3.fromRGB(40, 25, 60),
		DialogHolderLine = Color3.fromRGB(35, 20, 55),
		DialogButton = Color3.fromRGB(50, 30, 70),
		DialogButtonBorder = Color3.fromRGB(90, 50, 120),
		DialogBorder = Color3.fromRGB(80, 45, 110),
		DialogInput = Color3.fromRGB(60, 35, 80),
		DialogInputLine = Color3.fromRGB(145, 75, 170),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(135, 65, 160),
		HoverChange = 0.04
	},
	Rose = {
		Name = "Rose",
		Accent = Color3.fromRGB(219, 48, 123),
		AcrylicMain = Color3.fromRGB(35, 25, 30),
		AcrylicBorder = Color3.fromRGB(145, 35, 75),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(65, 25, 45), Color3.fromRGB(75, 30, 50)),
		AcrylicNoise = 0.92,
		TitleBarLine = Color3.fromRGB(150, 65, 95),
		Tab = Color3.fromRGB(190, 85, 115),
		Element = Color3.fromRGB(170, 60, 90),
		ElementBorder = Color3.fromRGB(95, 35, 55),
		InElementBorder = Color3.fromRGB(120, 50, 70),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(190, 75, 105),
		ToggleToggled = Color3.fromRGB(45, 15, 25),
		SliderRail = Color3.fromRGB(190, 75, 105),
		DropdownFrame = Color3.fromRGB(200, 95, 125),
		DropdownHolder = Color3.fromRGB(75, 30, 45),
		DropdownBorder = Color3.fromRGB(95, 35, 55),
		DropdownOption = Color3.fromRGB(190, 75, 105),
		Keybind = Color3.fromRGB(190, 75, 105),
		Input = Color3.fromRGB(190, 75, 105),
		InputFocused = Color3.fromRGB(35, 15, 20),
		InputIndicator = Color3.fromRGB(210, 95, 125),
		InputIndicatorFocus = Color3.fromRGB(219, 48, 123),
		Dialog = Color3.fromRGB(75, 30, 45),
		DialogHolder = Color3.fromRGB(65, 25, 40),
		DialogHolderLine = Color3.fromRGB(60, 20, 35),
		DialogButton = Color3.fromRGB(75, 30, 45),
		DialogButtonBorder = Color3.fromRGB(115, 45, 65),
		DialogBorder = Color3.fromRGB(105, 40, 60),
		DialogInput = Color3.fromRGB(85, 35, 50),
		DialogInputLine = Color3.fromRGB(200, 85, 115),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(190, 75, 105),
		HoverChange = 0.04
	},
	Midnight = {
		Name = "Midnight",
		Accent = Color3.fromRGB(52, 50, 178),
		AcrylicMain = Color3.fromRGB(20, 20, 20),
		AcrylicBorder = Color3.fromRGB(83, 83, 130),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(1, 1, 39), Color3.fromRGB(6, 6, 54)),
		AcrylicNoise = 0.96,
		TitleBarLine = Color3.fromRGB(77, 75, 126),
		Tab = Color3.fromRGB(126, 127, 180),
		Element = Color3.fromRGB(111, 108, 160),
		ElementBorder = Color3.fromRGB(32, 32, 59),
		InElementBorder = Color3.fromRGB(85, 83, 110),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(120, 117, 160),
		ToggleToggled = Color3.fromRGB(30, 12, 68),
		SliderRail = Color3.fromRGB(117, 117, 160),
		DropdownFrame = Color3.fromRGB(161, 161, 200),
		DropdownHolder = Color3.fromRGB(35, 36, 80),
		DropdownBorder = Color3.fromRGB(32, 30, 65),
		DropdownOption = Color3.fromRGB(116, 116, 160),
		Keybind = Color3.fromRGB(110, 123, 160),
		Input = Color3.fromRGB(116, 112, 160),
		InputFocused = Color3.fromRGB(20, 10, 30),
		InputIndicator = Color3.fromRGB(136, 140, 190),
		Dialog = Color3.fromRGB(37, 37, 80),
		DialogHolder = Color3.fromRGB(24, 24, 65),
		DialogHolderLine = Color3.fromRGB(25, 26, 60),
		DialogButton = Color3.fromRGB(46, 44, 80),
		DialogButtonBorder = Color3.fromRGB(71, 72, 110),
		DialogBorder = Color3.fromRGB(72, 70, 100),
		DialogInput = Color3.fromRGB(55, 55, 85),
		DialogInputLine = Color3.fromRGB(133, 131, 190),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(119, 121, 160),
		HoverChange = 0.04,
	},
	Forest = {
		Name = "Forest",
		Accent = Color3.fromRGB(46, 141, 70),
		AcrylicMain = Color3.fromRGB(20, 35, 25),
		AcrylicBorder = Color3.fromRGB(50, 90, 60),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(15, 35, 20), Color3.fromRGB(20, 40, 25)),
		AcrylicNoise = 0.92,
		TitleBarLine = Color3.fromRGB(60, 100, 70),
		Tab = Color3.fromRGB(80, 140, 90),
		Element = Color3.fromRGB(70, 120, 80),
		ElementBorder = Color3.fromRGB(30, 50, 35),
		InElementBorder = Color3.fromRGB(60, 90, 70),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(90, 150, 100),
		ToggleToggled = Color3.fromRGB(19, 57, 21),
		SliderRail = Color3.fromRGB(90, 150, 100),
		DropdownFrame = Color3.fromRGB(100, 160, 110),
		DropdownHolder = Color3.fromRGB(35, 60, 40),
		DropdownBorder = Color3.fromRGB(30, 50, 35),
		DropdownOption = Color3.fromRGB(90, 150, 100),
		Keybind = Color3.fromRGB(90, 150, 100),
		Input = Color3.fromRGB(90, 150, 100),
		InputFocused = Color3.fromRGB(15, 25, 18),
		InputIndicator = Color3.fromRGB(110, 170, 120),
		InputIndicatorFocus = Color3.fromRGB(46, 141, 70),
		Dialog = Color3.fromRGB(35, 60, 40),
		DialogHolder = Color3.fromRGB(30, 50, 35),
		DialogHolderLine = Color3.fromRGB(25, 45, 30),
		DialogButton = Color3.fromRGB(35, 60, 40),
		DialogButtonBorder = Color3.fromRGB(70, 110, 80),
		DialogBorder = Color3.fromRGB(60, 100, 70),
		DialogInput = Color3.fromRGB(45, 70, 50),
		DialogInputLine = Color3.fromRGB(100, 160, 110),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(90, 150, 100),
		HoverChange = 0.04
	},
	Sunset = {
		Name = "Sunset",
		Accent = Color3.fromRGB(255, 128, 0),
		AcrylicMain = Color3.fromRGB(40, 25, 25),
		AcrylicBorder = Color3.fromRGB(130, 80, 60),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(70, 35, 20), Color3.fromRGB(60, 30, 20)),
		AcrylicNoise = 0.92,
		TitleBarLine = Color3.fromRGB(140, 90, 70),
		Tab = Color3.fromRGB(180, 120, 90),
		Element = Color3.fromRGB(160, 100, 70),
		ElementBorder = Color3.fromRGB(70, 40, 30),
		InElementBorder = Color3.fromRGB(110, 70, 50),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(180, 110, 80),
		ToggleToggled = Color3.fromRGB(62, 34, 21),
		SliderRail = Color3.fromRGB(180, 110, 80),
		DropdownFrame = Color3.fromRGB(190, 130, 100),
		DropdownHolder = Color3.fromRGB(60, 35, 25),
		DropdownBorder = Color3.fromRGB(70, 40, 30),
		DropdownOption = Color3.fromRGB(180, 110, 80),
		Keybind = Color3.fromRGB(180, 110, 80),
		Input = Color3.fromRGB(180, 110, 80),
		InputFocused = Color3.fromRGB(30, 20, 15),
		InputIndicator = Color3.fromRGB(200, 130, 100),
		InputIndicatorFocus = Color3.fromRGB(255, 128, 0),
		Dialog = Color3.fromRGB(60, 35, 25),
		DialogHolder = Color3.fromRGB(50, 30, 20),
		DialogHolderLine = Color3.fromRGB(45, 25, 15),
		DialogButton = Color3.fromRGB(60, 35, 25),
		DialogButtonBorder = Color3.fromRGB(100, 65, 45),
		DialogBorder = Color3.fromRGB(90, 55, 40),
		DialogInput = Color3.fromRGB(70, 45, 35),
		DialogInputLine = Color3.fromRGB(190, 120, 90),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(180, 110, 80),
		HoverChange = 0.04
	},
	Ocean = {
		Name = "Ocean",
		Accent = Color3.fromRGB(0, 141, 255),
		AcrylicMain = Color3.fromRGB(20, 25, 40),
		AcrylicBorder = Color3.fromRGB(40, 60, 100),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(15, 25, 45), Color3.fromRGB(20, 30, 50)),
		AcrylicNoise = 0.92,
		TitleBarLine = Color3.fromRGB(50, 70, 120),
		Tab = Color3.fromRGB(70, 90, 160),
		Element = Color3.fromRGB(60, 80, 140),
		ElementBorder = Color3.fromRGB(30, 40, 70),
		InElementBorder = Color3.fromRGB(50, 60, 100),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(80, 100, 170),
		ToggleToggled = Color3.fromRGB(11, 35, 67),
		SliderRail = Color3.fromRGB(80, 100, 170),
		DropdownFrame = Color3.fromRGB(90, 110, 180),
		DropdownHolder = Color3.fromRGB(25, 35, 60),
		DropdownBorder = Color3.fromRGB(30, 40, 70),
		DropdownOption = Color3.fromRGB(80, 100, 170),
		Keybind = Color3.fromRGB(80, 100, 170),
		Input = Color3.fromRGB(80, 100, 170),
		InputFocused = Color3.fromRGB(15, 20, 35),
		InputIndicator = Color3.fromRGB(100, 120, 190),
		InputIndicatorFocus = Color3.fromRGB(0, 141, 255),
		Dialog = Color3.fromRGB(25, 35, 60),
		DialogHolder = Color3.fromRGB(20, 30, 55),
		DialogHolderLine = Color3.fromRGB(15, 25, 50),
		DialogButton = Color3.fromRGB(25, 35, 60),
		DialogButtonBorder = Color3.fromRGB(45, 65, 110),
		DialogBorder = Color3.fromRGB(40, 60, 100),
		DialogInput = Color3.fromRGB(35, 45, 70),
		DialogInputLine = Color3.fromRGB(90, 110, 180),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(80, 100, 170),
		HoverChange = 0.04
	},
	Emerald = {
		Name = "Emerald",
		Accent = Color3.fromRGB(0, 168, 107),
		AcrylicMain = Color3.fromRGB(20, 35, 30),
		AcrylicBorder = Color3.fromRGB(30, 100, 80),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(20, 55, 45), Color3.fromRGB(25, 60, 50)),
		AcrylicNoise = 0.92,
		TitleBarLine = Color3.fromRGB(40, 110, 90),
		Tab = Color3.fromRGB(50, 130, 100),
		Element = Color3.fromRGB(40, 120, 95),
		ElementBorder = Color3.fromRGB(25, 75, 60),
		InElementBorder = Color3.fromRGB(35, 85, 70),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(45, 130, 100),
		ToggleToggled = Color3.fromRGB(15, 40, 30),
		SliderRail = Color3.fromRGB(45, 130, 100),
		DropdownFrame = Color3.fromRGB(55, 140, 110),
		DropdownHolder = Color3.fromRGB(20, 70, 55),
		DropdownBorder = Color3.fromRGB(25, 75, 60),
		DropdownOption = Color3.fromRGB(45, 130, 100),
		Keybind = Color3.fromRGB(45, 130, 100),
		Input = Color3.fromRGB(45, 130, 100),
		InputFocused = Color3.fromRGB(10, 35, 25),
		InputIndicator = Color3.fromRGB(55, 150, 120),
		InputIndicatorFocus = Color3.fromRGB(0, 168, 107),
		Dialog = Color3.fromRGB(20, 70, 55),
		DialogHolder = Color3.fromRGB(15, 65, 50),
		DialogHolderLine = Color3.fromRGB(15, 60, 45),
		DialogButton = Color3.fromRGB(20, 70, 55),
		DialogButtonBorder = Color3.fromRGB(30, 90, 70),
		DialogBorder = Color3.fromRGB(25, 85, 65),
		DialogInput = Color3.fromRGB(25, 75, 60),
		DialogInputLine = Color3.fromRGB(50, 140, 110),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(45, 130, 100),
		HoverChange = 0.04
	},
	Sapphire = {
		Name = "Sapphire",
		Accent = Color3.fromRGB(0, 105, 255),
		AcrylicMain = Color3.fromRGB(24, 30, 85),
		AcrylicBorder = Color3.fromRGB(25, 80, 150),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(13, 33, 94), Color3.fromRGB(21, 44, 127)),
		AcrylicNoise = 0.88,
		TitleBarLine = Color3.fromRGB(50, 120, 200),
		Tab = Color3.fromRGB(60, 140, 220),
		Element = Color3.fromRGB(42, 98, 176),
		ElementBorder = Color3.fromRGB(23, 66, 113),
		InElementBorder = Color3.fromRGB(27, 65, 126),
		ElementTransparency = 0.85,
		ToggleSlider = Color3.fromRGB(50, 140, 210),
		ToggleToggled = Color3.fromRGB(20, 50, 80),
		SliderRail = Color3.fromRGB(50, 140, 210),
		DropdownFrame = Color3.fromRGB(60, 150, 230),
		DropdownHolder = Color3.fromRGB(15, 60, 100),
		DropdownBorder = Color3.fromRGB(30, 90, 140),
		DropdownOption = Color3.fromRGB(50, 140, 210),
		Keybind = Color3.fromRGB(50, 140, 210),
		Input = Color3.fromRGB(50, 140, 210),
		InputFocused = Color3.fromRGB(15, 40, 60),
		InputIndicator = Color3.fromRGB(60, 160, 240),
		InputIndicatorFocus = Color3.fromRGB(0, 105, 255),
		Dialog = Color3.fromRGB(10, 60, 100),
		DialogHolder = Color3.fromRGB(15, 50, 90),
		DialogHolderLine = Color3.fromRGB(15, 45, 80),
		DialogButton = Color3.fromRGB(10, 60, 100),
		DialogButtonBorder = Color3.fromRGB(30, 100, 160),
		DialogBorder = Color3.fromRGB(20, 80, 130),
		DialogInput = Color3.fromRGB(30, 90, 140),
		DialogInputLine = Color3.fromRGB(55, 150, 230),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(50, 140, 210),
		HoverChange = 0.05
	},
	Cloud = {
		Name = "Cloud",
		Accent = Color3.fromRGB(27, 114, 138),
		AcrylicMain = Color3.fromRGB(13, 62, 77),
		AcrylicBorder = Color3.fromRGB(80, 118, 130),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(51, 74, 83), Color3.fromRGB(4, 47, 66)),
		AcrylicNoise = 0.94,
		TitleBarLine = Color3.fromRGB(97, 97, 97),
		Tab = Color3.fromRGB(126, 175, 180),
		Element = Color3.fromRGB(66, 130, 160),
		ElementBorder = Color3.fromRGB(40, 100, 122),
		InElementBorder = Color3.fromRGB(75, 109, 110),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(100, 152, 160),
		ToggleToggled = Color3.fromRGB(26, 59, 80),
		SliderRail = Color3.fromRGB(115, 150, 160),
		DropdownFrame = Color3.fromRGB(158, 194, 200),
		DropdownHolder = Color3.fromRGB(39, 99, 116),
		DropdownBorder = Color3.fromRGB(33, 119, 120),
		DropdownOption = Color3.fromRGB(121, 152, 160),
		Keybind = Color3.fromRGB(108, 153, 160),
		Input = Color3.fromRGB(112, 156, 160),
		InputFocused = Color3.fromRGB(14, 35, 40),
		InputIndicator = Color3.fromRGB(137, 181, 190),
		Dialog = Color3.fromRGB(11, 75, 88),
		DialogHolder = Color3.fromRGB(18, 77, 93),
		DialogHolderLine = Color3.fromRGB(33, 76, 86),
		DialogButton = Color3.fromRGB(43, 72, 80),
		DialogButtonBorder = Color3.fromRGB(62, 100, 110),
		DialogBorder = Color3.fromRGB(26, 86, 100),
		DialogInput = Color3.fromRGB(4, 97, 107),
		DialogInputLine = Color3.fromRGB(70, 120, 130),
		Text = Color3.fromRGB(209, 240, 233),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(112, 155, 160),
		HoverChange = 0.04,
	},
	Grape = {
		Name = "Grape",
		Accent = Color3.fromRGB(183, 176, 223),
		AcrylicMain = Color3.fromRGB(0, 0, 0),
		AcrylicBorder = Color3.fromRGB(20, 20, 20),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(6, 0, 16), Color3.fromRGB(6, 0, 16)),
		AcrylicNoise = 1,
		TitleBarLine = Color3.fromRGB(25, 25, 25),
		Tab = Color3.fromRGB(40, 40, 40),
		Element = Color3.fromRGB(15, 15, 15),
		ElementBorder = Color3.fromRGB(6, 0, 16),
		InElementBorder = Color3.fromRGB(40, 40, 40),
		ElementTransparency = 1,
		ToggleSlider = Color3.fromRGB(255, 255, 255),
		ToggleToggled = Color3.fromRGB(19, 16, 36),
		SliderRail = Color3.fromRGB(40, 40, 40),
		DropdownFrame = Color3.fromRGB(20, 20, 20),
		DropdownHolder = Color3.fromRGB(12, 0, 34),
		DropdownBorder = Color3.fromRGB(6, 0, 16),
		DropdownOption = Color3.fromRGB(40, 40, 40),
		Keybind = Color3.fromRGB(40, 40, 40),
		Input = Color3.fromRGB(40, 40, 40),
		InputFocused = Color3.fromRGB(6, 0, 16),
		InputIndicator = Color3.fromRGB(60, 60, 60),
		InputIndicatorFocus = Color3.fromRGB(255, 255, 255),
		Dialog = Color3.fromRGB(7, 0, 18),
		DialogHolder = Color3.fromRGB(7, 0, 18),
		DialogHolderLine = Color3.fromRGB(7, 0, 18),
		DialogButton = Color3.fromRGB(13, 0, 33),
		DialogButtonBorder = Color3.fromRGB(30, 30, 30),
		DialogBorder = Color3.fromRGB(27, 27, 27),
		DialogInput = Color3.fromRGB(7, 0, 18),
		DialogInputLine = Color3.fromRGB(60, 60, 60),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(123, 144, 170),
		Hover = Color3.fromRGB(40, 40, 40),
		HoverChange = 0.04
	},
	Bloody = {
		Name = "Bloody",
		Accent = Color3.fromRGB(144, 0, 0),
		AcrylicMain = Color3.fromRGB(61, 0, 0),
		AcrylicBorder = Color3.fromRGB(86, 0, 0),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(90, 0, 0), Color3.fromRGB(100, 0, 0)),
		AcrylicNoise = 0.92,
		TitleBarLine = Color3.fromRGB(126, 0, 0),
		Tab = Color3.fromRGB(134, 0, 0),
		Element = Color3.fromRGB(156, 0, 0),
		ElementBorder = Color3.fromRGB(91, 0, 0),
		InElementBorder = Color3.fromRGB(106, 0, 0),
		ElementTransparency = 0.86,
		ToggleSlider = Color3.fromRGB(130, 5, 5),
		ToggleToggled = Color3.fromRGB(66, 0, 0),
		SliderRail = Color3.fromRGB(150, 30, 30),
		DropdownFrame = Color3.fromRGB(150, 30, 30),
		DropdownHolder = Color3.fromRGB(79, 0, 0),
		DropdownBorder = Color3.fromRGB(116, 0, 0),
		DropdownOption = Color3.fromRGB(150, 30, 30),
		Keybind = Color3.fromRGB(150, 30, 30),
		Input = Color3.fromRGB(150, 30, 30),
		InputFocused = Color3.fromRGB(40, 10, 10),
		InputIndicator = Color3.fromRGB(113, 1, 1),
		Dialog = Color3.fromRGB(85, 0, 1),
		DialogHolder = Color3.fromRGB(77, 0, 8),
		DialogHolderLine = Color3.fromRGB(88, 4, 4),
		DialogButton = Color3.fromRGB(115, 14, 21),
		DialogButtonBorder = Color3.fromRGB(83, 0, 1),
		DialogBorder = Color3.fromRGB(43, 4, 5),
		DialogInput = Color3.fromRGB(108, 20, 21),
		DialogInputLine = Color3.fromRGB(91, 1, 1),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(131, 131, 131),
		Hover = Color3.fromRGB(181, 0, 0),
		HoverChange = 0.04
	},
	Arctic = {
		Name = "Arctic",
		Accent = Color3.fromRGB(64, 224, 255),
		AcrylicMain = Color3.fromRGB(10, 18, 25),
		AcrylicBorder = Color3.fromRGB(35, 55, 70),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(15, 25, 35), Color3.fromRGB(18, 30, 40)),
		AcrylicNoise = 0.94,
		TitleBarLine = Color3.fromRGB(45, 70, 90),
		Tab = Color3.fromRGB(70, 110, 140),
		Element = Color3.fromRGB(60, 95, 120),
		ElementBorder = Color3.fromRGB(60, 95, 120),
		InElementBorder = Color3.fromRGB(70, 110, 140),
		ElementTransparency = 0.88,
		ToggleSlider = Color3.fromRGB(90, 140, 180),
		ToggleToggled = Color3.fromRGB(15, 25, 35),
		SliderRail = Color3.fromRGB(90, 140, 180),
		DropdownFrame = Color3.fromRGB(110, 170, 220),
		DropdownHolder = Color3.fromRGB(30, 45, 60),
		DropdownBorder = Color3.fromRGB(60, 95, 120),
		DropdownOption = Color3.fromRGB(90, 140, 180),
		Keybind = Color3.fromRGB(90, 140, 180),
		Input = Color3.fromRGB(90, 140, 180),
		InputFocused = Color3.fromRGB(10, 18, 25),
		InputIndicator = Color3.fromRGB(130, 200, 255),
		InputIndicatorFocus = Color3.fromRGB(64, 224, 255),
		Dialog = Color3.fromRGB(30, 45, 60),
		DialogHolder = Color3.fromRGB(18, 30, 40),
		DialogHolderLine = Color3.fromRGB(15, 25, 35),
		DialogButton = Color3.fromRGB(30, 45, 60),
		DialogButtonBorder = Color3.fromRGB(45, 70, 90),
		DialogBorder = Color3.fromRGB(40, 60, 80),
		DialogInput = Color3.fromRGB(35, 55, 70),
		DialogInputLine = Color3.fromRGB(110, 170, 220),
		Text = Color3.fromRGB(240, 250, 255),
		SubText = Color3.fromRGB(180, 200, 220),
		Hover = Color3.fromRGB(90, 140, 180),
		HoverChange = 0.04
	},

	-- ✨ 10 NEW THEMES ✨

	Neon = {
		Name = "Neon",
		Accent = Color3.fromRGB(0, 255, 180),
		AcrylicMain = Color3.fromRGB(5, 5, 15),
		AcrylicBorder = Color3.fromRGB(0, 180, 120),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(5, 5, 20), Color3.fromRGB(10, 5, 25)),
		AcrylicNoise = 0.98,
		TitleBarLine = Color3.fromRGB(0, 150, 100),
		Tab = Color3.fromRGB(0, 200, 140),
		Element = Color3.fromRGB(0, 160, 110),
		ElementBorder = Color3.fromRGB(0, 100, 70),
		InElementBorder = Color3.fromRGB(0, 140, 90),
		ElementTransparency = 0.88,
		ToggleSlider = Color3.fromRGB(0, 200, 140),
		ToggleToggled = Color3.fromRGB(5, 20, 15),
		SliderRail = Color3.fromRGB(0, 180, 120),
		DropdownFrame = Color3.fromRGB(0, 220, 160),
		DropdownHolder = Color3.fromRGB(0, 30, 20),
		DropdownBorder = Color3.fromRGB(0, 100, 70),
		DropdownOption = Color3.fromRGB(0, 180, 120),
		Keybind = Color3.fromRGB(0, 180, 120),
		Input = Color3.fromRGB(0, 160, 110),
		InputFocused = Color3.fromRGB(0, 20, 15),
		InputIndicator = Color3.fromRGB(0, 220, 160),
		InputIndicatorFocus = Color3.fromRGB(0, 255, 180),
		Dialog = Color3.fromRGB(0, 25, 18),
		DialogHolder = Color3.fromRGB(5, 18, 13),
		DialogHolderLine = Color3.fromRGB(0, 15, 10),
		DialogButton = Color3.fromRGB(0, 30, 20),
		DialogButtonBorder = Color3.fromRGB(0, 120, 80),
		DialogBorder = Color3.fromRGB(0, 100, 70),
		DialogInput = Color3.fromRGB(0, 35, 25),
		DialogInputLine = Color3.fromRGB(0, 180, 120),
		Text = Color3.fromRGB(200, 255, 230),
		SubText = Color3.fromRGB(100, 200, 160),
		Hover = Color3.fromRGB(0, 180, 120),
		HoverChange = 0.04
	},
	Lavender = {
		Name = "Lavender",
		Accent = Color3.fromRGB(160, 130, 255),
		AcrylicMain = Color3.fromRGB(25, 20, 45),
		AcrylicBorder = Color3.fromRGB(80, 60, 130),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(30, 22, 55), Color3.fromRGB(38, 28, 65)),
		AcrylicNoise = 0.93,
		TitleBarLine = Color3.fromRGB(90, 70, 150),
		Tab = Color3.fromRGB(130, 105, 200),
		Element = Color3.fromRGB(100, 80, 170),
		ElementBorder = Color3.fromRGB(55, 40, 100),
		InElementBorder = Color3.fromRGB(80, 60, 140),
		ElementTransparency = 0.86,
		ToggleSlider = Color3.fromRGB(140, 110, 210),
		ToggleToggled = Color3.fromRGB(30, 20, 60),
		SliderRail = Color3.fromRGB(130, 100, 200),
		DropdownFrame = Color3.fromRGB(150, 120, 220),
		DropdownHolder = Color3.fromRGB(35, 28, 65),
		DropdownBorder = Color3.fromRGB(70, 55, 120),
		DropdownOption = Color3.fromRGB(130, 100, 200),
		Keybind = Color3.fromRGB(130, 100, 200),
		Input = Color3.fromRGB(110, 85, 180),
		InputFocused = Color3.fromRGB(20, 15, 40),
		InputIndicator = Color3.fromRGB(160, 130, 240),
		InputIndicatorFocus = Color3.fromRGB(160, 130, 255),
		Dialog = Color3.fromRGB(32, 25, 60),
		DialogHolder = Color3.fromRGB(25, 20, 50),
		DialogHolderLine = Color3.fromRGB(22, 17, 45),
		DialogButton = Color3.fromRGB(35, 28, 65),
		DialogButtonBorder = Color3.fromRGB(80, 60, 140),
		DialogBorder = Color3.fromRGB(70, 55, 120),
		DialogInput = Color3.fromRGB(40, 32, 75),
		DialogInputLine = Color3.fromRGB(140, 110, 210),
		Text = Color3.fromRGB(235, 225, 255),
		SubText = Color3.fromRGB(160, 145, 210),
		Hover = Color3.fromRGB(130, 100, 200),
		HoverChange = 0.04
	},
	Cyberpunk = {
		Name = "Cyberpunk",
		Accent = Color3.fromRGB(255, 220, 0),
		AcrylicMain = Color3.fromRGB(10, 5, 20),
		AcrylicBorder = Color3.fromRGB(180, 0, 100),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(8, 3, 18), Color3.fromRGB(15, 5, 30)),
		AcrylicNoise = 0.97,
		TitleBarLine = Color3.fromRGB(180, 0, 90),
		Tab = Color3.fromRGB(200, 0, 110),
		Element = Color3.fromRGB(140, 0, 80),
		ElementBorder = Color3.fromRGB(80, 0, 45),
		InElementBorder = Color3.fromRGB(120, 0, 65),
		ElementTransparency = 0.88,
		ToggleSlider = Color3.fromRGB(180, 0, 100),
		ToggleToggled = Color3.fromRGB(20, 5, 30),
		SliderRail = Color3.fromRGB(160, 0, 90),
		DropdownFrame = Color3.fromRGB(200, 0, 110),
		DropdownHolder = Color3.fromRGB(15, 5, 30),
		DropdownBorder = Color3.fromRGB(100, 0, 55),
		DropdownOption = Color3.fromRGB(160, 0, 90),
		Keybind = Color3.fromRGB(160, 0, 90),
		Input = Color3.fromRGB(130, 0, 75),
		InputFocused = Color3.fromRGB(8, 3, 18),
		InputIndicator = Color3.fromRGB(200, 0, 110),
		InputIndicatorFocus = Color3.fromRGB(255, 220, 0),
		Dialog = Color3.fromRGB(12, 5, 25),
		DialogHolder = Color3.fromRGB(10, 3, 20),
		DialogHolderLine = Color3.fromRGB(8, 2, 16),
		DialogButton = Color3.fromRGB(15, 5, 30),
		DialogButtonBorder = Color3.fromRGB(100, 0, 55),
		DialogBorder = Color3.fromRGB(80, 0, 45),
		DialogInput = Color3.fromRGB(18, 6, 35),
		DialogInputLine = Color3.fromRGB(160, 0, 90),
		Text = Color3.fromRGB(255, 240, 200),
		SubText = Color3.fromRGB(200, 100, 150),
		Hover = Color3.fromRGB(180, 0, 100),
		HoverChange = 0.04
	},
	Sakura = {
		Name = "Sakura",
		Accent = Color3.fromRGB(255, 100, 150),
		AcrylicMain = Color3.fromRGB(45, 25, 35),
		AcrylicBorder = Color3.fromRGB(200, 100, 140),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(60, 30, 45), Color3.fromRGB(70, 35, 52)),
		AcrylicNoise = 0.91,
		TitleBarLine = Color3.fromRGB(210, 120, 155),
		Tab = Color3.fromRGB(220, 130, 165),
		Element = Color3.fromRGB(190, 100, 135),
		ElementBorder = Color3.fromRGB(110, 55, 80),
		InElementBorder = Color3.fromRGB(155, 80, 110),
		ElementTransparency = 0.85,
		ToggleSlider = Color3.fromRGB(220, 130, 165),
		ToggleToggled = Color3.fromRGB(50, 25, 35),
		SliderRail = Color3.fromRGB(200, 110, 150),
		DropdownFrame = Color3.fromRGB(230, 145, 180),
		DropdownHolder = Color3.fromRGB(65, 35, 50),
		DropdownBorder = Color3.fromRGB(130, 70, 100),
		DropdownOption = Color3.fromRGB(200, 110, 150),
		Keybind = Color3.fromRGB(200, 110, 150),
		Input = Color3.fromRGB(180, 95, 130),
		InputFocused = Color3.fromRGB(30, 15, 22),
		InputIndicator = Color3.fromRGB(240, 155, 190),
		InputIndicatorFocus = Color3.fromRGB(255, 100, 150),
		Dialog = Color3.fromRGB(60, 32, 45),
		DialogHolder = Color3.fromRGB(50, 26, 37),
		DialogHolderLine = Color3.fromRGB(44, 22, 33),
		DialogButton = Color3.fromRGB(65, 35, 50),
		DialogButtonBorder = Color3.fromRGB(145, 75, 105),
		DialogBorder = Color3.fromRGB(120, 65, 92),
		DialogInput = Color3.fromRGB(75, 40, 57),
		DialogInputLine = Color3.fromRGB(210, 120, 155),
		Text = Color3.fromRGB(255, 240, 245),
		SubText = Color3.fromRGB(220, 175, 195),
		Hover = Color3.fromRGB(200, 110, 150),
		HoverChange = 0.04
	},
	Toxic = {
		Name = "Toxic",
		Accent = Color3.fromRGB(150, 255, 0),
		AcrylicMain = Color3.fromRGB(8, 18, 5),
		AcrylicBorder = Color3.fromRGB(80, 150, 0),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(6, 15, 4), Color3.fromRGB(10, 22, 6)),
		AcrylicNoise = 0.96,
		TitleBarLine = Color3.fromRGB(100, 180, 0),
		Tab = Color3.fromRGB(110, 200, 0),
		Element = Color3.fromRGB(90, 160, 0),
		ElementBorder = Color3.fromRGB(50, 90, 0),
		InElementBorder = Color3.fromRGB(75, 130, 0),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(120, 210, 0),
		ToggleToggled = Color3.fromRGB(8, 18, 5),
		SliderRail = Color3.fromRGB(100, 180, 0),
		DropdownFrame = Color3.fromRGB(130, 220, 0),
		DropdownHolder = Color3.fromRGB(12, 25, 7),
		DropdownBorder = Color3.fromRGB(70, 120, 0),
		DropdownOption = Color3.fromRGB(100, 180, 0),
		Keybind = Color3.fromRGB(100, 180, 0),
		Input = Color3.fromRGB(85, 150, 0),
		InputFocused = Color3.fromRGB(5, 12, 3),
		InputIndicator = Color3.fromRGB(140, 230, 0),
		InputIndicatorFocus = Color3.fromRGB(150, 255, 0),
		Dialog = Color3.fromRGB(10, 20, 6),
		DialogHolder = Color3.fromRGB(8, 16, 5),
		DialogHolderLine = Color3.fromRGB(6, 12, 4),
		DialogButton = Color3.fromRGB(12, 24, 7),
		DialogButtonBorder = Color3.fromRGB(80, 140, 0),
		DialogBorder = Color3.fromRGB(65, 115, 0),
		DialogInput = Color3.fromRGB(14, 28, 8),
		DialogInputLine = Color3.fromRGB(110, 200, 0),
		Text = Color3.fromRGB(220, 255, 200),
		SubText = Color3.fromRGB(130, 200, 80),
		Hover = Color3.fromRGB(110, 200, 0),
		HoverChange = 0.04
	},
	Gold = {
		Name = "Gold",
		Accent = Color3.fromRGB(255, 195, 0),
		AcrylicMain = Color3.fromRGB(20, 16, 5),
		AcrylicBorder = Color3.fromRGB(120, 90, 0),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(25, 19, 5), Color3.fromRGB(30, 23, 7)),
		AcrylicNoise = 0.93,
		TitleBarLine = Color3.fromRGB(150, 115, 10),
		Tab = Color3.fromRGB(180, 140, 15),
		Element = Color3.fromRGB(145, 110, 10),
		ElementBorder = Color3.fromRGB(80, 62, 5),
		InElementBorder = Color3.fromRGB(120, 92, 8),
		ElementTransparency = 0.86,
		ToggleSlider = Color3.fromRGB(190, 148, 15),
		ToggleToggled = Color3.fromRGB(25, 19, 5),
		SliderRail = Color3.fromRGB(170, 132, 12),
		DropdownFrame = Color3.fromRGB(200, 158, 20),
		DropdownHolder = Color3.fromRGB(28, 21, 6),
		DropdownBorder = Color3.fromRGB(100, 77, 7),
		DropdownOption = Color3.fromRGB(170, 132, 12),
		Keybind = Color3.fromRGB(170, 132, 12),
		Input = Color3.fromRGB(145, 110, 10),
		InputFocused = Color3.fromRGB(15, 11, 3),
		InputIndicator = Color3.fromRGB(220, 172, 22),
		InputIndicatorFocus = Color3.fromRGB(255, 195, 0),
		Dialog = Color3.fromRGB(24, 18, 6),
		DialogHolder = Color3.fromRGB(20, 15, 5),
		DialogHolderLine = Color3.fromRGB(17, 13, 4),
		DialogButton = Color3.fromRGB(28, 21, 7),
		DialogButtonBorder = Color3.fromRGB(120, 92, 8),
		DialogBorder = Color3.fromRGB(100, 77, 7),
		DialogInput = Color3.fromRGB(32, 24, 8),
		DialogInputLine = Color3.fromRGB(175, 135, 15),
		Text = Color3.fromRGB(255, 248, 220),
		SubText = Color3.fromRGB(210, 175, 90),
		Hover = Color3.fromRGB(170, 132, 12),
		HoverChange = 0.04
	},
	Mint = {
		Name = "Mint",
		Accent = Color3.fromRGB(62, 210, 170),
		AcrylicMain = Color3.fromRGB(220, 250, 240),
		AcrylicBorder = Color3.fromRGB(140, 230, 200),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(240, 255, 248), Color3.fromRGB(225, 248, 238)),
		AcrylicNoise = 0.94,
		TitleBarLine = Color3.fromRGB(160, 225, 200),
		Tab = Color3.fromRGB(80, 195, 155),
		Element = Color3.fromRGB(120, 215, 185),
		ElementBorder = Color3.fromRGB(100, 190, 160),
		InElementBorder = Color3.fromRGB(115, 205, 175),
		ElementTransparency = 0.75,
		ToggleSlider = Color3.fromRGB(62, 185, 148),
		ToggleToggled = Color3.fromRGB(200, 240, 225),
		SliderRail = Color3.fromRGB(140, 220, 190),
		DropdownFrame = Color3.fromRGB(160, 235, 210),
		DropdownHolder = Color3.fromRGB(235, 252, 245),
		DropdownBorder = Color3.fromRGB(120, 210, 180),
		DropdownOption = Color3.fromRGB(100, 200, 165),
		Keybind = Color3.fromRGB(100, 200, 165),
		Input = Color3.fromRGB(140, 220, 192),
		InputFocused = Color3.fromRGB(85, 175, 145),
		InputIndicator = Color3.fromRGB(80, 195, 155),
		InputIndicatorFocus = Color3.fromRGB(62, 210, 170),
		Dialog = Color3.fromRGB(235, 252, 245),
		DialogHolder = Color3.fromRGB(242, 255, 250),
		DialogHolderLine = Color3.fromRGB(230, 248, 240),
		DialogButton = Color3.fromRGB(240, 255, 248),
		DialogButtonBorder = Color3.fromRGB(150, 225, 195),
		DialogBorder = Color3.fromRGB(130, 215, 182),
		DialogInput = Color3.fromRGB(225, 248, 238),
		DialogInputLine = Color3.fromRGB(140, 220, 190),
		Text = Color3.fromRGB(20, 50, 40),
		SubText = Color3.fromRGB(50, 120, 95),
		Hover = Color3.fromRGB(140, 220, 192),
		HoverChange = 0.05
	},
	Volcanic = {
		Name = "Volcanic",
		Accent = Color3.fromRGB(255, 80, 0),
		AcrylicMain = Color3.fromRGB(15, 8, 5),
		AcrylicBorder = Color3.fromRGB(120, 40, 0),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(20, 10, 5), Color3.fromRGB(28, 14, 7)),
		AcrylicNoise = 0.96,
		TitleBarLine = Color3.fromRGB(140, 55, 5),
		Tab = Color3.fromRGB(165, 65, 8),
		Element = Color3.fromRGB(130, 50, 5),
		ElementBorder = Color3.fromRGB(70, 28, 3),
		InElementBorder = Color3.fromRGB(105, 42, 4),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(170, 70, 10),
		ToggleToggled = Color3.fromRGB(20, 10, 5),
		SliderRail = Color3.fromRGB(150, 60, 8),
		DropdownFrame = Color3.fromRGB(185, 80, 12),
		DropdownHolder = Color3.fromRGB(22, 11, 6),
		DropdownBorder = Color3.fromRGB(90, 36, 4),
		DropdownOption = Color3.fromRGB(150, 60, 8),
		Keybind = Color3.fromRGB(150, 60, 8),
		Input = Color3.fromRGB(125, 50, 5),
		InputFocused = Color3.fromRGB(10, 5, 3),
		InputIndicator = Color3.fromRGB(200, 90, 15),
		InputIndicatorFocus = Color3.fromRGB(255, 80, 0),
		Dialog = Color3.fromRGB(20, 10, 6),
		DialogHolder = Color3.fromRGB(16, 8, 4),
		DialogHolderLine = Color3.fromRGB(13, 6, 3),
		DialogButton = Color3.fromRGB(22, 11, 6),
		DialogButtonBorder = Color3.fromRGB(100, 40, 5),
		DialogBorder = Color3.fromRGB(85, 34, 4),
		DialogInput = Color3.fromRGB(26, 13, 7),
		DialogInputLine = Color3.fromRGB(160, 65, 10),
		Text = Color3.fromRGB(255, 235, 220),
		SubText = Color3.fromRGB(210, 140, 100),
		Hover = Color3.fromRGB(160, 65, 10),
		HoverChange = 0.04
	},
	Galaxy = {
		Name = "Galaxy",
		Accent = Color3.fromRGB(130, 80, 255),
		AcrylicMain = Color3.fromRGB(5, 3, 15),
		AcrylicBorder = Color3.fromRGB(60, 30, 130),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(8, 4, 22), Color3.fromRGB(12, 6, 30)),
		AcrylicNoise = 0.97,
		TitleBarLine = Color3.fromRGB(70, 35, 155),
		Tab = Color3.fromRGB(90, 50, 180),
		Element = Color3.fromRGB(70, 38, 150),
		ElementBorder = Color3.fromRGB(38, 20, 82),
		InElementBorder = Color3.fromRGB(58, 30, 125),
		ElementTransparency = 0.88,
		ToggleSlider = Color3.fromRGB(100, 58, 195),
		ToggleToggled = Color3.fromRGB(8, 4, 22),
		SliderRail = Color3.fromRGB(85, 48, 170),
		DropdownFrame = Color3.fromRGB(110, 65, 210),
		DropdownHolder = Color3.fromRGB(10, 5, 28),
		DropdownBorder = Color3.fromRGB(50, 26, 110),
		DropdownOption = Color3.fromRGB(85, 48, 170),
		Keybind = Color3.fromRGB(85, 48, 170),
		Input = Color3.fromRGB(72, 40, 145),
		InputFocused = Color3.fromRGB(5, 3, 15),
		InputIndicator = Color3.fromRGB(120, 72, 225),
		InputIndicatorFocus = Color3.fromRGB(130, 80, 255),
		Dialog = Color3.fromRGB(8, 4, 22),
		DialogHolder = Color3.fromRGB(6, 3, 18),
		DialogHolderLine = Color3.fromRGB(5, 2, 14),
		DialogButton = Color3.fromRGB(10, 5, 28),
		DialogButtonBorder = Color3.fromRGB(65, 34, 140),
		DialogBorder = Color3.fromRGB(55, 28, 118),
		DialogInput = Color3.fromRGB(12, 6, 33),
		DialogInputLine = Color3.fromRGB(95, 55, 185),
		Text = Color3.fromRGB(225, 210, 255),
		SubText = Color3.fromRGB(150, 120, 220),
		Hover = Color3.fromRGB(90, 50, 180),
		HoverChange = 0.04
	},
	Coral = {
		Name = "Coral",
		Accent = Color3.fromRGB(255, 100, 80),
		AcrylicMain = Color3.fromRGB(45, 18, 15),
		AcrylicBorder = Color3.fromRGB(200, 80, 65),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(55, 20, 17), Color3.fromRGB(65, 24, 20)),
		AcrylicNoise = 0.91,
		TitleBarLine = Color3.fromRGB(210, 95, 78),
		Tab = Color3.fromRGB(220, 100, 85),
		Element = Color3.fromRGB(185, 80, 65),
		ElementBorder = Color3.fromRGB(100, 42, 35),
		InElementBorder = Color3.fromRGB(150, 65, 52),
		ElementTransparency = 0.85,
		ToggleSlider = Color3.fromRGB(225, 108, 90),
		ToggleToggled = Color3.fromRGB(48, 18, 15),
		SliderRail = Color3.fromRGB(205, 92, 75),
		DropdownFrame = Color3.fromRGB(235, 115, 96),
		DropdownHolder = Color3.fromRGB(60, 24, 20),
		DropdownBorder = Color3.fromRGB(120, 50, 42),
		DropdownOption = Color3.fromRGB(200, 88, 72),
		Keybind = Color3.fromRGB(200, 88, 72),
		Input = Color3.fromRGB(178, 76, 62),
		InputFocused = Color3.fromRGB(28, 11, 9),
		InputIndicator = Color3.fromRGB(245, 122, 102),
		InputIndicatorFocus = Color3.fromRGB(255, 100, 80),
		Dialog = Color3.fromRGB(58, 22, 18),
		DialogHolder = Color3.fromRGB(48, 18, 15),
		DialogHolderLine = Color3.fromRGB(42, 16, 13),
		DialogButton = Color3.fromRGB(62, 24, 20),
		DialogButtonBorder = Color3.fromRGB(140, 58, 48),
		DialogBorder = Color3.fromRGB(118, 50, 40),
		DialogInput = Color3.fromRGB(70, 28, 23),
		DialogInputLine = Color3.fromRGB(210, 96, 78),
		Text = Color3.fromRGB(255, 240, 238),
		SubText = Color3.fromRGB(225, 175, 168),
		Hover = Color3.fromRGB(200, 88, 72),
		HoverChange = 0.04
	},
}

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
	MinimizeKey = Enum.KeyCode.LeftControl,
}

local function isMotor(value)
	local motorType = tostring(value):match("^Motor%((.+)%)$")

	if motorType then
		return true, motorType
	else
		return false
	end
end

local Connection = {}

Connection.__index = Connection

function Connection.new(signal, handler)
	return setmetatable({
		signal = signal,
		connected = true,
		_handler = handler,
	}, Connection)
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
	return setmetatable({
		_connections = {},
		_threads = {},
	}, Signal)
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

local Linear = {}
Linear.__index = Linear

function Linear.new(targetValue, options)
	assert(targetValue, "Missing argument #1: targetValue")

	options = options or {}

	return setmetatable({
		_targetValue = targetValue,
		_velocity = options.velocity or 1,
	}, Linear)
end

function Linear:step(state, dt)
	local position = state.value
	local velocity = self._velocity
	local goal = self._targetValue

	local dPos = dt * velocity

	local complete = dPos >= math.abs(goal - position)
	position = position + dPos * (goal > position and 1 or -1)
	if complete then
		position = self._targetValue
		velocity = 0
	end

	return {
		complete = complete,
		value = position,
		velocity = velocity,
	}
end

local Instant = {}
Instant.__index = Instant

function Instant.new(targetValue)
	return setmetatable({
		_targetValue = targetValue,
	}, Instant)
end

function Instant:step()
	return {
		complete = true,
		value = self._targetValue,
	}
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

		local z
		if c > EPS then
			z = j / c
		else
			local a = dt * f
			z = a + ((a * a) * (c * c) * (c * c) / 20 - c * c) * (a * a * a) / 6
		end

		local y
		if f * c > EPS then
			y = j / (f * c)
		else
			local b = f * c
			y = dt + ((dt * dt) * (b * b) * (b * b) / 20 - b * b) * (dt * dt * dt) / 6
		end

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

	return {
		complete = complete,
		value = complete and g or p1,
		velocity = v1,
	}
end

local noop = function() end

local BaseMotor = {}
BaseMotor.__index = BaseMotor

function BaseMotor.new()
	return setmetatable({
		_onStep = Signal.new(),
		_onStart = Signal.new(),
		_onComplete = Signal.new(),
	}, BaseMotor)
end

function BaseMotor:onStep(handler)
	return self._onStep:connect(handler)
end

function BaseMotor:onStart(handler)
	return self._onStart:connect(handler)
end

function BaseMotor:onComplete(handler)
	return self._onComplete:connect(handler)
end

function BaseMotor:start()
	if not self._connection then
		self._connection = RunService.RenderStepped:Connect(function(deltaTime)
			self:step(deltaTime)
		end)
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

function BaseMotor:__tostring()
	return "Motor"
end

local SingleMotor = setmetatable({}, BaseMotor)
SingleMotor.__index = SingleMotor

function SingleMotor.new(initialValue, useImplicitConnections)
	assert(initialValue, "Missing argument #1: initialValue")
	assert(typeof(initialValue) == "number", "initialValue must be a number!")

	local self = setmetatable(BaseMotor.new(), SingleMotor)

	if useImplicitConnections ~= nil then
		self._useImplicitConnections = useImplicitConnections
	else
		self._useImplicitConnections = true
	end

	self._goal = nil
	self._state = {
		complete = true,
		value = initialValue,
	}

	return self
end

function SingleMotor:step(deltaTime)
	if self._state.complete then
		return true
	end

	local newState = self._goal:step(self._state, deltaTime)

	self._state = newState
	self._onStep:fire(newState.value)

	if newState.complete then
		if self._useImplicitConnections then
			self:stop()
		end

		self._onComplete:fire()
	end

	return newState.complete
end

function SingleMotor:getValue()
	return self._state.value
end

function SingleMotor:setGoal(goal)
	self._state.complete = false
	self._goal = goal

	self._onStart:fire()

	if self._useImplicitConnections then
		self:start()
	end
end

function SingleMotor:__tostring()
	return "Motor(Single)"
end

local GroupMotor = setmetatable({}, BaseMotor)
GroupMotor.__index = GroupMotor

local function toMotor(value)
	if isMotor(value) then
		return value
	end

	local valueType = typeof(value)

	if valueType == "number" then
		return SingleMotor.new(value, false)
	elseif valueType == "table" then
		return GroupMotor.new(value, false)
	end

	error(("Unable to convert %q to motor; type %s is unsupported"):format(value, valueType), 2)
end

function GroupMotor.new(initialValues, useImplicitConnections)
	assert(initialValues, "Missing argument #1: initialValues")
	assert(typeof(initialValues) == "table", "initialValues must be a table!")
	assert(
		not initialValues.step,
		'initialValues contains disallowed property "step". Did you mean to put a table of values here?'
	)

	local self = setmetatable(BaseMotor.new(), GroupMotor)

	if useImplicitConnections ~= nil then
		self._useImplicitConnections = useImplicitConnections
	else
		self._useImplicitConnections = true
	end

	self._complete = true
	self._motors = {}

	for key, value in pairs(initialValues) do
		self._motors[key] = toMotor(value)
	end

	return self
end

function GroupMotor:step(deltaTime)
	if self._complete then
		return true
	end

	local allMotorsComplete = true

	for _, motor in pairs(self._motors) do
		local complete = motor:step(deltaTime)
		if not complete then

			allMotorsComplete = false
		end
	end

	self._onStep:fire(self:getValue())

	if allMotorsComplete then
		if self._useImplicitConnections then
			self:stop()
		end

		self._complete = true
		self._onComplete:fire()
	end

	return allMotorsComplete
end

function GroupMotor:setGoal(goals)
	assert(not goals.step, 'goals contains disallowed property "step". Did you mean to put a table of goals here?')

	self._complete = false
	self._onStart:fire()

	for key, goal in pairs(goals) do
		local motor = assert(self._motors[key], ("Unknown motor for key %s"):format(key))
		motor:setGoal(goal)
	end

	if self._useImplicitConnections then
		self:start()
	end
end

function GroupMotor:getValue()
	local values = {}

	for key, motor in pairs(self._motors) do
		values[key] = motor:getValue()
	end

	return values
end

function GroupMotor:__tostring()
	return "Motor(Group)"
end

local Flipper = {
	SingleMotor = SingleMotor,
	GroupMotor = GroupMotor,

	Instant = Instant,
	Linear = Linear,
	Spring = Spring,

	isMotor = isMotor,
}

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
			TextSize = 14,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
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

function Creator.GetThemeProperty(Property)
	local Theme = Creator.Themes[Creator.Theme]
	if Theme then
		return Theme[Property]
	end
	return Creator.Themes.Dark[Property]
end

function Creator.UpdateTheme()
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
	local themeName = (Library and Library.Theme) or Creator.Theme or "Dark"
	local theme = Themes[themeName] or Themes["Dark"]
	return theme[Property]
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

	for Name, Value in next, Properties or {} do
		if Name ~= "ThemeTag" then
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
	
	return Object
end

function Creator.SpringMotor(Initial, Instance, Prop, IgnoreDialogCheck, ResetOnThemeChange)
	IgnoreDialogCheck = IgnoreDialogCheck or false
	ResetOnThemeChange = ResetOnThemeChange or false
	local Motor = Flipper.SingleMotor.new(Initial)
	Motor:onStep(function(value)
		Instance[Prop] = value
	end)

	if ResetOnThemeChange then
		table.insert(Creator.TransparencyMotors, Motor)
	end

	local function SetValue(Value, Ignore)
		Ignore = Ignore or false
		if not IgnoreDialogCheck then
			if not Ignore then
				if Prop == "BackgroundTransparency" and Library.DialogOpen then
					return
				end
			end
		end
		Motor:setGoal(Flipper.Spring.new(Value, { frequency = 8 }))
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

local function map(value, inMin, inMax, outMin, outMax)
	return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

local function viewportPointToWorld(location, distance)
	local unitRay = game:GetService("Workspace").CurrentCamera:ScreenPointToRay(location.X, location.Y)
	return unitRay.Origin + unitRay.Direction * distance
end

local function getOffset()
	local viewportSizeY = game:GetService("Workspace").CurrentCamera.ViewportSize.Y
	return map(viewportSizeY, 0, 2560, 8, 56)
end

local viewportPointToWorld, getOffset = unpack({ viewportPointToWorld, getOffset })

local BlurFolder = Instance.new("Folder")
BlurFolder.Name = "FluentBlur"
do
	local ws = game:GetService("Workspace")
	local function attachToCurrentCamera()
		local cam = ws.CurrentCamera
		if cam and BlurFolder.Parent ~= cam then
			BlurFolder.Parent = cam
		end
	end
	attachToCurrentCamera()
	ws:GetPropertyChangedSignal("CurrentCamera"):Connect(attachToCurrentCamera)
end

local function createAcrylic()
	local Part = Creator.New("Part", {
		Name = "Body",
		Color = Color3.new(0, 0, 0),
		Material = Enum.Material.Glass,
		Size = Vector3.new(1, 1, 0),
		Anchored = true,
		CanCollide = false,
		Locked = true,
		CastShadow = false,
		Transparency = 0.98,
	}, {
		Creator.New("SpecialMesh", {
			Name = "Mesh",
			MeshType = Enum.MeshType.Brick,
			Offset = Vector3.new(0, 0, -0.000001),
		}),
	})

	return Part
end

function AcrylicBlur()
	local function createAcrylicBlur(distance)
		local cleanups = {}

		distance = distance or 0.001
		local positions = {
			topLeft = Vector2.new(),
			topRight = Vector2.new(),
			bottomRight = Vector2.new(),
		}
		local model = createAcrylic()
		model.Parent = BlurFolder

		local function updatePositions(size, position)
			positions.topLeft = position
			positions.topRight = position + Vector2.new(size.X, 0)
			positions.bottomRight = position + size
		end

		local function render()
			local res = game:GetService("Workspace").CurrentCamera
			if res then
				res = res.CFrame
			end
			local cond = res
			if not cond then
				cond = CFrame.new()
			end

			local camera = cond
			local topLeft = positions.topLeft
			local topRight = positions.topRight
			local bottomRight = positions.bottomRight

			local topLeft3D = viewportPointToWorld(topLeft, distance)
			local topRight3D = viewportPointToWorld(topRight, distance)
			local bottomRight3D = viewportPointToWorld(bottomRight, distance)

			local width = (topRight3D - topLeft3D).Magnitude
			local height = (topRight3D - bottomRight3D).Magnitude

			model.CFrame = CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, camera.XVector, camera.YVector, camera.ZVector)
			model.Mesh.Scale = Vector3.new(width, height, 0)
		end

		local function onChange(rbx)
			local offset = getOffset()
			local size = rbx.AbsoluteSize - Vector2.new(offset, offset)
			local position = rbx.AbsolutePosition + Vector2.new(offset / 2, offset / 2)

			updatePositions(size, position)
			task.spawn(render)
		end

		local function renderOnChange()
			local camera = game:GetService("Workspace").CurrentCamera
			if not camera then
				return
			end
			table.insert(cleanups, camera:GetPropertyChangedSignal("CFrame"):Connect(render))
			table.insert(cleanups, camera:GetPropertyChangedSignal("ViewportSize"):Connect(render))
			table.insert(cleanups, camera:GetPropertyChangedSignal("FieldOfView"):Connect(render))
			task.spawn(render)
		end

		model.Destroying:Connect(function()
			for _, item in cleanups do
				pcall(function()
					item:Disconnect()
				end)
			end
		end)

		renderOnChange()

		return onChange, model
	end

	return function(distance)
		local Blur = {}
		local onChange, model = createAcrylicBlur(distance)

		local comp = Creator.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		})

		Creator.AddSignal(comp:GetPropertyChangedSignal("AbsolutePosition"), function()
			onChange(comp)
		end)

		Creator.AddSignal(comp:GetPropertyChangedSignal("AbsoluteSize"), function()
			onChange(comp)
		end)

		Blur.AddParent = function(Parent)
			Creator.AddSignal(Parent:GetPropertyChangedSignal("Visible"), function()
				Blur.SetVisibility(Parent.Visible)
			end)
		end

		Blur.SetVisibility = function(Value)
			model.Transparency = Value and 0.98 or 1
		end

		Blur.Frame = comp
		Blur.Model = model

		return Blur
	end
end

function AcrylicPaint()
	local New = Creator.New
	local AcrylicBlur = AcrylicBlur()

	return function(props)
		local AcrylicPaint = {}

		AcrylicPaint.Frame = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0.9,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
		}, {
			New("ImageLabel", {
				Image = "rbxassetid://8992230677",
				ScaleType = "Slice",
				SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 120, 1, 116),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				ImageTransparency = 0.7,
			}),

			New("UICorner", {
				CornerRadius = UDim.new(0, 12),
			}),

			New("Frame", {
				BackgroundTransparency = 0.45,
				Size = UDim2.fromScale(1, 1),
				Name = "Background",
				ThemeTag = {
					BackgroundColor3 = "AcrylicMain",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 12),
				}),
			}),

			New("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.4,
				Size = UDim2.fromScale(1, 1),
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 12),
				}),

				New("UIGradient", {
					Rotation = 90,
					ThemeTag = {
						Color = "AcrylicGradient",
					},
				}),
			}),

			New("ImageLabel", {
				Image = "rbxassetid://9968344105",
				ImageTransparency = 0.98,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, 128, 0, 128),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 12),
				}),
			}),

			New("ImageLabel", {
				Image = "rbxassetid://9968344227",
				ImageTransparency = 0.9,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, 128, 0, 128),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ThemeTag = {
					ImageTransparency = "AcrylicNoise",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 12),
				}),
			}),

			New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 12),
				}),
				New("UIStroke", {
					Transparency = 0.45,
					Thickness = 1,
					ThemeTag = {
						Color = "AcrylicBorder",
					},
				}),
			}),
		})

		local Blur

		if Library.UseAcrylic then
			Blur = AcrylicBlur()
			Blur.Frame.Parent = AcrylicPaint.Frame
			AcrylicPaint.Model = Blur.Model
			AcrylicPaint.AddParent = Blur.AddParent
			AcrylicPaint.SetVisibility = Blur.SetVisibility
		end

		return AcrylicPaint
	end
end

local Acrylic = {
	AcrylicBlur = AcrylicBlur(),
	CreateAcrylic = createAcrylic,
	AcrylicPaint = AcrylicPaint(),
}

function Acrylic.init()
	local baseEffect = Instance.new("DepthOfFieldEffect")
	baseEffect.FarIntensity = 0
	baseEffect.InFocusRadius = 0.1
	baseEffect.NearIntensity = 1

	local depthOfFieldDefaults = {}

	function Acrylic.Enable()
		for _, effect in pairs(depthOfFieldDefaults) do
			effect.Enabled = false
		end
		baseEffect.Parent = game:GetService("Lighting")
	end

	function Acrylic.Disable()
		for _, effect in pairs(depthOfFieldDefaults) do
			effect.Enabled = effect.enabled
		end
		baseEffect.Parent = nil
	end

	local function registerDefaults()
		local function register(object)
			if object:IsA("DepthOfFieldEffect") then
				depthOfFieldDefaults[object] = { enabled = object.Enabled }
			end
		end

		for _, child in pairs(game:GetService("Lighting"):GetChildren()) do
			register(child)
		end

		if game:GetService("Workspace").CurrentCamera then
			for _, child in pairs(game:GetService("Workspace").CurrentCamera:GetChildren()) do
				register(child)
			end
		end
	end

	registerDefaults()
	Acrylic.Enable()
end

local Components = {
	Assets = {
		Close = "rbxassetid://9886659671",
		Min = "rbxassetid://9886659276",
		Max = "rbxassetid://9886659406",
		Restore = "rbxassetid://9886659001",
	},
}

Components.Element = (function()
	local New = Creator.New

	local Spring = Flipper.Spring.new

	return function(Title, Desc, Parent, Hover, Options)
		local Element = {}
		local Options = Options or {}

		Element.TitleLabel = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			Text = Title,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Element.Header = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 5),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		})

		if Options and Options.Icon then
			local iconImage = Options.Icon
			pcall(function()
				if Library and Library.GetIcon then
					local resolved = Library:GetIcon(Options.Icon)
					if resolved then iconImage = resolved end
				end
			end)
			Element.IconImage = New("ImageLabel", {
				Image = iconImage,
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			})
			Element.IconImage.Parent = Element.Header
		end

		Element.TitleLabel.Parent = Element.Header

		Element.DescLabel = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
			Text = Desc,
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 13,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		Element.LabelHolder = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -28, 0, 0),
		}, {
			New("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 13),
				PaddingTop = UDim.new(0, 13),
			}),
			Element.Header,
			Element.DescLabel,
		})

		Element.Border = New("UIStroke", {
			Transparency = 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(0, 0, 0),
			ThemeTag = {
				Color = "ElementBorder",
			},
		})

		Element.Frame = New("TextButton", {
			Visible = Options.Visible and Options.Visible or true,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 0.89,
			BackgroundColor3 = Color3.fromRGB(130, 130, 130),
			Parent = Parent,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = "",
			LayoutOrder = 7,
			ThemeTag = {
				BackgroundColor3 = "Element",
				BackgroundTransparency = "ElementTransparency",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 9),
			}),
			Element.Border,
			Element.LabelHolder,
		})

		function Element:SetTitle(Set)
			Element.TitleLabel.Text = Set
			local hasTitle = (Set ~= nil and Set ~= "")
			Element.Header.Visible = hasTitle

			if not hasTitle then
				if Element.IconImage then
					if not Element.DescRow then
						Element.DescRow = New("Frame", {
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 14),
							LayoutOrder = 2,
						}, {
							New("UIListLayout", {
								Padding = UDim.new(0, 5),
								FillDirection = Enum.FillDirection.Horizontal,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							}),
						})
						Element.DescRow.Parent = Element.LabelHolder
					end

					if not Element.DescIconImage then
						Element.DescIconImage = New("ImageLabel", {
							Image = Element.IconImage.Image,
							Size = UDim2.fromOffset(16, 16),
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							ThemeTag = {
								ImageColor3 = "Text",
							},
						})
						Element.DescIconImage.Parent = Element.DescRow
					else
						Element.DescIconImage.Image = Element.IconImage.Image
						Element.DescIconImage.Parent = Element.DescRow
					end

					Element.DescLabel.Parent = Element.DescRow
					Element.DescLabel.LayoutOrder = 2
					Element.DescLabel.Size = UDim2.new(1, -24, 0, 14)
				else
					if Element.DescRow then
						Element.DescRow:Destroy()
						Element.DescRow = nil
						Element.DescIconImage = nil
					end
					Element.DescLabel.Parent = Element.LabelHolder
					Element.DescLabel.LayoutOrder = 2
					Element.DescLabel.Size = UDim2.new(1, 0, 0, 14)
				end
			else
				if Element.DescRow then
					Element.DescRow:Destroy()
					Element.DescRow = nil
					Element.DescIconImage = nil
				end
				Element.DescLabel.Parent = Element.LabelHolder
				Element.DescLabel.LayoutOrder = 2
				Element.DescLabel.Size = UDim2.new(1, 0, 0, 14)
			end
			if Library.Window and Library.Window.AllElements and Library.Window.AllElements[Element.Frame] then
				Library.Window.AllElements[Element.Frame].title = Set
			elseif Library.Windows and #Library.Windows > 0 then
				local currentWindow = Library.Windows[#Library.Windows]
				if currentWindow and currentWindow.AllElements and currentWindow.AllElements[Element.Frame] then
					currentWindow.AllElements[Element.Frame].title = Set
				end
			end
		end

		function Element:Visible(Bool)
			Element.Frame.Visible = Bool
		end

		function Element:SetDesc(Set)
			if Set == nil then
				Set = ""
			end
			if Set == "" then
				Element.DescLabel.Visible = false
			else
				Element.DescLabel.Visible = true
			end
			Element.DescLabel.Text = Set
			if Library.Window and Library.Window.AllElements and Library.Window.AllElements[Element.Frame] then
				Library.Window.AllElements[Element.Frame].description = Set
			elseif Library.Windows and #Library.Windows > 0 then
				local currentWindow = Library.Windows[#Library.Windows]
				if currentWindow and currentWindow.AllElements and currentWindow.AllElements[Element.Frame] then
					currentWindow.AllElements[Element.Frame].description = Set
				end
			end
		end

		function Element:GetTitle()
			return Element.TitleLabel.Text
		end

		function Element:GetDesc()
			return Element.DescLabel.Text
		end

		function Element:Destroy()
			Element.Frame:Destroy()
		end

		Element.Header.Visible = not (Title == nil or Title == "")

		Element:SetTitle(Title or "")
		Element:SetDesc(Desc)

		if Library.Window and Library.Window.RegisterElement then
			Library.Window.RegisterElement(Element.Frame, Title, "Element", Desc)
		elseif Library.Windows and #Library.Windows > 0 then
			local currentWindow = Library.Windows[#Library.Windows]
			if currentWindow and currentWindow.RegisterElement then
				currentWindow.RegisterElement(Element.Frame, Title, "Element", Desc)
			end
		end

		if Hover then
			local Themes = Library.Themes
			local Motor, SetTransparency = Creator.SpringMotor(
				Creator.GetThemeProperty("ElementTransparency"),
				Element.Frame,
				"BackgroundTransparency",
				false,
				true
			)

			Creator.AddSignal(Element.Frame.MouseEnter, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
			end)
			Creator.AddSignal(Element.Frame.MouseLeave, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
			end)
			Creator.AddSignal(Element.Frame.MouseButton1Down, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency") + Creator.GetThemeProperty("HoverChange"))
			end)
			Creator.AddSignal(Element.Frame.MouseButton1Up, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
			end)
		end

		return Element
	end
end)()
Components.Section = (function()
	local New = Creator.New

	return function(Title, Parent, Icon)
		local Section = {}

		-- padding รอบ elements ข้างใน card
		local CARD_PAD_H  = 8   -- padding ซ้ายขวาภายใน card
		local CARD_PAD_V  = 6   -- padding บนล่างภายใน card
		local HEADER_H    = 28  -- ความสูง header row
		local GAP_TOP     = 6   -- ระยะห่างระหว่าง section card กับของข้างบน

		Section.Layout = New("UIListLayout", {
			Padding = UDim.new(0, 4),
		})

		-- Container ที่อยู่ใน card (มี padding)
		Section.Container = New("Frame", {
			Size = UDim2.new(1, -(CARD_PAD_H * 2), 0, 0),
			Position = UDim2.fromOffset(CARD_PAD_H, HEADER_H + CARD_PAD_V),
			BackgroundTransparency = 1,
		}, {
			Section.Layout,
		})

		-- accent bar ซ้ายของ header
		local AccentLine = New("Frame", {
			Size = UDim2.new(0, 3, 0, 14),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundTransparency = 0,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		-- header row
		local SectionHeader = New("Frame", {
			Size = UDim2.new(1, 0, 0, HEADER_H),
			Position = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 7),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
			}),
			AccentLine,
			Icon and New("ImageLabel", {
				Image = Icon,
				Size = UDim2.fromOffset(14, 14),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				ThemeTag = { ImageColor3 = "SubText" },
			}) or nil,
			New("TextLabel", {
				RichText = true,
				Text = Title,
				TextTransparency = 0,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				TextSize = 13,
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				Size = UDim2.fromScale(0, 1),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				ThemeTag = { TextColor3 = "Text" },
			}),
		})

		-- เส้นขีดคั่น header กับ content
		local HeaderDivider = New("Frame", {
			Size = UDim2.new(1, -16, 0, 1),
			Position = UDim2.new(0, 8, 0, HEADER_H),
			BackgroundTransparency = 0.7,
			ThemeTag = { BackgroundColor3 = "InElementBorder" },
		})

		-- Card wrapper — มีขอบ + bg จาง ๆ
		local CardFrame = New("Frame", {
			BackgroundTransparency = 0.93,
			Size = UDim2.new(1, 0, 0, HEADER_H + CARD_PAD_V),
			LayoutOrder = 7,
			Parent = Parent,
			ThemeTag = { BackgroundColor3 = "Element" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 10) }),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 0.55,
				Thickness = 1,
				ThemeTag = { Color = "InElementBorder" },
			}),
			SectionHeader,
			HeaderDivider,
			Section.Container,
		})

		-- gap ด้านบนของแต่ละ section card
		Section.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, HEADER_H + CARD_PAD_V + GAP_TOP),
			LayoutOrder = 7,
			Parent = Parent,
		}, {
			New("UIPadding", {
				PaddingTop = UDim.new(0, GAP_TOP),
			}),
			CardFrame,
		})

		-- Section.Root ชี้ไปที่ CardFrame เพื่อให้ layout คำนวณถูก
		Section._CardFrame = CardFrame

		Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			local contentH = Section.Layout.AbsoluteContentSize.Y
			Section.Container.Size = UDim2.new(1, -(CARD_PAD_H * 2), 0, contentH)
			local totalCardH = HEADER_H + CARD_PAD_V + contentH + CARD_PAD_V
			CardFrame.Size = UDim2.new(1, 0, 0, totalCardH)
			Section.Root.Size = UDim2.new(1, 0, 0, totalCardH + GAP_TOP)
		end)

		if Library.Window and Library.Window.RegisterElement then
			Library.Window.RegisterElement(Section.Root, Title, "Section")
		elseif Library.Windows and #Library.Windows > 0 then
			local currentWindow = Library.Windows[#Library.Windows]
			if currentWindow and currentWindow.RegisterElement then
				currentWindow.RegisterElement(Section.Root, Title, "Section")
			end
		end

		return Section
	end
end)()
Components.Tab = (function()
	local New = Creator.New
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local Components = Components

	local TabModule = {
		Window = nil,
		Tabs = {},
		Containers = {},
		SelectedTab = 0,
		TabCount = 0,
		AnimationTask = nil,
		CurrentAnimationTab = 0,
	}

	function TabModule:Init(Window)
		TabModule.Window = Window
		return TabModule
	end

	function TabModule:GetCurrentTabPos()
		local TabHolderPos = TabModule.Window.TabHolder.AbsolutePosition.Y
		local TabPos = TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y

		return TabPos - TabHolderPos
	end

	function TabModule:New(Title, Icon, Parent)
		local Window = TabModule.Window
		local Elements = Library.Elements

		TabModule.TabCount = TabModule.TabCount + 1
		local TabIndex = TabModule.TabCount

		local Tab = {
			Selected = false,
			Name = Title,
			Type = "Tab",
		}

		if not fischbypass then 
			if Library:GetIcon(Icon) then
				Icon = Library:GetIcon(Icon)
			end

			if Icon == "" or nil then
				Icon = nil
			end
		end

		Tab.Frame = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundTransparency = 0.92,
			Parent = Parent,
			ZIndex = 10,
			ThemeTag = {
				BackgroundColor3 = "Tab",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("TextLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = not fischbypass and Icon and UDim2.new(0, 32, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
				Text = Title,
				RichText = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Medium,
					Enum.FontStyle.Normal
				),
				TextSize = 12,
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				Size = UDim2.new(1, -12, 1, 0),
				BackgroundTransparency = 1,
				ZIndex = 11,
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
			New("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(0, 9, 0.5, 0),
				BackgroundTransparency = 1,
				Image = Icon and Icon or nil,
				ZIndex = 11,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			}),
		})

		local ContainerLayout = New("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Tab.ContainerAnim = New("CanvasGroup", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Parent = Window.ContainerHolder,
			Visible = false,
			Position = UDim2.fromOffset(0, 0),
		})

		Tab.ContainerFrame = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Parent = Tab.ContainerAnim,
			Visible = true,
			BottomImage = "rbxassetid://6889812791",
			MidImage = "rbxassetid://6889812721",
			TopImage = "rbxassetid://6276641225",
			ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
			ScrollBarImageTransparency = 0.95,
			ScrollBarThickness = 3,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = true,
		}, {
			ContainerLayout,
			New("UIPadding", {
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 1),
				PaddingTop = UDim.new(0, 1),
				PaddingBottom = UDim.new(0, 1),
			}),
		})

		Tab.ContainerXMotor = Flipper.SingleMotor.new(0)
		Tab.ContainerTransparencyMotor = Flipper.SingleMotor.new(0)

		Tab.ContainerXMotor:onStep(function(Value)
			if Tab.ContainerAnim and Tab.ContainerAnim.Parent then
				Tab.ContainerAnim.Position = UDim2.fromOffset(Value, 0)
			end
		end)

		Tab.ContainerTransparencyMotor:onStep(function(Value)
			if Tab.ContainerAnim and Tab.ContainerAnim.Parent then
				Tab.ContainerAnim.GroupTransparency = Value
			end
		end)

		Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
		end)

		Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(0.92, Tab.Frame, "BackgroundTransparency")

		Creator.AddSignal(Tab.Frame.MouseEnter, function()
			Tab.SetTransparency(Tab.Selected and 0.85 or 0.87)
		end)
		Creator.AddSignal(Tab.Frame.MouseLeave, function()
			Tab.SetTransparency(Tab.Selected and 0.89 or 0.92)
		end)
		Creator.AddSignal(Tab.Frame.MouseButton1Down, function()
			Tab.SetTransparency(0.92)
		end)
		Creator.AddSignal(Tab.Frame.MouseButton1Up, function()
			Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
		end)
		Creator.AddSignal(Tab.Frame.MouseButton1Click, function()
			TabModule:SelectTab(TabIndex)
		end)

		TabModule.Containers[TabIndex] = Tab.ContainerAnim
		TabModule.Tabs[TabIndex] = Tab

		Tab.Container = Tab.ContainerFrame
		Tab.ScrollFrame = Tab.Container

		Tab.SubTabs = {}
		Tab.SubTabContainers = {}
		Tab.SelectedSubTab = 0
		Tab.SubTabCount = 0
		Tab.SubTabHolder = nil

		function Tab:AddSubTab(Title, Icon)
			self.SubTabCount = self.SubTabCount + 1
			local SubTabIndex = self.SubTabCount

			if not self.SubTabHolder then
				local SubTabListLayout = New("UIListLayout", {
					Padding = UDim.new(0, 6),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				})

				self.SubTabHolder = New("ScrollingFrame", {
					Size = UDim2.new(1, -20, 0, 40),
					Position = UDim2.fromOffset(1, 8),
					BackgroundTransparency = 1,
					Parent = self.ContainerFrame,
					ScrollingDirection = Enum.ScrollingDirection.X,
					ScrollBarThickness = 0,
					ScrollBarImageTransparency = 1,
					ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
					CanvasSize = UDim2.fromScale(0, 1),
					BorderSizePixel = 0,
				}, {
					SubTabListLayout,
					New("UIPadding", {
						PaddingLeft = UDim.new(0, 0),
						PaddingRight = UDim.new(0, 0),
						PaddingTop = UDim.new(0, 0),
						PaddingBottom = UDim.new(0, 0),
					}),
				})

				Creator.AddSignal(SubTabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					self.SubTabHolder.CanvasSize = UDim2.new(0, SubTabListLayout.AbsoluteContentSize.X, 0, 40)
				end)

				local SubTabContainerHolder = New("Frame", {
					Size = UDim2.new(1, -11, 1, -56),
					Position = UDim2.fromOffset(1, 48),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Parent = self.ContainerFrame,
				})

				self.SubTabContainerHolder = SubTabContainerHolder
			end

			local SubTabIcon = Icon
			if not fischbypass then 
				if Library:GetIcon(Icon) then
					SubTabIcon = Library:GetIcon(Icon)
				end

				if SubTabIcon == "" or nil then
					SubTabIcon = nil
				end
			end

			local SubTabButton = New("TextButton", {
				Size = UDim2.new(0, 0, 0, 32),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 0.92,
				Parent = self.SubTabHolder,
				Text = "",
				ThemeTag = {
					BackgroundColor3 = "Tab",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				New("UIStroke", {
					Transparency = 1,
					Thickness = 1,
					ThemeTag = {
						Color = "Accent",
					},
				}),
				New("UIListLayout", {
					Padding = UDim.new(0, 6),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
					PaddingTop = UDim.new(0, 6),
					PaddingBottom = UDim.new(0, 6),
				}),
				SubTabIcon and New("ImageLabel", {
					Size = UDim2.fromOffset(16, 16),
					BackgroundTransparency = 1,
					Image = SubTabIcon,
					LayoutOrder = 1,
					ThemeTag = {
						ImageColor3 = "Text",
					},
				}) or nil,
				New("TextLabel", {
					Text = Title,
					RichText = true,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextTransparency = 0,
					FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					TextSize = 12,
					TextXAlignment = "Left",
					TextYAlignment = "Center",
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					ThemeTag = {
						TextColor3 = "Text",
					},
				}),
			})

			local SubTabContainerAnim = New("CanvasGroup", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				GroupTransparency = 0,
				Parent = self.SubTabContainerHolder,
				Visible = false,
				Position = UDim2.fromOffset(0, 0),
			})

			local SubTabContainer = New("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Parent = SubTabContainerAnim,
				Visible = true,
				BottomImage = "rbxassetid://6889812791",
				MidImage = "rbxassetid://6889812721",
				TopImage = "rbxassetid://6276641225",
				ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
				ScrollBarImageTransparency = 0.95,
				ScrollBarThickness = 3,
				BorderSizePixel = 0,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = true,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				New("UIPadding", {
					PaddingRight = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 1),
					PaddingTop = UDim.new(0, 1),
					PaddingBottom = UDim.new(0, 1),
				}),
			})

			local SubTabLayout = SubTabContainer:FindFirstChild("UIListLayout")
			Creator.AddSignal(SubTabLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				SubTabContainer.CanvasSize = UDim2.new(0, 0, 0, SubTabLayout.AbsoluteContentSize.Y + 2)
			end)

			local SubTabXMotor = Flipper.SingleMotor.new(0)
			local SubTabTransparencyMotor = Flipper.SingleMotor.new(0)

			SubTabXMotor:onStep(function(Value)
				if SubTabContainerAnim and SubTabContainerAnim.Parent then
					SubTabContainerAnim.Position = UDim2.fromOffset(Value, 0)
				end
			end)

			SubTabTransparencyMotor:onStep(function(Value)
				if SubTabContainerAnim and SubTabContainerAnim.Parent then
					SubTabContainerAnim.GroupTransparency = Value
				end
			end)

			local SubTabMotor, SubTabSetTransparency = Creator.SpringMotor(0.92, SubTabButton, "BackgroundTransparency")
			local SubTabStroke = SubTabButton:FindFirstChild("UIStroke")

			local function UpdateSubTabAppearance()
				if self.SelectedSubTab == SubTabIndex then
					SubTabSetTransparency(0.75)
					if SubTabStroke then
						SubTabStroke.Transparency = 0
					end
				else
					SubTabSetTransparency(0.92)
					if SubTabStroke then
						SubTabStroke.Transparency = 1
					end
				end
			end

			Creator.AddSignal(SubTabButton.MouseEnter, function()
				if self.SelectedSubTab ~= SubTabIndex then
					SubTabSetTransparency(0.87)
				end
			end)

			Creator.AddSignal(SubTabButton.MouseLeave, function()
				UpdateSubTabAppearance()
			end)

			Creator.AddSignal(SubTabButton.MouseButton1Down, function()
				SubTabSetTransparency(0.92)
			end)

			Creator.AddSignal(SubTabButton.MouseButton1Up, function()
				UpdateSubTabAppearance()
			end)

			UpdateSubTabAppearance()

			Creator.AddSignal(SubTabButton.MouseButton1Click, function()
				self:SelectSubTab(SubTabIndex)
			end)

			local SubTab = {
				Type = "SubTab",
				Name = Title,
				Button = SubTabButton,
				Container = SubTabContainer,
				ContainerAnim = SubTabContainerAnim,
				XMotor = SubTabXMotor,
				TransparencyMotor = SubTabTransparencyMotor,
				SetTransparency = SubTabSetTransparency,
				Selected = false,
			}

			self.SubTabs[SubTabIndex] = SubTab
			self.SubTabContainers[SubTabIndex] = SubTabContainerAnim

			if self.SubTabCount == 1 then
				self:SelectSubTab(SubTabIndex)
			end

			function SubTab:AddSection(SectionTitle, SectionIcon)
				local Section = { Type = "Section" }

				local Icon = SectionIcon
				if not fischbypass then 
					if Library:GetIcon(Icon) then
						Icon = Library:GetIcon(Icon)
					end

					if Icon == "" or nil then
						Icon = nil
					end
				end

				local SectionFrame = Components.Section(SectionTitle, SubTab.Container, Icon)
				Section.Container = SectionFrame.Container
				Section.ScrollFrame = SubTab.Container

				setmetatable(Section, Elements)
				return Section
			end

			setmetatable(SubTab, Elements)
			return SubTab
		end

		function Tab:SelectSubTab(SubTabIndex)
			if self.SelectedSubTab == SubTabIndex then
				return
			end

			local PreviousSubTab = self.SelectedSubTab
			local Direction = (PreviousSubTab > 0 and SubTabIndex > PreviousSubTab) and 1 or -1
			if PreviousSubTab == 0 then
				Direction = 0
			end

			local ContainerSize = self.SubTabContainerHolder and self.SubTabContainerHolder.AbsoluteSize.X or 500
			local SlideDistance = math.min(ContainerSize * 0.15, 60)

			self.SelectedSubTab = SubTabIndex

			for idx, SubTabObj in next, self.SubTabs do
				SubTabObj.Selected = (idx == SubTabIndex)
				local SubTabStroke = SubTabObj.Button:FindFirstChild("UIStroke")
				if idx == SubTabIndex then
					SubTabObj.SetTransparency(0.75)
					if SubTabStroke then
						SubTabStroke.Transparency = 0
					end
				else
					SubTabObj.SetTransparency(0.92)
					if SubTabStroke then
						SubTabStroke.Transparency = 1
					end
				end
			end

			if PreviousSubTab > 0 and PreviousSubTab ~= SubTabIndex and self.SubTabs[PreviousSubTab] and self.SubTabs[SubTabIndex] then
				local OldContainer = self.SubTabs[PreviousSubTab].ContainerAnim
				local NewContainer = self.SubTabs[SubTabIndex].ContainerAnim
				local OldSubTab = self.SubTabs[PreviousSubTab]
				local NewSubTab = self.SubTabs[SubTabIndex]

				for idx, Container in next, self.SubTabContainers do
					if Container and idx ~= PreviousSubTab and idx ~= SubTabIndex then
						Container.Visible = false
						Container.Position = UDim2.fromOffset(0, 0)
						Container.GroupTransparency = 0
						if self.SubTabs[idx] then
							pcall(function()
								self.SubTabs[idx].XMotor:setGoal(Instant(0))
								self.SubTabs[idx].TransparencyMotor:setGoal(Instant(0))
							end)
						end
					end
				end

				OldContainer.Visible = true
				OldContainer.Position = UDim2.fromOffset(0, 0)
				OldContainer.GroupTransparency = 0
				pcall(function()
					OldSubTab.XMotor:setGoal(Instant(0))
					OldSubTab.TransparencyMotor:setGoal(Instant(0))
				end)

				NewContainer.Visible = true
				NewContainer.Position = UDim2.fromOffset(Direction * SlideDistance, 0)
				NewContainer.GroupTransparency = 1
				pcall(function()
					NewSubTab.XMotor:setGoal(Instant(Direction * SlideDistance))
					NewSubTab.TransparencyMotor:setGoal(Instant(1))
				end)

				task.wait()

				pcall(function()
					OldSubTab.XMotor:setGoal(Spring(-Direction * SlideDistance, { frequency = 4, dampingRatio = 0.7 }))
					OldSubTab.TransparencyMotor:setGoal(Spring(1, { frequency = 4, dampingRatio = 0.7 }))
				end)

				pcall(function()
					NewSubTab.XMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
					NewSubTab.TransparencyMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
				end)

				task.spawn(function()
					task.wait(0.5)
					if self.SelectedSubTab == SubTabIndex and self.SubTabs[PreviousSubTab] then
						local OldContainer = self.SubTabs[PreviousSubTab].ContainerAnim
						local OldSubTab = self.SubTabs[PreviousSubTab]
						if OldContainer and OldContainer.Parent then
							OldContainer.Visible = false
							OldContainer.Position = UDim2.fromOffset(0, 0)
							OldContainer.GroupTransparency = 0
						end
						if OldSubTab and OldSubTab.XMotor and OldSubTab.TransparencyMotor then
							pcall(function()
								OldSubTab.XMotor:setGoal(Instant(0))
								OldSubTab.TransparencyMotor:setGoal(Instant(0))
							end)
						end
					end
				end)
			else
				for idx, Container in next, self.SubTabContainers do
					if Container then
						Container.Visible = (idx == SubTabIndex)
						Container.Position = UDim2.fromOffset(0, 0)
						Container.GroupTransparency = 0
						if self.SubTabs[idx] then
							pcall(function()
								self.SubTabs[idx].XMotor:setGoal(Instant(0))
								self.SubTabs[idx].TransparencyMotor:setGoal(Instant(0))
							end)
						end
					end
				end
			end
		end

		function Tab:AddSection(SectionTitle, SectionIcon)
			if self.SelectedSubTab > 0 and self.SubTabs[self.SelectedSubTab] then
				return self.SubTabs[self.SelectedSubTab]:AddSection(SectionTitle, SectionIcon)
			end

			local Section = { Type = "Section" }

			local Icon = SectionIcon
			if not fischbypass then 
				if Library:GetIcon(Icon) then
					Icon = Library:GetIcon(Icon)
				end

				if Icon == "" or nil then
					Icon = nil
				end
			end

			local SectionFrame = Components.Section(SectionTitle, Tab.Container, Icon)
			Section.Container = SectionFrame.Container
			Section.ScrollFrame = Tab.Container

			setmetatable(Section, Elements)
			return Section
		end

		setmetatable(Tab, Elements)
		return Tab
	end

	function TabModule:SelectTab(Tab)
		if TabModule.SelectedTab == Tab then
			return
		end
		
		if TabModule.AnimationTask then
			task.cancel(TabModule.AnimationTask)
			TabModule.AnimationTask = nil
		end

		local Window = TabModule.Window
		local PreviousTab = TabModule.SelectedTab
		
		local Direction = (PreviousTab > 0 and Tab > PreviousTab) and 1 or -1
		if PreviousTab == 0 then
			Direction = 0
		end
		
		local ContainerSize = Window.ContainerHolder and Window.ContainerHolder.AbsoluteSize.X or (Window.ContainerCanvas and Window.ContainerCanvas.AbsoluteSize.X or 500)
		local SlideDistance = math.min(ContainerSize * 0.15, 60)

		TabModule.SelectedTab = Tab
		TabModule.CurrentAnimationTab = Tab

		for _, TabObject in next, TabModule.Tabs do
			TabObject.SetTransparency(0.92)
			TabObject.Selected = false
		end
		TabModule.Tabs[Tab].SetTransparency(0.89)
		TabModule.Tabs[Tab].Selected = true

		Window.TabDisplay.Text = TabModule.Tabs[Tab].Name
		Window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), { frequency = 6 }))

		if PreviousTab > 0 and PreviousTab ~= Tab and TabModule.Tabs[PreviousTab] and TabModule.Tabs[Tab] then
			local OldContainer = TabModule.Tabs[PreviousTab].ContainerAnim
			local NewContainer = TabModule.Tabs[Tab].ContainerAnim
			local OldTab = TabModule.Tabs[PreviousTab]
			local NewTab = TabModule.Tabs[Tab]

			if not OldContainer or not NewContainer or not OldTab.ContainerXMotor or not OldTab.ContainerTransparencyMotor or not NewTab.ContainerXMotor or not NewTab.ContainerTransparencyMotor then
				for idx, Container in next, TabModule.Containers do
					if Container then
						Container.Visible = (idx == Tab)
						Container.Position = UDim2.fromOffset(0, 0)
						Container.GroupTransparency = 0
					end
				end
				return
			end

			for idx, Container in next, TabModule.Containers do
				if Container and idx ~= PreviousTab and idx ~= Tab then
					Container.Visible = false
					Container.Position = UDim2.fromOffset(0, 0)
					Container.GroupTransparency = 0
					if TabModule.Tabs[idx] and TabModule.Tabs[idx].ContainerXMotor and TabModule.Tabs[idx].ContainerTransparencyMotor then
						pcall(function()
							TabModule.Tabs[idx].ContainerXMotor:setGoal(Instant(0))
							TabModule.Tabs[idx].ContainerTransparencyMotor:setGoal(Instant(0))
						end)
					end
				end
			end

			OldContainer.Visible = true
			OldContainer.Position = UDim2.fromOffset(0, 0)
			OldContainer.GroupTransparency = 0
			pcall(function()
				OldTab.ContainerXMotor:setGoal(Instant(0))
				OldTab.ContainerTransparencyMotor:setGoal(Instant(0))
			end)

			NewContainer.Visible = true
			NewContainer.Position = UDim2.fromOffset(Direction * SlideDistance, 0)
			NewContainer.GroupTransparency = 1
			pcall(function()
				NewTab.ContainerXMotor:setGoal(Instant(Direction * SlideDistance))
				NewTab.ContainerTransparencyMotor:setGoal(Instant(1))
			end)

			task.wait()

			pcall(function()
				OldTab.ContainerXMotor:setGoal(Spring(-Direction * SlideDistance, { frequency = 4, dampingRatio = 0.7 }))
				OldTab.ContainerTransparencyMotor:setGoal(Spring(1, { frequency = 4, dampingRatio = 0.7 }))
			end)

			pcall(function()
				NewTab.ContainerXMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
				NewTab.ContainerTransparencyMotor:setGoal(Spring(0, { frequency = 4, dampingRatio = 0.7 }))
			end)

			TabModule.AnimationTask = task.spawn(function()
				task.wait(0.5)
				if TabModule.CurrentAnimationTab == Tab and TabModule.Tabs[PreviousTab] then
					local OldContainer = TabModule.Tabs[PreviousTab].ContainerAnim
					local OldTab = TabModule.Tabs[PreviousTab]
					if OldContainer and OldContainer.Parent then
						OldContainer.Visible = false
						OldContainer.Position = UDim2.fromOffset(0, 0)
						OldContainer.GroupTransparency = 0
					end
					if OldTab and OldTab.ContainerXMotor and OldTab.ContainerTransparencyMotor then
						pcall(function()
							OldTab.ContainerXMotor:setGoal(Instant(0))
							OldTab.ContainerTransparencyMotor:setGoal(Instant(0))
						end)
					end
					TabModule.AnimationTask = nil
				end
			end)
		else
			for idx, Container in next, TabModule.Containers do
				if Container then
					Container.Visible = (idx == Tab)
					Container.Position = UDim2.fromOffset(0, 0)
					Container.GroupTransparency = 0
					if TabModule.Tabs[idx] and TabModule.Tabs[idx].ContainerXMotor and TabModule.Tabs[idx].ContainerTransparencyMotor then
						pcall(function()
							TabModule.Tabs[idx].ContainerXMotor:setGoal(Instant(0))
							TabModule.Tabs[idx].ContainerTransparencyMotor:setGoal(Instant(0))
						end)
					end
				end
			end
		end
	end

	return TabModule
end)()
Components.Button = (function()
	local New = Creator.New

	local Spring = Flipper.Spring.new

	return function(Theme, Parent, DialogCheck)
		DialogCheck = DialogCheck or false
		local Button = {}

		Button.Title = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 13,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Button.HoverFrame = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ThemeTag = {
				BackgroundColor3 = "Hover",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		})

		Button.Frame = New("TextButton", {
			Size = UDim2.new(0, 0, 0, 34),
			Parent = Parent,
			ThemeTag = {
				BackgroundColor3 = "DialogButton",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 0.55,
				ThemeTag = {
					Color = "DialogButtonBorder",
				},
			}),
			Button.HoverFrame,
			Button.Title,
		})
		local Motor, SetTransparency = Creator.SpringMotor(1, Button.HoverFrame, "BackgroundTransparency", DialogCheck)
		Creator.AddSignal(Button.Frame.MouseEnter, function()
			SetTransparency(0.97)
		end)
		Creator.AddSignal(Button.Frame.MouseLeave, function()
			SetTransparency(1)
		end)
		Creator.AddSignal(Button.Frame.MouseButton1Down, function()
			SetTransparency(1)
		end)
		Creator.AddSignal(Button.Frame.MouseButton1Up, function()
			SetTransparency(0.97)
		end)

		return Button
	end
end)()
Components.Dialog = (function()
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New = Creator.New

	local Dialog = {
		Window = nil,
	}

	function Dialog:Init(Window)
		Dialog.Window = Window
		return Dialog
	end

	function Dialog:Create()
		local NewDialog = {
			Buttons = 0,
		}

		NewDialog.TintFrame = New("TextButton", {
			Text = "",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			Parent = Dialog.Window.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		})

		local TintMotor, TintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true)

		NewDialog.ButtonHolder = New("Frame", {
			Size = UDim2.new(1, -40, 1, -40),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})

		NewDialog.ButtonHolderFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 70),
			Position = UDim2.new(0, 0, 1, -70),
			ThemeTag = {
				BackgroundColor3 = "DialogHolder",
			},
		}, {
			New("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				ThemeTag = {
					BackgroundColor3 = "DialogHolderLine",
				},
			}),
			NewDialog.ButtonHolder,
		})

		NewDialog.Title = New("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.SemiBold,
				Enum.FontStyle.Normal
			),
			Text = "Dialog",
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 22,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 22),
			Position = UDim2.fromOffset(20, 25),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		NewDialog.Scale = New("UIScale", {
			Scale = 1,
		})

		local ScaleMotor, Scale = Creator.SpringMotor(1.1, NewDialog.Scale, "Scale")

		NewDialog.Root = New("CanvasGroup", {
			Size = UDim2.fromOffset(300, 165),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			GroupTransparency = 1,
			Parent = NewDialog.TintFrame,
			ThemeTag = {
				BackgroundColor3 = "Dialog",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 12),
			}),
			New("UIStroke", {
				Transparency = 0.4,
				ThemeTag = {
					Color = "DialogBorder",
				},
			}),
			NewDialog.Scale,
			NewDialog.Title,
			NewDialog.ButtonHolderFrame,
		})

		local RootMotor, RootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency")

		function NewDialog:Open()
			Library.DialogOpen = true
			NewDialog.Scale.Scale = 1.1
			TintTransparency(0.75)
			RootTransparency(0)
			Scale(1)
		end

		function NewDialog:Close()
			Library.DialogOpen = false
			TintTransparency(1)
			RootTransparency(1)
			Scale(1.1)
			NewDialog.Root.UIStroke:Destroy()
			task.wait(0.15)
			NewDialog.TintFrame:Destroy()
		end

		function NewDialog:Button(Title, Callback)
			NewDialog.Buttons = NewDialog.Buttons + 1
			Title = Title or "Button"
			Callback = Callback or function() end

			local Button = Components.Button("", NewDialog.ButtonHolder, true)
			Button.Title.Text = Title

			for _, Btn in next, NewDialog.ButtonHolder:GetChildren() do
				if Btn:IsA("TextButton") then
					Btn.Size =
						UDim2.new(1 / NewDialog.Buttons, -(((NewDialog.Buttons - 1) * 10) / NewDialog.Buttons), 0, 32)
				end
			end

			Creator.AddSignal(Button.Frame.MouseButton1Click, function()
				Library:SafeCallback(Callback)
				pcall(function()
					NewDialog:Close()
				end)
			end)

			return Button
		end

		return NewDialog
	end

	return Dialog
end)()
Components.Notification = (function()
	local Spring  = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New     = Creator.New

	local TypeColors = {
		info    = Color3.fromRGB(96,  205, 255),  -- ฟ้า
		success = Color3.fromRGB(80,  220, 120),  -- เขียว
		warning = Color3.fromRGB(255, 200,  60),  -- เหลือง
		error   = Color3.fromRGB(255,  80,  80),  -- แดง
		default = Color3.fromRGB(160, 120, 255),  -- ม่วง (default)
	}

	local TypeIcons = {
		info    = "ℹ️",
		success = "✅",
		warning = "⚠️",
		error   = "❌",
		default = "🔔",
	}

	local Notification = {}

	function Notification:Init(GUI)
		Library.ActiveNotifications = Library.ActiveNotifications or {}

		-- Holder อยู่มุมล่างขวา
		Notification.Holder = New("Frame", {
			Position = UDim2.new(1, -20, 1, -20),
			Size     = UDim2.new(0, 320, 1, -20),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Parent   = GUI,
		}, {
			New("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder           = Enum.SortOrder.LayoutOrder,
				VerticalAlignment   = Enum.VerticalAlignment.Bottom,
				Padding             = UDim.new(0, 10),
			}),
		})
	end

	function Notification:New(Config)
		Config.Title      = Config.Title      or "Notification"
		Config.Content    = Config.Content    or ""
		Config.SubContent = Config.SubContent or ""
		Config.Duration   = Config.Duration   or nil
		-- Type: "info" | "success" | "warning" | "error" | "default"
		Config.Type       = Config.Type       or "default"

		local accentColor = TypeColors[Config.Type] or TypeColors.default
		local iconText    = Config.Icon or TypeIcons[Config.Type] or TypeIcons.default

		local NewNotification = { Closed = false }

		NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()

		local TypeBar = New("Frame", {
			Size             = UDim2.new(0, 3, 1, -16),
			Position         = UDim2.new(0, 8, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundColor3 = accentColor,
			BorderSizePixel  = 0,
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local IconLabel = New("TextLabel", {
			Text             = iconText,
			FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			TextSize         = 18,
			Size             = UDim2.fromOffset(28, 28),
			Position         = UDim2.new(0, 18, 0, 10),
			BackgroundTransparency = 1,
			TextXAlignment   = Enum.TextXAlignment.Center,
			TextYAlignment   = Enum.TextYAlignment.Center,
			RichText         = false,
		})

		NewNotification.Title = New("TextLabel", {
			Position         = UDim2.new(0, 52, 0, 10),
			Text             = Config.Title,
			RichText         = true,
			TextSize         = 13,
			TextXAlignment   = Enum.TextXAlignment.Left,
			TextYAlignment   = Enum.TextYAlignment.Center,
			Size             = UDim2.new(1, -80, 0, 16),
			TextWrapped      = true,
			BackgroundTransparency = 1,
			FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
			TextColor3       = accentColor,
		})

		NewNotification.ContentLabel = New("TextLabel", {
			FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text             = Config.Content,
			TextSize         = 12,
			TextXAlignment   = Enum.TextXAlignment.Left,
			AutomaticSize    = Enum.AutomaticSize.Y,
			Size             = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextWrapped      = true,
			ThemeTag         = { TextColor3 = "Text" },
		})

		NewNotification.SubContentLabel = New("TextLabel", {
			FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text             = Config.SubContent,
			TextSize         = 11,
			TextXAlignment   = Enum.TextXAlignment.Left,
			AutomaticSize    = Enum.AutomaticSize.Y,
			Size             = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextWrapped      = true,
			ThemeTag         = { TextColor3 = "SubText" },
		})

		NewNotification.LabelHolder = New("Frame", {
			AutomaticSize    = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position         = UDim2.new(0, 52, 0, 30),
			Size             = UDim2.new(1, -68, 0, 0),
		}, {
			New("UIListLayout", {
				SortOrder         = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding           = UDim.new(0, 2),
			}),
			NewNotification.ContentLabel,
			NewNotification.SubContentLabel,
		})

		NewNotification.CloseButton = New("TextButton", {
			Text             = "",
			Position         = UDim2.new(1, -10, 0, 10),
			Size             = UDim2.fromOffset(18, 18),
			AnchorPoint      = Vector2.new(1, 0),
			BackgroundTransparency = 0.75,
			BackgroundColor3 = Color3.fromRGB(60, 55, 80),
			BorderSizePixel  = 0,
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			New("ImageLabel", {
				Image       = "rbxassetid://9886659671",
				Size        = UDim2.fromOffset(10, 10),
				Position    = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(200, 190, 220),
			}),
		})

		local ProgressTrack = New("Frame", {
			Size             = UDim2.new(1, -16, 0, 2),
			Position         = UDim2.new(0, 8, 1, -6),
			BackgroundTransparency = 0.7,
			BorderSizePixel  = 0,
			ThemeTag         = { BackgroundColor3 = "Element" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local ProgressFill = New("Frame", {
			Size             = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = accentColor,
			BorderSizePixel  = 0,
			Parent           = ProgressTrack,
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		NewNotification.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, 0, 1, 0),
			Position         = UDim2.fromScale(1, 0),
		}, {
			NewNotification.AcrylicPaint.Frame,
			-- Background
			New("Frame", {
				Size             = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 0.90,
				BorderSizePixel  = 0,
				ThemeTag         = { BackgroundColor3 = "AcrylicMain" },
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 12) }),
			}),
			-- Border
			New("UIStroke", {
				Transparency     = 0.5,
				Thickness        = 1,
				ApplyStrokeMode  = Enum.ApplyStrokeMode.Border,
				Color            = accentColor,
			}),
			TypeBar,
			IconLabel,
			NewNotification.Title,
			NewNotification.CloseButton,
			NewNotification.LabelHolder,
			ProgressTrack,
		})

		-- ซ่อนถ้าไม่มีข้อความ
		if Config.Content    == "" then NewNotification.ContentLabel.Visible    = false end
		if Config.SubContent == "" then NewNotification.SubContentLabel.Visible = false end

		NewNotification.Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, 0, 0, 200),
			Parent           = Notification.Holder,
		}, {
			NewNotification.Root,
		})

		local RootMotor = Flipper.GroupMotor.new({ Scale = 1, Offset = 70 })
		RootMotor:onStep(function(v)
			NewNotification.Root.Position = UDim2.new(v.Scale, v.Offset, 0, 0)
		end)

		Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
			NewNotification:Close()
		end)

		function NewNotification:ApplyTransparency()
			if Library.Theme == "Glass" and Library.UseAcrylic then
				local Value = Library.NotificationTransparency or 1
				local t = math.min(0.85 + Value * 0.08, 0.97)
				local bt = math.min(0.8 + Value * 0.1, 0.95)
				if NewNotification.AcrylicPaint and NewNotification.AcrylicPaint.Model then
					NewNotification.AcrylicPaint.Model.Transparency = t
				end
				if NewNotification.AcrylicPaint and NewNotification.AcrylicPaint.Frame
					and NewNotification.AcrylicPaint.Frame.Background then
					NewNotification.AcrylicPaint.Frame.Background.BackgroundTransparency = bt
				end
			end
		end

		function NewNotification:Open()
			local contentH = NewNotification.LabelHolder.AbsoluteSize.Y
			local totalH   = math.max(56, 36 + contentH + 14) + 10
			NewNotification.Holder.Size = UDim2.new(1, 0, 0, totalH)

			RootMotor:setGoal({
				Scale  = Spring(0, { frequency = 6 }),
				Offset = Spring(0, { frequency = 6 }),
			})

			task.defer(function()
				task.wait(0.08)
				NewNotification:ApplyTransparency()
			end)

			-- Progress bar animation
			if Config.Duration and Config.Duration > 0 then
				local steps    = Config.Duration * 20
				local stepSize = 1 / steps
				task.spawn(function()
					for i = 1, steps do
						if NewNotification.Closed then break end
						local pct = 1 - (i * stepSize)
						TweenService:Create(ProgressFill,
							TweenInfo.new(1 / 20, Enum.EasingStyle.Linear),
							{ Size = UDim2.new(pct, 0, 1, 0) }
						):Play()
						task.wait(1 / 20)
					end
				end)
			else
				ProgressTrack.Visible = false
			end
		end

		function NewNotification:Close()
			if not NewNotification.Closed then
				NewNotification.Closed = true

				for i, notif in pairs(Library.ActiveNotifications or {}) do
					if notif == NewNotification then
						table.remove(Library.ActiveNotifications, i)
						break
					end
				end

				task.spawn(function()
					RootMotor:setGoal({
						Scale  = Spring(1, { frequency = 6 }),
						Offset = Spring(70, { frequency = 6 }),
					})
					task.wait(0.35)
					if Library.UseAcrylic and NewNotification.AcrylicPaint
						and NewNotification.AcrylicPaint.Model then
						NewNotification.AcrylicPaint.Model:Destroy()
					end
					NewNotification.Holder:Destroy()
				end)
			end
		end

		table.insert(Library.ActiveNotifications, NewNotification)
		NewNotification:Open()

		if Config.Duration then
			task.delay(Config.Duration, function()
				NewNotification:Close()
			end)
		end

		return NewNotification
	end

	return Notification
end)()
Components.Textbox = (function()
	local New = Creator.New

	return function(Parent, Acrylic)
		Acrylic = Acrylic or false
		local Textbox = {}

		Textbox.Input = New("TextBox", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromOffset(10, 0),
			ThemeTag = {
				TextColor3 = "Text",
				PlaceholderColor3 = "SubText",
			},
		})

		Textbox.Container = New("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -12, 1, 0),
		}, {
			Textbox.Input,
		})

		Textbox.Indicator = New("Frame", {
			Size = UDim2.new(1, -4, 0, 1),
			Position = UDim2.new(0, 2, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = Acrylic and 0.5 or 0,
			ThemeTag = {
				BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine",
			},
		})

		Textbox.Frame = New("Frame", {
			Size = UDim2.new(0, 0, 0, 32),
			BackgroundTransparency = Acrylic and 0.88 or 0,
			Parent = Parent,
			ThemeTag = {
				BackgroundColor3 = Acrylic and "Input" or "DialogInput",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = Acrylic and 0.45 or 0.55,
				ThemeTag = {
					Color = Acrylic and "InElementBorder" or "DialogButtonBorder",
				},
			}),
			Textbox.Indicator,
			Textbox.Container,
		})

		local function Update()
			local PADDING = 2
			local Reveal = Textbox.Container.AbsoluteSize.X

			if not Textbox.Input:IsFocused() or Textbox.Input.TextBounds.X <= Reveal - 2 * PADDING then
				Textbox.Input.Position = UDim2.new(0, PADDING, 0, 0)
			else
				local Cursor = Textbox.Input.CursorPosition
				if Cursor ~= -1 then
					local subtext = string.sub(Textbox.Input.Text, 1, Cursor - 1)
					local width = TextService:GetTextSize(
						subtext,
						Textbox.Input.TextSize,
						Textbox.Input.Font,
						Vector2.new(math.huge, math.huge)
					).X

					local CurrentCursorPos = Textbox.Input.Position.X.Offset + width
					if CurrentCursorPos < PADDING then
						Textbox.Input.Position = UDim2.fromOffset(PADDING - width, 0)
					elseif CurrentCursorPos > Reveal - PADDING - 1 then
						Textbox.Input.Position = UDim2.fromOffset(Reveal - width - PADDING - 1, 0)
					end
				end
			end
		end

		task.spawn(Update)

		Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Update)
		Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), Update)

		Creator.AddSignal(Textbox.Input.Focused, function()
			Update()
			Textbox.Indicator.Size = UDim2.new(1, -2, 0, 2)
			Textbox.Indicator.Position = UDim2.new(0, 1, 1, 0)
			Textbox.Indicator.BackgroundTransparency = 0
			Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "InputFocused" or "DialogHolder" })
			Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = "InputIndicatorFocus" })
		end)

		Creator.AddSignal(Textbox.Input.FocusLost, function()
			Update()
			Textbox.Indicator.Size = UDim2.new(1, -4, 0, 1)
			Textbox.Indicator.Position = UDim2.new(0, 2, 1, 0)
			Textbox.Indicator.BackgroundTransparency = 0.5
			Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "Input" or "DialogInput" })
			Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine" })
		end)

		return Textbox
	end
end)()
Components.TitleBar = (function()
	local New = Creator.New
	local AddSignal = Creator.AddSignal

	return function(Config)
		local TitleBar = {}

		-- Window control button (Min/Max/Close)
		local function BarButton(Icon, Pos, Parent, Callback)
			local Button = {
				Callback = Callback or function() end,
			}

			Button.Frame = New("TextButton", {
				Size = UDim2.new(0, 32, 0, 32),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 0.96,
				Parent = Parent,
				Position = Pos,
				Text = "",
				ThemeTag = {
					BackgroundColor3 = "Hover",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
				New("ImageLabel", {
					Image = Icon,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Name = "Icon",
					ThemeTag = {
						ImageColor3 = "SubText",
					},
				}),
			})

			local Motor, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")

			AddSignal(Button.Frame.MouseEnter, function()
				SetTransparency(0.88)
			end)
			AddSignal(Button.Frame.MouseLeave, function()
				SetTransparency(1, true)
			end)
			AddSignal(Button.Frame.MouseButton1Down, function()
				SetTransparency(0.80)
			end)
			AddSignal(Button.Frame.MouseButton1Up, function()
				SetTransparency(0.88)
			end)
			AddSignal(Button.Frame.MouseButton1Click, Button.Callback)

			Button.SetCallback = function(Func)
				Button.Callback = Func
			end

			return Button
		end

		-- MAIN TITLEBAR FRAME — height 52px for a premium feel
		TitleBar.Frame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 52),
			BackgroundTransparency = 1,
			Parent = Config.Parent,
		}, {
			New("Frame", {
				Name = "LeftSection",
				Size = UDim2.new(1, -160, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 10),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 14),
				}),

				-- Logo image (ไม่มีเส้นขอบ, ขอบโค้งนิดเดียว)
				Config.Icon and New("Frame", {
					Name = "LogoFrame",
					Size = UDim2.fromOffset(30, 30),
					BackgroundTransparency = 1, -- 👻 ปรับเป็น 1 ให้พื้นหลังใสสนิท จะได้ไม่มีสี่เหลี่ยมทึบๆ มากวนใจ
					LayoutOrder = 1,
					ThemeTag = {
						BackgroundColor3 = "Accent",
					},
				}, {
					New("UICorner", { CornerRadius = UDim.new(0, 4) }), -- 📉 ปรับความโค้งจาก 8 เหลือ 4 (โค้งแค่มุมนิดๆ)
					
					-- ❌ ลบคำสั่ง New("UIStroke") ทิ้งไปเลย เพื่อลบเส้นขอบออก 100%

					New("ImageLabel", {
						Image = Config.Icon,
						Size = UDim2.fromOffset(35, 35), -- 🖼️ ขยายโลโก้ให้ใหญ่ขึ้นอีกนิด (เป็น 26) เพราะไม่มีกรอบแล้ว
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ThemeTag = { ImageColor3 = "Text" },
					}, {
						-- เผื่อรูปโลโก้ของคุณเป็นสี่เหลี่ยมจัตุรัสเป๊ะๆ เลยแถม UICorner ให้รูปมันโค้งตามเฟรมด้วย
						New("UICorner", { CornerRadius = UDim.new(0, 4) }) 
					}),
				}) or nil,

				-- Text stack: Title above SubTitle
				New("Frame", {
					Name = "TextStack",
					Size = UDim2.fromScale(0, 1),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					LayoutOrder = Config.Icon and 2 or 1,
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, 1),
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					-- Title (bold, larger)
					New("TextLabel", {
						RichText = true,
						Text = Config.Title,
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						TextSize = 13,
						TextXAlignment = "Left",
						TextYAlignment = "Center",
						Size = UDim2.fromScale(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						ThemeTag = { TextColor3 = "Text" },
					}),

					-- SubTitle (smaller, dimmer)
					Config.SubTitle and New("TextLabel", {
						RichText = true,
						Text = Config.SubTitle,
						TextTransparency = 0.45,
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Regular,
							Enum.FontStyle.Normal
						),
						TextSize = 10,
						TextXAlignment = "Left",
						TextYAlignment = "Center",
						Size = UDim2.fromScale(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						ThemeTag = { TextColor3 = "Text" },
					}) or nil,
				}),
			}),

			New("Frame", {
				Name = "RightSection",
				Size = UDim2.new(0, 154, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -6, 0, 0),
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 4),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
				}),
			}),

			-- Bottom separator line
			New("Frame", {
				BackgroundTransparency = 0.55,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, -1),
				ThemeTag = { BackgroundColor3 = "TitleBarLine" },
			}),
		})

		-- Anchor helpers for BarButtons inside RightSection using UIListLayout
		local function RightBarButton(Icon, Parent, Callback)
			local Button = { Callback = Callback or function() end }
			Button.Frame = New("TextButton", {
				Size = UDim2.new(0, 32, 0, 32),
				BackgroundTransparency = 1,
				Parent = Parent,
				Text = "",
				ThemeTag = { BackgroundColor3 = "Hover" },
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 8) }),
				New("ImageLabel", {
					Image = Icon,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Name = "Icon",
					ThemeTag = { ImageColor3 = "SubText" },
				}),
			})
			local Motor, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")
			AddSignal(Button.Frame.MouseEnter, function() SetTransparency(0.88) end)
			AddSignal(Button.Frame.MouseLeave, function() SetTransparency(1, true) end)
			AddSignal(Button.Frame.MouseButton1Down, function() SetTransparency(0.80) end)
			AddSignal(Button.Frame.MouseButton1Up, function() SetTransparency(0.88) end)
			AddSignal(Button.Frame.MouseButton1Click, Button.Callback)
			Button.SetCallback = function(Func) Button.Callback = Func end
			return Button
		end

		local rightSection = TitleBar.Frame:FindFirstChild("RightSection")
		TitleBar.MinButton = RightBarButton(Components.Assets.Min, rightSection, function()
			Library.Window:Minimize()
		end)
		TitleBar.MaxButton = RightBarButton(Components.Assets.Max, rightSection, function()
			Config.Window.Maximize(not Config.Window.Maximized)
		end)
		TitleBar.CloseButton = RightBarButton(Components.Assets.Close, rightSection, function()
			Library.Window:Dialog({
				Title = "Close",
				Content = "Are you sure you want to unload the interface?",
				Buttons = {
					{ Title = "Yes", Callback = function() Library:Destroy() end },
					{ Title = "No" },
				},
			})
		end)

		return TitleBar
	end
end)()
Components.Window = (function()
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New = Creator.New

	return function(Config)
		local Window = {
			Minimized = false,
			Maximized = false,
			Size = Config.Size,
			CurrentPos = 0,
			TabWidth = 0,
			Position = UDim2.fromOffset(0, 0),
			DropdownsOutsideWindow = Config.DropdownsOutsideWindow == true,
		}

		Library.Window = Window

		local Dragging, DragInput, MousePos, StartPos = false
		local Resizing, ResizePos = false
		local MinimizeNotif = false

		Window.AcrylicPaint = Acrylic.AcrylicPaint()

		local function CenterWindow()
			local vp = Camera.ViewportSize
			local x = math.max(0, (vp.X - Window.Size.X.Offset) / 2)
			local y = math.max(0, (vp.Y - Window.Size.Y.Offset) / 2)
			Window.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
			if Window.Root then
				Window.Root.Position = Window.Position
			end
		end
		Window.TabWidth = Config.TabWidth

		local Selector = New("Frame", {
			Size = UDim2.fromOffset(3, 0),
			BackgroundColor3 = Color3.fromRGB(76, 194, 255),
			Position = UDim2.fromOffset(0, (Window.TabHolderTop or 45) + 0),
			AnchorPoint = Vector2.new(0, 0.5),
			ZIndex = 1,
			ThemeTag = {
				BackgroundColor3 = "Accent",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 9),
			}),
		})

		local ResizeStartFrame = New("Frame", {
			Size = UDim2.fromOffset(20, 20),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -20, 1, -2),
		})

		local SearchElements = {}
		local AllElements = {}

		local function UpdateElementVisibility(searchTerm)
			if not searchTerm then searchTerm = "" end
			
			local function normalizeText(text)
				if not text then return "" end
				text = tostring(text)
				text = string.gsub(text, "^%s+", "")
				text = string.gsub(text, "%s+$", "")
				text = string.gsub(text, "%s+", " ")
				return string.lower(text)
			end
			
			local function getElementValues(elementFrame)
				local values = {}
				
				local function addText(text)
					if text and text ~= "" then
						table.insert(values, tostring(text))
					end
				end
				
				local function findTextInDescendants(obj)
					if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
						addText(obj.Text)
					end
					for _, child in pairs(obj:GetChildren()) do
						findTextInDescendants(child)
					end
				end
				
				findTextInDescendants(elementFrame)
				
				return values
			end
			
			local function checkMatch(text, query)
				if query == "" then
					return true
				end
				
				local normalizedText = normalizeText(text)
				if normalizedText == "" then
					return false
				end
				
				local queryLower = normalizeText(query)
				if queryLower == "" then
					return true
				end
				
				if string.find(queryLower, "%s", 1) then
					local words = {}
					for word in string.gmatch(queryLower, "%S+") do
						if #word > 0 then
							table.insert(words, word)
						end
					end
					
					if #words == 0 then
						return true
					end
					
					for _, word in ipairs(words) do
						if not string.find(normalizedText, word, 1, true) then
							return false
						end
					end
					return true
				else
					return string.find(normalizedText, queryLower, 1, true) ~= nil
				end
			end
			
			local normalizedQuery = normalizeText(searchTerm)
			
			local matchedSectionFrames = {}
			local elementsInMatchedSections = {}
			
			for element, data in pairs(AllElements) do
				if element and element.Parent then
					if data.type == "Section" then
						local title = tostring(data.title or "")
						if normalizedQuery ~= "" and checkMatch(title, normalizedQuery) then
							matchedSectionFrames[element] = true
							if element:FindFirstChild("Container") then
								local container = element:FindFirstChild("Container")
								for _, child in pairs(container:GetChildren()) do
									if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
										elementsInMatchedSections[child] = true
									end
								end
							end
						end
					end
				end
			end
			
			for element, data in pairs(AllElements) do
				if element and element.Parent then
					if normalizedQuery == "" then
						element.Visible = true
					else
						local title = tostring(data.title or "")
						local desc = tostring(data.description or "")
						local matchesTitle = checkMatch(title, normalizedQuery)
						local matchesDesc = checkMatch(desc, normalizedQuery)
						local matchesValues = false
						
						local elementValues = getElementValues(element)
						for _, value in ipairs(elementValues) do
							if checkMatch(value, normalizedQuery) then
								matchesValues = true
								break
							end
						end
						
						local matchesSection = elementsInMatchedSections[element] == true
						
						if not matchesSection and data.section then
							for sectionFrame, _ in pairs(matchedSectionFrames) do
								if data.section == sectionFrame then
									matchesSection = true
									break
								end
							end
						end
						
						element.Visible = matchesTitle or matchesDesc or matchesValues or matchesSection
					end
				end
			end

			local searchTermForClosure = searchTerm
			task.spawn(function()
				task.wait(0.05)
				
				if not Window or not Window.ContainerHolder then return end
				
				for _, tabContainer in pairs(Window.ContainerHolder:GetChildren()) do
					if tabContainer:IsA("ScrollingFrame") then
						local containerLayout = tabContainer:FindFirstChild("UIListLayout")
						if containerLayout then
							local containerPadding = tabContainer:FindFirstChild("UIPadding")
							local paddingTop = containerPadding and containerPadding.PaddingTop.Offset or 1
							local paddingBottom = containerPadding and containerPadding.PaddingBottom.Offset or 1
							local contentSize = containerLayout.AbsoluteContentSize.Y + paddingTop + paddingBottom
							tabContainer.CanvasSize = UDim2.new(0, 0, 0, math.max(0, contentSize))
						end
						
						for _, section in pairs(tabContainer:GetChildren()) do
							if section:IsA("Frame") and section.Name ~= "UIPadding" then
								local sectionContainer = section:FindFirstChild("Container")
								
								if sectionContainer and sectionContainer:IsA("Frame") then
									local containerLayout = sectionContainer:FindFirstChild("UIListLayout")
									if containerLayout then
										local hasVisibleChild = false
										for _, element in pairs(sectionContainer:GetChildren()) do
											if not element:IsA("UIListLayout") and element.Visible then
												hasVisibleChild = true
												break
											end
										end
										
										if searchTermForClosure == "" or hasVisibleChild then
											section.Visible = true
											local containerPadding = sectionContainer:FindFirstChild("UIPadding")
											local containerPaddingTop = containerPadding and containerPadding.PaddingTop.Offset or 0
											local containerPaddingBottom = containerPadding and containerPadding.PaddingBottom.Offset or 0
											local containerContentSize = containerLayout.AbsoluteContentSize.Y + containerPaddingTop + containerPaddingBottom
											sectionContainer.Size = UDim2.new(1, 0, 0, math.max(0, containerContentSize))
										else
											section.Visible = false
											sectionContainer.Size = UDim2.new(1, 0, 0, 0)
										end
									end
								end
								
								local sectionLayout = section:FindFirstChild("UIListLayout")
								if sectionLayout then
									local sectionPadding = section:FindFirstChild("UIPadding")
									local sectionPaddingTop = sectionPadding and sectionPadding.PaddingTop.Offset or 0
									local sectionPaddingBottom = sectionPadding and sectionPadding.PaddingBottom.Offset or 0
									local sectionContentSize = sectionLayout.AbsoluteContentSize.Y + sectionPaddingTop + sectionPaddingBottom
									section.Size = UDim2.new(1, 0, 0, math.max(0, sectionContentSize + 25))
								end
							end
						end
					end
				end
			end)
		end

		local function RegisterElement(elementFrame, title, elementType, description)
			if elementFrame then
				local sectionFrame = nil
				local parent = elementFrame.Parent
				
				while parent do
					if parent:FindFirstChild("Container") then
						local sectionRoot = parent
						local sectionContainer = parent:FindFirstChild("Container")
						if sectionContainer and elementFrame.Parent == sectionContainer then
							sectionFrame = sectionRoot
							break
						end
					end
					parent = parent.Parent
				end
				
				AllElements[elementFrame] = {
					title = tostring(title or ""),
					type = elementType or "Element",
					description = tostring(description or ""),
					section = sectionFrame
				}
			end
		end

		Window.ShowSearch = (Config.Search == nil) and true or (Config.Search and true or false)

		local ImageAsset = Config.Image
		local hasImage = ImageAsset and type(ImageAsset) == "string" and ImageAsset ~= ""
		local imageSize = Window.TabWidth - 24
		local topOffset = 0

		local ImageFrame = hasImage and New("ImageLabel", {
			Size = UDim2.new(0, imageSize, 0, imageSize),
			Position = UDim2.new(0.5, 0, 0, topOffset),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Image = ImageAsset,
			ZIndex = 5,
			Visible = true,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
		}) or nil

		Window.HasImage = hasImage
		Window.ImageFrame = ImageFrame
		Window.ImageSize = imageSize
		Window.TopOffset = topOffset

		local searchOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
		local searchHeight = 28

		local tabHolderTop
		if hasImage then
			if Window.ShowSearch then
				tabHolderTop = imageSize + 10 + topOffset + searchHeight + 6
			else
				tabHolderTop = imageSize + 10 + topOffset
			end
		else
			if Window.ShowSearch then
				tabHolderTop = topOffset + searchHeight + 6
			else
				tabHolderTop = 45
			end
		end
		Window.TabHolderTop = tabHolderTop

		Window.TabHolder = New("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -(tabHolderTop + 6)),
			Position = UDim2.new(0, 0, 0, tabHolderTop),
			BackgroundTransparency = 1,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = 0,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 4),
			}),
		})

		local SearchFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.new(0, 0, 0, searchOffset),
			BackgroundTransparency = 0.7,
			ZIndex = 10,
			Visible = Window.ShowSearch,
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			ThemeTag = {
				BackgroundColor3 = "Element",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		})

		local SearchInput = New("TextBox", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -36, 1, 0),
			Position = UDim2.new(0, 8, 0, 0),
			PlaceholderText = "Search...",
			PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
			ClearTextOnFocus = false,
			Text = "",
			Parent = SearchFrame,
			ThemeTag = {
				TextColor3 = "Text",
				PlaceholderColor3 = "SubText",
			},
		})

		local SearchIcon = New("ImageLabel", {
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.new(1, -13, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "rbxassetid://10734943674",
			Parent = SearchFrame,
			ImageTransparency = 0.3,
			ThemeTag = {
				ImageColor3 = "SubText",
			},
		})

		local SearchTextbox = {
			Input = SearchInput,
			Frame = SearchFrame,
		}

		Creator.AddSignal(SearchTextbox.Input:GetPropertyChangedSignal("Text"), function()
			local searchText = SearchTextbox.Input.Text or ""
			UpdateElementVisibility(searchText)
		end)

		Creator.AddSignal(SearchTextbox.Input.FocusLost, function(enterPressed)
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(input, gameProcessed)
			if gameProcessed then return end
			if input.KeyCode == Enum.KeyCode.Escape and SearchTextbox.Input:IsFocused() then
				SearchTextbox.Input.Text = ""
				SearchTextbox.Input:ReleaseFocus()
			end
		end)

		Window.SearchElements = SearchElements
		Window.AllElements = AllElements
		Window.RegisterElement = RegisterElement
		Window.UpdateElementVisibility = UpdateElementVisibility

		local imageSize = Window.TabWidth - 24
		local topOffset = Window.TopOffset or 25
		local imageOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
		local searchHeight = 28
		local totalOffset = (Window.ShowSearch and searchHeight or 0) + imageOffset

		local TabFrame = New("Frame", {
			Size = UDim2.new(0, Window.TabWidth, 1, Window.ShowSearch and -63 or -31),
			Position = UDim2.new(0, 12, 0, Window.ShowSearch and 54 or 19),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, {
			ImageFrame,
			SearchFrame,
			Window.TabHolder,
			Selector,
		})

		Window.TabFrame = TabFrame

		Window.TabDisplay = New("TextLabel", {
			RichText = true,
			Text = "Tab",
			TextTransparency = 0,
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextSize = 28,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 28),
			Position = UDim2.fromOffset(Window.TabWidth + 26, 56),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Window.ContainerHolder = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		})

		Window.ContainerAnim = New("CanvasGroup", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		})

		Window.ContainerCanvas = New("Frame", {
			Size = UDim2.new(1, -Window.TabWidth - 32, 1, -102),
			Position = UDim2.fromOffset(Window.TabWidth + 26, 90),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, {
			Window.ContainerAnim,
			Window.ContainerHolder
		})

		local backgroundTransparency = Config.BackgroundTransparency
		if backgroundTransparency == nil then
			backgroundTransparency = 0.5
		end
		Window.BackgroundTransparency = backgroundTransparency

		local backgroundImageTransparency = Config.BackgroundImageTransparency
		if backgroundImageTransparency == nil then
			backgroundImageTransparency = backgroundTransparency
		end
		Window.BackgroundImageTransparency = backgroundImageTransparency

		local rootChildren = {}
		
		if Config.BackgroundImage then
			local BackgroundImageFrame = New("ImageLabel", {
				Name = "BackgroundImage",
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 1,
				Image = Config.BackgroundImage,
				ImageTransparency = math.max(0, math.min(1, backgroundImageTransparency)),
				ZIndex = 0,
				ScaleType = Enum.ScaleType.Stretch,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
			})
			Window.BackgroundImage = BackgroundImageFrame
			table.insert(rootChildren, BackgroundImageFrame)
			
			if Window.AcrylicPaint and Window.AcrylicPaint.Frame then
				if backgroundImageTransparency <= 0.1 then
					Window.AcrylicPaint.Frame.BackgroundTransparency = 1
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 1
					end
					local function makeTransparent(obj)
						if obj:IsA("Frame") then
							obj.BackgroundTransparency = 1
						elseif obj:IsA("ImageLabel") then
							obj.ImageTransparency = 1
						end
						for _, child in ipairs(obj:GetChildren()) do
							if not child:IsA("UICorner") and not child:IsA("UIGradient") and not child:IsA("UIStroke") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
								makeTransparent(child)
							end
						end
					end
					makeTransparent(Window.AcrylicPaint.Frame)
				elseif backgroundImageTransparency < 0.3 then
					Window.AcrylicPaint.Frame.BackgroundTransparency = 0.99
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 0.99
					end
				else
					Window.AcrylicPaint.Frame.BackgroundTransparency = 0.98
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 0.98
					end
				end
			end
		end
		
		table.insert(rootChildren, Window.AcrylicPaint.Frame)
		table.insert(rootChildren, Window.TabDisplay)
		table.insert(rootChildren, Window.ContainerCanvas)
		table.insert(rootChildren, TabFrame)
		table.insert(rootChildren, ResizeStartFrame)

		Window.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size = Window.Size,
			Position = Window.Position,
			Parent = Config.Parent,
		}, rootChildren)

		CenterWindow()
		Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), function()
			CenterWindow()
		end)

		Window.TitleBar = Components.TitleBar({
			Title = Config.Title,
			SubTitle = Config.SubTitle,
			Icon = Config.Icon,
			Discord = Config.Discord,
			Parent = Window.Root,
			Window = Window,
			UserInfoTitle = Config.UserInfoTitle,
			UserInfo = Config.UserInfo,
			UserInfoSubtitle = Config.UserInfoSubtitle,
			UserInfoSubtitleColor = Config.UserInfoSubtitleColor,
		})

		if Config.UserInfo then
			local function parseColor(value)
				if typeof(value) == "Color3" then return value end
				return Themes[Library.Theme].SubText or Color3.fromRGB(170,170,170)
			end

			local userInfoHeight = 56
			Window.UserInfoHeight = userInfoHeight
			Window.UserInfoTop = Config.UserInfoTop
			local UserInfoSection = New("Frame", {
				Name = "UserInfoSection",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, userInfoHeight),
				Position = Config.UserInfoTop and UDim2.fromOffset(0, 0) or UDim2.new(0, 0, 1, -(userInfoHeight + 2)),
				ZIndex = 15,
				Parent = TabFrame,
			})

			New("Frame", {
				Name = "UserInfoSeparator",
				BackgroundTransparency = 0.5,
				Size = UDim2.new(1, 0, 0, 1),
				Position = Config.UserInfoTop and UDim2.fromOffset(0, userInfoHeight + 4) or UDim2.new(0, 0, 1, -(userInfoHeight + 4)),
				ZIndex = 15,
				Parent = TabFrame,
				ThemeTag = {
					BackgroundColor3 = "TitleBarLine",
				},
			})

			local avatarSize = 28
			local Avatar = New("ImageLabel", {
				Name = "Avatar",
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(avatarSize, avatarSize),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Image = "rbxassetid://0",
				Parent = UserInfoSection,
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }),
				New("UIStroke", { Transparency = 0.7, Thickness = 1, ThemeTag = { Color = "ElementBorder" } }),
			})

			pcall(function()
				local Players = game:GetService("Players")
				local content, isReady = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				if isReady and content then
					Avatar.Image = content
				end
			end)

			local titleText = tostring((Config.UserInfoTitle ~= nil and Config.UserInfoTitle) or (LocalPlayer.Name or "User"))
			local subtitleText = (Config.UserInfoSubtitle ~= nil) and tostring(Config.UserInfoSubtitle) or ""

			New("TextLabel", {
				Name = "UserName",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				TextSize = 13,
				Text = titleText,
				Size = UDim2.new(1, -avatarSize - 12, 0.5, 0),
				Position = UDim2.new(0, avatarSize + 12, 0, -2),
				Parent = UserInfoSection,
				ThemeTag = { TextColor3 = "Text" },
			})

			New("TextLabel", {
				Name = "UserSubtitle",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextSize = 12,
				TextTransparency = 0.2,
				Text = subtitleText,
				TextColor3 = parseColor(Config.UserInfoSubtitleColor),
				Size = UDim2.new(1, -avatarSize - 12, 0.5, 0),
				Position = UDim2.new(0, avatarSize + 12, 0.5, 2),
				Parent = UserInfoSection,
			})

			if Config.UserInfoTop then
				local topOffset = Window.TopOffset or 0
				local imageOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
				TabFrame.Position = UDim2.new(0, 12, 0, 39)
				TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, -(31 + imageOffset + userInfoHeight))
				local searchOffset = hasImage and (imageSize + 10 + topOffset) or topOffset
				SearchFrame.Position = UDim2.new(0, 0, 0, userInfoHeight + 6 + searchOffset)
				if ImageFrame then
					ImageFrame.Position = UDim2.new(0.5, 0, 0, userInfoHeight + topOffset)
				end
				local newTabHolderTop = userInfoHeight + 6 + (hasImage and (imageSize + 10 + topOffset) or topOffset) + (Window.ShowSearch and (searchHeight + 6) or 0)
				Window.TabHolderTop = newTabHolderTop
				Window.TabHolder.Position = UDim2.new(0, 0, 0, newTabHolderTop)
				Window.TabHolder.Size = UDim2.new(1, 0, 1, -(newTabHolderTop + 6 + userInfoHeight))
				if Window.UpdateTabHolderLayout then
					Window:UpdateTabHolderLayout(newTabHolderTop)
				end
			else
				Window.TabHolder.Size = UDim2.new(1, 0, 1, -(tabHolderTop + 6 + userInfoHeight))
				if Window.UpdateTabHolderLayout then
					Window:UpdateTabHolderLayout(tabHolderTop)
				end
			end
		end

		if Library.UseAcrylic then
			Window.AcrylicPaint.AddParent(Window.Root)
		end

		local SizeMotor = Flipper.GroupMotor.new({
			X = Window.Size.X.Offset,
			Y = Window.Size.Y.Offset,
		})

		local PosMotor = Flipper.GroupMotor.new({
			X = Window.Position.X.Offset,
			Y = Window.Position.Y.Offset,
		})

		_G.CDDrag = 0
		Window.SelectorPosMotor = Flipper.SingleMotor.new(17)
		Window.SelectorSizeMotor = Flipper.SingleMotor.new(0)
		Window.ContainerBackMotor = Flipper.SingleMotor.new(0)
		Window.ContainerPosMotor = Flipper.SingleMotor.new(94)
		Window.ContainerXMotor = Flipper.SingleMotor.new(0)

		SizeMotor:onStep(function(values)
			task.wait(_G.CDDrag / 10)
			Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
			task.spawn(function()
				task.wait(0.01)
				if Window.UpdateTabHolderLayout then
					Window:UpdateTabHolderLayout()
				end
			end)
		end)

		PosMotor:onStep(function(values)
			task.wait(_G.CDDrag / 10)
			Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
		end)

		local LastValue = 0
		local LastTime = 0
		Window.SelectorPosMotor:onStep(function(Value)
			local base = Window.TabHolderTop or 45
			local verticalInset = 16
			local selectorY = base + Value + verticalInset

			local searchOffset = Window.HasImage and (Window.ImageSize + Window.TopOffset + 10) or Window.TopOffset
			local searchTop = searchOffset
			local searchBottom = searchTop + 28

			if Window.HasImage and Window.ImageSize then
				local imageBottom = Window.ImageSize + Window.TopOffset + 10
				if selectorY < imageBottom then
					Selector.Visible = false
					return
				end
			end

			if Window.ShowSearch then
				if selectorY >= searchTop and selectorY <= searchBottom then
					Selector.Visible = false
					return
				end
			end

			if Window.UserInfoHeight then
				local tabFrameSize = Window.TabFrame and Window.TabFrame.Size.Y.Offset or 0
				local userInfoTop = Window.UserInfoTop and 0 or (tabFrameSize - Window.UserInfoHeight - 2)
				local userInfoBottom = userInfoTop + Window.UserInfoHeight
				
				if selectorY >= userInfoTop and selectorY <= userInfoBottom then
					Selector.Visible = false
					return
				end
			end

			Selector.Visible = true
			Selector.Position = UDim2.new(0, 0, 0, selectorY)
			local Now = tick()
			local DeltaTime = Now - LastTime

			if LastValue ~= nil then
				Window.SelectorSizeMotor:setGoal(Spring((math.abs(Value - LastValue) / (DeltaTime * 60)) + 16))
				LastValue = Value
			end
			LastTime = Now
		end)

		Window.SelectorSizeMotor:onStep(function(Value)
			Selector.Size = UDim2.new(0, 4, 0, Value)
		end)

		Window.ContainerBackMotor:onStep(function(Value)
			Window.ContainerAnim.GroupTransparency = Value
		end)

		local ContainerXValue = 0
		local ContainerYValue = 94

		local function UpdateContainerPosition()
			if Window.ContainerAnim then
				Window.ContainerAnim.Position = UDim2.fromOffset(ContainerXValue, ContainerYValue)
			end
		end

		Window.ContainerPosMotor:onStep(function(Value)
			ContainerYValue = Value
			UpdateContainerPosition()
		end)

		Window.ContainerXMotor:onStep(function(Value)
			ContainerXValue = Value
			UpdateContainerPosition()
		end)

		local OldSizeX
		local OldSizeY
		Window.Maximize = function(Value, NoPos, Instant)
			Window.Maximized = Value
			Window.TitleBar.MaxButton.Frame.Icon.Image = Value and Components.Assets.Restore or Components.Assets.Max

			if Value then
				OldSizeX = Window.Size.X.Offset
				OldSizeY = Window.Size.Y.Offset
			end
			local SizeX = Value and Camera.ViewportSize.X or OldSizeX
			local SizeY = Value and Camera.ViewportSize.Y or OldSizeY
			SizeMotor:setGoal({
				X = Flipper[Instant and "Instant" or "Spring"].new(SizeX, { frequency = 6 }),
				Y = Flipper[Instant and "Instant" or "Spring"].new(SizeY, { frequency = 6 }),
			})
			Window.Size = UDim2.fromOffset(SizeX, SizeY)

			if not NoPos then
				PosMotor:setGoal({
					X = Spring(Value and 0 or Window.Position.X.Offset, { frequency = 6 }),
					Y = Spring(Value and 0 or Window.Position.Y.Offset, { frequency = 6 }),
				})
			end
		end

		Creator.AddSignal(Window.TitleBar.Frame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				MousePos = Input.Position
				StartPos = Window.Root.Position

				if Window.Maximized then
					StartPos = UDim2.fromOffset(
						Mouse.X - (Mouse.X * ((OldSizeX - 100) / Window.Root.AbsoluteSize.X)),
						Mouse.Y - (Mouse.Y * (OldSizeY / Window.Root.AbsoluteSize.Y))
					)
				end

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseMovement
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = Input
			end
		end)

		Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Resizing = true
				ResizePos = Input.Position
			end
		end)

		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				Window.Position = UDim2.fromOffset(StartPos.X.Offset + Delta.X, StartPos.Y.Offset + Delta.Y)
				PosMotor:setGoal({
					X = Instant(Window.Position.X.Offset),
					Y = Instant(Window.Position.Y.Offset),
				})

				if Window.Maximized then
					Window.Maximize(false, true, true)
				end
			end

			if
				(Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
				and Resizing
			then
				local Delta = Input.Position - ResizePos
				local StartSize = Window.Size

				local TargetSize = Vector3.new(StartSize.X.Offset, StartSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * Delta
				local TargetSizeClamped =
					Vector2.new(math.clamp(TargetSize.X, 470, 2048), math.clamp(TargetSize.Y, 380, 2048))

				SizeMotor:setGoal({
					X = Flipper.Instant.new(TargetSizeClamped.X),
					Y = Flipper.Instant.new(TargetSizeClamped.Y),
				})
			end
		end)

		Creator.AddSignal(UserInputService.InputEnded, function(Input)
			if Resizing == true or Input.UserInputType == Enum.UserInputType.Touch then
				Resizing = false
				Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
			end
		end)

		Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			if Window.TabHolder and Window.TabHolder.UIListLayout then
				local padding = Window.TabHolder:FindFirstChild("UIPadding")
				local paddingTop = padding and padding.PaddingTop.Offset or 6
				local paddingBottom = padding and padding.PaddingBottom.Offset or 6
				local contentSize = Window.TabHolder.UIListLayout.AbsoluteContentSize.Y + paddingTop + paddingBottom
				if contentSize > 0 then
					Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, contentSize)
				end
			end
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if
				type(Library.MinimizeKeybind) == "table"
				and Library.MinimizeKeybind.Type == "Keybind"
				and not UserInputService:GetFocusedTextBox()
			then
				if Input.KeyCode.Name == Library.MinimizeKeybind.Value then
					Window:Minimize()
				end
			elseif Input.KeyCode == Library.MinimizeKey and not UserInputService:GetFocusedTextBox() then
				Window:Minimize()
			end
		end)

		function Window:ToggleSearch()
			Window.ShowSearch = not Window.ShowSearch
			SearchFrame.Visible = Window.ShowSearch
			local topOffset = Window.TopOffset or 25
			local searchOffset = Window.HasImage and (Window.ImageSize + 10 + topOffset) or topOffset
			SearchFrame.Position = UDim2.new(0, 0, 0, searchOffset)
			local imageOffset = Window.HasImage and (Window.ImageSize + 10 + topOffset) or topOffset
			local searchHeight = 28
			local totalOffset = (Window.ShowSearch and searchHeight or 0) + imageOffset
			TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, -(totalOffset + 31))

			if Window.UpdateTabHolderLayout then
				Window:UpdateTabHolderLayout()
			end
		end

		function Window:Minimize()
			Window.Minimized = not Window.Minimized
			Window.Root.Visible = not Window.Minimized

			for _, Option in next, Library.Options do
				if Option and Option.Type == "Dropdown" and Option.Opened then
					pcall(function()
						Option:Close()
					end)
				end
			end
			if not MinimizeNotif then
				MinimizeNotif = true
				local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
				if not Mobile then Library:Notify({
					Title = "Interface",
					Content = "Press " .. Key .. " to toggle the interface.",
					Duration = 6
					})
				else 
					Library:Notify({
						Title = "Interface",
						Content = "Tap to the button to toggle the interface.",
						Duration = 6
					})
				end
			end

			if not RunService:IsStudio() and Library.Minimizer then
				pcall(function()
					if Mobile then
						local mobileButton = Library.Minimizer:FindFirstChild("TextButton")
						if mobileButton then
							local imageLabel = mobileButton:FindFirstChild("ImageLabel")
							if imageLabel then
								imageLabel.Image = Window.Minimized and "rbxassetid://10734896384" or "rbxassetid://10734897102"
							end
						end
					else
						local desktopButton = Library.Minimizer:FindFirstChild("TextButton")
						if desktopButton then
							local imageLabel = desktopButton:FindFirstChild("ImageLabel")
							if imageLabel then
								imageLabel.Image = Window.Minimized and "rbxassetid://10734896384" or "rbxassetid://10734897102"
							end
						end
					end
				end)
			end
		end

		function Window:Destroy()
			if Library.UseAcrylic then
				Window.AcrylicPaint.Model:Destroy()
			end
			Window.Root:Destroy()
		end

		function Window:SetBackgroundImage(imageUrl, imageTransparency)
			if not Window.BackgroundImage then
				local imgTransparency = imageTransparency or Window.BackgroundImageTransparency or Window.BackgroundTransparency or 0.5
				local BackgroundImageFrame = New("ImageLabel", {
					Name = "BackgroundImage",
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromOffset(0, 0),
					BackgroundTransparency = 1,
					Image = imageUrl,
					ImageTransparency = math.max(0, math.min(1, imgTransparency)),
					ZIndex = 0,
					ScaleType = Enum.ScaleType.Stretch,
					Parent = Window.Root,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, 8),
					}),
				})
				Window.BackgroundImage = BackgroundImageFrame
				if imageTransparency ~= nil then
					Window.BackgroundImageTransparency = imageTransparency
				end
			else
				Window.BackgroundImage.Image = imageUrl
				Window.BackgroundImage.ScaleType = Enum.ScaleType.Stretch
				if imageTransparency ~= nil then
					Window.BackgroundImageTransparency = imageTransparency
					Window.BackgroundImage.ImageTransparency = math.max(0, math.min(1, imageTransparency))
				end
			end
		end

		function Window:SetBackgroundTransparency(transparency)
			transparency = transparency or 0.5
			Window.BackgroundTransparency = transparency
		end

		function Window:SetBackgroundImageTransparency(transparency)
			transparency = transparency or 0.5
			Window.BackgroundImageTransparency = transparency
			if Window.BackgroundImage then
				Window.BackgroundImage.ImageTransparency = math.max(0, math.min(1, transparency))
			end
			if Window.AcrylicPaint and Window.AcrylicPaint.Frame then
				if transparency <= 0.1 then
					Window.AcrylicPaint.Frame.BackgroundTransparency = 1
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 1
					end
					local function makeTransparent(obj)
						if obj:IsA("Frame") then
							obj.BackgroundTransparency = 1
						elseif obj:IsA("ImageLabel") then
							obj.ImageTransparency = 1
						end
						for _, child in ipairs(obj:GetChildren()) do
							if not child:IsA("UICorner") and not child:IsA("UIGradient") and not child:IsA("UIStroke") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
								makeTransparent(child)
							end
						end
					end
					makeTransparent(Window.AcrylicPaint.Frame)
				elseif transparency < 0.3 then
					Window.AcrylicPaint.Frame.BackgroundTransparency = 0.99
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 0.99
					end
				else
					Window.AcrylicPaint.Frame.BackgroundTransparency = 0.98
					if Window.AcrylicPaint.Model then
						Window.AcrylicPaint.Model.Transparency = 0.98
					end
				end
			end
		end

		local DialogModule = Components.Dialog:Init(Window)
		function Window:Dialog(Config)
			local Dialog = DialogModule:Create()
			Dialog.Title.Text = Config.Title

			local ContentHolder = New("ScrollingFrame", {
				BackgroundTransparency = 1,
				ScrollBarImageTransparency = 0.7,
				ScrollBarThickness = 4,
				BottomImage = "rbxassetid://6889812791",
				MidImage = "rbxassetid://6889812721",
				TopImage = "rbxassetid://6276641225",
				Position = UDim2.fromOffset(20, 60),
				Size = UDim2.new(1, -40, 1, -110),
				CanvasSize = UDim2.fromOffset(0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Parent = Dialog.Root,
			})

			local Content = New("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Text = Config.Content,
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextWrapped = true,
				Size = UDim2.new(1, -8, 0, 0),
				BackgroundTransparency = 1,
				Parent = ContentHolder,
				ThemeTag = { TextColor3 = "Text" },
			})

			New("UISizeConstraint", {
				MinSize = Vector2.new(300, 165),
				MaxSize = Vector2.new(620, math.huge),
				Parent = Dialog.Root,
			})

			local maxWidth = math.min(620, Window.Size.X.Offset - 120)
			local baseWidth = math.max(300, math.min(maxWidth, Content.TextBounds.X + 40))
			Dialog.Root.Size = UDim2.fromOffset(baseWidth, 165)
			ContentHolder.Size = UDim2.new(1, -40, 1, -110)
			task.defer(function()
				local contentHeight = Content.TextBounds.Y
				local desired = math.clamp(contentHeight + 110, 165, 420)
				Dialog.Root.Size = UDim2.fromOffset(baseWidth, desired)
				ContentHolder.CanvasSize = UDim2.fromOffset(0, contentHeight)
			end)

			for _, Button in next, Config.Buttons do
				Dialog:Button(Button.Title, Button.Callback)
			end

			Dialog:Open()
		end

		local TabModule = Components.Tab:Init(Window)
		function Window:AddTab(TabConfig)
			local tab = TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder)
			return tab
		end

		function Window:SelectTab(Tab)
			TabModule:SelectTab(Tab)
		end

		Creator.AddSignal(Window.TabHolder:GetPropertyChangedSignal("CanvasPosition"), function()
			LastValue = TabModule:GetCurrentTabPos() + 16
			LastTime = 0
			Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
		end)

		return Window
	end
end)()
local ElementsTable = {}
local AddSignal = Creator.AddSignal

ElementsTable.Button = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Button"
	Element.NoIdx = true

	function Element:New(Config)
		assert(Config.Title, "Button - Missing Title")
		Config.Callback = Config.Callback or function() end

		local ButtonFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)

		local ButtonIco = New("ImageLabel", {
			Image = "rbxassetid://10709791437",
			Size = UDim2.fromOffset(14, 14),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 1,
			Parent = ButtonFrame.Frame,
			ThemeTag = { ImageColor3 = "Accent" },
		})

		-- accent left bar
		local BtnAccentBar = New("Frame", {
			Size = UDim2.new(0, 2, 0, 14),
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Parent = ButtonFrame.Frame,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local BtnMotor, SetBtnT = Creator.SpringMotor(ButtonFrame.Frame.BackgroundTransparency, ButtonFrame.Frame, "BackgroundTransparency")
		Creator.AddSignal(ButtonFrame.Frame.MouseEnter, function()
			TweenService:Create(BtnAccentBar, TweenInfo.new(0.18), { BackgroundTransparency = 0.2, Size = UDim2.new(0, 3, 0, 18) }):Play()
			SetBtnT(math.max(0, ButtonFrame.Frame.BackgroundTransparency - 0.05))
		end)
		Creator.AddSignal(ButtonFrame.Frame.MouseLeave, function()
			TweenService:Create(BtnAccentBar, TweenInfo.new(0.18), { BackgroundTransparency = 1, Size = UDim2.new(0, 2, 0, 14) }):Play()
			SetBtnT(Creator.GetThemeProperty("ElementTransparency"))
		end)
		Creator.AddSignal(ButtonFrame.Frame.MouseButton1Down, function()
			SetBtnT(math.max(0, ButtonFrame.Frame.BackgroundTransparency - 0.08))
		end)
		Creator.AddSignal(ButtonFrame.Frame.MouseButton1Up, function()
			SetBtnT(math.max(0, ButtonFrame.Frame.BackgroundTransparency + 0.03))
		end)

		Creator.AddSignal(ButtonFrame.Frame.MouseButton1Click, function()
			Library:SafeCallback(Config.Callback)
		end)

		return ButtonFrame
	end

	return Element
end)()
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
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local ToggleBorder = New("UIStroke", {
			Transparency = 0.4,
			Thickness = 1.5,
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
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
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
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			New("UIAspectRatioConstraint", { AspectRatio = 1 }),
		})

		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
			Func(Toggle.Value)
		end

		function Toggle:SetValue(Value)
			Value = not not Value
			Toggle.Value = Value

			local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			-- knob เลื่อน
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
ElementsTable.Dropdown = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Dropdown"
	local New = Creator.New

	function Element:New(Idx, Config)

		local windowDropdownsOutside = false
		if Library.Window and Library.Window.DropdownsOutsideWindow ~= nil then
			windowDropdownsOutside = Library.Window.DropdownsOutsideWindow
		elseif Library.Windows and #Library.Windows > 0 then
			for i = #Library.Windows, 1, -1 do
				local window = Library.Windows[i]
				if window and window.DropdownsOutsideWindow ~= nil then
					windowDropdownsOutside = window.DropdownsOutsideWindow
					break
				end
			end
		end
		
		local Dropdown = {
			Values = Config.Values,
			Value = Config.Default,
			Multi = Config.Multi,
			Buttons = {},
			Opened = false,
			Type = "Dropdown",
			Callback = Config.Callback or function() end,
			Search = (Config.Search == nil) and true or Config.Search,
			KeepSearch = Config.KeepSearch == true,
			OpenToRight = windowDropdownsOutside
		}

		if Dropdown.Multi and Config.AllowNull then
			Dropdown.Value = {}
		end

		local DropdownFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		DropdownFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)

		Dropdown.SetTitle = DropdownFrame.SetTitle
		Dropdown.SetDesc = DropdownFrame.SetDesc
		Dropdown.Visible = DropdownFrame.Visible
		Dropdown.Elements = DropdownFrame
		
		local container = self.Container

		local DropdownDisplay = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			Text = "",
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 14,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0.5, 0),
			Position = UDim2.new(0, 8, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local initialRotation = 180
		local openRotation = windowDropdownsOutside and -90 or 0
		local closeRotation = 180

		local DropdownIco = New("ImageLabel", {
			Image = "rbxassetid://10709790948",
			Size = UDim2.fromOffset(16, 16),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			BackgroundTransparency = 1,
			Rotation = initialRotation,
			ThemeTag = {
				ImageColor3 = "SubText",
			},
		})

		local DropdownInner = New("TextButton", {
			Size = UDim2.fromOffset(160, 32),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88,
			Parent = DropdownFrame.Frame,
			ThemeTag = {
				BackgroundColor3 = "DropdownFrame",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIStroke", {
				Transparency = 0.45,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "InElementBorder",
				},
			}),
			DropdownIco,
			DropdownDisplay,
		})

		local DropdownListLayout = New("UIListLayout", {
			Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		local DropdownScrollFrame = New("ScrollingFrame", {
			Size = UDim2.new(1, -5, 1, -10),
			Position = UDim2.fromOffset(5, 5),
			BackgroundTransparency = 1,
			BottomImage = "rbxassetid://6889812791",
			MidImage = "rbxassetid://6889812721",
			TopImage = "rbxassetid://6276641225",
			ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
			ScrollBarImageTransparency = 0.75,
			ScrollBarThickness = 5,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
		}, {
			DropdownListLayout,
		})

		local SearchBar
		local SearchBox
		if Dropdown.Search then
			SearchBar = New("Frame", {
				Size = UDim2.new(1, -10, 0, 28),
				Position = UDim2.fromOffset(5, 5),
				BackgroundTransparency = 0.7,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				ThemeTag = { BackgroundColor3 = "Element" },
				ZIndex = 24,
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 4) }),
			})

			SearchBox = New("TextBox", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -36, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				PlaceholderText = "Search...",
				PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
				ClearTextOnFocus = false,
				Text = "",
				Parent = SearchBar,
				ThemeTag = {
					TextColor3 = "Text",
					PlaceholderColor3 = "SubText",
				},
				ZIndex = 24,
			})

			local SearchIcon = New("ImageLabel", {
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(1, -13, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://10734943674",
				Parent = SearchBar,
				ImageTransparency = 0.3,
				ZIndex = 25,
				ThemeTag = {
					ImageColor3 = "SubText",
				},
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
					task.wait()
					RecalculateCanvasSize()
					task.wait()
					RecalculateListSize()
					task.wait()
					RecalculateListPosition()
				end)
			end

			Creator.AddSignal(SearchBox:GetPropertyChangedSignal("Text"), ApplyFilter)
		end

		local DropdownHolderFrame = New("Frame", {
			Size = UDim2.fromScale(1, 0.6),
			ThemeTag = {
				BackgroundColor3 = "DropdownHolder",
			},
		}, {
			SearchBar,
			DropdownScrollFrame,
			New("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "DropdownBorder",
				},
			}),
			New("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=5554236805",
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(23, 23, 277, 277),
				Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
				Position = UDim2.fromOffset(-15, -15),
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				ImageTransparency = 0.1,
			}),
		})

		local DropdownHolderCanvas = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(170, 300),
			Parent = Library.GUI,
			Visible = false,
		}, {
			DropdownHolderFrame,
			New("UISizeConstraint", {
				MinSize = Vector2.new(170, 0),
			}),
		})
		table.insert(Library.OpenFrames, DropdownHolderCanvas)

		local windowRoot = nil
		if Library.Window and Library.Window.Root then
			windowRoot = Library.Window.Root
		elseif Library.Windows and #Library.Windows > 0 then
			for i = #Library.Windows, 1, -1 do
				local window = Library.Windows[i]
				if window and window.Root then
					windowRoot = window.Root
					break
				end
			end
		end
		
		if not windowRoot and container then
			local parent = container.Parent
			while parent do
				if parent:IsA("Frame") then
					if parent:FindFirstChild("ContainerCanvas") or (parent.Name and parent:FindFirstChild("TitleBar")) then
						windowRoot = parent
						break
					end
				end
				if parent:IsA("ScreenGui") then
					break
				end
				parent = parent.Parent
			end
		end

		local function RecalculateListPosition()
			if not DropdownHolderCanvas or not DropdownInner then return end
			
			local dropdownX = DropdownInner.AbsolutePosition.X
			local dropdownY = DropdownInner.AbsolutePosition.Y
			local dropdownWidth = DropdownInner.AbsoluteSize.X
			local dropdownHeight = DropdownInner.AbsoluteSize.Y
			local canvasWidth = DropdownHolderCanvas.AbsoluteSize.X
			local canvasHeight = DropdownHolderCanvas.AbsoluteSize.Y
			local viewportHeight = Camera.ViewportSize.Y
			local viewportWidth = Camera.ViewportSize.X
			
			if not windowRoot then
				if Library.Window and Library.Window.Root then
					windowRoot = Library.Window.Root
				elseif Library.Windows and #Library.Windows > 0 then
					for i = #Library.Windows, 1, -1 do
						local window = Library.Windows[i]
						if window and window.Root then
							windowRoot = window.Root
							break
						end
					end
				end
				
				if not windowRoot and container then
					local parent = container.Parent
					while parent do
						if parent:IsA("Frame") then
							if parent:FindFirstChild("ContainerCanvas") or (parent.Name and parent:FindFirstChild("TitleBar")) then
								windowRoot = parent
								break
							end
						end
						if parent:IsA("ScreenGui") then
							break
						end
						parent = parent.Parent
					end
				end
			end
			
			local targetX = dropdownX - 1
			local useFixedY = false
			
			if windowRoot then
				local windowX = windowRoot.AbsolutePosition.X
				local windowWidth = windowRoot.AbsoluteSize.X
				local windowRight = windowX + windowWidth
				
				if Dropdown.OpenToRight then
					targetX = windowRight + 5
					if Dropdown.SavedY == nil then
						Dropdown.SavedY = dropdownY
					end
					useFixedY = true
				else
					local canvasRight = dropdownX + canvasWidth - 1
					if canvasRight > windowRight then
						targetX = math.max(windowX + 5, windowRight - canvasWidth - 5)
					end
					Dropdown.SavedY = nil
				end
			else
				local canvasRight = dropdownX + canvasWidth - 1
				if canvasRight > viewportWidth then
					if Dropdown.OpenToRight then
						targetX = viewportWidth + 5
						if Dropdown.SavedY == nil then
							Dropdown.SavedY = dropdownY
						end
						useFixedY = true
					else
						targetX = math.max(5, viewportWidth - canvasWidth - 5)
					end
					Dropdown.SavedY = nil
				end
			end
			
			local targetY
			if useFixedY and windowRoot then
				local windowY = windowRoot.AbsolutePosition.Y
				local windowHeight = windowRoot.AbsoluteSize.Y
				local windowCenterY = windowY + windowHeight / 2
				targetY = windowCenterY - canvasHeight / 2
				
				local windowTop = windowY
				local windowBottom = windowY + windowHeight
				local viewportTop = 0
				local viewportBottom = viewportHeight
				
				if targetY + canvasHeight > viewportBottom then
					targetY = viewportBottom - canvasHeight - 5
				end
				if targetY < viewportTop then
					targetY = viewportTop + 5
				end
				
				if targetY + canvasHeight > windowBottom then
					targetY = windowBottom - canvasHeight - 5
				end
				if targetY < windowTop then
					targetY = windowTop + 5
				end
			elseif useFixedY and Dropdown.SavedY then
				targetY = Dropdown.SavedY
				
				local spaceBelow = viewportHeight - (Dropdown.SavedY + dropdownHeight)
				local spaceAbove = Dropdown.SavedY
				
				if canvasHeight > spaceBelow and canvasHeight <= spaceAbove then
					targetY = Dropdown.SavedY - canvasHeight - 5
				elseif canvasHeight > spaceBelow and canvasHeight > spaceAbove then
					if spaceBelow > spaceAbove then
						targetY = Dropdown.SavedY + dropdownHeight + 5
					else
						targetY = math.max(5, Dropdown.SavedY - canvasHeight - 5)
					end
				else
					targetY = Dropdown.SavedY + dropdownHeight + 5
				end
			else
				local spaceBelow = viewportHeight - (dropdownY + dropdownHeight)
				local spaceAbove = dropdownY
				
				if canvasHeight <= spaceBelow then
					targetY = dropdownY + dropdownHeight + 5
				elseif canvasHeight <= spaceAbove then
					targetY = dropdownY - canvasHeight - 5
				else
					if spaceBelow > spaceAbove then
						targetY = dropdownY + dropdownHeight + 5
					else
						targetY = math.max(5, dropdownY - canvasHeight - 5)
					end
				end
			end
			
			DropdownHolderCanvas.Position = UDim2.fromOffset(targetX, targetY)
		end

		local ListSizeX = 0
		local function RecalculateListSize()
			if not DropdownHolderCanvas or not DropdownHolderFrame then return end
			
			local visibleCount = 0
			for _, element in next, DropdownScrollFrame:GetChildren() do
				if not element:IsA("UIListLayout") and element.Visible then
					visibleCount = visibleCount + 1
				end
			end
			
			local itemHeight = 32
			local padding = 3
			local searchHeight = Dropdown.Search and 38 or 0
			local innerMargins = 10
			local estimatedContent = (visibleCount > 0) and (visibleCount * itemHeight + (visibleCount - 1) * padding + innerMargins + searchHeight) or (innerMargins + searchHeight)
			local maxHeight = 392
			local targetHeight = math.min(estimatedContent, maxHeight)
			
			local canvasWidth = math.max(170, ListSizeX > 0 and (ListSizeX + 20) or 170)
			DropdownHolderCanvas.Size = UDim2.fromOffset(canvasWidth, targetHeight)
			
			local many = visibleCount > 10
			DropdownHolderFrame.Size = UDim2.fromScale(1, many and (targetHeight / math.max(targetHeight, 1)) or 1)
		end

		local function RecalculateCanvasSize()
			DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
		end

		RecalculateListPosition()
		RecalculateListSize()
		RecalculateCanvasSize()

		if Dropdown.OpenToRight then
			if windowRoot then
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsolutePosition"), function()
					if Dropdown.Opened then
						Dropdown.SavedY = nil
						RecalculateListPosition()
					end
				end)
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsoluteSize"), function()
					if Dropdown.Opened then
						RecalculateListPosition()
					end
				end)
			end
		else
			Creator.AddSignal(DropdownInner:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition)
			if windowRoot then
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsolutePosition"), function()
					if Dropdown.Opened then
						RecalculateListPosition()
					end
				end)
				Creator.AddSignal(windowRoot:GetPropertyChangedSignal("AbsoluteSize"), function()
					if Dropdown.Opened then
						RecalculateListPosition()
					end
				end)
			end
		end
		Creator.AddSignal(DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			RecalculateCanvasSize()
			task.wait()
			RecalculateListSize()
			task.wait()
			RecalculateListPosition()
		end)

		Creator.AddSignal(DropdownInner.MouseButton1Click, function()
			if Dropdown.Opened then
				Dropdown:Close()
			else
				Dropdown:Open()
			end
		end)

		Creator.AddSignal(DropdownInner.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.Touch then
				if Dropdown.Opened then
					Dropdown:Close()
				else
					Dropdown:Open()
				end
			end
		end)

		Creator.AddSignal(DropdownDisplay:GetPropertyChangedSignal("Text"), function()
			for _, Element in next, DropdownScrollFrame:GetChildren() do
				if not Element:IsA("UIListLayout") then
					Element.Visible = true
				end
			end
			RecalculateListPosition()
			RecalculateListSize()
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				local mousePos = Input.UserInputType == Enum.UserInputType.MouseButton1 and Vector2.new(Mouse.X, Mouse.Y) or Input.Position
				local AbsPos, AbsSize = DropdownHolderFrame.AbsolutePosition, DropdownHolderFrame.AbsoluteSize
				local innerAbsPos, innerAbsSize = DropdownInner.AbsolutePosition, DropdownInner.AbsoluteSize
				
				local clickedInsideDropdown = mousePos.X >= AbsPos.X and mousePos.X <= AbsPos.X + AbsSize.X and mousePos.Y >= AbsPos.Y and mousePos.Y <= AbsPos.Y + AbsSize.Y
				local clickedInsideInner = mousePos.X >= innerAbsPos.X and mousePos.X <= innerAbsPos.X + innerAbsSize.X and mousePos.Y >= innerAbsPos.Y and mousePos.Y <= innerAbsPos.Y + innerAbsSize.Y
				
				if not clickedInsideDropdown and not clickedInsideInner then
					Dropdown:Close()
				end
			end
		end)

		local ScrollFrame = self.ScrollFrame
		function Dropdown:Open()
			if Dropdown.Opened then
				return
			end
			Dropdown.Opened = true
			if Dropdown.OpenToRight then
				Dropdown.SavedY = nil
			end
			for _, frame in ipairs(Library.OpenFrames) do
				if frame ~= DropdownHolderCanvas and frame.Visible then
					frame.Visible = false
				end
			end
			if SearchBox and not Dropdown.KeepSearch then
				SearchBox.Text = ""
			end
			DropdownHolderCanvas.Visible = true
			RecalculateListPosition()
			RecalculateListSize()
			RecalculateCanvasSize()
			task.wait()
			TweenService:Create(
				DropdownHolderFrame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Size = UDim2.fromScale(1, 1) }
			):Play()
			TweenService:Create(
				DropdownIco,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Rotation = openRotation }
			):Play()
		end

		function Dropdown:Close()
			Dropdown.Opened = false
			if Dropdown.OpenToRight then
				Dropdown.SavedY = nil
			end
			DropdownHolderFrame.Size = UDim2.fromScale(1, 1)
			DropdownHolderCanvas.Visible = false
			TweenService:Create(
				DropdownIco,
				TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Rotation = closeRotation }
			):Play()
			Dropdown:Display()
			for _, element in next, DropdownScrollFrame:GetChildren() do
				if not element:IsA("UIListLayout") then
					element.Visible = true
				end
			end
		end

		function Dropdown:Display()
			local Values = Dropdown.Values
			local Str = ""

			if Config.Multi then
				for Idx, Value in next, Values do
					if Dropdown.Value[Value] then
						Str = Str .. Value .. ", "
					end
				end
				Str = Str:sub(1, #Str - 2)
			else
				Str = Dropdown.Value or ""
			end

			DropdownDisplay.Text = (Str == "" and "--" or Str)
		end

		function Dropdown:GetActiveValues()
			if Config.Multi then
				local T = {}

				for Value, Bool in next, Dropdown.Value do
					table.insert(T, Value)
				end

				return T
			else
				return Dropdown.Value and 1 or 0
			end
		end

		function Dropdown:SetActiveValues(Value)
			Dropdown.Value = Value

			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)

			Dropdown:BuildDropdownList()
		end

		function Dropdown:BuildDropdownList()
			local Values = Dropdown.Values
			local Buttons = {}

			for _, Element in next, DropdownScrollFrame:GetChildren() do
				if not Element:IsA("UIListLayout") then
					Element:Destroy()
				end
			end

			local layoutOrder = 0
			local hasRenderedItem = false

			for _, Value in ipairs(Values) do
				layoutOrder = layoutOrder + 1

				local Table = {}

				local ButtonSelector = New("Frame", {
					Size = UDim2.fromOffset(4, 14),
					BackgroundColor3 = Color3.fromRGB(76, 194, 255),
					Position = UDim2.fromOffset(-1, 16),
					AnchorPoint = Vector2.new(0, 0.5),
					ThemeTag = {
						BackgroundColor3 = "Accent",
					},
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, 2),
					}),
				})

				local ButtonLabel = New("TextLabel", {
					FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
					Text = Value,
					TextColor3 = Color3.fromRGB(200, 200, 200),
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromOffset(10, 0),
					Name = "ButtonLabel",
					ThemeTag = {
						TextColor3 = "Text",
					},
				})

				local Button = New("TextButton", {
					Size = UDim2.new(1, -5, 0, 32),
					BackgroundTransparency = 1,
					ZIndex = 23,
					Text = "",
					Parent = DropdownScrollFrame,
					LayoutOrder = layoutOrder,
					ThemeTag = {
						BackgroundColor3 = "DropdownOption",
					},
				}, {
					ButtonSelector,
					ButtonLabel,
					New("UICorner", { CornerRadius = UDim.new(0, 7) }),
					New("UIStroke", {
						Transparency = 1,
						Thickness = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						ThemeTag = { Color = "Accent" },
					}),
				})

				local Selected

				if Config.Multi then
					Selected = Dropdown.Value[Value]
				else
					Selected = Dropdown.Value == Value
				end

				local BackMotor, SetBackTransparency = Creator.SpringMotor(1, Button, "BackgroundTransparency")
				local SelMotor, SetSelTransparency = Creator.SpringMotor(1, ButtonSelector, "BackgroundTransparency")
				local SelectorSizeMotor = Flipper.SingleMotor.new(6)

				SelectorSizeMotor:onStep(function(value)
					ButtonSelector.Size = UDim2.new(0, 4, 0, value)
				end)

				Creator.AddSignal(Button.MouseEnter, function()
					SetBackTransparency(Selected and 0.85 or 0.89)
				end)
				Creator.AddSignal(Button.MouseLeave, function()
					SetBackTransparency(Selected and 0.89 or 1)
				end)
				Creator.AddSignal(Button.MouseButton1Down, function()
					SetBackTransparency(0.92)
				end)
				Creator.AddSignal(Button.MouseButton1Up, function()
					SetBackTransparency(Selected and 0.85 or 0.89)
				end)

				function Table:UpdateButton()
					if Config.Multi then
						Selected = Dropdown.Value[Value]
						if Selected then
							SetBackTransparency(0.89)
						end
					else
						Selected = Dropdown.Value == Value
						SetBackTransparency(Selected and 0.89 or 1)
					end

					SelectorSizeMotor:setGoal(Flipper.Spring.new(Selected and 14 or 6, { frequency = 6 }))
					SetSelTransparency(Selected and 0 or 1)
				end

				AddSignal(Button.Activated, function()
					local Try = not Selected

					if Dropdown:GetActiveValues() == 1 and not Try and not Config.AllowNull then
					else
						if Config.Multi then
							Selected = Try
							Dropdown.Value[Value] = Selected and true or nil
						else
							Selected = Try
							Dropdown.Value = Selected and Value or nil

							for _, OtherButton in next, Buttons do
								OtherButton:UpdateButton()
							end
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
				hasRenderedItem = true
			end

			ListSizeX = 0
			for Button, Table in next, Buttons do
				if Button.ButtonLabel then
					local textSize = Button.ButtonLabel.TextBounds.X
					if textSize > ListSizeX then
						ListSizeX = textSize
					end
				end
			end
			ListSizeX = math.max(150, ListSizeX + 40)

			RecalculateCanvasSize()
			RecalculateListSize()
		end

		function Dropdown:SetValues(NewValues)
			if NewValues then
				Dropdown.Values = NewValues
			end

			Dropdown:BuildDropdownList()
		end

		function Dropdown:OnChanged(Func)
			Dropdown.Changed = Func
			Func(Dropdown.Value)
		end

		function Dropdown:SetValue(Val)
			if Dropdown.Multi then
				local nTable = {}

				for Value, Bool in next, Val do
					if table.find(Dropdown.Values, Value) then
						nTable[Value] = true
					end
				end

				Dropdown.Value = nTable
			else
				if not Val then
					Dropdown.Value = nil
				elseif table.find(Dropdown.Values, Val) then
					Dropdown.Value = Val
				end
			end

			Dropdown:BuildDropdownList()

			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end

		function Dropdown:Destroy()
			DropdownFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Dropdown:BuildDropdownList()
		Dropdown:Display()

		local Defaults = {}

		if type(Config.Default) == "string" then
			local Idx = table.find(Dropdown.Values, Config.Default)
			if Idx then
				table.insert(Defaults, Idx)
			end
		elseif type(Config.Default) == "table" then
			for _, Value in next, Config.Default do
				local Idx = table.find(Dropdown.Values, Value)
				if Idx then
					table.insert(Defaults, Idx)
				end
			end
		elseif type(Config.Default) == "number" and Dropdown.Values[Config.Default] ~= nil then
			table.insert(Defaults, Config.Default)
		end

		if next(Defaults) then
			for i = 1, #Defaults do
				local Index = Defaults[i]
				if Config.Multi then
					Dropdown.Value[Dropdown.Values[Index]] = true
				else
					Dropdown.Value = Dropdown.Values[Index]
				end

				if not Config.Multi then
					break
				end
			end

			Dropdown:BuildDropdownList()
			Dropdown:Display()
		end

		Library.Options[Idx] = Dropdown
		return Dropdown
	end

	return Element
end)()
ElementsTable.Paragraph = (function()
	local Paragraph = {}
	Paragraph.__index = Paragraph
	Paragraph.__type = "Paragraph"
	Paragraph.NoIdx = true

	function Paragraph:New(Config)
		Config.Content = Config.Content or ""

		local Paragraph = Components.Element(Config.Title, Config.Content, Paragraph.Container, false, Config)
		Paragraph.Frame.BackgroundTransparency = 0.90
		Paragraph.Border.Transparency = 0.50

		Paragraph.SetTitle = Paragraph.SetTitle
		Paragraph.SetDesc = Paragraph.SetDesc
		Paragraph.Visible = Paragraph.Visible
		Paragraph.Elements = Paragraph

		return Paragraph
	end

	return Paragraph
end)()
ElementsTable.Slider = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Slider"

	function Element:New(Idx, Config)
		assert(Config.Title,                        "Slider - Missing Title.")
		assert(Config.Default   ~= nil,             "Slider - Missing default value.")
		assert(Config.Min       ~= nil,             "Slider - Missing minimum value.")
		assert(Config.Max       ~= nil,             "Slider - Missing maximum value.")
		-- Rounding เป็น optional — ถ้าไม่ส่งมาก็ default เป็น 0
		Config.Rounding = Config.Rounding ~= nil and Config.Rounding or 0

		local Slider = {
			Value = nil,
			Min = Config.Min,
			Max = Config.Max,
			Rounding = Config.Rounding,
			Callback = Config.Callback or function(Value) end,
			Type = "Slider",
		}

		local Dragging = false

		local SliderFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		SliderFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)

		Slider.Elements = SliderFrame
		Slider.SetTitle = SliderFrame.SetTitle
		Slider.SetDesc = SliderFrame.SetDesc
		Slider.Visible = SliderFrame.Visible

		local SliderDot = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(13, 13),
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			New("UIAspectRatioConstraint", { AspectRatio = 1 }),
			New("UIStroke", {
				Transparency = 0.55,
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = { Color = "AcrylicMain" },
			}),
		})

		local SliderRail = New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(6, 0),
			Size = UDim2.new(1, -12, 1, 0),
		}, {
			SliderDot,
		})

		local SliderFill = New("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			ThemeTag = {
				BackgroundColor3 = "Accent",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		})

		local SliderDisplay = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			Text = "Value",
			TextSize = 11,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 100, 0, 14),
			Position = UDim2.new(0, -4, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		local SliderInput = New("TextBox", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = "",
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.8,
			Size = UDim2.new(0, 0, 0, 14),
			Position = UDim2.new(0, -4, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			PlaceholderText = "Value",
			ClearTextOnFocus = false,
			Visible = true,
			TextWrapped = false,
			TextTransparency = 1,
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "SubText",
				BackgroundColor3 = "Element",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 1,
				Thickness = 1,
			}),
		})

		local SliderInner = New("Frame", {
			Size = UDim2.new(1, 0, 0, 7),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 0.45,
			Parent = SliderFrame.Frame,
			ThemeTag = {
				BackgroundColor3 = "SliderRail",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
			New("UISizeConstraint", {
				MaxSize = Vector2.new(150, math.huge),
			}),
			SliderDisplay,
			SliderInput,
			SliderFill,
			SliderRail,
		})

		local isHovering = false
		local inputVisible = false
		local currentWidthTween = nil

		local function calculateInputWidth(text)
			local textSize = game:GetService("TextService"):GetTextSize(
				text or "0",
				12,
				Enum.Font.SourceSans,
				Vector2.new(1000, 14)
			)
			local padding = 8
			local minWidth = 25
			local maxWidth = 80
			return math.max(minWidth, math.min(maxWidth, textSize.X + padding))
		end

		local function updateInputWidth(text, animate)
			if currentWidthTween then
				currentWidthTween:Cancel()
				currentWidthTween = nil
			end

			local targetWidth = calculateInputWidth(text)
			local currentWidth = SliderInput.Size.X.Offset

			if animate and math.abs(targetWidth - currentWidth) > 0.5 then
				currentWidthTween = TweenService:Create(SliderInput, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, targetWidth, 0, 14)
				})
				currentWidthTween:Play()
				currentWidthTween.Completed:Connect(function()
					currentWidthTween = nil
				end)
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

				local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

				TweenService:Create(SliderInput, tweenInfo, {
					TextTransparency = 0,
					BackgroundTransparency = 0.8
				}):Play()

				TweenService:Create(SliderInput.UIStroke, tweenInfo, {
					Transparency = 0.7
				}):Play()
			end
		end)

		Creator.AddSignal(SliderFrame.Frame.MouseLeave, function()
			isHovering = false
			if not SliderInput:IsFocused() and inputVisible then
				local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

				TweenService:Create(SliderInput, tweenInfo, {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play()

				TweenService:Create(SliderInput.UIStroke, tweenInfo, {
					Transparency = 1
				}):Play()

				task.wait(0.2)
				SliderDisplay.Visible = true
				inputVisible = false
			end
		end)

		Creator.AddSignal(SliderInput.Changed, function(property)
			if property == "Text" then
				local text = SliderInput.Text
				local cleanText = text:gsub("[^%d%.%-]", "")
				if cleanText:find("%-") and cleanText:find("%-") ~= 1 then
					cleanText = cleanText:gsub("%-", "")
				end
				local dotCount = 0
				cleanText = cleanText:gsub("%.", function()
					dotCount = dotCount + 1
					return dotCount == 1 and "." or ""
				end)

				if cleanText ~= text then
					SliderInput.Text = cleanText
					return
				end

				if inputVisible or SliderInput:IsFocused() then
					updateInputWidth(cleanText, true)
				end
			end
		end)

		Creator.AddSignal(SliderInput.FocusLost, function(enterPressed)
			local inputValue = tonumber(SliderInput.Text)
			if inputValue then
				Slider:SetValue(inputValue)
			else
				SliderInput.Text = tostring(Slider.Value)
				updateInputWidth(tostring(Slider.Value), true)
			end

			if not isHovering then
				local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

				TweenService:Create(SliderInput, tweenInfo, {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play()

				TweenService:Create(SliderInput.UIStroke, tweenInfo, {
					Transparency = 1
				}):Play()

				task.wait(0.2)
				SliderDisplay.Visible = true
				inputVisible = false
			end
		end)

		Creator.AddSignal(SliderInput.Focused, function()
			SliderInput.Text = tostring(Slider.Value)
			updateInputWidth(tostring(Slider.Value), false)
		end)

		Creator.AddSignal(SliderInput.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = false
			end
		end)

		Creator.AddSignal(SliderDot.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
			end
		end)

		Creator.AddSignal(SliderDot.InputEnded, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = false
			end
		end)

		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if Dragging then
				local position = nil
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					position = Input.Position
				elseif Input.UserInputType == Enum.UserInputType.Touch then
					position = Input.Position
				end

				if position then
					local SizeScale = math.clamp((position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
					Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
				end
			end
		end)

		Creator.AddSignal(SliderRail.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				local SizeScale = math.clamp((Input.Position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
				Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
			end
		end)

		Creator.AddSignal(SliderRail.InputEnded, function(Input)
			if Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = false
			end
		end)

		function Slider:OnChanged(Func)
			Slider.Changed = Func
			Func(Slider.Value)
		end

		function Slider:SetValue(Value)
			self.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Rounding)
			SliderDot.Position = UDim2.new((self.Value - Slider.Min) / (Slider.Max - Slider.Min), -7, 0.5, 0)
			SliderFill.Size = UDim2.fromScale((self.Value - Slider.Min) / (Slider.Max - Slider.Min), 1)
			SliderDisplay.Text = tostring(self.Value)

			if inputVisible or SliderInput:IsFocused() then
				SliderInput.Text = tostring(self.Value)
				updateInputWidth(tostring(self.Value), not SliderInput:IsFocused())
			end
			if not inputVisible and not SliderInput:IsFocused() then
				SliderInput.Text = tostring(self.Value)
			end

			Library:SafeCallback(Slider.Callback, self.Value)
			Library:SafeCallback(Slider.Changed, self.Value)
		end

		function Slider:Destroy()
			SliderFrame:Destroy()
			Library.Options[Idx] = nil
		end

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

		-- แปลง EnumItem → string ตั้งแต่ต้น
		local defaultKey = typeof(Config.Default) == "EnumItem" and Config.Default.Name or tostring(Config.Default)

		local Keybind = {
			Value = defaultKey,
			Toggled = false,
			Mode = Config.Mode or "Toggle",
			Type = "Keybind",
			Callback = Config.Callback or function(Value) end,
			ChangedCallback = Config.ChangedCallback or function(New) end,
		}

		local Picking = false

		local KeybindFrame = Components.Element(Config.Title, Config.Description, self.Container, true)

		Keybind.SetTitle = KeybindFrame.SetTitle
		Keybind.SetDesc = KeybindFrame.SetDesc
		Keybind.Visible = KeybindFrame.Visible
		Keybind.Elements = KeybindFrame

		local KeybindDisplayLabel = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			Text = defaultKey,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(0, 0, 0, 14),
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local KeybindDisplayFrame = New("TextButton", {
			Size = UDim2.fromOffset(0, 32),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88,
			Parent = KeybindFrame.Frame,
			AutomaticSize = Enum.AutomaticSize.X,
			ThemeTag = {
				BackgroundColor3 = "Keybind",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			New("UIStroke", {
				Transparency = 0.45,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "InElementBorder",
				},
			}),
			KeybindDisplayLabel,
		})

		function Keybind:GetState()
			if UserInputService:GetFocusedTextBox() and Keybind.Mode ~= "Always" then
				return false
			end

			if Keybind.Mode == "Always" then
				return true
			elseif Keybind.Mode == "Hold" then
				if Keybind.Value == "None" then
					return false
				end

				local Key = Keybind.Value

				if Key == "MouseLeft" or Key == "MouseRight" then
					return Key == "MouseLeft" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						or Key == "MouseRight"
						and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
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

			-- แปลง EnumItem → string ก่อน assign
			if typeof(Key) == "EnumItem" then Key = Key.Name end
			KeybindDisplayLabel.Text = tostring(Key)
			Keybind.Value = Key
			Keybind.Mode = Mode
		end

		function Keybind:OnClick(Callback)
			Keybind.Clicked = Callback
		end

		function Keybind:OnChanged(Callback)
			Keybind.Changed = Callback
			Callback(Keybind.Value)
		end

		function Keybind:DoClick()
			Library:SafeCallback(Keybind.Callback, Keybind.Toggled)
			Library:SafeCallback(Keybind.Clicked, Keybind.Toggled)
		end

		function Keybind:Destroy()
			KeybindFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(KeybindDisplayFrame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Picking = true
				KeybindDisplayLabel.Text = "..."

				wait(0.2)

				local Event
				Event = UserInputService.InputBegan:Connect(function(Input)
					local Key

					if Input.UserInputType == Enum.UserInputType.Keyboard then
						Key = Input.KeyCode.Name
					elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Key = "MouseLeft"
					elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
						Key = "MouseRight"
					end

					local EndedEvent
					EndedEvent = UserInputService.InputEnded:Connect(function(Input)
						if
							Input.KeyCode.Name == Key
							or Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1
							or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
						then
							Picking = false

							KeybindDisplayLabel.Text = Key
							Keybind.Value = Key

							Library:SafeCallback(Keybind.ChangedCallback, Input.KeyCode or Input.UserInputType)
							Library:SafeCallback(Keybind.Changed, Input.KeyCode or Input.UserInputType)

							Event:Disconnect()
							EndedEvent:Disconnect()
						end
					end)
				end)
			end
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if not Picking and not UserInputService:GetFocusedTextBox() then
				if Keybind.Mode == "Toggle" then
					local Key = Keybind.Value

					if Key == "MouseLeft" or Key == "MouseRight" then
						if
							Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1
							or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
						then
							Keybind.Toggled = not Keybind.Toggled
							Keybind:DoClick()
						end
					elseif Input.UserInputType == Enum.UserInputType.Keyboard then
						if Input.KeyCode.Name == Key then
							Keybind.Toggled = not Keybind.Toggled
							Keybind:DoClick()
						end
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

		local Colorpicker = {
			Value = Config.Default,
			Transparency = Config.Transparency or 0,
			Type = "Colorpicker",
			Title = type(Config.Title) == "string" and Config.Title or "Colorpicker",
			Callback = Config.Callback or function(Color) end,
		}

		function Colorpicker:SetHSVFromRGB(Color)
			local H, S, V = Color3.toHSV(Color)
			Colorpicker.Hue = H
			Colorpicker.Sat = S
			Colorpicker.Vib = V
		end

		Colorpicker:SetHSVFromRGB(Colorpicker.Value)

		local ColorpickerFrame = Components.Element(Config.Title, Config.Description, self.Container, true)

		Colorpicker.SetTitle = ColorpickerFrame.SetTitle
		Colorpicker.SetDesc = ColorpickerFrame.SetDesc
		Colorpicker.Visible = ColorpickerFrame.Visible
		Colorpicker.Elements = ColorpickerFrame

		local DisplayFrameColor = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Colorpicker.Value,
			Parent = ColorpickerFrame.Frame,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		})

		local DisplayFrame = New("ImageLabel", {
			Size = UDim2.fromOffset(26, 26),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Parent = ColorpickerFrame.Frame,
			Image = "http://www.roblox.com/asset/?id=14204231522",
			ImageTransparency = 0.45,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(40, 40),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			DisplayFrameColor,
		})

		local function CreateColorDialog()
			local Dialog = Components.Dialog:Create()
			Dialog.Title.Text = Colorpicker.Title
			Dialog.Root.Size = UDim2.fromOffset(430, 330)

			local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
			local Transparency = Colorpicker.Transparency

			local function CreateInput()
				local Box = Components.Textbox()
				Box.Frame.Parent = Dialog.Root
				Box.Frame.Size = UDim2.new(0, 90, 0, 32)

				return Box
			end

			local function CreateInputLabel(Text, Pos)
				return New("TextLabel", {
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					),
					Text = Text,
					TextColor3 = Color3.fromRGB(240, 240, 240),
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 32),
					Position = Pos,
					BackgroundTransparency = 1,
					Parent = Dialog.Root,
					ThemeTag = {
						TextColor3 = "Text",
					},
				})
			end

			local function GetRGB()
				local Value = Color3.fromHSV(Hue, Sat, Vib)
				return { R = math.floor(Value.r * 255), G = math.floor(Value.g * 255), B = math.floor(Value.b * 255) }
			end

			local SatCursor = New("ImageLabel", {
				Size = UDim2.new(0, 18, 0, 18),
				ScaleType = Enum.ScaleType.Fit,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=4805639000",
			})

			local SatVibMap = New("ImageLabel", {
				Size = UDim2.fromOffset(180, 160),
				Position = UDim2.fromOffset(20, 55),
				Image = "rbxassetid://4155801252",
				BackgroundColor3 = Colorpicker.Value,
				BackgroundTransparency = 0,
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),
				SatCursor,
			})

			local OldColorFrame = New("Frame", {
				BackgroundColor3 = Colorpicker.Value,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = Colorpicker.Transparency,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),
			})
			local OldColorFrameChecker = New("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=14204231522",
				ImageTransparency = 0.45,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(40, 40),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(112, 220),
				Size = UDim2.fromOffset(88, 24),
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),
				New("UIStroke", {
					Thickness = 2,
					Transparency = 0.75,
				}),
				OldColorFrame,
			})

			local DialogDisplayFrame = New("Frame", {
				BackgroundColor3 = Colorpicker.Value,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 0,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),
			})

			local DialogDisplayFrameChecker = New("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=14204231522",
				ImageTransparency = 0.45,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(40, 40),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(20, 220),
				Size = UDim2.fromOffset(88, 24),
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),
				New("UIStroke", {
					Thickness = 2,
					Transparency = 0.75,
				}),
				DialogDisplayFrame,
			})

			local SequenceTable = {}

			for Color = 0, 1, 0.1 do
				table.insert(SequenceTable, ColorSequenceKeypoint.new(Color, Color3.fromHSV(Color, 1, 1)))
			end

			local HueSliderGradient = New("UIGradient", {
				Color = ColorSequence.new(SequenceTable),
				Rotation = 90,
			})

			local HueDragHolder = New("Frame", {
				Size = UDim2.new(1, 0, 1, -10),
				Position = UDim2.fromOffset(0, 5),
				BackgroundTransparency = 1,
			})

			local HueDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(14, 14),
				Image = "http://www.roblox.com/asset/?id=12266946128",
				Parent = HueDragHolder,
				ThemeTag = {
					ImageColor3 = "DialogInput",
				},
			})

			local HueSlider = New("Frame", {
				Size = UDim2.fromOffset(12, 190),
				Position = UDim2.fromOffset(210, 55),
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
				HueSliderGradient,
				HueDragHolder,
			})

			local HexInput = CreateInput()
			HexInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 55)
			CreateInputLabel("Hex", UDim2.fromOffset(Config.Transparency and 360 or 340, 55))

			local RedInput = CreateInput()
			RedInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 95)
			CreateInputLabel("Red", UDim2.fromOffset(Config.Transparency and 360 or 340, 95))

			local GreenInput = CreateInput()
			GreenInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 135)
			CreateInputLabel("Green", UDim2.fromOffset(Config.Transparency and 360 or 340, 135))

			local BlueInput = CreateInput()
			BlueInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 175)
			CreateInputLabel("Blue", UDim2.fromOffset(Config.Transparency and 360 or 340, 175))

			local AlphaInput
			if Config.Transparency then
				AlphaInput = CreateInput()
				AlphaInput.Frame.Position = UDim2.fromOffset(260, 215)
				CreateInputLabel("Alpha", UDim2.fromOffset(360, 215))
			end

			local TransparencySlider, TransparencyDrag, TransparencyColor
			if Config.Transparency then
				local TransparencyDragHolder = New("Frame", {
					Size = UDim2.new(1, 0, 1, -10),
					Position = UDim2.fromOffset(0, 5),
					BackgroundTransparency = 1,
				})

				TransparencyDrag = New("ImageLabel", {
					Size = UDim2.fromOffset(14, 14),
					Image = "http://www.roblox.com/asset/?id=12266946128",
					Parent = TransparencyDragHolder,
					ThemeTag = {
						ImageColor3 = "DialogInput",
					},
				})

				TransparencyColor = New("Frame", {
					Size = UDim2.fromScale(1, 1),
				}, {
					New("UIGradient", {
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(1, 1),
						}),
						Rotation = 270,
					}),
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				})

				TransparencySlider = New("Frame", {
					Size = UDim2.fromOffset(12, 190),
					Position = UDim2.fromOffset(230, 55),
					Parent = Dialog.Root,
					BackgroundTransparency = 1,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
					New("ImageLabel", {
						Image = "http://www.roblox.com/asset/?id=14204231522",
						ImageTransparency = 0.45,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = UDim2.fromOffset(40, 40),
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						Parent = Dialog.Root,
					}, {
						New("UICorner", {
							CornerRadius = UDim.new(1, 0),
						}),
					}),
					TransparencyColor,
					TransparencyDragHolder,
				})
			end

			local function Display()
				SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
				HueDrag.Position = UDim2.new(0, -1, Hue, -6)
				SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)
				DialogDisplayFrame.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)

				HexInput.Input.Text = "#" .. Color3.fromHSV(Hue, Sat, Vib):ToHex()
				RedInput.Input.Text = GetRGB()["R"]
				GreenInput.Input.Text = GetRGB()["G"]
				BlueInput.Input.Text = GetRGB()["B"]

				if Config.Transparency then
					TransparencyColor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
					DialogDisplayFrame.BackgroundTransparency = Transparency
					TransparencyDrag.Position = UDim2.new(0, -1, 1 - Transparency, -6)
					AlphaInput.Input.Text = Library:Round((1 - Transparency) * 100, 0) .. "%"
				end
			end

			Creator.AddSignal(HexInput.Input.FocusLost, function(Enter)
				if Enter then
					local Success, Result = pcall(Color3.fromHex, HexInput.Input.Text)
					if Success and typeof(Result) == "Color3" then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
				Display()
			end)

			Creator.AddSignal(RedInput.Input.FocusLost, function(Enter)
				if Enter then
					local CurrentColor = GetRGB()
					local Success, Result = pcall(Color3.fromRGB, RedInput.Input.Text, CurrentColor["G"], CurrentColor["B"])
					if Success and typeof(Result) == "Color3" then
						if tonumber(RedInput.Input.Text) <= 255 then
							Hue, Sat, Vib = Color3.toHSV(Result)
						end
					end
				end
				Display()
			end)

			Creator.AddSignal(GreenInput.Input.FocusLost, function(Enter)
				if Enter then
					local CurrentColor = GetRGB()
					local Success, Result =
						pcall(Color3.fromRGB, CurrentColor["R"], GreenInput.Input.Text, CurrentColor["B"])
					if Success and typeof(Result) == "Color3" then
						if tonumber(GreenInput.Input.Text) <= 255 then
							Hue, Sat, Vib = Color3.toHSV(Result)
						end
					end
				end
				Display()
			end)

			Creator.AddSignal(BlueInput.Input.FocusLost, function(Enter)
				if Enter then
					local CurrentColor = GetRGB()
					local Success, Result =
						pcall(Color3.fromRGB, CurrentColor["R"], CurrentColor["G"], BlueInput.Input.Text)
					if Success and typeof(Result) == "Color3" then
						if tonumber(BlueInput.Input.Text) <= 255 then
							Hue, Sat, Vib = Color3.toHSV(Result)
						end
					end
				end
				Display()
			end)

			if Config.Transparency then
				Creator.AddSignal(AlphaInput.Input.FocusLost, function(Enter)
					if Enter then
						pcall(function()
							local Value = tonumber(AlphaInput.Input.Text)
							if Value >= 0 and Value <= 100 then
								Transparency = 1 - Value * 0.01
							end
						end)
					end
					Display()
				end)
			end

			Creator.AddSignal(SatVibMap.InputBegan, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinX = SatVibMap.AbsolutePosition.X
						local MaxX = MinX + SatVibMap.AbsoluteSize.X
						local MouseX = math.clamp(Mouse.X, MinX, MaxX)

						local MinY = SatVibMap.AbsolutePosition.Y
						local MaxY = MinY + SatVibMap.AbsoluteSize.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

						Sat = (MouseX - MinX) / (MaxX - MinX)
						Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			Creator.AddSignal(HueSlider.InputBegan, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinY = HueSlider.AbsolutePosition.Y
						local MaxY = MinY + HueSlider.AbsoluteSize.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

						Hue = ((MouseY - MinY) / (MaxY - MinY))
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			if Config.Transparency then
				Creator.AddSignal(TransparencySlider.InputBegan, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local MinY = TransparencySlider.AbsolutePosition.Y
							local MaxY = MinY + TransparencySlider.AbsoluteSize.Y
							local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

							Transparency = 1 - ((MouseY - MinY) / (MaxY - MinY))
							Display()

							RenderStepped:Wait()
						end
					end
				end)
			end

			Display()

			Dialog:Button("Done", function()
				Colorpicker:SetValue({ Hue, Sat, Vib }, Transparency)
			end)
			Dialog:Button("Cancel")
			Dialog:Open()
		end

		function Colorpicker:Display()
			Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)

			DisplayFrameColor.BackgroundColor3 = Colorpicker.Value
			DisplayFrameColor.BackgroundTransparency = Colorpicker.Transparency

			Element.Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
			Element.Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
		end

		function Colorpicker:SetValue(HSV, Transparency)
			local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

			Colorpicker.Transparency = Transparency or 0
			Colorpicker:SetHSVFromRGB(Color)
			Colorpicker:Display()
		end

		function Colorpicker:SetValueRGB(Color, Transparency)
			Colorpicker.Transparency = Transparency or 0
			Colorpicker:SetHSVFromRGB(Color)
			Colorpicker:Display()
		end

		function Colorpicker:OnChanged(Func)
			Colorpicker.Changed = Func
			Func(Colorpicker.Value)
		end

		function Colorpicker:Destroy()
			ColorpickerFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(ColorpickerFrame.Frame.MouseButton1Click, function()
			CreateColorDialog()
		end)

		Creator.AddSignal(ColorpickerFrame.Frame.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.Touch then
				CreateColorDialog()
			end
		end)

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

		local Input = {
			Value = Config.Default or "",
			Numeric = Config.Numeric or false,
			Finished = Config.Finished or false,
			Callback = Config.Callback or function(Value) end,
			Type = "Input",
		}

		local InputFrame = Components.Element(Config.Title, Config.Description, self.Container, false)

		Input.SetTitle = InputFrame.SetTitle
		Input.SetDesc = InputFrame.SetDesc
		Input.Visible = InputFrame.Visible
		Input.Elements = InputFrame

		local Textbox = Components.Textbox(InputFrame.Frame, true)
		Textbox.Frame.Position = UDim2.new(1, -10, 0.5, 0)
		Textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
		Textbox.Frame.Size = UDim2.fromOffset(160, 32)
		Textbox.Input.Text = Config.Default or ""
		Textbox.Input.PlaceholderText = Config.Placeholder or ""

		local Box = Textbox.Input

		function Input:SetValue(Text)
			if Config.MaxLength and #Text > Config.MaxLength then
				Text = Text:sub(1, Config.MaxLength)
			end

			if Input.Numeric then
				if (not tonumber(Text)) and Text:len() > 0 then
					Text = Input.Value
				end
			end

			Input.Value = Text
			Box.Text = Text

			Library:SafeCallback(Input.Callback, Input.Value)
			Library:SafeCallback(Input.Changed, Input.Value)
		end

		if Input.Finished then
			AddSignal(Box.FocusLost, function(enter)
				if not enter then
					return
				end
				Input:SetValue(Box.Text)
			end)
		else
			AddSignal(Box:GetPropertyChangedSignal("Text"), function()
				Input:SetValue(Box.Text)
			end)
		end

		function Input:OnChanged(Func)
			Input.Changed = Func
			Func(Input.Value)
		end

		function Input:Destroy()
			InputFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Library.Options[Idx] = Input
		return Input
	end

	return Element
end)()

ElementsTable.MiniBar = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "MiniBar"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "MiniBar - Missing Title")
		Config.Min     = Config.Min     or 0
		Config.Max     = Config.Max     or 100
		Config.Default = Config.Default or 0
		Config.Color   = Config.Color   or nil

		local Bar = {
			Value    = Config.Default,
			Min      = Config.Min,
			Max      = Config.Max,
			Type     = "MiniBar",
			Callback = Config.Callback or function() end,
		}

		local BarFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		Bar.SetTitle = BarFrame.SetTitle
		Bar.SetDesc  = BarFrame.SetDesc
		Bar.Visible  = BarFrame.Visible
		Bar.Elements = BarFrame

		-- Label เปอร์เซ็นต์ ชิดขวาสุด
		local PctLabel = New("TextLabel", {
			Text             = "0%",
			FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			TextSize         = 12,
			AnchorPoint      = Vector2.new(1, 0.5),
			Position         = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 1,
			Size             = UDim2.fromOffset(36, 16),
			TextXAlignment   = Enum.TextXAlignment.Right,
			Parent           = BarFrame.Frame,
			ThemeTag         = { TextColor3 = "SubText" },
		})

		-- Track อยู่ซ้ายของ label เหมือน Slider
		local Track = New("Frame", {
			AnchorPoint          = Vector2.new(1, 0.5),
			Position             = UDim2.new(1, -50, 0.5, 0),
			Size                 = UDim2.new(1, 0, 0, 6),
			BackgroundTransparency = 0.5,
			Parent               = BarFrame.Frame,
			ThemeTag             = { BackgroundColor3 = "SliderRail" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			New("UISizeConstraint", { MaxSize = Vector2.new(150, math.huge) }),
		})

		-- Fill bar
		local Fill = New("Frame", {
			Size             = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Config.Color or Color3.fromRGB(96, 205, 255),
			Parent           = Track,
			ThemeTag         = Config.Color and {} or { BackgroundColor3 = "Accent" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.1),
					NumberSequenceKeypoint.new(0.6, 0),
					NumberSequenceKeypoint.new(1, 0.15),
				}),
			}),
		})

		function Bar:SetValue(Value)
			Value = math.clamp(Value, self.Min, self.Max)
			self.Value = Value
			local pct = (Value - self.Min) / math.max(self.Max - self.Min, 1)
			TweenService:Create(Fill, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(pct, 0, 1, 0)
			}):Play()
			PctLabel.Text = math.floor(pct * 100) .. "%"
			Library:SafeCallback(Bar.Callback, Value)
			Library:SafeCallback(Bar.Changed,  Value)
		end

		function Bar:OnChanged(Func) Bar.Changed = Func Func(Bar.Value) end
		function Bar:Destroy() BarFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		Bar:SetValue(Config.Default)
		if Idx then Library.Options[Idx] = Bar end
		return Bar
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

		local Root = New("Frame", {
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			Parent = self.Container,
			LayoutOrder = 7,
		})

		if Config.Label ~= "" then
			New("TextLabel", {
				Text = Config.Label,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
				TextSize = 11,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 14),
				AutomaticSize = Enum.AutomaticSize.X,
				Parent = Root,
				ThemeTag = { TextColor3 = "SubText" },
			})
		end

		local lineL = New("Frame", {
			Size = UDim2.new(0.5, Config.Label ~= "" and -10 or 0, 0, 1),
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			Parent = Root,
			BackgroundTransparency = 0.6,
			ThemeTag = { BackgroundColor3 = "TitleBarLine" },
		}, { New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }) }) })

		local lineR = New("Frame", {
			Size = UDim2.new(0.5, Config.Label ~= "" and -10 or 0, 0, 1),
			Position = UDim2.fromScale(1, 0.5),
			AnchorPoint = Vector2.new(1, 0.5),
			Parent = Root,
			BackgroundTransparency = 0.6,
			ThemeTag = { BackgroundColor3 = "TitleBarLine" },
		}, { New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) }) })

		function Sep:Destroy() Root:Destroy() if Idx then Library.Options[Idx] = nil end end
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
		info    = { bg = Color3.fromRGB(30, 80, 160),    icon = "rbxassetid://10723415903" },
		success = { bg = Color3.fromRGB(30, 130, 80),    icon = "rbxassetid://10709751939" },
		warning = { bg = Color3.fromRGB(160, 110, 20),   icon = "rbxassetid://10709753149" },
		error   = { bg = Color3.fromRGB(160, 35, 35),    icon = "rbxassetid://10709752996" },
	}

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Alert - Missing Title")
		Config.Type = Config.Type or "info"
		Config.Content = Config.Content or ""

		local Alert = { Type = "Alert" }
		local style = AlertColors[Config.Type] or AlertColors.info

		local Root = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = style.bg,
			BackgroundTransparency = 0.75,
			Parent = self.Container,
			LayoutOrder = 7,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 6) }),
			New("UIStroke", { Color = style.bg, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
			New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) }),
			New("UIListLayout", { Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Top }),
			New("ImageLabel", {
				Image = style.icon,
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				LayoutOrder = 1,
			}),
			New("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -22, 0, 0),
				LayoutOrder = 2,
			}, {
				New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
				New("TextLabel", {
					Text = Config.Title,
					FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
					TextSize = 13,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 16),
					LayoutOrder = 1,
				}),
				New("TextLabel", {
					Text = Config.Content,
					FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
					TextSize = 12,
					TextColor3 = Color3.fromRGB(220, 220, 220),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 2,
					Visible = Config.Content ~= "",
				}),
			}),
		})

		function Alert:Destroy() Root:Destroy() if Idx then Library.Options[Idx] = nil end end
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

		local Checkbox = {
			Value = Config.Default or false,
			Type = "Checkbox",
			Callback = Config.Callback or function() end,
		}

		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		Checkbox.SetTitle = CBFrame.SetTitle
		Checkbox.SetDesc = CBFrame.SetDesc
		Checkbox.Visible = CBFrame.Visible
		Checkbox.Elements = CBFrame

		local CheckBg = New("Frame", {
			Size = UDim2.fromOffset(20, 20),
			Position = UDim2.new(1, -12, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88,
			Parent = CBFrame.Frame,
			ThemeTag = { BackgroundColor3 = "Accent" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 6) }),
			New("UIStroke", {
				Transparency = 0.35,
				Thickness = 1.5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = { Color = "Accent" },
			}),
		})

		local CheckMark = New("ImageLabel", {
			Image = "rbxassetid://10734966248",
			Size = UDim2.fromOffset(11, 11),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ImageTransparency = 1,
			Parent = CheckBg,
		})

		local function UpdateVisual(val)
			local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			TweenService:Create(CheckBg, ti, {
				BackgroundTransparency = val and 0.05 or 0.88,
			}):Play()
			TweenService:Create(CheckMark, ti, {
				ImageTransparency = val and 0 or 1,
				Size = val and UDim2.fromOffset(13, 13) or UDim2.fromOffset(7, 7),
			}):Play()
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
		function Checkbox:OnChanged(Func) Checkbox.Changed = Func Func(Checkbox.Value) end
		function Checkbox:Destroy() CBFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

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

		local OptionsHolder = New("Frame", {
			Size = UDim2.new(1, -20, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Parent = RGFrame.LabelHolder,
			LayoutOrder = 3,
		}, {
			New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
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

				local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				TweenService:Create(btn.Outer, ti, {
					BackgroundTransparency = isSelected and 0.05 or 0.88,
					Size = isSelected and UDim2.fromOffset(18, 18) or UDim2.fromOffset(16, 16),
				}):Play()
				TweenService:Create(btn.Inner, ti, {
					BackgroundTransparency = isSelected and 0 or 1,
					Size = isSelected and UDim2.fromOffset(9, 9) or UDim2.fromOffset(5, 5),
				}):Play()
			end
		end

		for _, opt in ipairs(Config.Options) do
			local Row = New("TextButton", {
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = 1,
				Text = "",
				Parent = OptionsHolder,
			}, {
				New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 8),
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
			})

			-- (เพิ่มเติม: ถ้าเป็น Multi จะเปลี่ยนปุ่มเป็นสี่เหลี่ยมแบบ Checkbox แทนวงกลมก็ได้นะ ลองแก้ CornerRadius ดู)
			local Outer = New("Frame", {
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 0.9,
				Parent = Row,
				ThemeTag = { BackgroundColor3 = "Accent" },
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }),
				New("UIAspectRatioConstraint", { AspectRatio = 1 }),
				New("UIStroke", { Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "Accent" } }),
			})

			local Inner = New("Frame", {
				Size = UDim2.fromOffset(4, 4),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Parent = Outer,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			})

			New("TextLabel", {
				Text = tostring(opt),
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -24, 1, 0),
				Parent = Row,
				ThemeTag = { TextColor3 = "Text" },
			})

			local BtnData = { Value = opt, Outer = Outer, Inner = Inner }
			table.insert(Buttons, BtnData)

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

ElementsTable.NumberInput = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "NumberInput"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "NumberInput - Missing Title")
		Config.Default = Config.Default or 0
		Config.Step = Config.Step or 1
		Config.Min = Config.Min or -math.huge
		Config.Max = Config.Max or math.huge

		local NI = {
			Value = Config.Default,
			Step = Config.Step,
			Min = Config.Min,
			Max = Config.Max,
			Type = "NumberInput",
			Callback = Config.Callback or function() end,
		}

		local NIFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		NI.SetTitle = NIFrame.SetTitle
		NI.SetDesc = NIFrame.SetDesc
		NI.Visible = NIFrame.Visible
		NI.Elements = NIFrame

		local Holder = New("Frame", {
			Size = UDim2.fromOffset(110, 30),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.9,
			Parent = NIFrame.Frame,
			ThemeTag = { BackgroundColor3 = "Element" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 6) }),
			New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
		})

		local makeBtn = function(txt, side)
			return New("TextButton", {
				Text = txt,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
				TextSize = 16,
				Size = UDim2.fromOffset(28, 28),
				Position = side == "L" and UDim2.fromOffset(1, 1) or UDim2.new(1, -29, 0, 1),
				BackgroundTransparency = 1,
				Parent = Holder,
				ThemeTag = { TextColor3 = "Text" },
			})
		end

		local MinusBtn = makeBtn("−", "L")
		local PlusBtn  = makeBtn("+", "R")

		local ValBox = New("TextBox", {
			Text = tostring(Config.Default),
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			TextSize = 13,
			Size = UDim2.new(1, -58, 1, 0),
			Position = UDim2.fromOffset(30, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = Holder,
			ThemeTag = { TextColor3 = "Text" },
		})

		local function set(v)
			v = math.clamp(Library:Round(v, 0), NI.Min, NI.Max)
			NI.Value = v
			ValBox.Text = tostring(v)
			Library:SafeCallback(NI.Callback, v)
			Library:SafeCallback(NI.Changed, v)
		end

		Creator.AddSignal(MinusBtn.MouseButton1Click, function() set(NI.Value - NI.Step) end)
		Creator.AddSignal(PlusBtn.MouseButton1Click,  function() set(NI.Value + NI.Step) end)
		Creator.AddSignal(ValBox.FocusLost, function()
			local n = tonumber(ValBox.Text)
			if n then set(n) else ValBox.Text = tostring(NI.Value) end
		end)

		-- Hold to repeat
		for _, btn in ipairs({ {MinusBtn, -1}, {PlusBtn, 1} }) do
			local b, dir = btn[1], btn[2]
			Creator.AddSignal(b.MouseButton1Down, function()
				task.delay(0.5, function()
					while b:IsDescendantOf(game) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						set(NI.Value + NI.Step * dir)
						task.wait(0.08)
					end
				end)
			end)
		end

		function NI:SetValue(v) set(v) end
		function NI:OnChanged(Func) NI.Changed = Func Func(NI.Value) end
		function NI:Destroy() NIFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		if Idx then Library.Options[Idx] = NI end
		return NI
	end
	return Element
end)()

ElementsTable.CopyButton = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "CopyButton"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "CopyButton - Missing Title")
		Config.CopyText = Config.CopyText or ""

		local CB = { Type = "CopyButton", Value = Config.CopyText }

		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		CB.SetTitle = CBFrame.SetTitle
		CB.SetDesc = CBFrame.SetDesc
		CB.Visible = CBFrame.Visible
		CB.Elements = CBFrame

		local CopyBtn = New("TextButton", {
			Text = "Copy",
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			TextSize = 12,
			Size = UDim2.fromOffset(60, 26),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.85,
			Parent = CBFrame.Frame,
			ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 5) }),
			New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "Accent" } }),
		})

		Creator.AddSignal(CopyBtn.MouseButton1Click, function()
			pcall(function()
				if setclipboard then setclipboard(CB.Value)
				elseif toclipboard then toclipboard(CB.Value) end
			end)
			CopyBtn.Text = "✓ Copied"
			task.delay(1.5, function()
				if CopyBtn and CopyBtn.Parent then
					CopyBtn.Text = "Copy"
				end
			end)
			Library:SafeCallback(Config.Callback, CB.Value)
		end)

		function CB:SetCopyText(t) self.Value = t end
		function CB:Destroy() CBFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

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
		QA.SetTitle = QAFrame.SetTitle
		QA.SetDesc  = QAFrame.SetDesc
		QA.Visible  = QAFrame.Visible
		QA.Elements = QAFrame

		local ActionsHolder = New("Frame", {
			Size = UDim2.fromOffset(0, 30),
			AutomaticSize = Enum.AutomaticSize.X,
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent = QAFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 4),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),
		})

		for _, action in ipairs(Config.Actions) do
			local iconImg = action.Icon and Library:GetIcon(action.Icon) or action.Image or ""

			local Btn = New("TextButton", {
				Size = UDim2.fromOffset(30, 30),
				BackgroundTransparency = 0.88,
				Text = action.Icon and "" or (action.Text or ""),
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
				TextSize = 11,
				Parent = ActionsHolder,
				ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" },
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 6) }),
				New("UIStroke", { Transparency = 0.6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
				iconImg ~= "" and New("ImageLabel", {
					Image = iconImg,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ThemeTag = { ImageColor3 = "Text" },
				}) or nil,
			})

			local Motor, SetT = Creator.SpringMotor(0.88, Btn, "BackgroundTransparency")
			Creator.AddSignal(Btn.MouseEnter, function() SetT(0.75) end)
			Creator.AddSignal(Btn.MouseLeave, function() SetT(0.88) end)
			Creator.AddSignal(Btn.MouseButton1Down, function() SetT(0.95) end)
			Creator.AddSignal(Btn.MouseButton1Up, function() SetT(0.75) end)
			Creator.AddSignal(Btn.MouseButton1Click, function()
				Library:SafeCallback(action.Callback)
			end)
		end

		function QA:Destroy() QAFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = QA end
		return QA
	end
	return Element
end)()

ElementsTable.Timer = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Timer"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "Timer - Missing Title")
		Config.CountDown = Config.CountDown or false
		Config.StartValue = Config.StartValue or (Config.CountDown and 60 or 0)

		local Tim = {
			Type = "Timer",
			Running = false,
			Value = Config.StartValue,
			CountDown = Config.CountDown,
			Callback = Config.Callback or function() end,
		}

		local TFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		Tim.SetTitle = TFrame.SetTitle
		Tim.SetDesc  = TFrame.SetDesc
		Tim.Visible  = TFrame.Visible
		Tim.Elements = TFrame

		local function fmtTime(s)
			s = math.floor(math.abs(s))
			return string.format("%02d:%02d", math.floor(s / 60), s % 60)
		end

		local TimeLabel = New("TextLabel", {
			Text = fmtTime(Config.StartValue),
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
			TextSize = 18,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(60, 22),
			Position = UDim2.new(1, -120, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = TFrame.Frame,
			ThemeTag = { TextColor3 = "Accent" },
		})

		local BtnHolder = New("Frame", {
			Size = UDim2.fromOffset(52, 30),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent = TFrame.Frame,
		}, {
			New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Center }),
		})

		local function makeSmallBtn(txt)
			return New("TextButton", {
				Text = txt,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
				TextSize = 12,
				Size = UDim2.fromOffset(24, 24),
				BackgroundTransparency = 0.85,
				Parent = BtnHolder,
				ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" },
			}, { New("UICorner", { CornerRadius = UDim.new(0, 4) }) })
		end

		local PlayBtn  = makeSmallBtn("▶")
		local ResetBtn = makeSmallBtn("↺")

		local tickConn
		local function stopTick()
			if tickConn then tickConn:Disconnect() tickConn = nil end
		end
		local function startTick()
			stopTick()
			tickConn = RunService.Heartbeat:Connect(function(dt)
				if Tim.Running then
					Tim.Value = Tim.Value + (Tim.CountDown and -dt or dt)
					TimeLabel.Text = fmtTime(Tim.Value)
					Library:SafeCallback(Tim.Callback, Tim.Value)
					if Tim.CountDown and Tim.Value <= 0 then
						Tim.Value = 0
						Tim.Running = false
						PlayBtn.Text = "▶"
						stopTick()
						Library:SafeCallback(Config.OnEnd)
					end
				end
			end)
		end

		Creator.AddSignal(PlayBtn.MouseButton1Click, function()
			Tim.Running = not Tim.Running
			PlayBtn.Text = Tim.Running and "⏸" or "▶"
			if Tim.Running then startTick() else stopTick() end
		end)

		Creator.AddSignal(ResetBtn.MouseButton1Click, function()
			Tim.Running = false
			PlayBtn.Text = "▶"
			stopTick()
			Tim.Value = Config.StartValue
			TimeLabel.Text = fmtTime(Config.StartValue)
		end)

		function Tim:Destroy() stopTick() TFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = Tim end
		return Tim
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
		BG.SetTitle = BGFrame.SetTitle
		BG.SetDesc  = BGFrame.SetDesc
		BG.Visible  = BGFrame.Visible
		BG.Elements = BGFrame

		local BtnRow = New("Frame", {
			Size = UDim2.fromOffset(0, 28),
			AutomaticSize = Enum.AutomaticSize.X,
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent = BGFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 0),
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		})

		for i, btn in ipairs(Config.Buttons) do
			local isFirst = i == 1
			local isLast  = i == #Config.Buttons

			local B = New("TextButton", {
				Text = btn.Text or "Button",
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
				TextSize = 12,
				Size = UDim2.fromOffset(0, 28),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 0.85,
				Parent = BtnRow,
				ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" },
			}, {
				New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
			})

			local Motor, SetT = Creator.SpringMotor(0.85, B, "BackgroundTransparency")
			Creator.AddSignal(B.MouseEnter, function() SetT(0.72) end)
			Creator.AddSignal(B.MouseLeave, function() SetT(0.85) end)
			Creator.AddSignal(B.MouseButton1Down, function() SetT(0.95) end)
			Creator.AddSignal(B.MouseButton1Up, function() SetT(0.72) end)
			Creator.AddSignal(B.MouseButton1Click, function()
				Library:SafeCallback(btn.Callback)
			end)
		end

		function BG:Destroy() BGFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = BG end
		return BG
	end
	return Element
end)()

ElementsTable.Divider = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "Divider"

	function Element:New(Idx, Config)
		Config = Config or {}
		local DV = { Type = "Divider" }

		local divH = Config.Height or 1
		local Root = New("Frame", {
			Size = UDim2.new(1, 0, 0, divH + (Config.Label and 20 or 0)),
			BackgroundTransparency = 1,
			Parent = self.Container,
			LayoutOrder = 7,
		})

		local Line = New("Frame", {
			Size = UDim2.new(1, -24, 0, divH),
			Position = UDim2.new(0, 12, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 0.55,
			Parent = Root,
			ThemeTag = { BackgroundColor3 = "InElementBorder" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			-- fade ขอบซ้าย-ขวาเสมอ
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.15, 0),
					NumberSequenceKeypoint.new(0.85, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		})

		if Config.Label and Config.Label ~= "" then
			local LabelBg = New("Frame", {
				Size = UDim2.fromOffset(0, 18),
				AutomaticSize = Enum.AutomaticSize.X,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 0.88,
				Parent = Root,
				ThemeTag = { BackgroundColor3 = "Element" },
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
				New("TextLabel", {
					Text = Config.Label,
					FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
					TextSize = 10,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(0, 18),
					AutomaticSize = Enum.AutomaticSize.X,
					TextXAlignment = Enum.TextXAlignment.Center,
					ThemeTag = { TextColor3 = "SubText" },
				}),
			})
		end

		function DV:Destroy() Root:Destroy() if Idx then Library.Options[Idx] = nil end end
		if Idx then Library.Options[Idx] = DV end
		return DV
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

		-- ฟังก์ชันอัปเดตสถานะปุ่ม (เพิ่ม Animation ให้ตัวหนังสือและขอบ)
		local function updateChip(item, btn)
			local active = table.find(CH.Value, item) ~= nil
			local stroke = btn:FindFirstChildOfClass("UIStroke")

			-- อนิเมชันพื้นหลังและตัวหนังสือ
			TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = active and 0.15 or 0.92, -- กดแล้วสว่าง, ไม่กดจะจางๆ
				TextTransparency = active and 0 or 0.4 -- กดแล้วข้อความชัด 100%, ไม่กดข้อความจะดรอปลงนิดนึง
			}):Play()

			-- อนิเมชันขอบ (Stroke)
			if stroke then
				TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = active and 0.15 or 0.85
				}):Play()
			end
		end

		for _, item in ipairs(Config.Items) do
			local chip = New("TextButton", {
				Text = tostring(item),
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium), -- เปลี่ยนเป็น Medium ให้อ่านง่ายและคลีนขึ้น
				TextSize = 12, -- ขยายตัวอักษรขึ้นนิดนึง (จาก 11)
				Size = UDim2.fromOffset(0, 28), -- เพิ่มความสูงปุ่มให้อักษรอยู่ตรงกลางสวยๆ
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 0.92,
				TextXAlignment = Enum.TextXAlignment.Center, -- จัดกึ่งกลางแนวนอน
				TextYAlignment = Enum.TextYAlignment.Center, -- จัดกึ่งกลางแนวตั้ง
				Parent = ChipRow,
				ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }), -- ขอบมนแบบเม็ดยา (Pill shape)
				New("UIStroke", { Transparency = 0.85, Thickness = 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "Accent" } }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }), -- เพิ่มพื้นที่หายใจซ้ายขวา
			})

			ChipBtns[item] = chip
			updateChip(item, chip)

			Creator.AddSignal(chip.MouseButton1Click, function()
				local idx = table.find(CH.Value, item)
				if idx then
					table.remove(CH.Value, idx)
				else
					if not Config.Multi then CH.Value = {} end
					table.insert(CH.Value, item)
				end
				for it, btn in pairs(ChipBtns) do
					updateChip(it, btn)
				end
				Library:SafeCallback(CH.Callback, CH.Value)
				Library:SafeCallback(CH.Changed, CH.Value)
			end)
		end

		function CH:SetValue(v)
			self.Value = v
			for it, btn in pairs(ChipBtns) do updateChip(it, btn) end
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

-- END OF 30 NEW ELEMENTS

ElementsTable.StatusIndicator = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "StatusIndicator"

	local StatusColors = {
		online  = Color3.fromRGB(0,  200, 100),
		offline = Color3.fromRGB(120, 120, 120),
		running = Color3.fromRGB(96,  205, 255),
		stopped = Color3.fromRGB(255, 80,  80),
		warning = Color3.fromRGB(255, 200, 50),
	}

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "StatusIndicator - Missing Title")
		Config.Status = Config.Status or "offline"
		Config.Label  = Config.Label  or Config.Status

		local SI = { Type = "StatusIndicator", Status = Config.Status }
		local SIFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		SI.SetTitle = SIFrame.SetTitle
		SI.SetDesc  = SIFrame.SetDesc
		SI.Visible  = SIFrame.Visible
		SI.Elements = SIFrame

		local Holder = New("Frame", {
			Size               = UDim2.fromOffset(0, 22),
			AutomaticSize      = Enum.AutomaticSize.X,
			Position           = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint        = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent             = SIFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection      = Enum.FillDirection.Horizontal,
				Padding            = UDim.new(0, 6),
				VerticalAlignment  = Enum.VerticalAlignment.Center,
			}),
		})

		local Dot = New("Frame", {
			Size               = UDim2.fromOffset(8, 8),
			BackgroundColor3   = StatusColors[Config.Status] or StatusColors.offline,
			Parent             = Holder,
		}, {
			New("UICorner",           { CornerRadius = UDim.new(1, 0) }),
			New("UIAspectRatioConstraint", { AspectRatio = 1 }),
		})

		local StatusLabel = New("TextLabel", {
			Text               = Config.Label,
			FontFace           = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			TextSize           = 12,
			BackgroundTransparency = 1,
			Size               = UDim2.fromOffset(0, 14),
			AutomaticSize      = Enum.AutomaticSize.X,
			TextColor3         = StatusColors[Config.Status] or StatusColors.offline,
			Parent             = Holder,
		})

		function SI:SetStatus(status, label)
			self.Status = status
			local col = StatusColors[status] or StatusColors.offline
			Dot.BackgroundColor3 = col
			StatusLabel.TextColor3 = col
			StatusLabel.Text = label or status
			-- pulse animation เมื่อ running
			if status == "running" then
				local function pulse()
					if SI.Status ~= "running" then return end
					TweenService:Create(Dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Size = UDim2.fromOffset(10, 10) }):Play()
					task.delay(0.6, function()
						if SI.Status ~= "running" then return end
						TweenService:Create(Dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Size = UDim2.fromOffset(8, 8) }):Play()
						task.delay(0.6, pulse)
					end)
				end
				pulse()
			else
				Dot.Size = UDim2.fromOffset(8, 8)
			end
		end

		function SI:Destroy() SIFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		SI:SetStatus(Config.Status, Config.Label)
		if Idx then Library.Options[Idx] = SI end
		return SI
	end
	return Element
end)()

ElementsTable.CounterButton = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "CounterButton"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "CounterButton - Missing Title")
		Config.Default = Config.Default or 1
		Config.Min     = Config.Min     or 1
		Config.Max     = Config.Max     or 99
		Config.Step    = Config.Step    or 1

		local CB = {
			Value    = Config.Default,
			Type     = "CounterButton",
			Callback = Config.Callback or function() end,
		}

		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		CB.SetTitle = CBFrame.SetTitle
		CB.SetDesc  = CBFrame.SetDesc
		CB.Visible  = CBFrame.Visible
		CB.Elements = CBFrame

		local Holder = New("Frame", {
			Size               = UDim2.fromOffset(96, 30),
			Position           = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint        = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent             = CBFrame.Frame,
		}, {
			New("UIListLayout", {
				FillDirection     = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder         = Enum.SortOrder.LayoutOrder,
			}),
		})

		local function makeBtn(txt, lo)
			return New("TextButton", {
				Text               = txt,
				FontFace           = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
				TextSize           = 16,
				Size               = UDim2.fromOffset(30, 30),
				BackgroundTransparency = 0.85,
				LayoutOrder        = lo,
				Parent             = Holder,
				ThemeTag           = { BackgroundColor3 = "Element", TextColor3 = "Text" },
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 7) }),
				New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
			})
		end

		local MinusBtn = makeBtn("−", 1)
		local ValLabel = New("TextLabel", {
			Text               = tostring(Config.Default),
			FontFace           = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
			TextSize           = 13,
			Size               = UDim2.fromOffset(36, 30),
			BackgroundTransparency = 1,
			TextXAlignment     = Enum.TextXAlignment.Center,
			LayoutOrder        = 2,
			Parent             = Holder,
			ThemeTag           = { TextColor3 = "Text" },
		})
		local PlusBtn = makeBtn("+", 3)

		local function set(v)
			v = math.clamp(math.floor(v / Config.Step + 0.5) * Config.Step, Config.Min, Config.Max)
			CB.Value = v
			ValLabel.Text = tostring(v)
			-- dim buttons at limit
			TweenService:Create(MinusBtn, TweenInfo.new(0.1), { BackgroundTransparency = v <= Config.Min and 0.95 or 0.85 }):Play()
			TweenService:Create(PlusBtn,  TweenInfo.new(0.1), { BackgroundTransparency = v >= Config.Max and 0.95 or 0.85 }):Play()
			Library:SafeCallback(CB.Callback, v)
			Library:SafeCallback(CB.Changed, v)
		end

		Creator.AddSignal(MinusBtn.MouseButton1Click, function() set(CB.Value - Config.Step) end)
		Creator.AddSignal(PlusBtn.MouseButton1Click,  function() set(CB.Value + Config.Step) end)

		-- hold to repeat
		for _, pair in ipairs({ {MinusBtn, -1}, {PlusBtn, 1} }) do
			local btn, dir = pair[1], pair[2]
			Creator.AddSignal(btn.MouseButton1Down, function()
				task.delay(0.4, function()
					while btn:IsDescendantOf(game) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						set(CB.Value + Config.Step * dir)
						task.wait(0.07)
					end
				end)
			end)
		end

		function CB:SetValue(v) set(v) end
		function CB:OnChanged(Func) CB.Changed = Func Func(CB.Value) end
		function CB:Destroy() CBFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		set(Config.Default)
		if Idx then Library.Options[Idx] = CB end
		return CB
	end
	return Element
end)()

ElementsTable.ToggleGroup = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "ToggleGroup"

	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title,   "ToggleGroup - Missing Title")
		assert(Config.Options, "ToggleGroup - Missing Options")

		local TG = {
			Value    = Config.Default or Config.Options[1],
			Type     = "ToggleGroup",
			Callback = Config.Callback or function() end,
		}

		local TGFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
		TG.SetTitle = TGFrame.SetTitle
		TG.SetDesc  = TGFrame.SetDesc
		TG.Visible  = TGFrame.Visible
		TG.Elements = TGFrame

		local Row = New("Frame", {
			Size               = UDim2.fromOffset(0, 28),
			AutomaticSize      = Enum.AutomaticSize.X,
			Position           = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint        = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.88,
			Parent             = TGFrame.Frame,
			ThemeTag           = { BackgroundColor3 = "Element" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 7) }),
			New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "InElementBorder" } }),
			New("UIListLayout", {
				FillDirection     = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder         = Enum.SortOrder.LayoutOrder,
			}),
		})

		local Btns = {}

		local function updateBtns(selected)
			for _, b in ipairs(Btns) do
				local active = b.Value == selected
				TweenService:Create(b.Frame, TweenInfo.new(0.15), {
					BackgroundTransparency = active and 0.0 or 1,
				}):Play()
				TweenService:Create(b.Label, TweenInfo.new(0.15), {
					TextColor3 = active and Color3.fromRGB(255,255,255) or Creator.GetThemeProperty("SubText"),
				}):Play()
			end
		end

		for i, opt in ipairs(Config.Options) do
			local Btn = New("TextButton", {
				Text               = "",
				Size               = UDim2.fromOffset(0, 28),
				AutomaticSize      = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				LayoutOrder        = i,
				Parent             = Row,
				ThemeTag           = { BackgroundColor3 = "Accent" },
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 6) }),
				New("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
			})

			local Lbl = New("TextLabel", {
				Text               = tostring(opt),
				FontFace           = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
				TextSize           = 12,
				BackgroundTransparency = 1,
				Size               = UDim2.fromScale(1, 1),
				AutomaticSize      = Enum.AutomaticSize.X,
				TextColor3         = Creator.GetThemeProperty("SubText"),
				Parent             = Btn,
			})

			table.insert(Btns, { Frame = Btn, Label = Lbl, Value = opt })

			Creator.AddSignal(Btn.MouseButton1Click, function()
				TG.Value = opt
				updateBtns(opt)
				Library:SafeCallback(TG.Callback, opt)
				Library:SafeCallback(TG.Changed, opt)
			end)
		end

		function TG:SetValue(v)
			self.Value = v
			updateBtns(v)
			Library:SafeCallback(self.Callback, v)
			Library:SafeCallback(self.Changed, v)
		end
		function TG:OnChanged(Func) TG.Changed = Func Func(TG.Value) end
		function TG:Destroy() TGFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

		updateBtns(TG.Value)
		if Idx then Library.Options[Idx] = TG end
		return TG
	end
	return Element
end)()

ElementsTable.Accordion = (function()
	local Element = {}
	Element.__index = Element
	Element.__type  = "Accordion"

	function Element:New(Idx, Config)
		Config       = Config or {}
		assert(Config.Title, "Accordion - Missing Title")
		Config.Open  = Config.Open  ~= nil and Config.Open  or false
		Config.Icon  = Config.Icon  -- optional Lucide icon name

		local CORNER      = 8
		local HEADER_H    = 40
		local ANIM_TIME   = 0.22
		local ANIM_STYLE  = Enum.EasingStyle.Quart
		local ANIM_DIR    = Enum.EasingDirection.Out

		local Acc = {
			Type    = "Accordion",
			Opened  = Config.Open,
			Elements = {},
		}

		local Root = New("Frame", {
			Size             = UDim2.new(1, 0, 0, HEADER_H),
			BackgroundTransparency = 0.88,
			ClipsDescendants = true,
			Parent           = self.Container,
			BorderSizePixel  = 0,
			ThemeTag         = { BackgroundColor3 = "Element" },
		}, {
			New("UICorner",  { CornerRadius = UDim.new(0, CORNER) }),
			New("UIStroke",  {
				Transparency    = 0.55,
				Thickness       = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag        = { Color = "InElementBorder" },
			}),
		})

		local AccentBar = New("Frame", {
			Size             = UDim2.new(0, 3, 1, -(CORNER * 2)),
			Position         = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundTransparency = Config.Open and 0 or 1,
			BorderSizePixel  = 0,
			Parent           = Root,
			ThemeTag         = { BackgroundColor3 = "Accent" },
		}, {
			New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local Header = New("TextButton", {
			Size             = UDim2.new(1, 0, 0, HEADER_H),
			BackgroundTransparency = 1,
			Text             = "",
			Parent           = Root,
		})

		-- Icon ซ้าย (optional)
		local IconImg
		if Config.Icon then
			local iconId = Library:GetIcon(Config.Icon)
			if iconId and iconId ~= "" then
				IconImg = New("ImageLabel", {
					Image            = iconId,
					Size             = UDim2.fromOffset(15, 15),
					Position         = UDim2.new(0, 12, 0.5, 0),
					AnchorPoint      = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					ThemeTag         = { ImageColor3 = Config.Open and "Accent" or "SubText" },
					Parent           = Header,
				})
			end
		end

		local titleX = Config.Icon and IconImg and 34 or 12

		-- Title
		local TitleLabel = New("TextLabel", {
			Text             = Config.Title,
			FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
			TextSize         = 13,
			TextXAlignment   = Enum.TextXAlignment.Left,
			Position         = UDim2.new(0, titleX, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, -titleX - 36, 1, 0),
			Parent           = Header,
			ThemeTag         = { TextColor3 = Config.Open and "Accent" or "Text" },
		})

		-- Chevron (หมุนตาม state)
		local Chevron = New("ImageLabel", {
			Image            = "rbxassetid://10734886735",
			Size             = UDim2.fromOffset(14, 14),
			Position         = UDim2.new(1, -14, 0.5, 0),
			AnchorPoint      = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Rotation         = Config.Open and 180 or 0,
			Parent           = Header,
			ThemeTag         = { ImageColor3 = Config.Open and "Accent" or "SubText" },
		})

		local ContentFrame = New("Frame", {
			Size             = UDim2.new(1, -16, 0, 0),
			AutomaticSize    = Enum.AutomaticSize.Y,
			Position         = UDim2.new(0, 8, 0, HEADER_H + 4),
			BackgroundTransparency = 1,
			Parent           = Root,
		}, {
			New("UIListLayout", {
				Padding       = UDim.new(0, 6),
				SortOrder     = Enum.SortOrder.LayoutOrder,
			}),
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 10),
			}),
		})

		local contentLayout = ContentFrame:FindFirstChildOfClass("UIListLayout")

		local function getContentHeight()
			return contentLayout.AbsoluteContentSize.Y + 14
		end

		local function setOpen(open, instant)
			Acc.Opened = open
			local targetH = open and (HEADER_H + getContentHeight()) or HEADER_H
			local ti = TweenInfo.new(instant and 0 or ANIM_TIME, ANIM_STYLE, ANIM_DIR)

			TweenService:Create(Root,    ti, { Size = UDim2.new(1, 0, 0, targetH) }):Play()
			TweenService:Create(Chevron, ti, { Rotation = open and 180 or 0 }):Play()
			TweenService:Create(AccentBar, ti, { BackgroundTransparency = open and 0 or 1 }):Play()
			TweenService:Create(TitleLabel, ti, {
				TextColor3 = open
					and Creator.GetThemeProperty("Accent")
					or  Creator.GetThemeProperty("Text"),
			}):Play()
			TweenService:Create(Chevron, ti, {
				ImageColor3 = open
					and Creator.GetThemeProperty("Accent")
					or  Creator.GetThemeProperty("SubText"),
			}):Play()
			if IconImg then
				TweenService:Create(IconImg, ti, {
					ImageColor3 = open
						and Creator.GetThemeProperty("Accent")
						or  Creator.GetThemeProperty("SubText"),
				}):Play()
			end
		end

		-- อัปเดตขนาดอัตโนมัติเมื่อ content เปลี่ยน
		Creator.AddSignal(contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			if Acc.Opened then
				Root.Size = UDim2.new(1, 0, 0, HEADER_H + getContentHeight())
			end
		end)

		-- Hover effect บน Header
		Creator.AddSignal(Header.MouseEnter, function()
			if not Acc.Opened then
				TweenService:Create(Root, TweenInfo.new(0.15), {
					BackgroundTransparency = 0.82,
				}):Play()
			end
		end)
		Creator.AddSignal(Header.MouseLeave, function()
			TweenService:Create(Root, TweenInfo.new(0.15), {
				BackgroundTransparency = 0.88,
			}):Play()
		end)

		-- คลิก Header
		Creator.AddSignal(Header.MouseButton1Click, function()
			setOpen(not Acc.Opened)
		end)

		Acc.Container   = ContentFrame
		Acc.ScrollFrame = self.ScrollFrame or ContentFrame
		setmetatable(Acc, Library.Elements)

		function Acc:Open()    setOpen(true)  end
		function Acc:Close()   setOpen(false) end
		function Acc:Toggle()  setOpen(not self.Opened) end
		function Acc:Destroy()
			Root:Destroy()
			if Idx then Library.Options[Idx] = nil end
		end

		-- เปิดตอนเริ่มถ้า Config.Open = true
		if Config.Open then
			task.defer(function()
				setOpen(true, true) -- instant ไม่ animate ตอน init
			end)
		end

		if Idx then Library.Options[Idx] = Acc end
		return Acc
	end

	return Element
end)()

local NotificationModule = Components.Notification
NotificationModule:Init(GUI)

local New = Creator.New

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
			New("UICorner", { CornerRadius = UDim.new(0, 6) }),
			New("UIStroke", {
				Transparency    = 0.55,
				Thickness       = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color           = TypeColors[Config.Type] or TypeColors.default,
			}),
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
			FontFace               = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
			Text                   = Config.Text,
			TextColor3             = TypeColors[Config.Type] or TypeColors.default,
			TextSize               = 12,
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

local NotificationModule = Components.Notification
NotificationModule:Init(GUI)

local New = Creator.New

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
	if Name ~= nil and Icons["lucide-" .. Name] then
		return Icons["lucide-" .. Name]
	end
	return nil
end

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

		-- Button และ Paragraph ใช้ New(Config) ไม่มี Idx
		-- ตรวจ: ถ้า ElementComponent.NoIdx = true ให้ส่ง Idx เป็น Config แทน
		if ElementComponent.NoIdx then
			return ElementComponent:New(Idx)
		end
		return ElementComponent:New(Idx, Config)
	end
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

local SaveManager = {} do

	SaveManager.Folder = "FluentSettings"

	SaveManager.Ignore = {}

	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) 

				return { type = "Toggle", idx = idx, value = object.Value } 

			end,

			Load = function(idx, data)

				if SaveManager.Options[idx] then 

					SaveManager.Options[idx]:SetValue(data.value)

				end

			end,
		},

		Slider = {
			Save = function(idx, object)

				return { type = "Slider", idx = idx, value = tostring(object.Value) }

			end,

			Load = function(idx, data)

				if SaveManager.Options[idx] then 

					SaveManager.Options[idx]:SetValue(data.value)

				end

			end,
		},

		Dropdown = {
			Save = function(idx, object)

				return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }

			end,

			Load = function(idx, data)

				if SaveManager.Options[idx] then 

					SaveManager.Options[idx]:SetValue(data.value)

				end

			end,
		},

		Colorpicker = {
			Save = function(idx, object)

				return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }

			end,

			Load = function(idx, data)

				if SaveManager.Options[idx] then 

					SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)

				end

			end,
		},

		Keybind = {
			Save = function(idx, object)

				return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value }

			end,

			Load = function(idx, data)

				if SaveManager.Options[idx] then 

					SaveManager.Options[idx]:SetValue(data.key, data.mode)

				end

			end,
		},

		LiveLabel = {
			Save = function(idx, object)
				return { type = "LiveLabel", idx = idx, value = object.Value, ltype = object._type }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetText(data.value or "")
					SaveManager.Options[idx]:SetType(data.ltype or "default")
				end
			end,
		},

		Input = {
			Save = function(idx, object)

				return { type = "Input", idx = idx, text = object.Value }

			end,

			Load = function(idx, data)

				if SaveManager.Options[idx] and type(data.text) == "string" then

					SaveManager.Options[idx]:SetValue(data.text)

				end

			end,
		},

		-- ✨ New Element Parsers ✨

		MiniBar = {
			Save = function(idx, object)
				return { type = "MiniBar", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},

		Checkbox = {
			Save = function(idx, object)
				return { type = "Checkbox", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},

		RadioGroup = {
			Save = function(idx, object)
				return { type = "RadioGroup", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},

		NumberInput = {
			Save = function(idx, object)
				return { type = "NumberInput", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},

		TagInput = {
			Save = function(idx, object)
				return { type = "TagInput", idx = idx, value = table.concat(object.Value, ",") }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					local tags = {}
					for t in (data.value or ""):gmatch("[^,]+") do
						table.insert(tags, t)
					end
					SaveManager.Options[idx]:SetValue(tags)
				end
			end,
		},

		Chip = {
			Save = function(idx, object)
				return { type = "Chip", idx = idx, value = table.concat(object.Value, ",") }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					local vals = {}
					for v in (data.value or ""):gmatch("[^,]+") do
						table.insert(vals, v)
					end
					SaveManager.Options[idx]:SetValue(vals)
				end
			end,
		},

		SearchBar = {
			Save = function(idx, object)
				return { type = "SearchBar", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value or "") end
			end,
		},

		CounterButton = {
			Save = function(idx, object)
				return { type = "CounterButton", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end
			end,
		},

		ToggleGroup = {
			Save = function(idx, object)
				return { type = "ToggleGroup", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end
			end,
		},

		NotifBadge = {
			Save = function(idx, object)
				return { type = "NotifBadge", idx = idx, count = object.Count }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then SaveManager.Options[idx]:SetCount(data.count or 0) end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)

		for _, key in next, list do

			self.Ignore[key] = true

		end

	end

	function SaveManager:SetFolder(folder)

		self.Folder = folder;

		self:BuildFolderTree()

	end

	function SaveManager:Save(name)

		if (not name) then

			return false, "no config file is selected"

		end

		local fullPath = self.Folder .. "/" .. name .. ".json"

		local data = {
			objects = {}
		}

		for idx, option in next, SaveManager.Options do

			if self.Parser[option.Type] and not self.Ignore[idx] then

				table.insert(data.objects, self.Parser[option.Type].Save(idx, option))

			end

		end	

		local success, encoded = pcall(httpService.JSONEncode, httpService, data)

		if not success then

			return false, "failed to encode data"

		end

		writefile(fullPath, encoded)

		return true

	end

	if not RunService:IsStudio() then

		function SaveManager:Load(name)

			if (not name) then

				return false, "no config file is selected"

			end

			local file = self.Folder .. "/" .. name .. ".json"

			if not isfile(file) then return false, "Create Config Save File" end

			local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))

			if not success then return false, "decode error" end

			for _, option in next, decoded.objects do

				if self.Parser[option.type] and not self.Ignore[option.idx] then

					task.spawn(function() self.Parser[option.type].Load(option.idx, option) end)

				end

			end

			Fluent.SettingLoaded = true

			return true, decoded

		end

	end

	SaveManager.IgnoreThemeSettings = function(self)

		self:SetIgnoreIndexes({ 

			"InterfaceTheme", "AcrylicToggle", "TransparentToggle", "MenuKeybind"
		})

	end

	function SaveManager:BuildFolderTree()

		local paths = {
			self.Folder,

			self.Folder .. "/"
		}

		for i = 1, #paths do

			local str = paths[i]

			if not isfolder(str) then

				makefolder(str)

			end

		end

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

				while char ~= "/" and char ~= "\\" and char ~= "" do

					pos = pos - 1

					char = file:sub(pos, pos)

				end

				if char == "/" or char == "\\" then

					local name = file:sub(pos + 1, start - 1)

					if name ~= "options" then

						table.insert(out, name)

					end

				end

			end

		end

		return out

	end

	function SaveManager:SetLibrary(library)

		self.Library = library

		self.Options = library.Options

	end

	if not RunService:IsStudio() then

		function SaveManager:LoadAutoloadConfig()

			if isfile(self.Folder .. "/autoload.txt") then

				local name = readfile(self.Folder .. "/autoload.txt")
				name = name:match("^%s*(.-)%s*$") -- trim whitespace/newlines

				if not name or name == "" then return end

				local success, err = self:Load(name)

				if not success then

					return self.Library:Notify({
						Title = "Interface",

						Content = "Config loader",

						SubContent = "Failed to load autoload config: " .. err,

						Duration = 7
					})

				end

				self.Library:Notify({
					Title = "Interface",

					Content = "Config loader",

					SubContent = string.format("Auto loaded config %q", name),

					Duration = 7
				})

			end

		end

	end

	function SaveManager:BuildConfigSection(tab)

		assert(self.Library, "Must set SaveManager.Library")

		local section = tab:AddSection("Configuration", "settings")

		section:AddInput("SaveManager_ConfigName",    { Title = "Config name" })

		section:AddDropdown("SaveManager_ConfigList", { Title = "Config list", Values = self:RefreshConfigList(), AllowNull = true })

		section:AddButton({
			Title = "Create config",

			Callback = function()

				local name = SaveManager.Options.SaveManager_ConfigName.Value

				if name:gsub(" ", "") == "" then 

					return self.Library:Notify({
						Title = "Interface",

						Content = "Config loader",

						SubContent = "Invalid config name (empty)",

						Duration = 7
					})

				end

				local success, err = self:Save(name)

				if not success then

					return self.Library:Notify({
						Title = "Interface",

						Content = "Config loader",

						SubContent = "Failed to save config: " .. err,

						Duration = 7
					})

				end

				self.Library:Notify({
					Title = "Interface",

					Content = "Config loader",

					SubContent = string.format("Created config %q", name),

					Duration = 7
				})

				SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())

				SaveManager.Options.SaveManager_ConfigList:SetValue(nil)

			end
		})

		section:AddButton({Title = "Load config", Callback = function()

			local name = SaveManager.Options.SaveManager_ConfigList.Value

			local success, err = self:Load(name)

			if not success then

				return self.Library:Notify({
					Title = "Interface",

					Content = "Config loader",

					SubContent = "Failed to load config: " .. err,

					Duration = 7
				})

			end

			self.Library:Notify({
				Title = "Interface",

				Content = "Config loader",

				SubContent = string.format("Loaded config %q", name),

				Duration = 7
			})

		end})

		section:AddButton({Title = "Save config", Callback = function()

			local name = SaveManager.Options.SaveManager_ConfigList.Value

			local success, err = self:Save(name)

			if not success then

				return self.Library:Notify({
					Title = "Interface",

					Content = "Config loader",

					SubContent = "Failed to overwrite config: " .. err,

					Duration = 7
				})

			end

			self.Library:Notify({
				Title = "Interface",

				Content = "Config loader",

				SubContent = string.format("Overwrote config %q", name),

				Duration = 7
			})

		end})

		section:AddButton({Title = "Refresh list", Callback = function()

			SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())

			SaveManager.Options.SaveManager_ConfigList:SetValue(nil)

		end})

		-- Set as autoload — Button (validate ก่อนเขียน)
		local AutoloadButton
		AutoloadButton = section:AddButton({
			Title = "Set as autoload",
			Description = "Current autoload: none",
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value
				if not name or name == "" then
					return self.Library:Notify({
						Title = "Interface",
						Content = "Config loader",
						SubContent = "Select a config from the list first",
						Duration = 5,
					})
				end
				writefile(self.Folder .. "/autoload.txt", name)
				AutoloadButton:SetDesc("Current autoload: " .. name)
				self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = string.format("Set %q as autoload config", name),
					Duration = 7,
				})
			end,
		})

		-- Clear autoload
		section:AddButton({
			Title = "Clear autoload",
			Description = "ยกเลิก autoload config",
			Callback = function()
				writefile(self.Folder .. "/autoload.txt", "")
				AutoloadButton:SetDesc("Current autoload: none")
				self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Autoload config cleared",
					Duration = 5,
				})
			end,
		})

		-- แสดงชื่อ autoload ปัจจุบัน (ถ้ามี)
		if isfile(self.Folder .. "/autoload.txt") then
			local name = (readfile(self.Folder .. "/autoload.txt") or ""):match("^%s*(.-)%s*$") or ""
			if name ~= "" then
				AutoloadButton:SetDesc("Current autoload: " .. name)
			end
		end

		SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })

	end

	if not RunService:IsStudio() then

		SaveManager:BuildFolderTree()

	end

end

local InterfaceManager = {} do

	InterfaceManager.Folder = "FluentSettings"

	InterfaceManager.Settings = {
		Acrylic = true,

		Transparency = true,

		MenuKeybind = "M"
	}

	function InterfaceManager:SetTheme(name)

		InterfaceManager.Settings.Theme = name

	end

	function InterfaceManager:SetFolder(folder)

		self.Folder = folder;

		self:BuildFolderTree()

	end

	function InterfaceManager:SetLibrary(library)

		self.Library = library

	end

	function InterfaceManager:BuildFolderTree()

		local paths = {}

		local parts = self.Folder:split("/")

		for idx = 1, #parts do

			paths[#paths + 1] = table.concat(parts, "/", 1, idx)

		end

		table.insert(paths, self.Folder)

		table.insert(paths, self.Folder .. "/")

		for i = 1, #paths do

			local str = paths[i]

			if not isfolder(str) then

				makefolder(str)

			end

		end

	end

	function InterfaceManager:SaveSettings()

		writefile(self.Folder .. "/options.json", httpService:JSONEncode(InterfaceManager.Settings))

	end

	function InterfaceManager:LoadSettings()

		local path = self.Folder .. "/options.json"

		if isfile(path) then

			local data = readfile(path)

			if not RunService:IsStudio() then local success, decoded = pcall(httpService.JSONDecode, httpService, data) end

			if success then

				for i, v in next, decoded do

					InterfaceManager.Settings[i] = v

				end

			end

		end

	end

	function InterfaceManager:BuildInterfaceSection(tab)

		assert(self.Library, "Must set InterfaceManager.Library")

		local Library = self.Library

		local Settings = InterfaceManager.Settings

		InterfaceManager:LoadSettings()

		local section = tab:AddSection("Interface", "monitor")

		local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
			Title = "Theme",

			Description = "Changes the interface theme.",

			Values = Library.Themes,

			Default = self.Library.Theme,

			Callback = function(Value)

				Library:SetTheme(Value)

				Settings.Theme = Value

				InterfaceManager:SaveSettings()

			end
		})

		InterfaceTheme:SetValue(Settings.Theme)

		if Library.UseAcrylic and not Mobile then

			section:AddToggle("AcrylicToggle", {
				Title = "Acrylic",

				Description = "The blurred background requires graphic quality 8+",

				Default = Settings.Acrylic,

				Callback = function(Value)

					Library:ToggleAcrylic(Value)

					Settings.Acrylic = Value

					InterfaceManager:SaveSettings()

				end
			})

		elseif Mobile then

			Settings.Acrylic = false

		end

		section:AddSlider("WindowTransparency", {
			Title = "Window Transparency",

			Description = "Adjusts the window transparency.",

			Default = 1,

			Min = 0,

			Max = 3,

			Rounding = 1,

			Callback = function(Value)

				Library:SetWindowTransparency(Value)

			end
		})

		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Library.MinimizeKey.Name or Settings.MenuKeybind })

		MenuKeybind:OnChanged(function()

			Settings.MenuKeybind = MenuKeybind.Value

			InterfaceManager:SaveSettings()

		end)

		Library.MinimizeKeybind = MenuKeybind

	end

end

Library.CreateWindow = function(self, Config)

	assert(Config.Title, "Window - Missing Title")

	if Library.Window then

		print("You cannot create more than one window.")

		return

	end

	Library.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.LeftControl

	Library.UseAcrylic = Config.Acrylic or false

	Library.Acrylic = Config.Acrylic or false

	Library.Theme = Config.Theme or "Dark"

	if Config.BackgroundImage == nil then
		Config.BackgroundImage = "rbxassetid://13196113628"
	end

	if Config.BackgroundTransparency == nil then
		Config.BackgroundTransparency = 0.5
	end

	if Config.Acrylic then

		Acrylic.init()

	end

	local Icon = Config.Icon

	if not fischbypass then 

		if Library:GetIcon(Icon) then

			Icon = Library:GetIcon(Icon)

		end

		if Icon == "" or Icon == nil then

			Icon = nil

		end

	end

	local Window = Components.Window({
		Parent = GUI,

		Size = Config.Size,

		Title = Config.Title,

		Icon = Icon,

		Image = Config.Image,

		BackgroundImage = Config.BackgroundImage,

		BackgroundTransparency = Config.BackgroundTransparency,

		BackgroundImageTransparency = Config.BackgroundImageTransparency,

		SubTitle = Config.SubTitle,

		Discord = Config.Discord,

		TabWidth = Config.TabWidth,

		DropdownsOutsideWindow = Config.DropdownsOutsideWindow,

		Search = Config.Search,

		UserInfoTitle = Config.UserInfoTitle,

		UserInfo = Config.UserInfo,

		UserInfoTop = Config.UserInfoTop,

		UserInfoSubtitle = Config.UserInfoSubtitle,

		UserInfoSubtitleColor = Config.UserInfoSubtitleColor,
	})

	Library.Window = Window

	table.insert(Library.Windows, Window)

	InterfaceManager:SetTheme(Config.Theme)

	Library:SetTheme(Config.Theme)

	return Window

end

function Library:CreateMinimizer(Config)
	Config = Config or {}
	if self.Minimizer and self.Minimizer.Parent then
		return self.Minimizer
	end

	local parentGui = Library.GUI or GUI
	if parentGui then parentGui.DisplayOrder = 1000 end
	local isMobile = Mobile and true or false

	local iconAsset = "rbxassetid://10734897102"
	if type(Config.Icon) == "string" and Config.Icon ~= "" then
		pcall(function()
			local resolved = Library:GetIcon(Config.Icon)
			if resolved then
				iconAsset = resolved
			elseif string.match(Config.Icon, "^rbxassetid://%d+$") then
				iconAsset = Config.Icon
			end
		end)
	end

	local useAcrylic = (Config.Acrylic == true)
	local draggableWhole = (Config.Draggable == true)

	local holder
	local function createButton(isDesktop)
		return New("TextButton", {
			Name = "MinimizeButton",
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1, -- ลบพื้นหลังออก 100%
			AutoButtonColor = false,
		}, {
			New("ImageLabel", {
				Name = "Icon",
				Image = iconAsset,
				Size = UDim2.new(0.85, 0, 0.85, 0), -- ขนาดรูป
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				-- ถ้าไอคอนมีพื้นหลังติดมาด้วย บรรทัดนี้จะทำให้พื้นหลังถูกตัดขอบ
				ClipsDescendants = true, 
				ThemeTag = {
					ImageColor3 = "Text",
				},
			}, {
				New("UIAspectRatioConstraint", { AspectRatio = 1, AspectType = Enum.AspectType.FitWithinMaxSize }),
				
				-- [เพิ่มตรงนี้] ทำให้ขอบของไอคอนมนขึ้น
				-- ถ้าอยากให้กลมดิ๊กเป็นวงกลมเลย ให้แก้เป็น UDim.new(1, 0)
				-- ถ้าอยากให้มนน้อยลง ให้แก้เป็น UDim.new(0.15, 0)
				New("UICorner", { CornerRadius = UDim.new(0.25, 0) }) 
			}),
		})
	end

	if isMobile then
		holder = New("Frame", {
			Name = "FluentMinimizer",
			Parent = parentGui,
			Size = Config.Size or UDim2.fromOffset(40, 40),
			Position = Config.Position or UDim2.new(0.45, 0, 0.025, 0),
			BackgroundTransparency = 1,
			ZIndex = 999999999,
			Visible = (Config.Visible ~= false),
		})
	else
		holder = New("Frame", {
			Name = "FluentMinimizer",
			Parent = parentGui,
			Size = Config.Size or UDim2.fromOffset(40, 40),
			Position = Config.Position or UDim2.new(0, 300, 0, 20),
			BackgroundTransparency = 1,
			ZIndex = 999999999,
			Visible = (Config.Visible ~= false),
		})
	end

	-- ปิดระบบ Acrylic ไปเลยถ้าพื้นหลังใสแล้ว จะได้ไม่กินสเปค
	if useAcrylic then
		pcall(function()
			-- เราจะไม่สร้าง AcrylicPaint แล้ว เพื่อให้ปุ่มดูใส 100% ลอยๆ จริงๆ
		end)
	end

	local btnInstance = createButton(not isMobile)
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
					local pos = Input.Position
					dragStart = Vector2.new(pos.X, pos.Y)
					dragOffset = holder.Position
					local conn
					conn = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							isDragging = false
							dragStart = nil
							dragOffset = nil
							conn:Disconnect()
						end
					end)
				end
			end)

			Creator.AddSignal(RunService.Heartbeat, function()
				if isDragging and dragStart and dragOffset and holder and holder.Parent then
					local mouse = LocalPlayer:GetMouse()
					local current = Vector2.new(mouse.X, mouse.Y)
					local delta = current - dragStart
					local newX = dragOffset.X.Offset + delta.X
					local newY = dragOffset.Y.Offset + delta.Y
					local viewport = workspace.Camera.ViewportSize
					local size = holder.AbsoluteSize
					if newX < 0 then newX = 0 end
					if newY < 0 then newY = 0 end
					if newX > viewport.X - size.X then newX = viewport.X - size.X end
					if newY > viewport.Y - size.Y then newY = viewport.Y - size.Y end
					holder.Position = UDim2.new(0, newX, 0, newY)
				end
			end)
		end

		AddSignal(button.MouseButton1Click, function()
			task.wait(0.1)
			if not isDragging and Library.Window then
				Library.Window:Minimize()
			end
		end)
	end

	self.Minimizer = holder
	return holder
end

function Library:SetTheme(Value)

	if Library.Window and table.find(Library.Themes, Value) then

		Library.Theme = Value

		Creator.UpdateTheme()

		if Value == "Glass" then

			Library:SetWindowTransparency(0.9)

		end

	end

end

function Library:Destroy()

	if Library.Window then

		Library.Unloaded = true

		if Library.UseAcrylic then

			Library.Window.AcrylicPaint.Model:Destroy()

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

	if Library.Window and Library.UseAcrylic then

		Value = math.clamp(Value, 0, 3)

		if Library.Theme == "Glass" then

			local glassTransparency = 0.8 + (Value * 0.05)

			if Value > 1 then

				glassTransparency = 0.85 + ((Value - 1) * 0.04)

			end

			if Value > 2 then

				glassTransparency = 0.93 + ((Value - 2) * 0.04)

			end

			Library.Window.AcrylicPaint.Model.Transparency = math.min(glassTransparency, 0.99)

			local backgroundTransparency = 0.7 + (Value * 0.08)

			if Value > 1 then

				backgroundTransparency = 0.78 + ((Value - 1) * 0.07)

			end

			if Value > 2 then

				backgroundTransparency = 0.85 + ((Value - 2) * 0.1)

			end

			Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = math.min(backgroundTransparency, 0.99)

			Library.NotificationTransparency = Value

			for _, notification in pairs(Library.ActiveNotifications or {}) do

				if notification and notification.ApplyTransparency then

					notification:ApplyTransparency()

				end

			end

		else

			Library.Window.AcrylicPaint.Model.Transparency = 0.98

			Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = Value * 0.3

		end

	end

end

function Library:Notify(Config)

	return NotificationModule:New(Config)

end

if getgenv then

	getgenv().Fluent = Library

else

	Fluent = Library

end

local MinimizeButton = New("TextButton", {
	BackgroundColor3 = Color3.fromRGB(25, 25, 30),

	Size = UDim2.new(1, 0, 1, 0),

	BorderSizePixel = 0,

	BackgroundTransparency = 0.05, 
}, {
	New("UICorner", {
		CornerRadius = UDim.new(0, 14),
	}),

	New("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),

			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
		},

		Rotation = 45,
	}),

	New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,

		Color = Color3.fromRGB(100, 150, 255),

		Transparency = 0.6,

		Thickness = 2,
	}),

	New("Frame", {
		BackgroundColor3 = Color3.fromRGB(100, 150, 255),

		BackgroundTransparency = 0.9,

		Size = UDim2.new(1, -6, 1, -6),

		Position = UDim2.new(0, 3, 0, 3),

		BorderSizePixel = 0,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 11),
		}),
	}),

	New("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),

		BackgroundTransparency = 0.94,

		Size = UDim2.new(0.7, 0, 0.3, 0),

		Position = UDim2.new(0.15, 0, 0.1, 0),

		BorderSizePixel = 0,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
	}),

	New("ImageLabel", {
		Image = "rbxassetid://10734897102",

		Size = UDim2.new(0.8, 0, 0.8, 0),

		Position = UDim2.new(0.5, 0, 0.5, 0),

		AnchorPoint = Vector2.new(0.5, 0.5),

		BackgroundTransparency = 1,

		ImageColor3 = Color3.fromRGB(255, 255, 255),

		ImageTransparency = 0.1,
	}, {
		New("UIAspectRatioConstraint", {
			AspectRatio = 1,

			AspectType = Enum.AspectType.FitWithinMaxSize,
		})
	})
})

local MobileMinimizeButton = New("TextButton", {
	BackgroundColor3 = Color3.fromRGB(25, 25, 30),

	Size = UDim2.new(1, 0, 1, 0),

	BorderSizePixel = 0,

	BackgroundTransparency = 0.05,
}, {
	New("UICorner", {
		CornerRadius = UDim.new(0, 12),
	}),

	New("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),

			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
		},

		Rotation = 45,
	}),

	New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,

		Color = Color3.fromRGB(100, 150, 255),

		Transparency = 0.7,

		Thickness = 1.5,
	}),

	New("Frame", {
		BackgroundColor3 = Color3.fromRGB(100, 150, 255),

		BackgroundTransparency = 0.92,

		Size = UDim2.new(1, -4, 1, -4),

		Position = UDim2.new(0, 2, 0, 2),

		BorderSizePixel = 0,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
	}),

	New("ImageLabel", {
		Image = "rbxassetid://10734897102",

		Size = UDim2.new(0.8, 0, 0.8, 0),

		Position = UDim2.new(0.5, 0, 0.5, 0),

		AnchorPoint = Vector2.new(0.5, 0.5),

		BackgroundTransparency = 1,

		ImageColor3 = Color3.fromRGB(255, 255, 255),

		ImageTransparency = 0.1,
	}, {
		New("UIAspectRatioConstraint", {
			AspectRatio = 1,

			AspectType = Enum.AspectType.FitWithinMaxSize,
		})
	})
})

local Minimizer

local isDragging = false

local dragStart = nil

local dragOffset = nil

Creator.AddSignal(MinimizeButton.InputBegan, function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then

		isDragging = true

		dragStart = Vector2.new(Input.Position.X, Input.Position.Y)

		dragOffset = (Library.Minimizer or Minimizer).Position

		local connection

		connection = Input.Changed:Connect(function()

			if Input.UserInputState == Enum.UserInputState.End then

				isDragging = false

				dragStart = nil

				dragOffset = nil

				connection:Disconnect()

			end

		end)

	end

end)

Creator.AddSignal(MobileMinimizeButton.InputBegan, function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

		isDragging = true

		dragStart = Vector2.new(Input.Position.X, Input.Position.Y)

		dragOffset = (Library.Minimizer or Minimizer).Position

		local connection

		connection = Input.Changed:Connect(function()

			if Input.UserInputState == Enum.UserInputState.End then

				isDragging = false

				dragStart = nil

				dragOffset = nil

				connection:Disconnect()

			end

		end)

	end

end)

Creator.AddSignal(RunService.Heartbeat, function()

	local activeMin = Library.Minimizer or Minimizer

	if isDragging and dragStart and dragOffset and activeMin and activeMin.Parent then

		local currentMousePos = Vector2.new(Mouse.X, Mouse.Y)

		local delta = currentMousePos - dragStart

		local newX = dragOffset.X.Offset + delta.X

		local newY = dragOffset.Y.Offset + delta.Y

		local viewportSize = workspace.Camera.ViewportSize

		local minimizerSize = activeMin.AbsoluteSize

		if newX < 0 then newX = 0 end

		if newY < 0 then newY = 0 end

		if newX > viewportSize.X - minimizerSize.X then 

			newX = viewportSize.X - minimizerSize.X 

		end

		if newY > viewportSize.Y - minimizerSize.Y then 

			newY = viewportSize.Y - minimizerSize.Y 

		end

		activeMin.Position = UDim2.new(0, newX, 0, newY)

	end

end)

Creator.AddSignal(MinimizeButton.MouseButton1Click, function()

	task.wait(0.1)

	if not isDragging then

		Library.Window:Minimize()

	end

end)

Creator.AddSignal(MobileMinimizeButton.MouseButton1Click, function()

	task.wait(0.1)

	if not isDragging then

		Library.Window:Minimize()

	end

end)

    

-- ═══════════════════════════════════════════════════════════════
-- ✨ FEATURE PACK - PART 1: CORE & WINDOW
-- ═══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- [2] TAB BADGES / NOTIFICATION DOTS
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    local tab = Window:AddTab({ Title = "Combat", Icon = "sword" })
    tab:SetBadge(5)          -- แสดงตัวเลข
    tab:SetBadge("NEW")      -- แสดงข้อความ
    tab:SetBadge(nil)        -- ซ่อน badge
    tab:SetBadgeDot(true)    -- แสดงจุดแดงอย่างเดียว
]]
do
    local _origTabNew = Components.Tab.New
    function Components.Tab:New(Title, Icon, Parent)
        local tab = _origTabNew(self, Title, Icon, Parent)

        -- สร้าง Badge Frame
        local BadgeFrame = Creator.New("Frame", {
            Name = "TabBadge",
            Size = UDim2.fromOffset(18, 18),
            Position = UDim2.new(1, -4, 0, 4),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Color3.fromRGB(255, 60, 60),
            Visible = false,
            ZIndex = 15,
            Parent = tab.Frame,
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            Creator.New("TextLabel", {
                Name = "BadgeLabel",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 10,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                ZIndex = 16,
            }),
        })

        function tab:SetBadge(value)
            if value == nil then
                BadgeFrame.Visible = false
                return
            end
            local label = BadgeFrame:FindFirstChild("BadgeLabel")
            local str = tostring(value)
            if type(value) == "number" and value > 99 then str = "99+" end
            label.Text = str
            -- ปรับขนาดตามความยาวข้อความ
            local w = math.max(18, #str * 7 + 8)
            BadgeFrame.Size = UDim2.fromOffset(w, 18)
            BadgeFrame.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            BadgeFrame.Visible = true
            -- Animate pop
            BadgeFrame.Size = UDim2.fromOffset(w * 0.5, 9)
            TweenService:Create(BadgeFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(w, 18)
            }):Play()
        end

        function tab:SetBadgeDot(visible)
            if visible then
                local label = BadgeFrame:FindFirstChild("BadgeLabel")
                label.Text = ""
                BadgeFrame.Size = UDim2.fromOffset(10, 10)
                BadgeFrame.Position = UDim2.new(1, -2, 0, 2)
                BadgeFrame.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
                BadgeFrame.Visible = true
            else
                BadgeFrame.Visible = false
            end
        end

        function tab:ClearBadge()
            TweenService:Create(BadgeFrame, TweenInfo.new(0.15), {
                Size = UDim2.fromOffset(0, 0)
            }):Play()
            task.delay(0.15, function()
                BadgeFrame.Visible = false
            end)
        end

        return tab
    end
end

-- ──────────────────────────────────────────────────────────────
-- [3] TABLE / GRID ELEMENT
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    local tbl = Section:AddTable({
        Title = "Players",
        Headers = { "Name", "Score", "Ping" },
        Rows = {
            { "Player1", "100", "45ms" },
            { "Player2", "80",  "120ms" },
        },
        Striped = true,   -- สลับสีแถว
        Sortable = true,  -- คลิก header เพื่อ sort
    })
    tbl:SetRows({ ... })       -- อัปเดตข้อมูล
    tbl:AddRow({ ... })        -- เพิ่มแถว
    tbl:ClearRows()            -- ล้างทั้งหมด
]]
ElementsTable.Table = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Table"
    Element.NoIdx = true

    function Element:New(Config)
        Config = Config or {}
        assert(Config.Title, "Table - Missing Title")
        Config.Headers = Config.Headers or {}
        Config.Rows = Config.Rows or {}
        Config.Striped = Config.Striped ~= false
        Config.Sortable = Config.Sortable or false

        local Tbl = { Type = "Table", Rows = {}, SortCol = nil, SortAsc = true }

        -- outer element frame
        local OuterFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        OuterFrame.Frame.BackgroundTransparency = 0.88

        -- Scroll container
        local ScrollFrame = Creator.New("ScrollingFrame", {
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0.7,
            BottomImage = "rbxassetid://6889812791",
            MidImage = "rbxassetid://6889812721",
            TopImage = "rbxassetid://6276641225",
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Parent = OuterFrame.LabelHolder,
            LayoutOrder = 4,
            BorderSizePixel = 0,
        }, {
            Creator.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
        })

        -- Header row
        local HeaderRow = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundTransparency = 0.75,
            LayoutOrder = 1,
            Parent = ScrollFrame,
            ThemeTag = { BackgroundColor3 = "Accent" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            Creator.New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
        })

        local colCount = math.max(1, #Config.Headers)
        local HeaderLabels = {}

        for i, hdr in ipairs(Config.Headers) do
            local lbl = Creator.New("TextButton", {
                Size = UDim2.new(1 / colCount, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = hdr .. (Config.Sortable and " ↕" or ""),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                LayoutOrder = i,
                Parent = HeaderRow,
            })
            HeaderLabels[i] = lbl

            if Config.Sortable then
                Creator.AddSignal(lbl.MouseButton1Click, function()
                    if Tbl.SortCol == i then
                        Tbl.SortAsc = not Tbl.SortAsc
                    else
                        Tbl.SortCol = i
                        Tbl.SortAsc = true
                    end
                    -- อัปเดต header labels
                    for j, hl in ipairs(HeaderLabels) do
                        hl.Text = Config.Headers[j] .. (j == Tbl.SortCol and (Tbl.SortAsc and " ↑" or " ↓") or " ↕")
                    end
                    Tbl:Refresh()
                end)
            end
        end

        -- Row container
        local RowContainer = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Parent = ScrollFrame,
        }, {
            Creator.New("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 1),
            }),
        })

        local function buildRow(rowData, idx)
            local isEven = idx % 2 == 0
            local row = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = Config.Striped and (isEven and 0.92 or 1) or 1,
                LayoutOrder = idx,
                Parent = RowContainer,
                ThemeTag = { BackgroundColor3 = "Element" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
            })
            for j = 1, colCount do
                Creator.New("TextLabel", {
                    Size = UDim2.new(1 / colCount, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(rowData[j] or ""),
                    TextSize = 12,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    LayoutOrder = j,
                    Parent = row,
                    ThemeTag = { TextColor3 = "Text" },
                })
            end
            return row
        end

        function Tbl:Refresh()
            for _, c in pairs(RowContainer:GetChildren()) do
                if not c:IsA("UIListLayout") then c:Destroy() end
            end
            local sorted = {}
            for _, r in ipairs(self.Rows) do table.insert(sorted, r) end
            if self.SortCol then
                table.sort(sorted, function(a, b)
                    local av, bv = tostring(a[self.SortCol] or ""), tostring(b[self.SortCol] or "")
                    local an, bn = tonumber(av), tonumber(bv)
                    if an and bn then
                        return self.SortAsc and an < bn or an > bn
                    end
                    return self.SortAsc and av < bv or av > bv
                end)
            end
            for i, r in ipairs(sorted) do buildRow(r, i) end
        end

        function Tbl:SetRows(rows)
            self.Rows = rows or {}
            self:Refresh()
        end

        function Tbl:AddRow(row)
            table.insert(self.Rows, row)
            self:Refresh()
        end

        function Tbl:ClearRows()
            self.Rows = {}
            self:Refresh()
        end

        Tbl:SetRows(Config.Rows)
        return Tbl
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [4] CONTEXT MENU (RIGHT-CLICK)
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:AttachContextMenu(element.Frame, {
        { Label = "Copy Value",    Icon = "copy",   Callback = function() end },
        { Label = "Reset Default", Icon = "rotate-ccw", Callback = function() end },
        { Separator = true },
        { Label = "Delete",        Icon = "trash",  Callback = function() end, Danger = true },
    })
]]
do
    local ContextMenuFrame = Creator.New("Frame", {
        Name = "ContextMenu",
        Size = UDim2.fromOffset(180, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 9999,
        Parent = Library.GUI,
    })

    local ContextInner = Creator.New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0.08,
        ZIndex = 9999,
        Parent = ContextMenuFrame,
        ThemeTag = { BackgroundColor3 = "DropdownHolder" },
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Creator.New("UIStroke", {
            Transparency = 0.4,
            ThemeTag = { Color = "DropdownBorder" },
        }),
        Creator.New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
        }),
        Creator.New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
        }),
    })

    local function closeContext()
        ContextMenuFrame.Visible = false
        for _, c in pairs(ContextInner:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
                c:Destroy()
            end
        end
    end

    Creator.AddSignal(UserInputService.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = Vector2.new(input.Position.X, input.Position.Y)
            local ap = ContextMenuFrame.AbsolutePosition
            local as = ContextMenuFrame.AbsoluteSize
            if not (pos.X >= ap.X and pos.X <= ap.X + as.X and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y) then
                closeContext()
            end
        end
    end)

    function Library:AttachContextMenu(frame, items)
        Creator.AddSignal(frame.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                closeContext()
                local layout = ContextInner:FindFirstChildOfClass("UIListLayout")
                local totalH = 10
                local order = 0
                for _, item in ipairs(items) do
                    order = order + 1
                    if item.Separator then
                        Creator.New("Frame", {
                            Size = UDim2.new(1, 0, 0, 1),
                            BackgroundTransparency = 0.6,
                            LayoutOrder = order,
                            Parent = ContextInner,
                            ThemeTag = { BackgroundColor3 = "InElementBorder" },
                        })
                        totalH = totalH + 3
                    else
                        local btn = Creator.New("TextButton", {
                            Size = UDim2.new(1, 0, 0, 30),
                            BackgroundTransparency = 1,
                            Text = "",
                            LayoutOrder = order,
                            Parent = ContextInner,
                            ZIndex = 10000,
                        }, {
                            Creator.New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                            Creator.New("UIListLayout", {
                                FillDirection = Enum.FillDirection.Horizontal,
                                Padding = UDim.new(0, 6),
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                            }),
                            Creator.New("UIPadding", {
                                PaddingLeft = UDim.new(0, 8),
                            }),
                        })

                        -- Icon
                        if item.Icon then
                            local iconId = Library:GetIcon(item.Icon) or item.Icon
                            Creator.New("ImageLabel", {
                                Size = UDim2.fromOffset(14, 14),
                                BackgroundTransparency = 1,
                                Image = iconId,
                                LayoutOrder = 1,
                                Parent = btn,
                                ImageColor3 = item.Danger and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(200, 200, 200),
                            })
                        end

                        Creator.New("TextLabel", {
                            Size = UDim2.new(1, -30, 1, 0),
                            BackgroundTransparency = 1,
                            Text = item.Label or "",
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                            LayoutOrder = 2,
                            Parent = btn,
                            TextColor3 = item.Danger and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(220, 220, 220),
                        })

                        local Motor, SetT = Creator.SpringMotor(1, btn, "BackgroundTransparency")
                        Creator.AddSignal(btn.MouseEnter, function() SetT(0.85) end)
                        Creator.AddSignal(btn.MouseLeave, function() SetT(1) end)
                        Creator.AddSignal(btn.MouseButton1Click, function()
                            closeContext()
                            Library:SafeCallback(item.Callback)
                        end)
                        totalH = totalH + 32
                    end
                end

                ContextMenuFrame.Size = UDim2.fromOffset(180, totalH)
                -- ตำแหน่ง
                local mx = Mouse.X
                local my = Mouse.Y
                local vp = Camera.ViewportSize
                if mx + 180 > vp.X then mx = vp.X - 185 end
                if my + totalH > vp.Y then my = vp.Y - totalH - 5 end
                ContextMenuFrame.Position = UDim2.fromOffset(mx, my)
                ContextInner.Size = UDim2.fromScale(1, 1)
                ContextMenuFrame.Visible = true
            end
        end)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [6] INLINE COLOR PICKER
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Section:AddInlineColorPicker("MyColor", {
        Title = "Accent Color",
        Default = Color3.fromRGB(105, 215, 255),
        Transparency = false,
        Callback = function(color) print(color) end,
    })
]]
ElementsTable.InlineColorPicker = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "InlineColorPicker"

    function Element:New(Idx, Config)
        assert(Config.Title, "InlineColorPicker - Missing Title")
        assert(Config.Default, "InlineColorPicker - Missing Default")

        local ICP = {
            Value = Config.Default,
            Transparency = Config.Transparency or 0,
            Type = "InlineColorPicker",
            Callback = Config.Callback or function() end,
        }

        local function setHSV(c)
            local h, s, v = Color3.toHSV(c)
            ICP.Hue, ICP.Sat, ICP.Vib = h, s, v
        end
        setHSV(ICP.Value)

        local OuterFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)

        -- preview swatch
        local Swatch = Creator.New("Frame", {
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(1, -10, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = ICP.Value,
            Parent = OuterFrame.Frame,
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 5) }),
            Creator.New("UIStroke", { Transparency = 0.5, ThemeTag = { Color = "InElementBorder" } }),
        })

        -- Expandable picker panel
        local PickerPanel = Creator.New("Frame", {
            Size = UDim2.new(1, -20, 0, 0),
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = OuterFrame.LabelHolder,
            LayoutOrder = 5,
        })

        local PickerInner = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 170),
            BackgroundTransparency = 0.92,
            Parent = PickerPanel,
            ThemeTag = { BackgroundColor3 = "Element" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        })

        local isOpen = false
        local PANEL_H = Config.Transparency and 195 or 170

        local function refreshSwatch()
            ICP.Value = Color3.fromHSV(ICP.Hue, ICP.Sat, ICP.Vib)
            Swatch.BackgroundColor3 = ICP.Value
            Library:SafeCallback(ICP.Callback, ICP.Value)
            Library:SafeCallback(ICP.Changed, ICP.Value)
        end

        -- SatVib map
        local SatCursor = Creator.New("ImageLabel", {
            Size = UDim2.fromOffset(14, 14),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "http://www.roblox.com/asset/?id=4805639000",
        })

        local SatMap = Creator.New("ImageLabel", {
            Size = UDim2.fromOffset(140, 120),
            Position = UDim2.fromOffset(8, 8),
            Image = "rbxassetid://4155801252",
            BackgroundColor3 = ICP.Value,
            Parent = PickerInner,
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
            SatCursor,
        })

        -- Hue slider
        local HueDrag = Creator.New("ImageLabel", {
            Size = UDim2.fromOffset(12, 12),
            Image = "http://www.roblox.com/asset/?id=12266946128",
            ThemeTag = { ImageColor3 = "DialogInput" },
        })
        local HueSeq = {}
        for c = 0, 1, 0.1 do table.insert(HueSeq, ColorSequenceKeypoint.new(c, Color3.fromHSV(c, 1, 1))) end

        local HueSlider = Creator.New("Frame", {
            Size = UDim2.fromOffset(12, 140),
            Position = UDim2.fromOffset(156, 8),
            Parent = PickerInner,
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            Creator.New("UIGradient", { Color = ColorSequence.new(HueSeq), Rotation = 90 }),
            Creator.New("Frame", {
                Size = UDim2.new(1, 0, 1, -10),
                Position = UDim2.fromOffset(0, 5),
                BackgroundTransparency = 1,
            }, { HueDrag }),
        })

        local function display()
            SatMap.BackgroundColor3 = Color3.fromHSV(ICP.Hue, 1, 1)
            HueDrag.Position = UDim2.new(0, -1, ICP.Hue, -6)
            SatCursor.Position = UDim2.new(ICP.Sat, 0, 1 - ICP.Vib, 0)
            refreshSwatch()
        end

        Creator.AddSignal(SatMap.InputBegan, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local mn = SatMap.AbsolutePosition
                    local mx2 = mn + SatMap.AbsoluteSize
                    ICP.Sat = math.clamp((Mouse.X - mn.X) / (mx2.X - mn.X), 0, 1)
                    ICP.Vib = 1 - math.clamp((Mouse.Y - mn.Y) / (mx2.Y - mn.Y), 0, 1)
                    display()
                    RenderStepped:Wait()
                end
            end
        end)

        Creator.AddSignal(HueSlider.InputBegan, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local mn = HueSlider.AbsolutePosition
                    local mx2 = mn + HueSlider.AbsoluteSize
                    ICP.Hue = math.clamp((Mouse.Y - mn.Y) / (mx2.Y - mn.Y), 0, 1)
                    display()
                    RenderStepped:Wait()
                end
            end
        end)

        -- Toggle open/close
        Creator.AddSignal(OuterFrame.Frame.MouseButton1Click, function()
            isOpen = not isOpen
            TweenService:Create(PickerPanel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -20, 0, isOpen and (PANEL_H + 10) or 0)
            }):Play()
        end)

        display()

        function ICP:SetValue(color, trans)
            ICP.Transparency = trans or 0
            setHSV(color)
            display()
        end

        function ICP:OnChanged(Func) ICP.Changed = Func Func(ICP.Value) end
        function ICP:Destroy() OuterFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

        if Idx then Library.Options[Idx] = ICP end
        return ICP
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [7] CONFIG AUTO-SAVE
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    SaveManager:EnableAutoSave("myconfig", 3)  -- auto-save ทุก 3 วินาที
    SaveManager:DisableAutoSave()
]]
do
    local _autoSaveConn = nil
    local _autoSaveDirty = false

    function SaveManager:EnableAutoSave(configName, debounceSeconds)
        debounceSeconds = debounceSeconds or 2
        if _autoSaveConn then _autoSaveConn:Disconnect() end

        -- Mark dirty เมื่อค่า option เปลี่ยน
        local function hookOptions()
            for idx, opt in pairs(Library.Options) do
                if opt and opt.OnChanged and not opt._autoSaveHooked then
                    opt._autoSaveHooked = true
                    pcall(function()
                        local orig = opt.Callback
                        opt.Callback = function(...)
                            _autoSaveDirty = true
                            if orig then Library:SafeCallback(orig, ...) end
                        end
                    end)
                end
            end
        end

        -- ตรวจสอบและ save เป็นระยะ
        _autoSaveConn = RunService.Heartbeat:Connect(function()
            hookOptions()
        end)

        -- Timer save จริง
        task.spawn(function()
            while _autoSaveConn do
                task.wait(debounceSeconds)
                if _autoSaveDirty and configName then
                    _autoSaveDirty = false
                    local ok = pcall(function() SaveManager:Save(configName) end)
                    if ok then
                        Library:Notify({
                            Title = "Auto-Save",
                            Content = "Config saved automatically",
                            Duration = 1.5,
                            Type = "success",
                        })
                    end
                end
            end
        end)
    end

    function SaveManager:DisableAutoSave()
        if _autoSaveConn then
            _autoSaveConn:Disconnect()
            _autoSaveConn = nil
        end
        _autoSaveDirty = false
    end

    function SaveManager:MarkDirty()
        _autoSaveDirty = true
    end
end

-- ──────────────────────────────────────────────────────────────
-- [9] BATCH DESTROY
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    -- ลบทุก element ใน section
    Library:DestroySection(section)

    -- ลบทุก element ใน tab
    Library:DestroyTab(tab)

    -- ลบทุก element ตาม predicate
    Library:DestroyWhere(function(idx, opt) return opt.Type == "Toggle" end)
]]
do
    function Library:DestroySection(section)
        if not section or not section.Container then return end
        local children = section.Container:GetChildren()
        for _, child in ipairs(children) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                -- หา option ที่ผูกกับ frame นี้
                for idx, opt in pairs(Library.Options) do
                    if opt and opt.Elements and opt.Elements.Frame == child then
                        Library:SafeCallback(function()
                            opt:Destroy()
                        end)
                        break
                    end
                end
                pcall(function() child:Destroy() end)
            end
        end
    end

    function Library:DestroyTab(tab)
        if not tab or not tab.Container then return end
        -- ลบทุก section และ element ใน tab
        local children = tab.Container:GetChildren()
        for _, child in ipairs(children) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                pcall(function() child:Destroy() end)
            end
        end
        -- ลบ options ที่อยู่ใน tab นี้
        for idx, opt in pairs(Library.Options) do
            if opt and opt.Elements and opt.Elements.Frame then
                if not opt.Elements.Frame:IsDescendantOf(game) then
                    Library.Options[idx] = nil
                end
            end
        end
    end

    function Library:DestroyWhere(predicate)
        local toRemove = {}
        for idx, opt in pairs(Library.Options) do
            if predicate(idx, opt) then
                table.insert(toRemove, { idx = idx, opt = opt })
            end
        end
        for _, item in ipairs(toRemove) do
            pcall(function()
                if item.opt.Destroy then
                    item.opt:Destroy()
                elseif item.opt.Elements and item.opt.Elements.Frame then
                    item.opt.Elements.Frame:Destroy()
                end
            end)
            Library.Options[item.idx] = nil
        end
    end

    function Library:DestroyAll()
        local allOpts = {}
        for idx, opt in pairs(Library.Options) do
            table.insert(allOpts, { idx = idx, opt = opt })
        end
        for _, item in ipairs(allOpts) do
            pcall(function()
                if item.opt and item.opt.Destroy then
                    item.opt:Destroy()
                end
            end)
            Library.Options[item.idx] = nil
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- [10] THEME EDITOR แบบ REAL-TIME
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:OpenThemeEditor()   -- เปิด theme editor popup
    Library:ExportTheme()       -- return theme table ปัจจุบัน
    Library:ImportTheme(tbl)    -- โหลด theme จาก table
]]
do
    local _themeEditorOpen = false

    function Library:OpenThemeEditor()
        if _themeEditorOpen then return end
        _themeEditorOpen = true

        local Dialog = Components.Dialog:Create()
        Dialog.Title.Text = "Theme Editor"
        Dialog.Root.Size = UDim2.fromOffset(500, 420)

        local props = {
            "Accent", "AcrylicMain", "AcrylicBorder",
            "TitleBarLine", "Tab", "Element", "ElementBorder",
            "InElementBorder", "Text", "SubText", "Hover",
        }

        local scrollFrame = Creator.New("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -80),
            Position = UDim2.fromOffset(10, 55),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = Dialog.Root,
        }, {
            Creator.New("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            Creator.New("UIPadding", { PaddingBottom = UDim.new(0, 8) }),
        })

        local currentThemeData = {}
        -- Copy current theme
        for _, prop in ipairs(props) do
            local val = Creator.GetThemeProperty(prop)
            if val then currentThemeData[prop] = val end
        end

        local swatches = {}

        for i, prop in ipairs(props) do
            local color = currentThemeData[prop] or Color3.fromRGB(100, 100, 100)
            local row = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                LayoutOrder = i,
                Parent = scrollFrame,
            }, {
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8),
                }),
                Creator.New("TextLabel", {
                    Size = UDim2.new(0.55, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = prop,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    ThemeTag = { TextColor3 = "Text" },
                }),
            })

            local swatch = Creator.New("Frame", {
                Size = UDim2.fromOffset(22, 22),
                BackgroundColor3 = color,
                Parent = row,
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("UIStroke", { Transparency = 0.5, ThemeTag = { Color = "InElementBorder" } }),
            })
            swatches[prop] = swatch

            -- Hex input
            local hexBox = Creator.New("TextBox", {
                Size = UDim2.new(0.35, -30, 0, 24),
                BackgroundTransparency = 0.85,
                Text = "#" .. color:ToHex():upper(),
                TextSize = 11,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                ClearTextOnFocus = false,
                Parent = row,
                ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 4) }),
            })

            Creator.AddSignal(hexBox.FocusLost, function(enter)
                local ok, newColor = pcall(Color3.fromHex, hexBox.Text)
                if ok and typeof(newColor) == "Color3" then
                    currentThemeData[prop] = newColor
                    swatch.BackgroundColor3 = newColor
                    -- Apply real-time
                    if Themes[Library.Theme] then
                        Themes[Library.Theme][prop] = newColor
                        Creator.UpdateTheme()
                    end
                else
                    hexBox.Text = "#" .. (currentThemeData[prop] or Color3.fromRGB(100,100,100)):ToHex():upper()
                end
            end)
        end

        -- Export button
        Dialog:Button("Export to Clipboard", function()
            local out = "{\n"
            for prop, color in pairs(currentThemeData) do
                out = out .. string.format('\t%s = Color3.fromRGB(%d, %d, %d),\n',
                    prop,
                    math.floor(color.R * 255),
                    math.floor(color.G * 255),
                    math.floor(color.B * 255)
                )
            end
            out = out .. "}"
            pcall(function()
                if setclipboard then setclipboard(out)
                elseif toclipboard then toclipboard(out) end
            end)
            Library:Notify({ Title = "Theme Editor", Content = "Theme copied to clipboard!", Duration = 3, Type = "success" })
        end)
        Dialog:Button("Close", function()
            _themeEditorOpen = false
        end)

        Dialog:Open()
    end

    function Library:ExportTheme()
        local out = {}
        local props = { "Accent","AcrylicMain","AcrylicBorder","TitleBarLine","Tab","Element",
                        "ElementBorder","InElementBorder","Text","SubText","Hover","HoverChange",
                        "ElementTransparency","ToggleSlider","ToggleToggled","SliderRail",
                        "DropdownFrame","DropdownHolder","DropdownBorder","DropdownOption",
                        "Keybind","Input","InputFocused","InputIndicator","InputIndicatorFocus" }
        for _, prop in ipairs(props) do
            out[prop] = Creator.GetThemeProperty(prop)
        end
        return out
    end

    function Library:ImportTheme(themeTable)
        assert(type(themeTable) == "table", "ImportTheme: expected table")
        local themeName = themeTable.Name or ("Custom_" .. tostring(tick()):sub(-4))
        Themes[themeName] = themeTable
        if not table.find(Themes.Names, themeName) then
            table.insert(Themes.Names, themeName)
        end
        Library:SetTheme(themeName)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [14] WINDOW BORDER GLOW / SHADOW
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:SetWindowGlow(true)                          -- เปิด glow (ใช้สี Accent)
    Library:SetWindowGlow(true, Color3.fromRGB(255,0,0)) -- กำหนดสีเอง
    Library:SetWindowGlow(false)                         -- ปิด glow
]]
do
    local _glowFrame = nil

    function Library:SetWindowGlow(enabled, color)
        if not Library.Window or not Library.Window.Root then return end

        if not enabled then
            if _glowFrame then
                TweenService:Create(_glowFrame, TweenInfo.new(0.3), { ImageTransparency = 1 }):Play()
                task.delay(0.3, function()
                    if _glowFrame then _glowFrame:Destroy() _glowFrame = nil end
                end)
            end
            return
        end

        local glowColor = color or Creator.GetThemeProperty("Accent") or Color3.fromRGB(105, 215, 255)

        if not _glowFrame then
            _glowFrame = Creator.New("ImageLabel", {
                Name = "WindowGlow",
                Size = UDim2.new(1, 60, 1, 60),
                Position = UDim2.new(0, -30, 0, -30),
                BackgroundTransparency = 1,
                Image = "rbxassetid://5028857084",
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(24, 24, 276, 276),
                ImageTransparency = 1,
                ZIndex = 0,
                Parent = Library.Window.Root,
            })
        end

        _glowFrame.ImageColor3 = glowColor
        TweenService:Create(_glowFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            ImageTransparency = 0.55,
        }):Play()

        -- Pulse animation
        task.spawn(function()
            while _glowFrame and _glowFrame.Parent do
                TweenService:Create(_glowFrame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0.65,
                }):Play()
                task.wait(2)
                if not (_glowFrame and _glowFrame.Parent) then break end
                TweenService:Create(_glowFrame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    ImageTransparency = 0.45,
                }):Play()
                task.wait(2)
            end
        end)
    end

    function Library:UpdateGlowColor(color)
        if _glowFrame then
            TweenService:Create(_glowFrame, TweenInfo.new(0.3), { ImageColor3 = color }):Play()
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- [15] ELEMENT HIGHLIGHT ON SEARCH
-- ──────────────────────────────────────────────────────────────
-- Patch UpdateElementVisibility ให้ highlight ข้อความที่ตรงกับ search term
do
    local _origUpdateVisibility = nil

    -- เพิ่ม highlight function ให้ Library
    function Library:HighlightSearchMatch(textLabel, searchTerm)
        if not textLabel or not textLabel:IsA("TextLabel") then return end
        if not searchTerm or searchTerm == "" then
            -- ลบ highlight ออก ถ้ามี
            if textLabel:FindFirstChild("SearchHighlight") then
                textLabel:FindFirstChild("SearchHighlight"):Destroy()
            end
            return
        end

        local text = textLabel.Text or ""
        local lower = text:lower()
        local lowerSearch = searchTerm:lower()
        local startIdx = lower:find(lowerSearch, 1, true)
        if not startIdx then return end

        -- คำนวณตำแหน่ง highlight
        local before = text:sub(1, startIdx - 1)
        local match = text:sub(startIdx, startIdx + #searchTerm - 1)

        local beforeWidth = TextService:GetTextSize(
            before,
            textLabel.TextSize,
            textLabel.Font,
            Vector2.new(math.huge, math.huge)
        ).X

        local matchWidth = TextService:GetTextSize(
            match,
            textLabel.TextSize,
            textLabel.Font,
            Vector2.new(math.huge, math.huge)
        ).X

        -- สร้าง/อัปเดต highlight frame
        local hl = textLabel:FindFirstChild("SearchHighlight")
        if not hl then
            hl = Creator.New("Frame", {
                Name = "SearchHighlight",
                BackgroundColor3 = Creator.GetThemeProperty("Accent") or Color3.fromRGB(105, 215, 255),
                BackgroundTransparency = 0.65,
                ZIndex = textLabel.ZIndex - 1,
                Parent = textLabel,
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 2) }),
            })
        end

        hl.Size = UDim2.new(0, matchWidth + 4, 1, -2)
        hl.Position = UDim2.new(0, beforeWidth - 2, 0, 1)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [16] DARK/LIGHT MODE TOGGLE แบบ ANIMATED
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:ToggleDarkLight()   -- สลับระหว่าง Dark/Light แบบ animated
    Library:SetDarkMode(true)   -- บังคับ Dark mode
    Library:SetDarkMode(false)  -- บังคับ Light mode
]]
do
    Library._isDarkMode = true

    function Library:ToggleDarkLight()
        self._isDarkMode = not self._isDarkMode
        self:SetDarkMode(self._isDarkMode)
    end

    function Library:SetDarkMode(isDark)
        self._isDarkMode = isDark
        local targetTheme = isDark and "Dark" or "Light"

        -- ถ้า theme ปัจจุบันเป็นธีมที่ custom ให้ map ไป Dark/Light ตาม tone
        if not table.find({ "Dark", "Darker", "AMOLED", "Midnight", "Forest",
                             "Sunset", "Ocean", "Emerald", "Sapphire", "Cloud",
                             "Grape", "Bloody", "Arctic", "Neon", "Lavender",
                             "Cyberpunk", "Sakura", "Toxic", "Gold", "Volcanic",
                             "Galaxy", "Coral" }, Library.Theme) then
            -- custom theme, ไม่บังคับ override
        else
            if isDark and (Library.Theme == "Light" or Library.Theme == "Balloon" or
                           Library.Theme == "SoftCream" or Library.Theme == "Mint") then
                targetTheme = "Dark"
            elseif not isDark and (Library.Theme == "Dark" or Library.Theme == "Darker" or
                                    Library.Theme == "AMOLED") then
                targetTheme = "Light"
            else
                targetTheme = Library.Theme
            end
        end

        -- Flash animation ระหว่างเปลี่ยน theme
        if Library.Window and Library.Window.Root then
            local flashFrame = Creator.New("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = isDark and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                ZIndex = 9998,
                Parent = Library.Window.Root,
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            })

            TweenService:Create(flashFrame, TweenInfo.new(0.12), { BackgroundTransparency = 0.7 }):Play()
            task.wait(0.12)
            Library:SetTheme(targetTheme)
            TweenService:Create(flashFrame, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
            task.delay(0.25, function() flashFrame:Destroy() end)
        else
            Library:SetTheme(targetTheme)
        end

        Library:Notify({
            Title = "Theme",
            Content = isDark and "Switched to Dark Mode" or "Switched to Light Mode",
            Duration = 2,
            Type = "info",
        })
    end
end

-- Register ใหม่ใน Elements
do
    for _, ElementComponent in pairs({
        ElementsTable.Table,
        ElementsTable.InlineColorPicker,
    }) do
        if ElementComponent and ElementComponent.__type then
            Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
                ElementComponent.Container = self.Container
                ElementComponent.Type = self.Type
                ElementComponent.ScrollFrame = self.ScrollFrame
                ElementComponent.Library = Library
                if ElementComponent.NoIdx then
                    return ElementComponent:New(Idx)
                end
                return ElementComponent:New(Idx, Config)
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- ✨ FEATURE PACK - PART 2: NEW ELEMENTS
-- ═══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- [18] IMAGE ELEMENT
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Section:AddImage({
        Image = "rbxassetid://12345678",
        Caption = "My Screenshot",
        AspectRatio = 16/9,    -- optional
        Height = 120,           -- optional, default 120
    })
]]
ElementsTable.Image = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Image"
    Element.NoIdx = true

    function Element:New(Config)
        Config = Config or {}
        assert(Config.Image, "Image - Missing Image asset")

        local h = Config.Height or 120
        local Img = { Type = "Image" }

        local Root = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, h + (Config.Caption and 22 or 0)),
            BackgroundTransparency = 0.92,
            Parent = self.Container,
            LayoutOrder = 7,
            ThemeTag = { BackgroundColor3 = "Element" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("UIStroke", {
                Transparency = 0.55,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                ThemeTag = { Color = "ElementBorder" },
            }),
        })

        local ImgLabel = Creator.New("ImageLabel", {
            Size = UDim2.new(1, 0, 0, h),
            BackgroundTransparency = 1,
            Image = Config.Image,
            ScaleType = Enum.ScaleType.Fit,
            Parent = Root,
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        })

        if Config.AspectRatio then
            Creator.New("UIAspectRatioConstraint", {
                AspectRatio = Config.AspectRatio,
                Parent = ImgLabel,
            })
        end

        if Config.Caption then
            Creator.New("TextLabel", {
                Size = UDim2.new(1, -16, 0, 20),
                Position = UDim2.new(0, 8, 0, h + 1),
                BackgroundTransparency = 1,
                Text = Config.Caption,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                Parent = Root,
                ThemeTag = { TextColor3 = "SubText" },
            })
        end

        function Img:SetImage(asset)
            ImgLabel.Image = asset
        end

        function Img:SetCaption(text)
            local lbl = Root:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.Text = text end
        end

        function Img:Destroy() Root:Destroy() end

        return Img
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [19] PROGRESS STEPS / WIZARD
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    local wizard = Section:AddProgressSteps({
        Title = "Setup",
        Steps = { "Connect", "Configure", "Done" },
        Current = 1,
    })
    wizard:SetStep(2)       -- ไปขั้นตอนที่ 2
    wizard:NextStep()       -- ขั้นตอนถัดไป
    wizard:PrevStep()       -- ขั้นตอนก่อนหน้า
]]
ElementsTable.ProgressSteps = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "ProgressSteps"
    Element.NoIdx = true

    function Element:New(Config)
        Config = Config or {}
        assert(Config.Steps and #Config.Steps > 0, "ProgressSteps - Missing Steps")

        local PS = {
            Type = "ProgressSteps",
            Current = Config.Current or 1,
            Total = #Config.Steps,
            OnChange = Config.OnChange or function() end,
        }

        local OuterFrame = Components.Element(Config.Title or "", "", self.Container, false, Config)
        OuterFrame.Frame.BackgroundTransparency = 0.9

        local StepHolder = Creator.New("Frame", {
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            Parent = OuterFrame.LabelHolder,
            LayoutOrder = 3,
        })

        local stepButtons = {}
        local n = #Config.Steps

        for i, stepName in ipairs(Config.Steps) do
            local xPos = (i - 1) / math.max(n - 1, 1)

            -- Dot
            local dot = Creator.New("Frame", {
                Size = UDim2.fromOffset(22, 22),
                Position = UDim2.new(xPos, -11, 0.3, -11),
                AnchorPoint = Vector2.new(0, 0),
                BackgroundTransparency = 0.5,
                Parent = StepHolder,
                ThemeTag = { BackgroundColor3 = "Accent" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                Creator.New("UIAspectRatioConstraint", { AspectRatio = 1 }),
                Creator.New("TextLabel", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = tostring(i),
                    TextSize = 11,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                }),
            })

            -- Label
            Creator.New("TextLabel", {
                Size = UDim2.new(0, 60, 0, 14),
                Position = UDim2.new(xPos, -30, 0.3, 16),
                BackgroundTransparency = 1,
                Text = stepName,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Center,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                Parent = StepHolder,
                ThemeTag = { TextColor3 = "SubText" },
            })

            -- Connector line (ยกเว้นตัวสุดท้าย)
            if i < n then
                local lineW = 1 / math.max(n - 1, 1)
                Creator.New("Frame", {
                    Size = UDim2.new(lineW, -22, 0, 2),
                    Position = UDim2.new(xPos, 11, 0.3, -1),
                    BackgroundTransparency = 0.6,
                    Parent = StepHolder,
                    ThemeTag = { BackgroundColor3 = "InElementBorder" },
                })
            end

            stepButtons[i] = dot
        end

        local function updateVisuals()
            for i, dot in ipairs(stepButtons) do
                local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
                if i < PS.Current then
                    -- completed
                    TweenService:Create(dot, ti, { BackgroundTransparency = 0, Size = UDim2.fromOffset(22, 22) }):Play()
                    local lbl = dot:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.Text = "✓" end
                elseif i == PS.Current then
                    -- current
                    TweenService:Create(dot, ti, { BackgroundTransparency = 0, Size = UDim2.fromOffset(26, 26) }):Play()
                    local lbl = dot:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.Text = tostring(i) end
                else
                    -- future
                    TweenService:Create(dot, ti, { BackgroundTransparency = 0.7, Size = UDim2.fromOffset(22, 22) }):Play()
                    local lbl = dot:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.Text = tostring(i) end
                end
            end
        end

        function PS:SetStep(step)
            self.Current = math.clamp(step, 1, self.Total)
            updateVisuals()
            Library:SafeCallback(self.OnChange, self.Current)
        end

        function PS:NextStep()
            self:SetStep(self.Current + 1)
        end

        function PS:PrevStep()
            self:SetStep(self.Current - 1)
        end

        function PS:OnChanged(Func)
            self.OnChange = Func
        end

        function PS:Destroy() OuterFrame.Frame:Destroy() end

        updateVisuals()
        return PS
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [20] MARKDOWN TEXT RENDERER
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Section:AddMarkdown({
        Text = "**Bold** and *italic* and `code` here\n## Header",
    })
    -- หรือใช้ฟังก์ชัน convert โดยตรง
    local richText = Library:MarkdownToRichText("**hello** world")
]]
do
    function Library:MarkdownToRichText(text)
        if type(text) ~= "string" then return tostring(text) end
        local result = text

        -- Headers
        result = result:gsub("^## (.+)$",  '<font size="16"><b>%1</b></font>')
        result = result:gsub("^# (.+)$",   '<font size="20"><b>%1</b></font>')
        result = result:gsub("\n## (.+)",  '\n<font size="16"><b>%1</b></font>')
        result = result:gsub("\n# (.+)",   '\n<font size="20"><b>%1</b></font>')

        -- Bold+Italic ***text***
        result = result:gsub("%*%*%*(.-)%*%*%*", "<b><i>%1</i></b>")
        -- Bold **text**
        result = result:gsub("%*%*(.-)%*%*", "<b>%1</b>")
        -- Italic *text*
        result = result:gsub("%*(.-)%*", "<i>%1</i>")
        -- Strikethrough ~~text~~
        result = result:gsub("~~(.-)~~", "<s>%1</s>")
        -- Underline __text__
        result = result:gsub("__(.-)__", "<u>%1</u>")
        -- Inline code `text`
        result = result:gsub("`(.-)``", '<font color="#A8FF60" face="RobotoMono">%1</font>')
        result = result:gsub("`(.-)`", '<font color="#A8FF60">%1</font>')
        -- Newline
        result = result:gsub("\\n", "\n")

        return result
    end
end

ElementsTable.Markdown = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Markdown"
    Element.NoIdx = true

    function Element:New(Config)
        Config = Config or {}
        assert(Config.Text, "Markdown - Missing Text")

        local MD = { Type = "Markdown" }
        local richText = Library:MarkdownToRichText(Config.Text)

        local Root = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 0.92,
            Parent = self.Container,
            LayoutOrder = 7,
            ThemeTag = { BackgroundColor3 = "Element" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("UIStroke", {
                Transparency = 0.55,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                ThemeTag = { Color = "ElementBorder" },
            }),
            Creator.New("UIPadding", {
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
            }),
        })

        local TextLbl = Creator.New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = richText,
            RichText = true,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            Parent = Root,
            ThemeTag = { TextColor3 = "Text" },
        })

        function MD:SetText(text)
            TextLbl.Text = Library:MarkdownToRichText(text)
        end

        function MD:Destroy() Root:Destroy() end
        return MD
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [22] CODE BLOCK ELEMENT
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Section:AddCodeBlock({
        Title = "Example",
        Code = 'local x = Library:GetIcon("sword")',
        Language = "lua",   -- optional (visual only)
        MaxLines = 8,
    })
]]
ElementsTable.CodeBlock = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "CodeBlock"
    Element.NoIdx = true

    local LuaKeywords = {
        "local","function","end","if","then","else","elseif","for","do",
        "while","repeat","until","return","true","false","nil","and","or","not",
        "in","break","continue",
    }

    local function syntaxHighlight(code)
        -- escape RichText
        local result = code
            :gsub("&", "&amp;")
            :gsub("<", "&lt;")
            :gsub(">", "&gt;")

        -- strings
        result = result:gsub('(".-")', '<font color="#FFC66D">%1</font>')
        result = result:gsub("('.-')", '<font color="#FFC66D">%1</font>')
        -- numbers
        result = result:gsub("(%f[%w]%d+%.?%d*%f[%W])", '<font color="#6897BB">%1</font>')
        -- comments
        result = result:gsub("(%-%-[^\n]*)", '<font color="#808080">%1</font>')
        -- keywords
        for _, kw in ipairs(LuaKeywords) do
            result = result:gsub(
                "%f[%a](" .. kw .. ")%f[%A]",
                '<font color="#CC7832"><b>%1</b></font>'
            )
        end

        return result
    end

    function Element:New(Config)
        Config = Config or {}
        assert(Config.Code, "CodeBlock - Missing Code")

        local CB = { Type = "CodeBlock" }
        local maxH = (Config.MaxLines or 8) * 18 + 20

        local Root = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = self.Container,
            LayoutOrder = 7,
        })

        -- Header bar
        local Header = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundTransparency = 0.7,
            Parent = Root,
            ThemeTag = { BackgroundColor3 = "AcrylicMain" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = (Config.Language or "lua") .. (Config.Title and (" — " .. Config.Title) or ""),
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                ThemeTag = { TextColor3 = "SubText" },
            }),
        })

        -- Copy button
        local CopyBtn = Creator.New("TextButton", {
            Size = UDim2.fromOffset(55, 20),
            Position = UDim2.new(1, -8, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 0.75,
            Text = "Copy",
            TextSize = 11,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            Parent = Header,
            ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
        })

        Creator.AddSignal(CopyBtn.MouseButton1Click, function()
            pcall(function()
                if setclipboard then setclipboard(Config.Code)
                elseif toclipboard then toclipboard(Config.Code) end
            end)
            CopyBtn.Text = "✓"
            task.delay(1.5, function()
                if CopyBtn and CopyBtn.Parent then CopyBtn.Text = "Copy" end
            end)
        end)

        -- Code area
        local CodeScroll = Creator.New("ScrollingFrame", {
            Size = UDim2.new(1, 0, 0, math.min(maxH, 200)),
            Position = UDim2.fromOffset(0, 28),
            BackgroundTransparency = 0.85,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = Root,
            ThemeTag = { BackgroundColor3 = "AcrylicMain" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
            }),
        })

        Root.Size = UDim2.new(1, 0, 0, 28 + math.min(maxH, 200))

        Creator.New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = syntaxHighlight(Config.Code),
            RichText = true,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
            Parent = CodeScroll,
            ThemeTag = { TextColor3 = "Text" },
        })

        function CB:SetCode(code)
            Config.Code = code
            local lbl = CodeScroll:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.Text = syntaxHighlight(code) end
        end

        function CB:Destroy() Root:Destroy() end
        return CB
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [25] RATING ELEMENT
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Section:AddRating("MyRating", {
        Title = "Rate this",
        Max = 5,
        Default = 3,
        AllowHalf = false,
        Callback = function(value) print(value) end,
    })
]]
ElementsTable.Rating = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Rating"

    function Element:New(Idx, Config)
        Config = Config or {}
        assert(Config.Title, "Rating - Missing Title")
        Config.Max = Config.Max or 5
        Config.Default = Config.Default or 0

        local Rating = {
            Value = Config.Default,
            Max = Config.Max,
            Type = "Rating",
            Callback = Config.Callback or function() end,
        }

        local RFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        Rating.SetTitle = RFrame.SetTitle
        Rating.SetDesc = RFrame.SetDesc

        local StarHolder = Creator.New("Frame", {
            Size = UDim2.fromOffset(Config.Max * 26, 26),
            Position = UDim2.new(1, -10, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Parent = RFrame.Frame,
        }, {
            Creator.New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 2),
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }),
        })

        local Stars = {}
        local STAR_FULL = "rbxassetid://10734966248"
        local STAR_EMPTY = "rbxassetid://10734966097"

        local function updateStars(hoverValue)
            local displayVal = hoverValue or Rating.Value
            for i, star in ipairs(Stars) do
                TweenService:Create(star, TweenInfo.new(0.1), {
                    ImageColor3 = i <= displayVal
                        and (Creator.GetThemeProperty("Accent") or Color3.fromRGB(255, 195, 0))
                        or Color3.fromRGB(80, 80, 90),
                    Size = i <= displayVal and UDim2.fromOffset(22, 22) or UDim2.fromOffset(20, 20),
                }):Play()
            end
        end

        for i = 1, Config.Max do
            local star = Creator.New("ImageLabel", {
                Size = UDim2.fromOffset(20, 20),
                BackgroundTransparency = 1,
                Image = STAR_FULL,
                ImageColor3 = Color3.fromRGB(80, 80, 90),
                LayoutOrder = i,
                Parent = StarHolder,
            })

            local hitbox = Creator.New("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                Parent = star,
                ZIndex = star.ZIndex + 1,
            })

            Stars[i] = star

            Creator.AddSignal(hitbox.MouseEnter, function() updateStars(i) end)
            Creator.AddSignal(hitbox.MouseLeave, function() updateStars(nil) end)
            Creator.AddSignal(hitbox.MouseButton1Click, function()
                -- click ดาวเดิม = reset
                if Rating.Value == i then
                    Rating.Value = 0
                else
                    Rating.Value = i
                end
                updateStars(nil)
                Library:SafeCallback(Rating.Callback, Rating.Value)
                Library:SafeCallback(Rating.Changed, Rating.Value)
            end)
        end

        function Rating:SetValue(v)
            self.Value = math.clamp(v, 0, self.Max)
            updateStars(nil)
            Library:SafeCallback(self.Callback, self.Value)
            Library:SafeCallback(self.Changed, self.Value)
        end

        function Rating:OnChanged(Func) Rating.Changed = Func Func(Rating.Value) end
        function Rating:Destroy() RFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

        updateStars(nil)
        if Idx then Library.Options[Idx] = Rating end
        return Rating
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [27] RANGE SLIDER (TWO-HANDLE)
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Section:AddRangeSlider("MyRange", {
        Title = "HP Range",
        Min = 0, Max = 100,
        DefaultMin = 20, DefaultMax = 80,
        Rounding = 0,
        Callback = function(minVal, maxVal) end,
    })
]]
ElementsTable.RangeSlider = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "RangeSlider"

    function Element:New(Idx, Config)
        Config = Config or {}
        assert(Config.Title, "RangeSlider - Missing Title")
        assert(Config.Min ~= nil, "RangeSlider - Missing Min")
        assert(Config.Max ~= nil, "RangeSlider - Missing Max")
        Config.DefaultMin = Config.DefaultMin or Config.Min
        Config.DefaultMax = Config.DefaultMax or Config.Max
        Config.Rounding = Config.Rounding or 0

        local RS = {
            MinValue = Config.DefaultMin,
            MaxValue = Config.DefaultMax,
            Min = Config.Min,
            Max = Config.Max,
            Rounding = Config.Rounding,
            Type = "RangeSlider",
            Callback = Config.Callback or function() end,
        }

        local SliderFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        RS.SetTitle = SliderFrame.SetTitle
        RS.SetDesc = SliderFrame.SetDesc

        local DisplayLabel = Creator.New("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
            Text = "",
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(120, 14),
            Position = UDim2.new(0, -4, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            ThemeTag = { TextColor3 = "SubText" },
        })

        local Rail = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 6),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -10, 0.5, 0),
            BackgroundTransparency = 0.45,
            Parent = SliderFrame.Frame,
            ThemeTag = { BackgroundColor3 = "SliderRail" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            Creator.New("UISizeConstraint", { MaxSize = Vector2.new(180, math.huge) }),
            DisplayLabel,
        })

        local Fill = Creator.New("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 0,
            Parent = Rail,
            ThemeTag = { BackgroundColor3 = "Accent" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
        })

        local function makeDot()
            return Creator.New("Frame", {
                Size = UDim2.fromOffset(14, 14),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                BackgroundTransparency = 0,
                Parent = Rail,
                ThemeTag = { BackgroundColor3 = "Accent" },
                ZIndex = 3,
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                Creator.New("UIStroke", { Transparency = 0.4, Thickness = 2, ThemeTag = { Color = "AcrylicMain" } }),
            })
        end

        local MinDot = makeDot()
        local MaxDot = makeDot()

        local function roundVal(v)
            return Library:Round(math.clamp(v, RS.Min, RS.Max), RS.Rounding)
        end

        local function updateUI()
            local range = RS.Max - RS.Min
            local minPct = (RS.MinValue - RS.Min) / range
            local maxPct = (RS.MaxValue - RS.Min) / range
            MinDot.Position = UDim2.new(minPct, 0, 0.5, 0)
            MaxDot.Position = UDim2.new(maxPct, 0, 0.5, 0)
            Fill.Position = UDim2.new(minPct, 0, 0, 0)
            Fill.Size = UDim2.new(maxPct - minPct, 0, 1, 0)
            DisplayLabel.Text = tostring(RS.MinValue) .. " – " .. tostring(RS.MaxValue)
        end

        local function setupDrag(dot, isMin)
            local dragging = false
            Creator.AddSignal(dot.InputBegan, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            Creator.AddSignal(dot.InputEnded, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            Creator.AddSignal(UserInputService.InputChanged, function(inp)
                if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    local railAP = Rail.AbsolutePosition.X
                    local railAS = Rail.AbsoluteSize.X
                    local pct = math.clamp((Mouse.X - railAP) / railAS, 0, 1)
                    local val = roundVal(RS.Min + (RS.Max - RS.Min) * pct)
                    if isMin then
                        RS.MinValue = math.min(val, RS.MaxValue)
                    else
                        RS.MaxValue = math.max(val, RS.MinValue)
                    end
                    updateUI()
                    Library:SafeCallback(RS.Callback, RS.MinValue, RS.MaxValue)
                    Library:SafeCallback(RS.Changed, RS.MinValue, RS.MaxValue)
                end
            end)
        end

        setupDrag(MinDot, true)
        setupDrag(MaxDot, false)

        function RS:SetValue(minV, maxV)
            self.MinValue = roundVal(minV)
            self.MaxValue = roundVal(maxV)
            self.MinValue = math.min(self.MinValue, self.MaxValue)
            self.MaxValue = math.max(self.MinValue, self.MaxValue)
            updateUI()
            Library:SafeCallback(self.Callback, self.MinValue, self.MaxValue)
            Library:SafeCallback(self.Changed, self.MinValue, self.MaxValue)
        end

        function RS:GetValue() return self.MinValue, self.MaxValue end
        function RS:OnChanged(Func) RS.Changed = Func Func(RS.MinValue, RS.MaxValue) end
        function RS:Destroy() SliderFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

        RS:SetValue(Config.DefaultMin, Config.DefaultMax)
        if Idx then Library.Options[Idx] = RS end
        return RS
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [28] TOGGLE WITH SUB-ELEMENTS
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    local group = Section:AddToggleGroup("AimGroup", {
        Title = "Aimbot",
        Default = false,
        Callback = function(v) end,
    })
    group:AddSlider("AimFOV", { Title = "FOV", Min=1, Max=360, Default=90, Callback=... })
    group:AddDropdown("AimPart", { Title = "Target Part", Values={"Head","Torso"}, Default="Head" })
    -- sub-elements จะ enable/disable ตามสถานะ toggle
]]
ElementsTable.ToggleSubGroup = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "ToggleSubGroup"

    function Element:New(Idx, Config)
        Config = Config or {}
        assert(Config.Title, "ToggleSubGroup - Missing Title")

        local TSG = {
            Value = Config.Default or false,
            Type = "ToggleSubGroup",
            Callback = Config.Callback or function() end,
            _subElements = {},
        }

        -- สร้าง Toggle หลัก
        local toggle = ElementsTable.Toggle.Container and ElementsTable.Toggle or ElementsTable.Toggle
        local MainToggle = ElementsTable.Toggle:New(Idx, {
            Title = Config.Title,
            Description = Config.Description,
            Default = TSG.Value,
            Callback = function(v)
                TSG.Value = v
                TSG:_updateSubElements()
                Library:SafeCallback(TSG.Callback, v)
                Library:SafeCallback(TSG.Changed, v)
            end,
        })
        MainToggle.Container = self.Container

        -- Sub-element container
        local SubContainer = Creator.New("Frame", {
            Size = UDim2.new(1, -16, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.fromOffset(16, 0),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = self.Container,
            LayoutOrder = 8,
        }, {
            Creator.New("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            Creator.New("Frame", {
                Size = UDim2.new(0, 2, 1, 0),
                Position = UDim2.fromOffset(0, 0),
                BackgroundTransparency = 0.6,
                ThemeTag = { BackgroundColor3 = "Accent" },
            }),
        })

        -- proxy: AddXxx ไปที่ SubContainer
        local proxySection = {
            Container = SubContainer,
            ScrollFrame = self.ScrollFrame,
        }
        setmetatable(proxySection, Library.Elements)

        function TSG:_updateSubElements()
            for _, elem in ipairs(self._subElements) do
                if elem and elem.Frame then
                    elem.Frame.BackgroundTransparency = self.Value and
                        Creator.GetThemeProperty("ElementTransparency") or 0.96
                    -- visual dim ถ้า disabled
                    for _, child in pairs(elem.Frame:GetDescendants()) do
                        if child:IsA("TextLabel") or child:IsA("TextButton") then
                            if not self.Value then
                                child.TextTransparency = 0.5
                            else
                                child.TextTransparency = 0
                            end
                        end
                    end
                end
            end
            -- Animate height
            TweenService:Create(SubContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -16, 0, self.Value and SubContainer.UIListLayout and SubContainer.UIListLayout.AbsoluteContentSize.Y or 0)
            }):Play()
        end

        -- ให้ TSG ทำ AddXxx ได้ผ่าน proxy
        setmetatable(TSG, {
            __index = function(t, k)
                if proxySection[k] then return proxySection[k] end
                return rawget(t, k)
            end
        })

        function TSG:SetValue(v)
            self.Value = v
            -- Update toggle visual ผ่าน Library.Options
            if Library.Options[Idx] and Library.Options[Idx] ~= self then
                Library.Options[Idx]:SetValue(v)
            end
        end

        function TSG:OnChanged(Func) TSG.Changed = Func Func(TSG.Value) end
        function TSG:Destroy()
            if Library.Options[Idx] then Library.Options[Idx]:Destroy() end
            SubContainer:Destroy()
            Library.Options[Idx] = nil
        end

        if Idx then Library.Options[Idx] = TSG end
        return TSG
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [33] ELEMENT LOCKING
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:LockElement("MyToggle", "Admin only")     -- ล็อก
    Library:UnlockElement("MyToggle")                  -- ปลดล็อก
    Library:LockAll()                                  -- ล็อกทั้งหมด
    Library:UnlockAll()                                -- ปลดทั้งหมด
]]
do
    local _lockedElements = {}

    function Library:LockElement(idx, reason)
        local opt = Library.Options[idx]
        if not opt or not opt.Elements or not opt.Elements.Frame then return end

        _lockedElements[idx] = true
        local frame = opt.Elements.Frame

        -- overlay
        local overlay = frame:FindFirstChild("LockOverlay")
        if not overlay then
            overlay = Creator.New("Frame", {
                Name = "LockOverlay",
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.6,
                ZIndex = frame.ZIndex + 5,
                Parent = frame,
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 9) }),
                Creator.New("ImageLabel", {
                    Image = Library:GetIcon("lock") or "rbxassetid://10723434711",
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    ImageColor3 = Color3.fromRGB(200, 200, 200),
                }),
            })

            if reason then
                Creator.New("TextLabel", {
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = "🔒 " .. reason,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    Parent = overlay,
                })
            end
        end

        overlay.Visible = true
        TweenService:Create(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 0.6 }):Play()
    end

    function Library:UnlockElement(idx)
        _lockedElements[idx] = nil
        local opt = Library.Options[idx]
        if not opt or not opt.Elements or not opt.Elements.Frame then return end
        local overlay = opt.Elements.Frame:FindFirstChild("LockOverlay")
        if overlay then
            TweenService:Create(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
            task.delay(0.2, function()
                if overlay and overlay.Parent then overlay.Visible = false end
            end)
        end
    end

    function Library:IsLocked(idx)
        return _lockedElements[idx] == true
    end

    function Library:LockAll(reason)
        for idx in pairs(Library.Options) do
            Library:LockElement(idx, reason)
        end
    end

    function Library:UnlockAll()
        for idx in pairs(Library.Options) do
            Library:UnlockElement(idx)
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- [34] ELEMENT DEPENDENCIES
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    -- Element B จะ enable เฉพาะเมื่อ Element A เป็น true
    Library:SetDependency("ElementB_Idx", "ElementA_Idx", function(valueA)
        return valueA == true  -- condition
    end)

    -- หลาย dependency
    Library:SetDependency("ElementC", { "A", "B" }, function(vals)
        return vals["A"] and vals["B"]
    end)
]]
do
    local _dependencies = {}

    local function evalDependency(dep)
        local opt = Library.Options[dep.target]
        if not opt then return end

        local shouldEnable
        if type(dep.sources) == "string" then
            local src = Library.Options[dep.sources]
            local val = src and src.Value
            shouldEnable = dep.condition(val)
        else
            local vals = {}
            for _, srcIdx in ipairs(dep.sources) do
                local src = Library.Options[srcIdx]
                vals[srcIdx] = src and src.Value
            end
            shouldEnable = dep.condition(vals)
        end

        if shouldEnable then
            Library:UnlockElement(dep.target)
        else
            Library:LockElement(dep.target, "Requires: " .. tostring(
                type(dep.sources) == "string" and dep.sources or table.concat(dep.sources, ", ")
            ))
        end
    end

    function Library:SetDependency(targetIdx, sourceIdxOrTable, conditionFunc)
        local dep = {
            target = targetIdx,
            sources = sourceIdxOrTable,
            condition = conditionFunc,
        }
        table.insert(_dependencies, dep)

        -- hook source callbacks
        local sources = type(sourceIdxOrTable) == "string" and { sourceIdxOrTable } or sourceIdxOrTable
        for _, srcIdx in ipairs(sources) do
            local src = Library.Options[srcIdx]
            if src then
                local origCb = src.Callback
                src.Callback = function(...)
                    if origCb then Library:SafeCallback(origCb, ...) end
                    evalDependency(dep)
                end
            end
        end

        -- eval ทันที
        evalDependency(dep)
    end

    function Library:RemoveDependency(targetIdx)
        for i = #_dependencies, 1, -1 do
            if _dependencies[i].target == targetIdx then
                table.remove(_dependencies, i)
            end
        end
        Library:UnlockElement(targetIdx)
    end
end

-- Register elements ใหม่ส่วนที่ 2
do
    local newElements = {
        ElementsTable.Image,
        ElementsTable.ProgressSteps,
        ElementsTable.Markdown,
        ElementsTable.CodeBlock,
        ElementsTable.Rating,
        ElementsTable.RangeSlider,
        ElementsTable.ToggleSubGroup,
    }
    for _, ElementComponent in ipairs(newElements) do
        if ElementComponent and ElementComponent.__type then
            Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
                ElementComponent.Container = self.Container
                ElementComponent.Type = self.Type
                ElementComponent.ScrollFrame = self.ScrollFrame
                ElementComponent.Library = Library
                if ElementComponent.NoIdx then
                    return ElementComponent:New(Idx)
                end
                return ElementComponent:New(Idx, Config)
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- ✨ FEATURE PACK - PART 3: SYSTEM & UX
-- ═══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- [31] COMMAND PALETTE (Ctrl+K)
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    -- เปิดเองได้
    Library:OpenCommandPalette()
    -- หรือกด Ctrl+K / Cmd+K อัตโนมัติ
    -- เพิ่ม custom command:
    Library:RegisterCommand({
        Name = "Toggle Aimbot",
        Description = "Enable/Disable aimbot",
        Icon = "target",
        Action = function() Library.Options["Aimbot"]:SetValue(not Library.Options["Aimbot"].Value) end,
    })
]]
do
    local _commands = {}
    local _paletteOpen = false
    local _paletteFrame = nil
    local _searchBox = nil
    local _resultHolder = nil

    -- auto-populate commands จาก Library.Options
    local function getAutoCommands()
        local cmds = {}
        for idx, opt in pairs(Library.Options) do
            if opt and opt.Type then
                if opt.Type == "Toggle" or opt.Type == "Checkbox" then
                    table.insert(cmds, {
                        Name = "Toggle: " .. (opt.Elements and opt.Elements.TitleLabel and opt.Elements.TitleLabel.Text or idx),
                        Description = opt.Value and "Currently ON" or "Currently OFF",
                        Icon = "toggle-right",
                        Action = function()
                            if opt.SetValue then opt:SetValue(not opt.Value) end
                        end,
                        _auto = true,
                    })
                elseif opt.Type == "Button" then
                    table.insert(cmds, {
                        Name = "Button: " .. (opt.Elements and opt.Elements.TitleLabel and opt.Elements.TitleLabel.Text or idx),
                        Description = "Click button",
                        Icon = "zap",
                        Action = function()
                            if opt.Callback then Library:SafeCallback(opt.Callback) end
                        end,
                        _auto = true,
                    })
                end
            end
        end
        return cmds
    end

    function Library:RegisterCommand(cmd)
        assert(cmd.Name, "RegisterCommand: Missing Name")
        assert(cmd.Action, "RegisterCommand: Missing Action")
        table.insert(_commands, cmd)
    end

    local function buildResultList(query)
        if not _resultHolder then return end
        for _, c in pairs(_resultHolder:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end

        local allCmds = {}
        for _, c in ipairs(_commands) do table.insert(allCmds, c) end
        for _, c in ipairs(getAutoCommands()) do table.insert(allCmds, c) end

        local filtered = {}
        local lq = (query or ""):lower()
        for _, cmd in ipairs(allCmds) do
            if lq == "" or cmd.Name:lower():find(lq, 1, true) or
               (cmd.Description and cmd.Description:lower():find(lq, 1, true)) then
                table.insert(filtered, cmd)
            end
        end

        -- Max 8 results
        for i = 1, math.min(8, #filtered) do
            local cmd = filtered[i]
            local btn = Creator.New("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 0.92,
                Text = "",
                LayoutOrder = i,
                Parent = _resultHolder,
                ThemeTag = { BackgroundColor3 = "Element" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
                Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
            })

            if cmd.Icon then
                local iconId = Library:GetIcon(cmd.Icon) or cmd.Icon
                Creator.New("ImageLabel", {
                    Size = UDim2.fromOffset(16, 16),
                    BackgroundTransparency = 1,
                    Image = iconId,
                    Parent = btn,
                    ThemeTag = { ImageColor3 = "Accent" },
                })
            end

            Creator.New("Frame", {
                Size = UDim2.new(1, -30, 1, 0),
                BackgroundTransparency = 1,
                Parent = btn,
            }, {
                Creator.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
                Creator.New("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Text = cmd.Name,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    LayoutOrder = 1,
                    ThemeTag = { TextColor3 = "Text" },
                }),
                cmd.Description and Creator.New("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 14),
                    BackgroundTransparency = 1,
                    Text = cmd.Description,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    LayoutOrder = 2,
                    ThemeTag = { TextColor3 = "SubText" },
                }) or nil,
            })

            local Motor, SetT = Creator.SpringMotor(0.92, btn, "BackgroundTransparency")
            Creator.AddSignal(btn.MouseEnter, function() SetT(0.8) end)
            Creator.AddSignal(btn.MouseLeave, function() SetT(0.92) end)
            Creator.AddSignal(btn.MouseButton1Click, function()
                Library:CloseCommandPalette()
                Library:SafeCallback(cmd.Action)
            end)
        end
    end

    function Library:OpenCommandPalette()
        if _paletteOpen then return end
        _paletteOpen = true

        local W = 440
        local parent = Library.GUI

        _paletteFrame = Creator.New("Frame", {
            Name = "CommandPalette",
            Size = UDim2.fromOffset(W, 0),
            Position = UDim2.new(0.5, -W/2, 0, 80),
            BackgroundTransparency = 0.08,
            ZIndex = 9990,
            Parent = parent,
            ThemeTag = { BackgroundColor3 = "DropdownHolder" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 10) }),
            Creator.New("UIStroke", { Transparency = 0.35, ThemeTag = { Color = "Accent" } }),
        })

        -- Search input
        local SearchRow = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 44),
            BackgroundTransparency = 1,
            Parent = _paletteFrame,
        }, {
            Creator.New("ImageLabel", {
                Image = Library:GetIcon("search") or "rbxassetid://10734943674",
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(0, 14, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                ThemeTag = { ImageColor3 = "SubText" },
            }),
        })

        _searchBox = Creator.New("TextBox", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.fromOffset(38, 0),
            BackgroundTransparency = 1,
            PlaceholderText = "Search commands...",
            Text = "",
            TextSize = 14,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            ClearTextOnFocus = false,
            Parent = SearchRow,
            ThemeTag = { TextColor3 = "Text", PlaceholderColor3 = "SubText" },
        })

        Creator.New("Frame", {
            Size = UDim2.new(1, -20, 0, 1),
            Position = UDim2.new(0, 10, 0, 44),
            BackgroundTransparency = 0.7,
            Parent = _paletteFrame,
            ThemeTag = { BackgroundColor3 = "InElementBorder" },
        })

        _resultHolder = Creator.New("Frame", {
            Size = UDim2.new(1, -16, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.new(0, 8, 0, 52),
            BackgroundTransparency = 1,
            Parent = _paletteFrame,
        }, {
            Creator.New("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            Creator.New("UIPadding", { PaddingBottom = UDim.new(0, 8) }),
        })

        -- Auto-resize
        local layout = _resultHolder:FindFirstChildOfClass("UIListLayout")
        Creator.AddSignal(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            local h = layout.AbsoluteContentSize.Y + 60 + 16
            _paletteFrame.Size = UDim2.fromOffset(W, math.min(h, 380))
        end)

        Creator.AddSignal(_searchBox:GetPropertyChangedSignal("Text"), function()
            buildResultList(_searchBox.Text)
        end)

        buildResultList("")
        task.defer(function() _searchBox:CaptureFocus() end)

        -- Animate in
        _paletteFrame.Position = UDim2.new(0.5, -W/2, 0, 60)
        TweenService:Create(_paletteFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -W/2, 0, 80)
        }):Play()
    end

    function Library:CloseCommandPalette()
        if not _paletteOpen then return end
        _paletteOpen = false
        if _paletteFrame then
            TweenService:Create(_paletteFrame, TweenInfo.new(0.15), { Position = UDim2.new(0.5, -220, 0, 60) }):Play()
            task.delay(0.15, function()
                if _paletteFrame then _paletteFrame:Destroy() _paletteFrame = nil end
            end)
        end
    end

    -- Hotkey Ctrl+K
    Creator.AddSignal(UserInputService.InputBegan, function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.K and
           (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
            if _paletteOpen then
                Library:CloseCommandPalette()
            else
                Library:OpenCommandPalette()
            end
        end
        if input.KeyCode == Enum.KeyCode.Escape and _paletteOpen then
            Library:CloseCommandPalette()
        end
    end)
end

-- ──────────────────────────────────────────────────────────────
-- [32] UNDO / REDO SYSTEM
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:Undo()   -- Ctrl+Z
    Library:Redo()   -- Ctrl+Y
    Library:GetHistory()  -- return history stack
    Library:ClearHistory()
    -- เปิด/ปิด auto-tracking
    Library:EnableUndoRedo(true)
]]
do
    local _undoStack = {}
    local _redoStack = {}
    local _maxHistory = 50
    local _trackingEnabled = false
    local _isUndoRedo = false

    local function pushUndo(idx, oldVal, newVal)
        if _isUndoRedo then return end
        table.insert(_undoStack, { idx = idx, oldVal = oldVal, newVal = newVal })
        if #_undoStack > _maxHistory then table.remove(_undoStack, 1) end
        _redoStack = {} -- clear redo
    end

    function Library:EnableUndoRedo(enabled)
        _trackingEnabled = enabled
        if not enabled then return end

        -- Hook ทุก option
        for idx, opt in pairs(Library.Options) do
            if opt and not opt._undoHooked then
                opt._undoHooked = true
                local origCb = opt.Callback
                local lastVal = opt.Value
                opt.Callback = function(newVal)
                    if not _isUndoRedo then
                        pushUndo(idx, lastVal, newVal)
                        lastVal = newVal
                    end
                    if origCb then Library:SafeCallback(origCb, newVal) end
                end
            end
        end
    end

    function Library:Undo()
        if #_undoStack == 0 then
            Library:Notify({ Title = "Undo", Content = "Nothing to undo", Duration = 1.5, Type = "info" })
            return
        end
        local entry = table.remove(_undoStack)
        table.insert(_redoStack, entry)

        local opt = Library.Options[entry.idx]
        if opt and opt.SetValue then
            _isUndoRedo = true
            pcall(function() opt:SetValue(entry.oldVal) end)
            _isUndoRedo = false
        end

        Library:Notify({
            Title = "Undo",
            Content = "Reverted: " .. tostring(entry.idx),
            Duration = 1.5,
            Type = "info",
        })
    end

    function Library:Redo()
        if #_redoStack == 0 then
            Library:Notify({ Title = "Redo", Content = "Nothing to redo", Duration = 1.5, Type = "info" })
            return
        end
        local entry = table.remove(_redoStack)
        table.insert(_undoStack, entry)

        local opt = Library.Options[entry.idx]
        if opt and opt.SetValue then
            _isUndoRedo = true
            pcall(function() opt:SetValue(entry.newVal) end)
            _isUndoRedo = false
        end

        Library:Notify({
            Title = "Redo",
            Content = "Redone: " .. tostring(entry.idx),
            Duration = 1.5,
            Type = "info",
        })
    end

    function Library:GetHistory() return _undoStack end
    function Library:ClearHistory() _undoStack = {} _redoStack = {} end

    -- Hotkeys Ctrl+Z / Ctrl+Y
    Creator.AddSignal(UserInputService.InputBegan, function(input, gp)
        if gp or UserInputService:GetFocusedTextBox() then return end
        local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        if ctrl and input.KeyCode == Enum.KeyCode.Z then Library:Undo() end
        if ctrl and input.KeyCode == Enum.KeyCode.Y then Library:Redo() end
    end)
end

-- ──────────────────────────────────────────────────────────────
-- [35] HOTKEY MANAGER
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:RegisterHotkey("OpenMenu", Enum.KeyCode.F1, function()
        Library.Window:Minimize()
    end)
    Library:UnregisterHotkey("OpenMenu")
    Library:ShowHotkeyList()   -- แสดง popup รายการ hotkey ทั้งหมด
]]
do
    local _hotkeys = {}

    function Library:RegisterHotkey(name, keyCode, callback, description)
        _hotkeys[name] = {
            name = name,
            keyCode = keyCode,
            callback = callback,
            description = description or "",
            enabled = true,
        }
    end

    function Library:UnregisterHotkey(name)
        _hotkeys[name] = nil
    end

    function Library:SetHotkeyEnabled(name, enabled)
        if _hotkeys[name] then _hotkeys[name].enabled = enabled end
    end

    function Library:ShowHotkeyList()
        local Dialog = Components.Dialog:Create()
        Dialog.Title.Text = "Hotkey List"
        Dialog.Root.Size = UDim2.fromOffset(380, 300)

        local scroll = Creator.New("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -80),
            Position = UDim2.fromOffset(10, 55),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = Dialog.Root,
        }, {
            Creator.New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
        })

        local i = 0
        -- Built-in hotkeys
        local builtins = {
            { name = "Command Palette", key = "Ctrl+K", desc = "Open command search" },
            { name = "Undo",            key = "Ctrl+Z", desc = "Undo last change" },
            { name = "Redo",            key = "Ctrl+Y", desc = "Redo last change" },
        }

        for _, hk in ipairs(builtins) do
            i = i + 1
            Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = i % 2 == 0 and 0.92 or 1,
                LayoutOrder = i,
                Parent = scroll,
                ThemeTag = { BackgroundColor3 = "Element" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("TextLabel", {
                    Size = UDim2.new(0.55, 0, 1, 0),
                    Position = UDim2.fromOffset(8, 0),
                    BackgroundTransparency = 1,
                    Text = hk.name,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    ThemeTag = { TextColor3 = "Text" },
                }),
                Creator.New("TextLabel", {
                    Size = UDim2.new(0, 80, 1, 0),
                    Position = UDim2.new(0.55, 0, 0, 0),
                    BackgroundTransparency = 0.8,
                    Text = hk.key,
                    TextSize = 11,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                    ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
                }, {
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                }),
            })
        end

        for _, hk in pairs(_hotkeys) do
            i = i + 1
            Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = i % 2 == 0 and 0.92 or 1,
                LayoutOrder = i,
                Parent = scroll,
                ThemeTag = { BackgroundColor3 = "Element" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("TextLabel", {
                    Size = UDim2.new(0.55, 0, 1, 0),
                    Position = UDim2.fromOffset(8, 0),
                    BackgroundTransparency = 1,
                    Text = hk.name,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    ThemeTag = { TextColor3 = "Text" },
                }),
                Creator.New("TextLabel", {
                    Size = UDim2.new(0, 80, 1, 0),
                    Position = UDim2.new(0.55, 0, 0, 0),
                    BackgroundTransparency = 0.8,
                    Text = typeof(hk.keyCode) == "EnumItem" and hk.keyCode.Name or tostring(hk.keyCode),
                    TextSize = 11,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                    ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
                }, {
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                }),
            })
        end

        Dialog:Button("Close")
        Dialog:Open()
    end

    -- Dispatch registered hotkeys
    Creator.AddSignal(UserInputService.InputBegan, function(input, gp)
        if gp or UserInputService:GetFocusedTextBox() then return end
        for _, hk in pairs(_hotkeys) do
            if hk.enabled and input.KeyCode == hk.keyCode then
                Library:SafeCallback(hk.callback)
            end
        end
    end)
end

-- ──────────────────────────────────────────────────────────────
-- [36] VALUE HISTORY PER ELEMENT
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:GetValueHistory("MySlider")   -- return { 50, 75, 90, 100 }
    Library:RestoreHistory("MySlider", 2) -- restore ค่าที่ index 2
    Library:ClearValueHistory("MySlider")
]]
do
    local _valueHistories = {}
    local MAX_HIST = 10

    -- Hook ทุก option ที่สร้างใหม่
    local origOptions = Library.Options
    setmetatable(Library.Options, {
        __newindex = function(t, k, v)
            rawset(t, k, v)
            if v and v.Callback and not v._histHooked then
                v._histHooked = true
                local origCb = v.Callback
                v.Callback = function(newVal)
                    if not _valueHistories[k] then _valueHistories[k] = {} end
                    local hist = _valueHistories[k]
                    -- ไม่เก็บซ้ำกับค่าล่าสุด
                    if hist[#hist] ~= newVal then
                        table.insert(hist, newVal)
                        if #hist > MAX_HIST then table.remove(hist, 1) end
                    end
                    if origCb then Library:SafeCallback(origCb, newVal) end
                end
            end
        end,
    })

    function Library:GetValueHistory(idx)
        return _valueHistories[idx] or {}
    end

    function Library:RestoreHistory(idx, histIdx)
        local hist = _valueHistories[idx]
        if not hist then return end
        local val = hist[histIdx]
        if val == nil then return end
        local opt = Library.Options[idx]
        if opt and opt.SetValue then
            opt:SetValue(val)
        end
    end

    function Library:RestoreLastHistory(idx)
        local hist = _valueHistories[idx]
        if not hist or #hist < 2 then return end
        local val = hist[#hist - 1]
        local opt = Library.Options[idx]
        if opt and opt.SetValue then
            opt:SetValue(val)
        end
    end

    function Library:ClearValueHistory(idx)
        _valueHistories[idx] = nil
    end
end

-- ──────────────────────────────────────────────────────────────
-- [38] PROFILE SYSTEM
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:CreateProfile("PVP")
    Library:CreateProfile("Farm")
    Library:SwitchProfile("PVP")       -- บันทึก current แล้วโหลด PVP
    Library:GetCurrentProfile()        -- return "PVP"
    Library:DeleteProfile("Farm")
    Library:ListProfiles()             -- return { "PVP", "Farm" }
]]
do
    local _profiles = {}
    local _currentProfile = "default"

    local function captureCurrentValues()
        local snapshot = {}
        for idx, opt in pairs(Library.Options) do
            if opt and opt.Type and SaveManager.Parser[opt.Type] then
                snapshot[idx] = { type = opt.Type, value = opt.Value }
            end
        end
        return snapshot
    end

    local function applySnapshot(snapshot)
        for idx, data in pairs(snapshot) do
            local opt = Library.Options[idx]
            if opt and opt.SetValue then
                pcall(function() opt:SetValue(data.value) end)
            end
        end
    end

    function Library:CreateProfile(name)
        if not _profiles[name] then
            _profiles[name] = captureCurrentValues()
        end
        Library:Notify({
            Title = "Profiles",
            Content = 'Created profile "' .. name .. '"',
            Duration = 2,
            Type = "success",
        })
        return _profiles[name]
    end

    function Library:SaveProfile(name)
        name = name or _currentProfile
        _profiles[name] = captureCurrentValues()
        -- บันทึกลงไฟล์ถ้าทำได้
        if not RunService:IsStudio() then
            pcall(function()
                if not isfolder(SaveManager.Folder) then makefolder(SaveManager.Folder) end
                local path = SaveManager.Folder .. "/profile_" .. name .. ".json"
                writefile(path, httpService:JSONEncode(_profiles[name]))
            end)
        end
    end

    function Library:LoadProfile(name)
        -- โหลดจากไฟล์ก่อนถ้ามี
        if not RunService:IsStudio() then
            pcall(function()
                local path = SaveManager.Folder .. "/profile_" .. name .. ".json"
                if isfile(path) then
                    local data = httpService:JSONDecode(readfile(path))
                    if data then _profiles[name] = data end
                end
            end)
        end
        return _profiles[name]
    end

    function Library:SwitchProfile(name)
        -- บันทึก profile ปัจจุบันก่อน
        Library:SaveProfile(_currentProfile)

        -- โหลด profile ใหม่
        local profile = Library:LoadProfile(name)
        if not profile then
            Library:Notify({
                Title = "Profiles",
                Content = 'Profile "' .. name .. '" not found',
                Duration = 2,
                Type = "error",
            })
            return false
        end

        _currentProfile = name
        applySnapshot(profile)

        Library:Notify({
            Title = "Profiles",
            Content = 'Switched to "' .. name .. '"',
            Duration = 2,
            Type = "success",
        })
        return true
    end

    function Library:GetCurrentProfile() return _currentProfile end

    function Library:DeleteProfile(name)
        _profiles[name] = nil
        if not RunService:IsStudio() then
            pcall(function()
                local path = SaveManager.Folder .. "/profile_" .. name .. ".json"
                if isfile(path) then
                    writefile(path, "")  -- executor อาจไม่มี deletefile
                end
            end)
        end
    end

    function Library:ListProfiles()
        local list = {}
        for name in pairs(_profiles) do table.insert(list, name) end
        return list
    end

    -- สร้าง default profile
    _profiles["default"] = {}
end

-- ──────────────────────────────────────────────────────────────
-- [39] REMOTE CONFIG LOADER
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:LoadRemoteConfig("https://pastebin.com/raw/XXXXXXXX", function(success, err)
        if success then print("Config loaded!") end
    end)

    Library:LoadRemoteTheme("https://pastebin.com/raw/YYYYYYYY")
]]
do
    function Library:LoadRemoteConfig(url, callback)
        task.spawn(function()
            local ok, result = pcall(function()
                local response = game:GetService("HttpService"):GetAsync(url)
                return response
            end)

            if not ok then
                Library:Notify({
                    Title = "Remote Config",
                    Content = "Failed to fetch config",
                    SubContent = tostring(result),
                    Duration = 5,
                    Type = "error",
                })
                if callback then callback(false, result) end
                return
            end

            local decodeOk, decoded = pcall(function()
                return httpService:JSONDecode(result)
            end)

            if not decodeOk or not decoded then
                Library:Notify({
                    Title = "Remote Config",
                    Content = "Invalid JSON format",
                    Duration = 5,
                    Type = "error",
                })
                if callback then callback(false, "Invalid JSON") end
                return
            end

            -- Apply config
            if decoded.objects then
                for _, option in ipairs(decoded.objects) do
                    if SaveManager.Parser[option.type] then
                        task.spawn(function()
                            SaveManager.Parser[option.type].Load(option.idx, option)
                        end)
                    end
                end
            end

            Library:Notify({
                Title = "Remote Config",
                Content = "Config loaded successfully!",
                Duration = 3,
                Type = "success",
            })
            if callback then callback(true, decoded) end
        end)
    end

    function Library:LoadRemoteTheme(url, callback)
        task.spawn(function()
            local ok, result = pcall(function()
                return game:GetService("HttpService"):GetAsync(url)
            end)

            if not ok then
                if callback then callback(false, result) end
                return
            end

            local decodeOk, themeData = pcall(function()
                return httpService:JSONDecode(result)
            end)

            if decodeOk and type(themeData) == "table" then
                -- แปลง hex strings กลับเป็น Color3
                for k, v in pairs(themeData) do
                    if type(v) == "string" and #v == 6 then
                        local ok2, color = pcall(Color3.fromHex, v)
                        if ok2 then themeData[k] = color end
                    end
                end
                Library:ImportTheme(themeData)
                if callback then callback(true, themeData) end
            else
                if callback then callback(false, "Invalid theme data") end
            end
        end)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [46] NOTIFICATION QUEUE / STACK LIMIT
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:SetMaxNotifications(3)     -- แสดงพร้อมกันได้ max 3
    Library:SetNotificationPosition("TopRight")  -- TopRight, TopLeft, BottomRight, BottomLeft
    Library:ClearAllNotifications()
]]
do
    Library._maxNotifications = 5
    Library._notificationQueue = {}
    Library._notificationPosition = "BottomRight"

    function Library:SetMaxNotifications(max)
        self._maxNotifications = max
    end

    function Library:SetNotificationPosition(pos)
        self._notificationPosition = pos
        local holder = Components.Notification.Holder
        if not holder then return end

        if pos == "TopRight" then
            holder.Position = UDim2.new(1, -20, 0, 20)
            holder.AnchorPoint = Vector2.new(1, 0)
            local layout = holder:FindFirstChildOfClass("UIListLayout")
            if layout then layout.VerticalAlignment = Enum.VerticalAlignment.Top end
        elseif pos == "TopLeft" then
            holder.Position = UDim2.new(0, 20, 0, 20)
            holder.AnchorPoint = Vector2.new(0, 0)
            local layout = holder:FindFirstChildOfClass("UIListLayout")
            if layout then layout.VerticalAlignment = Enum.VerticalAlignment.Top end
        elseif pos == "BottomLeft" then
            holder.Position = UDim2.new(0, 20, 1, -20)
            holder.AnchorPoint = Vector2.new(0, 1)
            local layout = holder:FindFirstChildOfClass("UIListLayout")
            if layout then layout.VerticalAlignment = Enum.VerticalAlignment.Bottom end
        else -- BottomRight (default)
            holder.Position = UDim2.new(1, -20, 1, -20)
            holder.AnchorPoint = Vector2.new(1, 1)
            local layout = holder:FindFirstChildOfClass("UIListLayout")
            if layout then layout.VerticalAlignment = Enum.VerticalAlignment.Bottom end
        end
    end

    function Library:ClearAllNotifications()
        for _, notif in ipairs(Library.ActiveNotifications or {}) do
            pcall(function() notif:Close() end)
        end
        Library.ActiveNotifications = {}
        Library._notificationQueue = {}
    end

    -- Patch Notify เพื่อจัดการ queue
    local _origNotify = Library.Notify
    function Library:Notify(Config)
        local activeCount = #(Library.ActiveNotifications or {})
        if activeCount >= Library._maxNotifications then
            -- Queue ไว้ก่อน
            table.insert(Library._notificationQueue, Config)
            return nil
        end
        local notif = _origNotify(self, Config)
        -- เมื่อ notification ปิด ให้ดึงจาก queue
        if notif then
            local origClose = notif.Close
            notif.Close = function(self2)
                origClose(self2)
                task.defer(function()
                    if #Library._notificationQueue > 0 then
                        local next = table.remove(Library._notificationQueue, 1)
                        task.wait(0.1)
                        Library:Notify(next)
                    end
                end)
            end
        end
        return notif
    end
end

-- ──────────────────────────────────────────────────────────────
-- [47] NOTIFICATION ACTIONS (BUTTONS)
-- ──────────────────────────────────────────────────────────────
-- ใช้งานผ่าน Notify ปกติ เพิ่ม field Actions:
--[[
    Library:Notify({
        Title = "Update Available",
        Content = "Version 2.1 is ready",
        Duration = 10,
        Actions = {
            { Label = "Update Now", Callback = function() end, Primary = true },
            { Label = "Later",      Callback = function() end },
        },
    })
]]
-- Patch ใน NotificationModule ด้านบน ผ่าน wrapper Notify ที่เราแล้ว override
-- (Actions จะถูก inject เข้าไปใน notification root)
do
    local _origNotifyFinal = Library.Notify
    function Library:Notify(Config)
        -- เราจะสร้าง notification ปกติก่อน แล้ว inject buttons
        local notif = _origNotifyFinal(self, Config)
        if notif and Config.Actions and #Config.Actions > 0 and notif.Root then
            -- เพิ่ม action buttons ด้านล่าง
            local ActionRow = Creator.New("Frame", {
                Size = UDim2.new(1, -16, 0, 28),
                Position = UDim2.new(0, 8, 1, -34),
                BackgroundTransparency = 1,
                Parent = notif.Root,
                ZIndex = notif.Root.ZIndex + 1,
            }, {
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
            })

            for _, action in ipairs(Config.Actions) do
                local btn = Creator.New("TextButton", {
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = action.Primary and 0.2 or 0.85,
                    Text = action.Label or "OK",
                    TextSize = 11,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    Parent = ActionRow,
                    ThemeTag = { BackgroundColor3 = action.Primary and "Accent" or "Element", TextColor3 = "Text" },
                }, {
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
                })

                Creator.AddSignal(btn.MouseButton1Click, function()
                    Library:SafeCallback(action.Callback)
                    pcall(function() notif:Close() end)
                end)
            end

            -- ขยาย holder ให้รองรับ buttons
            if notif.Holder then
                notif.Holder.Size = UDim2.new(1, 0, 0, notif.Holder.Size.Y.Offset + 34)
            end
        end
        return notif
    end
end

-- ──────────────────────────────────────────────────────────────
-- [48] PERSISTENT NOTIFICATION (BELL ICON)
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:CreateNotificationHistory()  -- สร้าง bell icon
    Library:AddToHistory({
        Title = "Alert",
        Content = "Something happened",
        Time = os.time(),
    })
    Library:ClearNotificationHistory()
]]
do
    local _notifHistory = {}
    local _historyFrame = nil
    local _historyOpen = false
    local _bellBadge = nil

    function Library:CreateNotificationHistory(parent)
        parent = parent or Library.GUI
        local bellHolder = Creator.New("Frame", {
            Name = "NotifBell",
            Size = UDim2.fromOffset(36, 36),
            Position = UDim2.new(1, -50, 0, 10),
            BackgroundTransparency = 0.85,
            ZIndex = 500,
            Parent = parent,
            ThemeTag = { BackgroundColor3 = "Element" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("UIStroke", { Transparency = 0.5, ThemeTag = { Color = "InElementBorder" } }),
        })

        local bellBtn = Creator.New("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            Parent = bellHolder,
        }, {
            Creator.New("ImageLabel", {
                Image = Library:GetIcon("bell") or "rbxassetid://10709775704",
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                ThemeTag = { ImageColor3 = "Text" },
            }),
        })

        _bellBadge = Creator.New("Frame", {
            Name = "BellBadge",
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.new(1, -2, 0, 2),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Color3.fromRGB(255, 60, 60),
            Visible = false,
            Parent = bellHolder,
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            Creator.New("TextLabel", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "0",
                TextSize = 9,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
            }),
        })

        Creator.AddSignal(bellBtn.MouseButton1Click, function()
            if _historyOpen then
                Library:CloseNotificationHistory()
            else
                Library:OpenNotificationHistory()
            end
        end)

        return bellHolder
    end

    function Library:AddToHistory(config)
        config.time = config.time or os.time()
        config.read = false
        table.insert(_notifHistory, 1, config)
        if #_notifHistory > 50 then table.remove(_notifHistory) end

        -- อัปเดต badge
        if _bellBadge then
            local unread = 0
            for _, h in ipairs(_notifHistory) do
                if not h.read then unread = unread + 1 end
            end
            local lbl = _bellBadge:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.Text = unread > 99 and "99+" or tostring(unread) end
            _bellBadge.Visible = unread > 0
        end
    end

    function Library:OpenNotificationHistory()
        if _historyOpen then return end
        _historyOpen = true

        _historyFrame = Creator.New("Frame", {
            Name = "NotifHistory",
            Size = UDim2.fromOffset(300, 350),
            Position = UDim2.new(1, -310, 0, 50),
            BackgroundTransparency = 0.08,
            ZIndex = 9500,
            Parent = Library.GUI,
            ThemeTag = { BackgroundColor3 = "DropdownHolder" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 10) }),
            Creator.New("UIStroke", { Transparency = 0.4, ThemeTag = { Color = "AcrylicBorder" } }),
        })

        Creator.New("TextLabel", {
            Size = UDim2.new(1, -16, 0, 36),
            Position = UDim2.fromOffset(8, 0),
            BackgroundTransparency = 1,
            Text = "🔔 Notifications",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
            Parent = _historyFrame,
            ThemeTag = { TextColor3 = "Text" },
        })

        local scroll = Creator.New("ScrollingFrame", {
            Size = UDim2.new(1, -16, 1, -44),
            Position = UDim2.new(0, 8, 0, 40),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = _historyFrame,
        }, {
            Creator.New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
        })

        if #_notifHistory == 0 then
            Creator.New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Text = "No notifications yet",
                TextSize = 13,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                Parent = scroll,
                ThemeTag = { TextColor3 = "SubText" },
            })
        else
            for i, notif in ipairs(_notifHistory) do
                notif.read = true
                local timeStr = ""
                pcall(function()
                    local diff = os.time() - notif.time
                    if diff < 60 then timeStr = "Just now"
                    elseif diff < 3600 then timeStr = math.floor(diff/60) .. "m ago"
                    else timeStr = math.floor(diff/3600) .. "h ago" end
                end)

                Creator.New("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 0.88,
                    LayoutOrder = i,
                    Parent = scroll,
                    ThemeTag = { BackgroundColor3 = "Element" },
                }, {
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIPadding", {
                        PaddingLeft = UDim.new(0, 8),
                        PaddingRight = UDim.new(0, 8),
                        PaddingTop = UDim.new(0, 6),
                        PaddingBottom = UDim.new(0, 6),
                    }),
                    Creator.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
                    Creator.New("Frame", {
                        Size = UDim2.new(1, 0, 0, 16),
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                    }, {
                        Creator.New("UIListLayout", {
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                        }),
                        Creator.New("TextLabel", {
                            Size = UDim2.new(1, -50, 1, 0),
                            BackgroundTransparency = 1,
                            Text = notif.Title or "",
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                            ThemeTag = { TextColor3 = "Text" },
                        }),
                        Creator.New("TextLabel", {
                            Size = UDim2.fromOffset(50, 16),
                            BackgroundTransparency = 1,
                            Text = timeStr,
                            TextSize = 10,
                            TextXAlignment = Enum.TextXAlignment.Right,
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                            ThemeTag = { TextColor3 = "SubText" },
                        }),
                    }),
                    notif.Content ~= "" and Creator.New("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Text = notif.Content or "",
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextWrapped = true,
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                        LayoutOrder = 2,
                        ThemeTag = { TextColor3 = "SubText" },
                    }) or nil,
                })
            end
        end

        -- ล้าง badge
        if _bellBadge then _bellBadge.Visible = false end

        -- Click outside to close
        Creator.AddSignal(UserInputService.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and _historyOpen then
                local pos = Vector2.new(input.Position.X, input.Position.Y)
                if _historyFrame then
                    local ap = _historyFrame.AbsolutePosition
                    local as = _historyFrame.AbsoluteSize
                    if not (pos.X >= ap.X and pos.X <= ap.X + as.X and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y) then
                        Library:CloseNotificationHistory()
                    end
                end
            end
        end)
    end

    function Library:CloseNotificationHistory()
        if not _historyOpen then return end
        _historyOpen = false
        if _historyFrame then
            TweenService:Create(_historyFrame, TweenInfo.new(0.15), { Size = UDim2.fromOffset(300, 0) }):Play()
            task.delay(0.15, function()
                if _historyFrame then _historyFrame:Destroy() _historyFrame = nil end
            end)
        end
    end

    function Library:ClearNotificationHistory()
        _notifHistory = {}
        if _bellBadge then _bellBadge.Visible = false end
    end

    -- Auto-add ทุก notification ลง history
    local _notifyForHistory = Library.Notify
    function Library:Notify(Config)
        Library:AddToHistory({
            Title = Config.Title or "Notification",
            Content = Config.Content or "",
            time = os.time(),
        })
        return _notifyForHistory(self, Config)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- ✨ FEATURE PACK - PART 4: ANIMATION, SEARCH & TOOLS
-- ═══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- [52] AUDIT LOG
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:EnableAuditLog(true)
    local logs = Library:GetAuditLog()
    Library:ClearAuditLog()
    Library:ShowAuditLog()   -- แสดง popup
]]
do
    local _auditLog = {}
    local _auditEnabled = false

    function Library:EnableAuditLog(enabled)
        _auditEnabled = enabled
        if not enabled then return end

        -- Hook ทุก option
        for idx, opt in pairs(Library.Options) do
            if opt and opt.Callback and not opt._auditHooked then
                opt._auditHooked = true
                local origCb = opt.Callback
                opt.Callback = function(newVal)
                    if _auditEnabled then
                        table.insert(_auditLog, {
                            time = os.time(),
                            idx = idx,
                            type = opt.Type,
                            value = tostring(newVal),
                        })
                        if #_auditLog > 200 then table.remove(_auditLog, 1) end
                    end
                    if origCb then Library:SafeCallback(origCb, newVal) end
                end
            end
        end
    end

    function Library:GetAuditLog() return _auditLog end
    function Library:ClearAuditLog() _auditLog = {} end

    function Library:ShowAuditLog()
        local Dialog = Components.Dialog:Create()
        Dialog.Title.Text = "Audit Log"
        Dialog.Root.Size = UDim2.fromOffset(420, 350)

        local scroll = Creator.New("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -80),
            Position = UDim2.fromOffset(10, 55),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = Dialog.Root,
        }, {
            Creator.New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }),
        })

        local logs = #_auditLog > 0 and _auditLog or {{ idx="—", type="—", value="No logs", time=os.time() }}
        for i, log in ipairs(logs) do
            local timeStr = ""
            pcall(function()
                timeStr = os.date("%H:%M:%S", log.time)
            end)
            Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = i % 2 == 0 and 0.88 or 1,
                LayoutOrder = i,
                Parent = scroll,
                ThemeTag = { BackgroundColor3 = "Element" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 3) }),
                Creator.New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal }),
                Creator.New("TextLabel", {
                    Size = UDim2.fromOffset(55, 22),
                    BackgroundTransparency = 1,
                    Text = timeStr,
                    TextSize = 10,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    ThemeTag = { TextColor3 = "SubText" },
                }),
                Creator.New("TextLabel", {
                    Size = UDim2.new(0.45, -55, 1, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(log.idx),
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    ThemeTag = { TextColor3 = "Text" },
                }),
                Creator.New("TextLabel", {
                    Size = UDim2.new(0.35, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "→ " .. tostring(log.value),
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    ThemeTag = { TextColor3 = "Accent" },
                }),
            })
        end

        Dialog:Button("Export", function()
            local out = "Time\tElement\tType\tValue\n"
            for _, log in ipairs(_auditLog) do
                out = out .. string.format("%s\t%s\t%s\t%s\n",
                    os.date("%H:%M:%S", log.time), log.idx, log.type, log.value)
            end
            pcall(function()
                if setclipboard then setclipboard(out)
                elseif toclipboard then toclipboard(out) end
            end)
        end)
        Dialog:Button("Close")
        Dialog:Open()
    end
end

-- ──────────────────────────────────────────────────────────────
-- [53] DEBUG MODE OVERLAY
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:EnableDebugOverlay(true)   -- เปิด
    Library:EnableDebugOverlay(false)  -- ปิด
]]
do
    local _debugFrame = nil
    local _debugConn = nil

    function Library:EnableDebugOverlay(enabled)
        if not enabled then
            if _debugFrame then _debugFrame:Destroy() _debugFrame = nil end
            if _debugConn then _debugConn:Disconnect() _debugConn = nil end
            return
        end

        if _debugFrame then return end

        _debugFrame = Creator.New("Frame", {
            Name = "DebugOverlay",
            Size = UDim2.fromOffset(200, 120),
            Position = UDim2.new(0, 10, 1, -130),
            BackgroundTransparency = 0.3,
            ZIndex = 9999,
            Parent = Library.GUI,
            ThemeTag = { BackgroundColor3 = "AcrylicMain" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("UIStroke", { Transparency = 0.4, ThemeTag = { Color = "Accent" } }),
            Creator.New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 6),
            }),
        })

        local function makeStatLabel(name)
            return Creator.New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16),
                BackgroundTransparency = 1,
                Text = name .. ": —",
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
                Parent = _debugFrame,
                ThemeTag = { TextColor3 = "Text" },
            })
        end

        local lblTitle  = Creator.New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = "🔧 DEBUG",
            TextSize = 11,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
            Parent = _debugFrame,
            ThemeTag = { TextColor3 = "Accent" },
        })

        local lblFPS    = makeStatLabel("FPS")
        local lblPing   = makeStatLabel("Ping")
        local lblMem    = makeStatLabel("Memory")
        local lblElems  = makeStatLabel("Elements")
        local lblSigs   = makeStatLabel("Signals")
        local lblTheme  = makeStatLabel("Theme")

        local frameCount = 0
        local lastTime = tick()

        _debugConn = RunService.Heartbeat:Connect(function()
            frameCount = frameCount + 1
            local now = tick()
            if now - lastTime >= 0.5 then
                local fps = math.floor(frameCount / (now - lastTime))
                frameCount = 0
                lastTime = now

                local ping = 0
                pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)

                local mem = 0
                pcall(function() mem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb()) end)

                local elemCount = 0
                for _ in pairs(Library.Options) do elemCount = elemCount + 1 end

                lblFPS.Text    = "FPS:      " .. fps
                lblPing.Text   = "Ping:     " .. math.floor(ping) .. "ms"
                lblMem.Text    = "Memory:   " .. mem .. "MB"
                lblElems.Text  = "Elements: " .. elemCount
                lblSigs.Text   = "Signals:  " .. #Creator.Signals
                lblTheme.Text  = "Theme:    " .. (Library.Theme or "?")
            end
        end)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [54] API RATE LIMITER
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    -- Wrap callback ให้ throttle ได้ไม่เกิน 1 ครั้งต่อ 0.1 วินาที
    local throttled = Library:Throttle(function(v)
        print("value:", v)
    end, 0.1)

    -- Debounce: เรียกหลังหยุด delay วินาที
    local debounced = Library:Debounce(function(v)
        print("done:", v)
    end, 0.3)
]]
do
    function Library:Throttle(func, delay)
        delay = delay or 0.1
        local lastCall = 0
        return function(...)
            local now = tick()
            if now - lastCall >= delay then
                lastCall = now
                return func(...)
            end
        end
    end

    function Library:Debounce(func, delay)
        delay = delay or 0.3
        local thread = nil
        return function(...)
            local args = { ... }
            if thread then
                task.cancel(thread)
            end
            thread = task.delay(delay, function()
                thread = nil
                func(table.unpack(args))
            end)
        end
    end

    function Library:Once(func)
        local called = false
        return function(...)
            if not called then
                called = true
                return func(...)
            end
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- [66] ELEMENT ENTRANCE ANIMATION
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:SetEntranceAnimation("slide")   -- "slide", "fade", "pop", "none"
    -- ทุก element ที่สร้างใหม่จะ animate เข้า
]]
do
    Library._entranceAnimation = "slide"

    function Library:SetEntranceAnimation(style)
        self._entranceAnimation = style
    end

    function Library:AnimateElementIn(frame)
        if not frame or not frame.Parent then return end
        local style = self._entranceAnimation

        if style == "slide" then
            frame.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset + 30, frame.Position.Y.Scale, frame.Position.Y.Offset)
            frame.BackgroundTransparency = 1
            TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset - 30, frame.Position.Y.Scale, frame.Position.Y.Offset),
                BackgroundTransparency = Creator.GetThemeProperty("ElementTransparency") or 0.88,
            }):Play()
        elseif style == "fade" then
            frame.BackgroundTransparency = 1
            TweenService:Create(frame, TweenInfo.new(0.3), {
                BackgroundTransparency = Creator.GetThemeProperty("ElementTransparency") or 0.88,
            }):Play()
        elseif style == "pop" then
            local origSize = frame.Size
            frame.Size = UDim2.new(origSize.X.Scale, origSize.X.Offset * 0.8, origSize.Y.Scale, origSize.Y.Offset * 0.8)
            frame.BackgroundTransparency = 1
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = origSize,
                BackgroundTransparency = Creator.GetThemeProperty("ElementTransparency") or 0.88,
            }):Play()
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- [67] RIPPLE EFFECT บน BUTTON
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:AddRippleEffect(button.Frame)   -- เพิ่ม ripple ให้ frame ใดก็ได้
    -- เปิด/ปิด global
    Library:SetRippleEnabled(true)
]]
do
    Library._rippleEnabled = true

    function Library:SetRippleEnabled(enabled)
        self._rippleEnabled = enabled
    end

    function Library:AddRippleEffect(frame)
        if not frame then return end
        Creator.AddSignal(frame.InputBegan, function(input)
            if not Library._rippleEnabled then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
               input.UserInputType ~= Enum.UserInputType.Touch then return end

            local ap = frame.AbsolutePosition
            local as = frame.AbsoluteSize
            local relX = input.Position.X - ap.X
            local relY = input.Position.Y - ap.Y

            local maxR = math.sqrt(as.X^2 + as.Y^2) * 1.2

            local ripple = Creator.New("Frame", {
                Name = "Ripple",
                Size = UDim2.fromOffset(0, 0),
                Position = UDim2.new(0, relX, 0, relY),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.7,
                ZIndex = frame.ZIndex + 2,
                Parent = frame,
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            })

            TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(maxR * 2, maxR * 2),
                BackgroundTransparency = 1,
            }):Play()

            game:GetService("Debris"):AddItem(ripple, 0.55)
        end)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [69] WINDOW SHAKE ANIMATION
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:ShakeWindow()                        -- shake ปกติ
    Library:ShakeWindow({ intensity = 8, duration = 0.4 })
]]
do
    function Library:ShakeWindow(config)
        if not Library.Window or not Library.Window.Root then return end
        config = config or {}
        local intensity = config.intensity or 5
        local duration = config.duration or 0.3
        local steps = 12

        local root = Library.Window.Root
        local origPos = root.Position
        local elapsed = 0

        task.spawn(function()
            for i = 1, steps do
                local t = i / steps
                local dampen = 1 - t
                local ox = (math.random() * 2 - 1) * intensity * dampen
                local oy = (math.random() * 2 - 1) * intensity * dampen * 0.5
                root.Position = UDim2.new(
                    origPos.X.Scale, origPos.X.Offset + ox,
                    origPos.Y.Scale, origPos.Y.Offset + oy
                )
                task.wait(duration / steps)
            end
            root.Position = origPos
        end)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [70] SKELETON LOADING
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    local skeleton = Library:ShowSkeleton(section.Container, 3)  -- 3 placeholder rows
    task.wait(2)  -- โหลดข้อมูล
    skeleton:Remove()  -- ลบ skeleton ออก
]]
do
    function Library:ShowSkeleton(container, rowCount)
        rowCount = rowCount or 3
        local skeletons = {}

        for i = 1, rowCount do
            local row = Creator.New("Frame", {
                Name = "SkeletonRow_" .. i,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 0.9,
                Parent = container,
                LayoutOrder = 999 + i,
                ThemeTag = { BackgroundColor3 = "Element" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            })

            -- Shimmer
            local shimmer = Creator.New("Frame", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(-0.4, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.85,
                Parent = row,
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
                Creator.New("UIGradient", {
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.5, 0.6),
                        NumberSequenceKeypoint.new(1, 1),
                    }),
                    Rotation = 0,
                }),
            })

            -- Animate shimmer
            task.spawn(function()
                while row.Parent do
                    TweenService:Create(shimmer, TweenInfo.new(0.9, Enum.EasingStyle.Linear), {
                        Position = UDim2.new(1.4, 0, 0, 0),
                    }):Play()
                    task.wait(1)
                    shimmer.Position = UDim2.new(-0.4, 0, 0, 0)
                    task.wait(0.1)
                end
            end)

            table.insert(skeletons, row)
        end

        return {
            rows = skeletons,
            Remove = function(self)
                for _, row in ipairs(self.rows) do
                    TweenService:Create(row, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
                    game:GetService("Debris"):AddItem(row, 0.25)
                end
            end,
        }
    end
end

-- ──────────────────────────────────────────────────────────────
-- [71] TYPEWRITER EFFECT บน TEXT
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:TypewriterEffect(textLabel, "Hello World!", 0.05)  -- 0.05s ต่อตัวอักษร
    Library:TypewriterEffect(textLabel, "Hello!", 0.05, function()
        print("Done typing!")
    end)
]]
do
    function Library:TypewriterEffect(textLabel, text, speed, onComplete)
        speed = speed or 0.04
        if not textLabel or not textLabel:IsA("TextLabel") then return end

        textLabel.Text = ""
        task.spawn(function()
            for i = 1, #text do
                textLabel.Text = text:sub(1, i)
                task.wait(speed)
            end
            if onComplete then Library:SafeCallback(onComplete) end
        end)
    end

    function Library:TypewriterParagraph(config)
        -- สร้าง Paragraph แล้วพิมพ์ข้อความแบบ typewriter
        -- config.Container, config.Text, config.Speed
        local frame = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 0.92,
            Parent = config.Container,
            LayoutOrder = 7,
            ThemeTag = { BackgroundColor3 = "Element" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("UIPadding", {
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
            }),
        })

        local lbl = Creator.New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = "",
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            Parent = frame,
            ThemeTag = { TextColor3 = "Text" },
        })

        Library:TypewriterEffect(lbl, config.Text, config.Speed, config.OnComplete)
        return frame
    end
end

-- ──────────────────────────────────────────────────────────────
-- [75] COLLAPSIBLE SIDEBAR
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:CollapseSidebar()    -- ซ่อน sidebar เหลือแค่ icon
    Library:ExpandSidebar()      -- แสดง sidebar เต็ม
    Library:ToggleSidebar()      -- สลับ
]]
do
    local _sidebarCollapsed = false
    local COLLAPSED_W = 42
    local EXPANDED_W = nil  -- จะเก็บค่าเดิม

    function Library:CollapseSidebar()
        if not Library.Window or not Library.Window.TabFrame then return end
        _sidebarCollapsed = true
        EXPANDED_W = EXPANDED_W or Library.Window.TabWidth

        local tabFrame = Library.Window.TabFrame
        TweenService:Create(tabFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, COLLAPSED_W, tabFrame.Size.Y.Scale, tabFrame.Size.Y.Offset),
        }):Play()

        -- ซ่อน text labels ของ tabs
        for _, tab in pairs(Components.Tab.Tabs or {}) do
            if tab.Frame then
                for _, child in pairs(tab.Frame:GetDescendants()) do
                    if child:IsA("TextLabel") then
                        TweenService:Create(child, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
                    end
                end
            end
        end

        -- ซ่อน search
        if Library.Window.TabHolder then
            local search = Library.Window.TabHolder.Parent:FindFirstChild("SearchFrame")
                        or Library.Window.TabFrame:FindFirstChild("SearchFrame")
            if search then
                TweenService:Create(search, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, search.Size.Y.Scale, search.Size.Y.Offset) }):Play()
            end
        end
    end

    function Library:ExpandSidebar()
        if not Library.Window or not Library.Window.TabFrame then return end
        _sidebarCollapsed = false
        local w = EXPANDED_W or Library.Window.TabWidth

        local tabFrame = Library.Window.TabFrame
        TweenService:Create(tabFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, w, tabFrame.Size.Y.Scale, tabFrame.Size.Y.Offset),
        }):Play()

        for _, tab in pairs(Components.Tab.Tabs or {}) do
            if tab.Frame then
                for _, child in pairs(tab.Frame:GetDescendants()) do
                    if child:IsA("TextLabel") then
                        TweenService:Create(child, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
                    end
                end
            end
        end
    end

    function Library:ToggleSidebar()
        if _sidebarCollapsed then
            Library:ExpandSidebar()
        else
            Library:CollapseSidebar()
        end
    end

    function Library:IsSidebarCollapsed()
        return _sidebarCollapsed
    end
end

-- ──────────────────────────────────────────────────────────────
-- [85] SEARCH HISTORY
-- ──────────────────────────────────────────────────────────────
-- Patch search box ใน Window เพื่อจำ history
do
    Library._searchHistory = {}
    Library._maxSearchHistory = 10

    function Library:AddSearchHistory(term)
        if not term or term == "" then return end
        -- ลบซ้ำ
        for i = #self._searchHistory, 1, -1 do
            if self._searchHistory[i] == term then
                table.remove(self._searchHistory, i)
            end
        end
        table.insert(self._searchHistory, 1, term)
        if #self._searchHistory > self._maxSearchHistory then
            table.remove(self._searchHistory)
        end
    end

    function Library:GetSearchHistory()
        return self._searchHistory
    end

    function Library:ClearSearchHistory()
        self._searchHistory = {}
    end
end

-- ──────────────────────────────────────────────────────────────
-- [87] FUZZY SEARCH
-- ──────────────────────────────────────────────────────────────
do
    function Library:FuzzyMatch(str, pattern)
        str = str:lower()
        pattern = pattern:lower()
        if pattern == "" then return true, 0 end

        local score = 0
        local strIdx = 1
        local lastMatch = -1
        local consecutive = 0

        for i = 1, #pattern do
            local char = pattern:sub(i, i)
            local found = str:find(char, strIdx, true)
            if not found then return false, 0 end

            -- Bonus สำหรับตัวอักษรติดกัน
            if found == lastMatch + 1 then
                consecutive = consecutive + 1
                score = score + consecutive * 3
            else
                consecutive = 0
                score = score + 1
            end

            -- Bonus สำหรับตัวแรกของคำ
            if found == 1 or str:sub(found - 1, found - 1) == " " then
                score = score + 5
            end

            lastMatch = found
            strIdx = found + 1
        end

        -- Penalty สำหรับความยาวที่ต่างกัน
        score = score - (#str - #pattern) * 0.1

        return true, score
    end

    -- Patch UpdateElementVisibility ให้ใช้ fuzzy
    local _origUpdate = nil
    if Library.Window and Library.Window.UpdateElementVisibility then
        _origUpdate = Library.Window.UpdateElementVisibility
    end

    function Library:FuzzySearch(query, elements)
        if not query or query == "" then return elements end
        local results = {}
        for _, elem in ipairs(elements) do
            local match, score = Library:FuzzyMatch(tostring(elem.title or ""), query)
            if not match then
                match, score = Library:FuzzyMatch(tostring(elem.description or ""), query)
            end
            if match then
                table.insert(results, { elem = elem, score = score })
            end
        end
        table.sort(results, function(a, b) return a.score > b.score end)
        local out = {}
        for _, r in ipairs(results) do table.insert(out, r.elem) end
        return out
    end
end

-- ──────────────────────────────────────────────────────────────
-- [88] SEARCH ACROSS ALL TABS
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:GlobalSearch("aimbot")   -- return list of matches across all tabs
    Library:OpenGlobalSearch()       -- แสดง UI สำหรับค้นข้ามทุก tab
]]
do
    function Library:GlobalSearch(query)
        if not query or query == "" then return {} end
        local results = {}
        local lq = query:lower()

        for idx, opt in pairs(Library.Options) do
            if opt and opt.Elements then
                local title = opt.Elements.TitleLabel and opt.Elements.TitleLabel.Text or ""
                local desc = opt.Elements.DescLabel and opt.Elements.DescLabel.Text or ""

                local matchTitle = title:lower():find(lq, 1, true)
                local matchDesc = desc:lower():find(lq, 1, true)

                if matchTitle or matchDesc then
                    -- หา tab name
                    local tabName = "Unknown"
                    if opt.Elements.Frame then
                        local parent = opt.Elements.Frame.Parent
                        while parent do
                            -- หา tab container
                            if parent.Name == "ContainerAnim" or parent.Name == "ContainerFrame" then
                                -- traverse up หา tab name
                                break
                            end
                            parent = parent.Parent
                        end
                    end

                    table.insert(results, {
                        idx = idx,
                        title = title,
                        description = desc,
                        type = opt.Type,
                        tab = tabName,
                        frame = opt.Elements.Frame,
                        matchTitle = matchTitle ~= nil,
                    })
                end
            end
        end

        -- Sort: title match ก่อน
        table.sort(results, function(a, b)
            if a.matchTitle ~= b.matchTitle then return a.matchTitle end
            return a.title < b.title
        end)

        return results
    end

    function Library:OpenGlobalSearch()
        local W = 420
        local searchDialog = Creator.New("Frame", {
            Name = "GlobalSearch",
            Size = UDim2.fromOffset(W, 44),
            Position = UDim2.new(0.5, -W/2, 0, 100),
            BackgroundTransparency = 0.08,
            ZIndex = 9990,
            Parent = Library.GUI,
            ThemeTag = { BackgroundColor3 = "DropdownHolder" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 10) }),
            Creator.New("UIStroke", { Transparency = 0.35, ThemeTag = { Color = "InElementBorder" } }),
        })

        local input = Creator.New("TextBox", {
            Size = UDim2.new(1, -44, 1, 0),
            Position = UDim2.fromOffset(38, 0),
            BackgroundTransparency = 1,
            PlaceholderText = "Search all tabs... (ESC to close)",
            Text = "",
            TextSize = 13,
            ClearTextOnFocus = false,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            Parent = searchDialog,
            ThemeTag = { TextColor3 = "Text", PlaceholderColor3 = "SubText" },
        })

        Creator.New("ImageLabel", {
            Image = Library:GetIcon("search") or "rbxassetid://10734943674",
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(0, 14, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Parent = searchDialog,
            ThemeTag = { ImageColor3 = "SubText" },
        })

        local resultList = Creator.New("Frame", {
            Size = UDim2.new(1, -16, 0, 0),
            Position = UDim2.new(0, 8, 0, 48),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = searchDialog,
        }, {
            Creator.New("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }),
            Creator.New("UIPadding", { PaddingBottom = UDim.new(0, 8) }),
        })

        local resultLayout = resultList:FindFirstChildOfClass("UIListLayout")
        Creator.AddSignal(resultLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            searchDialog.Size = UDim2.fromOffset(W, math.min(44 + resultLayout.AbsoluteContentSize.Y + 16, 360))
        end)

        Creator.AddSignal(input:GetPropertyChangedSignal("Text"), function()
            for _, c in pairs(resultList:GetChildren()) do
                if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
            end

            local results = Library:GlobalSearch(input.Text)
            for i, res in ipairs(results) do
                if i > 8 then break end
                local row = Creator.New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 0.9,
                    Text = "",
                    LayoutOrder = i,
                    Parent = resultList,
                    ThemeTag = { BackgroundColor3 = "Element" },
                }, {
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = UDim.new(0, 6),
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                    }),
                    Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
                    Creator.New("TextLabel", {
                        Size = UDim2.new(0.6, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = res.title,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                        ThemeTag = { TextColor3 = "Text" },
                    }),
                    Creator.New("TextLabel", {
                        Size = UDim2.new(0.25, 0, 1, 0),
                        BackgroundTransparency = 0.85,
                        Text = res.type or "",
                        TextSize = 10,
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                        ThemeTag = { BackgroundColor3 = "InElementBorder", TextColor3 = "SubText" },
                    }, {
                        Creator.New("UICorner", { CornerRadius = UDim.new(0, 3) }),
                    }),
                })

                Creator.AddSignal(row.MouseButton1Click, function()
                    -- Scroll ไปหา element
                    if res.frame and res.frame.Parent then
                        res.frame:TweenPosition(res.frame.Position, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
                    end
                    searchDialog:Destroy()
                end)
            end
        end)

        Creator.AddSignal(UserInputService.InputBegan, function(inp, gp)
            if inp.KeyCode == Enum.KeyCode.Escape then
                Library:AddSearchHistory(input.Text)
                searchDialog:Destroy()
            end
        end)

        task.defer(function() input:CaptureFocus() end)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [89] RECENT ELEMENTS PANEL
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:GetRecentElements()     -- return list ล่าสุด 5 อัน
    Library:OpenRecentPanel()       -- แสดง popup
    Library:ClearRecentElements()
]]
do
    Library._recentElements = {}
    local MAX_RECENT = 5

    local function trackRecent(idx, opt)
        -- ลบ idx เก่าออกก่อน
        for i = #Library._recentElements, 1, -1 do
            if Library._recentElements[i].idx == idx then
                table.remove(Library._recentElements, i)
            end
        end
        table.insert(Library._recentElements, 1, {
            idx = idx,
            title = opt.Elements and opt.Elements.TitleLabel and opt.Elements.TitleLabel.Text or idx,
            type = opt.Type,
            time = os.time(),
        })
        if #Library._recentElements > MAX_RECENT then
            table.remove(Library._recentElements)
        end
    end

    -- Patch: track ทุก option callback
    setmetatable(Library.Options, {
        __newindex = function(t, k, v)
            rawset(t, k, v)
            if v and v.Callback and not v._recentHooked then
                v._recentHooked = true
                local origCb = v.Callback
                v.Callback = function(...)
                    if not v._suppressRecent then
                        trackRecent(k, v)
                    end
                    if origCb then Library:SafeCallback(origCb, ...) end
                end
            end
        end,
    })

    function Library:GetRecentElements()
        return Library._recentElements
    end

    function Library:ClearRecentElements()
        Library._recentElements = {}
    end

    function Library:OpenRecentPanel()
        local Dialog = Components.Dialog:Create()
        Dialog.Title.Text = "Recently Changed"
        Dialog.Root.Size = UDim2.fromOffset(360, 260)

        local scroll = Creator.New("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -80),
            Position = UDim2.fromOffset(10, 55),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = Dialog.Root,
        }, {
            Creator.New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
        })

        local recents = Library._recentElements
        if #recents == 0 then
            Creator.New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Text = "No recent changes",
                TextSize = 13,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                Parent = scroll,
                ThemeTag = { TextColor3 = "SubText" },
            })
        else
            for i, item in ipairs(recents) do
                local timeStr = ""
                pcall(function()
                    local diff = os.time() - item.time
                    if diff < 60 then timeStr = "Just now"
                    elseif diff < 3600 then timeStr = math.floor(diff/60) .. "m ago"
                    else timeStr = math.floor(diff/3600) .. "h ago" end
                end)

                local row = Creator.New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 0.9,
                    Text = "",
                    LayoutOrder = i,
                    Parent = scroll,
                    ThemeTag = { BackgroundColor3 = "Element" },
                }, {
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = UDim.new(0, 8),
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                    }),
                    Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
                    Creator.New("Frame", {
                        Size = UDim2.new(1, -70, 1, 0),
                        BackgroundTransparency = 1,
                    }, {
                        Creator.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
                        Creator.New("TextLabel", {
                            Size = UDim2.new(1, 0, 0, 18),
                            BackgroundTransparency = 1,
                            Text = item.title,
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                            LayoutOrder = 1,
                            ThemeTag = { TextColor3 = "Text" },
                        }),
                        Creator.New("TextLabel", {
                            Size = UDim2.new(1, 0, 0, 14),
                            BackgroundTransparency = 1,
                            Text = item.type .. " · " .. timeStr,
                            TextSize = 10,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                            LayoutOrder = 2,
                            ThemeTag = { TextColor3 = "SubText" },
                        }),
                    }),
                    Creator.New("TextLabel", {
                        Size = UDim2.fromOffset(50, 20),
                        BackgroundTransparency = 0.8,
                        Text = "Go →",
                        TextSize = 11,
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                        ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
                    }, {
                        Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    }),
                })

                Creator.AddSignal(row.MouseButton1Click, function()
                    -- Navigate ไปยัง element
                    local opt = Library.Options[item.idx]
                    if opt and opt.Elements and opt.Elements.Frame then
                        -- Scroll to element
                        local frame = opt.Elements.Frame
                        if frame.Parent and frame.Parent:IsA("ScrollingFrame") then
                            local scrollFrame = frame.Parent
                            local targetY = frame.AbsolutePosition.Y - scrollFrame.AbsolutePosition.Y + scrollFrame.CanvasPosition.Y
                            TweenService:Create(scrollFrame, TweenInfo.new(0.3), {
                                CanvasPosition = Vector2.new(0, targetY)
                            }):Play()
                        end
                    end
                end)
            end
        end

        Dialog:Button("Clear All", function()
            Library:ClearRecentElements()
        end)
        Dialog:Button("Close")
        Dialog:Open()
    end
end

-- ──────────────────────────────────────────────────────────────
-- [94] ELEMENT CLONING API
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    -- Clone element ไปยัง section อื่น
    Library:CloneElement("MyToggle", targetSection, "MyToggle_Clone")
    -- Clone พร้อม config override
    Library:CloneElement("MySlider", targetSection, "MySlider2", {
        Title = "Slider Copy",
        Default = 50,
    })
]]
do
    function Library:CloneElement(sourceIdx, targetSection, newIdx, configOverride)
        local source = Library.Options[sourceIdx]
        if not source then
            warn("CloneElement: source '" .. tostring(sourceIdx) .. "' not found")
            return nil
        end

        if not targetSection or not targetSection.Container then
            warn("CloneElement: invalid target section")
            return nil
        end

        -- สร้าง config ใหม่จาก source
        local config = {
            Title = source.Elements and source.Elements.TitleLabel and source.Elements.TitleLabel.Text or "",
            Description = source.Elements and source.Elements.DescLabel and source.Elements.DescLabel.Text or "",
            Default = source.Value,
            Callback = source.Callback,
        }

        -- Merge config override
        if configOverride then
            for k, v in pairs(configOverride) do config[k] = v end
        end

        -- Map type → AddXxx function
        local typeMap = {
            Toggle = "AddToggle",
            Slider = "AddSlider",
            Dropdown = "AddDropdown",
            Input = "AddInput",
            Colorpicker = "AddColorpicker",
            Keybind = "AddKeybind",
            Checkbox = "AddCheckbox",
            Rating = "AddRating",
            RangeSlider = "AddRangeSlider",
        }

        local addFn = typeMap[source.Type]
        if not addFn or not targetSection[addFn] then
            warn("CloneElement: unsupported type '" .. tostring(source.Type) .. "'")
            return nil
        end

        -- สำหรับ Slider ต้องมี Min/Max
        if source.Type == "Slider" then
            config.Min = source.Min or 0
            config.Max = source.Max or 100
            config.Rounding = source.Rounding or 0
        elseif source.Type == "Dropdown" then
            config.Values = source.Values or {}
            config.Multi = source.Multi
        elseif source.Type == "Keybind" then
            config.Default = source.Value or "None"
            config.Mode = source.Mode or "Toggle"
        end

        return targetSection[addFn](targetSection, newIdx or (sourceIdx .. "_clone"), config)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [95] BATCH UPDATE API
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    -- Update หลาย element พร้อมกัน ไม่ trigger callback จนกว่าจะ flush
    Library:BatchUpdate(function(batch)
        batch.set("Toggle1", true)
        batch.set("Slider1", 75)
        batch.set("Dropdown1", "Option A")
    end)
    -- หรือ manual mode:
    Library:BeginBatch()
    Library:BatchSet("Toggle1", true)
    Library:BatchSet("Slider1", 75)
    Library:EndBatch()   -- trigger callbacks ทั้งหมด
]]
do
    local _batchMode = false
    local _batchQueue = {}

    function Library:BeginBatch()
        _batchMode = true
        _batchQueue = {}
    end

    function Library:BatchSet(idx, value)
        if _batchMode then
            table.insert(_batchQueue, { idx = idx, value = value })
        else
            local opt = Library.Options[idx]
            if opt and opt.SetValue then
                pcall(function() opt:SetValue(value) end)
            end
        end
    end

    function Library:EndBatch()
        _batchMode = false
        for _, item in ipairs(_batchQueue) do
            local opt = Library.Options[item.idx]
            if opt and opt.SetValue then
                pcall(function() opt:SetValue(item.value) end)
            end
        end
        _batchQueue = {}
    end

    function Library:BatchUpdate(func)
        Library:BeginBatch()
        local batch = {
            set = function(idx, value)
                Library:BatchSet(idx, value)
            end,
            get = function(idx)
                local opt = Library.Options[idx]
                return opt and opt.Value
            end,
        }
        Library:SafeCallback(func, batch)
        Library:EndBatch()
    end

    function Library:BatchSetMultiple(values)
        Library:BeginBatch()
        for idx, value in pairs(values) do
            Library:BatchSet(idx, value)
        end
        Library:EndBatch()
    end
end

-- ──────────────────────────────────────────────────────────────
-- [8] GAMEPAD / CONTROLLER NAVIGATION
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Library:EnableGamepadNav(true)
    Library:EnableGamepadNav(false)
    -- D-Pad Up/Down เลื่อนระหว่าง elements
    -- A button = activate (click)
    -- B button = back / close
]]
do
    local _gamepadEnabled = false
    local _focusedIdx = nil
    local _focusFrame = nil

    local function getVisibleOptions()
        local list = {}
        for idx, opt in pairs(Library.Options) do
            if opt and opt.Elements and opt.Elements.Frame and
               opt.Elements.Frame:IsDescendantOf(game) and
               opt.Elements.Frame.Visible then
                table.insert(list, { idx = idx, opt = opt })
            end
        end
        table.sort(list, function(a, b)
            local pa = a.opt.Elements.Frame.AbsolutePosition
            local pb = b.opt.Elements.Frame.AbsolutePosition
            if math.abs(pa.Y - pb.Y) > 5 then return pa.Y < pb.Y end
            return pa.X < pb.X
        end)
        return list
    end

    local function setFocus(idx)
        _focusedIdx = idx
        local opt = Library.Options[idx]
        if not opt or not opt.Elements or not opt.Elements.Frame then return end

        local frame = opt.Elements.Frame

        -- สร้าง focus indicator
        if not _focusFrame then
            _focusFrame = Creator.New("Frame", {
                Name = "GamepadFocus",
                BackgroundTransparency = 1,
                ZIndex = 999,
                Parent = Library.GUI,
            }, {
                Creator.New("UIStroke", {
                    Thickness = 2,
                    Color = Creator.GetThemeProperty("Accent") or Color3.fromRGB(105, 215, 255),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                }),
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 9) }),
            })
        end

        -- ติดตาม frame
        _focusFrame.Size = frame.Size + UDim2.fromOffset(4, 4)
        _focusFrame.Position = UDim2.new(
            0, frame.AbsolutePosition.X - 2,
            0, frame.AbsolutePosition.Y - 2
        )
        _focusFrame.Visible = true

        -- Scroll to element
        local parent = frame.Parent
        while parent do
            if parent:IsA("ScrollingFrame") then
                local elemY = frame.AbsolutePosition.Y - parent.AbsolutePosition.Y + parent.CanvasPosition.Y
                TweenService:Create(parent, TweenInfo.new(0.2), {
                    CanvasPosition = Vector2.new(0, math.max(0, elemY - parent.AbsoluteSize.Y / 2))
                }):Play()
                break
            end
            parent = parent.Parent
        end
    end

    local function activateFocused()
        if not _focusedIdx then return end
        local opt = Library.Options[_focusedIdx]
        if not opt then return end

        if opt.Type == "Toggle" or opt.Type == "Checkbox" then
            if opt.SetValue then opt:SetValue(not opt.Value) end
        elseif opt.Type == "Button" then
            if opt.Callback then Library:SafeCallback(opt.Callback) end
        elseif opt.Type == "Slider" then
            -- เพิ่มค่า 10% ของ range
            if opt.SetValue then
                local step = (opt.Max - opt.Min) * 0.1
                opt:SetValue(opt.Value + step)
            end
        end
    end

    function Library:EnableGamepadNav(enabled)
        _gamepadEnabled = enabled
        if not enabled and _focusFrame then
            _focusFrame.Visible = false
        end
    end

    Creator.AddSignal(UserInputService.InputBegan, function(input)
        if not _gamepadEnabled then return end

        local visible = getVisibleOptions()
        if #visible == 0 then return end

        local currentPos = 1
        for i, item in ipairs(visible) do
            if item.idx == _focusedIdx then currentPos = i break end
        end

        if input.KeyCode == Enum.KeyCode.DPadDown then
            local next = (currentPos % #visible) + 1
            setFocus(visible[next].idx)
        elseif input.KeyCode == Enum.KeyCode.DPadUp then
            local prev = ((currentPos - 2) % #visible) + 1
            setFocus(visible[prev].idx)
        elseif input.KeyCode == Enum.KeyCode.ButtonA then
            activateFocused()
        elseif input.KeyCode == Enum.KeyCode.ButtonB then
            if Library.Window then Library.Window:Minimize() end
        end
    end)
end

-- ──────────────────────────────────────────────────────────────
-- [26] TAG INPUT
-- ──────────────────────────────────────────────────────────────
--[[
    Usage:
    Section:AddTagInput("MyTags", {
        Title = "Tags",
        Placeholder = "Type and press Enter...",
        MaxTags = 10,
        Callback = function(tags) print(tags) end,
    })
]]
ElementsTable.TagInput = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "TagInput"

    function Element:New(Idx, Config)
        Config = Config or {}
        assert(Config.Title, "TagInput - Missing Title")
        Config.MaxTags = Config.MaxTags or 20

        local TI = {
            Value = Config.Default or {},
            Type = "TagInput",
            Callback = Config.Callback or function() end,
        }

        local TIFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)

        local TagHolder = Creator.New("Frame", {
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            Parent = TIFrame.LabelHolder,
            LayoutOrder = 3,
        }, {
            Creator.New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 4),
                Wraps = true,
            }),
            Creator.New("UIPadding", { PaddingBottom = UDim.new(0, 6) }),
        })

        local InputBox = Creator.New("TextBox", {
            Size = UDim2.fromOffset(120, 24),
            BackgroundTransparency = 0.88,
            PlaceholderText = Config.Placeholder or "Add tag...",
            Text = "",
            TextSize = 12,
            ClearTextOnFocus = false,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            Parent = TagHolder,
            ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "SubText" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
            Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 6) }),
        })

        local function addTag(text)
            text = text:gsub("^%s+", ""):gsub("%s+$", "")
            if text == "" then return end
            if #TI.Value >= Config.MaxTags then return end
            -- ไม่เพิ่มซ้ำ
            for _, t in ipairs(TI.Value) do
                if t == text then return end
            end
            table.insert(TI.Value, text)

            local tagFrame = Creator.New("Frame", {
                Size = UDim2.fromOffset(0, 22),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 0.7,
                Parent = TagHolder,
                LayoutOrder = #TI.Value,
                ThemeTag = { BackgroundColor3 = "Accent" },
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 4),
                }),
                Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 4) }),
                Creator.New("TextLabel", {
                    Size = UDim2.fromOffset(0, 22),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Text = text,
                    TextSize = 11,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                }),
                Creator.New("TextButton", {
                    Size = UDim2.fromOffset(14, 14),
                    BackgroundTransparency = 1,
                    Text = "×",
                    TextSize = 13,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                }),
            })

            -- Close button
            local closeBtn = tagFrame:FindFirstChildOfClass("TextButton")
            local tagText = text
            Creator.AddSignal(closeBtn.MouseButton1Click, function()
                for i, t in ipairs(TI.Value) do
                    if t == tagText then
                        table.remove(TI.Value, i)
                        break
                    end
                end
                TweenService:Create(tagFrame, TweenInfo.new(0.15), { Size = UDim2.fromOffset(0, 0) }):Play()
                game:GetService("Debris"):AddItem(tagFrame, 0.2)
                Library:SafeCallback(TI.Callback, TI.Value)
                Library:SafeCallback(TI.Changed, TI.Value)
            end)

            -- Move inputbox to end
            InputBox.LayoutOrder = 9999
            Library:SafeCallback(TI.Callback, TI.Value)
            Library:SafeCallback(TI.Changed, TI.Value)
        end

        Creator.AddSignal(InputBox.FocusLost, function(enterPressed)
            if enterPressed then
                addTag(InputBox.Text)
                InputBox.Text = ""
            end
        end)

        Creator.AddSignal(InputBox:GetPropertyChangedSignal("Text"), function()
            -- ตรวจ comma หรือ Enter
            local text = InputBox.Text
            if text:find(",") then
                local tags = text:split(",")
                for _, tag in ipairs(tags) do
                    addTag(tag)
                end
                InputBox.Text = ""
            end
        end)

        function TI:SetValue(tags)
            -- ล้างทั้งหมดแล้วเพิ่มใหม่
            self.Value = {}
            for _, child in pairs(TagHolder:GetChildren()) do
                if child ~= InputBox and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                    child:Destroy()
                end
            end
            for _, tag in ipairs(tags or {}) do addTag(tag) end
        end

        function TI:OnChanged(Func) TI.Changed = Func Func(TI.Value) end
        function TI:Destroy() TIFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end

        if Idx then Library.Options[Idx] = TI end
        return TI
    end

    return Element
end)()

-- Register remaining elements
do
    for _, ElementComponent in ipairs({ ElementsTable.TagInput }) do
        if ElementComponent and ElementComponent.__type then
            Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
                ElementComponent.Container = self.Container
                ElementComponent.Type = self.Type
                ElementComponent.ScrollFrame = self.ScrollFrame
                ElementComponent.Library = Library
                if ElementComponent.NoIdx then
                    return ElementComponent:New(Idx)
                end
                return ElementComponent:New(Idx, Config)
            end
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- SaveManager: เพิ่ม Parser สำหรับ elements ใหม่
-- ──────────────────────────────────────────────────────────────
do
    local newParsers = {
        RangeSlider = {
            Save = function(idx, object)
                return { type = "RangeSlider", idx = idx, minValue = object.MinValue, maxValue = object.MaxValue }
            end,
            Load = function(idx, data)
                if SaveManager.Options[idx] then
                    SaveManager.Options[idx]:SetValue(data.minValue, data.maxValue)
                end
            end,
        },
        Rating = {
            Save = function(idx, object)
                return { type = "Rating", idx = idx, value = object.Value }
            end,
            Load = function(idx, data)
                if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end
            end,
        },
        InlineColorPicker = {
            Save = function(idx, object)
                return { type = "InlineColorPicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
            end,
            Load = function(idx, data)
                if SaveManager.Options[idx] then
                    SaveManager.Options[idx]:SetValue(Color3.fromHex(data.value), data.transparency)
                end
            end,
        },
        TagInput = {
            Save = function(idx, object)
                return { type = "TagInput", idx = idx, value = table.concat(object.Value, ",") }
            end,
            Load = function(idx, data)
                if SaveManager.Options[idx] then
                    local tags = {}
                    for t in (data.value or ""):gmatch("[^,]+") do table.insert(tags, t) end
                    SaveManager.Options[idx]:SetValue(tags)
                end
            end,
        },
    }

    for k, v in pairs(newParsers) do
        SaveManager.Parser[k] = v
    end
end

-- ═══════════════════════════════════════════════════════════════
-- END FEATURE PACK PART 4
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- ✨ FEATURE PACK - PART 5: ADVANCED FEATURES
-- ═══════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────
-- [11] CUSTOM FONT SUPPORT
-- ──────────────────────────────────────────────────────────────
do
    Library._globalFont = nil

    function Library:SetGlobalFont(fontFamily, weight)
        self._globalFont = fontFamily
        self._globalFontWeight = weight or Enum.FontWeight.Regular
        if Library.GUI then
            for _, obj in pairs(Library.GUI:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    pcall(function()
                        local cf = obj.FontFace
                        obj.FontFace = Font.new(fontFamily, weight or cf.Weight, cf.Style)
                    end)
                end
            end
        end
        Library:Notify({ Title = "Font", Content = "Font updated", Duration = 2, Type = "success" })
    end

    function Library:ResetFont()
        Library:SetGlobalFont("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular)
    end

    function Library:GetAvailableFonts()
        return {
            { Name = "Gotham (Default)", Family = "rbxasset://fonts/families/GothamSSm.json" },
            { Name = "Ubuntu",           Family = "rbxasset://fonts/families/Ubuntu.json" },
            { Name = "Roboto Mono",      Family = "rbxasset://fonts/families/RobotoMono.json" },
            { Name = "Source Sans",      Family = "rbxasset://fonts/families/SourceSansPro.json" },
            { Name = "Nunito",           Family = "rbxasset://fonts/families/Nunito.json" },
        }
    end
end

-- ──────────────────────────────────────────────────────────────
-- [13] BLUR INTENSITY CONTROL
-- ──────────────────────────────────────────────────────────────
do
    Library._blurIntensity = 0
    local _blurEffect = nil

    function Library:SetBlurIntensity(intensity)
        intensity = math.clamp(intensity, 0, 56)
        Library._blurIntensity = intensity
        if intensity == 0 then
            if _blurEffect then _blurEffect.Enabled = false end
            return
        end
        if not _blurEffect then
            _blurEffect = Instance.new("BlurEffect")
            _blurEffect.Name = "FluentBlur"
            _blurEffect.Parent = game:GetService("Lighting")
        end
        _blurEffect.Enabled = true
        _blurEffect.Size = intensity
    end

    function Library:GetBlurIntensity() return Library._blurIntensity end

    function Library:AnimateBlur(target, duration)
        target = math.clamp(target, 0, 56)
        duration = duration or 0.5
        if target > 0 then
            if not _blurEffect then
                _blurEffect = Instance.new("BlurEffect")
                _blurEffect.Name = "FluentBlur"
                _blurEffect.Parent = game:GetService("Lighting")
            end
            _blurEffect.Enabled = true
        end
        local start = Library._blurIntensity
        local t0 = tick()
        task.spawn(function()
            while true do
                local t = math.min((tick() - t0) / duration, 1)
                local e = t < 0.5 and 2*t*t or -1+(4-2*t)*t
                Library:SetBlurIntensity(start + (target - start) * e)
                if t >= 1 then break end
                task.wait(1/60)
            end
        end)
    end

    function Library:DisableBlur() Library:AnimateBlur(0, 0.3) end
end

-- ──────────────────────────────────────────────────────────────
-- [17] GLASSMORPHISM LEVEL
-- ──────────────────────────────────────────────────────────────
do
    Library._glassLevel = 0

    function Library:SetGlassLevel(level)
        level = math.clamp(level, 0, 1)
        Library._glassLevel = level
        if Library.UseAcrylic then Library:AnimateBlur(level * 32, 0.4) end
        if Library.Window and Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Frame then
            TweenService:Create(Library.Window.AcrylicPaint.Frame, TweenInfo.new(0.4), {
                BackgroundTransparency = 0.3 + level * 0.65,
            }):Play()
        end
    end

    function Library:GetGlassLevel() return Library._glassLevel end
end

-- ──────────────────────────────────────────────────────────────
-- [21] SPARKLINE / MINI CHART
-- ──────────────────────────────────────────────────────────────
ElementsTable.Sparkline = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "Sparkline"

    function Element:New(Idx, Config)
        Config = Config or {}
        assert(Config.Title, "Sparkline - Missing Title")
        Config.MaxPoints = Config.MaxPoints or 30
        Config.Height = Config.Height or 50

        local SP = { Type = "Sparkline", Points = {}, MaxPoints = Config.MaxPoints }
        local OuterFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        OuterFrame.Frame.BackgroundTransparency = 0.9

        local ChartFrame = Creator.New("Frame", {
            Size = UDim2.new(1, -20, 0, Config.Height),
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 0.92,
            Parent = OuterFrame.LabelHolder,
            LayoutOrder = 3,
            ThemeTag = { BackgroundColor3 = "AcrylicMain" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            Creator.New("UIStroke", { Transparency = 0.6, ThemeTag = { Color = "InElementBorder" } }),
        })

        local ValueLabel = Creator.New("TextLabel", {
            Size = UDim2.fromOffset(60, 16),
            Position = UDim2.new(1, -6, 0, 4),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Text = "—",
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
            Parent = ChartFrame,
            ThemeTag = { TextColor3 = "Accent" },
        })

        local BarHolder = Creator.New("Frame", {
            Size = UDim2.new(1, -4, 1, -4),
            Position = UDim2.fromOffset(2, 2),
            BackgroundTransparency = 1,
            Parent = ChartFrame,
        }, {
            Creator.New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 1),
            }),
        })

        local barColor = Config.Color or Color3.fromRGB(105, 215, 255)

        local function rebuildBars()
            for _, b in pairs(BarHolder:GetChildren()) do
                if not b:IsA("UIListLayout") then b:Destroy() end
            end
            if #SP.Points == 0 then return end
            local maxVal, minVal = 0, math.huge
            for _, v in ipairs(SP.Points) do
                if v > maxVal then maxVal = v end
                if v < minVal then minVal = v end
            end
            if maxVal == minVal then maxVal = minVal + 1 end
            local barW = math.max(2, math.floor((ChartFrame.AbsoluteSize.X - 4) / Config.MaxPoints) - 1)
            for i, v in ipairs(SP.Points) do
                local pct = math.max(0.05, (v - minVal) / (maxVal - minVal))
                Creator.New("Frame", {
                    Size = UDim2.new(0, barW, pct, 0),
                    BackgroundColor3 = barColor,
                    BackgroundTransparency = 0.3 + (1 - pct) * 0.5,
                    LayoutOrder = i,
                    Parent = BarHolder,
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 2) }) })
            end
            local latest = SP.Points[#SP.Points]
            ValueLabel.Text = Config.FormatValue and Config.FormatValue(latest) or string.format("%.1f", latest)
        end

        function SP:AddPoint(v)
            table.insert(self.Points, v)
            if #self.Points > self.MaxPoints then table.remove(self.Points, 1) end
            rebuildBars()
        end

        function SP:SetPoints(pts)
            self.Points = {}
            for _, v in ipairs(pts) do
                table.insert(self.Points, v)
                if #self.Points > self.MaxPoints then table.remove(self.Points, 1) end
            end
            rebuildBars()
        end

        function SP:Clear()
            self.Points = {}
            for _, b in pairs(BarHolder:GetChildren()) do
                if not b:IsA("UIListLayout") then b:Destroy() end
            end
            ValueLabel.Text = "—"
        end

        function SP:GetLatest() return self.Points[#self.Points] end
        function SP:GetAverage()
            if #self.Points == 0 then return 0 end
            local s = 0
            for _, v in ipairs(self.Points) do s = s + v end
            return s / #self.Points
        end

        if Config.AutoUpdate then
            task.spawn(function()
                local interval = Config.UpdateInterval or 1
                while ChartFrame.Parent do
                    local val = Config.AutoUpdate()
                    if val then SP:AddPoint(val) end
                    task.wait(interval)
                end
            end)
        end

        function SP:Destroy() OuterFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
        if Idx then Library.Options[Idx] = SP end
        return SP
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [23] FILE PICKER ELEMENT
-- ──────────────────────────────────────────────────────────────
ElementsTable.FilePicker = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "FilePicker"

    function Element:New(Idx, Config)
        Config = Config or {}
        assert(Config.Title, "FilePicker - Missing Title")

        local FP = { Value = Config.Default or "", Type = "FilePicker", Callback = Config.Callback or function() end }
        local FPFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        FP.SetTitle = FPFrame.SetTitle; FP.SetDesc = FPFrame.SetDesc

        local DisplayLabel = Creator.New("TextLabel", {
            Size = UDim2.fromOffset(120, 28),
            Position = UDim2.new(1, -10, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 0.88,
            Text = FP.Value ~= "" and (FP.Value:match("[^/\\]+$") or FP.Value) or "No file",
            TextSize = 11,
            TextTruncate = Enum.TextTruncate.AtEnd,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            Parent = FPFrame.Frame,
            ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "SubText" },
        }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }), Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }) })

        local BrowseBtn = Creator.New("TextButton", {
            Size = UDim2.fromOffset(60, 22),
            Position = UDim2.new(1, -140, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 0.75,
            Text = "Browse",
            TextSize = 11,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
            Parent = FPFrame.Frame,
            ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
        }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }) })

        Creator.AddSignal(BrowseBtn.MouseButton1Click, function()
            local Dialog = Components.Dialog:Create()
            Dialog.Title.Text = "Select File"
            Dialog.Root.Size = UDim2.fromOffset(360, 300)

            local folder = Config.Folder or (SaveManager and SaveManager.Folder) or "."
            local files = {}
            pcall(function()
                if listfiles then
                    for _, f in ipairs(listfiles(folder)) do
                        if not Config.Filter or f:sub(-#Config.Filter) == Config.Filter then
                            table.insert(files, f)
                        end
                    end
                end
            end)

            local scroll = Creator.New("ScrollingFrame", {
                Size = UDim2.new(1, -20, 1, -80),
                Position = UDim2.fromOffset(10, 55),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                CanvasSize = UDim2.fromScale(0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Parent = Dialog.Root,
            }, { Creator.New("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }) })

            if #files == 0 then
                Creator.New("TextLabel", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "No files in: " .. folder, TextSize = 12, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"), Parent = scroll, ThemeTag = { TextColor3 = "SubText" } })
            else
                for i, filePath in ipairs(files) do
                    local fileName = filePath:match("[^/\\]+$") or filePath
                    local btn = Creator.New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 0.9, Text = fileName, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = i, Parent = scroll, ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" },
                    }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }), Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 10) }) })
                    Creator.AddSignal(btn.MouseButton1Click, function()
                        FP.Value = filePath
                        DisplayLabel.Text = fileName
                        Dialog:Close()
                        Library:SafeCallback(FP.Callback, filePath)
                        Library:SafeCallback(FP.Changed, filePath)
                    end)
                end
            end

            Dialog:Button("Cancel")
            Dialog:Open()
        end)

        function FP:SetValue(path)
            self.Value = path
            DisplayLabel.Text = path:match("[^/\\]+$") or path
            Library:SafeCallback(self.Callback, path)
        end
        function FP:OnChanged(Func) FP.Changed = Func Func(FP.Value) end
        function FP:Destroy() FPFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
        if Idx then Library.Options[Idx] = FP end
        return FP
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [24] DATE/TIME PICKER
-- ──────────────────────────────────────────────────────────────
ElementsTable.DatePicker = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "DatePicker"

    function Element:New(Idx, Config)
        Config = Config or {}
        assert(Config.Title, "DatePicker - Missing Title")

        local now = Config.Default or os.time()
        local di = {}
        pcall(function() di = os.date("*t", now) end)

        local DP = {
            Type = "DatePicker",
            Year = di.year or 2024, Month = di.month or 1, Day = di.day or 1,
            Hour = di.hour or 0, Min = di.min or 0,
            Callback = Config.Callback or function() end,
        }

        local function getTS()
            local ts = 0
            pcall(function()
                ts = os.time({ year=DP.Year, month=DP.Month, day=DP.Day, hour=DP.Hour, min=DP.Min, sec=0 })
            end)
            return ts
        end

        local function fmt()
            if Config.ShowTime then
                return string.format("%04d-%02d-%02d %02d:%02d", DP.Year, DP.Month, DP.Day, DP.Hour, DP.Min)
            end
            return string.format("%04d-%02d-%02d", DP.Year, DP.Month, DP.Day)
        end

        local DPFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        DP.SetTitle = DPFrame.SetTitle; DP.SetDesc = DPFrame.SetDesc

        local DisplayBtn = Creator.New("TextButton", {
            Size = UDim2.fromOffset(Config.ShowTime and 150 or 110, 28),
            Position = UDim2.new(1, -10, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 0.88,
            Text = fmt(),
            TextSize = 12,
            FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
            Parent = DPFrame.Frame,
            ThemeTag = { BackgroundColor3 = "DropdownFrame", TextColor3 = "Text" },
        }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }), Creator.New("UIStroke", { Transparency = 0.4, ThemeTag = { Color = "InElementBorder" } }) })

        Creator.AddSignal(DisplayBtn.MouseButton1Click, function()
            local Dialog = Components.Dialog:Create()
            Dialog.Title.Text = "📅 " .. Config.Title
            Dialog.Root.Size = UDim2.fromOffset(300, 220)

            local function makeSpinner(label, val, min, max, px, py)
                local f = Creator.New("Frame", { Size = UDim2.fromOffset(65, 68), Position = UDim2.fromOffset(px, py), BackgroundTransparency = 0.9, Parent = Dialog.Root, ThemeTag = { BackgroundColor3 = "Element" } }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }) })
                Creator.New("TextLabel", { Size = UDim2.new(1,0,0,14), BackgroundTransparency=1, Text=label, TextSize=10, Parent=f, ThemeTag={TextColor3="SubText"} })
                local up = Creator.New("TextButton", { Size=UDim2.new(1,0,0,18), Position=UDim2.fromOffset(0,14), BackgroundTransparency=1, Text="▲", TextSize=12, Parent=f, ThemeTag={TextColor3="Accent"} })
                local vl = Creator.New("TextLabel", { Size=UDim2.new(1,0,0,18), Position=UDim2.fromOffset(0,32), BackgroundTransparency=1, Text=string.format("%02d",val), TextSize=16, FontFace=Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Bold), Parent=f, ThemeTag={TextColor3="Text"} })
                local dn = Creator.New("TextButton", { Size=UDim2.new(1,0,0,18), Position=UDim2.fromOffset(0,50), BackgroundTransparency=1, Text="▼", TextSize=12, Parent=f, ThemeTag={TextColor3="Accent"} })
                local cur = val
                Creator.AddSignal(up.MouseButton1Click, function() cur = ((cur-min+1) % (max-min+1)) + min; vl.Text = string.format("%02d",cur) end)
                Creator.AddSignal(dn.MouseButton1Click, function() cur = ((cur-min-1) % (max-min+1)) + min; vl.Text = string.format("%02d",cur) end)
                return function() return cur end
            end

            local getY = makeSpinner("YEAR", DP.Year, 2000, 2099, 10, 55)
            local getM = makeSpinner("MON",  DP.Month, 1, 12, 85, 55)
            local getD = makeSpinner("DAY",  DP.Day, 1, 31, 160, 55)

            Dialog:Button("Confirm", function()
                DP.Year = getY(); DP.Month = getM(); DP.Day = getD()
                DisplayBtn.Text = fmt()
                Library:SafeCallback(DP.Callback, getTS())
                Library:SafeCallback(DP.Changed, getTS())
            end)
            Dialog:Button("Cancel")
            Dialog:Open()
        end)

        function DP:SetValue(ts)
            local d = {}
            pcall(function() d = os.date("*t", ts) end)
            if d.year then DP.Year=d.year; DP.Month=d.month; DP.Day=d.day; DP.Hour=d.hour or 0; DP.Min=d.min or 0; DisplayBtn.Text=fmt() end
        end
        function DP:GetTimestamp() return getTS() end
        function DP:OnChanged(Func) DP.Changed = Func end
        function DP:Destroy() DPFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
        if Idx then Library.Options[Idx] = DP end
        return DP
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [29] DRAG-AND-DROP LIST
-- ──────────────────────────────────────────────────────────────
ElementsTable.DragList = (function()
    local Element = {}
    Element.__index = Element
    Element.__type = "DragList"

    function Element:New(Idx, Config)
        Config = Config or {}
        assert(Config.Title, "DragList - Missing Title")
        assert(Config.Items, "DragList - Missing Items")

        local DL = { Type = "DragList", Items = { table.unpack(Config.Items) }, Callback = Config.Callback or function() end }
        local DLFrame = Components.Element(Config.Title, Config.Description, self.Container, false, Config)
        DLFrame.Frame.BackgroundTransparency = 0.9

        local ListHolder = Creator.New("Frame", {
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            Parent = DLFrame.LabelHolder,
            LayoutOrder = 3,
        }, { Creator.New("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }), Creator.New("UIPadding", { PaddingBottom = UDim.new(0, 6) }) })

        local function buildList()
            for _, c in pairs(ListHolder:GetChildren()) do
                if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
            end
            for i, item in ipairs(DL.Items) do
                local row = Creator.New("Frame", {
                    Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 0.88, LayoutOrder = i, Parent = ListHolder, ThemeTag = { BackgroundColor3 = "Element" },
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }), Creator.New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Center }), Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }) })
                Creator.New("TextLabel", { Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 0.8, Text = tostring(i), TextSize = 11, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold), LayoutOrder = 1, Parent = row, ThemeTag = { BackgroundColor3 = "Accent", TextColor3 = "Text" } }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                Creator.New("TextLabel", { Size = UDim2.new(1, -80, 1, 0), BackgroundTransparency = 1, Text = tostring(item), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"), LayoutOrder = 2, Parent = row, ThemeTag = { TextColor3 = "Text" } })
                local upBtn = Creator.New("TextButton", { Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, Text = "↑", TextSize = 14, LayoutOrder = 3, Parent = row, ThemeTag = { TextColor3 = "Accent" } })
                local dnBtn = Creator.New("TextButton", { Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, Text = "↓", TextSize = 14, LayoutOrder = 4, Parent = row, ThemeTag = { TextColor3 = "Accent" } })
                local ii = i
                Creator.AddSignal(upBtn.MouseButton1Click, function()
                    if ii > 1 then DL.Items[ii], DL.Items[ii-1] = DL.Items[ii-1], DL.Items[ii]; buildList(); Library:SafeCallback(DL.Callback, DL.Items); Library:SafeCallback(DL.Changed, DL.Items) end
                end)
                Creator.AddSignal(dnBtn.MouseButton1Click, function()
                    if ii < #DL.Items then DL.Items[ii], DL.Items[ii+1] = DL.Items[ii+1], DL.Items[ii]; buildList(); Library:SafeCallback(DL.Callback, DL.Items); Library:SafeCallback(DL.Changed, DL.Items) end
                end)
            end
        end

        buildList()
        function DL:SetItems(items) self.Items = { table.unpack(items) }; buildList() end
        function DL:GetItems() return self.Items end
        function DL:OnChanged(Func) DL.Changed = Func Func(DL.Items) end
        function DL:Destroy() DLFrame.Frame:Destroy() if Idx then Library.Options[Idx] = nil end end
        if Idx then Library.Options[Idx] = DL end
        return DL
    end

    return Element
end)()

-- ──────────────────────────────────────────────────────────────
-- [40] ELEMENT VISIBILITY CONDITIONS
-- ──────────────────────────────────────────────────────────────
do
    local _visConditions = {}
    function Library:SetVisibilityCondition(idx, cond)
        _visConditions[idx] = cond
        Library:RefreshVisibilityConditions()
    end
    function Library:RemoveVisibilityCondition(idx)
        _visConditions[idx] = nil
        local opt = Library.Options[idx]
        if opt and opt.Elements and opt.Elements.Frame then opt.Elements.Frame.Visible = true end
    end
    function Library:RefreshVisibilityConditions()
        for idx, cond in pairs(_visConditions) do
            local opt = Library.Options[idx]
            if opt and opt.Elements and opt.Elements.Frame then
                local ok, show = pcall(cond)
                opt.Elements.Frame.Visible = ok and show or false
            end
        end
    end
    task.spawn(function()
        while true do
            task.wait(2)
            if next(_visConditions) then Library:RefreshVisibilityConditions() end
        end
    end)
end

-- ──────────────────────────────────────────────────────────────
-- [41] SWIPE GESTURE (MOBILE)
-- ──────────────────────────────────────────────────────────────
do
    Library._swipeEnabled = false
    local _swipeStart = nil

    function Library:EnableSwipeGesture(enabled) self._swipeEnabled = enabled end

    Creator.AddSignal(UserInputService.InputBegan, function(inp)
        if Library._swipeEnabled and inp.UserInputType == Enum.UserInputType.Touch then
            _swipeStart = Vector2.new(inp.Position.X, inp.Position.Y)
        end
    end)
    Creator.AddSignal(UserInputService.InputEnded, function(inp)
        if not Library._swipeEnabled or not _swipeStart then return end
        if inp.UserInputType == Enum.UserInputType.Touch then
            local delta = Vector2.new(inp.Position.X, inp.Position.Y) - _swipeStart
            _swipeStart = nil
            if math.abs(delta.X) > math.abs(delta.Y) and math.abs(delta.X) > 80 then
                local tm = Components.Tab
                if not tm or not tm.SelectedTab then return end
                local cur = tm.SelectedTab
                if delta.X < 0 and cur < (tm.TabCount or 0) then tm:SelectTab(cur + 1)
                elseif delta.X > 0 and cur > 1 then tm:SelectTab(cur - 1) end
            end
        end
    end)
end

-- ──────────────────────────────────────────────────────────────
-- [42] HAPTIC FEEDBACK (MOBILE)
-- ──────────────────────────────────────────────────────────────
do
    Library._hapticEnabled = true
    function Library:SetHapticEnabled(v) self._hapticEnabled = v end
    function Library:Haptic(style)
        if not self._hapticEnabled or not Mobile then return end
        pcall(function()
            local HS = game:GetService("HapticService")
            local m = Enum.VibrationMotor.Small
            local i = 0.5; local d = 0.05
            if style == "Light" then i = 0.3; d = 0.04
            elseif style == "Heavy" then i = 1.0; d = 0.1
            elseif style == "Error" then i = 1.0; d = 0.15; m = Enum.VibrationMotor.Large end
            if HS:IsMotorSupported(Enum.UserInputType.Gamepad1, m) then
                HS:SetMotor(Enum.UserInputType.Gamepad1, m, i)
                task.delay(d, function() HS:SetMotor(Enum.UserInputType.Gamepad1, m, 0) end)
            end
        end)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [44] FLOATING ACTION BUTTON (FAB)
-- ──────────────────────────────────────────────────────────────
do
    function Library:CreateFAB(Config)
        Config = Config or {}
        local iconId = Library:GetIcon(Config.Icon or "plus") or "rbxassetid://10734924532"
        local isExpanded = false

        local holder = Creator.New("Frame", {
            Name = "FAB",
            Size = UDim2.fromOffset(48, 48),
            Position = Config.Position or UDim2.new(1, -60, 1, -60),
            BackgroundTransparency = 0,
            ZIndex = 9000,
            Parent = Library.GUI,
            ThemeTag = { BackgroundColor3 = "Accent" },
        }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

        local mainBtn = Creator.New("TextButton", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = holder,
        }, { Creator.New("ImageLabel", { Image = iconId, Size = UDim2.fromOffset(22,22), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, ImageColor3 = Color3.fromRGB(255,255,255) }) })

        local subBtns = {}
        for i, action in ipairs(Config.Actions or {}) do
            local sub = Creator.New("Frame", {
                Size = UDim2.fromOffset(40, 40),
                Position = UDim2.new(0.5, -20, 0, -(i * 52 + 4)),
                BackgroundTransparency = 0, ZIndex = 9001, Visible = false, Parent = holder,
                ThemeTag = { BackgroundColor3 = "Element" },
            }, { Creator.New("UICorner", { CornerRadius = UDim.new(1,0) }), Creator.New("UIStroke", { Transparency=0.4, ThemeTag={Color="Accent"} }) })
            local clickBtn = Creator.New("TextButton", { Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=sub }, {
                Creator.New("ImageLabel", { Image=Library:GetIcon(action.Icon or "circle") or "rbxassetid://10709798174", Size=UDim2.fromOffset(18,18), Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1, ThemeTag={ImageColor3="Text"} })
            })
            Creator.AddSignal(clickBtn.MouseButton1Click, function()
                Library:SafeCallback(action.Callback)
                isExpanded = false
                for _, sb in ipairs(subBtns) do
                    TweenService:Create(sb, TweenInfo.new(0.15), { Size=UDim2.fromOffset(0,0) }):Play()
                    task.delay(0.15, function() sb.Visible=false sb.Size=UDim2.fromOffset(40,40) end)
                end
            end)
            table.insert(subBtns, sub)
        end

        Creator.AddSignal(mainBtn.MouseButton1Click, function()
            isExpanded = not isExpanded
            for _, sb in ipairs(subBtns) do
                if isExpanded then
                    sb.Visible = true; sb.Size = UDim2.fromOffset(0,0)
                    TweenService:Create(sb, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size=UDim2.fromOffset(40,40) }):Play()
                else
                    TweenService:Create(sb, TweenInfo.new(0.15), { Size=UDim2.fromOffset(0,0) }):Play()
                    task.delay(0.15, function() sb.Visible=false sb.Size=UDim2.fromOffset(40,40) end)
                end
            end
        end)

        return {
            Frame = holder,
            Destroy = function() holder:Destroy() end,
        }
    end
end

-- ──────────────────────────────────────────────────────────────
-- [55] ENCRYPTED CONFIG
-- ──────────────────────────────────────────────────────────────
do
    local function xor(data, key)
        local r = {}
        for i = 1, #data do
            r[i] = string.char(bit32.bxor(data:byte(i), key:byte(((i-1) % #key) + 1)))
        end
        return table.concat(r)
    end

    local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function b64enc(s)
        local r = {}
        for i = 1, #s, 3 do
            local a, b, c = s:byte(i, i+2)
            b = b or 0; c = c or 0
            local n = bit32.lshift(a,16) + bit32.lshift(b,8) + c
            r[#r+1] = b64chars:sub(bit32.rshift(n,18)%64+1, bit32.rshift(n,18)%64+1)
            r[#r+1] = b64chars:sub(bit32.rshift(n,12)%64+1, bit32.rshift(n,12)%64+1)
            r[#r+1] = i+1<=#s and b64chars:sub(bit32.rshift(n,6)%64+1, bit32.rshift(n,6)%64+1) or "="
            r[#r+1] = i+2<=#s and b64chars:sub(n%64+1, n%64+1) or "="
        end
        return table.concat(r)
    end

    local function b64dec(s)
        s = s:gsub("[^"..b64chars.."=]","")
        local r = {}
        for i = 1, #s, 4 do
            local function v(b) return b and ((b64chars:find(string.char(b)) or 1)-1) or 0 end
            local a,b,c,d = s:byte(i,i+3)
            local n = bit32.lshift(v(a),18) + bit32.lshift(v(b),12) + bit32.lshift(v(c),6) + v(d)
            r[#r+1] = string.char(bit32.rshift(n,16)%256)
            if string.char(c or 61) ~= "=" then r[#r+1] = string.char(bit32.rshift(n,8)%256) end
            if string.char(d or 61) ~= "=" then r[#r+1] = string.char(n%256) end
        end
        return table.concat(r)
    end

    function SaveManager:SaveEncrypted(name, key)
        assert(name and key, "SaveEncrypted: Missing name or key")
        local data = { objects = {} }
        for idx, opt in pairs(SaveManager.Options) do
            if SaveManager.Parser[opt.Type] then
                table.insert(data.objects, SaveManager.Parser[opt.Type].Save(idx, opt))
            end
        end
        local encrypted = b64enc(xor(httpService:JSONEncode(data), key))
        if not RunService:IsStudio() then
            pcall(function()
                if not isfolder(SaveManager.Folder) then makefolder(SaveManager.Folder) end
                writefile(SaveManager.Folder .. "/" .. name .. ".enc", encrypted)
            end)
        end
        Library:Notify({ Title = "Config", Content = 'Encrypted "' .. name .. '" saved', Duration = 2, Type = "success" })
        return encrypted
    end

    function SaveManager:LoadEncrypted(name, key)
        assert(name and key, "LoadEncrypted: Missing name or key")
        local enc = ""
        if not RunService:IsStudio() then
            pcall(function()
                local p = SaveManager.Folder .. "/" .. name .. ".enc"
                if isfile(p) then enc = readfile(p) end
            end)
        end
        if enc == "" then
            Library:Notify({ Title = "Config", Content = '"' .. name .. '" not found', Duration = 3, Type = "error" })
            return false
        end
        local ok, result = pcall(function() return httpService:JSONDecode(xor(b64dec(enc), key)) end)
        if not ok or not result then
            Library:Notify({ Title = "Config", Content = "Wrong key or corrupted", Duration = 3, Type = "error" })
            return false
        end
        for _, opt in pairs(result.objects or {}) do
            if SaveManager.Parser[opt.type] then
                task.spawn(function() SaveManager.Parser[opt.type].Load(opt.idx, opt) end)
            end
        end
        Library:Notify({ Title = "Config", Content = 'Encrypted "' .. name .. '" loaded', Duration = 2, Type = "success" })
        return true
    end
end

-- ──────────────────────────────────────────────────────────────
-- [56] MULTI-LANGUAGE SUPPORT (i18n)
-- ──────────────────────────────────────────────────────────────
do
    Library._language = "en"
    Library._translations = {
        en = { Save="Save", Load="Load", Close="Close", Search="Search...", Confirm="Confirm", Cancel="Cancel", Yes="Yes", No="No", Reset="Reset", Apply="Apply", Delete="Delete", Copy="Copy", Theme="Theme", Settings="Settings" },
        th = { Save="บันทึก", Load="โหลด", Close="ปิด", Search="ค้นหา...", Confirm="ยืนยัน", Cancel="ยกเลิก", Yes="ใช่", No="ไม่", Reset="รีเซ็ต", Apply="ใช้งาน", Delete="ลบ", Copy="คัดลอก", Theme="ธีม", Settings="การตั้งค่า" },
        ja = { Save="保存", Load="読込", Close="閉じる", Search="検索...", Confirm="確認", Cancel="キャンセル", Yes="はい", No="いいえ", Reset="リセット", Apply="適用", Delete="削除", Copy="コピー", Theme="テーマ", Settings="設定" },
    }
    function Library:T(key)
        local lang = self._translations[self._language]
        if lang and lang[key] then return lang[key] end
        return (self._translations["en"] and self._translations["en"][key]) or key
    end
    function Library:SetLanguage(code)
        self._language = code
        Library:Notify({ Title = "Language", Content = "Language: " .. code, Duration = 2, Type = "info" })
    end
    function Library:RegisterLanguage(code, t)
        if not self._translations[code] then self._translations[code] = {} end
        for k,v in pairs(t) do self._translations[code][k] = v end
    end
    function Library:GetAvailableLanguages()
        local l = {}
        for code in pairs(self._translations) do table.insert(l, code) end
        return l
    end
end

-- ──────────────────────────────────────────────────────────────
-- [64] EXPORT DATA เป็น CSV
-- ──────────────────────────────────────────────────────────────
do
    function Library:ExportToCSV(filename)
        local lines = { "Index,Type,Value,Title" }
        for idx, opt in pairs(Library.Options) do
            if opt and opt.Type then
                local title = ""
                pcall(function() title = opt.Elements and opt.Elements.TitleLabel and opt.Elements.TitleLabel.Text or "" end)
                local value = tostring(opt.Value or "")
                if value:find(",") then value = '"' .. value:gsub('"','""') .. '"' end
                if title:find(",") then title = '"' .. title:gsub('"','""') .. '"' end
                table.insert(lines, idx .. "," .. opt.Type .. "," .. value .. "," .. title)
            end
        end
        local csv = table.concat(lines, "\n")
        if filename and not RunService:IsStudio() then
            pcall(function()
                if not isfolder(SaveManager.Folder) then makefolder(SaveManager.Folder) end
                writefile(SaveManager.Folder .. "/" .. filename, csv)
            end)
            Library:Notify({ Title = "Export", Content = 'Saved "' .. filename .. '"', Duration = 2, Type = "success" })
        else
            pcall(function() if setclipboard then setclipboard(csv) elseif toclipboard then toclipboard(csv) end end)
            Library:Notify({ Title = "Export", Content = "CSV copied! (" .. (#lines-1) .. " elements)", Duration = 3, Type = "success" })
        end
        return csv
    end
end

-- ──────────────────────────────────────────────────────────────
-- [65] IMPORT DATA จาก CSV
-- ──────────────────────────────────────────────────────────────
do
    function Library:ImportFromCSV(csvString)
        if not csvString or csvString == "" then return 0 end
        local lines = csvString:split("\n")
        local imported = 0
        for i = 2, #lines do
            local line = lines[i]:gsub("\r","")
            if line ~= "" then
                local parts = {}
                for p in line:gmatch("([^,]+)") do table.insert(parts, p:gsub('^"',''):gsub('"$','')) end
                if #parts >= 3 then
                    local opt = Library.Options[parts[1]]
                    if opt and opt.SetValue then
                        local v = parts[3]
                        if opt.Type == "Toggle" or opt.Type == "Checkbox" then pcall(function() opt:SetValue(v=="true") end)
                        elseif opt.Type == "Slider" or opt.Type == "Rating" then
                            local n = tonumber(v); if n then pcall(function() opt:SetValue(n) end) end
                        else pcall(function() opt:SetValue(v) end) end
                        imported = imported + 1
                    end
                end
            end
        end
        Library:Notify({ Title = "Import", Content = "Imported " .. imported .. " values", Duration = 3, Type = "success" })
        return imported
    end

    function Library:ImportFromCSVFile(filename)
        local content = ""
        pcall(function()
            local p = SaveManager.Folder .. "/" .. filename
            if isfile(p) then content = readfile(p) end
        end)
        if content == "" then
            Library:Notify({ Title = "Import", Content = '"' .. filename .. '" not found', Duration = 3, Type = "error" })
            return 0
        end
        return Library:ImportFromCSV(content)
    end
end

-- ──────────────────────────────────────────────────────────────
-- [73] GRADIENT ANIMATION บน ACCENT
-- ──────────────────────────────────────────────────────────────
do
    local _accentConn = nil
    local _accentOriginal = nil

    function Library:StartAccentAnimation(config)
        config = config or {}
        local colors = config.Colors or {
            Color3.fromRGB(105, 215, 255), Color3.fromRGB(160, 130, 255),
            Color3.fromRGB(255, 100, 150), Color3.fromRGB(105, 215, 255),
        }
        local speed = config.Speed or 4
        if not _accentOriginal then _accentOriginal = Creator.GetThemeProperty("Accent") end
        if _accentConn then _accentConn:Disconnect() end
        local t0 = tick()
        local n = #colors
        _accentConn = RunService.Heartbeat:Connect(function()
            local t = ((tick()-t0)/speed) % 1
            local seg = math.floor(t*(n-1))
            local segT = (t*(n-1)) - seg
            seg = math.clamp(seg, 0, n-2)
            local c1, c2 = colors[seg+1], colors[seg+2]
            if not c1 or not c2 then return end
            local cur = Color3.new(c1.R+(c2.R-c1.R)*segT, c1.G+(c2.G-c1.G)*segT, c1.B+(c2.B-c1.B)*segT)
            if Themes[Library.Theme] then Themes[Library.Theme].Accent = cur; Creator.UpdateTheme() end
        end)
    end

    function Library:StopAccentAnimation()
        if _accentConn then _accentConn:Disconnect(); _accentConn = nil end
        if _accentOriginal and Themes[Library.Theme] then
            Themes[Library.Theme].Accent = _accentOriginal; Creator.UpdateTheme(); _accentOriginal = nil
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- [77] SPLIT VIEW
-- ──────────────────────────────────────────────────────────────
do
    function Library:CreateSplitView(tab)
        if not tab or not tab.Container then return nil end
        local SV = {}
        local SplitFrame = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Parent = tab.Container, LayoutOrder = 7,
        }, { Creator.New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Top }) })

        local LeftPane = Creator.New("Frame", { Size=UDim2.new(0.5,-3,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, LayoutOrder=1, Parent=SplitFrame }, { Creator.New("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder }) })
        local RightPane = Creator.New("Frame", { Size=UDim2.new(0.5,-3,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, LayoutOrder=2, Parent=SplitFrame }, { Creator.New("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder }) })

        local function makePane(pane, title)
            local s = { Container = pane, ScrollFrame = tab.ScrollFrame }
            if title then
                Creator.New("TextLabel", { Size=UDim2.new(1,0,0,22), BackgroundTransparency=0.85, Text=title, TextSize=12, FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Bold), LayoutOrder=0, Parent=pane, ThemeTag={BackgroundColor3="Element",TextColor3="Text"} }, { Creator.New("UICorner",{CornerRadius=UDim.new(0,6)}) })
            end
            setmetatable(s, Library.Elements)
            return s
        end

        function SV:AddLeftSection(t) return makePane(LeftPane, t) end
        function SV:AddRightSection(t) return makePane(RightPane, t) end
        function SV:SetRatio(r)
            r = math.clamp(r, 0.1, 0.9)
            LeftPane.Size = UDim2.new(r, -3, 0, 0)
            RightPane.Size = UDim2.new(1-r, -3, 0, 0)
        end
        function SV:Destroy() SplitFrame:Destroy() end
        return SV
    end
end

-- ──────────────────────────────────────────────────────────────
-- [80] BREADCRUMB NAVIGATION
-- ──────────────────────────────────────────────────────────────
do
    local _breadcrumbFrame = nil
    local _breadcrumbs = {}

    function Library:SetBreadcrumb(crumbs)
        _breadcrumbs = crumbs or {}
        if not _breadcrumbFrame and Library.Window and Library.Window.ContainerCanvas then
            _breadcrumbFrame = Creator.New("Frame", { Name="Breadcrumb", Size=UDim2.new(1,0,0,24), Position=UDim2.fromOffset(0,-28), BackgroundTransparency=1, Parent=Library.Window.ContainerCanvas, ZIndex=10 }, { Creator.New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,0), VerticalAlignment=Enum.VerticalAlignment.Center }) })
        end
        if not _breadcrumbFrame then return end
        for _, c in pairs(_breadcrumbFrame:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        for i, crumb in ipairs(_breadcrumbs) do
            Creator.New("TextLabel", {
                Size=UDim2.fromOffset(0,20), AutomaticSize=Enum.AutomaticSize.X, BackgroundTransparency=1,
                Text=crumb, TextSize=11, FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json", i==#_breadcrumbs and Enum.FontWeight.Bold or Enum.FontWeight.Regular),
                LayoutOrder=i*2, Parent=_breadcrumbFrame,
                TextColor3=i==#_breadcrumbs and (Creator.GetThemeProperty("Accent") or Color3.fromRGB(105,215,255)) or (Creator.GetThemeProperty("SubText") or Color3.fromRGB(148,152,175)),
            })
            if i < #_breadcrumbs then
                Creator.New("TextLabel", { Size=UDim2.fromOffset(16,20), BackgroundTransparency=1, Text=" › ", TextSize=11, LayoutOrder=i*2+1, Parent=_breadcrumbFrame, ThemeTag={TextColor3="SubText"} })
            end
        end
    end

    function Library:ShowBreadcrumb(v) if _breadcrumbFrame then _breadcrumbFrame.Visible = v end end
    function Library:ClearBreadcrumb() Library:SetBreadcrumb({}) end
    function Library:PushBreadcrumb(c) table.insert(_breadcrumbs, c); Library:SetBreadcrumb(_breadcrumbs) end
    function Library:PopBreadcrumb() table.remove(_breadcrumbs); Library:SetBreadcrumb(_breadcrumbs) end
end

-- ──────────────────────────────────────────────────────────────
-- [82] TAB REORDERING
-- ──────────────────────────────────────────────────────────────
do
    Library._tabReorderEnabled = false
    function Library:EnableTabReorder(enabled)
        self._tabReorderEnabled = enabled
        local tm = Components.Tab
        if not tm or not tm.Tabs then return end
        for tabIdx, tab in pairs(tm.Tabs) do
            if tab.Frame and not tab._reorderHooked then
                tab._reorderHooked = true
                local holdTimer, isDragging = nil, false
                Creator.AddSignal(tab.Frame.InputBegan, function(inp)
                    if not Library._tabReorderEnabled then return end
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        holdTimer = task.delay(0.4, function()
                            holdTimer = nil; isDragging = true
                            TweenService:Create(tab.Frame, TweenInfo.new(0.15), { BackgroundTransparency=0.6 }):Play()
                        end)
                    end
                end)
                Creator.AddSignal(tab.Frame.InputEnded, function(inp)
                    if not Library._tabReorderEnabled then return end
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        if holdTimer then task.cancel(holdTimer); holdTimer = nil end
                        if isDragging then
                            isDragging = false
                            TweenService:Create(tab.Frame, TweenInfo.new(0.15), { BackgroundTransparency=0.92 }):Play()
                        end
                    end
                end)
                Creator.AddSignal(UserInputService.InputChanged, function(inp)
                    if not isDragging then return end
                    if inp.UserInputType == Enum.UserInputType.MouseMovement then
                        for oi, ot in pairs(tm.Tabs) do
                            if oi ~= tabIdx and ot.Frame then
                                local ap = ot.Frame.AbsolutePosition
                                local as = ot.Frame.AbsoluteSize
                                if inp.Position.Y >= ap.Y and inp.Position.Y <= ap.Y+as.Y then
                                    local lo1, lo2 = tab.Frame.LayoutOrder, ot.Frame.LayoutOrder
                                    tab.Frame.LayoutOrder = lo2; ot.Frame.LayoutOrder = lo1
                                    break
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- [83] SECTION TEMPLATES
-- ──────────────────────────────────────────────────────────────
do
    Library._templates = {}

    Library._templates["PlayerSettings"] = function(tab)
        local s = tab:AddSection("Player")
        s:AddSlider("WalkSpeed", { Title="Walk Speed", Min=16, Max=500, Default=16, Rounding=0, Callback=function(v) pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed=v end) end })
        s:AddSlider("JumpPower", { Title="Jump Power", Min=7, Max=500, Default=50, Rounding=0, Callback=function(v) pcall(function() LocalPlayer.Character.Humanoid.JumpPower=v end) end })
        s:AddToggle("Noclip", { Title="Noclip", Default=false, Callback=function(v) Library:Notify({Title="Noclip",Content=v and "ON" or "OFF",Duration=1,Type=v and "success" or "info"}) end })
        return s
    end

    Library._templates["VisualSettings"] = function(tab)
        local s = tab:AddSection("Visual")
        s:AddToggle("FullBright", { Title="Fullbright", Default=false, Callback=function(v) pcall(function() local l=game:GetService("Lighting"); l.Brightness=v and 2 or 1; l.Ambient=v and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0) end) end })
        s:AddSlider("FOV", { Title="FOV", Min=30, Max=120, Default=70, Rounding=0, Callback=function(v) pcall(function() Camera.FieldOfView=v end) end })
        s:AddDropdown("ThemePicker", { Title="Theme", Values=Library.Themes, Default=Library.Theme, Callback=function(v) Library:SetTheme(v) end })
        return s
    end

    function Library:ApplyTemplate(tab, name)
        local t = Library._templates[name]
        if not t then warn("[FluentUI] Template '" .. name .. "' not found") return nil end
        return t(tab)
    end

    function Library:RegisterTemplate(name, fn) Library._templates[name] = fn end
    function Library:GetTemplates()
        local l = {}
        for n in pairs(Library._templates) do table.insert(l, n) end
        return l
    end
end

-- ──────────────────────────────────────────────────────────────
-- [84] FLOATING TOOLBAR
-- ──────────────────────────────────────────────────────────────
do
    function Library:CreateFloatingToolbar(Config)
        Config = Config or {}
        local TB = {}
        local holder = Creator.New("Frame", {
            Name = "FloatingToolbar",
            Size = UDim2.fromOffset(0, 36), AutomaticSize = Enum.AutomaticSize.X,
            Position = Config.Position or UDim2.new(0.5, -100, 0, 8),
            BackgroundTransparency = 0.1, ZIndex = 8000, Parent = Library.GUI,
            ThemeTag = { BackgroundColor3 = "DropdownHolder" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 10) }),
            Creator.New("UIStroke", { Transparency=0.4, ThemeTag={Color="AcrylicBorder"} }),
            Creator.New("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, VerticalAlignment=Enum.VerticalAlignment.Center, Padding=UDim.new(0,2) }),
            Creator.New("UIPadding", { PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6) }),
        })

        local function addItem(item)
            if item.Separator then
                Creator.New("Frame", { Size=UDim2.new(0,1,0.6,0), BackgroundTransparency=0.5, Parent=holder, ThemeTag={BackgroundColor3="InElementBorder"} })
                return
            end
            local btn = Creator.New("TextButton", { Size=UDim2.fromOffset(30,30), BackgroundTransparency=1, Text="", Parent=holder, ThemeTag={BackgroundColor3="Hover"} }, {
                Creator.New("UICorner", { CornerRadius=UDim.new(0,6) }),
                Creator.New("ImageLabel", { Image=Library:GetIcon(item.Icon or "circle") or "rbxassetid://10709798174", Size=UDim2.fromOffset(16,16), Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1, ThemeTag={ImageColor3="Text"} }),
            })
            local _, SetT = Creator.SpringMotor(1, btn, "BackgroundTransparency")
            Creator.AddSignal(btn.MouseEnter, function() SetT(0.88) end)
            Creator.AddSignal(btn.MouseLeave, function() SetT(1) end)
            Creator.AddSignal(btn.MouseButton1Click, function() Library:SafeCallback(item.Callback) end)
            return btn
        end

        for _, item in ipairs(Config.Buttons or {}) do addItem(item) end

        -- Draggable
        local dragging, dragStart, dragOffset = false
        Creator.AddSignal(holder.InputBegan, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; dragStart = Vector2.new(inp.Position.X, inp.Position.Y); dragOffset = holder.Position
                inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        Creator.AddSignal(RunService.Heartbeat, function()
            if dragging then
                local d = Vector2.new(Mouse.X, Mouse.Y) - dragStart
                local vp = Camera.ViewportSize
                holder.Position = UDim2.fromOffset(math.clamp(dragOffset.X.Offset+d.X, 0, vp.X-holder.AbsoluteSize.X), math.clamp(dragOffset.Y.Offset+d.Y, 0, vp.Y-36))
            end
        end)

        function TB:Show() holder.Visible = true end
        function TB:Hide() holder.Visible = false end
        function TB:AddButton(item) return addItem(item) end
        function TB:Destroy() holder:Destroy() end
        return TB
    end
end

-- ──────────────────────────────────────────────────────────────
-- [90] PLUGIN SYSTEM
-- ──────────────────────────────────────────────────────────────
do
    Library._plugins = {}
    Library._loadedPlugins = {}

    function Library:RegisterPlugin(p)
        assert(p.Name and p.Init, "RegisterPlugin: Missing Name or Init")
        Library._plugins[p.Name] = p
    end

    function Library:LoadPlugin(name)
        local p = Library._plugins[name]
        if not p then Library:Notify({Title="Plugin",Content='"'..name..'" not found',Duration=3,Type="error"}); return false end
        if Library._loadedPlugins[name] then Library:Notify({Title="Plugin",Content='"'..name..'" already loaded',Duration=2,Type="warning"}); return false end
        local ok, err = pcall(function() p.Init(Library) end)
        if not ok then Library:Notify({Title="Plugin",Content='Failed: '..tostring(err),Duration=5,Type="error"}); return false end
        Library._loadedPlugins[name] = p
        Library:Notify({Title="Plugin",Content='"'..name..'" v'..(p.Version or "?")..' loaded',Duration=2,Type="success"})
        return true
    end

    function Library:UnloadPlugin(name)
        local p = Library._loadedPlugins[name]
        if not p then return false end
        if p.Destroy then pcall(function() p.Destroy() end) end
        Library._loadedPlugins[name] = nil
        Library:Notify({Title="Plugin",Content='"'..name..'" unloaded',Duration=2,Type="info"})
        return true
    end

    function Library:GetPlugins()
        local l = {}
        for name, p in pairs(Library._plugins) do
            table.insert(l, {name=name, version=p.Version, author=p.Author, loaded=Library._loadedPlugins[name]~=nil})
        end
        return l
    end

    function Library:RegisterElementType(typeName, et)
        et.__type = typeName
        ElementsTable[typeName] = et
        Elements["Add"..typeName] = function(self, Idx, Config)
            et.Container = self.Container; et.Type = self.Type; et.ScrollFrame = self.ScrollFrame; et.Library = Library
            return et.NoIdx and et:New(Idx) or et:New(Idx, Config)
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- [92] HOT RELOAD
-- ──────────────────────────────────────────────────────────────
do
    Library._hotReloadEnabled = false
    Library._reloadCallback = nil

    function Library:EnableHotReload(enabled)
        self._hotReloadEnabled = enabled
        if enabled then
            Library:Notify({Title="Hot Reload",Content="Ctrl+R to reload",Duration=3,Type="info"})
        end
    end

    function Library:TriggerReload()
        Creator.UpdateTheme()
        if not RunService:IsStudio() then
            pcall(function()
                local p = SaveManager.Folder .. "/autoload.txt"
                if isfile(p) then
                    local name = (readfile(p) or ""):match("^%s*(.-)%s*$")
                    if name ~= "" then SaveManager:Load(name) end
                end
            end)
        end
        if Library._reloadCallback then Library:SafeCallback(Library._reloadCallback) end
        Library:Notify({Title="Hot Reload",Content="Reloaded successfully",Duration=1.5,Type="success"})
    end

    function Library:SetReloadCallback(fn) Library._reloadCallback = fn end

    Creator.AddSignal(UserInputService.InputBegan, function(inp, gp)
        if gp or not Library._hotReloadEnabled then return end
        local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        if ctrl and inp.KeyCode == Enum.KeyCode.R then Library:TriggerReload() end
    end)
end

-- ──────────────────────────────────────────────────────────────
-- [93] TYPE-SAFE CONFIG VALIDATION
-- ──────────────────────────────────────────────────────────────
do
    local schemas = {
        AddToggle   = { required={"Title"}, types={Title="string",Default="boolean",Callback="function"} },
        AddSlider   = { required={"Title","Min","Max","Default"}, types={Title="string",Min="number",Max="number",Default="number",Callback="function"} },
        AddDropdown = { required={"Title","Values"}, types={Title="string",Values="table",Callback="function"} },
        AddInput    = { required={"Title"}, types={Title="string",Default="string",Callback="function"} },
        AddKeybind  = { required={"Title","Default"}, types={Title="string"} },
    }

    function Library:ValidateConfig(elementType, config)
        local s = schemas[elementType]
        if not s then return true end
        local errors = {}
        for _, f in ipairs(s.required or {}) do
            if config[f] == nil then table.insert(errors, "Missing required: '" .. f .. "'") end
        end
        for f, et in pairs(s.types or {}) do
            if config[f] ~= nil and typeof(config[f]) ~= et then
                table.insert(errors, "'" .. f .. "' expected " .. et .. ", got " .. typeof(config[f]))
            end
        end
        if #errors > 0 then
            warn("[FluentUI] " .. elementType .. " errors:"); for _,e in ipairs(errors) do warn("  • "..e) end
            return false, errors
        end
        return true
    end
end

-- ──────────────────────────────────────────────────────────────
-- [45] LANDSCAPE/PORTRAIT AUTO-LAYOUT
-- ──────────────────────────────────────────────────────────────
do
    Library._landscapeMode = false
    local function checkOrientation()
        local vp = Camera.ViewportSize
        local isLandscape = vp.X > vp.Y
        if isLandscape ~= Library._landscapeMode then
            Library._landscapeMode = isLandscape
            Library:Notify({ Title="Layout", Content=isLandscape and "Landscape mode" or "Portrait mode", Duration=1.5, Type="info" })
        end
    end
    Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), checkOrientation)
    function Library:IsLandscape() return Library._landscapeMode end
    function Library:IsPortrait() return not Library._landscapeMode end
end

-- ──────────────────────────────────────────────────────────────
-- Register all new elements + SaveManager parsers
-- ──────────────────────────────────────────────────────────────
do
    for _, ec in ipairs({ ElementsTable.Sparkline, ElementsTable.FilePicker, ElementsTable.DatePicker, ElementsTable.DragList }) do
        if ec and ec.__type then
            Elements["Add"..ec.__type] = function(self, Idx, Config)
                ec.Container = self.Container; ec.Type = self.Type; ec.ScrollFrame = self.ScrollFrame; ec.Library = Library
                return ec.NoIdx and ec:New(Idx) or ec:New(Idx, Config)
            end
        end
    end

    SaveManager.Parser["FilePicker"] = {
        Save = function(i,o) return {type="FilePicker",idx=i,value=o.Value} end,
        Load = function(i,d) if SaveManager.Options[i] then SaveManager.Options[i]:SetValue(d.value or "") end end,
    }
    SaveManager.Parser["DatePicker"] = {
        Save = function(i,o) return {type="DatePicker",idx=i,value=o:GetTimestamp()} end,
        Load = function(i,d) if SaveManager.Options[i] then SaveManager.Options[i]:SetValue(tonumber(d.value) or os.time()) end end,
    }
    SaveManager.Parser["DragList"] = {
        Save = function(i,o) return {type="DragList",idx=i,value=table.concat(o.Items,",")} end,
        Load = function(i,d)
            if SaveManager.Options[i] then
                local items = {}
                for it in (d.value or ""):gmatch("[^,]+") do table.insert(items, it) end
                SaveManager.Options[i]:SetItems(items)
            end
        end,
    }
end

-- ═══════════════════════════════════════════════════════════════
-- END FEATURE PACK PART 5
-- ═══════════════════════════════════════════════════════════════




if RunService:IsStudio() then task.wait(0.01) end
return Library, SaveManager, InterfaceManager, Mobile