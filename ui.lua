function Assigner:CreateWindow()
  self.ui:CreateUi()
  --self.ui:SetupUi()
end

function Assigner.ui:CreateUi()
  ---------------
  -- Main Frame
  ---------------

  self.frame = CreateFrame("Frame", nil, UIParent)
  self.frame:SetFrameStrata("DIALOG")
  self.frame:SetWidth(720)
  self.frame:SetHeight(480)
  self.frame:SetPoint(unpack(Assigner.db.char.WindowPosition))
  self.frame:EnableMouse(true)
  self.frame:SetMovable(true)
  self.frame:SetScale(1)
  self.frame:RegisterForDrag("LeftButton")
  self.frame:SetClampedToScreen( true )
  self.frame:SetScript("OnDragStart", function () self.frame:StartMoving() end)
  self.frame:SetScript("OnDragStop", function () 
    self.frame:StopMovingOrSizing() 
    _, _, relativePoint, xOfs, yOfs = this:GetPoint()
    Assigner.db.char.WindowPosition = {relativePoint, xOfs, yOfs}
  end)
  self.frame:SetScript("OnHide", function () self.frame:StopMovingOrSizing() end)
  self.frame:SetBackdrop(Assigner.constants.BACKDROP)
  self.frame:SetBackdropColor(0, 0, 0, 0.85)

  self.frame:Hide()

  ---------------
  ---- Close Button
  ---------------
  
  self.frame.closeButton = CreateFrame("Button", "YourCloseButtonName", self.frame, "UIPanelCloseButton")
  self.frame.closeButton:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", 0, 0)
  self.frame.closeButton:SetScript("OnClick", function() self.frame:Hide() end)

  ---------------
  ---- Top titles
  ---------------

  self.frame.name = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.frame.name:SetText("Assigner")
  self.frame.name:SetFont(Assigner.constants.FONTS["Lobster"], 35)
	self.frame.name:SetPoint("TOP", self.frame, "TOP", 0, -20)
  self.frame.name:SetTextColor(97/255, 175/255, 239/255)
  
  self.frame.name.version = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.frame.name.version:SetPoint("RIGHT", self.frame.name, "RIGHT", 20, 20)
  self.frame.name.version:SetFont(Assigner.constants.FONTS["Lobster"], 17)
  self.frame.name.version:SetText(tostring(Assigner.version))
  self.frame.name.version:SetTextColor(224/255, 108/255, 96/255)

  self.frame.section = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.frame.section:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 40, -70)
  self.frame.section:SetText("Sections")
  self.frame.section:SetFont(Assigner.constants.FONTS["Lobster"], 30)
  self.frame.section:SetTextColor(228/255, 190/255, 120/255)

  ---------------
  ---- Create Pages
  ---------------

	self.frame.pages = {}
	self.frame.scrollFrames = {}
  self.frame.sliders = {}
  self.frame.pageButtons = {}

end

