-- 局内Buff详情
require "UnLua"
local UIUtils = require "Utils.UIUtils"
local WBP_Activity_AutoChess_Buff = Class("BluePrints.UI.BP_EMUserWidget_C")
local Model = require "BluePrints.UI.AutoChess.AutoChessDataModel"

function WBP_Activity_AutoChess_Buff:ShowBuff(MissionId)
    self:BindBtnEvent()
    if self.List_Buff then
        self.List_Buff:ClearListItems()
        self.List_Buff:SetVisibility(UE4.ESlateVisibility.Visible)
        self:GetBuffsInfoTable(MissionId)
        self:BuffInit()
    end
end

function WBP_Activity_AutoChess_Buff:BuffInit()
    if self.BuffData and #self.BuffData > 0 then
        for Index = 1, #self.BuffData do
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            local Row = DataMgr.AutoChessBuff[self.BuffData[Index]]
            if Row then
                Obj.BuffName = GText(Row.BuffName)
                Obj.BuffIcon = Row.BuffIcon
                self.List_Buff:AddItem(Obj)
            else
                DebugPrint(ErrorTag, "传入的AutoChessBuff主键非法")
            end
        end
    else
        DebugPrint(ErrorTag, "MissionData 无效或长度小于等于 0，无法执行循环。")
    end
end

function WBP_Activity_AutoChess_Buff:GetBuffsInfoTable(MissionId)
    self.MissionId = MissionId
    local BuffData = Model:GetBuffsByMissionId(self.MissionId)
    if BuffData then
        self.BuffData = BuffData
    end
end

function WBP_Activity_AutoChess_Buff:BindBtnEvent()
    if self.Btn_CheckBuff then
        self.Btn_CheckBuff.Button_Area.OnClicked:Add(self, self.ShowBuffDetail)
    end
end

function WBP_Activity_AutoChess_Buff:ShowBuffDetail()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local BuffDetailUI = UIManager:GetUIObj("AutoChessBuffDetail")
    if not BuffDetailUI then
        BuffDetailUI = UIManager:LoadUINew("AutoChessBuffDetail", self.MissionId)
    end
    BuffDetailUI:SetVisibility(UE4.ESlateVisibility.Visible)
end

return WBP_Activity_AutoChess_Buff
