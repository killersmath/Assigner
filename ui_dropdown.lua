local globalDropDownID
local players = {}

function Assigner.ui:CreateDropDownPlayerMenu(parent, prefix, mark, order, pos) 
  if(not pos.anchor) then pos.anchor = "TOPLEFT" end
  local dropDown = CreateFrame("Button", prefix..mark..order, parent, "UIDropDownMenuTemplate")
  dropDown:SetPoint(pos.anchor, pos.x, pos.y)

  UIDropDownMenu_SetWidth(120, dropDown)
  getglobal(dropDown:GetName().."Button"):SetScript("OnClick", function() 
    local dropDownID = getglobal(dropDown:GetName())
		Assigner.ui:DropDownPlayerOnClick(dropDownID)
		ToggleDropDownMenu(); -- inherit UIDropDownMenuTemplate functions
    end)
  return dropDown
end

-- Initialize a specific dropdown
function Assigner.ui:DropDownPlayerOnClick(dropDownID)
  globalDropDownID = dropDownID -- feed global
  self:PopulatePlayers()
	UIDropDownMenu_Initialize(dropDownID, self.PopulateDropdownPlayer)
end

function Assigner.ui:PopulateDropdownPlayer()
  local info = {}
  -- Default Option
  info.text = "NONE"
  info.checked = false
  info.checkable = false
  info.func = function() 
    UIDropDownMenu_SetSelectedID(globalDropDownID, this:GetID())
    Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].Assigns.Data[globalDropDownID:GetName()] = getglobal(globalDropDownID:GetName().."Text"):GetText()
   end
  UIDropDownMenu_AddButton(info);
  -- Players options
  for i=1,table.getn(players) do
    info.text = players[i].name
    info.value = players[i].name
    info.checked = false
    info.checkable = false
    local color = Assigner.ui:GetClassColor(players[i].class)
    if(color) then
      info.textR = color.r
      info.textG = color.g
      info.textB = color.b
    end
    info.func = function() 
      UIDropDownMenu_SetSelectedID(globalDropDownID, this:GetID())
      Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].Assigns.Data[globalDropDownID:GetName()] = getglobal(globalDropDownID:GetName().."Text"):GetText()
     end
    UIDropDownMenu_AddButton(info);
  end
end

function Assigner.ui:PopulatePlayers()
  players = {}
  for w=1,GetNumRaidMembers() do
    local playerClass = UnitClass("raid"..w)
    if(playerClass == "Rogue" or playerClass == "Warrior" or playerClass == "Paladin" or playerClass == "Druid") then
      table.insert(players, {name=UnitName("raid"..w), class=playerClass})
    end
  end

  table.sort(players, function (a,b) 
    if(a.class == b.class) then
      return a.name < b.name
    else
      return a.class < b.class
    end
  end)
end

function Assigner.ui:GetClassColor(className)
  classColor = {}
  if(className=="Warrior") then
    classColor.r = 0.78; classColor.g = 0.61; classColor.b = 0.43
    return classColor
  elseif(className=="Rogue") then
    classColor.r = 1.00; classColor.g = 0.96; classColor.b = 0.41
    return classColor
  elseif(className=="Paladin") then
    classColor.r = 0.96; classColor.g = 0.55; classColor.b = 0.73
    return classColor
  elseif(className=="Druid") then
    classColor.r = 1.00; classColor.g = 0.49; classColor.b = 0.04
    return classColor
  end
  return nil
end