function Assigner.ui:CreateDefaultPage(id, displayName, displayIcon, iconCoords)
  self.frame.scrollFrames[id] = CreateFrame("ScrollFrame", nil, self.frame)
  self.frame.scrollFrames[id]:SetWidth(500)
  self.frame.scrollFrames[id]:SetHeight(405)
  self.frame.scrollFrames[id].id = id

  self.frame.scrollFrames[id]:SetPoint("BOTTOMRIGHT", -30, 10)
  self.frame.scrollFrames[id]:Hide()
  self.frame.scrollFrames[id]:EnableMouseWheel(true)
  self.frame.scrollFrames[id]:SetBackdrop(Assigner.constants.BACKDROP)
  self.frame.scrollFrames[id]:SetBackdropColor(33/255, 37/255, 77/255,1)
  self.frame.scrollFrames[id]:SetScript("OnMouseWheel", function()
                                  local maxScroll = this:GetVerticalScrollRange()
                                  local Scroll = this:GetVerticalScroll()
                                  local toScroll = (Scroll - (20*arg1))
                                  if toScroll < 0 then
                                    this:SetVerticalScroll(0)
                                  elseif toScroll > maxScroll then
                                    this:SetVerticalScroll(maxScroll)
                                  else
                                    this:SetVerticalScroll(toScroll)
                                  end
                                  local script = self.frame.sliders[this.id]:GetScript("OnValueChanged")
                                  self.frame.sliders[this.id]:SetScript("OnValueChanged", nil)
                                  self.frame.sliders[this.id]:SetValue(toScroll/maxScroll)
                                  self.frame.sliders[this.id]:SetScript("OnValueChanged", script)
                                end)

  self.frame.sliders[id] = CreateFrame("Slider", nil, self.frame.scrollFrames[id])
  self.frame.sliders[id]:SetOrientation("VERTICAL")
  self.frame.sliders[id]:SetPoint("TOPLEFT", self.frame.scrollFrames[id], "TOPRIGHT", 5, 0)
  self.frame.sliders[id]:SetBackdrop(Assigner.constants.BACKDROP)
  self.frame.sliders[id]:SetBackdropColor(0,0,0,0.5)
  self.frame.sliders[id].thumbtexture = self.frame.sliders[id]:CreateTexture()
  self.frame.sliders[id].thumbtexture:SetTexture(0.18,0.27,0.5,1)
  self.frame.sliders[id]:SetThumbTexture(self.frame.sliders[id].thumbtexture)
  self.frame.sliders[id]:SetMinMaxValues(0,1)
  self.frame.sliders[id]:SetHeight(406)
  self.frame.sliders[id]:SetWidth(15)
  self.frame.sliders[id]:SetValue(0)
  self.frame.sliders[id].ScrollFrame = self.frame.scrollFrames[id]
  self.frame.sliders[id]:SetScript("OnValueChanged", function() this.ScrollFrame:SetVerticalScroll(this.ScrollFrame:GetVerticalScrollRange()*this:GetValue()) end  )

  -- Main Page of Page
  self.frame.pages[id] = CreateFrame("Frame", id.." Page", self.frame.scrollFrames[id])
  self.frame.pages[id]:SetHeight(1)
  self.frame.pages[id]:SetWidth(500)

  -- Top Title of page
  self.frame.pages[id].name = self.frame.pages[id]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.frame.pages[id].name:SetPoint("TOP", self.frame.pages[id], "TOP", 0, -10)
  self.frame.pages[id].name:SetHeight(30)
  self.frame.pages[id].name:SetJustifyH("LEFT")
  self.frame.pages[id].name:SetTextColor(1, 1, 1)
  self.frame.pages[id].name:SetText(displayName .. " Assignement")
  self.frame.pages[id].name:SetFont(Assigner.constants.FONTS["Righteous"], 15)

  if(displayIcon) then
    self.frame.pages[id].titleIcon = CreateFrame("Frame", nil, self.frame.pages[id])
    self.frame.pages[id].titleIcon:SetHeight(30)
    self.frame.pages[id].titleIcon:SetWidth(30)
    self.frame.pages[id].titleIcon:SetPoint("LEFT", self.frame.pages[id].name, "LEFT", -35, 0)
    self.frame.pages[id].titleIcon.texture = self.frame.pages[id].titleIcon:CreateTexture(nil, "ARTWORK")
    self.frame.pages[id].titleIcon.texture:SetAllPoints(self.frame.pages[id].titleIcon)
    self.frame.pages[id].titleIcon.texture:SetTexture(displayIcon)
    if(iconCoords) then
      self.frame.pages[id].titleIcon.texture:SetTexCoord(unpack(iconCoords))
    end
  end

  self:CreateStandardPageButton(id, displayName)

  self.frame.scrollFrames[id]:SetScrollChild(self.frame.pages[id])

  return self.frame.pages[id]
end

