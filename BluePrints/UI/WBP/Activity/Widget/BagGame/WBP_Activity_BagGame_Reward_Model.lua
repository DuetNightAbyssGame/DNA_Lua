--[[
    奖励弹窗模型（兼容层）
    实际逻辑已移至 BagGameController，此文件保留以兼容现有调用
    建议后续直接使用 BagGameController:OpenRewardPopup(Widget, Type)
]]

local BagGameController = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameController"
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"

---@class ActivityBagGameRewardModel
local ActivityBagGameRewardModel = {}

-- 当前活动ID（代理到 Model）
ActivityBagGameRewardModel.CurEventId = DataMgr.BackpackPuzzleConstant and 
                                        DataMgr.BackpackPuzzleConstant.BagGameEventId and 
                                        DataMgr.BackpackPuzzleConstant.BagGameEventId.ConstantValue or 103015

--- 打开奖励弹窗
---@param Widget table 调用者 Widget
---@param Type number|nil 默认选中的关卡ID
function ActivityBagGameRewardModel:OpenReward(Widget, Type)
    self:SetRewardParams(Type)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(100213, self.Params, Widget)
end

--- 设置奖励弹窗参数
---@param Type number|nil 默认选中的关卡ID
function ActivityBagGameRewardModel:SetRewardParams(Type)
    -- 使用 Model 构建基础参数
    self.Params = BagGameModel:BuildRewardParams(Type)
    
    -- 设置回调函数（需要绑定到本模块以保持兼容）
    for LevelId, Data in pairs(self.Params.ConfigData.Datas) do
        Data.ReceiveAllCallBack = self.GetAllRewards
        Data.ReceiveAllParam = {RewardModel = self, Type = LevelId}
        
        for _, Item in ipairs(Data.Items) do
            Item.ReceiveCallBack = self.GetRewards
            Item.ReceiveParm = {RewardModel = self}
        end
    end
end

--- 领取单个奖励
---@param RewardItem table 奖励项 Widget
---@param Content table 奖励内容数据
function ActivityBagGameRewardModel.GetRewards(RewardItem, Content)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    
    local function Callback(ErrCode, Rewards)
        local BackpackPuzzleLevelInfo = Avatar.BackpackPuzzles and Avatar.BackpackPuzzles[Content.ConfigData.Type]
        local MaxScore = 0
        local RewardsGotInfo = nil
        if BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo.FinishScore then
            MaxScore = BackpackPuzzleLevelInfo.FinishScore
        end
        if BackpackPuzzleLevelInfo then
            RewardsGotInfo = BackpackPuzzleLevelInfo.ScoreRewardsGot
        end

        Content.ConfigData.CanReceive = false
        Content.ConfigData.RewardsGot = false
        if MaxScore < Content.ConfigData.Score then
            Content.ConfigData.InProgress = true
        else
            Content.ConfigData.InProgress = false
            local GotState = RewardsGotInfo and RewardsGotInfo[Content.ConfigData.Index]
            if GotState == 2 then
                Content.ConfigData.CanReceive = false
                Content.ConfigData.RewardsGot = true
            else
                Content.ConfigData.CanReceive = true
                Content.ConfigData.RewardsGot = false
            end
        end
        Content.SelfWidget:RefreshBtn(ErrCode == 0)
        Content.Owner:RefreshButton(Content.ConfigData.ReceiveParm.RewardModel:CheckHaveRewardToGet(Content.ConfigData.Type))
        
        if not ErrorCode:Check(ErrCode) then
            return
        end
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
            RewardItem:SetFocus()
        end, RewardItem)
    end
    
    Avatar:BackpackPuzzleGetScoreReward(Content.ConfigData.Type, Content.ConfigData.Index, Callback)
end

--- 检查某关卡是否有可领取奖励
---@param Type number 关卡ID
---@return boolean 是否有可领取奖励
function ActivityBagGameRewardModel:CheckHaveRewardToGet(Type)
    return BagGameModel:HasRewardToGet(Type)
end

--- 领取关卡全部奖励
---@param _PopupWidget table 弹窗Widget（由CommonPopupUI传入，未使用）
---@param ReceiveAllParm table 参数
function ActivityBagGameRewardModel.GetAllRewards(_PopupWidget, ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    
    local function Callback(ErrCode, Rewards)
        for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
            local Content = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
            local BackpackPuzzleLevelInfo = Avatar.BackpackPuzzles and Avatar.BackpackPuzzles[Content.ConfigData.Type]
            local MaxScore = 0
            local RewardsGotInfo = nil
            if BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo.FinishScore then
                MaxScore = BackpackPuzzleLevelInfo.FinishScore
            end
            if BackpackPuzzleLevelInfo then
                RewardsGotInfo = BackpackPuzzleLevelInfo.ScoreRewardsGot
            end
            Content.ConfigData.CanReceive = false
            Content.ConfigData.RewardsGot = false
            if MaxScore < Content.ConfigData.Score then
                Content.ConfigData.InProgress = true
            else
                Content.ConfigData.InProgress = false
                local GotState = RewardsGotInfo and RewardsGotInfo[Content.ConfigData.Index]
                if GotState == 2 then
                    Content.ConfigData.CanReceive = false
                    Content.ConfigData.RewardsGot = true
                else
                    Content.ConfigData.CanReceive = true
                    Content.ConfigData.RewardsGot = false
                end
            end
            if Content.SelfWidget then
                Content.SelfWidget:RefreshBtn(Content.ConfigData.RewardsGot)
            end
        end
        ReceiveAllParm.SelfWidget:RefreshButton(ReceiveAllParm.RewardModel:CheckHaveRewardToGet(ReceiveAllParm.Type))
        
        if not ErrorCode:Check(ErrCode) then
            return
        end
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
            ReceiveAllParm.SelfWidget:SetFocus()
        end, ReceiveAllParm.SelfWidget)
    end
    
    Avatar:BackpackPuzzleGetAllScoreReward(ReceiveAllParm.Type, Callback)
end

return ActivityBagGameRewardModel
