require "UnLua"

local LuaConst = require("EMLuaConst")
local BP_TalkItemInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

function BP_TalkItemInteractiveComponent_C:SetInteractiveInfo(Info)
    self.Info = Info
    self:SetInteractiveDistance(Info.InteractiveDistance)
    self.PlayerFaceAngle = Info.PlayerFaceAngle
    self.TalkItemFaceAngle = Info.TalkItemFaceAngle
    self:InitCommonUIConfirmID(Info.InteractiveId)
    self:ProcessRawInfo()
end

function BP_TalkItemInteractiveComponent_C:ProcessRawInfo()
    self.bEnableItemFaceCheck = self.TalkItemFaceAngle and self.TalkItemFaceAngle > 0 and self.TalkItemFaceAngle < 180
    self.bEnablePlayerFaceCheck = self.PlayerFaceAngle and self.PlayerFaceAngle > 0 and self.PlayerFaceAngle < 180
    self.bEnableDistanceCheck = self.InteractiveDistance and self.InteractiveDistance > 0
end

function BP_TalkItemInteractiveComponent_C:BtnClicked(PlayerActor, InPressTimeSeconds)
    if self.Info and self.Info.StartInteractiveCallback then
        self.Info.StartInteractiveCallback(PlayerActor)
    end
end

function BP_TalkItemInteractiveComponent_C:IsCanInteractive(PlayerActor)
    local bRes = true
    if LuaConst.OpenComputeInteractive then
        if self.bEnableDistanceCheck then
            -- bRes = bRes and self.DistanceCheck(self.Owner, PlayerActor, self.InteractiveDistance)
            bRes = bRes and self:GetDistanceCheckResult()
        end
    else
        if self.bEnableDistanceCheck then
            bRes = bRes and self.DistanceCheck(self.Owner, PlayerActor, self.InteractiveDistance)
        end
    end

    if self.bEnableItemFaceCheck then
        bRes = bRes and self.BFaceToACheck(PlayerActor, self.Owner, self.TalkItemFaceAngle, false)
    end

    if self.bEnablePlayerFaceCheck then
        bRes = bRes and self.BFaceToACheck(self.Owner, PlayerActor, self.PlayerFaceAngle, false)
    end

    return bRes
end

return BP_TalkItemInteractiveComponent_C
