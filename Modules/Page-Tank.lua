Page_Tank = Assigner:NewModule("Page_Tank")

Page_Tank.defaultDB = {
	ShortStringMode = false,
  ChannelType = 1,
  CustomChannel = 1,
  Players = {
    -- Skull  (8)
    [8] = {
      [1] = "NONE",
      [2] = "NONE",
    },
    -- X
    [7] = {
      [1] = "NONE",
      [2] = "NONE",
    },
    -- Square 
    [6] = {
      [1] = "NONE",
      [2] = "NONE",
    },
    -- Triangle
    [4] = {
      [1] = "NONE",
      [2] = "NONE",
    },
    -- Diamond
    [3] = {
      [1] = "NONE",
      [2] = "NONE",
    },
    -- Moon
    [5] = {
      [1] = "NONE",
      [2] = "NONE",
    },
    -- Circle
    [2] = {
      [1] = "NONE",
      [2] = "NONE",
    },
    -- Star
    [1] = {
      [1] = "NONE",
      [2] = "NONE",
    },
  },
}

function Page_Tank:OnRegister()
  self:CreateWindow()
  self:SetupWindow()
end

function Page_Tank:CreateWindow()
  self.ui:CreateDefaultPage(self.name, "Tank", "Interface\\Icons\\Ability_Warrior_DefensiveStance")
  self.ui:CreateStandardTopMenuBar(self)

  self.ui.frame.pages[self.name].iconFrame = CreateFrame("Frame", nil, self.ui.frame.pages[self.name].topMenuBarFrame)
  self.ui.frame.pages[self.name].iconFrame:SetWidth(30)
  self.ui.frame.pages[self.name].iconFrame:SetHeight(85)
  self.ui.frame.pages[self.name].iconFrame:SetPoint("BOTTOMLEFT", 0, 0)

  self.ui:CreateRaidTargetTexture(self.ui.frame.pages[self.name].iconFrame, {x=62,y=-4.5}, "SKULL")
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 8, 1, {x=80,y=0}, {"WARRIOR", "PALADIN", "DRUID"})
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 8, 2, {x=240,y=0}, {"WARRIOR", "PALADIN", "DRUID"})

  -- Row 2 (Cross)
  self.ui:CreateRaidTargetTexture(self.ui.frame.pages[self.name].iconFrame, {x=62,y=-39.5}, "CROSS")
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 7, 1, {x=80,y=-35}, {"WARRIOR", "PALADIN", "DRUID"})
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 7, 2, {x=240,y=-35}, {"WARRIOR", "PALADIN", "DRUID"})

  -- Row 3 (Square)
  self.ui:CreateRaidTargetTexture(self.ui.frame.pages[self.name].iconFrame, {x=62,y=-74.5}, "SQUARE")
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 6, 1, {x=80,y=-70}, {"WARRIOR", "PALADIN", "DRUID"})
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 6, 2, {x=240,y=-70}, {"WARRIOR", "PALADIN", "DRUID"})

  -- Row 4 (Triangle)
  self.ui:CreateRaidTargetTexture(self.ui.frame.pages[self.name].iconFrame, {x=62,y=-109.5}, "TRIANGLE")
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 4, 1, {x=80,y=-105}, {"WARRIOR", "PALADIN", "DRUID"})
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 4, 2, {x=240,y=-105}, {"WARRIOR", "PALADIN", "DRUID"})

  -- Row 4 (Diamond)
  self.ui:CreateRaidTargetTexture(self.ui.frame.pages[self.name].iconFrame, {x=62,y=-144.5}, "DIAMOND")
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 3, 1, {x=80,y=-140}, {"WARRIOR", "PALADIN", "DRUID"})
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 3, 2, {x=240,y=-140}, {"WARRIOR", "PALADIN", "DRUID"})

  -- Row 5 (Moon)
  self.ui:CreateRaidTargetTexture(self.ui.frame.pages[self.name].iconFrame, {x=62,y=-179.5}, "MOON")
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 5, 1, {x=80,y=-175}, {"WARRIOR", "PALADIN", "DRUID"})
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 5, 2, {x=240,y=-175}, {"WARRIOR", "PALADIN", "DRUID"})

  -- Row 5 (Star)
  self.ui:CreateRaidTargetTexture(self.ui.frame.pages[self.name].iconFrame, {x=62,y=-214.5}, "STAR")
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 1, 1, {x=80,y=-210}, {"WARRIOR", "PALADIN", "DRUID"})
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 1, 2, {x=240,y=-210}, {"WARRIOR", "PALADIN", "DRUID"})

  -- Row 5 (Circle)
  self.ui:CreateRaidTargetTexture(self.ui.frame.pages[self.name].iconFrame, {x=62,y=-249.5}, "CIRCLE")
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 2, 1, {x=80,y=-245}, {"WARRIOR", "PALADIN", "DRUID"})
  self.ui:CreateDropDownPlayerMenu(self.ui.frame.pages[self.name].iconFrame, "Page"..self.name.."DropDownPlayer", 2, 2, {x=240,y=-245}, {"WARRIOR", "PALADIN", "DRUID"})
