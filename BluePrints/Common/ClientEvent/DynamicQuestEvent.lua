
local DynamicQuestEvent = Class(
{
	'BluePrints.Common.ClientEvent.BaseClientEvent',
    'BluePrints.Common.TimerMgr'
})
local TimeUtils = require "Utils.TimeUtils"
--local TimerMgr = require "BluePrints.Common.TimerMgr"
function DynamicQuestEvent:InitEvent(DynamicQuestId, Callback)

	-- Event Type
	self.Type = "DynamicQuest"

	self.DynamicQuestId = DynamicQuestId
	self.SpecialQuestFinishCallback = Callback
end

function DynamicQuestEvent:OnStartEvent( ... )
	self.DynamicQuestConfig=DataMgr.DynQuest[self.DynamicQuestId]
	assert(self.DynamicQuestConfig, "找不到动态任务编号:【" .. tostring(self.DynamicQuestConfig) .. "】")
	self.TriggerBoxStaticCreatorId = self.DynamicQuestConfig.TriggerBoxID
	self.FailTriggerBoxID=self.DynamicQuestConfig.FailTriggerBoxID
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		self.DynQuest=Avatar.DynamicQuests[self.DynamicQuestId]
	end
	EventManager:AddEvent(EventID.OnEnterTriggerBox, self, self.OnEnterTriggerBox)
	EventManager:AddEvent(EventID.OnLeaveTriggerBox, self, self.OnLeaveTriggerBox)
	self:ActivateTrigger()
end

function DynamicQuestEvent:ActivateTrigger( )
	DebugPrint("[动态事件]Trigger激活 动态事件Id"..tostring(self.DynamicQuestId).." "..TimeUtils.TimeToHMSStr())
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode and GameMode.TriggerActiveStaticCreator_DynQuestId then
		GameMode:TriggerActiveStaticCreator_DynQuestId({self.TriggerBoxStaticCreatorId}, self.DynamicQuestId)
		if self.FailTriggerBoxID~=self.TriggerBoxStaticCreatorId then
			GameMode:TriggerActiveStaticCreator_DynQuestId({self.FailTriggerBoxID}, self.DynamicQuestId)
		end
	else
		DebugPrint("[动态事件]Trigger激活 动态事件Id"..tostring(self.DynamicQuestId).." "..TimeUtils.TimeToHMSStr().."失败，GameMode或TriggerActiveStaticCreator_DynQuestId为空")
	end
end


function DynamicQuestEvent:TryActivateEvent( ... )
	local Avatar = GWorld:GetAvatar()
	if Avatar then
	local CanTrigger=Avatar:CheckDynamicQuestIsInCantTriggerState(self.DynamicQuestId)
		if CanTrigger then
			-- local Callback = function(Ret)
			-- 	if Ret==ErrorCode.RET_SUCCESS then
			-- 		self:OnActivateEvent()
			-- 	end
			-- end	
			DebugPrint("[动态事件]尝试触发动态事件Id"..tostring(self.DynamicQuestId).." "..TimeUtils.TimeToHMSStr())
			Avatar:TriggerDynamicQuestBegin(self.DynamicQuestId,function(Ret)
				if Ret==ErrorCode.RET_SUCCESS then
					DebugPrint("[动态事件]触发动态事件Id"..tostring(self.DynamicQuestId).."成功 "..TimeUtils.TimeToHMSStr())
					self:OnActivateEvent()
				else
					DebugPrint("[动态事件]触发动态事件Id"..tostring(self.DynamicQuestId).."失败 "..TimeUtils.TimeToHMSStr())
				end
			end)
		else
			DebugPrint("[动态事件]尝试触发动态事件Id"..tostring(self.DynamicQuestId).."失败，任务不在可触发状态 "..TimeUtils.TimeToHMSStr())
		end
end
end

