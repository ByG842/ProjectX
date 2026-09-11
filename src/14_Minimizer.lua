function Library:CreateMinimizer(Config)
	Config = Config or {}
	if self.Minimizer and self.Minimizer.Parent then
		return self.Minimizer
	end
	local parentGui = Library.GUI or GUI
	if parentGui then parentGui.DisplayOrder = 1000 end
	local isMobile = Mobile and true or false
	local iconAsset = "rbxassetid://10734897102"
	if Config.Icon == true then
		iconAsset = Library.BrandLogo
	elseif type(Config.Icon) == "string" and Config.Icon ~= "" then
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
	-- [ จุดที่แก้ ] ตามที่ขอ กลับไปเป็นโลโก้ล้วนๆ ไม่มีพื้นหลัง/กรอบ/มุมมนอะไรเลยเหมือนเดิม
	-- (ตัด backdrop ที่เพิ่มไปรอบก่อนออกทั้งหมด)
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
	Library.MinimizerAutoShow = (Config.Visible ~= false)
	if isMobile then
		holder = New("Frame", {
			Name = "FluentMinimizer",
			Parent = parentGui,
			Size = Config.Size or UDim2.fromOffset(40, 40),
			Position = Config.Position or UDim2.new(0.45, 0, 0.025, 0),
			BackgroundTransparency = 1,
			ZIndex = 999999999,
			Visible = false, -- 🔘 ไม่โผล่ตั้งแต่แรก จะโผล่ตอนกดพับหน้าต่างเท่านั้น
		})
	else
		holder = New("Frame", {
			Name = "FluentMinimizer",
			Parent = parentGui,
			Size = Config.Size or UDim2.fromOffset(40, 40),
			Position = Config.Position or UDim2.new(0, 300, 0, 20),
			BackgroundTransparency = 1,
			ZIndex = 999999999,
			Visible = false, -- 🔘 ไม่โผล่ตั้งแต่แรก จะโผล่ตอนกดพับหน้าต่างเท่านั้น
		})
	end

	-- 🎬 UIScale สำหรับอนิเมชัน pop-in/pop-out ตอนปุ่มมินิโผล่/หาย
	local MinimizerScale = New("UIScale", { Scale = 0 })
	MinimizerScale.Parent = holder
	local MinimizerScaleMotor, SetMinimizerScale = Creator.SpringMotor(0, MinimizerScale, "Scale")
	local minimizerHideToken = 0
	function Library.SetMinimizerVisible(Visible, Animate)
		if not Library.MinimizerAutoShow then
			return -- ผู้ใช้ปิดปุ่มนี้ไว้ทั้งหมด (Config.Visible == false ตอนสร้าง)
		end
		if not holder or not holder.Parent then
			return
		end
		minimizerHideToken = minimizerHideToken + 1
		local myToken = minimizerHideToken
		if Visible then
			holder.Visible = true
			if Animate == false then
				MinimizerScale.Scale = 1
			else
				SetMinimizerScale(1)
			end
		else
			if Animate == false then
				holder.Visible = false
				MinimizerScale.Scale = 0
			else
				SetMinimizerScale(0)
				task.delay(0.22, function()
					if myToken == minimizerHideToken then
						holder.Visible = false
					end
				end)
			end
		end
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

