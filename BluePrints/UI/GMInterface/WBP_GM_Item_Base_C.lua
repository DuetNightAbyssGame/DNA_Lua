--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
--GM指令UI里所有Item的基类
--Item中保存着自身的Command对象
require "UnLua"
local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
local WBP_GM_Item_Base_C = Class("BluePrints.UI.BP_EMUserWidget_C")

--设置当前Item的样式，如需定制样式可以在子类重写此方法
function WBP_GM_Item_Base_C:SetItem()
    if(self.Arrow)then
        self.Arrow:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    if(self.Command.Mode == "button")then
        self.Text_Name_Btn:SetText(self.Command.Text)
    elseif(self.Command.Mode == "switch")then
        if(self.Command.IsEnable)then
            self.Text_Name_Btn:SetText(self.Command.Text.."：开")
        else
            self.Text_Name_Btn:SetText(self.Command.Text.."：关")
        end
    elseif(self.Command.Mode == "edit")then
        if(self.Text_Name_Para)then
            self.Text_Name_Para:SetText(self.Command.Text)
        end
    elseif(self.Command.Mode == "menu")then
        self.Text_Name_Btn:SetText(self.Command.Text)
        if(self.Arrow)then
            self.Arrow:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
        end
        if(self.Command.Parameters:Length() <= 0)then
            --创建非全屏子菜单
            if(not IsValid(self.SubMenuWidget))then
                self.Command.SubMenuWidget = self:CreateMenuWidget()
            end
        end
    elseif(self.Command.Mode == "text")then
        for i=1,10 do
            if(self["Text_Name_"..i])then
                self["Text_Name_"..i]:SetText(self.Command.Parameters[i])
            else
                break
            end
        end
    end
    if(self.WidgetSwitcher)then
        if(self.Command.Mode == "edit")then
            self.WidgetSwitcher:SetActiveWidgetIndex(1)
        else
            self.WidgetSwitcher:SetActiveWidgetIndex(0)
        end
    end
    if(self.Command.ParentWidget)then
        --通知父控件Entry的数量改变了
        self.Command.ParentWidget:OnEntryNumChanged(self)
    end
end

function WBP_GM_Item_Base_C:OnSelfRemove()
    if(self.MenuAnchor and self.MenuAnchor:IsOpen())then
        self.MenuAnchor:Close()
    end
end

function WBP_GM_Item_Base_C:Exec(...)
    UIUtils.PlayCommonBtnSe(self)
    if(self.Command.CloseGM == true)then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        local GMPanel =  UIManager:GetUIObj("GMCommandPanel")
        GMPanel:CloseAllMenus()
        GMPanel:Close()
    end
    self.Command.IsEnable = not self.Command.IsEnable
    if(self.Command.Callback~=nil and self.Command.Callback~="")then
        GMFunctionLibrary.Exec(self,self.Command,...)
    end
    if(self.Command.Mode == "switch")then
        if(self.Command.VarName ~= "")then
            self.Command.IsEnable = GMVariable[self.Command.VarName]
        end
        if(self.Command.IsEnable)then
            self.Text_Name_Btn:SetText(self.Command.Text.."：开")
        else
            self.Text_Name_Btn:SetText(self.Command.Text.."：关")
        end
    elseif(self.Command.Mode == "menu")then
        self:SubMenuToggleOpen()
    end
end

function WBP_GM_Item_Base_C:SubMenuToggleOpen()
    if(self.Command.Parameters:Length() > 0)then
        --全屏菜单
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManger = GameInstance:GetGameUIManager()
        UIManger:LoadUI(self.Command.Parameters[1],self.Command.Parameters[2], UIConst.ZORDER_FOR_SECONDARY_POPUP,self.Command)
    else
        local SubMenuWidget = self.Command.SubMenuWidget
        if(SubMenuWidget == nil or self.MenuAnchor == nil)then
            UE4.UWidgetBlueprintLibrary.DismissAllMenus()
            return
        end
        if(self.MenuAnchor:IsOpen())then
            self.MenuAnchor:Close()
            SubMenuWidget:OnClose()
        else
            self.MenuAnchor:Open(true)
            SubMenuWidget:OnOpen()
            --设置菜单的位置
            local geometry = self.MenuAnchor:GetTickSpaceGeometry()
            local topleft = UE4.USlateBlueprintLibrary.GetLocalTopLeft(geometry)
            local vPos,_ = UE4.USlateBlueprintLibrary.LocalToViewport(self,geometry,topleft)
            local viewportSize = UE4.UWidgetLayoutLibrary.GetViewportSize(self)
            if (vPos.X > (viewportSize.X/2))then
                    --如果菜单在左侧显示，则向左移动菜单的“所需宽度”+菜单锚的宽度(注：这里的“所需宽度”不是屏幕中的实际占宽，而是该子菜单蓝图中最外层的设置宽度)
                    local MA_Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.MenuAnchor)
                    local offset = MA_Slot:GetSize()
                    local DesiredSize = SubMenuWidget:GetDesiredSize()
                    local Trans = DesiredSize
                    Trans.X = Trans.X*-1 - offset.X
                    Trans.Y = 0
                    SubMenuWidget:SetRenderTranslation(Trans)
            end
        end
    end
end

return WBP_GM_Item_Base_C
