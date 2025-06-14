-- Enhanced WhisperBind v2.0 для WoW Turtle (1.12.1)
-- Расширенная версия с категориями, переменными, статистикой и автоответчиком

wbopt = 0
wbcount = nil

WB_buttonbox = {}
WB_playerbox = {}
WB_messagebox = {}
WB_categories = WB_categories or {}
WB_icons = {}
WB_usage_stats = {}
WB_message_history = {}

-- Новые функции
WB_current_category = "All"
WB_category_list = {"All", "Trade", "Guild", "Raid", "PvP", "Social"}
WB_category_colors = {
    ["All"] = {1.0, 1.0, 1.0},
    ["Trade"] = {1.0, 0.8, 0.0},
    ["Guild"] = {0.0, 1.0, 0.0},
    ["Raid"] = {1.0, 0.0, 0.0},
    ["PvP"] = {0.8, 0.0, 1.0},
    ["Social"] = {0.0, 0.8, 1.0}
}

-- Автоответчик
if not WB_autoresponder then WB_autoresponder = {} end
WB_autoresponder.responses = WB_autoresponder.responses or {}
WB_autoresponder.keywords = WB_autoresponder.keywords or {}
WB_autoresponder.ignore_list = WB_autoresponder.ignore_list or {}
WB_autoresponder.enabled_rows = WB_autoresponder.enabled_rows or {}




-- UI элементы
WB_category_dropdown = nil
WB_stats_frame = nil
WB_autoresponder_frame = nil
WB_import_export_frame = nil

function wbinterface_OnLoad()
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("CHAT_MSG_WHISPER");
    this:RegisterEvent("CHAT_MSG_WHISPER_INFORM");

    DEFAULT_CHAT_FRAME:AddMessage("WhisperBind v2.0 is loaded", 0.0, 1.0, 0.0)
    WBInterfaceFrame:Show()
end

function wbinterface_OnEvent(event)
    if (event == "ADDON_LOADED") and (arg1 == "!WhisperBind") then
        DEFAULT_CHAT_FRAME:AddMessage("WhisperBind variables loaded", 0.0, 1.0, 0.0)
        wbopt = 0;
        WB_delmode = false;
        if (wbcount == nil) then wbcount = 3 end
        WB_autoresponder.ui_visible = false
        -- Инициализация новых переменных
        WB_InitializeNewFeatures()
        
        WBInterfaceFrame_Resize(wbcount)
        wbinterface_make_buttons();
        wbinterface_make_editboxes();
        wbinterface_make_delete_buttons();
        WB_CreateCategoryDropdown();
        WB_loadvalue();
		WB_CreateCategoryFilterButton()
		WB_SetCategoryFilter("All")
    elseif (event == "CHAT_MSG_WHISPER") then
        WB_HandleIncomingWhisper(arg1, arg2)
    elseif (event == "CHAT_MSG_WHISPER_INFORM") then
        WB_LogOutgoingMessage(arg1, arg2)
    end
end

-- Инициализация новых функций
function WB_InitializeNewFeatures()
    -- Инициализация категорий
    if not WB_categories[1] then
        for i = 1, wbcount do
            WB_categories[i] = "Общение"
            WB_icons[i] = ""
            WB_usage_stats[i] = 0
        end
    end
    
    -- Инициализация автоответчика
    if not WB_autoresponder.responses[1] then
        WB_autoresponder.responses[1] = "Спасибо за сообщение! Отвечу позже."
        WB_autoresponder.keywords[1] = "привет,здравствуй,добро пожаловать"
    end
end

