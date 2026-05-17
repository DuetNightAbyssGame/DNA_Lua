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
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"

local WBP_TaskIndicatorUI_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_TaskIndicatorUI_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.TargetPointPos = nil
    self.HelperCoefficient = 80
    self.OverrideNpcHelperCoefficient = 40      -- 仅针对NPC单独重载的指引点高度
    self.CenterPos = nil
    self.GuideInfoCache = GWorld:GetAvatar() and EMCache:Get("GuideInfoCache", true) or {} -- { [ChiandId] = {PointType, PointName, AreaName, IsNeedHide}}
    self.BranchGuideInfoCache = {}
    self.CurGuideChainId = nil
    self.CurGuideChainQuestId = nil
    --指引逻辑逐步迁移到 Storyline
    self.TargetPointType = nil
    self.TargetPointName = nil
    self.TargetAreaName = nil
    self.IsNeedChangeSmartGuideStyle = true
    self.IsShowSmartPointStyle = false
    self.BelongToQuestChainId = 0
    self.IsRangeOrPoint = false
    self.IsInTaskRegion = false
    self.NpcIndicatorPreVisibility = 0
    self.STLIndicatorType = nil
    self.ShowQuestHintFlag = false
    self.AvatarTrackingId = 0
end

function WBP_TaskIndicatorUI_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:OnLoadedInit()
    self:OnLoadedTaskIndicator()
    self:ListenForInputAction("ActiveGuide", EInputEvent.IE_Pressed, false, {self, self.RePlayAppearAnim})
    self:ListenForInputAction("ActiveGuide", EInputEvent.IE_Pressed, false, {self, self.CreateAndMoveFollowingPath})
    self:PlayAppearAnim()
    local IndicatorType, PointKey, MapKey, InNode, GuideTag = nil, nil, nil, nil, nil
    IndicatorType, PointKey, MapKey, InNode, GuideTag = ...
    self:SetGuideInfo(IndicatorType, PointKey, MapKey, InNode, GuideTag)
    if not MissionIndicatorManager.bTriggerCollapsAll then
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- function WBP_TaskIndicatorUI_C:SetVisibility(Visibility)
--     self.Overridden.SetVisibility(self, Visibility)
-- end

function WBP_TaskIndicatorUI_C:OnLoadedInit()
    local DesignedScreenSize = UIManager(self):GetDesignedScreenSize()
    self.CenterPos = FVector2D(DesignedScreenSize.X / 2, DesignedScreenSize.Y / 2)
    self.Guide_Node:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    local ZhiliuUI = UIManager(self):GetUIObj("ZhiliuEventTask")
    if ZhiliuUI then
        self:Hide("UIPopUp")
    end

    self.TargetWorldLoc = FVector(0, 0, 0) 
    self.OvalSize = FVector2D(0, 0)
    self.ScreenLocation = FVector2D(0, 0)
    self.CurrentWorldLoc = FVector(0, 0, 0) 
    self.LocationLerpInterval = 3                       -- 指引点的世界坐标插值间隙
    self.BoardSize = FVector2D(30, 30)                  -- 指引显示范围边界大小
    self.TargetOffsetOnDoor = 0                         -- 指引的偏移（挂在门上面的时候，插值目标点）
    self.CurrentOffsetOnDoor = 0                        -- 指引的偏移（挂在门上面的时候，插值当前点）
    self.OffsetLerpInterval = 150                       -- 指引点偏移插值间隙
    self.CacheScreenPos = FVector2D(0, 0)
    self.NpcIndicatorHideTags = {}
    self.DistanceUnit = GText("UI_SCALE_METER")
end

function WBP_TaskIndicatorUI_C:SetGuideInfo(PointType, PointName, MapKey, QuestNode, GuideTag)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.GuideInfoCache =
    {
        PointType = PointType,
        PointName = PointName,
        PointOrStaticCreatorName = MapKey,
        QuestNode = QuestNode,
        QuestHintId = QuestNode.QuestHintId
    }
    self.TargetPointType = PointType
    local GuidePointChainId = nil
    if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
        GuidePointChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
    else
        GuidePointChainId = QuestNode.Context.QuestChainId
    end
    self:ChangeIconStyleByQuestChainType(GuidePointChainId)
    self:TrySetDiffGuideIcon(GuidePointChainId, QuestNode.Key)

    self.TaskRegionId = 0
    if self.GuideInfoCache.PointOrStaticCreatorName == nil or GuidePointLocData[self.GuideInfoCache.PointOrStaticCreatorName] == nil or GuidePointLocData[self.GuideInfoCache.PointOrStaticCreatorName].SubRegionId == 0 then
        if self.GuideInfoCache.PointName ~= nil and GuidePointLocData[self.GuideInfoCache.PointName] and GuidePointLocData[self.GuideInfoCache.PointName].SubRegionId ~= 0 then
            self.TaskRegionId = GuidePointLocData[self.GuideInfoCache.PointName].SubRegionId
            self.CurrentFloorLevelId = GuidePointLocData[self.GuideInfoCache.PointName].FloorId
        else
            if Const.EnableTaskPrintError then
                ScreenPrint(string.format("指引点所在区域不存在，请检查导出数据是否正确！QuestChainId:"..tostring(GuidePointChainId)..", STL节点Key:"..tostring(QuestNode.Key)..", 指引点名称:"..tostring(self.GuideInfoCache.PointName)))
            end
        end
    else
        self.TaskRegionId = GuidePointLocData[self.GuideInfoCache.PointOrStaticCreatorName].SubRegionId
        self.CurrentFloorLevelId = GuidePointLocData[self.GuideInfoCache.PointOrStaticCreatorName].FloorId
    end

    local TrackingQuestChainId = Avatar.TrackingQuestChainId
    self:SetSmarPointInfoByQuestRegionId()
    self.STLIndicatorType = "Task"

    self.CurGuideChainId = GuidePointChainId
    self.AvatarTrackingId = TrackingQuestChainId
    DebugPrint("SetGuideInfo CurGuideChainId is:", self.CurGuideChainId, "TaskRegionId:", self.TaskRegionId, "NodeKey:", QuestNode.Key)
    if self.CurGuideChainId ~= self.AvatarTrackingId then
        self:Hide("TrackQuest")
    end

    if self.CurGuideChainId == TrackingQuestChainId and TrackingQuestChainId ~= 0 then
        EventManager:FireEvent(EventID.UpdateMiniMap, self:GetName(), "Task", "Add")
    end

    if GuidePointChainId == TrackingQuestChainId and self.TargetPointType == "N" then
        ---NPC头顶UI迭代后，不需要NPC已经创建，直接传NPCId就可以
        TaskUtils:UpdateAllMissionNpcGuideMaps(true, self:GetName(), tonumber(PointName))
    end
    if GuidePointLocData[self.GuideInfoCache.PointOrStaticCreatorName] and GuidePointLocData[self.GuideInfoCache.PointOrStaticCreatorName].R and
    GuidePointLocData[self.GuideInfoCache.PointOrStaticCreatorName].R <= 0 then
        local BattleMain = UIManager(self):GetUIObj("BattleMain")
        if BattleMain.Battle_Map then
            BattleMain.Battle_Map.WildMap:EnterOrExitTaskRegion(self.GuideInfoCache.PointOrStaticCreatorName, false)
        end
    end
