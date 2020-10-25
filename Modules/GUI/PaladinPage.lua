PaladinPage = Assigner:NewModule("PaladinPage")

PaladinPage.defaultDB = {
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

function PaladinPage:OnRegister()
  self:CreatePage()
  self:SetupPage()
end

function PaladinPage:CreatePage()
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

  self.ui.frame.pages[self.name].divineInterventionLayout.shortAnnounceCheckBox = self.ui:CreateCheckButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionShortAnnounceCheckBox" , {x=10, y=-35}, "Short Announce", function () PaladinPage.db.char.DivineIntervention.ShortStringMode = this:GetChecked() end)
  self.ui.frame.pages[self.name].divineInterventionLayout.resetAssign = self.ui:CreateButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionResetAssignButton" ,  {x=10, y=-65}, {w=140, h=30}, "Reset Assigns", self.OnDivineInterventionResetAssignClicked)
  self.ui.frame.pages[self.name].divineInterventionLayout.sendAssign = self.ui:CreateButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionSendAssignButton" , {x=10, y=-97}, {w=140, h=30}, "Send Assign", self.OnDivineInterventionSendAssignClicked)

  self.ui.frame.pages[self.name].divineInterventionLayout.sendSync = self.ui:CreateButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionSendSyncButton" , {x=155, y=-65}, {w=140, h=30}, "Send Sync", self.OnDivineInterventionSendSyncClicked)
  self.ui.frame.pages[self.name].divineInterventionLayout.showUI = self.ui:CreateButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionShowUIButton" , {x=155, y=-97}, {w=140, h=30}, "Show UI", function() PaladinDIMonitor:ShowGUI() end)
  
  --------
  --   Divine intervention Category
  -------

  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeHeader = self.ui.frame.pages[self.name].divineInterventionLayout:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeHeader:SetPoint("TOPLEFT", self.ui.frame.pages[self.name].divineInterventionLayout, "TOPLEFT", 300, -43)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeHeader:SetText("Channel Type")

  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeGroup = {}
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidCheckBox = self.ui:CreateCheckButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionChannelTypeRaidCheckBox" , {x=300, y=-58}, "Raid", self.OnDivineInterventionChannelTypeCheckBoxClicked)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidCheckBox.id = 1
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidWarningCheckBox = self.ui:CreateCheckButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionChannelTypeRaidWarningCheckBox" , {x=300, y=-80}, "Raid Warning", self.OnDivineInterventionChannelTypeCheckBoxClicked)
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeRaidWarningCheckBox.id = 2
  self.ui.frame.pages[self.name].divineInterventionLayout.channelTypeCustomCheckBox = self.ui:CreateCheckButton(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionChannelTypeCustomCheckBox", {x=300, y=-102}, "Custom Channel", self.OnDivineInterventionChannelTypeCheckBoxClicked)
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
    PaladinPage.db.char.DivineIntervention.Players[this.owner.row][this.owner.col] = this.value
  end

  for i=1,5 do
    local dropDown, textHeader
    dropDown = self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionDropDownPlayer", i, 1, {x=15,y=-(105+i*50)}, {"PALADIN"}, divineClickFunction)
    textHeader = self.ui.frame.pages[self.name].divineInterventionLayout:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    textHeader:SetPoint("TOP", dropDown, "TOP", 65, 15)
    textHeader:SetText("Paladin " .. i)
    textHeader:SetTextColor(0.96, 0.55, 0.73)
    dropDown = self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].divineInterventionLayout, "Page"..self.name.."DivineInterventionDropDownPlayer", i, 2, {x=160,y=-(105+i*50)}, {"PALADIN", "DRUID", "PRIEST"}, divineClickFunction)
    textHeader = self.ui.frame.pages[self.name].divineInterventionLayout:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    textHeader:SetPoint("TOP", dropDown, "TOP", 65, 15)
    textHeader:SetText("Target " .. i)
    textHeader:SetTextColor(1, 1, 1)
  end
end

function PaladinPage:SetupPage()
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

function PaladinPage:OnDivineInterventionResetAssignClicked()
  if (PaladinPage.db.char.DivineIntervention) then
    PaladinPage.db.char.DivineIntervention.Players = PaladinPage.core:Deepcopy(PaladinPage.defaultDB.DivineIntervention.Players)
    for i=1,table.getn(PaladinPage.db.char.DivineIntervention.Players) do
      for j=1,table.getn(PaladinPage.db.char.DivineIntervention.Players[i]) do
        UIDropDownMenu_SetSelectedValue(getglobal("Page"..PaladinPage.name.."DivineInterventionDropDownPlayer"..i..j), PaladinPage.db.char.DivineIntervention.Players[i][j])
      end
    end
  end
end

function PaladinPage:OnDivineInterventionSendSyncClicked()
  if (IsRaidLeader() or IsRaidOfficer()) then
    for index, data in pairs(PaladinPage.db.char.DivineIntervention.Players) do
      PaladinPage:TriggerEvent("Assigner_SendSync", "ASSPDI ".. index .. " " .. data[1] .. " " .. data[2])
    end
  else
    PaladinPage.core:Print("I am not allowed")
  end
end

function PaladinPage:HasDivineInterventionAssign()
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

function PaladinPage:GetDivineInterventionAssignString()
  local message = "=--- DI Assign ---=\n"

  if(self:HasDivineInterventionAssign()) then
    local count = 1
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

function PaladinPage:OnDivineInterventionSendAssignClicked()
  local currentTime = time()
  if((globalLastAnnounceTime + delayTime/1000) > currentTime) then return end

  local message = PaladinPage:GetDivineInterventionAssignString()
  PaladinPage.core:SendMessage(message, PaladinPage.db.char.DivineIntervention.ChannelType, PaladinPage.db.char.DivineIntervention.CustomChannel)
  globalLastAnnounceTime = currentTime
end

function PaladinPage:OnDivineInterventionCustomChannelEditBoxEnterPressed()
  local number = tonumber(this:GetText()) -- Only accept numbers
  if number then PaladinPage.db.char.DivineIntervention.CustomChannel = number
  else this:SetText(PaladinPage.db.char.DivineIntervention.CustomChannel)
  end
  this:ClearFocus()
end

function PaladinPage:OnDivineInterventionChannelTypeCheckBoxClicked()
  for _,checkbox in pairs(PaladinPage.ui.frame.pages[PaladinPage.name].divineInterventionLayout.channelTypeGroup) do
    checkbox:SetChecked(false) -- Uncheck all checkboxes in the group
  end

  this:SetChecked(true) -- self check
  PaladinPage.db.char.DivineIntervention.ChannelType = this.id -- save the new data

  if (this.id == 3) then PaladinPage.ui.frame.pages[PaladinPage.name].divineInterventionLayout.channelEditBox:Show()
  else PaladinPage.ui.frame.pages[PaladinPage.name].divineInterventionLayout.channelEditBox:Hide()
  end
end