--
-- DESCRIPTION
-- HUD自定义设计组件
-- @AUTHOR HY

-- HUD自定义设计组件
local M = {}

-------------------------------------------外部接口--------------------------------------
-- 注册组件函数
---@param AllHUDWidgetConfigData table 可拖拽的 HUD Widget 列表 Key: 拖拽节点的父节点, Value: 拖拽节点的信息
---                     （Table类型，类型1内部节点需要包含：WidgetClass, WidgetName, LocalOffset, ParentType等信息， 类型2内部节点需要包含：WidgetObj）
---@param bCreateWidgetAfterLayoutLoad boolean 可选参数，加载布局数据后是否需要手动加载Widget
---@param bAsyncWidgetLoading boolean 可选参数，是否异步加载，默认同步加载
function M:RegisterHUDDesignComponent(AllHUDWidgetConfigData, bCreateWidgetAfterLayoutLoad, bAsyncWidgetLoading)
    self.AllHUD_DraggableWidgetConfigData = AllHUDWidgetConfigData or {}
    self.bCreateWidgetAfterLayoutLoad = bCreateWidgetAfterLayoutLoad
    self.bAsyncWidgetLoading = bAsyncWidgetLoading

    self:InitializeVariable()
end

-- 销毁组件函数
---@param bClearChildren boolean 可选参数，是否清除所有子节点
function M:UnRegisterHUDDesignComponent(bClearChildren)
    self:_RemoveAllHUD_DraggableWidgets(bClearChildren)
    DebugPrint("HUDWidgetDesignComponent destroyed")
end

-- 获取可拖拽的Widget
---@param WidgetName string Widget名称
function M:GetWidgetByName(WidgetName)
    return self.AllValidDraggableWidgets[WidgetName]
end

-- 重新设置可拖拽Widget配置数据
---@param AllHUDWidgetConfigData table 可拖拽的 HUD Widget 列表 Key: 拖拽节点的父节点, Value: 拖拽节点的信息
function M:ResetDraggableWidgetConfigData(AllHUDWidgetConfigData)
    self.AllHUD_DraggableWidgetConfigData = AllHUDWidgetConfigData
end

-- 保存位置数据
function M:SaveAllWidgetLayoutData()
    if (self.EditPlanIndex == nil) then
        -- 尝试从Avatar上获取当前的布局方案索引
        self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
    end
    -- local HUDLayoutConfig = EMCache:Get("BattleHUDLayoutConfig", true) or {}
    -- local CurrentPlans = HUDLayoutConfig["LayoutPlans"] or {}

    local WidgetPlanData = {}
    for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
        local ParentNode = self[ParentName]
        if (IsValid(ParentNode) and self:IsEffectWidgetInCurrentPlan(WidgetConfig)) then
            local Position = nil
            local Slot = ParentNode.Slot
            if Slot then
                Position = Slot:GetPosition()
            else
                DebugPrint("HUDWidgetDesignComponent: Failed to get Slot for ParentNode: ", ParentName)
            end
            if (Position) then
                WidgetPlanData[ParentName] = { PosX = Position.X, PosY = Position.Y, 
                                                ScaleX=ParentNode.RenderTransform.Scale.X, ScaleY=ParentNode.RenderTransform.Scale.Y }
                -- 额外存储世界坐标
                if (WidgetConfig.bNeedAddWorldPos) then
                    local WorldPos = UIManager(self):GetWorldPosition(ParentNode)
                    WidgetPlanData[ParentName].WorldPosX = WorldPos.X
                    WidgetPlanData[ParentName].WorldPosY = WorldPos.Y
                end
                -- 有额外的关联节点，需要存储关联节点的一些额外信息
                if (WidgetConfig.RelativeNodeName) then
                    local RelativeNodeWidget = self[WidgetConfig.RelativeNodeName]
                    if (RelativeNodeWidget) then
                        local LayoutWidgetGeometry = self.RootLayoutNode:GetCachedGeometry()
                        local LayoutWidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
                        WidgetPlanData[ParentName].RelativeNodeSaveData = {
                            AreaRangeSizeY = RelativeNodeWidget.Slot:GetSize().Y,
                            AreaRangeSizeYPercent = RelativeNodeWidget.Slot:GetSize().Y / LayoutWidgetLocalSize.Y
                        }
                    end
                end
                -- 如果是需要手动添加的Widget，还需要存储是否已经添加过的状态
                if (WidgetConfig.bIsNeedManualAdd) then
                    WidgetPlanData[ParentName].bHasAddInHUDSetting = ParentNode:IsVisible()
                end
            end
        end
    end

    -- CurrentPlans[CurrentPlanIdx] = WidgetPlanData
    -- HUDLayoutConfig["LayoutPlans"] = CurrentPlans
    -- EMCache:Set("BattleHUDLayoutConfig", HUDLayoutConfig, true)
    if self.PlanName then
        WidgetPlanData.HudPlanName = self.PlanName
    end
    self.PlayerAvatar:UpdateMobileHudPlan(self.EditPlanIndex, WidgetPlanData)
    DebugPrint("HUDWidgetDesignComponent: Call Rpc UpdateMobileHudPlan!, EditPlanIndex is ", self.EditPlanIndex)
