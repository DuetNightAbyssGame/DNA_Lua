--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Item_CharacterSlot_C
local WBP_Com_Item_CharacterSlot_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_Com_Item_CharacterSlot_C:Init(Parmas)
    self.Parent = Parmas.Owner
end

function WBP_Com_Item_CharacterSlot_C:OnAddedToFocusPath()
    if self.Parent then
        self.Parent.Owner.CurFocusSlot = self.Parent
        self.Parent:OnFocusReceived()
    end
    return false
end

return WBP_Com_Item_CharacterSlot_C
