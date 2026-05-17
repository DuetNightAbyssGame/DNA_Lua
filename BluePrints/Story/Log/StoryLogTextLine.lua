local FStoryLogLine = require("BluePrints/Story/Log/StoryLogLine")

---@class FStoryLogTextLine : FStoryLogLine
---@field Text string
local M = setmetatable({}, {
	__index = FStoryLogLine
})

---@param Text string
---@return FStoryLogTextLine
function M:New(Text)
	Text = tostring(Text)

	local TextLine = setmetatable(FStoryLogLine:New(), {
		__index = M
	})
	TextLine.Text = Text
	return TextLine
end

---@return string
function M:ToString()
	return string.format("%s\n", self.Text)
end

---@return string
function M:ToRichString()
	return string.format("%s\n", self.Text)
end

return M
