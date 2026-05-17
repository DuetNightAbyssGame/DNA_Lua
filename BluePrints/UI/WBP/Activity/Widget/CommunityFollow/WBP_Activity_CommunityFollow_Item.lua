--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_CommunityFollow_Item_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

function M:Construct()
    self.Btn_Jump.Button_Area.OnClicked:Add(self, self.OnBtnJumpClicked)
    self.Btn_Reward.Button_Area.OnClicked:Add(self, self.OnBtnRewardClicked)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:OnBtnJumpClicked()
    local Url = self.Content.JumpLink
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        if self.Content.PhoneJumpLink and self.Content.PhoneJumpLink ~= "" then
            Url = self.Content.PhoneJumpLink
        end
    end
    UE4.UKismetSystemLibrary.LaunchURL(Url)
    self:MarkCommunityFollowed()
end

function M:MarkCommunityFollowed()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function Callback(Ret, Rewards)
            if Ret == 0 then
                self.IsCanGetReward = true
                self:RefreshUI()
                -- self.Content.ParentWidget:InitUI()
                ActivityReddotHelper.TryAddReddotCount(ActivityUtils, self.Content.ParentWidget.CurActivityId, "Red")
            end
        end
        Avatar:CallServer("MarkCommunityFollowed",Callback,self.Content.CommunityId)
    end
end

function M:OnBtnRewardClicked()
    -- 领奖
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function Callback(Ret, Rewards)
            if Ret == 0 then
                local UIManager = GWorld.GameInstance:GetGameUIManager()
                local AllRewards = RewardUtils:GetRewards(self.Content.Reward, nil)
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, AllRewards, false, function()
                    self.Content.ParentWidget:EnterRewardViewMode()
                end, self.Content.ParentWidget)
                -- self.IsGetReward = true
                -- self.IsCanGetReward = false
                -- self:RefreshUI()
                self.Content.ParentWidget:InitUI()
                local CommunityList = self.Content.ParentWidget.CommunityList
                local bShowRedDot = false
                local Community = Avatar.Community
                for i = 1, #CommunityList do
                    local CommunityId = CommunityList[i]
                    local IsCanGetReward = Community:IsRewardCanGet(CommunityId)
                    if IsCanGetReward then
                        bShowRedDot = true
                        break
                    end
                end
                if not bShowRedDot then
                    ActivityReddotHelper.TrySubReddotCount(ActivityUtils, self.Content.ParentWidget.CurActivityId, "Red")
                end
            end
        end
        Avatar:CallServer("GetCommunityFollowedReward",Callback,self.Content.CommunityId)
    end
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Widget = self

    self:InitUI()
end

function M:InitUI()
    self.IsCanGetReward = false
    self.IsGetReward = false
    local Avatar = GWorld:GetAvatar()
    if Avatar ~= nil then
        local Community = Avatar.Community
        self.IsCanGetReward = Community:IsRewardCanGet(self.Content.CommunityId)
        self.IsGetReward = Community:IsRewardGot(self.Content.CommunityId)
        if self.IsGetReward then
            self.IsCanGetReward = false
        end
    end
    self:RefreshUI()
    self.Btn_Jump:SetText(GText(self.Content.JumpTips))
    self.Btn_Reward:SetText(GText("UI_GameEvent_ClaimReward"))
    self.Text_Desc:SetText(GText(self.Content.JobTips))

    if self.Content.Icon == nil then
        self.Content.Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/SNS/T_Icon_Sns_Weibo.T_Icon_Sns_Weibo'"
    end
    local CommunityIcon =  LoadObject(self.Content.Icon)
    self.Image_ItemIcon:SetBrushFromTexture(CommunityIcon)


    self.Key_Item:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img", ImgShortPath = "LS"
            }
        }
    })

    self:SetGamepadIconVisibility(false)
    self.Text_Btn_Got:SetText(GText("UI_GameEvent_HasClaimed"))
    if (not self.IsCanGetReward and self.Content.RewardMark) then
        self:MarkCommunityFollowed()
    end