function Assigner.ui:CreateStandardPageButton(id, displayName)
  local button = self:CreateButton(self.frame, id.."Button", nil, {w=145, h=35}, displayName, Assigner.ui.OnPageSwitch)
  button.id = id

  local totalButtons = table.getn(self.frame.pageButtons)
  if(totalButtons == 0) then
    button:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 20, -100)
  else
    button:SetPoint("TOPLEFT", self.frame.pageButtons[totalButtons], "BOTTOMLEFT", 0, -2)
  end

  self.frame.pageButtons[totalButtons + 1] = button
end

function Assigner.ui:CreateStandardTopMenuBar(module)
  -- Top Menu Bar of page
  self.frame.pages[module.name].topMenuBarFrame = CreateFrame("Frame", nil, self.frame.pages[module.name])
  self.frame.pages[module.name].topMenuBarFrame:SetWidth(420)
  self.frame.pages[module.name].topMenuBarFrame:SetHeight(210)
  self.frame.pages[module.name].topMenuBarFrame:SetPoint("TOPLEFT", 10, -50)

  self.frame.pages[module.name].shortAnnounceCheckBox = self:CreateCheckButton(self.frame.pages[module.name].topMenuBarFrame, "Page"..module.name.."ShortAnnounceCheckBox" , {x=85, y=0}, "Short Announce", function () module.db.char.ShortStringMode = this:GetChecked() end)
  
  self.frame.pages[module.name].resetAssigns = self:CreateButton(self.frame.pages[module.name].topMenuBarFrame, "Page"..module.name.."ResetAssignementButton" ,  {x=70, y=-38}, {w=140, h=30}, "Reset Assigns", function () Assigner.ui:OnStandardResetAssignButtonClicked(module) end)
  self.frame.pages[module.name].sendButton = self:CreateButton(self.frame.pages[module.name].topMenuBarFrame, "Page"..module.name.."SendAssignementButton" , {x=70, y=-70}, {w=140, h=30}, "Send Assign", function () Assigner.ui:OnStandardSendAssignButtonClicked(module) end)

  -- channel type of page
  self:CreateNormalText(self.frame.pages[module.name].topMenuBarFrame, {x=310, y=-2}, "Channel"):SetFont("Fonts\\FRIZQT__.TTF", 15)
  self.frame.pages[module.name].channelTypeGroup = {}
  self.frame.pages[module.name].channelTypeRaidCheckBox = self:CreateCheckButton(self.frame.pages[module.name].topMenuBarFrame, "Page"..module.name.."ChannelTypeRaidCheckBox" , {x=280, y=-23}, "Raid", self.OnChannelTypeCheckBoxClicked)
  self.frame.pages[module.name].channelTypeRaidCheckBox.id = 1
  self.frame.pages[module.name].channelTypeRaidWarningCheckBox = self:CreateCheckButton(self.frame.pages[module.name].topMenuBarFrame, "Page"..module.name.."ChannelTypeRaidWarningCheckBox" , {x=280, y=-48}, "Raid Warning", self.OnChannelTypeCheckBoxClicked)
  self.frame.pages[module.name].channelTypeRaidWarningCheckBox.id = 2
  self.frame.pages[module.name].channelTypeCustomCheckBox = self:CreateCheckButton(self.frame.pages[module.name].topMenuBarFrame, "Page"..module.name.."ChannelTypeCustomCheckBox", {x=280, y=-74}, "Custom Channel", self.OnChannelTypeCheckBoxClicked)
  self.frame.pages[module.name].channelTypeCustomCheckBox.id = 3

  self.frame.pages[module.name].channelTypeGroup["ChannelTypeRaidCheckBox"] = self.frame.pages[module.name].channelTypeRaidCheckBox
  self.frame.pages[module.name].channelTypeGroup["ChannelTypeRaidWarningCheckBox"] = self.frame.pages[module.name].channelTypeRaidWarningCheckBox
  self.frame.pages[module.name].channelTypeGroup["ChannelTypeCustomCheckBox"] = self.frame.pages[module.name].channelTypeCustomCheckBox

  self.frame.pages[module.name].channelEditBox = self:CreateEditBox(self.frame.pages[module.name].topMenuBarFrame, "Page"..module.name.."ChannelEditBox" , nil, {w=15,h=30})
  self.frame.pages[module.name].channelEditBox:SetMaxLetters(1)
  self.frame.pages[module.name].channelEditBox:SetPoint("RIGHT", self.frame.pages[module.name].channelTypeCustomCheckBox, "RIGHT", 112, 0)
  self.frame.pages[module.name].channelEditBox:SetScript("OnEnterPressed", self.OnCustomChannelEditBoxEnterPressed)  
