--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Temple_Solo_Button_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    self.IsHovered = false
end

function M:Construct()
    self.Text:SetText(GText("UI_TempleEvent_EntryLevel")) 

    self.Controller:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X"
            }
        }
    })
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnClicked()
    self:PlayAnimation(self.Click)
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MouseEvent)
    self:PlayAnimation(self.UnHover)
end

return M
