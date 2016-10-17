
--[[

TODO:

multiple spec
resize based on board
mouse
--]]



--[[
do
local msg = "/cast [mod:shift, @player] LifeBloom; [nostance, help] LifeBloom; [stance:1, harm, mod:shift] Bash; [stance:1, harm] Claw;"..
					" [stance:1] Cat Form; [stance:3, nostealth, nocombat] Prowl; [stance:3, stealth] Travel Form; "..
						"[stance:4, nocombat, @player] LifeBloom; [outdoors, nostance, nomounted] Swift Zhevra; [mounted] Bear Form; "
local button = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
	button.bg = button:CreateTexture()
	button.bg:SetTexture("Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill")
	button.bg:SetDrawLayer("BACKGROUND")
	button.bg:SetAllPoints(button)
	button:SetPoint("CENTER", 0, -200)
	button.bg:SetDrawLayer("BACKGROUND")

	button.text = button:CreateFontString(nil, "OVERLAY","GameFontNormal")
	button.text:SetAllPoints(button)
	button:SetSize(40, 40)

	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext", msg)
end
--]]

local addon = {}

KeyBindSettings = {}

local fighting = false -- if the player is in combat or not
local Keys = {} --stores the key buttons once they are created
local Keyboard = CreateFrame("Frame", nil, UIParent) -- the frame holding the keys
local tempframe = Keyboard -- a hack for the parenting of the button creations
local SelectedFrame = nil --hack for the dropdown
local modif = {} --table that stores the modifiers
modif.CTRL = ""
modif.SHIFT = ""
modif.ALT = ""

--[[controls wanted:
select layout
new layout
show/hide mouse
spec

]]

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
Controls.AltCB:SetScript("OnClick", function(s) if s:GetChecked() then modif.ALT = "ALT-" else modif.ALT = "" end addon.RefreshKeys() end)
Controls.AltCB:SetSize(20, 20)



Controls.ShiftCB = CreateFrame("CheckButton", "KeyBindShiftCB", Controls, "ChatConfigCheckButtonTemplate");
_G[Controls.ShiftCB:GetName().."Text"]:SetText ("Shift")
Controls.ShiftCB:SetHitRectInsets(0,-40,0,0)
Controls.ShiftCB:SetPoint("TOPLEFT", Controls, "TOPLEFT", 10, -70)
Controls.ShiftCB:SetScript("OnClick", function(s) if s:GetChecked() then modif.SHIFT = "SHIFT-" else modif.SHIFT = "" end addon.RefreshKeys() end)
Controls.ShiftCB:SetSize(20, 20)


Controls.CtrlCB = CreateFrame("CheckButton", "KeyBindCtrlCB", Controls, "ChatConfigCheckButtonTemplate");
_G[Controls.CtrlCB:GetName().."Text"]:SetText ("Ctrl")
Controls.CtrlCB:SetHitRectInsets(0,-40,0,0)
Controls.CtrlCB:SetPoint("TOPLEFT", Controls, "TOPLEFT", 10, -100)
Controls.CtrlCB:SetScript("OnClick", function(s) if s:GetChecked() then modif.CTRL = "CTRL-" else modif.CTRL = "" end addon.RefreshKeys() end)
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





local function ColorHighlight(button) --change the colour of the highlight texture depending on the type of keybind
	if not button.type then KBTooltip:Hide() return end
	button:SetBackdropBorderColor(1,1,1,1)
	if button.type == "spell" then
		button:SetBackdropBorderColor(0,1,0,1)
	elseif button.type == "macro" then
		button:SetBackdropBorderColor(0,0,1,1)
	elseif button.type == "interface" then
		button:SetBackdropBorderColor(1,0,1,1)
	elseif button.type == "item" then
		button:SetBackdropBorderColor(0.5,0.5,1,1)
	elseif button.type =="none" then
		button:SetBackdropBorderColor(1,1,1,1)
	end

	KBTooltip:Hide()
	GameTooltip:Hide()
end

