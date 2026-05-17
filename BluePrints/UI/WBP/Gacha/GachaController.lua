local GachaModel = require "BluePrints.UI.WBP.Gacha.GachaModel"
local GachaCommon = require "BluePrints.UI.WBP.Gacha.GachaCommon"

--- @class GachaController :Controller
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
    M.Super.Init(self)

end

function M:Destory()
    M.Super.Destory(self)
end

--- @return GachaCommon
function M:GetModel()
    return GachaModel
end

function M:GetEventName()
    return EventID.GachaControllerEvent
end

--region 界面操作
function M:OpenView(WorldContex, Param)
    return M.Super.OpenView(self, WorldContex, GachaCommon.UIName, Param)
end

function M:GetView(WorldContex)
    return M.Super.GetView(self, WorldContex, GachaCommon.UIName)
end

--- 进行抽卡
function M:TryGacha(GachaId, IsSingle)
    local GachaTimes = GachaCommon.GachaTenResults
    if IsSingle then
        GachaTimes = GachaCommon.GachaOneResult
    end
    local Res = GachaModel:CheckCanGacha(GachaId, GachaTimes, false)
    if Res == 2 then
        UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_GACHA_CONDITION_INVALID, 1.0, "CommonToastMain")
    end
    if Res == 0 then
        -- self:RefreshOwnedAssets()
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Avatar:DrawSkinGacha(GachaId, tonumber(GachaTimes))
        end
    end
    return Res
end

--endregion

_G.GachaController = M
return M
