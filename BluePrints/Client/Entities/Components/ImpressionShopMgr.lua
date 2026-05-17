---@class ImpressionShopMgr
local Component = {}


function Component:PurchaseImpressionShopItem(ClientDelegate, ImpressionShopId, DiceNum)
    if not ImpressionShopId then
        Utils.ScreenPrint("印象商品Id为空，请检查代码逻辑")
    end
    local function Callback(Ret, IsCheckSuccess, rand1, rand2, PurchaseRewards)
        self.logger.debug("ZJT_ PurchaseImpressionShopItem ", Ret , IsCheckSuccess, rand1, rand2, PurchaseRewards)
        if ClientDelegate and ClientDelegate[1] and ClientDelegate[2] then
            ClientDelegate[2](ClientDelegate[1], Ret, IsCheckSuccess, rand1, rand2, PurchaseRewards)
        end
    end
    self:CallServer("PurchaseImpressionShopItem", Callback, ImpressionShopId, DiceNum)
end

---- 一般指在打开商店时解锁走这里 由服务器发起 Params == table
function Component:UnlockImpressionShopItem(UnlockShopIds)
    DebugPrint("ZJT_ 111111 UnlockImpressionShopItem ", UnlockShopIds)
    PrintTable({UnlockShopIds = UnlockShopIds}, 10)
end
return Component