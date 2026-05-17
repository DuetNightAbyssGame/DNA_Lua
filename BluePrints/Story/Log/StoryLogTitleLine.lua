local FStoryLogLine = require("BluePrints/Story/Log/StoryLogLine")

---@class FStoryLogTitleLine : FStoryLogLine
---@field Title string
local M = setmetatable({}, {
	__index = FStoryLogLine
})

---@param Title string
function M:New(Title)
	Title = tostring(Title)

	local TitleLine = setmetatable(FStoryLogLine:New(Title), {
		__index = M
	})
	TitleLine.Title = Title
	return TitleLine
end

---@return string
function M:ToString()
	return string.format("· %s\n", self.Title)
end

---@return string
function M:ToRichString()
	return string.format("<font color='red'>**%s**</font>\n", self.Title)
end

return M
