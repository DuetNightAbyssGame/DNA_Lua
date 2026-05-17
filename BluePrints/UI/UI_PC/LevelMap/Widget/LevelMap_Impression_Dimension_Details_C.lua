--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ImpressionTypes = require"BluePrints.UI.UI_PC.Impression.ImpressionConst".ImpressionTypes

---@type LevelMap_Impression_Dimension_Details_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Close()
    if self.Animating then
        return
    end
    M.Super.Close(self)
    self.Animating=true
    -- self:PlayAnimation(self.Auto_Out)
    self.DimensionGraph:SwitchActive(false)
    self.Panel:SetFocus()
end

function M:OnAnimationFinished(Animation)
    self.Animating=false
    -- if Animation==self.Auto_Out then
        -- self:SetVisibility(ESlateVisibility.Collapsed)
        -- self.Panel.Panel_Close:SetVisibility(ESlateVisibility.Collapsed)
        -- self.Panel:ClosePanel()
    -- end
end

function M:Construct()
    local UIModePlatform = CommonUtils.GetDeviceTypeByPlatformName(self)
    if UIModePlatform == 'Mobile' then
        self.bInMobile = true
    end
end

function M:Init(RegionId, Panel, bInShop)
    if self.Animating then
        return
    end
    self.Animating=true
    self.Panel=Panel
    self.RegionId = RegionId
    -- self.Panel.Panel_Close:SetVisibility(ESlateVisibility.Visible)
    -- self:PlayAnimation(self.Auto_In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_five_dimension_btn_hover", "", nil)
    local Avatar = GWorld:GetAvatar()
    local ImpressionAreaId = Avatar:GetImpressionAreaIdFromRegionId(RegionId)
    self:InitDimensionGraph(ImpressionAreaId)
    self.DimensionGraph:SwitchActive(true)
    self.Text_Area:SetText(GText(DataMgr.ImpressionRegion[ImpressionAreaId].RegionName))
    self.Text_Desc:SetText(GText("UI_RegionMap_ImpressionTitle"))
    self.Btn_Go:SetText(GText("UI_ImpressionShop_ShopName_Short"))
    self.Btn_Go:SetDefaultGamePadImg("Y")
    self.Btn_Go:BindEventOnClicked(self,self.GoShop)
    self.Btn_Close:Init("Close", self, self.Close)
    if self.Key_Tips then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(UGameplayStatics.GetPlayerController(self, 0))
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), nil)
    end
    local RegionData = DataMgr.ImpressionRegion[ImpressionAreaId]
    self.ImpressionRegionId = ImpressionAreaId
    self.RegionPointId = RegionData.RegionPointId
    self.GoUnlocked = false 
    if self.RegionPointId then
        local ConditionId = DataMgr.RegionPoint[self.RegionPointId].UnlockConditionId
        if ConditionId then
            self.GoUnlocked = ConditionUtils.CheckCondition(Avatar, ConditionId)
        end
    end
    self.Btn_Go:SetVisibility(not bInShop and self.GoUnlocked and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
end

function M:InitDimensionGraph(ImpressionAreaId)
    self.DimensionGraph = self.Dimension

    local RegionInfo = DataMgr.ImpressionRegion[ImpressionAreaId]
    if RegionInfo and RegionInfo.UIName then
        local Widget = self:CreateWidgetNew(RegionInfo.UIName)
        if Widget then
            self.Group_Anchor:ClearChildren()
            self.Group_Anchor:AddChild(Widget)
            self.DimensionGraph = Widget
        end
    end
    self.DimensionGraph:Init(ImpressionAreaId)
end

function M:GoShop()
    self:Close()
    if self.ImpressionRegionId and self.RegionPointId then
        self.Panel:ChangeRegion(self.ImpressionRegionId, function()
            self.Panel:OnRegionPointClick(self.RegionPointId, true)
            -- self.Panel:MoveMapToRegionPoint(self.RegionPointId)
        end)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(UKismetInputLibrary.GetKey(InKeyEvent))
    if InKeyName == "Escape" or InKeyName == UIConst.GamePadKey.FaceButtonRight then
        self:Close()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop and self.GoUnlocked then
        self:GoShop()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if self.bInMobile then
        return
    end
    self:SetFocus()
    if CurInputDevice == ECommonInputType.Gamepad then
        local KeyInfo = {
            { 
                KeyInfoList = {{Type = "Img", ImgShortPath = "B", ClickCallback = self.Close, Owner = self}},
                Desc = GText("UI_BACK"),
            }
        }
        self.Key_Tips:UpdateKeyInfo(KeyInfo)
    else
        local KeyInfo = {
            { 
                KeyInfoList = {{Type = "Text", Text = "Esc", ClickCallback = self.Close, Owner = self}},
                Desc = GText("UI_BACK"),
            }
        }
        self.Key_Tips:UpdateKeyInfo(KeyInfo)
    end
end

return M
