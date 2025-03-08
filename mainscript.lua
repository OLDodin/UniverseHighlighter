

local m_configForm = nil
local m_highlightForm = nil

local m_tickCnt = 0
local m_highlightObjID = nil
local m_underMouseObjID = nil
local m_needRestoreHighlightByCursor = false
local m_needRestoreHighlightByTarget = false
local m_avlUserTree  = nil
local m_avlGuildTree  = nil

local m_currHighlightFormMode = 0

local m_classColors={
	["WARRIOR"]		= { r = 143/255; g = 119/255; b = 075/255; a = 0.9 },
	["PALADIN"]		= { r = 207/255; g = 220/255; b = 155/255; a = 0.9 },
	["MAGE"]		= { r = 126/255; g = 159/255; b = 255/255; a = 0.9 },
	["DRUID"]		= { r = 255/255; g = 118/255; b = 060/255; a = 0.9 },
	["PSIONIC"]		= { r = 221/255; g = 123/255; b = 245/255; a = 0.9 },
	["STALKER"]		= { r = 150/255; g = 204/255; b = 086/255; a = 0.9 },
	["PRIEST"]		= { r = 255/255; g = 207/255; b = 123/255; a = 0.9 },
	["NECROMANCER"]	= { r = 208/255; g = 069/255; b = 075/255; a = 0.9 },
	["ENGINEER"]    = { r = 127/255; g = 128/255; b = 178/255; a = 0.9 },
	["BARD"]		= { r = 51/255;  g = 230/255; b = 230/255; a = 0.9 },
	["WARLOCK"] 	= { r = 125/255; g = 101/255; b = 219/255; a = 0.9 }, 
	["UNKNOWN"]		= { r = 127/255; g = 127/255; b = 127/255; a = 0 }
}



function ChangeMainWndVisible()
	LoadFormSettings()
	if isVisible(m_configForm) then
		DnD.HideWdg(m_configForm)
	else
		DnD.ShowWdg(m_configForm)
	end
end

local function GetTimestamp()
	return common.GetMsFromDateTime( common.GetLocalDateTime() )
end

function ClearAllHighlight()
	local unitList = avatar.GetUnitList()
	table.insert(unitList, avatar.GetId())
	
	for _, objID in pairs(unitList) do
		ClearHighlight(objID)
	end
end

function ClearHighlight(anObjID)
	if anObjID and object.IsExist(anObjID) then
		unit.Select( anObjID, false, nil, nil, nil )
		object.Highlight( anObjID, "SELECTION", nil, nil, 0 )
	end
end

function GetColorByObjID(anObjID)
	if GetCurrentSettings().useTargetColor and anObjID == avatar.GetTarget() then
		return GetCurrentSettings().targetSettings
	end
	
	local tmp = {}
	tmp.name = object.GetName(anObjID)
	if tmp.name and not m_avlUserTree:isEmpty() then
		local searchRes = m_avlUserTree:get(tmp)
		if searchRes ~= nil then
			return GetCurrentSettings().userSettings[searchRes.index]
		end
	end
	if unit.IsPlayer(anObjID) then
		local guildInfo = unit.GetGuildInfo(anObjID)
		if not m_avlGuildTree:isEmpty() and guildInfo and guildInfo.name and not guildInfo.name:IsEmpty() then
			local searchRes = m_avlGuildTree:get(guildInfo)
			if searchRes ~= nil then
				return GetCurrentSettings().guildSettings[searchRes.index]
			end
		end
	end
	if GetCurrentSettings().useClassColor then
		local color = m_classColors[unit.GetClass(anObjID).className]
		if not color then
			color = m_classColors["UNKNOWN"]
		end
		local classObj = {}
		classObj.color = color
		classObj.color2 = color
		classObj.useMode1 = false
		classObj.useMode2 = true
		
		return classObj
	end
	
	return nil
end

function Higlight(anObjID)
	if not anObjID or not object.IsExist(anObjID) then
		return
	end
	local colorSettings = GetColorByObjID(anObjID)
	if colorSettings then
		if colorSettings.useMode1 then
			unit.Select( anObjID, true, nil, colorSettings.color, 1.6 )
		end
		if colorSettings.useMode2 then
			object.Highlight( anObjID, "SELECTION", colorSettings.color2, nil, 0 )
		end
	end
end

function OnEventIngameUnderCursorChanged( params )
	if params.state == "main_view_3d_unit" then
		m_underMouseObjID = params.unitId
		m_needRestoreHighlightByCursor = true
	end	
	if m_needRestoreHighlightByCursor and params.unitId ~= m_underMouseObjID then
		ClearHighlight(m_underMouseObjID)
		Higlight(m_underMouseObjID)
		m_needRestoreHighlightByCursor = false
	end
end

function OnTargetChaged()
	local targetID = avatar.GetTarget()

	ClearHighlight(m_highlightObjID)
	Higlight(m_highlightObjID)
	Higlight(targetID)
	m_highlightObjID = targetID
end

