ElementsTable.ActionButton = (function()
	local Element = {}
	Element.__index = Element
	Element.__type = "ActionButton"
	function Element:New(Idx, Config)
		Config = Config or {}
		assert(Config.Title, "ActionButton - Missing Title")
		Config.CopyText  = Config.CopyText  or ""
		-- ข้อความบนปุ่มปรับแต่งได้
		local idleLabel    = Config.ButtonText        or "Copy"
		local copiedLabel  = Config.CopiedText        or "✓ Copied"
		local resetDelay   = Config.ResetDelay        or 1.5
		local btnWidth     = Config.ButtonWidth       or 68
		local btnHeight    = Config.ButtonHeight      or 26

		-- ── ยืนยันก่อนทำงาน (Confirm) ──────────────────────────────────
		-- Confirm         = true/false   -> เปิด/ปิดการยืนยันก่อนกดจริง (ค่าเริ่มต้น false)
		-- ConfirmTitle    = ชื่อหัวข้อของ Dialog
		-- ConfirmText     = ข้อความด้านใน เช่น "คุณต้องการขายสิ่งนี้หรือไม่?"
		-- ConfirmYesText  / ConfirmNoText  = ข้อความบนปุ่มยืนยัน/ยกเลิก
		-- ConfirmButtonText / CancelButtonText = ชื่อคีย์เดียวกัน (alias ให้เรียกแบบไหนก็ได้)
		-- OnConfirm(val)  / OnCancel(val) = callback เสริม แยกจาก Callback หลัก
		local confirmEnabled = Config.Confirm == true
		local confirmTitle   = Config.ConfirmTitle or "ยืนยันการทำงาน"
		local confirmText    = Config.ConfirmText or Config.ConfirmContent
			or ("คุณต้องการทำรายการ \"" .. tostring(Config.Title) .. "\" หรือไม่?")
		local confirmYesText = Config.ConfirmYesText or Config.ConfirmButtonText or "ยืนยัน"
		local confirmNoText  = Config.ConfirmNoText  or Config.CancelButtonText  or "ยกเลิก"
		local dialogBusy     = false -- กันไม่ให้เปิด Dialog ซ้อนกันตอนกดรัวๆ

		local CB = { Type = "ActionButton", Value = Config.CopyText }

		local CBFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config)
		CB.SetTitle  = CBFrame.SetTitle
		CB.SetDesc   = CBFrame.SetDesc
		CB.Visible   = CBFrame.Visible
		CB.Elements  = CBFrame

		-- ── ปุ่มเรียบ — แค่ข้อความ ไม่มีไอคอน ──────────────────────────
		local CopyBtn = New("TextButton", {
			Text                   = idleLabel,
			FontFace               = GetStyleProperty("FontMedium"),
			TextSize = GetStyleProperty("TextSizeSm"),
			Size                   = UDim2.fromOffset(btnWidth, btnHeight),
			Position               = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint            = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.85,
			AutoButtonColor        = false,
			Parent                 = CBFrame.Frame,
			ThemeTag               = { BackgroundColor3 = "Accent", TextColor3 = "Text" },
		}, {
			NewCorner("TinyCorner"),
			New("UIStroke", {
				Transparency    = 0.5,
				Thickness       = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag        = { Color = "Accent" },
			}),
		})

		-- hover / press spring
		local CopyMotor, SetCopyT = Creator.SpringMotor(0.85, CopyBtn, "BackgroundTransparency")
		Creator.AddSignal(CopyBtn.MouseEnter,       function() SetCopyT(0.72) end)
		Creator.AddSignal(CopyBtn.MouseLeave,       function() SetCopyT(0.85) end)
		Creator.AddSignal(CopyBtn.MouseButton1Down, function() SetCopyT(0.60) end)
		Creator.AddSignal(CopyBtn.MouseButton1Up,   function() SetCopyT(0.72) end)
		-- ── การทำงานจริงเมื่อกดยืนยันแล้ว (คัดลอก + ยิง Callback หลัก) ──────
		local function RunAction()
			pcall(function()
				if setclipboard then    setclipboard(CB.Value)
				elseif toclipboard then toclipboard(CB.Value) end
			end)
			-- feedback: เปลี่ยนข้อความชั่วคราว
			CopyBtn.Text = copiedLabel
			task.delay(resetDelay, function()
				if CopyBtn and CopyBtn.Parent then
					CopyBtn.Text = idleLabel
				end
			end)
			Library:SafeCallback(Config.Callback, CB.Value)
		end

		Creator.AddSignal(CopyBtn.MouseButton1Click, function()
			-- ไม่เปิดใช้ Confirm -> ทำงานทันทีเหมือนเดิม
			if not confirmEnabled then
				RunAction()
				return
			end

			if dialogBusy then return end
			dialogBusy = true

			-- ใช้ระบบ Dialog เดิมของไลบรารี (spring fade + scale สมูทอยู่แล้ว)
			if Library.Window and Library.Window.Dialog then
				Library.Window:Dialog({
					Title = confirmTitle,
					Content = confirmText,
					Buttons = {
						{
							Title = confirmYesText,
							Callback = function()
								dialogBusy = false
								RunAction()
								Library:SafeCallback(Config.OnConfirm, CB.Value)
							end,
						},
						{
							Title = confirmNoText,
							Callback = function()
								dialogBusy = false
								Library:SafeCallback(Config.OnCancel, CB.Value)
							end,
						},
					},
				})
			else
				-- เผื่อไม่มีระบบ Dialog ให้ทำงานตรงไปเลย (fallback กันพัง)
				dialogBusy = false
				RunAction()
			end
		end)

		-- ── API ─────────────────────────────────────────────────────────
		function CB:SetCopyText(t)  self.Value = t end
		function CB:SetButtonText(idle, copied)
			idleLabel   = idle   or idleLabel
			copiedLabel = copied or copiedLabel
			if CopyBtn and CopyBtn.Parent then CopyBtn.Text = idleLabel end
		end
		-- เปิด/ปิด และปรับข้อความของ Confirm ได้ภายหลังสร้างปุ่มแล้ว
		function CB:SetConfirm(enabled)
			confirmEnabled = enabled == true
		end
		function CB:SetConfirmText(title, text, yesText, noText)
			confirmTitle   = title   or confirmTitle
			confirmText    = text    or confirmText
			confirmYesText = yesText or confirmYesText
			confirmNoText  = noText  or confirmNoText
		end
		function CB:Destroy()
			CBFrame.Frame:Destroy()
			if Idx then Library.Options[Idx] = nil end
		end
		if Idx then Library.Options[Idx] = CB end
		return CB
	end
	return Element
end)()
