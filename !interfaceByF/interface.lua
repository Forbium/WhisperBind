Caster = "Caecus";
optvalue = 0;


function interface_OnLoad()
    DEFAULT_CHAT_FRAME:AddMessage("interfaceByF is loaded", 1.0, 1.0, 0.0)
    interface:Show()
    options:Hide()
    optvalue = 0;
end

function interface_DragOn()
    interface:StartMoving();
end

function ClickButton(player, text)
    SendChatMessage(text, "WHISPER", nil, player);
end

function optionsbtn()
    if(optvalue == 0) then
        options:Show()
        optvalue = 1;
    else
        options:Hide()
        optvalue = 0;
    end
end