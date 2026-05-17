local SettingUtils = require "Utils.SettingUtils"

local Component = {}
local SignBoardBubbleTalkController = require "BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkController"
local StoryInteractiveController = require "BluePrints.UI.WBP.StoryInteractive.StoryInteractiveController"
function Component:EnterWorld(...)
	SignBoardBubbleTalkController:Init()
	StoryInteractiveController:Init()
	-- 初始化红点树
	self:InitReddotTrees()
	-- 初始化布局方案
	local PlanCount = self:GetMobileHudPlanCount()
	if PlanCount < 7 then
		for i = 1, 7 - PlanCount do
			local PlanIndex = i + PlanCount
			-- 根据PlanIndex获取默认名称：1,2 -> UI_CustomLayout_DefaultPlanName1; 3,4 -> UI_CustomLayout_DefaultPlanName2; 5,6 -> UI_CustomLayout_DefaultPlanName3
			local DefaultPlanNameKey = nil
			if PlanIndex == 1 or PlanIndex == 2 then
				DefaultPlanNameKey = "UI_CustomLayout_DefaultPlanName1"
			elseif PlanIndex == 3 or PlanIndex == 4 then
				DefaultPlanNameKey = "UI_CustomLayout_DefaultPlanName2"
			elseif PlanIndex == 5 or PlanIndex == 6 then
				DefaultPlanNameKey = "UI_CustomLayout_DefaultPlanName3"
			end
			local DefaultPlanName = DefaultPlanNameKey and GText(DefaultPlanNameKey) or ("Layout_" .. PlanIndex)
			self:AddMobileHudPlan({HudPlanName = DefaultPlanName})
		end
	end
end

function Component:LeaveWorld(...)
	SignBoardBubbleTalkController:Destory()
	StoryInteractiveController:Destory()
end

function Component:InitReddotTrees()
	ReddotManager.AddNodeEx("Setting_Root")
	if SettingUtils.IsShowRedDotForLayoutPlan() then
		ReddotManager.IncreaseLeafNodeCount("Setting_Layout", 1)
	end

	-- 读服务器信息，初始化客服红点
	ReddotManager.ClearLeafNodeCount("Setting_Service")
	local HasCustomerServiceRedDot = self:CheckCustomerServiceRedDot()
	if HasCustomerServiceRedDot then
		ReddotManager.IncreaseLeafNodeCount("Setting_Service", 1)
	end

	-- 初始化二级密码红点
	ReddotManager.ClearLeafNodeCount("Setting_SecPassword")
    local GachaKey = "SecPasswordNew"
    local SecPasswordNewCache = EMCache:Get(GachaKey, true)
	if SecPasswordNewCache == nil then
		ReddotManager.IncreaseLeafNodeCount("Setting_SecPassword", 1)
	end


	-- 初始化移动端hud设置红点
    local IsFirstShow = EMCache:Get("FirstOpenMobileLayoutPlan", true)
	if IsFirstShow == nil then
		EMCache:Set("FirstOpenMobileLayoutPlan", true, true)
		if UIUtils.IsMobileInput() then
			ReddotManager.ClearLeafNodeCount("Setting_Control_Setting_SaveBulletJumpCamAdjustBtn")
			ReddotManager.IncreaseLeafNodeCount("Setting_Control_Setting_SaveBulletJumpCamAdjustBtn", 1)

			ReddotManager.ClearLeafNodeCount("Setting_Control_Setting_SaveAutoBulletJumpCamBtn")
			ReddotManager.IncreaseLeafNodeCount("Setting_Control_Setting_SaveAutoBulletJumpCamBtn", 1)

			ReddotManager.ClearLeafNodeCount("Setting_Control_TrailBtn")
			ReddotManager.IncreaseLeafNodeCount("Setting_Control_TrailBtn", 1)

			ReddotManager.ClearLeafNodeCount("Setting_Control_AddBtn")
			ReddotManager.IncreaseLeafNodeCount("Setting_Control_AddBtn", 1)
		end
	end
end

