local globalLastAnnounceTime = 0
local delayTime = 1000 --ms

Assigner = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0", "AceHook-2.1", "FuBarPlugin-2.0")

local T  = AceLibrary("Tablet-2.0")

defaults = {
  Active = true,
  CurrentFrameID = 1,
  Pages = {
    [1] = {
      ShortStringMode = false,
      ChannelType = 1,
      CustomChannel = 1,
      Players = {
      },
    },
    [2] = {
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
    },
    [3] = {
      ShortStringMode = false,
      ChannelType = 1,
      CustomChannel = 1,
      Players = {
      },
    },
  },
}

Assigner.constants = {
	BACKDROP = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		tileSize = 16,
		insets = {left = -1.5, right = -1.5, top = -1.5, bottom = -1.5},
  },
  FONTS = {
    ["Lobster"]       = "Interface\\AddOns\\Assigner\\Media\\Fonts\\Lobster.ttf",
    ["Righteous"]       = "Interface\\AddOns\\Assigner\\Media\\Fonts\\Righteous.ttf",
  },
  CLASS_COLORS = {
    ["WARRIOR"]       = {0.78, 0.60, 0.43},
    ["MAGE"]          = {0.41, 0.80, 0.94},
    ["ROGUE"]         = {1.00, 0.96, 0.41},
    ["DRUID"]         = {1.00, 0.49, 0.04},
    ["HUNTER"]        = {0.67, 0.83, 0.45},
    ["SHAMAN"]        = {0.96, 0.55, 0.79},
    ["WARLOCK"]       = {0.58, 0.51, 0.79},
    ["PRIEST"]        = {1.00, 1.00, 1.00},
    ["PALADIN"]       = {0.96, 0.55, 0.73},
  },
  CLASS_ICON_TCOORDS = {
		["WARRIOR"]       = {0.0234375, 0.22656250, 0.0234375, 0.2265625},
		["MAGE"]          = {0.2734375, 0.47656250, 0.0234375, 0.2265625},
		["ROGUE"]         = {0.5234375, 0.72656250, 0.0234375, 0.2265625},
		["DRUID"]         = {0.7734375, 0.97265625, 0.0234375, 0.2265625},
		["HUNTER"]        = {0.0234375, 0.22656250, 0.2734375, 0.4765625},
		["SHAMAN"]        = {0.2734375, 0.47656250, 0.2734375, 0.4765625},
		["PRIEST"]        = {0.5234375, 0.72656250, 0.2734375, 0.4765625},
		["WARLOCK"]       = {0.7734375, 0.97265625, 0.2734375, 0.4765625},
		["PALADIN"]       = {0.0234375, 0.22656250, 0.5234375, 0.7265625},
  },
  RAID_TARGETS_TCOORDS = {
    ["SKULL"]         = {0.75, 1.00, 0.25, 0.50},
    ["CROSS"]         = {0.50, 0.75, 0.25, 0.50},
    ["SQUARE"]        = {0.25, 0.50, 0.25, 0.50},
    ["TRIANGLE"]      = {0.75, 1.00, 0.00, 0.25},
    ["DIAMOND"]       = {0.50, 0.75, 0.00, 0.25},
    ["MOON"]          = {0.00, 0.25, 0.25, 0.50},
    ["STAR"]          = {0.00, 0.25, 0.00, 0.25},
    ["CIRCLE"]        = {0.25, 0.50, 0.00, 0.25},
  },
  RAID_TARGETS_NUMBERS = {
    [1] = "Star",
    [2] = "Circle",
    [3] = "Diamond",
    [4] = "Triangle",
    [5] = "Moon",
    [6] = "Square",
    [7] = "Cross",
    [8] = "Skull",
  },
}

local options  = {
  type = "group",
  handler = Assigner,
  args =
  {
    Active =
    {
      name = "Active",
      desc = "Activate/Suspend 'Assigner'",
      type = "toggle",
      get  = "GetActiveStatusOption",
      set  = "SetActiveStatusOption",
      order = 1,
    },
    Show = 
    {
      order = 2,
      name = "Show", 
      type = "execute",
      desc = "Show Interface",
      func = function() Assigner.ui.mainFrame:Show() end,
      disabled = function() return not Assigner.db.profile.Active end,
    },
  },
}

---------
-- FuBar
---------
Assigner.hasIcon = [[Interface\AddOns\Assigner\Media\icon]]
Assigner.title = "Assigner"
Assigner.defaultMinimapPosition = 260
Assigner.defaultPosition = "CENTER"
Assigner.cannotDetachTooltip = true
Assigner.tooltipHiddenWhenEmpty = false
Assigner.hideWithoutStandby = true
Assigner.independentProfile = true

