--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Theater_Toast_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"

-- stageinfo:
-- step 1：开幕
-- step 2,4,6,8,10: 第1-5轮
-- step 3,5,7,9: 轮间休息
-- step 11: 结束
-- step 12: 谢幕结束进入待机

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    self.RewardList = {}
    self.LevelList = {}
    self.LevelId2Index = {}
    self.StageTime = 0
    self.StepInfo = {}
    self.Step = 0
    self.TheaterConstant = DataMgr.TheaterConstant
    self.CurrentSelectedEntry = nil
    self.CurrentGameRound = 0 -- 当前进行到第几轮
    self.CurrentRoundState = false
    self.EnablePerform = true
    self.ReStartPerform = false
end

function M:Construct()
    local TargetNpc = self:FindTargetNpc()
    self:PlayTalk(DataMgr.TheaterConstant.StartGameTalkConfigId.ConstantValue, TargetNpc)
    self:InitItemInfo()
    self:InitListenEvent()
    
    self.Panel_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.ProgressBar_Title:SetPercent(0)
    self:PlayAnimation(self.Open_In)

    self.Text_open:SetText(GText("TheaterOnline_Game_Start01"))
    self.Text_open2:SetText(GText("TheaterOnline_Game_Start02"))

    AudioManager(self):PlayUISound(self, "event:/ui/common/toast_positive", nil, nil)
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnTheaterPerformGameEnd, self, self.TheaterPerformGameEnd)
    self:AddDispatcher(EventID.OnTheaterLevelStart, self, self.OnLevelStart)
    self:AddDispatcher(EventID.OnTheaterPerform, self, self.TheaterPerform)
end