--初始化游戏设置 例如按键
function Component:InitGameSetting()
	self:CheckActionMappingAdd()
	self:CheckActionMappingWithAvatar()
end

--检查是否有按键映射新增
function Component:CheckActionMappingAdd()
	local InputSetting = UE4.UInputSettings.GetInputSettings()
	local ActionMappings = InputSetting.ActionMappings:ToTable()
	local EngineActionMappings = {}
	local KeyInfo = DataMgr.KeyboardMap
    for k,v in ipairs(ActionMappings) do
        local Res = string.find(v.Key.KeyName,'Gamepad')
        local KeyData = DataMgr.KeyboardMap[v.ActionName]
        if Res == nil and KeyData and KeyData.IsShowInSetting then
            EngineActionMappings[v.ActionName] = v
        end
    end
	local AxisMappings = InputSetting.AxisMappings:ToTable()
    for k,v in ipairs(AxisMappings) do
        local Res = string.find(v.Key.KeyName,'Gamepad')
        local Res2 = string.find(v.AxisName,'Talk')
        if Res2 == nil and Res == nil and DataMgr.AxisName2ActionName[v.AxisName] then
			local Scale = tostring(v.Scale)
			local ActionName = DataMgr.AxisName2ActionName[v.AxisName][Scale]
			if ActionName then
				EngineActionMappings[ActionName] = v
			end
        end
    end
	for Action,Data in pairs(KeyInfo) do
		local EngineAction = EngineActionMappings[Action]
		if EngineAction == nil then
			if Data.AxisActionName then
				local Scale = tonumber(Data.Scale)
				local NewEngineMapping = UE4.FInputAxisKeyMapping()
				NewEngineMapping.Key = UE4.EKeys[Data.Key]
				NewEngineMapping.ActionName = Data.AxisActionName
				NewEngineMapping.Scale = Scale
				InputSetting:AddAxisMapping(NewEngineMapping)
			else
				local NewEngineMapping = UE4.FInputActionKeyMapping()
				NewEngineMapping.Key = UE4.EKeys[Data.Key]
				NewEngineMapping.ActionName = Action
				InputSetting:AddActionMapping(NewEngineMapping)
			end
		end
	end
	InputSetting:SaveKeyMappings()
end

--检查按键映射是否与服务端一致
function Component:CheckActionMappingWithAvatar()
	local InputSetting = UE4.UInputSettings.GetInputSettings()
	local ActionMappings = InputSetting.ActionMappings:ToTable()
	local EngineActionMappings = {}
	local KeyInfo = DataMgr.KeyboardMap
    for k,v in ipairs(ActionMappings) do
        local Res = string.find(v.Key.KeyName,'Gamepad')
        local KeyData = DataMgr.KeyboardMap[v.ActionName]
        if Res == nil and KeyData and KeyData.IsShowInSetting then
            EngineActionMappings[v.ActionName] = v
        end
    end
	local AxisMappings = InputSetting.AxisMappings:ToTable()
    for k,v in ipairs(AxisMappings) do
        local Res = string.find(v.Key.KeyName,'Gamepad')
        local Res2 = string.find(v.AxisName,'Talk')
        if Res2 == nil and Res == nil and DataMgr.AxisName2ActionName[v.AxisName] then
			local Scale = tostring(v.Scale)
			local ActionName = DataMgr.AxisName2ActionName[v.AxisName][Scale]
			if ActionName then
            	EngineActionMappings[ActionName] = v
			end
        end
    end
    local AddActionList = {}
	if self.ActionMapping:Length() == 0 then
		for Action,Data in pairs(KeyInfo) do
			local EngineAction = EngineActionMappings[Action]
			if Data.CanChanged then
				if Data.AxisActionName then
					if EngineAction and EngineAction.Key.KeyName ~= Data.Key then
						local NewKey = UE4.EKeys[Data.Key]
						if NewKey then
							InputSetting:RemoveAxisMapping(EngineAction)
							EngineAction.Key = NewKey
							local Scale = tonumber(Data.Scale)
							EngineAction.Scale = Scale
							table.insert(AddActionList,EngineAction)
						end
					end
				else
					if EngineAction and EngineAction.Key.KeyName ~= Data.Key then
						InputSetting:RemoveActionMapping(EngineAction)
						local NewKey = UE4.EKeys[Data.Key]
						if NewKey then
							EngineAction.Key = NewKey
							InputSetting:AddActionMapping(EngineAction)
						end
					end
				end
			end
		end
	else
		for Action,Key in pairs(self.ActionMapping) do
			local EngineAction = EngineActionMappings[Action]
			local ActionInfo = DataMgr.KeyboardMap[Action]
            if ActionInfo and ActionInfo.AxisActionName then
				if EngineAction and EngineAction.Key.KeyName ~= Key then
					local NewKey = UE4.EKeys[Key]
					if NewKey then
						InputSetting:RemoveAxisMapping(EngineAction)
						EngineAction.Key = NewKey
						local Scale = tonumber(ActionInfo.Scale)
						EngineAction.Scale = Scale
						table.insert(AddActionList,EngineAction)
					end
				end
			else
				if EngineAction and EngineAction.Key.KeyName ~= Key then
					InputSetting:RemoveActionMapping(EngineAction)
					local NewKey = UE4.EKeys[Key]
					if NewKey then
						EngineAction.Key = NewKey
						InputSetting:AddActionMapping(EngineAction)
					end
				end
			end
		end
	end
    for _,value in pairs(AddActionList) do
        InputSetting:AddAxisMapping(value)
    end
	InputSetting:SaveKeyMappings()
