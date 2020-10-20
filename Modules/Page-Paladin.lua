Page_Paladin = Assigner:NewModule("Page_Paladin")

Page_Paladin.defaultDB = {
  DivineIntervention = {
    ShortStringMode = false,
    ChannelType = 1,
    CustomChannel = 1,
    Players = {
      [1] = {
        [1] = "NONE",
        [2] = "NONE",
      },
      [2] = {
        [1] = "NONE",
        [2] = "NONE",
      },
      [3] = {
        [1] = "NONE",
        [2] = "NONE",
      },
      [4] = {
        [1] = "NONE",
        [2] = "NONE",
      },
      [5] = {
        [1] = "NONE",
        [2] = "NONE",
      },
    },
  }
}

function Page_Paladin:OnRegister()
  self:CreatePage()
  self:SetupPage()
end

function Page_Paladin:CreatePage()
  self.ui:CreateDefaultPage(self.name, "Paladin", "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes", self.core.constants.CLASS_ICON_TCOORDS["PALADIN"])
  
  self.ui.frame.pages[self.name].divineInterventionLayout = CreateFrame("Frame", nil, self.ui.frame.pages[self.name])
  self.ui.frame.pages[self.name].divineInterventionLayout:SetWidth(1)
  self.ui.frame.pages[self.name].divineInterventionLayout:SetHeight(1)
  self.ui.frame.pages[self.name].divineInterventionLayout:SetPoint("TOPLEFT", 0, -65)

  self.ui.frame.pages[self.name].divineInterventionLayout.fontHeader = self.ui.frame.pages[self.name]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.ui.frame.pages[self.name].divineInterventionLayout.fontHeader:SetPoint("TOPLEFT", self.ui.frame.pages[self.name].divineInterventionLayout, "TOPLEFT", 45, 0)
	self.ui.frame.pages[self.name].divineInterventionLayout.fontHeader:SetHeight(28)
	self.ui.frame.pages[self.name].divineInterventionLayout.fontHeader:SetJustifyH("LEFT")
	self.ui.frame.pages[self.name].divineInterventionLayout.fontHeader:SetTextColor(1,1,0)
  self.ui.frame.pages[self.name].divineInterventionLayout.fontHeader:SetText("Divine Intervention")
  
  self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon = CreateFrame("Frame", nil, self.ui.frame.pages[self.name])
  self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon:SetHeight(25)
  self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon:SetWidth(25)
  self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon:SetPoint("LEFT", self.ui.frame.pages[self.name].divineInterventionLayout.fontHeader, "LEFT", -30, 0)
  self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon.texture = self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon:CreateTexture(nil, "ARTWORK")
  self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon.texture:SetAllPoints(self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon)
  self.ui.frame.pages[self.name].divineInterventionLayout.titleIcon.texture:SetTexture("Interface\\Icons\\spell_nature_timestop")

  self.ui.frame.pages[self.name].divineInterventionLayout.shortAnnounceCheckBox = self.ui:CreateCheckButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionShortAnnounceCheckBox" , {x=25, y=-35}, "Short Announce", function () Page_Paladin.db.char.DivineIntervention.ShortStringMode = this:GetChecked() end)
  self.ui.frame.pages[self.name].divineInterventionLayout.resetAssign = self.ui:CreateButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionResetAssignButton" ,  {x=25, y=-65}, {w=140, h=30}, "Reset Assigns", self.OnDivineInterventionResetAssignClicked)
  self.ui.frame.pages[self.name].divineInterventionLayout.sendAssign = self.ui:CreateButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionSendAssignButton" , {x=25, y=-97}, {w=140, h=30}, "Send Assign", self.OnDivineInterventionSendAssignClicked)

  --------
  --   Divine intervention Category
  -------

  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeHeader = self.ui.frame.pages[self.name].divineInterventionLayout:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeHeader:SetPoint("TOPLEFT", self.ui.frame.pages[self.name].divineInterventionLayout, "TOPLEFT", 210, -43)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeHeader:SetText("Channel Type")

  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeGroup = {}
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidCheckBox = self.ui:CreateCheckButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionChannelTypeRaidCheckBox" , {x=210, y=-58}, "Raid", self.OnDivineInterventionChannelTypeCheckBoxClicked)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidCheckBox.id = 1
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidWarningCheckBox = self.ui:CreateCheckButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionChannelTypeRaidWarningCheckBox" , {x=210, y=-80}, "Raid Warning", self.OnDivineInterventionChannelTypeCheckBoxClicked)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidWarningCheckBox.id = 2
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeCustomCheckBox = self.ui:CreateCheckButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionChannelTypeCustomCheckBox", {x=210, y=-102}, "Custom Channel", self.OnDivineInterventionChannelTypeCheckBoxClicked)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeCustomCheckBox.id = 3

  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeGroup["ChannelTypeRaidCheckBox"] = self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidCheckBox
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeGroup["ChannelTypeRaidWarningCheckBox"] = self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidWarningCheckBox
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeGroup["ChannelTypeCustomCheckBox"] = self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeCustomCheckBox

  self.ui.frame.pages[self.name].divineInterventionLayout.channelEditBox = self.ui:CreateEditBox(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionChannelEditBox" , nil, {w=15,h=30})
  self.ui.frame.pages[self.name].divineInterventionLayout.channelEditBox:SetMaxLetters(1)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelEditBox:SetPoint("RIGHT", self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeCustomCheckBox, "RIGHT", 105, 0)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelEditBox:SetScript("OnEnterPressed", self.OnDivineInterventionCustomChannelEditBoxEnterPressed)  

  local divineClickFunction = function() 
    UIDropDownMenu_SetSelectedID(this.owner, this:GetID())
    Page_Paladin.db.char.DivineIntervention.Players[this.owner.row][this.owner.col] = this.value
  end

  for i=1,5 do
    local dropDown, textHeader
    dropDown = self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionDropDownPlayer", i, 1, {x=15,y=-(110+i*50)}, {"PALADIN"}, divineClickFunction)
    textHeader = self.ui.frame.pages[self.name].divineInterventionLayout:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    textHeader:SetPoint("TOP", dropDown, "TOP", 65, 15)
    textHeader:SetText("Paladin " .. i)
    textHeader:SetTextColor(0.96, 0.55, 0.73)
    dropDown = self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionDropDownPlayer", i, 2, {x=175,y=-(110+i*50)}, {"PALADIN", "DRUID", "PRIEST"}, divineClickFunction)
    textHeader = self.ui.frame.pages[self.name].divineInterventionLayout:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    textHeader:SetPoint("TOP", dropDown, "TOP", 65, 15)
    textHeader:SetText("Target " .. i)
    textHeader:SetTextColor(1, 1, 1)
  end
end

function Page_Paladin:SetupPage()
  -----------
  -- Channel Type
  ----------- 
  if(self.db.char.DivineIntervention) then
    self.ui.frame.pages[self.name].divineInterventionLayout.shortAnnounceCheckBox:SetChecked(self.db.char.DivineIntervention.ShortStringMode)
    if(self.db.char.DivineIntervention.ChannelType == 3) then 
      self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeCustomCheckBox:SetChecked(true)
    else
      self.ui.frame.pages[self.name].divineInterventionLayout.channelEditBox:Hide()
      if (self.db.char.DivineIntervention.ChannelType == 2) then 
        self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidWarningCheckBox:SetChecked(true)
      else 
        self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidCheckBox:SetChecked(true)
      end
    end
    self.ui.frame.pages[self.name].divineInterventionLayout.channelEditBox:SetText(self.db.char.DivineIntervention.CustomChannel)
  
    if (self.db.char.DivineIntervention.Players) then
      for i, players_i in ipairs(self.db.char.DivineIntervention.Players) do
        for j, player_i_j in ipairs (players_i) do
          getglobal("Page"..self.name.."DivineInterventionDropDownPlayer"..i..j.."Text"):SetText(player_i_j)
        end
      end
    end
  end


  if(self.core.db.char.CurrentPageID == self.name) then
    self.ui.frame.scrollFrames[self.name]:Show()
  end
end

function Page_Paladin:OnDivineInterventionResetAssignClicked()
  if (Page_Paladin.db.char.DivineIntervention) then
    Page_Paladin.db.char.DivineIntervention.Players = Page_Paladin.core:Deepcopy(Page_Paladin.defaultDB.DivineIntervention.Players)
    for i=1,table.getn(Page_Paladin.db.char.DivineIntervention.Players) do
      for j=1,table.getn(Page_Paladin.db.char.DivineIntervention.Players[i]) do
        UIDropDownMenu_SetSelectedValue(getglobal("Page"..Page_Paladin.name.."DivineInterventionDropDownPlayer"..i..j), Page_Paladin.db.char.DivineIntervention.Players[i][j])
      end
    end
  end
end

function Page_Paladin:HasDivineInterventionAssign()
  local found = false

  if (self.db.char.DivineIntervention.Players) then
    for _, i_value in self.db.char.DivineIntervention.Players do
      if (i_value[1] ~= "NONE") then -- paladin
        found = true
        break
      end
    end
  end

  return found
end

function Page_Paladin:GetDivineInterventionAssignString()
  local message = "=--- DI Assign ---=\n"

  if(self:HasDivineInterventionAssign()) then
    local count = 0
    for i, row in self.db.char.DivineIntervention.Players do
      if(row[1] ~= "NONE") then
        message = message .. "[".. count .. "]: " .. row[1] .. " -> " .. row[2] .. "\n"
        count = count+1
      end
    end
  else
    message = message .. "No Paladins" 
  end

  return message
end

function Page_Paladin:OnDivineInterventionSendAssignClicked()
  local currentTime = time()
  if((globalLastAnnounceTime + delayTime/1000) > currentTime) then return end

  local message = Page_Paladin:GetDivineInterventionAssignString()
  Page_Paladin.core:SendMessage(message, Page_Paladin.db.char.DivineIntervention.ChannelType, Page_Paladin.db.char.DivineIntervention.CustomChannel)
  globalLastAnnounceTime = currentTime
end

function Page_Paladin:OnDivineInterventionCustomChannelEditBoxEnterPressed()
  local number = tonumber(this:GetText()) -- Only accept numbers
  if number then Page_Paladin.db.char.DivineIntervention.CustomChannel = number
  else this:SetText(Page_Paladin.db.char.DivineIntervention.CustomChannel)
  end
  this:ClearFocus()
end

function Page_Paladin:OnDivineInterventionChannelTypeCheckBoxClicked()
  for _,checkbox in pairs(Page_Paladin.ui.frame.pages[Page_Paladin.name].divineInterventionLayout.channelTypeGroup) do
    checkbox:SetChecked(false) -- Uncheck all checkboxes in the group
  end

  this:SetChecked(true) -- self check
  Page_Paladin.db.char.DivineIntervention.ChannelType = this.id -- save the new data

  if (this.id == 3) then Page_Paladin.ui.frame.pages[Page_Paladin.name].divineInterventionLayout.channelEditBox:Show()
  else Page_Paladin.ui.frame.pages[Page_Paladin.name].divineInterventionLayout.channelEditBox:Hide()
  end
end