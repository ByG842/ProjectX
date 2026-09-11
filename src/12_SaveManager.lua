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
				local value = object.Value
				-- [ จุดที่แก้ ] โหมด Multi เก็บ Value เป็น dict ภายใน {opt = true}
				-- ถ้า save ตรงๆ ตอนโหลดกลับมาจะพังเพราะ SetValue คาดหวัง list ไม่ใช่ dict
				-- เลยแปลงเป็น list ตามลำดับ Options เดิมก่อน save ให้ตรงกับ format ที่ Callback ใช้
				if object.IsMulti then
					local list = {}
					for _, opt in ipairs(object.Options or {}) do
						if object.Value[opt] then table.insert(list, opt) end
					end
					value = list
				end
				return { type = "RadioGroup", idx = idx, value = value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},

		Stepper = {
			Save = function(idx, object)
				return { type = "Stepper", idx = idx, value = object.Value }
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
			"InterfaceTheme", "TransparentToggle", "MenuKeybind"
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

		-- No section title/box here — this is meant to be dropped straight into the
		-- "Config" subtab, so a "Configuration" header would just repeat the subtab name.
		local section = tab
		section:AddInput("SaveManager_ConfigName",    { Title = "Config name" })

		section:AddDropdown("SaveManager_ConfigList", { Title = "Config list", Values = self:RefreshConfigList(), AllowNull = true })

		-- ── แถวที่ 1: จัดการ Config Name ────────────────────────────────
		section:AddButtonGroup("SaveManager_NewConfig", {
			Title = "New config",
			Description = "Type a name above then create",
			Buttons = {
				{
					Text = "Create",
					Callback = function()
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
					end,
				},
			},
		})

		-- ── แถวที่ 2: Load / Save / Delete (ใช้ config ที่เลือกใน dropdown) ─
		section:AddButtonGroup("SaveManager_ConfigActions", {
			Title = "Actions",
			Description = "Select a config from the list first",
			Buttons = {
				{
					Text = "Load",
					Callback = function()
						local name = SaveManager.Options.SaveManager_ConfigList.Value
						local success, err = self:Load(name)
						if not success then
							return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Failed to load: " .. err, Duration = 7 })
						end
						self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("Loaded %q", name), Duration = 5 })
					end,
				},
				{
					Text = "Save",
					Callback = function()
						local name = SaveManager.Options.SaveManager_ConfigList.Value
						local success, err = self:Save(name)
						if not success then
							return self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Failed to save: " .. err, Duration = 7 })
						end
						self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = string.format("Saved %q", name), Duration = 5 })
					end,
				},
				{
					Text = "Delete",
					Callback = function()
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
					end,
				},
			},
		})

		-- ── แถวที่ 3: Autoload (ใช้ ActionButton เพื่อแสดงชื่อ config ปัจจุบัน + copy ได้) ──
		local AutoloadButton
		AutoloadButton = section:AddActionButton("SaveManager_AutoloadCopy", {
			Title       = "Set as autoload",
			Description = "Current autoload: none",
			CopyText    = "",
			ButtonText  = "Set ★",
			CopiedText  = "✓ Set!",
			ResetDelay  = 1.2,
			ButtonWidth  = 60,
			Callback = function(val)
				-- val จาก ActionButton คือ CopyText ซึ่งเราตั้งใหม่ทุกครั้งก่อน click
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
				{
					Text = "Refresh list",
					Callback = function()
						SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
						SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
					end,
				},
				{
					Text = "Clear autoload",
					Callback = function()
						writefile(self.Folder .. "/autoload.txt", "")
						AutoloadButton:SetDesc("Current autoload: none")
						self.Library:Notify({ Title = "Interface", Content = "Config loader", SubContent = "Autoload cleared", Duration = 5 })
					end,
				},
			},
		})

		-- แสดงชื่อ autoload ปัจจุบัน (ถ้ามี) + ตั้ง CopyText ของ ActionButton
		if isfile(self.Folder .. "/autoload.txt") then
			local name = (readfile(self.Folder .. "/autoload.txt") or ""):match("^%s*(.-)%s*$") or ""
			if name ~= "" then
				AutoloadButton:SetDesc("Current autoload: " .. name)
				AutoloadButton:SetCopyText(name)
			end
		end
		SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })

		-- Auto-load config หลัง UI พร้อม (delay เล็กน้อยให้ options ลงทะเบียนครบ)
		if not RunService:IsStudio() then
			task.delay(0.5, function()
				if isfile(self.Folder .. "/autoload.txt") then
					local name = (readfile(self.Folder .. "/autoload.txt") or ""):match("^%s*(.-)%s*$") or ""
					if name ~= "" then
						local success, err = self:Load(name)
						if success then
							self.Library:Notify({
								Title = "Interface",
								Content = "Config loader",
								SubContent = string.format('Auto loaded config "%s"', name),
								Duration = 7,
							})
						else
							self.Library:Notify({
								Title = "Interface",
								Content = "Config loader",
								SubContent = "Failed to auto load: " .. tostring(err),
								Duration = 7,
							})
						end
					end
				end
			end)
		end
	end
	if not RunService:IsStudio() then
		SaveManager:BuildFolderTree()
	end
end

