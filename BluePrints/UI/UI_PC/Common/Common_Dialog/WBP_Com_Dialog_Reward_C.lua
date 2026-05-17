--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_Dialog
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()

end

function M:InitContent(Params, PopupData, Owner)
    local ConfigData=Params.ConfigData
    self.TabConfigDatas=Params.TabConfigDatas
    self.ConfigData=ConfigData
    self.Owner=Owner
    self.Type=ConfigData.Type
    self.CurrentTab = nil
    self:BindDialogEvent(DialogEvent.OnTitleTabSelected, self.OnTabSelected)
    -- ConfigData({
    --     HasTab=flase,  是否为带Tab类型
    --     Type="",当前的Type类型
    --     ReddotName="",
    --     TabInfo={
    --              TabItems1=
    --                {Title, Tab的文本
    --                  ReddotName,要监听的红点树名称,
    --                  Type="",该Tab的类型
    --                  IsShowIcon=true,
    --                  IconPath="",
    --               },
    --
    --              }
    --     当是带Type类型时构建并传Datas表，不传时不用专门构造Data表,直接这样构造:ConfigData={Items={}ShowType,SourceNum......}
    --     Datas={
    --              "Type1"=Data1
    --              "Type2"=Data2
    --        }
    --
    --
    --     Data{
    --          Items = {
    --             Owner,持有者
    --              Item1={
    --             Text = "任务"   Tab文本
    --             ItemId = 1, Tab的Id
    --             CanReceive=false, 是否可领取
    --             InProgress=false,是否在进行中
    --             RewardsGot,是否已领取
    --             ShowIcon=true,是否显示图标
    --             IconPath="",图标路径
    --             TextProgress,进度文本
    --            NotShowNum，不显示数量
    --             通用小道具框的InitData
    --             Rewards={
    --                     Content1={},
    --                     Content2={},
    --                     Content3={},
    --                       },通用小道具框的InitData
    --              Nums=1，Item的数量
    --              NotreachText=""，未达成数量
    --              Hint="",获得条件提示文本
    --              ReceiveCallBack,点击领取后调用的RPC
    --              ReceiveParm={},领奖所需的参数
    --              LeftAligned=true  奖励是否左对齐，false时为右对齐
    --              BreakStarCount=3，星星数量，若有，则不再使用Hint文本
    --              },
    --               Item2={


    --               },
    --          },
    --          ShowIcon=true, 是否显示左下角总奖励Icon
    --          IconPath=""
    --          ShowSourceNum, 是否显示左下角数量
    --          Type="",       当前选中的Tab类型
    --          IconPath="",   左下角奖励Icon图标
    --          ShowTotalProgress = true, 是否显示左下角解锁进度
    --          OnlyShowNowProgress =false,是否只显示左下角
    --          Text_Total="",左下角文本
    --          NumMax,总计获得
    --          NowNum,现在数量
    --          ReceiveAllCallBack,点击全部领取后调用的RPC
    --          ReceiveAllParam={}, 领取相关参数
    --          ReceiveButtonText="",
    --          SortType=1,2,3   1:已经领取的Item置底 2:自动定位到未领取处
    --          }

    -- })
    self.Type2Index={}
    self.Datas=ConfigData.Datas
    self.Items=ConfigData.Items
    self.TabInfo=ConfigData.TabInfo
    self.HasTab=ConfigData.HasTab
    self.ReddotName=ConfigData.ReddotName
    if ConfigData.ShowTotalProgress ~= false then
        self.Text_Total:SetText(GText(ConfigData.Text_Total))
        self.Text_Num:SetText(tostring(ConfigData.NowNum))
        self.Text_NumMax:SetText(tostring(ConfigData.NumMax))
    else
        self.HorizontalBox_TotalProgress:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if ConfigData.OnlyShowNowProgress then
        self.Text_Split:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Text_NumMax:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if not ConfigData.ShowIcon then
        self.Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        if ConfigData.IconPath then
            local Icon = LoadObject(ConfigData.IconPath)
            self.Icon:SetBrushResourceObject(Icon)
            self.Icon:SetVisibility(UIConst.VisibilityOp.Visible)
        end
    end
    self.Btn_GetAll:SetText(GText(ConfigData.ReceiveButtonText))
    self.Btn_GetAll:SetDefaultGamePadImg("Y")
    self.Btn_GetAll:UnBindEventOnClickedByObj(self)
    self.Btn_GetAll:BindEventOnClicked(self,function ()
        if self.HasTab then
            ConfigData.Datas[self.Type].ReceiveAllParam.SelfWidget=self
            ConfigData.Datas[self.Type].ReceiveAllCallBack(self,ConfigData.Datas[self.Type].ReceiveAllParam)
        else
            ConfigData.ReceiveAllParam.SelfWidget=self
            ConfigData.ReceiveAllCallBack(self,ConfigData.ReceiveAllParam)
        end
    end)
    if self.HasTab then
        self:InitListTabInfo()
        self:ScrollToSelectTab()
    end
    if not self.HasTab then
        self:InitItem(ConfigData)
    end
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:AddInputMethodChangedListen()
    if  UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        self:InitGamepadView()
        self.List_Item:SetFocus()
    else
        self:SetFocus()
    end
