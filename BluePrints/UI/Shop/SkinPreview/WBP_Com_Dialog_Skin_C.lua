require "UnLua"

---@class WBP_Com_Dialog_Skin_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

---@param Params Common_Dialog_Params
function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    
    self:AddInputMethodChangedListen()
    for i = 1, #Params.ItemId do
        local ShopType = Params.ItemType[i]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        -- local Content = NewObject(self.ShopItemContentClass)
        if ShopType == "CharAccessory" then
            Content.ItemId = Params.ItemId[i]
            Content.ItemType = "CharAccessory"
            Content.Icon = DataMgr.CharAccessory[Params.ItemId[i]].Icon
            Content.Name = DataMgr.CharAccessory[Params.ItemId[i]].Name
        elseif ShopType == "WeaponAccessory" then
            Content.ItemId = Params.ItemId[i]
            Content.ItemType = "WeaponAccessory"
            Content.Icon = DataMgr.WeaponAccessory[Params.ItemId[i]].Icon
            Content.Name = DataMgr.WeaponAccessory[Params.ItemId[i]].Name
        elseif ShopType == "WeaponSkin" then
            Content.ItemId = Params.ItemId[i]
            Content.ItemType = "WeaponSkin"
            Content.Icon = DataMgr.WeaponSkin[Params.ItemId[i]].Icon
            Content.Name = DataMgr.WeaponSkin[Params.ItemId[i]].Name
        elseif ShopType == "Skin" then
            Content.ItemId = Params.ItemId[i]
            Content.ItemType = "Skin"
            Content.Icon = DataMgr.Skin[Params.ItemId[i]].Icon
            Content.Name = DataMgr.Skin[Params.ItemId[i]].SkinName
        end
        self.CommonTileView_Rewards:AddItem(Content)
    end
    self.CommonTileView_Rewards:RequestRefresh()
    -- self.CommonTileView_Rewards:SetControlScrollbarInside(true)
    -- self.CommonTileView_Rewards.bIsFocusable = false

    self:ShowGamepadShortcutBtn({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A",
            },
        },
        Desc = GText("UI_GACHA_DESDETAIL")
    })
end

-- 处理弹窗被聚焦事件，若有返回控件，则会聚焦在返回控件上
function M:HandleDialogFocused()
    return self.CommonTileView_Rewards
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if self:HasAnyFocus() then
        self.CommonTileView_Rewards:SetFocus()
    end
end

-- 用于监听键盘按下事件
function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
end



return M