end

function WBP_TaskIndicatorUI_C:TrySetDiffGuideIcon(InGuidePointChainId, InKey)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local BarWidget = TaskUtils:GetTaskBarWidget()
    if not BarWidget then
        return
    end

    local DoingQuestId = Avatar.QuestChains[InGuidePointChainId].DoingQuestId
    local Info = TaskUtils:GetQuestExtraInfo(InGuidePointChainId, DoingQuestId)
    if not Info then
        return
    end

    for _, Data in pairs(Info) do
        if Data.Node and Data.Node.Type == "BranchQuestStartNode" and IsEmptyTable(Data.DiffGuideList) == false then
            for Index, OptionElemts in pairs(Data.DiffGuideList) do
                for _, KeyList in pairs(OptionElemts) do
                    for _, KeyData in pairs(KeyList) do
                        if Data.IsUseDifftation then
                            if KeyData.IsShowOptional == true and InKey == KeyData.TargetIndicatorKey then
                                local Content = string.char(string.byte('A') + Index - 1)
                                -- local RetPath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_'..Content..'.T_Gp_Digging_'..Content
                                local RetPath = TaskUtils:GetDiffIconOptionalByQuestChainType(InGuidePointChainId, Content)
                                self.IconObject = LoadObject(RetPath)
                                self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", self.IconObject)
                                BarWidget:SetTaskBarSubTaskIcon(Index, InGuidePointChainId, "DiffOptional")
                            elseif KeyData.TargetIndicatorKey == InKey then
                                local Content = string.char(string.byte('A') + Index - 1)
                                -- local RetPath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SubTask_'..Content..'.T_Gp_SubTask_'..Content
                                local RetPath = TaskUtils:GetDiffIconByQuestChainType(InGuidePointChainId, Content)
                                self.IconObject = LoadObject(RetPath)
                                self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", self.IconObject)
                                BarWidget:SetTaskBarSubTaskIcon(Index, InGuidePointChainId, "Diff")
                            end
                        else
                            if KeyData.IsShowOptional == true and InKey == KeyData.TargetIndicatorKey then
                                self.IconObject = TaskUtils:GetOptinalIconTextureByQuestChainType(InGuidePointChainId)
                                self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", self.IconObject)
                                BarWidget:SetTaskBarSubTaskIcon(Index, InGuidePointChainId, "Optional")
                            end
                        end
                    end
                end
            end
        end
    end
end

function WBP_TaskIndicatorUI_C:RealSetABCImg(Object)
    self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", Object)
end

function WBP_TaskIndicatorUI_C:Construct()
    self.Super.Construct(self)
    EventManager:AddEvent(EventID.OnChangeTaskSubRegion, self, self.SetSmarPointInfoByQuestRegionId)
    EventManager:AddEvent(EventID.OnChangeTaskIndicator, self, self.ChangeAvatarTrackingQuestChainId)
    EventManager:AddEvent(EventID.OnSetQuestTracking,self, self.OnDoSetQuestTracking)
    EventManager:AddEvent(EventID.PlayLoopAnimAfterBarAnim, self, self.RePlayAppearAnim)
    EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainEnd, self, self.OnDeliverEnd)
    EventManager:AddEvent(EventID.ResetNpcMiniMap, self, self.ResetNpcIndicatorMiniMap)
    self.IsDestroied = false
end

function WBP_TaskIndicatorUI_C:Destruct()
    self.Super.Destruct(self)
    if self:IsListeningForInputAction("ActiveGuide") then
        self:StopListeningForInputAction("ActiveGuide", EInputEvent.IE_Pressed)
    end
    EventManager:RemoveEvent(EventID.OnChangeTaskSubRegion, self)
    EventManager:RemoveEvent(EventID.OnChangeTaskIndicator, self)
    EventManager:RemoveEvent(EventID.OnSetQuestTracking, self)
    EventManager:RemoveEvent(EventID.PlayLoopAnimAfterBarAnim, self)
    EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainEnd, self)
    EventManager:RemoveEvent(EventID.ResetNpcMiniMap, self)

    self.IsDestroied = true
