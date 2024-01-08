optvalue = 0;

--DEFAULT_CHAT_FRAME:AddMessage(saveinformation[1], 1.0, 1.0, 0.0)

saveinformation = {
1,
2,
3,
4,
5,
6,
7,
8,
9,
10,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil
}


function interface_OnLoad()
    this:RegisterEvent("ADDON_LOADED");

    DEFAULT_CHAT_FRAME:AddMessage("interfaceByF is loaded", 1.0, 1.0, 0.0)
    interface:Show()
    options:Hide()
    optvalue = 0;
end

function ClickButton(player, text)
    SendChatMessage(text, "WHISPER", nil, player);
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

function savevalue(nameb1, nameb2, nameb3, nameb4, nameb5, nameb6, nameb7, nameb8, nameb9, nameb10,
    playerb1, playerb2, playerb3, playerb4, playerb5, playerb6, playerb7, playerb8, playerb9, playerb10,
    messageb1, messageb2, messageb3, messageb4, messageb5, messageb6, messageb7, messageb8, messageb9, messageb10)
    if(nameb1 ~= nil)   then
        saveinformation[1] = nameb1;
    end
    if(nameb2 ~= nil)   then
        saveinformation[2] = nameb2;
    end
    if(nameb3 ~= nil)   then
        saveinformation[3] = nameb3;
    end
    if(nameb4 ~= nil)   then
        saveinformation[4] = nameb4;
    end
    if(nameb5 ~= nil)   then
        saveinformation[5] = nameb5;
    end
    if(nameb6 ~= nil)   then
        saveinformation[6] = nameb6;
    end
    if(nameb7 ~= nil)   then
        saveinformation[7] = nameb7;
    end
    if(nameb8 ~= nil)   then
        saveinformation[8] = nameb8;
    end
    if(nameb9 ~= nil)   then
        saveinformation[9] = nameb9;
    end
    if(nameb10 ~= nil)   then
        saveinformation[10] = nameb10;
    end

    saveinformation[11] = playerb1;
    saveinformation[12] = playerb2;
    saveinformation[13] = playerb3;
    saveinformation[14] = playerb4;
    saveinformation[15] = playerb5;
    saveinformation[16] = playerb6;
    saveinformation[17] = playerb7;
    saveinformation[18] = playerb8;
    saveinformation[19] = playerb9;
    saveinformation[20] = playerb10;

    saveinformation[21] = messageb1;
    saveinformation[22] = messageb2;
    saveinformation[23] = messageb3;
    saveinformation[24] = messageb4;
    saveinformation[25] = messageb5;
    saveinformation[26] = messageb6;
    saveinformation[27] = messageb7;
    saveinformation[28] = messageb8;
    saveinformation[29] = messageb9;
    saveinformation[30] = messageb10;

    DEFAULT_CHAT_FRAME:AddMessage(saveinformation[1], 1.0, 1.0, 0.0)

end


function loadvalue(namebox1)
    if(saveinformation[1] ~= nil) then
        namebox1:SetText(saveinformation[1]);
    end

    DEFAULT_CHAT_FRAME:AddMessage(namebox1:GetText(), 1.0, 1.0, 0.0)
end