require "UnLua"

local BP_AbyssComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

function BP_AbyssComponent_C:InitAbyssComponent()
    self.GameMode = self:GetOwner()

    self:InitListenEvent()

    if GWorld.GameInstance.TempAbyssInfo then
        -- 支持用GM直接进入对应AbyssDungeonId和Difficulty的关卡
        self.AbyssDungeonId = GWorld.GameInstance.TempAbyssInfo.AbyssDungeonId
        self.AbyssDifficulty = GWorld.GameInstance.TempAbyssInfo.AbyssDifficulty
        GWorld.GameInstance.TempAbyssInfo = nil
    else
        self.AbyssLogicServerInfo = self.GameMode.PreInitInfo 
        if not self.AbyssLogicServerInfo then
            DebugPrint("BP_AbyssComponent_C:InitAbyssComponent 从数据恢复拿信息")
            self.AbyssLogicServerInfo = self.GameMode:GetProgressDataAbyssLogicServerInfo()
            if not self.AbyssLogicServerInfo then
                GameState(self):ShowDungeonError("BP_AbyssComponent_C:从逻辑服拿到的信息为空 且 没有从数据恢复拿到信息", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.ServerData)
                return
            end
        end
        DebugPrint("BP_AbyssComponent_C:InitAbyssComponent 从逻辑服拿到的信息 AbyssId", self.AbyssLogicServerInfo.AbyssId, "AbyssLevelId", self.AbyssLogicServerInfo.AbyssLevelId, "AbyssDungeonId", self.AbyssLogicServerInfo.AbyssDungeonId)
        self.AbyssDungeonId = self.AbyssLogicServerInfo.AbyssDungeonId
        self.AbyssDifficulty = self:GetAbyssDifficulty()
    end
    self.GameMode:SetGameModeLevel(self.AbyssDifficulty)

    self.AbyssDungeonInfo = DataMgr.AbyssDungeon[self.AbyssDungeonId]
    if not self.AbyssDungeonInfo then
		GameState(self):ShowDungeonError("BP_AbyssComponent_C:当前AbyssDungeonId没有填写在对应的AbyssDungeon表中, 读表失败! 读入Id："..self.AbyssDungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

    self.AbyssRoomIndex = 0
    self.CurRoomId = 0
    DebugPrint("BP_AbyssComponent_C:InitAbyssComponent AbyssDungeonId", self.AbyssDungeonId, "AbyssDifficulty", self.AbyssDifficulty)
end

function BP_AbyssComponent_C:InitListenEvent()
    EventManager:AddEvent(EventID.OnAbyssSeasonEnd, self, self.OnAbyssSeasonEnd)
end

function BP_AbyssComponent_C:RemoveListenEvent()
    EventManager:RemoveEvent(EventID.OnAbyssSeasonEnd, self)
end

function BP_AbyssComponent_C:ReceiveEndPlay(EndPlayReason)
    self:RemoveListenEvent()
end

function BP_AbyssComponent_C:GetAbyssDifficulty()
    local AbyssId = self.AbyssLogicServerInfo.AbyssId
    local AbyssLevelIndex = self.AbyssLogicServerInfo.AbyssLevelId

    local AbyssLevelIdList = DataMgr.AbyssSeason[AbyssId].AbyssLevelId

    -- 索引从1开始，如果余数为0，Index变为循环长度，LoopTime循环次数-1
    local LoopTime = AbyssLevelIndex // #AbyssLevelIdList
    local RealAbyssLevelIndex = AbyssLevelIndex % #AbyssLevelIdList
    if RealAbyssLevelIndex == 0 then 
        RealAbyssLevelIndex = #AbyssLevelIdList
        LoopTime = LoopTime - 1
    end

    local CurLevelId = AbyssLevelIdList[RealAbyssLevelIndex]        -- AbyssLevelId可循环使用

    local AbyssLevelInfo = DataMgr.AbyssLevel[CurLevelId]
    return AbyssLevelInfo.InitLevel + (AbyssLevelInfo.LevelAddOn or 0) * LoopTime
end

function BP_AbyssComponent_C:GetAbyssId()
    return self.AbyssLogicServerInfo.AbyssId
end

function BP_AbyssComponent_C:InitGlobalPassive()
    if not self.AbyssDungeonId then
        GameState(self):ShowDungeonError("拿不到当前大秘境的Id", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.ServerData)
        return
    end
    local AbyssDungeonData = DataMgr.AbyssDungeon[self.AbyssDungeonId]
    if not AbyssDungeonData then
        GameState(self):ShowDungeonError("读不到当前大秘境配置, Id为 " .. self.AbyssDungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
        return
    end

    local AbyssBuffList = AbyssDungeonData.AbyssBuffID or {}
    for _, AbyssBuffID in pairs(AbyssBuffList) do 
        local AbyssBuffData = DataMgr.AbyssBuff[AbyssBuffID]
        if AbyssBuffData then 
            local GlobalPassiveId = AbyssBuffData.GlobalPassiveId
            local GlobalPassiveLevel = AbyssBuffData.GlobalPassiveLv
            if GlobalPassiveId and GlobalPassiveLevel then 
                local Battle = Battle(self)
                Battle:AddGlobalPassive(GlobalPassiveId, nil, GlobalPassiveLevel)
                DebugPrint("添加全局被动, Id = " .. GlobalPassiveId .. " Level = " .. GlobalPassiveLevel .. " AbyssDungeonId = " .. self.AbyssDungeonId)
            end
        else 
            DebugPrint("Tianyi@ 找不到大秘境词条, Id = " .. AbyssBuffID)
        end
    end
end

-- @ljl: 暂离恢复时，大秘境GameMode初始化不会调用该方法。如有需要，请在ProgressSnapShotComponent中添加逻辑。
function BP_AbyssComponent_C:InitAbyssBaseInfo()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not Player then
        GameState(self):ShowDungeonError("BP_AbyssComponent_C:InitAbyssBaseInfo 拿不到Player", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
        return
    end

    self:InitGlobalPassive()
    -- @zyh: 大秘境创建魅影统一到阵容预设创建魅影里
    --local Avatar = GWorld:GetAvatar()
    --if Avatar then
    --    local AvatarBattleInfo = Avatar.AvatarBattleInfo
    --    if AvatarBattleInfo.PhantomInfo1 and next(AvatarBattleInfo.PhantomInfo1.RoleInfo) then
    --        Player:CreatePhantom(AvatarBattleInfo.PhantomInfo1.RoleInfo.RoleId, 1, AvatarBattleInfo.PhantomInfo1, {IsSpawnBySquad=1})
    --    end
    --    if AvatarBattleInfo.PhantomInfo2 and next(AvatarBattleInfo.PhantomInfo2.RoleInfo) then
    --        Player:CreatePhantom(AvatarBattleInfo.PhantomInfo2.RoleInfo.RoleId, 1, AvatarBattleInfo.PhantomInfo2, {IsSpawnBySquad=1})
    --    end
    --end
    local LevelId = self.GameMode:GetActorLevelName(Player)
    self:TriggerStartNextRoom("", LevelId)
end

function BP_AbyssComponent_C:TriggerStartNextRoom(LastLevelId, NewLevelId)
    -- 真正上报上一房间通关时间的时机
    self:RealSendAbyssPassedTime()

    local gamestate = GameState(self)
    gamestate.AbyssBattleCount = -1
    self.AbyssRoomIndex = self.AbyssRoomIndex + 1
    local AbyssRoomId = self.AbyssDungeonInfo.RoomId[self.AbyssRoomIndex]

    DebugPrint("BP_AbyssComponent_C:TriggerStartNextRoom NewLevelId", NewLevelId, "AbyssRoomIndex", self.AbyssRoomIndex, "AbyssRoomId", AbyssRoomId)
    self.CurRoomId = AbyssRoomId
    self.AbyssRoomInfo = DataMgr.AbyssRoom[AbyssRoomId]
    if not self.AbyssRoomInfo then
        GameState(self):ShowDungeonError("BP_AbyssComponent_C: AbyssRoom表读表失败！ AbyssRoomId "..AbyssRoomId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
        return
    end

    self.GameMode:InitAbyssSubGameMode(self.AbyssRoomInfo.SubGamemode, NewLevelId)

    local SubGameMode = self.GameMode.SubGameModeInfo:FindRef(NewLevelId)
    if IsValid(SubGameMode) then
        self.GameMode:OnStartNextRoom(LastLevelId, NewLevelId);
		SubGameMode:OnAbyssRoomBegin(NewLevelId, AbyssRoomId);
    else
        GameState(self):ShowDungeonError("Error: BP_AbyssComponent_C:TriggerStartNextRoom 传入参数不合法"..LastLevelId..NewLevelId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Implement)
    end
end

function BP_AbyssComponent_C:RealSendAbyssPassedTime()
    if self.CachedPassedTime then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:TriggerCompleteAbyssRoom(self.CurRoomId, self.CachedPassedTime)
            DebugPrint("BP_AbyssComponent_C:TriggerStartNextRoom SendAbyssPassedTime", self.CurRoomId, self.CachedPassedTime)
        end
        self.CachedPassedTime = nil
    end
end

function BP_AbyssComponent_C:GetAbyssRoomIndex()
    return self.AbyssRoomIndex
end

-- 为了大秘境暂离返回，所有上报的时机改到进入下一房间玩家过门时
function BP_AbyssComponent_C:SendAbyssPassedTime(_PassedTime)
    local PassedTime = math.ceil(_PassedTime)
    -- local Avatar = GWorld:GetAvatar()
    -- Avatar:TriggerCompleteAbyssRoom(self.CurRoomId, PassedTime)
    self.CachedPassedTime = PassedTime
    DebugPrint("BP_AbyssComponent_C: SendAbyssPassedTime To Cache RoomId", self.CurRoomId, "PassedTime", PassedTime)
end

function BP_AbyssComponent_C:TriggerAbyssOnEnd()
    --更新词条红点
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
     --赛季信息
    local AbyssInfo = Avatar.Abysses[self.AbyssLogicServerInfo.AbyssId]
    if not AbyssInfo then
        return
    end
    local AbyssLevelInfo = AbyssInfo.AbyssLevelList[self.AbyssLogicServerInfo.AbyssLevelId]
    if not  AbyssLevelInfo  then 
        return 
    end
    local IsPassed= AbyssLevelInfo:IsAbyssLevelPass()
    if not IsPassed then
        return
    end
    local HasShow=self.AbyssLogicServerInfo.AbyssLevelId.."HasShow"
    local Entry1Detail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry1")
    if Entry1Detail[HasShow] then
        return
    else
        Entry1Detail[HasShow]=true
    end
    local AbyssId = self.AbyssLogicServerInfo.AbyssId
    local AbyssLevelIndex = self.AbyssLogicServerInfo.AbyssLevelId
    local AbyssLevelIdList = DataMgr.AbyssSeason[AbyssId].AbyssLevelId
    local RealAbyssLevelIndex = AbyssLevelIndex % #AbyssLevelIdList
    if RealAbyssLevelIndex == 0 then RealAbyssLevelIndex = #AbyssLevelIdList end
    local AbyssLevel = DataMgr.AbyssLevel
      --local PreLevel=self.AbyssLogicServerInfo.AbyssLevelId
    local PreLevel = AbyssLevelIdList[RealAbyssLevelIndex] 
    if not PreLevel then
        return
    end
    local NowLevel=PreLevel+1
    local DungeonId1=AbyssLevel[PreLevel].AbyssDungeon1
    local NewDungeon1BuffIds={}
    local NewDungeon2BuffIds={}
    if DungeonId1 then
        local PreDungeon1BuffIds={}
        local NowDungeon1BuffIds={}
        if AbyssLevel[NowLevel] then
            local NowDungeonId1=AbyssLevel[NowLevel].AbyssDungeon1
            NowDungeon1BuffIds=DataMgr.AbyssDungeon[NowDungeonId1].AbyssBuffID
        end
        if AbyssLevel[PreLevel] then
            local PreDungeonId1=AbyssLevel[PreLevel].AbyssDungeon1
            PreDungeon1BuffIds=DataMgr.AbyssDungeon[PreDungeonId1].AbyssBuffID
        end
        for _, Buff2Id in pairs(NowDungeon1BuffIds) do
            local Isfind=false
            for _, Buff1Id in pairs(PreDungeon1BuffIds) do
                if Buff2Id==Buff1Id then
                    Isfind=true
                    goto continue
                end
            end
            ::continue::
            if not Isfind then
                table.insert(NewDungeon1BuffIds,Buff2Id)
            end
        end
    end
    local DungeonId2=AbyssLevel[PreLevel].AbyssDungeon2
    if DungeonId2 then
        local PreDungeon2BuffIds={}
        local NowDungeon2BuffIds={}
        if AbyssLevel[NowLevel] then
            local NowDungeonId2=AbyssLevel[NowLevel].AbyssDungeon2
            NowDungeon2BuffIds=DataMgr.AbyssDungeon[NowDungeonId2].AbyssBuffID
        end
        if AbyssLevel[PreLevel] then
            local PreDungeonId2=AbyssLevel[PreLevel].AbyssDungeon2
            PreDungeon2BuffIds=DataMgr.AbyssDungeon[PreDungeonId2].AbyssBuffID
        end
        for _, Buff2Id in pairs(NowDungeon2BuffIds) do
            local Isfind=false
            for _, Buff1Id in pairs(PreDungeon2BuffIds) do
                if Buff2Id==Buff1Id then
                    Isfind=true
                    goto continue
                end
            end
            ::continue::
            if not Isfind then
                table.insert(NewDungeon2BuffIds,Buff2Id)
            end
        end
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry1")
    local HasNew=false
    for _, Value in ipairs(NewDungeon1BuffIds) do
        local CacheKey = tostring(Value)
        if not CacheDetail[self.AbyssLogicServerInfo.AbyssId] then
            CacheDetail[self.AbyssLogicServerInfo.AbyssId]={}
        end
        if not CacheDetail[self.AbyssLogicServerInfo.AbyssId][CacheKey] then
            CacheDetail[self.AbyssLogicServerInfo.AbyssId][CacheKey]=true
            HasNew=true
        end
    end
    if HasNew then
        ReddotManager.IncreaseLeafNodeCount("AbyssEntry1")
    end
    HasNew=false
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry2")
    for _, Value in ipairs(NewDungeon2BuffIds) do
        local CacheKey = tostring(Value)
        if not CacheDetail[self.AbyssLogicServerInfo.AbyssId] then
            CacheDetail[self.AbyssLogicServerInfo.AbyssId]={}
        end
        if not CacheDetail[self.AbyssLogicServerInfo.AbyssId][CacheKey] then
            CacheDetail[self.AbyssLogicServerInfo.AbyssId][CacheKey]=true
            HasNew=true
        end
    end
    if HasNew then
        ReddotManager.IncreaseLeafNodeCount("AbyssEntry2")
    end
end

-- 副本进行中 赛季结束需要中断副本并直接结算的逻辑
function BP_AbyssComponent_C:OnAbyssSeasonEnd(AbyssSeasonId)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

    EventManager:RemoveEvent(EventID.OnAbyssSeasonEnd, self)
	DebugPrint("BP_AbyssComponent_C:OnAbyssSeasonEnd")
	if Avatar:IsInEnterDungeon() then
		-- 如果是正在loading收到的，等到closeloading再调
		EventManager:AddEvent(EventID.CloseLoading, self, function()
			EventManager:RemoveEvent(EventID.CloseLoading, self)
            self:ShowSeasonEndPopup()
		end)
	else
		self:ShowSeasonEndPopup()
	end
end

function BP_AbyssComponent_C:ShowSeasonEndPopup()
	local Params = {}
	Params.RightCallbackFunction = function()
		self.GameMode:TriggerDungeonWin()
	end
	UIManager(self):ShowCommonPopupUI(100225, Params)
end

-- 策划允许正在死亡过程中，重新进入大秘境
-- 为了解决 发TriggerReEnterAbyss rpc等待回调的过程中，恰好走到结算、发了副本结算的rpc，
-- 导致重新挑战后无法正确上报分数的问题
function BP_AbyssComponent_C:SetReEnteringAbyss()
    DebugPrint("BP_AbyssComponent_C:SetReEnteringAbyss")
    self.IsReEntering = true
end

function BP_AbyssComponent_C:IsReEnteringAbyss()
    return self.IsReEntering or false
end


return BP_AbyssComponent_C
