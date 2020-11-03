globalLastAnnounceTime = 0
delayTime = 1000 --ms

Assigner = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceModuleCore-2.0", "AceEvent-2.0", "AceHook-2.1", "FuBarPlugin-2.0")
Assigner:SetModuleMixins("AceDebug-2.0", "AceEvent-2.0")
Assigner.ui = {}

local T  = AceLibrary("Tablet-2.0")

Assigner.defaultDB = {
  Active = true,
  CurrentPageID = "TankPage",
  WindowPosition = {"CENTER", 0, 0},
}

Assigner.cmdTable  = {
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
      func = function() Assigner.ui.frame:Show() end,
      disabled = function() return not Assigner.db.char.Active end,
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
    ["Lobster"]        = "Interface\\AddOns\\Assigner\\Media\\Fonts\\Lobster.ttf",
    ["Righteous"]      = "Interface\\AddOns\\Assigner\\Media\\Fonts\\Righteous.ttf",
    ["Roboto"]         = "Interface\\AddOns\\Assigner\\Media\\Fonts\\Roboto-Regular.ttf",
    ["Roboto-Bold"]    = "Interface\\AddOns\\Assigner\\Media\\Fonts\\Roboto-Bold.ttf",
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

Assigner:RegisterDB("AssignerDB")
Assigner:RegisterDefaults("char", Assigner.defaultDB )
Assigner:RegisterChatCommand( { "/ass", "/assinger" }, Assigner.cmdTable )

--------
-- Module Prototype  
--------

Assigner.modulePrototype.core = Assigner
Assigner.modulePrototype.ui = Assigner.ui

function Assigner.modulePrototype:OnInitialize()
  self.core:RegisterModule(self.name, self)
end

function Assigner.modulePrototype:HasPlayerAssign()
  local found = false

  if (self.db.char.Players) then
    for i, i_value in self.db.char.Players do
      for j, j_value in self.db.char.Players[i] do
        if (j_value ~= "NONE") then
          found = true
          break
        end
      end
    end
  end

  return found
end

function Assigner.modulePrototype:GetAssignementString()
  return ""
end

function Assigner.modulePrototype:BuildAssignementRowString(row, firstString, prefix)
  message = ""
  assignFound = false

  if self.db.char.Players then
    for _, player in self.db.char.Players[row] do
      if(player ~= "NONE") then
        if(assignFound) then
          message = message .. ", "
        else
          if (not firstString) then
            if(self.db.char.ShortStringMode or self.db.char.ChannelType == 2) then 
              message = message .. " "
            else 
              message = message .. "\n"
            end
          else 
            firstString = false
          end
          message = message .. "[" .. string.upper(prefix) .. "="
          assignFound = true
        end
        message = message .. player
      end
    end
  end

  if(assignFound) then
    message = message .. "]"
  end

  return message, firstString
end

function Assigner:RegisterModule(name, module)
  if module.db and module.RegisterDefaults and type(module.RegisterDefaults) == "function" then
		module:RegisterDefaults("char", module.defaultDB or {})
	else
		self:RegisterDefaults(name, "char", module.defaultDB or {})
  end
  
  -- adquire db
  if not module.db then module.db = self:AcquireDBNamespace(name) end

  -- append cmdTable
  if module.consoleOptions then
		if module.external then
			self.cmdTable.args["extra"].args[module.consoleCMD or name] = module.consoleOptions
		else
			self.cmdTable.args[module.consoleCMD or name] = module.consoleOptions
		end
  end
  
  if(module.db.char.Active) then
    self:ToggleModuleActive(module, module.db.char.Active)
  else
    self:ToggleModuleActive(module, true)
  end

  -- onregister trigger
  module.registered = true
	if module.OnRegister and type(module.OnRegister) == "function" then
		module:OnRegister()
  end

  
end

function Assigner:EnableModule(moduleName)
  local m = self:GetModule(moduleName)
  if m and not self:IsModuleActive(moduleName) then
    self:ToggleModuleActive(moduleName, true)
  end
end

function Assigner:DisableModule(moduleName)
	local m = self:GetModule(moduleName)
	if m then
		self:ToggleModuleActive(m, false)
	end
end

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
  local hint = "|cffFFA500Click:|r Show Window|r\n|cffFFA500Right-Click:|r Options"
  T:SetHint(hint)
end

function Assigner:OnTextUpdate()
  if (not self.db.char.Active) then
    self:SetText("Suspended")
  else
    self:SetText("Assigner")
  end
end

function Assigner:OnClick()
  if(arg1 == "LeftButton") then self.ui.frame:Show(); end
end

function Assigner:IconUpdate()
  if self.db.char.Active then
    self:SetIcon([[Interface\AddOns\Assigner\Media\icon]])
  else
    self:SetIcon([[Interface\AddOns\Assigner\Media\icon_disabled]])
  end
end

function Assigner:OnInitialize()
  self.OnMenuRequest = self.cmdTable
  self:CreateWindow()
  self.loading = true
  self:ToggleActive(true)
end

function Assigner:OnEnable()
  if AceLibrary("AceEvent-2.0"):IsFullyInitialized() then
		self:AceEvent_FullyInitialized()
	else
		self:RegisterEvent("AceEvent_FullyInitialized")
	end
  self:IconUpdate()
  self:UpdateTooltip()
end

function Assigner:AceEvent_FullyInitialized()
  --[[
  if GetNumRaidMembers() > 0 or not self.loading then
		-- Enable all disabled modules
		for name, module in self:IterateModules() do
				--self:ToggleModuleActive(module, true)
    end
  end
  --]]

  self.loading = nil
end

function Assigner:OnDisable()
  self:IconUpdate()
end

function Assigner:GetActiveStatusOption()
  return self.db.char.Active
end

function Assigner:SetActiveStatusOption(newStatus)
  self.db.char.Active = newStatus
  self:IconUpdate()
  self:UpdateText()
end