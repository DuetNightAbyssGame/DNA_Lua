local FSM= require "BluePrints.UI.ControllerFSM"
local MiscUtils = require "Utils.MiscUtils"
local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'

local IsBattleMainInVisible = function()
    local Player = GWorld:GetMainPlayer()
    if Player and Player.IsImmersionModel then
        return false
    end
    local BattleMain = UIManager():GetUIObj("BattleMain")
    return IsValid(BattleMain) and (BattleMain.IsPlayOutAnim or not BattleMain:IsVisible())
end

--region StateImpl
local State = {
    __index = {
        GetNextState = function(self)
            return DataMgr.AfterLoadingFSM[self.StateName].NextState
        end,
        OnAfterEnter = function(AfterLoadingMgr, NowState)
            AfterLoadingMgr:Fallback(NowState)
        end
    },
    New = function(Class, StateName, FuncTable)
        local NewObj = {}
        setmetatable(NewObj, Class)
        NewObj.OnEnter = function(AfterLoadingMgr) 
            try({
                exec = FuncTable.OnEnter,
                catch = function(err)
                    DebugPrint(ErrorTag, string.format("AfterLoading有流程出错了,出错状态：%s, 请根据日志报错的行去找人",AfterLoadingMgr.FSM:Current()))
                    LogError(Traceback(ErrorTag, err,true))
                    UIManager():DestroyAfterLoadingMgr()
                end,
            }, AfterLoadingMgr)
        end
        NewObj.StateName = StateName
        if FuncTable.OnAfterEnter then
            NewObj.OnAfterEnter = FuncTable.OnAfterEnter
        end
        if FuncTable.OnLeave then
            NewObj.OnLeave = FuncTable.OnLeave
        end
        if FuncTable.GetNextState then
            NewObj.GetNextState = FuncTable.GetNextState
        end
        return NewObj
    end,
}

local StateImpl = Class("BluePrints.Common.TimerMgr")

StateImpl.BeginState = State:New("BeginState", {
    OnEnter = function(AfterLoadingMgr) 
        GWorld.NetworkMgr:UpdateNetDisconnectUIConfirm()
        local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
        if IsValid(GameInputSubsystem) then
            GameInputSubsystem:DisableInputMode("CommonChangeScene")
        end
        GWorld.StoryMgr:EnableStory()
        local PlayerCharacter = GWorld:GetMainPlayer()
        if PlayerCharacter then
            PlayerCharacter:SetCanInteractiveTrigger(true, "Loading")
        end
        
    end,
    GetNextState = function(self) 
        return DataMgr.AfterLoadingFSM[self.StateName].NextState
    end,
})