end

function Component:UpdateSignBoardNpc(SignBoard,NpcId)
	local function callback(Ret)
		self.logger.debug("UpdateSignBoardNpc",Ret,SignBoard,NpcId)
		EventManager:FireEvent(EventID.UpdateSignBoardNpc,Ret,SignBoard,NpcId)
	end
	self:CallServer("UpdateSignBoardNpc",callback,SignBoard,NpcId)
end

function Component:UpdateActionMapping(ActionMapping)
	local function callback(Ret)
		self.logger.debug("UpdateActionMapping",Ret,ActionMapping)
		EventManager:FireEvent(EventID.OnUpdateActionMapping,Ret,ActionMapping)
	end
	self:CallServer("UpdateActionMapping",callback,ActionMapping)
end

--检测看板娘今天能否进行放置对话，true-可以，false-不行
function Component:CheckSignBoardNpcDailyTalkIsLimit(NpcId)
	if not NpcId or not DataMgr.Npc[NpcId] then
		return false
	end
	local NpcInfo = DataMgr.Npc[NpcId]
	local CharId = NpcInfo.CharId
	if not CharId or not self.CommonChars[CharId] then
		return false
	end
	local CommonChar = self.CommonChars[CharId]
	if CommonChar.DailySignBoardNpcTalkCount >= DataMgr.GlobalConstant.IndividualLongIdleTalkTimes.ConstantValue then
		return false
	end
	if self.TotalSignBoardNpcDailyTalkCount >= DataMgr.GlobalConstant.LongIdleTalkTimes.ConstantValue then
		return false
	end
	return true
end

--触发看板娘放置对话计数
function Component:TriggerAddSignBoardNpcDailyTalk(NpcId, callback)
	self.logger.debug("TriggerAddSignBoardNpcDailyTalk Begin", NpcId)
	local function Callback(Ret)
		self.logger.debug("TriggerAddSignBoardNpcDailyTalk Callback", NpcId,Ret)
		if callback then
			callback(Ret == ErrorCode.RET_SUCCESS)
		end
	end
	self:CallServer("TriggerAddSignBoardNpcDailyTalk", Callback, NpcId)
end

--检测看板娘对话是否已记录，true-已记录，false-未记录
function Component:CheckSignBoardNpcTalkIsRecord(NpcId,DialogueId)
	if not NpcId or not DataMgr.Npc[NpcId] then
		return false
	end
	local DialogueInfo = DataMgr.Dialogue_TextMapContent[DialogueId]
    if not DialogueInfo or not DialogueInfo.SpeakNpcId then
		return false
	end
	local SpeakNpcId = DialogueInfo.SpeakNpcId
	if SpeakNpcId ~= NpcId then
		return false
	end
	local NpcInfo = DataMgr.Npc[NpcId]
	local CharId = NpcInfo.CharId
	if not CharId or not self.CommonChars[CharId] then
		return false
	end
	local CommonChar = self.CommonChars[CharId]
	if CommonUtils.HasValue(CommonChar.SignBoardNpcAlreadyTalkList,DialogueId) then
		return true
	end
	return false
