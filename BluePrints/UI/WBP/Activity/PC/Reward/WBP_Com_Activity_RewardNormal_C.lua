--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_Dialog
local M = Class({"Blueprints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()

end

function M:OnLoaded(...)
    local Params = ...
    local ConfigData=Params.ConfigData
    self.TabConfigDatas=Params.TabConfigDatas
    self.ConfigData=ConfigData
    self.Owner=Params.Owner
    self.Type=ConfigData.Type
    self.CurrentTab = nil
    --self:BindDialogEvent(DialogEvent.OnTitleTabSelected, self.OnTabSelected)
    -- ConfigData({
    --     IsPacking = false, 是否为强包类型
    --     TopText="", 顶部文本
    --     TimeText="", 时间文本
    --     RemainTimeDict={},倒计时数据
    --     IsExpired=true, 是否无结束时间
    --     HasTab=flase,  是否为带Tab类型
    --     Type="",当前的Type类型
    --     ReddotName="",
    --     InSoundPath="",
    --     OutSoundPath="",
    --     TabSoundPath="",Tab切换音效路径
    --     RefreshPanleCallBack,刷新面板回调
    --     ReceiveBtnSoundPath ="",领取音效路径
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
    --     PackingInfo={
    --        SmallItem = false, 初始化小Item类型
    --        BigItem = false, 初始化大Item类型
    --        RewardTitle="",特殊奖励标题文本
    --        RewardDesc=true, 特殊奖励描述文本
    --        BtnTips，领取按钮提示文本
    --        GetAllBtnText="", 领取按钮文本
    --        HideReceiveBtnInfo,隐藏领取按钮信息
    --        CanReceive=true, 是否可领取
    --        IsGot = false, 是否已领取
    --        IsShowGotoBtn=true, 是否显示前往按钮
    --        GotoCallBack,点击前往回调
    --        GotoParam={},前往所需参数
    --        CheckDetailCallBack,点击查看详情回调
    --        CheckDetailParam={},查看详情所需参数
    --        ReceveCallBack,点击领取后调用的RPC
    --        ReceiveBtnSoundPath="",特殊领取的音效
    --        ReceveParam={}, 领取所需的参数
    --        ShowSourceNum=true, 是否显示左下角数量
    --        SmallItemInfo={
    --              IsHeadIcon=true, 是否为头像Icon
    --              HeadIconId,头像Id
    --              HeadFrameId,头像框Id
    --              bUsebigHead=true, 是否使用大头像
    --              ComItemInfo={} 通用小道具框的InitData
    --                      },
    --        BigItemInfo={
    --              BGIconPath="",大图背景路径
    --              }
    --            }
    --    }    
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
    --              ReceiveBtnPath=""
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
    --          Text_Total="",左下角文本
    --          NumMax,总计获得
    --          NowNum,现在数量
    --          ReceiveAllCallBack,点击全部领取后调用的RPC
    --          ReceiveAllParam={}, 领取相关参数
    --          ReceiveButtonText="",
    --          NeedDailyRefresh = false, 是否需要跨日刷新
    --          DailyRefreshFunc ,每日刷新的函数
    --          HasDailyQuest,  是否有每日任务
    --          SortType=1,2,3   1:已经领取的Item置底 2:自动定位到未领取处
    --          }

    -- })
    self.Type2Index={}
    self.Datas=ConfigData.Datas
    self.Items=ConfigData.Items
    self.TabInfo=ConfigData.TabInfo
    self.HasTab=ConfigData.HasTab
    self.ReddotName=ConfigData.ReddotName
    -- if ConfigData.ShowTotalProgress ~= false then
    --     self.RewardContent_OneClick.Text_ProgressTitle:SetText(GText(ConfigData.Text_Total))
    --     self.RewardContent_OneClick.Count_Main:SetText(tostring(ConfigData.NowNum))
    --     self.RewardContent_OneClick.Max_Main:SetText(tostring(ConfigData.NumMax))
    --     self.RewardContent_OneClick.Progress_Main:SetPercent(ConfigData.NowNum / ConfigData.NumMax)
    -- else
    --     self.HorizontalBox_TotalProgress:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- end
    -- if not ConfigData.ShowIcon then
    --     self.Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- else
    --     if ConfigData.IconPath then
    --         local Icon = LoadObject(ConfigData.IconPath)
    --         self.Icon:SetBrushResourceObject(Icon)
    --         self.Icon:SetVisibility(UIConst.VisibilityOp.Visible)
    --     end
    -- end
    if self.Text_Tip then
        self.Text_Tip:SetText(GText("UI_CommonQuestRefreshTitle"))
    end
    if self.ConfigData.IsPacking then
        self.Btn_DesignGet:SetDefaultGamePadImg("X")
        self.Key_Check:CreateGamepadKey("View")
    end
    self.RewardContent_OneClick.Btn_OneClick:SetText(GText(ConfigData.ReceiveButtonText))
    self.RewardContent_OneClick.Btn_OneClick:SetDefaultGamePadImg("Y")
    self.RewardContent_OneClick.Btn_OneClick:UnBindEventOnClickedByObj(self)
    self.RewardContent_OneClick.Btn_OneClick:BindEventOnClicked(self,function ()
        if self.HasTab then
            ConfigData.Datas[self.Type].ReceiveAllParam.SelfWidget=self
            ConfigData.Datas[self.Type].ReceiveAllCallBack(self,ConfigData.Datas[self.Type].ReceiveAllParam)
        else
            ConfigData.ReceiveAllParam.SelfWidget=self
            ConfigData.ReceiveAllCallBack(self,ConfigData.ReceiveAllParam)
        end
    end)
    self.Com_Tab:Init({
        TitleName = GText(self.ConfigData.TopText or "PermanenEventReward"),
        DynamicNode = {"Back","BottomKey"},
        BottomKeyInfo = {
            {
                KeyInfoList =  {{Type="Text", Text="SpaceBar", Owner=self, ClickCallback=self.RewardContent_OneClick.Btn_OneClick.OnBtnClicked}}, Desc = GText("UI_Achievement_GetAllReward"), bLongPress = false
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                Desc = GText("UI_BACK"),
                bLongPress = false,
            },
        },
        BackCallback = self.CloseSelf,
        OwnerPanel = self,
    })
    if self.HasTab then
        self:InitListTabInfo()
        if not self.ConfigData.IsPacking then
            self:ScrollToSelectTab()
        end
    end
    if not self.HasTab then
        self:InitItem(ConfigData)
        self:Refresh(ConfigData)
    end
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:AddInputMethodChangedListen()
    if  UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        self:TryInitGamepadView()
        self.List_Item:SetFocus()
    else
        self:SetFocus()
    end
    if self.ConfigData.IsExpired then
        self.Com_Time:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Com_Time:SetTimeText(GText(self.ConfigData.TimeText or ""), self.ConfigData.RemainTimeDict or {})
    end
    if self.In then
        self:PlayAnimation(self.In)
    end
    self:InitPackingInfo(ConfigData.PackingInfo)
    EventManager:AddEvent(EventID.OnDailyRefresh, self, self.OnRefreshInNextDay)
    if ConfigData.InSoundPath then
         AudioManager(self):PlayUISound(nil,ConfigData.InSoundPath, "ActivityReward_InSound", nil)
    end
    if ConfigData.PackingInfo and ConfigData.PackingInfo.ReceiveBtnSoundPath then
        if self.Btn_DesignGet then
            self.Btn_DesignGet.AudioEventPath=ConfigData.PackingInfo.ReceiveBtnSoundPath
        end
    end
    if ConfigData.ReceiveBtnSoundPath then
        if self.RewardContent_OneClick.Btn_OneClick then
            self.RewardContent_OneClick.Btn_OneClick.AudioEventPath=ConfigData.ReceiveBtnSoundPath
        end
    end
    EventManager:AddEvent(EventID.RefreshAcvitityRewardPanel, self, self.RefreshAcvitityRewardPanel)
