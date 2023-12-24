
--[[function Test1()
    CastSpellByName("Charge")
    r=0
    for kk=1,16 do 
    if UnitDebuff("target", kk) then
    if string.find(UnitDebuff("target", kk), "Ability_Gouge") then r=1
    end end end

    DEFAULT_CHAT_FRAME:AddMessage("R = "..r, 1.0, 1.0, 0.0)
    if r==1 then
    CastSpellByName("Hamstring")
    else
    CastSpellByName("Rend")
    end end
]]

function Start()
    CastSpellByName("Charge")
    r=0
    h=0

    for kk=1,16 do
    if UnitDebuff("target", kk) then
    if string.find(UnitDebuff("target", kk), "Ability_Gouge") then r=1 end
    if string.find(UnitDebuff("target", kk), "Ability_ShockWave") then h=1 end
    end end

    DEFAULT_CHAT_FRAME:AddMessage("R = "..r, 1.0, 1.0, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("H = "..h, 1.0, 1.0, 0.0)
    if r==0 then
    CastSpellByName("Rend") else
    if h==0 then
    CastSpellByName("Hamstring") else
    CastSpellByName("Heroic Strike") end end
end

function SunArm()
    s=0
    for k=1,16 do
    if UnitDebuff("target", k) then
    if string.find(UnitDebuff("target", k), "Ability_Warrior_Sunder") then
        name , s = UnitDebuff("target", k)
    end end end
    if s<5 then
        CastSpellByName("Sunder Armor")
    end
end


function AttakMy()
    if(GetUnitName("targettarget")~=GetUnitName("player"))then
        c=0
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);                --Активный значит в Defensive stance
        if isActive then
            CastSpellByName("Taunt")                                    --если Активный, то использовать Taunt
    
        else
            if UnitAffectingCombat("player") then                       --иначе если игрок в бою то
                CastSpellByName("Mocking Blow")                         --использовать Mocking Blow
            else
                CastSpellByName("Charge")                               --иначе использовать Charge
                for kk=1,16 do
                if UnitDebuff("target", kk) then
                    if string.find(UnitDebuff("target", kk), "Ability_Gouge") then            --если на враге найден дебаф от удара Hamstring то
                        if c==0 then
                            c=1
                            CastShapeshiftForm(2)                                             --изменить стойку на Defensive stance
                        end
                        if c==1 then
                            c=2
                            CastSpellByName("Taunt")                                          --использовать Taunt
                        end
                    else
                        CastSpellByName("Hamstring")                                          --использовать Hamstring
                    end
                end
                end
            end
        end
    else
        if(GetUnitName("targettarget")==GetUnitName("player")) and c==2 then
            c=3
            CastShapeshiftForm(1)                                             --изменить стойку на Battle stance
        end
    end
end 


--[[function AttakMy2()
  local _,_,isActive,_ = GetShapeshiftFormInfo(2);
  if isActive then
    CastSpellByName("Taunt")
  else
    CastShapeshiftForm(2)
  end
end]]

function Test2()
    --[[CastSpellByName("Riding Turtle")]]
    rnd = math.random(2)
    DEFAULT_CHAT_FRAME:AddMessage(rnd)
    if(rnd == 1) then
        CastSpellByName("Mechanical Squirrel Box")
    else
        CastSpellByName("Wyvern Roost Hatchling")
    end
end


function MyBot1()
    local teambuff1 = 1;
    local teambuff2 = 1;
    local targetdebuff = 1;
    if UnitIsFriend("player", "target") then
        while UnitBuff("target",teambuff1) do
            if string.find(UnitBuff("target",teambuff1),"Spell_Nature_Regeneration") then
                teambuff1=18
            end
            teambuff1=teambuff1+1
        end
        if teambuff1<17 then CastSpellByName("Mark of the Wild") end
        
        if (UnitHealthMax("target") ~= UnitHealth("target")) then
            if (UnitHealth("target") <= (0.7 * UnitHealthMax("target"))) then
                CastSpellByName("Healing Touch")
            end
            while UnitBuff("target",teambuff2) do
                if string.find(UnitBuff("target",teambuff2),"Spell_Nature_Rejuvenation") then
                    teambuff2=18
                end
                teambuff2=teambuff2+1
            end
            if teambuff2<17 then CastSpellByName("Rejuvenation") end
        end
    else
        if (UnitHealthMax("player") ~= UnitHealth("player")) then
            if (UnitHealth("player") <= (0.7 * UnitHealthMax("player"))) then
                CastSpellByName("Healing Touch")
            end
            while UnitBuff("player",teambuff2) do
                if string.find(UnitBuff("player",teambuff2),"Spell_Nature_Rejuvenation") then
                    teambuff2=18
                end
                teambuff2=teambuff2+1
            end
            if teambuff2<17 then CastSpellByName("Rejuvenation") end
        end
        while UnitDebuff("target",targetdebuff) do
            if string.find(UnitDebuff("target",targetdebuff),"Spell_Nature_StarFall") then 
                targetdebuff=18
            end
            targetdebuff=targetdebuff+1
        end
        if targetdebuff<17 then
            CastSpellByName("Moonfire")
        else
        CastSpellByName("Wrath")
        end
    end
end

--======= VERSION 2023.12.24 =============

