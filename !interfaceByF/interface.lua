optvalue = 0;

--DEFAULT_CHAT_FRAME:AddMessage(saveinformation[1], 1.0, 1.0, 0.0)

-- https://wowwiki-archive.fandom.com/wiki/USERAPI_SlashCmdList_AddSlashCommand
-- /forbium

-- Rogolist edition
saveinformation = {
namebox1 = "free",
namebox2 = "free",
namebox3 = "free",
namebox4 = "free",
namebox5 = "free",
namebox6 = "free",
namebox7 = "free",
namebox8 = "free",
namebox9 = "free",
namebox10 = "free",

playerbox1 = nil,
playerbox2 = nil,
playerbox3 = nil,
playerbox4 = nil,
playerbox5 = nil,
playerbox6 = nil,
playerbox7 = nil,
playerbox8 = nil,
playerbox9 = nil,
playerbox10 = nil,

messagebox1 = nil,
messagebox2 = nil,
messagebox3 = nil,
messagebox4 = nil,
messagebox5 = nil,
messagebox6 = nil,
messagebox7 = nil,
messagebox8 = nil,
messagebox9 = nil,
messagebox10 = nil
}

function interface_OnLoad()
    this:RegisterEvent("ADDON_LOADED");

    DEFAULT_CHAT_FRAME:AddMessage("interfaceByF is loaded", 1.0, 1.0, 0.0)
    interface:Show()
    options:Hide()
    optvalue = 0;

end

--addons_massiv = {}
--iii = 1

-- https://wowwiki-archive.fandom.com/wiki/Saving_variables_between_game_sessions
function interface_OnEvent(event)
	if (event == "ADDON_LOADED") then
		--addons_massiv[iii] = ("LOADED: === "..arg1)
		--iii = iii + 1;
		--DEFAULT_CHAT_FRAME:AddMessage("LOADED: === "..arg1, 1.0, 1.0, 0.0)
		if (arg1 == "!interfaceByF") then
			loadvalue();
			DEFAULT_CHAT_FRAME:AddMessage("variables loaded", 1.0, 1.0, 0.0)
		end
	end
end

--/run for _,k in pairs(addons_massiv) do print(k) end


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

-- Rogolist edition
function savevalue()

	if(namebox1:GetText() ~= nil)   then
		saveinformation.namebox1 = namebox1:GetText();
		interfacebutton1:SetText(saveinformation.namebox1);
	end
	if(namebox2:GetText() ~= nil)   then
		saveinformation.namebox2 = namebox2:GetText();
		interfacebutton2:SetText(saveinformation.namebox2);
	end
	if(namebox3:GetText() ~= nil)   then
		saveinformation.namebox3 = namebox3:GetText();
		interfacebutton3:SetText(saveinformation.namebox3);
	end
	if(namebox4:GetText() ~= nil)   then
		saveinformation.namebox4 = namebox4:GetText();
		interfacebutton4:SetText(saveinformation.namebox4);
	end
	if(namebox5:GetText() ~= nil)   then
		saveinformation.namebox5 = namebox5:GetText();
		interfacebutton5:SetText(saveinformation.namebox5);
	end
	if(namebox6:GetText() ~= nil)   then
		saveinformation.namebox6 = namebox6:GetText();
		interfacebutton6:SetText(saveinformation.namebox6);
	end
	if(namebox7:GetText() ~= nil)   then
		saveinformation.namebox7 = namebox7:GetText();
		interfacebutton7:SetText(saveinformation.namebox7);
	end
	if(namebox8:GetText() ~= nil)   then
		saveinformation.namebox8 = namebox8:GetText();
		interfacebutton8:SetText(saveinformation.namebox8);
	end
	if(namebox9:GetText() ~= nil)   then
		saveinformation.namebox9 = namebox9:GetText();
		interfacebutton9:SetText(saveinformation.namebox9);
	end
	if(namebox10:GetText() ~= nil)   then
		saveinformation.namebox10 = namebox10:GetText();
		interfacebutton10:SetText(saveinformation.namebox10);
	end

	saveinformation.playerbox1 = playerbox1:GetText();
	saveinformation.playerbox2 = playerbox2:GetText();
	saveinformation.playerbox3 = playerbox3:GetText();
	saveinformation.playerbox4 = playerbox4:GetText();
	saveinformation.playerbox5 = playerbox5:GetText();
	saveinformation.playerbox6 = playerbox6:GetText();
	saveinformation.playerbox7 = playerbox7:GetText();
	saveinformation.playerbox8 = playerbox8:GetText();
	saveinformation.playerbox9 = playerbox9:GetText();
	saveinformation.playerbox10 = playerbox10:GetText();

	saveinformation.messagebox1 = messagebox1:GetText();
	saveinformation.messagebox2 = messagebox2:GetText();
	saveinformation.messagebox3 = messagebox3:GetText();
	saveinformation.messagebox4 = messagebox4:GetText();
	saveinformation.messagebox5 = messagebox5:GetText();
	saveinformation.messagebox6 = messagebox6:GetText();
	saveinformation.messagebox7 = messagebox7:GetText();
	saveinformation.messagebox8 = messagebox8:GetText();
	saveinformation.messagebox9 = messagebox9:GetText();
	saveinformation.messagebox10 = messagebox10:GetText();
	
	--[[
	for i,k in pairs(saveinformation) do
		if (k ~= nil) then DEFAULT_CHAT_FRAME:AddMessage(i.." - "..k, 1.0, 1.0, 0.0) end
	end
	]]