end

-- 获取位置数据
function M:GetCurrentWidgetPlanData()
    if (self.EditPlanIndex == nil) then
        -- 尝试从Avatar上获取当前的布局方案索引
        self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
    end
    -- local HUDLayoutConfig = EMCache:Get("BattleHUDLayoutConfig", true) or {}
    -- local CurrentPlans = HUDLayoutConfig["LayoutPlans"] or {}

    local WidgetPlanData = {}
    for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
        local ParentNode = self[ParentName]
        if (IsValid(ParentNode) and self:IsEffectWidgetInCurrentPlan(WidgetConfig)) then
            local Position = nil
            local Slot = ParentNode.Slot
            if Slot then
                Position = Slot:GetPosition()
            else
                DebugPrint("HUDWidgetDesignComponent: Failed to get Slot for ParentNode: ", ParentName)
            end
            if (Position) then
                WidgetPlanData[ParentName] = { PosX = Position.X, PosY = Position.Y, 
                                                ScaleX=ParentNode.RenderTransform.Scale.X, ScaleY=ParentNode.RenderTransform.Scale.Y }
                -- 额外存储世界坐标
                if (WidgetConfig.bNeedAddWorldPos) then
                    local WorldPos = UIManager(self):GetWorldPosition(ParentNode)
                    WidgetPlanData[ParentName].WorldPosX = WorldPos.X
                    WidgetPlanData[ParentName].WorldPosY = WorldPos.Y
                end
                -- 有额外的关联节点，需要存储关联节点的一些额外信息
                if (WidgetConfig.RelativeNodeName) then
                    local RelativeNodeWidget = self[WidgetConfig.RelativeNodeName]
                    if (RelativeNodeWidget) then
                        local LayoutWidgetGeometry = self.RootLayoutNode:GetCachedGeometry()
                        local LayoutWidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
                        WidgetPlanData[ParentName].RelativeNodeSaveData = {
                            AreaRangeSizeY = RelativeNodeWidget.Slot:GetSize().Y,
                            AreaRangeSizeYPercent = RelativeNodeWidget.Slot:GetSize().Y / LayoutWidgetLocalSize.Y
                        }
                    end
                end
                -- 如果是需要手动添加的Widget，还需要存储是否已经添加过的状态
                if (WidgetConfig.bIsNeedManualAdd) then
                    WidgetPlanData[ParentName].bHasAddInHUDSetting = ParentNode:IsVisible()
                end
            end
        end
    end

    -- CurrentPlans[CurrentPlanIdx] = WidgetPlanData
    -- HUDLayoutConfig["LayoutPlans"] = CurrentPlans
    -- EMCache:Set("BattleHUDLayoutConfig", HUDLayoutConfig, true)
    if self.PlanName then
        WidgetPlanData.HudPlanName = self.PlanName
    end
    return WidgetPlanData
