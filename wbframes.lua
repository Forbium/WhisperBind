-- Enhanced WBFrames v2.0 - Fixed for WoW 1.12.1
-- Исправлены размеры окна и позиционирование элементов

WB_keywords_editbox = {}
WB_autorespond_checkbox = {}


WB_button = {}
WB_editbox = {}
WB_category_editbox = {}
WB_delmode = false
WB_show_advanced = false

-- UI элементы для расширенных функций
WB_stats_button = nil
WB_history_button = nil
WB_export_button = nil
WB_autoresponder_button = nil
WB_import_button = nil

if not WB_autoresponder then
    WB_autoresponder = {
        enabled = false,
        ui_visible = false,
        keywords = {},
        enabled_rows = {}
    }
end

-- Исправленная функция изменения размера окна
function WBInterfaceFrame_Resize(count)
    -- Размер основного окна с кнопками
    WBInterfaceFrame:SetWidth(72);
    WBInterfaceFrame:SetHeight(count*23+60);
    
    -- Исправленные размеры окна настроек
    local base_width = 292 -- базовая ширина для 4 колонок
    local width = base_width
    if WB_delmode then
        width = width + 30 -- место для кнопок удаления
    end
    if WB_show_advanced then
        width = width -- небольшое дополнительное место
    end
    if WB_autoresponder and WB_autoresponder.ui_visible then
        width = width + 122
    end

    
    WBOptionsFrame:SetWidth(width);
    WBOptionsFrame:SetPoint("TOPLEFT", "WBInterfaceFrame", "TOPRIGHT",-4,0);
    
    -- высота окна - точно по содержимому
    local header_height = 60 -- заголовок + кнопки управления + заголовки колонок
    local row_height = 22 -- высота одного ряда
    local bottom_margin = 2 -- отступ снизу
    local advanced_height = WB_show_advanced and 28 or 0 -- место для расширенных кнопок
    
    local total_height = header_height + count * row_height + bottom_margin + advanced_height
    WBOptionsFrame:SetHeight(total_height);
end

-- функция переключения режима удаления
function WB_delbtn()
    WB_delmode = not WB_delmode
    local status = WB_delmode and "включен" or "отключен"
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Режим удаления " .. status, 1.0, 1.0, 0.0)
    
    -- Пересоздаем кнопки удаления
    wbinterface_make_delete_buttons()
    
    -- Изменяем размер окна с учетом кнопок удаления
    WBInterfaceFrame_Resize(wbcount)

    -- Пересоздаем поля ввода, чтобы автоответы сдвинулись
    wbinterface_make_editboxes()
end

