--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_OnlineActionBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C",   "BluePrints.UI.BP_EMUserWidgetUtils_C"})
-- local OnlineActionModel = require "BluePrints.UI.BattleOnlineAction.OnlineActionModel"
-- local OnlineActionCommon = require "BluePrints.UI.BattleOnlineAction.OnlineActionCommon"
local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
local OnlineActionCommon = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon"
local OpenKey=OnlineActionCommon.OpenOnlineActionPageKey
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
local TextKey={
    KeyInfoList={
        {
            Type = "Text",
            ImgShortPath =OpenKey,
        },
    },
}
local ImgKey={
    KeyInfoList={
        {
            Type = "Img", 
            ImgShortPath ="Menu",
        }, 
    },
        bLongPress = true,
}
function M:Show()
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnClicked:Add(self, self.OnClick)
    self:PlayAnimation(self.In)
    --self.Text_OnlineAction:SetText(GText("UI_RegionOnline_Interact"))
    self.Key_OnlineAction:CreateCommonKey(TextKey)
    self.Key_OnlineAction_GamePad:CreateCommonKey(ImgKey)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/online_invite_interact_start", "OnlineActionBtnShow", nil)
    ReddotManager.AddListenerEx("OnlineActionBtn",self,self.OnReddotNumChange)
end

function M:OnReddotNumChange(Count,RdType,RdName)
   if Count>0 then
        self:ShowOrHideReddot(true)
   else
        self:ShowOrHideReddot(false)
        self:ShowOrHideBubble(0)
   end
end

--region 输入设备管理
-- 根据当前输入方式更新界面的样式
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    -- 根据当前输入方式更新界面的样式，子类重写该方法
    DebugPrint("WBP_Battle_OnlineActionBtn_C OnUpdateUIStyleByInputTypeChange CurInputType: "..CurInputType)
    if CurInputType == ECommonInputType.MouseAndKeyboard then
        self.WS_Key:SetActiveWidgetIndex(0)
    elseif CurInputType == ECommonInputType.Gamepad then
        self.WS_Key:SetActiveWidgetIndex(1)
    end
end

--隐藏按钮并销毁
function M:Hide()
    EventManager:RemoveEvent("GameViewportInputKeyPressed",self)
    self:UnbindAllFromAnimationFinished(self.Out)
        local FuncOnEnd=function()
        local BattleMain = UIManager(self):GetUIObj("BattleMain")
        if not BattleMain then
            ScreenPrint("yklua OnlineAction:HideBtn 没有拿到BattleMain")
            return
        end
        BattleMain.Pos_OnlineAction:ClearChildren()
    end
    self:BindToAnimationFinished(self.Out, FuncOnEnd)
    self:PlayAnimation(self.Out)
end

function M:PlayOutAni(onFinished)
    self:UnbindAllFromAnimationFinished(self.Out)
    if onFinished then
        self:BindToAnimationFinished(self.Out, onFinished)
    end
    self:PlayAnimation(self.Out)
end

function M:OnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "OnlineActionBtnClick", nil)
    OnlineActionController:OpenView()
end

function M:OnFastKeyOpne()
    DebugPrint("WBP_Battle_OnlineActionBtn_C OnFastKeyOpne")
    if IsValid(self) and self:IsVisible() then
        self:OnClick()
    end
end

function M:OnGlobalKeyDown(Key)
    if not IsValid(self)  then
        EventManager:RemoveEvent("GameViewportInputKeyPressed",self)
    end
    DebugPrint("WBP_Battle_OnlineActionBtn_C OnGlobalKeyDown InKey: "..Key.KeyName .."   多人动作界面开启按钮监听按键输入中，如果重复出现或者多人动作按钮消失后仍存在改Log，联系叶轲修改")
    if self.OpenKey and self.OpenKey==Key.KeyName then
        self:OnClick()
    end
end

function M:OnGlobalKeyUp(Key)
    if not IsValid(self)  then
        EventManager:RemoveEvent("GameViewportInputKeyReleased",self)
    end
    DebugPrint("WBP_Battle_OnlineActionBtn_C OnGlobalKeyUp InKey: "..Key.KeyName .."   多人动作界面开启按钮监听按键输入中，如果重复出现或者多人动作按钮消失后仍存在改Log，联系叶轲修改")
    if Key.KeyName==UIConst.GamePadKey.SpecialRight then
        self.Parent:OnReleaseGmaePadRightSpecial()
    end
end