end

-- 检查是否是该方案下的有效节点
function M:IsEffectWidgetInCurrentPlan(WidgetConfig)
    local MappedPlanIndex = self:_GetMappedPlanIndex(self.EditPlanIndex)
    if (WidgetConfig.bIsNeedManualAdd) then
        return MappedPlanIndex == 2
    else
        return true
    end
end

-- 读取位置数据
---@param bCreateWidgetAfterLayoutLoad boolean 读取布局数据后是否需要根据配置加载Widget
function M:LoadAllWidgetLayoutData(bCreateWidgetAfterLayoutLoad)
    if (self.EditPlanIndex == nil) then
        -- 尝试从Avatar上获取当前的布局方案索引
        self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
    end

    -- local HUDLayoutConfig = EMCache:Get("BattleHUDLayoutConfig", true) or {}

    -- local CurrentPlans = HUDLayoutConfig["LayoutPlans"] or {}
    -- local WidgetPlanData = CurrentPlans[self.EditPlanIndex] or {}

    local WidgetPlanData = self.PlayerAvatar:GetMobileHudPlan(self.EditPlanIndex) or {}
    if (bCreateWidgetAfterLayoutLoad) then
        self:GenerateAllWidgetWithConfigData(WidgetPlanData)
    else
        self:ArrangeAllWidgetTargetPosition(WidgetPlanData)
    end
    -- 蓝图接口，更新当前布局方案配置
    self:UpdateWidgetLayout(math.max(0, self.EditPlanIndex - 1))
    return WidgetPlanData
end

-- 获取单个Widget的布局数据
---@param LayoutWidgetName string 需要获取布局数据的Widget名称
function M:GetTargetWidgetLayoutData(LayoutWidgetName)
    if (self.EditPlanIndex == nil) then
        -- 尝试从Avatar上获取当前的布局方案索引
        self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
    end

    local WidgetPlanData = self.PlayerAvatar:GetMobileHudPlan(self.EditPlanIndex) or {}
    return WidgetPlanData[LayoutWidgetName]
end

-- 将EditPlanIndex (1-6) 映射到PlanIndex (1-2)
-- 映射规则：1,3,5 -> 1; 2,4,6 -> 2
---@param EditPlanIndex number 编辑的布局方案索引 (1-6)
---@return number 映射后的布局方案索引 (1-2)
function M:_GetMappedPlanIndex(EditPlanIndex)
    if EditPlanIndex == nil then
        return 1
    end
    -- 公式：((EditPlanIndex - 1) % 2) + 1
    -- 1->1, 2->2, 3->1, 4->2, 5->1, 6->2
    return ((EditPlanIndex - 1) % 2) + 1
end

-- 获取关联节点的期望保存数据（如果有的话）
---@param WidgetNodeName string 可拖拽Widget节点名称
function M:_GetRelativeNodeDesireSaveData(WidgetNodeName)
    if (self.EditPlanIndex == nil) then
        -- 尝试从Avatar上获取当前的布局方案索引
        self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
    end

    local WidgetPlanData = self.PlayerAvatar:GetMobileHudPlan(self.EditPlanIndex) or {}
    if (WidgetPlanData[WidgetNodeName] == nil) then
        return 
    end
    return WidgetPlanData[WidgetNodeName].RelativeNodeSaveData
end