function wbinterface_make_buttons()
    -- Очищаем старые кнопки
    for i = 1, 200 do
        if WB_button[i] then
            WB_button[i]:Hide()
            WB_button[i] = nil
        end
    end
    
    local j = 1

    -- Options button (id = 1)
    WB_button[j] = CreateFrame("Button", ("Button"..j), WBInterfaceFrame, "WBinterfacebuttonTemplate")
    WB_button[j]:SetPoint("TOP",0,-28);
    WB_button[j]:SetScript("OnClick", WB_optionsbtn);
    WB_button[j]:SetText("Options");
    j = j+1

    -- Save button (id = 2)
    WB_button[j] = CreateFrame("Button", ("Button"..j), WBOptionsFrame, "WBinterfacebuttonTemplate")
    WB_button[j]:SetPoint("TOPLEFT",6,-6);
    WB_button[j]:SetScript("OnClick", WB_savevalue);
    WB_button[j]:SetText("Save");
	WB_button[j]:SetWidth(70);
    j = j+1

    -- New button (id = 3)
    WB_button[j] = CreateFrame("Button", ("Button"..j), WBOptionsFrame, "WBinterfacebuttonTemplate")
    WB_button[j]:SetPoint("TOPLEFT",76,-6);
    WB_button[j]:SetScript("OnClick", WB_newbtn);
    WB_button[j]:SetText("New");
	WB_button[j]:SetWidth(70);
    j = j+1

    -- Del button (id = 4)
    WB_button[j] = CreateFrame("Button", ("Button"..j), WBOptionsFrame, "WBinterfacebuttonTemplate")
    WB_button[j]:SetPoint("TOPLEFT",146,-6);
    WB_button[j]:SetScript("OnClick", WB_delbtn);
    WB_button[j]:SetText("Del");
	WB_button[j]:SetWidth(70);
    j = j+1
    
    -- Advanced button (id = 5)
    WB_button[j] = CreateFrame("Button", ("Button"..j), WBOptionsFrame, "WBinterfacebuttonTemplate")
    WB_button[j]:SetPoint("TOPLEFT",216,-6);
    WB_button[j]:SetScript("OnClick", WB_advanced_toggle);
    WB_button[j]:SetText("Adv");
	WB_button[j]:SetWidth(70);
    j = j+1
    
    -- Column headers (ids 6,7,8,9) - исправлены позиции и размеры
    local headers = {"ButtonID", "Player", "Message", "Category"}
    local positions = {6, 76, 146, 216} -- исправленные позиции
    local widths = {70, 70, 70, 70} -- ширины колонок
    
    for i = 1, 4 do
        WB_button[j] = CreateFrame("Button", ("Button"..j), WBOptionsFrame, "WBinterfacebuttonTemplate")
        WB_button[j]:SetPoint("TOPLEFT", positions[i], -28);
        WB_button[j]:SetText(headers[i]);
        WB_button[j]:SetWidth(widths[i]);
        j = j+1
    end

    -- Main action buttons
    local n = wbcount
    for y = j, (j+n-1) do
        local row_height = 22
        local start_y = 54
        WB_button[y] = CreateFrame("Button", ("Button"..y), WBInterfaceFrame, "WBinterfacebuttonTemplate")
        WB_button[y]:SetPoint("TOP", 0, -(start_y + (y - j) * row_height));
        local yy = y
        WB_button[y]:SetScript("OnClick", function()
            WBClickButton(yy)
        end)
        
        -- Устанавливаем текст кнопки
        local button_text = WB_buttonbox and WB_buttonbox[y-j+1] or ("Btn" .. (y-j+1))
        WB_button[y]:SetText(button_text);
        
        -- Drag and drop functionality - исправлено для 1.12.1
        WB_button[y]:SetScript("OnMouseDown", function(arg1)
            if arg1 == "LeftButton" and IsShiftKeyDown() then
                WB_StartDrag(yy - j + 1)
            end
        end)
        
        -- Drop functionality - исправлено для 1.12.1
        WB_button[y]:SetScript("OnMouseUp", function(arg1)
            if arg1 == "LeftButton" and IsShiftKeyDown() and WB_drag_source then
                WB_DropRow(yy - j + 1)
            end
        end)
    end
    j = j+n
	-- Create category filter button
	WB_CreateCategoryFilterButton()
end

