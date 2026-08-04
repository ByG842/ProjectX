-- Components.lua
-- ขึ้นกับ: Creator.lua (และใช้ Library:GetIcon ที่มาจาก Icons.lua ตอน runtime)
-- เรียกใช้แบบ: local Components = loadstring(game:HttpGet(ComponentsURL))(Creator, Library, Mobile)

local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local fischbypass = false
if game.GameId == 5750914919 then
	fischbypass = true
end

local Creator, Library, Mobile = ...
assert(Creator, "Components.lua: ต้องส่ง Creator เข้ามาเป็นพารามิเตอร์ตัวแรก (จาก Creator.lua)")
assert(Library, "Components.lua: ต้องส่ง Library เข้ามาเป็นพารามิเตอร์ที่สอง (จาก Creator.lua)")

local Flipper = Creator.Flipper
local GetStyleProperty = Creator.GetStyleProperty
local NewCorner = Creator.NewCorner
local NewStroke = Creator.NewStroke
local viewportPointToWorld = Creator.ViewportPointToWorld
local getOffset = Creator.GetOffset

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

			NewCorner("WindowCorner"),

			New("Frame", {
				BackgroundTransparency = 0.45,
				Size = UDim2.fromScale(1, 1),
				Name = "Background",
				ThemeTag = {
					BackgroundColor3 = "AcrylicMain",
				},
			}, {
				NewCorner("WindowCorner"),
			}),

			New("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.4,
				Size = UDim2.fromScale(1, 1),
			}, {
				NewCorner("WindowCorner"),

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
				NewCorner("WindowCorner"),
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
				NewCorner("WindowCorner"),
			}),

			New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}, {
				NewCorner("WindowCorner"),
				New("UIStroke", {
					Transparency = 0.45,
					Thickness = GetStyleProperty("BorderThickness"),
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
			FontFace = GetStyleProperty("FontMedium"),
			Text = Title,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = GetStyleProperty("TextSizeMd"),
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
			TextSize = GetStyleProperty("TextSizeMd"),
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
			NewCorner("ElementCorner"),
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
			NewCorner("PillCorner"),
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
				TextSize = GetStyleProperty("TextSizeMd"),
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
			NewCorner("ElementCorner"),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 0.55,
				Thickness = GetStyleProperty("BorderThickness"),
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
			NewCorner("ElementCorner"),
			New("TextLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = not fischbypass and Icon and UDim2.new(0, 32, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
				Text = Title,
				RichText = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0,
				FontFace = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeSm"),
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
				NewCorner("SmallCorner"),
				New("UIStroke", {
					Transparency = 1,
					Thickness = GetStyleProperty("BorderThickness"),
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
					FontFace = GetStyleProperty("FontRegular"),
					TextSize = GetStyleProperty("TextSizeSm"),
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
			FontFace = GetStyleProperty("FontMedium"),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = GetStyleProperty("TextSizeMd"),
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
			NewCorner("ElementCorner"),
		})

		Button.Frame = New("TextButton", {
			Size = UDim2.new(0, 0, 0, 34),
			Parent = Parent,
			ThemeTag = {
				BackgroundColor3 = "DialogButton",
			},
		}, {
			NewCorner("ElementCorner"),
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
			NewCorner("ElementCorner"),
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
			FontFace = GetStyleProperty("FontSemiBold"),
			Text = "Dialog",
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = GetStyleProperty("TextSizeTitle"),
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
			NewCorner("WindowCorner"),
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

		local accentColor = TypeColors[Config.Type]
		if not accentColor then
			-- ไม่ใช่ type สี fixed (info/success/warning/error) → ใช้สี Accent ของธีมปัจจุบันแทน
			accentColor = Creator.GetThemeProperty("Accent") or TypeColors.default
		end
		local iconText    = Config.Icon or TypeIcons[Config.Type] or TypeIcons.default

		local NewNotification = { Closed = false }

		NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()

		-- 🖼️ AcrylicPaint มี ImageLabel เงา/glow แบบ soft-shadow (มุมมนมาในรูปเลย ไม่ใช่ UICorner)
		-- อยู่เบื้องหลัง panel เสมอ ต้องซ่อนตอนธีม Minecraft ไม่งั้นต่อให้มุม UICorner = 0 ก็จะยังดูมนอยู่ดี
		for _, child in ipairs(NewNotification.AcrylicPaint.Frame:GetChildren()) do
			if child:IsA("ImageLabel") and child.Image == "rbxassetid://8992230677" then
				NewNotification.MCShadowGlow = child
				break
			end
		end

		local TypeBar = New("Frame", {
			Size             = UDim2.new(0, 3, 1, -16),
			Position         = UDim2.new(0, 8, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundColor3 = accentColor,
			BorderSizePixel  = 0,
		}, {
			NewCorner("PillCorner"),
		})

		-- 🌑 Plaque มืดโปร่งแสงระหว่างเท็กซ์เจอร์กับตัวหนังสือ (สไตล์กล่อง GUI ของ Minecraft) กันตัวหนังสืออ่านยาก
		NewNotification.MCTextPlaqueCorner = NewCorner("WindowCorner")
		NewNotification.MCTextPlaque = New("Frame", {
			Size                    = UDim2.new(1, 0, 1, 0),
			BackgroundColor3        = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency  = 0.42,
			BorderSizePixel         = 0,
			Visible                 = (Library.Theme == "Minecraft"),
			_NoStyleRegister        = true,
		}, {
			NewNotification.MCTextPlaqueCorner,
		})

		local IconLabel = New("TextLabel", {
			Text             = iconText,
			FontFace         = GetStyleProperty("FontMedium"),
			TextSize = GetStyleProperty("TextSizeIcon"),
			Size             = UDim2.fromOffset(28, 28),
			Position         = UDim2.new(0, 18, 0, 10),
			BackgroundTransparency = 1,
			TextXAlignment   = Enum.TextXAlignment.Center,
			TextYAlignment   = Enum.TextYAlignment.Center,
			RichText         = false,
			_SizeKey         = "TextSizeIcon",
			_FontKey         = "FontMedium",
		})

		NewNotification.Title = New("TextLabel", {
			Position         = UDim2.new(0, 52, 0, 10),
			Text             = Config.Title,
			RichText         = true,
			TextSize = GetStyleProperty("TextSizeMd"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			TextYAlignment   = Enum.TextYAlignment.Center,
			Size             = UDim2.new(1, -80, 0, 16),
			TextWrapped      = true,
			BackgroundTransparency = 1,
			FontFace         = GetStyleProperty("FontBold"),
			TextColor3       = accentColor,
			_SizeKey         = "TextSizeMd",
			_FontKey         = "FontBold",
		})

		NewNotification.ContentLabel = New("TextLabel", {
			FontFace         = GetStyleProperty("FontMedium"),
			Text             = Config.Content,
			TextSize = GetStyleProperty("TextSizeSm"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			AutomaticSize    = Enum.AutomaticSize.Y,
			Size             = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextWrapped      = true,
			ThemeTag         = { TextColor3 = "Text" },
			_SizeKey         = "TextSizeSm",
			_FontKey         = "FontMedium",
		})

		NewNotification.SubContentLabel = New("TextLabel", {
			FontFace         = GetStyleProperty("FontMedium"),
			Text             = Config.SubContent,
			TextSize = GetStyleProperty("TextSizeXs"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			AutomaticSize    = Enum.AutomaticSize.Y,
			Size             = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextWrapped      = true,
			ThemeTag         = { TextColor3 = "SubText" },
			_SizeKey         = "TextSizeXs",
			_FontKey         = "FontMedium",
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
			NewCorner("PillCorner"),
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
			NewCorner("PillCorner"),
		})

		local ProgressFill = New("Frame", {
			Size             = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = accentColor,
			BorderSizePixel  = 0,
			Parent           = ProgressTrack,
		}, {
			NewCorner("PillCorner"),
		})

		-- 🧱 Minecraft texture — เท็กซ์เจอร์ dirt/stone ตัวเดียวกับพื้นหลังวินโดว์ ปูซ้ำ (tile) ให้ดูเป็นพิกเซล
		-- แสดงเฉพาะตอนธีมปัจจุบันเป็น Minecraft เท่านั้น ส่วนตอนสลับธีมจะถูกอัปเดตใน Library:SetTheme
		NewNotification.MCTextureCorner = NewCorner("WindowCorner")
		NewNotification.MCTexture = New("ImageLabel", {
			Image                  = "rbxassetid://127892835920326",
			ScaleType               = Enum.ScaleType.Tile,
			TileSize                = UDim2.new(0, 48, 1, 0), -- ปูซ้ำแค่แนวนอน แนวตั้งยืดเต็มพอดี 1 ชุด กันหญ้า/ดินซ้อนกันหลายแถบ
			Size                    = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency  = 1,
			ImageTransparency       = 0.12,
			ClipsDescendants        = true,
			Visible                 = (Library.Theme == "Minecraft"),
			_NoStyleRegister        = true,
		}, {
			NewNotification.MCTextureCorner,
		})

		-- 🖼️ Pixel bevel — กรอบเหลี่ยมชั้นในสีอ่อน ให้ดูเป็นแผงกระดาน Minecraft (นอกดำ/ในสว่าง)
		NewNotification.MCBevelStroke = New("UIStroke", {
			ApplyStrokeMode  = Enum.ApplyStrokeMode.Border,
			Color            = Color3.fromRGB(255, 255, 255),
			Transparency     = 0.78,
			Thickness        = 1,
			LineJoinMode     = Enum.LineJoinMode.Miter,
			_NoStyleRegister = true,
		})
		NewNotification.MCBevel = New("Frame", {
			Size                    = UDim2.new(1, -6, 1, -6),
			Position                = UDim2.fromOffset(3, 3),
			BackgroundTransparency  = 1,
			BorderSizePixel         = 0,
			Visible                 = (Library.Theme == "Minecraft"),
			_NoStyleRegister        = true,
		}, {
			NewNotification.MCBevelStroke,
		})

		NewNotification.BackgroundCorner = NewCorner("WindowCorner")
		local BackgroundFrame = New("Frame", {
			Size             = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 0.90,
			BorderSizePixel  = 0,
			ThemeTag         = { BackgroundColor3 = "AcrylicMain" },
		}, {
			NewNotification.BackgroundCorner,
		})

		NewNotification.RootStroke = New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = accentColor, Thickness = GetStyleProperty("BorderThickness"), LineJoinMode = Enum.LineJoinMode.Round })

		NewNotification.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, 0, 1, 0),
			Position         = UDim2.fromScale(1, 0),
		}, {
			NewNotification.AcrylicPaint.Frame,
			BackgroundFrame,
			NewNotification.MCTexture,
			-- Border
			NewNotification.RootStroke,
			NewNotification.MCBevel,
			NewNotification.MCTextPlaque,
			TypeBar,
			IconLabel,
			NewNotification.Title,
			NewNotification.CloseButton,
			NewNotification.LabelHolder,
			ProgressTrack,
		})

		-- เก็บ ref ตัวหนังสือทั้งหมดไว้ให้ RefreshStyle บังคับ sync ฟอนต์/ขนาดตรงๆ ไม่พึ่ง timing ของ StyleRegistry
		NewNotification.TextRefs = {
			{ obj = IconLabel,                          sizeKey = "TextSizeIcon", fontKey = "FontMedium" },
			{ obj = NewNotification.Title,               sizeKey = "TextSizeMd",   fontKey = "FontBold"   },
			{ obj = NewNotification.ContentLabel,        sizeKey = "TextSizeSm",   fontKey = "FontMedium" },
			{ obj = NewNotification.SubContentLabel,     sizeKey = "TextSizeXs",   fontKey = "FontMedium" },
		}

		-- 🔄 บังคับ sync เท็กซ์เจอร์ / มุมเหลี่ยม / ฟอนต์ / เงา ให้ตรงธีมปัจจุบันเสมอ ไม่ว่าจะเรียกตอนไหนก็ตาม
		function NewNotification:RefreshStyle()
			local isMinecraft = (Library.Theme == "Minecraft")

			if NewNotification.MCTexture then NewNotification.MCTexture.Visible = isMinecraft end
			if NewNotification.MCBevel then NewNotification.MCBevel.Visible = isMinecraft end
			if NewNotification.MCTextPlaque then NewNotification.MCTextPlaque.Visible = isMinecraft end
			if NewNotification.MCShadowGlow then NewNotification.MCShadowGlow.Visible = not isMinecraft end

			if NewNotification.BackgroundCorner then
				NewNotification.BackgroundCorner.CornerRadius = GetStyleProperty("WindowCorner")
			end
			if NewNotification.MCTextureCorner then
				NewNotification.MCTextureCorner.CornerRadius = GetStyleProperty("WindowCorner")
			end
			if NewNotification.MCTextPlaqueCorner then
				NewNotification.MCTextPlaqueCorner.CornerRadius = GetStyleProperty("WindowCorner")
			end
			if NewNotification.RootStroke then
				NewNotification.RootStroke.Thickness = GetStyleProperty("BorderThickness")
				-- UIStroke ปัดมุมกลมของตัวเองเสมอ (ไม่สนใจ UICorner) ต้องบังคับ Miter ตอนธีมเหลี่ยม
				NewNotification.RootStroke.LineJoinMode = isMinecraft and Enum.LineJoinMode.Miter or Enum.LineJoinMode.Round
			end
			if NewNotification.MCBevelStroke then
				NewNotification.MCBevelStroke.LineJoinMode = Enum.LineJoinMode.Miter
			end

			for _, entry in ipairs(NewNotification.TextRefs) do
				if entry.obj then
					entry.obj.TextSize = GetStyleProperty(entry.sizeKey)
					entry.obj.FontFace = GetStyleProperty(entry.fontKey)
				end
			end
		end

		NewNotification:RefreshStyle()

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
			NewNotification:RefreshStyle()

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
			FontFace = GetStyleProperty("FontRegular"),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = GetStyleProperty("TextSizeMd"),
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
			NewCorner("ElementCorner"),
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
				NewCorner("ElementCorner"),
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
					NewCorner("TinyCorner"), -- 📉 ปรับความโค้งจาก 8 เหลือ 4 (โค้งแค่มุมนิดๆ)
					
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
						NewCorner("TinyCorner") 
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
						FontFace = GetStyleProperty("FontBold"),
						TextSize = GetStyleProperty("TextSizeMd"),
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
						FontFace = GetStyleProperty("FontRegular"),
						TextSize = GetStyleProperty("TextSizeXs"),
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
				NewCorner("ElementCorner"),
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
		-- ✅ Icon = true ให้ใช้โลโก้เริ่มต้นของไลบรารี่แทนการใส่ rbxassetid เอง
		if Config.Icon == true then
			Config.Icon = Creator.LibraryLogo
		end

		local Window = {
			Minimized = false,
			Maximized = false,
			Size = Config.Size,
			CurrentPos = 0,
			TabWidth = 0,
			Position = UDim2.fromOffset(0, 0),
			DropdownsOutsideWindow = Config.DropdownsOutsideWindow == true,
			ManagedBackgroundImage = Config.ManagedBackgroundImage == true,
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
			NewCorner("ElementCorner"),
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
			NewCorner("SmallCorner"),
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
			NewCorner("TinyCorner"),
		})

		local SearchInput = New("TextBox", {
			FontFace = GetStyleProperty("FontMedium"),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = GetStyleProperty("TextSizeMd"),
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
			TextSize = GetStyleProperty("TextSizeTitle"),
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
			local isTiledBG = Config.BackgroundImageTile == true
			local BackgroundImageFrame = New("ImageLabel", {
				Name = "BackgroundImage",
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 1,
				Image = Config.BackgroundImage,
				ImageTransparency = math.max(0, math.min(1, backgroundImageTransparency)),
				ZIndex = 0,
				ScaleType = isTiledBG and Enum.ScaleType.Tile or Enum.ScaleType.Stretch,
				TileSize = isTiledBG and (Config.BackgroundImageTileSize or UDim2.fromOffset(64, 64)) or nil,
			}, {
				NewCorner("ElementCorner"),
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
				NewCorner("PillCorner"),
				New("UIStroke", { Transparency = 0.7, Thickness = GetStyleProperty("BorderThickness"), ThemeTag = { Color = "ElementBorder" } }),
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
				FontFace = GetStyleProperty("FontMedium"),
				TextSize = GetStyleProperty("TextSizeMd"),
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
				FontFace = GetStyleProperty("FontRegular"),
				TextSize = GetStyleProperty("TextSizeSm"),
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
				-- ✅ FIX: คำนวณ delta จาก frame ก่อนหน้า ไม่ใช่จาก ResizePos เดิม
				-- ป้องกัน delta สะสม ทำให้ resize กระโดดตอน drag เร็ว
				local Delta = Input.Position - ResizePos
				ResizePos = Input.Position -- อัปเดตทุก frame

				local currentW = SizeMotor:getValue().X
				local currentH = SizeMotor:getValue().Y

				local TargetSizeClamped = Vector2.new(
					math.clamp(currentW + Delta.X, 470, 2048),
					math.clamp(currentH + Delta.Y, 380, 2048)
				)

				SizeMotor:setGoal({
					X = Flipper.Instant.new(TargetSizeClamped.X),
					Y = Flipper.Instant.new(TargetSizeClamped.Y),
				})

				-- ✅ sync Window.Size แบบ live เพื่อให้ layout อื่นๆ ที่อ้าง Window.Size ถูกต้อง
				Window.Size = UDim2.fromOffset(TargetSizeClamped.X, TargetSizeClamped.Y)
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
					NewCorner("ElementCorner"),
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
				FontFace = GetStyleProperty("FontMedium"),
				Text = Config.Content,
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextSize = GetStyleProperty("TextSizeLg"),
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

Components.Creator = Creator
Components.Acrylic = Acrylic

return Components
