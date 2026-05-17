require "UnLua"
require "DataMgr"

local M = Class("BluePrints.Item.Chest.BP_MechanismBase_C")

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.KeyNum = 0
    if self.UnitParams then
        self.TreasureId = self.UnitParams["TreasureId"] or 0
        self.TimeOutTime = self.UnitParams["TimeOutTime"] or 5
    end
    if self.TreasureId then
        self.KeyID = DataMgr.ExtractionTreasureRewardRoom[self.TreasureId] and DataMgr.ExtractionTreasureRewardRoom[self.TreasureId].KeyID or 0
    end
    local ServerEntity = GWorld:GetServerEntity()
    if ServerEntity then
        self.DungeonObject = ServerEntity:GetDungeonObject()
    end
    self.CanExeuteOpenSuccess = true
end

function M:CheckCanInteractive(Player)
    if not self.DungeonObject then
        return false
    end
    local TreasureDatas = self.DungeonObject:GetTreasureDatasById(self.KeyID)
    self.KeyNum = #TreasureDatas
    return next(TreasureDatas)
end

function M:OpenMechanism(PlayerId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    local CB = function (RetCode)
        if RetCode == ErrorCode.RET_SUCCESS then
            self:OpenSuccess()
        end
    end
    GameMode:NotifyServerDungeonEventWithCallback(CB, "RewardRoomOpen", self.ServerUniqueId)
    self:AddTimer(self.TimeOutTime, self.TimeOut)
end

function M:OpenSuccess()
    self:ChangeState("Manual", 0, 1310703)
end

function M:TimeOut()
    DebugPrint("TreasureRoom TimeOut")
    -- UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_NetDelay"))
end

-- 覆盖交互组件显示文字
function M:GetInteractiveName(PlayerActor)
    local StrText = ""
    local InteractiveId = self.Data.InteractiveId
    if InteractiveId and DataMgr.CommonUIConfirm[InteractiveId] then
        if self.DefaultInteractiveComponent then
            self.DefaultInteractiveComponent:OverrideInteractiveIcon(DataMgr.CommonUIConfirm[InteractiveId].Icon)
        end
        if DataMgr.CommonUIConfirm[InteractiveId].ConfirmText then
            StrText = GText(DataMgr.CommonUIConfirm[InteractiveId].ConfirmText)
        end
        local HaveKey = self:CheckCanInteractive(PlayerActor)
        if HaveKey then
            StrText = "<Highlight>"..self.KeyNum.."/1</> "..StrText
        else
            StrText = "<Warning>0/1</> "..StrText
        end
    end
    return StrText
end

-- 覆盖交互组件Forbid逻辑
function M:IsForbidden(PlayerActor)
    return not self:CheckCanInteractive(PlayerActor)
end

return M
