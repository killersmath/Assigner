Assigner.ui = {}

function Assigner:CreateWindow()
  self.ui:InitializeUi()
  self.ui:PopulateUi()
end

function Assigner.ui:InitializeUi()
  ---------------
  -- Main Frame
  ---------------
  self.mainFrame = CreateFrame("Frame", nil, UIParent)
  self.mainFrame:SetFrameStrata("BACKGROUND")
  self.mainFrame:SetWidth(440) -- Set these to whatever height/width is needed 
  self.mainFrame:SetHeight(516) -- for your Texture
  self.mainFrame:SetPoint("CENTER", 0, 0)
  self.mainFrame:EnableMouse(true)
  self.mainFrame:SetMovable(true)
  self.mainFrame:RegisterForDrag("LeftButton")
  self.mainFrame:SetScript("OnDragStart", function () self.mainFrame:StartMoving() end)
  self.mainFrame:SetScript("OnDragStop", function () self.mainFrame:StopMovingOrSizing() end)
  self.mainFrame:SetScript("OnHide", function () self.mainFrame:StopMovingOrSizing() end)
  self.mainFrame:SetBackdrop({ 
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    --edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
    tile = true,
    tileSize = 32,  
    --edgeSize = 35, 
    insets = { left = 6, right = 6, top = 6, bottom = 6 } })
  self.mainFrame:SetBackdropColor( 0, 0, 0, .9)

  ---------------
  -- Top Title
  ---------------

  -- Frame
  self.topTitleFrame = CreateFrame("Frame", nil, self.mainFrame)
  self.topTitleFrame:SetWidth(210)
  self.topTitleFrame:SetHeight(40)
  self.topTitleFrame:SetPoint("TOP", self.mainFrame, "TOP", 0, 26)
  self.topTitleFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    edgeSize = 30,
    insets = { left = 4, right = 4, top = 3, bottom = 4 }
  })
  self.topTitleFrame:SetBackdropColor(0.265,0.265,0.265,1)
  -- Text
  self.topTitleFrame.text = self.topTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.topTitleFrame.text:SetWidth(200)
  self.topTitleFrame.text:SetJustifyH("CENTER")
  self.topTitleFrame.text:SetText("|cFF006699Assigner|r 1.0")
  self.topTitleFrame.text:SetPoint("CENTER", self.topTitleFrame, "CENTER", 0, 1.5)

  ---------------
  -- Top Menu Bar
  ---------------

  -- Frame
  self.topMenuBarFrame = CreateFrame("Frame", nil, self.mainFrame)
  self.topMenuBarFrame:SetWidth(420)
  self.topMenuBarFrame:SetHeight(105)
  self.mainFrame:SetFrameStrata("BACKGROUND")
  self.topMenuBarFrame:SetPoint("TOPLEFT", 10, -10)
  self.topMenuBarFrame:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground",})
  self.topMenuBarFrame:SetBackdropColor(33/255, 37/255, 43/255)

  self.shortAnnounceCheckBox = self:CreateCheckButtonWithText(self.topMenuBarFrame, {x=0, y=0}, "Short Announce", self.OnShortAnnounceCheckBox)
  
  -- reset assigns
  self.resetAssigns = self:CreateButton(self.topMenuBarFrame, {x=10, y=-38}, {w=140, h=30}, "Reset Assigns", Assigner.ui.ResetAssigns)

  -- send button
  self.sendButton = self:CreateButton(self.topMenuBarFrame, {x=10, y=-70}, {w=140, h=30}, "Send Assigment", Assigner.PostAssignement)

  -- channel type
  self:CreateNormalText(self.topMenuBarFrame, {x=310, y=-7}, "Channel"):SetFont("Fonts\\FRIZQT__.TTF", 15)

  self.channelTypeRaidCheckBox = self:CreateCheckButtonWithText(self.topMenuBarFrame, {x=245, y=-23}, "Raid", self.OnChannelTypeRaidCheckBoxClicked)
  self.channelTypeRaidWarningCheckBox = self:CreateCheckButtonWithText(self.topMenuBarFrame, {x=245, y=-48}, "Raid Warning", self.OnChannelTypeRaidWarningCheckBoxclicked)
  self.channelTypeCustomCheckBox = self:CreateCheckButtonWithText(self.topMenuBarFrame, {x=245, y=-74}, "Custom Channel", self.OnChannelTypeCustomCheckBoxClicked)
  
  self.channelEditBox = self:CreateEditBox(self.topMenuBarFrame, {x=400,y=-75}, {w=15,h=30})
  self.channelEditBox:SetMaxLetters(1)
  self.channelEditBox:SetScript("OnTextChanged", self.OnChannelEditBoxTextChanged)
  
  ---------------
  ---- Middle Frame
  ---------------

  self.middleFrame = CreateFrame("Frame", nil, self.mainFrame)
  self.middleFrame:SetFrameStrata("BACKGROUND")
  self.middleFrame:SetWidth(420)
  self.middleFrame:SetHeight(387)
  self.middleFrame:SetPoint("TOPLEFT", 10, -120)
  --self.middleFrame:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground",})
  --self.middleFrame:SetBackdropColor(33/255, 37/255, 77/255)

  local iconFrame
  iconFrame = CreateFrame("Frame", nil, self.middleFrame)
  iconFrame:SetFrameStrata("Medium")
  iconFrame:SetWidth(30)
  iconFrame:SetHeight(90)
  iconFrame:SetPoint("TOPLEFT", 30, -8)

  -- Row 1 (Skull)
  self:CreateIconTexture(iconFrame, {x=0,y=0}, {left=0.75,right=1,top=0.25,bottom=0.5})
  self:CreateNormalText(self.middleFrame, {x=140,y=-2}, "Player 1")
  self:CreateDropDownPlayerMenu(self.middleFrame, 8, 1, {x=80,y=-16})
  self:CreateNormalText(self.middleFrame, {x=300,y=-2}, "Player 2")
  self:CreateDropDownPlayerMenu(self.middleFrame, 8, 2, {x=240,y=-16})

  -- Row 2 (Cross)
  self:CreateIconTexture(iconFrame, {x=0,y=-48}, {left=0.5,right=0.75,top=0.25,bottom=0.5})
  self:CreateNormalText(self.middleFrame, {x=140,y=-50}, "Player 1")
  self:CreateDropDownPlayerMenu(self.middleFrame, 7, 1, {x=80,y=-64})
  self:CreateNormalText(self.middleFrame, {x=300,y=-50}, "Player 2")
  self:CreateDropDownPlayerMenu(self.middleFrame, 7, 2, {x=240,y=-64})

  -- Row 3 (Square)
  self:CreateIconTexture(iconFrame, {x=0,y=-96}, {left=0.25,right=0.5,top=0.25,bottom=0.5})
  self:CreateNormalText(self.middleFrame, {x=140,y=-98}, "Player 1")
  self:CreateDropDownPlayerMenu(self.middleFrame, 6, 1, {x=80,y=-112})
  self:CreateNormalText(self.middleFrame, {x=300,y=-98}, "Player 2")
  self:CreateDropDownPlayerMenu(self.middleFrame, 6, 2, {x=240,y=-112})

  -- Row 4 (Triangle)
  self:CreateIconTexture(iconFrame, {x=0,y=-144}, {left=0.75,right=1,top=0,bottom=0.25})
  self:CreateNormalText(self.middleFrame, {x=140,y=-146}, "Player 1")
  self:CreateDropDownPlayerMenu(self.middleFrame, 4, 1, {x=80,y=-160})
  self:CreateNormalText(self.middleFrame, {x=300,y=-146}, "Player 2")
  self:CreateDropDownPlayerMenu(self.middleFrame, 4, 2, {x=240,y=-160})

  -- Row 4 (Diamond)
  self:CreateIconTexture(iconFrame, {x=0,y=-192}, {left=0.5,right=0.75,top=0,bottom=0.25})
  self:CreateNormalText(self.middleFrame, {x=140,y=-194}, "Player 1")
  self:CreateDropDownPlayerMenu(self.middleFrame, 3, 1, {x=80,y=-208})
  self:CreateNormalText(self.middleFrame, {x=300,y=-194}, "Player 2")
  self:CreateDropDownPlayerMenu(self.middleFrame, 3, 2, {x=240,y=-208})

  -- Row 5 (Moon)
  self:CreateIconTexture(iconFrame, {x=0,y=-240}, {left=0,right=0.25,top=0.25,bottom=0.5})
  self:CreateNormalText(self.middleFrame, {x=140,y=-242}, "Player 1")
  self:CreateDropDownPlayerMenu(self.middleFrame, 5, 1, {x=80,y=-256})
  self:CreateNormalText(self.middleFrame, {x=300,y=-242}, "Player 2")
  self:CreateDropDownPlayerMenu(self.middleFrame, 5, 2, {x=240,y=-256})

  -- Row 5 (Star)
  self:CreateIconTexture(iconFrame, {x=0,y=-288}, {left=0,right=0.25,top=0,bottom=0.25})
  self:CreateNormalText(self.middleFrame, {x=140,y=-290}, "Player 1")
  self:CreateDropDownPlayerMenu(self.middleFrame, 1, 1, {x=80,y=-304})
  self:CreateNormalText(self.middleFrame, {x=300,y=-290}, "Player 2")
  self:CreateDropDownPlayerMenu(self.middleFrame, 1, 2, {x=240,y=-304})

  -- Row 5 (Circle)
  self:CreateIconTexture(iconFrame, {x=0,y=-336}, {left=0.25,right=0.5,top=0,bottom=0.25})
  self:CreateNormalText(self.middleFrame, {x=140,y=-338}, "Player 1")
  self:CreateDropDownPlayerMenu(self.middleFrame, 2, 1, {x=80,y=-352})
  self:CreateNormalText(self.middleFrame, {x=300,y=-338}, "Player 2")
  self:CreateDropDownPlayerMenu(self.middleFrame, 2, 2, {x=240,y=-352})

  ---------------
  ---- Close Button
  ---------------
  
  self.mainFrame.closeButton = CreateFrame("Button", "YourCloseButtonName", self.mainFrame, "UIPanelCloseButton")
  self.mainFrame.closeButton:SetPoint("TOPRIGHT", self.mainFrame, "TOPRIGHT", 5, 5)
  self.mainFrame.closeButton:SetScript("OnClick", function() self.mainFrame:Hide() end)

  self.mainFrame:Hide()
