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

		-- [ จุดที่แก้ ] ไอคอนคีย์บอร์ดนำหน้าปุ่ม บอกใบ้ทันทีว่านี่คือช่อง keybind ไม่ใช่ปุ่มธรรมดา
		local KeybindIcon = New("ImageLabel", {
			Image = Library:GetIcon("keyboard"),
			Size = UDim2.fromOffset(14, 14),
			BackgroundTransparency = 1,
			ImageTransparency = 0.35,
			ThemeTag = { ImageColor3 = "SubText" },
		})

		-- [ จุดที่แก้ ] เอา TextColor3/BackgroundColor3 hardcode ทิ้ง (บั๊กเดิม: ทับ ThemeTag จนไม่เปลี่ยนตามธีม)
		local KeybindDisplayLabel = New("TextLabel", {
			FontFace = GetStyleProperty("FontRegular"),
			Text = defaultKey,
			TextTransparency = (defaultKey == "None") and 0.45 or 0, -- [ จุดที่เพิ่ม ] "None" ให้จางแต่แรกเลย
			TextSize = GetStyleProperty("TextSizeMd"),
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(0, 0, 0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		-- [ จุดที่แก้ ] tag บอก Mode (Hold/Always) เล็กๆ จางๆ ให้รู้ทันทีว่าปุ่มนี้ทำงานแบบไหน
		-- โดยไม่ต้องเปิด config หรือถามใคร — [ จุดที่แก้ ] ไม่โชว์ตอน Toggle เพราะเป็นโหมด default
		-- อยู่แล้ว ใส่ไปก็รกเปล่าๆ โชว์เฉพาะ Hold/Always ที่คนอาจไม่รู้ว่าปุ่มทำงานต่างจากปกติ
		local KeybindModeTag = New("TextLabel", {
			FontFace = GetStyleProperty("FontRegular"),
			Text = "(" .. (Config.Mode or "Toggle") .. ")",
			Visible = (Config.Mode or "Toggle") ~= "Toggle",
			TextSize = GetStyleProperty("TextSizeXs"),
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(0, 0, 0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			TextTransparency = 0.45,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		-- [ จุดที่แก้ ] ปุ่มรีเซ็ตกลับเป็น "None" แบบเร็วๆ โผล่มาให้กดเฉพาะตอน hover และมีค่าตั้งไว้แล้ว
		-- ไม่ต้องมานั่งกด Backspace หรือหาปุ่มที่ไม่มีใครใช้เพื่อเคลียร์ค่า
		-- [ จุดที่แก้ ] เปลี่ยนสีไอคอนเป็นสีแดงตายตัว (ไม่ผูก ThemeTag) ให้ดูเป็นปุ่ม "ลบ/เคลียร์" ชัดเจน
		local KeybindResetBtn = New("ImageButton", {
			Image = Library:GetIcon("x"),
			Size = UDim2.fromOffset(12, 12),
			BackgroundTransparency = 1,
			ImageTransparency = 1, -- ซ่อนไว้ก่อน โผล่เฉพาะตอน hover
			ImageColor3 = Color3.fromRGB(235, 70, 70),
		})

		local KeybindRow = New("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
			}),
			KeybindIcon,
			KeybindDisplayLabel,
			KeybindModeTag,
			KeybindResetBtn,
		})

		local KeybindStroke = New("UIStroke", {
			Transparency = 0.45,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "InElementBorder",
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
			NewCorner("ElementCorner"),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),
			KeybindStroke,
			KeybindRow,
		})

		-- [ จุดที่เพิ่ม ] hover feedback ที่ของเดิมไม่มีเลย — ตอนนี้ hover แล้วพื้นหลัง/กรอบสว่างขึ้น
		-- ให้รู้สึกว่ากดได้ (affordance) แถมโผล่ปุ่ม reset (x) ให้กดตอน hover ด้วย
		-- [ จุดที่แก้ ] ใช้ local boolean เก็บ hover state เอง แทนการอิง GuiState ของ Instance โดยตรง
		-- (GuiState เป็น property ที่ใหม่กว่า และไม่แน่ใจว่ารองรับเหมือนกันทุก client/executor)
		local Hovering = false
		local _, SetKeybindBg     = Creator.SpringMotor(0.88, KeybindDisplayFrame, "BackgroundTransparency", true, false, { frequency = 8 })
		local _, SetKeybindStroke = Creator.SpringMotor(0.45, KeybindStroke, "Transparency", true, false, { frequency = 8 })
		local _, SetResetAlpha    = Creator.SpringMotor(1, KeybindResetBtn, "ImageTransparency", true, false, { frequency = 8 })
		local function RefreshResetVisibility(hovering)
			SetResetAlpha((hovering and Keybind.Value ~= "None") and 0.35 or 1)
		end
		Creator.AddSignal(KeybindDisplayFrame.MouseEnter, function()
			Hovering = true
			if not Picking then
				SetKeybindBg(0.8)
				SetKeybindStroke(0.15)
			end
			RefreshResetVisibility(true)
		end)
		Creator.AddSignal(KeybindDisplayFrame.MouseLeave, function()
			Hovering = false
			if not Picking then
				SetKeybindBg(0.88)
				SetKeybindStroke(0.45)
			end
			RefreshResetVisibility(false)
		end)
		Creator.AddSignal(KeybindResetBtn.MouseButton1Click, function()
			if Keybind.Value == "None" then return end
			Keybind:SetValue("None", Keybind.Mode)
			Library:SafeCallback(Keybind.ChangedCallback, "None")
			Library:SafeCallback(Keybind.Changed, "None")
		end)

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
			-- [ จุดที่เพิ่ม ] ค่า "None" ให้ตัวหนังสือจางลงหน่อย สื่อว่ายังไม่ได้ตั้งค่า
			KeybindDisplayLabel.TextTransparency = (Key == "None") and 0.45 or 0
			KeybindModeTag.Text = "(" .. tostring(Mode) .. ")"
			KeybindModeTag.Visible = tostring(Mode) ~= "Toggle" -- [ จุดที่เพิ่ม ] เผื่อมีคนเปลี่ยน Mode ทีหลังผ่าน SetValue
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
				-- [ จุดที่แก้ ] ของเดิมแค่เปลี่ยนข้อความเป็น "..." เฉยๆ ไม่ค่อยชัดว่ากำลังรออะไรอยู่
				-- ตอนนี้ไฮไลต์กรอบ/พื้นหลังเป็นสี Accent ให้เห็นชัดว่า "กำลังรอกดปุ่ม" อยู่จริงๆ
				KeybindDisplayLabel.Text = "Press a key..."
				KeybindDisplayLabel.TextTransparency = 0
				SetResetAlpha(1) -- ซ่อนปุ่ม reset ไว้ก่อนระหว่างกำลัง pick กันกดโดนพลาด
				Creator.OverrideTag(KeybindStroke, { Color = "Accent" })
				SetKeybindStroke(0.05)
				SetKeybindBg(0.75)
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
							KeybindDisplayLabel.TextTransparency = 0
							Keybind.Value = Key
							-- [ จุดที่แก้ ] คืนสีกรอบ/พื้นหลังกลับเป็นปกติ (เคารพว่าเมาส์ยังลอยอยู่ไหม โดยอิง
							-- local boolean ที่เก็บเอง แทน GuiState ของ Instance กันปัญหาความเข้ากันได้)
							Creator.OverrideTag(KeybindStroke, { Color = "InElementBorder" })
							SetKeybindStroke(Hovering and 0.15 or 0.45)
							SetKeybindBg(Hovering and 0.8 or 0.88)
							RefreshResetVisibility(Hovering)
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
