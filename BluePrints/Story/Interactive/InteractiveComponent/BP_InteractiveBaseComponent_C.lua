--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"

local EMCache = require "EMCache.EMCache"

---@type BP_InteractiveBaseComponent_C 
local BP_InteractiveBaseComponent_C = Class()

--function BP_InteractiveBaseComponent_C:Initialize(Initializer)
--end
local InteractiveTypeEnum = {
	Default = 0,
	Quest = 1,
	PickUpAll = 3,
}

function BP_InteractiveBaseComponent_C:ReceiveBeginPlay()
	self.Priority = "Normal"
	-- self.IsBtnDisplayMap = {}
	self.Owner = self:GetOwner()
	if self.CommonUIConfirmID then
		self:InitCommonUIConfirmID(self.CommonUIConfirmID)
	end
end

--function BP_InteractiveBaseComponent_C:ReceiveEndPlay()
--end

-- function BP_InteractiveBaseComponent_C:ReceiveTick(DeltaSeconds)
-- end

function BP_InteractiveBaseComponent_C:SetInteractiveName(Name)
	self.InteractiveName = Name
	self.DisplayInteractiveName = GText(Name)
	if self.DisplayInteractiveName == "" then
		self.DisplayInteractiveName = Name
	end
end

-- function BP_InteractiveBaseComponent_C:TriggerEnter(PlayerActor)
-- 	self.bEnter = true
-- end

-- function BP_InteractiveBaseComponent_C:TriggerTick(PlayerActor)
-- 	self:UpdateDisplayInteractiveBtn(PlayerActor)
-- end

-- function BP_InteractiveBaseComponent_C:TriggerExit(PlayerActor)
-- 	self.bEnter = false
-- 	if self:IsBtnDisplayed(PlayerActor) then
-- 		self:NotDisplayInteractiveBtn(PlayerActor)
-- 	end
-- end


-- function BP_InteractiveBaseComponent_C:IsCanInteractive(PlayerActor)
-- 	return true
-- end

-- function BP_InteractiveBaseComponent_C:IsBlockByScene(PlayerActor)
-- 	HitResult = FHitResult()
-- 	local CenterPos = PlayerActor:K2_GetActorLocation()
--     local HeadPos = CenterPos + FVector(0,0,PlayerActor.OriginHalfHeight)
-- 	local FootPos = CenterPos - FVector(0,0,PlayerActor.OriginHalfHeight)
--     local EndPos
-- 	if self:GetOwner().Box then
-- 		EndPos= self:GetOwner().Box:K2_GetComponentLocation()
-- 	else
-- 		EndPos= self:GetOwner():K2_GetActorLocation()
-- 	end
--     local bCenterHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, CenterPos, EndPos, ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
-- 	local bHeadHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, HeadPos, EndPos, ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
-- 	local bFootHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, FootPos, EndPos, ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
-- 	return bCenterHit and bHeadHit and bFootHit
-- end

-- function BP_InteractiveBaseComponent_C:UpdateDisplayInteractiveBtn(PlayerActor)
-- 	local DisplayInteractiveBtnRes = self:IsCanInteractive(PlayerActor)
-- 	if not PlayerActor:IsMainPlayer() then
-- 		return
-- 	end
-- 	if DisplayInteractiveBtnRes and not self:IsBtnDisplayed(PlayerActor) then
-- 		self:DisplayInteractiveBtn(PlayerActor)
-- 	elseif DisplayInteractiveBtnRes and self:IsBtnDisplayed(PlayerActor) then
-- 		self:RefreshInteractiveBtn(PlayerActor)
-- 	elseif DisplayInteractiveBtnRes == false and self:IsBtnDisplayed(PlayerActor) then
-- 		self:NotDisplayInteractiveBtn(PlayerActor)
-- 	end
-- end

