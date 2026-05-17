--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_BagGameButton_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

-- 给 Text_Button 设置显示文字
function M:SetText(Text)
    self.Text_Button:SetText(Text)
end

function M:SetGamePadImg(ImgShortPath, ImgLongPath)
    self.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = ImgShortPath,
                ImgLongPath = ImgLongPath,
            }
        },
        bLongPress = false,
        bButton = true,
    })
end

return M
