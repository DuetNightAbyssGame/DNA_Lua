--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@class Common_ItemDetails_Params @物品信息
---@field ItemType string @物品类型
---@field ItemId number @物品ID
---@field Uuid string @物品UUID
---@field DetailsButtonText string @详情按钮文本
---@field DetailsButtonClickCallback function @详情按钮点击回调
---@field IsArmoryMod boolean @是否是军械库Mod
---@field Parent UMenuAnchor

local Handled = UE4.UWidgetBlueprintLibrary.Handled()

---@type WBP_Com_Tips_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    M.Super.Construct(self)
    self.Panel_Detail:SetRenderOpacity(0)
    self.bIsFocusable = true
    self:PlayAnimation(self.In)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self:OverrideSizeX(self.PhoneSizeBoxWidth)
    else
        self:OverrideSizeX(self.PCSizeBoxWidth)
    end
    self.bShowLock = false
    self.Text_WeaponLevel01:SetText(GText("UI_LEVEL_NAME"))
    self.Text_Level01:SetText(GText("UI_LEVEL_NAME"))
    self.Text_Method:SetText(GText("UI_Tips_Obtining"))
    self.Line:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:AddInputMethodChangedListen()

    self.Btn02_Mod:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn01_Mod:SetVisibility(ESlateVisibility.Collapsed)
    self.Img_Aura:SetVisibility(ESlateVisibility.Collapsed)
    self.List_ModStar:SetVisibility(UIConst.VisibilityOp.Collapsed)

    self.Btn02PadKey = UIConst.GamePadKey.FaceButtonTop
    self.Btn01PadKey = UIConst.GamePadKey.FaceButtonLeft
    self.LockPadKey = UIConst.GamePadKey.SpecialRight
    self._bFocusOnce = true
end

function M:Destruct()
    self.btn02_mod:UnBindEventOnClickedByObj(self)
    self.btn01_mod:UnBindEventOnClickedByObj(self)
    self.Btn_Locked:UnBindEventOnReleased(self, self._BtnLockedReleased)
    self.Btn_Locked:UnBindEventOnPressed(self, self._BtnLockedPressed)
    M.Super.Destruct(self)
end

function M:InitItemBaseInfo(ItemInfo)
    self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))
    self.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    -- 设置稀有度颜色
    local FontMaterial = self.Text_ItemName:GetDynamicFontMaterial()
    if ItemInfo.Rarity == 6 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_6)
    elseif ItemInfo.Rarity == 5 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_5)
    elseif ItemInfo.Rarity == 4 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_4)
    elseif ItemInfo.Rarity == 3 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_3)
    elseif ItemInfo.Rarity == 2 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_2)
    elseif ItemInfo.Rarity == 1 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_1)
    else
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_0)
    end

    -- 设置名称
    self.Text_ItemName:SetText(GText(ItemInfo.Name or ItemInfo[self.Type.."Name"]))
end