end

function WBP_TaskIndicatorUI_C:GetGuideInfoFromCache(ChainId)
    if ChainId == 0 then
        self.TargetPointName = nil
        return
    end
    if not self.GuideInfoCache  then
        self.TargetPointName = nil
        return
    end
    local PointType = self.GuideInfoCache.PointType
    local PointName = self.GuideInfoCache.PointName
    local AreaName  = self.GuideInfoCache.AreaName
    self.TargetPointType = PointType
    self.TargetPointName = PointName
    self.TargetAreaName = AreaName
end

function WBP_TaskIndicatorUI_C:OnDeliverEnd()
    if self.CurGuideChainId == 0 then
        return
    end

    if self.CurGuideChainId == self.AvatarTrackingId then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    local TS = TalkSubsystem()
    if TS and TS:IsInImmersiveStory() then --隐藏tag必须为Talk
        self:Hide(Const.TalkHideTag)
    end
end

function WBP_TaskIndicatorUI_C:ResetNpcIndicatorMiniMap(InUnitId)
    if (self.TargetPointType == "N" or self.TargetPointType == "Npc" ) and self.GuideInfoCache.PointName == InUnitId 
    and self.CurGuideChainId == self.AvatarTrackingId then
        EventManager:FireEvent(EventID.UpdateMiniMap, self:GetName(), "Task", "Add")
    end
end

function WBP_TaskIndicatorUI_C:ChangeIconStyleByQuestChainType(InChainId)
    self.IsNeedChangeSmartGuideStyle = true
    if self.IconObject == nil or IsValid(self.IconObject) == false  then
        if not DataMgr.QuestChain[InChainId] then
            return
        end
        local Obj = nil
        
        local CurQuestChainType = DataMgr.QuestChain[InChainId].QuestChainType
        if CurQuestChainType == Const.MainQuestChainType then
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("ArrowColor", self.Color_Yellow.SpecifiedColor)
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("GeometryColor", self.Color_Yellow.SpecifiedColor)
            Obj = LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission.T_Gp_MainMission')
        elseif CurQuestChainType == Const.SideQuestChainType then
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("ArrowColor", self.Color_White.SpecifiedColor)
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("GeometryColor", self.Color_White.SpecifiedColor)
            Obj = LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SideMission.T_Gp_SideMission')
        elseif CurQuestChainType == Const.MainActivityQuestChainType then
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("ArrowColor", self.Color_Yellow.SpecifiedColor)
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("GeometryColor", self.Color_Yellow.SpecifiedColor)
            Obj = LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_EventMainMission.T_Gp_EventMainMission')
        elseif CurQuestChainType == Const.LimTimeQuestChainType then
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("ArrowColor", self.Color_Blue.SpecifiedColor)
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("GeometryColor", self.Color_Blue.SpecifiedColor)
            Obj = LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_LTMission.T_Gp_LTMission')
        elseif CurQuestChainType == Const.SpecialSideQuestChainType then
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("ArrowColor", self.Color_Blue.SpecifiedColor)
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetVectorParameterValue("GeometryColor", self.Color_Blue.SpecifiedColor)
            Obj = LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission.T_Gp_SpSideMission')
        end
        self.IconObject = Obj
        self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", Obj)
    else
        self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", self.IconObject)
    end
end

function WBP_TaskIndicatorUI_C:CreateAndMoveFollowingPath()
    if not IsValid(self) then
        return
    end

    if self.CurGuideChainId == self.AvatarTrackingId then
        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(self.CurGuideChainId, "Task")
        if #UIObjs > 1 then
            return
        end
        if IsValid(TaskUtils.TaskPathActor) and TaskUtils.IsCanMakeTaskPathActor == false then
            TaskUtils.TaskPathActor:K2_DestroyActor()
            TaskUtils.TaskPathActor = nil
        end
        TaskUtils:CreateAndMoveFollowingPath(self)
    end
end

function WBP_TaskIndicatorUI_C:OnDoSetQuestTracking()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if TaskUtils:GetQuestInterfaceJump(Avatar.TrackingQuestChainId) and TaskUtils:GetQuestIsShowGuide(Avatar.TrackingQuestChainId) then
        return
    end

    GWorld.GameInstance:AddTimer(0.5, function()
        self:CreateAndMoveFollowingPath()
	end, false)
end

function WBP_TaskIndicatorUI_C:RePlayAppearAnim()
    if self.WBP_TaskGuide_Base.Loop ~= nil then
        EMUIAnimationSubsystem:EMPlayAnimation(self.WBP_TaskGuide_Base, self.WBP_TaskGuide_Base.Loop)
        self:TryPlayAppearAudio()
    end 
end

function WBP_TaskIndicatorUI_C:PlayAppearAnim()
    local BarWidget = TaskUtils:GetTaskBarWidget()
    if BarWidget then
        if BarWidget:IsAnimationPlaying(BarWidget.Get_in) then
            BarWidget:BindToAnimationFinished(BarWidget.Get_in,
            {BarWidget,
            function()
                BarWidget:UnbindAllFromAnimationFinished(BarWidget.Get_in)
                EventManager:FireEvent(EventID.PlayLoopAnimAfterBarAnim)
            end})
        elseif BarWidget:IsAnimationPlaying(BarWidget.Main_Task_In) then
            BarWidget:BindToAnimationFinished(BarWidget.Main_Task_In,
            {BarWidget,
            function()
                BarWidget:UnbindAllFromAnimationFinished(BarWidget.Main_Task_In)
                EventManager:FireEvent(EventID.PlayLoopAnimAfterBarAnim)
            end})
        elseif BarWidget:IsAnimationPlaying(BarWidget.In) then
            BarWidget:BindToAnimationFinished(BarWidget.In,
            {BarWidget,
            function()
                BarWidget:UnbindAllFromAnimationFinished(BarWidget.In)
                EventManager:FireEvent(EventID.PlayLoopAnimAfterBarAnim)
            end})
        elseif BarWidget:IsAnimationPlaying(BarWidget.Main_Task_Out) then
            return
        else
            self:RePlayAppearAnim()
        end
    else
        self:RePlayAppearAnim()
    end