function CheckAllUnits()
	local unitList = avatar.GetUnitList()
	table.insert(unitList, avatar.GetId())
	
	for _, objID in pairs(unitList) do
		Higlight(objID)
	end
end

function OnUnitChanged(aParams)
	for i=0, GetTableSize(aParams.spawned)-1 do
		if aParams.spawned[i] then
			Higlight(aParams.spawned[i])
		end
	end
end

--при посадке на маунта заливка не обновляется
function OnEventSecondTimer()
	m_tickCnt = m_tickCnt + 1
	if m_tickCnt == 3 then
		CheckAllUnits()
		m_tickCnt = 0
	end
end


function SaveHighlight(aWdg)
	local index, saveObj = GetSaveInfo()
	if m_currHighlightFormMode == 1 then
		GetCurrentSettings().userSettings[index] = saveObj
	elseif m_currHighlightFormMode == 2 then
		GetCurrentSettings().guildSettings[index] = saveObj
	elseif m_currHighlightFormMode == 3 then
		GetCurrentSettings().targetSettings = saveObj
	end
	
	DnD.SwapWdg(getParent(aWdg))
end

function SavePressed()
	m_needRestoreHighlightByCursor = false
	m_needRestoreHighlightByTarget = false
	
	UpdateTableValuesFromContainer(GetCurrentSettings().userSettings, m_configForm, getChild(m_configForm, "containerPlayer"))
	UpdateTableValuesFromContainer(GetCurrentSettings().guildSettings, m_configForm, getChild(m_configForm, "containerGuild"))
	
	GetCurrentSettings().disableSystemHighlight = getCheckBoxState(getChild(m_configForm, "disableSystemHighlight"))
	GetCurrentSettings().useTargetColor = getCheckBoxState(getChild(m_configForm, "useTargetHighlight"))
	GetCurrentSettings().useClassColor = getCheckBoxState(getChild(m_configForm, "useClassHighlight"))

	
	SaveSettings()
	ClearAllHighlight()
	
	common.StateUnloadManagedAddon( "UserAddon/UniverseHighlighter" )
	common.StateLoadManagedAddon( "UserAddon/UniverseHighlighter" )
end

function LoadFormSettings()
	LoadSettings()
	SetFormSetting(m_configForm)
	m_avlUserTree  = GetAVLWStrTree()
	m_avlGuildTree  = GetAVLWStrTree()
	
	for i, element in ipairs(GetCurrentSettings().userSettings) do
		if element.name then
			 local copyElement = copyTable(element)
			 copyElement.index = i
			m_avlUserTree:add(copyElement)
		end
	end
	
	for i, element in ipairs(GetCurrentSettings().guildSettings) do
		if element.name then
			local copyElement = copyTable(element)
			copyElement.index = i
			m_avlGuildTree:add(copyElement)
		end
	end
	
	CheckAllUnits()
end

