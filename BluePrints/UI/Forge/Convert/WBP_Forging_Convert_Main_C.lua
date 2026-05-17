require "UnLua"
local WBP_Forging_Convert_Main_C = Class("BluePrints.UI.BP_UIState_C")

local ForgeConst = require "Blueprints.UI.Forge.ForgeConst"
local ForgeModel = require "Blueprints.UI.Forge.ForgeDataModel"
local ControllerFSM = require("Blueprints.UI.ControllerFSM")

WBP_Forging_Convert_Main_C._components = {
    "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp",
    "BluePrints.UI.Forge.Convert.WBP_Forging_Convert_Main_GamePadCompoment",
}

local CompendiumState = {
    NormalPage = 1,
    FocusSort = 2,
}

function WBP_Forging_Convert_Main_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    self.KeyboardKeyConfig = {
        [ForgeConst.BottomKeyTypes.BottomKey_Keyboard_Esc] = {
            KeyInfoList = {
                {Type="Text", Text="Esc", Owner=self, ClickCallback = self.OnClose},
            },
            Desc=GText("UI_BACK")
        },
    }

    self.GamepadKeyCofig = {
        [ForgeConst.BottomKeyTypes.BottomKey_Back] = {
            GamePadInfoList = {
                {Type="Img", ImgShortPath=UIConst.GamePadImgKey.FaceButtonRight, Owner=self}
            }, 
            Desc=GText("UI_BACK")
        },
        [ForgeConst.BottomKeyTypes.BottomKey_Confirm] = {
            GamePadInfoList = {
                {Type="Img", ImgShortPath=UIConst.GamePadImgKey.FaceButtonBottom, Owner=self}
            }, 
            Desc=GText("UI_Tips_Ensure")
        },
    }

    self.MaterialSlot = {}

    self:InitListenEvent()
    self:InitUI()
    self:InitKeySetting()
    self:InitTab()
    self:InitLeftList()
    self:ShowItemDetailsPanel(false)
    -- 延迟0.01s，默认选中第一个
    self:AddTimer(0.01, function ()
        self:ChooseDefault()
        self:RemoveTimer("TimeToLoadList")
    end, false, 0, "TimeToLoadList")

    self.WBP_Forging_Convert:InitSlider()
    self.EMList:SetScrollbarVisibility(UE4.ESlateVisibility.Collapsed)
    self.EMList:SetControlScrollbarInside(true)
    
    self:PlayAnimation(self.In)
    self.Com_Tab:PlayInAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "ForgeConvertIn", nil)

end
--手柄数值输入框用，左方向键和右方向键只有在preview才能拿到
function WBP_Forging_Convert_Main_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if self.WBP_Forging_Convert_PopUp_Choose:GetVisibility() ~= UE4.ESlateVisibility.Visible then
            if InKeyName== UIConst.GamePadKey.DPadLeft or InKeyName== UIConst.GamePadKey.DPadRight  then
                IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
            elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
                if self.WBP_Forging_Convert.WBP_Com_Slider:GetVisibility() == UE4.ESlateVisibility.Visible then
                    IsHandled = self:OnGamepadAclick()
                end
            end
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_Forging_Convert_Main_C:OnGamepadAclick()
    if self.WBP_Forging_Convert_PopUp_Choose:GetVisibility() == UE4.ESlateVisibility.Visible then
        return false
    end
    if self.WBP_Forging_Convert.WBP_Com_Slider:GetVisibility() ~= UE4.ESlateVisibility.Visible then
        return false
    end
    local Btn = self.WBP_Forging_Convert.WBP_Com_BtnText01
    if Btn and Btn.IsForbidden then
        self.WBP_Forging_Convert:OnConfirmBtnForbidClicked()
        return true
    end
    self.WBP_Forging_Convert:OnConfirmConvertClicked()
    return true
end

