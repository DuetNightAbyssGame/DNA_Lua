
local EActorEventType = require 'StoryCreator.StoryLogic.StorylineUtils'.EActorEventType
local QuestNodeUtils = require 'StoryCreator.StoryLogic.QuestNodeUtils'

local M = {}
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	self.DialogueId = Flow.DialogueId
	local TalkTaskData = TalkTask.TalkTaskData
    local StoryLine = GWorld.StoryMgr:GetStory(TalkTaskData.FilePath)
    for _, StoryNode in pairs(StoryLine.RunningNodeList) do
    	local Questline = StoryNode.Questline
		if Questline and Questline:GetNode(TalkTaskData.TalkNodeId) then
			self.TalkNode = Questline:GetNode(TalkTaskData.TalkNodeId)
			break
		end
	end
	if not self.TalkNode then
		self:PrintError("Error! EFNode_ChangeStaticCreator 未找到TalkNode")
        return
	end

	self.ActiveEnable = Params.IsActive
    self.EnableBlackScreenSync = Params.EnableBlackScreen
    self.EnableFadeIn = Params.EnableFadeIn
    self.EnableFadeOut = Params.EnableFadeOut
	local StaticCreatorIdList = Params.StaticCreatorIdList or {}
    self.StaticCreatorIdList = TArray(0)
    for index,StaticCreatorId in pairs(StaticCreatorIdList) do
        self.StaticCreatorIdList:Add(StaticCreatorId)
    end
	self.NewTargetPointName = Params.NewTargetPointName

	local EFNode_ChangeStaticCreator = Flow:CreateNode(UEFNode_Delegate)
	local IsActive = self.ActiveEnable and 1 or 0
	EFNode_ChangeStaticCreator.DebugLog = string.format("ChangeStaticCreator ActiveEnable: %d", IsActive)

	EFNode_ChangeStaticCreator.OnStart:Add(EFNode_ChangeStaticCreator, function(Node)
		self.FlowNode = Node
		self:Start()
	end)

	return EFNode_ChangeStaticCreator
end

function M:Start()
    -- 静态点有效性判断：是否存在对应刷新点
    if not self:IsAllStaticCreatorValid() then
        self:PrintError("Error! EFNode_ChangeStaticCreator 生成/销毁刷新点: 填入静态点Id不存在，节点中断！")
        return
    end

    if not self.EnableBlackScreenSync then
        self:ChangeStaticCreatorState()
        return
    end

    if self.EnableFadeIn then
        DebugPrint("EFNode_ChangeStaticCreator: 黑屏开启")
        --self:GetBlackUI():FadeIn(1, {Obj=self.TalkNode, Func=self.ChangeStaticCreatorState, Params={}})
        self:PlayBlackUIIn()
    else
	    if self.EnableFadeOut then  -- 特殊处理 如果淡入淡出都false则直接走后续步骤
            --self:GetBlackUI():SetToBlack()
            self:DirectShowBlackUI()
        end
        self:ChangeStaticCreatorState()
    end
end

function M:Finish()
	local Node = self.FlowNode
	if Node then
		Node:Finish({ Node.FinishPin })
	else
		self:PrintError("Error! EFNode_ChangeStaticCreator Node不存在")
	end
end

function M:PrintError(Message)
	local Message = Message and Message..", DialogueId: "..self.DialogueId
	-- UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType， "静态刷新点脚本执行失败", Message)
	GWorld.logger.error(Message)
end

function M:ChangeStaticCreatorState()
    DebugPrint("------------ EFNode_ChangeStaticCreator ------------------")
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)                                 
    assert(IsValid(GameMode), "GameMode is not valid!")
    if not IsValid(GameMode) then
		return
	end

    self.ActivedMonsterCount = 0
    local LoadFinishCallback = function(Unit)
        self.ActivedMonsterCount = self.ActivedMonsterCount + 1
        DebugPrint('EFNode_ChangeStaticCreator LoadFinishCallback self.ActivedMonsterCount Unit.CreatorId', self.ActivedMonsterCount, Unit.CreatorId)
        if self.ActivedMonsterCount == self.StaticCreatorIdList:Length() then
            self:FinishAction()
        end
    end

    if self.ActiveEnable then
        if self.EnableBlackScreenSync then
            -- 真正绑定回调和激活静态点逻辑
            local BindEventAndTrigger = function()
                DebugPrint("EFNode_ChangeStaticCreator 生成/销毁刷新点: 绑定事件并激活静态点")
                if not self:IsAllLevelLoaded() then
                    -- self:GetBlackUI():RemoveFromViewport()
                    self:DirectCloseBlackUI()
                    self:PrintError("Error! EFNode_ChangeStaticCreator 生成/销毁刷新点: 传送后静态点太远被序列化，节点中断！")
                    return
                end
                for index, StaticCreatorId in pairs(self.StaticCreatorIdList) do
                    GWorld.StoryMgr:BindStaticCreatorActorEvent(StaticCreatorId, EActorEventType.OnCreated, self, LoadFinishCallback)
                end
                QuestNodeUtils.STLTriggerActiveStaticCreator(self.TalkNode, self.StaticCreatorIdList)
            end

            local NewTargetPoint = GameMode.EMGameState:GetTargetPoint(self.NewTargetPointName)
            if self.NewTargetPointName == nil or self.NewTargetPointName == "" or (not IsValid(NewTargetPoint)) then
                if not self:IsAllLevelLoaded() then
                    -- self:GetBlackUI():RemoveFromViewport()
                    self:DirectCloseBlackUI()
                    self:PrintError("Error! EFNode_ChangeStaticCreator 生成/销毁刷新点: 没有填写TargetPoint且静态点太远被序列化，节点中断！")
                    return
                end
                BindEventAndTrigger()
            else
                local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)  -- 剧情默认单机
                if GameMode:GetWCSubSystem() then
                    DebugPrint("EFNode_ChangeStaticCreator 生成/销毁刷新点: 开始传送至目标点", self.NewTargetPointName)
                    GameMode:GetWCSubSystem():RequestAsyncTravel(Player, NewTargetPoint:GetTransform(), {GWorld.GameInstance, BindEventAndTrigger}, true)
                else
                    DebugPrint("Warning EFNode_ChangeStaticCreator 生成/销毁刷新点: 此区域没有WC")
                    GameMode:EMSetActorLocationAndRotation(0, self.NewTargetPointName, true);
                    BindEventAndTrigger()
                end
            end
        else
            QuestNodeUtils.STLTriggerActiveStaticCreator(self.TalkNode, self.StaticCreatorIdList)
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

