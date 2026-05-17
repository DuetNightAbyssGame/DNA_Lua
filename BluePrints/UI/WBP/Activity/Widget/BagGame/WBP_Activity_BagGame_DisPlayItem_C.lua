--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"

-- 使用 Model 中的物品类型常量
local ItemType = BagGameModel.ItemType

---@type WBP_Activity_BagGame_PlayItem03_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C",
"BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent",
"BluePrints.UI.BP_EMUserWidgetUtils_C",})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Switch_Type:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_Score01:SetText(GText("UI_GameEvent_BagGame_ItemScore"))
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
end

-- ==================== TileView Entry Widget 协议 ====================

--- TileView 复用 Entry Widget 时调用，复用 Init 初始化，补充数据对象状态同步
---@param Content UObject 数据对象（由 Play_C:InitDisPlayItem 创建）
function M:OnListItemObjectSet(Content)
    if not Content then return end
    self:Init(Content, Content.PlayScreen)

    -- TileView 特有：从数据对象恢复 Switch_Type 状态（Init 默认设为 0）
    self.Switch_Type:SetActiveWidgetIndex(Content.SwitchIndex or 0)

    -- TileView 特有：覆盖拖拽回调，闭包捕获 Content 数据对象同步 SwitchIndex
    self:SetCallbacks({
        OnDragDetectedCallback = function(self, PointerEvent, Operation)
            Content.SwitchIndex = 1
            self.Switch_Type:SetActiveWidgetIndex(1)
            if Operation and Operation.DefaultDragVisual and Operation.DefaultDragVisual.SetItemSize then
                Operation.DefaultDragVisual:SetItemSize()
            end
            if self.PlayScreen and self.PlayScreen.OnDragStateChanged then
                self.PlayScreen:OnDragStateChanged(true)
            end
        end,
        OnDragCancelCallback = function(self, PointerEvent, Operation)
            Content.SwitchIndex = 0
            self.Switch_Type:SetActiveWidgetIndex(0)
            if self.PlayScreen and self.PlayScreen.OnDragStateChanged then
                self.PlayScreen:OnDragStateChanged(false)
            end
        end,
    })
end

--- Widget 被 TileView 回收时清理引用
function M:BP_OnEntryReleased()
    self.Content = nil
    self.PlayScreen = nil
end

--- 外部数据变更后刷新可见 Widget 的显示（数量、Switch_Type）
function M:SyncDisplayFromContent()
    if not self.Content then return end
    local Content = self.Content

    if Content.ItemType == ItemType.Gun then
        self:SetAmmoNumber(Content.CurrentAmmo or 0, Content.MaxAmmo or 0)
    elseif Content.ItemType == ItemType.Ammo then
        self:SetStackNumber(Content.CurrentStack or 0)
    else
        self:SetStackNumber(Content.CurrentStack or 0)
    end

    self.Switch_Type:SetActiveWidgetIndex(Content.SwitchIndex or 0)
end

--- 根据路径设置物品图标
---@param GUIPath string
function M:SetItemIconByPath(GUIPath)
    if not self.Image_Icon or type(GUIPath) ~= "string" or GUIPath == "" then
        return
    end

    local IconObj = LoadObject(GUIPath)
    if not IconObj then
        return
    end
    local Material = self.Image_Icon:GetDynamicMaterial()
    if Material then
        Material:SetTextureParameterValue("IconTex", IconObj)
    else
        self.Image_Icon:SetBrushResourceObject(IconObj)
    end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    -- self:SetCursor(EMouseCursor.GrabHandClosed)
    -- 检查是否是左键按下
    local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
    if MouseButton.KeyName == "LeftMouseButton" then
        -- 构造一个Reply，告诉系统可以检测拖拽
        local Reply = UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE.EKeys.LeftMouseButton)
        return Reply
    end
    -- 返回未处理，让事件继续传递
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    -- self:SetCursor(EMouseCursor.Default)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