end

function Assigner.ui:SetupUi()
  for i,name in ipairs(self.pageInfos) do
    self.frame.pages[i].shortAnnounceCheckBox:SetChecked(Assigner.db.char.Pages[i].ShortStringMode)
    -----------
    -- Channel Type
    ----------- 
    if(Assigner.db.char.Pages[i].ChannelType == 3) then  self.frame.pages[i].channelTypeCustomCheckBox:SetChecked(true)
    else
      self.frame.pages[i].channelEditBox:Hide()
      if (Assigner.db.char.Pages[i].ChannelType == 2) then self.frame.pages[i].channelTypeRaidWarningCheckBox:SetChecked(true)
      else self.frame.pages[i].channelTypeRaidCheckBox:SetChecked(true)
      end
    end
    self.frame.pages[i].channelEditBox:SetText(Assigner.db.char.Pages[i].CustomChannel)
  end
  
  ------------
  -- Assigns
  ------------

  for w, page in ipairs(Assigner.db.char.Pages) do
    for i, players_i in ipairs(page.Players) do
      for j, player_i_j in ipairs (players_i) do
        local dropDownText = getglobal("Page"..w.."DropDownPlayer"..i..j.."Text")
        if(dropDownText) then
          dropDownText:SetText(player_i_j)
        end
      end
    end
  end
end

function Assigner.ui:OnStandardResetAssignButtonClicked(module)
  if (module) then
    module.db.char.Players = module.core:Deepcopy(module.defaultDB.Players)
    for i=1,table.getn(module.db.char.Players) do
      for j=1,table.getn(module.db.char.Players[i]) do
        UIDropDownMenu_SetSelectedValue(getglobal("Page"..module.name.."DropDownPlayer"..i..j), module.db.char.Players[i][j])
      end
    end
  end
end

function Assigner.ui:OnStandardSendAssignButtonClicked(module)
  if(module) then
    local currentTime = time()
    if((globalLastAnnounceTime + delayTime/1000) > currentTime) then return end

    local message = module:GetAssignementString()
    module.core:SendMessage(message, module.db.char.ChannelType, module.db.char.CustomChannel)
    globalLastAnnounceTime = currentTime
  end
end

function Assigner.ui:OnPageSwitch()
	Assigner.ui.frame.scrollFrames[Assigner.db.char.CurrentPageID]:Hide()
	Assigner.ui.frame.scrollFrames[this.id]:Show()
	Assigner.db.char.CurrentPageID = this.id
end

function Assigner.ui:OnCustomChannelEditBoxEnterPressed()
  local number = tonumber(this:GetText()) -- Only accept numbers
  if number then Assigner.db.namespaces[Assigner.db.char.CurrentPageID].char.CustomChannel = number
  else this:SetText(Assigner.db.namespaces[Assigner.db.char.CurrentPageID].char.CustomChannel)
  end
  this:ClearFocus()
end

function Assigner.ui:OnChannelTypeCheckBoxClicked()
  for _,checkbox in pairs(Assigner.ui.frame.pages[Assigner.db.char.CurrentPageID].channelTypeGroup) do
    checkbox:SetChecked(false) -- Uncheck all checkboxes in the group
  end
  this:SetChecked(true) -- self check

  Assigner.db.namespaces[Assigner.db.char.CurrentPageID].char.ChannelType = this.id -- save the new data

  if (this.id == 3) then
    Assigner.ui.frame.pages[Assigner.db.char.CurrentPageID].channelEditBox:Show()
  else
    Assigner.ui.frame.pages[Assigner.db.char.CurrentPageID].channelEditBox:Hide()
  end
end