function M:FinishAction()
    if not self.EnableBlackScreenSync then
        self:Finish()
        return
    end

    if self.EnableFadeOut then
        DebugPrint("EFNode_ChangeStaticCreator: 黑屏结束")
        -- self:GetBlackUI():FadeOut(1, {Obj=self.TalkNode, Func=self.Finish, Params={}})
        self:PlayBlackUIOut()
    else
        if self.EnableFadeIn then  -- 特殊处理 如果淡入淡出都false则直接走后续步骤
            -- self:GetBlackUI():SetToTransparent()
            self:DirectCloseBlackUI()
        end
        self:Finish()
    end
end

function M:Clear()
    DebugPrint("EFNode_ChangeStaticCreator: Clear")
    --self:GetBlackUI():RemoveFromViewport()
    -- if self.BlackUI then
    --     self.BlackUI:RemoveFromViewport()
    -- end
    self:DirectCloseBlackUI()
    if self.EnableBlackScreenSync then
        for index, StaticCreatorId in pairs(self.StaticCreatorIdList) do
            GWorld.StoryMgr:UnbindStaticCreatorActorEventByType(StaticCreatorId, EActorEventType.OnCreated)
        end
    end
end

--------- 静态点有效性判断，若不满足则节点中断 -----------------
-- 1.是否存在对应刷新点
function M:IsAllStaticCreatorValid()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)

    for _, CreatorId in pairs(self.StaticCreatorIdList) do
        local Creator = GameMode.EMGameState:GetStaticCreatorInfo(CreatorId)
        if not IsValid(Creator) then
            self:PrintError("Error! EFNode_ChangeStaticCreator 生成/销毁刷新点: 填入的静态点Id【"..tostring(CreatorId).."】找不到静态点，请检查！")
            return false
        end
    end

    return true
end

-- 2.该刷新点所在关卡是否被加载
function M:IsAllLevelLoaded()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)

    for _, CreatorId in pairs(self.StaticCreatorIdList) do
        local Creator = GameMode.EMGameState:GetStaticCreatorInfo(CreatorId)
        if not GameMode:CheckLevelLoadedByActor(Creator) then
            self:PrintError("Error! EFNode_ChangeStaticCreator 生成/销毁刷新点: 填入的静态点Id【"..tostring(CreatorId).."】所在关卡没有被加载，请检查！")
            return false
        end
    end

    return true
end
-----------------------------------------------------------------

function M:PlayBlackUIIn()
    local Params = {}
    Params.BlackScreenHandle          = "EFNode_ChangeStaticCreator"..self.DialogueId
    Params.InAnimationObj             = self
    Params.InAnimationCallback        = self.ChangeStaticCreatorState
    Params.InAnimationPlayTime        = 1
    Params.OutAnimationObj            = self
    Params.OutAnimationCallback       = self.Finish
    Params.OutAnimationPlayTime       = 1
    UIManager(GWorld.GameInstance):ShowCommonBlackScreen(Params)
end

function M:PlayBlackUIOut()
    UIManager(GWorld.GameInstance):HideCommonBlackScreen("EFNode_ChangeStaticCreator"..self.DialogueId)
end

function M:DirectShowBlackUI()
    local Params = {}
    Params.BlackScreenHandle          = "EFNode_ChangeStaticCreator"..self.DialogueId
    -- Params.InAnimationObj             = self
    -- Params.InAnimationCallback        = self.ChangeStaticCreatorState
    Params.InAnimationPlayTime        = 0
    Params.OutAnimationObj            = self
    Params.OutAnimationCallback       = self.Finish
    Params.OutAnimationPlayTime       = 1
    UIManager(GWorld.GameInstance):ShowCommonBlackScreen(Params)
end

function M:DirectCloseBlackUI()
    UIManager(GWorld.GameInstance):CloseCommonBlackScreenWithoutCB("EFNode_ChangeStaticCreator"..self.DialogueId)
end

return M
