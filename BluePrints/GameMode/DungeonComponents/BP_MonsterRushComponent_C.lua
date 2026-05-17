--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_MonsterRushComponent_C
require "UnLua"

local BP_MonsterRushComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

-- function M:Initialize(Initializer)
-- end

-- function BP_MonsterRushComponent_C:ReceiveBeginPlay()
--     self.Super.ReceiveBeginPlay(self)

--     self.RenderTexture=UKismetRenderingLibrary.CreateRenderTarget2D(self)
--     local size=UWidgetLayoutLibrary.GetViewportSize(self)
--     URuntimeCommonFunctionLibrary.RenderTarget2DResize(self.RenderTexture,size.X,size.Y)

--     local player=UGameplayStatics.GetPlayerCharacter(self,0)
--     self.SceneCaptureComponent=NewObject(USceneCaptureComponent2D,player)
--     self.SceneCaptureComponent:K2_AttachToComponent(player.CharCameraComponent)
--     self.SceneCaptureComponent:K2_SetRelativeTransform(FTransform(),false,nil,false)
--     URuntimeCommonFunctionLibrary.RegisterComponent(self.SceneCaptureComponent)
--     self.SceneCaptureComponent.FOVAngle=player.CharCameraComponent.FieldOfView
--     self.SceneCaptureComponent.TextureTarget=self.RenderTexture
--     self.SceneCaptureComponent.CaptureSource=ESceneCaptureSource.SCS_FinalToneCurveHDR
--     self.SceneCaptureComponent:SetComponentTickEnabled(false)
--     self.SceneCaptureComponent.bCaptureEveryFrame=false
--     self.SceneCaptureComponent.bCaptureOnMovement=false
-- end

-- function BP_MonsterRushComponent_C:ReceiveEndPlay()
--     self.Super.ReceiveEndPlay(self, Reason)

--     if self.SceneCaptureComponent then
--         self.SceneCaptureComponent:K2_DestroyComponent(self.SceneCaptureComponent)
--         self.SceneCaptureComponent=nil
--     end
--     UKismetRenderingLibrary.ReleaseRenderTarget2D(self.RenderTexture)
--     self.RenderTexture=nil
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

function BP_MonsterRushComponent_C:InitMonsterRushComponent()
	self.GameMode = self:GetOwner()
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self:InitData(self.GameMode.DungeonId)
    self:InitSceneCaptureComponent()
    self.FinishTime = 0
end

function BP_MonsterRushComponent_C:InitSceneCaptureComponent()
    self.RenderTexture=UKismetRenderingLibrary.CreateRenderTarget2D(self)
    local size=UWidgetLayoutLibrary.GetViewportSize(self)
    URuntimeCommonFunctionLibrary.RenderTarget2DResize(self.RenderTexture,size.X,size.Y)

    local player=UGameplayStatics.GetPlayerCharacter(self,0)
    self.SceneCaptureComponent=NewObject(USceneCaptureComponent2D,player)
    self.SceneCaptureComponent:K2_AttachToComponent(player.CharCameraComponent)
    self.SceneCaptureComponent:K2_SetRelativeTransform(FTransform(),false,nil,false)
    URuntimeCommonFunctionLibrary.RegisterComponent(self.SceneCaptureComponent)
    self.SceneCaptureComponent.FOVAngle=player.CharCameraComponent.FieldOfView
    self.SceneCaptureComponent.TextureTarget=self.RenderTexture
    self.SceneCaptureComponent.CaptureSource=ESceneCaptureSource.SCS_FinalColorHDR
    self.SceneCaptureComponent:SetComponentTickEnabled(false)
    self.SceneCaptureComponent.bCaptureEveryFrame=false
    self.SceneCaptureComponent.bCaptureOnMovement=false
end

function BP_MonsterRushComponent_C:ClearSceneCaptureComponent()
    if self.SceneCaptureComponent then
        self.SceneCaptureComponent:K2_DestroyComponent(self.SceneCaptureComponent)
        self.SceneCaptureComponent=nil
    end
    UKismetRenderingLibrary.ReleaseRenderTarget2D(self.RenderTexture)
    self.RenderTexture=nil
end

function BP_MonsterRushComponent_C:InitData(LevelId)
    self.LevelInfo = DataMgr.MonsterRushDungeon[LevelId]
    if not self.LevelInfo then
        LogError(_G.LogTag," thy  InitMonsterRushComponent->InitData is fail! self.LevelInfo is nil")
        return
    end
    self.Description = self.LevelInfo.Description
    self.GlobalPassiveList = self.LevelInfo.GlobalPassiveList
    self.MonsterList = self.LevelInfo.MonsterList
    self.StaticCreatorList = self.LevelInfo.StaticCreatorList
    self.TargetNum = self.LevelInfo.TargetNum
    self.MonsterRushKilledNum = 0
    self:InitStaticCreatorIdArr()
    self:InitMonsterArr()

end

function BP_MonsterRushComponent_C:ClearMonsterRushComponent()
    self:ClearSceneCaptureComponent()
end

function BP_MonsterRushComponent_C:InitMonsterRushBaseInfo()
    self:InitGlobalPassive()
end

function BP_MonsterRushComponent_C:InitGlobalPassive()
    if not self.GlobalPassiveList then
        LogError(_G.LogTag," thy  GlobalPassiveList is nil")
        return
    end
    for key, value in pairs(self.GlobalPassiveList) do
        Battle(self):AddGlobalPassive(value, nil, 0)
    end
