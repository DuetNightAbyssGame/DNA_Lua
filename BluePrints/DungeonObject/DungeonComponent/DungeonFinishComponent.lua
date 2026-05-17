local DungeonFinishComponent = DungeonClass.Class()

DungeonFinishComponent.__Component__ = {
}

function DungeonFinishComponent:BeginPlay()
    print("ljl@ DungeonFinishComponent BeginPlay")
end

-- 接受来自客户端发起的结束副本请求
function DungeonFinishComponent:OnNotifyServerDungeonEvent_TriggerGameEnd(IsWin, GameEndReason)
    print("ljl@ TriggerGameEnd IsWin", IsWin, "GameEndReason", GameEndReason)
    self:TryDungeonFinish(IsWin, GameEndReason)
end

-- 副本结束逻辑起点（服务器可调用）
function DungeonFinishComponent:TryDungeonFinish(IsWin, GameEndReason)
    local IsAllowedFinish = true
    if self.CheckAllowedFinish then     -- 各个玩法可以实现这个方法，检查副本是否允许结算
        IsAllowedFinish = self:CheckAllowedFinish(IsWin, GameEndReason)
    end

    print("ljl@ DungeonFinishComponent TryDungeonFinish IsAllowedFinish", IsAllowedFinish, "IsWin", IsWin, "GameEndReason", GameEndReason)
    if not IsAllowedFinish then
        return IsAllowedFinish
    end

    self:DungeonFinish(IsWin)
    self:NotifyGameModeDungeonEvent("OnServerGameEnd", IsWin, GameEndReason)
    return IsAllowedFinish
end

DungeonClass.AssembleComponents(DungeonFinishComponent)
return DungeonFinishComponent