-- 进入自定义设计状态
---@param EditPlanIndex number 编辑的布局方案索引
---@param RootLayoutNode UWidget 根布局节点
function M:EnterDesignState(EditPlanIndex, RootLayoutNode, WidgetPlanData)
    self.EditPlanIndex = EditPlanIndex
    self.RootLayoutNode = RootLayoutNode
    self.ManualAddWidgetsList = {}
    if WidgetPlanData then
        self:ArrangeAllWidgetTargetPosition(WidgetPlanData)
        self:UpdateWidgetLayout(math.max(0, self.EditPlanIndex - 1))
    else
        self:LoadAllWidgetLayoutData(self.bCreateWidgetAfterLayoutLoad)
    end
    for key, value in pairs(self.AllValidDraggableWidgets) do
        if (IsValid(value) and type(value.SetDraggable) == "function") then
            value:SetDraggable(true)
        end
    end 
    -- 隐藏移动范围
    if self.MoveRangePos then
        self.MoveRangePos:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 处理需要手动添加的Widget的状态
    for _, ValueInfo in pairs(self.ManualAddWidgetsList) do
        self:_UpdateManualAddWidgetBySaveData(ValueInfo.WidgetItem, ValueInfo.ParentNode, ValueInfo.bHasAddInHUDSetting)
    end
    DebugPrint("HUDWidgetDesignComponent: Enter Design State, EditPlanIndex is ", EditPlanIndex)
end

-- 退出自定义设计状态
function M:LeaveDesignState()
    for key, value in pairs(self.AllValidDraggableWidgets) do
        if (IsValid(value) and type(value.SetDraggable) == "function") then
            value:SetDraggable(false)
        end
    end 
end

function M:SetRootLayoutNode(RootLayoutNode)
    self.RootLayoutNode = RootLayoutNode
end

-- 重置为默认布局
function M:ResetToDefaultLayout()
    -- 重置所有按钮到默认状态
    self:ResetBtnStateInDefault(math.max(0, self.EditPlanIndex - 1))
    -- 所有关联节点也需要重置回默认状态
    self:ResetRelativeNodeStateInDefault()
end

-- 重置单个控件到默认布局
function M:ResetSingleItemToDefaultLayout(TargetWidget)
    if not IsValid(TargetWidget) then
        DebugPrint("HUDWidgetDesignComponent: ResetSingleItemToDefaultLayout Invalid TargetWidget!")
        return
    end

    local ParentNodeName = nil
    for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
        local SubWidgetItem = WidgetConfig.WidgetObj
        if (SubWidgetItem == TargetWidget) then
            ParentNodeName = ParentName
            break
        end
    end

    if not ParentNodeName then
        DebugPrint("HUDWidgetDesignComponent: ResetSingleItemToDefaultLayout Cannot find TargetWidget in ConfigData!")
        return
    end

    local WidgetPlanData = self.PlayerAvatar:GetMobileHudPlan(self.EditPlanIndex) or {}
    if (WidgetPlanData and WidgetPlanData[ParentNodeName]) then
        local SaveDataInHUD = WidgetPlanData[ParentNodeName]
        local ParentNode = self[ParentNodeName]
        self:_UpdateWidgetToTargetPos(ParentNode, FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY))
        self:_UpdateWidgetToTargetScale(ParentNode, FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY))
        DebugPrint(string.format("HUDWidgetDesignComponent [ResetSingleItemToDefaultLayout]: Set widget position to= X: %f, Y: %f, scale is X: %f, Y: %f, ParentNodeName: %s !", 
                    SaveDataInHUD.PosX, SaveDataInHUD.PosY, SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY, ParentNodeName))
    else
        -- 如果服务端没有记录数据，则重置回初始状态
        local ParentNode = self[ParentNodeName]
        local AllChildren = self.RootLayoutNode:GetAllChildren():ToTable() or {}
        for ChildIndex, ChildItem in ipairs(AllChildren) do
            if (ChildItem == ParentNode) then
                local Slot = ParentNode.Slot
                if (Slot) then
                    local MappedPlanIndex = self:_GetMappedPlanIndex(self.EditPlanIndex)
                    local DefaultPositionPlan = self["DefaultPosition0"..tostring(MappedPlanIndex)]
                    local DefaultScalePlan = self["DefaultPosScale0"..tostring(MappedPlanIndex)]
                    if (DefaultPositionPlan and DefaultPositionPlan:Get(ChildIndex)) then
                        Slot:SetPosition(DefaultPositionPlan:Get(ChildIndex))
                        ParentNode:SetRenderScale(DefaultScalePlan:Get(ChildIndex))
                        DebugPrint(string.format("HUDWidgetDesignComponent [ResetSingleItemToDefaultLayout]: Reset widget to initial position and scale, ParentNodeName: %s !", 
                                    ParentNodeName))
                    else
                        DebugPrint("HUDWidgetDesignComponent: ResetSingleItemToDefaultLayout Error Cannot find DefaultPositionPlan or ChildIndex!")
                    end
                end
                break
            end
        end
    end