local function ButtonMouseOver(button) --change the tooltip and highlight

	KBTooltip:SetPoint("TOPLEFT", button, "TOPRIGHT", 10, 0)
	KBTooltip.title:SetText((button.label:GetText() or "")..":\n"..(button.macro:GetText() or ""))
	if button.slot then
		--KBTooltip:SetAction(button.slot)
		GameTooltip:SetOwner(button, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", button, "BOTTOMLEFT")
		GameTooltip:SetAction(button.slot)

		GameTooltip:Show()
	end
	KBTooltip:SetWidth(KBTooltip.title:GetWidth()+10)
	KBTooltip:SetHeight(KBTooltip.title:GetHeight()+10)

	if (KBTooltip:GetWidth() < 15) or button.macro:GetText() == "" then
		KBTooltip:Hide()
	else
		KBTooltip:Show()
	end

end


local function NewButton(parent) -- creates new buttons to add the the keyboard
	if not parent then parent = Keyboard end
	local button = CreateFrame("Frame", nil, parent) -- parent it to the keyboard
	button:SetMovable(true)
	button:EnableMouse(true)

	button:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
	button:SetBackdropColor(0,0,0,0.8);
	button.label = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	button.label:SetFont("Fonts\\ARIALN.TTF", 15 )
	button.label:SetTextColor(1,1,1,0.7)
	button.label:SetHeight(50)
	button.label:SetPoint("TOPLEFT", button, "TOPLEFT", 7,  -7)
	button.label:SetPoint("RIGHT", button, "RIGHT", -7,  0)
	button.label:SetJustifyH("LEFT")
	button.label:SetJustifyV("TOP")
	button.macro = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")

	button.macro:SetJustifyH("RIGHT")
	button.macro:SetJustifyV("BOTTOM")
	button.macro:SetNonSpaceWrap(true)
	button.macro:SetPoint("TOPLEFT", button, "TOPLEFT", 15, -15)
	button.macro:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -15, 15)
	button.macro:SetText("")


	button.icon = button:CreateTexture()
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 5, -5)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -5, 5)
	button.icon:SetDrawLayer("BACKGROUND")
	button.icon:SetAlpha(0.8)
	button:SetScript("OnEnter", ButtonMouseOver)
	button:SetScript("OnLeave", ColorHighlight)
	button:SetScript("OnMouseDown",function() end)
	button:SetScript("OnMouseUp",function(self, mousebutton)
													if mousebutton == "LeftButton" then
														infoType, info1, info2 = GetCursorInfo()

														if infoType == "spell" then
															local spellname = GetSpellBookItemName(info1, info2 )
														SelectedFrame = self
														--print(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), spellname)
															SetBindingSpell(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), spellname)
															ClearCursor()
															SaveBindings(2)
															addon.RefreshKeys()
														end
													elseif mousebutton == "RightButton" then
														SelectedFrame = self
														ToggleDropDownMenu(1, nil, KBDropDown, self, 30, 20)

													end
												end)
		return button
end

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




local function SwitchBoard(board)
	if KeyBindAllBoards[board] or KBEditLayouts[board] then
		board = KeyBindAllBoards[board] or KBEditLayouts[board]

		local cx, cy = Keyboard:GetCenter()
		local left, right, top, bottom = cx, cx, cy, cy

		for i = 1, #board do

			local Key = Keys[i] or NewButton()

			if board[i][5] then
				Key:SetWidth(board[i][5])
				Key:SetHeight(board[i][6])
			else
				Key:SetWidth(85)
				Key:SetHeight(85)
			end


			if not Keys[i] then
				Keys[i] = Key
			end

			Key:SetPoint("TOPLEFT", Keyboard, "TOPLEFT", board[i][3], board[i][4])

			Key.label:SetText(board[i][1])
			tempframe = Key
			tempframe:Show()

			local l, r, t, b = Key:GetLeft(), Key:GetRight(), Key:GetTop(), Key:GetBottom()

			if l < left then
				left = l
			end
			if r > right then
				right = r
			end
			if t > top then
				top = t
			end
			if b < bottom then
				bottom = b
			end
		end

		Keyboard:SetWidth(right-left + 15)
		Keyboard:SetHeight(top-bottom+ 10)

	end

end

local function CheckModifiers()
	for v, button in pairs(Keys) do --change the events for shift/ctrl/alt
		if modif[button.label:GetText()] then

			button:SetScript("OnEnter", nil)
			button:SetScript("OnLeave", nil)
			button:SetScript("OnMouseDown", nil)
			button:SetScript("OnMouseUp", nil)

			button:SetScript("OnMouseDown", function(self)  end)
			button:SetScript("OnEnter", function(self)  end)


			button:SetScript("OnLeave", function(self)
											if self.active then

											else

											end
										end)
			button:SetScript("OnMouseUp", function(self)
										if self.active then
											self.active = false
											modif[button.label:GetText()] = ""
											addon.RefreshKeys()

										else
											self.active = true
											modif[button.label:GetText()] = button.label:GetText().."-"
											addon.RefreshKeys()

										end
								end)
		end
	end
