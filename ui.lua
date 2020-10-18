Assigner.ui = {}

function Assigner:CreateWindow()
  self.ui:CreateUi()
  self.ui:SetupUi()
end

function Assigner.ui:CreateUi()
  ---------------
  -- Main Frame
  ---------------
  self.frame = CreateFrame("Frame", nil, UIParent)
  self.frame:SetFrameStrata("DIALOG")
  self.frame:SetWidth(720)
  self.frame:SetHeight(480)
  self.frame:SetPoint("CENTER", 0, 0)
  self.frame:EnableMouse(true)
  self.frame:SetMovable(true)
  self.frame:RegisterForDrag("LeftButton")
  self.frame:SetClampedToScreen( true )
  self.frame:SetScript("OnDragStart", function () self.frame:StartMoving() end)
  self.frame:SetScript("OnDragStop", function () self.frame:StopMovingOrSizing() end)
  self.frame:SetScript("OnHide", function () self.frame:StopMovingOrSizing() end)
  self.frame:SetBackdrop(Assigner.constants.BACKDROP)
  self.frame:SetBackdropColor(0, 0, 0, 0.85)

  ---------------
  ---- Close Button
  ---------------
  
  self.frame.closeButton = CreateFrame("Button", "YourCloseButtonName", self.frame, "UIPanelCloseButton")
  self.frame.closeButton:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", 0, 0)
  self.frame.closeButton:SetScript("OnClick", function() self.frame:Hide() end)


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


	self.frame.pages = {}
	self.frame.scrollFrames = {}
  self.frame.sliders = {}
  
  self.pageInfos = { 
    {name="Tank", icon="Interface\\Icons\\Ability_Warrior_DefensiveStance"},
    {name="Kick/Pummel", icon="Interface\\Icons\\ability_kick"},
    {name="Divine Intervention", icon="Interface\\Icons\\spell_nature_timestop"}, 
  } 

  for i,info in ipairs(self.pageInfos) do
    self.frame.scrollFrames[i] = CreateFrame("ScrollFrame", nil, self.frame)
    self.frame.scrollFrames[i]:SetWidth(500)
    self.frame.scrollFrames[i]:SetHeight(405)
		self.frame.scrollFrames[i].id = i

		self.frame.scrollFrames[i]:SetPoint("BOTTOMRIGHT", -30, 10)
		self.frame.scrollFrames[i]:Hide()
		self.frame.scrollFrames[i]:EnableMouseWheel(true)
		self.frame.scrollFrames[i]:SetBackdrop(Assigner.constants.BACKDROP)
		self.frame.scrollFrames[i]:SetBackdropColor(33/255, 37/255, 77/255,1)
		self.frame.scrollFrames[i]:SetScript("OnMouseWheel", function()
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

		self.frame.sliders[i] = CreateFrame("Slider", nil, self.frame.scrollFrames[i])
		self.frame.sliders[i]:SetOrientation("VERTICAL")
		self.frame.sliders[i]:SetPoint("TOPLEFT", self.frame.scrollFrames[i], "TOPRIGHT", 5, 0)
		self.frame.sliders[i]:SetBackdrop(Assigner.constants.BACKDROP)
		self.frame.sliders[i]:SetBackdropColor(0,0,0,0.5)
		self.frame.sliders[i].thumbtexture = self.frame.sliders[i]:CreateTexture()
		self.frame.sliders[i].thumbtexture:SetTexture(0.18,0.27,0.5,1)
		self.frame.sliders[i]:SetThumbTexture(self.frame.sliders[i].thumbtexture)
		self.frame.sliders[i]:SetMinMaxValues(0,1)
		self.frame.sliders[i]:SetHeight(406)
		self.frame.sliders[i]:SetWidth(15)
		self.frame.sliders[i]:SetValue(0)
		self.frame.sliders[i].ScrollFrame = self.frame.scrollFrames[i]
		self.frame.sliders[i]:SetScript("OnValueChanged", function() this.ScrollFrame:SetVerticalScroll(this.ScrollFrame:GetVerticalScrollRange()*this:GetValue()) end  )

    -- Main Page of Page
		self.frame.pages[i] = CreateFrame("Frame", info.name.." Page", self.frame.scrollFrames[i])
		self.frame.pages[i]:SetHeight(1)
		self.frame.pages[i]:SetWidth(500)

    -- Top Title of page
		self.frame.pages[i].name = self.frame.pages[i]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		self.frame.pages[i].name:SetPoint("TOP", self.frame.pages[i], "TOP", 0, -10)
		self.frame.pages[i].name:SetHeight(30)
		self.frame.pages[i].name:SetJustifyH("LEFT")
    self.frame.pages[i].name:SetTextColor(1, 1, 1)
    self.frame.name.version:SetShadowColor(0, 0, 0)
    self.frame.name.version:SetShadowOffset(1, -1)
    self.frame.pages[i].name:SetText(info.name .. " Assignement")
    self.frame.pages[i].name:SetFont(Assigner.constants.FONTS["Righteous"], 15)

    self.frame.pages[i].titleIcon = CreateFrame("Frame", nil, self.frame.pages[i])
    self.frame.pages[i].titleIcon:SetHeight(30)
    self.frame.pages[i].titleIcon:SetWidth(30)
    self.frame.pages[i].titleIcon:SetPoint("LEFT", self.frame.pages[i].name, "LEFT", -35, 0)
		self.frame.pages[i].titleIcon.texture = self.frame.pages[i].titleIcon:CreateTexture(nil, "ARTWORK")
    self.frame.pages[i].titleIcon.texture:SetAllPoints(self.frame.pages[i].titleIcon)
    self.frame.pages[i].titleIcon.texture:SetTexture(info.icon)

    -- Top Menu Bar of page
    self.frame.pages[i].topMenuBarFrame = CreateFrame("Frame", nil, self.frame.pages[i])
    self.frame.pages[i].topMenuBarFrame:SetWidth(420)
    self.frame.pages[i].topMenuBarFrame:SetHeight(210)
    self.frame.pages[i].topMenuBarFrame:SetPoint("TOPLEFT", 10, -50)

    self.frame.pages[i].shortAnnounceCheckBox = self:CreateCheckButtonWithText(self.frame.pages[i].topMenuBarFrame, "Page"..i.."ShortAnnounceCheckBox" , {x=85, y=0}, "Short Announce", function () Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].ShortStringMode = this:GetChecked() end)
    
    self.frame.pages[i].resetAssigns = self:CreateButton(self.frame.pages[i].topMenuBarFrame, "Page"..i.."ResetAssignementButton" ,  {x=70, y=-38}, {w=140, h=30}, "Reset Assigns", Assigner.ui.ResetAssigns)
    self.frame.pages[i].sendButton = self:CreateButton(self.frame.pages[i].topMenuBarFrame, "Page"..i.."SendAssignementButton" , {x=70, y=-70}, {w=140, h=30}, "Send Assign", Assigner.PostAssignement)

    -- channel type of page
    self:CreateNormalText(self.frame.pages[i].topMenuBarFrame, {x=310, y=-2}, "Channel"):SetFont("Fonts\\FRIZQT__.TTF", 15)
    self.frame.pages[i].channelTypeGroup = {}
    self.frame.pages[i].channelTypeRaidCheckBox = self:CreateCheckButtonWithText(self.frame.pages[i].topMenuBarFrame, "Page"..i.."ChannelTypeRaidCheckBox" , {x=280, y=-23}, "Raid", self.OnChannelTypeCheckBoxClicked)
    self.frame.pages[i].channelTypeRaidCheckBox.id = 1
    self.frame.pages[i].channelTypeRaidWarningCheckBox = self:CreateCheckButtonWithText(self.frame.pages[i].topMenuBarFrame, "Page"..i.."ChannelTypeRaidWarningCheckBox" , {x=280, y=-48}, "Raid Warning", self.OnChannelTypeCheckBoxClicked)
    self.frame.pages[i].channelTypeRaidWarningCheckBox.id = 2
    self.frame.pages[i].channelTypeCustomCheckBox = self:CreateCheckButtonWithText(self.frame.pages[i].topMenuBarFrame, "Page"..i.."ChannelTypeCustomCheckBox", {x=280, y=-74}, "Custom Channel", self.OnChannelTypeCheckBoxClicked)
    self.frame.pages[i].channelTypeCustomCheckBox.id = 3

    self.frame.pages[i].channelTypeGroup["ChannelTypeRaidCheckBox"] = self.frame.pages[i].channelTypeRaidCheckBox
    self.frame.pages[i].channelTypeGroup["ChannelTypeRaidWarningCheckBox"] = self.frame.pages[i].channelTypeRaidWarningCheckBox
    self.frame.pages[i].channelTypeGroup["ChannelTypeCustomCheckBox"] = self.frame.pages[i].channelTypeCustomCheckBox

    self.frame.pages[i].channelEditBox = self:CreateEditBox(self.frame.pages[i].topMenuBarFrame, "Page"..i.."ChannelEditBox" , {x=400,y=-75}, {w=15,h=30})
    self.frame.pages[i].channelEditBox:SetMaxLetters(1)
    self.frame.pages[i].channelEditBox:SetScript("OnEnterPressed", self.OnCustomChanelEditBoxEnterPressed)

		self.frame.scrollFrames[i]:SetScrollChild(self.frame.pages[i])
  end
  
  self.frame.scrollFrames[Assigner.db.profile.CurrentFrameID]:Show()

  
  self.frame.tankAssigmentButton = self:CreateButton(self.frame, "TankAssignementButton", nil, {w=145, h=35}, self.pageInfos[1].name, Assigner.ui.OnPageSwitch)
  self.frame.tankAssigmentButton:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 20, -100)
  self.frame.tankAssigmentButton.id = 1
  self.frame.stunAssigmentButton = self:CreateButton(self.frame, "StunAssignementButton", nil, {w=145, h=35}, self.pageInfos[2].name, Assigner.ui.OnPageSwitch)
  self.frame.stunAssigmentButton:SetPoint("TOPLEFT", self.frame.tankAssigmentButton, "BOTTOMLEFT", 0, -2)
  self.frame.stunAssigmentButton.id = 2
  self.frame.divineIntAssigmentButton = self:CreateButton(self.frame, "DivineIntAssignementButton", nil, {w=145, h=35}, self.pageInfos[3].name, Assigner.ui.OnPageSwitch)
  self.frame.divineIntAssigmentButton:SetPoint("TOPLEFT", self.frame.stunAssigmentButton, "BOTTOMLEFT", 0, -2)
  self.frame.divineIntAssigmentButton.id = 3

  self.frame.section = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.frame.section:SetPoint("TOP", self.frame.tankAssigmentButton, "TOP", 0, 35)
  self.frame.section:SetText("Sections")
  self.frame.section:SetFont(Assigner.constants.FONTS["Lobster"], 30)
  self.frame.section:SetTextColor(228/255, 190/255, 120/255)

  local page = 2

  local iconFrame
  iconFrame = CreateFrame("Frame", nil, self.frame.pages[page].topMenuBarFrame)
  iconFrame:SetWidth(30)
  iconFrame:SetHeight(90)
  iconFrame:SetPoint("BOTTOMLEFT", 0, 0)

  self:CreateRaidTargetTexture(iconFrame, {x=50,y=0}, "SKULL")
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 8, 1, {x=80,y=0}, {"WARRIOR", "PALADIN", "ROGUE"})
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 8, 2, {x=240,y=0}, {"WARRIOR", "PALADIN", "ROGUE"})

  -- Row 2 (Cross)
  self:CreateRaidTargetTexture(iconFrame, {x=50,y=-48}, "CROSS")
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 7, 1, {x=80,y=-48}, {"WARRIOR", "PALADIN", "ROGUE"})
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 7, 2, {x=240,y=-48}, {"WARRIOR", "PALADIN", "ROGUE"})

  -- Row 3 (Square)
  self:CreateRaidTargetTexture(iconFrame, {x=50,y=-96}, "SQUARE")
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 6, 1, {x=80,y=-96}, {"WARRIOR", "PALADIN", "ROGUE"})
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 6, 2, {x=240,y=-96}, {"WARRIOR", "PALADIN", "ROGUE"})

  -- Row 4 (Triangle)
  self:CreateRaidTargetTexture(iconFrame, {x=50,y=-144}, "TRIANGLE")
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 4, 1, {x=80,y=-144}, {"WARRIOR", "PALADIN", "ROGUE"})
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 4, 2, {x=240,y=-144}, {"WARRIOR", "PALADIN", "ROGUE"})

  -- Row 4 (Diamond)
  self:CreateRaidTargetTexture(iconFrame, {x=50,y=-192}, "DIAMOND")
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 3, 1, {x=80,y=-192}, {"WARRIOR", "PALADIN", "ROGUE"})
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 3, 2, {x=240,y=-192}, {"WARRIOR", "PALADIN", "ROGUE"})

  -- Row 5 (Moon)
  self:CreateRaidTargetTexture(iconFrame, {x=50,y=-240}, "MOON")
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 5, 1, {x=80,y=-240}, {"WARRIOR", "PALADIN", "ROGUE"})
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 5, 2, {x=240,y=-240}, {"WARRIOR", "PALADIN", "ROGUE"})

  -- Row 5 (Star)
  self:CreateRaidTargetTexture(iconFrame, {x=50,y=-288}, "STAR")
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 1, 1, {x=80,y=-288}, {"WARRIOR", "PALADIN", "ROGUE"})
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 1, 2, {x=240,y=-288}, {"WARRIOR", "PALADIN", "ROGUE"})

  -- Row 5 (Circle)
  self:CreateRaidTargetTexture(iconFrame, {x=50,y=-336}, "CIRCLE")
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 2, 1, {x=80,y=-336}, {"WARRIOR", "PALADIN", "ROGUE"})
  self:CreateDropDownPlayerMenu(iconFrame, "Page"..page.."DropDownPlayer", 2, 2, {x=240,y=-336}, {"WARRIOR", "PALADIN", "ROGUE"})

  self.frame:Hide()