end

function M:ScrollToSelectTab()
    local SelectIndex = nil
    if self.Type then
        SelectIndex = self.Type2Index[self.Type]
    end
    if not SelectIndex then
        SelectIndex = 1
    end
    self.List_Tab:ScrollIndexIntoView(SelectIndex-1)
    self:AddTimer(0.1, function()
        self.List_Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        local Item = self.List_Tab:GetItemAt(SelectIndex-1)
        --self.Text_Progress:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_GetAll:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if Item then
            self.List_Tab:SetSelectedIndex(SelectIndex-1)
            Item.Entry:OnCellClicked(true)
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(Item.Entry)
        end
    end, false, 0, "SelectRewardTab", true)
end


function  M:InitItem(ConfigData)
    self.List_Item:ClearListItems()
    if ConfigData.SortType==1 then
        self:SortItems()
    end
    local Count=0
    for _, Item in pairs(ConfigData.Items) do
       local ClassPath = UIUtils.GetCommonItemContentClass()
       local MenuContent = NewObject(ClassPath)
           MenuContent.Owner=self
           MenuContent.ConfigData=Item
           MenuContent.Id=_-1
           if Item.CanReceive then
               Count=Count+1
           end
        self.List_Item:AddItem(MenuContent)
    end
    if ConfigData.SortType==2 then
        self:AddTimer(0.01,function ()
        local AllItemCount = self.List_Item:GetNumItems()
        local IndexToScroll=0
        for i = 0, AllItemCount - 1, 1 do
            local Item = self.List_Item:GetItemAt(i)
            if Item.ConfigData.CanReceive then
                self.MaxRewardGot=i
                self:AddTimer(0.1, function()
                    self.List_Item:ScrollIndexIntoView(i)
                end)
                return
            elseif not Item.ConfigData.RewardsGot and IndexToScroll==0 then
                IndexToScroll=i
            end
        end
        self.List_Item:ScrollIndexIntoView(IndexToScroll)
        end,false,0,nil,true)
    end
    -- self.List_Item:SetRenderOpacity(0)
    --     self:AddTimer(0.1, function()
    --     self.List_Item:SetRenderOpacity(1)
    --         UIUtils.PlayListViewFramingInAnimation(self, self.List_Item)
    --     end)
    if Count>0 then
        self.Btn_GetAll:ForbidBtn(false)
    else
        self.Btn_GetAll:ForbidBtn(true)
    end
end

function M:SortItems()
    if not self.Items then
        return
    end
    table.sort(self.Items, function(a,b)
        if a.CanReceive and not b.CanReceive then
            return true
        elseif not a.CanReceive and  b.CanReceive then
            return false
        elseif a.RewardsGot and not b.RewardsGot then
            return false
        elseif not a.RewardsGot and b.RewardsGot then
            return true
        elseif not a.NeedSwitchType and b.NeedSwitchType then
            return true
        elseif a.NeedSwitchType and not b.NeedSwitchType then
            return false
        end
        return a.SourceNum<b.SourceNum
    end)
