--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type ItemDetails_MenuAnchor_C
---@field CommonItemDetails Common_ItemDetails_PC
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})
local PC_PADDING = 60
local HoverTimer = nil
local Unhandled = UE4.UWidgetBlueprintLibrary.Unhandled()

function M:OnMenuClose()
    if self.ParentWidget then
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            if self.ParentWidget and self.ParentWidget.Content and self.ParentWidget.Content.bIsResetFocus then
                self.ParentWidget:SetFocus()
            end
        else
            if self.ParentWidget.Normal then
                self.ParentWidget:PlayAnimation(self.ParentWidget.Normal)
            end
        end
        -- if self.ParentWidget.SetSelected and not self.bAllowHover then
        --     self.ParentWidget:SetSelected(false)
        --     return
        -- end
        self.ParentWidget.Content.IsShowTips = false
        self.ParentWidget.Content.IsSelect = false
        self.ParentWidget:StopAllAnimations()
        if self.ParentWidget.VX_Loop then
            self.ParentWidget.VX_Loop:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.ParentWidget.Item then
            self.ParentWidget.Item:PlayAnimation(self.ParentWidget.Item.Normal)
        end
    end
end

function M:Construct()
    -- self.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.OnMenuOpenChanged)
    self:InitMenuOpenChangedListen()
    --初始化PC端的边距设置
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    if Platform == "PC" then
        self.OriginPadding = FMargin(0)
        local Padding = self.ItemDetailsMenuAnchor.ViewportPadding
        self.OriginPadding.Top = Padding.Top
        self.OriginPadding.Bottom = Padding.Bottom
        self.OriginPadding.Left = Padding.Left
        self.OriginPadding.Right = Padding.Right
        Padding.Top = Padding.Top + PC_PADDING
        Padding.Bottom = Padding.Bottom+ PC_PADDING
        self.ItemDetailsMenuAnchor:SetViewportPadding(Padding)
    end
end

function M:InitMenuOpenChangedListen()
    self.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.OnMenuOpenChanged)
end

function M:ClearMenuOpenChangedListen()
    self.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self, self.OnMenuOpenChanged)
end

function M:OnMenuOpenChanged(bIsOpen)
    UIManager(self):SetIsMenuAnchorOpen(bIsOpen)
    if(not bIsOpen) then
        self:OnMenuClose()
    end
end

function M:Destruct()
    self:StopHoverTimer()
    if not self.bMenuClosing then
        self:CloseItemDetailsWidget(true)
    end
    --self:ClearMenuOpenChangedListen()
    ---Umg有UI缓存，ViewportPadding需要重设回去 @todo 改到引擎里去重新还原值
    self.ItemDetailsMenuAnchor:SetViewportPadding(self.OriginPadding)
end

--- 当外部调用该方法时，菜单锚的打开关闭检测应该交给内部管理
---@param bAllowHover boolean 可选，允许悬浮打开菜单锚界面
function M:InitializeSetUp(Parent, Content, bAllowHover)
    self.ParentWidget = Parent
    self.Content = Content
    self.bAllowHover = bAllowHover
    if self.Content then
        self.Content.ItemType = self.Content.Type
        self.Content.ItemId = self.Content.UnitId
    end
end

function M:SetConfirmDesc(ConfirmDesc)
    if self.Content then
        self.Content.ConfirmDesc = ConfirmDesc
    end
end

--- InitializeSetUp的清理接口
function M:ClearSetup()
    self.ParentWidget, self.Content, self.bAllowHover = nil,nil,nil
end

function M:OnMouseEnter(MyGeometry,MouseEvent)
    DebugPrint("Wbp_itemdetails_Menuanchor_c:: OnMouseEnter")
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    if Platform ~= "PC" then return end
    if not self.bAllowHover or not self.Content then return end
    local bIsHover = true
    if ( self.Content.IsSelected~=nil) then
        bIsHover = self.Content.IsSelected~=true
    end
    if( self.ParentWidget.IsSelected~=nil) then
        bIsHover = self.ParentWidget.IsSelected~=true
    end
    self:StopHoverTimer()
    local Delay = 0.15
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        Delay = 0.1
    end
    local _,TimerKey = self:AddTimer(Delay, function()
        self:OpenItemDetailsWidget(bIsHover)
    end,false,0,nil,true)
    HoverTimer = TimerKey
