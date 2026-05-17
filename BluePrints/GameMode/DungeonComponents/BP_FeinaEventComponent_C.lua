--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_FeinaEventComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

function BP_FeinaEventComponent_C:InitFeinaEventComponent()
    self.GameMode = self:GetOwner()

    local FeinaEventInfo = DataMgr.FeinaGame[self.GameMode.DungeonId]
	if not FeinaEventInfo then
		GameState(self):ShowDungeonError("FeinaEventComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end
    self.SaveDataManualId = FeinaEventInfo.SaveDataManualId or {}
    self.SaveDataStaticId = FeinaEventInfo.SaveDataStaticId or {}
    self.TriggerStarToState = FeinaEventInfo.TriggerStarState or {}
    self.StarToRewardLevel = FeinaEventInfo.StarToRewardLevel or {}

    self.TriggeredStarState = {}    -- 记录下 只允许触发一次  {key = StaticCreatorId, value = {key = StatedId, value = true}}}
    self.Star = 0                   -- Star是当前收集物的数量，并非奖励等级

    self.bFogOpen = false
    self.InFogTime = 0
    DebugPrint("FeinaEventComponent:Init!", self.GameMode.DungeonId)
end

function BP_FeinaEventComponent_C:InitFeinaEventBaseInfo()
    self.GameMode:TriggerGameModeEvent("Event_OnPreInit")
    self:InitFeinaEventHUD()
    self.UpdateColor:Add(self, self.HUDUpdateColor)
    if self.GameMode.PreInitInfo and self.GameMode.PreInitInfo.PersistenceData then
        local SaveDataString  = self.GameMode.PreInitInfo.PersistenceData
        local FeinaSaveData = SerializeUtils:UnSerialize(SaveDataString)
        PrintTable(FeinaSaveData, 5)
        self:RecoverFeinaSaveData(FeinaSaveData)
    else
        self.GameMode:TriggerGameModeEvent("Event_OnInitTriggerStaticCreator")
    end
end

function BP_FeinaEventComponent_C:InitFeinaEventHUD()
    local UIBattleMain = UIManager(self):GetUI("BattleMain")
    if UIBattleMain then
        UIBattleMain:ShowFeinaEventHUD()
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:TryHideAllSkillUI()
end

-- 按理说可以做成lua直接调过来，不过先还是让策划从蓝图手动调吧
function BP_FeinaEventComponent_C:OnMechanismStateChangeFeina(Mechanism, StateId)
    if not IsValid(Mechanism) then
        return
    end
    local StaticCreatorId = Mechanism.CreatorId
    -- 是否填在表
    if not self.TriggerStarToState[StaticCreatorId] then
        return
    end
    -- 是否触发过
    if self.TriggeredStarState[StaticCreatorId] and self.TriggeredStarState[StaticCreatorId][StateId] then
        return
    end
    -- 是否满足 静态点id对应的状态id
    if self.TriggerStarToState[StaticCreatorId] ~= StateId then
        return
    end

    -- self.Star = self.Star + 1
    self:AddStar(1)

    if not self.TriggeredStarState[StaticCreatorId] then
        self.TriggeredStarState[StaticCreatorId] = {}
    end
    self.TriggeredStarState[StaticCreatorId][StateId] = true
end

function BP_FeinaEventComponent_C:SetStar(Num)
    self.Star = Num
    EventManager:FireEvent(EventID.OnRepFeinaStar, self.Star)
end

function BP_FeinaEventComponent_C:GetStar()
    return self.Star
end

function BP_FeinaEventComponent_C:AddStar(Num)
    self:SetStar(self:GetStar() + Num)
end

function BP_FeinaEventComponent_C:GetFinalRewardLevel()
    local RewardLevel = 0
    for _, Level in pairs(self.StarToRewardLevel) do
        if self:GetStar() >= Level then
            RewardLevel = RewardLevel + 1
        else
            break
        end
    end
    return RewardLevel
end

function BP_FeinaEventComponent_C:TriggerFeinaGameWin(LevelSequenceActor)
    if LevelSequenceActor and LevelSequenceActor.SequencePlayer then
        local SequencePlayer = LevelSequenceActor.SequencePlayer

        LevelSequenceActor.PlaybackSettings.bPauseAtEnd = true
        SequencePlayer.PlaybackSettings.bPauseAtEnd = true              -- 设置上面那个好像没用，这个有用，先这样吧
        SequencePlayer.OnPause:Add(self, function()
            -- UIManager(self):HideAllUI(false, "FeinaGameWin")         -- 写这儿会穿帮，但暂时没想到更好的地方解开，先这样
            self.GameMode:TriggerDungeonWin()
        end)

        UIManager(self):HideAllUI(true, "FeinaGameWin")
        SequencePlayer:Play()
    else
        self.GameMode:TriggerDungeonWin()
    end
