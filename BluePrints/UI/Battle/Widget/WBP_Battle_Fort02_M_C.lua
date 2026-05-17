require "UnLua"
require "DataMgr"

local WBP_Battle_Fort02_M_C = Class("BluePrints.UI.Battle.Widget.WBP_Battle_Fort_M_C")

WBP_Battle_Fort02_M_C._components = {
    "BluePrints.UI.UIComponent.TouchComponent",
}

function WBP_Battle_Fort02_M_C:Initialize(Initializer)
    WBP_Battle_Fort02_M_C.Super.Initialize(self)
end

function WBP_Battle_Fort02_M_C:OnLoaded(...)
    self.HideUITable = {
        Pos_Entry = 1,
        Pos_Drops = 1,
        Pos_SpecialDrops = 1,
        Pos_NewMonster = 1,
        Btn_Esc = 1,
        Btn_GuideBook = 1,
        Group_ChatEntry = 1,
        Buff = 1,
        Char_Skill = 1,
        Team = 1,
        Chat_Entry = 1,
        HBox = 1,
    }
    WBP_Battle_Fort02_M_C.Super.OnLoaded(self, ...)
end

AssembleComponents(WBP_Battle_Fort02_M_C)
return WBP_Battle_Fort02_M_C