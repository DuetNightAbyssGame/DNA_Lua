

local SpecialQuestEvent = Class('BluePrints.Common.ClientEvent.SpecialQuestEvent')
local DynamicQuestEvent = Class('BluePrints.Common.ClientEvent.DynamicQuestEvent')
local TimeUtils = require "Utils.TimeUtils"
local ClientEventUtils = {
    CurrentActiveDynamicEvent={},
	CurrentDoingDynamicEvent=nil,

	SpecialQuestEvents = {},
	CurrentEvent = nil,
}

function ClientEventUtils:GetCurrentEvent()
	return self.CurrentEvent
end

function ClientEventUtils:StartSpecialQuestEvent(...)
	local SpecialQuestId = ...
	if self.CurrentEvent then
		DebugPrint("特殊任务中开始另一特殊任务"..SpecialQuestId)
		return
		-- GWorld.logger.error("")
		-- self.CurrentEvent:Destroy()
	end
	if self.SpecialQuestEvents[SpecialQuestId] then
		DebugPrint("重复开始相同的特殊任务"..SpecialQuestId)
		return
	end

	local SpecialEvent = SpecialQuestEvent(...)
	self.SpecialQuestEvents[SpecialQuestId] = SpecialEvent
	SpecialEvent:StartEvent()
end

function ClientEventUtils:SetCurrentEvent(SpecialEvent)
	self.CurrentEvent = SpecialEvent
end

function ClientEventUtils:ClearSpecailQuestEvent(SpecialQuestId)
	local SpecialEvent = self.SpecialQuestEvents[SpecialQuestId]
	if SpecialEvent then
		if self.CurrentEvent and self.CurrentEvent.SpecialQuestId == SpecialQuestId then
			self.CurrentEvent = nil
		end
		self.SpecialQuestEvents[SpecialQuestId] = nil
	end
end

function ClientEventUtils:TryInterruptSpecialQuestEvent(SpecialQuestId, Reason)
	local SpecialEvent = self.SpecialQuestEvents[SpecialQuestId]
	if SpecialEvent then
		SpecialEvent:InterruptSpecialQuestEvent(Reason)
	end
end

function ClientEventUtils:GetCurrentActiveDynamicEvent(DynQuestId)
	if DynQuestId then
	for _, value in pairs(self.CurrentActiveDynamicEvent) do
		if value.DynamicQuestId==DynQuestId then
			return value
		end
	end
	else
		return self.CurrentActiveDynamicEvent
	end
end

function ClientEventUtils:StartDynamicEvent(...)
	local DynamicQuestId=...
	-- if self.CurrentActiveDynamicEvent then
	-- 	-- GWorld.logger.error("")
	-- 	self.CurrentActiveDynamicEvent:Destroy()
	-- end
	local DynamicQuestConfig=DataMgr.DynQuest[DynamicQuestId]
	--assert(DynamicQuestConfig, "找不到动态任务编号:【" .. tostring(DynamicQuestId) .. "】")
	if not DynamicQuestConfig then
		DebugPrint("找不到动态任务编号:【" .. tostring(DynamicQuestId) .. "】")
		return
	end
	local Avatar = GWorld:GetAvatar()
	local SubRegionId=Avatar:GetCurrentRegionId()
	local RegionId=Avatar:GetSubRegionId2RegionId(SubRegionId)
	if Avatar and RegionId==DynamicQuestConfig.RegionId then
		DebugPrint("[动态事件]动态事件Id"..tostring(DynamicQuestId).."解锁 "..TimeUtils.TimeToHMSStr())
		local DynamicEvent= DynamicQuestEvent(...)
		table.insert(self.CurrentActiveDynamicEvent,DynamicEvent)
		DynamicEvent:StartEvent()
	end
end