end

function Page_Tank:SetupWindow()
  -----------
  -- Short Announce Checkbox
  ----------- 
  self.ui.frame.pages[self.name].shortAnnounceCheckBox:SetChecked(self.db.char.ShortStringMode)
  
  -----------
  -- Channel Type
  -----------
  if(self.db.char.ChannelType == 3) then  self.ui.frame.pages[self.name].channelTypeCustomCheckBox:SetChecked(true)
  else
    self.ui.frame.pages[self.name].channelEditBox:Hide()
    if (self.db.char.ChannelType == 2) then self.ui.frame.pages[self.name].channelTypeRaidWarningCheckBox:SetChecked(true)
    else self.ui.frame.pages[self.name].channelTypeRaidCheckBox:SetChecked(true)
    end
  end
  self.ui.frame.pages[self.name].channelEditBox:SetText(self.db.char.CustomChannel)

  -----------
  -- Player Dropdown Menus
  ----------- 

  for i, players_i in ipairs(self.db.char.Players) do
    for j, player_i_j in ipairs (players_i) do
      local dropDownText = getglobal("Page"..self.name.."DropDownPlayer"..i..j.."Text")
      if(dropDownText) then
        dropDownText:SetText(player_i_j)
      end
    end
  end

  self.core:Print(self.core.db.char.CurrentPageID, self.name)

  if(self.core.db.char.CurrentPageID == self.name) then
    self.ui.frame.scrollFrames[self.core.db.char.CurrentPageID]:Show()
  end
end

function Page_Tank:GetAssignementString()
  local message = ""

  if (not self.db.char.ShortStringMode and self.db.char.ChannelType ~= 2) then
    message = "--- " .. self.ui.frame.pages[self.name].name:GetText()..  " ---\n"
  end

  if(self:HasPlayerAssign()) then
    local assignement
    firstString = true

    assignement, firstString = self:BuildAssignementRowString(8, firstString, "("..self.core.constants.RAID_TARGETS_NUMBERS[8].."): ")
    message = message .. assignement
    assignement, firstString = self:BuildAssignementRowString(7, firstString, "("..self.core.constants.RAID_TARGETS_NUMBERS[7].."): ")
    message = message .. assignement
    assignement, firstString = self:BuildAssignementRowString(6, firstString, "("..self.core.constants.RAID_TARGETS_NUMBERS[6].."): ")
    message = message .. assignement
    assignement, firstString = self:BuildAssignementRowString(4, firstString, "("..self.core.constants.RAID_TARGETS_NUMBERS[4].."): ")
    message = message .. assignement
    assignement, firstString = self:BuildAssignementRowString(3, firstString, "("..self.core.constants.RAID_TARGETS_NUMBERS[3].."): ")
    message = message .. assignement
    assignement, firstString = self:BuildAssignementRowString(5, firstString, "("..self.core.constants.RAID_TARGETS_NUMBERS[5].."): ")
    message = message .. assignement
    assignement, firstString = self:BuildAssignementRowString(1, firstString, "("..self.core.constants.RAID_TARGETS_NUMBERS[1].."): ")
    message = message .. assignement
    assignement, firstString = self:BuildAssignementRowString(2, firstString, "("..self.core.constants.RAID_TARGETS_NUMBERS[2].."): ")
    message = message .. assignement
  else
    message = message .. "No " .. self.ui.frame.pages[self.name].name:GetText()   
  end

  return message
end
