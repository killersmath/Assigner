PaladinDIMonitor = Assigner:NewModule("PaladinDIMonitor")

PaladinDIMonitor.defaultDB = {
  WindowPosition = {"CENTER", 0, 0},
}

PaladinDIMonitor.consoleCMD = "DI"

PaladinDIMonitor.consoleOptions = {
  order = 2,
  name = "Show/Hide", 
  type = "execute",
  desc = "Show/Hide Interface",
  func = function() if (PaladinDIMonitor.ui.PaladinDIMonitor:IsShown()) then PaladinDIMonitor.ui.PaladinDIMonitor:Hide() else PaladinDIMonitor.ui.PaladinDIMonitor:Show() end end,
}

local _playerName = UnitName("player");
local _, _class = UnitClass("player");


local _players = {
  [1] = {
    paladin = "NONE",
    target = "NONE",
    status = 1
  },
  [2] = {
    paladin = "NONE",
    target = "NONE",
    status = 1
  },
  [3] = {
    paladin = "NONE",
    target = "NONE",
    status = 1
  },
  [4] = {
    paladin = "NONE",
    target = "NONE",
    status = 1
  },
  [5] = {
    paladin = "NONE",
    target = "NONE",
    status = 1
  }
}

local _statusIcons = {
  [1] = {
    width = 15,
    height = 7.5,
    texturePath = "Interface\\AddOns\\Assigner\\Media\\Minus",
    textureCoords = {0, 1, 0, 1}
  },
  [2] = {
    width = 15,
    height = 15,
    texturePath = "Interface\\AddOns\\Assigner\\Media\\Yes_No",
    textureCoords = {0, 0.5, 0, 1}
  },
  [3] = {
    width = 15,
    height = 15,
    texturePath = "Interface\\AddOns\\Assigner\\Media\\Yes_No",
    textureCoords = {0.5, 1, 0, 1}
  }, 
}

-- Overwritte default initialize
function PaladinDIMonitor:OnInitialize()
  if(_class == "PALADIN") then
    self.core:RegisterModule(self.name, self)
  end
end

function PaladinDIMonitor:OnRegister()
  self:CreateWindow()
  self:UpdateUi()

  self.ui.PaladinDIMonitor:Hide()
end

function PaladinDIMonitor:ShowGUI()
  if (self.ui.PaladinDIMonitor) then
    self.ui.PaladinDIMonitor:Show()
  end
end

function PaladinDIMonitor:HideGUI()
  if (self.ui.PaladinDIMonitor) then
    self.ui.PaladinDIMonitor:Hide()
  end
end

