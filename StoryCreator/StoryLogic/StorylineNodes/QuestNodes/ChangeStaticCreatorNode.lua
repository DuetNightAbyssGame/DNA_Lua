


local EActorEventType = require 'StoryCreator.StoryLogic.StorylineUtils'.EActorEventType
local QuestNodeUtils = require 'StoryCreator.StoryLogic.QuestNodeUtils'

local ChangeStaticCreatorNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')

function ChangeStaticCreatorNode:Init()
    self.ActiveEnable = false
    self.EnableBlackScreenSync = false
    self.EnableFadeIn = false
    self.EnableFadeOut = false
	self.StaticCreatorIdList = {}
    self.NewTargetPointName = ""
    self.AssureTimerHandle = ""         -- 声明下 防止报错
    self.TempPrintInfo = {}
end

function ChangeStaticCreatorNode:Start(Context)
	self.Context = Context

    -- 静态点有效性判断：是否存在对应刷新点
    if not self:IsAllStaticCreatorValid() then
        self:PrintErrorlog("填入静态点Id不存在，节点中断！")
        return
    end

    if not self.EnableBlackScreenSync then
        self:ChangeStaticCreatorState()
        return
    end

    if self.EnableFadeIn then
        DebugPrint("ChangeStaticCreatorNode: 黑屏开启")
        --self:GetBlackUI():FadeIn(1, {Obj=self, Func=self.ChangeStaticCreatorState, Params={}})
        self:PlayBlackUIIn()
    else
	    if self.EnableFadeOut then  -- 特殊处理 如果淡入淡出都false则直接走后续步骤
            --self:GetBlackUI():SetToBlack()
            self:DirectShowBlackUI()
        end
        self:ChangeStaticCreatorState()
    end
end

function ChangeStaticCreatorNode:ChangeStaticCreatorState()
    DebugPrint("------------ ChangeStaticCreatorNode ------------------")
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)                                 
    assert(IsValid(GameMode), "GameMode is not valid!")
    if not IsValid(GameMode) then
		return
	end

    -- 为什么写在这里，而不是写在Show黑屏的那两个接口里呢？
    -- 因为策划可能配置，EnableBlackScreenSync为true，但是不启用黑屏
    -- 这种情况，保底timer就漏加了
    if self.EnableBlackScreenSync then
        self:AddAssureTimer()
    end

    self.ActivedMonsterCount = 0    -- 统计收到的回调数目
    -- 接收怪物初始化完毕的回调（其实可以不用仿函数了
    -- SelfNode: 该节点
    -- Info: table, Info.Actor = 该次回调的怪物
    local LoadFinishCallback = function(SelfNode, Info)
        self.ActivedMonsterCount = self.ActivedMonsterCount + 1
        if Info.Actor then
            DebugPrint("ChangeStaticCreatorNode 接收到回调. 目前收到的回调总数:", self.ActivedMonsterCount," CreatorId", Info.Actor.CreatorId, "Eid", Info.Actor.Eid, "UnitId", Info.Actor.UnitId, "Name", Info.Actor:GetName())
        else
            DebugPrint("ChangeStaticCreatorNode 接收到回调. 目前收到的回调总数:", self.ActivedMonsterCount)
        end

        if self.ActivedMonsterCount == #self.StaticCreatorIdList then
            GWorld.GameInstance:RemoveTimer(self.AssureTimerHandle)
            self:FinishAction()
        end
    end

    if self.ActiveEnable then
        if self.EnableBlackScreenSync then
            -- 真正绑定回调和激活静态点逻辑
            local BindEventAndTrigger = function()
                DebugPrint("ChangeStaticCreatorNode 生成/销毁刷新点: 绑定事件并激活静态点")
                -- 激活前检测静态点对应关卡是否加载
                -- 1. 若已加载（正常情况），绑定回调，等回调完成后结束节点
                -- 2. 存在关卡未加载，不绑定回调，直接关闭黑屏 结束节点
                local IsAllLevelLoaded = self:IsAllLevelLoaded()
                if IsAllLevelLoaded then
                    -- 1. 处理正常情况，绑定回调
                    for index, StaticCreatorId in pairs(self.StaticCreatorIdList) do
                        GWorld.StoryMgr:BindStaticCreatorActorEvent(StaticCreatorId, EActorEventType.OnCreated, self, LoadFinishCallback)
                    end
                end

                -- 静态点一定要激活
                QuestNodeUtils.STLTriggerActiveStaticCreator(self, self.StaticCreatorIdList)
                
                -- 2. 激活后再处理异常情况，然后Finish
                if not IsAllLevelLoaded then
                    -- self:GetBlackUI():RemoveFromViewport()
                    self:PrintErrorlog("静态点激活前检测到关卡未加载，黑屏直接关闭，节点完成！")
                    self:DirectCloseBlackUI()
                    self:Finish()
                end
            end

            local NewTargetPoint = GameMode.EMGameState:GetTargetPoint(self.NewTargetPointName)
            if self.NewTargetPointName == nil or self.NewTargetPointName == "" or (not IsValid(NewTargetPoint)) then
                -- 这段额外的检查可以不要了，BindEventAndTrigger都会做一次关卡加载的检查
                -- if not self:IsAllLevelLoaded() then
                --     -- self:GetBlackUI():RemoveFromViewport()
                --     self:PrintErrorlog("没有填写TargetPoint且静态点太远被序列化，节点完成！")
                --     self:DirectCloseBlackUI()
                --     self:Finish()
                --     return
                -- end
                BindEventAndTrigger()
            else
                local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)  -- 剧情默认单机
                if GameMode:GetWCSubSystem() then
                    DebugPrint("ChangeStaticCreatorNode 生成/销毁刷新点: 开始传送至目标点", self.NewTargetPointName)
                    GameMode:GetWCSubSystem():RequestAsyncTravel(Player, NewTargetPoint:GetTransform(), {GWorld.GameInstance, BindEventAndTrigger}, true)
                else
                    DebugPrint("Warning ChangeStaticCreatorNode 生成/销毁刷新点: 此区域没有WC")
                    GameMode:EMSetActorLocationAndRotation(0, self.NewTargetPointName, true);
                    BindEventAndTrigger()
                end
            end
        else
            QuestNodeUtils.STLTriggerActiveStaticCreator(self, self.StaticCreatorIdList)
            self:FinishAction()
        end
    else
        local StaticCreatorArray = TArray(0)
        for index,StaticCreatorId in pairs(self.StaticCreatorIdList) do
            StaticCreatorArray:Add(StaticCreatorId)
        end
        GameMode:TriggerInactiveStaticCreator(StaticCreatorArray, false, EDestroyReason.StoryLine)
        self:FinishAction()
    end
