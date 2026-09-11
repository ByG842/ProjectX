--[[
    Loader.lua
    ---------------------------------------------------------------
    โหลดไฟล์ src/*.lua ทั้งหมดจาก GitHub raw ตามลำดับ แล้ว "ต่อ" เป็น
    Lua chunk เดียวก่อนรัน (เทคนิคเดียวกับการ #include ไฟล์ .c เข้าด้วยกัน)

    ทำแบบนี้เพราะโค้ดต้นฉบับพึ่งพา local upvalue ที่แชร์กันข้ามทุก
    section (Services, Themes, Creator, Library, Components, Icons ฯลฯ)
    การต่อไฟล์แบบนี้รับประกันว่าพฤติกรรม runtime เหมือนไฟล์เดี่ยวเดิม
    ทุกประการ — ไม่ต้อง refactor logic ข้างในเลยแม้แต่บรรทัดเดียว

    แก้ตรงนี้แค่จุดเดียว: BASE_URL ให้ชี้ไป repo ของคุณ
    ---------------------------------------------------------------
]]

local BASE_URL = "https://github.com/ByG842/ProjectX/tree/main/src"
-- ตัวอย่าง: "https://raw.githubusercontent.com/johndoe/my-ui-lib/main/src/"

-- ลำดับไฟล์ "ต้องตรงเป๊ะ" ตามลำดับเดิมในไฟล์ต้นฉบับ ห้ามสลับ
local Files = {
	"01_Init.lua",
	"02_Themes.lua",
	"03_StyleSystem.lua",
	"04_Animation.lua",
	"05_Creator.lua",
	"06_AcrylicPaint.lua",
	"07_Components_Core.lua",
	"08_Components_Window.lua",
	"09_Elements/00_Init.lua",
	"09_Elements/01_Toggle.lua",
	"09_Elements/02_Dropdown.lua",
	"09_Elements/03_Slider.lua",
	"09_Elements/04_Keybind.lua",
	"09_Elements/05_Colorpicker.lua",
	"09_Elements/06_Input.lua",
	"09_Elements/07_Separator.lua",
	"09_Elements/08_Alert.lua",
	"09_Elements/09_Checkbox.lua",
	"09_Elements/10_RadioGroup.lua",
	"09_Elements/11_ActionButton.lua",
	"09_Elements/12_QuickActions.lua",
	"09_Elements/13_ButtonGroup.lua",
	"09_Elements/14_Chip.lua",
	"09_Elements/15_Stepper.lua",
	"09_Elements/16_LiveLabel.lua",
	"10_Icons.lua",
	"11_ElementsDispatcher.lua",
	"12_SaveManager.lua",
	"13_InterfaceManager.lua",
	"14_Minimizer.lua",
	"15_LibraryAPI.lua",
	"16_Main.lua",
}

local SourceParts = {}

for _, path in ipairs(Files) do
	local url = BASE_URL .. path
	local ok, bodyOrErr = pcall(function()
		return game:HttpGet(url, true)
	end)

	if not ok or type(bodyOrErr) ~= "string" or #bodyOrErr == 0 then
		error(("[Loader] โหลดไฟล์ไม่สำเร็จ: %s\n%s"):format(path, tostring(bodyOrErr)), 0)
	end

	table.insert(SourceParts, bodyOrErr)
end

local FullSource = table.concat(SourceParts, "\n")

local Chunk, CompileErr = loadstring(FullSource, "=GzLibrary")
if not Chunk then
	error("[Loader] compile โค้ดที่ประกอบร่างแล้วไม่ผ่าน: " .. tostring(CompileErr), 0)
end

-- Chunk() จะ return Library, SaveManager, InterfaceManager, Mobile เหมือนไฟล์เดิม
return Chunk()
