--[[
    RayfieldMac Interface Suite
    Rayfield (by Sirius) + FU Library (Extended Elements) — Merged & Redesigned
    Style: macOS / Maclib UI — Large, clean, frosted-glass panels

    New Window Design:
      • Bigger window (680 × 520 by default)
      • macOS-style traffic-light buttons (close · minimize · maximize)
      • Left sidebar tab navigation (icon + label, vertical)
      • Frosted / blurred dark background
      • Thin hairline borders, soft shadows
      • Smooth spring animations throughout

    All FU Elements added to Tab:
      CreateMiniBar, CreateSeparator, CreateAlert,
      CreateCheckbox, CreateRadioGroup, CreateNumberInput,
      CreateCopyButton, CreateQuickActions, CreateTimer,
      CreateButtonGroup, CreateDivider, CreateChip,
      CreateStatusIndicator, CreateCounterButton,
      CreateToggleGroup, CreateAccordion, CreateLiveLabel

    Original Rayfield Elements kept:
      CreateButton, CreateToggle, CreateSlider, CreateDropdown,
      CreateInput, CreateColorPicker, CreateSection,
      CreateLabel, CreateParagraph, CreateKeybind

    Usage example (identical to Rayfield):
        local Lib  = loadstring(game:HttpGet("<url>"))()
        local Win  = Lib:CreateWindow({ Name = "My Script" })
        local Tab  = Win:CreateTab("Main", 4483362458)
        Tab:CreateButton({ Name = "Do Thing", Callback = function() end })
        Tab:CreateToggle({ Name = "Speed Hack", CurrentValue = false, Callback = function(v) end })
        -- new elements:
        Tab:CreateCheckbox({ Name = "Auto Farm", Default = false, Callback = function(v) end })
        Tab:CreateMiniBar("HP", { Min=0, Max=100, Default=75 })
        Tab:CreateStatusIndicator("Connection", { Status="online" })
        Tab:CreateTimer("Uptime", {})
]]

-- ─── Services ────────────────────────────────────────────────────────────────
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local Players           = game:GetService("Players")
local CoreGui           = game:GetService("CoreGui")
local LocalPlayer       = Players.LocalPlayer

-- ─── Config ───────────────────────────────────────────────────────────────────
local RayfieldFolder          = "Rayfield"
local ConfigurationFolder     = RayfieldFolder .. "/Configurations"
local ConfigurationExtension  = ".rfld"
local NotificationDuration    = 6.5

-- ─── Library Table ───────────────────────────────────────────────────────────
local Library = { Flags = {}, Options = {} }

-- ─── macOS / Maclib Colour Palette ───────────────────────────────────────────
local Theme = {
    -- Window chrome
    WindowBg        = Color3.fromRGB(22, 22, 28),
    WindowBorder    = Color3.fromRGB(55, 55, 68),
    Sidebar         = Color3.fromRGB(17, 17, 22),
    SidebarBorder   = Color3.fromRGB(45, 45, 58),
    Topbar          = Color3.fromRGB(28, 28, 36),
    TopbarBorder    = Color3.fromRGB(50, 50, 64),
    Shadow          = Color3.fromRGB(0,  0,  0),

    -- Traffic lights
    Close           = Color3.fromRGB(255, 95,  86),
    Minimise        = Color3.fromRGB(255, 189, 46),
    Maximise        = Color3.fromRGB(39,  201, 63),

    -- Accent
    Accent          = Color3.fromRGB(100, 210, 255),
    AccentHover     = Color3.fromRGB(130, 225, 255),

    -- Elements
    ElementBg       = Color3.fromRGB(32, 32, 42),
    ElementBgHover  = Color3.fromRGB(40, 40, 52),
    ElementBorder   = Color3.fromRGB(55, 55, 70),

    -- Text
    Text            = Color3.fromRGB(235, 237, 248),
    SubText         = Color3.fromRGB(140, 144, 168),
    DisabledText    = Color3.fromRGB(90,  92, 108),

    -- Toggle
    ToggleOff       = Color3.fromRGB(65, 65, 80),
    ToggleOn        = Color3.fromRGB(100, 210, 255),

    -- Slider
    SliderRail      = Color3.fromRGB(55, 57, 72),
    SliderFill      = Color3.fromRGB(100, 210, 255),

    -- Input
    InputBg         = Color3.fromRGB(20, 20, 28),
    InputBorder     = Color3.fromRGB(60, 62, 78),
    InputFocusBorder= Color3.fromRGB(100, 210, 255),

    -- Notification
    NotifBg         = Color3.fromRGB(28, 28, 38),
    NotifBorder     = Color3.fromRGB(55, 55, 70),

    -- Section title
    SectionText     = Color3.fromRGB(100, 210, 255),

    -- Tab
    TabText         = Color3.fromRGB(140, 144, 168),
    TabTextSel      = Color3.fromRGB(235, 237, 248),
    TabSelBg        = Color3.fromRGB(36, 36, 48),
    TabSelBar       = Color3.fromRGB(100, 210, 255),
}

-- ─── Utility helpers ──────────────────────────────────────────────────────────
local function New(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() obj[k] = v end)
        end
    end
    for _, child in ipairs(children or {}) do
        if child then child.Parent = obj end
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Tween(inst, t, props)
    TweenService:Create(inst, TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function SafeCall(fn, ...)
    if type(fn) ~= "function" then return end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[RayfieldMac] callback error: " .. tostring(err)) end
end

local function MakeDraggable(handle, target)
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            mousePos  = input.Position
            framePos  = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(target, 0.1, { Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )})
        end
    end)
end

-- ─── ScreenGui ────────────────────────────────────────────────────────────────
local ScreenGui = New("ScreenGui", {
    Name            = "RayfieldMac",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    DisplayOrder    = 200,
})
if gethui then
    ScreenGui.Parent = gethui()
elseif CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- ─── Notification anchor ──────────────────────────────────────────────────────
local NotifAnchor = New("Frame", {
    Name                  = "Notifications",
    Size                  = UDim2.new(0, 320, 1, 0),
    Position              = UDim2.new(1, -330, 0, 0),
    BackgroundTransparency= 1,
    Parent                = ScreenGui,
}, { New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder,
         VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 8) }) })

-- ─── Notification function ────────────────────────────────────────────────────
function Library:Notify(cfg)
    task.spawn(function()
        local notif = New("Frame", {
            Size                  = UDim2.new(1, 0, 0, 0),
            AutomaticSize         = Enum.AutomaticSize.Y,
            BackgroundColor3      = Theme.NotifBg,
            BackgroundTransparency= 0.08,
            Parent                = NotifAnchor,
            ClipsDescendants      = true,
        }, {
            New("UICorner",  { CornerRadius = UDim.new(0, 12) }),
            New("UIStroke",  { Color = Theme.NotifBorder, Thickness = 1,
                               ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            New("UIPadding", { PaddingTop = UDim.new(0,12), PaddingBottom = UDim.new(0,12),
                               PaddingLeft = UDim.new(0,14), PaddingRight = UDim.new(0,14) }),
        })

        -- Accent bar
        New("Frame", {
            Size             = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = Theme.Accent,
            Parent           = notif,
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

        local holder = New("Frame", {
            Size              = UDim2.new(1, -16, 0, 0),
            AutomaticSize     = Enum.AutomaticSize.Y,
            Position          = UDim2.fromOffset(16, 0),
            BackgroundTransparency = 1,
            Parent            = notif,
        }, { New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }) })

        New("TextLabel", {
            Text              = cfg.Title or "Notification",
            FontFace          = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
            TextSize          = 14,
            TextColor3        = Theme.Text,
            TextXAlignment    = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size              = UDim2.new(1, 0, 0, 18),
            Parent            = holder,
            LayoutOrder       = 1,
        })
        New("TextLabel", {
            Text              = cfg.Content or "",
            FontFace          = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            TextSize          = 13,
            TextColor3        = Theme.SubText,
            TextWrapped       = true,
            TextXAlignment    = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size              = UDim2.new(1, 0, 0, 0),
            AutomaticSize     = Enum.AutomaticSize.Y,
            Parent            = holder,
            LayoutOrder       = 2,
        })

        notif.BackgroundTransparency = 1
        Tween(notif, 0.45, { BackgroundTransparency = 0.08 })
        task.wait(cfg.Duration or NotificationDuration)
        Tween(notif, 0.4, { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) })
        task.wait(0.45)
        notif:Destroy()
    end)
end

-- ─── Config save/load ────────────────────────────────────────────────────────
local CFileName, CEnabled = nil, false

local function PackColor(c)  return { R = c.R*255, G = c.G*255, B = c.B*255 } end
local function UnpackColor(t) return Color3.fromRGB(t.R, t.G, t.B) end

local function SaveConfiguration()
    if not CEnabled then return end
    local data = {}
    for i, v in pairs(Library.Flags) do
        if v.Type == "ColorPicker" then
            data[i] = PackColor(v.Color)
        else
            data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
        end
    end
    pcall(function()
        writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension,
                  HttpService:JSONEncode(data))
    end)
end

local function LoadConfigurationData(raw)
    local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok then return end
    for flag, val in pairs(data) do
        if Library.Flags[flag] then
            task.spawn(function()
                if Library.Flags[flag].Type == "ColorPicker" then
                    Library.Flags[flag]:Set(UnpackColor(val))
                else
                    Library.Flags[flag]:Set(val)
                end
            end)
        end
    end