function PaladinDIMonitor:CreateWindow()
    -- Main Frame
    self.ui.PaladinDIMonitor = CreateFrame("Frame", nil, UIParent)
    self.ui.PaladinDIMonitor:SetFrameStrata("FULLSCREEN_DIALOG")
    self.ui.PaladinDIMonitor:SetWidth(265)
    self.ui.PaladinDIMonitor:SetHeight(172)
    self.ui.PaladinDIMonitor:SetPoint(unpack(self.db.char.WindowPosition))
    self.ui.PaladinDIMonitor:EnableMouse(true)
    self.ui.PaladinDIMonitor:SetMovable(true)
    self.ui.PaladinDIMonitor:RegisterForDrag("LeftButton")
    self.ui.PaladinDIMonitor:SetClampedToScreen( true )
    self.ui.PaladinDIMonitor:SetScript("OnDragStart", function () self.ui.PaladinDIMonitor:StartMoving() end)
    self.ui.PaladinDIMonitor:SetScript("OnDragStop", function () 
      self.ui.PaladinDIMonitor:StopMovingOrSizing() 
      _, _, relativePoint, xOfs, yOfs = this:GetPoint()
      self.db.char.WindowPosition = {relativePoint, xOfs, yOfs} end)
    self.ui.PaladinDIMonitor:SetScript("OnHide", function ()  self.ui.PaladinDIMonitor:StopMovingOrSizing() end)
    self.ui.PaladinDIMonitor:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
     edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
     tile="true",
     edgeSize=10,
     tileSize=16,
     insets = {left=2, right=2, top=2, bottom=2}})
    self.ui.PaladinDIMonitor:SetBackdropColor(0, 0, 0, 0.9)
    self.ui.PaladinDIMonitor:SetBackdropBorderColor(0, 0, 0, 1)
  
    -- Title Frame Background

    self.ui.PaladinDIMonitor.TitleBackground = CreateFrame("Frame", nil, self.ui.PaladinDIMonitor)
    self.ui.PaladinDIMonitor.TitleBackground:Lower()
    self.ui.PaladinDIMonitor.TitleBackground:SetHeight(30)
    self.ui.PaladinDIMonitor.TitleBackground:SetPoint("TOPLEFT", 0, 0)
    self.ui.PaladinDIMonitor.TitleBackground:SetPoint("TOPRIGHT", 0, 0)
    self.ui.PaladinDIMonitor.TitleBackground:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
       edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
       tile="true",
       edgeSize=10,
       tileSize=16,
       insets = {left=2, right=2, top=2, bottom=2}})
    self.ui.PaladinDIMonitor.TitleBackground:SetBackdropColor(0, 0, 0, 0.7)
    self.ui.PaladinDIMonitor.TitleBackground:SetBackdropBorderColor(0, 0, 0, 1)

    -- Title Frame
    self.ui.PaladinDIMonitor.TitleFrame = CreateFrame("Frame", nil, self.ui.PaladinDIMonitor)
    self.ui.PaladinDIMonitor.TitleFrame:SetHeight(30)
    self.ui.PaladinDIMonitor.TitleFrame:SetPoint("TOPLEFT", 0, 0)
    self.ui.PaladinDIMonitor.TitleFrame:SetPoint("TOPRIGHT", 0, 0)
    -- Title Texts
    self.ui.PaladinDIMonitor.TitleText_Paladin = self.ui.PaladinDIMonitor.TitleFrame:CreateFontString(nil,"ARTWORK") 
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetPoint("TOPLEFT", 10, -8)
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetFont(Assigner.constants.FONTS["Roboto-Bold"], 12)
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetText("Paladin")
  
    self.ui.PaladinDIMonitor.TitleText_Target = self.ui.PaladinDIMonitor.TitleFrame:CreateFontString(nil,"ARTWORK") 
    self.ui.PaladinDIMonitor.TitleText_Target:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.TitleText_Paladin, "TOPLEFT", 110, 0)
    self.ui.PaladinDIMonitor.TitleText_Target:SetFont(Assigner.constants.FONTS["Roboto-Bold"], 12)
    self.ui.PaladinDIMonitor.TitleText_Target:SetText("Target")
  
    self.ui.PaladinDIMonitor.TitleText_Status = self.ui.PaladinDIMonitor.TitleFrame:CreateFontString(nil,"ARTWORK") 
    self.ui.PaladinDIMonitor.TitleText_Status:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.TitleText_Target, "TOPLEFT", 90, 0)
    self.ui.PaladinDIMonitor.TitleText_Status:SetFont(Assigner.constants.FONTS["Roboto-Bold"], 12)
    self.ui.PaladinDIMonitor.TitleText_Status:SetText("Status")
  
    self.ui.PaladinDIMonitor.rows = {}
  
    for i=1,5 do
      self.ui.PaladinDIMonitor.rows[i] = CreateFrame("Frame", nil, self.ui.PaladinDIMonitor)
      self.ui.PaladinDIMonitor.rows[i]:SetWidth(150)
      self.ui.PaladinDIMonitor.rows[i]:SetHeight(20)
  
      self.ui.PaladinDIMonitor.rows[i].paladinText =  self.ui.PaladinDIMonitor.rows[i]:CreateFontString(nil,"ARTWORK") 
      self.ui.PaladinDIMonitor.rows[i].paladinText:SetFont(Assigner.constants.FONTS["Roboto"], 11)
      self.ui.PaladinDIMonitor.rows[i].paladinText:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.rows[i],  "TOPLEFT", 10, 0)
  
      self.ui.PaladinDIMonitor.rows[i].targetText =  self.ui.PaladinDIMonitor.rows[i]:CreateFontString(nil,"ARTWORK") 
      self.ui.PaladinDIMonitor.rows[i].targetText:SetFont(Assigner.constants.FONTS["Roboto"], 11)
      self.ui.PaladinDIMonitor.rows[i].targetText:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.rows[i].paladinText,  "TOPLEFT", 110, 0)
  
      self.ui.PaladinDIMonitor.rows[i].statusIcon = CreateFrame("Frame", nil, self.ui.PaladinDIMonitor)
      self.ui.PaladinDIMonitor.rows[i].statusIcon.texture = self.ui.PaladinDIMonitor.rows[i].statusIcon:CreateTexture(nil, "ARTWORK")

      if (i==1) then
        self.ui.PaladinDIMonitor.rows[i]:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor, 0, -35)
      else
        self.ui.PaladinDIMonitor.rows[i]:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.rows[i-1], "BOTTOMLEFT", 0, -3)
      end
    end

    -- Bottom Frame Background
    self.ui.PaladinDIMonitor.BottomBackground = CreateFrame("Frame", nil, self.ui.PaladinDIMonitor)
    self.ui.PaladinDIMonitor.BottomBackground:Lower()
    self.ui.PaladinDIMonitor.BottomBackground:SetHeight(26)
    self.ui.PaladinDIMonitor.BottomBackground:SetPoint("BOTTOMLEFT", 0, 0)
    self.ui.PaladinDIMonitor.BottomBackground:SetPoint("BOTTOMRIGHT", 0, 0)
    self.ui.PaladinDIMonitor.BottomBackground:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile="true",
        edgeSize=10,
        tileSize=16,
        insets = {left=2, right=2, top=2, bottom=2}})
    self.ui.PaladinDIMonitor.BottomBackground:SetBackdropColor(0, 0, 0, 0.7)
    self.ui.PaladinDIMonitor.BottomBackground:SetBackdropBorderColor(0, 0, 0, 1)

    -- Bottom Frame
    self.ui.PaladinDIMonitor.BottomFrame = CreateFrame("Frame", nil, self.ui.PaladinDIMonitor)
    self.ui.PaladinDIMonitor.BottomFrame:SetHeight(26)
    self.ui.PaladinDIMonitor.BottomFrame:SetPoint("BOTTOMLEFT", 0, 0)
    self.ui.PaladinDIMonitor.BottomFrame:SetPoint("BOTTOMRIGHT", 0, 0)

    -- Bottom Texts
    self.ui.PaladinDIMonitor.BottomText_Left = self.ui.PaladinDIMonitor.BottomFrame:CreateFontString(nil,"ARTWORK") 
    self.ui.PaladinDIMonitor.BottomText_Left:SetPoint("BOTTOMLEFT", 10, 8)
    self.ui.PaladinDIMonitor.BottomText_Left:SetFont(Assigner.constants.FONTS["Roboto-Bold"], 12)
    self.ui.PaladinDIMonitor.BottomText_Left:SetText("DI Assignement")

    local button = CreateFrame("Button", nil, self.ui.PaladinDIMonitor.BottomFrame)