end

-- 设置单个控件到上次记录状态
function M:SetSingleItemToLastRecordState(TargetWidget, OpType, OpValue)
    if not IsValid(TargetWidget) then
        DebugPrint("HUDWidgetDesignComponent: SetSingleItemToLastRecordState Invalid TargetWidget!")
        return
    end
    local ParentNode = TargetWidget:GetParent()
    if (ParentNode) then
        if (OpType == "Pos") then
            self:_UpdateWidgetToTargetPos(ParentNode, OpValue)
        elseif (OpType == "Scale") then
            self:_UpdateWidgetToTargetScale(ParentNode, OpValue)
        end
    end
end

-------------------------------------------内部接口--------------------------------------
-- 初始化一些变量
---@field AllValidDraggableWidgets table 所有可拖拽的Widget列表 Key: Widget名称, Value: Widget对象
---@field PlayerAvatar table 玩家Avatar对象
function M:InitializeVariable()
    self.AllValidDraggableWidgets = {}
    self.PlayerAvatar = GWorld:GetAvatar()
    DebugPrint("HUDWidgetDesignComponent initialized")
end

-- 生成所有可拖拽的Widget, 并根据布局数据设置位置
---@param WidgetPlanData table 布局方案数据
function M:GenerateAllWidgetWithConfigData(WidgetPlanData)
    for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
        local SubWidgetClass = WidgetConfig.WidgetClass
        local SubWidgetName = WidgetConfig.WidgetName or ParentName
        local SubWidgetLocalOffset = WidgetConfig.LocalOffset
        local ParentType = WidgetConfig.ParentType
        local RelativeNodeName = WidgetConfig.RelativeNodeName
        local bIsNeedManualAdd = WidgetConfig.bIsNeedManualAdd
        local SaveDataInHUD = WidgetPlanData[ParentName]

        local ParentNode = self[ParentName]
        self:_CreateAllHUD_DraggableWidget(SubWidgetClass, SubWidgetName, SubWidgetLocalOffset, ParentNode, 
                                            ParentType, RelativeNodeName, bIsNeedManualAdd, SaveDataInHUD)
    end
end

