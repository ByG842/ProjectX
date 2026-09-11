local InterfaceManager = {} do
	InterfaceManager.Folder = "FluentSettings"
	InterfaceManager.Settings = {
		Transparency = true,
		MenuKeybind = "M",
		WindowTransparency = 1.5,
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
			local success, decoded
			if not RunService:IsStudio() then
				success, decoded = pcall(httpService.JSONDecode, httpService, data)
			end
			if success then
				for i, v in next, decoded do
					InterfaceManager.Settings[i] = v
				end
			end
		end
	end
	function InterfaceManager:BuildInterfaceSection(tab)

		-- กัน error กรณีสคริปต์ที่เรียกใช้ยังไม่ได้เซ็ต InterfaceManager.Library ไว้ก่อน
		-- (บั๊กเดียวกับที่เคยแก้ให้ SaveManager ด้านล่าง แต่ลืมแก้ให้ InterfaceManager เอง —
		-- ถ้าไม่มีบรรทัดนี้ assert ด้านล่างจะ error ทันที ทำให้ทั้งฟังก์ชันหยุดทำงานตั้งแต่ต้น
		-- ผลคือ subtab "Interface" และ "Config" ในแท็บ Settings จะไม่มี element ใดๆ ถูกสร้างเลย
		-- เห็นเป็นแค่พื้นหลังโปร่งใส/หมอกขาวๆ ว่างเปล่าทั้งสอง subtab)
		if not self.Library then
			self:SetLibrary(Library)
		end
		assert(self.Library, "Must set InterfaceManager.Library")
		local Library = self.Library
		local Settings = InterfaceManager.Settings
		InterfaceManager:LoadSettings()

		-- Split the Settings tab into two subtabs: Interface and Config
		local InterfaceSubTab = tab:AddSubTab("Interface", "monitor")
		local ConfigSubTab = tab:AddSubTab("Config", "settings")
		InterfaceManager.InterfaceSubTab = InterfaceSubTab
		InterfaceManager.ConfigSubTab = ConfigSubTab
		local section = InterfaceSubTab:AddSection("Interface", "monitor")
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
		local WindowTransparencySlider = section:AddSlider("WindowTransparency", {
			Title = "Window Transparency",
			Description = "Adjusts the window transparency.",
			Default = Settings.WindowTransparency or 1.5,
			Min = 0,
			Max = 3,
			Rounding = 1,
			Callback = function(Value)
				Library:SetWindowTransparency(Value)
				Settings.WindowTransparency = Value
				InterfaceManager:SaveSettings()
			end
		})
		InterfaceManager.WindowTransparencySlider = WindowTransparencySlider

		-- apply saved transparency right away when UI loads
		task.defer(function()
			Library:SetWindowTransparency(Settings.WindowTransparency or 1.5)
		end)

		-- 🎨 Custom Theme section — Accent Color lives separately from the preset theme dropdown
		local customThemeSection = InterfaceSubTab:AddSection("Custom Theme", "palette")
		local defaultAccentColor = Color3.fromRGB(200, 200, 200)
		if Settings.AccentColor and typeof(Settings.AccentColor) == "table" then
			defaultAccentColor = Color3.fromRGB(
				Settings.AccentColor.r or 200,
				Settings.AccentColor.g or 200,
				Settings.AccentColor.b or 200
			)
		end
		local AccentColorPicker = customThemeSection:AddColorpicker("CustomAccentColor", {
			Title = "Accent Color",
			Description = "Set a custom accent color without changing the whole theme.",
			Default = defaultAccentColor,
			Callback = function(Color)
				Library:SetAccentColor(Color)
				Settings.AccentColor = { r = math.floor(Color.R * 255), g = math.floor(Color.G * 255), b = math.floor(Color.B * 255) }
				InterfaceManager:SaveSettings()
			end,
		})

		-- ถ้าเคยตั้ง custom accent ไว้ ให้ apply ทันทีตอนโหลด UI
		if Settings.AccentColor and typeof(Settings.AccentColor) == "table" then
			task.defer(function()
				Library:SetAccentColor(defaultAccentColor, true)
			end)
		end
		local ResetAccentButton = customThemeSection:AddActionButton("ResetAccentColor", {
			Title      = "Reset Accent Color",
			ButtonText = "Reset",
			CopiedText = "✓ Reset",
			CopyText   = "",
			Callback   = function()
				Library:ResetAccentColor()
				Settings.AccentColor = nil
				InterfaceManager:SaveSettings()
				local themeAccent = (Themes[Library.Theme] and Themes[Library.Theme].Accent) or Color3.fromRGB(200, 200, 200)
				AccentColorPicker:SetValueRGB(themeAccent)
			end,
		})

		-- Minimize Bind now lives inside the "Interface" section, alongside Theme/Window Transparency
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Library.MinimizeKey.Name or Settings.MenuKeybind })

		MenuKeybind:OnChanged(function()
			Settings.MenuKeybind = MenuKeybind.Value
			InterfaceManager:SaveSettings()
		end)
		Library.MinimizeKeybind = MenuKeybind

		-- Build the Config (save/load) subtab. Make sure SaveManager has a Library reference
		-- even if the caller hasn't wired it up yet — this used to depend on call order.
		if SaveManager then
			if not SaveManager.Library then
				SaveManager:SetLibrary(Library)
			end
			if not InterfaceManager.ConfigSectionBuilt then
				SaveManager:BuildConfigSection(ConfigSubTab)
				InterfaceManager.ConfigSectionBuilt = true
			end
		end
		return InterfaceSubTab, ConfigSubTab
	end
end

Library.CreateWindow = function(self, Config)
	assert(Config.Title, "Window - Missing Title")
	if Library.Window then
		print("You cannot create more than one window.")
		return
	end
	Library.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.RightControl
	Library.UseAcrylic = false -- 🗑️ Acrylic blur mesh feature ถูกลบออกแล้ว
	Library.Acrylic = false
	Library.Theme = Config.Theme or "Dark"
	local userProvidedBackgroundImage = (Config.BackgroundImage ~= nil)
	if Config.BackgroundImage == nil then
		if Config.Theme == "Minecraft" then
			Config.BackgroundImage = "rbxassetid://127892835920326"
		else
			Config.BackgroundImage = "rbxassetid://13196113628"
		end
	end
	if Config.BackgroundTransparency == nil then
		Config.BackgroundTransparency = 0.5
	end
	if Config.BackgroundImageTransparency == nil and Config.Theme == "Minecraft" then
		Config.BackgroundImageTransparency = 0.08 -- เท็กซ์เจอร์ชัด/ทึบกว่าเดิม
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
		Theme = Config.Theme,
		ManagedBackgroundImage = not userProvidedBackgroundImage,
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
	Library:SetTheme(Config.Theme, true)
	return Window
end