end

function M:RefreshAcvitityRewardPanel()
    if self.ConfigData.RefreshPanleCallBack then
        self.ConfigData.RefreshPanleCallBack(self)
    end
    -- local ConfigData = self.ConfigData
    -- if self.HasTab then
    --     ConfigData = self.ConfigData.Datas[self.Type]
    -- end
    -- if ConfigData.NeedDailyRefresh then
    --     if self.Text_Tip then
    --         self.Text_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    --     end
    -- else
    --     if self.Text_Tip then
    --         self.Text_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
    --     end
    -- end
    -- self.RewardContent_OneClick.Text_ProgressTitle:SetText(GText(ConfigData.Text_Total))
    -- self.RewardContent_OneClick.Count_Main:SetText(tostring(ConfigData.NowNum))
    -- self.RewardContent_OneClick.Max_Main:SetText(tostring(ConfigData.NumMax))
    -- self.RewardContent_OneClick.Progress_Main:SetPercent(ConfigData.NowNum / ConfigData.NumMax)
    -- self:RefreshBtnGetAll(ConfigData)
    -- for i = 0, self.List_Item:GetNumItems() - 1 do
    --     local Item = self.List_Item:GetItemAt(i)
    --     if Item and Item.SelfWidget then
    --         Item.SelfWidget:RefreshBtn(Item.Content)
    --     end
    -- end