end

function M:RefreshBaseInfo()
    -- 刷新设备热键信息
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
        GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:InitKeyBoardView()
    else
        self:InitGamepadView()
    end
end

function M:OnSelectItemChanged(SelectItem)
    if (not SelectItem) then
        return
    end
    if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
        self:ClickListItemWhenSelectItemChanged(SelectItem)
    end
end

function M:ClickListItemWhenSelectItemChanged(Content)
    if Content and Content.Entry then
        Content.Entry:OnCellClicked()
    end
end

function M:OnUINavigation(NavigationDirection)
    if(NavigationDirection == EUINavigation.Left) then
        if self.CurFocusedRewardItem then
            self.CurFocusedRewardItem:StopHover()
            self.CurFocusedRewardItem = nil
        end
        self:ShowGamepadViewBtn(false)
        return self.SelectedContent.Entry
    elseif(NavigationDirection == EUINavigation.Right) then
         self:ShowGamepadViewBtn(true)
        return self:NavigateToFirstDisplayedItem(self.List_Item)
    end
end

function M:InitListTabInfo()
    self.List_Tab.BP_OnItemSelectionChanged:Add(self, self.OnSelectItemChanged)
    self.List_Tab:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnUINavigation})
    self.List_Tab:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.List_Item:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnUINavigation})
    self.List_Item:SetControlScrollbarInside(true)
    local ClassPath = '/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C'
    self.List_Tab:ClearListItems()
    for Index,TabItem in ipairs(self.TabInfo) do
        local Obj = NewObject(UE4.LoadClass(ClassPath))
        Obj.Root = self
        Obj.Index = Index
        Obj.Title = TabItem.Title
        Obj.Type=TabItem.Type
        Obj.ReddotName = TabItem.ReddotName
        Obj.IsShowIcon=TabItem.IsShowIcon
        Obj.IconPath=TabItem.IconPath
        self.List_Tab:AddItem(Obj)
        self.Type2Index[TabItem.Type] = Index
    end
end

function M:RefreshListRewardInfo(Item,NotPlaySound)
    if self.SelectedContent then
        self.SelectedContent.Entry:UnSelected()
    end
    self.SelectedContent = Item.Content
    self.SelectedContent.Entry:Selected(NotPlaySound)
    self:RealRefreshListRewardInfo(self.SelectedContent.Type)
end

function M:RealRefreshListRewardInfo(TabType)
    local ConfigData = self.Datas[TabType]
    self.Type=TabType
    --NumberModel["Get"..self.ArchiveType2Name[ArchiveType].."SumNumber"](NumberModel)
    self:Refresh(ConfigData)
    --self:AddListReward(ArchiveType, Sum)
    --self:RefreshProgressInfo(ArchiveType, Sum)
    self:RefreshBtnGetAll(ConfigData)
end

function M:RefreshBtnGetAll(ConfigData)
    local HasRewardToGet=false
    for _, Item in pairs(ConfigData.Items) do
        if Item.CanReceive and not Item.RewardsGot then
            HasRewardToGet=true
            break
        end
    end
    if HasRewardToGet then
        local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
        if CurInputDevice ~= ECommonInputType.Touch and CurInputDevice ~= ECommonInputType.MouseAndKeyboard then
            self.Btn_GetAll:SetVisibility(ESlateVisibility.HitTestInvisible)
        else
            self.Btn_GetAll:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Btn_GetAll:ForbidBtn(false)
        end
    else
         self.Btn_GetAll:ForbidBtn(true)
    end
end

