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

-- Save copied tables in `copies`, indexed by original table.
function Assigner:Deepcopy(orig, copies)
  copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      if copies[orig] then
          copy = copies[orig]
      else
          copy = {}
          copies[orig] = copy
          for orig_key, orig_value in next, orig, nil do
              copy[Assigner:Deepcopy(orig_key, copies)] = Assigner:Deepcopy(orig_value, copies)
          end
          setmetatable(copy, Assigner:Deepcopy(getmetatable(orig), copies))
      end
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end

function deepcopytable(obj, seen)
  -- Handle non-tables and previously-seen tables.
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  -- New table; mark it as seen and copy recursively.
  local s = seen or {}
  local res = {}
  s[obj] = res
  for k, v in pairs(obj) do res[deepcopytable(k, s)] = deepcopytable(v, s) end
  return setmetatable(res, getmetatable(obj))
end