function BP_InteractiveBaseComponent_C:DisplayInteractiveBtn(PlayerActor)
	local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
	local InteractiveUI = UIManager:LoadUINew(UIConst.InteractiveUIName)
	if not InteractiveUI then
		return
	end
	DebugPrint("1111111111111111", self:GetName(), self.InteractiveDistance)
	InteractiveUI:AddInteractiveItem(self)
	self:SetBtnDisplayed(PlayerActor, true)
	self:RefreshInteractiveBtn(PlayerActor)
end

function BP_InteractiveBaseComponent_C:RefreshInteractiveBtn(PlayerActor)
	local bChanged, bLocked = self:UpdateLockState()
	if not bLocked and not bChanged then
		bChanged = self:UpdateForbiddenState(PlayerActor)
	end
	if bChanged then
		self:UpdateInteractiveUIState()
	end
end

function BP_InteractiveBaseComponent_C:NotDisplayInteractiveBtn(PlayerActor)
	self:SetBtnDisplayed(PlayerActor, false)
	local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
	local InteractiveUI = UIManager:GetUIObj(UIConst.InteractiveUIName)
	if not InteractiveUI then
		return
	end
	InteractiveUI:RemoveInteractiveItem(self)
end

function  BP_InteractiveBaseComponent_C:OnStartInteractive(PlayerActor, MontageName, MechanismEid, SubFile)
	local Owner = self:GetOwner()
	if not self:CheckCanEnterOrEixt() then
		return
	end
	if PlayerActor and PlayerActor.SetEnterInteractive and MechanismEid ~= 0 then
		local RealSubFile = SubFile or "MechInteractive"
		PlayerActor.WaitCallBack = true
		PlayerActor:SetEnterInteractive(true, MontageName, Owner.InteractiveTag, RealSubFile)
	end
end

function BP_InteractiveBaseComponent_C:OnEndInteractive(PlayerActor, MontageName, MechanismEid, SubFile)
	local Owner = self:GetOwner()
	if not self:CheckCanEnterOrEixt() then 
		return
	end
	if PlayerActor and PlayerActor.SetEnterInteractive then
		local RealSubFile = SubFile or "MechInteractive"
		PlayerActor:SetEnterInteractive(false, MontageName, nil, RealSubFile)
	end
end	

function BP_InteractiveBaseComponent_C:CheckCanEnterOrEixt()
	if not self:GetOwner().UnitId then 
		return false
	end
	local UnitId = self:GetOwner().UnitId
	if not DataMgr.Mechanism[UnitId] and not self:GetOwner():IsMonster() then
		return false
	end
	if not self:GetOwner().MontageName and not self.MontageName then
		return false
	end
	return true
end

--- 根据配置的ID获取Icon，有特殊需求的在子类中重写
function BP_InteractiveBaseComponent_C:GetInteractiveIcon(PlayerActor)
	if self:IsLocked() then
		return "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Lock.T_Interactive_Lock'"
	end
	if self:IsForbidden(PlayerActor) then
		return "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Forbidden.T_Interactive_Forbidden'"
	end
	local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
	if not Data or not Data.Icon then
		return nil
	end
	local UseItemIcon = Data.UseItemIcon
	local Icon = Data.Icon
	local Avatar = GWorld:GetAvatar()
    if(Avatar and Avatar.Sex == 1 and Data.IconFemale ~= nil)then
		Icon = Data.IconFemale
	end
	return Icon, UseItemIcon
    -- local ImageResource = LoadObject(Data.Icon)
    -- return ImageResource
end

--- 根据配置的ID获取显示的名字，没有配置的话会使用DisplayInteractiveName
function BP_InteractiveBaseComponent_C:GetInteractiveName()
	if self.InteractiveName ~= "" then
		local Language = CommonConst.SystemLanguage or CommonConst.SystemLanguages.Default
		local TextMap = DataMgr["TextMap_" .. Language]
		local TextMapData = TextMap[self.InteractiveName]
		if (TextMapData ~= nil) then
			return GText(self.InteractiveName)
		end
	end
	local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
	if not Data then
		return GText(self.InteractiveName)
	end
	return GText(Data.ConfirmText)