function M:InitItemInfo()
    -- todo:对应n个关卡
    self.LevelList = {
        {LevelId = "1001", LevelName = GText("剧院联机-关卡1"), LevelIndex = 1, PerformId = 0},
        {LevelId = "1002", LevelName = GText("剧院联机-关卡2"), LevelIndex = 2, PerformId = 0},
        {LevelId = "1003", LevelName = GText("剧院联机-关卡3"), LevelIndex = 3, PerformId = 0},
        {LevelId = "1004", LevelName = GText("剧院联机-关卡4"), LevelIndex = 4, PerformId = 0},
        {LevelId = "1005", LevelName = GText("剧院联机-关卡5"), LevelIndex = 5, PerformId = 0},
    }

    for i = 1, 12 do
        self.StepInfo[i] = {
            Time = self.TheaterConstant["Step"..i] and self.TheaterConstant["Step"..i].ConstantValue or 0, -- 这里指的是各个阶段的开始时间
            Refer = nil,
            RandomId = nil,
        }
    end
    self.ListView_Title:ClearListItems()
    local StartTime = TimeUtils.NowTime()
    for Index, Level in pairs(self.LevelList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.LevelId = Level.LevelId
        Content.LevelName = Level.LevelName
        Content.Time = self.StepInfo[Index * 2 + 1].Time - self.StepInfo[Index * 2].Time
        Content.StartTime = StartTime + self.StepInfo[Index * 2].Time
        Content.EndTime = StartTime + self.StepInfo[Index * 2 + 1].Time
        Content.Index = Index
        Content.ParentWidget = self
        self.ListView_Title:AddItem(Content)
        self.LevelId2Index[Level.LevelId] = Index
    end
    self.ListView_Title:RequestRefresh()
end

function M:ResetPerformedRound()
    local PassedTime = TimeUtils.NowTime() - self.ActivityStartTime
    local CurStage
    local ProgressPercent = 0
    
    self:AddDelayFrameFunc(function()
        for i = 2, 11 do
            local StageStartTime = self.StepInfo[i].Time
            local NextStageStartTime = self.StepInfo[i + 1] and self.StepInfo[i + 1].Time or math.huge
            
            if PassedTime > NextStageStartTime then
                if i % 2 == 0 then
                    -- 已结束的表演轮次
                    local Index = math.tointeger(i / 2)
                    ProgressPercent = (Index - 1) * 0.25
                    local Item = self.ListView_Title:GetItemAt(Index - 1)
                    if Item.SelfWidget then
                        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
                        if GameInstance.TheaterPerformState and GameInstance.TheaterPerformState[Index] == true then
                            Item.SelfWidget:PlayAnimation(Item.SelfWidget.Success)
                        else
                            Item.SelfWidget:PlayAnimation(Item.SelfWidget.Fail)
                        end
                        Item.SelfWidget.Image_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
                    end
                    local Percent = (Index - 1) * 0.25
                    self.ProgressBar_Title:SetPercent(Percent)
                end
            else
                -- 在当前轮次重新进入
                -- 若此时处于表演轮次，当前轮次直接失败,参加下一回合
                -- 若处于休息轮次，则等待表演开始
                if i % 2 ~= 0 then
                    local Percent = (PassedTime - StageStartTime) / (NextStageStartTime - StageStartTime) * 0.25
                    self.ProgressBar_Title:SetPercent(ProgressPercent + Percent)
                else
                    local Index = math.tointeger(i / 2)
                    local Item = self.ListView_Title:GetItemAt(Index - 1)
                    if Item.SelfWidget then
                        -- 处理当前的表演
                        Item.SelfWidget:PlayAnimation(Item.SelfWidget.Fail)
                        Item.SelfWidget.Image_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
                        self.InterruptedRound = Index
                    end
                    local Percent = (Index - 1) * 0.25
                    self.ProgressBar_Title:SetPercent(Percent)
                end
                break
            end
        end
        self:StartStageTimer()
    end, 5)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
end

function M:UpdatePerformList(PerformList)
    if not PerformList then
        return
    end
    for Index, PerformId in pairs(PerformList) do
        self.LevelList[Index].PerformId = PerformId
    end
end

function M:TheaterPerform(PerformId)
    DebugPrint("ayff test Perform :", PerformId)
    if self.CurrentRoundState == true then
        return
    end
    if not self.EnablePerform then
        DebugPrint("ayff 当前不允许表演，忽略此次请求")
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local function Cb(ErrCode, Ret)
        DebugPrint("ayff test 剧院回调：", ErrorCode:Name(ErrCode), Ret)
        self:TheaterPerformCallback(ErrCode, Ret)
    end
    local PerformIndex = self.CurLevelIndex or 0
    if PerformIndex ~= 0 then
        Avatar:TheaterPerform(math.tointeger(PerformId), PerformIndex, Cb)
    end
end

function M:TheaterPerformCallback(ErrCode,Ret)
    DebugPrint("ayff 剧院活动表演结果:", ErrorCode:Name(ErrCode), Ret)
    local ErrorContent = DataMgr.ErrorCode[ErrCode] and DataMgr.ErrorCode[ErrCode].ErrorCodeContent or GText("无误")
    DebugPrint("ayff 剧院活动表演结果提示内容:", ErrorContent)
    if ErrCode == ErrorCode.RET_SUCCESS then
        local DelayTime = DataMgr.TheaterConstant.TheaterPerformResultDelay.ConstantValue or 0
        self:AddTimer(DelayTime, function()
            self:PlayAnimation(self.Tips_Success)
            AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_skill_match", nil, nil)
        end, false, 0, "TheaterPerformResultDelay")
        if self.CurrentSelectedEntry then
            self.CurrentSelectedEntry:SetSuccess(true)
            self.CurrentRoundState = true
        end
        
	    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        if not GameInstance.TheaterPerformState then
            GameInstance.TheaterPerformState = {}
        end
        GameInstance.TheaterPerformState[self.CurLevelIndex] = true
    else
    end
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Open_In then
        self:PlayAnimation(self.Open_Out)
        self:OnActivityStart()
    elseif InAnimation == self.Tips_Success then
        -- 会导致在匹配成功后，tips闪烁一下
        -- self:PlayAnimation(self.Tips_Out)
    end
end

function M:OnActivityStart()
    -- todo:匹配活动期间，NPC头顶的活动UI隐藏，不再进行显示，仅显示名字和气泡
    self.Panel_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.Title_In)

    if self.ReStartPerform then
        local NowTime = TimeUtils.NowTime()
        local PassedTime = NowTime % 1800
        self.ActivityStartTime = NowTime - PassedTime
        self:ResetPerformedRound()
    else
        self.ActivityStartTime = TimeUtils.NowTime()
        self:StartStageTimer()
    end
    DebugPrint("ayff 剧院活动开始时间:", self.ActivityStartTime)
end