---@param Content Common_ItemDetails_Params @物品信息
---@param Content.bNotShowAccess               @不需要显示获取途径
---@param Content.bCustomStype              @不使用默认的类型显示按钮（如配饰的预览按钮）
---@param Content.bNotFocus                 @不自动获取焦点
function M:RefreshItemInfo(Content ,bNotFocus, bInitLockedEvent)
    self.Content = Content
    if not Content.IsArmoryMod  and not bNotFocus and self._bFocusOnce then
        self:SetFocus()
        self._bFocusOnce = false
    end
    self.Btn02_Mod:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn01_Mod:SetVisibility(ESlateVisibility.Collapsed)
    self.EMScrollBox_1:ScrollToStart()
    self.Type = Content.ItemType or Content.Type
    self.ItemId = Content.ItemId or Content.Id or Content.UnitId
    if Content.HandleKeyDown ~= nil then
        self.HandleKeyDown = Content.HandleKeyDown
    else
        self.HandleKeyDown = true
    end
    self.KeyDownEvent = Content.ItemDetailKeyDownEvent or Content.KeyDownEvent
    self.OnAddedToFocusPathEvent = Content.OnItemDetailAddedToFocusPathEvent or Content.OnAddedToFocusPathEvent
    self.OnRemovedFromFocusPathEvent = Content.OnItemRemovedFromFocusPathEvent or Content.OnRemovedFromFocusPathEvent
    self.Content = Content
    self.JumpReturnCallBack = Content.JumpReturnCallBack
    --- 初始化公共部分信息
    if self.Type ~= "Tips" then
        local ItemInfo = nil
        if self.ItemId then
            ItemInfo = DataMgr[self.Type][self.ItemId]
            assert(ItemInfo, "没有找到物品信息"..self.Type..","..self.ItemId)
        else
            ItemInfo = {Name = Content.Name}
        end
        self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))

        -- 设置稀有度颜色
        local Rarity = ItemInfo.Rarity or ItemInfo[self.Type.."Rarity"]
        if not Rarity then -- 尝试取搜打撤宝物稀有度
            if ItemInfo and ItemInfo.TreasureRarity 
            and DataMgr.ExtractionTreasureRarity[ItemInfo.TreasureRarity] 
            and DataMgr.ExtractionTreasureRarity[ItemInfo.TreasureRarity].ShowRarity then
                Rarity = DataMgr.ExtractionTreasureRarity[ItemInfo.TreasureRarity].ShowRarity
            end
        end
        if Rarity == 6 then
            self.OutLine_Quality:SetBrushFromTexture(self.Img_Line_6)
        elseif Rarity == 5 then
            self.OutLine_Quality:SetBrushFromTexture(self.Img_Line_5)
        elseif Rarity == 4 then
            self.OutLine_Quality:SetBrushFromTexture(self.Img_Line_4)
        elseif Rarity == 3 then
            self.OutLine_Quality:SetBrushFromTexture(self.Img_Line_3)
        elseif Rarity == 2 then
            self.OutLine_Quality:SetBrushFromTexture(self.Img_Line_2)
        elseif Rarity == 1 then
            self.OutLine_Quality:SetBrushFromTexture(self.Img_Line_1)
        end


        local FontMaterial = self.Text_ItemName:GetDynamicFontMaterial()
        if Rarity == 6 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_6)
        elseif Rarity == 5 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_5)
        elseif Rarity == 4 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_4)
        elseif Rarity == 3 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_3)
        elseif Rarity == 2 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_2)
        elseif Rarity == 1 then
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_1)
        else
            FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_0)
        end
        if not Rarity or Rarity == 0 then
            self.OutLine_Quality:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.OutLine_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        -- 设置名称
        self.Text_ItemName:SetText(GText(ItemInfo.Name or ItemInfo[self.Type.."Name"]))
    end

    --- 加载对应Tips蓝图
    self:InitItemDetails(self.Type, self.ItemId, Content.Uuid)
    self.Panel_Controller:SetVisibility(ESlateVisibility.Collapsed)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    self:OnUpdateUIStyleByInputTypeChange(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())

    if bInitLockedEvent then
        self.Btn_Locked:ForbidBtn(false)
        if not Content.LockType then
            self.Key_Lock:SetVisibility(ESlateVisibility.Collapsed)
            self.Btn_Locked:SetVisibility(ESlateVisibility.Collapsed)
        else
            if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
                self.Key_Lock:SetVisibility(ESlateVisibility.Visible)
            end
            self.Btn_Locked:SetVisibility(ESlateVisibility.Visible)
            self:InitLockedEvent(Content)
            self.bLocked = Content.IsLocked
            if Content.IsLocked then
                self.Switcher_Lock:SetActiveWidgetIndex(0)
            else
                self.Switcher_Lock:SetActiveWidgetIndex(1)
            end
        end
    end
end

function M:OverrideSizeX(SizeX)
    self.SizeBox:SetWidthOverride(SizeX)
end