end

--- 看板娘对话是否有效
function Component:CheckSignBoardNpcTalkValid(NpcId, DialogueId)
	if not NpcId or not DataMgr.Npc[NpcId] then
		return false
	end
	local DialogueInfo = DataMgr.Dialogue[DialogueId]
    if not DialogueInfo or not DialogueInfo.SpeakNpcId then
		return false
	end
	if not DialogueInfo or not DialogueInfo.SpeakNpcId then
		return false
	end
	if DialogueInfo.SpeakNpcId ~= NpcId then
		return false
	end
	return true
end

--触发记录看板娘对话
function Component:TriggerRecordSignBoardNpcTalk(NpcId,DialogueId)
	self.logger.debug("TriggerRecordSignBoardNpcTalk Begin", NpcId,DialogueId)
	local function Callback(Ret)
		self.logger.debug("TriggerRecordSignBoardNpcTalk Callback", NpcId,DialogueId,Ret)
	end
	self:CallServer("TriggerRecordSignBoardNpcTalk", Callback, NpcId,DialogueId)
end

--region 移动端Hud布局相关
--获取生效的布局方案下标
function Component:GetCurrentMobileHudPlanIndex()
	return self.CurrentMobileHudPlan
end

--获取布局方案,PlanIndex不传默认获取当前生效的方案
function Component:GetMobileHudPlan(PlanIndex)
	local Index = PlanIndex or self.CurrentMobileHudPlan
	local Plan = self.MobileHudPlans[Index]
	if not Plan then
		return nil
	end
	return SerializeUtils:UnSerialize(Plan)
end

--获取布局方案数
function Component:GetMobileHudPlanCount()
	return self.MobileHudPlans:Length()
end

--切换生效的布局方案
function Component:SwitchMobileHudPlan(NewPlanIndex)
	self.logger.debug("SwitchMobileHudPlan Begin",self.CurrentMobileHudPlan,NewPlanIndex)
	
	local function Callback(Ret)
		self.logger.debug("SwitchMobileHudPlan Callback",Ret,self.CurrentMobileHudPlan,NewPlanIndex)
	end
	self:CallServer("SwitchMobileHudPlan",Callback,NewPlanIndex)
end

--更新某套布局方案
function Component:UpdateMobileHudPlan(PlanIndex,PlanInfo,IsChangeName)
	self.logger.debug("UpdateMobileHudPlan Begin",PlanIndex)
	local function Callback(Ret)
		EventManager:FireEvent(EventID.OnMobileHudPlanChanged, "Update", PlanIndex,PlanInfo,IsChangeName)
		self.logger.debug("UpdateMobileHudPlan Callback",Ret,PlanIndex)
	end
	self:CallServer("UpdateMobileHudPlan",Callback,PlanIndex,PlanInfo)
end

--根据NewPlanIndex的奇偶性，记录到方案1或方案2（1,3,5->方案1; 2,4,6->方案2）
function Component:RecordLayoutIndexToMappedPlan(NewPlanIndex)
	-- 判断NewPlanIndex是奇数还是偶数，映射到方案1或方案2
	local MappedPlanIndex = ((NewPlanIndex - 1) % 2) + 1  -- 1,3,5->1; 2,4,6->2

	-- 先获取现有方案数据
	local ExistingPlan = self:GetMobileHudPlan(MappedPlanIndex) or {}

	-- 更新方案数据，添加NewPlanIndex
	local UpdatedPlan = {}
	for k, v in pairs(ExistingPlan) do
		UpdatedPlan[k] = v
	end
	UpdatedPlan.CurrentLayout = NewPlanIndex

	self.logger.debug("RecordLayoutIndexToMappedPlan Begin",MappedPlanIndex,"NewPlanIndex",NewPlanIndex)
	local function Callback(Ret)
		self.logger.debug("RecordLayoutIndexToMappedPlan Callback",Ret,MappedPlanIndex,"NewPlanIndex",NewPlanIndex)
	end
	self:CallServer("UpdateMobileHudPlan",Callback,MappedPlanIndex,UpdatedPlan)
