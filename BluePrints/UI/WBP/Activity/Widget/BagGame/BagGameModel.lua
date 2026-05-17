local EMCache = require "EMCache.EMCache"

---@class BagGameModel:Model
local M = Class("BluePrints.Common.MVC.Model")
-- 格子常量
M.GRID_ROWS = 8   -- 行数
M.GRID_COLS = 10  -- 列数

-- 格子值常量
M.VALUE_UNCLICKABLE = 0     -- 不可点击
M.VALUE_SINGLE_REWARD = 1   -- 单倍奖励
M.VALUE_DOUBLE_REWARD = 2   -- 双倍奖励
M.VALUE_BLOCKED = -1        -- 不可用

-- 物品类型常量（与配表 PuzzleItemAttr.ItemType 对应）
M.ItemType = {
    Gun = "Gun",      -- 枪械
    Ammo = "Ammo",    -- 弹药
    Other = "Other",  -- 其他道具
}

--- 清理导表字符串中的换行标记，避免解析异常
---@param GridDistribute any
---@return any
local function SanitizeGridDistribute(GridDistribute)
    if type(GridDistribute) ~= "string" then
        return GridDistribute
    end

    local CleanValue = GridDistribute
    CleanValue = string.gsub(CleanValue, "\\n", "")
    CleanValue = string.gsub(CleanValue, "/n", "")
    CleanValue = string.gsub(CleanValue, "\r", "")
    CleanValue = string.gsub(CleanValue, "\n", "")
    return CleanValue
end


function M:Init()
    M.Super.Init(self)
    

    -- 当前活动ID
    self.CurEventId = DataMgr.BackpackPuzzleConstant and 
                      DataMgr.BackpackPuzzleConstant.BagGameEventId and 
                      DataMgr.BackpackPuzzleConstant.BagGameEventId.ConstantValue or 103015
    
    -- 关卡数据缓存
    self.LevelsInfo = nil
    
    -- 当前游戏状态
    self.CurrentLevelId = nil       -- 当前关卡ID
    self.CurrentScore = 0           -- 当前得分
    self.GridMatrix = nil           -- 格子矩阵
    self.OccupiedMatrix = nil       -- 占用矩阵
    self.PlacedItems = {}           -- 已放置物品记录
    self.CurrentUnconfirmedItem = nil -- 当前未确认物品
    
    -- 初始化关卡数据
    self:InitLevelsInfo()
end

function M:Destory()
    self:ClearGameState()
    M.Super.Destory(self)
end

--region 关卡数据
--- 初始化关卡信息（从配表读取）
function M:InitLevelsInfo()
    self.LevelsInfo = {}
    local BackpackPuzzleLevel = DataMgr.BackpackPuzzleLevel
    if not BackpackPuzzleLevel then return end
    local BackpackPuzzleLevelInfo = CommonUtils.CopyTable(BackpackPuzzleLevel)
    for _, Info in pairs(BackpackPuzzleLevelInfo) do
        Info.GridDistribute = SanitizeGridDistribute(Info.GridDistribute)
        table.insert(self.LevelsInfo, Info)
    end
    table.sort(self.LevelsInfo, function(A, B)
        return A.LevelId < B.LevelId
    end)
end

--- 获取所有关卡列表
---@return table 关卡列表
function M:GetLevelsInfo()
    -- if not self.LevelsInfo then
    -- end
    self:InitLevelsInfo()
    return self.LevelsInfo
end

--- 获取关卡数量
---@return number 关卡数量
function M:GetLevelCount()
    return self.LevelsInfo and #self.LevelsInfo or 0
end

--- 根据关卡ID获取关卡数据
---@param LevelId number 关卡ID
---@return table|nil 关卡数据
function M:GetLevelInfo(LevelId)
    local BackpackPuzzleLevelInfo = DataMgr.BackpackPuzzleLevel
    return BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo[LevelId]
end

--- 获取关卡的目标分数列表
---@param LevelId number 关卡ID
---@return table 目标分数数组
function M:GetLevelTargetScores(LevelId)
    local LevelInfo = self:GetLevelInfo(LevelId)
    return LevelInfo and LevelInfo.TargetScore or {}
end

--- 获取关卡的最高目标分数
---@param LevelId number 关卡ID
---@return number 最高目标分数
function M:GetLevelMaxTargetScore(LevelId)
    local TargetScores = self:GetLevelTargetScores(LevelId)
    local MaxScore = 0
    for _, Score in ipairs(TargetScores) do
        if Score > MaxScore then
            MaxScore = Score
        end
    end
    return MaxScore
end
--endregion