function WBP_Forging_Convert_Main_C:OnKeyDown(MyGeometry, InKeyEvent)
    if(CommonUtils:IfExistSystemGuideUI(self)) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    DebugPrint("Yihan@ OnKeyDown", InKey, InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    else
        if self.KeyDownEvent[InKeyName] then
            self.KeyDownEvent[InKeyName](self)
            IsHandled = true
        end
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_Forging_Convert_Main_C:OnKeyUp(MyGeometry, InKeyEvent)
    if(CommonUtils:IfExistSystemGuideUI(self)) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    DebugPrint("yeke@ OnKeyUp", InKey, InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:Handle_KeyUpOnGamePad(InKeyName)
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- 初始化界面相关
function WBP_Forging_Convert_Main_C:InitUI()
    -- 将选择界面隐藏 
    self.WBP_Forging_Convert_PopUp_Choose:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- 初始化事件监听
function WBP_Forging_Convert_Main_C:InitListenEvent()
    DebugPrint("Yihan@ InitListenEvent")
    self.EMList.BP_OnItemClicked:Add(self, self.OnEMListItemClicked)

    self.Btn_Close_Tips.OnClicked:Add(self, self.OnBackgroundClicked)
    -- 点击事件的回调
    self.WBP_Forging_Convert_PopUp_Choose:SetConfirmCallback(self, self.UpdateConvertMaterial)
    self.WBP_Forging_Convert:SetClearAllCallback(self, self.ClearAllMaterial)
    self.WBP_Forging_Convert:SetShowChooseUICallback(self, self.ShowChooseUI)
    
end

-- 初始化鼠标键盘的按键绑定
function WBP_Forging_Convert_Main_C:InitKeySetting()
    DebugPrint("Yihan@ InitKeySetting")
    self.SwitchTab_LeftKey = "Q"
    self.SwitchTab_RightKey = "E"
    self.EscapeKey = "Escape"

    self.KeyDownEvent = {}
    self.KeyDownEvent[self.EscapeKey] = self.OnReturnKeyDown
end

function WBP_Forging_Convert_Main_C:InitTab()
    local TabConfigData = {
        TitleName = GText("UI_Convert"),
        StyleName = "Text", 
        DynamicNode= {
            "Back",
            "ResourceBar",
            "BottomKey", 
        }, 
        BackCallback = self.OnClose,
        LastFocusWidget = self.EMList,
        GetReplyOnBack = self:Create_GetReplyOnBack(),
        BottomKeyInfo = {
           {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        },
        },
        OwnerPanel = self,
        OverridenTopResouces = {101}
    }
    self.Com_Tab:Init(TabConfigData)
end

function WBP_Forging_Convert_Main_C:InitLeftList()
    DebugPrint("Yihan@ InitLeftList")
    local ConvertData = DataMgr.Convert
    if not ConvertData then return end
    --接创建一个排序辅助表
    local sortHelper = {}

    for id, Data in pairs(ConvertData) do

        local ProductId

        if Data.ProductType == CommonConst.ArmoryType.Mod then
            ProductId = Data.ModConvertResource
        else
            ProductId = Data.ProductId
        end

        if ProductId then
            table.insert(sortHelper, {id = id, Data = Data})
        end
    end

    -- 按SortPriority降序排序
    table.sort(sortHelper, function(a, b)
        return a.Data.SortPriority > b.Data.SortPriority
    end)
    self.EMList:ClearListItems()
    for Index, item in ipairs(sortHelper) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Position = Index
        Content.Idx = item.id
        Content.bActivate = true
        Content.bGolden = false
        Content.ItemData = item.Data

        Content.ConvertId = item.CovertId

        --获取ResourceId
        local ResourceId, ItemType, ProductType
        if Content.ItemData.ProductType == CommonConst.ArmoryType.Mod then
            ResourceId = Content.ItemData.ModConvertResource
        else
            ResourceId = Content.ItemData.ProductId
        end
        local ResourceData = DataMgr.Resource[ResourceId]
        Content.Id = ResourceId
        Content.ItemType = "Resource"
        Content.ProductType = item.Data.ProductType
        Content.Rarity = ResourceData.Rarity
        Content.Icon = ResourceData.Icon
        Content.NotInteractive = true
        Content.ResourceName = ResourceData.ResourceName
        Content.ResourseCount = self:GetHaveCount(ResourceId)
        Content.Parent = self
        Content.IsNew = self:ItemIsNew(item.id)
        -- Content.ItemClickCallback = function(self)
        --     self:RefreshItemDetails(Content)
        -- end
        self.EMList:AddItem(Content)
    end
end

function WBP_Forging_Convert_Main_C:ItemIsNew(ConvertId)
    local ConvertReddotDetails = ReddotManager.GetLeafNodeCacheDetail("ForgeConvert")
    for _, Details in pairs(ConvertReddotDetails) do
        if ConvertId == Details.Id and Details.IsClicked then
            return false
        end
    end
    return true
end

function WBP_Forging_Convert_Main_C:GetHaveCount(ResourceId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return 0 end
    return Avatar:GetResourceNum(ResourceId)
end

function WBP_Forging_Convert_Main_C:RefreshItemDetails()
    if self.CurItemDetails ~= self.CurListItem or not self.bItemDetailsShowed then
        self.CurItemDetails = self.CurListItem
        self:ShowItemDetailsPanel(true)
        local ItemDetailParam = {}
        ItemDetailParam.ItemId = self.CurListItem.Id
        ItemDetailParam.ItemType = self.CurListItem.ItemType
        ItemDetailParam.bHideGamePad = false
        self.Tips_Item:PlayAnimation(self.Tips_Item.Change)
        self.Tips_Item:RefreshItemInfo(ItemDetailParam, false)
    end
end

function WBP_Forging_Convert_Main_C:OnBackgroundClicked()
    if self.bItemDetailsShowed then
        self:ShowItemDetailsPanel(false)
    end
end

-- 选择完材料的回调
function WBP_Forging_Convert_Main_C:UpdateConvertMaterial(ChoosedTbl, IsShow)
    -- 将选择的材料显示在炉子下面
    self.WBP_Forging_Convert:UpdateMaterialSlot(ChoosedTbl, IsShow)
    self.WBP_Forging_Convert:UpdateBottomState(ChoosedTbl)
    self.WBP_Forging_Convert:InitSliderValue()
end

-- 炉子清空材料的回调~
function WBP_Forging_Convert_Main_C:ClearAllMaterial()
    self.WBP_Forging_Convert:InitMaterialSlot()
    self.WBP_Forging_Convert_PopUp_Choose:InitAll(self.CurListItem)
end

-- 打开选择界面的回调
function WBP_Forging_Convert_Main_C:ShowChooseUI(ChoosedMaterialTbl)
    DebugPrint("Yihan@ WBP_Forging_Convert_C:ShowChooseUI", ChoosedMaterialTbl)
    self.WBP_Forging_Convert_PopUp_Choose:ShowChooseUI(true)
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C:ShowChooseUI", self.CurListItem.Idx)
    self.WBP_Forging_Convert_PopUp_Choose:ShowAllMaterial(self.CurListItem, ChoosedMaterialTbl)
end

function WBP_Forging_Convert_Main_C:OnEMListItemClicked(Item)
    DebugPrint("Yihan@ WBP_Forging_Convert_C:OnEMListItemClicked12312312313", Item)
    if self.WBP_Forging_Convert.bInMixAnimation or self.CurListItem == Item then return end
    -- 更改右侧上面的图标
    self.WBP_Forging_Convert:UpdateForingConvertContent(Item)
    -- 将下面的材料栏清空
    self.WBP_Forging_Convert:InitMaterialSlot()
    -- 将已经缓存的已选择的材料表清空
    self.WBP_Forging_Convert:ClearMergeTbl()
    self.WBP_Forging_Convert_PopUp_Choose:InitAll(Item)
    -- 并把下面的条条框框去掉
    self.WBP_Forging_Convert:UpdateBottomState({})
    -- 改变选中状态
    local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.EMList, self.EMList:GetIndexForItem(Item))
    -- 去除New状态相关
    DebugPrint("Yihan@ 111111111111111111CurWidget", CurWidget)
    if self:ItemIsNew(Item.Idx) then
        local ConvertReddotDetails = ReddotManager.GetLeafNodeCacheDetail("ForgeConvert")
        for _, Details in pairs(ConvertReddotDetails) do
            if Item.Idx == Details.Id then
                Details.IsClicked = true
            end
        end
        ReddotManager.DecreaseLeafNodeCount("ForgeConvert")
        if CurWidget then
            CurWidget:SetNewIcon(false)
        end  
    end
    if CurWidget then
        CurWidget:SetSelected(true)
    end
    Item.IsSelect = true
    if self.CurListItem then
        local PrevWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.EMList, self.EMList:GetIndexForItem(self.CurListItem))
        if PrevWidget then
            PrevWidget:SetSelected(false)
        end
        self.CurListItem.IsSelect = false
    end
    self.EMList:BP_ClearSelection()
    self.EMList:BP_SetItemSelection(Item, true)
    self.CurListItem = Item
    -- self.WBP_Forging_Convert_PopUp_Choose:InitSlotCount(Item)
    -- 播放点击音效
    AudioManager(self):PlayItemSound(self, self.CurListItem.Id, "Click", self.CurListItem.ItemType)
end

function WBP_Forging_Convert_Main_C:OnClose()
    DebugPrint("Yihan@ OnClose")
    if self:IsAnimationPlaying(self.In) then return end
    if self.IsClosing then return end
    
    if self.bItemDetailsShowed then
        self:ShowItemDetailsPanel(false)
    else
        self.IsClosing = true
        self:PlayAnimation(self.Out)

        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        local ForgePage = UIManager:GetUIObj("ForgeMain")
        if not ForgeConvertPage then
            local UI = UIManager:LoadUINew("ForgeMain")
        end

        -- 清空选择状态
        self:ClearChoosedState()
        -- 关闭铸造时，清空红点树
        ForgeModel:ClearConvertNewRedDots()
        AudioManager(self):SetEventSoundParam(self, "ForgeConvertIn", {ToEnd = 1})
    end
end

function WBP_Forging_Convert_Main_C:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then 
        self:Close()
    end
end

function WBP_Forging_Convert_Main_C:ChooseDefault()
    local ListItems = self.EMList:GetListItems()
    local ListItem = ListItems:GetRef(1)
    self:OnEMListItemClicked(ListItem)
end

function WBP_Forging_Convert_Main_C:ClearChoosedState()
    local ListItems = self.EMList:GetListItems()
    local ListItemsNum = ListItems:Num()
    for i = 1, ListItemsNum do 
        local ListItem = ListItems:GetRef(i)
        local PrevWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.EMList, self.EMList:GetIndexForItem(ListItem))
        if PrevWidget then
            PrevWidget:SetSelected(false)
        end
        self.CurListItem.IsSelect = false
    end
