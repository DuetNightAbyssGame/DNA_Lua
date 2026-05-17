--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Build_Entrance_C
local WBP_Build_SquadEntrance_C = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

function WBP_Build_SquadEntrance_C:Construct()

    self:InitDeviceInfo()
    self:InitListenEvent()

    self:InitBtn()
    self.Btn_Click.OnClicked:Add(self, self.EnterSquadMainUI)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 
    end

    local ConditionInId = DataMgr.UIUnlockRule.Squad and DataMgr.UIUnlockRule.Squad.ConditionId
    if not ConditionInId then
        GWorld.logger.error("DataMgr.UIUnlockRule.Squad.ConditionId 为 nil, 请检查下UIUnlockRule表的对应的配置情况")
        return
    end
    if not ConditionUtils.CheckCondition(Avatar, ConditionInId) then
        DebugPrint("thy   CheckSquadCondition false")
        return
    end
    --获取到当前拥有的预设阵容 没有预设阵容的情况下会把当前的配置作为第一套预设阵容
    if Avatar.Weapons[Avatar.MeleeWeapon] and Avatar.Weapons[Avatar.RangedWeapon] then
        Avatar:TryCreateDefaultSquad()
    else
        GWorld.logger.error("创建默认的预设阵容失败了，创建默认预设阵容的条件是角色身上拥有一把近战武器和一把远程武器，看到这条信息表示Avatar里没找到你的两把武器")
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_Build_SquadEntrance_C:InitUI()
    self.Text_Build:SetText(GText("UI_Squad"))
    --手机或者电脑用第一个
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        local KeyInfo = {
            KeyInfoList = {
                {
                    Type="Img", 
                    ImgShortPath = "Menu"
                }
            },         
        }
        self.Key_Controller:CreateCommonKey(KeyInfo)
        self.Key_Controller:SetVisibility(ESlateVisibility.Visible)
    else
        if self.Key_Controller then
            self.Key_Controller:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function WBP_Build_SquadEntrance_C:EnterSquadMainUI()
    --播放音效
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
    --防止手柄按钮直接监听到进入
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 
    end
    local ConditionInId = DataMgr.UIUnlockRule.Squad and DataMgr.UIUnlockRule.Squad.ConditionId
    if not ConditionInId then
        GWorld.logger.error("DataMgr.UIUnlockRule.Squad.ConditionId 为 nil, 请检查下UIUnlockRule表的对应的配置情况")
        return
    end
    if not ConditionUtils.CheckCondition(Avatar, ConditionInId) then
        DebugPrint("thy   CheckSquadCondition false")
        return
    end
    if Avatar.Weapons[Avatar.MeleeWeapon] and Avatar.Weapons[Avatar.RangedWeapon] then
        if CommonUtils.Size(Avatar.Squad) == 0 then
            Avatar:TryCreateDefaultSquad()
        end
        local SquadMainUI = UIManager(self):LoadUINew("SquadMainUINew")
    else
        GWorld.logger.error("创建默认的预设阵容失败了，创建默认预设阵容的条件是角色身上拥有一把近战武器和一把远程武器，看到这条信息表示Avatar里没找到你的两把武器")
    end
end

function WBP_Build_SquadEntrance_C:InitBtn()
    self.Btn_Click.OnClicked:Add(self, function() self:OnBtnClickClicked() end)
    self.Btn_Click.OnPressed:Add(self, function() self:OnBtnClickPressed() end)
    self.Btn_Click.OnHovered:Add(self, function() self:OnBtnClickHovered() end)
    self.Btn_Click.OnUnhovered:Add(self, function() self:OnBtnClickUnhovered() end)
    self:PlayAnimation(self.Normal)
end

function WBP_Build_SquadEntrance_C:OnBtnClickClicked()
    self:PlayAnimation(self.Click)
end

function WBP_Build_SquadEntrance_C:OnBtnClickPressed()
    self:PlayAnimation(self.Press)
end
function WBP_Build_SquadEntrance_C:OnBtnClickHovered()
    self:PlayAnimation(self.Hover)
end
function WBP_Build_SquadEntrance_C:OnBtnClickUnhovered()
    self:PlayAnimation(self.UnHover)
end

function WBP_Build_SquadEntrance_C:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_Build_SquadEntrance_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_Build_SquadEntrance_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("thy     CurGamepadName", CurGamepadName)

    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    --更新UI
    self:InitUI()
end

return WBP_Build_SquadEntrance_C
