local m_preview1 = nil
local m_preview2 = nil
local m_modeCheckBox1 = nil
local m_modeCheckBox2 = nil
local m_selectionColor1 = nil
local m_selectionColor2 = nil
local m_colorForm = nil
local m_index = nil
local m_useMode1 = true
local m_useMode2 = true

Global("WITHOUT_MODE_1", 1)
Global("ONLY_ALPHA_MODE_2", 1)

function InitHighlightForm()
	setTemplateWidget("common")
	local formWidth = 300
	local form=createWidget(mainForm, "HighlightForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, formWidth, 230, 100, 120)
	priority(form, 2500)
	hide(form)


	local btnWidth = 100
	
	setLocaleText(createWidget(form, "saveHighlightBtn", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_HIGH, btnWidth, 25, formWidth/2-btnWidth/2, 20))
	setLocaleText(createWidget(form, "header", "TextView", nil, nil, 150, 25, 20, 20))

	
	setLocaleText(createWidget(form, "colorMode1Btn", "Button", nil, nil, 80, 25, 10, 92))
	setLocaleText(createWidget(form, "colorMode2Btn", "Button", nil, nil, 80, 25, 10, 144))
			
	m_modeCheckBox1 = createWidget(form, "useMode1", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 280, 25, 10, 66)
	m_modeCheckBox2 = createWidget(form, "useMode2", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 280, 25, 10, 118)

	m_preview1 = createWidget(form, "preview1", "ImageBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 24, 24, 266, 92)
	m_preview2 = createWidget(form, "preview2", "ImageBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 24, 24, 266, 144)
	m_preview1:SetBackgroundTexture(nil)
	m_preview2:SetBackgroundTexture(nil)
	
	setText(createWidget(form, "closeButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")
	DnD:Init(form, form, true)
	
	return form
end

function GetSaveInfo()
	local saveObj = {}
	saveObj.color = m_selectionColor1
	saveObj.color2 = m_selectionColor2
	saveObj.useMode1 = m_useMode1
	saveObj.useMode2 = m_useMode2
	
	return m_index, saveObj
end

function SetHighlightSetting(aForm, anIndex, anUseMode1, anUseMode2, aSelectionColor1, aSelectionColor2, aMode)
	m_index = anIndex
	m_useMode1 = anUseMode1
	m_useMode2 = anUseMode2
	setLocaleText(m_modeCheckBox1, anUseMode1)
	setLocaleText(m_modeCheckBox2, anUseMode2)
	
	m_preview1:SetBackgroundColor(aSelectionColor1)
	m_preview2:SetBackgroundColor(aSelectionColor2)
	
	m_selectionColor1 = aSelectionColor1
	m_selectionColor2 = aSelectionColor2
	
	if aMode == WITHOUT_MODE_1 then
		m_useMode1 = false
		hide(getChild(aForm, "colorMode1Btn"))
		hide(getChild(aForm, "useMode1"))
		hide(getChild(aForm, "preview1"))
	elseif aMode == ONLY_ALPHA_MODE_2 then
	
	else
		show(getChild(aForm, "colorMode1Btn"))
		show(getChild(aForm, "useMode1"))
		show(getChild(aForm, "preview1"))
	end
end

function ChangeHighlightPreview(aWdg, aNum)
	swap(getParent(aWdg))
	local preview = m_preview1
	if aNum == 2 then
		preview = m_preview2
	end
	preview:SetBackgroundColor(GetColorFromColorSettingsForm())
end


function ShowColorMode1Pressed()
	AddReaction("setColorButton", ColorMode1Changed)
	ShowColorPressed(m_selectionColor1)
end

function ShowColorMode2Pressed()
	AddReaction("setColorButton", ColorMode2Changed)
	ShowColorPressed(m_selectionColor2)
end

function ShowColorPressed(aColor)
	if m_colorForm then
		DnD.Remove(m_colorForm)
		DestroyColorPanel(m_colorForm)
	end
	m_colorForm = CreateColorSettingsForm(aColor)
	DnD.ShowWdg(m_colorForm)
end

function ColorMode1Changed(aWdg)
	m_selectionColor1 = GetColorFromColorSettingsForm()
	ChangeHighlightPreview(aWdg, 1)
	OnTargetChaged()
end

function ColorMode2Changed(aWdg)
	m_selectionColor2 = GetColorFromColorSettingsForm()
	ChangeHighlightPreview(aWdg, 2)
	OnTargetChaged()
end