end

function BP_InteractiveBaseComponent_C:GetInteractiveCondition()
	local NeedKey, TotalKey = self:GetInteractiveConditionParam()
	if TotalKey <= 0 then
		return nil
	end
	local RealText = NeedKey.."/"..TotalKey
	if NeedKey < TotalKey then
		return "<Warning>"..RealText.."</>"
	else
		return "<Highlight>"..RealText.."</>"
	end
end

function BP_InteractiveBaseComponent_C:GetInteractiveConditionParam()
	local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
	if not Data or not Data.InteractiveCondition then
		return nil, -1
	end
	local InteractiveCondition = Data.InteractiveCondition
	local Condition = DataMgr.Condition[InteractiveCondition]
	if not Condition then
		print(_G.LogTag, "Error: Cant find Condition ", InteractiveCondition, " On Unit", self:GetOwner():GetName())
		return nil, -1
	end
	if not Condition["ConditionMap"]["HaveResource"] then
		return nil, -1
	end

	local NeedKey = Condition["ConditionMap"]["HaveResource"][1][2]
	local Avatar = GWorld:GetAvatar()
    if Avatar then
		NeedKey = Avatar.Resources:QueryResourceCount(Condition["ConditionMap"]["HaveResource"][1][1])
    end
	return NeedKey, Condition["ConditionMap"]["HaveResource"][1][2]
end

function BP_InteractiveBaseComponent_C:GetRarity()
	return 0
end

function BP_InteractiveBaseComponent_C:IsImportant()
	local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
	if not Data then
		return false
	end
	return Data.Important
end

-- function BP_InteractiveBaseComponent_C:IsBtnDisplayed(PlayerActor)
-- 	return self.IsBtnDisplayMap and self.IsBtnDisplayMap[PlayerActor] == true
-- end

-- function BP_InteractiveBaseComponent_C:SetBtnDisplayed(PlayerActor, value)
-- 	if not self.IsBtnDisplayMap then 
-- 		self.IsBtnDisplayMap = {}
-- 	end

-- 	if not value then value = nil end
-- 	self.IsBtnDisplayMap[PlayerActor] = value 
-- end

function BP_InteractiveBaseComponent_C:InitCommonUIConfirmID(CommonUIConfirmID)
	self.CommonUIConfirmID = CommonUIConfirmID
	local Data = DataMgr.CommonUIConfirm[CommonUIConfirmID]
	if not Data then
		return
	end
	self:SetInteractiveDistance(Data.InteractiveRadius or self.InteractiveDistance)
	self.InteractiveAngle = Data.InteractiveAngle or self.InteractiveAngle
	self.InteractiveFaceAngle = Data.PlayerFaceAngle or self.InteractiveFaceAngle
	self.ListPriority = Data.InteractivePriority or 0
end

function BP_InteractiveBaseComponent_C:CheckInteractiveSucc(PlayerEid)
	return self:CheckInteractiveCondition(PlayerEid)
end

function BP_InteractiveBaseComponent_C:CheckInteractiveCondition(PlayerEid)
	local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
	if not Data then
		return true
	end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return true
    end
    local InteractiveCondition = Data.InteractiveCondition
    if not InteractiveCondition then
        return true
    end
    return ConditionUtils.CheckCondition(Avatar, InteractiveCondition)
end

