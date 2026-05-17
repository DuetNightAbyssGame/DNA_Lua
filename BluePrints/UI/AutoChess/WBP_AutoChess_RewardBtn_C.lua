--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local RewardModel = require "BluePrints.UI.AutoChess.WBP_AutoChess_Reward_Model"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
---@type WBP_Activity_Jump_Fort_TaskProgress_C
local M = Class({"Blueprints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Init()
    self:SetText(GText("UI_AutoChess_QuestName"))
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
    self.ReddotNameKey = "AutoChessReward"
    if not ReddotManager.GetTreeNode(self.ReddotNameKey) then
        ReddotManager.AddNode(self.ReddotNameKey)
    end
    if not self.AddListenerFinish then
        self.AddListenerFinish = true
        ReddotManager.AddListener(self.ReddotNameKey,self,self.RefreshReddot)
    end
    self:RefreshReddot()
end

function M:SetText(Text)
    self.Text_Name:SetText(GText(Text))
end

function M:InitReddot(ReddotName)
    ReddotManager.RemoveListener(self.ReddotNameKey, self)
    self.ReddotNameKey = ReddotName
    if not ReddotManager.GetTreeNode(self.ReddotNameKey) then
        ReddotManager.AddNode(self.ReddotNameKey)
    end
    ReddotManager.AddListener(self.ReddotNameKey,self,self.RefreshReddot)
end

function M:RefreshReddot()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotNameKey)
    if not CacheDetail then
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    else
        local IsEmpty=true
        for _, __ in pairs(CacheDetail) do
            IsEmpty=false
            break
        end
        if not IsEmpty then
            self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end


function M:Construct()
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
    ReddotManager.RemoveListener("AutoChessReward", self)
    self.Super.Destruct(self)
end

function M:SetText(Text)
    self.Text_Name:SetText(Text)
end

function M:BindEventOnClicked(Obj, Func, Params)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = Params
end


function M:OnBtnClicked()
    if self.Obj and self.Func then
        if self.Params then
            self.Func(self.Obj, table.unpack(self.Params))
        else
            self.Func(self.Obj)
        end
    end
end

function M:OpenReward()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    RewardModel:OpenReward(self)
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