end

local function SetKey(button) -- set the texture/text for the key
	local spell = GetBindingAction(modif.CTRL..modif.SHIFT..modif.ALT..(button.label:GetText() or "")) or ""

	if spell:find("^SPELL") then
		button.icon:Show()
		spell = spell:match("SPELL%s(.*)")
		button.icon:SetTexture(GetSpellTexture(spell))
		button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.type = "spell"
		ColorHighlight(button)
	elseif spell:find("^MACRO") then
		button.icon:Show()
		spell = spell:match("MACRO%s(.*)")
		button.icon:SetTexture(select(2, GetMacroInfo(spell)))
		button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.type = "macro"
		ColorHighlight(button)
	elseif spell:find("^ITEM") then
		button.icon:Show()
		spell = spell:match("ITEM%s(.*)")
		button.icon:SetTexture(select(10, GetItemInfo(spell)))
		button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.type = "item"
		ColorHighlight(button)
	else
		button.icon:Hide()
		local found = false
		for i = 1, GetNumBindings() do
		local a = GetBinding(i)
			if spell:find(a) then

				local slot = spell:match("ACTIONBUTTON(%d+)") or spell:match("BT4Button(%d+)")

				if slot then
					button.icon:SetTexture(GetActionTexture(slot))
					button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					button.icon:Show()
					button.slot = slot
					--tooltip
				end
				spell = GetBindingText(spell, "BINDING_NAME_") or spell
				button.type = "interface"
				ColorHighlight(button)

				found = true

				--break -- ?
			end
		end
		if not found then
			button.type = "none"
			ColorHighlight(button)

		end
	end
	button.macro:SetText(spell)
end

function addon.RefreshKeys() --refresh all the highlights and text for the buttons
	for i = 1, #Keys do
		Keys[i]:Hide()
	end

	SwitchBoard(KeyBindSettings.currentboard or DefaultBoard)
	CheckModifiers()


	for i = 1, #Keys do
		SetKey(Keys[i])
	end

	for i = 1, 5 do
		SetKey(Mouse["Button"..i])
	end
end



--dropdown stuffs:



local DropDown = CreateFrame("Frame", "KBDropDown", Keyboard, "UIDropDownMenuTemplate")
DropDown:SetPoint("CENTER")
UIDropDownMenu_SetWidth(DropDown, 65)
UIDropDownMenu_SetButtonWidth(DropDown, 20)
DropDown:Hide()


