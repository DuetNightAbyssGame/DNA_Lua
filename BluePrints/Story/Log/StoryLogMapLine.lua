local FStoryLogLine = require("BluePrints/Story/Log/StoryLogLine")

---@class FStoryLogMapLine : FStoryLogLine
---@field TextOrderMap table<integer, table<string, string>>
local M = setmetatable({}, {
	__index = FStoryLogLine
})

---@param TextOrderMap table<integer, table<string, string>>
---@return FStoryLogMapLine
function M:New(TextOrderMap)
	TextOrderMap = TextOrderMap or {}

	local MapLine = setmetatable(FStoryLogLine:New(), {
		__index = M
	})
	MapLine.TextOrderMap = TextOrderMap
	return MapLine
end

---@return string
function M:ToString()
	local ResultString = ""
	for _, Tuple in pairs(self.TextOrderMap) do
		ResultString = string.format("%s[%s]: %s, ", ResultString, Tuple[1], Tuple[2])
	end
	return string.format("%s\n", ResultString)
end

---@return string
function M:ToRichString()
	local ResultString = ""
	for _, Tuple in pairs(self.TextOrderMap) do
		ResultString = string.format("%s**[%s]**: %s, ", ResultString, Tuple[1], Tuple[2])
	end
	return string.format("%s\n", ResultString)
end

return M