function ClientEventUtils:SetCurrentDoingDynamicEvent(DynQuestEvent)
	if self.CurrentDoingDynamicEvent then
		if DynQuestEvent==self.CurrentDoingDynamicEvent then
			DebugPrint("重复开始相同的动态任务"..TimeUtils.TimeToHMSStr())
			return
		end
		self.CurrentDoingDynamicEvent:Destroy()
	end
	self.CurrentDoingDynamicEvent=DynQuestEvent
end

function ClientEventUtils:GetCurrentDoingDynamicEvent()

	return self.CurrentDoingDynamicEvent
end

function ClientEventUtils:ClearCurrentActiveDynamicEvent(DynQuestId)
	for pos, value in pairs(self.CurrentActiveDynamicEvent) do
		if value.DynamicQuestId==DynQuestId then
			table.remove(self.CurrentActiveDynamicEvent, pos)
			return
		end
	end
end

function ClientEventUtils:PlayTaskBarAnimIn()
	local TaskBar=self:GetMainTaskBar()
	if TaskBar then
		TaskBar:PlayAnimation(TaskBar.DynamicEvent_In)
		TaskBar.Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
			TaskBar:PlayAnimation(TaskBar.Tooltip_In)
		end
	end
end

function ClientEventUtils:GetMainTaskBar()
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

function ClientEventUtils:TryPlayDelayedDynEventAnim()
	local DynEventUI=self:GetDynEventUI()
	if DynEventUI then
		if DynEventUI.DelayFailAnim  then
			DynEventUI:PlayFailAnim(GText("UI_DYNQUEST_FAIL"),self.PlayTaskBarAnimIn)
			DynEventUI.DelayFailAnim=false
		elseif DynEventUI.DelaySuccessAnim then
			DynEventUI:PlaySuccessAnim(GText("UI_DYNQUEST_SUCCESS"),self.PlayTaskBarAnimIn)
			DynEventUI.DelaySuccessAnim=false
		end
	end
end

function ClientEventUtils:ClearAllActiveDynamicEvent()
	for _, value in pairs(self.CurrentActiveDynamicEvent) do
		value:Destroy(false)
		--table.remove(self.CurrentActiveDynamicEvent, pos)
	end
	self.CurrentActiveDynamicEvent={}
end

function ClientEventUtils:ClearCurrentDoingDynamicEvent(FinishEvent,ForbidAnim)
	if self.CurrentDoingDynamicEvent then
		if FinishEvent then
		self.CurrentDoingDynamicEvent:TryFinishEvent(false,function ()
			self.CurrentDoingDynamicEvent=nil
		end,nil,nil,ForbidAnim)
		else
			self.CurrentDoingDynamicEvent=nil
		end
	end
end

function ClientEventUtils:CheckDynamicEventStarted(DynQuestId)
	for _, value in pairs(self.CurrentActiveDynamicEvent) do
		if value.DynamicQuestId==DynQuestId then
			return true
		end
	end
	return false
end

function ClientEventUtils:ShowDynEventUI(DynEvent)
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local BattleMain = UIManager:GetUIObj("BattleMain")
	if BattleMain then
		local DynamicEventUI=BattleMain:GetOrAddDynamicEventWidget()
		if DynamicEventUI then
			DynamicEventUI:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
			DynamicEventUI:SetEventInfo(DynEvent.DynamicQuestConfig.DynName,nil)
			local Avatar = GWorld:GetAvatar()
			if DynEvent.DynQuest and Avatar and Avatar:CheckDynamicQuestIsFirstTrigger(DynEvent.DynQuest.DynamicQuestId) then
				DynamicEventUI:PlayFirstInAnim(GText("UI_DYNQUEST"))
			else
				DynamicEventUI:PlayInAnim(GText("UI_DYNQUEST"))
			end
		end
	end
end


function ClientEventUtils:GetDynEventUI(NotCreate)
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local BattleMain = UIManager:GetUIObj("BattleMain")
	if BattleMain then
		local DynamicEventUI
		if NotCreate then
			DynamicEventUI=BattleMain:GetDynamicEventWidget()
		else
			DynamicEventUI=BattleMain:GetOrAddDynamicEventWidget()
		end
		return DynamicEventUI
	end