end

function Assigner.ui:SetupUi()
  for i,name in ipairs(self.pageInfos) do
    self.frame.pages[i].shortAnnounceCheckBox:SetChecked(Assigner.db.profile.Pages[i].ShortStringMode)
    -----------
    -- Channel Type
    ----------- 
    if(Assigner.db.profile.Pages[i].ChannelType == 3) then  self.frame.pages[i].channelTypeCustomCheckBox:SetChecked(true)
    else
      self.frame.pages[i].channelEditBox:Hide()
      if (Assigner.db.profile.Pages[i].ChannelType == 2) then self.frame.pages[i].channelTypeRaidWarningCheckBox:SetChecked(true)
      else self.frame.pages[i].channelTypeRaidCheckBox:SetChecked(true)
      end
    end
    self.frame.pages[i].channelEditBox:SetText(Assigner.db.profile.Pages[i].CustomChannel)
  end
  
  ------------
  -- Assigns
  ------------

  page = 2

  for i=1,table.getn(Assigner.db.profile.Pages[page].Players) do
    for j=1,table.getn(Assigner.db.profile.Pages[page].Players[i]) do
      local dropDownText = getglobal("Page"..page.."DropDownPlayer"..i..j.."Text")
      dropDownText:SetText(Assigner.db.profile.Pages[page].Players[i][j])
    end
  end