end


function interface_show()
	for i,k in pairs(saveinformation) do
		if (k ~= nil) then DEFAULT_CHAT_FRAME:AddMessage(i.." - "..k, 1.0, 1.0, 0.0) end
	end
end


function loadvalue()

	interfacebutton1:SetText(saveinformation.namebox1);
	interfacebutton2:SetText(saveinformation.namebox2);
	interfacebutton3:SetText(saveinformation.namebox3);
	interfacebutton4:SetText(saveinformation.namebox4);
	interfacebutton5:SetText(saveinformation.namebox5);
	interfacebutton6:SetText(saveinformation.namebox6);
	interfacebutton7:SetText(saveinformation.namebox7);
	interfacebutton8:SetText(saveinformation.namebox8);
	interfacebutton9:SetText(saveinformation.namebox9);
	interfacebutton10:SetText(saveinformation.namebox10);
	
	namebox1:SetText(saveinformation.namebox1);
	namebox2:SetText(saveinformation.namebox2);
	namebox3:SetText(saveinformation.namebox3);
	namebox4:SetText(saveinformation.namebox4);
	namebox5:SetText(saveinformation.namebox5);
	namebox6:SetText(saveinformation.namebox6);
	namebox7:SetText(saveinformation.namebox7);
	namebox8:SetText(saveinformation.namebox8);
	namebox9:SetText(saveinformation.namebox9);
	namebox10:SetText(saveinformation.namebox10);
	
	playerbox1:SetText(saveinformation.playerbox1);
	playerbox2:SetText(saveinformation.playerbox2);
	playerbox3:SetText(saveinformation.playerbox3);
	playerbox4:SetText(saveinformation.playerbox4);
	playerbox5:SetText(saveinformation.playerbox5);
	playerbox6:SetText(saveinformation.playerbox6);
	playerbox7:SetText(saveinformation.playerbox7);
	playerbox8:SetText(saveinformation.playerbox8);
	playerbox9:SetText(saveinformation.playerbox9);
	playerbox10:SetText(saveinformation.playerbox10);
	
	messagebox1:SetText(saveinformation.messagebox1);
	messagebox2:SetText(saveinformation.messagebox2);
	messagebox3:SetText(saveinformation.messagebox3);
	messagebox4:SetText(saveinformation.messagebox4);
	messagebox5:SetText(saveinformation.messagebox5);
	messagebox6:SetText(saveinformation.messagebox6);
	messagebox7:SetText(saveinformation.messagebox7);
	messagebox8:SetText(saveinformation.messagebox8);
	messagebox9:SetText(saveinformation.messagebox9);
	messagebox10:SetText(saveinformation.messagebox10);
	
	
end
