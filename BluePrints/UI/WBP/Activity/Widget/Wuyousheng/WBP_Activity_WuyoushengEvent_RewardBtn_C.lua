--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
---@type WBP_Activity_Jump_Fort_TaskProgress_C
local M = Class({"Blueprints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Init(ActivityConfigData, EventId)
    if ActivityConfigData and ActivityConfigData.EventId then
        self.EventId = ActivityConfigData.EventId
    elseif EventId then
        self.EventId = EventId
    else
        self.EventId = 110001
    end
    self:SetText(GText("PermanenEventReward"))
    self:BindEventOnClicked(self,self.OpenReward)
    self.Key_Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y"
            }
        }
    })
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
     if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:AddInputMethodChangedListen()
    end
    if not self.AddListenerFinish then
        self.AddListenerFinish = true
        ReddotManager.AddListenerEx("WuyoushengReward",self,self.RefreshReddot)
    end
    self:RefreshReddot()
end

function M:RefreshReddot()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("WuyoushengReward")
    if not CacheDetail then
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    else
        local IsEmpty=true
        for DungeonId, CanReceive in pairs(CacheDetail) do
            if CanReceive then
                IsEmpty=false
                break
            end
        end
        if not IsEmpty then
            self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
            EventManager:FireEvent(EventID.RefreshWuyoushengLevelReddot)
        end
    end
end


function M:Construct()
    self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

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


function M:Destruct()
    self:RemoveInputMethodChangedListen()
    self.Super.Destruct(self)
end

function M:SetText(Text)
    self.Text_Reward:SetText(Text)
end

function M:BindEventOnClicked(Obj, Func, Params)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = Params
end

function M:OnBtnHovered()
	self.IsHovering = true
	if self.IsPressing then
        return
    end
	self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
	self.IsHovering = false
	if not self.IsPressing then
		self:StopAllAnimations()
		self:PlayAnimation(self.Unhover)
	end
end

function M:OnBtnPressed()
	self.IsPressing = true
	self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
    self.IsPressing = false
    if not self.IsHovering then
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Normal)
    else
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Hover)
    end
end

function M:OnBtnClicked()
	self:StopAllAnimations()
	self:PlayAnimation(self.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/gift_entrance_btn_click", nil, nil)
    if self.Obj and self.Func then
        if self.Params then
            self.Func(self.Obj, table.unpack(self.Params))
        else
            self.Func(self.Obj)
        end
    end
end

function M:OpenReward()
    if not self.EventId then
        self.EventId = 110001
    end
    self.EventId = math.floor(tonumber(self.EventId) or 110001)

    local Avatar = GWorld:GetAvatar()
    local WuyoushengData = Avatar.WuyoushengActivity and Avatar.WuyoushengActivity[self.EventId]
    local Params={}
    Params.ConfigData={}
    Params.ConfigData.HasTab=false
    Params.ConfigData.Items={}
    Params.ConfigData.ShowIcon = true
    Params.ConfigData.IconPath ='/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star.T_Activity_Temple_Solo_Star'
    Params.ConfigData.ReddotName = "WuyoushengReward"
    Params.Title = GText("PermanenEventReward")

    local WuyoushengTaskData = DataMgr["WuyoushengEventReward"]
    
    local CurrentStars = 0
    local MaxStars = 0

    local SortedWuyoushengTaskData = {}
    for RewardKeyId, TaskInfo in pairs(WuyoushengTaskData) do
        if TaskInfo.EventId == self.EventId then
            local Item = {
                Id = RewardKeyId,
                Data = TaskInfo
            }
            table.insert(SortedWuyoushengTaskData, Item)
        end
    end
    table.sort(SortedWuyoushengTaskData, function(a, b)
        return a.Id < b.Id
    end)

    if WuyoushengData then
        CurrentStars = WuyoushengData:GetTotalStars() or 0
    end

    for _, Data in pairs(SortedWuyoushengTaskData) do
        local RewardKeyId = Data.Id
        local TaskInfo = Data.Data
        local Item={}
        local RewardState = 0
        if WuyoushengData and WuyoushengData.ProgressRewardsGot and WuyoushengData.ProgressRewardsGot[RewardKeyId] then
            if WuyoushengData.ProgressRewardsGot[RewardKeyId] == 1 then
                RewardState = 1
            end
        end
        local CanReceive = false
        if WuyoushengData then
            CanReceive = WuyoushengData:IsCompleted(RewardKeyId, TaskInfo.RequiredStar) and not WuyoushengData:IsRewarded(RewardKeyId)
        end
        
        Item.ItemId = RewardKeyId
        Item.CanReceive = CanReceive
        Item.RewardsGot = RewardState == 1
        Item.ReddotName = "WuyoushengReward"
        Item.ReceiveCallBack = self.GetRewards
        Item.NotreachText=GText("UI_Archive_CollectionInProgress")
        Item.Hint = GText("UI_TempleEvent_RewardTarget")
        Item.SourceNum = TaskInfo.RequiredStar
        Item.ShowIcon = true
        Item.IconPath = '/Game/UI/Texture/Dynamic/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star.T_Activity_Temple_Solo_Star'
        local Rewards={}
        local RewardItemId = TaskInfo.Reward
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
        table.insert(Params.ConfigData.Items,Item)
        MaxStars = math.max(MaxStars, TaskInfo.RequiredStar)
    end

    Params.ConfigData.NowNum = CurrentStars
    Params.ConfigData.NumMax = MaxStars
    Params.ConfigData.ShowIcon = true
    if #Params.ConfigData.Items > 0 then
        Params.ConfigData.IconPath = Params.ConfigData.Items[1].IconPath
    end
    Params.ConfigData.Text_Total = string.format(GText("UI_TempleEvent_StarHasGot"), CurrentStars, MaxStars)
    Params.ConfigData.ReceiveAllCallBack = self.GetAllRewards
    Params.ConfigData.ReceiveAllParam = {
        EventId = self.EventId,
    }
    Params.ConfigData.ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")

    UIManager(self):ShowCommonPopupUI(100158, Params)
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/shop_small_btn_click", nil, nil)
    self:PlayAnimation(self.Click)
end

function M:GetRewards(Content)
    local Avatar = GWorld:GetAvatar()
    local RewardKeyId = Content.ConfigData.ItemId
    if Avatar then
        local EventId = self.EventId or 110001
        local Callback = function(ErrCode, Ret)
            if ErrCode == 0 then
                Content.ConfigData.CanReceive = false
                Content.ConfigData.RewardsGot = true
                Content.SelfWidget:RefreshBtn(ErrCode == 0)
                
                -- 更新红点缓存状态
                local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("WuyoushengReward")
                if CacheDetail and CacheDetail[RewardKeyId] then
                    CacheDetail[RewardKeyId] = false
                    ReddotManager.DecreaseLeafNodeCount("WuyoushengReward")
                end
                
                -- 检查是否还有可以领奖的奖励
                local HasCanReceive = false
                local Avatar = GWorld:GetAvatar()
                if Avatar then
                    local WuyoushengData = Avatar.WuyoushengActivity and Avatar.WuyoushengActivity[EventId]
                    local WuyoushengTaskData = DataMgr["WuyoushengEventReward"]
                    if WuyoushengData and WuyoushengTaskData and Content.SelfWidget and Content.SelfWidget.List_Item then
                        for i = 0, Content.SelfWidget.List_Item:GetNumItems() - 1 do
                            local Item = Content.SelfWidget.List_Item:GetItemAt(i)
                            if Item and Item.ConfigData then
                                local RewardKeyId = Item.ConfigData.ItemId
                                local TaskInfo = WuyoushengTaskData[RewardKeyId]
                                if TaskInfo and TaskInfo.EventId == EventId then
                                    local CanReceive = WuyoushengData:IsCompleted(RewardKeyId, TaskInfo.RequiredStar) and not WuyoushengData:IsRewarded(RewardKeyId)
                                    if CanReceive then
                                        HasCanReceive = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                Content.Owner:RefreshButton(HasCanReceive)
                EventManager:FireEvent(EventID.RefreshWuyoushengReddot)
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Ret, false, nil, nil, false)
        end
        Avatar:WuyoushengGetReward(EventId, RewardKeyId, Callback)
    end
