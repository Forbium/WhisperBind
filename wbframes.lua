
WB_button = {}

WB_editbox = {}


function WBInterfaceFrame_Resize(count)
	--<AbsDimension x="72" y="260"/>
	WBInterfaceFrame:SetWidth(72);
    WBInterfaceFrame:SetHeight(wbcount*23+30);
	
	WBOptionsFrame:SetWidth(215);
	WBOptionsFrame:SetHeight(wbcount*23+30);

end


function wbinterface_make_buttons()	-- /run interface_make_buttons()
	--https://wowwiki-archive.fandom.com/wiki/UIHANDLER_OnClick
	local j = 1

	-- options id = 1
	--button[i] = CreateFrame(тип фрейма, уникальное имя для обращения, привязка, шаблон)
	WB_button[j] = CreateFrame("Button", ("Button"..j), WBInterfaceFrame, "WBinterfacebuttonTemplate")
	WB_button[j]:SetPoint("TOP",0,-6);
	--WB_button[j]:SetText("Options");
	WB_button[j]:SetScript("OnClick", WB_optionsbtn);
	j = j+1
	--DEFAULT_CHAT_FRAME:AddMessage("j = "..j, 1.0, 1.0, 0.0)

	-- save id = 11	/run i = 12; button[i]:Show();
	WB_button[j] = CreateFrame("Button", ("Button"..j), WBOptionsFrame, "WBinterfacebuttonTemplate")
	WB_button[j]:SetPoint("TOPLEFT",6,20);
	--WB_button[j]:SetText("Save");
	WB_button[j]:SetScript("OnClick", WB_savevalue);
	--button[i]:Hide();
	j = j+1
	--DEFAULT_CHAT_FRAME:AddMessage("j = "..j, 1.0, 1.0, 0.0)
	
	local n = 3
	for y=j,(j+n-1) do
		WB_button[y] = CreateFrame("Button", ("Button"..y), WBOptionsFrame, "WBinterfacebuttonTemplate")
		WB_button[y]:SetPoint("TOPLEFT",10+((y-j)*68),-6);
		--WB_button[y]:SetText("Column_"..y);
	end
	j = j+n
	--DEFAULT_CHAT_FRAME:AddMessage("j = "..j, 1.0, 1.0, 0.0)
	
	
	--WB_button[3]:SetText("ButtonID"); --/run button[13]:SetText("ButtonID");
	--WB_button[4]:SetText("Player");
	--WB_button[5]:SetText("Message");

	local n = wbcount
	for y=j,(j+n-1) do
		WB_button[y] = CreateFrame("Button", ("Button"..y-j), WBInterfaceFrame, "WBinterfacebuttonTemplate")
		WB_button[y]:SetPoint("TOP",0,-(32+(y-j)*22));
		--WB_button[y]:SetText("Button_"..y);
		--WB_button[y]:SetText("free");
		local yy = y
		WB_button[y]:SetScript("OnClick", function()
			WBClickButton(yy)
			--print(yy)
		end)
		--WB_button[y]:Click("test"..y)
	end
	j = j+n
	--DEFAULT_CHAT_FRAME:AddMessage("j = "..j, 1.0, 1.0, 0.0)
	
end

function wbinterface_make_editboxes()
	--https://wowwiki-archive.fandom.com/wiki/UIOBJECT_EditBox
	local j = 1

	n = wbcount
	for y=j,(j+n-1) do
		--<EditBox name = "namebox1" inherits = "InputBoxTemplate" autoFocus = "false">
		WB_editbox[y] = CreateFrame("EditBox", ("ButtonBox"..y-j), Button3, "WBeditboxTemplate")
		WB_editbox[y]:SetPoint("TOP",2,-(26+(y-j)*22));
		WB_editbox[y]:SetAutoFocus("false")
		--WB_editbox[y]:SetText("EditBox_"..y);
		--WB_editbox[y]:SetText("empty");
	end
	j = j+n
	
	n = wbcount
	for y=j,(j+n-1) do
		--<EditBox name = "namebox1" inherits = "InputBoxTemplate" autoFocus = "false">
		WB_editbox[y] = CreateFrame("EditBox", ("PlayerBox"..y-j), Button4, "WBeditboxTemplate")
		WB_editbox[y]:SetPoint("TOP",2,-(26+(y-j)*22));
		WB_editbox[y]:SetAutoFocus("false")
		--WB_editbox[y]:SetText("EditBox_"..y);
		--WB_editbox[y]:SetText("empty");
	end
	j = j+n

	n = wbcount
	for y=j,(j+n-1) do
		--<EditBox name = "namebox1" inherits = "InputBoxTemplate" autoFocus = "false">
		WB_editbox[y] = CreateFrame("EditBox", ("MessageBox"..y-j), Button5, "WBeditboxTemplate")
		WB_editbox[y]:SetPoint("TOP",2,-(26+(y-j)*22));
		WB_editbox[y]:SetAutoFocus("false")
		--WB_editbox[y]:SetText("EditBox_"..y);
		--WB_editbox[y]:SetText("empty");
	end
	j = j+n

end

