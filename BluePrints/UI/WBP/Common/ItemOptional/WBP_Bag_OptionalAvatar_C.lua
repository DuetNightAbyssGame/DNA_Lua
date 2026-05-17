--
-- DESCRIPTION
-- 背包自选角色、武器、魔灵弹窗
-- @COMPANY **
-- @AUTHOR ** HongYang
-- @DATE 2025-05-20 10:00:00
--

require "UnLua"

local StuffIconObject = require "BluePrints.UI.WBP.Bag.Widget.BagStuffIconObject"

local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:InitContent(Params, PopupData, Owner)
    M.Super.InitContent(self, Params, PopupData, Owner)

    self.OptionalItemsList = Params.OptionalItemsList
    self.ChooseCallbackFunction = Params.ChooseCallbackFunction
    self.FunctionCallbackObj = Params.FunctionCallbackObj

    self.OriginalTips = Params.Tips
    self.CurrentChooseWidget = nil
    self.AllItemsWidget = {}
    self.ParentWidget = Params.ParentWidget
    self.CurrentChooseInfo = Params.ParentWidget.CurrentChooseInfo or nil
    self.ResourceId = Params.ResourceId
    self.IsLimitedPrizePool = Params.IsLimitedPrizePool or false
    self.RestoreSelectIndex = Params.RestoreSelectIndex

    self:ShowGamepadShortcutBtn({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LS"
            }},
        Desc = GText("UI_Controller_CheckDetails")
    })

    -- self:ShowGamepadShortcutBtn({
    --     KeyInfoList = {
    --         {
    --             Type = "Img",
    --             ImgShortPath = "A"
    --         }},
    --     Desc = GText("UI_CTL_Select")
    -- })

    if self.IsLimitedPrizePool then
        self:InitLimitedPrizePoolItemsInfo()
    else
        self:InitAllOptionalItemsInfo()
    end
    self.Owner:ShowDialogTip(1)
end

function M:InitAllOptionalItemsInfo()
    self.WB_Avatar:ClearChildren()

    -- 未拥有前置
    for i,v in ipairs(self.OptionalItemsList) do v.__idx = i end
    table.sort(self.OptionalItemsList, function(a,b)
        local aNot = (a.HaveCountNumber or 0) == 0
        local bNot = (b.HaveCountNumber or 0) == 0
        if aNot ~= bNot then
            return aNot        -- 未拥有优先
        end
        return a.__idx < b.__idx   -- 保持原相对顺序
    end)
    for _,v in ipairs(self.OptionalItemsList) do v.__idx = nil end
    
    for Index, ItemInfo in ipairs(self.OptionalItemsList) do
        ItemInfo.Index = Index
        local Item = self:CreateWidgetNew("ComOptionalAvatarItem")
        self.WB_Avatar:AddChildToWrapBox(Item)
        Item:Init(ItemInfo.StuffType, ItemInfo, self.ChangeChooseClickCallback, self)
        table.insert(self.AllItemsWidget, Item)
    end

    local AllCanNavigateCount = #self.AllItemsWidget
    for Idx, TargetWidget in ipairs(self.AllItemsWidget) do
        if (TargetWidget) then
            TargetWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
            TargetWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
            if (Idx == 1) then
                TargetWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
                TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Idx + 1])
            elseif (Idx == AllCanNavigateCount) then
                TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Idx - 1])
                TargetWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
            else
                TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Idx - 1])
                TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Idx + 1])
            end
        end
    end

    if self.CurrentChooseInfo then
        self:ResetChooseInfo()
    end
end

function M:InitLimitedPrizePoolItemsInfo()
    self.WB_Avatar:ClearChildren()

    -- HUANGTIANYUTEST
    self.OptionalItemsList[1].HaveCountNumber = 1
    -- self.OptionalItemsList[2].HaveCountNumber = 1

    -- 未拥有前置
    for i,v in ipairs(self.OptionalItemsList) do v.__idx = i end
    table.sort(self.OptionalItemsList, function(a,b)
        local aNot = (a.HaveCountNumber or 0) == 0
        local bNot = (b.HaveCountNumber or 0) == 0
        if aNot ~= bNot then
            return aNot        -- 未拥有优先
        end
        return a.__idx < b.__idx   -- 保持原相对顺序
    end)
    for _,v in ipairs(self.OptionalItemsList) do v.__idx = nil end

    local RestoreChooseItem = nil
    for Index, ItemInfo in ipairs(self.OptionalItemsList) do
        ItemInfo.Index = Index
        local Item = self:CreateWidgetNew("ComOptionalAvatarItem")
        self.WB_Avatar:AddChildToWrapBox(Item)
        Item:InitLimitedPrizePoolItemInfo(ItemInfo.StuffType, ItemInfo, self.ChangeChooseClickCallback, self)
        if self.RestoreSelectIndex and self.RestoreSelectIndex == Index then
            RestoreChooseItem = Item
        end
        table.insert(self.AllItemsWidget, Item)
    end

    -- local AllCanNavigateCount = #self.AllItemsWidget
    local AllCanNavigateCount = 1
    for Idx, TargetWidget in ipairs(self.AllItemsWidget) do
        if (TargetWidget) then
            TargetWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
            TargetWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
            if (Idx == 1) then
                TargetWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
                if Idx == AllCanNavigateCount then
                    TargetWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
                else
                    TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Idx + 1])
                end
            elseif (Idx == AllCanNavigateCount) then
                TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Idx - 1])
                TargetWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
            else
                TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Idx - 1])
                TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Idx + 1])
            end
        end
    end

    if self.CurrentChooseInfo then
        self:ResetChooseInfo()
    end

    if RestoreChooseItem then
        RestoreChooseItem:OnBtnChooseClicked()
    end