end

function M:AddReddotChangedListen()
    --  注册一个监听回调，回调中遍历所有 TabInfo 并更新每个 tab 的红点显示
    local ReddotName = self.ReddotName
    if not ReddotName then
        return
    end
    ReddotManager.AddListenerEx(ReddotName, self, function(self, Count, RdType, RdName)
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
        for idx, Data in ipairs(self.ConfigData.TabInfo or {}) do
            if Data then
                local Type = Data.Type
                if CacheDetail and CacheDetail[Type] then
                    self.Com_TabSub:ShowTabRedDotByTabId(idx, false, true, false)
                else
                    self.Com_TabSub:ShowTabRedDotByTabId(idx, false, false, false)
                end
            end
        end
    end)
end

function M:InitPackingInfo(PackingInfo)
    if not PackingInfo then
        return
    end
    if PackingInfo.SmallItem then
        self.SmallItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.BigItem:SetVisibility(ESlateVisibility.Collapsed)
        if PackingInfo.IsHeadIcon then
            if PackingInfo.HeadFrameId then
                self.SmallItem.Com_ItemHead:SetHeadFrame(PackingInfo.HeadFrameId)
            else
                self.SmallItem.Com_ItemHead:SetHeadIcon(
                PackingInfo.SmallItemInfo.HeadIconId,
                PackingInfo.SmallItemInfo.bUsebigHead
            )
            end
                self.SmallItem.Com_ItemHead:SetHeadIcon(
                PackingInfo.SmallItemInfo.HeadIconId,
                PackingInfo.SmallItemInfo.Com_Item:Init(PackingInfo.ComItemInfo)
            )
        else
            self.SmallItem.Com_Item:Init(PackingInfo.SmallItemInfo.ComItemInfo)
        end
    end
    if PackingInfo.BigItem then
        if self.SmallItem then
            self.SmallItem:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.BigItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if PackingInfo.BigItem and PackingInfo.BigItemInfo and PackingInfo.BigItemInfo.BGIconPath then
         local Img =LoadObject(PackingInfo.BigItemInfo.BGIconPath)
            if Img then
                self.BigItem.Image_RewardItem:SetBrushResourceObject(Img)
            end
    end
    if PackingInfo.BtnDetailTips then
        self.Text_BtnDetailTips:SetText(GText(PackingInfo.BtnDetailTips))
    end
    if PackingInfo.ReceveCallBack then
        self.WS_Btn:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_DesignGet:BindEventOnClicked(self,function ()
            PackingInfo.ReceveParam.SelfWidget=self
            PackingInfo.ReceveCallBack(self,PackingInfo.ReceveParam)
        end)
        self.WS_Bottom:SetActiveWidgetIndex(0)
    else
        self.WS_Bottom:SetActiveWidgetIndex(1)
    end
    if PackingInfo.IsShowGotoBtn==false then
        self.WS_Btn:SetActiveWidgetIndex(1)
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
        self.Btn_Design:BindEventOnClicked(self,function ()
            PackingInfo.GotoCallBackCallBack(self,PackingInfo.GotoParam)
        end)
    end
    if PackingInfo.CheckDetailCallBack then
        self.Btn_Check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Check:BindEventOnClicked(self,function ()
            PackingInfo.CheckDetailCallBack(self,PackingInfo.CheckDetailParam)
        end)
    else
        self.Btn_Check:SetVisibility(ESlateVisibility.Collapsed)
    end
    if PackingInfo.CanReceive then
        self.Btn_DesignGet:ForbidBtn(false)
        self.Btn_DesignGet:SetText(GText("UI_Achievement_GetReward"))
    else
        if PackingInfo.IsGot then
            self.Btn_DesignGet:SetText(GText("UI_Reward_Received"))
        else
            self.Btn_DesignGet:SetText(GText("UI_Archive_CollectionInProgress"))
        end
        self.Btn_DesignGet:ForbidBtn(true)
    end
    if PackingInfo.GetAllBtnText then
        self.Btn_DesignGet:SetText(GText(PackingInfo.GetAllBtnText))
    end
    if PackingInfo.RewardTitle then
        self.Text_RewardTitle:SetText(GText(PackingInfo.RewardTitle))
    end
    if PackingInfo.RewardDesc then
        self.Text_RewardDesc:SetText(GText(PackingInfo.RewardDesc))
    end
    if PackingInfo.BtnTips then
        self.Text_BtnTips:SetText(GText(PackingInfo.BtnTips))
    end
    self.WS_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if PackingInfo.HideReceiveBtnInfo then
       self.WS_Bottom:SetVisibility(ESlateVisibility.Collapsed)
    end

