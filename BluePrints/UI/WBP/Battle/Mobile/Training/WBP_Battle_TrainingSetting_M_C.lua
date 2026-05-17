local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

local UIUtils = require "Utils.UIUtils"

function M:GetTrainingComp()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then 
        return GameMode:GetDungeonComponent()
    end

    return nil
end

function M:InitView()
    self.Text_TrainingMenu:SetText(GText("UI_DUNGEON_DES_TRAINING_14"))
    self.WBP_Com_BtnImg:BindEventOnClicked(self, self.OnBtnClicked)
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	self.TrainingData = DataMgr.Training[GameMode.DungeonId]
    self:AddTimer(1, function()
        self:UpdateMonsterNum()
    end, true, 0, "UpdateMonsterNumTimer")
end

function M:UpdateMonsterNum()
    local CurrentMonsterNum = self:GetTrainingComp():CheckAliveMonsterCount()
    local Text = string.format(GText("UI_DUNGEON_DES_TRAINING_41"), string.format("%d<Grey>/%d</>", CurrentMonsterNum, self.TrainingData.MaxEnemyNum))
    self.Text_TrainingTitle:SetText(Text)
end

function M:OnBtnClicked()
    UIManager(self):LoadUINew("TrainingSettingPage")
end

function M:Destruct()
    self:RemoveTimer("UpdateMonsterNumTimer")
end



return M