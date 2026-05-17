local function CreateWildcardReplaceFunctionMap()
	return {
		["{性别[:：]+.-|.-}"] = "ReplaceProtagonistGenderWildcard",
		["{性别2[:：]+.-|.-}"] = "ReplaceFormerProtagonistGenderWildcard",
		["{[Cc]+at[Nn]+ame}"] = "ReplaceCatNameWildcard",
		["{[Nn]+ick[Nn]+ame}"] = "ReplaceNickNameWildcard",
		["{[Nn]+ick[Nn]+ame2}"] = "ReplaceNickName2Wildcard",
		["{%$.-%$|.-}"] = "ReplaceTagWildcard",
		["{序数[:：]+.-}"] = "ReplaceNumberWildcard",
		["{空格}"] = "ReplaceSpaceWildcard",
		["{[Qq]+uest%(.-%):.-|.-}"] = "ReplaceQuestWildcard",
		["{[Qq]+uest[Cc]+hain%(.-%):.-|.-}"] = "ReplaceQuestChainWildcard"
	}
end

---@type BP_WildcardGameInstanceSubsystem_C
---@field WildcardReplaceFunctionMap table<string, string>
---@field TagWildcardMap table<string, number>
local M = Class()

function M:OnInitialize()
	self.bIsInitialized = true
	self.WildcardReplaceFunctionMap = CreateWildcardReplaceFunctionMap()
end

function M:OnDeinitialize()
	self.bIsInitialized = false
	self.WildcardReplaceFunctionMap = nil
end

function M:Reinitialize()
	self.bIsInitialized = true
	self.WildcardReplaceFunctionMap = CreateWildcardReplaceFunctionMap()
end

---@param Text string
---@return string
function M:ReplaceWildcard(Text)
	if (Text == nil) then
		return nil
	end

	if (not self.bIsInitialized) then
		self:Reinitialize()
	end

	local ReplacedText, _ = string.gsub(Text, "{.-}", function(Wildcard)
		for WildcardTypeRegex, Function in pairs(self.WildcardReplaceFunctionMap) do
			if (string.match(Wildcard, WildcardTypeRegex)) then
				return self[Function](self, Wildcard)
			end
		end
		return Wildcard
	end)
	return ReplacedText
end

---@param Wildcard string
---@return string
function M:ReplaceProtagonistGenderWildcard(Wildcard)
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		return "(未联网)主角性别"
	end

	local LeftValue, RightValue = string.match(Wildcard, "{.-[：:]+(.-)|(.-)}")
	if Avatar.Sex == 0 then
		return LeftValue
	else
		return RightValue
	end
end

---@param Wildcard string
---@return string
function M:ReplaceFormerProtagonistGenderWildcard(Wildcard)
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		return "(未联网)前主角性别"
	end

	local LeftValue, RightValue = string.match(Wildcard, "{.-[：:]+(.-)|(.-)}")
	if Avatar.WeitaSex == 0 then
		return LeftValue
	else
		return RightValue
	end
end

---@param Wildcard string
---@return string
function M:ReplaceCatNameWildcard(Wildcard)
	local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar.CatName and Avatar.CatName ~= "" then
		return Avatar.CatName
	end
	return GText("UI_Npc_Name_Mao")
end

---@param Wildcard string
---@return string
function M:ReplaceNickNameWildcard(Wildcard)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return "夜航主角名"
	end
	return Avatar.Nickname
end

---@param Wildcard string
---@return string
function M:ReplaceNickName2Wildcard(Wildcard)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return "泊暮主角名"
	end
	return Avatar.WeitaName
end

---@param Wildcard string
---@return string
function M:ReplaceTagWildcard(Wildcard)
	local Tag, KeyStr, ValueStr = string.match(Wildcard, "{%$(.-)%((.-)%)%$|(.+)}")
	if (Tag == nil and KeyStr == nil and ValueStr == nil) then
		Tag, ValueStr = string.match(Wildcard, "{%$(.-)%$|(.-)}")
	end
	local Values = string.split(string.gsub(ValueStr, " ", ""), ":")
	for idx, Value in pairs(Values) do
		local Rule, Value1, Value2 = string.match(Value, "(.-)%((.-)|(.-)%)")
		if Rule and Value1 and Value2 then
			if Rule == "性别" then
				Values[idx] = self:ReplaceProtagonistGenderWildcard("{性别:"..Value1.."|"..Value2.."}")
			elseif Rule == "性别2" then
				Values[idx] = self:ReplaceFormerProtagonistGenderWildcard("{性别2:"..Value1.."|"..Value2.."}")
			end
		end
	end

	local Avatar = GWorld:GetAvatar()
	if (not Avatar) then
		return Wildcard
	end

	local SaveValue = Avatar:GetTalkTag(Tag)
	if (KeyStr) then
		if (SaveValue == nil) then
			return Wildcard
		end

		local Keys = string.split(string.gsub(KeyStr, " ", ""), ",")
		for i, Key in ipairs(Keys) do
			local KeyInfo = string.split(Key, "_")
			if (DataMgr.TalkTag[Tag][KeyInfo[1]][tonumber(KeyInfo[2])] == SaveValue) then
				return Values[i]
			end
		end
	else
		if (SaveValue) then
			return Values[1]
		else
			return Values[2]
		end
	end
	return Wildcard
end

---@param Wildcard string
---@return string
function M:ReplaceNumberWildcard(Wildcard)
	local Number = string.match(Wildcard, "{序数[：:]+(.-)}")

	if (CommonConst.SystemLanguage ~= CommonConst.SystemLanguages.EN) then
		return Number
	end

	if (not tonumber(Number)) then
		return Number
	end

	if (Number == "11" or Number == "12" or Number == "13") then
		return Number .. "th"
	end

	local LastNumber = string.sub(Number, -1)
	if (LastNumber == "1") then
		return Number .. "st"
	elseif (LastNumber == "2") then
		return Number .. "nd"
	elseif (LastNumber == "3") then
		return Number .. "rd"
	else
		return Number .. "th"
	end
end

---@param Wildcard string
---@return string
function M:ReplaceSpaceWildcard(Wildcard)
	return " "
end

---@param Wildcard string
---@return string
function M:ReplaceQuestWildcard(Wildcard)
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		return Wildcard
	end

	local QuestId, LeftValue, RightValue = string.match(Wildcard, "{[Qq]+uest%((.-)%):(.-)|(.+)}")
	QuestId = tonumber(QuestId)
	if (Avatar:IsQuestFinished(QuestId)) then
		return LeftValue
	else
		return RightValue
	end
end

---@param Wildcard string
---@return string
function M:ReplaceQuestChainWildcard(Wildcard)
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		return Wildcard
	end

	local QuestChainId, LeftValue, RightValue = string.match(Wildcard, "{[Qq]+uest[Cc]+hain%((.-)%):(.-)|(.+)}")
	QuestChainId = tonumber(QuestChainId)
	if (Avatar:IsQuestChainFinished(QuestChainId)) then
		return LeftValue
	else
		return RightValue
	end
end

return M
