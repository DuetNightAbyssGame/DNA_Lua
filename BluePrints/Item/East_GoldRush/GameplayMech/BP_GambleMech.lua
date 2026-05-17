require "UnLua"
require "DataMgr"

local M = Class("BluePrints.Item.Chest.BP_MechanismBase_C")

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    if self.UnitParams then
        self.TributeId = self.UnitParams["TributeId"]
    end
    if self.TributeId then
        local TributeData = DataMgr.ExtractionTreasureTribute[self.TributeId]
        if TributeData then
            self.CostNum = TributeData.UnlockPoint
            self.Shape = TributeData.Shape
        end
    end
    local ServerEntity = GWorld:GetServerEntity()
    if ServerEntity then
        self.DungeonObject = ServerEntity:GetDungeonObject()
    end
    self.InteractiveContinue = false
end

function M:CheckCanInteractive(Player)
    if self.InteractiveContinue then
        return true
    end
    if not self.DungeonObject or not self.DungeonObject.KillMonsterScore or not self.CostNum then
        return false
    end
    return self.DungeonObject.KillMonsterScore >= self.CostNum
end

function M:OpenMechanism(PlayerId)
    if self.InteractiveContinue then
        UIManager(self):LoadUINew("SoloTreasureBag", {
            bSacrifice = true,
            ServerUniqueId = self.ServerUniqueId,
            TributeId = self.TributeId,
            BPGambleMech = self,
        }, function ()
        end, "Async")
    else
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if not GameMode then
            return
        end
        local CB = function ()
            UIManager(self):LoadUINew("SoloTreasureBag", {
                bSacrifice = true,
                ServerUniqueId = self.ServerUniqueId,
                TributeId = self.TributeId,
                BPGambleMech = self,
            }, function ()
            end, "Async")
        end
        GameMode:NotifyServerDungeonEventWithCallback(CB, "UnlockMechanism", self.ServerUniqueId)
    end
end

function M:TributeCancle()
    self.InteractiveContinue = true
    self:ChangeState("Manual", 0, 1310693)
end

function M:TributeSuccess()
    self:ChangeState("Manual", 0, 1310694)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    GameMode:NotifyServerDungeonEvent("SoloTreasureTribute", self.ServerUniqueId)
end

-- 覆盖交互组件显示文字
function M:GetInteractiveName(PlayerActor)
    local StrText = ""
    local InteractiveId = self.Data.InteractiveId
    if InteractiveId and DataMgr.CommonUIConfirm[InteractiveId] then
        if self.DefaultInteractiveComponent then
            self.DefaultInteractiveComponent:OverrideInteractiveIcon(DataMgr.CommonUIConfirm[InteractiveId].Icon)
        end
        if self.InteractiveContinue then
            StrText = GText("UI_Extraction_TM_9")
        elseif DataMgr.CommonUIConfirm[InteractiveId].ConfirmText then
            StrText = GText(DataMgr.CommonUIConfirm[InteractiveId].ConfirmText)
        end
    end
    return StrText
end

-- 覆盖交互组件Item
function M:GetCostItemInfo()
    if self.InteractiveContinue then
        return {}
    end
    if not self.DungeonObject then
        return {}
    end
    local CostItemInfo = {
        IconPath = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_26.T_Activity_SoloTreasure_26",
        CostNum = self.CostNum or 0,
        PossessNum = self.DungeonObject.KillMonsterScore or 0,
        ConsumeTextKey = GText("UI_Armory_Trace_Cost"),
    }
    return CostItemInfo
end

-- 覆盖交互组件Forbid逻辑
function M:IsForbidden(PlayerActor)
    return not self:CheckCanInteractive(PlayerActor)
end

return M
