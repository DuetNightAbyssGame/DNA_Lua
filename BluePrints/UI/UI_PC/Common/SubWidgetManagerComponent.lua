require "UnLua"

---@class SubWidgetManagerComponent
---管理子Widget的创建、切换、返回等功能
local Component = {}

-- 需要继承者实现的接口
-- 获取主界面的WidgetInfo（当TabId为主界面ID时使用）
-- function Component:GetMainWidgetInfo()
--     return {Idx = "Main"}
-- end

-- 获取主界面的焦点目标（当返回主界面时使用）
-- function Component:GetDesiredFocusTarget_Main()
--     return self
-- end

-- 关闭整个界面的回调
-- function Component:OnCloseAll()
--     self:Close()
-- end

-- 初始化Component
-- @param RootWidget 根Widget容器，子Widget会被添加到这里（支持Canvas、Overlay等容器类型）
-- @param MainTabId 主界面的TabId，如果TabId等于这个值，则使用self作为Widget
function Component:InitSubWidgetManager(RootWidget, MainTabId)
    self.Group_Root = RootWidget
    self.MainTabId = MainTabId
    self.SubUI = {}
    self.CurSubUI = nil
    self.CurTabId = nil
end

-- 打开子界面
-- @param WidgetInfo 界面信息，必须包含Idx字段
-- @param ... 传递给SwitchIn的参数
function Component:OpenSubUI(WidgetInfo, ...)
    local TabId = nil
    if WidgetInfo and WidgetInfo.Idx then
        TabId = WidgetInfo.Idx
    end
    
    -- 如果已经是当前界面，直接返回
    if self.CurTabId == TabId then
        return self.CurSubUI
    end
    
    -- 保存参数，用于SwitchOut完成后调用
    local SwitchInArgs = {...}
    local TargetTabId = TabId
    
    -- 调用当前界面的SwitchOut，并等待完成
    if self.CurSubUI and self.CurSubUI.SwitchOutWithCallback then
        -- 支持回调的SwitchOut，等待完成后再执行SwitchIn
        self.CurSubUI:SwitchOutWithCallback(function()
            self:DoSwitchIn(TargetTabId, WidgetInfo, table.unpack(SwitchInArgs))
        end, ...)
        return self.CurSubUI
    elseif self.CurSubUI and self.CurSubUI.SwitchOut then
        -- 不支持回调的SwitchOut，直接调用后立即执行SwitchIn
        self.CurSubUI:SwitchOut(...)
    end
    
    -- 立即执行SwitchIn（如果SwitchOut不支持回调或没有SwitchOut）
    self:DoSwitchIn(TargetTabId, WidgetInfo, table.unpack(SwitchInArgs))
    
    return self.CurSubUI
end

-- 执行SwitchIn的内部方法
function Component:DoSwitchIn(TabId, WidgetInfo, ...)
    if TabId then
        -- 如果子界面不存在，创建它
        if not self.SubUI[TabId] then
            if TabId ~= self.MainTabId then
                local Widget = self:CreateWidgetNew(TabId)
                if Widget then
                    Widget.Root = self
                    Widget.WidgetInfo = WidgetInfo
                    -- 设置上一界面信息
                    if self.CurSubUI then
                        Widget.PreWidgetInfo = self.CurSubUI.WidgetInfo
                    end
                    
                    -- 根据RootWidget类型选择添加方式并设置布局
                    if self.Group_Root.AddChildToOverlay then
                        -- Overlay类型：需要设置对齐方式才能正确显示
                        self.Group_Root:AddChildToOverlay(Widget)
                        local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
                        if OverlaySlot then
                            -- 设置全屏填充对齐方式（这是Overlay显示的关键）
                            OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
                            OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
                            OverlaySlot:SetPadding(FMargin(0, 0, 0, 0))
                        end
                    else
                        -- Canvas或其他类型
                        self.Group_Root:AddChild(Widget)
                        local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Widget)
                        if CanvasSlot then
                            -- Canvas Slot布局
                            local Anchors = FAnchors()
                            Anchors.Minimum = FVector2D(0, 0)
                            Anchors.Maximum = FVector2D(1, 1)
                            CanvasSlot:SetOffsets(FMargin(0, 0, 0, 0))
                            CanvasSlot:SetAnchors(Anchors)
                        end
                    end
                    self.SubUI[TabId] = Widget
                end
            else
                -- 主界面使用self
                local Widget = self
                Widget.Root = self
                Widget.WidgetInfo = WidgetInfo
                self.SubUI[TabId] = Widget
            end
        end
        
        -- 切换到新界面
        self.CurTabId = TabId
        self.CurSubUI = self.SubUI[TabId]
        if self.CurSubUI and self.CurSubUI.SwitchIn then
            self.CurSubUI:SwitchIn(...)
            if self.CurSubUI.SetFocus then
                self.CurSubUI:SetFocus()
            end
        end
    else
        -- 如果TabId为空，关闭所有子界面
        self:OnCloseAll()
    end
end

-- 返回上一界面
function Component:ReturnPreWidget()
    -- 当前界面为空或为最后界面时退出
    if not self.CurSubUI or not self.CurSubUI.PreWidgetInfo then
        if self.OnCloseAll then
            self:OnCloseAll()
        end
    elseif self.CurSubUI then
        self:OpenSubUI(self.CurSubUI.PreWidgetInfo)
    end
end

-- 返回按钮点击处理
-- 注意：这个方法可以被重写以添加特定逻辑（如动画检查等）
function Component:OnClickBack()
    -- 如果子界面有自定义的OnReturnKeyDown，优先调用
    if self.CurSubUI and self.CurSubUI ~= self and self.CurSubUI.OnReturnKeyDown then
        self.CurSubUI:OnReturnKeyDown()
    else
        -- 默认返回上一界面
        self:ReturnPreWidget()
    end
end

-- 返回按键处理
function Component:OnReturnKeyDown()
    self:OnClickBack()
end

-- 获取期望的焦点目标
function Component:BP_GetDesiredFocusTarget()
    if self.CurSubUI == self then
        if self.GetDesiredFocusTarget_Main then
            return self:GetDesiredFocusTarget_Main()
        else
            return self
        end
    else
        return self.CurSubUI
    end
end

-- 清理所有子界面
function Component:ClearAllSubUI()
    if self.SubUI then
        for _, Widget in pairs(self.SubUI) do
            -- 主界面不删除
            if Widget ~= self then
                Widget:RemoveFromParent()
            end
        end
    end
    self.SubUI = {}
    self.CurSubUI = nil
    self.CurTabId = nil
end

-- 获取当前子界面
function Component:GetCurrentSubUI()
    return self.CurSubUI
end

-- 获取当前TabId
function Component:GetCurrentTabId()
    return self.CurTabId
end

function Component:InitOtherPageTab(TabConfigData,DontPlayInAnim,Object,Callback)
    self.Com_Tab:Init(TabConfigData,DontPlayInAnim)
    self.Com_Tab:BindEventOnTabSelected(Object, Callback)
end

return Component