function wbinterface_make_editboxes()
    -- Очищаем старые editbox'ы
    for i = 1, 200 do
        if WB_editbox[i] then
            WB_editbox[i]:Hide()
            WB_editbox[i] = nil
        end
    end
    for i = 1, 50 do
        if WB_category_editbox[i] then
            WB_category_editbox[i]:Hide()
            WB_category_editbox[i] = nil
        end
    end

    for i = 1, 200 do
        if WB_keywords_editbox[i] then
            WB_keywords_editbox[i]:Hide()
            WB_keywords_editbox[i] = nil
        end
        if WB_autorespond_checkbox[i] then
            WB_autorespond_checkbox[i]:Hide()
            WB_autorespond_checkbox[i] = nil
        end
    end

    
    local j = 1
    local n = wbcount
    local start_y = -54 -- начальная позиция для первого ряда полей

    -- Button name editboxes
    for y = j, (j+n-1) do
        WB_editbox[y] = CreateFrame("EditBox", ("ButtonBox"..(y-j)), WBOptionsFrame, "WBeditboxTemplate")
        WB_editbox[y]:SetPoint("TOPLEFT", 13, start_y - (y-j)*22)
        WB_editbox[y]:SetAutoFocus(false)
        WB_editbox[y]:SetWidth(62)
        -- Восстанавливаем значение
        if WB_buttonbox and WB_buttonbox[y-j+1] then
            WB_editbox[y]:SetText(WB_buttonbox[y-j+1])
        end
    end
    j = j+n

    -- Player name editboxes
    for y = j, (j+n-1) do
        WB_editbox[y] = CreateFrame("EditBox", ("PlayerBox"..(y-j)), WBOptionsFrame, "WBeditboxTemplate")
        WB_editbox[y]:SetPoint("TOPLEFT", 83, start_y - (y-j)*22)
        WB_editbox[y]:SetAutoFocus(false)
        WB_editbox[y]:SetWidth(62)
        if WB_playerbox and WB_playerbox[y-j+1] then
            WB_editbox[y]:SetText(WB_playerbox[y-j+1])
        end
    end
    j = j+n

    -- Message editboxes
    for y = j, (j+n-1) do
        WB_editbox[y] = CreateFrame("EditBox", ("MessageBox"..(y-j)), WBOptionsFrame, "WBeditboxTemplate")
        WB_editbox[y]:SetPoint("TOPLEFT", 153, start_y - (y-j)*22)
        WB_editbox[y]:SetAutoFocus(false)
        WB_editbox[y]:SetWidth(62)
        if WB_messagebox and WB_messagebox[y-j+1] then
            WB_editbox[y]:SetText(WB_messagebox[y-j+1])
        end
    end
    j = j+n

    -- Category editboxes
    for y = j, (j+n-1) do
        local row_index = y-j+1  -- локальная переменная для замыкания
        WB_category_editbox[row_index] = CreateFrame("EditBox", ("CategoryBox"..(y-j)), WBOptionsFrame, "WBeditboxTemplate")
        WB_category_editbox[row_index]:SetPoint("TOPLEFT", 223, start_y - (y-j)*22)
        WB_category_editbox[row_index]:SetAutoFocus(false)
        WB_category_editbox[row_index]:SetWidth(62)
        if WB_categories and WB_categories[row_index] then
            WB_category_editbox[row_index]:SetText(WB_categories[row_index])
        end
        WB_category_editbox[row_index]:SetScript("OnMouseDown", function(self, arg1)
            if arg1 == "RightButton" then
                WB_ShowCategoryRowMenu(row_index)
            end
        end)
    end

    -- === Динамическое вычисление позиции для автоответа ===
    if WB_autoresponder and WB_autoresponder.ui_visible then
        local base_x = 223 + 62 + 5 -- X после колонки "Категория" + небольшой отступ
        if WB_delmode then
            base_x = base_x + 30 -- если есть кнопка удаления, сдвигаем еще правее
        end

        -- Добавляем заголовки для автоответа (один раз)
        if not WB_keyword_header then
            WB_keyword_header = CreateFrame("Button", "WBKeywordHeader", WBOptionsFrame, "WBinterfacebuttonTemplate")
            WB_keyword_header:SetPoint("TOPRIGHT", -43, -28)
            WB_keyword_header:SetText("Keyword")
            WB_keyword_header:SetWidth(70)
        else
            WB_keyword_header:SetPoint("TOPRIGHT", -43, -28)
            WB_keyword_header:Show()
        end
        if not WB_auto_header then
            WB_auto_header = CreateFrame("Button", "WBAutoHeader", WBOptionsFrame, "WBinterfacebuttonTemplate")
            WB_auto_header:SetPoint("TOPRIGHT", -7, -28)
            WB_auto_header:SetText("Auto")
            WB_auto_header:SetWidth(35)
        else
            WB_auto_header:SetPoint("TOPRIGHT", -7, -28)
            WB_auto_header:Show()
        end

        for i = 1, n do
            WB_keywords_editbox[i] = CreateFrame("EditBox", "WBKeywordBox"..i, WBOptionsFrame, "WBeditboxTemplate")
            WB_keywords_editbox[i]:SetPoint("TOPRIGHT", -34, start_y - (i-1)*22)
            WB_keywords_editbox[i]:SetAutoFocus(false)
            WB_keywords_editbox[i]:SetWidth(80)
            if WB_autoresponder.keywords and WB_autoresponder.keywords[i] then
                WB_keywords_editbox[i]:SetText(WB_autoresponder.keywords[i])
            end
        end

        for i = 1, n do
            WB_autorespond_checkbox[i] = CreateFrame("CheckButton", "WBCheck"..i, WBOptionsFrame, "UICheckButtonTemplate")
            WB_autorespond_checkbox[i]:SetPoint("TOPRIGHT", -3, (start_y - (i - 1) * 22) + 3)
            local checkbox = WB_autorespond_checkbox[i]
            checkbox:SetScript("OnClick", function()
                WB_autoresponder.enabled_rows[i] = checkbox:GetChecked()
            end)
            if WB_autoresponder.enabled_rows and WB_autoresponder.enabled_rows[i] ~= nil then
                checkbox:SetChecked(WB_autoresponder.enabled_rows[i])
            end
        end
    else
        -- Скрываем заголовки, если автоответчик выключен
        if WB_keyword_header then WB_keyword_header:Hide() end
        if WB_auto_header then WB_auto_header:Hide() end
    end
