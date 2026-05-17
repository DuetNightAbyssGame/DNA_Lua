--
-- DESCRIPTION
-- 手机端List子项（聊天不同频道）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_TabIcon_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--    Info = {
--             Text = "任务"   Tab文本
--             TabId = 1, Tab的Id,
---            IconPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 图片路径
--             ShowRedDot = 1, 显示红点,
--             IsNew = 1, 显示新图标,
--             ShowRedDotNum = 10, 显示数量红点
--             IsLocked = false,  是否此Tab仍处于锁定状态（true为锁定）
--             LockReasonText = GText("UI_RegionMap_MaxMark"), 未解锁点击提示文本
--           }     

function M:OnListItemObjectSet(Content)
    self.Index = Content.Index
    self.ChannelType = Content.ChannelType
    self.ParentWidget = Content.ParentWidget
    self.ClickCallback = Content.ClickCallback
    self:UpdateView(Content)
end

function M:SetDisturbIcon(bNotDisturb)
    RunAsyncTask(self, "SetDisturbIconTask", function(CoroutineObj)
        if bNotDisturb then
            if not self.DisturbUI then
                self.DisturbUI = UIManager():CreateWidgetAsync(nil, CoroutineObj, 
                    '/Game/UI/WBP/Chat/Widget/WBP_Chat_DontDisturb.WBP_Chat_DontDisturb', false)
                self.Group_ChatDontDisturb:AddChild(self.DisturbUI)
            end
            self.Group_ChatDontDisturb:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        else
            self.Group_ChatDontDisturb:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end)
end

function M:UpdateView(Content)
    Content.UI = self
    self.Info = Content
    if (Content.ChannelIcon) then
        local Icon = LoadObject(Content.ChannelIcon)
        self.Image_Icon:SetBrushResourceObject(Icon)
        self.Image_Sign:SetBrushResourceObject(Icon)
        -- local Material = self.Img_TabIcon:GetDynamicMaterial()
        -- Material:SetTextureParameterValue("Mask", Icon)
    end
    self.Text_TabName:SetText(GText(Content.ChannelName))
    if(self.Reddot)then
        self:SetReddot(Content.IsNew, Content.ShowRedDot)
    end
    if (self.Reddot_Num) then
        self:SetReddotNum(Content.ShowRedDotNum)
    end
    if (Content.NeedSelectIdx == self.Index) then
        self:SetIsSelected(true)
    else
        self:SetIsSelected(false)
    end
    self:SetDisturbIcon(Content.bNotDisturb)
end

function M:SetIsSelected(bIsSelect)
    if (bIsSelect) then
        self:PlayAnimation(self.Click)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:SetReddot(IsNew,Upgradeable,OtherReddot)
    self.IsNew = IsNew
    self.Upgradeable = Upgradeable
    self.OtherReddot = OtherReddot
    if(IsNew)then
        self.New:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        return
    end
    self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if(self.Reddot) then
        if(OtherReddot)then
            self.Reddot:SetReddotStyle(1)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        elseif(Upgradeable)then
            self.Reddot:SetReddotStyle(1)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

function M:SetReddotNum(RedNum)
    if (RedNum ~= nil and RedNum > 0) then
        self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if RedNum > ChatCommon.ReddotMaxCount then
            self.Reddot_Num:SetNum(ChatCommon.ReddotMaxCount.."+")
        else
            self.Reddot_Num:SetNum(RedNum)
        end
    else
        self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M
