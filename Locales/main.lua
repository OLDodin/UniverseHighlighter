Global("Locales", {})

function getLocale()
	return Locales[common.GetLocalization()] or Locales["eng"]
end

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

Locales["rus"]={}
Locales["rus"]["line1"]="Кого: "
Locales["rus"]["colorMode1Btn"]="Цвет: "
Locales["rus"]["colorMode2Btn"]="Цвет: "
Locales["rus"]["colorTargetBtn"]="Подсветка цели"
Locales["rus"]["saveBtn"]="Сохранить"
Locales["rus"]["saveHighlightBtn"]="Сохранить"
Locales["rus"]["header1"]="Настройки"
Locales["rus"]["header2"]="Подсветка игроков"
Locales["rus"]["header3"]="Подсветка гильдий"
Locales["rus"]["useMode1"]="Использовать обводку"
Locales["rus"]["useMode2"]="Использовать заливку"
Locales["rus"]["disableSystemHighlight"]="Выкл. стандарную подсветку"
Locales["rus"]["setColorButton"]="OK"
Locales["rus"]["red"]="Красный"
Locales["rus"]["green"]="Зелёный"
Locales["rus"]["blue"]="Синий"
Locales["rus"]["alpha"]="Прозрач."
Locales["rus"]["headerColor"]="Выберите цвет"
Locales["rus"]["addPlayerNameButton"]="Добавить"
Locales["rus"]["addGuildNameButton"]="Добавить"
Locales["rus"]["useTargetHighlight"]=" "
Locales["rus"]["useClassHighlight"]="Подсветка классов"
Locales["rus"]["infoTxt"]="Приоритет подсветки - 1) Ваша цель 2) Из списка игроков 3) Из списка гильдий 4) По классам"
Locales["rus"]["enterName"]=userMods.ToWString("Введите имя")

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

Locales["eng"]={}