function M:RefreshReddotInfo()
    DebugPrint("@@@ComDilaog Reward Try Clear Reddot ReddotName:",self.ReddotName," Type:",self.SelectedContent.Type)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotName)
    if CacheDetail[self.SelectedContent.Type] then
        local Num = 0
        for _,_ in pairs(CacheDetail[self.SelectedContent.Type]) do
            Num = Num + 1
        end
        CacheDetail[self.SelectedContent.Type] = nil
        DebugPrint("@@@ComDilaog Reward Clear Reddot ReddotName:",self.ReddotName," Type:",self.SelectedContent.Type," Num:",Num)
        ReddotManager.DecreaseLeafNodeCount(self.ReddotName, Num)
    end
end

function M:Destruct()
    self.Super.Destruct(self)
    ReddotManager.RemoveListener(self.ReddotName,self)
    self:RemoveInputMethodChangedListen()
    if self.List_Tab then
        self.List_Tab:ClearListItems()
    end
    self.List_Item:ClearListItems()
end



function M:NavigateToFirstDisplayedItem(List)
    local ItemUIs = List:GetDisplayedEntryWidgets()
    if ItemUIs:Length() > 0 then
        local TargetWidget = nil
        for i=1,ItemUIs:Length() do
            local Widget = ItemUIs:GetRef(i)
            local Index = Widget.Content.Id
            if Index then
                if (not TargetWidget) or (Index < TargetWidget.Content.Id) then
                    TargetWidget = Widget
                end
            end
        end
        if TargetWidget then
            List:BP_NavigateToItem(TargetWidget.Content)
            return TargetWidget
        end
    end
    return List
end



function M:InitGamepadView()
    if self:HasAnyFocus() then
        self:NavigateToFirstDisplayedItem(self.List_Item)
    end
    --self:UpdateUIStyle(true)
    self.Btn_GetAll:SetGamePadIconVisible(true)
    if not self.Btn_GetAll:IsBtnForbidden() then 
        self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    self:ShowGamepadViewBtn(false)
    self:ShowGamepadViewSingleBtn(false)
end

function M:InitKeyBoardView()
    self.IsInViewMode=false
    self.Btn_GetAll:SetGamePadIconVisible(false)
    if not self.Btn_GetAll:IsBtnForbidden() then 
        self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self:ShowGamepadViewBtn(false)
    self:ShowGamepadViewSingleBtn(false)
end

function M:ShowGamepadScrollBtn(bShow)
    if bShow then 
        if self.GamepadScrollBtnIndex then
            if self.Owner:GetGamepadShortcutByIndex(self.GamepadScrollBtnIndex) then
                self:ShowGamepadShortcut(self.GamepadViewBtnIndex)
            end
            return
        end
        self.GamepadScrollBtnIndex = self:ShowGamepadShortcutBtn({        
            KeyInfoList = {
            {
                Type = "Img",
                ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("LV", self.CurGamepadName)
            }},
            Desc = GText("UI_Controller_Slide")
        })
    else 
        if self.GamepadScrollBtnIndex then 
            self:HideGamepadShortcut(self.GamepadScrollBtnIndex)
            self.GamepadScrollBtnIndex = nil
        end
    end
end
function M:ShowGamepadViewBtn(bShow)
    if bShow then 
        if self.GamepadViewBtnIndex then 
            if self.Owner:GetGamepadShortcutByIndex(self.GamepadViewBtnIndex) then
                self:ShowGamepadShortcut(self.GamepadViewBtnIndex)
            end
            return 
        end
            self.GamepadViewBtnIndex = self:ShowGamepadShortcutBtn({        
            KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LS"
            }},
            Desc = GText("UI_Controller_CheckReward")
        })
    else 
        if self.GamepadViewBtnIndex then 
            self:HideGamepadShortcut(self.GamepadViewBtnIndex)
            self.GamepadViewBtnIndex = nil
        end
    end
end