-- Загрузка значений в UI
function WB_loadvalue()
    for i = 1, wbcount do
        -- Загрузка имен кнопок
        if WB_editbox[i] then
            WB_editbox[i]:SetText(WB_buttonbox[i] or "")
        end
        -- Загрузка имен игроков
        if WB_editbox[i + wbcount] then
            WB_editbox[i + wbcount]:SetText(WB_playerbox[i] or "")
        end
        -- Загрузка сообщений
        if WB_editbox[i + wbcount * 2] then
            WB_editbox[i + wbcount * 2]:SetText(WB_messagebox[i] or "")
        end
        -- Загрузка категорий
        if WB_category_editbox[i] then
            WB_category_editbox[i]:SetText(WB_categories[i] or "Общение")
        end
        -- Обновление текста кнопок
        if WB_button[i + 9] then -- исправлен индекс для основных кнопок
            WB_button[i + 9]:SetText(WB_buttonbox[i] or ("Btn" .. i))
        end
		if WB_keywords_editbox[i] then
			WB_keywords_editbox[i]:SetText(WB_autoresponder.keywords[i] or "")
		end
		if WB_autorespond_checkbox[i] then
			WB_autorespond_checkbox[i]:SetChecked(WB_autoresponder.enabled_rows[i] or false)
		end
    end
    if WB_autoresponder and WB_autoresponder.ui_visible then
        -- Загружаем ключевые слова
        if WB_autoresponder.keywords then
            for i = 1, wbcount do
                if WB_keywords_editbox[i] and WB_autoresponder.keywords[i] then
                    WB_keywords_editbox[i]:SetText(WB_autoresponder.keywords[i])
                end
            end
        end
        
        -- Загружаем состояние чекбоксов
        if WB_autoresponder.enabled_rows then
            for i = 1, wbcount do
                if WB_autorespond_checkbox[i] then
                    WB_autorespond_checkbox[i]:SetChecked(WB_autoresponder.enabled_rows[i] or false)
                end
            end
        end
    end
    WB_ApplyCategoryColors()
end

-- Сохранение значений из UI
function WB_savevalue()
    for i = 1, wbcount do
        -- Сохранение имен кнопок
        if WB_editbox[i] then
            WB_buttonbox[i] = WB_editbox[i]:GetText()
        end
        -- Сохранение имен игроков
        if WB_editbox[i + wbcount] then
            WB_playerbox[i] = WB_editbox[i + wbcount]:GetText()
        end
        -- Сохранение сообщений
        if WB_editbox[i + wbcount * 2] then
            WB_messagebox[i] = WB_editbox[i + wbcount * 2]:GetText()
        end
        -- Сохранение категорий
        if WB_category_editbox[i] then
            WB_categories[i] = WB_category_editbox[i]:GetText()
        end
        -- Обновление текста основных кнопок
        if WB_button[i + 9] then
            WB_button[i + 9]:SetText(WB_buttonbox[i] or ("Btn" .. i))
        end
		if WB_keywords_editbox[i] then
			WB_autoresponder.keywords[i] = WB_keywords_editbox[i]:GetText()
		end
		if WB_autorespond_checkbox[i] then
			WB_autoresponder.enabled_rows[i] = WB_autorespond_checkbox[i]:GetChecked()
		end
        
	end
    if WB_autoresponder then
        -- Инициализируем таблицы если их нет
        if not WB_autoresponder.keywords then
            WB_autoresponder.keywords = {}
        end
        if not WB_autoresponder.enabled_rows then
            WB_autoresponder.enabled_rows = {}
        end
        
        -- Сохраняем ключевые слова
        for i = 1, wbcount do
            if WB_keywords_editbox[i] then
                WB_autoresponder.keywords[i] = WB_keywords_editbox[i]:GetText()
            end
        end
        
        -- Сохраняем состояние чекбоксов
        for i = 1, wbcount do
            if WB_autorespond_checkbox[i] then
                WB_autoresponder.enabled_rows[i] = WB_autorespond_checkbox[i]:GetChecked()
            end
        end
    end
    WB_UpdateCategoryList()

    WB_ApplyCategoryColors()
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Настройки сохранены", 0.0, 1.0, 0.0)
end

-- Функции кнопок интерфейса
function WB_optionsbtn()
    if WBOptionsFrame:IsVisible() then
        WBOptionsFrame:Hide()
    else
        WBOptionsFrame:Show()
    end
end

function WB_newbtn()
    wbcount = wbcount + 1
    WB_buttonbox[wbcount] = "Btn" .. wbcount
    WB_playerbox[wbcount] = ""
    WB_messagebox[wbcount] = ""
    WB_categories[wbcount] = "Общение"
    WB_usage_stats[wbcount] = 0
    WB_UpdateCategoryList()
    WB_ApplyCategoryColors()
    WB_rebuild_interface()
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Добавлена новая кнопка", 0.0, 1.0, 0.0)
end