end

function M:OnMouseLeave(MouseEvent)
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    if Platform ~= "PC" then return end
    self:StopHoverTimer()
    if not self.bAllowHover or not self.Content then return end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        return
    end
    self:CloseItemDetailsWidget()
end

-- ZDX 会导致部分大道具框执行两次Open操作
-- function M:OnMouseButtonUp(MyGeometry, MouseEvent)
--     if not self.Content then return Unhandled end
--     self:OpenItemDetailsWidget(false)
--     return Unhandled
-- end

function M:StopHoverTimer()
    if self:IsExistTimer(HoverTimer) then
        self:RemoveTimer(HoverTimer)
    end
    HoverTimer = nil
end

---主动打开菜单锚界面接口
---@param bIsHover boolean 是否由鼠标悬浮触发的
---@param Content table 可选参数，若前面调用了InitializeSetUp，则外部调用时就没必要再传了
function M:OpenItemDetailsWidget(bIsHover, Content)
    DebugPrint("ItemDetails_MenuAnchor:: OpenItemDetailsWidget")
    if self.Content then Content = self.Content end
    if not Content then return end
    if not Content.IsShowDetails and self.Content then return end
    --点击的时候不希望打开tips
    if not bIsHover and Content.bDontOpenTipsWhenClick then return end
    if self.bAllowRetain and self.ItemDetailsMenuAnchor:IsOpen() then return end
    Content.bIsHoverState = bIsHover
    if(Content.MenuPlacement)then
        self.ItemDetailsMenuAnchor:SetPlacement(Content.MenuPlacement)
    end

    if (self.IsRevertShear) then
        local Transform = self.ItemDetailsMenuAnchor.RenderTransform
        Transform.Shear.X = -self.RenderTransform.Shear.X
        self.ItemDetailsMenuAnchor:SetRenderTransform(Transform)
    end

    self.ItemDetailsMenuAnchor:Open(not bIsHover)
    if self.CommonItemDetails then
        self.CommonItemDetails.Parent = self.ItemDetailsMenuAnchor
        self.CommonItemDetails.ParentWidget = self
        if self.ParentWidget then
            self.CommonItemDetails.UIName = self.ParentWidget.UIName
        end
        self.CommonItemDetails:RefreshItemInfo(Content)
    end
end

function M:ExecuteOnGuideTouchOpen()
    self.OriginbAllowHover= self.bAllowHover
    self.bAllowHover = false
    self.bGuideState = true
    if self.ItemDetailsMenuAnchor.SetUseApplicationMenuStack then
        self.ItemDetailsMenuAnchor:SetUseApplicationMenuStack(false)
    end
end

function M:ExecuteOnGuideTouchClose()
    self:OpenItemDetailsWidget(false)
end

---主动关闭菜单锚界面接口
function M:CloseItemDetailsWidget(bForce)
    self.bMenuClosing = true
    if not (self.ItemDetailsMenuAnchor:IsOpen()) then return end
    if self.bAllowRetain and not bForce then return end
    self.ItemDetailsMenuAnchor:Close()
    if self.LastFocusWidget then
        self.LastFocusWidget:SetFocus()
        -- UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.LastFocusWidget)
    end
    if self.bGuideState then
        if self.ItemDetailsMenuAnchor.SetUseApplicationMenuStack then
            self.ItemDetailsMenuAnchor:SetUseApplicationMenuStack(true)
        end
        self.bGuideState = nil
        self.bAllowHover = self.OriginbAllowHover
    end
end

-- 从菜单锚界面返回之后，光标应该移动到哪个控件
function M:SetLastFocusWidget(Widget)
    self.LastFocusWidget = Widget
end

---菜单锚界面是否暂留
function M:SetAllowRetain(bAllowRetain)
    self.bAllowRetain = bAllowRetain
end

---是否还原Shear
function M:SetRevertShear(IsRevertShear)
    self.IsRevertShear = IsRevertShear
end

function M:SetAllowHover(bAllowHover)
    self.bAllowHover = bAllowHover
    self:StopHoverTimer()
end

---@todo 应用窗口激活的时候需要考虑将菜单锚还原

return M