buff_trigger = {
    "mark",
    "thorns"
}
buff_spell = {
    "Mark of the Wild",
    "Thorns"
}
buff_effect = {
    "Spell_Nature_Regeneration",
    "Spell_Nature_Thorns"
}

allbuff_trigger = "allbuff"

queuery_spells = {}
queuery_names = {}


function battle_OnLoad()
    this:RegisterEvent("CHAT_MSG_WHISPER");
    DEFAULT_CHAT_FRAME:AddMessage("addon loaded", 1.0, 1.0, 0.0)
end

function battle_OnEvent(event)
    if (event == "CHAT_MSG_WHISPER") then
        name = arg2
        text = arg1 -- "mark" "thons" "root" "allbuff"=>"mark thorns root"

        DEFAULT_CHAT_FRAME:AddMessage(name.." send me "..text, 1.0, 1.0, 0.0)

        if ( string.find(text,"^ *"..allbuff_trigger.." *$" ) ) then
            local temp = ""
            for _,s in pairs(buff_trigger) do
                temp = temp..s.." "
            end
            text = temp
            DEFAULT_CHAT_FRAME:AddMessage(temp, 1.0, 1.0, 0.0)
        end

        for y = 1, table.getn(buff_trigger) do 
            --if ( string.find(text,"^ *"..buff_trigger[y].." *$" ) ) then
            if ( string.find(text,"^ *"..buff_trigger[y].." +")  or string.find(text," +"..buff_trigger[y].." *$") or string.find(text," +"..buff_trigger[y].." +") ) then
                queuery_spells[table.getn(queuery_spells)+1] = buff_spell[y]
                queuery_names[table.getn(queuery_names)+1] = name

                DEFAULT_CHAT_FRAME:AddMessage("+ add to queuery for "..name.." cast "..buff_spell[y].." as "..table.getn(queuery_spells), 0.0, 0.5, 0.5)
            end
        end
    end
end

function buffcasting()
    --for i = 1,table.getn(queuery_spells) do
    --for i,v in pairs(queuery_spells) do
    while(queuery_spells[1]) do
        TargetByName(queuery_names[1]);

        -- nomer spella v massive
        local a;
        for j,s in pairs(buff_spell) do if s==queuery_spells[1] then a=j end end

        local b = 1;
        while UnitBuff("target",b) do
            if string.find(UnitBuff("target",b),buff_effect[a]) then
                b=18; end; b=b+1;
        end

        local castspell=queuery_spells[1];
        table.remove(queuery_names, 1)
        table.remove(queuery_spells, 1)
        for ig, vg in pairs(queuery_spells) do DEFAULT_CHAT_FRAME:AddMessage(ig.." - "..queuery_names[ig].." + "..vg, 0.0, 1.0, 0.5) end

        if b<17 then CastSpellByName(castspell); break end

    end
end


-- a = { 1 = "cast"; 2 = "spell"}
-- a[i] = (1 = "cast")



--[[======= BAD VERSION 2023.12.15 =============

function AllBuff()
    local teambuff1 = 1;
    local teambuff2 = 1;
    
    if ("target" == nil) then TargetUnit("player") end
    
    while UnitBuff("target",teambuff1) do
        if string.find(UnitBuff("target",teambuff1),"Spell_Nature_Regeneration") then
            teambuff1=18
        end
        teambuff1=teambuff1+1
    end
    if teambuff1<17 then CastSpellByName("Mark of the Wild") end
    while UnitBuff("target",teambuff2) do
        if string.find(UnitBuff("target",teambuff2),"Spell_Nature_Thorns") then
            teambuff2=18
        end
        teambuff2=teambuff2+1
    end
    if teambuff2<17 then CastSpellByName("Thorns") end
end



battle_Library = {}

function battle_OnLoad()
    this:RegisterEvent("CHAT_MSG_WHISPER");
    DEFAULT_CHAT_FRAME:AddMessage("it`s okey", 1.0, 1.0, 0.0)
end

function battle_OnEvent(event)
    local trigger = "allbuff"

    if (event == "CHAT_MSG_WHISPER") then
        name = arg2
        text = arg1 -- "mark" "thons" "root" "allbuff"=>"mark thorns root"

        if ( string.find(text,"^ *"..trigger.." *$" ) ) then
            DEFAULT_CHAT_FRAME:AddMessage(name.." send me "..text, 1.0, 1.0, 0.0)

            battle_Library[table.getn(battle_Library)+1] = {name = arg2; spell = arg1}
        end
    end
end

function battle_Cast()
    for i = 1,table.getn(battle_Library) do
        --DEFAULT_CHAT_FRAME:AddMessage(i..") asker is "..battle_Library[i].name, 1.0, 1.0, 0.0)

        --if (not battle_Library[i]) then
            DEFAULT_CHAT_FRAME:AddMessage("nil is = "..battle_Library[i].name, 1.0, 1.0, 0.0)      -- nil = nil
        else
            TargetByName(battle_Library[i].name)
            --DEFAULT_CHAT_FRAME:AddMessage("name is = "..battle_Library[i].name, 1.0, 1.0, 0.0)
            --battle_Library[i] = nil
            table.remove(battle_Library, i)
            for ig, v in pairs(battle_Library) do DEFAULT_CHAT_FRAME:AddMessage(ig.." - "..v.name.." + "..v.spell, 0.0, 1.0, 0.5) end
            AllBuff()
        --end
    end
end]]