end

-- функция создания кнопок удаления
function wbinterface_make_delete_buttons()
    -- Очищаем старые кнопки удаления
    local del_start_index = 50 -- начинаем с индекса 50 для кнопок удаления
    for i = del_start_index, del_start_index + 49 do
        if WB_button[i] then
            WB_button[i]:Hide()
            WB_button[i] = nil
        end
    end
    
    if not WB_delmode then return end
    
    local start_y = -55 -- та же начальная позиция что и у полей ввода
    
    for i = 1, wbcount do
        local del_btn_index = del_start_index + i - 1
        
        -- Создаем кнопку удаления
        WB_button[del_btn_index] = CreateFrame("Button", ("DelButton"..i), WBOptionsFrame, "WBinterfacebuttonTemplate")
        
        -- Позиционируем кнопку удаления точно на уровне соответствующего ряда
        local del_x = 290 -- позиция справа от категории
        WB_button[del_btn_index]:SetPoint("TOPLEFT", del_x, start_y - (i-1)*22);
        WB_button[del_btn_index]:SetText("X");
        WB_button[del_btn_index]:SetWidth(20)
        WB_button[del_btn_index]:SetHeight(20)
        
        -- Сохраняем номер строки для удаления
        local row_to_delete = i
        WB_button[del_btn_index]:SetScript("OnClick", function()
            WB_delete_row(row_to_delete)
        end)
        
        WB_button[del_btn_index]:Show()
    end
end

-- Создание дополнительных UI элементов
function WB_CreateAdvancedUI()
    if not WB_show_advanced then return end
    
    -- Кнопки расширенных функций - размещаем внизу окна
    local bottom_y = 8
    
    if not WB_stats_button then
        WB_stats_button = CreateFrame("Button", "WBStatsButton", WBOptionsFrame, "WBinterfacebuttonTemplate")
        WB_stats_button:SetPoint("BOTTOMLEFT", 10, bottom_y)
        WB_stats_button:SetText("Stats")
        WB_stats_button:SetScript("OnClick", WB_ShowStats)
        WB_stats_button:SetWidth(45)
    end
    
    if not WB_history_button then
        WB_history_button = CreateFrame("Button", "WBHistoryButton", WBOptionsFrame, "WBinterfacebuttonTemplate")
        WB_history_button:SetPoint("BOTTOMLEFT", 60, bottom_y)
        WB_history_button:SetText("History")
        WB_history_button:SetScript("OnClick", WB_ShowHistory)
        WB_history_button:SetWidth(50)
    end
    
    if not WB_export_button then
        WB_export_button = CreateFrame("Button", "WBExportButton", WBOptionsFrame, "WBinterfacebuttonTemplate")
        WB_export_button:SetPoint("BOTTOMLEFT", 115, bottom_y)
        WB_export_button:SetText("Export")
        WB_export_button:SetScript("OnClick", WB_ExportSettings)
        WB_export_button:SetWidth(45)
    end
    
    if not WB_import_button then
        WB_import_button = CreateFrame("Button", "WBImportButton", WBOptionsFrame, "WBinterfacebuttonTemplate")
        WB_import_button:SetPoint("BOTTOMLEFT", 165, bottom_y)
        WB_import_button:SetText("Import")
        WB_import_button:SetScript("OnClick", WB_ShowImportDialog)
        WB_import_button:SetWidth(45)
    end
    
    if not WB_autoresponder_button then
        WB_autoresponder_button = CreateFrame("Button", "WBAutoresponderButton", WBOptionsFrame, "WBinterfacebuttonTemplate")
        WB_autoresponder_button:SetPoint("BOTTOMLEFT", 215, bottom_y)
        WB_autoresponder_button:SetText("Auto")
        WB_autoresponder_button:SetScript("OnClick", WB_ToggleAutoresponder)
        WB_autoresponder_button:SetWidth(40)
    end
	--WB_ToggleAutoresponderUI(WB_autoresponder.enabled)

    
    WB_stats_button:Show()
    WB_history_button:Show()
    WB_export_button:Show()
    WB_import_button:Show()
    WB_autoresponder_button:Show()
