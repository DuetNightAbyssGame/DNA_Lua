--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Fame_BtnRefresh_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Button_Hot.OnClicked:Add(self, self.OnRefreshBtnClicked)
    self.Button_Hot.OnHovered:Add(self, self.OnRefreshBtnHovered)
    self.Button_Hot.OnUnhovered:Add(self, self.OnRefreshBtnUnhovered)
    self.Button_Hot.OnPressed:Add(self, self.OnRefreshBtnPressed)
    self.Button_Hot.OnReleased:Add(self, self.OnRefreshBtnReleased)
end

function M:Init(Content)
    rawset(self, "Id", Content.Id)
    rawset(self, "Type", Content.Type)
    rawset(self, "Expend", Content.Expend)
    rawset(self, "Parent", Content.Parent)
    rawset(self, "MaxRefreshCount", Content.MaxRefreshCount)
    rawset(self, "AlreadyRefreshCount", Content.AlreadyRefreshCount)
    rawset(self, "RefreshClickedCallBack", Content.RefreshClickedCallBack)

    local IconContent = NewObject(UIUtils.GetCommonItemContentClass())
    IconContent.ItemType = self.Type
    IconContent.Id = self.Id
    local ResourceInfo = DataMgr[self.Type][self.Id]
    IconContent.Icon = ResourceInfo.Icon
    self.Icon:Init(IconContent)
    self.Text_Num:SetText(self.Expend)

    local Avatar = GWorld:GetAvatar()
    if(Avatar and ResourceInfo)then
        local Item = Avatar.Resources[self.Id] or {Count = 0}
        if (Item.Count >= self.Expend) then
            self.Text_Num:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFFF"))
        else
            self.Text_Num:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("D82E30FF")) 
        end
    end

    self.Text_Re:SetText(GText("RegionReputation_Refresh"))
    local RemainCount = math.max(0, self.MaxRefreshCount - self.AlreadyRefreshCount)
    self.Text_Number:SetText(string.format("%d/%d", RemainCount, self.MaxRefreshCount))
    self:UpdateGamePadStyle()
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Click then
        if self.bHovered then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
        else
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        end
    end
end

function M:OnRefreshBtnClicked()
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    if self.RefreshClickedCallBack then
        self.RefreshClickedCallBack(self.Parent)
    end
end

function M:OnRefreshBtnHovered()
    rawset(self, "bHovered", true)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
end

function M:OnRefreshBtnUnhovered()
    rawset(self, "bHovered", false)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnHover)
end

function M:OnRefreshBtnPressed()
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    -- ScreenPrint("OnRefreshBtnPressed")
end

function M:OnRefreshBtnReleased()
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    -- ScreenPrint("OnRefreshBtnReleased")
end

function M:UpdateGamePadStyle()
    if not self.Parent then
        return
    end
    if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
        self:UpdateMouseGamePadImage()
        self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:UpdateMouseGamePadImage()
    if self.InitedGamePadKey then
        return
    end
    local CurGamepadName = self.Parent.CurGamepadName
    -- 手柄资源选择按键图片
    self.WBP_Com_KeyImg:CreateCommonKey({KeyInfoList = {{
        Type = "Img",
        ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("Y", CurGamepadName)}
    }})
    rawset(self, "InitedGamePadKey", true)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Button_Hot.OnClicked:Remove(self, self.OnRefreshBtnClicked)
    self.Button_Hot.OnHovered:Remove(self, self.OnRefreshBtnHovered)
    self.Button_Hot.OnUnhovered:Remove(self, self.OnRefreshBtnUnhovered)
    self.Button_Hot.OnPressed:Remove(self, self.OnRefreshBtnPressed)
    self.Button_Hot.OnReleased:Remove(self, self.OnRefreshBtnReleased)
end


return M
