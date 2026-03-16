local LuaSettings  = require("luasettings")
local UIManager    = require("ui/uimanager")
local ConfirmBox   = require("ui/widget/confirmbox")
local InputDialog  = require("ui/widget/inputdialog")
local Menu         = require("ui/widget/menu")
local InfoMessage  = require("ui/widget/infomessage")
local DataStorage  = require("datastorage")
local _            = require("gettext")
local Screen       = require("device").screen

local SETTINGS_FILE = DataStorage:getSettingsDir() .. "/exclude_folders.lua"

local function loadSettings()
    local s = LuaSettings:open(SETTINGS_FILE)
    return {
        history          = s:readSetting("history",          {}),
        statistics       = s:readSetting("statistics",       {}),
        history_files    = s:readSetting("history_files",    {}),
        statistics_files = s:readSetting("statistics_files", {}),
        _s = s,
    }
end

local function saveSettings(cfg)
    cfg._s:saveSetting("history",          cfg.history)
    cfg._s:saveSetting("statistics",       cfg.statistics)
    cfg._s:saveSetting("history_files",    cfg.history_files)
    cfg._s:saveSetting("statistics_files", cfg.statistics_files)
    cfg._s:flush()
end

local function normalizePath(path)
    return (path or ""):gsub("//+", "/"):gsub("/$", "")
end