end

function Assigner.ui:PopulateUi()
  self.shortAnnounceCheckBox.checkBox:SetChecked(Assigner.db.profile.ShortStringMode)
  -----------
  -- Channel Type
  ----------- 
  if(Assigner.db.profile.ChannelType == 3) then 
    self.channelTypeCustomCheckBox.checkBox:SetChecked(true)
  else
    self.channelEditBox:Hide()
    if (Assigner.db.profile.ChannelType == 2) then self.channelTypeRaidWarningCheckBox.checkBox:SetChecked(true)
    else self.channelTypeRaidCheckBox.checkBox:SetChecked(true)
    end
  end
  self.channelEditBox:SetText(Assigner.db.profile.CustomChannel)

  ------------
  -- Assigns
  ------------

  for key, value in Assigner.db.profile.Assigns do
    local obj = getglobal(key.."Text")
    if(obj) then
      obj:SetText(value)
    end
  end
end

function Assigner.ui:ResetAssigns()
  Assigner.db.profile.Assigns = defaults.Assigns

  for key, value in Assigner.db.profile.Assigns do
    local obj = getglobal(key.."Text")
    if(obj) then
      obj:SetText(value)
    end
  end
end

function Assigner.ui:CreateNormalText(parent, pos, text)
  local textFrame = parent:CreateFontString(parent, "ARTWORK", "GameFontHighlight")
  textFrame:SetPoint("TOPLEFT", pos.x, pos.y)
  textFrame:SetText(text)
  return textFrame
