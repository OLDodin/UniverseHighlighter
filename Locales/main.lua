Global("Locales", {})

function getLocale()
	return Locales[common.GetLocalization()] or Locales["eng"]
end

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

Locales["rus"]={}
Locales["rus"]["line1"]="����: "
Locales["rus"]["colorMode1Btn"]="����: "
Locales["rus"]["colorMode2Btn"]="����: "
Locales["rus"]["colorTargetBtn"]="��������� ����"
Locales["rus"]["saveBtn"]="���������"
Locales["rus"]["saveHighlightBtn"]="���������"
Locales["rus"]["header1"]="���������"
Locales["rus"]["header2"]="��������� �������"
Locales["rus"]["header3"]="��������� �������"
Locales["rus"]["useMode1"]="������������ �������"
Locales["rus"]["useMode2"]="������������ �������"
Locales["rus"]["disableSystemHighlight"]="����. ���������� ���������"
Locales["rus"]["setColorButton"]="OK"
Locales["rus"]["red"]="�������"
Locales["rus"]["green"]="������"
Locales["rus"]["blue"]="�����"
Locales["rus"]["alpha"]="�������."
Locales["rus"]["headerColor"]="�������� ����"
Locales["rus"]["addPlayerNameButton"]="��������"
Locales["rus"]["addGuildNameButton"]="��������"
Locales["rus"]["useTargetHighlight"]=" "
Locales["rus"]["useClassHighlight"]="��������� �������"
Locales["rus"]["infoTxt"]="��������� ��������� - 1) ���� ���� 2) �� ������ ������� 3) �� ������ ������� 4) �� �������"
Locales["rus"]["enterName"]=userMods.ToWString("������� ���")

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

Locales["eng"]={}