function M:OnLevelStart(LevelId)
    local Index = self.LevelId2Index[LevelId]
    local Item = self.ListView_Title:GetItemAt(Index - 1)
    local EntryWidget = Item.SelfWidget
    -- local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.ListView_Title, Index - 1)
    self.CurrentSelectedEntry = EntryWidget
    self.CurrentRoundState = false
    local TextLevel = string.format(GText("TheaterOnline_Game_Round"), Index)
    self.Text_Level:SetText(TextLevel)
    
    local PerformId = self.LevelList[Index].PerformId
    local PerformData = DataMgr.TheaterRandom[PerformId]
    local TalkConfigId = PerformData.TalkConfigId
    local Name = TalkUtils:DialogueIdToContent(TalkConfigId)
    self.Text_Message:SetText(Name)

    if EntryWidget then
        if self.InterruptedRound and self.InterruptedRound == Index then
            --这一轮中途加入的，直接失败
        else
            EntryWidget:OnLevelStart()
            EntryWidget:PlayAnimation(EntryWidget.Normal)
        end
    else
        Item.IsNotDisplay = true
        DebugPrint("ayff 未找到对应的EntryWidget，Index:", Index)
    end
    self:PlayAnimation(self.Tips_In)
    self:UpdateProgress(Index)
    self.CurrentRountState = false
    self.CurLevelIndex = Index
    if self.PlayLoopSoundTimer then
        self:RemoveTimer(self.PlayLoopSoundTimer)
        self.PlayLoopSoundTimer = nil
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_skill_instruct", nil, nil)

    if self.RestProgressTimer then
        self:RemoveTimer(self.RestProgressTimer)
        self.RestProgressTimer = nil
    end

    local performId = self.LevelList[Index].PerformId
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    EventManager:FireEvent(EventID.OnTheaterNPCPerform)

    local TargetNpc = self:FindTargetNpc()
    if TargetNpc then
        -- 根据performId,表演不同的东西
        self:PerformAction(performId, TargetNpc)
    end
end

function M:FindTargetNpc()
    local NowTime = TimeUtils.NowTime()
    local ValidNpcId = nil
    
    -- 遍历TheaterNpc表，找到满足当前时间的NPC
    for NpcId, NpcData in pairs(DataMgr.TheaterNpc) do
        if NpcData.StartTime and NpcData.EndTime then
            local StartTime = NpcData.StartTime:GetTime()
            local EndTime = NpcData.EndTime:GetTime()
            if NowTime >= StartTime and NowTime < EndTime then
                ValidNpcId = NpcId
                DebugPrint("JLY Found valid TheaterNpc, NpcId:", NpcId, "StartTime:", StartTime, "EndTime:", EndTime, "NowTime:", NowTime)
                break
            end
        end
    end
    
    if not ValidNpcId then
        DebugPrint("JLY No valid TheaterNpc found for current time:", NowTime)
        return nil
    end
    
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local TargetNpc = GameState.NpcCharacterMap:FindRef(ValidNpcId)
    
    if not TargetNpc then
        DebugPrint("JLY NpcCharacterMap does not contain NpcId:", ValidNpcId)
    end
    
    return TargetNpc
end

function M:PerformAction(performId, TargetNpc)
    local PlayerActor = GWorld:GetAvatar()
    local performData = DataMgr.TheaterRandom[performId]
    -- 首先肯定要播冒泡
    local TalkConfigId = performData.TalkConfigId
    local GameInstance = GWorld.GameInstance
    local TalkContext = GameInstance:GetTalkContext()
    self.BubbleTalkKey = TalkContext:StartTalk(TalkConfigId,nil,nil, PlayerActor, TargetNpc, nil)
    
    -- 然后根据是Pet还是Resource走不同的逻辑
    if performData.Refer == "Pet" then
        local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
        local PetId = performData.PetNPCID or 900015
        local StaticCreatorId = self.TheaterConstant.PetCreatorID.ConstantValue
        
        -- 获取静态点信息
        local StaticCreator = GameState:GetStaticCreatorInfo(StaticCreatorId)
        if not IsValid(StaticCreator) then
            DebugPrint("静态点不存在:", StaticCreatorId)
            return
        end
        
        -- 获取静态点的位置
        local SpawnLocation = StaticCreator:K2_GetActorLocation()
        local SpawnRotation = StaticCreator:K2_GetActorRotation()
        DebugPrint("静态点位置:", SpawnLocation.X, SpawnLocation.Y, SpawnLocation.Z)
        
        -- 创建UnitContext
        local Context = AEventMgr.CreateUnitContext()
        Context.UnitId = PetId
        Context.UnitType = "NPC"
        Context.Loc = SpawnLocation
        Context.Rotation = SpawnRotation
        Context.IntParams:Add("Level", 1)
        
        -- 创建Pet（异步）
        GameState.EventMgr:CreateUnitNew(Context, false)
        
        -- 保存PetId用于后续清除
        self.CreatedPetId = PetId
    elseif performData.Refer == "Resource" then
        -- 如果是Resource，则播放Resource的表演
        local ResourceInfo = DataMgr.Resource[performId]
        if ResourceInfo then
            local PlayAnim = ResourceInfo.PlayAnim
            TargetNpc:PlayTalkAction(PlayAnim)
        end
    end

    -- 如果配了表情，还要播表情
    if performData.MontageName then
        TargetNpc:NewPlayFacial(performData.MontageName)
    end
