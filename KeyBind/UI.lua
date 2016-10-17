
local Controls = CreateFrame("Frame", nil, UIParent)
local Mouse = CreateFrame("Frame", nil, Controls)

Controls:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
Controls:SetBackdropColor(0,0,0,0.8);
Controls:EnableMouse(true)
Controls:SetMovable(true)
Controls:SetSize(250, 180)
Controls:SetPoint("TOPLEFT", UIParent, "CENTER", -400, 400)
Controls:SetScript("OnMouseDown", function(s) s:StartMoving() end)
Controls:SetScript("OnMouseUp", function(s) s:StopMovingOrSizing() end)

Controls.Close = CreateFrame("Button",nil, Controls, "UIPanelButtonTemplate")
Controls.Close:SetSize(15, 15)
Controls.Close:SetText("X")
Controls.Close:SetScript("OnClick", function(s) Controls:Hide() Keyboard:Hide() end)
Controls.Close:SetPoint("TOPRIGHT", Controls, "TOPRIGHT")

Controls.Slider = CreateFrame("Slider", "KeyBind_Slider1", Controls, "OptionsSliderTemplate")

	Controls.Slider:SetMinMaxValues(0.5,1)
	Controls.Slider:SetValueStep(0.05)
	Controls.Slider:SetValue(1)
	_G[Controls.Slider:GetName().."Low"]:SetText("0.5")
	_G[Controls.Slider:GetName().."High"]:SetText("1")
	Controls.Slider:SetScript("OnValueChanged",
				function(self) Keyboard:SetScale(self:GetValue()) Mouse:SetScale(self:GetValue())end)

	Controls.Slider:SetWidth(200)
	Controls.Slider:SetHeight(20)
	Controls.Slider:SetPoint("BOTTOMLEFT", Controls, "BOTTOMLEFT", 15, 15)



Controls.AltCB = CreateFrame("CheckButton", "KeyBindAltCB", Controls, "ChatConfigCheckButtonTemplate");
_G[Controls.AltCB:GetName().."Text"]:SetText ("Alt")
Controls.AltCB:SetHitRectInsets(0,-40,0,0)
Controls.AltCB:SetPoint("TOPLEFT", Controls, "TOPLEFT", 10, -40)
Controls.AltCB:SetScript("OnClick", function(s) if s:GetChecked() then modif.ALT = "ALT-" else modif.ALT = "" end addon:RefreshKeys() end)
Controls.AltCB:SetSize(20, 20)



Controls.ShiftCB = CreateFrame("CheckButton", "KeyBindShiftCB", Controls, "ChatConfigCheckButtonTemplate");
_G[Controls.ShiftCB:GetName().."Text"]:SetText ("Shift")
Controls.ShiftCB:SetHitRectInsets(0,-40,0,0)
Controls.ShiftCB:SetPoint("TOPLEFT", Controls, "TOPLEFT", 10, -70)
Controls.ShiftCB:SetScript("OnClick", function(s) if s:GetChecked() then modif.SHIFT = "SHIFT-" else modif.SHIFT = "" end addon:RefreshKeys() end)
Controls.ShiftCB:SetSize(20, 20)


Controls.CtrlCB = CreateFrame("CheckButton", "KeyBindCtrlCB", Controls, "ChatConfigCheckButtonTemplate");
_G[Controls.CtrlCB:GetName().."Text"]:SetText ("Ctrl")
Controls.CtrlCB:SetHitRectInsets(0,-40,0,0)
Controls.CtrlCB:SetPoint("TOPLEFT", Controls, "TOPLEFT", 10, -100)
Controls.CtrlCB:SetScript("OnClick", function(s) if s:GetChecked() then modif.CTRL = "CTRL-" else modif.CTRL = "" end addon:RefreshKeys() end)
Controls.CtrlCB:SetSize(20, 20)



Mouse:SetSize(256, 384)
Mouse:SetPoint("TOPLEFT", Controls, "TOPRIGHT", 100, 0)
Mouse:EnableMouse(true)
Mouse:SetMovable(true)
Mouse:SetScript("OnMouseDown", function(self) self:StartMoving() end)
Mouse:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)

Mouse:Hide()

