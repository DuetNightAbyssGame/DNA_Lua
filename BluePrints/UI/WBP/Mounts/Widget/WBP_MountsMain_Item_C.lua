--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_MountsMain_Item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

local RarityImageTable = {
    [3] = "/Game/UI/WBP/Common/VX/Mounts/MI_MountsMain_Item_11.MI_MountsMain_Item_11",
    [4] = "/Game/UI/WBP/Common/VX/Mounts/MI_MountsMain_Item_10.MI_MountsMain_Item_10",
    [5] = "/Game/UI/WBP/Common/VX/Mounts/MI_MountsMain_Item_09.MI_MountsMain_Item_09",
    [6] = "/Game/UI/WBP/Common/VX/Mounts/MI_MountsMain_Item_08.MI_MountsMain_Item_08",
}

function M:Construct()
    self:InitBtnEvent()
    EventManager:AddEvent(EventID.MountsItemOnClick , self, self.MountsItemOnClick)
end

function M:Destruct()
    EventManager:RemoveEvent(EventID.MountsItemOnClick , self)
end

function M:MountsItemOnClick(SelectMountId)
    if not self.IsEmpty and self.IsSelect and self.MountId ~= SelectMountId then
        self.IsSelect = false
        self:PlayBtnAnimation("Normal")
        self.Image_Select_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnListItemObjectSet(Content)
    self.IsEmpty = false
    if Content.IsEmpty then
        self.IsEmpty = true
        self.Switch_Type:SetActiveWidgetIndex(2)
        self.BG_Group:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    elseif Content.HasMount then
        self.Switch_Type:SetActiveWidgetIndex(0)
    else
        self.Switch_Type:SetActiveWidgetIndex(1)
    end
    self.BG_Group:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.MountId = Content.MountId
    self.MountConfig = self.MountId and DataMgr.Mount[self.MountId]
    self.MountsMain = Content.MountsMain
    self.ItemIndex = Content.ItemIndex
    self.HasMount = Content.HasMount
    self.IsEmpty = Content.IsEmpty
    self.IsSelect = self.MountsMain:GetDisplayMountId() == self.MountId
    if self.IsSelect then
        if self.HasMount then
            self:PlayAnimation(self.Click, self.Click:GetEndTime())
        else
            self:PlayAnimation(self.Forbidden_Click, self.Forbidden_Click:GetEndTime())
        end
    else
        self:PlayAnimation(self.In, self.In:GetEndTime())
    end
    self.Image_Select_1:SetVisibility(not self.IsSelect and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:InitMountItemUIDisplay()
    self:InitMountItemRedDot()
end

function M:InitMountItemUIDisplay()
    if not self.MountConfig then
        return
    end
    self.Text_Name_Normal:SetText(GText(self.MountConfig.MountName))
    self.Text_Name_None:SetText(GText(self.MountConfig.MountName))
    self.Text_Name_None02:SetVisibility(self.HasMount and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Name_None02:SetText(GText("UI_PersonInfo_NotHeld"))
    local Obj = LoadObject(self.MountConfig.MountIcon)
    if Obj then
        self.Image_Icon_Normal:SetBrushResourceObject(Obj)
        self.Image_Icon_None:SetBrushResourceObject(Obj)
    end
    local MountRarity = self.MountConfig.MountRarity or 3
    local RarityIconObj = LoadObject(RarityImageTable[MountRarity])
    if RarityIconObj then
        self.Image_Bg_03:SetBrushResourceObject(RarityIconObj)
        self.Image_Bg_03:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    local SkinNameLine = { nil, nil, "Line_Blue", "Line_Purple", "Line_Gold", "Line_Red"} --分别对应稀有度1，2，3，4，5，6
    if SkinNameLine[MountRarity] and self[SkinNameLine[MountRarity]] then
        self.Image_Bg_Line:SetBrushResourceObject(self[SkinNameLine[MountRarity]])
    end
end

function M:InitMountItemRedDot()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Mount_Item")
    if not CacheDetail then
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    if not self.HasMount or CacheDetail[self.MountId] then
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function M:RemoveMountItemRedDot()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Mount_Item")
    if not self.HasMount or not CacheDetail or CacheDetail[self.MountId] then
        return
    end
    CacheDetail[self.MountId] = 1
    ReddotManager.DecreaseLeafNodeCount("Mount_Item", 1)
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitBtnEvent()
    self.Btn_Item.OnClicked:Clear()
    self.Btn_Item.OnHovered:Clear()
    self.Btn_Item.OnUnhovered:Clear()
    self.Btn_Item.OnPressed:Clear()
    self.Btn_Item.OnReleased:Clear()
    self.Btn_Item.OnClicked:Add(self, self.OnMountsItemBtn_OnClicked)
    self.Btn_Item.OnHovered:Add(self, self.OnMountsItemBtn_OnHovered)
    self.Btn_Item.OnUnhovered:Add(self, self.OnMountsItemBtn_OnUnhovered)
    self.Btn_Item.OnPressed:Add(self, self.OnMountsItemBtn_OnPressed)
end

function M:PlayBtnAnimation(BtnState)
    if self.HasMount then
        self:PlayAnimation(self[BtnState])
    else
        self:PlayAnimation(self["Forbidden_"..BtnState])
    end
end

function M:OnMountsItemBtn_OnClicked()
    if self.IsEmpty then
        return
    end
    self:RemoveMountItemRedDot()
    if self.IsSelect then
        return
    end
    self.IsSelect = true
    self:PlayBtnAnimation("Click")
    self.Image_Select_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    EventManager:FireEvent(EventID.MountsItemOnClick, self.MountId)
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
end

function M:OnMountsItemBtn_OnHovered()
    if self.IsEmpty then
        return
    end
    if self.IsSelect then
        return
    end
    self:PlayBtnAnimation("Hover")
end

function M:OnMountsItemBtn_OnUnhovered()
    if self.IsEmpty then
        return
    end
    if self.IsSelect then
        return
    end
    self:PlayBtnAnimation("UnHover")
end

function M:OnMountsItemBtn_OnPressed()
    if self.IsEmpty then
        return
    end
    if self.IsSelect then
        return
    end
    self:PlayBtnAnimation("Press")
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Forbidden_UnHover or Animation == self.UnHover then
        self:PlayBtnAnimation("Normal")
    elseif Animation == self.In then
        self:PlayBtnAnimation("Normal")
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:OnMountsItemBtn_OnClicked()
    return UIUtils.Handle
end

return M
