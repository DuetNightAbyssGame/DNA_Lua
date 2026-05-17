--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_Depute_Walnut_Item_P_C
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

--function M:Initialize(Initializer)
--end

-- function M:Construct()

-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Root:SetRenderOpacity(0)
    self.ScrollBox_List:ClearChildren()
    self.Content = Content
    self.DungeonData = Content.DungeonData
    self.DungeonIds = Content.DungeonIds
    self.Parent = Content.Parent
    Content.SelfWidget = self
    self:InitItemContent()
    self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Wrap)
    
end

function M:BP_OnEntryReleased()
    if self.Content then
        self.Content.SelfWidget = nil
    end
end

function M:SetWalnutTitleMatColor(WalnutType)
    if WalnutType == 1 then
        self.TextColor = self.Sx_Text_WalnutTypeTitleMatColor
        self.ImageBG_LightColor = self.Sx_ImageBG_LightColor
        self.VX_BGLightColor = self.Sx_VX_BGLightColor
    elseif WalnutType == 2 then
        self.TextColor = self.Zl_Text_WalnutTypeTitleMatColor
        self.ImageBG_LightColor = self.Zl_ImageBG_LightColor
        self.VX_BGLightColor = self.Zl_VX_BGLightColor
    else
        self.TextColor = self.Hl_Text_WalnutTypeTitleMatColor
        self.ImageBG_LightColor = self.Hl_ImageBG_LightColor
        self.VX_BGLightColor = self.Hl_VX_BGLightColor
    end
end

function M:InitItemContent()
    -- 检查是否有 DungeonData
    if not self.DungeonData then
        return
    end
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- 播放进入动画
    self:PlayAnimation(self.In)

    -- 获取核桃类型数据
    local WalnutTypeData = DataMgr.WalnutType[self.DungeonData.WalnutType]
    if not WalnutTypeData then
        DebugPrint("Error: WalnutTypeData not found for WalnutType: ", self.DungeonData.WalnutType)
        return
    end

    -- 设置核桃头像和名称
    local Icon = LoadObject(WalnutTypeData.TypeIcon)
    self.Image_WalnutIcon:SetBrushResourceObject(Icon)
    self.Text_WalnutTypeTitle:SetText(GText(WalnutTypeData.Name))
    self.Text_HaveTitle:SetText(GText("UI_NUM_NAME"))
    self.Text_Open:SetText(GText("UI_Walnut_Dungeon_Opening"))


    self.ImageBG_LightColor = FLinearColor()
    self.VX_BGLightColor = FLinearColor()
    self.TextColor = FLinearColor()

    -- self.WalnutTypeSettings = {
    --     [1] = {
    --         ImageBG_LightColor = self.Sx_ImageBG_LightColor,
    --         VX_BGLightColor = self.Sx_VX_BGLightColor,
    --         TextColor = self.Sx_Text_WalnutTypeTitleMatColor
    --     },
    --     [2] = {
    --         ImageBG_LightColor = self.Zl_ImageBG_LightColor,
    --         VX_BGLightColor = self.Zl_VX_BGLightColor,
    --         TextColor = self.Zl_Text_WalnutTypeTitleMatColor
    --     },
    --     [3] = {
    --         ImageBG_LightColor = self.Hl_ImageBG_LightColor,
    --         VX_BGLightColor = self.Hl_VX_BGLightColor,
    --         TextColor = self.Hl_Text_WalnutTypeTitleMatColor
    --     }
    -- }

    -- 根据 WalnutType 获取相应的颜色
    --local WalnutSettings = self.WalnutTypeSettings[self.DungeonData.WalnutType]

    self:SetWalnutTitleMatColor(self.DungeonData.WalnutType)
 -- 设置背景颜色
    self.ImageBG_Light:SetColorAndOpacity(self.ImageBG_LightColor)
    self.VX_BGLight:SetColorAndOpacity(self.VX_BGLightColor)

    -- 设置字体材质颜色
    local Text_WalnutTypeTitleMat = self.Text_WalnutTypeTitle:GetDynamicFontMaterial()
    Text_WalnutTypeTitleMat:SetVectorParameterValue("MainColor", self.TextColor)


    -- 获取玩家头像
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    -- 获取玩家背包中的核桃
    self.WalnutsInBag = Avatar.Walnuts.WalnutBag
    local CurrentCount = 0

    -- 计算当前类型核桃数量
    for WalnutId, Number in pairs(self.WalnutsInBag) do
        local WalnutData = DataMgr.Walnut[WalnutId]
        if WalnutData and self.DungeonData.WalnutType == WalnutData.WalnutType then
            CurrentCount = CurrentCount + Number
        end
    end
    self.Text_HaveNum:SetText(CurrentCount)

    table.sort(self.DungeonIds, function(a, b)
        local DataA = DataMgr.Dungeon[a]
        local DataB = DataMgr.Dungeon[b]

        if not DataA or not DataB then
            return false
        end

        return DataA.DungeonLevel < DataB.DungeonLevel
    end)

    self.ItemTable = {}
    local ItemNum = 0
    -- 加载关卡数据
    for _, DungeonId in pairs(self.DungeonIds) do
        local Data = DataMgr.Dungeon[DungeonId]
        if not Data then
            DebugPrint("Error: Cannot find dungeon data for DungeonId:", DungeonId)
            break
        end
        ItemNum = ItemNum + 1
        local Item = UIManager(self):_CreateWidgetNew("Walnut_LevelItem")
        Item:Init(Data, self.DungeonIds, WalnutTypeData,self.DungeonData.WalnutType, self.Parent)
        self.ScrollBox_List:AddChild(Item)
    end
    self.ScrollBox_List:GetChildAt(ItemNum -1):SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)

    if ItemNum >= 3 then return end
    for i = 1, 3 - ItemNum do
        local Item = UIManager(self):_CreateWidgetNew("Walnut_LevelItem")
        Item:Init(nil)
        self.ScrollBox_List:AddChild(Item)
    end

end



function M:OnMouseEnter(MyGeometry, MouseEvent)
    self.IsEnter = true
    if self.IsUnLocked or self.Mobile or self:IsAnimationPlaying(self.In) then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_camp_hover", nil, nil)
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    self.IsEnter = false
    if self.IsUnLocked or self.Mobile or self:IsAnimationPlaying(self.In) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    --DebugPrint("CurrentChild   ---",self.ScrollBox_List:GetChildAt(0):GetName())
    --当聚焦到item的时候 设置聚焦到第一个关卡按钮
    self.ScrollBox_List:GetChildAt(0).Btn_Click:SetFocus()
    self.Parent:UpdatKeyDisplay()
    return  UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
