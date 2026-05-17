
require "UnLua"

---@type WBP_Com_Cost_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
--参数说明
--ResourceId:资源Id
--Icon:针对非Resource类的，直接显示Icon，和ResourceId互斥
--bShowDenominator:显示消耗结构的分母
--CostText:显示分母时的提示文本
--Denominator:消耗结构分母
--Numerator:消耗结构分子
--KeyIconName:打开提示的快捷键名称
--Owner:父蓝图
--ItemMenuAnchorChangedCallback:打开tips监听回调
function M:InitContent(Params)
    self.Group_Controller:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.IsGamePadIconVisible = true
    if Params.IsGamePadIconVisible == false then
        self.IsGamePadIconVisible = false
    end
    self.Btn_Cost.OnPressed:Add(self,function ()
        self.Common_Item_Icon:OnMouseButtonDown()
    end)
    self.Btn_Cost.OnReleased:Add(self,function ()
        self.Common_Item_Icon:OnMouseButtonUp()
    end)
    self.Btn_Cost.OnHovered:Add(self,
    function ()
        self.Common_Item_Icon:OnMouseEnter()
    end)
    self.Btn_Cost.OnUnhovered:Add(self,function ()
        self.Common_Item_Icon:OnMouseLeave()
    end)
    self.Common_Item_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Owner=Params.Owner
    if Params.ResourceId then
        local Resource = DataMgr.Resource[Params.ResourceId]
        local Icon = LoadObject(Resource.Icon)
        self.Common_Item_Icon:Init({
            Id = Params.ResourceId,
            Icon = Icon,
            ItemType = "Resource",
            UIName = Params.UIName or "CommonDialog",
            IsShowDetails = Params.IsShowDetails == nil and true or Params.IsShowDetails,
            IsCantItemSelection = true,
            MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
            HandleMouseDown = Params.HandleMouseDown,
            HandleKeyDown = false,
            NotInteractive = Params.NotInteractive,
        })
    elseif Params.Icon then
        self.Common_Item_Icon:Init({
            Icon = Params.Icon,
            IsCantItemSelection = true,
            HandleMouseDown = Params.HandleMouseDown,
            HandleKeyDown = false,
            NotInteractive = Params.NotInteractive,
        })
    end
    self.Text_Possess:SetText(FormatNumber(Params.Numerator, false))
    if Params.bShowDenominator then
        self.Group_Expend:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Text_Expend:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Text_Expend:SetText(FormatNumber(Params.Denominator, false))
    else
        self.Group_Expend:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if Params.CostText then
        self.Text_CostTitle:SetText(Params.CostText)
        self.Text_CostTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Text_CostTitle:SetVisibility(ESlateVisibility.Collapsed)
    end
    if  Params.Denominator and Params.Numerator < Params.Denominator then
        self.Text_Possess:SetColorAndOpacity(self.UnEnoughColor)
    else
        self.Text_Possess:SetColorAndOpacity(self.NormalColor)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
    self.Common_Item_Icon.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.ItemMenuAnchorChanged)
    self:InitConfig()
    self:InitGamePad(Params.KeyIconName)
    self.IsOpen=false
    self.ItemMenuAnchorChangedCallback = Params.ItemMenuAnchorChangedCallback
end

function M:OpenTip()
    self.Common_Item_Icon:OnMouseButtonUp()
    self.OpenByKey=true
end
function M:SetPossess(PossessNum)
    self.Text_Possess:SetText(PossessNum)
    if  tonumber(self.Text_Possess:GetText()) < tonumber(self.Text_Expend:GetText()) then
        self.Text_Possess:SetColorAndOpacity(self.UnEnoughColor)
    else
        self.Text_Possess:SetColorAndOpacity(self.NormalColor)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    self.Group_Controller:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    local IsGamepad = UIUtils.IsGamepadInput()
    if (IsGamepad and self.IsGamePadIconVisible) then
        self.Group_Controller:SetVisibility(UIConst.VisibilityOp["Visible"])
    else
        -- 手机逻辑
    end
    --self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:SetCost(Cost, Possess)
    self.Text_Expend:SetText(Cost)
    if Possess then self.Text_Possess:SetText(Possess) end
    if tonumber(self.Text_Possess:GetText()) < tonumber(self.Text_Expend:GetText()) then
        self.Text_Possess:SetColorAndOpacity(self.UnEnoughColor)
    else
        self.Text_Possess:SetColorAndOpacity(self.NormalColor)
    end
end

-- 手动设置颜色
function M:SetIsEnough(bIsEnough)
    if bIsEnough then 
        self.Text_Possess:SetColorAndOpacity(self.NormalColor)
    else 
        self.Text_Possess:SetColorAndOpacity(self.UnEnoughColor)
    end
end


function M:InitGamePad(KeyIconName)
      --手柄相关
      KeyIconName=KeyIconName or "LS"
      local ImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(KeyIconName, self.CurGamepadName)
      --self.Key.Img:SetBrushFromTexture(Img)
      self.Key:CreateCommonKey({
          KeyInfoList = {
              {
                  Type = "Img",
                  ImgLongPath=ImgPath
              }
          },
      })
end

function M:InitConfig()
    -- 获取当前InputType
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    -- 获取当前GamepadName
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    -- 根据输入设备更新图标显示
    --self:RefreshIconAndGamePadVisibility()
end

function M:RefreshIconAndGamePadVisibility()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SwitchToGamePad()
    else
        self:SwitchToPC()
    end
end

function M:SwitchToPC()
    self.Key:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:SwitchToGamePad()
    self.Key:SetVisibility(UIConst.VisibilityOp["Visible"])
end

function M:OnkeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    -- 处理手柄相关的交互事件
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        if (InKeyName == "Gamepad_FaceButton_Bottom") then
            --   IsEventHandled=true
            --   self.Common_Item_Icon:OnMouseButtonUp()
        elseif InKeyName == "Gamepad_FaceButton_Right" then
            -- IsEventHandled = true
            -- self.Common_Item_Icon:OnMouseButtonUp()
        end
    end
    return IsEventHandled
end

function M:OpenTipsBindEvents(Widget)
    local Events = {}
    Events.OnMenuOpenChanged = self.ItemMenuAnchorChanged
    Widget:BindEvents(self, Events)
end

--打开tips监听
function M:ItemMenuAnchorChanged(IsOpen)
    self.IsOpen=IsOpen
    if self.ItemMenuAnchorChangedCallback then
        self.ItemMenuAnchorChangedCallback(self.Owner, IsOpen)
    end
    if not IsOpen then
        if self.OpenByKey then
            self.Common_Item_Icon:PlayAnimation(self.Common_Item_Icon.Normal)
            self.OpenByKey=false
        end
    end
end

function M:IsTipOpen()
   return self.IsOpen
end


function M:Handle_KeyEventOnGamePad(InKeyName)
    local IsEventHandled = false
    -- 处理手柄相关的交互事件
    if (InKeyName == "Gamepad_RightStick_Right") then
        self.Common_Item_Icon:OnMouseButtonUp()
        IsEventHandled=true
    end
    return IsEventHandled
end


function M:Destruct()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

--用于手柄快捷打开控件
function M:Activate()
    self.Common_Item_Icon:OnMouseButtonUp() 
end

--用于手柄快捷关闭控件
function M:InActivate()
    self.Common_Item_Icon:OnMouseLeave()
end

function M:SetGamePadIconVisible(IsVisible)
    self.IsGamePadIconVisible = IsVisible
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

return M