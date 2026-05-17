local FStoryLogTitleLine = require("BluePrints/Story/Log/StoryLogTitleLine")
local FStoryLogTextLine = require("BluePrints/Story/Log/StoryLogTextLine")
local FStoryLogKeyLine = require("BluePrints/Story/Log/StoryLogKeyLine")
local FStoryLogMapLine = require("BluePrints/Story/Log/StoryLogMapLine")

---@class FStoryLog
---@field LineArray table<number, FStoryLogLine>
local M = {}

---@return FStoryLog
function M:New()
	local StoryLog = setmetatable({}, {
		__index = M
	})
	StoryLog.LineArray = {}
	return StoryLog
end

---@param Title string
function M:AddTitleLine(Title)
	table.insert(self.LineArray, FStoryLogTitleLine:New(Title))
end

---@param Text string
function M:AddTextLine(Text)
	table.insert(self.LineArray, FStoryLogTextLine:New(Text))
end

---@param Key string
---@param Value string
function M:AddKeyLine(Key, Value)
	table.insert(self.LineArray, FStoryLogKeyLine:New(Key, Value))
end

---@param TextOrderMap table<integer, table<string, string>>
function M:AddMapLine(TextOrderMap)
	table.insert(self.LineArray, FStoryLogMapLine:New(TextOrderMap))
end

function M:AddSeparator()
	self:AddTextLine("—————————————————————————————————————————————")
end

---@return string
function M:ToString()
	local Text = ""
	for _, Line in ipairs(self.LineArray) do
		Text = Text .. Line:ToString()
	end
	return Text
end

---@return string
function M:ToRichString()
	local RichText = ""
	for _, Line in ipairs(self.LineArray) do
		RichText = RichText .. Line:ToRichString()
	end
	return RichText
end

return M
