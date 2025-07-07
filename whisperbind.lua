wbopt = 0
wbcount = nil

WB_buttonbox = {}
WB_playerbox = {}
WB_messagebox = {}

--DEFAULT_CHAT_FRAME:AddMessage(saveinformation[1], 1.0, 1.0, 0.0)

-- https://wowwiki-archive.fandom.com/wiki/USERAPI_SlashCmdList_AddSlashCommand
-- /forbium

-- Rogolist edition 2024.01.11




function wbinterface_OnLoad()
    this:RegisterEvent("ADDON_LOADED");

    DEFAULT_CHAT_FRAME:AddMessage("WhisperBind is loaded", 1.0, 1.0, 0.0)
    WBInterfaceFrame:Show()
    --options:Hide()
    --wbopt = 0;
	--WBInterfaceFrame_Resize(wbcount)
	--defaultVariables()
end


-- https://wowwiki-archive.fandom.com/wiki/Saving_variables_between_game_sessions
function wbinterface_OnEvent(event)
	if (event == "ADDON_LOADED") then
		--addons_massiv[iii] = ("LOADED: === "..arg1)
		--iii = iii + 1;
		--DEFAULT_CHAT_FRAME:AddMessage("LOADED: === "..arg1, 1.0, 1.0, 0.0)
		if (arg1 == "!WhisperBind") then
			DEFAULT_CHAT_FRAME:AddMessage("WhisperBind variables loaded", 1.0, 1.0, 0.0)
			wbopt = 0;
			if (wbcount == nil) then wbcount = 3 end
			
			WBInterfaceFrame_Resize(wbcount)
			wbinterface_make_buttons();
			wbinterface_make_editboxes();
			WB_loadvalue();
		end
	end
end


function WBClickButton(id)
	--local text = clicked_button:GetText()
	id = id - 5
	--DEFAULT_CHAT_FRAME:AddMessage("id = "..id, 1.0, 1.0, 0.0)
	--DEFAULT_CHAT_FRAME:AddMessage("player = "..WB_playerbox[id], 1.0, 1.0, 0.0)
	--DEFAULT_CHAT_FRAME:AddMessage("message = "..WB_messagebox[id], 1.0, 1.0, 0.0)
	
	local player, text = WB_playerbox[id], WB_messagebox[id]
	--DEFAULT_CHAT_FRAME:AddMessage("player = "..player, 1.0, 1.0, 0.0)
	--DEFAULT_CHAT_FRAME:AddMessage("text = "..text, 1.0, 1.0, 0.0)
	
	--if (string.len(player)>1) and (string.len(text)>1) then
	if (string.len(player)>1) then
		SendChatMessage(text, "WHISPER", nil, player);
	end
end


function WB_optionsbtn()
    if(wbopt == 0) then
		--DEFAULT_CHAT_FRAME:AddMessage("show", 1.0, 1.0, 0.0)
        WBOptionsFrame:Show()
        --SaveFrame:Show()
        wbopt = 1;

    else
		--DEFAULT_CHAT_FRAME:AddMessage("hide", 1.0, 1.0, 0.0)
        WBOptionsFrame:Hide()
        --SaveFrame:Hide()
        wbopt = 0;

    end
end



-- Rogolist edition
function WB_savevalue()

	for ii = 1,wbcount do
		

		WB_buttonbox[ii] = WB_editbox[ii]:GetText()
		--DEFAULT_CHAT_FRAME:AddMessage("WB_buttonbox["..ii.."] = "..WB_editbox[ii]:GetText(), 1.0, 1.0, 0.0)
		local b=ii+5
		WB_button[b]:SetText(WB_buttonbox[ii])
		
		local p = ii + wbcount
		WB_playerbox[ii] = WB_editbox[p]:GetText()
		--DEFAULT_CHAT_FRAME:AddMessage("WB_playerbox["..ii.."] = "..WB_editbox[p]:GetText(), 1.0, 1.0, 0.0)

		local m = ii + wbcount*2
		WB_messagebox[ii] = WB_editbox[m]:GetText()
		--DEFAULT_CHAT_FRAME:AddMessage("WB_mesagebox["..ii.."] = "..WB_editbox[m]:GetText(), 1.0, 1.0, 0.0)
	end
	

end

function WB_loadvalue()
	
	WB_button[1]:SetText("Options");
	WB_button[2]:SetText("Save");
	WB_button[3]:SetText("ButtonID");
	WB_button[4]:SetText("Player");
	WB_button[5]:SetText("Message");

	for ii = 1,wbcount do
		local b = ii+5
		--WB_button[b]:SetText("Test");
		WB_button[b]:SetText(WB_buttonbox[ii]);
		--DEFAULT_CHAT_FRAME:AddMessage("WB_button["..b.."] = "..WB_buttonbox[ii], 1.0, 1.0, 0.0)
		
		--WB_editbox[ii]:SetText("Name");
		WB_editbox[ii]:SetText(WB_buttonbox[ii]);
		--DEFAULT_CHAT_FRAME:AddMessage("WB_editbox["..ii.."] = "..WB_buttonbox[ii], 1.0, 1.0, 0.0)
		local p = ii + wbcount
		--WB_editbox[p]:SetText("Play");
		WB_editbox[p]:SetText(WB_playerbox[ii]);
		--DEFAULT_CHAT_FRAME:AddMessage("WB_editbox["..p.."] = "..WB_playerbox[ii], 1.0, 1.0, 0.0)
		local m = ii + wbcount*2
		--WB_editbox[m]:SetText("Mess");
		WB_editbox[m]:SetText(WB_messagebox[ii]);
		--DEFAULT_CHAT_FRAME:AddMessage("WB_editbox["..m.."] = "..WB_messagebox[ii], 1.0, 1.0, 0.0)
	end
end

function WB_debug()
	local yy =1
	while WB_button[yy] do
		WB_button[yy]:SetText("Butt_"..yy);
		yy = yy + 1
	end
	
	local yy =1
	while WB_editbox[yy] do
		WB_editbox[yy]:SetText("EBox_"..yy);
		yy = yy + 1
	end
	
end

function WBdefaultVariables()
	for i=1,wbcount do
		WB_buttonbox[i] = "name"..i
		WB_playerbox[i] = "play"..i
		WB_messagebox[i] = "mess"..i
	end
end


function WB_interface_show()
	DEFAULT_CHAT_FRAME:AddMessage("BUTTONS:", 1.0, 1.0, 0.0)
	for i,k in pairs(WB_buttonbox) do
		if (k ~= nil) then DEFAULT_CHAT_FRAME:AddMessage(i.." - "..k, 1.0, 1.0, 0.0) end
	end
	
	DEFAULT_CHAT_FRAME:AddMessage("PLAYERS:", 1.0, 1.0, 0.0)
	for i,k in pairs(WB_playerbox) do
		if (k ~= nil) then DEFAULT_CHAT_FRAME:AddMessage(i.." - "..k, 1.0, 1.0, 0.0) end
	end
	
	DEFAULT_CHAT_FRAME:AddMessage("MESSAGES:", 1.0, 1.0, 0.0)
	for i,k in pairs(WB_messagebox) do
		if (k ~= nil) then DEFAULT_CHAT_FRAME:AddMessage(i.." - "..k, 1.0, 1.0, 0.0) end
	end
	
end