end

function Assigner.ui:CreateIconTexture(parent, pos, textCoords)
  local texture = parent:CreateTexture("Texture", "Background")
  texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
  texture:SetPoint("TOPLEFT", pos.x, pos.y) -- this is relative to the frame created above, unless an anchor frame is given
  texture:SetWidth(30)
  texture:SetHeight(30)
  texture:SetTexCoord(textCoords.left, textCoords.right, textCoords.top, textCoords.bottom)
  return texture
end

function Assigner.ui:CreateCheckButtonWithText(parent, pos, displayname, onClick)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
  -- Container Frame
  local container = CreateFrame("Frame", nil, parent)
  container:SetPoint(pos.anchor, pos.x, pos.y)
  -- Text Frame
	container.text = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  container.text:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
  container.text:SetWidth(120)
  container.text:SetJustifyH("RIGHT")
  container.text:SetJustifyV("CENTER")
  container.text:SetText(displayname)
  -- CheckBox Frame
  container.checkBox = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  container.checkBox:SetFrameStrata("LOW")
  container.checkBox:SetPoint("TOPRIGHT", container.text, "TOPRIGHT", container.checkBox:GetWidth(), -1);
  container.checkBox:SetScript("OnClick", onClick)

  function container:Resize()
    self.text:SetHeight(self.checkBox:GetHeight())
    self:SetWidth(container.text:GetWidth() + self.checkBox:GetWidth())
    self:SetHeight(40)  
  end

  container:Resize()

	return container;
