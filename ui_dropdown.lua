function Assigner.ui:CreateDropDownPlayerMenu(parent, prefix, row, col, pos, allowedClasses, clickFunc) 
  if(not pos.anchor) then pos.anchor = "TOPLEFT" end
  local dropDown = CreateFrame("Button", prefix..row..col, parent, "UIDropDownMenuTemplate")
  dropDown:SetPoint(pos.anchor, pos.x, pos.y)
  dropDown.prefix = prefix
  dropDown.row = row
  dropDown.col = col
  dropDown.allowedClasses = allowedClasses
  dropDown.clickFunc = clickFunc
  dropDown.initialize = function() Assigner.ui:InitializeDropDownPlayerMenu() end
  
  --UIDropDownMenu_SetButtonWidth(250, dropDown)
  getglobal(dropDown:GetName().."Button"):SetScript("OnClick", function() 
    ToggleDropDownMenu(); -- inherit UIDropDownMenuTemplate functions
    end)
  return dropDown
end

function Assigner.ui:InitializeDropDownPlayerMenu()
  local dropDownMenu = this:GetParent()
  local dropDownListLevel1 = getglobal("DropDownList1")
  dropDownListLevel1:SetScale(Assigner.ui.frame:GetScale()) -- Fix scale

  if (not dropDownMenu.clickFunc) then
    dropDownMenu.clickFunc = function() 
      UIDropDownMenu_SetSelectedID(this.owner, this:GetID())
      Assigner.db.namespaces[Assigner.db.char.CurrentPageID].char.Players[this.owner.row][this.owner.col] = this.value
    end
  end

  local info = {}
  info.text = "NONE"
  info.value = "NONE"
  info.checked = false
  info.owner = dropDownMenu -- Current Dropdown Menu which called this function
  info.func = dropDownMenu.clickFunc
  UIDropDownMenu_AddButton(info);

  for _,player in Assigner:GetRaidPlayers(dropDownMenu.allowedClasses) do

    info.text = player.name
    info.value = player.name
    info.owner = dropDownMenu
    info.checked = false
    info.icon = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"
		info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom = unpack(Assigner.constants.CLASS_ICON_TCOORDS[player.class])
    info.textR, info.textG, info.textB = unpack(Assigner.constants.CLASS_COLORS[player.class])
    info.func = dropDownMenu.clickFunc

    UIDropDownMenu_AddButton(info);

    getglobal("DropDownList1Button"..dropDownListLevel1.numButtons.."Icon"):SetPoint("RIGHT", -20, 0) -- Fix the Icon anchor
  end
end