StateImpl.JumpToRogueMain = State:New("JumpToRogueMain", {
    OnEnter = function(AfterLoadingMgr)
        local PlayerCharacter = GWorld:GetMainPlayer()
        local CurDungeonType = WorldTravelSubsystem():GetCurrentDungeonType()
        if CurDungeonType == CommonConst.DungeonType.Abyss then
            if PlayerCharacter then
                PlayerCharacter:DisableBattleWheel()
            end
        end
        local GameState = GameState()
        if GameState and GameState.IsInRegion and GameState:IsInRegion() then     -- 退出登录到主界面时，拿到的GameState不是EMGameState而是GameStateBase
            local ExitDungeonInfo = GWorld.GameInstance:GetExitDungeonData()
            if ExitDungeonInfo then
                GWorld.GameInstance:ClearExitDungeonData()
                if ExitDungeonInfo.Type == "Abyss" then
                    local AbyssId = ExitDungeonInfo.AbyssId
                    local AbyssLevelId = ExitDungeonInfo.AbyssLevelId
                    local AbyssDungeonIndex = ExitDungeonInfo.AbyssDungeonIndex
                    PageJumpUtils:JumpToAbyssLevelInfoPage(AbyssId, AbyssLevelId, AbyssDungeonIndex)
                elseif ExitDungeonInfo.Type == "Rouge" then
                    PageJumpUtils:JumpToRougeMain("ExitFromRouge")
                elseif ExitDungeonInfo.Type == "TryOut" then
                    local CurTabIndex = ExitDungeonInfo.CurTabIndex
                    local CurSelectIndex = ExitDungeonInfo.CurSelectIndex
                    local ActivityId = ExitDungeonInfo.ActivityId
                    PageJumpUtils:JumpToTryOut(CurTabIndex, ActivityId, CurSelectIndex)
                elseif ExitDungeonInfo.Type == "Paotai" then
                    local CurTabIndex = ExitDungeonInfo.CurTabIndex
                    local CurSelectIndex = ExitDungeonInfo.CurSelectIndex
                    PageJumpUtils:JumpToPaotai(CurTabIndex, CurSelectIndex)
                elseif ExitDungeonInfo.Type == "FeinaEvent" then
                    local CurTabIndex = ExitDungeonInfo.CurTabIndex
                    PageJumpUtils:JumpToFeinaEvent(CurTabIndex)
                elseif ExitDungeonInfo.Type == "Depute" then
                    if not ExitDungeonInfo.IsFromRegionMechanism then
                        local DeputeType = ExitDungeonInfo.DeputeType
                        --临时处理
                        PageJumpUtils:JumpToStyleOfPlaySubUI("NewDeputeRoot", true, DeputeType)
                    end
                elseif ExitDungeonInfo.Type == "GuildWar" then    
                    local JumpId = ExitDungeonInfo.JumpId               
                    PageJumpUtils:JumpToTargetPageByJumpId(JumpId,false ,false, true)
                elseif ExitDungeonInfo.Type == "Temple" then
                    local CurTabIndex = ExitDungeonInfo.CurTabIndex
                    PageJumpUtils:JumpToTempleSolo(CurTabIndex)
                elseif ExitDungeonInfo.Type == "MonsterRush" then
                    local CurTabIndex = ExitDungeonInfo.CurTabIndex
                    local EventId = ExitDungeonInfo.EventId
                    local DungeonId = ExitDungeonInfo.DungeonId
                    PageJumpUtils:JumpToMonsterRush(CurTabIndex, EventId, DungeonId)
                elseif ExitDungeonInfo.Type == "AutoChess" then
                    PageJumpUtils:JumpToAutoChessMain()
                elseif ExitDungeonInfo.Type == "SoloTreasure" then
                    if ExitDungeonInfo.Mode == 1 then -- 只有复刷关需要
                        local EventId = ExitDungeonInfo.EventId
                        local Mode = ExitDungeonInfo.Mode
                        local EventDungeonId = ExitDungeonInfo.EventDugeonId
                        PageJumpUtils:SoloTreasureRepeatLevel(EventId, Mode, EventDungeonId)
                    end
                end
            end
        end
    end,
})

StateImpl.GameplayReward = State:New("GameplayReward",{
    OnEnter = function(AfterLoadingMgr)
        --@todo 玩法奖励啥的..
    end,
})

StateImpl.DungeonUI = State:New("DungeonUI", {
    OnEnter = function(AfterLoadingMgr)
        ---@todo dungeonUI没有解耦，强行接过来会有些问题，以后再说
    end, 
})

StateImpl.SystemUnlock = State:New("SystemUnlock", {
    OnEnter = function(AfterLoadingMgr)
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:HandleCloseLoadingEvent_WhileSystemUnlock()
        end
    end, 
})

StateImpl.Entertainment = State:New("Entertainment", {
    OnEnter = function(AfterLoadingMgr)
        local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, USojournsGameInstanceSubsystem)
        if SojournsGameInstanceSubsystem then
            SojournsGameInstanceSubsystem:OnEnterOtherRegion()
        end
    end,

    GetNextState = function(self,AfterLoadingMgr)
        local NextStateName = DataMgr.AfterLoadingFSM[self.StateName].NextState
        local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, USojournsGameInstanceSubsystem)
        if not SojournsGameInstanceSubsystem then
            return NextStateName
        end

        if SojournsGameInstanceSubsystem:IsNeedBlockAfterLoading() then
            return self.StateName
        end

        return NextStateName
    end
})