end

function ChangeStaticCreatorNode:FinishAction()
    if not self.EnableBlackScreenSync then
        self:Finish()
        return
    end

    if self.EnableFadeOut then
        DebugPrint("ChangeStaticCreatorNode: 黑屏结束")
        -- self:GetBlackUI():FadeOut(1, {Obj=self, Func=self.Finish, Params={}})
        self:PlayBlackUIOut()
    else
        if self.EnableFadeIn then  -- 特殊处理 如果淡入淡出都false则直接走后续步骤
            -- self:GetBlackUI():SetToTransparent()
            self:DirectCloseBlackUI()
        end
        self:Finish()
    end
end

function ChangeStaticCreatorNode:Clear()
    DebugPrint("ChangeStaticCreatorNode: Clear")
    --self:GetBlackUI():RemoveFromViewport()
    -- if self.BlackUI then
    --     self.BlackUI:RemoveFromViewport()
    -- end
    GWorld.GameInstance:RemoveTimer(self.AssureTimerHandle)
    self:DirectCloseBlackUI()
    if self.EnableBlackScreenSync then
        for index, StaticCreatorId in pairs(self.StaticCreatorIdList) do
            GWorld.StoryMgr:UnbindStaticCreatorActorEventByType(StaticCreatorId, EActorEventType.OnCreated)
        end
    end
end

--------- 静态点有效性判断，若不满足则节点中断 -----------------
-- 1.是否存在对应刷新点
function ChangeStaticCreatorNode:IsAllStaticCreatorValid()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)

    for _, CreatorId in pairs(self.StaticCreatorIdList) do
        local Creator = GameMode.EMGameState:GetStaticCreatorInfo(CreatorId)
        if not IsValid(Creator) then
            ScreenPrint("Error! ChangeStaticCreatorNode 生成/销毁刷新点: 填入的静态点Id【"..tostring(CreatorId).."】找不到静态点，请检查！")
            table.insert(self.TempPrintInfo, CreatorId)
            return false
        end
    end

    return true
end

-- 2.该刷新点所在关卡是否被加载
function ChangeStaticCreatorNode:IsAllLevelLoaded()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)

    for _, CreatorId in pairs(self.StaticCreatorIdList) do
        local Creator = GameMode.EMGameState:GetStaticCreatorInfo(CreatorId)
        if not GameMode:CheckLevelLoadedByActor(Creator) then
            ScreenPrint("Error! ChangeStaticCreatorNode 生成/销毁刷新点: 填入的静态点Id【"..tostring(CreatorId).."】所在关卡没有被加载，请检查！")
            table.insert(self.TempPrintInfo, CreatorId)
            return false
        end
    end

    return true
