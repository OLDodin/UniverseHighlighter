local m_template = getChild(mainForm, "Template")


function GenerateWidgetForTable(aTable, aContainer, anIndex)
	setTemplateWidget(m_template)
	local panel=createWidget(aContainer, nil, "Panel", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 30, nil, nil, true)
	setBackgroundColor(panel, {r=1, g=1, b=1, a=0.5})
	setText(createWidget(panel, "Id", "TextView", WIDGET_ALIGN_LOW, WIDGET_ALIGN_CENTER, 30, 20, 10), anIndex)
	if aTable.name then
		local nameWidget=createWidget(panel, "Name"..tostring(anIndex), "EditLine", WIDGET_ALIGN_LOW, WIDGET_ALIGN_CENTER, 200, 20, 35)
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
	return panel
end

SetGenerateWidgetForContainerFunc(GenerateWidgetForTable)