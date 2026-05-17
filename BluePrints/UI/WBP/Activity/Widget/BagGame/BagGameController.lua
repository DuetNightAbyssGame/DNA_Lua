local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"

---@class BagGameController:Controller
---@field private _View WBP_Activity_BagGameMain_P_C
local M = Class("BluePrints.Common.MVC.Controller")

--region Override
function M:Init()
    M.Super.Init(self)
    self.isProcessingCallback = false
end

function M:Destory()
    M.Super.Destory(self)
end

function M:GetEventName()
    return EventID.BagGameControllerEvent
end

function M:GetModel()
    return BagGameModel
end
--endregion

--region 界面控制
--- 打开游戏界面
---@param LevelId number 关卡ID
---@param LevelContent table 关卡内容数据
---@param Owner table 调用者
function M:OpenPlayUI(LevelId, LevelContent, Owner)
    local Params = {
        Owner = Owner,
        Content = LevelContent,
    }
    UIManager(Owner):LoadUINew("BagGamePlay", Params)
end

--- 获取 View
function M:GetView(WorldContex, UIName)
    return M.Super.GetView(self, WorldContex, UIName)
end
--endregion

--region 游戏逻辑
--- 开始游戏（初始化游戏状态）
---@param LevelId number 关卡ID
---@return boolean 是否成功
function M:StartGame(LevelId)
    return self:GetModel():InitGameState(LevelId)
end

--- 重置游戏
function M:ResetGame()
    local Model = self:GetModel()
    if Model.CurrentLevelId then
        Model:InitGameState(Model.CurrentLevelId)
    end
end

--region 完成游戏（提交分数）
---@param Callback function 回调函数
function M:FinishGame(Callback)
    local Model = self:GetModel()
    local LevelId = Model.CurrentLevelId
    local Score = Model:CalculateCurrentScore()
    
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local function Cb(ErrCode,Ret)
        DebugPrint("FinishGame",ErrorCode:Name(ErrCode))
        if ErrCode == ErrorCode.RET_SUCCESS then
            Callback(true)
        else
            Callback(false)
            local ErrorCodeData = DataMgr.ErrorCode[ErrCode]
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(ErrorCodeData.ErrorCodeContent))
        end
        -- self.Owner:BlockAllUIInput(false)
    end
    -- self.Owner:BlockAllUIInput(true)
    -- RPC提交分数
    Avatar:BackpackPuzzleFinishGame(LevelId, Score, Cb)
end

--- 检查是否可以放置物品
---@param BaseRow number 基准行
---@param BaseCol number 基准列
---@param ShapeCells table 形状格子坐标
---@return boolean 是否可放置
function M:CanPlaceItem(BaseRow, BaseCol, ShapeCells)
    return self:GetModel():CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
end

--- 放置物品
---@param PlacedRecord table 放置记录
---@return boolean 是否成功
function M:PlaceItem(PlacedRecord)
    local Model = self:GetModel()
    
    -- 标记格子为已占用
    if PlacedRecord.Cells then
        for _, Cell in ipairs(PlacedRecord.Cells) do
            Model:MarkCellOccupied(Cell.Row, Cell.Col, PlacedRecord.DisPlayItemId)
        end
    end
    
    -- 添加放置记录
    Model:AddPlacedItem(PlacedRecord)
    
    -- 设置为未确认物品
    Model:SetUnconfirmedItem(PlacedRecord.Widget)
    
    return true
end

--- 确认放置物品
---@param PlacedWidget table 放置的 Widget
---@return boolean 是否成功
function M:ConfirmPlacedItem(PlacedWidget)
    local Model = self:GetModel()
    
    if Model:GetUnconfirmedItem() ~= PlacedWidget then
        return false
    end
    
    Model:SetUnconfirmedItem(nil)
    return true
end

--- 回收物品
---@param PlacedWidget table 放置的 Widget
---@return table|nil 放置记录（用于恢复 DisPlayItem 状态）
function M:RecycleItem(PlacedWidget)
    local Model = self:GetModel()
    local PlacedRecord, RecordIndex = Model:FindPlacedItemByWidget(PlacedWidget)
    
    if not PlacedRecord then
        return nil
    end
    
    -- 清除格子占用
    if PlacedRecord.Cells then
        for _, Cell in ipairs(PlacedRecord.Cells) do
            Model:ClearCellOccupied(Cell.Row, Cell.Col)
        end
    end
    
    -- 移除记录
    Model:RemovePlacedItem(RecordIndex)
    
    -- 如果是未确认物品，清除状态
    if Model:GetUnconfirmedItem() == PlacedWidget then
        Model:SetUnconfirmedItem(nil)
    end
    
    return PlacedRecord
end

--- 拉起已放置的物品
---@param PlacedWidget table 放置的 Widget
---@return table|nil 放置记录
function M:PickUpPlacedItem(PlacedWidget)
    return self:RecycleItem(PlacedWidget)
end

--- 检查是否有未确认物品
---@return boolean
function M:HasUnconfirmedItem()
    return self:GetModel():HasUnconfirmedItem()
end

--- 计算当前分数
---@return number 当前分数
function M:CalculateScore()
    return self:GetModel():CalculateCurrentScore()
end
--endregion

