
--[[

TODO:
multiple spec
resize based on board
mouse
--]]


local name, addon = ...

KeyBindSettings = {}

local fighting = false -- if the player is in combat or not
local Keys = {} --stores the key buttons once they are created

local DefaultBoard = KeyBindAllBoards.laptop

local SelectedFrame = nil --hack for the dropdown
local modif = {} --table that stores the modifiers
modif.CTRL = ""
modif.SHIFT = ""
modif.ALT = ""

addon.modif = modif

function addon:Load()
	if fighting then
		print('disabled in combat')
		return
	end


	local keyboard = self.keyboardFrame or self:CreateKeyboard()
	local mouse = self.mouseFrame or self:CreateMouseUI()
	local controls = self.controlsFrame or self:CreateControls()
	local dropdown = self.dropdown or self:CreateDropDown()
	local tooltip = self.tooltip or self:CreateTooltip()
	self.ddChanger = self.ddChanger or self:CreateChangerDD()
	controls:Show()
	keyboard:Show()
	self:LoadMounts()
	self:RefreshKeys()
end

function addon:LoadMounts()
	self.mounts = {}
	self.favMounts = {}
	self.mountCategories = {}
	local mountIDs = C_MountJournal.GetMountIDs()
	self.alphMounts = {}

	for _,mountID in pairs(mountIDs) do
		local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID)
		local mountInfo = {
			creatureName = creatureName,
			spellID = spellID,
			icon = icon,
			active = active,
			isUsable = isUsable,
			sourceType = sourceType,
			isFavorite = isFavorite,
			mountID = mountID
		}
		self.mounts[mountID] = mountInfo
		if isFavorite then
			self.favMounts[mountID] = true
		end
		local mountLetter = creatureName:sub(1,1)
		self.alphMounts[mountLetter] = self.alphMounts[mountLetter] or {}
		if not self.alphMounts[mountLetter][mountID] then
			self.alphMounts[mountLetter][mountID] = true
		end
		if not self.mountCategories[sourceType] then
			self.mountCategories[sourceType] = true
			print(sourceType)
		end
	end
end

function addon:GetKeyboard()
	return self.keyboardFrame
end


function addon:ColorHighlight(button) --change the colour of the highlight texture depending on the type of keybind
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

	self.tooltip:Hide()
	GameTooltip:Hide()
end

function addon:ButtonMouseOver(button) --change the tooltip and highlight
	local KBTooltip = self.tooltip
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





function addon:SwitchBoard(board)
	if KeyBindAllBoards[board] or KBEditLayouts[board] then
		board = KeyBindAllBoards[board] or KBEditLayouts[board]

		local cx, cy = self.keyboardFrame:GetCenter()
		local cx, cy = self.keyboardFrame:GetCenter()
		local left, right, top, bottom = cx, cx, cy, cy

		for i = 1, #board do

			local Key = Keys[i] or self:NewButton()

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

			Key:SetPoint("TOPLEFT", self.keyboardFrame, "TOPLEFT", board[i][3], board[i][4])
			Key:SetPoint("TOPLEFT", self.keyboardFrame, "TOPLEFT", board[i][3], board[i][4])

			Key.label:SetText(board[i][1])
			local tempframe = Key
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

		self.keyboardFrame:SetWidth(right-left + 15)
		self.keyboardFrame:SetWidth(right-left + 15)
		self.keyboardFrame:SetHeight(top-bottom+ 10)
		self.keyboardFrame:SetHeight(top-bottom+ 10)

	end

end

function addon:CheckModifiers()
	for v, button in pairs(Keys) do --change the events for shift/ctrl/alt
		if self.modif[button.label:GetText()] then

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
											addon:RefreshKeys()

										else
											self.active = true
											modif[button.label:GetText()] = button.label:GetText().."-"
											addon:RefreshKeys()

										end
								end)
		end
	end
end

function addon:SetKey(button) -- set the texture/text for the key
	local spell = GetBindingAction(modif.CTRL..modif.SHIFT..modif.ALT..(button.label:GetText() or "")) or ""

	if spell:find("^SPELL") then
		button.icon:Show()
		spell = spell:match("SPELL%s(.*)")
		button.icon:SetTexture(GetSpellTexture(spell))
		button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.type = "spell"
	elseif spell:find("^MACRO") then
		button.icon:Show()
		spell = spell:match("MACRO%s(.*)")
		button.icon:SetTexture(select(2, GetMacroInfo(spell)))
		button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.type = "macro"
	elseif spell:find("^ITEM") then
		button.icon:Show()
		spell = spell:match("ITEM%s(.*)")
		button.icon:SetTexture(select(10, GetItemInfo(spell)))
		button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.type = "item"
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
				self:ColorHighlight(button)

				found = true

				--break -- ?
			end
		end
		if not found then
			button.type = "none"


		end
	end
	self:ColorHighlight(button)
	button.macro:SetText(spell)
end


function addon:RefreshKeys() --refresh all the highlights and text for the buttons

	for i = 1, #Keys do
		Keys[i]:Hide()
	end

	self:SwitchBoard(KeyBindSettings.currentboard or DefaultBoard)
	self:CheckModifiers()


	for i = 1, #Keys do
		self:SetKey(Keys[i])
	end

	for i = 1, 5 do
		self:SetKey(self.mouseFrame["Button"..i])
	end
end



--dropdown stuffs:

