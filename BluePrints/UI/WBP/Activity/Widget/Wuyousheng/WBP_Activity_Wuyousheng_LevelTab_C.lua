--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Wuyousheng_LevelTab_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local WuyoushengLevelReddotName = "WuyoushengLevel"


function M:Construct()
    self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self:BindButtonPerformances()
end

function M:Destruct()
    self:UnBindButtonPerformances()
    ReddotManager.RemoveListener(WuyoushengLevelReddotName, self)
end

function M:Init(DungeonId, EventId, Index)
    self.DungeonId = DungeonId
    self.EventId = EventId
    self.Index = Index
    local WuyoushengEventLevelCfg = DataMgr.WuyoushengEventLevel[DungeonId]
    if WuyoushengEventLevelCfg then
        self.Text_Level:SetText(WuyoushengEventLevelCfg.LevelIconLetter)
    end
    self.Text_Index:SetText(Index)
    self:InitReddot()
    self:RefreshUI()
    if Index == self.ParentWidget.SelectedIndex then
        self.ParentWidget.SelectedWidget = self
        self:SetIsSelected(true)
        self:MarkLevelReddotRead()
    else
        self:SetIsSelected(false)
    end
end

function M:OnBtnClickClicked()
    if self.PerviousDungeonNotFinish then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WuyoushengEvent_Lock_Progress"))
        return
    end
    if self.ParentWidget == nil then
        return
    end
    if self.IsSelected then
        return
    end
    -- 点击时标记红点为已读
    self:MarkLevelReddotRead()
    self.ParentWidget:RefreshLevelInfo(self.DungeonId, self.Index, self.EndTime)
    self.ParentWidget:PlayAnimationForward(self.ParentWidget.Change)
    self.ParentWidget.Root.SelectedDungeonId = self.DungeonId
    self.ParentWidget.SelectedWidget:SetIsSelected(false)
    self.ParentWidget.SelectedWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    self.ParentWidget.SelectedWidget = self
    self.ParentWidget.SelectedIndex = self.Index
    self:SetIsSelected(true)
end

-- 设置选中状态
function M:SetIsSelected(IsSelected)
    if self.IsSelected == IsSelected then
        return
    end
    
    self.IsSelected = IsSelected
    if IsSelected then
        self:PlayButtonSelectAnim()
    else
        self:SwitchNormalAnimation()
        if self.IsForbidden then
            self:PlayButtonForbidAnim()
        end
    end
end

-- 设置禁用状态
function M:SetForbidden(IsForbid)
    if self.IsForbidden == IsForbid then
        return
    end
    
    self.IsForbidden = IsForbid
    self.Btn_Click:SetForbidden(IsForbid)
    if IsForbid then
        self:PlayButtonForbidAnim()
    else
        self:PlayButtonUnForbidAnim()
    end
end

function M:RefreshUI()
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.WuyoushengActivity then
        local WuyoushengData = Avatar.WuyoushengActivity[self.EventId]
        local FinishStars = 0
        if WuyoushengData then
            FinishStars = WuyoushengData:GetFinishStars(self.DungeonId) or 0
        end
        for i = 1, 3 do
            if FinishStars >= i then
                self["Star_"..i]:SetVisibility(UIConst.VisibilityOp.Visible)
            else
                self["Star_"..i]:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        end
    end
    self:RefreshLockState()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        -- 滚动到对应的位置
        if self.ParentWidget and self.ParentWidget.EMScrollBox_List and self.Index then
            -- 根据 Index 计算对应的 Widget 索引（每两个一组）
            local WidgetIndex = math.ceil(self.Index / 2)
            if self.ParentWidget.LevelTabWidgetList and self.ParentWidget.LevelTabWidgetList[WidgetIndex] then
                local TargetWidget = self.ParentWidget.LevelTabWidgetList[WidgetIndex]
                if TargetWidget then
                    self.ParentWidget.EMScrollBox_List:ScrollWidgetIntoView(TargetWidget, true)
                end
            end
        end
        self:OnBtnClickClicked()
    end
    return nil
end

function M:RefreshLockState()
    local WuyoushengEventLevelCfg = DataMgr.WuyoushengEventLevel[self.DungeonId]
    local WasLocked = self.IsLock == true
    self.IsLock = false
    self.PerviousDungeonNotFinish = false
    if WuyoushengEventLevelCfg then
        local PerviousDungeon = WuyoushengEventLevelCfg.PerviousDungeon
        if PerviousDungeon == nil then
            self.IsLock = false
        else
            local Avatar = GWorld:GetAvatar()
            if Avatar and Avatar.WuyoushengActivity then
                local WuyoushengData = Avatar.WuyoushengActivity[self.EventId]
                local FinishStars = 0
                if WuyoushengData then
                    FinishStars = WuyoushengData:GetFinishStars(PerviousDungeon) or 0
                end
                local UnlockDate = WuyoushengEventLevelCfg.UnlockDate
                UnlockDate = UnlockDate:GetTime()
                local NowTime = TimeUtils.NowTime()
                if FinishStars == 0 then
                    self.IsLock = true
                    self.PerviousDungeonNotFinish = true
                elseif NowTime < UnlockDate then
                    self.IsLock = false
                    self.EndTime = UnlockDate
                else
                    self.IsLock = false
                end
            end
        end
    end
    if self.IsLock then
        self.Image_Lock:SetVisibility(UIConst.VisibilityOp.selfHitTestInvisible)
        self:SetForbidden(true)
    else
        self.Image_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:SetForbidden(false)
    end
    -- 刷新红点显示
    self:RefreshLevelReddot()
