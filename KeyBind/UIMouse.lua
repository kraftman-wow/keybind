
local name, addon = ...
function addon:CreateMouseUI()

  local Controls = self.controlsFrame
  local Mouse = CreateFrame("Frame", nil, Controls)


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


  Mouse.Button1 = addon:NewButton(Mouse)
  Mouse.Button1.label:SetText("BUTTON1")
  Mouse.Button1:SetSize(50, 50)
  Mouse.Button1:SetPoint("TOPLEFT", -16, 90)

  Mouse.Button2 = addon:NewButton(Mouse)
  Mouse.Button2.label:SetText("BUTTON2")
  Mouse.Button2:SetSize(50, 50)
  Mouse.Button2:SetPoint("TOPLEFT", 184, 97)

  Mouse.Button3 = addon:NewButton(Mouse)
  Mouse.Button3.label:SetText("BUTTON3")
  Mouse.Button3:SetSize(50, 50)
  Mouse.Button3:SetPoint("TOPLEFT", 88, 128)

  Mouse.Button4 = addon:NewButton(Mouse)
  Mouse.Button4.label:SetText("BUTTON4")
  Mouse.Button4:SetSize(50, 50)
  Mouse.Button4:SetPoint("TOPLEFT", -56, -56)

  Mouse.Button5 = addon:NewButton(Mouse)
  Mouse.Button5.label:SetText("BUTTON5")
  Mouse.Button5:SetSize(50, 50)
  Mouse.Button5:SetPoint("TOPLEFT", -48, -141)

addon.mouseFrame = Mouse
return Mouse
end