end

function WBP_TaskIndicatorUI_C:Disappear()
    self:Close()
end

function WBP_TaskIndicatorUI_C:GetTargetStaticCreator(InTargetName)
    local TargetStaticCreator = nil
    TargetStaticCreator = self.GameState.StaticCreatorStringNameMap:FindRef(InTargetName)
    if TargetStaticCreator then
        return TargetStaticCreator
    end
    TargetStaticCreator = self.GameState.StaticCreatorMap:FindRef(InTargetName)
    if TargetStaticCreator then
        return TargetStaticCreator
    end
    local CreatorMap = self.GameState.StaticCreatorMap:ToTable()
    for _, v in pairs(CreatorMap) do
        if (v:GetDisplayName() == InTargetName) then
            return  v
        end
    end
end

function WBP_TaskIndicatorUI_C:GetNewTargetPoint()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    return GameState:GetTargetPoint(self.TargetPointName)
end

function WBP_TaskIndicatorUI_C:ChengeIsNeedCollapsedByRangeStyle()
    if self.TargetPointType ~= "P" then
        self.IsRangeOrPoint = false
        return
    end
    local Key = self.GuideInfoCache.PointOrStaticCreatorName
    if GuidePointLocData[Key] == nil or GuidePointLocData[Key].R == nil or not IsValid(self.PlayerCharacter) then
        self.IsRangeOrPoint = false
        return
    end
    local RealRadius = nil
    if GuidePointLocData[Key] and GuidePointLocData[Key].R and GuidePointLocData[Key].R > 0 then
        RealRadius = (GuidePointLocData[Key].R + 5) / 100
    end
    local PointLoc = FVector(GuidePointLocData[Key].X,  GuidePointLocData[Key].Y, GuidePointLocData[Key].Z)
    local Distance = UKismetMathLibrary.Vector_Distance2D(
        self.PlayerCharacter.CurrentLocation, PointLoc
    ) / 100.0
    if RealRadius == nil then
        self.IsRangeOrPoint = false
        return
    end

    local IsShowRange = Distance < RealRadius

    if RealRadius ~= nil and IsShowRange then
        self.IsRangeOrPoint = true
        return
    end

    self.IsRangeOrPoint = false
    return
end

function WBP_TaskIndicatorUI_C:TriggerQuestHint()
    if self.ShowQuestHintFlag == self.IsRangeOrPoint then
        return
    end

    if self.GuideInfoCache.QuestHintId == nil then
        return
    end
    local Obj = TaskUtils:GetTaskBarWidget()
    
    if self.IsRangeOrPoint and Obj then
        Obj:ShowQuestHint(self.GuideInfoCache.QuestHintId)
    elseif not self.IsRangeOrPoint and Obj then
        Obj:HideQuestHint(self.GuideInfoCache.QuestHintId)
    end

    self.ShowQuestHintFlag = self.IsRangeOrPoint
end

function WBP_TaskIndicatorUI_C:TryGetTaskGuideNpcUnitId()
    local TargetNpc = self.GameState:GetNpcInfo(self.TargetPointName)
    if TargetNpc and UE4.UKismetSystemLibrary.IsValid(TargetNpc) then
        return TargetNpc.UnitId
    end

    local TargetStaticCreator = self:GetTargetStaticCreator(self.GuideInfoCache.PointOrStaticCreatorName)
    if TargetStaticCreator and UE4.UKismetSystemLibrary.IsValid(TargetStaticCreator)
    and TargetStaticCreator.UnitType == "Npc"
    and self.Guide_Node.Visibility == UE4.ESlateVisibility.SelfHitTestInvisible then
        return TargetStaticCreator.UnitId
    end

    return nil
end

function WBP_TaskIndicatorUI_C:CalculateTargetPointPos()
    if self.IsInTaskRegion then --和追踪的任务在一个区域内，需要根据当前任务节点重新设置任务指引
        self.TargetPointType = self.GuideInfoCache.PointType
        if self.TargetPointType == "Area" then
            self.TargetPointName = self.GuideInfoCache.PointOrStaticCreatorName
        else
            self.TargetPointName = self.GuideInfoCache.PointName 
        end
    end

    if self.TargetPointType == "N" or self.TargetPointType == "Npc" then
       self:SetNpcGuideTargetPosition()
    elseif self.TargetPointType == "P" then
        self:SetTargetPositionByNewTargetPoint()
    elseif self.TargetPointType == "Observation" then
        self:SetTargetPositionByObservationPoint()
    else
        self:SetTargetPositionByStaticCreator()
    end
end