function M:InitItemDetails(ItemType, ItemId, Uuid)

    self.VerticalBox_Info:ClearChildren()
    self.Switch_Show:SetActiveWidgetIndex(0)

    local Avatar = GWorld:GetAvatar()
    -- 默认无按钮
    self.Panel_Extra:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Switch_Bg:SetActiveWidgetIndex(0)
    self.Switch_Frame:SetActiveWidgetIndex(0)
    --- 检查Content是否存在点击回调，如果有回调则显示按钮并绑定回调
    --- @note 建议在对应ItemType的子蓝图实现这些逻辑，并不是所有tips都需要按钮
    if(self.Content and self.Content.DetailsButtonClickCallback)then
        self.Switch_Bg:SetActiveWidgetIndex(1)
        self.Switch_Frame:SetActiveWidgetIndex(1)
        self.Panel_Extra:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Line:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn02_Mod:SetVisibility(ESlateVisibility.Visible)
        self.btn02_mod:SetText(self.Content.DetailsButtonText)
        self.btn02_mod:BindEventOnClicked(self.Content.Parent,self.Content.DetailsButtonClickCallback,self.Content)
    end

    local ItemInfoWidget
    if ItemType == "Mod" then
        if(self.Content.IsArmoryMod) then
            ItemInfoWidget = self:CreateWidgetNew('ArmoryModItemDetails')
        else
            ItemInfoWidget = self:CreateWidgetNew('ModItemDetails')
        end
        local HaloMod = DataMgr.Mod[self.ItemId]
        if HaloMod and HaloMod.ApplySlot and #HaloMod.ApplySlot == 1 and HaloMod.ApplySlot[1] == 9 then
            self.Img_Aura:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Img_Aura:SetVisibility(ESlateVisibility.Collapsed)
        end
    elseif ItemType == "Tips" or ItemType == "Resource" or ItemType == "CharAccessory" or ItemType == "WeaponAccessory" or ItemType == "CharPartMesh" or ItemType == "RougeLikeBlessing" or ItemType == "RougeLikeTreasure"
            or ItemType == "HeadSculpture" or ItemType == "HeadFrame" or ItemType == "Skin" or ItemType == "WeaponSkin" or ItemType == "Title" or ItemType == "TitleFrame" or ItemType == "Mount" then
        -- Resource如果是魅影，且拥有该角色
        if Avatar.Resources[ItemId] and Avatar.Resources[ItemId]:IsInfiniteBattleItem() and self:IsHasChar(ItemId) then
            self.Switch_Show:SetActiveWidgetIndex(1)
            ItemInfoWidget = self:CreateWidgetNew('PhantomItemDetails')
        else
            self.Panel_Extra:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Switch_Bg:SetActiveWidgetIndex(0)
            self.Switch_Frame:SetActiveWidgetIndex(0)
            ItemInfoWidget = self:CreateWidgetNew('ResourceItemDetails')
        end
    elseif ItemType == "Draft" then
        -- self.Panel_Extra:SetVisibility(UIConst.VisibilityOp.Visible)
        -- self.Switch_Bg:SetActiveWidgetIndex(1)
        ItemInfoWidget = self:CreateWidgetNew('DraftItemDetails')
    elseif ItemType == "Weapon"  then
        self.Switch_Show:SetActiveWidgetIndex(2)
        ItemInfoWidget = self:CreateWidgetNew('WeaponItemDetails')
    elseif ItemType == "Reward" then
        ItemInfoWidget = self:CreateWidgetNew('RewardItemDetails')
    elseif ItemType == "Pet" then
        self.Switch_Show:SetActiveWidgetIndex(2)
        ItemInfoWidget = self:CreateWidgetNew('PetItemDetails')
    elseif ItemType == "TreasureGroup" then
        self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        if not self.Content.bGuide then
            self.Text_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Panel_Hold:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Switch_Show:SetActiveWidgetIndex(4)
            if self.Content.bActive then
                self.Text_Describe:SetText(GText("RLGroup_Active"))
            else
                self.Text_Describe:SetText(GText("RLGroup_InActive"))
            end
        else
            self.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        end
        ItemInfoWidget = self:CreateWidgetNew('DescribeDetails')
        ItemInfoWidget.Text_Describe:SetText(GText(DataMgr.TreasureGroup[ItemId].GroupEffectDesc))
        self.VerticalBox_Info:AddChild(ItemInfoWidget)
        return
    elseif ItemType == "ExtractionTreasure" then
        self.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        ItemInfoWidget = self:CreateWidgetNew('ExtractionTreasureDetails')
    elseif self.Parent then
        self.Parent:Close()
        return
    end

    if (ItemType == "Resource" or (ItemType == "Mod" and not self.Content.IsArmoryMod) or ItemType == "CharPartMesh" or ItemType == "Draft") and (not self.Content.bNotShowAccess) then
        self:SetAccessItem(ItemType, ItemId)
    else
        self.Panel_Method:SetVisibility(UIConst.VisibilityOp.Collapsed) -- 不支持的类型，隐藏掉获取途径
    end

    if ItemInfoWidget then
        self.ItemInfoWidget = ItemInfoWidget
        ItemInfoWidget.ParentWidget = self
        ItemInfoWidget:InitItemInfo(ItemType, ItemId, Uuid, self.Content)
        self.VerticalBox_Info:AddChild(ItemInfoWidget)
    end