end

function M:RefreshPackingGetBtn(CanReceive, IsGot)
    if CanReceive then
        self.Btn_DesignGet:ForbidBtn(false)
        self.Btn_DesignGet:SetText(GText("UI_Achievement_GetReward"))
    else
        if IsGot then
            self.Btn_DesignGet:SetText(GText("UI_Reward_Received"))
        else
            self.Btn_DesignGet:SetText(GText("UI_Archive_CollectionInProgress"))
        end
        self.Btn_DesignGet:ForbidBtn(true)
    end
end
    

function M:UpdateBottomKey(ShowGetAllButton)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if ShowGetAllButton then
        local  BottomKeyInfo = {
                {
                KeyInfoList =  {{Type="Text", Text="SpaceBar", Owner=self, ClickCallback=self.RewardContent_OneClick.Btn_OneClick.OnBtnClicked}}, Desc = GText("UI_Achievement_GetAllReward"), bLongPress = false
                },
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                    Desc = GText("UI_BACK"),
                    bLongPress = false,
                },
            }
        self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    else
        local  BottomKeyInfo = {
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                    Desc = GText("UI_BACK"),
                    bLongPress = false,
                },
            }
        self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    end
end


function M:CloseSelf()
    if self:IsAnimationPlaying(self.In) or self:IsAnimationPlaying(self.Out) then
        return
    end
    local UIManager = UIManager(self)
    local PreviousUI = UIManager:GetUnderState()
    if PreviousUI then
        local PreviousUIName = PreviousUI:GetName()
        DebugPrint("JLY 上一个栈的UI是:", PreviousUIName)
        if PreviousUIName == "ActivityMain" then
            EventManager:FireEvent(EventID.OnReturnToActivityEntry)
            EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
        end
        if PreviousUIName== "AutoChessMain" then
            PreviousUI:PlayAnimationForward(PreviousUI.In)
            PreviousUI:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, false, UE4.ESlateVisibility.HitTestInvisible)
        end
    end
    if self.ConfigData.InSoundPath then
        AudioManager(self):SetEventSoundParam(nil, "ActivityReward_InSound", {ToEnd = 1})
        --AudioManager(self):PlayUISound(nil,self.ConfigData.OutSoundPath, "InSound", nil)
    end
    if self.Out then
        self:UnbindAllFromAnimationFinished(self.Out)
        self:BindToAnimationFinished(self.Out, { self, self.Close })
        self:PlayAnimation(self.Out)
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
        self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
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
        self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(false)
        self:UpdateBottomKey(true)
    else
        self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
        self:UpdateBottomKey(false)
    end
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
        local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
        ItemContent.IsEmpty = true
        return ItemContent
    end)
    self.List_Item:RequestFillEmptyContent()
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
        end
        if a.ItemId and b.ItemId then
            return a.ItemId<b.ItemId
        else
            return false
        end
    end)