function M:ShowGamepadViewSingleBtn(bShow)
    if bShow then 
        if self.GamepadViewSingleBtnIndex then 
            if self.Owner:GetGamepadShortcutByIndex(self.GamepadViewSingleBtnIndex) then
                self:ShowGamepadShortcut(self.GamepadViewSingleBtnIndex)
            end
                return 
            end
            self.GamepadViewSingleBtnIndex = self:ShowGamepadShortcutBtn({        
            KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "A"
            }},
            Desc = GText("UI_Controller_CheckDetails")
        })
    else 
        if self.GamepadViewSingleBtnIndex then 
            self:HideGamepadShortcut(self.GamepadViewSingleBtnIndex)
            self.GamepadViewSingleBtnIndex = nil
        end
    end
end



function M:RefreshButton(CanReceiveAll)
    if not CanReceiveAll then
        self.Btn_GetAll:ForbidBtn(true)
    else
        self.Btn_GetAll:ForbidBtn(false)
    end
end

function M:OnTabSelected(TabWidget)
    if self.TabConfigDatas and self.TabConfigDatas[TabWidget.Idx] then
        self:Refresh(self.TabConfigDatas[TabWidget.Idx] )
    end
end

function M:Refresh(ConfigData)
    self.Items=ConfigData.Items
    self.Text_Total:SetText(GText(ConfigData.Text_Total))
    self.Text_Num:SetText(tostring(ConfigData.NowNum))
    self.Text_NumMax:SetText(tostring(ConfigData.NumMax))
    if not ConfigData.ShowIcon then
        self.Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        if ConfigData.IconPath then
            local Icon = LoadObject(ConfigData.IconPath)
            self.Icon:SetBrushResourceObject(Icon)
        end
        self.Icon:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.Btn_GetAll:SetText(GText(ConfigData.ReceiveButtonText))
    self.Btn_GetAll:UnBindEventOnClickedByObj(self)
    self.Btn_GetAll:BindEventOnClicked(self,function ()
            ConfigData.ReceiveAllParam.SelfWidget=self
            ConfigData.ReceiveAllCallBack(self,ConfigData.ReceiveAllParam)
    end)
    self:InitItem(ConfigData)
end

function M:OnNavigateUp(Content)
    --Content.SelfWidget.Btn_GetAll:SetGamePadIconVisible(false)
    local Id=Content.Id-1
    if Id>=0 then
        local Item = self.List_Item:GetItemAt(Id)
        self.List_Item:NavigateToIndex(Id)
        --Item.SelfWidget:SetFocus()
        return Item.SelfWidget:FocusToRewardItem()
    end
    return Content.SelfWidget:FocusToRewardItem()
end

function M:OnNavigateDown(Content)
    local Id=Content.Id+1
    local AllItemCount = self.List_Item:GetNumItems()-1
    if Id<=AllItemCount then
        local Item = self.List_Item:GetItemAt(Id)
        self.List_Item:NavigateToIndex(Id)
        --Item.SelfWidget:SetFocus()
        return Item.SelfWidget:FocusToRewardItem()
    end
    return Content.SelfWidget:FocusToRewardItem()
end


function M:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:OnMenuOpenChanged(bIsOpen)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if bIsOpen then
            self:UpdateUIStyle(false)
        else
            self:UpdateUIStyle(true)
        end
    end
end

function M:UpdateUIStyle(IsVisible)
    if IsVisible then
        if self.Owner then
            self:ShowGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
            self:ShowGamepadViewSingleBtn(true)
        end
    else
        if self.Owner then
            self.Owner:HideAllGamepadShortcut()
        end
    end
end


function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled=false
    -- 处理手柄相关的交互事件
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        if (InKeyName== UIConst.GamePadKey.FaceButtonTop and  not self.IsInViewMode)  then
            IsEventHandled=true
            self.Btn_GetAll:OnBtnClicked()
        end
    elseif InKeyName=="SpaceBar"  then
        IsEventHandled=true
        self.Btn_GetAll:OnBtnClicked()
    end
    -- if IsEventHandled then
    --     return UWidgetBlueprintLibrary.Handled()
    -- else
    --     return UWidgetBlueprintLibrary.UnHandled()
    -- end 
    return IsEventHandled
end

return M