end

function PaladinDIMonitor:UpdateUi()
  local count = 0
  for i=1,5 do
    if (_players[i].paladin ~= "NONE") then
      self.ui.PaladinDIMonitor.rows[i].paladinText:SetText(_players[i].paladin)
      self.ui.PaladinDIMonitor.rows[i].targetText:SetText(_players[i].target)
      self:UpdateStatusRow(i)

      self.ui.PaladinDIMonitor.rows[i].paladinText:Show()
      self.ui.PaladinDIMonitor.rows[i].targetText:Show()
      self.ui.PaladinDIMonitor.rows[i].statusIcon:Show()

      count = count + 1
    else
      self.ui.PaladinDIMonitor.rows[i].paladinText:Hide()
      self.ui.PaladinDIMonitor.rows[i].targetText:Hide()
      self.ui.PaladinDIMonitor.rows[i].statusIcon:Hide()
    end
  end

  if (count == 0) then
    self.ui.PaladinDIMonitor:SetHeight(70)
  else
    self.ui.PaladinDIMonitor:SetHeight(58 + 22.10 * count)
  end
end

function PaladinDIMonitor:UpdateStatusRow(row)
  self.ui.PaladinDIMonitor.rows[row].statusIcon:SetWidth(_statusIcons[_players[row].status].width)
  self.ui.PaladinDIMonitor.rows[row].statusIcon:SetHeight(_statusIcons[_players[row].status].height)

  if (_players[row].status == 1) then self.ui.PaladinDIMonitor.rows[row].statusIcon:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.rows[row].targetText,  "TOPLEFT", 103, -4.5)
  else self.ui.PaladinDIMonitor.rows[row].statusIcon:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.rows[row].targetText,  "TOPLEFT", 103, 0)
  end
  self.ui.PaladinDIMonitor.rows[row].statusIcon.texture:SetAllPoints(self.ui.PaladinDIMonitor.rows[row].statusIcon)
  self.ui.PaladinDIMonitor.rows[row].statusIcon.texture:SetTexture(_statusIcons[_players[row].status].texturePath)
  self.ui.PaladinDIMonitor.rows[row].statusIcon.texture:SetTexCoord(unpack(_statusIcons[_players[row].status].textureCoords))
