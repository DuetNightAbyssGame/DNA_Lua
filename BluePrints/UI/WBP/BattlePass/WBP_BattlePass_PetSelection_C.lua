--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local BattlePassController = require "BluePrints.UI.WBP.BattlePass.Controller.BattlePassController"

local WBP_BattlePass_PetSelection_C = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function WBP_BattlePass_PetSelection_C:Construct()
    self.Avatar = GWorld:GetAvatar()
    assert(self.Avatar, "拿不到Avatar")
    self.PetItemList = {
        self.WBP_BattlePass_PetOption,
        self.WBP_BattlePass_PetOption_1,
        self.WBP_BattlePass_PetOption_2,
        self.WBP_BattlePass_PetOption_3,
        self.WBP_BattlePass_PetOption_4,
        self.WBP_BattlePass_PetOption_5,
    }
    
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self:AddInputMethodChangedListen()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_BattlePass_PetSelection_C:GetParent(Parent)
    self.Parent = Parent
end

function WBP_BattlePass_PetSelection_C:SwitchIn(...)
    self:PlayInAnim()
    self:InitUI()
    self.Parent:HidePlayerActor("PetSelection", true)
    --self.Parent:HidePetActor("PetSelection", true)
    self.Parent:HidePlayerFXAccessory(true)
    self.Parent:RemoveRefreshPetTimer()
    BattlePassController:GetModelData("ActorController"):SetArmoryCameraTag("BattlePass","","","Pet")
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_page_award_in", nil, nil)
end

function WBP_BattlePass_PetSelection_C:InitUI()
    self:GetBattlePetList()
    
    self.Text_Title:SetText(GText("UI_BattlePass_PetClaimTitle"))
    if BattlePassController:GetModelData("IsLastVersionPet") then
        self.Text_Show:SetText(GText("UI_BattlePass_PetReissueDetail"))
    else
        self.Text_Show:SetText(GText("UI_BattlePass_PetClaimDetail"))
    end
    self.Text_Check:SetText(GText("UI_Controller_CheckDetails"))
    self:InitPetList()
    self:InitBtn()
    self:InitLeftTime()
    self:RefreshTab()
    -------------- 手柄端 --------------------
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:AddDelayFrameFunc(function()
            self:InitGamepadView()
        end, 2)
    else
        self:InitKeyboardView()    
    end
end

function WBP_BattlePass_PetSelection_C:GetBattlePetList()
    if BattlePassController:GetModelData("IsLastVersionPet", false) then
        BattlePassController:SetModelData("BattlePassId", self.Avatar.BattlePassLastVersion)
    else
        BattlePassController:SetModelData("BattlePassId", self.Avatar.BattlePassVersion)
    end
    
    self.AvatarPetList = {}
    for _, Pet in pairs(self.Avatar.Pets) do
        local PetId = Pet.PetId
        if CommonUtils.HasValue(BattlePassController:GetModelData("PetList"), PetId) then
            local Star = Pet.BreakNum
            if not self.AvatarPetList[PetId] then
                self.AvatarPetList[PetId] = {
                    Num = 0,
                    MaxStar = 0,
                }
            end
            self.AvatarPetList[PetId].Num = self.AvatarPetList[PetId].Num + 1
            self.AvatarPetList[PetId].MaxStar = math.max(self.AvatarPetList[PetId].MaxStar, Star)
        end
    end
end

function WBP_BattlePass_PetSelection_C:InitPetList()
    local AlreadyGotPet = self.Avatar.BattlePassPetClaimed
    if AlreadyGotPet then
        self.GotPetId = self.Avatar.BattlePassPetClaimedRecord[BattlePassController:GetModelData("BattlePassId")]
    end
    for Index, PetId in ipairs(BattlePassController:GetModelData("PetList")) do
        local PetItem = self.PetItemList[Index]
        local PetInfo = {
            PetId = PetId,
            Parent = self,
            AlreadyGot = self.GotPetId == PetId
        }
        if self.AvatarPetList[PetId] then
            PetInfo.HasOwned = true
            PetInfo.Num = self.AvatarPetList[PetId].Num
            PetInfo.MaxStar = self.AvatarPetList[PetId].MaxStar
        end
        PetItem:InitUI(PetInfo)
    end
    self.WB_Pet:GetChildAt(0):OnBtnClicked()
