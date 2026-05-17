--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_ProcessEscape_C
local WBP_CoDefenceProgress_C = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


function WBP_CoDefenceProgress_C:OnLoaded(...)
    WBP_CoDefenceProgress_C.Super.OnLoaded(self, ...)
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    assert(BattleMain, "WBP_Battle_ProcessEscape_C 加载时拿不到BattleMain！")
    BattleMain.Pos_ProcessSew:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    BattleMain.Pos_ProcessSew:AddChild(self)
    self.IsInit = true-- AddChild会调用一次Destruct方法，self.IsInit会置为false  不提倡这种写法，最好是创建emuserwidget，否则需要自己维护相关逻辑
    --读取配置表信息
    self:InitDataInfo()
    self.Bar_Progress:GetDynamicMaterial():SetScalarParameterValue("Percent", 0)--因为进度条在动画后才初始化，所以一开始先把百分比设为0
    self.ProcessOngoingPositionOffSet = 12 --水位上涨图标设置偏移位移
    self:BindToAnimationFinished(self.In, {self, self.InitAllUI})
    self:PlayAnimation(self.In)
end

function WBP_CoDefenceProgress_C:InitDataInfo()
    -- 获取配置
    local IsSuccess, DungeonInfoTemp = CommonUtils.GetDungeonUIParams("RegionCoDefenceProgress")
    self.DungeonInfo = DungeonInfoTemp
    self.PointWidgetInstances = {}
    if not IsSuccess then
        self.TotalPointNum = 3
        self.WaterLevelTextmap ={
            [1] = "水位上涨中",--水位上涨中
            [2] = "储水池已满",--储水池已满
            [3] = "排水进程受阻，请开启水阀",--水阀可开启
            [4] = "水位降低中",--水位降低中
            [5] = "储水池已排空",--储水池已排空
            [6] = "%ss后排水机关毁坏",--%ss后排水机关毁坏
            [7] = "水阀即将开启",--水阀即将开启
        }
        return
    end
    --水槽的数量(数量待包装)
    self.TotalPointNum = self.DungeonInfo.TotalPointNums
    --文本根据不同情况设置textmap
    self.WaterLevelTextmap = {
        [1] = self.DungeonInfo.CoDefence_1,--水位上涨中
        [2] = self.DungeonInfo.CoDefence_2,--储水池已满
        [3] = self.DungeonInfo.CoDefence_3,--水阀可开启
        [4] = self.DungeonInfo.CoDefence_4,--水位降低中
        [5] = self.DungeonInfo.CoDefence_5,--储水池已排空
        [6] = self.DungeonInfo.CoDefence_6,--%ss后排水机关毁坏
        [7] = self.DungeonInfo.CoDefence_7,--水阀即将开启
    }

    --进度条涨满（0~100）时间 后续需要配表控制涨满时间可以改为读表的形式
    self.IsFirstTime = true --上涨时间不变，下降时间变为6s  标识为第一次上涨用的ticktime
    self.IsPlayedAnimation = false    
    self:UpdateWaterLevelTickTime()
end

function WBP_CoDefenceProgress_C:UpdateWaterLevelTickTime()
    self.Time = self.IsFirstTime and 3 or 6
    self.TickTime = self.Time / 100
end

function WBP_CoDefenceProgress_C:InitAllUI()
    --水槽
    self:InitPointPos()
    --水位上涨下降的箭头
    self:InitProcessOngoing()
    --初始化进度条
    self:InitProgress()
end

