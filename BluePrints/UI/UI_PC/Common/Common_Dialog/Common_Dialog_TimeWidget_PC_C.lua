local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C", 
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
})

function M:InitContent(Params, PopupData, Owner)
    if Params and Params.CountDownParams then
        local CountDownName = Params.CountDownParams.Name
        local CountDownRemainTime = Params.CountDownParams.RemainTime
        local CountDownTimeIconPath = Params.CountDownParams.TimeIcon
        local CountDownEndTime = TimeUtils.NowTime() + CountDownRemainTime
        self:AddTimer(1, function() 
            local CurrentTime = TimeUtils.NowTime()
            if CurrentTime > CountDownEndTime then
                self:RemoveTimer("DialogCountDown")
                return 
            end
            local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(CountDownEndTime)
            self.Time:SetTimeText(CountDownName, RemainTimeDict, CountDownTimeIconPath)
        end, true, -1, "DialogCountDown")
    end
end

return M