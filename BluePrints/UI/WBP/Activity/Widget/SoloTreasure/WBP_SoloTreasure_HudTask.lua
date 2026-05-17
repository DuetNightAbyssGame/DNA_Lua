--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_HudTask
local M = Class({"BluePrints.UI.BP_EMDungeonWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    DebugPrint("yly    WBP_SoloTreasure_HudTask Initialize")
end

function M:Construct()
    DebugPrint("yly    WBP_SoloTreasure_HudTask Construct")
    EventManager:AddEvent(EventID.OnTaskEnded, self, self.OnTaskEnded)
    EventManager:AddEvent(EventID.OnAllContainersRewardsClaimed, self, self.CloseSelf)
end

-- function M:Tick(MyGeometry, InDeltaTime)
--     DebugPrint("yly    WBP_SoloTreasure_HudTask Tick")
-- end

function M:Destruct()
    DebugPrint("yly    WBP_SoloTreasure_HudTask Destruct")
    EventManager:RemoveEvent(EventID.OnTaskEnded, self)
    if self:IsExistTimer("SoloTreasureGuardTaskCountDown") then
        self:RemoveTimer("SoloTreasureGuardTaskCountDown")
    end
end

function M:InitDungeonWidget(TaskInfo)
    M.Super.InitDungeonWidget(self)
    self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
    self:InitContent(TaskInfo)
    self:AddToBattleMain("Task","Overlay")
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self:PlayAnimation(self.In)
end

function M:RemoveTaskWidget()
    self:PlayAnimation(self.Out)
end

function M:InitContent(TaskInfo)
    if TaskInfo == nil then
        DebugPrint("yly    WBP_SoloTreasure_HudTask TaskInfo == nil")
        return
    end
    self.Panel_Title:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Panel_Task:SetVisibility(UIConst.VisibilityOp["Visible"])
    self.WB_Point:SetVisibility(UIConst.VisibilityOp["Visible"])

    self.Text_Title:SetText(GText("UI_SoloTreasure_GuardTask_LevelText"))
    self.Text_TaskTitle:SetText(GText("UI_Extraction_TM_43")) -- 任务文本
    local GamePlayId = TaskInfo.GamePlayId
    self.Text_TaskContent:SetText(GText(DataMgr.SoloTreasureGamePlay[GamePlayId].Title))
    self.Text_Num:SetText(DataMgr.SoloTreasureGamePlay[GamePlayId].TaskGains)
    self.TaskMaxTime = DataMgr.SoloTreasureGamePlay[GamePlayId].CountDown
    self.TimeCountDown = self.TaskMaxTime
    self:ShowFormatTimeMMSS(self.TaskMaxTime)
    self.timer = self:AddTimer(0.5, self.UpdateCountDownUI, true, 0, "SoloTreasureGuardTaskCountDown", false)
    self.ContainerIdList = DataMgr.SoloTreasureGamePlay[GamePlayId].Container
    local ContainerNum = self:table_leng(self.ContainerIdList)
    self.WB_Point:ClearChildren()
    for i = 1, ContainerNum do
        local ContainerInfoItem = UIManager(self):_CreateWidgetNew("SoloTreasureHudItem01")
        local ItemData = {
            Order = i,
            ContainerId = DataMgr.SoloTreasureGamePlay[GamePlayId].Container[i]
        }
        ContainerInfoItem:SetData(ItemData)
        local slot = self.WB_Point:AddChildToWrapBox(ContainerInfoItem)
    end
end

-- 将秒级时间戳转成 mm:ss
function M:ShowFormatTimeMMSS(seconds)
    seconds = math.max(0, math.floor(seconds))

    local min = math.floor(seconds / 60)
    local sec = seconds % 60

    self.Text_Time:SetText(string.format("%02d:%02d", min, sec))
end

function M:UpdateCountDownUI()
    -- if self.TimeCountDown > 0 then
    --     self.TimeCountDown = self.TimeCountDown - 1
    -- else
    --     self.TimeCountDown = 0
    --     if self:IsExistTimer("SoloTreasureGuardTaskCountDown") then
    --         self:RemoveTimer("SoloTreasureGuardTaskCountDown")
    --         -- self:OnTaskEnded(false)
    --     end
    -- end
    if self.GameMode then
        self.TimeCountDown = self.GameMode:TriggerDungeonComponentFun("OnGetDefenceGameRemainTime")
    end
    self:ShowFormatTimeMMSS(self.TimeCountDown)
end

function M:OnTaskEnded(IsWin)
    if IsWin then
        self.Panel_Task:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.WB_Point:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Text_TaskContent:SetText(GText("UI_Extraction_TM_42")) -- 任务显示《开启藏宝容器》
    else
        self:CloseSelf()
    end
end

function M:CloseSelf()
    DebugPrint("yly     CloseSelf")
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    if self:GetVisibility() ~= ESlateVisibility.Collapsed then
        self:BindToAnimationFinished(self.Out, {self, function()
            self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end})
        self:PlayAnimation(self.Out)
    end
end

function M:table_leng(t)
  local leng=0
  for k, v in pairs(t) do
    leng=leng+1
  end
  return leng;
end

return M