--初始化水槽
function WBP_CoDefenceProgress_C:InitPointPos()
    self.ProgressLen = USlateBlueprintLibrary.GetLocalSize(self.Point:GetCachedGeometry()).X
    --加个保底 默认长度321
    -- if self.ProgressLen == 0 then
    --     self.ProgressLen = 321
    -- end
    self.PointInterval = self.ProgressLen / (self.TotalPointNum)
    self.Point:ClearChildren()
    for i = 1, self.TotalPointNum do
        local NewPointWidget = self:CreateWidgetNew("BattleProcessPoint")
        self.PointWidgetInstances[i] = NewPointWidget
        self.Point:AddChild(NewPointWidget)
        NewPointWidget:InitWidget(self, i)

        local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(NewPointWidget)
        Slot:SetSize(FVector2D(0, 0))       -- 手动把size设成0，否则位置会错开
        Slot:SetPosition(FVector2D(self.PointInterval * (i - 1), 0))
    end
    DebugPrint("thy     PointWidgetInstances", #self.PointWidgetInstances)
    self.CurPointIndex = self.TotalPointNum
end

function WBP_CoDefenceProgress_C:GetWaterLevelLen()
    self.WaterLevelLen = USlateBlueprintLibrary.GetLocalSize(self.WaterLevelUI.Icon_Play01:GetCachedGeometry()).X
    self.WaterLevelMoveLen = self.ProgressLen - self.WaterLevelLen
end

--初始化水位上涨图标
function WBP_CoDefenceProgress_C:InitProcessOngoing()
    self.WaterLevelUI = self:CreateWidgetNew("ProcessOngoing")
    self.Point:AddChild(self.WaterLevelUI)
    self.WaterLevelUI:BindToAnimationFinished(self.WaterLevelUI.UP, {self, self.GetWaterLevelLen})
    self.WaterLevelUI:PlayAnimation(self.WaterLevelUI.UP)
    self.WaterLevelLen = USlateBlueprintLibrary.GetLocalSize(self.WaterLevelUI.Icon_Play01:GetCachedGeometry()).X
    self.WaterLevelMoveLen = self.ProgressLen - self.WaterLevelLen
    self:SetProcessOngoingPosition(self.ProcessOngoingPositionOffSet, true)
end

--设置水位上涨图标位置
function WBP_CoDefenceProgress_C:SetProcessOngoingPosition(Position, IsUp)
    if self.WaterLevelMoveLen < Position then
        return
    end
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WaterLevelUI)
    Slot:SetSize(FVector2D(0, 0))  
    Slot:SetPosition(FVector2D(Position, 0))
    if IsUp then 
        if not self.WaterLevelUI:IsPlayingAnimation(self.WaterLevelUI.UP) then
            self.WaterLevelUI:PlayAnimation(self.WaterLevelUI.UP, 0, 0)
        end
    else
        if not self.WaterLevelUI:IsPlayingAnimation(self.WaterLevelUI.Down) then
            self.WaterLevelUI:PlayAnimation(self.WaterLevelUI.Down, 0, 0)
        end
    end
end

--初始化进度条
function WBP_CoDefenceProgress_C:InitProgress()
    if not self.ColorBarProgress then
        self.ColorBarProgress = self.Bar_Progress:GetDynamicMaterial()
    end
    self.ColorBarProgress:SetScalarParameterValue("Percent", 0)
    self.CurPercent = 0
    self:UpdateProgressToTarget(self.TotalPointNum + 1)--初始化时进度条直接拉满
    self.IsFirstTime = false --水位上涨结束，之后都是下降水位，需要改变ticktime
end

--根据水位改变水槽的状态，目前仅初始化水位上涨的时候用
function WBP_CoDefenceProgress_C:UpdatePointStateByWaterLevel()
    local NeedToUpdatePointStateIndex = math.floor(self.CurPercent/(1/(self.TotalPointNum + 1)))
    if NeedToUpdatePointStateIndex > 0 and NeedToUpdatePointStateIndex < self.TotalPointNum + 1 then 
        local Point = self.PointWidgetInstances[NeedToUpdatePointStateIndex]
        Point:SetPointState("Lock")
    end
end

--设置水槽的状态
function WBP_CoDefenceProgress_C:SetPointState(PointIndex, NewStateIndex, TimerHandleName)
    DebugPrint("thy    SetPointState", PointIndex, NewStateIndex)
    if not PointIndex then
        PointIndex = 2
    end
    local Point = self.PointWidgetInstances[PointIndex]
    local StateStr = Point:StateIndex2StateStr(NewStateIndex)
    DebugPrint("thy    SetPointState  StateStr", StateStr)
    self:UpdateTextByPointState(StateStr)
    
    Point:SetPointState(StateStr, TimerHandleName, self.WaterLevelTextmap[6])
    self.CurPointIndex = PointIndex == 0 and 1 or PointIndex
end

