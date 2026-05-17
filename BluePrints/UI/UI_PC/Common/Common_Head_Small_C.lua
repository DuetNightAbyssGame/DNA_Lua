--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_Head_Small_C|WBP_Com_ItemHead_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local Handled = UWidgetBlueprintLibrary.Handled()

function M:BindOnClickEvent(Func)
    self.ClickFunc = Func
end

function M:BindOnMouseHover(Func)
    self.HoverFunc = Func
end

--是否保持按下状态
function M:SetHoldUp(bHoldUp)
    self.bHoldUp = bHoldUp
end

function M:Construct()
    self.Button_Area.OnHovered:Add(self, self.BtnAreaOnHovered)
    self.Button_Area.OnUnhovered:Add(self, self.BtnAreaOnUnhovered)
    self.Button_Area.OnReleased:Add(self, self.BtnAreaOnClicked)
    self.Button_Area.OnPressed:Add(self, self.BtnAreaOnPressed)
end

function M:Destruct()
    self.ClickFunc = nil
    self.HoverFunc = nil
    self.bHoldUp = nil
    self.bSelected = nil
    self.Button_Area.OnHovered:Remove(self, self.BtnAreaOnHovered)
    self.Button_Area.OnUnhovered:Remove(self, self.BtnAreaOnUnhovered)
    self.Button_Area.OnReleased:Remove(self, self.BtnAreaOnClicked)
    self.Button_Area.OnPressed:Remove(self, self.BtnAreaOnPressed)
end

function M:BtnAreaOnPressed(MyGeometry, MouseEvent)
    DebugPrint(LXYTag, "Common_Head_Small_C:BtnAreaOnPressed")
    if self.bDisableAction then return Handled end
    if self.bSelected then return Handled end
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
    return Handled
end

function M:SetHeadFrame(HeadFrameId)
    self.HeadFrameId = HeadFrameId
    if not HeadFrameId or HeadFrameId == CommonConst.DefaultNoHeadFrame then
        if not HeadFrameId then
            DebugPrint(LXYTag, "服务端没有同步头像框数据，暂时不显示头像框")
        end
        self.Head_Frame:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return 
    end
    local Conf = DataMgr.HeadFrame[HeadFrameId]
    if not Conf then 
        DebugPrint(LXYTag, "无效的头像框id")
        return 
    end
    UResourceLibrary.LoadObjectAsync(self, Conf.SmallIcon, {self,function(_,IconRes)
        self.Head_Frame:SetBrushResourceObject(IconRes)
    end})
    -- local IconRes = LoadObject(Conf.SmallIcon)
    -- if IconRes ~= nil then
    --     self.Head_Frame:SetBrushResourceObject(IconRes)
    -- end
    self.Head_Frame:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:BtnAreaOnClicked(MyGeometry, MouseEvent)
    DebugPrint(LXYTag, "Common_Head_Small_C:BtnAreaOnClicked")
    if self.bDisableAction then return Handled end
    if self.bHead then
        AudioManager(self):PlayUISound(self, "event:/ui/common/team_avatar_click", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    self.bSelected = true
    if self.ClickFunc then
        self.ClickFunc()
    end
    return Handled
end

function M:SetHeadIcon(HeadIcon, bUseBigHead)
    if bUseBigHead then
        self.Panel_Img:SetActiveWidgetIndex(2)
        local Material = self.Img_Head:GetDynamicMaterial()
        Material:SetTextureParameterValue("IconMap",HeadIcon)
        self.bUseBigHead = true
        return
    end
    self.bUseBigHead = false
    local Material = self.Img_Item:GetDynamicMaterial()
    Material:SetTextureParameterValue("IconMap",HeadIcon)
    --self.Img_Item:SetBrushResourceObject(HeadIcon)
    self.bHead = true
end

function M:SetHeadIconById(HeadIconId, bUseBigHead)
    local HeadData = DataMgr.HeadSculpture[HeadIconId]
    if not HeadData or not HeadData.HeadPath then 
        return 
    end
    UResourceLibrary.LoadObjectAsync(self, HeadData.HeadPath, {self,function(_,HeadIcon)
        self:SetHeadIcon(HeadIcon, bUseBigHead)
    end})
    -- local HeadIcon = LoadObject(HeadData.HeadPath)
    -- if not IsValid(HeadIcon) then 
    --     return 
    -- end
    -- self:SetHeadIcon(HeadIcon, bUseBigHead)
end

function M:SetHeadIconEmpty(bIsEmpty)
	self.bHead = false
    self:StopAllAnimations()
    if (bIsEmpty) then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self.Panel_Img:SetActiveWidgetIndex(3)
        self:PlayAnimation(self.Empty)
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Head_Frame:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        if self.bUseBigHead then
            self.Panel_Img:SetActiveWidgetIndex(2)
        else
            self.Panel_Img:SetActiveWidgetIndex(0)
        end
        self:PlayAnimation(self.Normal)
        self:SetVisibility(UIConst.VisibilityOp.Visible)
        if self.HeadFrameId then
            self.Head_Frame:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:BtnAreaOnHovered()
    DebugPrint(LXYTag, "Common_Head_Small_C:BtnAreaOnHovered")
    if self.bDisableAction then return end
    if (self.bHoldUp and self.bSelected) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
    if self.HoverFunc then
        self.HoverFunc(true)
    end
end

function M:BtnAreaOnUnhovered()
    DebugPrint(LXYTag, "Common_Head_Small_C:BtnAreaOnUnhovered")
    if self.bDisableAction then return end
    if (self.bHoldUp and self.bSelected) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
    if self.HoverFunc then
        self.HoverFunc(false)
    end
end

function M:PlayNormal()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    self.bSelected = false
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Click and not self.bHoldUp then
        self:PlayAnimation(self.Normal)
    elseif Animation == self.UnHover then
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
    end
end

function M:SetGamepadCursor()
    self.Button_Area:SetNavigatePosAngle(0)
    self.Button_Area:SetNavigatePosOffsetPercent(FVector2D(0.5, -0.5))
    self.Button_Area:SetNavigatePosOffsetAlignment(FVector2D(0.5, 0.5))
end

--- 需要禁用点击和Hover行为，仅使用头像功能
function M:SetDisableAction(bDisable)
    self.bDisableAction = bDisable
end


return M