end

function M:RefreshItems()
    if self.HasTab then
        self:Refresh(self.ConfigData.Datas[self.Type])
    else
       self:Refresh(self.ConfigData)
    end
end

function M:RefreshDaily()
    if self.HasTab then
        if self.ConfigData.Datas[self.Type].HasDailyQuest then
            self:Refresh(self.ConfigData.Datas[self.Type])
        end
    else
       self:Refresh(self.ConfigData)
    end
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
    elseif (CurInputDevice == ECommonInputType.Gamepad) then
        self:TryInitGamepadView()
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
    if self.ConfigData.IsPacking then
        local SubTabList  = {}
        for Index,TabItem in ipairs(self.TabInfo) do
            table.insert(SubTabList,{
                Text = GText(TabItem.Title),
                TabId = Index,
                ShowRedDot = false,
                --ReddotName = TabItem.ReddotName,
            })
        end
        self.Com_TabSub:Init( { 
                PlatformName = self.Platform,
                LeftKey = "A", 
                RightKey = "D",
                Tabs = SubTabList 
            } )
        self.Com_TabSub:BindEventOnTabSelected(self, self.OnTabSelected)
        self.Com_TabSub:SelectTab(1)
        self:AddReddotChangedListen()
        if #SubTabList <= 1 then
            self.Group_DetailTab:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Group_DetailTab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
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
    self:PlayAnimation(self.Change)
    self:AddTimer(0.01,function ()
	    UIUtils.PlayListViewFramingInAnimation(self, self.List_Item, {
			AnimName="In"})
		end,false,0,nil,true)
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
            self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.HitTestInvisible)
        else
            self.RewardContent_OneClick.Btn_OneClick:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(false)
            self:UpdateBottomKey(true)
        end
    else
        self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
        self:UpdateBottomKey(false)
    end
end

function M:RefreshReddotInfo()
    local TabType = (self.SelectedContent and self.SelectedContent.Type) or self.Type
    if not TabType then
        DebugPrint("@@@ComDilaog Reward RefreshReddotInfo: no tab type to clear reddot", self.ReddotName)
        return
    end
    DebugPrint("@@@ComDilaog Reward Try Clear Reddot ReddotName:", self.ReddotName, " Type:", TabType)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotName)
    if CacheDetail[TabType] then
        local Num = 0
        for _,_ in pairs(CacheDetail[TabType]) do
            Num = Num + 1
        end
        CacheDetail[TabType] = nil
        DebugPrint("@@@ComDilaog Reward Clear Reddot ReddotName:", self.ReddotName, " Type:", TabType, " Num:", Num)
        ReddotManager.DecreaseLeafNodeCount(self.ReddotName, Num)
    end
