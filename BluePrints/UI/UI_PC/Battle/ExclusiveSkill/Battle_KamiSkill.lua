--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_Kami_Skill_C
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

--function M:Initialize(Initializer)
--end

function M:Construct()
    DebugPrint("lgc@Battle_KamiSkill M:Construct", 123123)  
    self.DeltaTime = 0
end

function M:OnLoaded(OwnerPlayer, Params)
    DebugPrint("lgc@Battle_KamiSkill M:OnLoaded", 123123)
    -- 获取玩家的角色蓝图
    self.OwnerPlayer = OwnerPlayer
    self.CreatureId = Params.CreatureId
    self.bIsCreatureActive = false
    self.MaxLifeTime = 666
    self.Battle = Battle(self.OwnerPlayer)

    -- 默认隐藏
    self.Root:SetVisibility(ESlateVisibility.Collapsed)
    self:AddTimer(0.3, self.UpdateBattleCharUI, true, 0)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:UpdateBattleCharUI()
    if IsValid(self.OwnerPlayer) and IsValid(self.Battle) then
        local CreatureList = self.OwnerPlayer:GetCreatureList(self.CreatureId)
        local bHasActiveCreature = false
        local bFirstActive = false
        local MaxRemainingLifeTime = -1
        if CreatureList:Num() > 0 then
            local CurCreatureList = CreatureList:ToTable()
            --身上的八个此类创生物的Lifetime是永远保持一致的，所以只需要获取第一个即可
            if #CurCreatureList > 0 then
                local Creature = self.Battle:GetEntity(CurCreatureList[1])
                if IsValid(Creature) then
                    bHasActiveCreature = true
                    if not self.bIsCreatureActive then
                        self.bIsCreatureActive = true
                        bFirstActive = true
                    end
                    -- 获取Creature的剩余生命时间
                    local LeftLifeTime = Creature:GetLeftLifeTime()
                    if LeftLifeTime and LeftLifeTime > 0 then
                        MaxRemainingLifeTime = LeftLifeTime
                    end
                end
            end
        end
        if bHasActiveCreature and MaxRemainingLifeTime > 0 then
            -- 刚激活，记录最大值
            if bFirstActive then
                -- 获取总生命时间作为最大值
                local CurCreatureList = CreatureList:ToTable()
                if #CurCreatureList > 0 then
                    local FirstCreature = self.Battle:GetEntity(CurCreatureList[1])
                    if IsValid(FirstCreature) then
                        local TotalLifeTime = FirstCreature:GetTotalLifeTime()
                        if TotalLifeTime and TotalLifeTime > 0 then
                            self.MaxLifeTime = TotalLifeTime
                        else
                            self.MaxLifeTime = MaxRemainingLifeTime
                        end
                    end
                end
                self:PlayAnimation(self.In)
            end
            -- 更新进度
            self:UpdateProgress(MaxRemainingLifeTime, self.MaxLifeTime)
            -- 更新是否暂停
            -- 通过MaxRemainingLifeTime数值变化来判断是否暂停
            local bNowPausing = false
            if MaxRemainingLifeTime and MaxRemainingLifeTime > 0 then
                if self.LastMaxRemainingLifeTime and self.LastMaxRemainingLifeTime == MaxRemainingLifeTime then
                    bNowPausing = true
                end
            end
            self.LastMaxRemainingLifeTime = MaxRemainingLifeTime
            DebugPrint("lgc@Battle_KamiSkill M:UpdateBattleCharUI", bNowPausing, MaxRemainingLifeTime)
            self.bOldPausing = self.bOldPausing or false
            if bNowPausing and not self.bOldPausing then
                self:PlayAnimationForward(self.Pause)
            elseif not bNowPausing and self.bOldPausing then
                self:PlayAnimationReverse(self.Pause)
            else
                -- do nothing
            end
            self.bOldPausing = bNowPausing
            self.Root:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            -- 没有活跃的Creature或生命时间已耗尽
            if self.bIsCreatureActive then
                self:BindToAnimationFinished(self.Out, function ()
                    self:UnbindAllFromAnimationFinished(self.Out)
                    self.Root:SetVisibility(ESlateVisibility.Collapsed)
                end)
                
                self:PlayAnimation(self.Out)
            end
            self.bIsCreatureActive = false
        end
    end
end

function M:UpdateProgress(Remaining, Max)
    if Remaining > 0 then
        local Percent = math.max(Remaining / Max, 0)
        self.Progress_Kami:SetPercent(Percent)
        self.Num_Kami:SetText(string.format("%.0f", Remaining))
    end
end

--function M:Destruct()
--end


return M
