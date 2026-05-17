
local MiscUtils = require "Utils.MiscUtils"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"

local EMGlobalLuaTable = {}

function EMGlobalLuaTable.TriggerBattleEvent(Battle, EventName, ...)
	-- 战斗机制 
	Battle:TriggerLuaBattleEvent(EventName, ...)
end

function EMGlobalLuaTable.TriggerEventManager(EventName, ...)
	-- DebugPrint("gmy@EMGlobalLuaTable.TriggerEventManager EventName", EventName, ...)
	-- 触发Lua UI事件
	EventManager:FireEvent(EventName, ...)
end

function EMGlobalLuaTable.RemoveEvent(EventName, Object)
	EventManager:RemoveEvent(EventName, Object)
end

function EMGlobalLuaTable.TriggerDungeonComponentFun(GameMode,EventName,...)
	if GameMode and EventName then
		GameMode:TriggerDungeonComponentFun(EventName,...)
	end
end

function EMGlobalLuaTable.SkillUtilsSplitEval(Desc)
	local SkillUtils = require("Utils.SkillUtils")
	return SkillUtils.SplitEval(Desc, "$")
end

function EMGlobalLuaTable.GetTaskTargetPointPos()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local TaskIndicator = UIManager:GetUIObj("TaskIndicator")
	if  IsValid(TaskIndicator) and TaskIndicator.TargetPointPos~=nil then
		return TaskIndicator.TargetPointPos
	end
	return UE4.FVector(0, 0, 0)
end

function EMGlobalLuaTable.GetTransEPhysicalSurface(PhysicalSurface)
	return MiscUtils.TransEPhysicalSurface(PhysicalSurface)
end

function EMGlobalLuaTable.ShowRougeLikeError(Text)
	local BP_RougeLikeManager_C = require "BluePrints.GameMode.BP_RougeLikeManager_C"
	BP_RougeLikeManager_C:ShowRougeLikeError(Text)
end

--构建倒序的Map
function EMGlobalLuaTable.MakeTempFlexibleMap(FlexibleShowHideTags)
	local NewFlexibleMap = {}
	local FNpcArrayNum = FlexibleShowHideTags:Num()
	for FNpcArray, IsHide in pairs(FlexibleShowHideTags) do
		local NewFlexibleMapElement = {}
		NewFlexibleMapElement.NpcArray = FNpcArray
		NewFlexibleMapElement.IsHide = IsHide
		NewFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
		FNpcArrayNum = FNpcArrayNum - 1
	end
	return NewFlexibleMap
end

