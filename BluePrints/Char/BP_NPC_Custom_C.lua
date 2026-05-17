require "UnLua"
--
--

---@type BP_NPC_Custom_C
local M = Class()

function M:ReceiveBeginPlay()
	local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
	if PlatformName == "Android" or PlatformName == "IOS" then
		self.bMeshLodBudgetEnable = true
	else
		self.bMeshLodBudgetEnable = false
	end
	
	self.bHiddenBudgetEnable = true
	
--    DebugPrint("@@@ Custom NPC begin play ...")
    self.IsNPC = true
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance then
        local TalkContext = GameInstance:GetTalkContext()
        if IsValid(TalkContext) then
        	TalkContext:RecordCustomNPCInfo(self, true)
        end
    end

	local GameState = UE4.UGameplayStatics.GetGameState(self)
	GameState.CustomNpcSet:Add(self)
	GameState:RecordNpcEntity(self, true)--Todo 删除
    EventManager:AddEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, self, self.SetCustomNpcFlexibShowOrHide)
    self:SetCustomNpcFlexibShowOrHide()
	EventManager:AddEvent(EventID.CloseLoading, self, self.ResetLocation)
	self.IsDestroied = false
	self.Overridden.ReceiveBeginPlay(self)
end

function M:ResetLocation()
	if self.bInteractiveState == false then
		return
	end
	local SpawnPos = self:K2_GetActorLocation()
	local HalfHeight = self.CapsuleComponent:GetScaledCapsuleHalfHeight()
	local MeshOffsetZ = -self.Mesh.RelativeLocation.Z
    if MeshOffsetZ > HalfHeight and MeshOffsetZ < HalfHeight + 5 then
        HalfHeight = MeshOffsetZ
    end
	local Start = SpawnPos+ FVector(0,0,HalfHeight)
	local End = SpawnPos + FVector(0,0,-500)
	local HitResult = FHitResult()
	local Ret = UE4.UKismetSystemLibrary.LineTraceSingle(self, Start, End, ETraceTypeQuery.TraceScene, true, nil, 0, HitResult, true)
	if(Ret) then
		DebugPrint("CustomNPC半高：",HalfHeight,"打中位置：",HitResult.ImpactPoint,"打中目标：",HitResult.Actor:GetName(),"Pawn名字：",self:GetName(),"============sssss================")
		local SurfacePos = FVector(HitResult.ImpactPoint.X,HitResult.ImpactPoint.Y,HitResult.ImpactPoint.Z + HalfHeight)
		self:K2_SetActorLocation(SurfacePos, false, nil, false)
		if math.abs(HitResult.ImpactPoint.Z - SpawnPos.Z) > HalfHeight * 2 then
            Utils.ScreenPrint("CustomNPC静态刷新点位置异常,Pawn名字：" .. self:GetName() .. " SpawnPos.Z："  .. SpawnPos.Z .. " ImpactPoint.Z:" .. HitResult.ImpactPoint.Z)
        end
	end
end

function M:ReceiveEndPlay()
--   DebugPrint("@@@ Custom NPC end play ...")
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance then
        local TalkContext = GameInstance:GetTalkContext()
        if IsValid(TalkContext) then
        	TalkContext:RemoveCustomNPCInfo(self)
        end
    end

	local GameState = UE4.UGameplayStatics.GetGameState(self)
	GameState.CustomNpcSet:Remove(self)
	GameState:RecordNpcEntity(self, false)--Todo 删除
	EventManager:RemoveEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, self)
	EventManager:RemoveEvent(EventID.CloseLoading, self)
	self.IsDestroied = true
	self:DeInitLightBubbleTalk()
end

