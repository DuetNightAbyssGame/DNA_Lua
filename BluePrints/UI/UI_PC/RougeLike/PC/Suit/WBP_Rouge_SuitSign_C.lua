--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_SuitSign_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.ItemMenuAnchorChanged)
end

function M:Destruct()
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.ItemMenuAnchorChanged)

end

function M:BindEventOnMenuOpenChanged(Obj, OnMenuOpenChangedFunc)
    self.Obj = Obj
    self.OnMenuOpenChangedFunc = OnMenuOpenChangedFunc
end

function M:InitSuitSign(TreasureId, GroupId, Count, bPreview)
    local TreasureGroupData = DataMgr.TreasureGroup[GroupId]
    if TreasureGroupData then
        local IconObj = LoadObject(TreasureGroupData.Icon)
        assert(IconObj, "未找到对应TreasureGroup的Icon:"..GroupId)
        self.Image_TitleIcon:SetBrushResourceObject(IconObj)
        
        local TreasureNum = UIUtils.GetTreasureGroupNum(TreasureId)
        local Text = "<G>"..tostring(Count).."</>/"..tostring(TreasureNum)
        if TreasureNum > 0 then
            self.Text_SuitTitle:SetText(Text)
            self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)        
        end
        local bRealActive = false
        if not bPreview and Count == TreasureNum then
            bRealActive = true
        end
        self.Content = {ItemType = "TreasureGroup", ItemId = GroupId,MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight}
        self.Com_BtnQa:Init(
        {
            OwnerWidget  = self,
            ClickCallback = function ()
                if GroupId then
                    local Content = {ItemType = "TreasureGroup", ItemId = GroupId,MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight, bActive = bRealActive}
                    self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
                end
            end
        })   
    else
        ScreenPrint("未找到对应TreasureGroup信息：" .. GroupId)
    end
end

function M:ItemMenuAnchorChanged(bOpen)
    if self.OnMenuOpenChangedFunc then
        self.OnMenuOpenChangedFunc(self.Obj, bOpen)
    end
end

function M:OnGamePadDown(InKeyName)
    if InKeyName == UIConst.GamePadKey.LeftThumb then
        self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, self.Content)
        return UIUtils.Handled
    end
end

return M
