---@class FStoryLogLine
local M = {}

---@return FStoryLogLine
function M:New()
	local Line = setmetatable({}, {
		__index = M
	})
	return Line
end

---@return string
function M:ToString()
	return ""
end

---@return string
function M:ToRichString()
	return ""
end

return M
