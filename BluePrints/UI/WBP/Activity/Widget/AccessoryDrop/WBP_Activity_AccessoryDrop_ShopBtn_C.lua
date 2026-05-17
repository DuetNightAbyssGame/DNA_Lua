--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AccessoryDrop_ShopBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

function M:Construct()
    self:BindInputMethodChangedDelegate()

    self.Btn_Click.OnClicked:Add(self, self.GoToShopClick)
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

function M:Destruct()
    self:UnBindInputMethodChangedDelegate()
    self.Btn_Click.OnClicked:Remove(self, self.GoToShopClick)
end

function M:InitView(AccessDropConfig, AccessoryDrop, IsRefresh)
    self.AccessDropConfig = AccessDropConfig
    self.EventId = AccessDropConfig.EventId

    -- local MainTabId = DataMgr.Shop["AccessoryDropShop"].MainTabId[1]
    -- local MainName =  DataMgr.ShopTabMain[MainTabId].MainName
    -- self.Text_Name:SetText(GText(MainName))
    self.Text_Name:SetText(GText("Event_FreeAppearance_tittle01"))
    -- 气泡
    local nextAddDropBoxNumTime = math.floor(TimeUtils.NextDailyRefreshTime())
    local ActivityConfigData = DataMgr.EventMain[self.AccessDropConfig.EventId]
    -- 活动最后一天切宝箱开完
    if (nextAddDropBoxNumTime > ActivityConfigData.EventEndTime) and AccessoryDrop.CurDropBoxNum == 0 then
        if self.Panel_Bubble:GetVisibility() == ESlateVisibility.Collapsed then
            self:PlayAnimation(self.Bubble_In)
        end

        self.Text_Bubble:SetText(GText("Event_FreeAppearance_tips12"))
        self.Panel_Bubble:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        if self.Panel_Bubble:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            self:PlayAnimation(self.Bubble_Out)
        end
        self.Panel_Bubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    if not IsRefresh then
        self:InitGamePadBtn()
    end

    self:UpdateTime()
end

function M:UpdateTime()
    if self.AccessDropConfig then

        local ActivityConfigData = DataMgr.EventMain[self.AccessDropConfig.EventId]
        local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(ActivityConfigData.EventEndTime)
        self.Time:SetTimeText("", RemainTimeDict)
        --self.Time:SetTimeText("Event_FreeAppearance_tips11", RemainTimeDict)
    end
end

function M:GoToShopClick()
    local PageConfigData = DataMgr.EventPortal[self.EventId]
    if (not PageConfigData.EventShop) then
        return
    end
    PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.EventShop)
end

-- 绑定输入设备切换的委托
function M:BindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    end
end

function M:UnBindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
    end
end

-- 输入设备切换触发的委托
function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
    if NewGameInputType == ECommonInputType.Gamepad then
        self:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:InitGamePadBtn()
    self.Key_Controller:CreateCommonKey({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
        }}
    })
    self:SetGamePadVisibility()
end

function M:SetGamePadVisibility(Op)
    if Op == nil then
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            Op = UIConst.VisibilityOp.SelfHitTestInvisible
        else
            Op = UIConst.VisibilityOp.Collapsed
        end
    end
    self.Key_Controller:SetVisibility(Op)
end

return M