function WBP_TaskIndicatorUI_C:SetNpcGuideTargetPosition()
    local TargetNpc = self.GameState:GetNpcInfo(tonumber(self.TargetPointName))
    if TargetNpc then
        local NPCActorLocation = TargetNpc:K2_GetActorLocation()
        local NPCActorHalfHeight = 0
        if TargetNpc.CapsuleComponent then
            NPCActorHalfHeight = TargetNpc.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
        end
        local RealHelperCoefficient = self.OverrideNpcHelperCoefficient or self.HelperCoefficient
        self.TargetPointPos = UE4.FVector(NPCActorLocation.X, NPCActorLocation.Y, NPCActorLocation.Z + NPCActorHalfHeight + RealHelperCoefficient)
    else
        if self.GuideInfoCache and self.GuideInfoCache.PointOrStaticCreatorName ~= nil then
            local TargetStaticCreator = self:GetTargetStaticCreatorByName(self.GuideInfoCache.PointOrStaticCreatorName)
            if TargetStaticCreator and UE4.UKismetSystemLibrary.IsValid(TargetStaticCreator) then
                local TargetStaticCreatorLoc = TargetStaticCreator:K2_GetActorLocation()
                self.TargetPointPos = UE4.FVector(TargetStaticCreatorLoc.X, TargetStaticCreatorLoc.Y, TargetStaticCreatorLoc.Z + self.HelperCoefficient)
            else
                self.Guide_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        else
            self.Guide_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function WBP_TaskIndicatorUI_C:TryPlayAppearAudio()
    if self.Guide_Node.Visibility ~= ESlateVisibility.Collapsed then
        AudioManager(self):PlayUISound(self, "event:/ui/common/guide_point_show", nil, nil)
    end
end

function WBP_TaskIndicatorUI_C:TickChildBP()
    if self.CurGuideChainId == 0 then
        self.Guide_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    if self.CurGuideChainId ~= self.AvatarTrackingId then
        self.Guide_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    local IsOpenSmartGuide = false
    if not self.IsInTaskRegion then --当前区域不处于任务所在区域，需要根据区域联通图，标定相应的指引点位置
            local TargetPointInfo = self.SmartGuidePointInfo
            if TargetPointInfo ~= nil then --存在区域联通，标定相应指引点
                self.TargetPointType = 'P'
                -- self.TargetPointName = TargetPointInfo[2]
                if self:TryReplaceNearlySmartPoint(TargetPointInfo) then
                    IsOpenSmartGuide = false
                else
                    IsOpenSmartGuide = true
                end
            else
                self:GetGuideInfoFromCache(self.CurGuideChainId)
            end
    end
    self:ChangePointStyle(IsOpenSmartGuide)
    self:UpdateTaskIndicator_CPP()
end


function WBP_TaskIndicatorUI_C:TryReplaceNearlySmartPoint(SmarPointInfo)
    if SmarPointInfo == nil then
        return false
    end

    if SmarPointInfo[2] ~= nil then
        self.TargetPointName = SmarPointInfo[2]
        self.TargetPointSubRegionId = SmarPointInfo[1]
        return false
    else
        self:GetGuideInfoFromCache(self.CurGuideChainId)
        return true
    end
    return false
end

function WBP_TaskIndicatorUI_C:ChangePointStyle(IsOpenSmartGuide)
    if self.IsShowSmartPointStyle ~= IsOpenSmartGuide then
        self.IsNeedChangeSmartGuideStyle = true
        self.IsShowSmartPointStyle = IsOpenSmartGuide
    end

    if IsOpenSmartGuide and self.IsNeedChangeSmartGuideStyle then
        
        if not DataMgr.QuestChain[self.CurGuideChainId] then
            return
        end
        local CurQuestChainType = DataMgr.QuestChain[self.CurGuideChainId].QuestChainType
        if CurQuestChainType == Const.MainQuestChainType or CurQuestChainType == Const.MainActivityQuestChainType then
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMissionEntrance.T_Gp_MainMissionEntrance'))
        elseif CurQuestChainType == Const.SideQuestChainType then
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SideMissionEntrance.T_Gp_SideMissionEntrance'))
        elseif CurQuestChainType == Const.LimTimeQuestChainType or CurQuestChainType == Const.SpecialSideQuestChainType then
            self.WBP_TaskGuide_Base.Img_Main:GetDynamicMaterial():SetTextureParameterValue("GuideIcon", LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpMissionEntrance.T_Gp_SpMissionEntrance'))
        end
        self.IsNeedChangeSmartGuideStyle = false
    end

    if not IsOpenSmartGuide and self.IsNeedChangeSmartGuideStyle then
        self:ChangeIconStyleByQuestChainType(self.CurGuideChainId)
        self.IsNeedChangeSmartGuideStyle = false
    end
end

-- function WBP_TaskIndicatorUI_C:UpdateIndicator()
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     if GameInstance == nil then
--         self:DebugPrint("UpdateIndicator: GameInstance 不存在")
--         return
--     end
    
--     local SceneManager = GameInstance:GetSceneManager()
--     if SceneManager == nil then
--         self:DebugPrint("UpdateIndicator: SceneManager 不存在")
--         return
--     end
--     -- 获取 PlayerCharacter
--     local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
--     if not IsValid(Player) or self.TargetPointPos == nil then
--         return
--     end

--     -- 获取 PlayerController
--     local Controller = Player:GetController()

--     -- 获取指引点是否在门上和门的位置
    
--     self.TargetWorldLoc.X, self.TargetWorldLoc.Y, self.TargetWorldLoc.Z = self.TargetPointPos.X, self.TargetPointPos.Y, self.TargetPointPos.Z
--     self.CurrentWorldLoc.X, self.CurrentWorldLoc.Y, self.CurrentWorldLoc.Z = self.TargetWorldLoc.X, self.TargetWorldLoc.Y, self.TargetWorldLoc.Z

    
--     -- 计算视口的中心位置和限制范围的椭圆大小
--     local ViewportSize = UIManager(self):GetViewportSize()
--     if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
--         self.CenterPos.X, self.CenterPos.Y  = ViewportSize.X * 0.5, ViewportSize.Y * 0.463
--         self.OvalSize.X, self.OvalSize.Y = 0.6 * ViewportSize.X * 0.5, 0.55 * ViewportSize.Y * 0.5
--     elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
--         self.CenterPos.X, self.CenterPos.Y  = ViewportSize.X * 0.5, ViewportSize.Y * 0.4723
--         self.OvalSize.X, self.OvalSize.Y = 0.620 * ViewportSize.X * 0.5, 0.532 * ViewportSize.Y * 0.5
--     end
    
--     if not Controller:IsA(APlayerController) then
--         return
--     end

--     -- 根据目标的世界坐标计算屏幕坐标（插值）
--     local CurrentOffsetOnDoor, LocLerpFinished, IndicatorAngle, TargetDistance,
--         CurrentDistance, IsOutElliptic, IsOutScreen =
--         UUIFunctionLibrary.LerpAndProjectWorldToScreenInEllipse(

--             Controller, self.TargetWorldLoc, self.CurrentWorldLoc, self.LocationLerpInterval,
--             self.ScreenLocation, self.CenterPos, self.OvalSize, self.BoardSize, false,
--             self.TargetOffsetOnDoor, self.CurrentOffsetOnDoor, self.OffsetLerpInterval, false, 0, 0, 0, false
        
--         )
--     self.IsOutScreen = IsOutScreen
--     self.IsOutElliptic = IsOutElliptic

--     -- 是否使用实际 Actor 的距离
--     if self.UseRealDistance then
--         TargetDistance = UKismetMathLibrary.Vector_Distance(
--             Player.CurrentLocation, self.TargetPointPos
--         ) / 100.0
--     end
--     self.PointRealDistance = TargetDistance

--     -- 设置指引点在屏幕边缘时隐藏数字显示箭头
--     self:SetArrowAndNumVisiblity(IndicatorAngle)

--     -- 把指引点的 UI 设置在屏幕坐标上
--     local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Guide_Node)
--     local ViewPortScale = UWidgetLayoutLibrary.GetViewportScale(self)
--     self.CacheScreenPos:Set(self.ScreenLocation.X / ViewPortScale, self.ScreenLocation.Y / ViewPortScale)
--     CanvasSlot:SetPosition(self.CacheScreenPos)
-- end

