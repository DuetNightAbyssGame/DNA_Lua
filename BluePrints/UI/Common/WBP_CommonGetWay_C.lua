--
-- DESCRIPTION
-- 包裹获取途径相关
-- @COMPANY **
-- @AUTHOR ** hy
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_CommonGetWay_C = Class()

function WBP_CommonGetWay_C:Initialize(Initializer)
    self.AllGetWay = {}
end

function WBP_CommonGetWay_C:ClickToGetWay()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    UIManger:LoadUI(UIConst.COMMONSCREENTOAST, "CommonScreenToast", UIConst.ZORDER_FOR_COMMON_TIP, "途径待开通", 1.0)
end

return WBP_CommonGetWay_C