--region 玩家进度数据
--- 获取玩家某关卡的完成分数
---@param LevelId number 关卡ID
---@return number 完成分数
function M:GetPlayerFinishScore(LevelId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.BackpackPuzzles then
        return 0
    end
    -- local BackpackPuzzleEventInfo = Avatar.BackpackPuzzles[self.CurEventId]
    -- if not BackpackPuzzleEventInfo then return 0 end
    
    local LevelInfo = Avatar.BackpackPuzzles[LevelId]
    return LevelInfo and LevelInfo.FinishScore or 0
end

--- 获取玩家某关卡的已领取奖励信息
---@param LevelId number 关卡ID
---@return table 已领取奖励字典 {[Score] = true}
function M:GetPlayerRewardsGot(LevelId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.BackpackPuzzles then
        return {}
    end
    -- local BackpackPuzzleEventInfo = Avatar.BackpackPuzzles[self.CurEventId]
    -- if not BackpackPuzzleEventInfo then return {} end
    
    local LevelInfo = Avatar.BackpackPuzzles[LevelId]
    return LevelInfo and LevelInfo.ScoreRewardsGot or {}
end

--- 计算玩家某关卡的星数
---@param LevelId number 关卡ID
---@return number 星数
function M:GetPlayerStarCount(LevelId)
    local FinishScore = self:GetPlayerFinishScore(LevelId)
    local TargetScores = self:GetLevelTargetScores(LevelId)
    
    local StarCount = 0
    for _, TargetScore in ipairs(TargetScores) do
        if FinishScore >= TargetScore then
            StarCount = StarCount + 1
        end
    end
    return StarCount
end

--- 检查某关卡某积分段是否可以领取奖励
---@param LevelId number 关卡ID
---@param ScoreIndex number 积分段索引（1-based）
---@return boolean 是否可领取
function M:CanReceiveReward(LevelId, ScoreIndex)
    local FinishScore = self:GetPlayerFinishScore(LevelId)
    local TargetScores = self:GetLevelTargetScores(LevelId)
    local RewardsGot = self:GetPlayerRewardsGot(LevelId)
    
    if not TargetScores[ScoreIndex] then
        return false
    end
    
    local TargetScore = TargetScores[ScoreIndex]
    -- 已达成目标 且 未领取（ScoreRewardsGot 按自然索引，值2=已领取）
    return FinishScore >= TargetScore and RewardsGot[ScoreIndex] ~= 2
end

--- 检查某关卡是否有可领取的奖励
---@param LevelId number 关卡ID
---@return boolean 是否有可领取奖励
function M:HasRewardToGet(LevelId)
    local FinishScore = self:GetPlayerFinishScore(LevelId)
    local TargetScores = self:GetLevelTargetScores(LevelId)
    local RewardsGot = self:GetPlayerRewardsGot(LevelId)
    
    for i, TargetScore in ipairs(TargetScores) do
        if FinishScore >= TargetScore and RewardsGot[i] ~= 2 then
            return true
        end
    end
    return false
end
--endregion

--region 物品数据
--- 获取物品模板数据（PuzzleItemTemplate）
---@param TemplateId number 模板ID
---@return table|nil 模板数据
function M:GetItemTemplate(TemplateId)
    return DataMgr.PuzzleItemTemplate and DataMgr.PuzzleItemTemplate[TemplateId]
end

--- 获取物品基础属性（PuzzleItemAttr）
---@param ItemId number 物品ID
---@return table|nil 属性数据
function M:GetItemAttr(ItemId)
    return DataMgr.PuzzleItemAttr and DataMgr.PuzzleItemAttr[ItemId]
end

--- 构建完整的物品内容数据
---@param TemplateId number 模板ID（不要传入 DisPlayItemId）
---@return table 物品内容数据
function M:BuildItemContent(TemplateId)
    local TemplateData = self:GetItemTemplate(TemplateId)
    local ItemId = TemplateData and TemplateData.ItemId or TemplateId
    local AttrData = self:GetItemAttr(ItemId)
    
    return {
        -- 模板数据 (PuzzleItemTemplate)
        TemplateId = TemplateId,
        ItemId = ItemId,
        CurrentAmmo = TemplateData and TemplateData.CurrentAmmo or 0,
        CurrentStack = TemplateData and TemplateData.CurrentStack or 0,
        
        -- 物品基础属性 (PuzzleItemAttr)
        ItemType = AttrData and AttrData.ItemType or "Other",
        ItemName = AttrData and AttrData.ItemName or ("Item_" .. ItemId),
        ItemGrid = AttrData and AttrData.ItemGrid or "[1]",
        BasicPoint = AttrData and AttrData.BasicPoint or 0,
        GUIPath = AttrData and AttrData.GUIPath or "",
        MaxAmmo = AttrData and AttrData.MaxAmmo or 0,
        MaxStack = AttrData and AttrData.MaxStack or 0,
    }
end

--- 解析 ItemGrid 字符串为 ShapeOffsets 坐标数组
---@param ItemGrid string 配表中的格子形状字符串
---@return table ShapeOffsets 坐标偏移数组 {{Row, Col}, ...}
function M:ParseItemGrid(ItemGrid)
    local Offsets = {}
    
    if not ItemGrid or ItemGrid == "" then
        return {{0, 0}}
    end
    
    local Row = 0
    for RowStr in string.gmatch(ItemGrid, "%[([^%]]+)%]") do
        local Col = 0
        for Value in string.gmatch(RowStr, "(%d+)") do
            if tonumber(Value) == 1 then
                table.insert(Offsets, {Row, Col})
            end
            Col = Col + 1
        end
        Row = Row + 1
    end
    
    if #Offsets == 0 then
        return {{0, 0}}
    end
    
    return Offsets
end
--endregion

--region 格子矩阵数据
--- 创建初始矩阵数据
---@return table 矩阵数据 Matrix[Row][Col] = Value
function M:CreateGridMatrix()
    local Matrix = {}
    for Row = 1, M.GRID_ROWS do
        Matrix[Row] = {}
        for Col = 1, M.GRID_COLS do
            Matrix[Row][Col] = 0
        end
    end
    return Matrix
end

--- 解析 GridDistribute 字符串为矩阵
---@param GridDistribute string 格子分布字符串
---@return table 矩阵数据
function M:ParseGridDistribute(GridDistribute)
    local Matrix = self:CreateGridMatrix()
    GridDistribute = SanitizeGridDistribute(GridDistribute)
    
    if not GridDistribute or GridDistribute == "" then
        return Matrix
    end
    
    local Row = 1
    for RowStr in string.gmatch(GridDistribute, "%[([^%]]+)%]") do
        if Row > M.GRID_ROWS then break end
        
        local Col = 1
        for Value in string.gmatch(RowStr, "([%-]?%d+)") do
            if Col > M.GRID_COLS then break end
            Matrix[Row][Col] = tonumber(Value) or 0
            Col = Col + 1
        end
        Row = Row + 1
    end
    
    return Matrix
end

--- 获取格子值
---@param Row number 行 (1-8)
---@param Col number 列 (1-10)
---@return number|nil 格子值
function M:GetGridValue(Row, Col)
    if not self.GridMatrix then return nil end
    if Row < 1 or Row > M.GRID_ROWS or Col < 1 or Col > M.GRID_COLS then
        return nil
    end
    return self.GridMatrix[Row][Col]
end

--- 设置格子值
---@param Row number 行 (1-8)
---@param Col number 列 (1-10)
---@param Value number 格子值
function M:SetGridValue(Row, Col, Value)
    if not self.GridMatrix then return end
    if Row < 1 or Row > M.GRID_ROWS or Col < 1 or Col > M.GRID_COLS then
        return
    end
    self.GridMatrix[Row][Col] = Value
end

--- 检查格子是否被占用
---@param Row number 行
---@param Col number 列
---@return boolean 是否被占用
function M:IsCellOccupied(Row, Col)
    if not self.OccupiedMatrix then return false end
    if not self.OccupiedMatrix[Row] then return false end
    return self.OccupiedMatrix[Row][Col] ~= nil
end

--- 标记格子为已占用
---@param Row number 行
---@param Col number 列
---@param PlacedItemId any 占用该格子的物品ID
function M:MarkCellOccupied(Row, Col, PlacedItemId)
    if Row < 1 or Row > M.GRID_ROWS or Col < 1 or Col > M.GRID_COLS then
        return
    end
    if not self.OccupiedMatrix then
        self.OccupiedMatrix = {}
        for r = 1, M.GRID_ROWS do
            self.OccupiedMatrix[r] = {}
        end
    end
    self.OccupiedMatrix[Row][Col] = PlacedItemId
end

--- 清除格子的占用状态
---@param Row number 行
---@param Col number 列
function M:ClearCellOccupied(Row, Col)
    if self.OccupiedMatrix and self.OccupiedMatrix[Row] then
        self.OccupiedMatrix[Row][Col] = nil
    end
end

--- 检查形状在指定位置是否可以放置
--- 允许部分格子超出边界或落在非得分区；仅阻止不可用(VALUE_BLOCKED)和已占用的格子
---@param BaseRow number 基准行
---@param BaseCol number 基准列
---@param ShapeCells table 形状格子坐标数组
---@return boolean 是否可以放置
function M:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
    for _, Cell in ipairs(ShapeCells) do
        local Row, Col = Cell.Row, Cell.Col
        -- 超出边界的格子跳过（允许临时超出，由确认按钮拦截）
        if Row >= 1 and Row <= M.GRID_ROWS and Col >= 1 and Col <= M.GRID_COLS then
            local Value = self:GetGridValue(Row, Col)
            if Value == nil or Value == M.VALUE_BLOCKED then
                return false
            end
            if self:IsCellOccupied(Row, Col) then
                return false
            end
        end
    end
    return true
end
--endregion

--region 游戏状态管理
--- 初始化游戏状态
---@param LevelId number 关卡ID
function M:InitGameState(LevelId)
    local LevelInfo = self:GetLevelInfo(LevelId)
    if not LevelInfo then
        DebugPrint("BagGameModel:InitGameState - 未找到关卡数据:", LevelId)
        return false
    end
    
    self.CurrentLevelId = LevelId
    self.CurrentScore = 0
    self.GridMatrix = self:ParseGridDistribute(LevelInfo.GridDistribute)
    self.OccupiedMatrix = {}
    for r = 1, M.GRID_ROWS do
        self.OccupiedMatrix[r] = {}
    end
    self.PlacedItems = {}
    self.CurrentUnconfirmedItem = nil
    
    return true
end

--- 清除游戏状态
function M:ClearGameState()
    self.CurrentLevelId = nil
    self.CurrentScore = 0
    self.GridMatrix = nil
    self.OccupiedMatrix = nil
    self.PlacedItems = {}
    self.CurrentUnconfirmedItem = nil
end

--- 添加放置记录
---@param PlacedRecord table 放置记录
function M:AddPlacedItem(PlacedRecord)
    table.insert(self.PlacedItems, PlacedRecord)
end

--- 移除放置记录
---@param RecordIndex number 记录索引
function M:RemovePlacedItem(RecordIndex)
    if RecordIndex and self.PlacedItems[RecordIndex] then
        table.remove(self.PlacedItems, RecordIndex)
    end
end

--- 根据 Widget 查找放置记录
---@param Widget table 放置的 Widget
---@return table|nil, number|nil 放置记录和索引
function M:FindPlacedItemByWidget(Widget)
    for i, Record in ipairs(self.PlacedItems) do
        if Record.Widget == Widget then
            return Record, i
        end
    end
    return nil, nil
end

--- 获取所有放置记录
---@return table 放置记录列表
function M:GetPlacedItems()
    return self.PlacedItems
end

--- 设置当前未确认物品
---@param ItemWidget table|nil
function M:SetUnconfirmedItem(ItemWidget)
    self.CurrentUnconfirmedItem = ItemWidget
end

--- 获取当前未确认物品
---@return table|nil
function M:GetUnconfirmedItem()
    return self.CurrentUnconfirmedItem
end

--- 检查是否有未确认物品
---@return boolean
function M:HasUnconfirmedItem()
    return self.CurrentUnconfirmedItem ~= nil
end

--- 获取弹药的基础分（用于枪械装弹加分计算）
--- 从配表读取默认弹药(ItemId=201)的基础分
---@return number 弹药基础分
function M:GetAmmoBasePoint()
    -- 遍历配表找到 Ammo 类型物品的基础分
    if DataMgr.PuzzleItemAttr then
        for _, AttrData in pairs(DataMgr.PuzzleItemAttr) do
            if AttrData.ItemType == M.ItemType.Ammo then
                return AttrData.BasicPoint or 10
            end
        end
    end
    return 10  -- 默认值
end

--- 计算单个物品的基础得分（不含倍率）
--- 规则：
---   - Other类型：基础分 × 堆叠数量
---   - Gun类型：基础分 + 装弹数 × 弹药基础分
---   - Ammo类型：基础分 × 堆叠数量
---@param PlacedRecord table 放置记录
---@return number 基础得分
function M:CalculateItemBaseScore(PlacedRecord)
    if not PlacedRecord then
        return 0
    end
    
    local BasicPoint = PlacedRecord.BasicPoint or 0
    local ItemType = PlacedRecord.ItemType
    
    if ItemType == M.ItemType.Gun then
        -- 枪械：基础分 + 装弹数 × 弹药基础分
        local AmmoBasePoint = self:GetAmmoBasePoint()
        local CurrentAmmo = PlacedRecord.CurrentAmmo or 0
        local Score = BasicPoint + CurrentAmmo * AmmoBasePoint
        DebugPrint(string.format("Gun得分计算: 基础分=%d + 装弹数=%d × 弹药分=%d = %d", 
            BasicPoint, CurrentAmmo, AmmoBasePoint, Score))
        return Score
    elseif ItemType == M.ItemType.Other then
        -- Other道具：基础分 × 堆叠数量
        local CurrentStack = PlacedRecord.CurrentStack or 1
        local Score = BasicPoint * CurrentStack
        DebugPrint(string.format("Other得分计算: 基础分=%d × 堆叠数=%d = %d", 
            BasicPoint, CurrentStack, Score))
        return Score
    elseif ItemType == M.ItemType.Ammo then
        -- Ammo弹药：基础分 × 堆叠数量（单独放置时）
        local CurrentStack = PlacedRecord.CurrentStack or 1
        local Score = BasicPoint * CurrentStack
        DebugPrint(string.format("Ammo得分计算: 基础分=%d × 堆叠数=%d = %d", 
            BasicPoint, CurrentStack, Score))
        return Score
    else
        -- 其他类型：默认使用基础分
        return BasicPoint
    end
end

--- 检查物品是否可以得分（所有格子都在可得分格或额外得分格上）
--- 规则：只有所有格子都在 VALUE_SINGLE_REWARD(1) 或 VALUE_DOUBLE_REWARD(2) 上才计分
---@param PlacedRecord table 放置记录
---@return boolean 是否可以得分
function M:CanItemScore(PlacedRecord)
    if not PlacedRecord or not PlacedRecord.Cells then
        return false
    end
    
    for _, Cell in ipairs(PlacedRecord.Cells) do
        local Value = self:GetGridValue(Cell.Row, Cell.Col)
        -- VALUE_UNCLICKABLE(0)=不可得分格, VALUE_BLOCKED(-1)=不可用
        -- 只有 VALUE_SINGLE_REWARD(1) 和 VALUE_DOUBLE_REWARD(2) 才能得分
        if not Value or Value == M.VALUE_UNCLICKABLE or Value == M.VALUE_BLOCKED then
            DebugPrint(string.format("物品不可得分: 格子(%d,%d)值=%s", 
                Cell.Row, Cell.Col, tostring(Value)))
            return false
        end
    end
    return true
end

--- 检查所有已放置物品是否都在可得分区域
---@return boolean 是否全部在得分格上
function M:AreAllPlacedItemsScoring()
    if not self.PlacedItems then return true end
    for _, Record in ipairs(self.PlacedItems) do
        if not self:CanItemScore(Record) then
            return false
        end
    end
    return true
end

--- 检查物品是否全部在额外得分格上（用于双倍计算）
--- 规则：只有所有格子都在 VALUE_DOUBLE_REWARD(2) 上才能双倍
---@param PlacedRecord table 放置记录
---@return boolean 是否全部在额外得分格
function M:IsItemAllOnDoubleReward(PlacedRecord)
    if not PlacedRecord or not PlacedRecord.Cells then
        return false
    end
    
    for _, Cell in ipairs(PlacedRecord.Cells) do
        local Value = self:GetGridValue(Cell.Row, Cell.Col)
        if Value ~= M.VALUE_DOUBLE_REWARD then
            return false
        end
    end
    return true
end

--- 计算当前放置物品的总分
--- 得分规则：
---   1. 只有所有格子都在可得分格(1)或额外得分格(2)上的物品才计分
---   2. 全在额外得分格(2)上的物品得分翻倍
---   3. 最终得分 = 全在额外得分格的物品得分之和×2 + 其余物品得分之和
---@return number 总分, number 双倍得分, number 普通得分
function M:CalculateCurrentScore()
    local DoubleRewardScore = 0  -- 全在额外得分格的物品得分之和
    local NormalRewardScore = 0  -- 其余普通可得分格的物品得分之和
    
    for _, Record in ipairs(self.PlacedItems) do
        -- 检查物品是否可以得分
        if self:CanItemScore(Record) then
            local ItemScore = self:CalculateItemBaseScore(Record)
            
            -- 检查是否全在额外得分格（用于双倍）
            if self:IsItemAllOnDoubleReward(Record) then
                DoubleRewardScore = DoubleRewardScore + ItemScore
                DebugPrint(string.format("物品 %s 全在额外得分格，基础分=%d（将×2）", 
                    tostring(Record.DisPlayItemId), ItemScore))
            else
                NormalRewardScore = NormalRewardScore + ItemScore
                DebugPrint(string.format("物品 %s 在普通得分格，基础分=%d", 
                    tostring(Record.DisPlayItemId), ItemScore))
            end
        else
            DebugPrint(string.format("物品 %s 不可得分（有格子在不可得分区域）", 
                tostring(Record.DisPlayItemId)))
        end
    end
    
    -- 最终得分 = 全在额外得分格的物品得分之和 × 2 + 其余普通可得分格的物品得分之和
    local TotalScore = DoubleRewardScore * 2 + NormalRewardScore
    self.CurrentScore = TotalScore
    
    DebugPrint(string.format("得分计算完成: 双倍区得分=%d×2=%d, 普通区得分=%d, 总分=%d", 
        DoubleRewardScore, DoubleRewardScore * 2, NormalRewardScore, TotalScore))
    
    return TotalScore, DoubleRewardScore, NormalRewardScore
end
--endregion

--region 子弹装配逻辑
--- 检查拖拽物品是否为子弹类型
---@param TemplateId number 物品模板ID
---@return boolean 是否为子弹类型
function M:IsAmmoItem(TemplateId)
    local Content = self:BuildItemContent(TemplateId)
    return Content and Content.ItemType == M.ItemType.Ammo
end

--- 检查放置物品是否为武器类型
---@param PlacedRecord table 放置记录
---@return boolean 是否为武器类型
function M:IsGunItem(PlacedRecord)
    if not PlacedRecord or not PlacedRecord.TemplateId then
        return false
    end
    local Content = self:BuildItemContent(PlacedRecord.TemplateId)
    return Content and Content.ItemType == M.ItemType.Gun
end

--- 获取放置物品的详细信息
---@param PlacedRecord table 放置记录
---@return table|nil 物品详细信息
function M:GetPlacedItemContent(PlacedRecord)
    if not PlacedRecord or not PlacedRecord.TemplateId then
        return nil
    end
    return self:BuildItemContent(PlacedRecord.TemplateId)
end

--- 检查两组格子是否有重叠
---@param Cells1 table 格子坐标数组 {{Row=r, Col=c}, ...}
---@param Cells2 table 格子坐标数组 {{Row=r, Col=c}, ...}
---@return boolean 是否有重叠
function M:CheckCellsOverlap(Cells1, Cells2)
    if not Cells1 or not Cells2 then
        return false
    end
    
    for _, Cell1 in ipairs(Cells1) do
        for _, Cell2 in ipairs(Cells2) do
            if Cell1.Row == Cell2.Row and Cell1.Col == Cell2.Col then
                return true
            end
        end
    end
    return false
end

--- 查找与子弹重叠的武器
---@param AmmoShapeCells table 子弹形状格子坐标数组
---@return table|nil 重叠的武器放置记录, boolean 是否可以装配
function M:FindOverlappingGun(AmmoShapeCells)
    if not AmmoShapeCells or #AmmoShapeCells == 0 then
        return nil, false
    end
    
    for _, Record in ipairs(self.PlacedItems) do
        if self:IsGunItem(Record) and Record.Cells then
            if self:CheckCellsOverlap(AmmoShapeCells, Record.Cells) then
                -- 找到重叠的武器，检查是否可以装配
                local GunContent = self:GetPlacedItemContent(Record)
                if GunContent then
                    local CurrentAmmo = Record.CurrentAmmo or GunContent.CurrentAmmo or 0
                    local MaxAmmo = GunContent.MaxAmmo or 0
                    local bCanLoad = CurrentAmmo < MaxAmmo
                    return Record, bCanLoad
                end
            end
        end
    end
    
    return nil, false
end

--- 计算装配结果
---@param GunRecord table 武器放置记录
---@param AmmoTemplateId number 子弹模板ID
---@return number 装配数量, number 剩余数量, boolean 是否成功
function M:CalculateLoadResult(GunRecord, AmmoTemplateId)
    if not GunRecord then
        return 0, 0, false
    end

    local GunContent = self:GetPlacedItemContent(GunRecord)
    local AmmoContent = self:BuildItemContent(AmmoTemplateId)
    
    if not GunContent or not AmmoContent then
        return 0, 0, false
    end
    
    local CurrentAmmo = GunRecord.CurrentAmmo or GunContent.CurrentAmmo or 0
    local MaxAmmo = GunContent.MaxAmmo or 0
    local AvailableAmmo = AmmoContent.CurrentStack or 0
    
    -- 计算可装配数量
    local CanLoad = MaxAmmo - CurrentAmmo
    local ActualLoad = math.min(CanLoad, AvailableAmmo)
    local Remaining = AvailableAmmo - ActualLoad
    
    return ActualLoad, Remaining, ActualLoad > 0
end

--- 执行装配操作（更新数据）
---@param GunRecord table 武器放置记录
---@param LoadAmount number 装配数量
---@return boolean 是否成功
function M:ExecuteLoadAmmo(GunRecord, LoadAmount)
    if not GunRecord or LoadAmount <= 0 then
        return false
    end
    
    local GunContent = self:GetPlacedItemContent(GunRecord)
    if not GunContent then
        return false
    end
    
    local CurrentAmmo = GunRecord.CurrentAmmo or GunContent.CurrentAmmo or 0
    GunRecord.CurrentAmmo = CurrentAmmo + LoadAmount
    
    DebugPrint("ExecuteLoadAmmo: 武器装配完成，当前弹药=" .. GunRecord.CurrentAmmo)
    return true
end

--- 检查武器弹药是否已满
---@param GunRecord table 武器放置记录
---@return boolean 是否已满
function M:IsGunAmmoFull(GunRecord)
    if not GunRecord then
        return false
    end
    
    local GunContent = self:GetPlacedItemContent(GunRecord)
    if not GunContent then
        return false
    end
    
    local CurrentAmmo = GunRecord.CurrentAmmo or GunContent.CurrentAmmo or 0
    local MaxAmmo = GunContent.MaxAmmo or 0
    
    return CurrentAmmo >= MaxAmmo
end
--endregion

--region Other 类型物品堆叠逻辑
--- 检查拖拽物品是否为 Other 类型（可堆叠）
---@param TemplateId number 物品模板ID
---@return boolean 是否为 Other 类型
function M:IsOtherItem(TemplateId)
    local Content = self:BuildItemContent(TemplateId)
    return Content and Content.ItemType == M.ItemType.Other
end

--- 检查放置物品是否为 Other 类型
---@param PlacedRecord table 放置记录
---@return boolean 是否为 Other 类型
function M:IsPlacedOtherItem(PlacedRecord)
    if not PlacedRecord or not PlacedRecord.TemplateId then
        return false
    end
    local Content = self:BuildItemContent(PlacedRecord.TemplateId)
    return Content and Content.ItemType == M.ItemType.Other
end

--- 检查两个物品是否为相同物品（可以堆叠）
---@param TemplateId1 number 物品模板ID 1
---@param TemplateId2 number 物品模板ID 2
---@return boolean 是否相同物品
function M:IsSameItem(TemplateId1, TemplateId2)
    local Content1 = self:BuildItemContent(TemplateId1)
    local Content2 = self:BuildItemContent(TemplateId2)
    
    if not Content1 or not Content2 then
        return false
    end
    
    -- 使用 ItemId 判断是否为相同物品
    return Content1.ItemId == Content2.ItemId
end

--- 查找与当前物品重叠的相同 Other 类型物品
---@param DragTemplateId number 拖拽物品的模板ID
---@param DragShapeCells table 拖拽物品的形状格子坐标数组
---@return table|nil 重叠的放置记录, boolean 是否可以堆叠
function M:FindOverlappingSameOther(DragTemplateId, DragShapeCells)
    if not DragShapeCells or #DragShapeCells == 0 then
        return nil, false
    end

    -- 检查拖拽物品是否为 Other 类型
    if not self:IsOtherItem(DragTemplateId) then
        return nil, false
    end

    for _, Record in ipairs(self.PlacedItems) do
        -- 必须是 Other 类型且是相同物品（按 TemplateId 比较）
        if self:IsPlacedOtherItem(Record) and self:IsSameItem(DragTemplateId, Record.TemplateId) then
            if Record.Cells and self:CheckCellsOverlap(DragShapeCells, Record.Cells) then
                -- 找到重叠的相同物品，检查是否可以堆叠
                local OtherContent = self:GetPlacedItemContent(Record)
                if OtherContent then
                    local CurrentStack = Record.CurrentStack or OtherContent.CurrentStack or 0
                    local MaxStack = OtherContent.MaxStack or 0
                    local bCanStack = CurrentStack < MaxStack
                    return Record, bCanStack
                end
            end
        end
    end
    
    return nil, false
end

--- 查找与拖拽物品形状格子有重叠的任意已放置物品记录
--- 用于检测"类型冲突"：拖拽物品与已放置物品有格子重叠，
--- 但不满足 Ammo+Gun 装配或 Other+同类Other 堆叠条件。
---@param DragShapeCells table 拖拽物品的形状格子坐标数组 {{Row=r, Col=c}, ...}
---@return table|nil 重叠的放置记录（第一个匹配到的）
function M:FindOverlappingPlacedItem(DragShapeCells)
    if not DragShapeCells or #DragShapeCells == 0 then
        return nil
    end

    for _, Record in ipairs(self.PlacedItems) do
        if Record.Cells and self:CheckCellsOverlap(DragShapeCells, Record.Cells) then
            return Record
        end
    end

    return nil
end

--- 计算堆叠结果
---@param TargetRecord table 目标放置记录（已放置的物品）
---@param SourceTemplateId number 源物品模板ID（拖拽的物品）
---@return number 堆叠数量, number 剩余数量, boolean 是否成功
function M:CalculateStackResult(TargetRecord, SourceTemplateId)
    if not TargetRecord then
        return 0, 0, false
    end

    local TargetContent = self:GetPlacedItemContent(TargetRecord)
    local SourceContent = self:BuildItemContent(SourceTemplateId)
    
    if not TargetContent or not SourceContent then
        return 0, 0, false
    end
    
    local CurrentStack = TargetRecord.CurrentStack or TargetContent.CurrentStack or 0
    local MaxStack = TargetContent.MaxStack or 0
    local AvailableStack = SourceContent.CurrentStack or 0
    
    -- 计算可堆叠数量
    local CanStack = MaxStack - CurrentStack
    local ActualStack = math.min(CanStack, AvailableStack)
    local Remaining = AvailableStack - ActualStack
    
    return ActualStack, Remaining, ActualStack > 0
end

--- 执行堆叠操作（更新数据）
---@param TargetRecord table 目标放置记录
---@param StackAmount number 堆叠数量
---@return boolean 是否成功
function M:ExecuteStack(TargetRecord, StackAmount)
    if not TargetRecord or StackAmount <= 0 then
        return false
    end
    
    local TargetContent = self:GetPlacedItemContent(TargetRecord)
    if not TargetContent then
        return false
    end
    
    local CurrentStack = TargetRecord.CurrentStack or TargetContent.CurrentStack or 0
    TargetRecord.CurrentStack = CurrentStack + StackAmount
    
    DebugPrint("ExecuteStack: 物品堆叠完成，当前堆叠数=" .. TargetRecord.CurrentStack)
    return true
end

--- 检查 Other 物品堆叠是否已满
---@param OtherRecord table 物品放置记录
---@return boolean 是否已满
function M:IsOtherStackFull(OtherRecord)
    if not OtherRecord then
        return false
    end
    
    local OtherContent = self:GetPlacedItemContent(OtherRecord)
    if not OtherContent then
        return false
    end
    
    local CurrentStack = OtherRecord.CurrentStack or OtherContent.CurrentStack or 0
    local MaxStack = OtherContent.MaxStack or 0
    
    return CurrentStack >= MaxStack
end
--endregion

--region 奖励弹窗数据构建
--- 构建奖励弹窗参数
---@param Type number|nil 默认选中的关卡ID
---@return table 弹窗参数
function M:BuildRewardParams(Type)
    local Params = {}
    local ConfigData = {
        HasTab = true,
        ReddotName = "BagGameAward",
        TabInfo = {},
        Datas = {},
    }
    if Type then
        ConfigData.Type = Type
    end
    
    local LevelsInfo = self:GetLevelsInfo()
    local Avatar = GWorld:GetAvatar()
    local BackpackPuzzleEventInfo = Avatar and Avatar.BackpackPuzzles
    
    for _, Info in ipairs(LevelsInfo) do
        -- Tab 信息
        local TableItem = {}
        TableItem.Title = Info.LevelName
        TableItem.Type = Info.LevelId
        TableItem.ReddotName = "BagGameAward"
        TableItem.IsShowIcon = false
        table.insert(ConfigData.TabInfo, TableItem)
        
        -- 奖励数据
        local SumNum = #(Info.TargetReward)
        local BackpackPuzzleLevelInfo = BackpackPuzzleEventInfo and BackpackPuzzleEventInfo[Info.LevelId]
        local MaxScore = BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo.FinishScore or 0
        local RewardsGotInfo = BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo.ScoreRewardsGot
        
        local Data = { Items = {} }
        local CurrentNum = 0
        
        for i = 1, SumNum do
            local Item = {}
            Item.Score = Info.TargetScore[i]
            Item.Index = i
            Item.Type = Info.LevelId
            Item.CanReceive = false
            Item.RewardsGot = false
            
            if MaxScore < Item.Score then
                Item.InProgress = true
            else
                CurrentNum = CurrentNum + 1
                Item.InProgress = false
                local GotState = RewardsGotInfo and RewardsGotInfo[i]
                if GotState == 2 then
                    Item.CanReceive = false
                    Item.RewardsGot = true
                else
                    Item.CanReceive = true
                    Item.RewardsGot = false
                end
            end
            
            Item.NotreachText = GText("UI_EventReward_NotAchieved")
            Item.Hint = string.format(GText("UI_BackpackPuzzle_Target"..i), Item.Score)
            Item.Rewards = self:BuildRewardContent(Info.TargetReward[i])
            
            table.insert(Data.Items, Item)
        end
        
        Data.ShowIcon = false
        Data.ShowSourceNum = true
        Data.Text_Total = GText("UI_EventReward_Achieved")
        Data.NowNum = CurrentNum
        Data.NumMax = SumNum
        Data.ReceiveButtonText = GText("UI_BattlePass_ClaimAll")
        ConfigData.Datas[Info.LevelId] = Data
    end
    
    Params.ConfigData = ConfigData
    Params.Title = GText("UI_BackpackPuzzle_RewardBtn")
    return Params
end

--- 构建单个奖励的内容数据
---@param RewardId number 奖励ID
---@return table 奖励内容列表
function M:BuildRewardContent(RewardId)
    local Rewards = {}
    local RewardInfo = DataMgr.Reward and DataMgr.Reward[RewardId]
    if not RewardInfo then return Rewards end
    
    local Ids = RewardInfo.Id or {}
    local RewardCount = RewardInfo.Count or {}
    local TableName = RewardInfo.Type or {}
    
    for i = 1, #Ids do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local ItemId = Ids[i]
        Content.IsShowDetails = true
        Content.Id = ItemId
        Content.ItemId = ItemId
        Content.Count = RewardUtils:GetCount(RewardCount[i])
        Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
        Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
        Content.ItemType = TableName[i]
        Content.bHasGot = false
        table.insert(Rewards, Content)
    end
    
    return Rewards
end

--- 构建关卡列表的 Content 数据
---@param LevelInfo table 关卡配置数据
---@param DataIndex number 数据序号（用于 Content.Id）
---@return table Content 数据
function M:BuildLevelListContent(LevelInfo, DataIndex)
    local PlayerScore = self:GetPlayerFinishScore(LevelInfo.LevelId)
    
    return {
        -- 列表逻辑用的 ID（简单序号）
        Id = DataIndex,
        -- 配表字段
        LevelId = LevelInfo.LevelId,
        LevelName = LevelInfo.LevelName,
        LevelDes = LevelInfo.LevelDes,
        UnlockDate = LevelInfo.UnlockDate,
        TargetScore = LevelInfo.TargetScore,
        TargetReward = LevelInfo.TargetReward,
        LevelInitialItem = LevelInfo.LevelInitialItem,
        GridDistribute = LevelInfo.GridDistribute,
        -- 玩家进度
        PlayerScore = PlayerScore,
    }
end
--- 构建结算奖励预览内容列表
--- 根据结算分数，找出达成的目标分数对应的奖励，构建为 Content 对象列表
---@param TotalScore number 结算总分
---@param TargetScores table 目标分数数组 {100, 300, 1000}
---@param TargetRewards table 目标奖励ID数组 {60010, 60011, 60012}（对应 DataMgr.Reward 的 ID）
---@return table Content 对象列表
function M:BuildSettlementRewardContents(TotalScore, TargetScores, TargetRewards)
    local RewardContents = {}

    if not TargetScores or not TargetRewards then
        return RewardContents
    end

    for i, Score in ipairs(TargetScores) do
        if TotalScore >= Score and TargetRewards[i] then
            local Items = self:BuildRewardContent(TargetRewards[i])
            for _, Content in ipairs(Items) do
                table.insert(RewardContents, Content)
            end
        end
    end

    return RewardContents
end
--endregion

return M
