require "UnLua"

local LevelDetails = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})
local SoloTreasureDataModel = require "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel"

function LevelDetails:RefreshStoryLevelDetailPanel(Result)
    self:LoadProgressData(Result)

    local CurRow = Result and Result.CurRow
    if not CurRow then
        DebugPrint(ErrorTag, "----------------未能拿到当前进度行 CurRow-----------------")
        return
    end

    local UserCurProgressId = CurRow.EventProgressId
    if not UserCurProgressId then
        DebugPrint(ErrorTag, "----------------未能拿到用户当前进度ID-----------------")
        return
    end

    local EventDungeonId = CurRow.EventDugeonId
    if not EventDungeonId then
        DebugPrint(ErrorTag, "----------------未能拿到剧情关 EventDugeonId-----------------")
        return
    end

    -- 更新当前选中的剧情关ID（后续刷新费用/撤离等都可以用这个）
    self.CurEventDungeonId = EventDungeonId

    -- 读“活动剧情关”表：TreasureHuntStoryDungeon（按 EventDugeonId 索引）
    local StoryRow = DataMgr.TreasureHuntStoryDungeon and DataMgr.TreasureHuntStoryDungeon[EventDungeonId]
    if not StoryRow then
        DebugPrint(ErrorTag, "----------------TreasureHuntStoryDungeon 行不存在:", EventDungeonId, "-----------------")
        return
    end

    -- 关卡名/描述：来自剧情关表

    self.Text_Map:SetText(GText(StoryRow.DungeonName))

    self.Text_Info:SetText(GText(StoryRow.DungeonDes))

    -- 机关鸟状态文案：来自进度表（PetConText）

    self.Text_Status:SetText(GText(CurRow.PetConText))

    self.Text_Cost:SetText(StoryRow.Fee)

    -- Coin图案
    local ResourceId = DataMgr.GlobalConstant["SoloTreasureCurrent"].ConstantValue
    local CoinIconPath = DataMgr.Resource[ResourceId].Icon
    local CoinObj = LoadObject(CoinIconPath)
    if CoinObj then
        self.Icon_Cost:SetBrushFromTexture(CoinObj)
    end

    -- 地图图片
    if self.Img_Map and StoryRow.DungeonImage then
        local MapImgObj = LoadObject(StoryRow.DungeonImage)
        if MapImgObj then
            self.Img_Map:SetBrushFromTexture(MapImgObj)
        end
    end

    -- 撤离时限
    local DungeonId = StoryRow.DungeonId
    local TotalTime = SoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId) -- 对应难度的 DungeonId 查撤离时限
    local TimeStr = self:FormatTimeMS(TotalTime)

    self.Text_Time:SetText(TimeStr)

    -- 机关鸟图样
    if self.Icon_Bird then
        local CurStageIndex = Result.CurStageIndex -- 拿到最新的阶段
        local OldStageIndex, _ = SoloTreasureDataModel:GetLastStageBirdEx(self.EventId) -- 内存快照拿到旧的数据
        self:UpdateBirdState(CurStageIndex, OldStageIndex)
    end
end

function LevelDetails:UpdateBirdState(CurStageIndex, OldStageIndex)
    if not CurStageIndex then
        return
    end
    OldStageIndex = OldStageIndex or CurStageIndex

    -- 第一次初始化：展示旧阶段
    self.CurBirdStage = OldStageIndex

    self:ChangeBirdTexture(OldStageIndex)
    self:PlayBirdIn(OldStageIndex) -- In finished -> Loop（在回调里做）

    if CurStageIndex == OldStageIndex then
        return
    end

    -- 已经在目标阶段就不切
    if self.CurBirdStage == CurStageIndex then
        return
    end

    -- 记录待切阶段，走 Out -> (finished) -> 切图+In -> (finished) -> Loop
    self.PendingBirdStage = CurStageIndex

    self:AddTimer(
        1,
        function()
            self:PlayBirdOut()
        end,
        nil,
        nil,
        nil,
        true
    )
end

-- 更改材质贴图
function LevelDetails:ChangeBirdTexture(StateIndex)
    local TexturePath = self.TreasureHuntProgressData[StateIndex].PetConBP
    local ImgObj = LoadObject(TexturePath)
    if ImgObj then
        if not self.BirdMID then
            self.BirdMID = self.Icon_Bird:GetDynamicMaterial()
        end
        if self.BirdMID then
            self.BirdMID:SetTextureParameterValue("MainTex", ImgObj)
        end
    end
end

function LevelDetails:StopAllBirdAnim()
    for i = 1, 5 do
        local inAnim = self["BirdIn_" .. i]
        if inAnim then
            self:StopAnimation(inAnim)
        end
        local loopAnim = self["BirdLoop_" .. i]
        if loopAnim then
            self:StopAnimation(loopAnim)
        end
    end
end

function LevelDetails:PlayBirdOut()
    self:StopAllBirdAnim()
    local OutAnim = self.BirdOut
    self.BirdOutAnim = OutAnim
    self:PlayAnimation(OutAnim)
end

function LevelDetails:PlayBirdIn(StageIndex)
    -- self:StopAllBirdAnim()
    local InAnim = self["BirdIn_" .. StageIndex]
    self.CurBirdInAnim = InAnim
    if InAnim then
        self:PlayAnimation(InAnim)
    end

    -- TODO: 这里可能重复播了Loop 估计得检查一下
    local LoopAnim = self["BirdLoop_" .. StageIndex]
    if LoopAnim then
        self:PlayAnimation(LoopAnim, 0, 0) -- 无限循环
    end
end

function LevelDetails:PlayBirdLoop(StageIndex)
    local LoopAnim = self["BirdLoop_" .. StageIndex]
    if LoopAnim then
        self:PlayAnimation(LoopAnim, 0, 0) -- 无限循环
    end
end

function LevelDetails:OnAnimationFinished(Animation)
    -- 1) Out 播完：切贴图 + 播 In
    if self.BirdOutAnim and Animation == self.BirdOutAnim then
        self.BirdOutAnim = nil

        if self.PendingBirdStage then
            self.CurBirdStage = self.PendingBirdStage
            self.PendingBirdStage = nil

            self:ChangeBirdTexture(self.CurBirdStage)
            self:PlayBirdIn(self.CurBirdStage)
        end
        return
    end

    -- 2) In 播完：播 Loop
    if self.CurBirdInAnim and Animation == self.CurBirdInAnim then
        self.CurBirdInAnim = nil
        if self.CurBirdStage then
            self:PlayBirdLoop(self.CurBirdStage)

            SoloTreasureDataModel:CommitBirdSnapshotByResult(self.EventId, self.NewResult)
        end
        return
    end
end

function LevelDetails:LoadProgressData(Result)
    local EventId = SoloTreasureDataModel:GetEventId()
    if EventId then
        self.EventId = EventId
    end
    local TreasureHuntProgressData = SoloTreasureDataModel:GetTreasureHuntProgressData(self.EventId)
    if not TreasureHuntProgressData then
        DebugPrint(ErrorTag, "--------------TreasureHuntProgressData is nil--------------")
    else
        self.TreasureHuntProgressData = TreasureHuntProgressData
    end
    if Result then
        self.NewResult = Result
    end
end

function LevelDetails:FormatTimeMS(totalSeconds)
    if not totalSeconds or totalSeconds < 0 then
        return "0:00"
    end

    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60

    -- 分钟不补 0，秒补 0
    return string.format("%d:%02d", minutes, seconds)
end

return LevelDetails
