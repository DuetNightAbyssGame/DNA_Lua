--
-- DESCRIPTION
-- 累充活动SP奖励上方的展示Item （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:FillWithData(Content)
    self.Content = Content
    self.ParentWidget = Content.ParentWidget
    self.ItemType = Content.ItemType
    self.Id = Content.Id
    self.Index = Content.Index
    self.Count = Content.Count
    self.StuffClickCallback = Content.StuffClickCallback

    self:UpdateView(Content)

    -- 一些点击相关
    self:UnBindButtonPerformances()
    self:BindButtonPerformances()
end

function M:GetRewardStuffIndex()
    return self.Index
end

function M:UpdateView(Content)
    local Type = Content.LastRewardTypeId
    local Id = Content.LastRewardId
    local ItemData = DataMgr[Type][Id]
	if not ItemData then
		return
	end
    local Name = ItemData.MountName or ""
    -- self.Text_Num:SetText(Content.NeedPoint)
    self.Text_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Title:SetText(string.format(GText("UI_Event_CumulativeTopUpEvent_FinalRewardDes"), Content.NeedPoint))
    self.TextReName:SetText(GText(Name))
    self.Com_Key_View:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
    })
    -- local IconDynaMaterial = self.Img_Icon:GetDynamicMaterial()
    -- if(IconDynaMaterial)then
    --     IconDynaMaterial:SetTextureParameterValue("IconMap", Content.Icon)
    -- end

    -- self:PlayAnimation(self.Normal)
end

function M:BindButtonPerformances()
    self.BtnView:BindEventOnClicked(self, self.OnBtnClicked)
    self.BtnView:TryOverrideSoundFunc(function() end)
end

function M:UnBindButtonPerformances()
    self.BtnView:UnBindEventOnClickedByObj(self)
end

function M:OnStuffDetailViewOpenChanged(IsOpened)
    if (type(self.StuffClickCallback) == "function") then
        self.StuffClickCallback(self.ParentWidget, IsOpened, self.Index)
    end
end

function M:OnBtnClicked()
    if self.Content == nil then
        return
    end
    if self.Content.LastRewardTypeId ~= "Mount" or self.Content.LastRewardId == nil then
        return
    end
    local Content = {}
    Content.TypeId = self.Content.LastRewardId
    Content.ItemType = self.Content.LastRewardTypeId
    Content.SinglePreview = true
    Content.HidePurchase = true
    UIManager(self):LoadUINew("SkinPreview", Content, self.ParentWidget)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    -- UIManager(self):LoadUINew("MountsMain", self.Content.LastRewardId)
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
    if IsUseGamePad then
        self.WS_Btn:SetActiveWidgetIndex(1)
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
    end
end

return M