end

function PaladinDIMonitor:OnEnable()
  --self.core:Print(self.name .. " Enabled")

  if AceLibrary("AceEvent-2.0"):IsFullyInitialized() then
		self:AceEvent_FullyInitialized()
	else
		self:RegisterEvent("AceEvent_FullyInitialized")
	end
end

function PaladinDIMonitor:AceEvent_FullyInitialized()
  self:RegisterEvent("SpellStatus_SpellCastInstant")
  self:RegisterEvent("Assigner_RecvSync")
end

function PaladinDIMonitor:OnDisable()
  --self.core:Print(self.name .. " Disabled")
  self:UnregisterAllEvents()
end

function PaladinDIMonitor:AssignCount()
  count = 0
  for i=1,5 do
    if (_players[i].paladin == "NONE") then
      break
    end
    count = count + 1
  end

  return count
end

function PaladinDIMonitor:SortPlayers()
  for i=1,4 do
    if(_players[i].paladin == "NONE") then
      for j=(i+1),5 do
        if(_players[j].paladin ~= "NONE") then
          local p = _players[i].paladin
          local t = _players[i].target
          _players[i].paladin = _players[j].paladin
          _players[i].target  = _players[j].target
          _players[j].paladin = p
          _players[j].target = t
        end
      end
    end
  end
end

function PaladinDIMonitor:FindPaladin(name)
  for i, data in pairs(_players) do
    if(data.paladin == name) then
      return i
    end
  end

  return nil
end

function PaladinDIMonitor:Assigner_RecvSync(sync, rest, sender)
  if(sync == "ASSCDI") then
    local index = self:FindPaladin(sender)
    if (index) then
      if(_players[index].status == 1) then
        if(rest == _players[index].target) then
          _players[index].status = 2
        else
          _players[index].status = 3
        end
        self:UpdateStatusRow(index)
      end
    end
  elseif (sync == "ASSPDI") then
    local _, _, index, paladin, target = string.find(rest, "(%d+) (%S+) (%S+)") -- "Index Paladin Target"

    if (index) then
      index = tonumber(index) -- From string to number
      _players[index].paladin = paladin
      _players[index].target = target
      _players[index].status = 1
      if(index == 5) then
        self:SortPlayers()
        self:UpdateUi()
      end
    end
  end
end

function PaladinDIMonitor:SpellStatus_SpellCastInstant(sId, sName, sRank, sFullName, sCastTime)
  if sName == "Divine Intervention" then
		local targetName = nil
		if spellTarget then
			targetName = spellTarget
			spellCasting = nil
			spellTarget = nil
		else
			if UnitExists("target") and UnitIsPlayer("target") and not UnitIsEnemy("target", "player") then
				targetName = UnitName("target")
			else
				targetName = UnitName("player")
			end
		end
    self:TriggerEvent("Assigner_SendSync", "ASSCDI "..targetName)
  end
end