end

function M:ClearPerformAction()
    if self.BubbleTalkKey then
        local TS = TalkSubsystem()
        if (TS) then
            TS:ForceInterruptTalkTaskData(function(TalkTaskData)
                return TalkTaskData.FilePath == self.BubbleTalkKey
            end)
        end
        self.BubbleTalkKey = nil
    end
    -- 清除之前创建的Pet
    DebugPrint("JLY ClearPerformAction - 开始清除Pet, CreatedPetId:", self.CreatedPetId)
    if self.CreatedPetId then
        DebugPrint("JLY ClearPerformAction - 存在CreatedPetId:", self.CreatedPetId)
        local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
        if not GameState then
            DebugPrint("JLY ClearPerformAction - 错误: 无法获取GameState")
            self.CreatedPetId = nil
            return
        end
        DebugPrint("JLY ClearPerformAction - 成功获取GameState, 准备查找Pet, PetId:", self.CreatedPetId)
        local OldPet = GameState:GetNpcInfo(self.CreatedPetId)
        if OldPet then
            DebugPrint("JLY ClearPerformAction - 找到Pet对象, 检查有效性")
            if IsValid(OldPet) then
                DebugPrint("JLY ClearPerformAction - Pet有效, 开始销毁, PetId:", self.CreatedPetId)
                OldPet:EMActorDestroy(EDestroyReason.TalkContext)
                DebugPrint("JLY ClearPerformAction - Pet销毁完成, PetId:", self.CreatedPetId)
            else
                DebugPrint("JLY ClearPerformAction - Pet对象无效, PetId:", self.CreatedPetId)
            end
        else
            DebugPrint("JLY ClearPerformAction - 错误: 未找到Pet对象, PetId:", self.CreatedPetId)
        end
        self.CreatedPetId = nil
        DebugPrint("JLY ClearPerformAction - 已清空CreatedPetId")
    else
        DebugPrint("JLY ClearPerformAction - CreatedPetId为空, 无需清除Pet")
    end

    local TargetNpc = self:FindTargetNpc()
    if TargetNpc then
        TargetNpc:PlayDefaultAnimation()
        TargetNpc:NewInitDefaultFacial()
    end
end

function M:StartStageTimer()
    if self.StageCheckTimer then
        self:RemoveTimer(self.StageCheckTimer)
    end
    
    self.StageCheckTimer = self:AddTimer(1.0, function()
        self:CheckCurrentStage()
    end, true, 0, "StageCheck", true)
    
    self:CheckCurrentStage()
end

function M:CheckCurrentStage()
    if not self.ActivityStartTime then
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local RegionId = Avatar.CurrentRegionId
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)

    
    if not GameState:IsInRegion() or Avatar:IsInHardBoss() or RegionId ~= 101901 then
        -- 离开剧院
        DebugPrint("ayff 离开剧院区域，关闭剧院活动UI regionid:", RegionId)
        self:Close()
    end
    
    local CurrentTime = TimeUtils.NowTime()
    local ElapsedTime = CurrentTime - self.ActivityStartTime
    
    -- 查找当前应该执行的阶段
    local CurrentStage = self:GetCurrentStageByTime(ElapsedTime)
    
    -- 如果阶段发生变化，执行新阶段
    if CurrentStage ~= self.CurrentStage then
        self.CurrentStage = CurrentStage
        self:ExecuteStage(CurrentStage, ElapsedTime)
    end
end

function M:GetCurrentStageByTime(ElapsedTime)
    for Stage = 1, 12 do
        local StageStartTime = self.StepInfo[Stage].Time
        local NextStageStartTime = self.StepInfo[Stage + 1] and self.StepInfo[Stage + 1].Time or math.huge
        DebugPrint("ayff 阶段:", Stage, "开始时间:", StageStartTime, "下阶段开始时间:", NextStageStartTime)
        
        if ElapsedTime >= StageStartTime and ElapsedTime < NextStageStartTime then
            return Stage
        end
    end
    
    -- 如果超过所有阶段时间，返回最后一个阶段
    return 12
end