function DynamicQuestEvent:OnActivateEvent( ... )
	PrintTable({OnActivateEvent=self.DynamicQuestId})
	--更新动态事件状态
	local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
	local Avatar = GWorld:GetAvatar()
    if  Avatar then
		if  Avatar:CheckAllDynamicQuestAlreadyTrigger() then
			EventManager:FireEvent(EventID.FirstDynQuest)
		end
	end
	ClientEventUtils:ShowDynEventUI(self)
	EventManager:FireEvent(EventID.OnActiveDynamicQuest, self.DynamicQuestId)
	local TaskBar=self:GetMainTaskBar()
	local TrackingQuestChain = Avatar.TrackingQuestChainId
	if TaskBar then
		TaskBar:PlayAnimation(TaskBar.DynamicEvent_In)
		if TrackingQuestChain ~= 0 then
			if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
				TaskBar:PlayAnimation(TaskBar.Tooltip_Out)
				TaskBar.Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			else
				TaskBar.Tips:SetVisibility(ESlateVisibility.Collapsed)
			end
			if TaskBar.VBox_SubTasks:GetChildrenCount() > 0 then
				TaskBar.VBox_SubTasks:SetVisibility(ESlateVisibility.Collapsed)
			end
		end
		--TaskBar.Tips:SetVisibility(ESlateVisibility.Collapsed)
	end
	
		ClientEventUtils:SetCurrentDoingDynamicEvent(self)
	local StoryPath = self.DynamicQuestConfig.StoryPath
		self.DynamicQuestStory = GWorld.StoryMgr:RunStory(StoryPath, nil, nil, nil, nil, {DynQuestId = self.DynamicQuestId})
end

function DynamicQuestEvent:TryFinishEvent(Result, Callback, NodeId, DialogueId,ForbidAnim)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		if Result then
			local _Callback = function(Ret)
				self:OnFinishEvent(true, Callback,DialogueId,ForbidAnim)
			end
			Avatar:TriggerDynamicQuestEnd(self.DynamicQuestId,"Success",_Callback,DialogueId)
		else
			local _Callback = function(Ret)
				self:OnFinishEvent(false, Callback,nil,ForbidAnim)
			end
			Avatar:TriggerDynamicQuestEnd(self.DynamicQuestId,"Fail",_Callback,DialogueId)
		end
	end
end

function DynamicQuestEvent:GetMainTaskBar()
	local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local TaskUIObj = nil
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI ~= nil and BattleMainUI.Pos_TaskBar:GetChildAt(0) then
        TaskUIObj = BattleMainUI.Pos_TaskBar:GetChildAt(0)
    end
	if TaskUIObj ~= nil then
        return TaskUIObj
    end
    return nil
end

function DynamicQuestEvent:OnFinishEvent(Result, Callback,DialogueId,ForbidAnim)
	-- body
	local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
	--ClientEventUtils:HideDynEventUI()
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode then
		if Result then
			GameMode:TriggerOnDynQuestSuccess(self.DynamicQuestId)
		else
			GameMode:TriggerOnDynQuestFail(self.DynamicQuestId)
		end
			GameMode:TriggerOnDynQuestEnd(self.DynamicQuestId)
	end
	local DynEventUI=ClientEventUtils:GetDynEventUI()
	local function PlayTaskBarAnim()
		local TaskBar=self:GetMainTaskBar()
		if TaskBar then
			TaskBar:PlayAnimation(TaskBar.DynamicEvent_In)
			TaskBar.Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
				TaskBar:PlayAnimation(TaskBar.Tooltip_In)
				if TaskBar.Panel_Tips2:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible then
					TaskBar:PlayAnimation(TaskBar.Tooltip2_Out)
				end
			end
			if TaskBar.VBox_SubTasks:GetChildrenCount() > 0 then
				TaskBar.VBox_SubTasks:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			end
		end
	end
	if Result==false then
		DebugPrint("[动态事件]动态事件Id"..tostring(self.DynamicQuestId).."事件失败 "..TimeUtils.TimeToHMSStr())
		--UIManager:LoadUINew("ExploreToastFail", "UI_DYNQUEST_FAIL",nil,self.DynamicQuestConfig.DynName)
		if ForbidAnim~=true then
			DynEventUI:PlayFailAnim(GText("UI_DYNQUEST_FAIL"),PlayTaskBarAnim)
		end
	else
		DebugPrint("[动态事件]动态事件Id"..tostring(self.DynamicQuestId).."事件成功 "..TimeUtils.TimeToHMSStr())
		--UIManager:LoadUINew("ExploreToastSuccess","UI_DYNQUEST_SUCCESS",nil,self.DynamicQuestConfig.DynName)
		if ForbidAnim~=true then
			DynEventUI:PlaySuccessAnim(GText("UI_DYNQUEST_SUCCESS"),PlayTaskBarAnim)
		end
		local Avatar = GWorld:GetAvatar()
		if self.DynamicQuestConfig.DynImpression then
			for Key, ImprPlusId in pairs(self.DynamicQuestConfig.DynImpression ) do
				if Key==DialogueId then
					if Avatar and (ImprPlusId > 0) then
						Avatar:ShowImpressionPlusUI(ImprPlusId, function()
							self:ShowReward()
						end)
					end
					goto continue
				end
			end
		end
		self:ShowReward()
		::continue::
	end
	self:Destroy(Result)
	--self:RecoverUniversalConfig()
	--重新开始其他任务
	--self:RecoverOtherQuest()
	if Callback then
		Callback()
	end
	if self.DynamicQuestFinishCallback then
		self.DynamicQuestFinishCallback(Result)
	end
