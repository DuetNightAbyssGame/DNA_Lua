--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_SettleItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

-- function M:Initialize(Initializer)
-- end

function M:Construct()
    DebugPrint("thy       abyssItem   Construct")
    self.VX_Star:SetVisibility(ESlateVisibility.Visible)
    self.Root:SetRenderOpacity(0)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    --设置文本
    self.Text_Tier:SetText(string.format(GText("Abyss_NextDungeonShow"), GText("UI_Chardata_Data_Num_"..Content.RoomIndex)))
    --切换和星星状态
    if Content.CountDown > 0 then 
        self.Switcher_Star:SetActiveWidgetIndex(0)
    else
        self.VX_Star:SetVisibility(ESlateVisibility.Collapsed)
        self.Switcher_Star:SetActiveWidgetIndex(1)
    end
    --EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)
    self:PlayAnimation(self.In)
    if Content.ItemIndex == 5 then
        self.Img_Deco:SetVisibility(ESlateVisibility.Collapsed)
    end
end

return M
