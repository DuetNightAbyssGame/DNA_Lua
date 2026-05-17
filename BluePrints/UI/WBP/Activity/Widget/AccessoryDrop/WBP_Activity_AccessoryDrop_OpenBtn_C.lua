--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AccessoryDrop_OpenBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

function M:Construct()
    self:BindInputMethodChangedDelegate()
    self.Btn_Click.OnClicked:Add(self, self.OnClicked)
    self.Icon_Coin:SetVisibility(UIConst.VisibilityOp.Visible)
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

function M:Destruct()
    self:UnBindInputMethodChangedDelegate()
    self.Btn_Click.OnClicked:Remove(self, self.OnClicked)
end

function M:InitView(AccessDropConfig, AccessoryDrop, IsRefresh)
    self.AccessDropConfig = AccessDropConfig
    self.AccessoryDrop = AccessoryDrop

    local TodayCanOpenBoxCount = self:GetTodayCanOpenBoxCount()
    self.Text_Open:SetText(GText("Event_FreeAppearance_Btn01"))
    self.Text_Num:SetText(TodayCanOpenBoxCount)
    self.Text_Cost:SetText(AccessDropConfig.CoinPerBox * TodayCanOpenBoxCount)

    if TodayCanOpenBoxCount > 0 then
        self.Reddot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    -- 宝箱全部开启
    local nextAddDropBoxNumTime = math.floor(TimeUtils.NextDailyRefreshTime())
    local ActivityConfigData = DataMgr.EventMain[self.AccessDropConfig.EventId]

    self.OpenState = false
    -- 活动最后一天切宝箱开完
    if (nextAddDropBoxNumTime > ActivityConfigData.EventEndTime) and AccessoryDrop.CurDropBoxNum == 0 then
        self.WS_Type:SetActiveWidgetIndex(1)
        self.Text_Tips:SetText(GText("Event_FreeAppearance_Btn06"))
    elseif AccessoryDrop.CurDropBoxNum == 0 then
        self.WS_Type:SetActiveWidgetIndex(2)
        self.Text_Tips_Forbidden:SetText(GText("Event_FreeAppearance_Btn05"))
    elseif TodayCanOpenBoxCount == 0 then
        self.WS_Type:SetActiveWidgetIndex(2)
        self.Text_Tips_Forbidden:SetText(GText("Event_FreeAppearance_Btn04"))
    else
        self.WS_Type:SetActiveWidgetIndex(0)
        self.OpenState = true 
    end

    if not IsRefresh then
        self:InitGamePadBtn()

        local RecourceConfig = DataMgr.Resource[AccessDropConfig.BoxCoinId]
        local Content = {}
        Content.UIName = "AccessoryDrop"
        Content.IsCantItemSelection = true
        Content.Icon = RecourceConfig.Icon
        Content.ParentWidget = self
        Content.ItemType = "Resource"
        Content.Id = RecourceConfig.ResourceId
        Content.Rarity = RecourceConfig.Rarity
        Content.IsShowDetails = true
        Content.HandleMouseDown = true
        self.Icon_Coin:Init(Content)
    end

end

function M:SetOpenFunc(OpenFuncInfo)
    self.OpenFuncInfo = OpenFuncInfo
end

function M:OnClicked()
    if self.OpenState then
        self.OpenFuncInfo.Func(self.OpenFuncInfo.Obj)
    end
end

function M:GetBoxCoinCount(BoxCoinId)
    local BoxCoin = GWorld:GetAvatar().Resources[BoxCoinId]
    return BoxCoin and BoxCoin.Count or 0
end

function M:GetTodayCanOpenBoxCount()
    local OwnBoxCoinAmount = self:GetBoxCoinCount(self.AccessDropConfig.BoxCoinId)
    local CoinPerBox = self.AccessDropConfig.CoinPerBox
    local BoxCount = OwnBoxCoinAmount > 0 and math.floor(OwnBoxCoinAmount / CoinPerBox) or 0
    local TodayCanOpenBoxCount = BoxCount > self.AccessoryDrop.CurDropBoxNum and self.AccessoryDrop.CurDropBoxNum or
                                     BoxCount
    return TodayCanOpenBoxCount
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
            ImgShortPath = "Y"
        }}
    })
    self.Controller_Cost:CreateCommonKey({
        KeyInfoList = {{
            ImgShortPath = "Right",
            Type = "Img"
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
    self.Controller_Cost:SetVisibility(Op)
end

function M:OnResourceClick()
    local Icon_Coin = self.Icon_Coin
       -- 点击显示Tips，且Tips已经显示时
    if Icon_Coin.NotInteractive or (Icon_Coin.IsShowDetails and Icon_Coin.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) or Icon_Coin:IsInAnimationPlaying() then
        return true
    end

    -- 点击显示Tips，且Tips已经显示时
    if Icon_Coin.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then
        return true
    end
    
    local Content = {ItemType = Icon_Coin.ItemType, ItemId = Icon_Coin.Id, Uuid = Icon_Coin.Uuid, MenuPlacement = Icon_Coin.MenuPlacement, UIName = Icon_Coin.UIName, HandleKeyDown = Icon_Coin.HandleKeyDown}
    Icon_Coin.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
    Icon_Coin.Content.IsShowTips = true
    Icon_Coin.Content.IsSelect = true

    return true
end

return M