end

function WBP_Forging_Convert_Main_C:ShowItemDetailsPanel(bIsShow)
    if bIsShow then
        self.Tips_Item:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Btn_Close_Tips:SetVisibility(UE4.ESlateVisibility.Visible)
        self.bItemDetailsShowed = true
        self.Tips_Item.ParentWidget = self
        if UIUtils.IsGamepadInput() then
            self.Tips_Item:SetFocus()
            self:UpdateGamePadUIOnTipsChanged(true)
            self:UpdateGamepadBottomKeyInfo({ForgeConst.BottomKeyTypes.BottomKey_Back})
        end
    else
        self.Tips_Item:SetVisibility(UE4.ESlateVisibility.Hidden)
        self.Btn_Close_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.WBP_Forging_Convert.Shop:PlayerUnHoverAnimation()
        self.bItemDetailsShowed = false
        if UIUtils.IsGamepadInput() then
            self:UpdateGamePadUIOnTipsChanged(false)
            self:SetFocus_Lua()
            self:EnterState_Normal()
        end
    end
end

function WBP_Forging_Convert_Main_C:InitUsedByJumpPage()
    self:InitUI()
    self:InitLeftList()
    self:ShowItemDetailsPanel(false)
    -- 延迟0.01s，默认选中第一个
    self:AddTimer(0.01, function ()
        self:ChooseDefault()
        self:RemoveTimer("TimeToLoadList")
    end, false, 0, "TimeToLoadList")
end

-- function WBP_Forging_Convert_Main_C:ReceiveEnterState(StackAction)
--     self.Super.ReceiveEnterState(self, StackAction)
--     AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "ForgeConvertIn", nil)
-- end

function WBP_Forging_Convert_Main_C:OnReturnKeyDown()
    self:OnClose()
end

function WBP_Forging_Convert_Main_C:Destruct()
    DebugPrint("Yihan@ WBP_Forging_Convert_Main_C Destruct")
end

AssembleComponents(WBP_Forging_Convert_Main_C)
return WBP_Forging_Convert_Main_C