StateImpl.TriggerGuide = State:New("TriggerGuide", {
    OnEnter = function(AfterLoadingMgr)
        local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
        local GameMode = MiscUtils.GameMode()
        if(not GWorld.GameInstance:IsNullDungeonId(DungeonId)) then
            DebugPrint("SystemGuide Enter Dungeon" )
            EventManager:FireEvent(EventID.ExitRegion)
            EventManager:FireEvent(EventID.SystemGuideEnterDungeon, DungeonId)
        elseif(GameMode ~= nil and GameMode.IsInRegion and GameMode:IsInRegion()) then
            local CurMode =  UE4.URuntimeCommonFunctionLibrary.GetInputMode(GWorld.GameInstance:GetWorld())
            DebugPrint("SystemGuide Enter Region" ,CurMode)
            EventManager:FireEvent(EventID.SystemGuideEnterRegion)
        else
            DebugPrint( "ERROR:SystemGuide Not Enter Region And Not Enter Dungeon")
        end
        -- if not SystemGuideManager.IsGuideStoryRunning then
        --     UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "gm runstory guide/Guide_Mod")
        -- end
    end, 
    GetNextState = function(self,AfterLoadingMgr)
        if AfterLoadingMgr.bGuideEndPending then
            AfterLoadingMgr.bGuideEndPending = nil
            if IsBattleMainInVisible() then
                return self.StateName
            else
                return DataMgr.AfterLoadingFSM[self.StateName].NextState
            end
        end
        if StorylineUtils:IsGuideNodeRunning() or IsBattleMainInVisible() then
            return self.StateName
        else
            return DataMgr.AfterLoadingFSM[self.StateName].NextState
        end
    end,
})

StateImpl.OpenForcePopup = State:New("OpenForcePopup",{
    OnEnter = function(AfterLoadingMgr)
        local GameMode = MiscUtils.GameMode()
        local GameState = GameState()
        if GameMode ~= nil and GameState ~= nil  then
            if GameState.GameModeType=="Trial" then
                AfterLoadingMgr:Pause()
                UIManager():AddTimer(0.1, function()
                    UIManager():LoadUINew("TryOutMain")
                end, false, 0,nil, true)
                return
            end
        end

        --UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "gm A:OnGetMonthlyCardDailyReward({Resources = {[99]=90}})")
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            if ReturnActivityController and ReturnActivityController.DisplayReturnWelcomBannerCache then
                ReturnActivityController.DisplayReturnWelcomBannerCache = nil
                ReturnActivityController:TryDisplayReturnWelcomBanner()
            end
            MonthCardController:TryPopUpCacheReward()
            UIManager(PlayerCharacter):TryShowPlayerLevelUpInfo({CurLevel = Avatar.Level, ShowProgresBar = false})
        end
    end,
})

StateImpl.LayoutPlan = State:New("LayoutPlan",{
    OnEnter = function(AfterLoadingMgr)
        local Avatar = GWorld:GetAvatar()
        if Avatar and UIUtils.IsMobileInput() then
            local PlayerCharacter = GWorld:GetMainPlayer()
            local LayoutPlanIndex = Avatar:GetCurrentMobileHudPlanIndex()
            local LayoutPlanCount = Avatar:GetMobileHudPlanCount()
            local ResPlant = LayoutPlanCount == 0 and LayoutPlanIndex == 1
            if ResPlant then
                UIManager(PlayerCharacter):LoadUINew("LayoutPlan")
            end
        end
    end,
})

StateImpl.MainLineQuest = State:New("MainLineQuest",{
    OnEnter =function(AfterLoadingMgr)
        local GameMode = MiscUtils.GameMode()
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar.NotifyAvatarRegionAllReady and GameMode and GameMode:IsInRegion() then
            local BattleMainUI = UIManager():GetUIObj("BattleMain")
            if Avatar and Avatar.TrackingQuestChainId ~= 0 and Avatar.TrackingQuestChainId ~= nil and BattleMainUI.Pos_TaskBar then
                BattleMainUI.Pos_TaskBar:SetVisibility(UIConst.VisibilityOp.Visible)
            else
                BattleMainUI.Pos_TaskBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
            Avatar:NotifyAvatarRegionAllReady()
        end
    end,
    OnAfterEnter = function(AfterLoadingMgr, NowState)
        if not GWorld.StoryMgr then return end
        local WaitOfTimeNodeTable = {}
        GWorld.StoryMgr:GetRunningNodeTableByType("WaitOfTimeNode",WaitOfTimeNodeTable)
        if not table.isempty(WaitOfTimeNodeTable) then
            return
        end
        local TalkNodeTable = {}
        GWorld.StoryMgr:GetRunningNodeTableByType("TalkNode",WaitOfTimeNodeTable)
        if not table.isempty(TalkNodeTable) then
            return
        end
        AfterLoadingMgr:Fallback(NowState)
    end,
    GetNextState = function(self,AfterLoadingMgr)
        if AfterLoadingMgr.bGuideEndPending then
            AfterLoadingMgr.bGuideEndPending = nil
            if IsBattleMainInVisible() then
                return self.StateName
            else
                return DataMgr.AfterLoadingFSM[self.StateName].NextState
            end
        end
        if StorylineUtils:IsGuideNodeRunning() or IsBattleMainInVisible() then
            return self.StateName
        else
            return DataMgr.AfterLoadingFSM[self.StateName].NextState
        end
    end
})