end

--获取方案1和方案2中记录的当前布局值
--@return: Plan1CurrentLayout, Plan2CurrentLayout 方案1和方案2中记录的当前布局值
function Component:GetMappedPlanCurrentLayout()
	local Plan1 = self:GetMobileHudPlan(1)
	local Plan2 = self:GetMobileHudPlan(2)
	local Plan1CurrentLayout = Plan1 and Plan1.CurrentLayout or 1
	local Plan2CurrentLayout = Plan2 and Plan2.CurrentLayout or 2
	return Plan1CurrentLayout, Plan2CurrentLayout
end

--新增一套布局方案
function Component:AddMobileHudPlan(PlanInfo)
	self.logger.debug("AddMobileHudPlan Begin")
	local function Callback(Ret)
		self.logger.debug("AddMobileHudPlan Callback",Ret)
	end
	self:CallServer("AddMobileHudPlan",Callback,PlanInfo)
end

--移除某套布局方案
function Component:RemoveMobileHudPlan(PlanIndex)
	self.logger.debug("RemoveMobileHudPlan Begin",self.CurrentMobileHudPlan,PlanIndex)
	local function Callback(Ret)
		self.logger.debug("RemoveMobileHudPlan Callback",Ret,PlanIndex)
	end
	self:CallServer("RemoveMobileHudPlan",Callback,PlanIndex)
end

--初始化布局方案
function Component:InitMobileHudPlan(PlanIndex)
	self.logger.debug("InitMobileHudPlan Begin",self.CurrentMobileHudPlan,PlanIndex)
	local function Callback(Ret)
		self.logger.debug("InitMobileHudPlan Callback",Ret,PlanIndex)
	end
	self:CallServer("InitMobileHudPlan",Callback,PlanIndex)
end
--endregion

--region begin 客服红点相关
--收到客服红点
function Component:OnReceiveCustomerServiceRedDot()
	self.logger.debug("OnReceiveCustomerServiceRedDot",self.DataStatistics["CustomerServiceRedDot"])
	ReddotManager.IncreaseLeafNodeCount("Setting_Service", 1)
end

--清除客服红点
function Component:ClearCustomerServiceRedDot()
	self.logger.debug("ClearCustomerServiceRedDot Begin",self.DataStatistics["CustomerServiceRedDot"])
	local function Callback(Ret)
		self.logger.debug("ClearCustomerServiceRedDot Callback",Ret,self.DataStatistics["CustomerServiceRedDot"])
	end
	self:CallServer("ClearCustomerServiceRedDot",Callback)
end

--检查客服红点
function Component:CheckCustomerServiceRedDot()
	if self.DataStatistics["CustomerServiceRedDot"] then
		return true
	end
	return false
end
--endregion

--region begin STL发奖相关
--获取STL奖励
function Component:GetInteractTriggerReward(InteractTriggerId)
	self.logger.debug("GetInteractTriggerReward Begin",InteractTriggerId,self.InteractTriggerRewardRecords[InteractTriggerId])
	local function Callback(Ret, Rewards)
		self.logger.debug("GetInteractTriggerReward Callback",Ret,InteractTriggerId)
		if (ErrorCode:Check(Ret)) then
			UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, self, false)
		end
	end
	self:CallServer("GetInteractTriggerReward",Callback,InteractTriggerId)
end

--检查STL是否已领奖，true-已领奖，false-未领奖
function Component:CheckInteractTriggerRewardIsGot(InteractTriggerId)
	if self.InteractTriggerRewardRecords and self.InteractTriggerRewardRecords[InteractTriggerId] then
		return true
	end
	return false
end
--endregion

return Component