end

function WB_HideAdvancedUI()
    if WB_stats_button then WB_stats_button:Hide() end
    if WB_history_button then WB_history_button:Hide() end
    if WB_export_button then WB_export_button:Hide() end
    if WB_import_button then WB_import_button:Hide() end
    if WB_autoresponder_button then WB_autoresponder_button:Hide() end
    WB_autoresponder.ui_visible = false
    WB_ToggleAutoresponderUI(false)
end

-- Переключение расширенного режима
function WB_advanced_toggle()
    WB_show_advanced = not WB_show_advanced
    
    if WB_show_advanced then
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:Расширенный режим включен", 0.0, 1.0, 0.0)
        WB_CreateAdvancedUI()
    else
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:Расширенный режим отключен", 1.0, 1.0, 0.0)
        WB_HideAdvancedUI()
    end
    
    WBInterfaceFrame_Resize(wbcount)
end

-- Drag & Drop функциональность
WB_drag_source = nil

function WB_StartDrag(row_index)
    WB_drag_source = row_index
    DEFAULT_CHAT_FRAME:AddMessage("Перетаскивание строки " .. row_index .. " (Shift+Click на цель)", 1.0, 1.0, 0.0)
end

function WB_DropRow(target_index)
    if not WB_drag_source or WB_drag_source == target_index then
        WB_drag_source = nil
        return
    end
    
    -- Сохраняем данные источника
    local temp_button = WB_buttonbox[WB_drag_source]
    local temp_player = WB_playerbox[WB_drag_source]
    local temp_message = WB_messagebox[WB_drag_source]
    local temp_category = WB_categories[WB_drag_source]
    local temp_stats = WB_usage_stats[WB_drag_source]
    
    -- Перемещаем данные
    WB_buttonbox[WB_drag_source] = WB_buttonbox[target_index]
    WB_playerbox[WB_drag_source] = WB_playerbox[target_index]
    WB_messagebox[WB_drag_source] = WB_messagebox[target_index]
    WB_categories[WB_drag_source] = WB_categories[target_index]
    WB_usage_stats[WB_drag_source] = WB_usage_stats[target_index]
    
    WB_buttonbox[target_index] = temp_button
    WB_playerbox[target_index] = temp_player
    WB_messagebox[target_index] = temp_message
    WB_categories[target_index] = temp_category
    WB_usage_stats[target_index] = temp_stats
    
    -- Обновляем интерфейс
    WB_loadvalue()
    WB_ApplyCategoryColors()
    
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Строка " .. WB_drag_source .. " перемещена на позицию " .. target_index, 0.0, 1.0, 0.0)
    WB_drag_source = nil
end


-- Переключение автоответчика
function WB_ToggleAutoresponder()
    WB_autoresponder.ui_visible = not WB_autoresponder.ui_visible
    WB_ToggleAutoresponderUI(WB_autoresponder.ui_visible)
end