end

function BP_FeinaEventComponent_C:CustomFinishInfo(AvatarStr, IsWin)
    if IsWin then
        return {
            PersistenceData = self:GetFeinaSaveData(),
            CollectDropNum = self:GetStar(),
        }
    else
        return {
            CollectDropNum = self.OldStar or 0,
        }
    end
end

function BP_FeinaEventComponent_C:GetFeinaSaveData()
    local _ManualItemSaveData = {}
    for _, ManualId in pairs(self.SaveDataManualId) do
        local ManualItem = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualId)
        if IsValid(ManualItem) then
            local SavaData = ManualItem:GetDungeonSaveData()
            _ManualItemSaveData[ManualId] = SavaData
        end
    end
    local _StaticItemSaveData = {}
    for _, StaticCreatorId in pairs(self.SaveDataStaticId) do
        local StaticCreator = self.GameMode.EMGameState:GetStaticCreatorInfo(StaticCreatorId)
        if IsValid(StaticCreator) and StaticCreator.ChildEids:Length() > 0 then
            local StaticItem = Battle(self):GetEntity(StaticCreator.ChildEids:GetRef(1))
            if IsValid(StaticItem) then
                local SavaData = StaticItem:GetDungeonSaveData()
                _StaticItemSaveData[StaticCreatorId] = SavaData
            end
        end
    end

    local DungeonSaveData = {
        ManualItemSaveData = _ManualItemSaveData,
        StaticItemSaveData = _StaticItemSaveData,
        TriggeredStarState = self.TriggeredStarState,
        CollectStar = self:GetStar(),
    }

    local SerializedString = SerializeUtils:Serialize(DungeonSaveData)
    DebugPrint("FeinaEventComponent:GetFeinaSaveData", SerializedString)
    return SerializedString
end

function BP_FeinaEventComponent_C:RecoverFeinaSaveData(FeinaSaveData)
    self.TriggeredStarState = FeinaSaveData.TriggeredStarState or {}
    self.OldStar = FeinaSaveData.CollectStar or 0               -- 从恢复数据里拿到的羽毛数，如果这次以失败结算，则上报旧的羽毛数而非新的
    self:SetStar(self.OldStar or 0)

    local ManualItemSaveData = FeinaSaveData.ManualItemSaveData or {}
    for ManualId, Data in pairs(ManualItemSaveData) do
        -- local ManualItem = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualId)
        -- if IsValid(ManualItem) and Data.StateId then
        --     local StateId = Data.StateId
        --     ManualItem.StateId = StateId
        -- end
        local RecoverInfo = FManualItemRecoverInfo()
        RecoverInfo.StateId = Data.StateId or -1
        self.GameMode:SetManualItemInfo(ManualId, RecoverInfo)
    end

    local StaticItemSaveData = FeinaSaveData.StaticItemSaveData or {}
    for CreatorId, Data in pairs(StaticItemSaveData) do
		local Creator = self.GameMode.EMGameState:GetStaticCreatorInfo(CreatorId)
		if IsValid(Creator) then
			Creator:RealActiveStaticCreator({DungeonState = Data})
		end
	end
end

-----------------------------------------------迷雾功能-------------------------------------------------
--是否开启迷雾 处于安全范围的时间 迷失后传送的位置 迷失后是否要关闭迷雾
function BP_FeinaEventComponent_C:OpenOrCloseFog(bOpen, InFogTime, SafeTransform, bAutoClose)
    if InFogTime == 0 then
        GWorld.logger.error("菲娜活动组件 OpenOrCloseFog InFogTime为0")
        return
    end
    print(_G.LogTag,"菲娜活动组件 OpenOrCloseFog", bOpen, InFogTime, SafeTransform, bAutoClose)
    self.InFogTime = InFogTime
    self.SafeTransform = SafeTransform
    self.bAutoClose = bAutoClose
    if not self.bFogOpen and bOpen then
        self.InFogTime = InFogTime
        self:AddTimer(InFogTime, self.OnPlayerLostInFog, false, 0, "PlayerInFog", false)
    elseif self.bFogOpen and not bOpen then
        self:RemoveTimer("PlayerInFog")
    end
    self.bFogOpen = bOpen
