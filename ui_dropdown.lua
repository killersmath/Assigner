function Assigner.ui:CreateDropDownPlayerMenu(parent, prefix, row, col, pos, allowedClasses) 
  if(not pos.anchor) then pos.anchor = "TOPLEFT" end
  local dropDown = CreateFrame("Button", prefix..row..col, parent, "UIDropDownMenuTemplate")
  dropDown:SetPoint(pos.anchor, pos.x, pos.y)
  dropDown.prefix = prefix
  dropDown.row = row
  dropDown.col = col
  dropDown.allowedClasses = allowedClasses
  dropDown.initialize = Assigner.ui.InitializeDropDownPlayerMenu

  --UIDropDownMenu_SetWidth(150, dropDown)
  getglobal(dropDown:GetName().."Button"):SetScript("OnClick", function() 
    ToggleDropDownMenu(); -- inherit UIDropDownMenuTemplate functions
    end)

  return dropDown
end

function Assigner.ui:InitializeDropDownPlayerMenu()
  local currentDropDownMenu = this:GetParent()
  local players = Assigner:GetRaidPlayers(currentDropDownMenu.allowedClasses)

  local clickFunc = function() 
    UIDropDownMenu_SetSelectedID(this.owner, this:GetID())
    Assigner.db.profile.Pages[Assigner.db.profile.CurrentFrameID].Players[this.owner.row][this.owner.col] = this.value
  end

  local info = {}
  info.text = "NONE"
  info.value = "NONE"
  info.checked = false
  info.owner = currentDropDownMenu -- DropdownMenu
  info.func = clickFunc
  UIDropDownMenu_AddButton(info);

  for _,player in players do
    info.text = player.name
    info.value = player.name
    info.checked = false
    info.owner = currentDropDownMenu
    local color = Assigner.constants.CLASS_COLORS[player.class]
    if(color) then info.textR, info.textG, info.textB = unpack(color) end
    info.func = clickFunc
    UIDropDownMenu_AddButton(info);
  end
end