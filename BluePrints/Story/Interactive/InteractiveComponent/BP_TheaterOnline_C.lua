require "UnLua"
require "DataMgr"

---@type BP_TheaOnlineInteract_C

local LuaConst = require("EMLuaConst")
local BP_TheaOnlineInteract_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

function BP_TheaOnlineInteract_C:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.Owner = self:GetOwner()
end

function BP_TheaOnlineInteract_C:SetComponentInfo()
    self.bIsAccept = false
end

function BP_TheaOnlineInteract_C:IsCanInteractive(PlayerActor)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return false end
    local Cb = function(ErrCode,Ret)
        if Ret and Ret.IsJoin == false then
            self.bIsAccept = false
        else
            self.bIsAccept = true
        end
    end
    Avatar:TheaterPerformStateGet(Cb)

    if LuaConst.OpenComputeInteractive then
        return self:GetDistanceCheckResult()
            and self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false)
            and not self.bIsAccept
    else
        return self.DistanceCheckComponent(self, PlayerActor, self.InteractiveDistance, false)
            and self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false)
            and not self.bIsAccept
    end
end

function BP_TheaOnlineInteract_C:StartInteractive(PlayerActor)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Cb = function(ErrCode,Ret)
        local ErrorContent = DataMgr.ErrorCode[ErrCode] and DataMgr.ErrorCode[ErrCode].ErrorCodeContent or GText("报名成功")
        DebugPrint("ayff test 剧院联机活动加入结果:", ErrorContent)
        if ErrCode == ErrorCode.RET_SUCCESS then
            UIManager(self):ShowUITip("CommonToastMain", GText("TheaterOnline_Game_Sign_Success"),3)
            self.bIsAccept = true
            EventManager:FireEvent(EventID.OnTheaterJoinPerformGame)
            return
        elseif ErrCode == ErrorCode.RET_THEATER_PERFORMGAME_NOT_JOIN_TIME then
            -- 新增报名失败倒计时
            UIManager(self):ShowUITip("CommonToastMain", GText("TheaterOnline_Game_Sign_Fail"),3)
            EventManager:FireEvent(EventID.OnTheaterJoinPerformGameFail)
        else
            UIManager(self):ShowUITip("CommonToastMain", GText("TheaterOnline_Game_Sign_Fail"),3)
        end
    end
    Avatar:TheaterJoinPerformGame(Cb)
end

function BP_TheaOnlineInteract_C:BtnPressed(PlayerActor)
	self:StartInteractive(PlayerActor)
end

return BP_TheaOnlineInteract_C
