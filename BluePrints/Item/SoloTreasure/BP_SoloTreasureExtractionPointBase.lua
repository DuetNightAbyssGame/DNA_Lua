--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type SoloTreasureExtractionointBase_C
local M = Class({"BluePrints.Common.TimerMgr", "BluePrints.Common.Triggers.BP_AOITriggerBox_C"})

function M:Initialize(Initializer)

end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

-- function M:OnOverlapActor(OtherActor, OtherComponent)
--     if not OtherActor then
--         return
--     end
--     if OtherActor.IsCharacter and not OtherActor:IsCharacter() then
--         return
--     end
--     self:InitCountDown()
-- end

-- function M:InitCountDown()
--     if self.CountDownIsOpen then
--         self.CountDownIsOpen = false
--         self:CloseCountDown()
--     else
--         self.CountDownIsOpen = true
--         self:StartCountDown()
--     end
-- end

function M:BeginOverlapExecLogic()
    DebugPrint("BeginOverlapExecLogic")
    if self.LeaveEvacuationPointTips then
        self.LeaveEvacuationPointTips:CloseUI()
        self.LeaveEvacuationPointTips = nil
    end
    --创建倒计时TipsUI
    self.EvacuationCountDownTips = UIManager(self):LoadUINew("SoloTreasureExtractionCountDownTips")
    self.EvacuationTime = DataMgr.SoloTreasure.EvacuationTime or 10
    --开始倒计时
    self:AddTimer(0.1, function()
        if not (self.EvacuationTime and self.EvacuationCountDownTips) then
            self:RemoveTimer("EvacuationTime")
            return
        end
        self.EvacuationTime = math.max(0, self.EvacuationTime - 0.1)
        if self.EvacuationCountDownTips.SetCountDownTime then
            local CountDownTime = math.ceil(self.EvacuationTime)
            self.EvacuationCountDownTips:SetCountDownTime(CountDownTime, CountDownTime <= 5)
        end
        if self.EvacuationTime <= 0 then
            self:RemoveTimer("EvacuationTime")
            self.EvacuationCountDownTips:CloseUI()
            self.EvacuationCountDownTips = nil
            local GameMode = UE4.UGameplayStatics.GetGameMode(self)
            if GameMode then
                GameMode:TriggerDungeonComponentFun("FinishSolotreasure", true, "EvacuationSuccessful")
            end
            return
        end
    end, true, 0.1, "EvacuationTime", true)


end

function M:EndOverlapExecLogic()
    DebugPrint("EndOverlapExecLogic")
    --关闭倒计时
    self:RemoveTimer("EvacuationTime")
    --local EvacuationCountDownTips = UIManager(self):GetUIObj("SoloTreasureExtractionCountDownTips")
    if self.EvacuationCountDownTips then
        self.EvacuationCountDownTips:CloseUI()
        self.EvacuationCountDownTips = nil
    end
    -- 5 秒内只弹一次提示
    if self.EndOverlapUITipCD then
        return
    end
    self.EndOverlapUITipCD = true
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_24"))
    self:AddTimer(0.1, function()
        self.EndOverlapUITipCD = false
    end, false, 5)
    --self.LeaveEvacuationPointTips = UIManager(self):LoadUINew("LeaveSoloTreasureExtractionTips")
end

-- function M:CloseCountDown()
--     DebugPrint("thy CloseCountDown")
-- end

-- function M:StartCountDown()
--     DebugPrint("thy StartCountDown")
-- end

return M