function WB_delbtn()
    WB_delmode = not WB_delmode
    local status = WB_delmode and "включен" or "отключен"
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Режим удаления " .. status, 1.0, 1.0, 0.0)
    wbinterface_make_delete_buttons()
    WBInterfaceFrame_Resize(wbcount)
end

-- Обработка переменных в сообщениях
function WB_ProcessVariables(message, target_player)
    local processed = message
    local player_name = UnitName("player")
    local zone_name = GetZoneText()
    local current_time = date("%H:%M")
    local guild_name = GetGuildInfo("player") or "Без гильдии"
    
    -- Замена переменных
    processed = string.gsub(processed, "%%player%%", target_player or "")
    processed = string.gsub(processed, "%%myname%%", player_name or "")
    processed = string.gsub(processed, "%%time%%", current_time)
    processed = string.gsub(processed, "%%zone%%", zone_name or "")
    processed = string.gsub(processed, "%%guild%%", guild_name)
    processed = string.gsub(processed, "%%level%%", tostring(UnitLevel("player")))
    processed = string.gsub(processed, "%%class%%", UnitClass("player") or "")
    
    return processed
end

-- Улучшенная функция отправки сообщения
function WBClickButton(id)
    id = id - 9 -- исправлен индекс
    
    local player, text = WB_playerbox[id], WB_messagebox[id]
    
    if (string.len(player or "") > 1) then
        -- Обработка переменных
        local processed_text = WB_ProcessVariables(text, player)
        
        -- Отправка сообщения
        SendChatMessage(processed_text, "WHISPER", nil, player);
        
        -- Обновление статистики
        WB_usage_stats[id] = (WB_usage_stats[id] or 0) + 1
        
        -- Добавление в историю
        WB_AddToHistory(player, processed_text)
        
        -- Уведомление
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:Отправлено [" .. player .. "]: " .. processed_text, 0.8, 0.8, 1.0)
    end
end

-- История сообщений
function WB_AddToHistory(player, message)
    local history_entry = {
        player = player,
        message = message,
        time = date("%H:%M:%S"),
        date = date("%d.%m.%Y")
    }
    
    table.insert(WB_message_history, 1, history_entry)
    
    -- Ограничиваем историю 50 записями (исправлено для 1.12.1)
    local history_count = 0
    for _ in pairs(WB_message_history) do
        history_count = history_count + 1
    end
    
    if history_count > 50 then
        table.remove(WB_message_history, 51)
    end
end

-- Автоответчик
function WB_HandleIncomingWhisper(message, sender)

    for _, ignored in pairs(WB_autoresponder.ignore_list) do
        if string.lower(sender) == string.lower(ignored) then
            return
        end
    end

    local message_lower = string.lower(message)

    for i = 1, wbcount do
        if WB_autoresponder.enabled_rows[i] then
            local keyword_str = WB_autoresponder.keywords[i] or ""
            local keywords = WB_SplitString(keyword_str, ",")
            for _, keyword in pairs(keywords) do
                keyword = string.gsub(keyword, "^%s*(.-)%s*$", "%1")
                if string.find(message_lower, string.lower(keyword)) then
                    local response = WB_ProcessVariables(WB_messagebox[i], sender)
                    local delay = math.random(2, 5)
                    WB_ScheduleMessage(sender, response, delay)
                    return
                end
            end
        end
    end
end


-- Запланированная отправка сообщения
function WB_ScheduleMessage(player, message, delay)
    local start_time = GetTime()
    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function()
        if GetTime() - start_time >= delay then
            SendChatMessage(message, "WHISPER", nil, player)
            DEFAULT_CHAT_FRAME:AddMessage("[WB]:Автоответ [" .. player .. "]: " .. message, 1.0, 1.0, 0.0)
            this:SetScript("OnUpdate", nil)
        end
    end)
end

-- Логирование исходящих сообщений
function WB_LogOutgoingMessage(message, player)
    WB_AddToHistory(player, message)
end