end

function M:ChangeChooseClickCallback(bSelectState, ChooseInfo)
    -- if not ChooseInfo then
    --     return
    -- end
    if (self.CurrentChooseWidget) then
        self.CurrentChooseWidget:SetSelected(false)
    end
    self.CurrentChooseInfo = ChooseInfo

    if (bSelectState) then
        -- 选中
        self.CurrentChooseWidget = ChooseInfo.ChooseWidget
        self.CurrentChooseWidget:SetSelected(true)
        if (type(self.ChooseCallbackFunction) == "function") then
            self.ChooseCallbackFunction(self.FunctionCallbackObj, self.CurrentChooseInfo)
        end
        self.Owner:ForbidRightBtn(false)
        if self.CurrentChooseInfo.ResourceId then
            local ResourceName = DataMgr.Resource[self.CurrentChooseInfo.ResourceId].ResourceName

            local Funds = {}
            Funds[1] = {}
            Funds[1].FundId = self.ResourceId
            Funds[1].FundNeed = 1
            Funds[1].CostText = GText("UI_Armory_Trace_Cost")
            self:AddDelayFrameFunc(function()
                self:BroadcastDialogEvent("UpdateFunds", { Funds = Funds })
                self.Owner:HideDialogTip(1, false)
                self.Owner:ShowDialogTip(2)
            end, 1)
        end
    else
        -- 取消选中
        self.CurrentChooseWidget = nil
        self.Owner:ForbidRightBtn(true)
        self.Owner:HideDialogTip(2)
        self.Owner:ShowDialogTip(1)
        -- self:BroadcastDialogEvent("UpdateDialogTipText", { Tips = self.OriginalTips, DialogItemIndex = 1, bShowTip = true})
    end

    -- AudioManager(self):PlayItemSound(self, self.Item.Id, "Click", self.Item.ItemType) -- 播一下音效
end

function M:StoreChooseInfo()
    if not self.ParentWidget then
        return
    end
    local CurrentSelectIndex = nil
    if self.CurrentChooseWidget then
        if self.CurrentChooseInfo then
            CurrentSelectIndex = self.CurrentChooseInfo.Index
        end
    end
    self.ParentWidget.SelectWidgetChooseIndex = CurrentSelectIndex
end

function M:ResetChooseInfo()
    -- 二次确认取消时，重置选中状态
    local ChooseWidget = self.AllItemsWidget[self.CurrentChooseInfo.ChooseIndex]
    ChooseWidget:OnBtnChooseClicked()
end

-- 此处计算是否全部都已经选过，如果有没选过的就禁用，return true
function M:IsForbiddenChoose()
    if self.IsLimitedPrizePool then
        for _, ItemInfo in ipairs(self.OptionalItemsList) do
            if (ItemInfo.HaveCountNumber or 0) == 0 then
                return true
            end
        end
    end
    return false
end

function M:ScrollToTargetItem(TargetItem)
    self.ScrollBox_Avatar:ScrollWidgetIntoView(TargetItem)
end

function M:BP_GetDesiredFocusTarget()
    return self.CurrentChooseWidget or self.ScrollBox_Avatar
end 

function M:OnBtnYes()
    if self.Owner then 
        if self.CurrentChooseInfo == nil then
            self.Owner:OnForbiddenRightBtnClicked()
        else
            self.Owner:OnRightBtnClicked()
        end
    end
end

function M:HideSelf(bIsHide, IsNeedFocus)
    if (self.Owner) then
        if (bIsHide) then
            self.Owner:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.Owner:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        if (IsNeedFocus) then
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
            self:AddTimer(0.6, function()
                self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
                self:SetFocus()
            end)
        end
    end
end

function M:CloseDialog()
    if (self.Owner) then
        self.Owner:Close()
    end
end

function M:GetCurrentHoverItem()
    local TargetWidget = nil
    local AllChildren = self.WB_Avatar:GetAllChildren()
    for i=1,AllChildren:Length() do
        local ChildItem = AllChildren:GetRef(i)
        if ChildItem:CheckIsInHovered() then
            TargetWidget = ChildItem
            break
        end
    end
    return TargetWidget
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.LeftThumb) then
            -- 打开菜单锚
            local CurrentHoveredWidget = self:GetCurrentHoverItem()
            if (CurrentHoveredWidget ~= nil) then
                CurrentHoveredWidget:OnBtnCheckClicked()
                IsEventHandled = true
            end
        -- elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
        --     -- 确认获取
        --     self:OnBtnYes()
        --     IsEventHandled = true
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
            -- 2026/1/28 改为A键领取
            self:OnBtnYes()
            IsEventHandled = true
        end
    end
    return IsEventHandled
end

return M
