local Component = {}

-- ds通知客户端开始播sequence
function Component:OpeningSequence_Lua()
    --EventManager:AddEvent(EventID.OnHardBossOpeningSequencePause, self, self.OnHardBossOpeningSequencePauseCallback)
    -- 用来标识，自己和联机的人是否都准备好了
    -- self.IsSelfReady = false
    -- self.IsOtherPlayerReady = false

    --self:ClientHideHardBossDgActor(true, "Boss")      -- 移到bossbattleopennode里统一做了
    self:ClientHideHardBossDgActor(true, "AirWall")

    local HardBossInfo = DataMgr.HardBossDg[self.DungeonId]
    local HardBossMainInfo = DataMgr.HardBossMain[HardBossInfo.HardBossId]
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.HardBossInfo = {}
    GameState.HardBossInfo["BossBattleId"] = HardBossInfo.HardBossId
    GameState.HardBossInfo["DifficultyId"] = HardBossInfo.DifficultyId
    local StorylinePath = HardBossMainInfo.StorylinePath
    if StorylinePath then
        local STLCallback = function()
            self:ClientHardBossOpeningCallback()
        end
        --GWorld.StoryMgr:RunStory(StorylinePath, 10100, nil, STLCallback, STLCallback)       -- 后续考虑封装下/放到函数库里
        self:ClientSafeRunStory(StorylinePath, 10100, STLCallback)
        return
    else
        self:ClientHardBossOpeningCallback()
    end
end

function Component:RemoveOpeningSequence_Lua()
    -- self.IsOtherPlayerReady = true
    -- self:CheckCanPlay()
end

-- 1.2新流程，客户端无需暂停sequence来等待其他玩家ready了，相关逻辑先干掉
-- function Component:OnHardBossOpeningSequencePauseCallback()
--     -- 通知ds 该客户端播完剧情了
--     local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--     Player.RPCComponent:NotifyServerPlaySequenceFinish(Player.Eid)
--     self.IsSelfReady = true
--     self:CheckCanPlay()
-- end

-- function Component:CheckCanPlay()
--     if self.IsSelfReady and self.IsOtherPlayerReady then
--         EventManager:FireEvent(EventID.OnHardBossOpeningAllPlayerReady)
--     end
-- end

function Component:ClientHardBossOpeningCallback()
    --self:ClientHideHardBossDgActor(false, "Boss")     -- 移到bossbattleopennode里统一做了
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player.RPCComponent:NotifyServerPlaySequenceFinish(Player.Eid)

    self:ClientHideHardBossDgActor(false, "AirWall")
end

--region 客户端播sequence隐藏Actor相关

---@type fun(IsHide: boolean, ActorType: string) @对外接口，联机梦魇专用，用于客户端隐藏部分Actor
---@param IsHide boolean @是否隐藏
---@param ActorType string @Actor类型，支持 "Boss", "AirWall"
function Component:ClientHideHardBossDgActor(IsHide, ActorType)
    local TimerHandle = "HideHardBossDgBoss_"..ActorType

    if IsHide then
        local HideSucc = self:TryHideActor(true, ActorType)
        -- 加个timer 万一这时客户端拿不到boss
        if not HideSucc then
            self:AddTimer(0.1, function()
                local IsHideSucc = self:TryHideActor(true, ActorType)
                if IsHideSucc then
                    self:RemoveTimer(TimerHandle)
                end
            end, true, 0, TimerHandle, true)
        end
    else
        self:RemoveTimer(TimerHandle)
        self:TryHideActor(false, ActorType)
    end
end

---@type fun(IsHide: boolean, ActorType: string) : boolean  @真正显示/隐藏Actor，不对外
---@param IsHide boolean @是否隐藏
---@param ActorType string @Actor类型，支持 "Boss", "AirWall"
---@return boolean @是否显示/隐藏成功
function Component:TryHideActor(IsHide, ActorType)
    if ActorType == "Boss" then
        local Boss = self:GetBossMonsterByType()
        if not Boss then
            return false
        end
        Boss:SetActorHideTag("HardBossDg", IsHide, false, true)
    elseif ActorType == "AirWall" then
        local AirWall = self:GetAirWallByUnitId()
        if not AirWall then
            return false
        end
        AirWall:SetActorHideTag("HardBossDg", IsHide)
    end
    return true
end

-- 这里先偷个懒吧，直接拿当前场上type为boss的怪物
-- 本来想读表根据UnitId拿的，但是设计表的时候，会根据人数生成不同UnitId的Boss，客户端拿起来太麻烦了
function Component:GetBossMonsterByType()
    for _, Monster in pairs(self.MonsterMap) do
        if IsValid(Monster) and (Monster.IsBossMonster) and Monster:IsBossMonster() then
            return Monster
        end
    end
    return nil
end

function Component:GetAirWallByUnitId()
    for _, CombatItem in pairs(self.CombatItemMap) do
        if IsValid(CombatItem) and CombatItem.UnitId == Const.HardBossDgPrepareAirwallId then
            return CombatItem
        end
    end
    return nil
end

--endregion

return Component