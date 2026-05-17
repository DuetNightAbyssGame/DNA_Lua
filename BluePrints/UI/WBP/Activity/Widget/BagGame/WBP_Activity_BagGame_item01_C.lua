--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"

---@type WBP_Activity_BagGame_item01_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.bIsPlaceholder = false
end

function M:Destruct()
    -- 安全移除事件监听（无论是否为占位格子，Remove 不会报错）
    self.Btn_Center_L.OnClicked:Remove(self, self.OnCenterLBtnClicked)
    self.Btn_Center_R.OnClicked:Remove(self, self.OnCenterRBtnClicked)
end

function M:OnListItemObjectSet(Content)
    -- 先移除之前可能绑定的事件（处理 ListView widget 复用）
    ReddotManager.RemoveListener("BagGameNew", self)
    self.Btn_Center_L.OnClicked:Remove(self, self.OnCenterLBtnClicked)
    self.Btn_Center_R.OnClicked:Remove(self, self.OnCenterRBtnClicked)

    self.Owner = Content.Owner
    self.Content = Content
    self.Widget = self

    self.Switch_Change:SetVisibility(UIConst.VisibilityOp.Collapsed)

    if Content.IsPlaceholder then
        self:ShowPlaceholder()
        return
    end

    self.bIsPlaceholder = false
    self.Index = Content.Id  -- 保存索引，用于缩放计算
    self:InitData(Content)
    self:InitView(Content)

    self.Btn_Center_L.OnClicked:Add(self, self.OnCenterLBtnClicked)
    self.Btn_Center_R.OnClicked:Add(self, self.OnCenterRBtnClicked)

    -- Content 就绪后注册红点监听（回调会立即触发一次刷新）
    ReddotManager.AddListenerEx("BagGameNew", self, self.UpdateBagGameNewReddot)
end

function M:BP_OnEntryReleased()
    ReddotManager.RemoveListener("BagGameNew", self)
end

--- 红点回调：通过当前 item 的 LevelId 索引缓存判断是否显示 New
function M:UpdateBagGameNewReddot(Count, RdType, Name)
    if not self.New then return end
    if not self.Content or not self.Content.LevelId then
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail("BagGameNew")
    if NewCacheDetail and NewCacheDetail[self.Content.LevelId] == true then
        self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:InitData(Content)
end

function M:InitView(Content)
    self.Switch_Style:SetActiveWidgetIndex(1)
    self.Switch_Change:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.PanalS:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local FinishCount = 0
    if Content.TargetScore then
        for i, TargetScore in ipairs(Content.TargetScore) do
            local IsFinish = Content.PlayerScore and Content.PlayerScore >= TargetScore
            if IsFinish then
                FinishCount = FinishCount + 1
            end
        end
    end
    self:Set_NumandStart(self.Index, FinishCount)
    self:UpdateSmallStarCount(FinishCount)
    self:UpdateLockState(FinishCount)
    self:UpdateFinishState(FinishCount)
    self.Text_CenterNum_Check:SetText(tostring(self.Index))
    self.Text_CenterNum_Lock:SetText(tostring(self.Index))
end

function M:UpdateSmallStarCount(FinishCount)
    for i = 1, 3 do
        local SmallStar = self["Image_Star0" .. i]
        if SmallStar then
            if i <= FinishCount then
                SmallStar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            else
                SmallStar:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        end
    end
end

function M:UpdateLockState()
    local bUnlocked = true
    if self.Index and self.Index > 1 then
        bUnlocked = false
        if self.Owner and self.Owner.OriginalDataList then
            local PrevInfo = self.Owner.OriginalDataList[self.Index - 1]
            if PrevInfo then
                local PrevFinishCount = 0
                if PrevInfo.PlayerScore ~= nil and PrevInfo.TargetScore then
                    for _, TargetScore in ipairs(PrevInfo.TargetScore) do
                        if PrevInfo.PlayerScore >= TargetScore then
                            PrevFinishCount = PrevFinishCount + 1
                        end
                    end
                else
                    PrevFinishCount = BagGameModel:GetPlayerStarCount(PrevInfo.LevelId)
                end
                bUnlocked = PrevFinishCount > 0
            end
        end
    end

    self.bUnlocked = bUnlocked

    if self.Overlay_Lock then
        if bUnlocked then
            self.Overlay_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.Overlay_Lock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    end
end

function M:UpdateFinishState(FinishCount)
    local bFinished = FinishCount >= 3
    if self.Overlay_Check then
        if bFinished then
            self.Overlay_Check:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.Overlay_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

--- 显示占位态（第一关左侧 / 最后一关右侧的不存在的格子，仅用于占位）
function M:ShowPlaceholder()
    self.bIsPlaceholder = true
    self.bIsSelected = false
    self.Switch_Change:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.PanalS:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Switch_Style:SetActiveWidgetIndex(0)
end

function M:OnCenterLBtnClicked()
    if self.Owner and self.Owner.ScrollToPreviousItem then
        self.Owner:ScrollToPreviousItem()
    end
end

function M:OnCenterRBtnClicked()
    if self.Owner and self.Owner.ScrollToNextItem then
        self.Owner:ScrollToNextItem()
    end
end

--- 设置箭头按钮状态
---@param bCanScrollLeft boolean 是否可以向左滚动
---@param bCanScrollRight boolean 是否可以向右滚动
function M:SetArrowButtonState(bCanScrollLeft, bCanScrollRight)
    if self.Btn_Center_L then
        self.Btn_Center_L:SetIsEnabled(bCanScrollLeft)
    end
    if self.Btn_Center_R then
        self.Btn_Center_R:SetIsEnabled(bCanScrollRight)
    end
end

function M:PlaySelected()
    if self.bIsPlaceholder then return end  -- 占位格子不响应选中
    -- Switch_Change: 0=Panel_Center(解锁), 1=Panel_Lock(锁定)
    self.Switch_Change:SetActiveWidgetIndex(self.bUnlocked and 0 or 1)
    self.Switch_Change:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.PanalS:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.Change then
        self:PlayAnimation(self.Change)
    end
    self.bIsSelected = true
    self.Btn_Center_L:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Center_R:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:PlayUnselected()
    if self.bIsPlaceholder then return end  -- 占位格子不响应取消选中
    self.Switch_Change:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.PanalS:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.Change then
        self:PlayAnimationReverse(self.Change)
    end
    self.bIsSelected = false
    self.Btn_Center_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Center_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return M