StateImpl.DynamicQuest = State:New("DynamicQuest", {
    OnEnter =function(AfterLoadingMgr) 
        local GameMode = MiscUtils.GameMode()
        if GameMode and GameMode.ActivateDynamicQuestEvent then
            GameMode:ActivateDynamicQuestEvent()
        end
    end,
    OnAfterEnter = function(AfterLoadingMgr, NowState)
        if not GWorld.StoryMgr then return end
        local WaitOfTimeNodeTable = {}
        GWorld.StoryMgr:GetRunningNodeTableByType("WaitOfTimeNode",WaitOfTimeNodeTable)
        if not table.isempty(WaitOfTimeNodeTable) then
            return
        end
        local TalkNodeTable = {}
        GWorld.StoryMgr:GetRunningNodeTableByType("TalkNode",WaitOfTimeNodeTable)
        if not table.isempty(TalkNodeTable) then
            return
        end
        AfterLoadingMgr:Fallback(NowState)
    end,
    GetNextState = function(self,AfterLoadingMgr)
        if AfterLoadingMgr.bGuideEndPending then
            AfterLoadingMgr.bGuideEndPending = nil
            if IsBattleMainInVisible() then
                return self.StateName
            else
                return DataMgr.AfterLoadingFSM[self.StateName].NextState
            end
        end
        if StorylineUtils:IsGuideNodeRunning() or IsBattleMainInVisible() then
            return self.StateName
        else
            return DataMgr.AfterLoadingFSM[self.StateName].NextState
        end
    end
})

StateImpl.EndState = State:New("EndState", {
    OnEnter =function(AfterLoadingMgr) 
        UIManager():DestroyAfterLoadingMgr()
        UIManager():StartScriptDetectionCheck()
    end,
    GetNextState = function(self) end,
})

--endregion

--region AfterLoadingMgr
local AfterLoadingMgr = Class()

function AfterLoadingMgr.New()
    local NewObj = {}
    setmetatable(NewObj, AfterLoadingMgr)
    NewObj.FSM = FSM.New(NewObj, StateImpl)
    return NewObj
end

function AfterLoadingMgr:Pause()
    self.bPause = true
    DebugPrint(WarningTag, string.format("AfterLoadingMgr 状态机暂停，当前状态：%s",self.FSM:Current()))
end

function AfterLoadingMgr:Fallback(State)
    if not State then State = self.FSM:Current() end
    if (not self.bPause) and self:IsCurrentState(State) then
        DebugPrint(WarningTag, string.format("AfterLoadingMgr 状态机没有被暂停，继续执行 State: %s",State))
        self:Continue()
    end
end

function AfterLoadingMgr:IsCurrentState(State)
    return self.FSM:Current() == State
end

function AfterLoadingMgr:IsEnd()
    local CurrState = self.FSM:Current()
    return CurrState == "EndState" 
end

function AfterLoadingMgr:Continue()
    if self.bPause then
        DebugPrint(WarningTag, string.format("AfterLoadingMgr 状态机从暂停中恢复, CurrState: %s",self.FSM:Current()))
    end
    self.bPause = false
    if self:IsEnd() then
        DebugPrint(WarningTag, "AfterLoadingMgr 状态机执行完毕！！！")
        return
    end
    local CurrState = self.FSM:Current()
    if not CurrState then 
        DebugPrint(WarningTag, "AfterLoadingMgr 状态机开始执行！！！")
        self.FSM:Enter("BeginState")
        return
    end
    local NextState = StateImpl[CurrState]:GetNextState(self)
    if NextState then
        if NextState == CurrState then
            DebugPrint(WarningTag, string.format("AfterLoadingMgr GetNextState保持原状，暂停切换 CurrState:%s",CurrState))
            return
        end
        DebugPrint(WarningTag, string.format("AfterLoadingMgr 切换状态，前个状态：%s，下个状态：%s",CurrState, NextState))
        self.FSM:Enter(NextState)
    end
end
--endregion

return AfterLoadingMgr