-- Вспомогательная функция разделения строки
function WB_SplitString(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

-- Создание dropdown для категорий (упрощено для 1.12.1)
function WB_CreateCategoryDropdown()
    -- В 1.12.1 dropdown более сложен, упростим пока
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Категории доступны через правый клик по полю категории", 1.0, 1.0, 0.0)
end

-- Фильтрация по категориям
function WB_FilterByCategory()
    for i = 1, wbcount do
        local button_index = i + 9
        if WB_button[button_index] then
            if WB_current_category == "Все" or WB_categories[i] == WB_current_category then
                WB_button[button_index]:Show()
            else
                WB_button[button_index]:Hide()
            end
        end
    end
end

-- Применение цветов категорий к кнопкам
function WB_ApplyCategoryColors()
    for i = 1, wbcount do
        local button_index = i + 9
        if WB_button[button_index] and WB_categories[i] then
            local color = WB_category_colors[WB_categories[i]] or {1.0, 1.0, 1.0}
            -- Применяем цвет к тексту кнопки
            if WB_button[button_index]:GetFontString() then
                WB_button[button_index]:GetFontString():SetTextColor(color[1], color[2], color[3])
            end
        end
    end
end

-- Экспорт настроек (упрощенная версия для безопасности)
function WB_ExportSettings()
    local export_lines = {}
    table.insert(export_lines, "-- WhisperBind Export --")
    table.insert(export_lines, "wbcount=" .. wbcount)
    
    for i = 1, wbcount do
        local btn = WB_buttonbox[i] or ""
        local player = WB_playerbox[i] or ""
        local msg = WB_messagebox[i] or ""
        local cat = WB_categories[i] or "Общение"
        local stats = WB_usage_stats[i] or 0
        
        table.insert(export_lines, string.format("WB[%d]=\"%s\"||\"%s\"||\"%s\"||\"%s\"||%d", 
            i, btn, player, msg, cat, stats))
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:=== ЭКСПОРТ НАСТРОЕК ===", 0.0, 1.0, 0.0)
    for _, line in ipairs(export_lines) do
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:" .. line, 1.0, 1.0, 0.0)
    end
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:=== КОНЕЦ ЭКСПОРТА ===", 0.0, 1.0, 0.0)
end

-- Импорт настроек (безопасная версия)
function WB_ImportSettings(import_string)
    -- Простой парсер для безопасности
    if string.find(import_string, "wbcount=") then
        local count = string.match(import_string, "wbcount=(%d+)")
        if count then
            wbcount = tonumber(count)
            DEFAULT_CHAT_FRAME:AddMessage("[WB]:Импорт: установлено " .. wbcount .. " кнопок", 0.0, 1.0, 0.0)
            WB_rebuild_interface()
            return true
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Ошибка импорта: неверный формат", 1.0, 0.0, 0.0)
    return false
end

-- Показать статистику использования
function WB_ShowStats()
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:=== Статистика использования ===", 1.0, 1.0, 0.0)
    for i = 1, wbcount do
        local usage = WB_usage_stats[i] or 0
        local button_name = WB_buttonbox[i] or ("Кнопка " .. i)
        local category = WB_categories[i] or "Без категории"
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:" .. button_name .. " [" .. category .. "]: " .. usage .. " раз", 0.8, 0.8, 1.0)
    end
end

-- Показать историю сообщений
function WB_ShowHistory()
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:=== История сообщений (последние 10) ===", 1.0, 1.0, 0.0)
    local count = 0
    for i, entry in ipairs(WB_message_history) do
        if count >= 10 then break end
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:[" .. entry.time .. "] " .. entry.player .. ": " .. entry.message, 0.8, 1.0, 0.8)
        count = count + 1
    end
end

-- Slash команды
SLASH_WBSTATS1 = "/wbstats"
SlashCmdList["WBSTATS"] = WB_ShowStats

SLASH_WBHISTORY1 = "/wbhistory"
SlashCmdList["WBHISTORY"] = WB_ShowHistory

SLASH_WBEXPORT1 = "/wbexport"
SlashCmdList["WBEXPORT"] = WB_ExportSettings

SLASH_WBAUTO1 = "/wbauto"
SlashCmdList["WBAUTO"] = function()
    WB_autoresponder.enabled = not WB_autoresponder.enabled
    local status = WB_autoresponder.enabled and "включен" or "отключен"
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Автоответчик " .. status, 1.0, 1.0, 0.0)
end





-- Добавьте эти функции в whisperbind.lua

-- Переключение категории фильтра
-- Switch category filter
function WB_SetCategoryFilter(category)
    WB_current_category = category or "All"
    WB_FilterByCategory()
    WB_UpdateCategoryButton()
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Category filter: " .. WB_current_category, 0.0, 1.0, 1.0)
end

-- Обновление текста кнопки категории
function WB_UpdateCategoryButton()
    if WB_category_filter_button then
        WB_category_filter_button:SetText("Cat: " .. WB_current_category)
        -- Apply category color to button
        local color = WB_category_colors[WB_current_category] or {1.0, 1.0, 1.0}
        if WB_category_filter_button:GetFontString() then
            WB_category_filter_button:GetFontString():SetTextColor(color[1], color[2], color[3])
        end
    end
end

-- Cycle through categories
function WB_CycleCategoryFilter()
    local current_index = 1
    for i, cat in ipairs(WB_category_list) do
        if cat == WB_current_category then
            current_index = i
            break
        end
    end
    
    local next_index = current_index + 1
    if next_index > table.getn(WB_category_list) then
        next_index = 1
    end
    
    WB_SetCategoryFilter(WB_category_list[next_index])
end

-- Улучшенная функция фильтрации
function WB_FilterByCategory()
    local visible_count = 0
    for i = 1, wbcount do
        local button_index = i + 9 -- main buttons start from index 10
        if WB_button[button_index] then
            local should_show = (WB_current_category == "All" or WB_categories[i] == WB_current_category)
            if should_show then
                WB_button[button_index]:Show()
                -- Reposition visible buttons
                local start_y = 54
                local row_height = 23
                WB_button[button_index]:SetPoint("TOP", 0, -(start_y + visible_count * row_height))
                visible_count = visible_count + 1
            else
                WB_button[button_index]:Hide()
            end
        end
    end
    
    -- Update main window size for visible buttons count
    local display_count = math.max(visible_count, 1) -- minimum 1 for correct display
    WBInterfaceFrame:SetHeight(display_count * 23 + 60)
    
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Showing buttons: " .. visible_count .. "/" .. wbcount, 0.8, 0.8, 0.8)
end

WB_category_filter_button = nil


-- Create category filter button
function WB_CreateCategoryFilterButton()
    if not WB_category_filter_button then
        -- Create category filter button
        WB_category_filter_button = CreateFrame("Button", "WBCategoryFilterButton", WBInterfaceFrame, "WBinterfacebuttonTemplate")
        WB_category_filter_button:SetPoint("TOP", 0, -6) -- below Options button
        WB_category_filter_button:SetScript("OnClick", function()
            if arg1 == "LeftButton" then
                WB_CycleCategoryFilter()
            elseif arg1 == "RightButton" then
                WB_ShowCategoryMenu()
            end
        end)
        WB_category_filter_button:SetText("Cat: All")
        WB_category_filter_button:SetWidth(60)
        WB_category_filter_button:Show()
        
        -- Register right clicks
        WB_category_filter_button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    end
    WB_UpdateCategoryButton()
end

-- Улучшенное меню выбора категории
function WB_ShowCategoryMenu()
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:=== Category Filter Selection ===", 1.0, 1.0, 0.0)
    for i, category in ipairs(WB_category_list) do
        local marker = (category == WB_current_category) and " [CURRENT]" or ""
        local color = WB_category_colors[category] or {1.0, 1.0, 1.0}
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:" .. i .. ". " .. category .. marker, color[1], color[2], color[3])
    end
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Commands:", 0.8, 0.8, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:/wb filter [name] - set filter", 0.8, 0.8, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Left click - next category", 0.8, 0.8, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Right click - this menu", 0.8, 0.8, 1.0)
end

