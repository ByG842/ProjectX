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

	New("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(100, 150, 255),
		Transparency = 0.6, Thickness = GetStyleProperty("BorderThickness") }),

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
		NewCorner("ElementCorner"),
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
	NewCorner("WindowCorner"),
	New("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
		},

		Rotation = 45,
	}),

	New("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(100, 150, 255),
		Transparency = 0.7, Thickness = GetStyleProperty("BorderThickness") }),

	New("Frame", {
		BackgroundColor3 = Color3.fromRGB(100, 150, 255),
		BackgroundTransparency = 0.92,
		Size = UDim2.new(1, -4, 1, -4),
		Position = UDim2.new(0, 2, 0, 2),
		BorderSizePixel = 0,
	}, {
		NewCorner("ElementCorner"),
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
		local currentMousePos = UserInputService:GetMouseLocation()
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
if RunService:IsStudio() then task.wait(0.01) end
return Library, SaveManager, InterfaceManager, Mobile