function WBP_CoDefenceProgress_C:UpdateTextByPointState(StateStr)
    if StateStr == "Fail" and self.CurPointIndex == 1 then
        self.Text_Title:SetText("")
    elseif StateStr == "CountDown" or StateStr == "Fail" then
        self.Text_Title:SetText(GText(self.WaterLevelTextmap[3]))
    elseif StateStr == "Complete" then
        self.Text_Title:SetText(GText(self.WaterLevelTextmap[7]))
    end
    self:PlayAnimation(self.Text_Refresh)
end

--隐藏水位上涨图标
function WBP_CoDefenceProgress_C:HideWaterLevelUI()
    self.WaterLevelUI:StopAllAnimations()
    self.WaterLevelUI:SetVisibility(ESlateVisibility.Hidden)
end

--根据水槽的索引得到水位对应的percent
function WBP_CoDefenceProgress_C:GetWaterLevelPercentByPointIndex(PointIndex)
    local PerPointPercent = 1 / (self.TotalPointNum)
    return PerPointPercent * (PointIndex - 1)
end

--更新进度条百分比位置
function WBP_CoDefenceProgress_C:UpdateProgressToTarget(PointIndex)
    local TargetPercent = self:GetWaterLevelPercentByPointIndex(PointIndex)
    self:AddTimer(self.TickTime, self.RealUpdateProgressToTarget, true, 0.01, "ProgressToTarget", true, TargetPercent)
end

--实际控制进度条
function WBP_CoDefenceProgress_C:RealUpdateProgressToTarget(TargetPercent)
    if not self.ColorBarProgress then
        self.ColorBarProgress = self.Bar_Progress:GetDynamicMaterial()
    end
    if self.CurPercent < TargetPercent then
        self:CheckWaterLevelAndUpdateTextMap(TargetPercent)
        self.CurPercent = math.min(self.CurPercent + 0.01, TargetPercent)
        self:UpdatePointStateByWaterLevel()
        self.ColorBarProgress:SetScalarParameterValue("Percent", self.CurPercent)
        self:SetProcessOngoingPosition(self.ProgressLen * self.CurPercent, true)
    elseif self.CurPercent > TargetPercent then
        self:CheckWaterLevelAndUpdateTextMap(TargetPercent)
        self.CurPercent = math.max(self.CurPercent - 0.01, TargetPercent)
        self.ColorBarProgress:SetScalarParameterValue("Percent", self.CurPercent)
        self:SetProcessOngoingPosition(self.ProgressLen * self.CurPercent, false)
    else
        self:HideWaterLevelUI()
        self:CheckWaterLevelAndUpdateTextMap(TargetPercent)
        self:RemoveTimer("ProgressToTarget")
        if self.CurPercent == 1 then
            local GameMode = UE4.UGameplayStatics.GetGameMode(self) 
            GameMode:TriggerGameModeEvent("OnCoDefenceProgressFull")      
        end
    end
end

--文本根据不同情况设置textmap
function WBP_CoDefenceProgress_C:CheckWaterLevelAndUpdateTextMap(TargetPercent)
    if not self.WaterLevelTextmap then
        return
    end
    if self.CurPercent < TargetPercent then
        if not self.IsPlayedAnimation then
            self:PlayAnimation(self.Text_Refresh)
            self.IsPlayedAnimation = true
        end
        self.Text_Title:SetText(GText(self.WaterLevelTextmap[1]))
    elseif self.CurPercent > TargetPercent then
        --self.Text_Title:SetText(GText(self.WaterLevelTextmap[4])) --水位下降中暂时不需要
    elseif self.CurPercent == 1 then 
        self.Text_Title:SetText(GText(self.WaterLevelTextmap[2]))
        self:PlayAnimation(self.Text_Refresh)
    elseif self.CurPercent == 0 then
        self.Text_Title:SetText(GText(self.WaterLevelTextmap[5]))
        self:PlayAnimation(self.Text_Refresh)
    else
        -- if self.PointWidgetInstances[math.min(self.CurPointIndex + 1, self.TotalPointNum)].IsDestroy then
        --     self.Text_Title:SetText(GText(self.WaterLevelTextmap[3]))
        -- else
        --     self.Text_Title:SetText(GText(self.WaterLevelTextmap[7]))
        -- end
    end
end

function WBP_CoDefenceProgress_C:CloseDungeonUI()
    self:Close()
end

return WBP_CoDefenceProgress_C
