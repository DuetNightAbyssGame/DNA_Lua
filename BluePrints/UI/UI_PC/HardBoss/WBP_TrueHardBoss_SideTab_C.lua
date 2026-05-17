--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_TrueHardBoss_SideTab_C = Class("BluePrints.UI.BP_EMUserWidget_C")

-- function WBP_TrueHardBoss_SideTab_C:Initialize(Initializer)
-- end

function WBP_TrueHardBoss_SideTab_C:Construct()
    self.Btn_TabClick.OnClicked:Add(self, self.OnCellClicked)
    self.Btn_TabClick.OnHovered:Add(self, self.OnCellHovered)
    self.Btn_TabClick.OnUnhovered:Add(self, self.OnCellUnhovered)
    self.Btn_TabClick.OnPressed:Add(self, self.OnCellPressed)
    self.Btn_TabClick.OnReleased:Add(self, self.OnCellReleased)
    self.Btn_TabClick:SetVisibility(UE4.ESlateVisibility.Visible)
end

function WBP_TrueHardBoss_SideTab_C:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Entry = self
    local AllDifficultyInfo = DataMgr.HardBossDifficulty
    local DifficultyInfo = AllDifficultyInfo[self.Content.Id]
    local DifficultyLevel = DifficultyInfo.DifficultyLevel
    self.UnlockCondition = DifficultyInfo.UnlockCondition
    self.Text_TabLevelNormal:SetText(GText("BATTLE_UI_BLOOD_LV")..DifficultyLevel)
    self.Text_TabLevelSelect:SetText(GText("BATTLE_UI_BLOOD_LV")..DifficultyLevel)
    self:BindEventOnClicked(self.Content.Parent,self.Content.Parent.RefreshListBossInfo,self.Content.Index)
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar:CheckHardBossCondition(self.Content.Id) then
        self.Content.IsLocked = false
        if self.Content.Parent.Flag then
            self.Content.SelectedIndex[self.Content.Parent.HardBossId] = self.Content.Index
        end
    else
        self.Content.IsLocked = true
    end
    if self.Content.IsLocked then
        if self.Content.IsSelect then
            self:PlayAnimation(self.Lock_Click)
        else
            self:PlayAnimation(self.Lock_Normal)
        end
    else
        if self.Content.IsSelect then
            self:PlayAnimation(self.Click)
        else
            self:PlayAnimation(self.Normal)
        end
    end
    if self.Content.IsSelect then
        self.Group_TabSelect:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.Group_Normal:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Group_TabSelect:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Group_Normal:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
    if self.Content.Index == self.Content.NumberOfChoices then
        self.Image_TabLine:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Image_TabLineSelect:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Content.Parent:SelectFirstTime()
    end
end

function WBP_TrueHardBoss_SideTab_C:BindEventOnClicked(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = { ... }
end

function WBP_TrueHardBoss_SideTab_C:OnCellClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
    return self:OnCellClickedWithoutSound()
end

function WBP_TrueHardBoss_SideTab_C:OnCellClickedWithoutSound()
    -- if self.Content.IsLocked then
    --     local Avatar = GWorld:GetAvatar()
    --     ConditionUtils.CheckCondition(Avatar, self.UnlockCondition, true)
    --     return false
    -- end
    if self.Content.IsSelect then
        return false
    end
    if self.Obj and self.Func then
        self.Func(self.Obj, table.unpack(self.Params))
    end
    self.Content.IsSelect = true
    self:StopAllAnimations()
    if self.Content.IsLocked then
        self:PlayAnimation(self.Lock_Click)
    else
        self:PlayAnimation(self.Click)
    end
    return true
end

function WBP_TrueHardBoss_SideTab_C:OnCellHovered()
    if self.Content.IsSelect then
        return
    end
    self:StopAnimation(self.Normal)
    self:StopAnimation(self.Lock_Normal)
    if self.Content.IsLocked then
        self:PlayAnimation(self.Lock_Hover)
    else
        self:PlayAnimation(self.Hover)
    end
end

function WBP_TrueHardBoss_SideTab_C:OnCellUnhovered()
    if self.Content.IsSelect then
        return
    end
    self:StopAnimation(self.Hover)
    self:StopAnimation(self.Lock_Hover)
    if self.Content.IsLocked then
        self:PlayAnimation(self.Lock_UnHover)
    else
        self:PlayAnimation(self.UnHover)
    end
end

function WBP_TrueHardBoss_SideTab_C:OnCellPressed()
    if self.Content.IsSelect then
        return
    end
    self:StopAnimation(self.Hover)
    self:StopAnimation(self.Lock_Hover)
    if self.Content.IsLocked then
        self:PlayAnimation(self.Lock_Press)
    else
        self:PlayAnimation(self.Press)
    end
end

function WBP_TrueHardBoss_SideTab_C:OnCellReleased()
    if self.Content.IsSelect then
        return
    end
    self:StopAnimation(self.Press)
    self:StopAnimation(self.Lock_Press)
end

return WBP_TrueHardBoss_SideTab_C