--region 奖励领取
--- 打开奖励弹窗
---@param Widget table 调用者 Widget
---@param Type number|nil 默认选中的关卡ID
function M:OpenRewardPopup(Widget, Type)
    local Params = self:GetModel():BuildRewardParams(Type)
    
    -- 设置回调
    for LevelId, Data in pairs(Params.ConfigData.Datas) do
        Data.ReceiveAllCallBack = function(ReceiveAllParm)
            self:GetAllRewards(ReceiveAllParm)
        end
        Data.ReceiveAllParam = {RewardModel = self, Type = LevelId, SelfWidget = nil}
        
        for _, Item in ipairs(Data.Items) do
            Item.ReceiveCallBack = function(RewardItem, Content)
                self:GetReward(RewardItem, Content)
            end
            Item.ReceiveParm = {RewardModel = self}
        end
    end
    
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(100213, Params, Widget)
end

--- 领取单个奖励
---@param RewardItem table 奖励项 Widget
---@param Content table 奖励内容数据
function M:GetReward(RewardItem, Content)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    
    local Model = self:GetModel()
    local LevelId = Content.ConfigData.Type
    local RewardIndex = Content.ConfigData.Index
    
    local function Callback(ErrCode, Rewards)
        local FinishScore = Model:GetPlayerFinishScore(LevelId)
        local RewardsGot = Model:GetPlayerRewardsGot(LevelId)
        local TargetScore = Content.ConfigData.Score
        
        Content.ConfigData.CanReceive = false
        Content.ConfigData.RewardsGot = false
        
        if FinishScore < TargetScore then
            Content.ConfigData.InProgress = true
        else
            Content.ConfigData.InProgress = false
            local GotState = RewardsGot[RewardIndex]
            if GotState == 2 then
                Content.ConfigData.CanReceive = false
                Content.ConfigData.RewardsGot = true
            else
                Content.ConfigData.CanReceive = true
                Content.ConfigData.RewardsGot = false
            end
        end
        
        Content.SelfWidget:RefreshBtn(ErrCode == 0)
        Content.Owner:RefreshButton(Model:HasRewardToGet(LevelId))
        
        if not ErrorCode:Check(ErrCode) then
            return
        end
        
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
            RewardItem:SetFocus()
        end, RewardItem)
    end
    
    Avatar:BackpackPuzzleGetScoreReward(LevelId, RewardIndex, Callback)
end

--- 领取关卡全部奖励
---@param ReceiveAllParm table 参数
function M:GetAllRewards(ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    
    local Model = self:GetModel()
    local LevelId = ReceiveAllParm.Type
    
    local function Callback(ErrCode, Rewards)
        for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
            local Content = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
            local ItemLevelId = Content.ConfigData.Type
            local FinishScore = Model:GetPlayerFinishScore(ItemLevelId)
            local RewardsGot = Model:GetPlayerRewardsGot(ItemLevelId)
            local TargetScore = Content.ConfigData.Score
            local ItemIndex = Content.ConfigData.Index
            
            Content.ConfigData.CanReceive = false
            Content.ConfigData.RewardsGot = false
            
            if FinishScore < TargetScore then
                Content.ConfigData.InProgress = true
            else
                Content.ConfigData.InProgress = false
                local GotState = RewardsGot[ItemIndex]
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
        
        ReceiveAllParm.SelfWidget:RefreshButton(Model:HasRewardToGet(LevelId))
        
        if not ErrorCode:Check(ErrCode) then
            return
        end
        
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
            ReceiveAllParm.SelfWidget:SetFocus()
        end, ReceiveAllParm.SelfWidget)
    end
    
    Avatar:BackpackPuzzleGetAllScoreReward(LevelId, Callback)
end

--- 检查某关卡是否有可领取奖励
---@param LevelId number 关卡ID
---@return boolean
function M:CheckHaveRewardToGet(LevelId)
    return self:GetModel():HasRewardToGet(LevelId)
end
--endregion

--region 数据获取（代理 Model 方法，方便 View 调用）
--- 获取关卡列表
function M:GetLevelsInfo()
    return self:GetModel():GetLevelsInfo()
end

--- 获取关卡数量
function M:GetLevelCount()
    return self:GetModel():GetLevelCount()
end

--- 获取关卡数据
function M:GetLevelInfo(LevelId)
    return self:GetModel():GetLevelInfo(LevelId)
end

--- 获取玩家完成分数
function M:GetPlayerFinishScore(LevelId)
    return self:GetModel():GetPlayerFinishScore(LevelId)
end

--- 获取玩家星数
function M:GetPlayerStarCount(LevelId)
    return self:GetModel():GetPlayerStarCount(LevelId)
end

--- 获取关卡最高目标分数
function M:GetLevelMaxTargetScore(LevelId)
    return self:GetModel():GetLevelMaxTargetScore(LevelId)
end

--- 构建物品内容数据
function M:BuildItemContent(TemplateId)
    return self:GetModel():BuildItemContent(TemplateId)
end

--- 解析物品形状
function M:ParseItemGrid(ItemGrid)
    return self:GetModel():ParseItemGrid(ItemGrid)
end

--- 解析格子分布
function M:ParseGridDistribute(GridDistribute)
    return self:GetModel():ParseGridDistribute(GridDistribute)
end
--endregion

_G.BagGameController = M
return M