-- Slash команда для фильтрации
WB_category_list = {"All", "Trade", "Guild", "Raid", "PvP", "Social"}
WB_category_colors = {
    ["All"] = {1.0, 1.0, 1.0},
    ["Trade"] = {1.0, 0.8, 0.0},
    ["Guild"] = {0.0, 1.0, 0.0},
    ["Raid"] = {1.0, 0.0, 0.0},
    ["PvP"] = {0.8, 0.0, 1.0},
    ["Social"] = {0.0, 0.8, 1.0}
}

-- Slash command for filtering
SLASH_WBFILTER1 = "/wbfilter"
SlashCmdList["WBFILTER"] = function(msg)
    if msg and string.len(msg) > 0 then
        local category = msg
        -- Check if category exists
        local found = false
        for _, cat in ipairs(WB_category_list) do
            if string.lower(cat) == string.lower(category) then
                WB_SetCategoryFilter(cat)
                found = true
                break
            end
        end
        if not found then
            DEFAULT_CHAT_FRAME:AddMessage("[WB]:Category not found: " .. category, 1.0, 0.0, 0.0)
            WB_ShowCategoryMenu()
        end
    else
        WB_CycleCategoryFilter()
    end
end

-- Update WB_InitializeNewFeatures function to use English categories
function WB_InitializeNewFeatures()
    -- Initialize categories
    if not WB_categories[1] then
        for i = 1, wbcount do
            WB_categories[i] = "Social"
            WB_icons[i] = ""
            WB_usage_stats[i] = 0
        end
    end
    
    -- Initialize autoresponder
    if not WB_autoresponder.responses[1] then
        WB_autoresponder.responses[1] = "Thanks for your message! Will reply later."
        WB_autoresponder.keywords[1] = "hello,hi,greetings"
    end
	-- Инициализация включённых строк автоответа
	if not WB_autoresponder.keywords then
		WB_autoresponder.keywords = {}
	end
	if not WB_autoresponder.enabled_rows then
		WB_autoresponder.enabled_rows = {}
	end

	for i = 1, wbcount do
		if WB_autoresponder.enabled_rows[i] == nil then
			WB_autoresponder.enabled_rows[i] = false
		end
	end