local function DropDown_Initialize(self, level) -- the menu items, needs a cleanup
	level = level or 1
	local info = UIDropDownMenu_CreateInfo()
	local value = UIDROPDOWNMENU_MENU_VALUE

	if level == 1 then
		info.text = "Unbind Key"
		info.value = 1
		info.tooltipTitle = "Unbind"
		info.tooltipText = "Removes all bindings from the selected key"
		info.func = function()
								if SelectedFrame.label ~= "" then
									SetBinding(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""))
									SelectedFrame.macro:SetText("")
									addon.RefreshKeys()
									SaveBindings(2)
								end
							end
		UIDropDownMenu_AddButton(info, level)

		info.text = "General Macro"
		info.value = "General Macro"
		info.tooltipTitle = "Macro"
		info.tooltipText = "Bind the selected key to a general macro"
		info.hasArrow = true
		info.func = function() end
		UIDropDownMenu_AddButton(info, level)

			info.text = "Player Macro"
		info.value = "Player Macro"
		info.tooltipTitle = "Macro"
		info.tooltipText = "Bind the selected key to a player-specific macro"
		info.hasArrow = true
		info.func = function() end
		UIDropDownMenu_AddButton(info, level)

		info.text = "Spell"
		info.value = "Spell"
		info.tooltipTitle = "Spell"
		info.tooltipText = "Bind the selected key to a spell"
		info.hasArrow = true
		info.func = function() end
		UIDropDownMenu_AddButton(info, level)

		info.text = "UI Bind"
		info.value = "UIBind"
		info.tooltipTitle = "UI Bind"
		info.tooltipText = "Bind the selected key to an interface action"
		info.hasArrow = true
		info.func = function() end
		UIDropDownMenu_AddButton(info, level)

		info.text = "Items"
		info.value = "Bag"
		info.tooltipTitle = "Items"
		info.tooltipText = "Bind the selected key to an item in your bag"
		info.hasArrow = true
		info.func = function() end
		UIDropDownMenu_AddButton(info, level)

		info.text = "Mounts/pets"
		info.value = "MountPet"
		info.tooltipTitle = "Mounts & Pets"
		info.tooltipTxt = "Bind the selected key to a mount or pet"
		info.hasArrow = true
		info.func = function() end
		UIDropDownMenu_AddButton(info, level)

	elseif level ==2 then
		if value == "Spell" then
			for i = 1, GetNumSpellTabs() do
				local name, texture, offset, numSpells = GetSpellTabInfo(i);
				if not name then
					--break
				end

				info.text = name
				info.value = "Tab"..i
				info.tooltipTitle = name
				info.hasArrow = true
				info.func = function() end
				UIDropDownMenu_AddButton(info, level)
			end
		end

		if value == "MountPet" then
			info.text = "Mount"
			info.value = "MOUNT"
			info.hasArrow = true
			UIDropDownMenu_AddButton(info, level)

			info.text = "Pet"
			info.value = "CRITTER"
			info.hasArrow = true
			UIDropDownMenu_AddButton(info, level)
		end


		if value == "General Macro" then
			for i = 1,36 do
			local title, iconTexture, body = GetMacroInfo(i)
				if title then
				info.text = title
				info.value = title
				info.tooltipTitle = title
				info.tooltipText = body
				info.hasArrow = false
				info.func = function(self) SetBindingMacro(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), title) SaveBindings(2) addon.RefreshKeys() end
				UIDropDownMenu_AddButton(info, level)
				end

			end
		end

		if value == "Player Macro" then
			for i = 37, 54 do
			local title, iconTexture, body = GetMacroInfo(i)
				if title then
				info.text = title
				info.value = title
				info.tooltipTitle = title
				info.tooltipText = body
				info.hasArrow = false
				info.func = function(self) SetBindingMacro(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), title) SaveBindings(2) addon.RefreshKeys() end
				UIDropDownMenu_AddButton(info, level)
				end
			end
		end

		if value == "UIBind" then
			for i = 1, GetNumBindings() do
				local name, bind = GetBinding(i)

				if name:find("^HEADER") then
					local title = _G["BINDING_"..name]
					if title and not (title == "") then
						info.text = title
						info.value = "UIBind"..i
						info.tooltipTitle = title
						info.tooltipText = "Actions related to "..title
						info.hasArrow = true
						info.func = function(self) end
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
		end

		if value == "Bag" then
			for bag = 0,NUM_BAG_SLOTS do
				local name = GetBagName(bag)

				info.text = name
				info.value = "bag"..bag
				info.tooltipTitle = name
				info.tooltipText = ""
				info.hasArrow = true
				info.func = function(self) end
				UIDropDownMenu_AddButton(info, level)
			end
		end
	elseif level == 3 then
		if value:find("Tab") then
			for i = 1, GetNumSpellTabs() do
				if value == "Tab"..i then
					local temp, texture, offset, numSlots = GetSpellTabInfo(i);
					for j = offset+1, (offset+numSlots) do
						local spellName, spellSubName = GetSpellBookItemName(j, BOOKTYPE_SPELL)
							if spellName and not (IsPassiveSpell(j, BOOKTYPE_SPELL)) then
								info.text = spellName
								info.value = spellName
								info.hasArrow = false
								info.func = function(self) SetBindingSpell(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), spellName) SaveBindings(2) addon.RefreshKeys() end
								UIDropDownMenu_AddButton(info, level)
							end
					end
				end
			end
		elseif value:find("bag") then
			local bag = value:match("bag(%d)")
			for slot = 1,GetContainerNumSlots(bag) do
				local item = GetContainerItemLink(bag, slot)
				local texture = GetContainerItemInfo(bag,slot)
				if IsUsableItem(item) then
					info.text = item
					info.value = bag
					info.tooltipTitle = item
					info.tooltipText = item
					info.hasArrow = false
					info.func = function(self) SetBindingItem(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), item) SaveBindings(2) addon.RefreshKeys() end
					UIDropDownMenu_AddButton(info, level)
				end
			end

		elseif value:find("^UIBind") then
		local value = value:match("^UIBind(%d+)")
			for i = tonumber(value), GetNumBindings() do
			i = i + 1
				local name, bind = GetBinding(i)

				if name:find("^HEADER") then
				return end
				local title = name
					info.text = GetBindingText(title, "BINDING_NAME_")
					info.value = j
					info.tooltipTitle = title
					info.tooltipText = "Actions related to "..title
					info.hasArrow = false
					info.func = function(self) SetBinding(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), title) SaveBindings(2) addon.RefreshKeys() end
					UIDropDownMenu_AddButton(info, level)
			end
		elseif value:find("^MOUNT") then
			local mountIDs = C_MountJournal.GetMountIDs()
			for k,mountID in pairs(mountIDs) do
				local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected, mountID = C_MountJournal.GetMountInfoByID(mountID)
				local name = GetSpellInfo(spellID)

				info.text = creatureName
				info.value = i
				info.tooltipTitle = creatureName
				info.tooltipText = "Actions related to "
				info.hasArrow = false
				info.func = function(self) SetBindingSpell(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), name) SaveBindings(2) addon.RefreshKeys() end
				UIDropDownMenu_AddButton(info, level)
			end
		elseif value:find("^CRITTER") then
			for i = 1, C_PetBattles.GetNumPets() do
				local creatureID, creatureName, spellID, icon =   C_PetJournal.GetPetInfoByIndex(i)
					local name = spellID

					info.text = creatureName
					info.value = i
					info.tooltipTitle = creatureName
					info.tooltipText = "Actions related to "
					info.hasArrow = false
					info.func = function(self) SetBindingSpell(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), name) SaveBindings(2) addon.RefreshKeys() end
					UIDropDownMenu_AddButton(info, level)

			end
		end
	end
