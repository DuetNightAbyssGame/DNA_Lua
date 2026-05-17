--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_HudItem01_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    DebugPrint("yly    WBP_SoloTreasure_HudItem01_C Initialize")
end

function M:Construct()
    DebugPrint("yly    WBP_SoloTreasure_HudItem01_C Construct")
    EventManager:AddEvent(EventID.OnContainerBeAttacked,self, self.OnContainerAttacked)
    EventManager:AddEvent(EventID.OnContainerBeRepaired,self, self.OnContainerRepaired)
    EventManager:AddEvent(EventID.OnContainerDestroyed,self, self.OnContainerDestroyed)
end

function M:Destruct()
    DebugPrint("yly    WBP_SoloTreasure_HudItem01_C Destruct")
    EventManager:RemoveEvent(EventID.OnContainerBeAttacked, self)
    EventManager:RemoveEvent(EventID.OnContainerBeRepaired, self)
    EventManager:RemoveEvent(EventID.OnContainerDestroyed, self)
end

function M:SetData(data)
    if data == nil then
        GWorld.logger.error("WBP_SoloTreasure_HudItem01_C get data = nil")
        return
    end
    self.Order = data.Order
    self.ContainerId = data.ContainerId
    self.CurHpPercent = 1.0  -- 满血

    -- 显示HP
    self:ShowHP(self.CurHpPercent)
    -- 设置图标（ABCD）
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance == nil then
        DebugPrint("WBP_SoloTreasure_HudItem01_C: GameInstance 不存在")
        return
    end
    local SceneManager = GameInstance:GetSceneManager()
    if SceneManager == nil then
        DebugPrint("WBP_SoloTreasure_HudItem01_C: SceneManager 不存在")
        return
    end
    local Content = string.char(string.byte('A') + self.Order - 1)
    local RetPath = SceneManager:GetExcavationABCIconPath(Content)
    UE4.UResourceLibrary.LoadObjectAsync(self, RetPath, {self, self.RealSetABCImg})

    -- yly Test
    -- self:AddTimer(2.0, function()
    --     self:ShowHP(0)
    -- end)
    -- self:AddTimer(2.3, function()
    --     self:PlayAnimation(self.Normal)
    --     -- self:PlayAnimation(self.UnderAttack)
    -- end)
end

function M:SetSpecialEffectForDiffHp(CurHpPercent)
    if CurHpPercent >= 0.5 then
        self:PlayAnimation(self.HP_Healthy)
    elseif CurHpPercent > 0 then
        self:PlayAnimation(self.HP_Low)
    else
        self:PlayAnimation(self.Destroyed)
    end
end

function M:RealSetABCImg(Object)
    self.Icon_Organ:SetBrushResourceObject(Object)
end

function M:ShowHP(CurHpPercent)
    -- 设置环形进度
    self.Progress:GetDynamicMaterial():SetScalarParameterValue("Percent", 1.0 - CurHpPercent)
    -- 设置Hp对应特效
    self:PlayAnimation(self.Normal)
    self:AddTimer(0.1, function()
        self:SetSpecialEffectForDiffHp(CurHpPercent)
    end)
end

function M:OnContainerAttacked(CStaticId, CurHpPercent)
    if CStaticId == self.ContainerId then
        DebugPrint("yly HudItem01 CStaticId = ", CStaticId, "Attacked, ShowHP = ", CurHpPercent)
        self:ShowHP(CurHpPercent)
        if not self:IsExistTimer("TimerRedFlash" .. self.ContainerId) then
            self:AddTimer(0.2, function()
                self:PlayAnimation(self.UnderAttack)
            end, false, 0, "TimerGap".. self.ContainerId)
            -- self:PlayAnimation(self.UnderAttack)
            self:AddTimer(1.5, function()
                -- self:StopAnimation(self.UnderAttack) 这种方式暂停不了UnderAttack
                self:PlayAnimation(self.Normal)
            end, false, 0, "TimerRedFlash".. self.ContainerId)
        end
    end
end

function M:OnContainerRepaired(CStaticId, CurHpPercent)
    if CStaticId == self.ContainerId then
        self:ShowHP(CurHpPercent)
        self:PlayAnimation(self.Return)
    end
end

function M:OnContainerDestroyed(CStaticId)
    if CStaticId == self.ContainerId then
        self:RemoveTimer("TimerRedFlash" .. self.ContainerId)
        self:RemoveTimer("TimerGap" .. self.ContainerId)
        DebugPrint("yly HudItem01 CStaticId = ", CStaticId, "Destroyed, ShowHP = ", 0)
        self:ShowHP(0)
    end
end

return M