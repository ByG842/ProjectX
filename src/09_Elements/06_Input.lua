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
		-- [ จุดที่เพิ่ม ] เปิดให้ Components.Textbox setter ควบคุม stroke จากข้างนอกได้ ไว้ใช้ตอนรีเซ็ต
		-- หลัง flash แดง (เดิม flash เสร็จแล้ว transparency มันค้างอยู่ที่ 0.15 ตลอดไปจนกว่าจะโฟกัสใหม่)
		local Textbox = Components.Textbox(InputFrame.Frame, true)
		Textbox.Frame.Position = UDim2.new(1, -10, 0.5, 0)
		Textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
		Textbox.Frame.Size = UDim2.fromOffset(160, 32)
		Textbox.Input.Text = Config.Default or ""
		Textbox.Input.PlaceholderText = Config.Placeholder or ""
		local Box = Textbox.Input

		-- [ จุดที่เพิ่ม ] ปุ่มเคลียร์ข้อความ (×) โผล่ตอน hover ถ้ามีข้อความอยู่ กดแล้วเคลียร์รวดเดียว
		-- ไม่ต้องกด Backspace ไล่ทีละตัว — เพิ่มความ "ใช้ง่าย" ตามที่ขอ
		-- [ จุดที่แก้ ] เปลี่ยนสีไอคอนเป็นสีแดงตายตัวเหมือนปุ่มรีเซ็ตใน Keybind ให้ดูเป็นชุดเดียวกัน
		local ClearBtn = New("ImageButton", {
			Image = Library:GetIcon("x"),
			Size = UDim2.fromOffset(12, 12),
			Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			ImageTransparency = 1, -- ซ่อนไว้ก่อน
			ImageColor3 = Color3.fromRGB(235, 70, 70),
			Parent = Textbox.Frame,
		})
		Textbox.Container.Size = UDim2.new(1, -30, 1, 0) -- เผื่อพื้นที่ให้ปุ่ม × ด้านขวา ไม่ให้ตัวหนังสือทับ

		local _, SetClearAlpha = Creator.SpringMotor(1, ClearBtn, "ImageTransparency", true, false, { frequency = 8 })
		local function RefreshClearBtn(hovering)
			SetClearAlpha((hovering and Box.Text ~= "") and 0.35 or 1)
		end
		Creator.AddSignal(Textbox.Frame.MouseEnter, function() RefreshClearBtn(true) end)
		Creator.AddSignal(Textbox.Frame.MouseLeave, function() RefreshClearBtn(false) end)
		Creator.AddSignal(ClearBtn.MouseButton1Click, function()
			Input:SetValue("")
		end)

		-- ⚠️ Validation feedback: ขอบแดง + สั่นเบาๆ ตอนกรอกค่าไม่ถูก (เกิน MaxLength หรือไม่ใช่ตัวเลขตอน Numeric=true)
		local function FlashInvalid()
			task.spawn(function()
				local origPos = Textbox.Frame.Position
				local amplitudes = { 6, -5, 4, -3, 2, 0 }
				for _, amp in ipairs(amplitudes) do
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
					Creator.OverrideTag(Textbox.Stroke, { Color = "InElementBorder" })
					-- [ จุดที่แก้ ] บั๊กเดิม: transparency ค้างที่ 0.15 ตลอดไปถ้าไม่ไปโฟกัส/blur ใหม่อีกที
					-- ตอนนี้สั่งสปริงคืนค่ากลับ base ให้ตรงๆ เลย
					if Textbox.SetStrokeTransparency and Textbox.BaseStrokeTransparency then
						Textbox.SetStrokeTransparency(Textbox.BaseStrokeTransparency)
					end
				end
			end)
		end
		function Input:SetValue(Text)
			local wasInvalid = false
			if Config.MaxLength and #Text > Config.MaxLength then
				Text = Text:sub(1, Config.MaxLength)
				wasInvalid = true
			end
			if Input.Numeric then
				if (not tonumber(Text)) and Text:len() > 0 then
					Text = Input.Value
					wasInvalid = true
				end
			end
			if wasInvalid then
				FlashInvalid()
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