-- return true 可显示
function EMGlobalLuaTable.CustomNpcFlexibShow(FlexibleShowHideTags)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return true
	end
	local TempFlexibleMap = EMGlobalLuaTable.MakeTempFlexibleMap(FlexibleShowHideTags)

	for i = 1, FlexibleShowHideTags:Num(), 1 do
		local TargetQuestId = TempFlexibleMap[i].NpcArray.Quest.QuestId
		local TargetQuestState = TempFlexibleMap[i].NpcArray.Quest.MyQuestState
		local TargetTalkTriggerId = TempFlexibleMap[i].NpcArray.ImpressionTalk.TalkTriggerId
		local TalkState = TempFlexibleMap[i].NpcArray.ImpressionTalk.TalkQuestState
		local FlexibleQuestChainId = TempFlexibleMap[i].NpcArray.QuestChain.QuestChainId
		local FlexibleQuestChainState = TempFlexibleMap[i].NpcArray.QuestChain.QuestChainState
		if TempFlexibleMap[i].NpcArray.EditableStructType == 0 then --0任务类型
			local QuestChainId = tonumber(string.sub(TargetQuestId, 1, 6))--从子任务id里筛选六个字符的ChainId
			local QuestStateType = {
				Doing = 1,
				Success = 2,
			}
			if not Avatar.QuestChains[QuestChainId] then
				-- DebugPrint("QuestChain is unexist:", QuestChainId)
				goto continue
			end
			local QuestChains = Avatar.QuestChains[QuestChainId]

			if TargetQuestState == QuestStateType.Doing and QuestChains.DoingQuestId == TargetQuestId then --任务在进行中
				return TempFlexibleMap[i].IsHide
			elseif TargetQuestState == QuestStateType.Success then --任务已完成
				if QuestChains:CheckQuestIdComplete(TargetQuestId) then
					return TempFlexibleMap[i].IsHide
				end
			else
				--其他类型暂不处理
				-- DebugPrint("QuestChain state is error:", QuestChainId)
			end
		elseif TempFlexibleMap[i].NpcArray.EditableStructType == 1 then --1印象对话类型

			local TalkStateType = {
				Compelete = 0,
				UnCompelete = 1,
				CheckSuccess = 2,
				CheckFail = 3,
			}
			if TalkState == TalkStateType.Compelete then
				if Avatar:IsStorylineComplete(TargetTalkTriggerId)  then
				return TempFlexibleMap[i].IsHide
				end
			elseif TalkState == TalkStateType.UnCompelete then
				if Avatar:IsStorylineUnComplete(TargetTalkTriggerId) then
				return TempFlexibleMap[i].IsHide
				end
			elseif TalkState == TalkStateType.CheckSuccess then
				if Avatar:IsStorylineSuccess(TargetTalkTriggerId) then
				return TempFlexibleMap[i].IsHide
				end
			elseif TalkState == TalkStateType.CheckFail then
				if Avatar:IsStorylineFailure(TargetTalkTriggerId) then
				return TempFlexibleMap[i].IsHide
				end
			else
				--对话其他情况暂不处理
			end
		elseif TempFlexibleMap[i].NpcArray.EditableStructType == 2 then --2任务链类型
			local QuestChainStateType = {
				Doing = 1,
				Success = 2,
			}
			if not Avatar.QuestChains[FlexibleQuestChainId] then
				-- DebugPrint("QuestChain is unexist:", FlexibleQuestChainId)
				goto continue
			end
			local TargetQuestChain = Avatar.QuestChains[FlexibleQuestChainId]

			if FlexibleQuestChainState == QuestChainStateType.Doing and TargetQuestChain:IsDoing() then --任务在进行中
				return TempFlexibleMap[i].IsHide
			elseif FlexibleQuestChainState == QuestChainStateType.Success and TargetQuestChain:IsFinish() then --任务已完成
				return TempFlexibleMap[i].IsHide
			else
				--其他类型暂不处理
				-- DebugPrint("QuestChain state is error:", FlexibleQuestChainId)
			end
		end
		::continue::
	end

	return true
end

function EMGlobalLuaTable.GenerateEnhanceLogName()
    local SystemTime = os.time()
    local FinalLogName = os.date("%Y_%m_%d_%H_%M", SystemTime)
	-- 登录USDK在登录界面时
    local SdkUserId = HeroUSDKUtils.GetUserInfo().sdkUserId
    if SdkUserId ~= "" then
        FinalLogName = string.format("%s-%s", FinalLogName, SdkUserId)
    end

	-- 游戏内
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        FinalLogName = string.format("%s-%d", FinalLogName, Avatar.Uid)
    end

    return FinalLogName
end

function EMGlobalLuaTable.ShowEnhanceLogUploadTip(...)
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	if not UIManager then
		return
	end
	local Args = {...}
	local Result = Args[1]
	local FileName = Args[2]
	if Result == UE4.EUploadEnhanceLogResult.Success then
        -- 上报成功
        local TipText = string.format( GText("UI_Opition_Log_Finish"), FileName)
        UIManager:ShowUITip(UIConst.Tip_CommonToast, TipText)
    else
        UIManager:ShowUITip(UIConst.Tip_CommonToast, string.format( GText("UI_Opition_Log_UpdateFail"), tostring(Result)))
    end
end

function EMGlobalLuaTable.ShowClearLogTip()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	if not UIManager then
		return
	end
	UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Opition_Log_Cleand"))
end

-- return true 可显示
function EMGlobalLuaTable.CustomNpcAtmosShow(AtmosphereTagArray)
	if AtmosphereTagArray:Num() == 0 then
		return true
	end

	local Avatar = GWorld:GetAvatar()
	if Avatar then
		local SuitData = Avatar.Suits:GetSuitBase(CommonConst.SuitType.PlayerCharacterSuit)
		if SuitData and SuitData:GetSubSuitBase(CommonConst.PlayerCharacterSuit.NpcHideShowTag) then
			local SubSuitData = SuitData:GetSubSuitBase(CommonConst.PlayerCharacterSuit.NpcHideShowTag)
			for Tag, Value in pairs(SubSuitData) do
				if AtmosphereTagArray:Contains(Tag) and Value==true then
					return false
				end
			end
		end
	end

	return true
end

return EMGlobalLuaTable