function M:Construct()
    local BattleUI = UIManager(self):GetUIObj("BattleMain")
    local OpenKey=OnlineActionCommon.OpenOnlineActionPageKey
    self.OpenKey=OpenKey
    EventManager:RemoveEvent("GameViewportInputKeyPressed",self)
    EventManager:AddEvent("GameViewportInputKeyPressed",self,self.OnGlobalKeyDown)
    EventManager:RemoveEvent("GameViewportInputKeyReleased",self)
    EventManager:AddEvent("GameViewportInputKeyReleased", self,self.OnGlobalKeyUp)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.WS_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    --self.WBP_Com_HudBubble:Init({Text=GText("UI_RegionOnline_BubbleApply"),Arrow=1,ColorType=1})

    --BattleUI:ListenForInputAction("OpenOnlineActionPage", EInputEvent.IE_Pressed, false, {self, self.OnFastKeyOpne})
    --DebugPrint("WBP_Battle_OnlineActionBtn_C ListenForInputAction")
end



function M:ShowOrHideReddot(bShow)
    if bShow then
        --self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

--1代表申请 2导表邀请 0或nil 为隐藏
function M:ShowOrHideBubble(BubbleKind)
    self:InitBubble()
    self.BubbleKind=BubbleKind
    if BubbleKind==1 then
        self.WBP_Com_HudBubble.Text_Bubble:SetText(GText("UI_RegionOnline_BubbleApply"))
        if self.WBP_Com_HudBubble:IsVisible() then
            return
        end
        self.WBP_Com_HudBubble:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.WBP_Com_HudBubble:PlayInAndLoopAnimation()
    elseif BubbleKind==2 then
        self.WBP_Com_HudBubble.Text_Bubble:SetText(GText("UI_RegionOnline_BubbleInvite"))
        if self.WBP_Com_HudBubble:IsVisible() then
            return
        end
        self.WBP_Com_HudBubble:PlayInAndLoopAnimation()
        self.WBP_Com_HudBubble:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        --self.WBP_Com_HudBubble:PlayAnimation(self.WBP_Com_HudBubble.Loop,0,0)
    else
        self.WBP_Com_HudBubble:StopAllAnimations()
        self.WBP_Com_HudBubble:PlayAnimation(self.WBP_Com_HudBubble.Out)
        self.WBP_Com_HudBubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:Tick(MyGeometry, InDeltaTime)
    OnlineActionController:NotifyTick(InDeltaTime)
    self:UpdateBubbleState()
end

function M:InitBubble()
    if self.HaveInitBubble then
        return
    end
    self.HaveInitBubble=true
    self.WBP_Com_HudBubble:Init({Text=GText("UI_RegionOnline_BubbleApply")})
end

-- 根据当前输入方式更新界面的样式
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    -- 根据当前输入方式更新界面的样式，子类重写该方法
    if CurInputType == ECommonInputType.MouseAndKeyboard then
        if not CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        else
            self:InitKeyboardUI()
        end
    elseif CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadUI()
    end
end

function M:InitGamepadUI()
    self.WS_Key:SetActiveWidgetIndex(1)
        -- self.Key_OnlineAction:SetVisibility(UIConst.VisibilityOp.Collapsed)
        -- self.Key_OnlineAction_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:InitKeyboardUI()
    self.WS_Key:SetActiveWidgetIndex(0)

    -- self.Key_OnlineAction:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    -- self.Key_OnlineAction_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:UpdateBubbleState()
    local OnlineActionModel = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionModel"
    local hasInvitation = OnlineActionModel:HaveOtherInvitation()
    local hasApply = OnlineActionModel:HaveOtherApply()

    local cur = self.BubbleKind or 0
    local target = cur

    if cur == 2 then
        if not hasInvitation then
            if hasApply then
                target = 1
            else
                target = 0
            end
        end
    elseif cur == 1 then
        if not hasApply then
            if hasInvitation then
                target = 2
            else
                target = 0
            end
        end
    else
        if hasInvitation then
            target = 2
        elseif hasApply then
            target = 1
        else
            target = 0
        end
    end

    if target ~= cur and cur ~= 0 then
        self:ShowOrHideBubble(target)
    end
end

function M:Destruct()
    ReddotManager.RemoveAllListener("OnlineActionBtn",self)
    EventManager:RemoveEvent("GameViewportInputKeyPressed",self)
    EventManager:RemoveEvent("GameViewportInputKeyReleased",self)
    --M.Super.Destruct(self)
end


return M