end

function M:RefreshUI()
    if self.IsGetReward then
        self:PlayAnimation(self.Forbidden)
        self.Group_Got:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    elseif self.IsCanGetReward then
        self:PlayAnimation(self.Normal)
        self.WS_Btn:SetActiveWidgetIndex(1)
        self.Group_Got:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self:PlayAnimation(self.Normal)
        self.WS_Btn:SetActiveWidgetIndex(0)
        self.Group_Got:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    local RewardId = self.Content.Reward
    local RewardData = DataMgr.Reward[RewardId]
    local ItemId = RewardData.Id[1]
    local Count = RewardUtils:GetCount(RewardData.Count[1])
    local IconPath = ItemUtils.GetItemIconPath(ItemId, RewardData.Type[1])
    local Rarity = ItemUtils.GetItemRarity(ItemId, RewardData.Type[1])
    local ItemType = RewardData.Type[1]
    local Content = {
        Id = ItemId,
        Rarity = Rarity,
        Icon = IconPath,
        ItemType = ItemType,
        Count = Count,
        IsShowDetails = true,
        HandleMouseDown = true,
        bHasGot = self.IsGetReward,
        bCanGet = self.IsCanGetReward,
        OnMenuOpenChangedEvents = {
            Obj = self,
            Callback = self.OnMenuOpenChangedEvent
        }
    }
    self.Com_Item_Universal_M:Init(Content)
end

function M:OnMenuOpenChangedEvent(IsOpen)
    if IsOpen then
        self.IsOpenMenu = true
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("EmptyView")
        end
    else
        self.IsOpenMenu = false
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("ACheckRewardView")
        end
    end
end
function M:OnAddedToFocusPath(InFocusEvent) 
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:OnItemSelectionChanged(true)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:OnItemSelectionChanged(false)
    end
end

function M:OnItemSelectionChanged(IsSelected)
    self.bIsSelected = IsSelected
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if IsSelected then
            self:SetGamepadIconVisibility(true)
            self:PlayAnimation(self.Hover)
        else
            self:SetGamepadIconVisibility(false)
            self:PlayAnimation(self.UnHover)
        end
    end
end

function M:SetGamepadIconVisibility(bShow)
    if bShow then
        self.Key_Item:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Jump:SetGamepadIconVisibility(true)
        self.Btn_Reward:SetGamePadIconVisible(true)
    else
        self.Key_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_Jump:SetGamepadIconVisibility(false)
        self.Btn_Reward:SetGamePadIconVisible(false)
    end
end


function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if(InKeyName == "Gamepad_LeftThumbstick") then
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips("ACheckRewardView")
        end
        self.Com_Item_Universal_M:SetFocus()
        self:SetGamepadIconVisibility(false)
        self.IsFocusItem = true
        IsHandled = true
    elseif(InKeyName == "Gamepad_FaceButton_Right" and self.IsFocusItem and self.IsOpenMenu ~= true) then
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        if ActivityMain then
            ActivityMain:UpdateActivityKeyTips()
        end
        self:SetFocus()
        self.IsFocusItem = false
        self:SetGamepadIconVisibility(true)
        IsHandled = true
    elseif(InKeyName == "Gamepad_FaceButton_Bottom" and self.IsFocusItem ~= true) then
        if self.IsGetReward then
            IsHandled = true
        elseif self.IsCanGetReward then
            self:OnBtnRewardClicked()
            self.Btn_Reward:PlayAnimation(self.Btn_Reward.Press)
        else
            self:OnBtnJumpClicked()
            self.Btn_Jump:PlayAnimation(self.Btn_Jump.Press)
        end
        IsHandled = true
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.MouseAndKeyboard and self.bIsSelected then
        self:PlayAnimation(self.UnHover)
        self:SetGamepadIconVisibility(false)
        self.bIsSelected = false
        self.Content.ParentWidget:LeaveRewardViewMode()
    end
end

return M