function WBP_TaskIndicatorUI_C:SetSmarPointInfoByQuestRegionId()
    DebugPrint("SetSmarPointInfoByQuestRegionId start===")
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    self.PlayerRegionId = Avatar.CurrentRegionId
    if self.TaskRegionId ~= self.PlayerRegionId then --当玩家不处于任务区域时，根据联通图显示相关指引点
        self.SmartGuidePointInfo = self:TryGetTargetGuidePointByRegionGraph(self.PlayerRegionId, self.TaskRegionId)
        self.IsInTaskRegion = false
    else
        self.IsInTaskRegion = true
    end
    EventManager:FireEvent(EventID.UpdateMiniMap, self:GetName(), "Task", "ChangeRegion")

    local CurTrackingQuestChaindId = Avatar.TrackingQuestChainId
    if Avatar.QuestChains[CurTrackingQuestChaindId] then
        local TrackingQuestId = Avatar.QuestChains[CurTrackingQuestChaindId].DoingQuestId
        DebugPrint("CurTrackQuestChain:", CurTrackingQuestChaindId, "CurTrackDoingQuestId", TrackingQuestId)
    end
    MissionIndicatorManager:TryToArrangeIndicatorBySmartPointInfo()
    if self.SmartGuidePointInfo == nil and self.GuideInfoCache.PointOrStaticCreatorName then
        local SourceTarget = self:TryToFindGuidePointTarget(self.GuideInfoCache.PointOrStaticCreatorName)
        if SourceTarget == nil then
            self:Hide("ExistTarget")
        end
    elseif self.SmartGuidePointInfo ~= nil then
        self:Show("ExistTarget")
    end

    DebugPrint("TargetPointName:", self.TargetPointName)
    DebugPrint("TargePosition:", self.TargetPointPos)
    DebugPrint("TaskRegionId:", self.TaskRegionId , "PlayerRegionId:", self.PlayerRegionId)
    DebugPrint("SetSmarPointInfoByQuestRegionId end===")
end

function WBP_TaskIndicatorUI_C:ChangeAvatarTrackingQuestChainId(InMissionNpcGuideMaps)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local CurTrackingQuestChaindId = Avatar.TrackingQuestChainId
    self.AvatarTrackingId = CurTrackingQuestChaindId
end

