function Assigner.ui:CreateIconTexture(parent, pos, textCoords)
  local texture = parent:CreateTexture("Texture", "Background")
  texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
  texture:SetPoint("TOPLEFT", pos.x, pos.y) -- this is relative to the frame created above, unless an anchor frame is given
  texture:SetWidth(30)
  texture:SetHeight(30)
  texture:SetTexCoord(textCoords.left, textCoords.right, textCoords.top, textCoords.bottom)
  return texture
end

function Assigner.ui:CreateNormalText(parent, pos, text)
  local textFrame = parent:CreateFontString(parent, "OVERLAY", "GameFontHighlightSmall")
  textFrame:SetPoint("TOPLEFT", pos.x, pos.y)
  textFrame:SetText(text)
  --textFrame:SetFont("Fonts\\FRIZQT__.TTF", 9)
  return textFrame
end

function Assigner.ui:CreateCheckButtonWithText(parent, globalName, pos, displayName, onClick)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
  local checkButton = CreateFrame("CheckButton", globalName, parent, "UICheckButtonTemplate")
	checkButton:SetPoint(pos.anchor, pos.x, pos.y)
	checkButton:SetHeight(30)
	checkButton:SetWidth(30)
	checkButton:SetScript("OnClick", onClick)
  getglobal(globalName.."Text"):SetText(displayName)
  return checkButton
end

function Assigner.ui:CreateButton(parent, pos, size, displayText, onClick)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
  local button = CreateFrame("Button",nil, parent ,"UIPanelButtonTemplate")
  button:SetPoint(pos.anchor,pos.x,pos.y)
  button:SetWidth(size.w)
  button:SetHeight(size.h)
  button:SetText(displayText)
  button:SetScript("OnClick", onClick)
  return button
end

function Assigner.ui:CreateEditBox(parent, pos, size, displayText)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
  local editBox = CreateFrame("EditBox", nil, parent ,"InputBoxTemplate")
	editBox:SetPoint(pos.anchor,pos.x,pos.y)
	editBox:SetWidth(size.w)
	editBox:SetHeight(size.h)
	editBox:SetAutoFocus(nil)
  return editBox
end

function Assigner.ui:CreateOptionsButton(id, name, text, anchorFrame, pos)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
	local button = CreateFrame("Button", name, Assigner.ui.frame, "UIPanelButtonTemplate")
	button:SetPoint("TOPLEFT", anchorFrame, pos.anchor, pos.x, pos.y)
	button:SetHeight(35)
	button:SetWidth(150)
	button:SetText(text)
	button:SetScript("OnClick", Assigner.ui.OnPageSwitch)
	button.id = id
	return button
end