local FStoryLogLine = require("BluePrints/Story/Log/StoryLogLine")

---@class FStoryLogKeyLine : FStoryLogLine
---@field Key string
---@field Text string
local M = setmetatable({}, {
	__index = FStoryLogLine
})

---@param Key string
---@param Text string
---@return FStoryLogKeyLine
function M:New(Key, Text)
	Key = tostring(Key)
	Text = tostring(Text)

	local KeyLine = setmetatable(FStoryLogLine:New(), {
		__index = M
	})
	KeyLine.Key = Key
	KeyLine.Text = Text
	return KeyLine
end

---@return string
function M:ToString()
	return string.format("%s: %s\n", self.Key, self.Text)
end

---@return string
function M:ToRichString()
	return string.format("**%s**: %s\n", self.Key, self.Text)
end

return M