-- Простое меню выбора категории для 1.12.1
function WB_ShowCategoryRowMenu(row_index)
    if not row_index then
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:Ошибка: не передан номер строки для меню категории.", 1.0, 0.2, 0.2)
        return
    end
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Доступные категории: All, Trade, Guild, Raid, PvP, Social", 1.0, 1.0, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Введите название категории вручную в поле или используйте команду:", 0.8, 0.8, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:/wb cat " .. row_index .. " [category]", 0.8, 0.8, 1.0)
end

-- Диалог импорта - упрощенный для 1.12.1
function WB_ShowImportDialog()
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:=== Импорт настроек ===", 1.0, 1.0, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Используйте команду: /wb import [строка_настроек]", 0.8, 0.8, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:или скопируйте строки экспорта и выполните их как команды", 0.8, 0.8, 1.0)
end

function WB_delete_row(row_index)
    if row_index > wbcount or row_index < 1 then
        DEFAULT_CHAT_FRAME:AddMessage("[WB]:Ошибка: неверный индекс строки " .. row_index, 1.0, 0.0, 0.0)
        return
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Удаление строки " .. row_index .. " из " .. wbcount, 1.0, 1.0, 0.0)
    
    -- Смещаем все данные после удаляемой строки на одну позицию назад
    for i = row_index, wbcount - 1 do
        WB_buttonbox[i] = WB_buttonbox[i + 1]
        WB_playerbox[i] = WB_playerbox[i + 1]
        WB_messagebox[i] = WB_messagebox[i + 1]
        if WB_categories then
            WB_categories[i] = WB_categories[i + 1]
        end
        if WB_usage_stats then
            WB_usage_stats[i] = WB_usage_stats[i + 1]
        end
    end
    
    -- Очищаем последнюю строку
    WB_buttonbox[wbcount] = nil
    WB_playerbox[wbcount] = nil
    WB_messagebox[wbcount] = nil
    if WB_categories then
        WB_categories[wbcount] = nil
    end
    if WB_usage_stats then
        WB_usage_stats[wbcount] = nil
    end
    
    -- Уменьшаем счетчик
    wbcount = wbcount - 1
    
    -- Пересоздаем интерфейс
    WB_rebuild_interface()
    
    DEFAULT_CHAT_FRAME:AddMessage("[WB]:Строка удалена. Осталось строк: " .. wbcount, 0.0, 1.0, 0.0)
end

function WB_rebuild_interface()    
    -- Сначала скрываем все старые элементы
    for i = 1, 200 do
        if WB_button[i] then
            WB_button[i]:Hide()
        end
        if WB_editbox[i] then
            WB_editbox[i]:Hide()
        end
    end
    for i = 1, 50 do
        if WB_category_editbox[i] then
            WB_category_editbox[i]:Hide()
        end
    end
    -- Учитываем положение полей автоответчика
    if WB_autoresponder.ui_visible then
        WB_ToggleAutoresponderUI(true)
        wbinterface_make_editboxes()
    end

    
    -- Пересоздаем интерфейс
    WBInterfaceFrame_Resize(wbcount)
    wbinterface_make_buttons();
    WB_ApplyCategoryColors()
    wbinterface_make_editboxes();
    wbinterface_make_delete_buttons();
    
    -- Восстанавливаем расширенный режим если был включен
    if WB_show_advanced then
        WB_CreateAdvancedUI()
    end
    
    -- Загружаем значения
    WB_loadvalue();
    if WB_ApplyCategoryColors then
        WB_ApplyCategoryColors();
    end
end

-- Применение размеров кнопок (новая функция)
function WB_ApplyButtonSizes()
    local button_size = WB_button_size or 22 -- размер по умолчанию
    
    for i = 10, 9 + wbcount do -- основные кнопки - исправлен индекс
        if WB_button[i] then
            WB_button[i]:SetHeight(button_size)
            -- Перепозиционируем кнопки с учетом нового размера
            local start_y = 54
            WB_button[i]:SetPoint("TOP", 0, -(start_y + (i - 10) * (button_size + 1)))
        end
    end
end

