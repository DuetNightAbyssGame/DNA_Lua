--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Bag_RandomBoxDialog_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

function M:InitContent(Params, PopupData, Owner)
    self.Params = Params

    self:ShowItemList(self.Params.UseParam)
    if Params.ChooseCallbackFunction then
        self.Panel_Exchange:SetVisibility(UIConst.VisibilityOp.Visible)
        self:SetSlider()
    else
        self.Panel_Exchange:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

end

function M:ShowItemList(PackId)
    local PackDetail = DataMgr.Reward[PackId].Id
    local Types = DataMgr.Reward[PackId].Type
    local Counts = DataMgr.Reward[PackId].Count
    local Rates = DataMgr.Reward[PackId].Param

    self.List_Item:ClearListItems()
    for key, value in pairs(PackDetail) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local ResourceConfig = DataMgr.Resource[value]

        Content.Id = value
        Content.Type = Types[key]
        Content.Count = Counts[key][1]
        Content.Owner = self
        Content.Rate = math.floor(Rates[key] / 10000) * 100
        Content.Icon = ResourceConfig.Icon
        Content.Rarity = ResourceConfig.Rarity
        Content.UseEffectType = ResourceConfig.UseEffectType
        Content.IsShowDetails = true
        Content.BonusType = 1
        Content.ExtraBonusText = GText(Content.Rate .. "%")
        
        self.List_Item:AddItem(Content)
    end
    self.List_Item:RequestFillEmptyContent()

    -- local ResourceData = DataMgr.Resource[self.Params.ResourceId]
    -- self.Icon_Gift:SetBrushResourceObject(LoadObject(ResourceData.Icon))
end

function M:SetSlider()
    local MaxCount = self:GetMaxCount()
    self.Num_Limit:SetText(GText(tostring(MaxCount)))

    local ConfigData = {
        InitValue = 1,
        MinValue = 1,
        MaxValue = MaxCount,
        EnableMiniBtn = true,
        EnableMaxBtn = true,
        ClickInterval = 1,
        MinusBtnCallback = self.MinusBtnCallback,

        AddBtnCallback = self.AddBtnCallback,
        MaxBtnCallback = self.AddBtnCallback,
        SliderChangeCallback = self.SliderChangeCallback,
        -- SoundResPath = {Minus="event:/ui/common/click_btn_minus"},
        OwnerPanel = self,
        PlatformName = "PC"
    }
    self.Com_Slider:Init(ConfigData)

    self:ChangeCountClickCallback()
end

function M:GetMaxCount()
    local Avatar = GWorld:GetAvatar()
    local ResourceData = Avatar.Resources[self.Params.ResourceId]
    return ResourceData and ResourceData.Count or 0
end

function M:MinusBtnCallback()
    self.CurrentCount = self.Com_Slider.CurrentCount
    self:UpdateOpenCount()
    self:ChangeCountClickCallback()
end

function M:AddBtnCallback()
    self.CurrentCount = self.Com_Slider.CurrentCount
    self:UpdateOpenCount()
    self:ChangeCountClickCallback()
end

function M:SliderChangeCallback(Value)
    self.CurrentCount = Value
    self:UpdateOpenCount()
    self:ChangeCountClickCallback()
end

function M:UpdateOpenCount()
    self.Num_Exchange:SetText(GText(tostring(self.CurrentCount)))
end

function M:ChangeCountClickCallback()
    local ConsumeInfo = {
        ResourceId = self.Params.ResourceId,
        ConsumeCount = self.CurrentCount or 1
    }

    if (type(self.Params.ChooseCallbackFunction) == "function") then
        self.Params.ChooseCallbackFunction(self.Params.FunctionCallbackObj, ConsumeInfo)
    end
    -- self.Owner:ForbidRightBtn(false)

end

return M
