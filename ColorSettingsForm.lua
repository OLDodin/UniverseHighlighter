local m_redWdg = nil
local m_greenWdg = nil
local m_blueWdg = nil
local m_alphaWdg = nil
local m_colorPreview = nil

local m_colorPanels = {}

function CreateColorSettingsForm(aColor)
	local form=createWidget(mainForm, "colorSettingsForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 400, 240, 200, 100)
	priority(form, 3000)
	hide(form)
	
	setText(createWidget(form, "closeButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")
	setLocaleText(createWidget(form, "setColorButton", "Button", WIDGET_ALIGN_CENTER, WIDGET_ALIGN_HIGH, 200, 30, nil, 20))
	setLocaleText(createWidget(form, "headerColor", "TextView", WIDGET_ALIGN_CENTER, WIDGET_ALIGN_LOW, 140, 25, 20, 20))
	
	m_colorPreview = createWidget(form, "colorPreview", "ImageBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 100, 100, 280, 70)
	m_colorPreview:SetBackgroundTexture(nil)
	
	
	m_redWdg = CreateSlider(form, "redSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 70)
	m_greenWdg = CreateSlider(form, "greenSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 95)
	m_blueWdg = CreateSlider(form, "blueSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 120)
	m_alphaWdg = CreateSlider(form, "alphaSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 145)
	
	local sliderParams	= {
							valueMin	= 0,
							valueMax	= 1.0,
							stepsCount	= 20,
							value		= 1.0,
							sliderWidth		= 120,
							sliderChangedFunc = function( value ) 
								OnColorChanged()
							end
						}

	
	sliderParams.description = getLocale()["red"]
	sliderParams.value = aColor.r
	m_redWdg:Init(sliderParams)
	sliderParams.description = getLocale()["green"]
	sliderParams.value = aColor.g
	m_greenWdg:Init(sliderParams)
	sliderParams.description = getLocale()["blue"]
	sliderParams.value = aColor.b
	m_blueWdg:Init(sliderParams)
	sliderParams.description = getLocale()["alpha"]
	sliderParams.value = aColor.a
	m_alphaWdg:Init(sliderParams)
	
	m_colorPanels[form] = {
		redSliderObj = m_redWdg,
		greenSliderObj = m_greenWdg,
		blueSliderObj = m_blueWdg,
		alphaSliderObj = m_alphaWdg
	}
	
	DnD.Init(form, form, true)
	OnColorChanged()
	
	return form
end

function GetColorFromColorSettingsForm()
	local color = {}
	color.r = m_redWdg:Get()
	color.g = m_greenWdg:Get()
	color.b = m_blueWdg:Get()
	color.a = m_alphaWdg:Get()
	
	return color
end

function OnColorChanged()
	m_colorPreview:SetBackgroundColor(GetColorFromColorSettingsForm())
end

local function ColorPanelPrepareDestroy(aColorPanel)
	local colorPanelSliders = m_colorPanels[aColorPanel]
	if not colorPanelSliders then
		return
	end
	
	colorPanelSliders.redSliderObj:PrepareDestroy()
	colorPanelSliders.greenSliderObj:PrepareDestroy()
	colorPanelSliders.blueSliderObj:PrepareDestroy()
	colorPanelSliders.alphaSliderObj:PrepareDestroy()
	
	m_colorPanels[aColorPanel] = nil
end

function DestroyColorPanel(aColorPanel)
	ColorPanelPrepareDestroy(aColorPanel)
	destroy(aColorPanel)
end
