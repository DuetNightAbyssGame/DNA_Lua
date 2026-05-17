--
-- DESCRIPTION
-- 通用Toast
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_ToastList_P
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.CurNewToastIndex = 0
end

function M:AddAndUpdateCurrentUITips()
    self.CurNewToastIndex = self.CurNewToastIndex + 1
    -- UITipList:SetNeedPaintDeferred(self.IsMenuAnchorOpen and not self:IsInHUDShowMode())
    local AllChildCount = self.VerticalBox_Toast:GetChildrenCount()
    if (AllChildCount >= 3) then
        -- 如果超过三个，则倒数第三个立刻播放消失动画
        local FirstUITopTip = self.VerticalBox_Toast:GetChildAt(AllChildCount - 3)
        FirstUITopTip:PlayOutAnim()
    end
    -- 新增一个，剩下的两个需要播放额外动效
    for TipsIndex = 1, 2, 1 do
        local SpecialUITopTip = self.VerticalBox_Toast:GetChildAt(AllChildCount - TipsIndex)
        if (SpecialUITopTip == nil) then
            break
        end
        if (type(SpecialUITopTip.PlayFadeInAnimByIndex) == "function") then
            SpecialUITopTip:PlayFadeInAnimByIndex(TipsIndex)
        end
    end
    return self.CurNewToastIndex
end

function M:Hide(HideTag)
    M.Super.Hide(self, HideTag)
    self.VerticalBox_Toast:ClearChildren()
end

function M:AddNewUITips(UITopTipItem)
    self.VerticalBox_Toast:AddChildToVerticalBox(UITopTipItem)
end

function M:RemoveUITips(UITopTipItem)
    self.CurNewToastIndex = self.CurNewToastIndex - 1
    self.VerticalBox_Toast:RemoveChild(UITopTipItem)
end

function M:Destruct()
    M.Super.Destruct(self)
    self.VerticalBox_Toast:ClearChildren()
end

return M