function BP_InteractiveBaseComponent_C:InteractiveFailed()
    local TalkContext = GWorld.GameInstance:GetTalkContext()
    local TalkTriggerId = DataMgr.CommonUIConfirm[self.CommonUIConfirmID].TalkTriggerId
    -- local Player = UGameplayStatics.GetPlayerPawn(self, 0)
	if TalkTriggerId then
        TalkContext:StartTalk(TalkTriggerId)
	-- else
	-- 	local TalkData = DataMgr.CommonUIConfirm[self.CommonUIConfirmID].InteractiveFailDialogue
	-- 	if TalkData and TalkData.TalkId then
	-- 		TalkContext:StartTalk(nil, TalkData.TalkId, TalkData.BranchId, Player, nil)
	-- 	end
	end
    local FailMsg = self:GetOverridenFailMsg()
    FailMsg = FailMsg or DataMgr.CommonUIConfirm[self.CommonUIConfirmID].InteractiveFailMsg
    if FailMsg then
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:ShowUITip(UIConst.Tip_CommonTop, GText(FailMsg))
    end

	-- if Player.MechanismEid ~= 0 then
    -- 	self:EndInteractive(Player)
	-- end
end

function BP_InteractiveBaseComponent_C:CheckPlayerTag(PlayerActor)
	if (IsValid(PlayerActor) == false) then
		return false
	end
	--沒有需要切換的tag就直接返回true
	if not self.InteractiveTag or self.InteractiveTag == "None" then
		return true
	end
    local Owner = self:GetOwner()
    local Res = PlayerActor:CanEnterInteractive() or (Owner.AutoSyncProp ~= nil and Owner.AutoSyncProp.CharacterTag == "Defeated")
    return Res
end

function BP_InteractiveBaseComponent_C:IsForbidden()
	return false
end

function BP_InteractiveBaseComponent_C:OnClicked_Forbidden()
end

function BP_InteractiveBaseComponent_C:IsLocked()
	return false
end

function BP_InteractiveBaseComponent_C:OnClicked_Locked()
end

function BP_InteractiveBaseComponent_C:GetUUID()
	return nil
end

--动态覆盖禁止交互时的提示Pop
function BP_InteractiveBaseComponent_C:GetOverridenFailMsg()
	return self.OverridenFailMsg 
end

--动态覆盖禁止交互时的提示Pop
function BP_InteractiveBaseComponent_C:SetOverridenFailMsg(FailMsg)
	self.OverridenFailMsg = FailMsg
end

function BP_InteractiveBaseComponent_C:UpdateLockState()
	local UUID = self:GetUUID()
	if not UUID then
		return false, false
	end
	local LockStateCache = EMCache:Get("InteractiveLockState", true)

	if not LockStateCache then
		LockStateCache = { { [UUID] = true } }
		EMCache:Set("InteractiveLockState", LockStateCache, true)
	end

	local CurrentLockState = self:IsLocked()
	if CurrentLockState ~= LockStateCache[UUID] then
		if CurrentLockState == false then
			---@type WBP_InteractivePanel_C
			local InteractiveUI = UIManager(self):GetUIObj(UIConst.InteractiveUIName)
			if not InteractiveUI then
				return
			end
			InteractiveUI:PlayItemAnimation(self, "UnLock", true)
		end

		LockStateCache[UUID] = CurrentLockState
		EMCache:Set("InteractiveLockState", LockStateCache, true)
		return true, CurrentLockState
	end
	return false, CurrentLockState
end

function BP_InteractiveBaseComponent_C:UpdateForbiddenState(PlayerActor)
	if self.bForbidden == nil then
		self.bForbidden = self:IsForbidden(PlayerActor)
	else
		local bOldForbidden = self.bForbidden
		self.bForbidden = self:IsForbidden(PlayerActor)
		if self.bForbidden ~= bOldForbidden then
			return true
		end
	end
	return false
end

function BP_InteractiveBaseComponent_C:UpdateInteractiveUIState()
	---@type WBP_InteractivePanel_C
	local InteractiveUI = UIManager(self):GetUIObj(UIConst.InteractiveUIName)
	if not InteractiveUI then
		return
	end
	InteractiveUI:UpdateInteractiveItemState(self)
end

--- @return number
--- nil代表不显示星星
function BP_InteractiveBaseComponent_C:GetStars()
	return nil
end

function BP_InteractiveBaseComponent_C:IsLastingInteract()
	return false
end

