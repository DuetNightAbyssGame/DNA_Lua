--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_Rouge_DifficultyListItem_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function WBP_Rouge_DifficultyListItem_C:Construct()
    self.Text_LvName:SetText(GText("UI_RL_LevelLimit"))
    self.IsSelect = false
    self.IsCantInteractable = false
    self.Hovered = false
    self:UnBindEventOnClicked()

    self.Btn_Click.OnClicked:Add(self, self.OnCellClicked)
    self.Btn_Click.OnHovered:Add(self, self.OnCellHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnCellUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnCellPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnCellReleased)
end

function WBP_Rouge_DifficultyListItem_C:Destruct()
    self:UnBindEventOnClicked()
end

function WBP_Rouge_DifficultyListItem_C:BindEventOnClicked(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = {...}
end

function WBP_Rouge_DifficultyListItem_C:UnBindEventOnClicked()
    self.Obj = nil
    self.Func = nil
    self.Params = nil
end

function WBP_Rouge_DifficultyListItem_C:ItemSetNavigationRuleCustom(Obj, Func)
    self:SetNavigationRuleCustom(EUINavigation.Up,{Obj,Func})
    self:SetNavigationRuleCustom(EUINavigation.Down,{Obj,Func})
end

function WBP_Rouge_DifficultyListItem_C:InitInfo(DifficultyId, Index, Unlock)
    self.DifficultyId = DifficultyId
    local RougeLikeDifficulty = DataMgr.RougeLikeDifficulty
    self.UnlockLevel = RougeLikeDifficulty[DifficultyId].RecommendLevel
    self.Title_Level:SetText(GText("RL_Difficulty_"..Index))
    self.Text_Lv:SetText(self.UnlockLevel)
    self:RefreshState(Unlock)
    if self.Unlock then
        self:PlayAnimation(self.Normal)
    else
        self:PlayAnimation(self.Forbidden)
    end
end

function WBP_Rouge_DifficultyListItem_C:UnSelected()
    self:StopAllAnimations()
    if self.Unlock then
        self:PlayAnimation(self.Normal)
    else
        self:PlayAnimation(self.Forbidden)
    end
    self.IsSelect = false
end

function WBP_Rouge_DifficultyListItem_C:Selected()
    self:StopAllAnimations()
    self:PlayAnimation(self.Select)
    self.IsSelect = true
end

function WBP_Rouge_DifficultyListItem_C:RefreshState(Unlock)
    local Avatar = GWorld:GetAvatar()
    if Unlock == nil then
        self.Unlock = false
        local UnlockCondition = DataMgr.RougeLikeDifficulty[self.DifficultyId].UnlockCondition
        if UnlockCondition then
            if Avatar then
                self.Unlock = Avatar:CheckCondition(UnlockCondition)
            end
        else
            self.Unlock = true
        end
    else
        self.Unlock = Unlock
    end
    self.IsCantInteractable = true
	if Avatar then
        if not Avatar:IsRougeLikeInProgress() then
            self.IsCantInteractable = false
        end
    end
    if self.Unlock then
        self.Image_Lock:SetVisibility(ESlateVisibility.Collapsed)
    else
		self.Image_Lock:SetVisibility(ESlateVisibility.Visible)
    end
end

function WBP_Rouge_DifficultyListItem_C:OnCellClicked()
    if self.IsSelect then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    -- local Avatar = GWorld:GetAvatar()
    -- if Avatar then
    --     if Avatar:IsRougeLikeInProgress() and Avatar.RougeLike.ProgressingDifficultyId == self.DifficultyId then
    --         self:PlayAnimation(self.Select)
    --     elseif not Avatar:IsRougeLikeInProgress() then
    --         self:PlayAnimation(self.Select)
    --     end
    -- end
    if self.Obj and self.Func then
        self.Func(self.Obj, table.unpack(self.Params))
    end
end

function WBP_Rouge_DifficultyListItem_C:OnCellClickedWithoutSound()
    if not ReddotManager.GetTreeNode("PaotaiEventNewLevel") then
        ReddotManager.AddNodeEx("PaotaiEventNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewLevel")
    if CacheDetail[self.Content.DungeonId] == 1 then
        CacheDetail[self.Content.DungeonId] = 0
        ReddotManager.DecreaseLeafNodeCount("PaotaiEventNewLevel")
    end

    if self.Content.IsSelect then
        return false
    end
    if self.Content.LockReason then
        if self.Content.LockReason == "PreDungeon" then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.PaotaiMiniGame[self.Content.DungeonId].LockToast))
        end
        return false
    else
        if self.Obj and self.Func then
            self.Func(self.Obj, table.unpack(self.Params))
        end
        self:StopAllAnimations()
        self:PlayAnimation(self.Click)
        return true
    end
end

function WBP_Rouge_DifficultyListItem_C:OnCellHovered()
    if self.IsSelect or self.IsCantInteractable then
        return
    end
    self.Hovered = true
    self:StopAnimation(self.Normal)
    self:StopAnimation(self.Forbidden)
    self:PlayAnimation(self.Hover)
end

function WBP_Rouge_DifficultyListItem_C:OnCellUnhovered()
    if self.IsSelect or self.IsCantInteractable then
        return
    end
    self.Hovered = false
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
end

function WBP_Rouge_DifficultyListItem_C:OnCellPressed()
    if self.IsSelect or self.IsCantInteractable then
        return
    end
    self:PlayAnimation(self.Press)
end

function WBP_Rouge_DifficultyListItem_C:OnCellReleased()
    if self.IsSelect or self.IsCantInteractable then
        return
    end
    self:StopAnimation(self.Press)
    if self.Hovered then
        self:PlayAnimation(self.Hover)
    else
        if self.Unlock then
            self:PlayAnimation(self.Normal)
        else
            self:PlayAnimation(self.Forbidden)
        end
    end
end

return WBP_Rouge_DifficultyListItem_C