local function LoadDropDownMounts(info, value, level)
	local i = 1
	local mountList = value:find("^FAVMOUNT") and addon.favMounts or addon.mounts
	if value:find("^ALPHMOUNT:") then
		local alph = value:match("^ALPHMOUNT:(.+)")
		print(alph)
		mountList = addon.alphMounts[alph]
	end
	for mountID,_ in pairs(mountList) do
		local mount = addon.mounts[mountID]
		info.text = mount.creatureName
		info.value = i
		i = i +1
		info.tooltipTitle = mount.creatureName
		info.tooltipText = "Actions related to "
		info.hasArrow = false
		info.func = function(self) SetBindingSpell(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), mount.creatureName) SaveBindings(2) addon:RefreshKeys() end
		UIDropDownMenu_AddButton(info, level)

	end
end

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
									addon:RefreshKeys()
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
			info.text = "Fav Mounts"
			info.value = "FAVMOUNT"
			info.hasArrow = true
			UIDropDownMenu_AddButton(info, level)

			info.text = "Mount"
			info.value = "ALPHMOUNTS"
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
				info.func = function(self) SetBindingMacro(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), title) SaveBindings(2) addon:RefreshKeys() end
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
				info.func = function(self) SetBindingMacro(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), title) SaveBindings(2) addon:RefreshKeys() end
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
								info.func = function(self) SetBindingSpell(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), spellName) SaveBindings(2) addon:RefreshKeys() end
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
					info.func = function(self) SetBindingItem(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), item) SaveBindings(2) addon:RefreshKeys() end
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
					info.func = function(self) SetBinding(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), title) SaveBindings(2) addon:RefreshKeys() end
					UIDropDownMenu_AddButton(info, level)
			end

		elseif value:find('ALPHMOUNTS') then
			for k,v in pairs(addon.alphMounts) do
		   info.text = k
			 info.value = "ALPHMOUNT:"..k
			 info.hasArrow = true
			 UIDropDownMenu_AddButton(info, level)
			end

		elseif value:find("^MOUNT") or value:find("^FAVMOUNT") or value:find("^ALPHMOUNT:")then
			LoadDropDownMounts(info, value,level)
		elseif value:find("^CRITTER") then
			for i = 1, GetNumCompanions(value) do
				local creatureID, creatureName, spellID, icon =  GetCompanionInfo(value, i)
					local name = spellID

					info.text = creatureName
					info.value = i
					info.tooltipTitle = creatureName
					info.tooltipText = "Actions related to "
					info.hasArrow = false
					info.func = function(self) SetBindingSpell(modif.CTRL..modif.SHIFT..modif.ALT..(SelectedFrame.label:GetText() or ""), name) SaveBindings(2) addon:RefreshKeys() end
					UIDropDownMenu_AddButton(info, level)

			end
		end
	elseif level == 4 then
		if value:find('^ALPHMOUNT') then
			LoadDropDownMounts(info, value,level)
		end
	end
end



function addon:CreateDropDown()
	print(self.keyboardFrame)
	local DropDown = CreateFrame("Frame", "KBDropDown", self.keyboardFrame, "UIDropDownMenuTemplate")
	DropDown:SetPoint("CENTER")
	UIDropDownMenu_SetWidth(DropDown, 65)
	UIDropDownMenu_SetButtonWidth(DropDown, 20)
	DropDown:Hide()
	self.dropdown = DropDown
	UIDropDownMenu_Initialize(DropDown, DropDown_Initialize, "MENU")
	return DropDown
end


--IsPassiveSpell(spellID, "bookType")






local function KeyHandler(self, key)
	if modif[key] then
		for v, button in pairs(Keys) do
			if modif[button.label:GetText()] then
				if button.active then
					button.active = false
					modif[button.label:GetText()] = ""
					addon:RefreshKeys()

				else
					button.active = true
					modif[button.label:GetText()] = button.label:GetText().."-"
					addon:RefreshKeys()

				end
			end
		end
	end
end




function addon:CreateChangerDD()
	local Controls = self.controlsFrame
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
			info.func = function() KeyBindSettings.currentboard = name addon:RefreshKeys() UIDropDownMenu_SetText(self, name) end
			UIDropDownMenu_AddButton(info, level)
		end


		info.colorCode = "|cFFFFFFFF"
		if KBEditLayouts then
			for name in pairs(KBEditLayouts) do
				info.text = name

				--set color
				info.value = name
				info.func = function() KeyBindSettings.currentboard = name addon:RefreshKeys() UIDropDownMenu_SetText(self, name) end
				UIDropDownMenu_AddButton(info,level)
			end
		end
	end


	UIDropDownMenu_Initialize(KBChangeBoardDD, ChangeBoardDD_Initialize)
	self.ddChanger = KBChangeBoardDD
	return KBChangeBoardDD
end
local KeyCheck = CreateFrame("Frame")
KeyCheck:EnableKeyboard(true)
KeyCheck:EnableKeyboard(true)
--KeyCheck:SetScript("OnKeyDown", KeyHandler)

function addon:BattleCheck(event)
	if event == "PLAYER_REGEN_DISABLED" then
		fighting = true
		self.keyboardFrame:Hide()
		self.controlsFrame:Hide()
	elseif event == "PLAYER_REGEN_ENABLED" then
		fighting = false
	elseif event == "PLAYER_TARGET_CHANGED" then
		--addon:RefreshKeys()
	end
end

local SpecCheck = CreateFrame("Frame")
SpecCheck:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
SpecCheck:SetScript("OnEvent", function(self, spec) end)

local EventCheck = CreateFrame("Frame")
EventCheck:RegisterEvent("PLAYER_REGEN_ENABLED")
EventCheck:RegisterEvent("PLAYER_REGEN_DISABLED")
EventCheck:RegisterEvent("PLAYER_TARGET_CHANGED")
EventCheck:SetScript("OnEvent", function(self,event) addon:BattleCheck(event) end)


SLASH_KeyBind1 = "/kb";
SLASH_KeyBind2 = "/keybind";
SlashCmdList["KeyBind"] = function() addon:Load() end
