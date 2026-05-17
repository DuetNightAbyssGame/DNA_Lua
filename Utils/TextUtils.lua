local EWildcardClassification = {
	Story = "Story"
}

---@params TextMapId: string
---@return string
local function Localize(TextMapId, Language)
	Language = Language or CommonConst.SystemLanguage or CommonConst.SystemLanguages.Default

	if (TextMapId == nil) then
		return nil
	end

	if (Language == nil) then
		return nil
	end

	local TextMap = DataMgr["TextMap_" .. Language]

	local TextMapData = TextMap[TextMapId]
	if (TextMapData == nil) then
		return TextMapId
	end

	local LocalizedText = TextMapData[Language]
	if (LocalizedText == nil) then
		return TextMapId
	end

	return LocalizedText
end

---@params TextMapId: string
---@params Text: string
---@return string
local function ReplaceWildcards(TextMapId, Text)
	if (TextMapId == nil) then
		return Text
	end

	local TextMapData = DataMgr.TextMapWildcard[TextMapId]
	if (TextMapData == nil) then
		return Text
	end

	local ReplacedWildcardsText = Text
	if (TextMapData.WildcardClassification == EWildcardClassification.Story) then
		local WildcardSubsystem = UWildcardGameInstanceSubsystem.GetSubsystem(GWorld.GameInstance)
		if (IsValid(WildcardSubsystem)) then
			ReplacedWildcardsText = WildcardSubsystem:ReplaceWildcard(Text)
		end
	end

	return ReplacedWildcardsText
end

local M = {}

---@params Text: string
---@return string
function M:GetDisplayText(Text, Language)
	local DisplayText = Localize(Text, Language)
	DisplayText = ReplaceWildcards(Text, DisplayText)
	return DisplayText
end

return M
