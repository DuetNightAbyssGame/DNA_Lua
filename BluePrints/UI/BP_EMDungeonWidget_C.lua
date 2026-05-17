
local M = Class({--[["BluePrints.Common.StageTimerMgr", ]]"BluePrints.UI.BP_EMUserWidget_C"})

M._components = {
    "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

-- BP_EMUserWidgetUtils_C 已经做过了，这里不再需要了
-- -- 性能优化 需要传入UE4.ETickingGroup.TG_EndPhysics
-- function M:AddTimer(Interval, Func, IsLoop, Delay, Key, IsRealTime, ...)
--     return M.Super.AddTimer(self, Interval, Func, IsLoop, Delay, Key, IsRealTime, UE4.ETickingGroup.TG_EndPhysics, ...)
-- end

function M:InitDungeonWidget()
    self:InitListenEvent()
end

function M:InitListenEvent()
    
end

-- @param PosName string 挂载的点位名称
-- @param PosType string 挂载的点位类型 {"Overlay","SizeBox"}
function M:AddToBattleMain(PosName, PosType)
    if (not PosName) or (not PosType) then
        return
    end

    local Res = self:TryAddToBattleMain(PosName, PosType)
    if Res then
        return
    end

    self:AddTimer(0.1, function()
        local Res1 = self:TryAddToBattleMain(PosName, PosType)
        if Res1 then
            self:RemoveTimer("AddSelfToBattleMain")
        end
    end, true, 0, "AddSelfToBattleMain")
end

function M:TryAddToBattleMain(PosName, PosType)
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if not BattleMainUI then
        return false
    end

    BattleMainUI[PosName]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if PosType == "Overlay" then
        BattleMainUI[PosName]:AddChildToOverlay(self)
    elseif PosType == "SizeBox" then
        BattleMainUI[PosName]:AddChild(self)
    end
    return true
end

AssembleComponents(M)
return M
