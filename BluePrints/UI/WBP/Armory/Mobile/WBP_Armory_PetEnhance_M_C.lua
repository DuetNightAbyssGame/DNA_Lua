
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE 2025.3.11
--
require "UnLua"
--宠物进阶词条界面移动端
---@type WBP_Armory_PetEnhance_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {
  "BluePrints.UI.WBP.Armory.WBP_Armory_PetEnhance_Base_Compoment"

}
function M:InitTabInfo()
    self.Tab_PetEnhance:Init({
        Tabs = {},
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("Pet_Affix_Break"),
        BackCallback = self.OnReturnKeyDown
    })
end

function M:Close()
    -- TODO 界面关闭逻辑
    M.Super.Close(self)
end

function M:InitListenEvent()
    -- TODO 监听相关事件
end

function M:OnLoaded(...)
    -- 界面初始化完成
    local P=...
    M.Super.OnLoaded(self, ...)
    self:InitListenEvent()
    self:PlayInAnim()
end
function M:RefreshBaseInfo()
    -- 刷新一些基础数据
end

function M:OnReturnKeyDown()
    -- 返回上一级
    if (not self:CheckIsCanCloseSelf()) then
        return
    end

    self:PlayOutAnim()
end


--------------------------输入交互--------------------------------
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

AssembleComponents(M)

return M
