
require "UnLua"

local AIBattleMgr = Class()

AIBattleMgr._components = {
    --"BluePrints.GameMode.Components.CoverComponent",
    --"BluePrints.GameMode.Components.LocAdjustComponent",
    -- "BluePrints.Combat.Components.AICampComponent",
    "BluePrints.GameMode.Components.AIAlertComponent",
    "BluePrints.GameMode.Components.DivisionComponent",
    --"BluePrints.GameMode.Components.MonShareSkillCDComponent",
}

function AIBattleMgr:AIBattleMgrReceiveBeginPlay()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    self:ComponentReceiveBeginPlay()
end

function AIBattleMgr:InitAIBattleMgr()
	self:InitComponent()
    self:ResetRVOParams()
end

function AIBattleMgr:InitComponent()
end

function AIBattleMgr:TickAIBattleMgr(DeltaSeconds)
    if self:GetPlayerNum() <= 0 then 
        return 
    end
    -- self.CoverComponent:Tick(DeltaSeconds)
    self.LocAdjustComponent:Tick(DeltaSeconds)
    self:TickComponent(DeltaSeconds)
end

function AIBattleMgr:ResetRVOParams()
    -- 设置RVO参数
    -- 引擎默认值：
    -- local DefaultTimeToLive = 1.5
    -- local LockTimeAfterAvoid = 0.2
    -- local LockTimeAfterClean = 0.001
    -- local DeltaTimeToPredict = 0.5
    -- local ArtificialRadiusExpansion = 1.5
    -- local HeightCheckMargin = 10

    local DefaultTimeToLive  = DataMgr.RVOData["DefaultTimeToLive"].ParamValue[1]     
    local LockTimeAfterAvoid = DataMgr.RVOData["LockTimeAfterAvoid"].ParamValue[1]      			-- 表示发生一次避让决策后，锁当前速度多长时间，该速度会在一段时间内覆盖寻路输出速度，并且在这段时间内不会再计算避让。
    local LockTimeAfterClean = DataMgr.RVOData["LockTimeAfterClean"].ParamValue[1]    				-- 表示发生一次无避让决策后，锁当前速度（每帧寻路输出速度）多长时间，时间过后才会开始计算避让。
    local DeltaTimeToPredict = DataMgr.RVOData["DeltaTimeToPredict"].ParamValue[1]       
    local ArtificialRadiusExpansion = DataMgr.RVOData["ArtificialRadiusExpansion"].ParamValue[1]   -- 该数据 * 角色胶囊体半径 = RVO计算避让时的单位半径
    local HeightCheckMargin = DataMgr.RVOData["HeightCheckMargin"].ParamValue[1]             		-- 表示两个避让对象最大高度差，超过这个高度差不参与避让

    self:ResetAvoidanceManagerParams(DefaultTimeToLive, LockTimeAfterAvoid, LockTimeAfterClean, DeltaTimeToPredict, ArtificialRadiusExpansion, HeightCheckMargin)
end

AssembleComponents(AIBattleMgr)
return AIBattleMgr