-- 根据布局数据设置所有可拖拽Widget位置
---@param WidgetPlanData table 布局方案数据
function M:ArrangeAllWidgetTargetPosition(WidgetPlanData)
    local MappedPlanIndex = self:_GetMappedPlanIndex(self.EditPlanIndex)
    local DefaultPositionPlan = self["DefaultPosition0"..tostring(MappedPlanIndex)]
    local DefaultScalePlan = self["DefaultPosScale0"..tostring(MappedPlanIndex)]
    for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
        local SubWidgetName = WidgetConfig.WidgetName or ParentName
        local SubWidgetItem, RelativeNodeSaveData = WidgetConfig.WidgetObj, nil
        local ParentNode = self[ParentName]

        if (WidgetConfig.bIsNeedManualAdd) then
            self.ManualAddWidgetsList[SubWidgetName] = {
                WidgetItem = SubWidgetItem,
                ParentNode = ParentNode,
                bHasAddInHUDSetting = false,
            }
        end

        if (IsValid(SubWidgetItem)) then
            if (WidgetPlanData) then
                local SaveDataInHUD = WidgetPlanData[ParentName]
                if (SaveDataInHUD) then
                    local PositionInServer = FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY)
                    local ScaleInServer = FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY)
                    local TargetChildIndex = self.RootLayoutNode:GetChildIndex(ParentNode) + 1

                    if (self.bIsDefaultLayoutData) then
                        if (not self:_FVector2D_Equal(PositionInServer, DefaultPositionPlan:Get(TargetChildIndex)) or 
                                not self:_FVector2D_Equal(ScaleInServer, DefaultScalePlan:Get(TargetChildIndex))) then
                            self.bIsDefaultLayoutData = false
                        end
                    end
                    -- 设置位置和缩放
                    self:_UpdateWidgetToTargetPos(ParentNode, PositionInServer, false, true)
                    self:_UpdateWidgetToTargetScale(ParentNode, ScaleInServer, true)
                    -- 处理关联节点的数据更新
                    if (WidgetConfig.RelativeNodeName) then
                        RelativeNodeSaveData = SaveDataInHUD.RelativeNodeSaveData
                    end
                    -- 处理需要手动添加的Widget的状态
                    if (WidgetConfig.bIsNeedManualAdd) then
                        self.ManualAddWidgetsList[SubWidgetName].bHasAddInHUDSetting = SaveDataInHUD.bHasAddInHUDSetting
                    end
                    DebugPrint(string.format("HUDWidgetDesignComponent [ArrangeAllWidget]: Set widget position to: X: %f, Y: %f, scale is X: %f, Y: %f, WidgetName: %s !", 
                                SaveDataInHUD.PosX, SaveDataInHUD.PosY, SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY, ParentName))
                end
            end
            if (WidgetConfig.RelativeNodeName) then
                self:_UpdateRelativeWidgetBySaveData(SubWidgetItem, WidgetConfig.RelativeNodeName, RelativeNodeSaveData)
            end
            self.AllValidDraggableWidgets[SubWidgetName] = SubWidgetItem 
        end
    end
end