end

-- ─── Helper: make a macOS-style element row ───────────────────────────────────
local function MakeElementRow(parent, title, desc)
    local row = New("Frame", {
        Size             = UDim2.new(1, -16, 0, 46),
        BackgroundColor3 = Theme.ElementBg,
        BackgroundTransparency = 0.15,
        Parent           = parent,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 10) }),
        New("UIStroke", { Color = Theme.ElementBorder, Thickness = 1,
                          ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
    })

    -- Title
    New("TextLabel", {
        Text           = title or "",
        FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
        TextSize       = 13,
        TextColor3     = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Size           = UDim2.new(0.6, -10, 0, 18),
        Position       = UDim2.fromOffset(14, desc and 6 or 14),
        Parent         = row,
    })

    if desc and desc ~= "" then
        New("TextLabel", {
            Text           = desc,
            FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            TextSize       = 11,
            TextColor3     = Theme.SubText,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size           = UDim2.new(0.6, -10, 0, 14),
            Position       = UDim2.fromOffset(14, 26),
            Parent         = row,
        })
    end

    -- hover
    row.MouseEnter:Connect(function()
        Tween(row, 0.18, { BackgroundColor3 = Theme.ElementBgHover })
    end)
    row.MouseLeave:Connect(function()
        Tween(row, 0.22, { BackgroundColor3 = Theme.ElementBg })
    end)

    return row
end

