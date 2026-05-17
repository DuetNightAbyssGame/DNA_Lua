--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AutoChess_MonsterHead_C
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
function M:OnListItemObjectSet(Content)
    self.MissionId = Content.MissionId
    local Info = DataMgr.CombatChessInfo[Content.AutoChessId]
    self.Monster_Head:SetBrushResourceObject(LoadObject(Info.MonsterIcon))
    self.Icon_Type.Icon:SetBrushResourceObject(LoadObject(Info.PositionIcon))
    if Content.EquipCount == 2 then
        self.Equipment_01.WS_Type:SetActiveWidgetIndex(0)
        self.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
    elseif Content.EquipCount == 1 then
        self.Equipment_01.WS_Type:SetActiveWidgetIndex(1)
        self.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
    else
        self.Equipment_01.WS_Type:SetActiveWidgetIndex(0)
        self.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
    end
    self.Button_Area.OnClicked:Add(self, self.OnClick)
end


function M:OnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    UIManager(self):LoadUINew("AutoChessDeputeMonsterInfoUI",self.MissionId)
end


return M
