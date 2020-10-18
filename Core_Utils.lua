function Assigner:SendMessage(message, channelType, channelID)
  if(channelType == 1) then
    SendChatMessage(message, "RAID")
  elseif(channelType == 2) then
    SendChatMessage(message, "RAID_WARNING")
  else
    SendChatMessage(message, "CHANNEL", nil, channelID)
  end
end

function Assigner:GetRaidPlayers(allowedClasses)
  local players = {}
  for w=1,GetNumRaidMembers() do
    local _, classToken = UnitClass("raid"..w)
    if(allowedClasses ~= nil) then
      for _, class in pairs(allowedClasses) do
        if class == classToken then 
          table.insert(players, {name=UnitName("raid"..w), class=classToken})
        end
      end
    else table.insert(players, {name=UnitName("raid"..w), class=classToken})
    end
  end

  table.sort(players, function (a,b) 
    if(a.class == b.class) then return a.name < b.name
    else return a.class < b.class
    end
  end)

  return players
end