-- ─── CreateWindow ─────────────────────────────────────────────────────────────
function Library:CreateWindow(Settings)
    Settings = Settings or {}

    -- config saving
    pcall(function()
        if Settings.ConfigurationSaving then
            CFileName = Settings.ConfigurationSaving.FileName or tostring(game.PlaceId)
            CEnabled  = Settings.ConfigurationSaving.Enabled or false
            local folder = Settings.ConfigurationSaving.FolderName or ConfigurationFolder
            ConfigurationFolder = folder
            if CEnabled and not isfolder(folder) then makefolder(folder) end
        end
    end)

    -- ── Main window ──────────────────────────────────────────────────────────
    local WIN_W, WIN_H = 680, 520
    local SIDE_W = 185

    local MainFrame = New("Frame", {
        Name             = "MainFrame",
        Size             = UDim2.fromOffset(WIN_W, WIN_H),
        Position         = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
        BackgroundColor3 = Theme.WindowBg,
        ClipsDescendants = false,
        Parent           = ScreenGui,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 14) }),
        New("UIStroke", { Color = Theme.WindowBorder, Thickness = 1,
                          ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
    })

    -- soft drop shadow
    New("ImageLabel", {
        Name             = "Shadow",
        Size             = UDim2.new(1, 60, 1, 60),
        Position         = UDim2.new(0, -30, 0, -30),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://6014261993",
        ImageColor3      = Theme.Shadow,
        ImageTransparency= 0.5,
        ZIndex           = 0,
        Parent           = MainFrame,
        ScaleType        = Enum.ScaleType.Slice,
        SliceCenter      = Rect.new(49, 49, 450, 450),
    })

    -- ── Topbar ───────────────────────────────────────────────────────────────
    local Topbar = New("Frame", {
        Name             = "Topbar",
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.Topbar,
        Parent           = MainFrame,
        ZIndex           = 3,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 14) }),
    })
    -- hide bottom corners of topbar
    New("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        Position         = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = Theme.Topbar,
        Parent           = Topbar,
        ZIndex           = 2,
    })
    -- bottom border line
    New("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.TopbarBorder,
        Parent           = Topbar,
        ZIndex           = 3,
    })

    -- traffic lights
    local function TrafficLight(color, xOff)
        local btn = New("TextButton", {
            Size             = UDim2.fromOffset(13, 13),
            Position         = UDim2.new(0, xOff, 0.5, -6),
            BackgroundColor3 = color,
            Text             = "",
            ZIndex           = 4,
            Parent           = Topbar,
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        return btn
    end
    local BtnClose    = TrafficLight(Theme.Close,    14)
    local BtnMinimise = TrafficLight(Theme.Minimise, 32)
    local BtnMaximise = TrafficLight(Theme.Maximise, 50)

    -- Window title
    New("TextLabel", {
        Text          = Settings.Name or "RayfieldMac",
        FontFace      = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
        TextSize      = 14,
        TextColor3    = Theme.Text,
        BackgroundTransparency = 1,
        Size          = UDim2.new(1, -130, 1, 0),
        Position      = UDim2.fromOffset(0, 0),
        TextXAlignment= Enum.TextXAlignment.Center,
        ZIndex        = 4,
        Parent        = Topbar,
    })

    MakeDraggable(Topbar, MainFrame)

    -- ── Sidebar ──────────────────────────────────────────────────────────────
    local Sidebar = New("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, SIDE_W, 1, -44),
        Position         = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = Theme.Sidebar,
        Parent           = MainFrame,
        ZIndex           = 2,
        ClipsDescendants = true,
    })
    -- right border
    New("Frame", {
        Size             = UDim2.new(0, 1, 1, 0),
        Position         = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Theme.SidebarBorder,
        Parent           = Sidebar,
    })
    -- round bottom-left
    New("UICorner", { CornerRadius = UDim.new(0, 14), Parent = Sidebar })
    -- repair top corners
    New("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        BackgroundColor3 = Theme.Sidebar,
        Parent           = Sidebar,
    })

    local TabList = New("Frame", {
        Size              = UDim2.new(1, -16, 1, -16),
        Position          = UDim2.fromOffset(8, 8),
        BackgroundTransparency = 1,
        Parent            = Sidebar,
    }, {
        New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
    })

    -- ── Content area ─────────────────────────────────────────────────────────
    local ContentArea = New("Frame", {
        Name             = "ContentArea",
        Size             = UDim2.new(1, -SIDE_W, 1, -44),
        Position         = UDim2.new(0, SIDE_W, 0, 44),
        BackgroundTransparency = 1,
        Parent           = MainFrame,
        ClipsDescendants = true,
    })
    -- round bottom-right corner
    New("UICorner", { CornerRadius = UDim.new(0, 14), Parent = ContentArea })
    New("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        BackgroundColor3 = Theme.WindowBg,
        Parent           = ContentArea,
    })

    -- ── Window state ─────────────────────────────────────────────────────────
    local Hidden, Minimised, Debounce = false, false, false
    local TabPages    = {}
    local TabButtons  = {}
    local CurrentTab  = nil

    local function SelectTab(btn, page)
        for _, b in pairs(TabButtons) do
            Tween(b.Bar,   0.2, { BackgroundTransparency = 1 })
            Tween(b.Label, 0.2, { TextColor3 = Theme.TabText })
            Tween(b.Icon,  0.2, { ImageColor3 = Theme.TabText })
            Tween(b.Bg,    0.2, { BackgroundTransparency = 1 })
        end
        Tween(btn.Bar,   0.2, { BackgroundTransparency = 0 })
        Tween(btn.Label, 0.2, { TextColor3 = Theme.TabTextSel })
        Tween(btn.Icon,  0.2, { ImageColor3 = Theme.TabTextSel })
        Tween(btn.Bg,    0.2, { BackgroundTransparency = 0.85 })

        for _, p in pairs(TabPages) do p.Visible = false end
        page.Visible = true
        CurrentTab = page
    end

    -- ── Traffic light actions ─────────────────────────────────────────────────
    BtnClose.MouseButton1Click:Connect(function()
        Tween(MainFrame, 0.35, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 })
        task.wait(0.4)
        ScreenGui:Destroy()
    end)

    local minimised = false
    BtnMinimise.MouseButton1Click:Connect(function()
        if Debounce then return end
        Debounce = true
        minimised = not minimised
        if minimised then
            Tween(MainFrame, 0.4, { Size = UDim2.fromOffset(WIN_W, 44) })
            ContentArea.Visible = false
        else
            ContentArea.Visible = true
            Tween(MainFrame, 0.4, { Size = UDim2.fromOffset(WIN_W, WIN_H) })
        end
        task.wait(0.45)
        Debounce = false
    end)

    local maximised = false
    BtnMaximise.MouseButton1Click:Connect(function()
        if Debounce then return end
        Debounce = true
        maximised = not maximised
        local cam = workspace.CurrentCamera
        if maximised then
            Tween(MainFrame, 0.45, {
                Size     = UDim2.fromOffset(cam.ViewportSize.X - 40, cam.ViewportSize.Y - 40),
                Position = UDim2.new(0, 20, 0, 20),
            })
        else
            Tween(MainFrame, 0.45, {
                Size     = UDim2.fromOffset(WIN_W, WIN_H),
                Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
            })
        end
        task.wait(0.5)
        Debounce = false
    end)

    -- K to toggle hide
    UserInputService.InputBegan:Connect(function(input, proc)
        if proc then return end
        if input.KeyCode == Enum.KeyCode.K then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- ── Opening animation ─────────────────────────────────────────────────────
    MainFrame.BackgroundTransparency = 1
    MainFrame.Size = UDim2.fromOffset(WIN_W, 50)
    Tween(MainFrame, 0.5, {
        BackgroundTransparency = 0,
        Size = UDim2.fromOffset(WIN_W, WIN_H),
    })

    -- ── Window object ─────────────────────────────────────────────────────────
    local Window = {}

    function Window:Notify(cfg)
        Library:Notify(cfg)
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    -- ── CreateTab ─────────────────────────────────────────────────────────────
    function Window:CreateTab(name, imageId)
        -- Page scrolling frame
        local page = New("ScrollingFrame", {
            Name                = name,
            Size                = UDim2.new(1, -16, 1, -16),
            Position            = UDim2.fromOffset(8, 8),
            BackgroundTransparency = 1,
            ScrollBarThickness  = 4,
            ScrollBarImageColor3= Theme.Accent,
            CanvasSize          = UDim2.fromOffset(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible             = false,
            Parent              = ContentArea,
        }, {
            New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
            New("UIPadding",    { PaddingBottom = UDim.new(0, 8) }),
        })
        table.insert(TabPages, page)

        -- Sidebar button
        local tabBtn = New("TextButton", {
            Size             = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Text             = "",
            Parent           = TabList,
        })

        local tabBg = New("Frame", {
            Size             = UDim2.fromScale(1, 1),
            BackgroundColor3 = Theme.TabSelBg,
            BackgroundTransparency = 1,
            Parent           = tabBtn,
        }, { New("UICorner", { CornerRadius = UDim.new(0, 8) }) })

        local tabBar = New("Frame", {
            Size             = UDim2.new(0, 3, 0, 20),
            Position         = UDim2.new(0, 0, 0.5, -10),
            BackgroundColor3 = Theme.TabSelBar,
            BackgroundTransparency = 1,
            Parent           = tabBtn,
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

        local tabIcon = New("ImageLabel", {
            Size             = UDim2.fromOffset(18, 18),
            Position         = UDim2.new(0, 10, 0.5, -9),
            BackgroundTransparency = 1,
            Image            = imageId and ("rbxassetid://" .. tostring(imageId)) or "",
            ImageColor3      = Theme.TabText,
            Parent           = tabBtn,
        })

        local tabLabel = New("TextLabel", {
            Text             = name,
            FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
            TextSize         = 13,
            TextColor3       = Theme.TabText,
            TextXAlignment   = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size             = UDim2.new(1, -36, 1, 0),
            Position         = UDim2.fromOffset(34, 0),
            Parent           = tabBtn,
        })

        local btnRef = { Bar = tabBar, Label = tabLabel, Icon = tabIcon, Bg = tabBg }
        table.insert(TabButtons, btnRef)

        tabBtn.MouseButton1Click:Connect(function()
            SelectTab(btnRef, page)
        end)

        -- auto-select first tab
        if #TabPages == 1 then
            SelectTab(btnRef, page)
        end

        -- ──────────────────────────────────────────────────────────────────────
        -- Tab element methods
        -- ──────────────────────────────────────────────────────────────────────
        local Tab = {}

        -- ── Section ────────────────────────────────────────────────────────
        function Tab:CreateSection(sectionName)
            local firstSection = (#page:GetChildren() <= 2)
            if not firstSection then
                New("Frame", { Size = UDim2.new(1, 0, 0, 6), BackgroundTransparency = 1, Parent = page })
            end
            local lbl = New("TextLabel", {
                Text           = string.upper(sectionName or ""),
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize       = 10,
                TextColor3     = Theme.SectionText,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, -16, 0, 18),
                Parent         = page,
            })
            New("UIPadding", { PaddingLeft = UDim.new(0, 6), Parent = lbl })
            return { Set = function(_, t) lbl.Text = string.upper(t) end }
        end

        -- ── Label ──────────────────────────────────────────────────────────
        function Tab:CreateLabel(text)
            local row = MakeElementRow(page, text, nil)
            row.BackgroundColor3 = Theme.Sidebar
            return { Set = function(_, t)
                row:FindFirstChildWhichIsA("TextLabel").Text = t
            end }
        end

        -- ── Paragraph ──────────────────────────────────────────────────────
        function Tab:CreateParagraph(cfg)
            local frame = New("Frame", {
                Size             = UDim2.new(1, -16, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Sidebar,
                Parent           = page,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 10) }),
                New("UIStroke", { Color = Theme.ElementBorder, Thickness = 1,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                New("UIPadding", { PaddingTop = UDim.new(0,12), PaddingBottom = UDim.new(0,12),
                                   PaddingLeft = UDim.new(0,14), PaddingRight = UDim.new(0,14) }),
            })
            local titleLbl = New("TextLabel", {
                Text           = cfg.Title or "",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
                TextSize       = 13,
                TextColor3     = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 18),
                Parent         = frame,
            })
            local contentLbl = New("TextLabel", {
                Text           = cfg.Content or "",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextSize       = 12,
                TextColor3     = Theme.SubText,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped    = true,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 0),
                AutomaticSize  = Enum.AutomaticSize.Y,
                Parent         = frame,
            })
            return { Set = function(_, t) titleLbl.Text = t.Title contentLbl.Text = t.Content end }
        end

        -- ── Button ─────────────────────────────────────────────────────────
        function Tab:CreateButton(cfg)
            local row = MakeElementRow(page, cfg.Name, cfg.Description)
            -- arrow indicator
            New("TextLabel", {
                Text           = "›",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize       = 18,
                TextColor3     = Theme.Accent,
                BackgroundTransparency = 1,
                Size           = UDim2.fromOffset(20, 20),
                Position       = UDim2.new(1, -28, 0.5, -10),
                Parent         = row,
            })
            local interact = New("TextButton", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Text = "", Parent = row, ZIndex = 5,
            })
            interact.MouseButton1Click:Connect(function()
                Tween(row, 0.12, { BackgroundColor3 = Theme.AccentHover })
                task.wait(0.12)
                Tween(row, 0.2, { BackgroundColor3 = Theme.ElementBg })
                SafeCall(cfg.Callback)
                SaveConfiguration()
            end)
            return { Set = function(_, n)
                row:FindFirstChildWhichIsA("TextLabel").Text = n
            end }
        end

        -- ── Toggle ─────────────────────────────────────────────────────────
        function Tab:CreateToggle(cfg)
            cfg.Type = "Toggle"
            local val = cfg.CurrentValue or false

            local row = MakeElementRow(page, cfg.Name, cfg.Description)

            -- macOS-style pill switch
            local track = New("Frame", {
                Size             = UDim2.fromOffset(44, 24),
                Position         = UDim2.new(1, -54, 0.5, -12),
                BackgroundColor3 = val and Theme.ToggleOn or Theme.ToggleOff,
                Parent           = row,
            }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local knob = New("Frame", {
                Size             = UDim2.fromOffset(18, 18),
                Position         = val and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent           = track,
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIDropShadow", {}), -- pure visual
            })

            local interact = New("TextButton", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Text = "", Parent = row, ZIndex = 5,
            })

            local function setVisual(v)
                Tween(track, 0.22, { BackgroundColor3 = v and Theme.ToggleOn or Theme.ToggleOff })
                Tween(knob,  0.22, { Position = v and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3) })
            end
            setVisual(val)

            interact.MouseButton1Click:Connect(function()
                val = not val
                cfg.CurrentValue = val
                setVisual(val)
                SafeCall(cfg.Callback, val)
                SaveConfiguration()
            end)

            function cfg:Set(v)
                val = v; cfg.CurrentValue = v
                setVisual(v)
                SafeCall(cfg.Callback, v)
            end

            if cfg.Flag then Library.Flags[cfg.Flag] = cfg end
            return cfg
        end

        -- ── Slider ─────────────────────────────────────────────────────────
        function Tab:CreateSlider(cfg)
            cfg.Type = "Slider"
            local min, max = cfg.Range and cfg.Range[1] or 0, cfg.Range and cfg.Range[2] or 100
            local val = math.clamp(cfg.CurrentValue or min, min, max)

            local row = MakeElementRow(page, cfg.Name, cfg.Description)
            row.Size = UDim2.new(1, -16, 0, 62)

            local valLabel = New("TextLabel", {
                Text           = tostring(val) .. (cfg.Suffix or ""),
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                TextSize       = 12,
                TextColor3     = Theme.Accent,
                BackgroundTransparency = 1,
                Size           = UDim2.fromOffset(60, 16),
                Position       = UDim2.new(1, -70, 0, 10),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent         = row,
            })

            local rail = New("Frame", {
                Size             = UDim2.new(1, -28, 0, 5),
                Position         = UDim2.fromOffset(14, 42),
                BackgroundColor3 = Theme.SliderRail,
                Parent           = row,
            }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local fill = New("Frame", {
                Size             = UDim2.new((val - min)/(max - min), 0, 1, 0),
                BackgroundColor3 = Theme.SliderFill,
                Parent           = rail,
            }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local thumb = New("Frame", {
                Size             = UDim2.fromOffset(16, 16),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new((val-min)/(max-min), 0, 0.5, 0),
                BackgroundColor3 = Theme.Accent,
                Parent           = rail,
                ZIndex           = 5,
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIStroke", { Color = Color3.fromRGB(255,255,255),
                                  Thickness = 2,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            local dragging = false
            local interact = New("TextButton", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Text = "", Parent = row, ZIndex = 6,
            })
            interact.MouseButton1Down:Connect(function() dragging = true end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            local function updateFromX(absX)
                local relX  = math.clamp(absX - rail.AbsolutePosition.X, 0, rail.AbsoluteSize.X)
                local pct   = relX / rail.AbsoluteSize.X
                val         = math.floor(min + pct * (max - min) + 0.5)
                cfg.CurrentValue = val
                local fpct  = (val - min) / (max - min)
                Tween(fill,  0.1, { Size = UDim2.new(fpct, 0, 1, 0) })
                Tween(thumb, 0.1, { Position = UDim2.new(fpct, 0, 0.5, 0) })
                valLabel.Text = tostring(val) .. (cfg.Suffix or "")
                SafeCall(cfg.Callback, val)
                SaveConfiguration()
            end

            RunService.RenderStepped:Connect(function()
                if dragging then
                    updateFromX(UserInputService:GetMouseLocation().X)
                end
            end)

            function cfg:Set(v)
                val = math.clamp(v, min, max)
                cfg.CurrentValue = val
                local fpct = (val-min)/(max-min)
                Tween(fill,  0.15, { Size = UDim2.new(fpct, 0, 1, 0) })
                Tween(thumb, 0.15, { Position = UDim2.new(fpct, 0, 0.5, 0) })
                valLabel.Text = tostring(val) .. (cfg.Suffix or "")
            end

            if cfg.Flag then Library.Flags[cfg.Flag] = cfg end
            return cfg
        end

        -- ── Dropdown ───────────────────────────────────────────────────────
        function Tab:CreateDropdown(cfg)
            cfg.Type = "Dropdown"
            if type(cfg.CurrentOption) == "string" then cfg.CurrentOption = {cfg.CurrentOption} end
            cfg.CurrentOption = cfg.CurrentOption or {}

            local opened = false

            local row = MakeElementRow(page, cfg.Name, cfg.Description)

            local selLabel = New("TextLabel", {
                Text           = (#cfg.CurrentOption > 0) and cfg.CurrentOption[1] or "None",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextSize       = 12,
                TextColor3     = Theme.SubText,
                BackgroundTransparency = 1,
                Size           = UDim2.fromOffset(120, 16),
                Position       = UDim2.new(1, -134, 0.5, -8),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent         = row,
            })

            local arrow = New("TextLabel", {
                Text           = "⌄",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize       = 14,
                TextColor3     = Theme.SubText,
                BackgroundTransparency = 1,
                Size           = UDim2.fromOffset(16, 16),
                Position       = UDim2.new(1, -20, 0.5, -8),
                Parent         = row,
            })

            -- list
            local listFrame = New("ScrollingFrame", {
                Size                = UDim2.new(1, -16, 0, 0),
                Position            = UDim2.fromOffset(8, 0),
                BackgroundColor3    = Theme.InputBg,
                BackgroundTransparency = 0.05,
                ScrollBarThickness  = 3,
                ScrollBarImageColor3= Theme.Accent,
                CanvasSize          = UDim2.fromOffset(0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Visible             = false,
                ClipsDescendants    = true,
                Parent              = page,
                ZIndex              = 10,
            }, {
                New("UICorner",  { CornerRadius = UDim.new(0, 10) }),
                New("UIStroke",  { Color = Theme.ElementBorder, Thickness = 1,
                                   ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }),
                New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4) }),
            })

            for _, opt in ipairs(cfg.Options or {}) do
                local optBtn = New("TextButton", {
                    Size             = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Text             = opt,
                    FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    TextSize         = 13,
                    TextColor3       = table.find(cfg.CurrentOption, opt) and Theme.Accent or Theme.Text,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    Parent           = listFrame,
                    ZIndex           = 11,
                }, { New("UIPadding", { PaddingLeft = UDim.new(0, 12) }) })
                optBtn.MouseButton1Click:Connect(function()
                    if not cfg.MultipleOptions then
                        cfg.CurrentOption = {opt}
                        selLabel.Text = opt
                        -- close
                        opened = false
                        Tween(arrow, 0.2, { TextColor3 = Theme.SubText })
                        Tween(listFrame, 0.2, { Size = UDim2.new(1, -16, 0, 0) })
                        task.wait(0.22)
                        listFrame.Visible = false
                    else
                        local idx = table.find(cfg.CurrentOption, opt)
                        if idx then table.remove(cfg.CurrentOption, idx)
                        else table.insert(cfg.CurrentOption, opt) end
                        selLabel.Text = #cfg.CurrentOption == 0 and "None"
                            or #cfg.CurrentOption == 1 and cfg.CurrentOption[1]
                            or "Various"
                    end
                    -- recolor options
                    for _, c in ipairs(listFrame:GetChildren()) do
                        if c:IsA("TextButton") then
                            c.TextColor3 = table.find(cfg.CurrentOption, c.Text) and Theme.Accent or Theme.Text
                        end
                    end
                    SafeCall(cfg.Callback, cfg.CurrentOption)
                    SaveConfiguration()
                end)
            end

            local interact = New("TextButton", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Text = "", Parent = row, ZIndex = 5,
            })
            interact.MouseButton1Click:Connect(function()
                if Debounce then return end
                opened = not opened
                if opened then
                    listFrame.Visible = true
                    local items = math.min(#(cfg.Options or {}), 6)
                    Tween(listFrame, 0.25, { Size = UDim2.new(1, -16, 0, items * 34 + 8) })
                    Tween(arrow, 0.2, { TextColor3 = Theme.Accent })
                else
                    Tween(listFrame, 0.2, { Size = UDim2.new(1, -16, 0, 0) })
                    Tween(arrow, 0.2, { TextColor3 = Theme.SubText })
                    task.wait(0.22)
                    listFrame.Visible = false
                end
            end)

            function cfg:Set(v)
                if type(v) == "string" then v = {v} end
                cfg.CurrentOption = v
                selLabel.Text = #v == 0 and "None" or #v == 1 and v[1] or "Various"
            end

            if cfg.Flag then Library.Flags[cfg.Flag] = cfg end
            return cfg
        end

        -- ── Input ──────────────────────────────────────────────────────────
        function Tab:CreateInput(cfg)
            local row = MakeElementRow(page, cfg.Name, cfg.Description)

            local inputFrame = New("Frame", {
                Size             = UDim2.fromOffset(140, 28),
                Position         = UDim2.new(1, -150, 0.5, -14),
                BackgroundColor3 = Theme.InputBg,
                Parent           = row,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 7) }),
                New("UIStroke", { Color = Theme.InputBorder, Thickness = 1,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            local box = New("TextBox", {
                Size              = UDim2.new(1, -16, 1, 0),
                Position          = UDim2.fromOffset(8, 0),
                BackgroundTransparency = 1,
                FontFace          = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextSize          = 12,
                TextColor3        = Theme.Text,
                PlaceholderColor3 = Theme.SubText,
                PlaceholderText   = cfg.PlaceholderText or "",
                TextXAlignment    = Enum.TextXAlignment.Left,
                ClearTextOnFocus  = cfg.ClearTextOnFocus ~= false,
                Parent            = inputFrame,
            })

            local stroke = inputFrame:FindFirstChildOfClass("UIStroke")
            box.Focused:Connect(function()
                Tween(stroke, 0.18, { Color = Theme.InputFocusBorder })
            end)
            box.FocusLost:Connect(function()
                Tween(stroke, 0.18, { Color = Theme.InputBorder })
                SafeCall(cfg.Callback, box.Text)
                if cfg.RemoveTextAfterFocusLost then box.Text = "" end
                SaveConfiguration()
            end)

            local val = {}
            function val:Set(t) box.Text = t end
            return val
        end

        -- ── ColorPicker ────────────────────────────────────────────────────
        function Tab:CreateColorPicker(cfg)
            cfg.Type = "ColorPicker"
            local h, s, v = (cfg.Color or Color3.fromRGB(255,0,0)):ToHSV()

            local row = MakeElementRow(page, cfg.Name, cfg.Description)
            row.Size = UDim2.new(1, -16, 0, 46)

            local swatch = New("TextButton", {
                Size             = UDim2.fromOffset(36, 24),
                Position         = UDim2.new(1, -46, 0.5, -12),
                BackgroundColor3 = Color3.fromHSV(h, s, v),
                Text             = "",
                Parent           = row,
                ZIndex           = 5,
            }, {
                New("UICorner",  { CornerRadius = UDim.new(0, 6) }),
                New("UIStroke",  { Color = Theme.ElementBorder, Thickness = 1,
                                   ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            -- pop-up picker
            local picker = New("Frame", {
                Size             = UDim2.fromOffset(220, 140),
                Position         = UDim2.new(1, -230, 1, 6),
                BackgroundColor3 = Theme.InputBg,
                Visible          = false,
                Parent           = row,
                ZIndex           = 20,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 10) }),
                New("UIStroke", { Color = Theme.ElementBorder, Thickness = 1,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            -- SV canvas
            local canvas = New("ImageButton", {
                Size             = UDim2.new(1, -50, 1, -20),
                Position         = UDim2.fromOffset(8, 8),
                Image            = "rbxassetid://11415645739",
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                Parent           = picker,
                ZIndex           = 21,
            }, { New("UICorner", { CornerRadius = UDim.new(0, 6) }) })

            local svKnob = New("Frame", {
                Size             = UDim2.fromOffset(10, 10),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(s, 0, 1 - v, 0),
                BackgroundColor3 = Color3.fromHSV(h, s, v),
                Parent           = canvas, ZIndex = 22,
            }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                 New("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1.5,
                                   ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) })

            -- Hue rail (vertical, right side)
            local hueRail = New("Frame", {
                Size             = UDim2.new(0, 18, 1, -20),
                Position         = UDim2.new(1, -26, 0, 8),
                Parent           = picker, ZIndex = 21,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                New("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                        ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
                    }),
                    Rotation = 90,
                }),
            })

            local hueKnob = New("Frame", {
                Size             = UDim2.new(1, 4, 0, 6),
                Position         = UDim2.new(0, -2, h, -3),
                AnchorPoint      = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                Parent           = hueRail, ZIndex = 22,
            }, { New("UICorner", { CornerRadius = UDim.new(0, 3) }) })

            local hex = New("TextBox", {
                Size              = UDim2.new(1, -16, 0, 22),
                Position          = UDim2.fromOffset(8, -30),
                AnchorPoint       = Vector2.new(0, 1),
                BackgroundColor3  = Theme.ElementBg,
                FontFace          = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextSize          = 11,
                TextColor3        = Theme.Text,
                TextXAlignment    = Enum.TextXAlignment.Center,
                Text              = string.format("#%02X%02X%02X", math.floor(Color3.fromHSV(h,s,v).R*255+0.5),
                                        math.floor(Color3.fromHSV(h,s,v).G*255+0.5),
                                        math.floor(Color3.fromHSV(h,s,v).B*255+0.5)),
                Parent            = picker, ZIndex = 22,
            }, { New("UICorner", { CornerRadius = UDim.new(0, 5) }) })

            local function updateAll()
                local col = Color3.fromHSV(h, s, v)
                swatch.BackgroundColor3 = col
                canvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svKnob.Position         = UDim2.new(s, 0, 1 - v, 0)
                svKnob.BackgroundColor3 = col
                hueKnob.Position        = UDim2.new(0, -2, h, -3)
                hex.Text = string.format("#%02X%02X%02X", math.floor(col.R*255+0.5),
                               math.floor(col.G*255+0.5), math.floor(col.B*255+0.5))
                cfg.Color = col
                SafeCall(cfg.Callback, col)
                SaveConfiguration()
            end

            local svDrag, hDrag = false, false
            canvas.MouseButton1Down:Connect(function() svDrag = true end)
            hueRail.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then hDrag = true end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDrag = false; hDrag = false
                end
            end)
            RunService.RenderStepped:Connect(function()
                if svDrag then
                    local mx = UserInputService:GetMouseLocation()
                    s = math.clamp((mx.X - canvas.AbsolutePosition.X) / canvas.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((mx.Y - canvas.AbsolutePosition.Y) / canvas.AbsoluteSize.Y, 0, 1)
                    updateAll()
                end
                if hDrag then
                    local my = UserInputService:GetMouseLocation().Y
                    h = math.clamp((my - hueRail.AbsolutePosition.Y) / hueRail.AbsoluteSize.Y, 0, 1)
                    updateAll()
                end
            end)

            local open = false
            swatch.MouseButton1Click:Connect(function()
                open = not open
                picker.Visible = open
            end)

            function cfg:Set(col)
                h, s, v = col:ToHSV()
                updateAll()
            end

            if cfg.Flag then Library.Flags[cfg.Flag] = cfg end
            return cfg
        end

        -- ── Keybind ────────────────────────────────────────────────────────
        function Tab:CreateKeybind(cfg)
            cfg.Type = "Keybind"
            local checking = false

            local row = MakeElementRow(page, cfg.Name, cfg.Description)

            local kbFrame = New("Frame", {
                Size             = UDim2.fromOffset(80, 26),
                Position         = UDim2.new(1, -90, 0.5, -13),
                BackgroundColor3 = Theme.InputBg,
                Parent           = row,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 7) }),
                New("UIStroke", { Color = Theme.InputBorder, Thickness = 1,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            local kbBox = New("TextBox", {
                Size              = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                FontFace          = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                TextSize          = 12,
                TextColor3        = Theme.Accent,
                TextXAlignment    = Enum.TextXAlignment.Center,
                Text              = cfg.CurrentKeybind or "None",
                Parent            = kbFrame,
            })

            kbBox.Focused:Connect(function() checking = true; kbBox.Text = "..." end)
            kbBox.FocusLost:Connect(function()
                checking = false
                if kbBox.Text == "" or kbBox.Text == "..." then
                    kbBox.Text = cfg.CurrentKeybind or "None"
                end
            end)

            UserInputService.InputBegan:Connect(function(input, proc)
                if checking then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        local split = string.split(tostring(input.KeyCode), ".")
                        cfg.CurrentKeybind = split[3]
                        kbBox.Text = split[3]
                        kbBox:ReleaseFocus()
                        SaveConfiguration()
                    end
                elseif cfg.CurrentKeybind and not proc then
                    if input.KeyCode == Enum.KeyCode[cfg.CurrentKeybind] then
                        SafeCall(cfg.Callback)
                    end
                end
            end)

            function cfg:Set(v)
                cfg.CurrentKeybind = v
                kbBox.Text = v
            end

            if cfg.Flag then Library.Flags[cfg.Flag] = cfg end
            return cfg
        end

        -- ================================================================
        -- ── FU Extended Elements ────────────────────────────────────────
        -- ================================================================

        -- ── MiniBar (progress read-only bar) ──────────────────────────────
        function Tab:CreateMiniBar(idx, cfg)
            cfg = cfg or {}
            local min_, max_ = cfg.Min or 0, cfg.Max or 100
            local val = math.clamp(cfg.Default or 0, min_, max_)

            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)

            local pctLabel = New("TextLabel", {
                Text           = math.floor(((val-min_)/(max_-min_))*100) .. "%",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                TextSize       = 12,
                TextColor3     = Theme.SubText,
                BackgroundTransparency = 1,
                Size           = UDim2.fromOffset(36, 16),
                Position       = UDim2.new(1, -10, 0.5, -8),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent         = row,
            })

            local rail = New("Frame", {
                Size             = UDim2.new(0, 130, 0, 5),
                Position         = UDim2.new(1, -178, 0.5, -2),
                BackgroundColor3 = Theme.SliderRail,
                Parent           = row,
            }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local fillBar = New("Frame", {
                Size             = UDim2.new((val-min_)/(max_-min_), 0, 1, 0),
                BackgroundColor3 = cfg.Color or Theme.Accent,
                Parent           = rail,
            }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local bar = { Value = val, Min = min_, Max = max_, Type = "MiniBar" }
            function bar:SetValue(v)
                v = math.clamp(v, self.Min, self.Max)
                self.Value = v
                local pct = (v - self.Min) / math.max(self.Max - self.Min, 1)
                Tween(fillBar, 0.3, { Size = UDim2.new(pct, 0, 1, 0) })
                pctLabel.Text = math.floor(pct * 100) .. "%"
                SafeCall(self.Callback, v)
            end
            bar.Callback = cfg.Callback or function() end
            Library.Options[idx] = bar
            return bar
        end

        -- ── Separator ─────────────────────────────────────────────────────
        function Tab:CreateSeparator(idx, cfg)
            cfg = cfg or {}
            local label = cfg.Label or ""
            local root  = New("Frame", {
                Size             = UDim2.new(1, -16, 0, 22),
                BackgroundTransparency = 1,
                Parent           = page,
            })
            if label ~= "" then
                New("TextLabel", {
                    Text           = label,
                    FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
                    TextSize       = 11,
                    TextColor3     = Theme.SubText,
                    BackgroundTransparency = 1,
                    Size           = UDim2.fromOffset(0, 14),
                    AutomaticSize  = Enum.AutomaticSize.X,
                    Position       = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint    = Vector2.new(0.5, 0.5),
                    Parent         = root,
                })
            end
            local function line(anchor, xScale, grad)
                local l = New("Frame", {
                    Size             = UDim2.new(xScale, label~="" and -10 or 0, 0, 1),
                    AnchorPoint      = Vector2.new(anchor, 0.5),
                    Position         = UDim2.new(anchor==0 and 0 or 1, 0, 0.5, 0),
                    BackgroundTransparency = 0.5,
                    BackgroundColor3 = Theme.ElementBorder,
                    Parent           = root,
                })
                New("UIGradient", { Transparency = grad, Parent = l })
            end
            line(0, 0.5, NumberSequence.new({ NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0) }))
            line(1, 0.5, NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1) }))
            return { Destroy = function() root:Destroy() end }
        end

        -- ── Alert ─────────────────────────────────────────────────────────
        function Tab:CreateAlert(idx, cfg)
            cfg = cfg or {}
            local colors = {
                info    = Color3.fromRGB(30, 80, 160),
                success = Color3.fromRGB(30, 130, 80),
                warning = Color3.fromRGB(160, 110, 20),
                error   = Color3.fromRGB(160, 35, 35),
            }
            local t = cfg.Type or "info"
            local frame = New("Frame", {
                Size             = UDim2.new(1, -16, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = colors[t] or colors.info,
                BackgroundTransparency = 0.75,
                Parent           = page,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 10) }),
                New("UIStroke", { Color = colors[t] or colors.info, Thickness = 1,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                New("UIPadding", { PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10),
                                   PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) }),
            })
            New("TextLabel", {
                Text           = cfg.Title or "Alert",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize       = 13,
                TextColor3     = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 18),
                Parent         = frame,
            })
            New("TextLabel", {
                Text           = cfg.Content or "",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextSize       = 12,
                TextColor3     = Theme.SubText,
                TextWrapped    = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 0),
                AutomaticSize  = Enum.AutomaticSize.Y,
                Parent         = frame,
            })
            local al = { Type = "Alert" }
            function al:Destroy() frame:Destroy() end
            Library.Options[idx] = al
            return al
        end

        -- ── Checkbox ──────────────────────────────────────────────────────
        function Tab:CreateCheckbox(idx, cfg)
            cfg = cfg or {}
            local val = cfg.Default or false

            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)

            local box = New("Frame", {
                Size             = UDim2.fromOffset(20, 20),
                Position         = UDim2.new(1, -30, 0.5, -10),
                BackgroundTransparency = val and 0.05 or 0.88,
                BackgroundColor3 = Theme.Accent,
                Parent           = row,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                New("UIStroke", { Color = Theme.Accent, Thickness = 1.5,
                                  Transparency = 0.35,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            local mark = New("TextLabel", {
                Text           = "✓",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize       = 14,
                TextColor3     = Color3.fromRGB(255,255,255),
                BackgroundTransparency = 1,
                Size           = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextTransparency = val and 0 or 1,
                Parent         = box,
            })

            local interact = New("TextButton", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Text = "", Parent = row, ZIndex = 5,
            })

            local function updateVis(v)
                Tween(box,  0.18, { BackgroundTransparency = v and 0.05 or 0.88 })
                Tween(mark, 0.18, { TextTransparency = v and 0 or 1 })
            end

            interact.MouseButton1Click:Connect(function()
                val = not val
                updateVis(val)
                SafeCall(cfg.Callback, val)
                SaveConfiguration()
            end)

            local cb = { Value = val, Type = "Checkbox" }
            function cb:SetValue(v)
                val = v; self.Value = v
                updateVis(v)
                SafeCall(cfg.Callback, v)
            end
            Library.Options[idx] = cb
            return cb
        end

        -- ── RadioGroup ────────────────────────────────────────────────────
        function Tab:CreateRadioGroup(idx, cfg)
            cfg = cfg or {}
            local isMulti = cfg.Multi or false
            local opts    = cfg.Options or {}
            local val     = isMulti and {} or (cfg.Default or opts[1])
            if isMulti and type(cfg.Default) == "table" then
                for _, d in ipairs(cfg.Default) do val[d] = true end
            end

            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)
            row.Size = UDim2.new(1, -16, 0, 0)
            row.AutomaticSize = Enum.AutomaticSize.Y

            local holder = New("Frame", {
                Size             = UDim2.new(1, -20, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                Position         = UDim2.fromOffset(10, 46),
                BackgroundTransparency = 1,
                Parent           = row,
            }, {
                New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
                New("UIPadding",    { PaddingBottom = UDim.new(0, 10) }),
            })

            local buttons = {}

            local function getVal()
                if not isMulti then return val end
                local sel = {}
                for _, o in ipairs(opts) do if val[o] then table.insert(sel, o) end end
                return sel
            end

            local function updateBtns()
                for _, b in ipairs(buttons) do
                    local sel = isMulti and val[b.Value] or (b.Value == val)
                    Tween(b.Outer, 0.18, { BackgroundTransparency = sel and 0.05 or 0.88 })
                    Tween(b.Inner, 0.18, { BackgroundTransparency = sel and 0 or 1 })
                end
            end

            for _, opt in ipairs(opts) do
                local btn = New("TextButton", {
                    Size             = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    Text             = "",
                    Parent           = holder,
                }, {
                    New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
                                         Padding = UDim.new(0,8),
                                         VerticalAlignment = Enum.VerticalAlignment.Center }),
                })

                local outer = New("Frame", {
                    Size             = UDim2.fromOffset(16, 16),
                    BackgroundTransparency = 0.88,
                    BackgroundColor3 = Theme.Accent,
                    Parent           = btn,
                }, {
                    New("UICorner",          { CornerRadius = UDim.new(1, 0) }),
                    New("UIAspectRatioConstraint", { AspectRatio = 1 }),
                    New("UIStroke",          { Transparency = 0.3,
                                               ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                })

                local inner = New("Frame", {
                    Size             = UDim2.fromOffset(4, 4),
                    Position         = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(255,255,255),
                    Parent           = outer,
                }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                New("TextLabel", {
                    Text           = tostring(opt),
                    FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                    TextSize       = 13,
                    TextColor3     = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(1, -24, 1, 0),
                    Parent         = btn,
                })

                table.insert(buttons, { Value = opt, Outer = outer, Inner = inner })

                btn.MouseButton1Click:Connect(function()
                    if isMulti then
                        val[opt] = not val[opt] or nil
                    else
                        val = opt
                    end
                    updateBtns()
                    SafeCall(cfg.Callback, getVal())
                end)
            end
            updateBtns()

            local rg = { Value = val, Type = "RadioGroup" }
            function rg:SetValue(v)
                if isMulti then val = {} if type(v)=="table" then for _,x in ipairs(v) do val[x]=true end end
                else val = v end
                updateBtns()
                SafeCall(cfg.Callback, getVal())
            end
            Library.Options[idx] = rg
            return rg
        end

        -- ── NumberInput ───────────────────────────────────────────────────
        function Tab:CreateNumberInput(idx, cfg)
            cfg = cfg or {}
            local val  = cfg.Default or 0
            local step = cfg.Step    or 1
            local min_ = cfg.Min     or -math.huge
            local max_ = cfg.Max     or math.huge

            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)

            local holder = New("Frame", {
                Size             = UDim2.fromOffset(100, 30),
                Position         = UDim2.new(1, -110, 0.5, -15),
                BackgroundTransparency = 1,
                Parent           = row,
            }, {
                New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
                                      VerticalAlignment = Enum.VerticalAlignment.Center }),
            })

            local function makeBtn(txt, lo)
                return New("TextButton", {
                    Text             = txt,
                    FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                    TextSize         = 16,
                    Size             = UDim2.fromOffset(30, 30),
                    BackgroundColor3 = Theme.ElementBg,
                    TextColor3       = Theme.Text,
                    LayoutOrder      = lo,
                    Parent           = holder,
                }, { New("UICorner", { CornerRadius = UDim.new(0, 7) }) })
            end

            local minusBtn = makeBtn("−", 1)
            local valLabel = New("TextLabel", {
                Text             = tostring(val),
                FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
                TextSize         = 13,
                Size             = UDim2.fromOffset(40, 30),
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Center,
                TextColor3       = Theme.Text,
                LayoutOrder      = 2,
                Parent           = holder,
            })
            local plusBtn = makeBtn("+", 3)

            local ni = { Value = val, Type = "NumberInput" }
            local function set(v)
                v = math.clamp(math.floor(v/step+0.5)*step, min_, max_)
                ni.Value = v; val = v
                valLabel.Text = tostring(v)
                SafeCall(cfg.Callback, v)
            end
            minusBtn.MouseButton1Click:Connect(function() set(val - step) end)
            plusBtn.MouseButton1Click:Connect(function()  set(val + step) end)
            function ni:SetValue(v) set(v) end
            Library.Options[idx] = ni
            set(val)
            return ni
        end

        -- ── CopyButton ────────────────────────────────────────────────────
        function Tab:CreateCopyButton(idx, cfg)
            cfg = cfg or {}
            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)
            local copyBtn = New("TextButton", {
                Text             = "Copy",
                FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                TextSize         = 12,
                Size             = UDim2.fromOffset(60, 26),
                Position         = UDim2.new(1, -70, 0.5, -13),
                BackgroundColor3 = Theme.ElementBgHover,
                TextColor3       = Theme.Accent,
                Parent           = row, ZIndex = 5,
            }, { New("UICorner", { CornerRadius = UDim.new(0, 7) }) })
            copyBtn.MouseButton1Click:Connect(function()
                local text = cfg.Text or cfg.GetText and cfg.GetText() or ""
                if setclipboard then setclipboard(text) end
                copyBtn.Text = "✓ Copied"
                task.delay(1.5, function() copyBtn.Text = "Copy" end)
                SafeCall(cfg.Callback, text)
            end)
            local cb = { Type = "CopyButton" }
            function cb:SetText(t) cfg.Text = t end
            Library.Options[idx] = cb
            return cb
        end

        -- ── QuickActions ──────────────────────────────────────────────────
        function Tab:CreateQuickActions(idx, cfg)
            cfg = cfg or {}
            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)
            local actHolder = New("Frame", {
                Size             = UDim2.fromOffset(0, 30),
                AutomaticSize    = Enum.AutomaticSize.X,
                Position         = UDim2.new(1, -10, 0.5, -15),
                AnchorPoint      = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Parent           = row,
            }, {
                New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
                                      Padding = UDim.new(0,4),
                                      VerticalAlignment = Enum.VerticalAlignment.Center,
                                      HorizontalAlignment = Enum.HorizontalAlignment.Right }),
            })
            for _, act in ipairs(cfg.Actions or {}) do
                local btn = New("TextButton", {
                    Size             = UDim2.fromOffset(30, 30),
                    BackgroundColor3 = Theme.ElementBg,
                    BackgroundTransparency = 0.5,
                    Text             = act.Text or "",
                    FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize         = 11,
                    TextColor3       = Theme.Text,
                    Parent           = actHolder,
                }, { New("UICorner", { CornerRadius = UDim.new(0, 8) }) })
                if act.Icon then
                    New("ImageLabel", {
                        Image            = "rbxassetid://"..tostring(act.Icon),
                        Size             = UDim2.fromOffset(14,14),
                        Position         = UDim2.fromScale(0.5,0.5),
                        AnchorPoint      = Vector2.new(0.5,0.5),
                        BackgroundTransparency = 1,
                        ImageColor3      = Theme.Text,
                        Parent           = btn,
                    })
                end
                btn.MouseButton1Click:Connect(function() SafeCall(act.Callback) end)
            end
            local qa = { Type = "QuickActions" }
            Library.Options[idx] = qa
            return qa
        end

        -- ── Timer ─────────────────────────────────────────────────────────
        function Tab:CreateTimer(idx, cfg)
            cfg = cfg or {}
            local countdown = cfg.CountDown or false
            local startVal  = cfg.StartValue or (countdown and 60 or 0)
            local running   = false

            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)

            local function fmt(s)
                s = math.floor(math.abs(s))
                return string.format("%02d:%02d", math.floor(s/60), s%60)
            end

            local timeLbl = New("TextLabel", {
                Text           = fmt(startVal),
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize       = 18,
                BackgroundTransparency = 1,
                TextColor3     = Theme.Accent,
                Size           = UDim2.fromOffset(64, 22),
                Position       = UDim2.new(1, -130, 0.5, -11),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent         = row,
            })

            local btnHolder = New("Frame", {
                Size             = UDim2.fromOffset(56, 30),
                Position         = UDim2.new(1, -66, 0.5, -15),
                BackgroundTransparency = 1,
                Parent           = row,
            }, {
                New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
                                      Padding = UDim.new(0,4),
                                      VerticalAlignment = Enum.VerticalAlignment.Center }),
            })

            local function makeSmall(txt)
                return New("TextButton", {
                    Text             = txt,
                    FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                    TextSize         = 12,
                    Size             = UDim2.fromOffset(26, 26),
                    BackgroundColor3 = Theme.ElementBg,
                    TextColor3       = Theme.Text,
                    Parent           = btnHolder,
                }, { New("UICorner", { CornerRadius = UDim.new(0, 5) }) })
            end

            local playBtn  = makeSmall("▶")
            local resetBtn = makeSmall("↺")

            local tim = { Value = startVal, Running = false, Type = "Timer" }
            local conn

            local function stopTick()
                if conn then conn:Disconnect() conn = nil end
            end
            local function startTick()
                stopTick()
                conn = RunService.Heartbeat:Connect(function(dt)
                    if running then
                        tim.Value = tim.Value + (countdown and -dt or dt)
                        timeLbl.Text = fmt(tim.Value)
                        SafeCall(cfg.Callback, tim.Value)
                        if countdown and tim.Value <= 0 then
                            tim.Value = 0; running = false
                            playBtn.Text = "▶"
                            stopTick()
                            SafeCall(cfg.OnEnd)
                        end
                    end
                end)
            end

            playBtn.MouseButton1Click:Connect(function()
                running = not running
                tim.Running = running
                playBtn.Text = running and "⏸" or "▶"
                if running then startTick() else stopTick() end
            end)

            resetBtn.MouseButton1Click:Connect(function()
                running = false; tim.Running = false
                playBtn.Text = "▶"
                stopTick()
                tim.Value = startVal
                timeLbl.Text = fmt(startVal)
            end)

            function tim:Destroy() stopTick() row:Destroy() end
            Library.Options[idx] = tim
            return tim
        end

        -- ── ButtonGroup ───────────────────────────────────────────────────
        function Tab:CreateButtonGroup(idx, cfg)
            cfg = cfg or {}
            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)
            local btnRow = New("Frame", {
                Size             = UDim2.fromOffset(0, 28),
                AutomaticSize    = Enum.AutomaticSize.X,
                Position         = UDim2.new(1, -10, 0.5, -14),
                AnchorPoint      = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Parent           = row,
            }, {
                New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
                                      Padding = UDim.new(0, 0),
                                      VerticalAlignment = Enum.VerticalAlignment.Center }),
            })
            for _, btn in ipairs(cfg.Buttons or {}) do
                local b = New("TextButton", {
                    Text             = btn.Text or "Btn",
                    FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize         = 12,
                    Size             = UDim2.fromOffset(0, 28),
                    AutomaticSize    = Enum.AutomaticSize.X,
                    BackgroundColor3 = Theme.ElementBg,
                    TextColor3       = Theme.Text,
                    Parent           = btnRow,
                }, {
                    New("UIStroke", { Color = Theme.ElementBorder, Thickness = 1,
                                      ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                    New("UIPadding", { PaddingLeft = UDim.new(0,14), PaddingRight = UDim.new(0,14) }),
                })
                b.MouseButton1Click:Connect(function() SafeCall(btn.Callback) end)
                b.MouseEnter:Connect(function() Tween(b, 0.15, { BackgroundColor3 = Theme.ElementBgHover }) end)
                b.MouseLeave:Connect(function() Tween(b, 0.18, { BackgroundColor3 = Theme.ElementBg }) end)
            end
            local bg = { Type = "ButtonGroup" }
            Library.Options[idx] = bg
            return bg
        end

        -- ── Divider ───────────────────────────────────────────────────────
        function Tab:CreateDivider(idx, cfg)
            local div = New("Frame", {
                Size             = UDim2.new(1, -16, 0, 1),
                BackgroundColor3 = Theme.ElementBorder,
                BackgroundTransparency = 0.4,
                Parent           = page,
            })
            return { Destroy = function() div:Destroy() end }
        end

        -- ── Chip (multi-tag selector) ──────────────────────────────────────
        function Tab:CreateChip(idx, cfg)
            cfg = cfg or {}
            local items = cfg.Items or {}
            local multi = cfg.Multi ~= false
            local val   = {}
            if cfg.Default then for _, d in ipairs(cfg.Default) do val[d] = true end end

            local frame = New("Frame", {
                Size             = UDim2.new(1, -16, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.ElementBg,
                BackgroundTransparency = 0.15,
                Parent           = page,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 10) }),
                New("UIStroke", { Color = Theme.ElementBorder, Thickness = 1,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                New("UIPadding", { PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10),
                                   PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) }),
            })

            if cfg.Title then
                New("TextLabel", {
                    Text           = cfg.Title,
                    FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize       = 13,
                    TextColor3     = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(1, 0, 0, 18),
                    Parent         = frame,
                })
            end

            local chipRow = New("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent           = frame,
            }, {
                New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
                                      Padding = UDim.new(0,8), Wraps = true }),
                New("UIPadding",    { PaddingTop = UDim.new(0,6) }),
            })

            local chipBtns = {}
            local function updateChip(item, btn)
                local active = val[item] == true
                Tween(btn, 0.18, {
                    BackgroundTransparency = active and 0.15 or 0.88,
                    TextTransparency       = active and 0 or 0.35,
                })
                local s = btn:FindFirstChildOfClass("UIStroke")
                if s then Tween(s, 0.18, { Transparency = active and 0.1 or 0.8 }) end
            end

            for _, item in ipairs(items) do
                local chip = New("TextButton", {
                    Text             = tostring(item),
                    FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize         = 12,
                    Size             = UDim2.fromOffset(0, 28),
                    AutomaticSize    = Enum.AutomaticSize.X,
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = 0.88,
                    TextColor3       = Theme.Text,
                    Parent           = chipRow,
                }, {
                    New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    New("UIStroke", { Color = Theme.Accent, Transparency = 0.8, Thickness = 1,
                                      ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                    New("UIPadding", { PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) }),
                })
                chipBtns[item] = chip
                updateChip(item, chip)
                chip.MouseButton1Click:Connect(function()
                    if val[item] then val[item] = nil
                    else
                        if not multi then val = {} end
                        val[item] = true
                    end
                    for it, btn in pairs(chipBtns) do updateChip(it, btn) end
                    -- build array
                    local sel = {}
                    for _, it in ipairs(items) do if val[it] then table.insert(sel, it) end end
                    SafeCall(cfg.Callback, sel)
                end)
            end

            local ch = { Value = val, Type = "Chip" }
            function ch:SetValue(v)
                val = {}
                if type(v) == "table" then for _, x in ipairs(v) do val[x] = true end end
                for it, btn in pairs(chipBtns) do updateChip(it, btn) end
            end
            Library.Options[idx] = ch
            return ch
        end

        -- ── StatusIndicator ───────────────────────────────────────────────
        function Tab:CreateStatusIndicator(idx, cfg)
            cfg = cfg or {}
            local statusColors = {
                online  = Color3.fromRGB(0, 200, 100),
                offline = Color3.fromRGB(120, 120, 120),
                running = Theme.Accent,
                stopped = Color3.fromRGB(255, 80, 80),
                warning = Color3.fromRGB(255, 200, 50),
            }
            local status = cfg.Status or "offline"
            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)

            local dot = New("Frame", {
                Size             = UDim2.fromOffset(10, 10),
                Position         = UDim2.new(1, -66, 0.5, -5),
                BackgroundColor3 = statusColors[status] or statusColors.offline,
                Parent           = row,
            }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local lbl = New("TextLabel", {
                Text           = cfg.Label or status,
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json"),
                TextSize       = 12,
                TextColor3     = Theme.SubText,
                BackgroundTransparency = 1,
                Size           = UDim2.fromOffset(50, 16),
                Position       = UDim2.new(1, -12, 0.5, -8),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent         = row,
            })

            local si = { Status = status, Type = "StatusIndicator" }
            function si:SetStatus(s)
                self.Status = s
                Tween(dot, 0.25, { BackgroundColor3 = statusColors[s] or statusColors.offline })
                lbl.Text = s
            end
            Library.Options[idx] = si
            return si
        end

        -- ── CounterButton ─────────────────────────────────────────────────
        function Tab:CreateCounterButton(idx, cfg)
            cfg = cfg or {}
            local val  = cfg.Default or 1
            local step = cfg.Step    or 1
            local min_ = cfg.Min     or 1
            local max_ = cfg.Max     or 99

            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)

            local holder = New("Frame", {
                Size             = UDim2.fromOffset(100, 30),
                Position         = UDim2.new(1, -110, 0.5, -15),
                BackgroundTransparency = 1,
                Parent           = row,
            }, {
                New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
                                      VerticalAlignment = Enum.VerticalAlignment.Center,
                                      SortOrder = Enum.SortOrder.LayoutOrder }),
            })

            local function mkBtn(txt, lo)
                return New("TextButton", {
                    Text             = txt,
                    FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                    TextSize         = 16,
                    Size             = UDim2.fromOffset(30, 30),
                    BackgroundColor3 = Theme.ElementBg,
                    TextColor3       = Theme.Text,
                    LayoutOrder      = lo,
                    Parent           = holder,
                }, { New("UICorner", { CornerRadius = UDim.new(0, 7) }) })
            end

            local minusBtn = mkBtn("−", 1)
            local valLabel = New("TextLabel", {
                Text             = tostring(val),
                FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
                TextSize         = 13,
                Size             = UDim2.fromOffset(40, 30),
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Center,
                TextColor3       = Theme.Text,
                LayoutOrder      = 2,
                Parent           = holder,
            })
            local plusBtn = mkBtn("+", 3)

            local cb = { Value = val, Type = "CounterButton" }
            local function set(v)
                v = math.clamp(math.floor(v/step+0.5)*step, min_, max_)
                cb.Value = v; val = v
                valLabel.Text = tostring(v)
                SafeCall(cfg.Callback, v)
            end
            minusBtn.MouseButton1Click:Connect(function() set(val - step) end)
            plusBtn.MouseButton1Click:Connect(function()  set(val + step) end)
            function cb:SetValue(v) set(v) end
            Library.Options[idx] = cb
            set(val)
            return cb
        end

        -- ── ToggleGroup (segmented control) ───────────────────────────────
        function Tab:CreateToggleGroup(idx, cfg)
            cfg = cfg or {}
            local opts = cfg.Options or {}
            local val  = cfg.Default or opts[1]

            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)

            local row2 = New("Frame", {
                Size             = UDim2.fromOffset(0, 28),
                AutomaticSize    = Enum.AutomaticSize.X,
                Position         = UDim2.new(1, -10, 0.5, -14),
                AnchorPoint      = Vector2.new(1, 0),
                BackgroundColor3 = Theme.ElementBg,
                BackgroundTransparency = 0.5,
                Parent           = row,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 8) }),
                New("UIStroke", { Color = Theme.ElementBorder, Thickness = 1,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
                                      VerticalAlignment = Enum.VerticalAlignment.Center }),
            })

            local btns = {}
            local function update(selected)
                for _, b in ipairs(btns) do
                    local active = b.Value == selected
                    Tween(b.Frame, 0.15, { BackgroundTransparency = active and 0 or 1 })
                    Tween(b.Label, 0.15, { TextColor3 = active and Color3.new(1,1,1) or Theme.SubText })
                end
            end

            for _, opt in ipairs(opts) do
                local btn = New("TextButton", {
                    Text             = "",
                    Size             = UDim2.fromOffset(0, 28),
                    AutomaticSize    = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Theme.Accent,
                    Parent           = row2,
                }, {
                    New("UICorner", { CornerRadius = UDim.new(0, 7) }),
                    New("UIPadding", { PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) }),
                })
                local lbl = New("TextLabel", {
                    Text             = tostring(opt),
                    FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize         = 12,
                    BackgroundTransparency = 1,
                    Size             = UDim2.fromScale(1,1),
                    AutomaticSize    = Enum.AutomaticSize.X,
                    TextColor3       = Theme.SubText,
                    Parent           = btn,
                })
                table.insert(btns, { Frame = btn, Label = lbl, Value = opt })
                btn.MouseButton1Click:Connect(function()
                    val = opt
                    update(opt)
                    SafeCall(cfg.Callback, opt)
                end)
            end
            update(val)

            local tg = { Value = val, Type = "ToggleGroup" }
            function tg:SetValue(v) val = v update(v) SafeCall(cfg.Callback, v) end
            Library.Options[idx] = tg
            return tg
        end

        -- ── Accordion (collapsible section) ───────────────────────────────
        function Tab:CreateAccordion(idx, cfg)
            cfg = cfg or {}
            local open    = cfg.Open or false
            local ANIM    = 0.22

            local outer = New("Frame", {
                Size             = UDim2.new(1, -16, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.ElementBg,
                BackgroundTransparency = 0.15,
                Parent           = page,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 10) }),
                New("UIStroke", { Color = Theme.ElementBorder, Thickness = 1,
                                  ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
            })

            local header = New("TextButton", {
                Size             = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
                Text             = "",
                Parent           = outer, ZIndex = 5,
            })

            New("TextLabel", {
                Text           = cfg.Title or "Accordion",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
                TextSize       = 13,
                TextColor3     = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, -50, 1, 0),
                Position       = UDim2.fromOffset(14, 0),
                Parent         = header,
            })

            local arrow = New("TextLabel", {
                Text           = open and "∧" or "∨",
                FontFace       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize       = 14,
                TextColor3     = Theme.SubText,
                BackgroundTransparency = 1,
                Size           = UDim2.fromOffset(20, 20),
                Position       = UDim2.new(1, -30, 0.5, -10),
                Parent         = header,
            })

            local body = New("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                ClipsDescendants = true,
                BackgroundTransparency = 1,
                Parent           = outer,
            }, {
                New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
                New("UIPadding",    { PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12),
                                       PaddingBottom = UDim.new(0, open and 10 or 0) }),
            })

            if not open then body.Visible = false end

            local acc = { Type = "Accordion", Open = open }
            local bodyInner = New("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent           = body,
            }, {
                New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
            })

            header.MouseButton1Click:Connect(function()
                open = not open
                acc.Open = open
                arrow.Text = open and "∧" or "∨"
                if open then
                    body.Visible = true
                    Tween(body, ANIM, { Size = UDim2.new(1, 0, 0, bodyInner.AbsoluteSize.Y + 16) })
                else
                    Tween(body, ANIM, { Size = UDim2.new(1, 0, 0, 0) })
                    task.wait(ANIM + 0.02)
                    body.Visible = false
                end
            end)

            -- inner Tab-like object for adding elements inside accordion
            acc.Section = { Container = bodyInner }

            Library.Options[idx] = acc
            return acc
        end

        -- ── LiveLabel (pill badge) ─────────────────────────────────────────
        function Tab:CreateLiveLabel(idx, cfg)
            cfg = cfg or {}
            local typeColors = {
                default = Color3.fromRGB(165, 168, 185),
                info    = Theme.Accent,
                success = Color3.fromRGB(80, 215, 130),
                warning = Color3.fromRGB(255, 195, 60),
                error   = Color3.fromRGB(255, 80, 80),
            }
            local t = cfg.Type or "default"
            local row = MakeElementRow(page, cfg.Title or idx, cfg.Description)

            local pill = New("Frame", {
                AutomaticSize    = Enum.AutomaticSize.XY,
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -10, 0.5, 0),
                BackgroundColor3 = typeColors[t] or typeColors.default,
                BackgroundTransparency = 0.72,
                Parent           = row,
                Visible          = (cfg.Text or "") ~= "",
            }, {
                New("UICorner",  { CornerRadius = UDim.new(0, 6) }),
                New("UIStroke",  { Color = typeColors[t] or typeColors.default,
                                   Transparency = 0.4, Thickness = 1,
                                   ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),
                New("UIPadding", { PaddingLeft = UDim.new(0,7), PaddingRight = UDim.new(0,7),
                                   PaddingTop = UDim.new(0,3), PaddingBottom = UDim.new(0,3) }),
            })

            local valLabel = New("TextLabel", {
                Text             = cfg.Text or "",
                FontFace         = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                TextSize         = 12,
                TextColor3       = typeColors[t] or typeColors.default,
                TextXAlignment   = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                Parent           = pill,
            })

            local ll = { Value = cfg.Text or "", Type = "LiveLabel" }
            function ll:SetText(text)
                self.Value      = text or ""
                valLabel.Text   = self.Value
                pill.Visible    = self.Value ~= ""
            end
            function ll:SetType(tp)
                local col = typeColors[tp] or typeColors.default
                Tween(pill,     0.2, { BackgroundColor3 = col })
                Tween(valLabel, 0.2, { TextColor3 = col })
            end
            Library.Options[idx] = ll
            return ll
        end

        return Tab
    end -- CreateTab

    -- ── Auto-load config after 3.5s ──────────────────────────────────────────
    task.delay(3.5, function()
        if CEnabled then
            pcall(function()
                if isfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension) then
                    LoadConfigurationData(readfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension))
                    Library:Notify({ Title = "Configuration Loaded",
                                     Content = "Previous session config loaded." })
                end
            end)
        end
    end)

    return Window
end -- CreateWindow

return Library