-- 创建可拖拽的 Widget
---@param SubWidgetClass UClass 子 Widget 类对象
---@param SubWidgetName string 子 Widget 名称
---@param SubWidgetLocalOffset FVector2D 子 Widget 相对于父节点的本地偏移
---@param ParentNode UWidget 父节点
---@param ParentType string 父节点类型 "CanvasPanel" or "Overlay"
---@param RelativeNodeName string 关联节点名称
---@param bIsNeedManualAdd boolean 是否是需要手动添加的节点 Widget
---@param SaveDataInHUD table 布局方案中的位置数据 {PosX, PosY, ScaleX, ScaleY}
function M:_CreateAllHUD_DraggableWidget(SubWidgetClass, SubWidgetName, SubWidgetLocalOffset, ParentNode, ParentType, RelativeNodeName, bIsNeedManualAdd, SaveDataInHUD)
    local function AttachSubWidgetToParent(WidgetName, DestWidget)
        -- 添加到指定父节点或视口
        if (ParentNode) then
            if (ParentType == "CanvasPanel") then
                -- 添加到指定父节点的 CanvasPanel
                local Slot = ParentNode:AddChild(DestWidget)
                if (Slot ~= nil) then
                    if (SubWidgetLocalOffset) then
                        Slot:SetPosition(SubWidgetLocalOffset)
                    else
                        Slot:SetPosition(FVector2D(0, 0))
                    end
                else
                    DebugPrint("HUDWidgetDesignComponent: Failed to add widget to ParentNode!")
                end
            elseif (ParentType == "Overlay") then
                -- 添加到指定父节点的 Overlay
                local Slot = ParentNode:AddChildToOverlay(DestWidget)
                if (Slot ~= nil) then
                    if (SubWidgetLocalOffset) then
                        Slot:SetPadding(FMargin(SubWidgetLocalOffset.X, SubWidgetLocalOffset.Y, 0, 0))
                    else
                        Slot:SetPadding(FMargin(0, 0, 0, 0))
                    end
                else
                    DebugPrint("HUDWidgetDesignComponent: Failed to add widget to ParentNode!")
                end
            else
                -- 其他类型的父节点处理逻辑可以在这里添加
                DebugPrint("HUDWidgetDesignComponent:Error Unsupported ParentType: ", ParentType)
            end
            self:_UpdateWidgetToTargetPos(ParentNode, FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY))
            self:_UpdateWidgetToTargetScale(ParentNode, FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY))
            -- 处理关联节点的数据更新
            if (RelativeNodeName) then
                self:_UpdateRelativeWidgetBySaveData(DestWidget, RelativeNodeName, SaveDataInHUD.RelativeNodeSaveData)
            end
            if (bIsNeedManualAdd) then
                self.ManualAddWidgetsList[SubWidgetName] = {
                    WidgetItem = DestWidget,
                    ParentNode = ParentNode,
                    bHasAddInHUDSetting = SaveDataInHUD.bHasAddInHUDSetting,
                }
            end
            DebugPrint(string.format("HUDWidgetDesignComponent [CreateAllHUD]: Set widget position in ParentNode Slot to: X: %f, Y: %f, scale is X: %f, Y: %f, WidgetName: %s !", 
                        SaveDataInHUD.PosX, SaveDataInHUD.PosY, SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY, WidgetName))
        else
            -- 添加到视口
            DestWidget:AddToViewport()

            -- 设置初始位置
            if (SaveDataInHUD) then
                DestWidget:SetPositionInViewport(FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY))
            else
                DestWidget:SetPositionInViewport(FVector2D(0, 0))
            end
        end
        self.AllValidDraggableWidgets[WidgetName] = DestWidget
    end

    if not SubWidgetClass then
        DebugPrint("HUDWidgetDesignComponent Invalid widget class!")
        return nil
    end

    -- 创建 Widget
    if (self.bAsyncWidgetLoading) then
        UIManager(self):CreateWidgetAsync(SubWidgetClass, function(SubWidget)
            if not SubWidget then
                DebugPrint("HUDWidgetDesignComponent: Failed to create widget asynchronously!")
                return
            end
            AttachSubWidgetToParent(SubWidgetName, SubWidget)
        end)
    else
        local SubWidget = UIManager(self):CreateWidget(SubWidgetClass)
        if not SubWidget then
            DebugPrint("HUDWidgetDesignComponent: Failed to create widget!")
            return nil
        end
        AttachSubWidgetToParent(SubWidgetName, SubWidget)
    end
end

-- 移除所有可拖拽 Widget
---@param bClearChildren boolean 是否清除所有子节点
function M:_RemoveAllHUD_DraggableWidgets(bClearChildren)
    if (bClearChildren) then
        for Name, Widget in pairs(self.AllValidDraggableWidgets) do
            if (IsValid(Widget)) then
                Widget:RemoveFromParent()
            end
        end
    else
        for Name, Widget in pairs(self.AllValidDraggableWidgets) do
            if (IsValid(Widget)) then
                Widget:LeaveDesignState()
            end
        end
    end
    
    self.AllValidDraggableWidgets = {}
    DebugPrint("HUDWidgetDesignComponent: Removed all draggable widgets")
end

-- 设置 Widget 到目标位置
---@param WidgetNode UWidget 目标 Widget 节点
---@param TargetPos FVector2D 目标位置
---@param bIsAbsolutePosition boolean 目标位置是否为绝对位置
---@param bIsOnlyModifyBPValue boolean 是否仅修改蓝图变量值，不修改实际位置
function M:_UpdateWidgetToTargetPos(WidgetNode, TargetPos, bIsAbsolutePosition, bIsOnlyModifyBPValue)
    if (bIsAbsolutePosition) then
        TargetPos = UIUtils.GetRelativePositionInParent(WidgetNode, TargetPos)
    end
    if (not bIsOnlyModifyBPValue) then
        local ParentSlot = WidgetNode.Slot
        if (ParentSlot) then
            ParentSlot:SetPosition(TargetPos)
        else
            ParentSlot:SetPositionInViewport(TargetPos)
        end
    end
    self:_SetWidgetInfoToBPValue(WidgetNode, "Pos", TargetPos)
