require "UnLua"

---@type WBP_Shop_SkinPreview_M_C
local M = Class("BluePrints.UI.Shop.SkinPreview.WBP_Shop_SkinPreview_Base_C")

function M:Construct()
    M.Super.Construct(self)

    self.Btn_HideUI.Btn_Click.OnClicked:Add(self,self.OnHideUIKeyDown)
    self.Btn_HideUI.Text_Btn:SetText(GText("UI_CameraSystem_HideUI"))

    self.Btn_Riding.Btn_Click.OnClicked:Add(self,self.OnRideMount)
    self.Btn_Riding.Text_Btn:SetText(GText("UI_CTL_Ride"))
    self.WS_Ride:SetActiveWidgetIndex(1)

    -- self.WBP_MountsMainBtn.Btn_Hide:BindEvents(self, {
    --     OnClicked = self.OnHideUIKeyDown,
    -- })
    -- self.WBP_MountsMainBtn.Btn_Riding:BindEvents(self, {
    --     OnClicked = self.OnRideMount,
    -- })
    self.WBP_MountsMainBtn:SetVisibility(UIConst.VisibilityOp["Collapsed"])

    local DyeIconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Dye.T_Tab_Dye'"
    local ReplayIconPath = "Texture2D'/Game/UI/Texture/Static/Atlas/Shop/T_Shop_Refresh.T_Shop_Refresh'"
    self.IconCache = {}
    self.IconCache.Dye = LoadObject(DyeIconPath)
    self.IconCache.Replay = LoadObject(ReplayIconPath)
end

function M:InitKeySetting()
    M.Super.InitKeySetting(self)

    self.KeyDownEvents = {}
    self.RepeatKeyDownEvents = {}
end

function M:UpdateUI()
    M.Super.UpdateUI(self)

    self.Tab_Skin.Panel_Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Com_Hint.bAutoButtonChange = false
end

function M:OnRideMount()
    M.Super.OnRideMount(self)
    if self.IsRiderMount then
        self.WS_Ride:SetActiveWidgetIndex(1)
    else
        self.WS_Ride:SetActiveWidgetIndex(0)
    end
end

--- 更新重播按键，子类实现
function M:UpdateReplayTips()
    if self.ShopItemData.ItemType == "Mount" then
        -- self.WBP_MountsMainBtn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Riding:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Dye:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_HideUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif self.ShopItemData.ItemType == "Resource" then
        -- 是动作: 按钮变为“重播”
        self:SetDyeIcon(false)
        if self.ShopItemData.ResourceSType == "GestureItem" then
            self.Text_Color:SetText(GText("UI_Replay"))
            self.Btn_Selective.OnClicked:Add(self, self.OnReplayGesture)

            -- self.WBP_MountsMainBtn:SetVisibility(ESlateVisibility.Collapsed)
            self.Btn_Riding:SetVisibility(ESlateVisibility.Collapsed)
            self.Btn_Dye:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Btn_HideUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    elseif self.ShopItemData.ItemType == "WeaponAccessory" or self.ShopItemData.ItemType == "CharAccessory" then
        -- 是不可染色的配饰: 隐藏按钮
        -- self.WBP_MountsMainBtn:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Riding:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Dye:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_HideUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        -- 其他情况: 按钮为“染色”
        self:SetDyeIcon(true)
        self.Text_Color:SetText(GText("UI_SkinPreview_Dye"))
        self.Btn_Selective.OnClicked:Add(self, self.OnClickDyeingPreview)

        -- self.WBP_MountsMainBtn:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Riding:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Dye:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_HideUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

--- 设置图标
function M:SetDyeIcon(IsDyeIcon)
    local IconObject = IsDyeIcon and self.IconCache.Dye or self.IconCache.Replay
    if IconObject and self.Img_Dye then
        self.Img_Dye:SetBrushResourceObject(IconObject)
    end
end

--- 输入模式切换
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    M.Super.OnUpdateUIStyleByInputTypeChange(self,CurInputDevice, CurGamepadName)
end

function M:Destruct()
    self.IconCache = nil
    M.Super.Destruct(self)
end

return M