end

function ClientEventUtils:HideDynEventUI()
	-- local UIManager = GWorld.GameInstance:GetGameUIManager()
	-- local BattleMain = UIManager:GetUIObj("BattleMain")
	-- if BattleMain then
	-- 	local DynamicEventUI=BattleMain:GetOrAddDynamicEventWidget()
	-- 	DynamicEventUI:PlayAnimation(DynamicEventUI.Out)
	-- 	DynamicEventUI:BindToAnimationFinished(DynamicEventUI.Out, {DynamicEventUI,function ()
	-- 		DynamicEventUI:SetVisibility(UE4.ESlateVisibility.Collapsed)
	-- 		DynamicEventUI:UnbindAllFromAnimationFinished(DynamicEventUI.Out)
	-- 	end})
	-- end
end

function  ClientEventUtils.GetDynEventInfo(Id)
	local Message=""
    local Avatar = GWorld:GetAvatar()
    if  Avatar then
        local DynamicQuest = Avatar.DynamicQuests
        local function GetState(State)
            if State==0 then
                return "未激活"
            elseif State==1 then
                return "可激活"
            elseif  State==2 then
                return "进行中"
            elseif  State==3 then
                return"已完成"
            elseif State==4 then
                return"失败"
            end
        end
        if DynamicQuest then
           if Id==nil or Id=="" or Id=="nil" then
                Message=Message.."-------------所有动态事件信息--------------\n"
                for _, DynQuest in pairs(DynamicQuest) do
                    Message=Message.."动态事件Id:"..DynQuest.DynamicQuestId.."   "
                    Message=Message.."事件状态:"..GetState(DynQuest.State).."   "
                    Message=Message.."触发概率:"..tostring(DynQuest.Chance).."\n"
                end
           else
                local Exist=false
                for _, DynQuest in pairs(DynamicQuest) do
                    if _==tonumber(Id) then
                    Exist=true
                    local StartTime="无"
                    local EndTime="无"
                    Message=Message.."动态事件Id:".._.."\n"
                    Message=Message.."事件状态:"..GetState(DynQuest.State)..'\n'
                    if DynQuest.StartTime >0 then StartTime=TimeUtils.TimeToStr(DynQuest.StartTime) end
                    Message=Message.."开始时间:"..StartTime.."\n"
                    if DynQuest.StartTime >0 then EndTime=TimeUtils.TimeToStr(DynQuest.LastEndTime) end
                    Message=Message.."上一次结束时间:"..EndTime.."\n"
                    Message=Message.."已完成次数:"..tostring(DynQuest.AlreadyCompleteTimes).."\n"
                    Message=Message.."触发概率:"..tostring(DynQuest.Chance).."\n"
                    end
                end
                if not Exist then
                    Message=Message.."无Id为"..tostring(Id).."的动态事件\n"
                end
            end
            Message=Message.."-------------客户端动态事件信息--------------\n"
            local CurrentDoing=ClientEventUtils:GetCurrentDoingDynamicEvent()
            if CurrentDoing then
                Message=Message.."当前进行的动态事件ID："..tostring(CurrentDoing.DynamicQuestId)..'\n'
            else
                Message=Message.."无正在进行的动态事件\n"
            end
            local ActiveEvent=ClientEventUtils:GetCurrentActiveDynamicEvent()
            if ActiveEvent and #ActiveEvent~=0 then
                Message=Message.."当前已经激活Trigger的动态事件ID："
                for _, Event in pairs(ActiveEvent) do
                    Message=Message..tostring(Event.DynamicQuestId)..' '
                end
            else
                Message=Message.."没有已经激活Trigger的动态事件"
            end
        else
            Message=Message.."无动态事件"
        end
    else
        Message=Message.."无Avatar"
    end
	return Message
end

return ClientEventUtils