end

-------------------------------- 按钮 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    local Btn = self.Btn_Click
    if not Btn then
        return
    end
    
    Btn.OnClicked:Add(self, self.OnBtnClicked)
    Btn.OnPressed:Add(self, self.OnBtnPressed)
    Btn.OnReleased:Add(self, self.OnBtnReleased)
    
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        Btn.OnHovered:Add(self, self.OnBtnHovered)
        Btn.OnUnhovered:Add(self, self.OnBtnUnhovered)
    end
end

function M:UnBindButtonPerformances()
    local Btn = self.Btn_Click
    if not Btn then
        return
    end
    
    Btn.OnClicked:Clear()
    Btn.OnPressed:Clear()
    Btn.OnReleased:Clear()
    
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        Btn.OnHovered:Clear()
        Btn.OnUnhovered:Clear()
    end
end

-------------------------------- 按钮动画相关 -----------------------------------
function M:SwitchNormalAnimation()
    self:StopAllAnimations()
    if self.Normal then
        self:PlayAnimation(self.Normal)
    end
end

function M:PlayButtonClickSound()

end

function M:PlayButtonClickAnimation()
    self:StopAllAnimations()
    if self.Click then
        self:PlayAnimation(self.Click)
    end
end

function M:OnBtnClicked(bNotPlaySound)
    -- Press时按钮的状态和现在不一样, 直接返回
    if self.CurrentClickIsForbid ~= self.IsForbidden then
        return
    end
    
    if self.IsForbidden == true then
        self:OnForbiddenClicked()
    else
        if self.IsSelected == false then
            if not bNotPlaySound then
                self:PlayButtonClickSound()
            end
            self:PlayButtonClickAnimation()
        end
        self:OnBtnClickClicked()
    end
end

function M:OnForbiddenClicked()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_WuyoushengEvent_Lock_Progress"))
end

function M:PlayButtonPressAnim()
    self:StopAllAnimations()
    if self.Press then
        self:PlayAnimation(self.Press)
    end
end

function M:OnBtnPressed()
    if self.IsSelected == true then
        return
    end
    
    if self.IsForbidden == true then
        self.CurrentClickIsForbid = true
        return
    end

    AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_sub_page_level", nil, nil)
    
    self.CurrentClickIsForbid = false
    self.IsPressing = true
    self:PlayButtonPressAnim()
end

function M:PlayButtonHoverAnim()
    self:StopAllAnimations()
    if self.Hover then
        self:PlayAnimation(self.Hover)
    end
end

function M:OnBtnHovered()
    if self.IsSelected == true then
        return
    end
    
    if self.IsForbidden == true then
        return
    end
    
    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseButHoverAnim()
    self:StopAllAnimations()
    self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseAndUnHoverAnim()
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function M:OnBtnReleased()
    self.IsPressing = false
    
    if self.IsSelected == true then
        return
    end
    
    if self.IsForbidden ~= true and not self.IsHovering then
        self:PlayButtonReleaseAndUnHoverAnim()
    elseif self.IsForbidden ~= true then
        self:PlayButtonReleaseButHoverAnim()
    end
end

function M:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function M:OnBtnUnhovered()
    self.IsHovering = false
    
    if self.IsSelected == true then
        return
    end
    
    if self.IsForbidden ~= true and not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end

function M:PlayButtonForbidAnim()
    self:StopAllAnimations()
    if self.Forbidden then
        self:PlayAnimation(self.Forbidden)
    end
end

function M:PlayButtonUnForbidAnim()
    self:StopAllAnimations()
    if self.IsHovering then
        self:PlayButtonHoverAnim()
    else
        self:SwitchNormalAnimation()
    end
end

function M:PlayButtonSelectAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

--region 红点
function M:InitReddot()
    if not ReddotManager.GetTreeNode(WuyoushengLevelReddotName) then
        ReddotManager.AddNodeEx(WuyoushengLevelReddotName, nil, Const.ReddotCacheType.UserCache)
    end
    ReddotManager.AddListenerEx(WuyoushengLevelReddotName, self, self.UpdateLevelReddot)
    self:RefreshLevelReddot()
end

function M:MarkLevelReddotRead()
    if not self.DungeonId then
        return
    end
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(WuyoushengLevelReddotName)
    if CacheData and CacheData[self.DungeonId] == true then
        CacheData[self.DungeonId] = false
        ReddotManager.DecreaseLeafNodeCount(WuyoushengLevelReddotName)
    end
end

function M:RefreshLevelReddot()
    if not self.DungeonId then
        return
    end
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(WuyoushengLevelReddotName)
    if CacheData and CacheData[self.DungeonId] == true and not self.IsLock then
        if self.New then
            self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    else
        if self.New then
            self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:UpdateLevelReddot(Count)
    self:RefreshLevelReddot()
end
--endregion

return M
