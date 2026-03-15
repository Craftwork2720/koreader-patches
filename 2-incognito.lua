local UIManager  = require("ui/uimanager")
local _          = require("gettext")
local logger     = require("logger")

local M = {
    _active = false,
    _file   = nil,
}

local ok_rh, ReadHistory = pcall(require, "readhistory")
if ok_rh and ReadHistory then

    local orig_addItem = ReadHistory.addItem
    ReadHistory.addItem = function(self, file, ts, no_flush)
        if M._active and file == M._file then
            return
        end
        return orig_addItem(self, file, ts, no_flush)
    end

    local orig_reload = ReadHistory.reload
    ReadHistory.reload = function(self, force_read)
        orig_reload(self, force_read)
        if not M._active then return end
        local filtered = {}
        for _, item in ipairs(self.hist) do
            if item.file ~= M._file then
                table.insert(filtered, item)
            end
        end
        if #filtered ~= #self.hist then
            self.hist = filtered
        end
    end
end

local ok_dr, DocumentRegistry = pcall(require, "document/documentregistry")
if ok_dr and DocumentRegistry then

    local orig_openDocument = DocumentRegistry.openDocument
    DocumentRegistry.openDocument = function(self, file, provider)
        local doc = orig_openDocument(self, file, provider)
        if doc and M._active and file == M._file then
            doc.is_pic = true
        end
        return doc
    end
end

UIManager:scheduleIn(0, function()
    local ok_fm, FileManager = pcall(require, "apps/filemanager/filemanager")
    if not ok_fm or not FileManager then return end

    FileManager:addFileDialogButtons("incognito", function(file, is_file)
        if not is_file then return nil end

        return {
            {
                text = _("Open Incognito"),
                callback = function()
                    M._active = true
                    M._file   = file

                    local dialog = UIManager:getTopmostVisibleWidget()
                    if dialog then
                        UIManager:close(dialog)
                    end

                    UIManager:scheduleIn(0.1, function()
                        local ReaderUI = require("apps/reader/readerui")

                        local orig_init = ReaderUI.init
                        ReaderUI.init = function(self_rui, ...)
                            ReaderUI.init = orig_init
                            orig_init(self_rui, ...)
                            if M._active and self_rui.doc_settings then
                                local ds = self_rui.doc_settings
                                local orig_flush = ds.flush
                                ds.flush = function(self_ds, ...)
                                    if M._active then return end
                                    return orig_flush(self_ds, ...)
                                end
                            end
                        end

                        local orig_onClose = ReaderUI.onClose
                        ReaderUI.onClose = function(self_rui, ...)
                            ReaderUI.onClose = orig_onClose
                            local closed_file = M._file

                            local ret = orig_onClose(self_rui, ...)

                            M._active = false
                            M._file   = nil


                            if closed_file then
                                local ok_bl, BookList = pcall(require, "ui/widget/booklist")
                                if ok_bl and BookList and BookList.resetBookInfoCache then
                                    BookList.resetBookInfoCache(closed_file)
                                end
                            end

                            return ret
                        end

                        ReaderUI:showReader(file)
                    end)
                end,
            },
        }
    end)
end)

return M