end

-- 设置 Widget 到目标缩放
---@param WidgetNode UWidget 目标 Widget 节点
---@param TargetScale FVector2D 目标缩放
---@param bIsOnlyModifyBPValue boolean 是否仅修改蓝图变量值，不修改实际缩放
function M:_UpdateWidgetToTargetScale(WidgetNode, TargetScale, bIsOnlyModifyBPValue)
    if (not bIsOnlyModifyBPValue) then
        WidgetNode:SetRenderScale(TargetScale)
        -- WidgetNode.RenderTransform.Scale = TargetScale
    end
    self:_SetWidgetInfoToBPValue(WidgetNode, "Scale", TargetScale)
end

-- 更新关联节点的保存数据
---@param DraggableWidgetItem UWidget 目标 Widget 节点
---@param RelativeNodeName string 关联节点名称
---@param RelativeNodeSaveData table 关联节点的保存数据
function M:_UpdateRelativeWidgetBySaveData(DraggableWidgetItem, RelativeNodeName, RelativeNodeSaveData)
    -- 根据关联节点名称更新不同的节点样式以及大小
    if (RelativeNodeName == "MoveRangePos") then
        -- 处理移动范围节点
        local RelativeNodeWidget = self[RelativeNodeName]
        if (RelativeNodeWidget) then
            local Params = {
                RelativeName = RelativeNodeName,
                TouchAreaWidget = self.Btn_MoveRange
            }
            DraggableWidgetItem:InitRelativeNodeSaveData(RelativeNodeWidget, RelativeNodeSaveData, Params)
        end
    end
end

-- 更新需要手动添加的Widget状态
---@param DraggableWidgetItem UWidget 目标 Widget 节点
---@param ParentNode UWidget 目标 Widget 的父节点，实际位置更新的节点
---@param bHasAddInHUDSetting boolean 是否已经显示在了HUD上
function M:_UpdateManualAddWidgetBySaveData(DraggableWidgetItem, ParentNode, bHasAddInHUDSetting)
    if (bHasAddInHUDSetting) then
        ParentNode:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        ParentNode:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- 更新数据到蓝图变量上
---@param ParentNode UWidget 目标 Widget 节点
---@param TypeStr string 数据类型 "Pos" or "Scale"
---@param Value FVector2D 目标值
function M:_SetWidgetInfoToBPValue(ParentNode, TypeStr, Value)
    local TargetChildIndex = self.RootLayoutNode:GetChildIndex(ParentNode) + 1
    if (TargetChildIndex > 0) then
        if (TypeStr == "Pos") then
            local CurPositionPlan = self["InPosition0"..tostring(self.EditPlanIndex)]
            if (CurPositionPlan and CurPositionPlan:Get(TargetChildIndex)) then
                CurPositionPlan:Set(TargetChildIndex, Value)
            end
        elseif (TypeStr == "Scale") then
            local CurScalePlan = self["PosScale0"..tostring(self.EditPlanIndex)]
            if (CurScalePlan and CurScalePlan:Get(TargetChildIndex)) then
                CurScalePlan:Set(TargetChildIndex, Value)
            end
        end
    end
end

-- 比较两个数字是否相等（考虑精度问题）
function M:_Numbers_Equal(a, b, Epsilon)
    if (not a or not b) then
        return false
    end
    Epsilon = Epsilon or 1e-10  -- 默认精度阈值
    return math.abs(a - b) < Epsilon
end

-- 比较两个向量2D是否相等（考虑精度问题）
function M:_FVector2D_Equal(a, b, Epsilon)
    if (not a or not b) then
        return false
    end
    Epsilon = Epsilon or 1e-10  -- 默认精度阈值
    if (math.abs(a.X - b.X) > Epsilon) then
        return false
    elseif (math.abs(a.Y - b.Y) > Epsilon) then
        return false
    end
    return true
end

return M
