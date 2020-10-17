Assigner.ui = {}

function Assigner:CreateWindow()
  self.ui:InitializeUi()
  self.ui:PopulateUi()
end

function Assigner.ui:InitializeUi()
  ---------------
  -- Main Frame
  ---------------
  self.frame = CreateFrame("Frame", nil, UIParent)
  self.frame:SetFrameStrata("DIALOG")
  self.frame:SetWidth(720) -- Set these to whatever height/width is needed 
  self.frame:SetHeight(400) -- for your Texture
  self.frame:SetPoint("CENTER", 0, 0)
  self.frame:EnableMouse(true)
  self.frame:SetMovable(true)
  self.frame:RegisterForDrag("LeftButton")
  self.frame:SetClampedToScreen( true )
  self.frame:SetScript("OnDragStart", function () self.frame:StartMoving() end)
  self.frame:SetScript("OnDragStop", function () self.frame:StopMovingOrSizing() end)
  self.frame:SetScript("OnHide", function () self.frame:StopMovingOrSizing() end)
  self.frame:SetBackdrop(Assigner.constants.backdrop)
  self.frame:SetBackdropColor(0, 0, 0, 0.9)

	self.frame.pages = {}
	self.frame.scrollFrames = {}
  self.frame.sliders = {}
  
  self.pageNames = { "Tank", "Stun/Kick/Pummel" }

  for i,name in ipairs(self.pageNames) do
		self.frame.scrollFrames[i] = CreateFrame("ScrollFrame", nil, self.frame)
		self.frame.scrollFrames[i]:SetHeight(350)
		self.frame.scrollFrames[i]:SetWidth(500)
		self.frame.scrollFrames[i].id = i

		self.frame.scrollFrames[i]:SetPoint("BOTTOMRIGHT", -30, 10)
		self.frame.scrollFrames[i]:Hide()
		self.frame.scrollFrames[i]:EnableMouseWheel(true)
		self.frame.scrollFrames[i]:SetBackdrop(Assigner.constants.backdrop)
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
		self.frame.sliders[i]:SetBackdrop(Assigner.constants.backdrop)
		self.frame.sliders[i]:SetBackdropColor(0,0,0,0.5)
		self.frame.sliders[i].thumbtexture = self.frame.sliders[i]:CreateTexture()
		self.frame.sliders[i].thumbtexture:SetTexture(0.18,0.27,0.5,1)
		self.frame.sliders[i]:SetThumbTexture(self.frame.sliders[i].thumbtexture)
		self.frame.sliders[i]:SetMinMaxValues(0,1)
		self.frame.sliders[i]:SetHeight(348)
		self.frame.sliders[i]:SetWidth(15)
		self.frame.sliders[i]:SetValue(0)
		self.frame.sliders[i].ScrollFrame = self.frame.scrollFrames[i]
		self.frame.sliders[i]:SetScript("OnValueChanged", function() this.ScrollFrame:SetVerticalScroll(this.ScrollFrame:GetVerticalScrollRange()*this:GetValue()) end  )

		self.frame.pages[i] = CreateFrame("Frame", name.." Page", self.frame.scrollFrames[i])
		self.frame.pages[i]:SetHeight(1)
		self.frame.pages[i]:SetWidth(500)

		self.frame.pages[i].name = self.frame.pages[i]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		self.frame.pages[i].name:SetPoint("TOP", self.frame.pages[i], "TOP", 0, -10)
		self.frame.pages[i].name:SetHeight(30)
		self.frame.pages[i].name:SetJustifyH("LEFT")
		self.frame.pages[i].name:SetTextColor(1,1,1)
    self.frame.pages[i].name:SetText(name)

		self.frame.scrollFrames[i]:SetScrollChild(self.frame.pages[i])

  end
  
  self.frame.scrollFrames[Assigner.db.profile.CurrentFrameID]:Show()
  
  self.frame.tankAssigmentButton = self:CreateOptionsButton(1, "TankAssignementButton",	self.pageNames[1]	, self.frame, {anchor="TOPLEFT", x=20, y=-60})
	self.frame.stunAssigmentButton = self:CreateOptionsButton(2, "StunAssignementButton",	 self.pageNames[2] , self.frame.tankAssigmentButton, {anchor="BOTTOMLEFT",x=0, y=-2})
	
  local page = 2

  -- Frame
  self.frame.pages[page].topMenuBarFrame = CreateFrame("Frame", nil, self.frame.pages[page])
  self.frame.pages[page].topMenuBarFrame:SetWidth(420)
  self.frame.pages[page].topMenuBarFrame:SetHeight(210)
  self.frame.pages[page].topMenuBarFrame:SetPoint("TOPLEFT", 10, -50)

  self.frame.pages[page].shortAnnounceCheckBox = self:CreateCheckButtonWithText(self.frame.pages[page].topMenuBarFrame, "ShortAnnounceCheckBox" , {x=85, y=0}, "Short Announce", function () Assigner.db.profile.ShortStringMode = this:GetChecked() end)
  
  self.frame.pages[page].resetAssigns = self:CreateButton(self.frame.pages[page].topMenuBarFrame, {x=70, y=-38}, {w=140, h=30}, "Reset Assigns", Assigner.ui.ResetAssigns)
  self.frame.pages[page].sendButton = self:CreateButton(self.frame.pages[page].topMenuBarFrame, {x=70, y=-70}, {w=140, h=30}, "Send Assigment", Assigner.PostAssignement)

  -- channel type
  self:CreateNormalText(self.frame.pages[page].topMenuBarFrame, {x=310, y=-2}, "Channel"):SetFont("Fonts\\FRIZQT__.TTF", 15)
  self.frame.pages[page].channelTypeGroup = {}
  self.frame.pages[page].channelTypeRaidCheckBox = self:CreateCheckButtonWithText(self.frame.pages[page].topMenuBarFrame, "ChannelTypeRaidCheckBox" , {x=280, y=-23}, "Raid", self.OnChannelTypeCheckBoxClicked)
  self.frame.pages[page].channelTypeRaidCheckBox.id = 1
  self.frame.pages[page].channelTypeRaidWarningCheckBox = self:CreateCheckButtonWithText(self.frame.pages[page].topMenuBarFrame, "ChannelTypeRaidWarningCheckBox" , {x=280, y=-48}, "Raid Warning", self.OnChannelTypeCheckBoxClicked)
  self.frame.pages[page].channelTypeRaidWarningCheckBox.id = 2
  self.frame.pages[page].channelTypeCustomCheckBox = self:CreateCheckButtonWithText(self.frame.pages[page].topMenuBarFrame, "ChannelTypeCustomCheckBox", {x=280, y=-74}, "Custom Channel", self.OnChannelTypeCheckBoxClicked)
  self.frame.pages[page].channelTypeCustomCheckBox.id = 3

  self.frame.pages[page].channelTypeGroup["ChannelTypeRaidCheckBox"] = self.frame.pages[page].channelTypeRaidCheckBox
  self.frame.pages[page].channelTypeGroup["ChannelTypeRaidWarningCheckBox"] = self.frame.pages[page].channelTypeRaidWarningCheckBox
  self.frame.pages[page].channelTypeGroup["ChannelTypeCustomCheckBox"] = self.frame.pages[page].channelTypeCustomCheckBox

  self.frame.pages[page].channelEditBox = self:CreateEditBox(self.frame.pages[page].topMenuBarFrame, {x=400,y=-75}, {w=15,h=30})
  self.frame.pages[page].channelEditBox:SetMaxLetters(1)
  self.frame.pages[page].channelEditBox:SetScript("OnEnterPressed", function()
    local number = tonumber(this:GetText())
    if number then Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].CustomChannel = number
    else this:SetText(Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].CustomChannel)
    end
  end)

  local iconFrame
  iconFrame = CreateFrame("Frame", nil, self.frame.pages[page].topMenuBarFrame)
  iconFrame:SetWidth(30)
  iconFrame:SetHeight(90)
  iconFrame:SetPoint("BOTTOMLEFT", 0, 0)

  local prefix = Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].Assigns.Prefix

  self:CreateIconTexture(iconFrame, {x=50,y=0}, {left=0.75,right=1,top=0.25,bottom=0.5})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 8, 1, {x=80,y=0})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 8, 2, {x=240,y=0})

  -- Row 2 (Cross)
  self:CreateIconTexture(iconFrame, {x=50,y=-48}, {left=0.5,right=0.75,top=0.25,bottom=0.5})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 7, 1, {x=80,y=-48})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 7, 2, {x=240,y=-48})

  -- Row 3 (Square)
  self:CreateIconTexture(iconFrame, {x=50,y=-96}, {left=0.25,right=0.5,top=0.25,bottom=0.5})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 6, 1, {x=80,y=-96})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 6, 2, {x=240,y=-96})

  -- Row 4 (Triangle)
  self:CreateIconTexture(iconFrame, {x=50,y=-144}, {left=0.75,right=1,top=0,bottom=0.25})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 4, 1, {x=80,y=-144})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 4, 2, {x=240,y=-144})

  -- Row 4 (Diamond)
  self:CreateIconTexture(iconFrame, {x=50,y=-192}, {left=0.5,right=0.75,top=0,bottom=0.25})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 3, 1, {x=80,y=-192})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 3, 2, {x=240,y=-192})

  -- Row 5 (Moon)
  self:CreateIconTexture(iconFrame, {x=50,y=-240}, {left=0,right=0.25,top=0.25,bottom=0.5})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 5, 1, {x=80,y=-240})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 5, 2, {x=240,y=-240})

  -- Row 5 (Star)
  self:CreateIconTexture(iconFrame, {x=50,y=-288}, {left=0,right=0.25,top=0,bottom=0.25})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 1, 1, {x=80,y=-288})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 1, 2, {x=240,y=-288})

  -- Row 5 (Circle)
  self:CreateIconTexture(iconFrame, {x=50,y=-336}, {left=0.25,right=0.5,top=0,bottom=0.25})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 2, 1, {x=80,y=-336})
  self:CreateDropDownPlayerMenu(iconFrame, prefix, 2, 2, {x=240,y=-336})

  ---------------
  ---- Close Button
  ---------------
  
  self.frame.closeButton = CreateFrame("Button", "YourCloseButtonName", self.frame, "UIPanelCloseButton")
  self.frame.closeButton:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", 15, 15)
  self.frame.closeButton:SetScript("OnClick", function() self.frame:Hide() end)

  self.frame:Hide()
end

function Assigner.ui:PopulateUi()
  local page = 2
  self.frame.pages[page].shortAnnounceCheckBox:SetChecked(Assigner.db.profile.Pages[page].ShortStringMode)
  -----------
  -- Channel Type
  ----------- 
  if(Assigner.db.profile.Pages[page].ChannelType == 3) then  self.frame.pages[page].channelTypeCustomCheckBox:SetChecked(true)
  else
    self.frame.pages[page].channelEditBox:Hide()
    if (Assigner.db.profile.Pages[page].ChannelType == 2) then self.frame.pages[page].channelTypeRaidWarningCheckBox:SetChecked(true)
    else self.frame.pages[page].channelTypeRaidCheckBox:SetChecked(true)
    end
  end
  self.frame.pages[page].channelEditBox:SetText(Assigner.db.profile.Pages[page].CustomChannel)
  ------------
  -- Assigns
  ------------

  for key, value in Assigner.db.profile.Pages[page].Assigns.Data do
    local obj = getglobal(key.."Text")
    if(obj) then
      obj:SetText(value)
      --obj:SetFont("Fonts\\FRIZQT__.TTF", 9)
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