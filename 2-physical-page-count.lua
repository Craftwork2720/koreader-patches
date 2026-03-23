local CheckButton   = require("ui/widget/checkbutton")
local Event         = require("ui/event")
local InputDialog   = require("ui/widget/inputdialog")
local UIManager     = require("ui/uimanager")
local ReaderPageMap = require("apps/reader/modules/readerpagemap")
local _             = require("gettext")

local DEFAULT_CPP = ReaderPageMap.chars_per_synthetic_page_default or 1500

local function getPhysicalPages(ui)
    return ui.doc_settings:readSetting("pagemap_physical_pages")
end

local function setPhysicalPages(ui, pages)
    if pages then
        ui.doc_settings:saveSetting("pagemap_physical_pages", pages)
    else
        ui.doc_settings:delSetting("pagemap_physical_pages")
    end
end

local function rebuildMap(self, physical_pages, update_ui)
    if not physical_pages or physical_pages <= 0 then
        self.ui.doc_settings:delSetting("pagemap_chars_per_synthetic_page")
        self.chars_per_synthetic_page = nil
        return
    end

    local cpp, result_pages
    if self.ui.document:hasPageMap() then
        cpp = self.ui.document:getSyntheticPageMapCharsPerPage()
        if cpp <= 0 then cpp = self.chars_per_synthetic_page or DEFAULT_CPP end
        result_pages = #self.ui.document:getPageMap()
    else
        cpp = DEFAULT_CPP
        self.ui.document:buildSyntheticPageMap(cpp)
        result_pages = #self.ui.document:getPageMap()
    end

    if result_pages <= 0 then result_pages = physical_pages end

    local best_cpp, best_diff = cpp, math.abs(result_pages - physical_pages)
    local seen_cpp = {}
    for _ = 1, 8 do
        if result_pages == physical_pages then break end
        local new_cpp = math.max(1, math.floor(cpp * result_pages / physical_pages))
        if new_cpp == cpp or seen_cpp[new_cpp] then break end
        seen_cpp[new_cpp] = true
        cpp = new_cpp
        self.ui.document:buildSyntheticPageMap(cpp)
        result_pages = #self.ui.document:getPageMap()
        local diff = math.abs(result_pages - physical_pages)
        if diff < best_diff then
            best_diff = diff
            best_cpp = cpp
        end
    end
    cpp = best_cpp
    if self.ui.document:getSyntheticPageMapCharsPerPage() ~= cpp then
        self.ui.document:buildSyntheticPageMap(cpp)
    end

    if not self.has_pagemap then
        self.has_pagemap = true
        self:resetLayout()
        self.view:registerViewModule("pagemap", self)
    end
    self.chars_per_synthetic_page = cpp
    self.page_labels_cache = nil
    self.use_page_labels = true
    self.ui.doc_settings:saveSetting("pagemap_use_page_labels", true)
    self.ui.doc_settings:saveSetting("pagemap_chars_per_synthetic_page", cpp)
    self.ui.doc_settings:saveSetting("pagemap_doc_pages", select(3, self:getCurrentPageLabel()))

    if update_ui then
        self:updateVisibleLabels()
        UIManager:setDirty(self.view.dialog, "partial")
        UIManager:broadcastEvent(Event:new("UsePageLabelsUpdated"))
    end
end

local function showDialog(pagemap)
    local ui = pagemap.ui
    local dialog
    dialog = InputDialog:new{
        title       = _("Physical page count"),
        input       = tostring(getPhysicalPages(ui) or ""),
        input_type  = "number",
        description = _("Enter the number of pages in the physical book.\nKOReader will calculate characters per page automatically."),
        buttons = {
            {
                {
                    text = _("Cancel"),
                    id   = "close",
                    callback = function()
                        UIManager:close(dialog)
                    end,
                },
                {
                    text             = _("Set"),
                    is_enter_default = true,
                    callback         = function()
                        local val = tonumber(dialog:getInputText())
                        if val and val > 0 then
                            setPhysicalPages(ui, val)
                            UIManager:close(dialog)
                            UIManager:nextTick(function()
                                rebuildMap(pagemap, val, true)
                            end)
                        end
                    end,
                },
                {
                    text     = _("Clear"),
                    callback = function()
                        setPhysicalPages(ui, nil)
                        UIManager:close(dialog)
                        UIManager:nextTick(function()
                            pagemap.use_page_labels = false
                            pagemap.page_labels_cache = nil
                            pagemap.chars_per_synthetic_page = nil
                            pagemap.ui.doc_settings:saveSetting("pagemap_use_page_labels", false)
                            pagemap.ui.doc_settings:delSetting("pagemap_chars_per_synthetic_page")
                            UIManager:broadcastEvent(Event:new("UsePageLabelsUpdated"))
                        end)
                    end,
                },
            },
        },
    }
    local check_show_in_margin = CheckButton:new{
        text     = _("Show stable page numbers in margin"),
        checked  = pagemap.has_pagemap and pagemap.show_page_labels,
        parent   = dialog,
        callback = function()
            pagemap.show_page_labels = not pagemap.show_page_labels
            pagemap.ui.doc_settings:saveSetting("pagemap_show_page_labels", pagemap.show_page_labels)
            pagemap:resetLayout()
            pagemap:updateVisibleLabels()
            UIManager:setDirty(pagemap.view.dialog, "partial")
        end,
    }
    dialog:addWidget(check_show_in_margin)
    UIManager:show(dialog)
    dialog:onShowKeyboard()
end

local orig_postInit      = ReaderPageMap._postInit
local orig_init          = ReaderPageMap.init
local orig_onReaderReady = ReaderPageMap.onReaderReady
local orig_addToMainMenu = ReaderPageMap.addToMainMenu

ReaderPageMap._postInit = function(self)
    self._physical_pages_applied = false
    orig_postInit(self)
end

ReaderPageMap.onReaderReady = function(self)
    if orig_onReaderReady then orig_onReaderReady(self) end
    if not self._physical_pages_applied then
        self._physical_pages_applied = true
        local p = getPhysicalPages(self.ui)
        if p then rebuildMap(self, p, false) end
    end
end

ReaderPageMap.init = function(self)
    self._last_page_number = nil
    orig_init(self)
end

function ReaderPageMap:_getLastPageNumber()
    self._last_page_number = self._last_page_number or #self.ui.document:getPageMap()
    return self._last_page_number
end

ReaderPageMap.addToMainMenu = function(self, menu_items)
    orig_addToMainMenu(self, menu_items)
    menu_items.pagemap_physical_pages = {
        text = _("Physical page count…"),
        sub_text = function()
            local p = getPhysicalPages(self.ui)
            return p and tostring(p) or nil
        end,
        callback = function()
            showDialog(self)
        end,
    }
end
