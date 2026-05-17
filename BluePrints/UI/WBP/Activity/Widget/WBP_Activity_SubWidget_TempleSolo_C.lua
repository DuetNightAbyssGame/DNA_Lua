--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Temple_Solo_Reward_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
    self.EventId = ActivityConfigData and ActivityConfigData.EventId or 108001
    self:UpdatePage()
    self:BindButtonPerformances()
    self.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:InitController()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:AddInputMethodChangedListen()
    end

    self:RefreshReddotInfo()
    self:InitReddotListen()
end

function M:InitController()
    self.Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y"
            }
        }
    })
end

function M:Destruct()
    self:UnbindButtonPerformances()
end

function M:BindButtonPerformances()
    self.Btn_Click.OnClicked:Add(self, self.OnClicked)
end

function M:UnbindButtonPerformances()
    self.Btn_Click.OnClicked:Clear()
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

function M:UpdatePage()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    self.Text_Reward:SetText(GText("UI_TempleEvent_RewardProgress"))
end

function M:OnClicked()
    -- local Params = self:MakeRewardData()
    if not self.EventId then
        self.EventId = 108001
    end

    local Avatar = GWorld:GetAvatar()
    local TempleData = Avatar.Temple[108001]
    local Params={}
    Params.ConfigData={}
    Params.ConfigData.TabInfo={}
    Params.ConfigData.Items={}
    Params.ConfigData.HasTab=true
    Params.ConfigData.Datas={}
    Params.ConfigData.ShowIcon = true
    Params.ConfigData.IconPath ='/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star.T_Activity_Temple_Solo_Star'
    Params.Title = GText("UI_TempleEvent_RewardProgress")

    local TempleTaskData = DataMgr["TempleEventReward"]
    local TabTypes = {
        GText("UI_TempleEvent_NormalMode"),
        GText("UI_TempleEvent_HardMode"),
    }

    local TabNum = {}
    local CurrentStars = 0
    local CurrentHardStars = 0
    local MaxStars = 0
    local MaxHardStars = 0

    local SortedTempleTaskData = {}
    for RewardId, TaskInfo in pairs(TempleTaskData) do
        local Item = {
            Id = RewardId,
            Data = TaskInfo
        }
        table.insert(SortedTempleTaskData, Item)
    end
    table.sort(SortedTempleTaskData, function(a, b)
        return a.Id < b.Id
    end)

    for i = 1, #TabTypes do
        local TabItem={}
        TabItem.Index = i
        TabItem.Type = i
        TabItem.Title = GText(TabTypes[i])
        TabItem.IsShowIcon = false
        TabItem.ReddotName = "TempleSoloEventReward"
        table.insert(Params.ConfigData.TabInfo,TabItem)
        local RewardData={}
        RewardData.ShowIcon=false
        RewardData.NowNum = 1
        RewardData.NumMax = 2
        -- RewardData.ReceiveAllCallBack = self.GetAllRewards or self.Owner.GetAllRewards
        RewardData.ReceiveAllCallBack = self.GetAllRewards
        -- RewardData.ReceiveAllParam = {Index = i}
        RewardData.ReceiveAllParam = {
            EventId = self.EventId,
            TabIndex = i,
            IsHardMode = (i == 2),
        }
        RewardData.Type = TabTypes[i]
        RewardData.Text_Total = string.format(GText("UI_TempleEvent_StarHasGot"),1,2)
        RewardData.ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")
        RewardData.Items = {}
        Params.ConfigData.Datas[i] = RewardData

        TabNum[i] = {NowNum = 0, NumMax = 0}
    end

    for k, v in pairs (DataMgr.TempleEventLevel) do
        if TempleData and TempleData.FinishStars[k] then
            if v.IsHardMode then    
                CurrentHardStars = CurrentHardStars + TempleData.FinishStars[k]
            else
                CurrentStars = CurrentStars + TempleData.FinishStars[k]
            end
        end
        if v.IsHardMode then    
            MaxHardStars = MaxHardStars + 3
        else
            MaxStars = MaxStars + 3
        end
    end

    for _, Data in pairs(SortedTempleTaskData) do
        local RewardId = Data.Id
        local TaskInfo = Data.Data
        local TempleEventData = Avatar.Temple and Avatar.Temple[self.EventId]
        local Item={}
        local RewardState = 0
        if TempleEventData and TempleEventData.ProgressRewardsGot and TempleEventData.ProgressRewardsGot[RewardId] then
            if TempleEventData.ProgressRewardsGot[RewardId] == 1 then
                RewardState = 1
            elseif TempleEventData.ProgressRewardsGot[RewardId] == 2 then
                RewardState = 2
            end
        end
        Item.ItemId = RewardId
        Item.Type = TaskInfo.IsHardMode and 2 or 1
        -- Item.CanReceive = (TaskInfo.IsHardMode and (CurrentHardStars >= TaskInfo.StarRequired)) or (not TaskInfo.IsHardMode and (CurrentStars >= TaskInfo.StarRequired))
        Item.CanReceive = RewardState == 1
        Item.RewardsGot = RewardState == 2
        Item.ReddotName = "TempleSoloEventReward"
        Item.ReceiveCallBack = self.GetRewards
        Item.NotreachText=GText("UI_Archive_CollectionInProgress")
        Item.Hint = GText("UI_TempleEvent_RewardTarget")
        Item.SourceNum = TaskInfo.StarRequired
        Item.ShowIcon = true
        Item.IconPath =TaskInfo.IsHardMode and '/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star_Challenge.T_Activity_Temple_Solo_Star_Challenge' 
            or '/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star.T_Activity_Temple_Solo_Star' 
        local Rewards={}
        local RewardItemId = TaskInfo.RewardId
        local RewardInfo = DataMgr.Reward[RewardItemId]
        if RewardInfo then
            local Ids = RewardInfo.Id or {}
            local RewardCount = RewardInfo.Count or {}
            local TableName = RewardInfo.Type or {}
            for i = 1, #Ids do
                local ItemId = Ids[i]
                local Count = RewardUtils:GetCount(RewardCount[i])
                local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                local ItemType = TableName[i]
                local RewardContent = {
                    ItemType = ItemType,
                    ItemId = ItemId,
                    Count = Count,
                    Rarity = Rarity,
                }
                table.insert(Rewards, RewardContent)
            end
        end
        Item.Rewards=Rewards
        table.insert(Params.ConfigData.Datas[Item.Type].Items,Item)
        TabNum[Item.Type].NowNum = TaskInfo.IsHardMode and CurrentHardStars or CurrentStars
        TabNum[Item.Type].NumMax = TaskInfo.IsHardMode and MaxHardStars or MaxStars
    end

    for i = 1, #TabTypes do
        Params.ConfigData.Datas[i].NowNum = TabNum[i].NowNum
        Params.ConfigData.Datas[i].NumMax = TabNum[i].NumMax
        Params.ConfigData.Datas[i].ShowIcon = true
        Params.ConfigData.Datas[i].IconPath = Params.ConfigData.Datas[i].Items[1].IconPath
        -- DebugPrint("ayff test path :",Params.ConfigData.Datas[i].IconPath)
    end

    Params.ConfigData.Type=Params.ConfigData.TabInfo[1].Type
    Params.ConfigData.ReddotName = "TempleSoloEventReward"
    -- return Params

    UIManager(self):ShowCommonPopupUI(100261, Params)
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/shop_small_btn_click", nil, nil)
    self:PlayAnimation(self.Click)