function M:ExecuteStage(Stage, ElapsedTime)
    DebugPrint("ayff 执行阶段:", Stage, "经过时间:", ElapsedTime)
    
    if Stage == 1 then
        -- 第1阶段：开幕
        local LevelId = self.LevelList[1].LevelId
        self:AddTimer(0.1, function()
            self:OnOpeningStart(LevelId)
        end)
    elseif Stage == 2 or Stage == 4 or Stage == 6 or Stage == 8 or Stage == 10 then
        -- 第2,4,6,8,10阶段：游戏关卡
        local GameRoundIndex = math.floor(Stage / 2)  -- 1,2,3,4,5
        local LevelId = self.LevelList[GameRoundIndex].LevelId
        self:OnLevelStart(LevelId)
    elseif Stage == 3 or Stage == 5 or Stage == 7 or Stage == 9 then
        -- 第3,5,7,9阶段：休息时间
        local LevelId = self.LevelList[math.floor((Stage + 1) / 2)].LevelId
        self:OnRestStart(LevelId)
        self:ClearPerformAction()
    elseif Stage == 11 then
        -- 第11阶段：结束
        self:OnEndingStart()
        self:ClearPerformAction()
    elseif Stage == 12 then
        self:TheaterPerformGameEnd()
        if self.StageCheckTimer then
            self:RemoveTimer(self.StageCheckTimer)
            self.StageCheckTimer = nil
        end
    end
end

function M:OnOpeningStart(LevelId)
    local Index = self.LevelId2Index[LevelId]
    local Item = self.ListView_Title:GetItemAt(Index - 1)
    local EntryWidget = Item.SelfWidget
    -- local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.ListView_Title, Index - 1)
    if EntryWidget then
        EntryWidget:PlayAnimation(EntryWidget.Normal_Loop)
        -- 动效跟音效配合的不是很好
        self.PlayLoopSoundTimer = self:AddTimer(1, function()
            AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_waiting", nil, nil)
        end, true)
    end
end

function M:OnRestStart(LevelId)
    local Index = self.LevelId2Index[LevelId]
    local Item = self.ListView_Title:GetItemAt(Index - 1)
    local EntryWidget = Item.SelfWidget
    -- local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.ListView_Title, Index - 1)
    if EntryWidget then
        EntryWidget:PlayAnimation(EntryWidget.Normal_Loop)
    end
    
    -- 动效跟音效配合的不是很好
    self.PlayLoopSoundTimer = self:AddTimer(1, function()
        AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_waiting", nil, nil)
    end, true)

    self.Panel_Toast_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.RestProgressTimer = self:AddTimer(0.1, function()
        local Percent = self.ProgressBar_Title.Percent
        self.ProgressBar_Title:SetPercent(Percent + 0.0025)
    end, true)
    self.CurLevelIndex = 0
end

function M:OnEndingStart()
end

function M:OnStandbyStart()
end

function M:TheaterPerformGameEnd()
    DebugPrint("ayff 剧院活动结束 start close ui")
    UIManager(self):ShowUITip("CommonToastMain", GText("TheaterOnline_Game_Finish"),3)
    
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    GameState:ShowSynthesisSuccessEffect(0)
    local TargetNpc = self:FindTargetNpc()
    self:PlayTalk(DataMgr.TheaterConstant.EndGameTalkConfigId.ConstantValue, TargetNpc)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    GameInstance.TheaterPerformState = nil
    self:Close()
end

function M:UpdateProgress(Index)
    local Percent = (Index - 1) * 0.25
    self.ProgressBar_Title:SetPercent(Percent)
end

function M:Close()
    if self.ParentWidget then
        self.ParentWidget.Pos_Rouge_CountDown:ClearChildren()
        self.ParentWidget.Pos_Rouge_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.IsInit = true
    self.Super.Close(self)
end

function M:Destruct()
    if self.StageCheckTimer then
        self:RemoveTimer(self.StageCheckTimer)
        self.StageCheckTimer = nil
    end

    if self.RestProgressTimer then
        self:RemoveTimer(self.RestProgressTimer)
        self.RestProgressTimer = nil
    end
end

function M:PlayTalk(TalkConfigId, TargetNpc)
    if not TargetNpc then
        return
    end
    local PlayerActor = GWorld:GetAvatar()
    local GameInstance = GWorld.GameInstance
    local TalkContext = GameInstance:GetTalkContext()
    self.BubbleTalkKey = TalkContext:StartTalk(TalkConfigId,nil,nil, PlayerActor, TargetNpc, nil)
end

return M