end

function M:Destruct()
    self.Super.Destruct(self)
    ReddotManager.RemoveListener(self.ReddotName,self)
    EventManager:RemoveEvent(EventID.OnDailyRefresh, self)
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
            if Widget.Content then
                local Index = Widget.Content.Id
                if Index then
                    if (not TargetWidget) or (Index < TargetWidget.Content.Id) then
                        TargetWidget = Widget
                    end
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

function M:TryInitGamepadView()
    -- if self:HasAnyFocus() then
    --     self:InitGamepadView()
    -- end
    self:InitGamepadView()
end



function M:InitGamepadView()
    self:NavigateToFirstDisplayedItem(self.List_Item)
    --self:UpdateUIStyle(true)
    self.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(true)
    if not self.RewardContent_OneClick.Btn_OneClick:IsBtnForbidden() then 
        self.RewardContent_OneClick.Btn_OneClick:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    if self.ConfigData.IsPacking then
        self.Btn_DesignGet:SetGamePadIconVisible(true)
        if not self.Btn_DesignGet:IsBtnForbidden() then 
            self.Btn_DesignGet:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
    end
    if self.Key_Check then
        self.Key_Check:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self:ShowGamepadViewBtn(true)
    --self:ShowGamepadViewSingleBtn(false)
end

function M:InitKeyBoardView()
    self.IsInViewMode=false
    self.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(false)
    if not self.RewardContent_OneClick.Btn_OneClick:IsBtnForbidden() then 
        self.RewardContent_OneClick.Btn_OneClick:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if self.ConfigData.IsPacking then
        self.Btn_DesignGet:SetGamePadIconVisible(false)
        if not self.Btn_DesignGet:IsBtnForbidden() then 
            self.Btn_DesignGet:SetVisibility(UIConst.VisibilityOp.Visible)
        end
    end
    if self.Key_Check then
        self.Key_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:ShowGamepadViewBtn(false)
    --self:ShowGamepadViewSingleBtn(true)
    local ConfigData = self.Datas[self.Type]
    if not ConfigData then
        ConfigData = self.ConfigData
    end
    self:RefreshBtnGetAll(ConfigData)
    self:PlayAnimation(self.Normal)
end

function M:ShowGamepadScrollBtn(bShow)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if bShow then 
        -- if self.GamepadScrollBtnIndex then
        --     if self.Owner:GetGamepadShortcutByIndex(self.GamepadScrollBtnIndex) then
        --         self:ShowGamepadShortcut(self.GamepadViewBtnIndex)
        --     end
        --     return
        -- end
        -- self.GamepadScrollBtnIndex = self:ShowGamepadShortcutBtn({        
        --     KeyInfoList = {
        --     {
        --         Type = "Img",
        --         ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("LV", self.CurGamepadName)
        --     }},
        --     Desc = GText("UI_Controller_Slide")
        -- })
    else 
        -- if self.GamepadScrollBtnIndex then 
        --     self:HideGamepadShortcut(self.GamepadScrollBtnIndex)
        --     self.GamepadScrollBtnIndex = nil
        -- end
    end
end
--控制常态时需要显示的内容，true时为gamepad，false为keyboard
function M:ShowGamepadViewBtn(bShow)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if bShow then 
        local IsScrollable = self:CheckDescScrollable()
        if IsScrollable then
            self.Com_Tab:UpdateBottomKeyInfo({
                {
                    GamePadInfoList =  {{ Type="Img", ImgShortPath="RV", Owner=self }},
                    Desc = GText("UI_Controller_Slide"),
                    bLongPress = false,
                },
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                    Desc = GText("UI_BACK"),
                    bLongPress = false,
                },
            })
        else
            self.Com_Tab:UpdateBottomKeyInfo({
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                    Desc = GText("UI_BACK"),
                    bLongPress = false,
                },
            })
        end
        if self.ConfigData.IsPacking then
          self.Btn_DesignGet:SetGamePadIconVisible(true)
          self.Com_TabSub:UpdateUIStyleInPlatform(true)
        end
    else 
       self.Com_Tab:UpdateBottomKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                Desc = GText("UI_BACK"),
                bLongPress = false,
            },
        })
        if self.ConfigData.IsPacking then
          self.Btn_DesignGet:SetGamePadIconVisible(false)
          self.Com_TabSub:UpdateUIStyleInPlatform(false)
        end
    end