end

function Assigner.ui:ResetAssigns()
  Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].Assigns = defaults.pages[Assigner.db.profile.CurrentFrameID].Assigns

  for key, value in Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].Assigns do
    local obj = getglobal(key.."Text")
    if(obj) then
      obj:SetText(value)
    end
  end
end

function Assigner.ui:OnPageSwitch()
	Assigner.ui.frame.scrollFrames[Assigner.db.profile.CurrentFrameID]:Hide()
	Assigner.ui.frame.scrollFrames[this.id]:Show()
	Assigner.db.profile.CurrentFrameID = this.id
end

function Assigner.ui:OnCustomChanelEditBoxEnterPressed()
  local number = tonumber(this:GetText())
  if number then Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].CustomChannel = number
  else this:SetText(Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].CustomChannel)
  end
  this:ClearFocus()
end

function Assigner.ui:OnChannelTypeCheckBoxClicked()
  local currentPage = Assigner.ui.frame.pages[Assigner.db.profile.CurrentFrameID]
  if this:GetChecked() then
    for _,v in pairs(currentPage.channelTypeGroup) do
      if (v.id ~= this.id) then v:SetChecked(false)
      end
    end

    if this.id == 3 then currentPage.channelEditBox:Show()
    else currentPage.channelEditBox:Hide()
    end

    Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].ChannelType = this.id
  else this:SetChecked(true) -- Disable Self Uncheck
  end
end