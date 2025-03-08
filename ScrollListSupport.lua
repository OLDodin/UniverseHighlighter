
function GenerateWidgetForTable(aTable, aContainer, anIndex)
	setTemplateWidget("common")
	local panel=createWidget(aContainer, "containerPanel"..tostring(anIndex), "Panel", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 30, nil, nil, true)
	setBackgroundColor(panel, {r=1, g=1, b=1, a=0.5})
	setText(createWidget(panel, "Id", "TextView", WIDGET_ALIGN_LOW, WIDGET_ALIGN_CENTER, 30, 20, 10), anIndex)
	local nameWidget=createWidget(panel, "Name"..tostring(anIndex), "EditLine", WIDGET_ALIGN_LOW, WIDGET_ALIGN_CENTER, 200, 20, 35)
	if aTable.name then
		setText(nameWidget, aTable.name)
		setBackgroundTexture(nameWidget, nil)
		setBackgroundColor(nameWidget, nil)
	end
	local containerParentName = getName(getParent(aContainer))
	local containerName = getName(aContainer)
	
	if containerParentName then
		if compare(containerParentName, "ConfigForm") then
			setText(createWidget(panel, "editButton"..containerName, "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_CENTER, 15, 15, 30), "e")
		end
		setText(createWidget(panel, "deleteButton"..containerName, "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_CENTER, 15, 15, 10), "x")
	end
	return panel, nameWidget
end

local function GetNameEditWdg(aContainerElement, anIndex)
	return getChild(aContainerElement, "Name"..tostring(anIndex))
end

local function GetIndexForWidgetByMainPanel(anWidget)
	local parentWdg = getParent(anWidget)
	
	while parentWdg do 
		local wdgName = getName(parentWdg)
		if findSimpleString(wdgName, "containerPanel") then
			local nStr = string.gsub(wdgName, "containerPanel", "")
			--container from 0
			return tonumber(nStr) - 1
		end
		parentWdg = getParent(parentWdg)
	end
end

SetGenerateWidgetForContainerFunc(GenerateWidgetForTable)
SetGetNameEditWdgFromContainerFunc(GetNameEditWdg)
SetGetIndexForWidgetInContainerFunc(GetIndexForWidgetByMainPanel)