function Assigner:OnTooltipUpdate()
  --local groupType = self.db.profile.GroupType
  --local hint = string.format("%s\n|cffFFA500Click:|r Cycle Group Mode|r\n|cffFFA500Right-Click:|r Options",groupTypeDesc[groupType])
  local hint = "|cffFFA500Click:|r Show Window|r\n|cffFFA500Right-Click:|r Options"
  T:SetHint(hint)
end

function Assigner:OnTextUpdate()
  local active = self.db.profile.Active
  if (not active) then
    self:SetText("Suspended")
  else
    self:SetText("Assigner")
  end
end

function Assigner:OnClick()
  if(arg1 == "LeftButton") then
    self.ui.frame:Show();
  end
end

function Assigner:IconUpdate()
  if self.db.profile.Active then
    self:SetIcon([[Interface\AddOns\Assigner\Media\icon]])
  else
    self:SetIcon([[Interface\AddOns\Assigner\Media\icon_disabled]])
  end
end

function Assigner:OnEnable() -- PLAYER_LOGIN (2)
  self:IconUpdate()
  self:UpdateTooltip()
end

function Assigner:OnDisable()
  self:IconUpdate()
end

function Assigner:OnInitialize()
  self:RegisterDB("AssignerDB")
  self:RegisterDefaults("profile", defaults )

  self:RegisterChatCommand( { "/ass", "/assinger" }, options )
  self.OnMenuRequest = options
  
  self:CreateWindow()

  --DEFAULT_CHAT_FRAME:AddMessage(self.addon.title.." v"..self.addon.version.. " has been loaded.")
end

function Assigner:GetActiveStatusOption()
  return self.db.profile.Active
end

function Assigner:SetActiveStatusOption(newStatus)
  self.db.profile.Active = newStatus
  self:IconUpdate()
  self:UpdateText()
end

function Assigner:GetStunAssignementString(markID)
  local message = ""
  local firstPrint = true

  if(Assigner.db.profile.Pages[2].Players[markID][1] ~= "NONE" or Assigner.db.profile.Pages[2].Players[markID][2] ~= "NONE") then
    if(Assigner.db.profile.Pages[2].ShortStringMode or Assigner.db.profile.Pages[2].ChannelType == 2) then
      if(not firstPrint) then
        message = message .. "; "
      else
        firstPrint = false
      end
    else
      if(not firstPrint) then
        message = message .. "\n "
      else
        firstPrint = false
      end
    end

    message = message .. "("..Assigner.constants.RAID_TARGETS_NUMBERS[markID].."):"
    if(Assigner.db.profile.Pages[2].Players[markID][1] ~= "NONE") then
      Assigner:Print(Assigner.db.profile.Pages[2].Players, markID)
      message = message .. " " .. Assigner.db.profile.Pages[2].Players[markID][1]
        if(Assigner.db.profile.Pages[2].Players[markID][2] ~= "NONE") then
          message = message .. ", " .. Assigner.db.profile.Pages[2].Players[markID][2]
        end
    elseif(Assigner.db.profile.Pages[2].Players[markID][2] ~= "NONE") then
      message = message.." " .. Assigner.db.profile.Pages[2].Players[markID][2]
    end
  end
  return message
end

function Assigner:HasAssignInPage(page)
  local found = false

  for _, value in Assigner.db.profile.Pages[page].Players do
    if (value ~= "NONE") then
      found = true
      break
    end
  end

  return found
end

function Assigner:GetAssignementString()
  local currentPageID = Assigner.db.profile.CurrentFrameID
  local message = ""

  if (self:HasAssignInPage(currentPageID)) then
    if (not Assigner.db.profile.Pages[currentPageID].ShortStringMode and Assigner.db.profile.Pages[currentPageID].ChannelType ~= 2) then
      message = "=-------- " .. Assigner.ui.frame.pages[currentPageID].name:GetText()..  "--------=\n"
    end

    if (currentPageID == 2) then
      message = message .. Assigner:GetStunAssignementString(8)
      message = message .. Assigner:GetStunAssignementString(7)
      message = message .. Assigner:GetStunAssignementString(6)
      message = message .. Assigner:GetStunAssignementString(4)
      message = message .. Assigner:GetStunAssignementString(3)
      message = message .. Assigner:GetStunAssignementString(5)
      message = message .. Assigner:GetStunAssignementString(1)
      message = message .. Assigner:GetStunAssignementString(2)
    else 
      self:Print("Wrong Page")
    end
  else 
    message = "No Assigns"
  end

  return message
end

function Assigner:PostAssignement()
  local currentTime = time()
  if((globalLastAnnounceTime + delayTime/1000) > currentTime) then return end

  local message = Assigner:GetAssignementString()
  Assigner:SendMessage(message, Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].ChannelType, Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].CustomChannel)
  globalLastAnnounceTime = currentTime
end