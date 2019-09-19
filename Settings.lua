local m_currentSettings = nil

function SaveSettings()
	if not m_currentSettings then
		return
	end
	userMods.SetGlobalConfigSection("UH_settings", m_currentSettings)
end

function SaveDefaultSettings()
	local defObj = {}
	defObj.color = { r = 1, g = 1, b = 0, a = 0.9 }
	defObj.color2 = { r = 1, g = 0, b = 0, a = 0.9 }
	defObj.useMode1 = true
	defObj.useMode2 = true
	
	local saveObj = {}
	saveObj.disableSystemHighlight = true
	saveObj.useTargetColor = false
	saveObj.useClassColor = false
	
	saveObj.userSettings = {}
	saveObj.guildSettings = {}
	saveObj.targetSettings = defObj
	
	userMods.SetGlobalConfigSection("UH_settings", saveObj)
end

function LoadSettings()
	local settings = userMods.GetGlobalConfigSection("UH_settings")
	if not settings then
		SaveDefaultSettings()
		settings = userMods.GetGlobalConfigSection("UH_settings")
	end
	m_currentSettings = settings
end

function GetCurrentSettings()
	return m_currentSettings
end