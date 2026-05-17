--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_JJGame_ChallengeScoreItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

local ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.CacheKey = "ChallengeScoreItem"..self.Count
    self.Btn_Click.OnClicked:Add(self,self.OnClick)
    ReddotManager.AddListenerEx(ChallengeRewardReddotName, self, self.UpdateChallengeReddot)
end

function M:Destruct()
    self.Btn_Click.OnClicked:Clear()
    ReddotManager.RemoveListener(ChallengeRewardReddotName, self)
end

function M:Init(Params)
    self.Owner = Params.Owner
    self.Count = Params.Count
    self.Index = Params.Index
    self.RewardId = Params.RewardId
    self.CanGet = Params.CanGet
    self.IsReceived = Params.IsReceived
    self.CacheKey = Params.CacheKey
    self.Text_Score:SetText(Params.Count)
    self.MidTermConst = DataMgr.MidTermGoalConstant
    self.MidTermGoalEventId = self.MidTermConst["MidTermGoalEventId"].ConstantValue
    
end

--region 红点
function M:UpdateChallengeReddot(Count)
    self.Avatar = GWorld:GetAvatar()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
    if not CacheData then return end
    if CacheData[self.CacheKey] and Count > 0 then
        self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Reddot:SetVisibility(UIConst.VisibilityOp.Hidden)
    end
end
--endregion

function M:OnClick()
    if not self.CanGet then
        AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_gift_btn_click_disable", nil, nil)
        local Params = {
            Count = self.Count,
            Index = self.Index,
            ActivityId = self.MidTermGoalEventId,
            BackFocusWidget = self.Owner.List_Challenge,
            -- OnCloseCallbackFunction = function()
            -- end
        }
        UIManager(self):ShowCommonPopupUI(100101, Params, self)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_gift_btn_click", nil, nil)
        self.Owner:OnChallengeRewardGet(self)
    end
end

return M