end

function WBP_BattlePass_PetSelection_C:InitBtn()
    if BattlePassController:GetModelData("IsLastVersionPet", false) then
        self.Btn_Reward:SetText(GText("UI_BattlePass_PetClaim"))
        self.Btn_Reward:ForbidBtn(false)
    else
        local AlreadyGotPet = self.Avatar.BattlePassPetClaimed
        if AlreadyGotPet then
            self.Btn_Reward:SetText(GText("UI_BattlePass_PetHasClaimed"))
            self.Btn_Reward:ForbidBtn(true)
        else
            local IsPetCanClaim = self.Avatar.BattlePassPetCanClaim
            if IsPetCanClaim then
                self.Btn_Reward:SetText(GText("UI_BattlePass_PetClaim"))
                self.Btn_Reward:ForbidBtn(false)
            else
                self.Btn_Reward:SetText(GText("UI_BattlePass_Claimlock"))
                self.Btn_Reward:ForbidBtn(true)
            end
        end
    end
    self.Btn_Reward.Button_Area.OnClicked:Add(self, self.OnClaimBtnClicked)
    self.Btn_Check:BindEventOnClicked(self, self.OnBtnChecked)
    self.Key_Check:CreateCommonKey({
        KeyInfoList = {{Type = "Img", ImgShortPath = "View"}},
    })
end

function WBP_BattlePass_PetSelection_C:InitLeftTime()
    if BattlePassController:GetModelData("IsLastVersionPet", false) then
        self.Time_Left:SetVisibility(UIConst.VisibilityOp.Collapsed)    
    else
        self.Time_Left:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Time_Left.Text_TimeTitle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:RefreshTime(BattlePassController:GetModelData("BattlePassEndTime"))
        self:AddTimer(1, self.RefreshTime, true, 0, "RefreshBattlePassTime", true, BattlePassController:GetModelData("BattlePassEndTime"))
    end
end

function WBP_BattlePass_PetSelection_C:RefreshTime(EndTime)
    local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(EndTime)
    self.Time_Left:SetTimeText(GText("UI_BattlePass_RemainTime"), RemainTimeDict)
end

function WBP_BattlePass_PetSelection_C:OnClaimBtnClicked()
    if not BattlePassController:GetModelData("IsLastVersionPet", false) then
        local AlreadyGotPet = self.Avatar.BattlePassPetClaimed
        if AlreadyGotPet then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_BattlePass_PetHasClaimed"))
            return
        else
            local IsPetCanClaim = self.Avatar.BattlePassPetCanClaim
            if not IsPetCanClaim then
                UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_BattlePass_Claimlock"))
                return
            end
        end
    end
    
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_special", nil, nil)
    
    local PopupText = string.format(GText("UI_BattlePass_ClaimConfirm"), self.CurrentSelectName)
    local Params = {
        RightCallbackObj = self,
        RightCallbackFunction = self.OnChoosePet,
        ShortText = PopupText
    }
    UIManager(self):ShowCommonPopupUI(100179, Params)
end

function WBP_BattlePass_PetSelection_C:OnChoosePet()
    local OnGetItemPageClosed = function()
        if BattlePassController:GetModelData("IsLastVersionPet", false) then
            self.Parent:OnReturnKeyDown()
        end
        self:GetBattlePetList()
        self:InitPetList()
        self:InitBtn()
    end
    local ChoosePetCallback = function()
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded("Pet", self.CurrentSelectId, 1, nil, false, OnGetItemPageClosed, self, false)
    end
    if BattlePassController:GetModelData("IsLastVersionPet", false) then
        self.Avatar:BattlePassChooseLastVersionPet(self.CurrentSelectId, ChoosePetCallback)
    else
        self.Avatar:BattlePassChoosePet(self.CurrentSelectId, ChoosePetCallback)
    end
end