end

function DynamicQuestEvent:ShowReward()
	local RewardId = self.DynamicQuestConfig.Reward
	local RewardList={}
	for _,Id in ipairs(RewardId) do
		-- body
    local RewardInfo = DataMgr.Reward[Id]
    if RewardInfo then
        local RewardIds = RewardInfo.Id or {}
        local RewardCounts = RewardInfo.Count or {}
        local RewardTypes = RewardInfo.Type or {}
        for i = 1, #RewardIds do
            local ItemId = RewardIds[i]
            local Count = RewardUtils:GetCount(RewardCounts[i])
            local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
            local ItemType = RewardTypes[i]
            local RewardContent = {
                ItemId = ItemId,
                ItemType = ItemType,
                Count = Count,
                Rarity = Rarity,
            }
            table.insert(RewardList, RewardContent)
        end
    end
end
	UIUtils.ShowHudReward("UI_DYNQUEST_REWARD",  RewardList)
end

function DynamicQuestEvent:Destroy(Result, Info)
	EventManager:RemoveEvent(EventID.OnDynamicQuestFail, self)
	EventManager:RemoveEvent(EventID.OnEnterTriggerBox,self)
	EventManager:RemoveEvent(EventID.OnLeaveTriggerBox,self)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if self.LeaveTriggerTimerKey and  Player:IsExistTimer(self.LeaveTriggerTimerKey) then
		Player:RemoveTimer(self.LeaveTriggerTimerKey)
        self.LeaveTriggerTimerKey = nil
    end
	local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
	ClientEventUtils:ClearCurrentActiveDynamicEvent(self.DynamicQuestId)
	ClientEventUtils:ClearCurrentDoingDynamicEvent(false)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not IsValid(GameMode) then
		return
	end
 --    local StaticCreatorArray = TArray(0)
	-- StaticCreatorArray:Add(self.TriggerBoxStaticCreatorId)
	-- GameMode:TriggerInactiveStaticCreator(StaticCreatorArray)
	-- 清理该特殊任务的所有区域数据
	GameMode:ClearRegionActorData("DynamicQuestId", self.DynamicQuestId, EDestroyReason.QuestChainClear, function(Target, Key, Value)
        return Target.ExtraRegionInfo.DynQuestId == Value
    end)
		--失败时清理STL
		if self.DynamicQuestStory and Result==false then
			GWorld.StoryMgr:StopStoryline(self.DynamicQuestStory)
			self.DynamicQuestStory = nil
		end
end

--------------------触发事件----------------------
function DynamicQuestEvent:OnEnterTriggerBox(TriggerEventId, TriggerBase, EMActorEid)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if not Player then
		return 
	end
	if TriggerEventId == self.TriggerBoxStaticCreatorId and Player.Eid == EMActorEid then
		-- 玩家进入触发
		if self.LeaveTriggerTimerKey and Player:IsExistTimer(self.LeaveTriggerTimerKey) then
			Player:RemoveTimer(self.LeaveTriggerTimerKey)
			self.LeaveTriggerTimerKey = nil
		end
		self:TryActivateEvent()
	end
end

function DynamicQuestEvent:OnLeaveTriggerBox(TriggerEventId, TriggerBase, EMActorEid)
	local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
	if ClientEventUtils:GetCurrentDoingDynamicEvent()~=self then
		return
	end
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if not Player then
		return
	end
	if TriggerEventId == self.FailTriggerBoxID and Player.Eid == EMActorEid then
		local _,LeaveTriggerTimerKey=Player:AddTimer(DataMgr.GlobalConstant.DynTriggerFailTime.ConstantValue,function()
			--local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
				-- 玩家离开触发
				self:TryFinishEvent(false)
				self.LeaveTriggerTimerKey=nil
		end,false,0,"CheckDynamicEventFail")
		self.LeaveTriggerTimerKey=LeaveTriggerTimerKey
	end
end



return DynamicQuestEvent