end

-- Update default category in WB_newbtn function
function WB_newbtn()
    wbcount = wbcount + 1
    WB_buttonbox[wbcount] = "Btn" .. wbcount
    WB_playerbox[wbcount] = ""
    WB_messagebox[wbcount] = ""
    WB_categories[wbcount] = "Social"
    WB_usage_stats[wbcount] = 0
    WB_rebuild_interface()
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:New button added", 0.0, 1.0, 0.0)
end

-- Add to slash command help
-- Update the SlashCmdList["WBCAT"] function to include filter command and English help:

SLASH_WBCAT1 = "/wbcat"
SLASH_WBCAT2 = "/wb"
SlashCmdList["WBCAT"] = function(msg)
    local args = {}
    for word in string.gfind(msg, "%S+") do
        table.insert(args, word)
    end
    
    if args[1] == "filter" and args[2] then
        local category = args[2]
        local found = false
        for _, cat in ipairs(WB_category_list) do
            if string.lower(cat) == string.lower(category) then
                WB_SetCategoryFilter(cat)
                found = true
                break
            end
        end
        if not found then
            DEFAULT_CHAT_FRAME:AddMessage("[WB]:Category not found: " .. category, 1.0, 0.0, 0.0)
        end
        return
    elseif args[1] == "cat" and args[2] and args[3] then
        local row = tonumber(args[2])
        local category = args[3]
        if row and row <= wbcount and WB_categories then
            WB_categories[row] = category
            if WB_category_editbox[row] then
                WB_category_editbox[row]:SetText(category)
            end
            WB_ApplyCategoryColors()
            DEFAULT_CHAT_FRAME:AddMessage("[WB]:Category for row " .. row .. " set to: " .. category, 0.0, 1.0, 0.0)
        end
    elseif args[1] == "import" and args[2] then
        local import_string = string.sub(msg, 8) -- remove "import "
        WB_ImportSettings(import_string)
    else
        DEFAULT_CHAT_FRAME:AddMessage("WhisperBind Commands:", 1.0, 1.0, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("/wb cat [number] [category] - set category", 0.8, 0.8, 1.0)
        DEFAULT_CHAT_FRAME:AddMessage("/wb filter [category] - filter by category", 0.8, 0.8, 1.0)
        DEFAULT_CHAT_FRAME:AddMessage("/wb import [string] - import settings", 0.8, 0.8, 1.0)
    end
end