end

--进入奖励查看显示a,b,退出时隐藏
function M:ShowGamepadViewSingleBtn(bShow)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if bShow then 
        -- if self.GamepadViewSingleBtnIndex then 
        --     if self.Owner:GetGamepadShortcutByIndex(self.GamepadViewSingleBtnIndex) then
        --         self:ShowGamepadShortcut(self.GamepadViewSingleBtnIndex)
        --     end
        --         return 
        --     end
        --     self.GamepadViewSingleBtnIndex = self:ShowGamepadShortcutBtn({        
        --     KeyInfoList = {
        --     {
        --         Type = "Img",
        --         ImgShortPath = "A"
        --     }},
        --     Desc = GText("UI_Controller_CheckDetails")
        -- })
        self.Com_Tab:UpdateBottomKeyInfo({
            {
                GamePadInfoList =  {{ Type="Img", ImgShortPath="A", Owner=self }},
                Desc = GText("UI_Controller_CheckReward"),
                bLongPress = false,
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
                Desc = GText("UI_BACK"),
                bLongPress = false,
            },
        })
    else 
        self.Com_Tab:UpdateBottomKeyInfo({
            -- {
            --     KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
            --     GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnReturnKeyDown, Owner=self}},
            --     Desc = GText("UI_BACK"),
            --     bLongPress = false,
            -- },
        })
        -- if self.GamepadViewSingleBtnIndex then 
        --     self:HideGamepadShortcut(self.GamepadViewSingleBtnIndex)
        --     self.GamepadViewSingleBtnIndex = nil
        -- end
    end
end



function M:RefreshButton(CanReceiveAll)
    if not CanReceiveAll then
        self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(true)
        self:UpdateBottomKey(false)
    else
        self.RewardContent_OneClick.Btn_OneClick:ForbidBtn(false)
        self:UpdateBottomKey(true)
    end
end

function M:OnTabSelected(TabWidget)
    if self.ConfigData and self.ConfigData.TabInfo[TabWidget.Idx] then
        self:RealRefreshListRewardInfo(self.ConfigData.TabInfo[TabWidget.Idx].Type)
    end
end

function M:Refresh(ConfigData)
    self.Items=ConfigData.Items
    if ConfigData.NeedDailyRefresh then
        if self.Text_Tip then
            self.Text_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    else
        if self.Text_Tip then
            self.Text_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    self.RewardContent_OneClick.Text_ProgressTitle:SetText(GText(ConfigData.Text_Total))
    self.RewardContent_OneClick.Count_Main:SetText(tostring(ConfigData.NowNum))
    self.RewardContent_OneClick.Max_Main:SetText(tostring(ConfigData.NumMax))
    self.RewardContent_OneClick.Progress_Main:SetPercent(ConfigData.NowNum / ConfigData.NumMax)
    -- if not ConfigData.ShowIcon then
    --     self.Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- else
    --     if ConfigData.IconPath then
    --         local Icon = LoadObject(ConfigData.IconPath)
    --         self.Icon:SetBrushResourceObject(Icon)
    --     end
    --     self.Icon:SetVisibility(UIConst.VisibilityOp.Visible)
    -- end
    self.RewardContent_OneClick.Btn_OneClick:SetText(GText(ConfigData.ReceiveButtonText))
    self.RewardContent_OneClick.Btn_OneClick:UnBindEventOnClickedByObj(self)
    self.RewardContent_OneClick.Btn_OneClick:BindEventOnClicked(self,function ()
            ConfigData.ReceiveAllParam.SelfWidget=self
            ConfigData.ReceiveAllCallBack(self,ConfigData.ReceiveAllParam)
    end)
    self:InitItem(ConfigData)
