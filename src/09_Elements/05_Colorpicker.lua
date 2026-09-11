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
			NewCorner("TinyCorner"),
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
			NewCorner("TinyCorner"),
			DisplayFrameColor,
		})

		local function CreateColorDialog()
			local Dialog = Components.Dialog:Create()
			Dialog.Title.Text = Colorpicker.Title
			Dialog.Root.Size = UDim2.fromOffset(460, 460)
			local CHECKER_IMG = "http://www.roblox.com/asset/?id=14204231522"
			local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
			local Transparency = Colorpicker.Transparency
			local StartColor, StartTransparency = Colorpicker.Value, Colorpicker.Transparency

			-- ✨ NEW LAYOUT — grid-based, spacious, easier to read at a glance
			local ROOT_W, ROOT_H = 460, 460
			local MAP_X, MAP_Y, MAP_SIZE = 20, 130, 190
			local SLIDER_W, SLIDER_GAP = 16, 14
			local HUE_X = MAP_X + MAP_SIZE + SLIDER_GAP
			local ALPHA_X = HUE_X + SLIDER_W + SLIDER_GAP
			local INPUTS_X = (Config.Transparency and (ALPHA_X + SLIDER_W + SLIDER_GAP))
				or (HUE_X + SLIDER_W + SLIDER_GAP)
			local INPUTS_W = ROOT_W - 20 - INPUTS_X
			local function CreateInput()
				local Box = Components.Textbox()
				Box.Frame.Parent = Dialog.Root
				Box.Frame.Size = UDim2.new(0, 90, 0, 32)
				return Box
			end
			local function Caption(Text, Pos, Width)
				return New("TextLabel", {
					FontFace = GetStyleProperty("FontSemiBold"),
					Text = string.upper(Text),
					TextColor3 = Color3.fromRGB(150, 150, 150),
					TextSize = GetStyleProperty("TextSizeXs"),
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(0, Width or 190, 0, 14),
					Position = Pos,
					BackgroundTransparency = 1,
					Parent = Dialog.Root,
					ThemeTag = {
						TextColor3 = "SubText",
					},
				})
			end

			-- Rounded swatch with a checker backing so transparency is always visible
			local function MakeSwatch(X, Y, W, H, Color, Trans, Corner)
				local ColorFrame = New("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Color,
					BackgroundTransparency = Trans,
				}, {
					NewCorner(Corner or "SmallCorner"),
				})

				local Holder = New("ImageLabel", {
					Image = CHECKER_IMG,
					ImageTransparency = 0.45,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(40, 40),
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(W, H),
					Position = UDim2.fromOffset(X, Y),
					Parent = Dialog.Root,
				}, {
					NewCorner(Corner or "SmallCorner"),
					New("UIStroke", { Transparency = 0.55, ThemeTag = { Color = "DialogBorder" } }),
					ColorFrame,
				})

				return Holder, ColorFrame
			end
			local function GetRGB()
				local Value = Color3.fromHSV(Hue, Sat, Vib)
				return {
					R = math.floor(Value.r * 255 + 0.5),
					G = math.floor(Value.g * 255 + 0.5),
					B = math.floor(Value.b * 255 + 0.5),
				}
			end

			-- ===== Current vs New preview, side by side up top =====
			Caption("Current", UDim2.fromOffset(MAP_X, 58))
			Caption("New", UDim2.fromOffset(MAP_X + 210, 58))
			local _, CurrentColorFrame = MakeSwatch(MAP_X, 74, 190, 42, StartColor, StartTransparency)
			local _, NewColorFrame = MakeSwatch(MAP_X + 210, 74, 190, 42, Color3.fromHSV(Hue, Sat, Vib), Transparency)

			-- ===== Saturation / Value map =====
			local SatCursor = New("ImageLabel", {
				Size = UDim2.fromOffset(20, 20),
				ScaleType = Enum.ScaleType.Fit,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=4805639000",
				ZIndex = 3,
			})

			local SatVibMap = New("ImageLabel", {
				Size = UDim2.fromOffset(MAP_SIZE, MAP_SIZE),
				Position = UDim2.fromOffset(MAP_X, MAP_Y),
				Image = "rbxassetid://4155801252",
				BackgroundColor3 = Colorpicker.Value,
				BackgroundTransparency = 0,
				Parent = Dialog.Root,
			}, {
				NewCorner("SmallCorner"),
				New("UIStroke", { Transparency = 0.55, ThemeTag = { Color = "DialogBorder" } }),
				SatCursor,
			})

			-- ===== Hue slider =====
			local SequenceTable = {}
			for Color = 0, 1, 0.1 do
				table.insert(SequenceTable, ColorSequenceKeypoint.new(Color, Color3.fromHSV(Color, 1, 1)))
			end
			local HueSliderGradient = New("UIGradient", {
				Color = ColorSequence.new(SequenceTable),
				Rotation = 90,
			})

			local HueDragHolder = New("Frame", {
				Size = UDim2.new(1, 0, 1, -16),
				Position = UDim2.fromOffset(0, 8),
				BackgroundTransparency = 1,
			})

			local HueDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(16, 16),
				Image = "http://www.roblox.com/asset/?id=12266946128",
				Parent = HueDragHolder,
				ThemeTag = {
					ImageColor3 = "DialogInput",
				},
			})

			local HueSlider = New("Frame", {
				Size = UDim2.fromOffset(SLIDER_W, MAP_SIZE),
				Position = UDim2.fromOffset(HUE_X, MAP_Y),
				Parent = Dialog.Root,
			}, {
				NewCorner("PillCorner"),
				New("UIStroke", { Transparency = 0.6, ThemeTag = { Color = "DialogBorder" } }),
				HueSliderGradient,
				HueDragHolder,
			})

			-- ===== Alpha slider (only when the picker supports transparency) =====
			local TransparencySlider, TransparencyDrag, TransparencyColor
			if Config.Transparency then
				local TransparencyDragHolder = New("Frame", {
					Size = UDim2.new(1, 0, 1, -16),
					Position = UDim2.fromOffset(0, 8),
					BackgroundTransparency = 1,
				})

				TransparencyDrag = New("ImageLabel", {
					Size = UDim2.fromOffset(16, 16),
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
					NewCorner("PillCorner"),
				})

				TransparencySlider = New("Frame", {
					Size = UDim2.fromOffset(SLIDER_W, MAP_SIZE),
					Position = UDim2.fromOffset(ALPHA_X, MAP_Y),
					Parent = Dialog.Root,
					BackgroundTransparency = 1,
				}, {
					NewCorner("PillCorner"),
					New("UIStroke", { Transparency = 0.6, ThemeTag = { Color = "DialogBorder" } }),
					New("ImageLabel", {
						Image = CHECKER_IMG,
						ImageTransparency = 0.45,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = UDim2.fromOffset(40, 40),
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
					}, {
						NewCorner("PillCorner"),
					}),
					TransparencyColor,
					TransparencyDragHolder,
				})
			end

			-- ===== Hex / RGB / Alpha inputs, grouped with small caption labels =====
			Caption("Hex", UDim2.fromOffset(INPUTS_X, MAP_Y))
			local HexInput = CreateInput()
			HexInput.Frame.Size = UDim2.new(0, INPUTS_W, 0, 32)
			HexInput.Frame.Position = UDim2.fromOffset(INPUTS_X, MAP_Y + 16)
			Caption("R                    G                    B", UDim2.fromOffset(INPUTS_X, MAP_Y + 56))
			local RGB_GAP = 8
			local RGB_W = (INPUTS_W - RGB_GAP * 2) / 3
			local RedInput = CreateInput()
			RedInput.Frame.Size = UDim2.new(0, RGB_W, 0, 32)
			RedInput.Frame.Position = UDim2.fromOffset(INPUTS_X, MAP_Y + 72)
			local GreenInput = CreateInput()
			GreenInput.Frame.Size = UDim2.new(0, RGB_W, 0, 32)
			GreenInput.Frame.Position = UDim2.fromOffset(INPUTS_X + RGB_W + RGB_GAP, MAP_Y + 72)
			local BlueInput = CreateInput()
			BlueInput.Frame.Size = UDim2.new(0, RGB_W, 0, 32)
			BlueInput.Frame.Position = UDim2.fromOffset(INPUTS_X + (RGB_W + RGB_GAP) * 2, MAP_Y + 72)
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

			-- ===== Quick-pick preset swatches, pill-shaped for a friendlier feel =====
			local PRESETS = {
				Color3.fromRGB(255, 255, 255),
				Color3.fromRGB(0, 0, 0),
				Color3.fromRGB(255, 70, 70),
				Color3.fromRGB(255, 150, 60),
				Color3.fromRGB(255, 225, 70),
				Color3.fromRGB(90, 220, 120),
				Color3.fromRGB(70, 190, 255),
				Color3.fromRGB(90, 120, 255),
				Color3.fromRGB(180, 110, 255),
				Color3.fromRGB(255, 110, 190),
			}

			Caption("Presets", UDim2.fromOffset(MAP_X, MAP_Y + MAP_SIZE + 16))
			local PresetHolder = New("Frame", {
				Size = UDim2.new(1, -40, 0, 28),
				Position = UDim2.fromOffset(MAP_X, MAP_Y + MAP_SIZE + 32),
				BackgroundTransparency = 1,
				Parent = Dialog.Root,
			}, {
				New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
			})

			for _, PresetColor in ipairs(PRESETS) do
				local Stroke = New("UIStroke", { Transparency = 0.5, ThemeTag = { Color = "DialogBorder" } })

				local Swatch = New("TextButton", {
					Text = "",
					Size = UDim2.fromOffset(28, 28),
					BackgroundColor3 = PresetColor,
					Parent = PresetHolder,
				}, {
					NewCorner("PillCorner"),
					Stroke,
				})

				Creator.AddSignal(Swatch.MouseEnter, function()
					Stroke.Transparency = 0
					Stroke.Thickness = 2
				end)
				Creator.AddSignal(Swatch.MouseLeave, function()
					Stroke.Transparency = 0.5
					Stroke.Thickness = GetStyleProperty("BorderThickness")
				end)
				Creator.AddSignal(Swatch.MouseButton1Click, function()
					Hue, Sat, Vib = Color3.toHSV(PresetColor)
					Display()
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
