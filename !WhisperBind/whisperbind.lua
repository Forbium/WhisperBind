optvalue = 0;

-- https://wowwiki-archive.fandom.com/wiki/USERAPI_SlashCmdList_AddSlashCommand
-- /forbium

WB_storage = {}

function whisperbind_OnLoad()
    this:RegisterEvent("ADDON_LOADED");

    DEFAULT_CHAT_FRAME:AddMessage("whisperbindByF is loaded", 1.0, 1.0, 0.0)
    whisperbind:Show()
    options:Hide()
    optvalue = 0;

end

-- https://wowwiki-archive.fandom.com/wiki/Saving_variables_between_game_sessions
function whisperbind_OnEvent(event)
	if (event == "ADDON_LOADED") then
		if (arg1 == "!whisperbindByF") then
			loadvalue();
			DEFAULT_CHAT_FRAME:AddMessage("variables loaded", 1.0, 1.0, 0.0)
		end
	end
end


function ClickButton(player, text)
	if (string.len(player)>1) and (string.len(text)>1) then
		SendChatMessage(text, "WHISPER", nil, player);
	end
end

function optionsbtn()
    if(optvalue == 0) then
        options:Show()
        SaveFrame:Show()
        optvalue = 1;

    else
        options:Hide()
        SaveFrame:Hide()
        optvalue = 0;

    end
end

function savevalue()

	if(namebox1:GetText() ~= nil)   then
		WB_storage.namebox1 = namebox1:GetText();
		whisperbindbutton1:SetText(WB_storage.namebox1);
	end
	if(namebox2:GetText() ~= nil)   then
		WB_storage.namebox2 = namebox2:GetText();
		whisperbindbutton2:SetText(WB_storage.namebox2);
	end
	if(namebox3:GetText() ~= nil)   then
		WB_storage.namebox3 = namebox3:GetText();
		whisperbindbutton3:SetText(WB_storage.namebox3);
	end
	if(namebox4:GetText() ~= nil)   then
		WB_storage.namebox4 = namebox4:GetText();
		whisperbindbutton4:SetText(WB_storage.namebox4);
	end
	if(namebox5:GetText() ~= nil)   then
		WB_storage.namebox5 = namebox5:GetText();
		whisperbindbutton5:SetText(WB_storage.namebox5);
	end
	if(namebox6:GetText() ~= nil)   then
		WB_storage.namebox6 = namebox6:GetText();
		whisperbindbutton6:SetText(WB_storage.namebox6);
	end
	if(namebox7:GetText() ~= nil)   then
		WB_storage.namebox7 = namebox7:GetText();
		whisperbindbutton7:SetText(WB_storage.namebox7);
	end
	if(namebox8:GetText() ~= nil)   then
		WB_storage.namebox8 = namebox8:GetText();
		whisperbindbutton8:SetText(WB_storage.namebox8);
	end
	if(namebox9:GetText() ~= nil)   then
		WB_storage.namebox9 = namebox9:GetText();
		whisperbindbutton9:SetText(WB_storage.namebox9);
	end
	if(namebox10:GetText() ~= nil)   then
		WB_storage.namebox10 = namebox10:GetText();
		whisperbindbutton10:SetText(WB_storage.namebox10);
	end

	WB_storage.playerbox1 = playerbox1:GetText();
	WB_storage.playerbox2 = playerbox2:GetText();
	WB_storage.playerbox3 = playerbox3:GetText();
	WB_storage.playerbox4 = playerbox4:GetText();
	WB_storage.playerbox5 = playerbox5:GetText();
	WB_storage.playerbox6 = playerbox6:GetText();
	WB_storage.playerbox7 = playerbox7:GetText();
	WB_storage.playerbox8 = playerbox8:GetText();
	WB_storage.playerbox9 = playerbox9:GetText();
	WB_storage.playerbox10 = playerbox10:GetText();

	WB_storage.messagebox1 = messagebox1:GetText();
	WB_storage.messagebox2 = messagebox2:GetText();
	WB_storage.messagebox3 = messagebox3:GetText();
	WB_storage.messagebox4 = messagebox4:GetText();
	WB_storage.messagebox5 = messagebox5:GetText();
	WB_storage.messagebox6 = messagebox6:GetText();
	WB_storage.messagebox7 = messagebox7:GetText();
	WB_storage.messagebox8 = messagebox8:GetText();
	WB_storage.messagebox9 = messagebox9:GetText();
	WB_storage.messagebox10 = messagebox10:GetText();
end


function whisperbind_show()
	for i,k in pairs(WB_storage) do
		if (k ~= nil) then DEFAULT_CHAT_FRAME:AddMessage(i.." - "..k, 1.0, 1.0, 0.0) end
	end
end

function loadvalue()

	whisperbindbutton1:SetText(WB_storage.namebox1);
	namebox1:SetText(WB_storage.namebox1);
	whisperbindbutton2:SetText(WB_storage.namebox2);
	whisperbindbutton3:SetText(WB_storage.namebox3);
	whisperbindbutton4:SetText(WB_storage.namebox4);
	whisperbindbutton5:SetText(WB_storage.namebox5);
	whisperbindbutton6:SetText(WB_storage.namebox6);
	whisperbindbutton7:SetText(WB_storage.namebox7);
	whisperbindbutton8:SetText(WB_storage.namebox8);
	whisperbindbutton9:SetText(WB_storage.namebox9);
	whisperbindbutton10:SetText(WB_storage.namebox10);
	
	namebox1:SetText(WB_storage.namebox1);
	namebox2:SetText(WB_storage.namebox2);
	namebox3:SetText(WB_storage.namebox3);
	namebox4:SetText(WB_storage.namebox4);
	namebox5:SetText(WB_storage.namebox5);
	namebox6:SetText(WB_storage.namebox6);
	namebox7:SetText(WB_storage.namebox7);
	namebox8:SetText(WB_storage.namebox8);
	namebox9:SetText(WB_storage.namebox9);
	namebox10:SetText(WB_storage.namebox10);
	
	playerbox1:SetText(WB_storage.playerbox1);
	playerbox2:SetText(WB_storage.playerbox2);
	playerbox3:SetText(WB_storage.playerbox3);
	playerbox4:SetText(WB_storage.playerbox4);
	playerbox5:SetText(WB_storage.playerbox5);
	playerbox6:SetText(WB_storage.playerbox6);
	playerbox7:SetText(WB_storage.playerbox7);
	playerbox8:SetText(WB_storage.playerbox8);
	playerbox9:SetText(WB_storage.playerbox9);
	playerbox10:SetText(WB_storage.playerbox10);
	
	messagebox1:SetText(WB_storage.messagebox1);
	messagebox2:SetText(WB_storage.messagebox2);
	messagebox3:SetText(WB_storage.messagebox3);
	messagebox4:SetText(WB_storage.messagebox4);
	messagebox5:SetText(WB_storage.messagebox5);
	messagebox6:SetText(WB_storage.messagebox6);
	messagebox7:SetText(WB_storage.messagebox7);
	messagebox8:SetText(WB_storage.messagebox8);
	messagebox9:SetText(WB_storage.messagebox9);
	messagebox10:SetText(WB_storage.messagebox10);
end