-- 是否可以被一键拾取
function BP_InteractiveBaseComponent_C:CanPickUpWithOneClick()
	return false
end

-- 是否需要强调显示
function BP_InteractiveBaseComponent_C:GetShouldHighlight()
	local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
	if not Data or not Data.HighLight then
		return false
	end
	return true
end

function BP_InteractiveBaseComponent_C:GetQuestID()
	return nil
end


function BP_InteractiveBaseComponent_C:GetSpecialQuestID()
	return nil
end

-- 最终权重值 = 大类权重值 + 子权重值
function BP_InteractiveBaseComponent_C:GetInteractivePriority()
	local ConfirmData = DataMgr.CommonUIConfirm[self:GetCommonUIConfirmID()]
	local Type = InteractiveTypeEnum.Default

	local SubPriority = 0
	if ConfirmData and ConfirmData.InteractivePriority then
		SubPriority = ConfirmData.InteractivePriority * 0.1
	end

	if self:GetQuestID() then
		-- 任务相关交互选项，子权重值 通过读取QuestChain 与 QuestTypePriority 来获取
		Type = InteractiveTypeEnum.Quest
		local QusetData = DataMgr.QuestChain[self:GetQuestID()]
		if QusetData and QusetData.QuestChainType then
			local QusetPriorityData = DataMgr.QuestTypePriority[QusetData.QuestChainType]
			if QusetPriorityData and QusetPriorityData.TypePriority then
				SubPriority = QusetPriorityData.TypePriority * 0.1
			end
		end
	elseif ConfirmData and ConfirmData.InteractiveType then
		Type = ConfirmData.InteractiveType
	end

	local FinalPriority = SubPriority
	local TypeData = DataMgr.InteractiveType[Type]
	if TypeData and TypeData.Priority then
		FinalPriority = FinalPriority + TypeData.Priority
	end
	return FinalPriority
end

function BP_InteractiveBaseComponent_C:GetCommonUIConfirmID()
	return self.CommonUIConfirmID
end

function BP_InteractiveBaseComponent_C:GetQuestInteractiveType()
	local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
	if not Data or not Data.Icon then
		return nil
	end
	if Data.QuestInteractiveType then
		return Data.QuestInteractiveType
	end
	return nil
end

-- 获取长按总共所需的时间 若长按时间不确定（血清获取、表现形式为Loop）则传0
function BP_InteractiveBaseComponent_C:GetNeedLongPressTime()
	return 0
end

-- 获取已经长按的进度 重新显示时用以展示当前交互进度
function BP_InteractiveBaseComponent_C:GetLongPressedPercent()
	return 0
end

-- 停止交互时 交互进度从1到0所需时间 若为0则为保存当前交互进度（非交互时不掉进度） 若无特殊需求无需重写
function BP_InteractiveBaseComponent_C:GetReduceTime()
	return 0.1
end

-- 进度类型长按交互选项是否显示剩余交互时间 默认显示
function BP_InteractiveBaseComponent_C:NeedShowRemaindTime()
	return true
end

-- 获取长按中交的互选项文本
function BP_InteractiveBaseComponent_C:GetLongPressingText()
	return self:GetInteractiveName()
end

-- 获取消耗资产的 ID 及 数量
-- @return table
-- @field IconPath string 图标路径
-- @field CostNum number 资产数量
-- @field PossessNum number 拥有的资产数量
-- @field ConsumeTextKey string|nil 消耗说明文案的本地化 key（有值时显示 Text_Consume）
function BP_InteractiveBaseComponent_C:GetCostItemInfo()
	return nil
	-- local CostItemInfo = {
	-- 	IconPath = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Coin_Main_Lv3.T_Coin_Main_Lv3",
	-- 	CostNum = 10000,
	-- 	PossessNum = 1000,
	-- 	ConsumeTextKey = "UI_Interactive_Consume_Tips",
	-- }
	-- return CostItemInfo
end

return BP_InteractiveBaseComponent_C
