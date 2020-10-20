Page_Paladin = Assigner:NewModule("Page_Paladin")

Page_Paladin.defaultDB = {
	ShortStringMode = false,
  ChannelType = 1,
  CustomChannel = 1,
  Players = {
  },
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
	self.ui.frame.pages[self.name].divineInterventionLayout.fontHeader:SetPoint("TOPLEFT", self.ui.frame.pages[self.name].divineInterventionLayout, "TOPLEFT", 50, 0)
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

  self.ui.frame.pages[self.name].divineInterventionLayout.textureDesc = self.ui.frame.pages[self.name].divineInterventionLayout:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.ui.frame.pages[self.name].divineInterventionLayout.textureDesc:SetPoint("TOPLEFT", self.ui.frame.pages[self.name].divineInterventionLayout, "TOPLEFT", 50, -30)
	self.ui.frame.pages[self.name].divineInterventionLayout.textureDesc:SetText("Bar Texture")
end

function Page_Paladin:SetupPage()
  if(self.core.db.char.CurrentPageID == self.name) then
    self.ui.frame.scrollFrames[self.name]:Show()
  end
end
