PaladinDIMonitor = Assigner:NewModule("PaladinDIMonitor")

local _playerName = UnitName("player");
local _, _class = UnitClass("player");

PaladinDIMonitor.defaultDB = {
  WindowPosition = {"CENTER", 0, 0},
}

PaladinDIMonitor.consoleCMD = "DI"
PaladinDIMonitor.consoleOptions = {
	type = "group",
	name = "Divine Invervention",
	desc = "Options for Divine Intervention Module",
	args   = {
		["show"] = {
			type = "execute",
			name = "Show GUI",
			desc = "Show the Divine Intervention GUI.",
			order = 1,
			func = function() PaladinDIMonitor:ShowGUI() end,
    },
    ["hide"] = {
			type = "execute",
			name = "Hide GUI",
			desc = "Hide the Divine Intervention GUI.",
			order = 2,
			func = function() PaladinDIMonitor:HideGUI() end,
    },
	}
}


local _players = {
  [1] = {
    paladin = "Gohk",
    target = "Target-1",
    status = 2
  },
  [2] = {
    paladin = "Andromedus",
    target = "Target-2",
    status = 3
  },
  [3] = {
    paladin = "Paladin-3",
    target = "Target-3",
    status = 1
  },
  [4] = {
    paladin = "NONE",
    target = "Target-4",
    status = 1
  },
  [5] = {
    paladin = "NONE",
    target = "Target-5",
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
  --if(_class == "PALADIN") then
    self.core:RegisterModule(self.name, self)
  --end
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
    self.ui.PaladinDIMonitor:SetFrameStrata("DIALOG")
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
    self.ui.PaladinDIMonitor.TitleFrame = CreateFrame("Frame", nil, self.ui.PaladinDIMonitor)
    self.ui.PaladinDIMonitor.TitleFrame:SetFrameStrata("BACKGROUND")
    self.ui.PaladinDIMonitor.TitleFrame:SetHeight(30)
    self.ui.PaladinDIMonitor.TitleFrame:SetPoint("TOPLEFT", 0, 0)
    self.ui.PaladinDIMonitor.TitleFrame:SetPoint("TOPRIGHT", 0, 0)
    self.ui.PaladinDIMonitor.TitleFrame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
       edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
       tile="true",
       edgeSize=10,
       tileSize=16,
       insets = {left=2, right=2, top=2, bottom=2}})
    self.ui.PaladinDIMonitor.TitleFrame:SetBackdropColor(0, 0, 0, 0.7)
    self.ui.PaladinDIMonitor.TitleFrame:SetBackdropBorderColor(0, 0, 0, 1)
  
    -- Title Texts
    self.ui.PaladinDIMonitor.TitleText_Paladin = self.ui.PaladinDIMonitor:CreateFontString(nil,"ARTWORK") 
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetPoint("TOPLEFT", 10, -8)
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetFont(Assigner.constants.FONTS["Roboto-Bold"], 12)
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetText("Paladin")
  
    self.ui.PaladinDIMonitor.TitleText_Target = self.ui.PaladinDIMonitor:CreateFontString(nil,"ARTWORK") 
    self.ui.PaladinDIMonitor.TitleText_Target:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.TitleText_Paladin, "TOPLEFT", 110, 0)
    self.ui.PaladinDIMonitor.TitleText_Target:SetFont(Assigner.constants.FONTS["Roboto-Bold"], 12)
    self.ui.PaladinDIMonitor.TitleText_Target:SetText("Target")
  
    self.ui.PaladinDIMonitor.TitleText_Status = self.ui.PaladinDIMonitor:CreateFontString(nil,"ARTWORK") 
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
    self.ui.PaladinDIMonitor.TitleFrame = CreateFrame("Frame", nil, self.ui.PaladinDIMonitor)
    self.ui.PaladinDIMonitor.TitleFrame:SetFrameStrata("BACKGROUND")
    self.ui.PaladinDIMonitor.TitleFrame:SetHeight(26)
    self.ui.PaladinDIMonitor.TitleFrame:SetPoint("BOTTOMLEFT", 0, 0)
    self.ui.PaladinDIMonitor.TitleFrame:SetPoint("BOTTOMRIGHT", 0, 0)
    self.ui.PaladinDIMonitor.TitleFrame:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile="true",
        edgeSize=10,
        tileSize=16,
        insets = {left=2, right=2, top=2, bottom=2}})
    self.ui.PaladinDIMonitor.TitleFrame:SetBackdropColor(0, 0, 0, 0.7)
    self.ui.PaladinDIMonitor.TitleFrame:SetBackdropBorderColor(0, 0, 0, 1)

    -- Bottom Texts
    self.ui.PaladinDIMonitor.TitleText_Paladin = self.ui.PaladinDIMonitor:CreateFontString(nil,"ARTWORK") 
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetPoint("BOTTOMLEFT", 10, 8)
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetFont(Assigner.constants.FONTS["Roboto-Bold"], 12)
    self.ui.PaladinDIMonitor.TitleText_Paladin:SetText("DI Assignement")

    local button = CreateFrame("Button", nil, self.ui.PaladinDIMonitor)
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
    self.ui.PaladinDIMonitor:SetHeight(60 + 22 * count)
  end
end

function PaladinDIMonitor:UpdateStatusRow(row)
  self.ui.PaladinDIMonitor.rows[row].statusIcon:SetWidth(_statusIcons[_players[row].status].width)
  self.ui.PaladinDIMonitor.rows[row].statusIcon:SetHeight(_statusIcons[_players[row].status].height)

  if (_players[row].status == 1) then self.ui.PaladinDIMonitor.rows[row].statusIcon:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.rows[row].targetText,  "TOPLEFT", 103, -4.5)
  else self.ui.PaladinDIMonitor.rows[row].statusIcon:SetPoint("TOPLEFT", self.ui.PaladinDIMonitor.rows[row].targetText,  "TOPLEFT", 103, 0)
  end
  self.ui.PaladinDIMonitor.rows[row].statusIcon.texture = self.ui.PaladinDIMonitor.rows[row].statusIcon:CreateTexture(nil, "ARTWORK")
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
  --self:RegisterEvent("SpellStatus_SpellCastInstant")
  --self:RegisterEvent("Assigner_SendSync")
  --self:RegisterEvent("CHAT_MSG_ADDON")

  --self:RegisterEvent("Assigner_RecvSync")
end

function PaladinDIMonitor:OnDisable()
  --self.core:Print(self.name .. " Disabled")
  self:UnregisterAllEvents()
end

function PaladinDIMonitor:Assigner_SendSync(msg)
	local _, _, sync, rest = string.find(msg, "(%S+)%s*(.*)$")

	if not sync then return end

  SendAddonMessage("Assigner", msg, "RAID")
  self:CHAT_MSG_ADDON("Assigner", msg, "RAID", _playerName)
end

function PaladinDIMonitor:CHAT_MSG_ADDON(prefix, message, type, sender)
	if prefix ~= "Assigner" or type ~= "RAID" then return end

	local _, _, sync, rest = string.find(message, "(%S+)%s*(.*)$")
	if not sync then return end

	self:TriggerEvent("Assigner_RecvSync", sync, rest, sender)
end

function PaladinDIMonitor:Assigner_RecvSync( sync, rest, nick )
  self.core:Print("Sync " .. sync)
  self.core:Print("Rest " .. rest)
  self.core:Print("Nick " .. nick)
end

function PaladinDIMonitor:SpellStatus_SpellCastInstant(sId, sName, sRank, sFullName, sCastTime)
  --if sName == BS["Fear Ward"] then
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
  --end
end