--- 初始化 DisPlayItem
--- Content 字段对照配表：
---   TemplateId  - PuzzleItemTemplate.TemplateId（模板ID，唯一标识）
---   ItemId      - PuzzleItemAttr.ItemId（物品ID，引用基础属性）
---   ItemType    - PuzzleItemAttr.ItemType（物品类型：Gun/Ammo/Other）
---   ItemName    - PuzzleItemAttr.ItemName（物品名称）
---   ItemGrid    - PuzzleItemAttr.ItemGrid（格子形状字符串，如 "[1],[1],[1],[1]"）
---   BasicPoint  - PuzzleItemAttr.BasicPoint（基础分）
---   GUIPath     - PuzzleItemAttr.GUIPath（图片资产路径）
---   MaxAmmo     - PuzzleItemAttr.MaxAmmo（弹药上限，Gun类型）
---   MaxStack    - PuzzleItemAttr.MaxStack（堆叠上限，Ammo/Other类型）
---   CurrentAmmo - PuzzleItemTemplate.CurrentAmmo（当前装弹量，Gun类型）
---   CurrentStack- PuzzleItemTemplate.CurrentStack（当前堆叠数，Ammo/Other类型）
---@param Content table 内容数据
---@param PlayScreen table Play界面引用（可选，用于拖拽时的回调）
function M:Init(Content, PlayScreen)
    self.Content = Content
    self.PlayScreen = PlayScreen     -- 保存Play界面引用
    
    -- 使用配表字段
    self.TemplateId = Content.TemplateId        -- 模板ID（唯一标识）
    self.ItemId = Content.ItemId                -- 物品ID
    self.ItemType = Content.ItemType            -- 物品类型（Gun/Ammo/Other）
    self.bIsOtherType = self.ItemType == ItemType.Other
    self.ItemName = Content.ItemName            -- 物品名称
    self.BasicPoint = Content.BasicPoint or 0   -- 基础分
    self.GUIPath = Content.GUIPath              -- 图片路径
    self:SetItemIconByPath(self.GUIPath)
    self.CurrentAmmo = Content.CurrentAmmo or 0
    self.MaxAmmo = Content.MaxAmmo or 0
    self.CurrentStack = Content.CurrentStack or 0
    self.MaxStack = Content.MaxStack or 0
    
    -- 兼容旧字段：DisPlayItemId 用于拖拽识别（优先使用唯一实例 ID）
    self.DisPlayItemId = Content.DisPlayItemId or Content.TemplateId or Content.Id
    -- 根据类型设置数量显示
    if self.ItemType == ItemType.Gun then
        if self.Image_Ammo then
            self.Image_Ammo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        -- 枪械：显示 当前弹药/弹药上限
        self:SetAmmoNumber(self.CurrentAmmo, self.MaxAmmo)
    elseif self.ItemType == ItemType.Ammo then
        if self.Image_Ammo then
            self.Image_Ammo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        -- 弹药：只显示当前堆叠数
        self:SetStackNumber(self.CurrentStack)
    else
        if self.Image_Ammo then
            self.Image_Ammo:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        -- 其他：仅显示当前堆叠数
        self:SetStackNumber(self.CurrentStack)
    end
    
    -- 设置基础分
    self:SetScoreNumber(self.BasicPoint)
    
    -- 设置形状数据：从 ItemGrid 解析或使用预处理的 ShapeOffsets
    if Content.ShapeOffsets then
        self.ShapeOffsets = Content.ShapeOffsets
    elseif Content.ItemGrid then
        self.ShapeOffsets = self:ParseItemGrid(Content.ItemGrid)
    else
        self.ShapeOffsets = {{0, 0}}  -- 默认单格
    end
    self:SetShapeView()
    
    self:SetCallbacks({
        OnDragDetectedCallback = function(self, PointerEvent, Operation)
            self.Switch_Type:SetActiveWidgetIndex(1)
            -- 拖拽创建后，按形状更新 DragUI 的背景尺寸
            if Operation and Operation.DefaultDragVisual and Operation.DefaultDragVisual.SetItemSize then
                Operation.DefaultDragVisual:SetItemSize()
            end
            -- 通知 PlayScreen 进入抓取状态，播放 recycle_in 动画
            if self.PlayScreen and self.PlayScreen.OnDragStateChanged then
                self.PlayScreen:OnDragStateChanged(true)
            end
        end,
        OnDragCancelCallback = function(self, PointerEvent, Operation)
            self.Switch_Type:SetActiveWidgetIndex(0)
            -- 通知 PlayScreen 退出抓取状态，播放 recycle_out 动画
            if self.PlayScreen and self.PlayScreen.OnDragStateChanged then
                self.PlayScreen:OnDragStateChanged(false)
            end
        end,
    })
end

--- 解析 ItemGrid 字符串为 ShapeOffsets 坐标数组（代理到 Model）
---@param ItemGrid string 配表中的格子形状字符串
---@return table ShapeOffsets 坐标偏移数组 {{Row, Col}, ...}
function M:ParseItemGrid(ItemGrid)
    return BagGameModel:ParseItemGrid(ItemGrid)
end

