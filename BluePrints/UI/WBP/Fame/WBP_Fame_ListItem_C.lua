--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Fame_ListItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.BtnReward_1.Button_Area.OnClicked:Add(self, self.OnReceiveBtnClicked)
end

function M:Destruct()
    self.BtnReward_1.Button_Area.OnClicked:Remove(self, self.OnReceiveBtnClicked)
end

function M:OnListItemObjectSet(Content)
    rawset(self, "Content", Content)
    -- 领奖状态 0 不可领取 1 可领取 2 已领取
    rawset(self, "State", Content.State)
    -- 当前奖励对应等级
    rawset(self, "Level", Content.Level)
    rawset(self, "RewardID", Content.RewardID)
    rawset(self, "FameModel", Content.FameModel)
    rawset(self, "RegionId", Content.RegionId)
    rawset(self, "Parent", Content.Parent)
    rawset(self, "Index", Content.Index)
    rawset(self, "OnMenuOpenChanged", Content.OnMenuOpenChanged)
    rawset(self, "OnReceiveRewardCallBack", Content.OnReceiveRewardCallBack)

    self.RichTextContent:SetText(string.format(GText("ReputationLevel_ListContent"), self.Level))
    self:InitRewardList()
    self:InitBtn()
    Content.SelfWidget = self
end

function M:InitRewardList()
    local RewardData = DataMgr.Reward[self.RewardID]
    if not RewardData then
        UEPrint(string.format("WBP_Fame_ListItem_C InitRewardList not find RewardID Data %d", self.RewardID))
        return
    end
    self.ListItem:ClearListItems()
    for i = 1, #RewardData.Id do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local Id = RewardData.Id[i]
        local Type = RewardData.Type[i]
        local ResourceInfo
        if DataMgr[Type] and DataMgr[Type][Id] then
            ResourceInfo = DataMgr[Type][Id]
        else
            UEPrint(string.format("WBP_Fame_ListItem_C InitRewardList not find ResourceInfo Data Type:%s Id:%d", tostring(Type), tostring(Id)))
            ResourceInfo = {
                Rarity = 1,
                Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'"
            }
        end
        Content.ItemType = Type
        Content.Id = Id
        Content.Rarity = ResourceInfo.Rarity
        Content.Icon = ResourceInfo.Icon
        Content.IsShowDetails = true
        Content.Count = RewardData.Count[i][1]
        Content.bHasGot = self.State == CommonConst.FameRewardState.AlreadyClaimed
        Content.OnMenuOpenChangedEvents = {Obj = self.Parent, Callback = self.OnMenuOpenChanged}
        self.ListItem:AddItem(Content)
    end
end

function M:InitBtn()
    local SwitcherIdx = 0
    if self.State == CommonConst.FameRewardState.ReadyClaim then
        SwitcherIdx = 0
        self.BtnReward_1:SetText(GText("UI_GameEvent_ClaimReward"))
    elseif self.State == CommonConst.FameRewardState.AlreadyClaimed then
        SwitcherIdx = 1
    elseif self.State == CommonConst.FameRewardState.NotClaimable then
        SwitcherIdx = 2
        self.TextBlock_92:SetText(GText("UI_EventReward_NotAchieved"))
    end
    self.Switcher_Btn:SetActiveWidgetIndex(SwitcherIdx)
end

function M:OnReceiveBtnClicked()
    if self.State ~= CommonConst.FameRewardState.ReadyClaim then
        return
    end
	local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GetRegionReputationLevelReward(self.RegionId, {self.Level}, self.OnReceiveRewardCallBack)
    end
end

--region 输入相关
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadButtonDown(InKeyName)
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:Handle_OnGamePadButtonDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        self:OnReceiveBtnClicked()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        rawset(self, "bFocusedList", true)
        self.ListItem:NavigateToIndex(0)
        self.ListItem:SetFocus()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.bFocusedList then
            rawset(self, "bFocusedList", false)
            self:SetFocus()
            IsEventHandled = true
        end
    end
    return IsEventHandled
end
--endrehion

--region 手柄相关
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self.Parent.UpdateSelectedRewardIdx(self.Parent, self.Index)
    if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
        rawset(self, "bFocused", true)
        self:UpdateGamePadStyle()
        self:PlayAnimation(self.Hover)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusLost(InFocusEvent)
    if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.bFocused then
            self:PlayAnimation(self.UnHover)
        end
        rawset(self, "bFocused", false)
        self:UpdateGamePadStyle()
    end
end

function M:UpdateGamePadStyle()
    if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad and self.bFocused then
        if not rawget(self, "GamePadKeyInited") then
            rawset(self, "GamePadKeyInited", true)
            self.WBP_Com_KeyImg:CreateCommonKey({KeyInfoList = {{
                Type = "Img",
                ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("X", self.Parent.CurGamepadName)}
            }})
        end
        self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:AddDelayFrameFunc(function()
            self.BtnReward_1:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self:SetFocus()
        end, 1)
    else
        if self.bFocused then
            self:PlayAnimation(self.UnHover)
        end
        self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:AddDelayFrameFunc(function()
            self.BtnReward_1:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
        end, 1)
    end
end
--endregion

return M