end

--IsPassiveSpell(spellID, "bookType")


UIDropDownMenu_Initialize(DropDown, DropDown_Initialize, "MENU")



local function KeyHandler(self, key)
	if modif[key] then
		for v, button in pairs(Keys) do
			if modif[button.label:GetText()] then
				if button.active then
					button.active = false
					modif[button.label:GetText()] = ""
					addon.RefreshKeys()

				else
					button.active = true
					modif[button.label:GetText()] = button.label:GetText().."-"
					addon.RefreshKeys()

				end
			end
		end
	end
end




local KBChangeBoardDDD = CreateFrame("Frame", "KBChangeBoardDD", Controls, "UIDropDownMenuTemplate")
KBChangeBoardDD:SetPoint("TOPLEFT", 0, -10)
UIDropDownMenu_SetWidth(KBChangeBoardDD, 100)
UIDropDownMenu_SetButtonWidth(KBChangeBoardDD, 100)



local function ChangeBoardDD_Initialize(self, level) -- the menu items, needs a cleanup
		level = level or 1
	local info = UIDropDownMenu_CreateInfo()
	local value = UIDROPDOWNMENU_MENU_VALUE

	info.colorCode = "|cFF31BD22"
	for name, buttons in pairs(KeyBindAllBoards) do
		info.text = name
		info.value = name
		info.func = function() KeyBindSettings.currentboard = name addon.RefreshKeys() UIDropDownMenu_SetText(self, name) end
		UIDropDownMenu_AddButton(info, level)
	end


	info.colorCode = "|cFFFFFFFF"
	if KBEditLayouts then
		for name in pairs(KBEditLayouts) do
			info.text = name

			--set color
			info.value = name
			info.func = function() KeyBindSettings.currentboard = name addon.RefreshKeys() UIDropDownMenu_SetText(self, name) end
			UIDropDownMenu_AddButton(info,level)
		end
	end
end


UIDropDownMenu_Initialize(KBChangeBoardDD, ChangeBoardDD_Initialize)

local KeyCheck = CreateFrame("Frame")
KeyCheck:EnableKeyboard(true)
--KeyCheck:SetScript("OnKeyDown", KeyHandler)

local function battlecheck(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		fighting = true
		Keyboard:Hide()
	elseif event == "PLAYER_REGEN_ENABLED" then
		fighting = false
	elseif event == "PLAYER_TARGET_CHANGED" then
		--addon.RefreshKeys()
	end
end

local SpecCheck = CreateFrame("Frame")
SpecCheck:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
SpecCheck:SetScript("OnEvent", function(self, spec) end)

local EventCheck = CreateFrame("Frame")
EventCheck:RegisterEvent("PLAYER_REGEN_ENABLED")
EventCheck:RegisterEvent("PLAYER_REGEN_DISABLED")
EventCheck:RegisterEvent("PLAYER_TARGET_CHANGED")
EventCheck:SetScript("OnEvent", battlecheck)




Keyboard:HookScript("OnShow", addon.RefreshKeys)

SLASH_KeyBind1 = "/kb";
SLASH_KeyBind2 = "/keybind";
SlashCmdList["KeyBind"] = function() if not fighting then Controls:Show() Keyboard:Show() end end
Keyboard:SetScale(1)
Keyboard:Hide()