function M:SetCustomNpcFlexibShowOrHide()
    local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	local TempFlexibleMap = {}
	-- local function MakeTempFlexibleMap() --构建倒序的Map
	-- 	local NewFlexibleMap = {}
	-- 	local FNpcArrayNum = self.FlexibleShowHide:Num()
	-- 	for FNpcArray, IsHide in pairs(self.FlexibleShowHide) do
	-- 		local NewFlexibleMapElement = {
	-- 			NpcArray = {
	-- 				Quest = nil,
	-- 				ImpressionTalk = nil
	-- 			},
	-- 			IsHide = false
	-- 		}
	-- 		NewFlexibleMapElement.NpcArray = FNpcArray
	-- 		NewFlexibleMapElement.IsHide = IsHide
	-- 		NewFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
	-- 		FNpcArrayNum = FNpcArrayNum - 1
	-- 	end
	-- 	return NewFlexibleMap
	-- end
	-- TempFlexibleMap = MakeTempFlexibleMap()
	local FNpcArrayNum = self.FlexibleShowHide:Num()
	for FNpcArray, IsHide in pairs(self.FlexibleShowHide) do
		local NewFlexibleMapElement = {
			NpcArray = {
				Quest = nil,
				ImpressionTalk = nil
			},
			IsHide = false
		}
		NewFlexibleMapElement.NpcArray = FNpcArray
		NewFlexibleMapElement.IsHide = IsHide
		TempFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
		FNpcArrayNum = FNpcArrayNum - 1
	end

	local function SetNpcShowOrHide(IsShow)
		if IsShow then
			self:SetCustomNpcHideTag("Flexible", false)
			self:SetCollisionDisableTag("Flexible", false)
		else
			self:SetCustomNpcHideTag("Flexible", true)
			self:SetCollisionDisableTag("Flexible", true)

		end
	end

	for i = 1, self.FlexibleShowHide:Num(), 1 do
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
				DebugPrint("QuestChain is unexist:", QuestChainId)
				goto continue
			end
			local QuestChains = Avatar.QuestChains[QuestChainId]

			if TargetQuestState == QuestStateType.Doing and QuestChains.DoingQuestId == TargetQuestId then --任务在进行中
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			elseif TargetQuestState == QuestStateType.Success then --任务已完成
				if QuestChains:CheckQuestIdComplete(TargetQuestId) then
					SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
					return
				end
			else
				--其他类型暂不处理
				DebugPrint("QuestChain state is error:", QuestChainId)
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
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.UnCompelete then
				if Avatar:IsStorylineUnComplete(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.CheckSuccess then
				if Avatar:IsStorylineSuccess(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.CheckFail then
				if Avatar:IsStorylineFailure(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
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
				DebugPrint("QuestChain is unexist:", FlexibleQuestChainId)
				goto continue
			end
			local TargetQuestChain = Avatar.QuestChains[FlexibleQuestChainId]

			if FlexibleQuestChainState == QuestChainStateType.Doing and TargetQuestChain:IsDoing() then --任务在进行中
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			elseif FlexibleQuestChainState == QuestChainStateType.Success and TargetQuestChain:IsFinish() then --任务已完成
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			else
				--其他类型暂不处理
				DebugPrint("QuestChain state is error:", FlexibleQuestChainId)
			end
		end
		::continue::
	end
end

function M:ActiveSetCustomNpcHideByAvatarSuitData()
	if self.AtmosphereTagArray:Num() == 0 then
		return
	end

	local Avatar = GWorld:GetAvatar()
	if Avatar then
		local SuitData = Avatar.Suits:GetSuitBase(CommonConst.SuitType.PlayerCharacterSuit)
		if SuitData and SuitData:GetSubSuitBase(CommonConst.PlayerCharacterSuit.NpcHideShowTag) then
			local SubSuitData = SuitData:GetSubSuitBase(CommonConst.PlayerCharacterSuit.NpcHideShowTag)
			for Tag, Value in pairs(SubSuitData) do
				if self.AtmosphereTagArray:Contains(Tag) then
					self:SetCustomNpcHideTag(Tag, Value)
					self:SetCollisionDisableTag(Tag, Value)
				end
			end
		end
	end
end

function M:InitHeadWidgetComponent()
    if IsValid(self.HeadWidgetComponent) then
        return
    end

    local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
    if not HeadUISubsystem then return end
    self.HeadWidgetComponent = HeadUISubsystem:InitHeadWidgetComponent(self)
end

function M:EnableHeadWidget(WidgetName, bEnable, ...)
	if bEnable then
    	self:InitHeadWidgetComponent()
	end
    if IsValid(self.HeadWidgetComponent) then
        if bEnable then
			if self.HeadWidgetComponent:NeedForceInit() then
				self.HeadWidgetComponent:AdjustSelfTransform()
			end
            self.HeadWidgetComponent:EnableWidget(WidgetName, ...)
        else
            self.HeadWidgetComponent:DisableWidget(WidgetName, ...)
        end
    end
end

function M:EnableBubbleWidget(bEnable, Content)
	self:EnableHeadWidget("Long_Bubble", bEnable, Content)
end

function M:EnableNameWidget(bEnable, Name)
	self:EnableHeadWidget("Name", bEnable, GText(Name))
end

return M