function WBP_BattlePass_PetSelection_C:SelectItem(PetId, PetName, Item)
    if UIUtils.UtilsGetCurrentInputType() == UE4.ECommonInputType.Gamepad then
        if self.CurrentSelectId == PetId then
            self:OnClaimBtnClicked()
        end
    end
    self.CurrentSelectId = PetId
    self.CurrentSelectName = PetName
    self.Text_ShowTitle:SetText(PetName)
    self.CurrentSelectItem = Item
    self:AddDelayFrameFunc(function()
        if self.Parent.CurSelectPetId ~= PetId then
            self.Parent:ChangePetActor({Type = "BattlePass",PetId = PetId,})
        end
        self.Parent.CurSelectPetId = PetId
    end, 2)
    for i = 0, self.WB_Pet:GetChildrenCount() - 1 do
        local PetItem = self.WB_Pet:GetChildAt(i)
        if PetItem.PetId ~= PetId then
            PetItem:OnUnSelect()
        end
    end
end

function WBP_BattlePass_PetSelection_C:RefreshTab()
    local BottomKeyInfo = {
        {
            KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Parent.OnClickBack, Owner=self.Parent}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
            Desc = GText("UI_BACK"),
            bLongPress = false
        }
    }
    self.Parent:UpdateBottomKeyInfo(BottomKeyInfo)
end

function WBP_BattlePass_PetSelection_C:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
    self.Super.RefreshOpInfoByInputDevice(self, self.CurInputDeviceType, self.CurGamepadName)
    if CurInputType == UE4.ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function WBP_BattlePass_PetSelection_C:InitGamepadView()
    DebugPrint("@zyh InitGamepadView Pet")
    self.WS_Check:SetActiveWidgetIndex(1)
    self.Btn_Reward.Img_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WB_Pet:GetChildAt(0).Button_Area:SetFocus()
end

function WBP_BattlePass_PetSelection_C:InitKeyboardView()
    self.WS_Check:SetActiveWidgetIndex(0)
    self.Btn_Reward.Img_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_BattlePass_PetSelection_C:BP_GetDesiredFocusTarget()
    if self.CurrentSelectItem and self.CurrentSelectItem.Button_Area then
        return self.CurrentSelectItem.Button_Area
    end
    return self.WB_Pet:GetChildAt(0).Button_Area
end

function WBP_BattlePass_PetSelection_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == Const.GamepadSpecialLeft then
        self:OnBtnChecked()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function WBP_BattlePass_PetSelection_C:OnBtnChecked()
    local PetList = CommonUtils.CopyTable(BattlePassController:GetModelData("PetList"))
    if self.CurrentSelectId and PetList then
        for Index, PetId in ipairs(PetList) do
            if PetId == self.CurrentSelectId then
                table.remove(PetList, Index)
                table.insert(PetList, 1, self.CurrentSelectId)
                break
            end
        end
    end
    
    UIManager(self):LoadUINew('ArmoryDetail',{PreviewPetIds = PetList, EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon})
end

function WBP_BattlePass_PetSelection_C:SwitchOut(...)
    self.Parent.CurSelectPetId = nil
    self.Parent:HidePlayerActor("PetSelection", false)
    --self.Parent:HidePetActor("PetSelection", false)
    self.Parent:HidePlayerFXAccessory(false)
    self.Parent:AddRefreshPetTimer()
    self.Parent:SetCameraAnim()
    self:PlayOutAnim()
end

function WBP_BattlePass_PetSelection_C:PlayInAnim()
    if self:IsAnyAnimationPlaying() then
        self:StopAllAnimations()
    end
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:PlayAnimationForward(self.In)
end

function WBP_BattlePass_PetSelection_C:PlayOutAnim()
    if not self.BindOutAnimation then
        self:BindToAnimationFinished(self.Out, {self,function()
            self:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        })
        self.BindOutAnimation = true
    end
    if self:IsAnyAnimationPlaying() then
        self:StopAllAnimations()
    end
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:PlayAnimationForward(self.Out)
    self.CurrentSelectId = nil
    self.CurrentSelectName = nil
    self.CurrentSelectItem = nil
end

return WBP_BattlePass_PetSelection_C