--- 根据 ShapeOffsets 设置 5×5 矩阵中对应格子的显示/隐藏
--- WrapBox_Items 中有 PlayItemIconBg_0 ~ PlayItemIconBg_24 共25个item
--- 排列为 5行5列，WrapBox 是横向排列（从左到右，从上到下）
--- 第一行: Index 0,1,2,3,4
--- 第二行: Index 5,6,7,8,9
--- 第三行: Index 10,11,12,13,14
--- 第四行: Index 15,16,17,18,19
--- 第五行: Index 20,21,22,23,24
--- 索引映射: Index = Row * 5 + Col
--- ShapeOffsets 格式: {{Row, Col}, ...}，其中 Row 和 Col 从 0 开始
--- 例如 "[1],[1],[1],[1]" 解析为 {{0, 0}, {1, 0}, {2, 0}, {3, 0}}，表示前四行的第一列（最左侧一列，竖向长度为4）
function M:SetShapeView()
    if not self.ShapeOffsets then return end
    
    local SHAPE_SIZE = 5  -- 5×5 矩阵
    
    -- 构建形状坐标查找表 {[Row_Col] = true}
    local ShapeMap = {}
    for _, Offset in ipairs(self.ShapeOffsets) do
        local Row = Offset[1]  -- ShapeOffsets 格式: {Row, Col}
        local Col = Offset[2]
        local Key = Row .. "_" .. Col
        ShapeMap[Key] = true
    end
    
    -- 遍历 5×5 矩阵，设置每个格子的显示状态
    -- WrapBox 横向排列（从左到右，从上到下）
    -- 索引计算: Index = Row * 5 + Col
    for Row = 0, SHAPE_SIZE - 1 do
        for Col = 0, SHAPE_SIZE - 1 do
            local Index = Row * SHAPE_SIZE + Col  -- 横向排列: Row * 5 + Col
            local IconBg = self["PlayItemIconBg_" .. Index]
            if IconBg then
                local Key = Row .. "_" .. Col
                if ShapeMap[Key] then
                    IconBg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                else
                    IconBg:SetVisibility(UIConst.VisibilityOp.Hidden)
                end
            end
        end
    end
end

--- 设置堆叠数量显示（仅显示当前数量，用于弹药类型）
---@param StackNum number 当前堆叠数
function M:SetStackNumber(StackNum)
    self.StackNumber = StackNum or 0
    self.CurrentStack = self.StackNumber
    if self.bIsOtherType then
        self.Text_Lable:SetText("x" .. tostring(self.StackNumber))
    else
        self.Text_Lable:SetText(self.StackNumber)
    end
end

--- 设置弹药/堆叠数量显示
---@param CurrentNum number 当前数量（装弹量或堆叠数）
---@param MaxNum number 上限数量（弹药上限或堆叠上限）
function M:SetAmmoNumber(CurrentNum, MaxNum)
    self.CurrentNum = CurrentNum or 0
    self.MaxNum = MaxNum or 0
    self.CurrentAmmo = self.CurrentNum
    self.MaxAmmo = self.MaxNum
    if self.MaxNum > 0 then
        self.Text_Lable:SetText(self.CurrentNum .. "/" .. self.MaxNum)
    else
        self.Text_Lable:SetText(self.CurrentNum)
    end
end

--- 提供给 DragUI 的同步初始化数据
---@return table
function M:GetDragSyncData()
    return {
        TemplateId = self.TemplateId,
        ItemType = self.ItemType,
        GUIPath = self.GUIPath,
        CurrentAmmo = self.CurrentAmmo or self.CurrentNum or 0,
        MaxAmmo = self.MaxAmmo or self.MaxNum or 0,
        CurrentStack = self.CurrentStack or self.StackNumber or 0,
        MaxStack = self.MaxStack or 0,
    }
end

function M:SetScoreNumber(ScoreNum)
    self.Text_ScoreNum:SetText(ScoreNum)
end

function M:OnDragDetected(MyGeometry, PointerEvent)
    -- 已放置完成的物品不允许再次抓取（从数据对象读状态，兼容 TileView Widget 复用）
    if self.Content and self.Content.SwitchIndex == 2 then
        return nil
    end

    -- 检查是否有未确认的放置物品
    if self.PlayScreen and self.PlayScreen:HasUnconfirmedItem() then
        -- 有未确认物品，禁止抓取新物品，显示提示
        self.PlayScreen:ShowCannotDragToast()
        return nil  -- 返回 nil 阻止拖拽
    end

    return self:OnDragDetectedComponent(MyGeometry, PointerEvent, self.DisPlayItemId, self.ShapeOffsets)
end

function M:OnDragLeave(MyGeometry, PointerEvent, Operation)

end

function M:OnDragCancelled(PointerEvent, Operation)
    if Operation and Operation.Tag == "BagGameDisPlayItem" then
        if self.OnDragCancelCallback then
            self.OnDragCancelCallback(self, PointerEvent, Operation)
        end
    end
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)

end

return M
