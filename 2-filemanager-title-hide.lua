-- Hides the large title label in FileManager only (without leaving extra whitespace)

local Screen = require("device").screen
local FileManager = require("apps/filemanager/filemanager")
local UIManager = require("ui/uimanager")
local VerticalSpan = require("ui/widget/verticalspan")

local TOP_MARGIN = Screen:scaleBySize(12) -- <-- top margin

local og_setupLayout = FileManager.setupLayout

function FileManager:setupLayout()
    og_setupLayout(self)

    local tb = self.title_bar
    if not tb or not tb.title_group then return end

    local tg = tb.title_group
    local sw = tb.subtitle_widget or tb.inner_subtitle_group

    while #tg > 0 do
        table.remove(tg, 1)
    end

    table.insert(tg, VerticalSpan:new{ width = TOP_MARGIN })
    if sw then
        table.insert(tg, sw)
    end

    tg:resetLayout()
    UIManager:setDirty(self, "ui", tb.dimen)
end