end

function M:OnNavigateUp(Content)
    --Content.SelfWidget.self.RewardContent_OneClick.Btn_OneClick:SetGamePadIconVisible(false)
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
        self:ShowGamepadViewSingleBtn(true)
        -- if self.ConfigData.IsPacking then
        --     self.Btn_DesignGet:SetGamePadIconVisible(true)
        --     if self.Key_Check then
        --         self.Key_Check:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        --     end
        -- end
    else
        self:ShowGamepadViewSingleBtn(false)
        -- if self.ConfigData.IsPacking then
        --     if self.Key_Check then
        --         self.Key_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
        --     end
        --     self.Btn_DesignGet:SetGamePadIconVisible(false)
        -- end
    end
end

function M:OnRefreshInNextDay()
    if self.ConfigData.DailyRefreshFunc then
            local Params = {}
            local RefreshParam = {}
            RefreshParam.SelfWidget =self
			Params.RightCallbackFunction = function()
			    self.ConfigData.DailyRefreshFunc(self,RefreshParam)
			end
			UIManager(self):ShowCommonPopupUI(100310, Params)
        end
end


function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled=false
    -- 处理手柄相关的交互事件
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        if (InKeyName== UIConst.GamePadKey.FaceButtonTop and  not self.IsInViewMode)  then
            IsEventHandled=true
            self.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
        else
            if self.ConfigData.IsPacking then
                IsEventHandled = self.Com_TabSub:Handle_KeyEventOnGamePad(InKeyName)
            end
        end
        if InKeyName == UIConst.GamePadKey.FaceButtonRight then
            IsEventHandled = true
            self:CloseSelf()
        end
        if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
            if self.ConfigData.IsPacking then
                self.Btn_DesignGet:OnBtnClicked()
            end
        end
        if InKeyName == UIConst.GamePadKey.SpecialLeft then
            if self.ConfigData.IsPacking then
                if self.ConfigData.PackingInfo.CheckDetailCallBack then
                    self.ConfigData.PackingInfo.CheckDetailCallBack(self,self.ConfigData.PackingInfo.CheckDetailParam)
                end
            end
        end
    elseif InKeyName=="SpaceBar"  then
        IsEventHandled=true
        self.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
    elseif InKeyName=="Escape"  then
        IsEventHandled=true
        self:CloseSelf()
    end
    if self.ConfigData.IsPacking and not IsEventHandled then
        IsEventHandled = self.Com_TabSub:Handle_KeyEventOnPC(InKeyName)
    end
    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end 
    --return IsEventHandled
end

-- 检查描述内容是否超出一屏
function M:CheckDescScrollable()
    if not self.EMScroll_Desc then
        return false
    end
    
    local ScrollOffsetMax = self.EMScroll_Desc:GetScrollOffsetOfEnd()
    
    -- 如果最大滚动偏移量大于0，说明内容超出一屏
    return ScrollOffsetMax > 0
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
    local AxisValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    -- 检查是否为右摇杆垂直轴（Gamepad_RightY）
    if KeyName == "Gamepad_RightY" then
        if self.EMScroll_Desc and self:CheckDescScrollable() and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            local CurrentOffset = self.EMScroll_Desc:GetScrollOffset()
            local ScrollSpeed = 10.0 -- 滚动速度
            local NewOffset = CurrentOffset - (AxisValue * ScrollSpeed)
            local MaxOffset = self.EMScroll_Desc:GetScrollOffsetOfEnd()
            NewOffset = math.max(0, math.min(NewOffset, MaxOffset))
            self.EMScroll_Desc:SetScrollOffset(NewOffset)
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
