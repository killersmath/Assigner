SyncManager = Assigner:NewModule("SyncManager")

local _playerName = UnitName("player");

function SyncManager:OnEnable()
  if AceLibrary("AceEvent-2.0"):IsFullyInitialized() then
		self:AceEvent_FullyInitialized()
	else
		self:RegisterEvent("AceEvent_FullyInitialized")
	end
end

function SyncManager:AceEvent_FullyInitialized()
  self:RegisterEvent("Assigner_SendSync")
  self:RegisterEvent("CHAT_MSG_ADDON")
end

function SyncManager:OnDisable()
  self:UnregisterAllEvents()
end

function SyncManager:Assigner_SendSync(msg)
	local _, _, sync, rest = string.find(msg, "(%S+)%s*(.*)$")

	if not sync then return end

  SendAddonMessage("Assigner", msg, "RAID")
end

function SyncManager:CHAT_MSG_ADDON(prefix, message, type, sender)
	if prefix ~= "Assigner" or type ~= "RAID" then return end

	local _, _, sync, rest = string.find(message, "(%S+)%s*(.*)$")
	if not sync then return end

	self:TriggerEvent("Assigner_RecvSync", sync, rest, sender)
end