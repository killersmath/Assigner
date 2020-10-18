function Assigner.ui:CreateRaidTargetTexture(parent, pos, targetName)
  local texture = parent:CreateTexture("Texture", "Background")
  texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
  texture:SetPoint("TOPLEFT", pos.x, pos.y) -- this is relative to the frame created above, unless an anchor frame is given
  texture:SetWidth(30)
  texture:SetHeight(30)
  texture:SetTexCoord(unpack(Assigner.constants.RAID_TARGETS_TCOORDS[targetName]))
  return texture
end

function Assigner.ui:CreateNormalText(parent, pos, text)
  local textFrame = parent:CreateFontString(parent, "OVERLAY", "GameFontHighlightSmall")
  textFrame:SetPoint("TOPLEFT", pos.x, pos.y)
  textFrame:SetText(text)
  --textFrame:SetFont("Fonts\\FRIZQT__.TTF", 9)
  return textFrame
end

function Assigner.ui:CreateCheckButtonWithText(parent, name, pos, displayText, onClick)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
  local checkButton = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
	checkButton:SetPoint(pos.anchor, pos.x, pos.y)
	checkButton:SetHeight(30)
	checkButton:SetWidth(30)
	checkButton:SetScript("OnClick", onClick)
  getglobal(name.."Text"):SetText(displayText)
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

function Assigner.ui:CreateOptionsButton(parent, name, pos, displayText, anchorFrame)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
	local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
	button:SetPoint("TOPLEFT", anchorFrame, pos.anchor, pos.x, pos.y)
	button:SetHeight(35)
	button:SetWidth(150)
	button:SetText(text)
	button:SetScript("OnClick", Assigner.ui.OnPageSwitch)
	button.id = id
	return button
end