end

function BP_MonsterRushComponent_C:OnMonsterRushTeleport()
    if IsStandAlone(self) or IsClient(self) then
        UIManager(self):LoadUINew('RougeTransition', self.SceneCaptureComponent, self.RenderTexture, false)
    end
end

function BP_MonsterRushComponent_C:MonsterRushTeleport(Location, Rotation)
	if self.GameMode.EMGameState.GameModeType ~= "MonsterRush" then
		return
	end
	self:OnMonsterRushTeleport()
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	PlayerCharacter:K2_TeleportTo(Location, Rotation, false, nil, false)
end

function BP_MonsterRushComponent_C:InitStaticCreatorIdArr()
    if self.StaticCreatorList then
        for index, value in ipairs(self.StaticCreatorList) do
            self.StaticCreatorId:Add(value)
        end
    end
end

function BP_MonsterRushComponent_C:InitMonsterArr()
    if self.MonsterList then
        for index, value in ipairs(self.MonsterList) do
            self.MonsterSpawnId:Add(value)
        end
    end
end

function BP_MonsterRushComponent_C:AddMonsterRushKilledNum(Num)
    self.MonsterRushKilledNum = math.min(self.MonsterRushKilledNum + Num, self.TargetNum)
    self:UpdateUI()
    self:CheckTargetNum()
end

function BP_MonsterRushComponent_C:UpdateLevelProgressHud(Progress, MaxProgress, Level)
    EventManager:FireEvent(EventID.OnWuyoushengLevelProgress, Progress, MaxProgress, Level)
end

function BP_MonsterRushComponent_C:ShowLevelUpTipsHud(Level)
    EventManager:FireEvent(EventID.OnWuyoushengLevelUp, Level)
end

function BP_MonsterRushComponent_C:UpdateUI()

end

function BP_MonsterRushComponent_C:CheckTargetNum()
	if self.MonsterRushKilledNum >= self.TargetNum then
        DebugPrint("thy    OnTargetNumSuccess")
        self.GameMode:TriggerGameModeEvent("OnTargetNumSuccess", self)
	end
end

function BP_MonsterRushComponent_C:CustomFinishInfo(AvatarStr, IsWin)
    -- 获取通关时间（秒）
    local TimerHandleName = self.GameMode.TimerHandleName
    if CommonUtils.HasClientTimerStruct(TimerHandleName) then
        self.FinishTime = math.floor(CommonUtils.GetClientTimerStructPassedTime(TimerHandleName))
    end
    if IsWin then
        -- 获取DungeonId
        local DungeonId = self.GameMode and self.GameMode.DungeonId
        if not DungeonId then
            return {
                Star = 0
            }
        end
        
        -- 从数据表获取时间要求配置
        local LevelData = DataMgr.WuyoushengEventLevel[DungeonId]
        if not LevelData or not LevelData.LevelGoalRequiredTime1 then
            return {
                Star = 0
            }
        end
        
        -- LevelGoalRequiredTime1格式: {-1, 180, 240}
        -- 第一个值是-1（占位符），后面两个是时间阈值
        local TimeThresholds = LevelData.LevelGoalRequiredTime1
        local Star2Threshold = TimeThresholds[2] or 240 -- 2星阈值
        local Star3Threshold = TimeThresholds[3] or 180  -- 3星阈值

        
        -- 根据通关时间判断星级
        local Star = 1
        if self.FinishTime < Star3Threshold then
            Star = 3
        elseif self.FinishTime < Star2Threshold then
            Star = 2
        else
            Star = 1
        end
        
        return {
            Star = Star
        }
    else
        return {
            Star = 0
        }
    end
end

function BP_MonsterRushComponent_C:ShowTopContent(Text, MaxNum)
    self.TopTextPrefix = Text
    self.TopMaxMum = MaxNum
    self.TopCurNum = 0
    self.TopVisibility = true
    EventManager:FireEvent(EventID.OnShowWuyoushengTop, self.TopTextPrefix, self.TopVisibility)
    EventManager:FireEvent(EventID.OnRepWuyoushengTop, self.TopCurNum, self.TopMaxMum)
end

function BP_MonsterRushComponent_C:HideTopContent()
    self.TopVisibility = false
    EventManager:FireEvent(EventID.OnShowWuyoushengTop, self.TopTextPrefix, self.TopVisibility)
end

function BP_MonsterRushComponent_C:AddTopContentCount(Num)
    self.TopCurNum = self.TopCurNum + Num
    EventManager:FireEvent(EventID.OnRepWuyoushengTop, self.TopCurNum, self.TopMaxMum)
end

function BP_MonsterRushComponent_C:GetTopContent()
    return self.TopTextPrefix or "", self.TopCurNum or 0, self.TopMaxMum or 1, self.TopVisibility or false
end

function BP_MonsterRushComponent_C:GetFinishTime()
    return self.FinishTime
end

function BP_MonsterRushComponent_C:BpOnTimerDel_MonsterRush_Wuyou()
    DebugPrint("jly    BpOnTimerDel_MonsterRushTimer")
    local TimerHandleName = self.GameMode.TimerHandleName
    if CommonUtils.HasClientTimerStruct(TimerHandleName) then
        self.FinishTime = math.floor(CommonUtils.GetClientTimerStructPassedTime(TimerHandleName))
    end
end

return BP_MonsterRushComponent_C