end

function BP_FeinaEventComponent_C:OnPlayerLostInFog()
    if not self.bFogOpen then
        return
    end
    if self.PlayerInFogNum and self.PlayerInFogNum > 0 then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:K2_SetActorTransform(self.SafeTransform, false, nil, false)
    Player:GetMovementComponent():ForceClientUpdate()
	Player:EnableCheckOverlapPush({})
    Player:ShowBlackScreenFade_StandAlone()
    Player:GetController():SetControlRotation(Player:K2_GetActorRotation())
	Player:Landed()
    self.GameMode:TriggerGameModeEvent("TriggerFogTransformActive")
    if self.bAutoClose then
        self:OpenOrCloseFog(false, self.InFogTime, self.SafeTransform, self.bAutoClose)
    end
end

function BP_FeinaEventComponent_C:AddPlayerInFogNum()
    if not self.PlayerInFogNum then
        self.PlayerInFogNum = 0
    end
    self.PlayerInFogNum = self.PlayerInFogNum + 1
end

function BP_FeinaEventComponent_C:SubPlayerInFogNum()
    if self.PlayerInFogNum and self.PlayerInFogNum > 0 then
        self.PlayerInFogNum = self.PlayerInFogNum - 1
    end
end

function BP_FeinaEventComponent_C:PlayerInSafe()
    if not self.bFogOpen then
        return
    end
    if self.PlayerInFogNum == 1 then
        self.GameMode:TriggerGameModeEvent("OnPlayerEnterSafe")
    end
    self:RemoveTimer("PlayerInFog")
end

function BP_FeinaEventComponent_C:PlayerOutSafe()
    if not self.bFogOpen then
        return
    end
    if self.PlayerInFogNum and self.PlayerInFogNum > 0 then
        return
    end
    if not self:IsExistTimer("PlayerInFog") then
        self.GameMode:TriggerGameModeEvent("OnPlayerOurSafe")
        self:AddTimer(self.InFogTime, self.OnPlayerLostInFog, false, 0, "PlayerInFog", false, self.SafeTransform, self.bAutoClose)
    end
end
-----------------------------------------------迷雾功能End----------------------------------------------

-----------------------------------------------夜莺功能-------------------------------------------------
function BP_FeinaEventComponent_C:OpenOrCloseFeinaBirdDisCheck(bOpen)
    if not IsValid(self.FeinaBird) then
        return
    end
    self.FeinaBird:OpenOrCloseDisCheck(bOpen)
end

function BP_FeinaEventComponent_C:StartFeinaBirdMove()
    if not IsValid(self.FeinaBird) then
        return
    end
    self.FeinaBird:StartMove()
end

function BP_FeinaEventComponent_C:GetNextPathInfos(NowPathId)
	local EMGameState = self.GameMode.EMGameState
	if EMGameState.NowPathId ~= NowPathId then 
		return nil
	end
	if not EMGameState.HijackPathInfo then 
		return nil
	end
	if not EMGameState.HijackPathInfo[NowPathId] then 
		return nil
	end
	local NewNowPathId = EMGameState.NextPathId
	if NewNowPathId and NewNowPathId ~= 0 and EMGameState.HijackPathInfo[NewNowPathId] then
		local NewPathInfos = EMGameState.HijackPathInfo[NewNowPathId]
		local NewNextPathId = nil
		if NewPathInfos[#NewPathInfos] then
			NewNextPathId = NewPathInfos[#NewPathInfos].NextPathId
		end
		EMGameState.NowPathId = NewNowPathId
		EMGameState.NextPathId = NewNextPathId
		return EMGameState.HijackPathInfo[NewNowPathId]
	end
	return nil
end

function BP_FeinaEventComponent_C:StartFeinaBirdResetMove()
    if not IsValid(self.FeinaBird) then
        return
    end
    self.FeinaBird:StartResetMove()
end

function BP_FeinaEventComponent_C:ResetBirdSpline(PathId, AutoMove)
    if not IsValid(self.FeinaBird) then
        return
    end
    self.FeinaBird:ResetPath(PathId, AutoMove)
end
-----------------------------------------------夜莺功能End----------------------------------------------

function BP_FeinaEventComponent_C:HUDUpdateColor(ColorMax)
    local FeinaEventHUD = UIManager(self):GetUI("FeinaEventHUD")
    if not FeinaEventHUD then return end
    FeinaEventHUD:UpdatePaintIcon(ColorMax)
end

return BP_FeinaEventComponent_C