end
-----------------------------------------------------------------

-- 黑屏开启，且有淡入
function ChangeStaticCreatorNode:PlayBlackUIIn()
    local Params = {}
    Params.BlackScreenHandle          = "ChangeStaticCreatorNode"..self.Key
    Params.InAnimationObj             = self
    Params.InAnimationCallback        = self.ChangeStaticCreatorState
    Params.InAnimationPlayTime        = 1
    Params.OutAnimationObj            = self
    Params.OutAnimationCallback       = self.Finish
    Params.OutAnimationPlayTime       = 1
    UIManager(GWorld.GameInstance):ShowCommonBlackScreen(Params)
end

-- 黑屏关闭，播淡出动效
function ChangeStaticCreatorNode:PlayBlackUIOut()
    UIManager(GWorld.GameInstance):HideCommonBlackScreen("ChangeStaticCreatorNode"..self.Key)
end

-- 直接开启黑屏，无淡入效果
function ChangeStaticCreatorNode:DirectShowBlackUI()
    local Params = {}
    Params.BlackScreenHandle          = "ChangeStaticCreatorNode"..self.Key
    -- Params.InAnimationObj             = self
    -- Params.InAnimationCallback        = self.ChangeStaticCreatorState
    Params.InAnimationPlayTime        = 0
    Params.OutAnimationObj            = self
    Params.OutAnimationCallback       = self.Finish
    Params.OutAnimationPlayTime       = 1
    UIManager(GWorld.GameInstance):ShowCommonBlackScreen(Params)
end

-- 直接关闭黑屏，并不触发回调（即Finish）
-- 1. 检测错误，刷新点id不存在，直接关闭黑屏并return
-- 2. 检测错误，刷新点所在关卡未加载，直接关闭黑屏（后续正常激活静态点、手动调Finish）
-- 3. Finish前，且需要淡入、不需要淡出，直接关闭黑屏（后续手动调Finish）
-- 4. 节点Clear，保底关闭黑屏
-- 5. 黑屏出现时间超过保底时长，关闭黑屏并继续节点（后续手动调Finish）
function ChangeStaticCreatorNode:DirectCloseBlackUI()
    UIManager(GWorld.GameInstance):CloseCommonBlackScreenWithoutCB("ChangeStaticCreatorNode"..self.Key)
end

-- 新增一个保底，如果超过保底时长，关闭黑屏并让节点继续
function ChangeStaticCreatorNode:AddAssureTimer()
    local OnAssureTimerEnd = function()
        self:PrintErrorlog("黑屏时间过长，触发保底后节点完成！")
        self:DirectCloseBlackUI()
        self:Finish()
    end

    self.AssureTimerHandle = "ChangeStaticCreatorNodeAssureTimer"..self.Key
    GWorld.GameInstance:AddTimer(5, OnAssureTimerEnd, false, 0, self.AssureTimerHandle)
end

function ChangeStaticCreatorNode:PrintErrorlog(Msg)
    ScreenPrint("Error! ChangeStaticCreatorNode 生成/销毁刷新点: ", Msg)
    local Message = "ChangeStaticCreatorNode "..Msg.."\t"..table.concat(self.TempPrintInfo, ",")..
    "\n====STL信息========"..
    "\nFileName:\t"..self.Context.FileName..
    "\nQuestChainId:\t"..self.Context.QuestChainId..
    "\nQuestId:\t"..self.Context.QuestId..
    "\nStoryNodeKey:\t"..self.Context.Data.key..
    "\nKey:\t"..self.Key..
    "\n====节点配置信息========"..
    "\n生成/销毁:\t"..tostring(self.ActiveEnable)..
    "\n启用黑屏同步:\t"..tostring(self.EnableBlackScreenSync)..
    "\n启用淡入黑屏:\t"..tostring(self.EnableFadeIn)..
    "\n启用淡出黑屏:\t"..tostring(self.EnableFadeOut)..
    "\n静态点Id列表:\t"..table.concat(self.StaticCreatorIdList, ",")..
    "\n目标点名称:\t"..tostring(self.NewTargetPointName)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "生成/销毁刷新点节点出错", Message)
    self.TempPrintInfo = {}
end

-- function ChangeStaticCreatorNode:GetBlackUI()
--     if self.BlackUI == nil then
--         self.BlackUI = UIManager(GWorld.GameInstance):_CreateWidgetNew("TalkBlackScreenBorder")
--     end
--     return self.BlackUI
-- end

return ChangeStaticCreatorNode