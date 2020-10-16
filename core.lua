local globalLastAnnounceTime = 0
local delayTime = 1000 --ms

Assigner = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0", "AceHook-2.1", "FuBarPlugin-2.0")

local T  = AceLibrary("Tablet-2.0")

defaults = {
  ChannelType = 1,
  CustomChannel = 1,
  Active = true,
  ShortStringMode = false,
  Assigns = {
    -- Skull
    ["ASDropDownPlayer81"] = "NONE",
    ["ASDropDownPlayer82"] = "NONE",
    -- X
    ["ASDropDownPlayer71"] = "NONE",
    ["ASDropDownPlayer72"] = "NONE",
    -- Square
    ["ASDropDownPlayer61"] = "NONE",
    ["ASDropDownPlayer62"] = "NONE",
    -- Triangle
    ["ASDropDownPlayer41"] = "NONE",
    ["ASDropDownPlayer42"] = "NONE",
    -- Diamond
    ["ASDropDownPlayer31"] = "NONE",
    ["ASDropDownPlayer32"] = "NONE",
    -- Moon
    ["ASDropDownPlayer51"] = "NONE",
    ["ASDropDownPlayer52"] = "NONE",
    -- Circle
    ["ASDropDownPlayer21"] = "NONE",
    ["ASDropDownPlayer22"] = "NONE",
    -- Star
    ["ASDropDownPlayer11"] = "NONE",
    ["ASDropDownPlayer12"] = "NONE",
  }
}

local iconTable = {
  [1] = "Star",
  [2] = "Circle",
  [3] = "Diamond",
  [4] = "Triangle",
  [5] = "Moon",
  [6] = "Square",
  [7] = "Cross",
  [8] = "Skull",
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
    self.ui.mainFrame:Show();
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

function Assigner:GetMarkString(markID)
  local message = ""
  if(Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."1"] ~= "NONE" or Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"] ~= "NONE") then
    if(Assigner.db.profile.ShortStringMode or Assigner.db.profile.ChannelType == 2) then
      if(not Assigner.firstPrint) then
        message = message .. "; "
      else
        Assigner.firstPrint = false
      end
      message = message .. "("..iconTable[markID].."):"
      if(Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."1"] ~= "NONE") then
        message = message .. " " .. Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."1"]
          if(Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"] ~= "NONE") then
            message = message .. ", " .. Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"]
          end
      elseif(Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"] ~= "NONE") then
        message = message.." " .. Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"]
      end
    else
      message = message .. "\n("..iconTable[markID].."):"
      if(Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."1"] ~= "NONE") then
        message = message .. " " .. Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."1"]
        if(Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"] ~= "NONE") then
          message = message .. ", " .. Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"]
        end
      elseif(Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"] ~= "NONE") then
        message = message.." " .. Assigner.db.profile.Assigns["ASDropDownPlayer"..markID.."2"]
      end
    end
  end
  return message
end

function Assigner:PostAssignement()
  local currentTime = time()
  if((globalLastAnnounceTime + delayTime/1000) > currentTime) then return end

  local hasAssign = false

  for _, value in Assigner.db.profile.Assigns do
    if (value ~= "NONE") then
      hasAssign = true
      break
    end
  end

  local message = ""

  if (hasAssign) then
    Assigner.firstPrint = true

    if(not Assigner.db.profile.ShortStringMode and Assigner.db.profile.ChannelType ~= 2) then
      message = message .. "=-------- Assignement --------="
    end

    message = message .. Assigner:GetMarkString(8)
    message = message .. Assigner:GetMarkString(7)
    message = message .. Assigner:GetMarkString(6)
    message = message .. Assigner:GetMarkString(4)
    message = message .. Assigner:GetMarkString(3)
    message = message .. Assigner:GetMarkString(5)
    message = message .. Assigner:GetMarkString(1)
    message = message .. Assigner:GetMarkString(2)
  else
    message = "No Assigns"
  end

  if(Assigner.db.profile.ChannelType == 1) then
    SendChatMessage(message, "RAID")
  elseif(Assigner.db.profile.ChannelType == 2) then
    SendChatMessage(message, "RAID_WARNING")
  else
    SendChatMessage(message, "CHANNEL", nil, tonumber(Assigner.ui.channelEditBox:GetText()))
  end

  globalLastAnnounceTime = currentTime
end