end

function Assigner.ui:CreateButton(parent, pos, size, displayText, onClick)
  if( not pos.anchor) then pos.anchor = "TOPLEFT" end
  local button = CreateFrame("Button",nil, parent ,"UIPanelButtonTemplate")
  button:SetPoint(pos.anchor,pos.x,pos.y)
  button:SetFrameStrata("MEDIUM")
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
	editBox:SetAutoFocus(false)
  editBox:SetFrameStrata("MEDIUM")
  return editBox
end

function Assigner.ui:OnShortAnnounceCheckBox()
  if(Assigner.ui.shortAnnounceCheckBox.checkBox:GetChecked()) then
    Assigner.db.profile.ShortStringMode = true
  else
    Assigner.db.profile.ShortStringMode = false
  end
end

function Assigner.ui:OnChannelTypeRaidCheckBoxClicked()
  if(Assigner.ui.channelTypeRaidCheckBox.checkBox:GetChecked()) then
    Assigner.db.profile.ChannelType = 1
    Assigner.ui.channelTypeRaidWarningCheckBox.checkBox:SetChecked(false)
    Assigner.ui.channelTypeCustomCheckBox.checkBox:SetChecked(false)
    Assigner.ui.channelEditBox:Hide()
  else
    Assigner.ui.channelTypeRaidCheckBox.checkBox:SetChecked(true)
  end
end

function Assigner.ui:OnChannelTypeRaidWarningCheckBoxclicked()
  if(Assigner.ui.channelTypeRaidWarningCheckBox.checkBox:GetChecked()) then
    Assigner.db.profile.ChannelType = 2
    Assigner.ui.channelTypeRaidCheckBox.checkBox:SetChecked(false)
    Assigner.ui.channelTypeCustomCheckBox.checkBox:SetChecked(false)
    Assigner.ui.channelEditBox:Hide()
  else
    Assigner.ui.channelTypeRaidWarningCheckBox.checkBox:SetChecked(true)
  end
end

function Assigner.ui:OnChannelTypeCustomCheckBoxClicked()
  if(Assigner.ui.channelTypeCustomCheckBox.checkBox:GetChecked()) then
    Assigner.db.profile.ChannelType = 3
    Assigner.ui.channelTypeRaidCheckBox.checkBox:SetChecked(false)
    Assigner.ui.channelTypeRaidWarningCheckBox.checkBox:SetChecked(false)
    Assigner.ui.channelEditBox:Show()
  else
    Assigner.ui.channelTypeCustomCheckBox.checkBox:SetChecked(true)
  end
end

function Assigner.ui:OnChannelEditBoxTextChanged()
  if(Assigner.ui.channelEditBox:GetText() == "") then return end

  local channel = tonumber(Assigner.ui.channelEditBox:GetText())
  if channel then
    Assigner.db.profile.CustomChannel = channel
  else
    Assigner.ui.channelEditBox:SetText(Assigner.db.profile.CustomChannel)
  end
end