function WBP_TaskIndicatorUI_C:CheckConditionIsUnlock(RegionData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    if RegionData == nil then
        return true
    end
    return ConditionUtils.CheckCondition(Avatar, RegionData)
end

function WBP_TaskIndicatorUI_C:TryGetTargetGuidePointByRegionGraph(CurSubRegionId, TargetSubRegionId)
    local function ContainsElement(table, element)
        for _, value in pairs(table) do
            if value[1] == element then
                return value
            end
        end
        return nil
    end

    local function CreateQueue()
        local queue = {}
        queue.first = 0
        queue.last = -1
        queue.QueueValue = {}
        queue.Path = {}
        return queue
    end
    -- 入队操作
    local function Enqueue(queue, value)
        local last = queue.last + 1
        queue.last = last
        queue.QueueValue[last] = value
        table.insert(queue.Path, value[1])
    end

    local function ContainsPath(table, element)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end

    -- 出队操作
    local function Dequeue(queue)
        local first = queue.first
        if first > queue.last then
            return nil
        end
        local value = queue.QueueValue[first]
        queue.QueueValue[first] = nil
        queue.first = first + 1
        return value
    end

    -- 判断队列是否为空
    local function IsEmptyQueue(queue)
        return queue.first > queue.last
    end

    if not DataMgr.RegionGraph[TargetSubRegionId] or
    not  DataMgr.SubRegion[TargetSubRegionId].RegionId then
        return nil
    end
    local TargetRegionId = DataMgr.SubRegion[TargetSubRegionId].RegionId

    if not DataMgr.RegionGraph[CurSubRegionId] or
    not DataMgr.RegionGraph[CurSubRegionId].SubRegionTarget or
    not DataMgr.RegionGraph[CurSubRegionId].SubRegionTarget.RegionTarget then
        return nil
    end
    local RegionTargetDatas = DataMgr.RegionGraph[CurSubRegionId].SubRegionTarget.RegionTarget

    local function TryFindTargetPointByBFS(RootTargetData)
        local RootSubRegionId = RootTargetData[1]
        if not DataMgr.RegionGraph[RootSubRegionId] or
           not DataMgr.RegionGraph[RootSubRegionId].SubRegionTarget or
           not DataMgr.RegionGraph[RootSubRegionId].SubRegionTarget.RegionTarget then
            return -1
        end

        local RootRegionQueue = CreateQueue()
        local RootRegionDatas = DataMgr.RegionGraph[RootSubRegionId].SubRegionTarget.RegionTarget --Debug 1：逐一遍历对应子区域里的SubRegionTarget数据
        for _, v in pairs(RootRegionDatas) do
            Enqueue(RootRegionQueue, v)
        end
        local QueueCount = RootRegionQueue.last - RootRegionQueue.first + 1

        local Weight = 1
        local QueueIndex = 0
        while not IsEmptyQueue(RootRegionQueue) do
            if ContainsElement(RootRegionQueue.QueueValue, TargetSubRegionId) == nil then --当前区域没有直接可达目标区域，需要逐个在当前区域的联通区域内找
                local frontData = RootRegionQueue.QueueValue[RootRegionQueue.first]
                local frontDataSubRegionId = frontData[1]
                QueueIndex = QueueIndex + 1
                if QueueIndex > QueueCount then
                    Weight = Weight + 1
                    QueueIndex = 0
                    QueueCount = RootRegionQueue.last - RootRegionQueue.first + 1
                end
                Dequeue(RootRegionQueue)

                if not DataMgr.RegionGraph[frontDataSubRegionId] or 
                not DataMgr.RegionGraph[frontDataSubRegionId].SubRegionTarget or
                not DataMgr.RegionGraph[frontDataSubRegionId].SubRegionTarget.RegionTarget then
                    goto continue
                end

                if DataMgr.RegionGraph[frontDataSubRegionId].RegionStart == DataMgr.RegionGraph[TargetSubRegionId].RegionStart then
                    local NewRegionDatas = DataMgr.RegionGraph[frontDataSubRegionId].SubRegionTarget.RegionTarget --取队列第一个区域

                    for _, NewRegionData in pairs(NewRegionDatas) do
                        local SubRegionId = NewRegionData[1]--Debug 2：取出队列第一个子区域数据，逐一遍历对应子区域里的SubRegionTarget数据
                        if DataMgr.RegionGraph[SubRegionId] and DataMgr.RegionGraph[TargetSubRegionId].RegionStart == DataMgr.RegionGraph[SubRegionId].RegionStart and
                        not ContainsPath(RootRegionQueue.Path, SubRegionId) then
                            Enqueue(RootRegionQueue, NewRegionData)
                            if ContainsElement(RootRegionQueue.QueueValue, TargetSubRegionId) then
                                return Weight + 1
                            end
                        end
                    end
                end
                ::continue::
            else
                return Weight + 1
            end
        end

        if IsEmptyQueue(RootRegionQueue) then --当前区域无论如何都到不了目标区域
            return -1
        end
    end

    local function TryFindNearestEnterByRegionId()
        local NearestData = nil
        local CurrentParentRegionId = DataMgr.SubRegion[CurSubRegionId].RegionId
        local TargetParentRegionId = DataMgr.SubRegion[TargetSubRegionId].RegionId
        if CurrentParentRegionId == TargetParentRegionId then
            return NearestData
        end
        local RetDistance = math.maxinteger
        for _, Data in pairs(RegionTargetDatas) do
            if Data and Data[1] and Data[2] and DataMgr.SubRegion[Data[1]] then
                local IterParentRegionId = DataMgr.SubRegion[Data[1]].RegionId
                local IsConditionUnlock = true
                if Data[4] and self:CheckConditionIsUnlock(Data[4]) == false then
                    IsConditionUnlock = false
                end
                if TargetParentRegionId == IterParentRegionId and IsConditionUnlock then
                    local NewTargetPoint = self.GameState:GetTargetPoint(Data[2])
                    if NewTargetPoint then
                        local PointLocation = NewTargetPoint:K2_GetActorLocation()
                        local Distance = UKismetMathLibrary.Vector_Distance(self.PlayerCharacter.CurrentLocation, PointLocation)
                        if Distance < RetDistance then
                            RetDistance = Distance
                            NearestData = Data
                        end
                    end
                end
            end
        end
        return NearestData
    end

    local RetData = TryFindNearestEnterByRegionId()
    local RetWeight = math.maxinteger
    if RetData ~= nil then
        return RetData
    end

    local MinDistance = math.maxinteger
    local RetDataTable = {}
    if not ContainsElement(RegionTargetDatas, TargetSubRegionId) then
        for _, IteraData in pairs(RegionTargetDatas) do
            local IterWeight = TryFindTargetPointByBFS(IteraData)
            if IterWeight >= 0 and IterWeight <= RetWeight then
                RetWeight = IterWeight
                table.insert(RetDataTable, IteraData)
            end
        end
        for _, Data in pairs(RetDataTable) do
            if self:CheckConditionIsUnlock(Data[4]) then
                local NewTargetPoint = self.GameState:GetTargetPoint(Data[2])
                if NewTargetPoint then
                    local PointLocation = NewTargetPoint:K2_GetActorLocation()
                    local Distance = UKismetMathLibrary.Vector_Distance(self.PlayerCharacter.CurrentLocation, PointLocation)
                    if Distance < MinDistance then
                        MinDistance = Distance
                        RetData = Data
                    end
                end
            end
        end

    else
        RetWeight = 1
        for _, IteraData in pairs(RegionTargetDatas) do
            if IteraData and IteraData[1] and IteraData[1] == TargetSubRegionId then
                table.insert(RetDataTable, IteraData)
            end
        end

        for _, Data in pairs(RetDataTable) do
            if Data and Data[1] and Data[2] and DataMgr.SubRegion[Data[1]] and self:CheckConditionIsUnlock(Data[4]) then
                local NewTargetPoint = self.GameState:GetTargetPoint(Data[2])
                if NewTargetPoint then
                    local PointLocation = NewTargetPoint:K2_GetActorLocation()
                    local Distance = UKismetMathLibrary.Vector_Distance(self.PlayerCharacter.CurrentLocation, PointLocation)
                    if Distance < MinDistance then
                        MinDistance = Distance
                        RetData = Data
                    end
                end
            end
        end
    end
    if IsEmptyTable(RetDataTable) then --无联通指引, 开始根据RegionStart寻找物理联通的区域
        if IsEmptyTable(DataMgr.RegionGraph[CurSubRegionId].RegionStart) then --室内空间
            for _, Data in pairs(RegionTargetDatas) do
                local IterSubRegionId = Data[1]
                if DataMgr.RegionGraph[IterSubRegionId] and IsEmptyTable(DataMgr.RegionGraph[IterSubRegionId].RegionStart) == false then --室内空间直接出去就行了不需要判断传送机关
                    for _, Id in pairs(DataMgr.RegionGraph[IterSubRegionId].RegionStart) do
                        if Id == TargetSubRegionId then
                            RetData = Data
                            RetWeight = 1
                            break
                        end
                    end
                end
            end
        else --同一个物理连通区域内
            for _, SubRegionId in pairs(DataMgr.RegionGraph[CurSubRegionId].RegionStart) do
                if SubRegionId == TargetSubRegionId then
                    RetWeight = 2
                    break
                end
            end
        end
    end

    local SourcePointTarget = nil

    if RetWeight > 1 and DataMgr.RegionGraph[CurSubRegionId] and DataMgr.RegionGraph[CurSubRegionId].RegionStart ~= nil then
        if self.GuideInfoCache.PointType == "N" or self.GuideInfoCache.PointType == "Npc" then
            local TargetNpc = self.GameState:GetNpcInfo(tonumber(self.GuideInfoCache.PointName))
            if TargetNpc then
                SourcePointTarget = TargetNpc
            else
                if self.GuideInfoCache.PointOrStaticCreatorName ~= nil then
                    SourcePointTarget = self:TryToFindGuidePointTarget(self.GuideInfoCache.PointOrStaticCreatorName)
                end
            end
        else
            if self.GuideInfoCache.PointName then
                SourcePointTarget = self:TryToFindGuidePointTarget(self.GuideInfoCache.PointName)
                if SourcePointTarget then
                    return nil
                end
            end
        end
    end

    if SourcePointTarget then
        return nil
    end

    return RetData
end

function WBP_TaskIndicatorUI_C:TryToFindGuidePointTarget(DisplayName)
    local TargetStaticCreator = nil
    TargetStaticCreator = self.GameState.StaticCreatorStringNameMap:FindRef(DisplayName)
    if TargetStaticCreator then
        return TargetStaticCreator
    end
    TargetStaticCreator = self.GameState.StaticCreatorMap:FindRef(DisplayName)
    if TargetStaticCreator then
        return TargetStaticCreator
    end

    local NewTargetPoint = self.GameState:GetTargetPoint(DisplayName) 
    if NewTargetPoint then
        return NewTargetPoint
    end

    local TalkSubsystem = TalkSubsystem()
	local ObservationPoint = TalkSubsystem:GetTalkInteractiveItem(DisplayName)
    if ObservationPoint then
        return ObservationPoint
    end
    return nil
end

function WBP_TaskIndicatorUI_C:CloseIndicator()
    TaskUtils:UpdateAllMissionNpcGuideMaps(false, self:GetName(), nil)
	EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
    EventManager:FireEvent(EventID.UpdateMiniMap, self:GetName(), "Task", "Delete")
    self.Super.Close(self)
    MissionIndicatorManager:TryToArrangeIndicatorBySmartPointInfo()
end

function WBP_TaskIndicatorUI_C:UpdateQuestArea(isAdd)
    if not self.TargetAreaName then
        return
    end
    if isAdd then
        if self.TargetArea then
            return
        end
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        local battleMain = UIManager:GetUI("BattleMain")
        if not battleMain then
            return
        end
        local miniMap = battleMain.Battle_Map or battleMain.Battle_Map_PC
        if miniMap then
            self.TargetArea = miniMap:AddArea(self.TargetAreaName)
        end
    else
        if not self.TargetArea then
            return
        end
        self.TargetArea:RemoveFromParent()
        self.TargetArea=nil
    end
end

function WBP_TaskIndicatorUI_C:GetTaskGuideNpcUnitIdFromCache()
    if not self.GuideInfoCache or not self.GuideInfoCache.PointName then
        return nil
    end
    local NpcId = self.GuideInfoCache.PointName
    local TargetNpc = self.GameState:GetNpcInfo(tonumber(NpcId))
    if TargetNpc and UE4.UKismetSystemLibrary.IsValid(TargetNpc) then
        return TargetNpc.UnitId
    else
        return nil
    end
end

return WBP_TaskIndicatorUI_C