-- Дополнительные slash команды для управления категориями
SLASH_WBCAT1 = "/wbcat"
SLASH_WBCAT2 = "/wb"
SlashCmdList["WBCAT"] = function(msg)
    local args = {}
    for word in string.gfind(msg, "%S+") do
        table.insert(args, word)
    end
    
    if args[1] == "cat" and args[2] and args[3] then
        local row = tonumber(args[2])
        local category = args[3]
        if row and row <= wbcount and WB_categories then
            WB_categories[row] = category
            if WB_category_editbox[row] then
                WB_category_editbox[row]:SetText(category)
            end
            WB_ApplyCategoryColors()
            DEFAULT_CHAT_FRAME:AddMessage("[WB]:Категория для строки " .. row .. " установлена: " .. category, 0.0, 1.0, 0.0)
        end
    elseif args[1] == "import" and args[2] then
        -- Простой импорт для команды
        local import_string = string.sub(msg, 8) -- убираем "import "
        WB_ImportSettings(import_string)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Команды WhisperBind:", 1.0, 1.0, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("/wb cat [номер] [категория] - установить категорию", 0.8, 0.8, 1.0)
        DEFAULT_CHAT_FRAME:AddMessage("/wb import [строка] - импорт настроек", 0.8, 0.8, 1.0)
    end
end


function WB_UpdateCategoryList()
    local base_categories = {"All", "Trade", "Guild", "Raid", "PvP", "Social"}
    local unique = {}
    -- Всегда добавляем основные категории
    for _, cat in ipairs(base_categories) do
        unique[cat] = true
    end
    -- Добавляем пользовательские категории из WB_categories
    for _, cat in ipairs(WB_categories) do
        if cat and cat ~= "" then unique[cat] = true end
    end
    WB_category_list = {}
    for k in pairs(unique) do table.insert(WB_category_list, k) end
end

function WB_ToggleAutoresponderUI(show)
    -- Сохраняем значения
    local saved_editbox = {}
    local saved_category = {}
    local saved_keywords = {}
    local saved_autorespond = {}

    -- Заменяем #WB_editbox на getn(WB_editbox) или используем фиксированный диапазон
    for i = 1, getn(WB_editbox) do
        if WB_editbox[i] and WB_editbox[i]:IsShown() then
            saved_editbox[i] = WB_editbox[i]:GetText()
        end
    end

    for i = 1, getn(WB_category_editbox) do
        if WB_category_editbox[i] and WB_category_editbox[i]:IsShown() then
            saved_category[i] = WB_category_editbox[i]:GetText()
        end
    end

    for i = 1, getn(WB_keywords_editbox) do
        if WB_keywords_editbox[i] and WB_keywords_editbox[i]:IsShown() then
            saved_keywords[i] = WB_keywords_editbox[i]:GetText()
        end
    end

    for i = 1, getn(WB_autorespond_checkbox) do
        if WB_autorespond_checkbox[i] then
            saved_autorespond[i] = WB_autorespond_checkbox[i]:GetChecked()
        end
    end

    -- Пересоздаём поля (с учётом нового состояния `show`)
    wbinterface_make_editboxes()

    -- Восстанавливаем значения
    for i = 1, getn(saved_editbox) do
        if WB_editbox[i] and saved_editbox[i] then
            WB_editbox[i]:SetText(saved_editbox[i])
        end
    end

    for i = 1, getn(saved_category) do
        if WB_category_editbox[i] and saved_category[i] then
            WB_category_editbox[i]:SetText(saved_category[i])
        end
    end

    for i = 1, getn(saved_keywords) do
        if WB_keywords_editbox[i] and saved_keywords[i] then
            WB_keywords_editbox[i]:SetText(saved_keywords[i])
        end
    end

    for i = 1, getn(saved_autorespond) do
        if WB_autorespond_checkbox[i] ~= nil then
            WB_autorespond_checkbox[i]:SetChecked(saved_autorespond[i])
            WB_autoresponder.enabled_rows[i] = saved_autorespond[i]
        end
    end

    -- Обновляем ширину окна
    local base_width = 292
    local autoresponder_extra = 122
    local new_width = base_width
    if WB_delmode then new_width = new_width + 30 end
    if WB_show_advanced then new_width = new_width + 0 end
    if show then new_width = new_width + autoresponder_extra end
    WBOptionsFrame:SetWidth(new_width)
end