function InitDefaultColor(anArr)
	local settings = anArr[#anArr]
	settings.color = { r = 1, g = 1, b = 0, a = 0.5 }
	settings.color2 = { r = 1, g = 0, b = 0, a = 0.85 }
	settings.useMode1 = false
	settings.useMode2 = true
	anArr[#anArr] = settings
end

function AddPlayerPressed()
	AddElementFromForm(GetCurrentSettings().userSettings, m_configForm, getChild(m_configForm, "containerPlayer") ) 

	InitDefaultColor(GetCurrentSettings().userSettings)
end

function AddGuildPressed()
	AddElementFromForm(GetCurrentSettings().guildSettings, m_configForm, getChild(m_configForm, "containerGuild"))
	
	InitDefaultColor(GetCurrentSettings().guildSettings)
end

function EditUserColorPressed(aWdg)
	local index = GetIndexForWidget(aWdg) + 1
	local settings = GetCurrentSettings().userSettings[index]
	SetHighlightSetting(m_highlightForm, index, settings.useMode1, settings.useMode2, settings.color, settings.color2, WITHOUT_MODE_1) 
	setText(getChild(m_highlightForm, "header"), getLocale()["header2"])
	DnD.ShowWdg(m_highlightForm)
	m_currHighlightFormMode = 1
end

function EditGuildColorPressed(aWdg)
	local index = GetIndexForWidget(aWdg) + 1
	local settings = GetCurrentSettings().guildSettings[index]
	SetHighlightSetting(m_highlightForm, index, settings.useMode1, settings.useMode2, settings.color, settings.color2, WITHOUT_MODE_1) 
	setText(getChild(m_highlightForm, "header"), getLocale()["header3"])
	DnD.ShowWdg(m_highlightForm)
	m_currHighlightFormMode = 2
end 

function EditTargetColorPressed()
	local settings = GetCurrentSettings().targetSettings
	SetHighlightSetting(m_highlightForm, 0, settings.useMode1, settings.useMode2, settings.color, settings.color2) 
	setText(getChild(m_highlightForm, "header"), getLocale()["colorTargetBtn"])
	DnD.ShowWdg(m_highlightForm)
	m_currHighlightFormMode = 3
end

function DeleteUserColorPressed(aWdg)
	DeleteContainer(GetCurrentSettings().userSettings, aWdg, m_configForm)
end

function DeleteGuildColorPressed(aWdg)
	DeleteContainer(GetCurrentSettings().guildSettings, aWdg, m_configForm)
end




function ChangeClientSettings()
	options.Update()
	local pageIds = options.GetPageIds()
	for pageIndex = 0, GetTableSize( pageIds ) - 1 do
		local pageId = pageIds[pageIndex]
		if pageIndex == 3 then
			local groupIds = options.GetGroupIds(pageId)
			if groupIds then
				for groupIndex = 0, GetTableSize( groupIds ) - 1 do
					local groupId = groupIds[groupIndex]
					local blockIds = options.GetBlockIds( groupId )
					for blockIndex = 0, GetTableSize( blockIds ) - 1 do
						local blockId = blockIds[blockIndex]
						local optionIds = options.GetOptionIds( blockId )
						for optionIndex = 0, GetTableSize( optionIds ) - 1 do
							local optionId = optionIds[optionIndex]

							if pageIndex == 3 and groupIndex == 0 and blockIndex == 1 then 
								if optionIndex == 0 then
									-- толщина обводки
									options.SetOptionCurrentIndex( optionId, 10 )
								elseif 	optionIndex == 1 then
									-- прозрачность обводки
									options.SetOptionCurrentIndex( optionId, 10 )
								end								
							end
						end
					end
				end		
			end
			options.Apply( pageId )
		end
	end
end

local function EditLineEsc(aParams)
	aParams.widget:SetFocus(false)
end

function Init()
	ChangeClientSettings()
	setTemplateWidget("common")
	
	local button=createWidget(mainForm, "UHButton", "Button", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 25, 25, 300, 120)
	setText(button, "UH")
	DnD.Init(button, button, true)
	
	common.RegisterReactionHandler(ButtonPressed, "execute")
	common.RegisterReactionHandler(CheckBoxChangedOn, "CheckBoxChangedOn")
	common.RegisterReactionHandler(CheckBoxChangedOff, "CheckBoxChangedOff")
	common.RegisterEventHandler( OnTargetChaged, "EVENT_AVATAR_TARGET_CHANGED")
	common.RegisterEventHandler(OnUnitChanged, "EVENT_UNITS_CHANGED")
	common.RegisterEventHandler(OnEventSecondTimer, "EVENT_SECOND_TIMER")
	common.RegisterReactionHandler(EditLineEsc, "EditLineEsc")
	
	m_configForm = InitConfigForm()
	m_highlightForm = InitHighlightForm()
	LoadFormSettings()
	
	AddReaction("UHButton", function () ChangeMainWndVisible() end)
	AddReaction("closeMainButton", function (aWdg) ChangeMainWndVisible() end)
	AddReaction("closeButton", function (aWdg) DnD.SwapWdg(getParent(aWdg)) end)
	AddReaction("colorMode1Btn", ShowColorMode1Pressed)
	AddReaction("colorMode2Btn", ShowColorMode2Pressed)
	AddReaction("saveBtn", SavePressed)
	AddReaction("saveHighlightBtn", SaveHighlight)
	AddReaction("addPlayerNameButton", AddPlayerPressed)
	AddReaction("addGuildNameButton", AddGuildPressed)
	AddReaction("editButtoncontainerPlayer", EditUserColorPressed)
	AddReaction("editButtoncontainerGuild", EditGuildColorPressed)
	AddReaction("colorTargetBtn", EditTargetColorPressed)
	AddReaction("deleteButtoncontainerPlayer", DeleteUserColorPressed)
	AddReaction("deleteButtoncontainerGuild", DeleteGuildColorPressed)

	
	local systemAddonStateChanged = false
	local targetSelectionLoaded = false
	local addons = common.GetStateManagedAddons()
	for i = 0, GetTableSize( addons ) do
		local info = addons[i]
		if info and info.name == "TargetSelection" then
			if info.isLoaded then
				targetSelectionLoaded = true
			end
		end
	end
	if GetCurrentSettings().disableSystemHighlight then 
		common.StateUnloadManagedAddon( "TargetSelection" )
		systemAddonStateChanged = targetSelectionLoaded		
	else
		common.StateLoadManagedAddon( "TargetSelection" )
		common.RegisterEventHandler( OnEventIngameUnderCursorChanged, "EVENT_INGAME_UNDER_CURSOR_CHANGED")
		systemAddonStateChanged = not targetSelectionLoaded
	end
	
	if systemAddonStateChanged then
		for i = 0, GetTableSize( addons ) do
			local info = addons[i]
			if info and string.find(info.name, "AOPanel") then
				if info.isLoaded then
					common.StateUnloadManagedAddon( info.name )
					common.StateLoadManagedAddon( info.name )
				end
			end
		end
	end
	
	CheckAllUnits()
	AoPanelSupportInit()
end

if (avatar.IsExist()) then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end