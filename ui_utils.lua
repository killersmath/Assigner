function Assigner.ui:CreateRaidTargetTexture(parent, pos, iconName)
  local texture = parent:CreateTexture("Texture", "Background")
  texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
  texture:SetPoint("TOPLEFT", pos.x, pos.y)
  texture:SetWidth(20)
  texture:SetHeight(20)
  texture:SetTexCoord(unpack(Assigner.constants.RAID_TARGETS_TCOORDS[iconName]))
  return texture
end

function Assigner.ui:CreateNormalText(parent, pos, displayText)
  local text = parent:CreateFontString(parent, "OVERLAY", "GameFontHighlightSmall")
  text:SetPoint("TOPLEFT", pos.x, pos.y)
  text:SetText(displayText)
  return text
end

function Assigner.ui:CreateCheckButton(parent, name, pos, displayText, onClick)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
  local checkButton = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
  checkButton.text = getglobal(name.."Text")
  checkButton.text:SetText(displayText)
	checkButton:SetPoint(pos.anchor, pos.x, pos.y)
	checkButton:SetHeight(30)
	checkButton:SetWidth(30)
  checkButton:SetScript("OnClick", onClick)
  --[[
  checkButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  checkButton:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
    GameTooltip:SetText("Test 1",1.0, 0.82, 0.0, 1,1)
    GameTooltip:AddLine("Test 2", 0.82, 1.0, 0.0);
    GameTooltip:Show()
  end)
  --]]
  return checkButton
end

function Assigner.ui:CreateButton(parent, name, pos, size, displayText, onClick)
  local button = CreateFrame("Button", name , parent ,"UIPanelButtonTemplate")
  if (pos ~= nil) then
    if( not pos.anchor) then pos.anchor = "TOPLEFT" end
    button:SetPoint(pos.anchor,pos.x,pos.y)
  end
  button:SetWidth(size.w)
  button:SetHeight(size.h)
  button:SetText(displayText)
  button:SetScript("OnClick", onClick)
  return button
end

function Assigner.ui:CreateEditBox(parent, name, pos, size, displayText)
  local editBox = CreateFrame("EditBox", nil, parent ,"InputBoxTemplate")
  if (pos ~= nil) then
    if( not pos.anchor) then pos.anchor = "TOPLEFT" end
    editBox:SetPoint(pos.anchor,pos.x,pos.y)
  end
  editBox:SetWidth(size.w)
  editBox:SetHeight(size.h)
	editBox:SetAutoFocus(nil)
  return editBox
end