end

function M:GetRewards(Content)
    local Avatar = GWorld:GetAvatar()
    local Temple = Avatar.Temple
    local TempleRewardId = Content.ConfigData.ItemId
    if Avatar then
        local Callback = function(ErrCode, Ret)
            Content.ConfigData.CanReceive = false
            Content.ConfigData.RewardsGot = true
            Content.SelfWidget:RefreshBtn(ErrCode == 0)
            Content.SelfWidget:RefreshReddotInfo()
            Content.Owner:RealRefreshListRewardInfo(Content.ConfigData.Type)
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Ret, false, nil, nil, false)
        end
        Avatar:TempleGetReward(TempleRewardId, Callback)
    end
end

function M:GetAllRewards(Content)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(ErrCode, Ret)
            local HaveReWardToGet = false
            for i = 0,Content.SelfWidget.List_Item:GetNumItems() - 1 do
                local Item = Content.SelfWidget.List_Item:GetItemAt(i)
                if Item.ConfigData.CanReceive == true then
                    Item.ConfigData.CanReceive = false
                    Item.ConfigData.RewardsGot = true
                end
                if Item.SelfWidget then
                    Item.SelfWidget:RefreshBtn(Item.ConfigData.RewardsGot)
                end
            end
            Content.SelfWidget:RefreshBtnGetAll(Content.SelfWidget)
            Content.SelfWidget:RefreshReddotInfo()
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Ret, false, nil, nil, false)
        end
        local IsHardMode = Content.IsHardMode
        Avatar:TempleGetAllModeReward(108001, IsHardMode, CallBack)
    end
end

function M:MakeRewardData()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MouseEvent)
    self:PlayAnimation(self.UnHover)
end

-- 手柄相关操作
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("ayff temple solo sub widget RefreshOpInfoByInputDevice",CurInputDevice, CurGamepadName)
    --- 输入设备切换通知
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:GamepadToPC()
    elseif CurInputDevice == ECommonInputType.Gamepad then
        self:PCToGamepad()
    end
    self.CurInputDeviceType = CurInputDevice
end

function M:PCToGamepad()
    self.Controller:SetVisibility(UE4.ESlateVisibility.Visible)
end

function M:GamepadToPC()
    self.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled=false
    if InKeyName== UIConst.GamePadKey.FaceButtonTop then
        IsEventHandled=true
        self:OnClicked()
    end
    return IsEventHandled
end

function M:InitReddotListen()
    if not self.ListenerAdded then
        self.ListenerAdded = true
        if not ReddotManager.GetTreeNode("TempleSoloEventReward") then
            ReddotManager.AddNodeEx("TempleSoloEventReward")
        end
        ReddotManager.AddListenerEx("TempleSoloEventReward",self,self.OnTempleRewardReddotChange)
    end
end

function M:OnTempleRewardReddotChange(Count)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloEventReward")
    if Count > 0 then
        self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:RefreshReddotInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    Avatar:RefreshTempleSoloEventRewardReddot()
    -- Avatar:TempleGetReward()
end

-- end

return M
