require "UnLua"

local HeadImpressionShopWidgetMgr = Class("BluePrints.Common.TimerMgr")

--- 纯Lua，单纯控制印象商店提示UI的显隐规则

--[[
HeadImpressionShopWidgetMgr.New = function(OwnerNpc)
    local Obj = setmetatable({}, {
        __index = HeadImpressionShopWidgetMgr
    })
    Obj.Owner = OwnerNpc

    ---@type float 刷新状态频率, 单位second
    Obj.UpdateImpressionStateInterval = 1 

    ---@type float 显示Widget的距离检测阈值,
    Obj.ShowImpressionDistanceSquare = 4000 * 4000

    Obj:AddImpressionShopShowTimer()
    return Obj
end

function HeadImpressionShopWidgetMgr:AddImpressionShopShowTimer()
    self.Owner:AddTimer(self.UpdateImpressionStateInterval, function()
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        if (not Player) or (not self.Owner)then 
            return 
        end
        local P0 = Player:K2_GetActorLocation()
        local P1 = self.Owner:K2_GetActorLocation()
        local DisSquare = UE4.UKismetMathLibrary.Vector_DistanceSquared(P0 ,P1)

        if DisSquare <= self.ShowImpressionDistanceSquare then
            self.Owner:OnEnableImpressionShopWidget(true)
        else
            self.Owner:OnEnableImpressionShopWidget(false)
        end

    end, true, 0, "RefreshWidget", false)
end
--]]

return HeadImpressionShopWidgetMgr