local Dispatcher = require("dispatcher")
local Event = require("ui/event")
local ReaderFooter = require("apps/reader/modules/readerfooter")
local _ = require("gettext")

Dispatcher:registerAction("hide_status_bar", {
    category = "none",
    event = "HideStatusBar",
    title = _("Hide status bar"),
    reader = true,
})

Dispatcher:registerAction("show_status_bar", {
    category = "none",
    event = "ShowStatusBar",
    title = _("Show status bar"),
    reader = true,
})

Dispatcher:registerAction("toggle_status_bar_visibility", {
    category = "none",
    event = "ToggleStatusBarVisibility",
    title = _("Toggle status bar visibility"),
    reader = true,
})

local original_onReaderReady = ReaderFooter.onReaderReady
local original_addToMainMenu = ReaderFooter.addToMainMenu

ReaderFooter.onReaderReady = function(self, ...)
    original_onReaderReady(self, ...)
    if G_reader_settings:isTrue("status_bar_hidden") then
        self.mode = self.mode_list.off
        self.view.footer_visible = false
        if self.ui.crelistener then
            self.ui:handleEvent(Event:new("SetStatusLine", 1))
        end
    end
end

ReaderFooter.addToMainMenu = function(self, menu_items)
    original_addToMainMenu(self, menu_items)

    table.insert(menu_items.status_bar.sub_item_table, 1, {
        text = _("Hide status bar"),
        checked_func = function()
            return G_reader_settings:isTrue("status_bar_hidden")
        end,
        keep_menu_open = true,
        callback = function()
            if G_reader_settings:isTrue("status_bar_hidden") then
                G_reader_settings:saveSetting("status_bar_hidden", false)
                self:onShowStatusBar()
            else
                G_reader_settings:saveSetting("status_bar_hidden", true)
                self:onHideStatusBar()
            end
        end,
        separator = true,
    })
end

function ReaderFooter:onHideStatusBar()
    if self.view.footer_visible == false then return end
    self:applyFooterMode(self.mode_list.off)
    self:onUpdateFooter(true, true)
    if self.ui.crelistener then
        self.ui:handleEvent(Event:new("SetStatusLine", 1))
    end
end

function ReaderFooter:onShowStatusBar()
    if self.view.footer_visible == true then return end
    local saved_mode = G_reader_settings:readSetting("reader_footer_mode")
        or self.mode_list.page_progress
    self:applyFooterMode(saved_mode)
    self:onUpdateFooter(true, true)
    if self.ui.crelistener then
        self.ui:handleEvent(Event:new("SetStatusLine", self.ui.document.configurable.status_line))
    end
end

function ReaderFooter:onToggleStatusBarVisibility()
    if self.view.footer_visible == false then
        self:onShowStatusBar()
    else
        self:onHideStatusBar()
    end
end
