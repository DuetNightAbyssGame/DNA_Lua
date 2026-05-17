--
-- DESCRIPTION
--
-- @COMPANY ** 搜打撤背包详情面板
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")

---@type WBP_SoloTreasure_BagDetail_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-- function M:Destruct()

-- end

function M:Init(InitParams)
    self.Parent = InitParams.Parent
    if not self.Parent or not InventoryController or not InventoryController.bInit then return end
    self:InitEvents()
    self.Text_Details:SetText(GText("UI_GACHA_DESDETAIL"))
    self.Text_Details01:SetText(GText("UI_Extraction_TotalScore"))
    self.Text_Details02:SetText(GText("UI_Extraction_BattleScore"))
    self.Text_Details03:SetText(GText("UI_Extraction_BattleScoreDescription"))
    self.Text_Details04:SetText(GText("UI_Extraction_TreasureScore"))
    self.Text_Details05:SetText(GText("UI_Extraction_TreasureScoreDescription"))
    local ServerEntity = GWorld:GetServerEntity()
    if not ServerEntity then self:CloseSelf() return end
    self.Dungeonobject = ServerEntity:GetDungeonObject()
    if not self.Dungeonobject then self:CloseSelf() return end
    self:UpdateBagTreasureValues()
    self:UpdateCombatValues()
end

function M:InitEvents()
    self.BP_OnAddedToFocusPath:Add(self,self.OnAddedToFocusPath)
    self.BP_OnRemovedFromFocusPath:Add(self,self.OnRemovedFromFocusPath)
    self:AddDispatcher(EventID.OnUpdateBagTreasureScore, self, function()
        self:UpdateBagTreasureValues()
    end)
    self:AddDispatcher(EventID.OnUpdateGameScore, self, function()
        self:UpdateCombatValues()
    end)
end

function M:RemoveEvents()
    self.BP_OnAddedToFocusPath:Remove(self,self.OnAddedToFocusPath)
    self.BP_OnRemovedFromFocusPath:Remove(self,self.OnRemovedFromFocusPath)
    self:RemoveDispatcher(EventID.OnUpdateBagTreasureScore, self)
    self:RemoveDispatcher(EventID.OnUpdateGameScore, self)
end

function M:UpdateBagTreasureValues()
    if not self.Dungeonobject then return end
    local BagTreasureValue = self.Dungeonobject.TreasureScore or 0
    if BagTreasureValue then
        local FormattedBagTreasureValue = Utils.FormatNumber(BagTreasureValue, false)
        self.Text_DetailsNum02:SetText(tostring(FormattedBagTreasureValue))
    end
end

function M:UpdateCombatValues()
    if not self.Dungeonobject then return end
    local CombatScore = self.Dungeonobject.KillMonsterScore or 0
    if CombatScore then
        local FormattedCombatScore = Utils.FormatNumber(CombatScore, false)
        self.Text_DetailsNum01:SetText(tostring(FormattedCombatScore))
    end
end

function M:CloseSelf()
    self:RemoveEvents()
    if self.Parent and self.Parent.bInBagDetailState then
        self.Parent:LeaveBagDetailState()
    end
end

function M:PlayInAnim()
    if not self.In then return end
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    self:SetFocus()
end

function M:PlayOutAnim()
    if not self.Out then return end
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAddedToFocusPath()
    DebugPrint("lgc@OnAddedToFocusPath")
    if not self.Parent or not self.Parent.bInBagDetailState then return end
    
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    DebugPrint("lgc@OnRemovedFromFocusPath")
    if UIUtils.IsGamepadInput() then return end
    if not self.Parent or not self.Parent.bInBagDetailState then return end
    self.Parent:LeaveBagDetailState()
end

return M
