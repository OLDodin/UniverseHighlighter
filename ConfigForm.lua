local m_useTargetHighlight = nil
local m_useClassHighlight = nil
local m_disableSystemHighlight = nil


function InitConfigForm()
	local template = getChild(mainForm, "Template")
	setTemplateWidget(template)
	local formWidth = 900
	local form=createWidget(mainForm, "ConfigForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, formWidth, 450, 100, 120)
	priority(form, 2500)
	hide(form)


	local btnWidth = 100
	
	setLocaleText(createWidget(form, "saveBtn", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_HIGH, btnWidth, 25, formWidth/2-btnWidth/2, 20))
	setLocaleText(createWidget(form, "header1", "TextView", nil, nil, 140, 25, 20, 20))
	setLocaleText(createWidget(form, "header2", "TextView", nil, nil, 140, 25, 350, 20))
	setLocaleText(createWidget(form, "header3", "TextView", nil, nil, 140, 25, 650, 20))

	setLocaleText(createWidget(form, "infoTxt", "TextView", nil, WIDGET_ALIGN_HIGH, formWidth-60, 25, 30, 50))
	
	setLocaleText(createWidget(form, "colorTargetBtn", "Button", nil, nil, 130, 25, 10, 135))
			
	m_useTargetHighlight = createWidget(form, "useTargetHighlight", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 135)
	m_useClassHighlight = createWidget(form, "useClassHighlight", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 110)
	m_disableSystemHighlight = createWidget(form, "disableSystemHighlight", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 60)

	
	setText(createWidget(form, "closeMainButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")
	DnD.Init(form, form, true)
	
	
	setLocaleText(createWidget(form, "addPlayerNameButton", "Button", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 260, 25, 310, 320))
	createWidget(form, "containerPlayer", "ScrollableContainer", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 280, 270, 300, 50)
	
	
	setLocaleText(createWidget(form, "addGuildNameButton", "Button", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 260, 25, 610, 320))
	createWidget(form, "containerGuild", "ScrollableContainer", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 280, 270, 600, 50)
	
	return form
end

function SetFormSetting(aForm)
	setLocaleText(m_useTargetHighlight, GetCurrentSettings().useTargetColor)
	setLocaleText(m_useClassHighlight, GetCurrentSettings().useClassColor)
	setLocaleText(m_disableSystemHighlight, GetCurrentSettings().disableSystemHighlight)

	ShowValuesFromTable(GetCurrentSettings().userSettings, aForm, getChild(aForm, "containerPlayer"))
	ShowValuesFromTable(GetCurrentSettings().guildSettings, aForm, getChild(aForm, "containerGuild"))
end
