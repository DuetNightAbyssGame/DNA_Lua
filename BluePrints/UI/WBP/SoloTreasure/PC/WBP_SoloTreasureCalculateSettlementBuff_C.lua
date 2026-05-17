--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_SettlementBuff_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
--     DebugPrint("yly    WBP_SoloTreasure_SettlementBuff_C Initialize")
-- end

-- function M:Construct()
--     DebugPrint("yly    WBP_SoloTreasure_SettlementBuff_C Construct")
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-- function M:Destruct()
--     DebugPrint("yly    WBP_SoloTreasure_SettlementBuff_C Destruct")
-- end

function M:InitData(Params)
    if Params == nil then
        DebugPrint("WBP_SoloTreasure_SettlementBuff_C InitData get Params is nil")
        return
    end
    self.Description = Params.Description
    self.Quality = Params.Quality
    self:InitText()
    self:InitBuffType()
end

function M:InitText()
    if self.Description then
        self.Text_Buff:SetText(GText(self.Description))
    end
end

function M:InitBuffType()
    if self.Quality then
        self:SetBuffType(self.Quality - 1)
    end
end

return M