end

function M:GetAllRewards(Content)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local EventId = self.EventId or 110001
        local function CallBack(ErrCode, Ret)
            if ErrCode == 0 then
                local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("WuyoushengReward")
                local DecreaseCount = 0
                
                for i = 0, Content.SelfWidget.List_Item:GetNumItems() - 1 do
                    local Item = Content.SelfWidget.List_Item:GetItemAt(i)
                    if Item.ConfigData.CanReceive == true then
                        Item.ConfigData.CanReceive = false
                        Item.ConfigData.RewardsGot = true
                        
                        -- 更新红点缓存状态
                        if CacheDetail and CacheDetail[Item.ConfigData.ItemId] then
                            CacheDetail[Item.ConfigData.ItemId] = false
                            DecreaseCount = DecreaseCount + 1
                        end
                    end
                    if Item.SelfWidget then
                        Item.SelfWidget:RefreshBtn(Item.ConfigData.RewardsGot)
                    end
                end
                
                -- 减少红点计数
                if DecreaseCount > 0 then
                    ReddotManager.DecreaseLeafNodeCount("WuyoushengReward", DecreaseCount)
                end
                
                -- 检查是否还有可以领奖的奖励
                local HasCanReceive = false
                local Avatar = GWorld:GetAvatar()
                if Avatar then
                    local WuyoushengData = Avatar.WuyoushengActivity and Avatar.WuyoushengActivity[EventId]
                    local WuyoushengTaskData = DataMgr["WuyoushengEventReward"]
                    if WuyoushengData and WuyoushengTaskData and Content.SelfWidget and Content.SelfWidget.List_Item then
                        for i = 0, Content.SelfWidget.List_Item:GetNumItems() - 1 do
                            local Item = Content.SelfWidget.List_Item:GetItemAt(i)
                            if Item and Item.ConfigData then
                                local RewardKeyId = Item.ConfigData.ItemId
                                local TaskInfo = WuyoushengTaskData[RewardKeyId]
                                if TaskInfo and TaskInfo.EventId == EventId then
                                    local CanReceive = WuyoushengData:IsCompleted(RewardKeyId, TaskInfo.RequiredStar) and not WuyoushengData:IsRewarded(RewardKeyId)
                                    if CanReceive then
                                        HasCanReceive = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                EventManager:FireEvent(EventID.RefreshWuyoushengReddot)
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Ret, false, nil, nil, false)
                Content.SelfWidget:RefreshButton(false)
            end
        end
        Avatar:WuyoushengGetAllReward(EventId, CallBack)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:InitKeyBoardView()
    elseif CurInputDevice==ECommonInputType.Gamepad then
        self:InitGamepadView()
    end
    -- 更新当前输入设备类型
    self.CurInputDeviceType = CurInputDevice
end

function M:InitKeyBoardView()
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitGamepadView()
     self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled=false
    if InKeyName== UIConst.GamePadKey.FaceButtonTop then
        IsEventHandled=true
        self:OnBtnClicked()
    end
    return IsEventHandled
end

function M:OnUpdateSubUIViewStyle(IsEnter)
    if IsEnter then
        self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end
return M