Mouse.Texture = Mouse:CreateTexture()
Mouse.Texture:SetTexture("Interface\\AddOns\\KeyBind\\Mouse.tga")
Mouse.Texture:SetPoint("TOPLEFT", Mouse, "TOPLEFT", -64, 256)
Mouse.Texture:SetPoint("BOTTOMRIGHT", Mouse, "BOTTOMRIGHT", 0, 0)

Controls.Mouse = CreateFrame("Button", nil, Controls, "UIPanelButtonTemplate")
Controls.Mouse:SetSize(80, 20)
Controls.Mouse:SetPoint("TOPRIGHT", Controls, "TOPRIGHT", -10, -30)
Controls.Mouse:SetText("Mouse")
Controls.Mouse:SetScript("OnClick", function(s) if Mouse:IsShown() then Mouse:Hide() else Mouse:Show() end end)

Controls.Keyboard = CreateFrame("Button", nil, Controls, "UIPanelButtonTemplate")
Controls.Keyboard:SetSize(80, 20)
Controls.Keyboard:SetPoint("TOPRIGHT", Controls.Mouse, "BOTTOMRIGHT", 0, -5)
Controls.Keyboard:SetText("Keyboard")
Controls.Keyboard:SetScript("OnClick", function(s) if Keyboard:IsShown() then Keyboard:Hide() else Keyboard:Show() end end)


Controls:Hide()


local DefaultBoard = KeyBindAllBoards.laptop




Keyboard:SetWidth(1490)
Keyboard:SetHeight(570)
Keyboard:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
Keyboard:SetBackdropColor(0,0,0,0.8);
Keyboard:SetPoint("CENTER", UIParent, "CENTER")
Keyboard:SetScript("OnMouseDown", function(self) self:StartMoving() end)
Keyboard:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
Keyboard:SetMovable(true) --make the keyboard moveable


--[[
local StanceDD = CreateFrame("Frame", "KBStanceDD", ExpFrame, "UIDropDownMenuTemplate")
StanceDD:SetPoint("TOPLEFT", 10, -5)
UIDropDownMenu_SetWidth(KBStanceDD, 65)
UIDropDownMenu_SetButtonWidth(KBStanceDD, 65)

local function StanceDD_Initialize(self, level) -- the menu items, needs a cleanup
		level = level or 1
	local info = UIDropDownMenu_CreateInfo()
	local value = UIDROPDOWNMENU_MENU_VALUE
		info.text = "Stance 1"
		info.value = 1
		info.func = function()  end
		UIDropDownMenu_AddButton(info, level)
end
UIDropDownMenu_Initialize(KBStanceDD, StanceDD_Initialize)

--]]





local KBTooltip = CreateFrame("Frame", "KeyBindTooltip", Controls) --tooltip to show the name of the macro/spell/action
KBTooltip:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});

KBTooltip:SetBackdropColor(0,0,0,1);
KBTooltip:SetWidth(200)
KBTooltip:SetHeight(25)
KBTooltip:SetFrameStrata("TOOLTIP")
KBTooltip.title = KBTooltip:CreateFontString(nil, "OVERLAY", "GameFontNormal")
KBTooltip.title:SetPoint("TOPLEFT", KBTooltip, "TOPLEFT", 5, -5)


Mouse.Button1 = NewButton(Mouse)
Mouse.Button1.label:SetText("BUTTON1")
Mouse.Button1:SetSize(50, 50)
Mouse.Button1:SetPoint("TOPLEFT", -16, 90)

Mouse.Button2 = NewButton(Mouse)
Mouse.Button2.label:SetText("BUTTON2")
Mouse.Button2:SetSize(50, 50)
Mouse.Button2:SetPoint("TOPLEFT", 184, 97)

Mouse.Button3 = NewButton(Mouse)
Mouse.Button3.label:SetText("BUTTON3")
Mouse.Button3:SetSize(50, 50)
Mouse.Button3:SetPoint("TOPLEFT", 88, 128)

Mouse.Button4 = NewButton(Mouse)
Mouse.Button4.label:SetText("BUTTON4")
Mouse.Button4:SetSize(50, 50)
Mouse.Button4:SetPoint("TOPLEFT", -56, -56)

Mouse.Button5 = NewButton(Mouse)
Mouse.Button5.label:SetText("BUTTON5")
Mouse.Button5:SetSize(50, 50)
Mouse.Button5:SetPoint("TOPLEFT", -48, -141)