end

function M:SetAccessItem(ItemType,ItemId)
    self.Method:ClearChildren(ItemType, ItemId)
    local ItemInfo = DataMgr[ItemType][ItemId]
    assert(ItemInfo, "不存在该物品：", ItemType, ItemId)
    self.Key_Controller_Method:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Method:SetVisibility(ESlateVisibility.Collapsed)
    -- 获取途径
    if ItemInfo.AccessKey then
        for _, Access in pairs(ItemInfo.AccessKey) do
            PageJumpUtils:GetItemAccess(self, ItemId, ItemType, Access, self.Content.UIName, self.JumpReturnCallBack)
        end
        PageJumpUtils:SortAccessItem(self.Method)
        if self.Method:GetChildrenCount() > 0 then
            self.Panel_Method:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            local CurMode =  UIUtils.UtilsGetCurrentInputType()
            if CurMode == ECommonInputType.Gamepad and self:GetFirstJumpItem() then
                self.Key_Controller_Method:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
        end
    end
end

function M:IsHasChar(ItemId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        for _, v in pairs(Avatar.Chars) do
            if v.CharId == DataMgr.Resource[ItemId].UseParam then
                return true
            end
        end
    end
    return false
end

--region 按钮相关

--- 存在按钮时修改Tips的样式
function M:InitButtonStyle()
    self.Switch_Bg:SetActiveWidgetIndex(1)
    self.Switch_Frame:SetActiveWidgetIndex(1)
    self.Panel_Extra:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Panel_Button:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Line:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

--- 真正绑定按钮事件逻辑
function M:RealInitButtonEvent(Widget, ButtonClickCallBack, ButtonClickText, bNotCloseTips)
    local CallBack = function()
        if not bNotCloseTips and self.ParentWidget then
            self.ParentWidget:CloseItemDetailsWidget(true)
        end
        ButtonClickCallBack()
    end
    self:InitButtonStyle()
    Widget:SetText(GText(ButtonClickText))
    Widget:UnBindEventOnClickedByObj(self)
    Widget:BindEventOnClicked(self, CallBack)
end

--- 绑定右按钮点击事件
---@param ButtonClickCallBack function @按钮点击回调
---@param ButtonClickText string @按钮文本
---@param ButtonClickPadKey string @按钮对应手柄按键（选填）
---@param bNotCloseTips boolean @点击后是否关闭Tips（选填）
---@param ButtonIcon number @按钮图标：0: 不显示 1：蓝色放大镜；2：黄色圆圈；3：黄色双三角
---@param Content
function M:InitButtonEvent(Content)
    if not Content or not Content.ButtonClickCallBack then
        return
    end
    self.Btn02_Mod:SetVisibility(ESlateVisibility.Visible)
    if Content.ButtonClickPadKey then
        self.Btn02PadKey = Content.ButtonClickPadKey
    end
    self.WS_Icon_R:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if Content.ButtonIcon == 1 then
        self.WS_Icon_R:SetActiveWidgetIndex(0)
    elseif Content.ButtonIcon == 2 then
        self.WS_Icon_R:SetActiveWidgetIndex(1)
    elseif Content.ButtonIcon == 3 then
        self.WS_Icon_R:SetActiveWidgetIndex(2)
    else
        self.WS_Icon_R:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Btn02_Mod:SetGamePadImg(DataMgr.KeyboardText[self.Btn02PadKey].KeyText)
    self:RealInitButtonEvent(self.Btn02_Mod, Content.ButtonClickCallBack, Content.ButtonClickText, Content.bNotCloseTips)
end

function M:HideButtons()
    self.Panel_Extra:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Button:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn02_Mod:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn01_Mod:SetVisibility(ESlateVisibility.Collapsed)
end

--- 绑定左按钮点击事件
---@param ButtonClickCallBack function @按钮点击回调
---@param ButtonClickText string @按钮文本
---@param ButtonClickPadKey string @按钮对应手柄按键（选填）
---@param bNotCloseTips boolean @点击后是否关闭Tips
---@param Content
function M:InitButton01Event(Content)
    if not Content or not Content.ButtonClickCallBack then
        return
    end
    self.Btn01_Mod:SetVisibility(ESlateVisibility.Visible)
    if Content.ButtonClickPadKey then
        self.Btn01PadKey = Content.ButtonClickPadKey
    end
    self.WS_Icon_L:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if Content.ButtonIcon == 1 then
        self.WS_Icon_L:SetActiveWidgetIndex(0)
    elseif Content.ButtonIcon == 2 then
        self.WS_Icon_L:SetActiveWidgetIndex(1)
    elseif Content.ButtonIcon == 3 then
        self.WS_Icon_L:SetActiveWidgetIndex(2)
    else
        self.WS_Icon_L:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Btn01_Mod:SetGamePadImg(DataMgr.KeyboardText[self.Btn01PadKey].KeyText)
    self:RealInitButtonEvent(self.Btn01_Mod, Content.ButtonClickCallBack, Content.ButtonClickText, Content.bNotCloseTips)
end

--- 绑定锁定按钮点击事件
---@param LockedButtonClickCallBack function @按钮点击回调
---@param LockPadKey string @按钮对应手柄按键（选填）
---@param Content
function M:InitLockedEvent(Content)
    if not Content or not Content.LockedButtonClickCallBack then
        return
    end
    if Content.LockPadKey then
        self.LockPadKey = Content.LockPadKey
    end
    self.bShowLock = true
    self.Btn_Locked:SetVisibility(ESlateVisibility.Visible)
    self.Switcher_Lock:SetActiveWidgetIndex(1)
    self.bLocked = false
    
    self.Btn_Locked:UnBindEventOnReleased(self, self._BtnLockedReleased)
    self.Btn_Locked:UnBindEventOnPressed(self, self._BtnLockedPressed)
    self.Btn_Locked:BindEventOnPressed(self, self._BtnLockedPressed)
    self.Btn_Locked:BindEventOnReleased(self, self._BtnLockedReleased, Content)
end

function M:_BtnLockedPressed()
    self:OnMouseButtonDown()
end

function M:_BtnLockedReleased(Content)
    local SetLock = function(bLock)
        self.bLocked = bLock
        if self.bLocked then
            self.Switcher_Lock:SetActiveWidgetIndex(0)
        else
            self.Switcher_Lock:SetActiveWidgetIndex(1)
        end
    end

    local bWaitRPCRet = Content.bWaitRPCRet
    Content.LockedButtonClickCallBack(SetLock)
    if bWaitRPCRet then
        return
    end
    SetLock(not self.bLocked)
end

--- 显示冲突文本
---@param bShow boolean @是否显示
---@param Text string   @显示的文本
---@param ColorNumber number  @标识颜色 0 or nil：白色 1：红色 2：黄色
function M:SetConflictLine(bShow, Text, ColorNumber)
    if bShow then
        self.Line:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Line.Text_Level:SetText(GText(Text))
        if ColorNumber == 1 then
            self.Line.Bg02:SetColorAndOpacity(self.Line.Red)
        elseif ColorNumber == 2 then
            self.Line.Bg02:SetColorAndOpacity(self.Line.Yellow)
        else
            self.Line.Bg02:SetColorAndOpacity(self.Line.White)
        end
    else
        self.Line:SetVisibility(ESlateVisibility.Collapsed)
    end
end


function M:GetFirstJumpItem()
    local Items = self.Method:GetAllChildren():ToTable()
    local Item
    for k, v in pairs(Items) do
        if not v.IsText then
            Item = v
            break
        end
    end
    return Item
end

function M:FocusJumpItem()
    local Item = self:GetFirstJumpItem()

    if Item then
        local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        GameInputSubsystem:SetShowFocusedWidget(nil)
        Item.Btn_Click:SetFocus()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if(self.KeyDownEvent)then
        local Reply
        Reply,IsEventHandled = self.KeyDownEvent.Callback(self.KeyDownEvent.Obj,MyGeometry, InKeyEvent,self.KeyDownEvent.Params)
        if(IsEventHandled)then
            return Reply
        end
    end
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:TryGoToFirstItem()
    local Item = self:GetFirstJumpItem()
    if Item then
        self.bFocusItem = true
        self:FocusJumpItem()
        return true
    end

    return false 
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = self.HandleKeyDown
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.bFocusItem then
            self.bFocusItem = false
            self:SetFocus()
        else
            if self.ParentWidget then
                self.ParentWidget:CloseItemDetailsWidget(true)
                local RootWidget = self.ParentWidget.ParentWidget
                if(RootWidget and RootWidget.bIsFocusable)then
                    RootWidget:SetFocus()
                end
            end
        end
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
        self:TryGoToFirstItem()
    elseif InKeyName == self.LockPadKey then
        self:_BtnLockedPressed()
        self:_BtnLockedReleased(self.Content)
    elseif InKeyName == self.Btn02PadKey then
        self.Btn02_Mod:OnBtnClicked()
    elseif InKeyName == self.Btn01PadKey then
        self.Btn01_Mod:OnBtnClicked()
    end
    return IsEventHandled
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
        local CurrentOffset = self.EMScrollBox_1:GetScrollOffset()
        local NextOffset = math.clamp(CurrentOffset + DeltaOffset,0, self.EMScrollBox_1:GetScrollOffsetOfEnd())
        self.EMScrollBox_1:SetScrollOffset(NextOffset)
    end
    if (self.HandleKeyDown) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
       return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:SetCallbacks(Callbacks)
    self.CallObj = Callbacks.CallObj
    self.OnMouseButtonDownCallback = Callbacks.OnMouseButtonDownCallback
end

---排除弹窗的输入干扰
function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if self.OnMouseButtonDownCallback then
        self.OnMouseButtonDownCallback(self.CallObj, MyGeometry, MouseEvent)
    end
    return Handled
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    return Handled
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    return Handled
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
    return Handled
end

function M:OnMouseButtonDoubleClick(MyGeometry, MouseEvent)
    return Handled
end

function M:OnMouseEnter(MyGeometry,MouseEvent)
    if self.Content.bIsHoverState and self.Parent and 
        UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad  then
        self.Parent:Close()
    end
end
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)   
    local bHoverState = self.Content and not self.Content.bIsHoverState
    if CurInputDevice == UE4.ECommonInputType.Gamepad and bHoverState then 
        if self.bShowLock then
            self.Key_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if self.Content and not self.Content.bHideGamePad then
            self.Panel_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if self:GetFirstJumpItem() then
            self.Key_Controller_Method:SetVisibility(ESlateVisibility.Visible)
        end
        self:InitGamepadView(CurGamepadName)
        self.Key_Confirm:SetVisibility(ESlateVisibility.Collapsed)
    elseif CurInputDevice == UE4.ECommonInputType.MouseAndKeyboard then 
        self.Key_Lock:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Controller:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Controller_Method:SetVisibility(ESlateVisibility.Collapsed)
    elseif CurInputDevice == UE4.ECommonInputType.Gamepad and self.Content and self.Content.ConfirmDesc then
        self.Key_Confirm:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("A", CurGamepadName),
                }
            },
            Desc = GText(self.Content.ConfirmDesc)
        })
        if self.Content and not self.Content.bHideGamePad then
            self.Panel_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        self.Key_Back:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Confirm:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:InitGamepadView(CurGamepadName)
    self.Key_Back:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("B", CurGamepadName),
            }
        },
        Desc = GText("UI_Tips_Close")
    })
    self.Key_Lock:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = DataMgr.KeyboardText[self.LockPadKey or UIConst.GamePadKey.SpecialRight].KeyText,
            },
        },
    })
    self.Key_Controller_Method:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = DataMgr.KeyboardText[UIConst.GamePadKey.SpecialLeft].KeyText,
            }
        },
    })
end

function M:OnAddedToFocusPath(InFocusEvent)
    if(self.OnAddedToFocusPathEvent and type(self.OnAddedToFocusPathEvent) == "table")then
        self.OnAddedToFocusPathEvent.Callback(self.OnAddedToFocusPathEvent.Obj, self.OnAddedToFocusPathEvent.Params)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if(self.OnRemovedFromFocusPathEvent and type(self.OnRemovedFromFocusPathEvent) == "table")then
        self.OnRemovedFromFocusPathEvent.Callback(self.OnRemovedFromFocusPathEvent.Obj, self.OnRemovedFromFocusPathEvent.Params)
    end
end

function M:PlayInAnim()
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
end

return M