local function isExcludedBy(filepath, folders)
    if not filepath or filepath == "" then return false end
    local fp = normalizePath(filepath)
    for _, folder in ipairs(folders) do
        local nf = normalizePath(folder)
        if nf:sub(1, 1) == "/" then
            if fp == nf or fp:sub(1, #nf + 1) == nf .. "/" then
                return true
            end
        else
            if fp:find(nf, 1, true) then
                return true
            end
        end
    end
    return false
end

local function isExcludedFile(filepath, files)
    if not filepath or filepath == "" then return false end
    local fp = normalizePath(filepath)
    for _, f in ipairs(files) do
        if fp == normalizePath(f) then return true end
    end
    return false
end

local function addToList(list, entry)
    for _, v in ipairs(list) do
        if v == entry then return false end
    end
    table.insert(list, entry)
    return true
end

local function isDirectMatch(filepath, list)
    local fp = normalizePath(filepath)
    for _, v in ipairs(list) do
        if fp == normalizePath(v) then return true end
    end
    return false
end

local ok_rh, ReadHistory = pcall(require, "readhistory")
if ok_rh and ReadHistory then
    local logger = require("logger")

    local orig_addItem = ReadHistory.addItem
    ReadHistory.addItem = function(self, file, ts, no_flush)
        local cfg = loadSettings()
        if isExcludedBy(file, cfg.history) or isExcludedFile(file, cfg.history_files) then
            logger.dbg("[exclude-folders] skipping history entry:", file)
            return
        end
        return orig_addItem(self, file, ts, no_flush)
    end

    local orig_updateLastBookTime = ReadHistory.updateLastBookTime
    ReadHistory.updateLastBookTime = function(self, no_flush)
        if not self.hist or not self.hist[1] then
            logger.dbg("[exclude-folders] updateLastBookTime: hist[1] is nil, skipping")
            return
        end
        return orig_updateLastBookTime(self, no_flush)
    end

    local orig_reload = ReadHistory.reload
    ReadHistory.reload = function(self, force_read)
        orig_reload(self, force_read)
        local cfg = loadSettings()
        local filtered = {}
        for _, item in ipairs(self.hist) do
            if not isExcludedBy(item.file, cfg.history)
            and not isExcludedFile(item.file, cfg.history_files) then
                table.insert(filtered, item)
            end
        end
        if #filtered ~= #self.hist then
            self.hist = filtered
        end
    end

    do
        local cfg = loadSettings()
        local filtered, removed = {}, 0
        for _, item in ipairs(ReadHistory.hist) do
            if not isExcludedBy(item.file, cfg.history)
            and not isExcludedFile(item.file, cfg.history_files) then
                table.insert(filtered, item)
            else
                removed = removed + 1
            end
        end
        if removed > 0 then
            ReadHistory.hist = filtered
        end
    end
end

local ok_dr, DocumentRegistry = pcall(require, "document/documentregistry")
if ok_dr and DocumentRegistry then
    local orig_openDocument = DocumentRegistry.openDocument
    DocumentRegistry.openDocument = function(self, file, provider)
        local doc = orig_openDocument(self, file, provider)
        local cfg = loadSettings()
        if doc and (isExcludedBy(file, cfg.statistics) or isExcludedFile(file, cfg.statistics_files)) then
            doc.is_pic = true
        end
        return doc
    end
end

local function showExcludeMenu(active_tab, menu)
    active_tab = active_tab or "history"

    local TAB = {
        history    = { label = _("Excluded from History"),    tab = _("History"),    folder_key = "history",    file_key = "history_files"    },
        statistics = { label = _("Excluded from Statistics"), tab = _("Statistics"), folder_key = "statistics", file_key = "statistics_files" },
    }
    local tab_order = { "history", "statistics" }

    local function buildItems()
        local t          = TAB[active_tab]
        local folder_key = t.folder_key
        local file_key   = t.file_key
        local cfg        = loadSettings()
        local folders    = cfg[folder_key]
        local files      = cfg[file_key]
        local items      = {}

        local tab_parts = {}
        for _, key in ipairs(tab_order) do
            local marker = (key == active_tab) and "● " or "○ "
            tab_parts[#tab_parts + 1] = marker .. TAB[key].tab
        end
        items[#items + 1] = {
            text  = table.concat(tab_parts, "     "),
            callback = function()
                active_tab = (active_tab == "history") and "statistics" or "history"
                local new_t = TAB[active_tab]
                menu:switchItemTable(new_t.label, buildItems())
            end,
        }
        items[#items + 1] = {
            text     = "",
            dim      = true,
            callback = function() end,
        }

        for i, path in ipairs(folders) do
            items[#items + 1] = {
                text = "▸ " .. path,
                callback = function()
                    UIManager:show(ConfirmBox:new{
                        text        = _("Remove from exclusion list?") .. "\n\n" .. path,
                        ok_text     = _("Remove"),
                        ok_callback = function()
                            local c = loadSettings()
                            table.remove(c[folder_key], i)
                            saveSettings(c)
                            menu:switchItemTable(t.label, buildItems())
                        end,
                    })
                end,
            }
        end

        for i, path in ipairs(files) do
            items[#items + 1] = {
                text = "" .. path,
                callback = function()
                    UIManager:show(ConfirmBox:new{
                        text        = _("Remove from exclusion list?") .. "\n\n" .. path,
                        ok_text     = _("Remove"),
                        ok_callback = function()
                            local c = loadSettings()
                            table.remove(c[file_key], i)
                            saveSettings(c)
                            menu:switchItemTable(t.label, buildItems())
                        end,
                    })
                end,
            }
        end

        if #folders == 0 and #files == 0 then
            items[#items + 1] = {
                text     = _("(nothing excluded yet)"),
                dim      = true,
                callback = function() end,
            }
        end

        items[#items + 1] = {
            text = _("＋ Add folder path…"),
            callback = function()
                local input
                input = InputDialog:new{
                    title       = _("Exclude folder"),
                    description = _("Any path fragment will match — e.g. 'Comics' excludes all folders and files containing that name."),
                    input_hint  = _("/path/to/folder"),
                    buttons = {{
                        { text = _("Cancel"), callback = function() UIManager:close(input) end },
                        {
                            text             = _("Add"),
                            is_enter_default = true,
                            callback = function()
                                local path = input:getInputText()
                                    :gsub("//+", "/"):gsub("/$", "")
                                UIManager:close(input)
                                if path ~= "" then
                                    local c = loadSettings()
                                    if addToList(c[folder_key], path) then
                                        saveSettings(c)
                                    else
                                        UIManager:show(InfoMessage:new{ text = _("Already in the list.") })
                                    end
                                end
                                menu:switchItemTable(t.label, buildItems())
                            end,
                        },
                    }},
                }
                UIManager:show(input)
                input:onShowKeyboard()
            end,
        }

        return items
    end

    local title = TAB[active_tab].label
    if menu then
        menu:switchItemTable(title, buildItems())
    else
        menu = Menu:new{
            title         = title,
            item_table    = buildItems(),
            is_borderless = true,
            is_popout     = false,
            width         = Screen:getWidth(),
            height        = Screen:getHeight(),
            onMenuSelect  = function(_, item) item.callback() end,
            onMenuHold    = function() end,
        }
        UIManager:show(menu)
    end
end

UIManager:scheduleIn(0, function()
    local ok_fm, FileManager = pcall(require, "apps/filemanager/filemanager")
    if not ok_fm or not FileManager then return end

    FileManager:addFileDialogButtons("exclude_folders", function(file, is_file)
        local cfg = loadSettings()

        local hist_key = is_file and "history_files"    or "history"
        local stat_key = is_file and "statistics_files" or "statistics"

        local in_history    = is_file and isExcludedFile(file, cfg.history_files)    or isExcludedBy(file, cfg.history)
        local in_statistics = is_file and isExcludedFile(file, cfg.statistics_files) or isExcludedBy(file, cfg.statistics)

        local direct_history    = is_file and isExcludedFile(file, cfg.history_files)    or isDirectMatch(file, cfg.history)
        local direct_statistics = is_file and isExcludedFile(file, cfg.statistics_files) or isDirectMatch(file, cfg.statistics)

        local inh_history    = in_history    and not direct_history
        local inh_statistics = in_statistics and not direct_statistics
        local kind           = is_file and _("file") or _("folder")

        local function toggleList(list_key, is_excluded)
            local c = loadSettings()
            if is_excluded then
                for i, v in ipairs(c[list_key]) do
                    if normalizePath(v) == normalizePath(file) then
                        table.remove(c[list_key], i); break
                    end
                end
            else
                local entry = (not is_file and file:sub(-1) ~= "/") and (file .. "/") or file
                addToList(c[list_key], entry)
            end
            saveSettings(c)
        end

        return {
            {
                text    = in_history and _("✓ Ignored in History") or _("Ignore in History"),
                enabled = not inh_history,
                callback = function()
                    local dialog = UIManager:getTopmostVisibleWidget()
                    if dialog then UIManager:close(dialog) end
                    toggleList(hist_key, in_history)
                    if not in_history then
                        UIManager:show(InfoMessage:new{
                            text = kind .. _(" added to exclusion list. Existing entries will be removed on next History open."),
                        })
                    end
                end,
            },
            {
                text    = in_statistics and _("✓ Ignored in Statistics") or _("Ignore in Statistics"),
                enabled = not inh_statistics,
                callback = function()
                    local dialog = UIManager:getTopmostVisibleWidget()
                    if dialog then UIManager:close(dialog) end
                    toggleList(stat_key, in_statistics)
                end,
            },
        }
    end)

    local FileManagerMenu = require("apps/filemanager/filemanagermenu")

    local ok_fh, FileManagerHistory = pcall(require, "apps/filemanager/filemanagerhistory")
    if ok_fh and FileManagerHistory then
        local orig_onShowHist = FileManagerHistory.onShowHist
        FileManagerHistory.onShowHist = function(self_fh, ...)
            local ok_rh2, ReadHistory2 = pcall(require, "readhistory")
            if ok_rh2 and ReadHistory2 then
                ReadHistory2:reload(true)
            end
            return orig_onShowHist(self_fh, ...)
        end
    end

    local orig_FM_setUpdateItemTable = FileManagerMenu.setUpdateItemTable
    FileManagerMenu.setUpdateItemTable = function(self_menu)
        local order = require("ui/elements/filemanager_menu_order")
        table.insert(order.tools, "exclude_folders")
        self_menu.menu_items.exclude_folders = {
            text     = _("Exclude from History & Statistics"),
            callback = function()
                showExcludeMenu("history")
            end,
        }
        orig_FM_setUpdateItemTable(self_menu)
    end

    local ReaderMenu = require("apps/reader/modules/readermenu")

    local orig_RM_setUpdateItemTable = ReaderMenu.setUpdateItemTable
    ReaderMenu.setUpdateItemTable = function(self_menu)
        local order = require("ui/elements/reader_menu_order")
        table.insert(order.tools, "exclude_current_book")
        self_menu.menu_items.exclude_current_book = {
            text = _("Exclude this book…"),
            sub_item_table = {
                {
                    text = _("Ignore in History"),
                    checked_func = function()
                        local file = self_menu.ui and self_menu.ui.document and self_menu.ui.document.file
                        if not file then return false end
                        local cfg = loadSettings()
                        return isExcludedFile(file, cfg.history_files) or isExcludedBy(file, cfg.history)
                    end,
                    enabled_func = function()
                        local file = self_menu.ui and self_menu.ui.document and self_menu.ui.document.file
                        if not file then return false end
                        local cfg = loadSettings()
                        local in_history = isExcludedFile(file, cfg.history_files) or isExcludedBy(file, cfg.history)
                        return not (in_history and not isExcludedFile(file, cfg.history_files))
                    end,
                    keep_menu_open = true,
                    callback = function(touchmenu_instance)
                        local file = self_menu.ui and self_menu.ui.document and self_menu.ui.document.file
                        if not file then return end
                        local c = loadSettings()
                        local in_history = isExcludedFile(file, c.history_files) or isExcludedBy(file, c.history)
                        if in_history then
                            for i, v in ipairs(c.history_files) do
                                if v == file then table.remove(c.history_files, i); break end
                            end
                        else
                            addToList(c.history_files, file)
                        end
                        saveSettings(c)
                        if touchmenu_instance then touchmenu_instance:updateItems() end
                    end,
                },
                {
                    text = _("Ignore in Statistics"),
                    checked_func = function()
                        local file = self_menu.ui and self_menu.ui.document and self_menu.ui.document.file
                        if not file then return false end
                        local cfg = loadSettings()
                        return isExcludedFile(file, cfg.statistics_files) or isExcludedBy(file, cfg.statistics)
                    end,
                    enabled_func = function()
                        local file = self_menu.ui and self_menu.ui.document and self_menu.ui.document.file
                        if not file then return false end
                        local cfg = loadSettings()
                        local in_stat = isExcludedFile(file, cfg.statistics_files) or isExcludedBy(file, cfg.statistics)
                        return not (in_stat and not isExcludedFile(file, cfg.statistics_files))
                    end,
                    keep_menu_open = true,
                    callback = function(touchmenu_instance)
                        local file = self_menu.ui and self_menu.ui.document and self_menu.ui.document.file
                        if not file then return end
                        local c = loadSettings()
                        local in_stat = isExcludedFile(file, c.statistics_files) or isExcludedBy(file, c.statistics)
                        if in_stat then
                            for i, v in ipairs(c.statistics_files) do
                                if v == file then table.remove(c.statistics_files, i); break end
                            end
                        else
                            addToList(c.statistics_files, file)
                        end
                        saveSettings(c)
                        if touchmenu_instance then touchmenu_instance:updateItems() end
                        UIManager:show(InfoMessage:new{
                            text = _("Change will take effect after reopening the book."),
                        })
                    end,
                },
            },
        }
        orig_RM_setUpdateItemTable(self_menu)
    end
end)
