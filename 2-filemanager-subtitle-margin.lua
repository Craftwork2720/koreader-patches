-- Adds horizontal margin to the file path (subtitle) displayed in the top TitleBar
-- Change SUBTITLE_H_MARGIN to any pixel value you want

local Screen = require("device").screen
local TitleBar = require("ui/widget/titlebar")

local SUBTITLE_H_MARGIN = Screen:scaleBySize(64)  -- <-- change this value

local og_init = TitleBar.init

function TitleBar:init()
    if self.subtitle then
        self.title_h_padding = (self.title_h_padding or 0) + SUBTITLE_H_MARGIN
        og_init(self)
        self.title_h_padding = self.title_h_padding - SUBTITLE_H_MARGIN
    else
        og_init(self)
    end
end