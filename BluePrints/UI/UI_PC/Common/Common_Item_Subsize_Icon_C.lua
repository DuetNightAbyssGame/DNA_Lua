require "UnLua"

-- 代码整合中，需要改动请联系 @Tianyi
---@type Common_Item_Icon_C|Common_Item_Subsize_Small_Base_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Item_Subsize_Small_Base_C")

function M:InitView()
    self:SetIcon()
end

local _RealSetIcon = function(self,Texture)
    if(Texture)then
        self.Img_Icon:SetBrushResourceObject(Texture)
        local __IconDynaMaterial = self.VX_Img_Icon:GetDynamicMaterial()
        if(__IconDynaMaterial)then
            __IconDynaMaterial:SetTextureParameterValue("MainTex", Texture)
        end
    end
end

function M:SetIcon() 
    if(type(self.Icon) == "string")then
        self:LoadTextureAsync(self.Icon,function(Texture)
            if not Texture then
                Texture = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
                DebugPrint(ErrorTag,string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s",self.Icon))
            end
            _RealSetIcon(self,Texture)
        end,"LoadIcon")
    else
        _RealSetIcon(self,self.Icon)
    end
end

-- 下面这些动画理论上要写在基类，但目前基类蓝图动画名称还不一样，后续修改
function M:OnMouseEnter(MyGeometry, MouseEvent)
    if not self.Content then return end
    if self.NotInteractive or self.Content.IsSelect or self.Content.IsShowTips then
        return 
    end
    self.IsHovering = true
    self:StopAnimation(self.UnHover)
    self:PlayAnimationForward(self.Hover)
    -- DebugPrint("Tianyi@ Icon play hover")
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if not self.Content then return end
    if self.NotInteractive or self.Content.IsSelect or self.Content.IsShowTips then
        return
    end
    self.IsHovering = false 
    self:StopAnimation(self.Hover)
    self:PlayAnimationForward(self.UnHover)
    -- DebugPrint("Tianyi@ Icon play unhover")
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    -- 点击显示Tips，且Tips已经显示时
    if self.NotInteractive or (self.IsShowDetails and self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Press)
    if self.HandleMouseDown then 
        return UWidgetBlueprintLibrary.Handled()
    end
    return UWidgetBlueprintLibrary.Unhandled()  
end

function M:OnCloseMenuAnchor(IsNeedMenuChangedCallback)
    -- 关闭菜单锚
    if (self.IsShowDetails and self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) then
        self.ItemDetails_MenuAnchor:ClearMenuOpenChangedListen()
        if (IsNeedMenuChangedCallback) then          
            self.ItemDetails_MenuAnchor:InitMenuOpenChangedListen()
        end
        self.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    else
        self.ItemDetails_MenuAnchor:OnMenuClose(false) 
    end
end

function M:PlayInAnimation()
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.UnHover and not self.IsHovering then 
        self:PlayAnimationForward(self.Normal)
    end
end

return M