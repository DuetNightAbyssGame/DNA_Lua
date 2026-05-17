--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_SubNumItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Init(ConfigData)
    rawset(self, "OwnerPanel", ConfigData.OwnerPanel)
    rawset(self, "ClickedCallback", ConfigData.ClickedCallback)
    rawset(self, "SpecificChangeCount", ConfigData.SpecificChangeCount)
    rawset(self, "GamePadKey", ConfigData.GamePadKey)

    self.Btn_PC:BindEventOnClicked(self, self.OnClicked)
    self.Btn_PC.Text_Num:SetText(self.SpecificChangeCount)

    self.Key_Num:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = UIConst.GamePadImgKey[self.GamePadKey],
            },
        },
        bDisableResetWhenChangeDevice = true,
    })
    self.Text_Num:SetText(self.SpecificChangeCount)

    self.bIsInForbid = false
end

function M:OnClicked()
    if (type(self.ClickedCallback) == "function") then
        self.ClickedCallback(self.OwnerPanel)
    end
end

function M:SetForbid(IsForbid)
    -- DebugPrint("Forbid Btn", IsForbid)
    self.Btn_PC:ForbidBtn(IsForbid)
    self.Key_Num:SetForbidKey(IsForbid)
    if IsForbid then
        self:PlayAnimation(self.Forbidden)
    else
        self:PlayAnimation(self.Normal)
    end
    self.bIsInForbid = IsForbid
end

function M:IsInForbidState()
    return self.bIsInForbid
end

function M:ChangeUIStyleForCurPlatform(IsUseKeyAndMouse)
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    self.WS_Item:SetActiveWidgetIndex(ActiveWidgetIndex)
end

return M
