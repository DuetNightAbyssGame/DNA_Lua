--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"

---@type WBP_Battle_FortBloodBar_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:ClearAllTimer()
    local EffectUIWidget = UIManager(self):GetUIObj(UIConst.BattleNearDeathPCName)
    if EffectUIWidget ~= nil  then
        EffectUIWidget:BindToAnimationFinished(EffectUIWidget.Out, function ()
            EffectUIWidget:UnbindAllFromAnimationFinished(EffectUIWidget.Out)
            UIManager(self):UnLoadUI(UIConst.BattleNearDeathPCName)
        end)
        EMUIAnimationSubsystem:EMPlayAnimation(EffectUIWidget,EffectUIWidget.Out)
    end

    EffectUIWidget = UIManager(self):GetUIObj(UIConst.BattleBrokenShieldPCName)
    if EffectUIWidget ~= nil then
        EffectUIWidget:StopAllAnimations()
        EffectUIWidget:Hide()
    end
    self.bIsDestruct = true
    self.IsDestroied = true
    if self.Owner and self.Owner.BillboardComponent then
        self.Owner.BillboardComponent:SetIsForbidShowBloodUI(false)
    end
    M.Super.Destruct(self)
end
function M:UpdateBloodScreenEffect()
    local CurrentBlood = self.CurHp
    local MaxBlood = self.MaxHp
    local BloodStrength = CurrentBlood / MaxBlood
    local NowEnergyShield = self.CurShield
    local SystemUIConfig = DataMgr.SystemUI[UIConst.BattleNearDeathPCName]
    if SystemUIConfig then
            --濒死特效参数
        local FirstLevelFactor= SystemUIConfig.Params.FirstLevelFactor
        local SecondLevelFactor=SystemUIConfig.Params.SecondLevelFactor
        local ShowUIBloodStrength=SystemUIConfig.Params.ShowUIBloodStrength
        local SecondLevelBloodStrength=SystemUIConfig.Params.SecondLevelBloodStrength
        if FirstLevelFactor==nil or SecondLevelFactor==nil or ShowUIBloodStrength==nil or SecondLevelBloodStrength==nil then
            return
        end
        local PreNearDeath=self.IsNearDeath
        self.IsNearDeath= BloodStrength < ShowUIBloodStrength and NowEnergyShield <= 0
        local EffectUIWidget = UIManager(self):GetUIObj(UIConst.BattleNearDeathPCName)
        local InAnimName
        if not PreNearDeath and self.IsNearDeath then
            InAnimName="In"
        end
        if PreNearDeath and self.IsNearDeath then
        InAnimName="Loop"
        end
        if PreNearDeath and not self.IsNearDeath then
            InAnimName="Out"
        end
        if self.IsNearDeath then
            if (EffectUIWidget == nil) then
                EffectUIWidget = UIManager(self):LoadUINew(UIConst.BattleNearDeathPCName)
            end
            if EffectUIWidget ~= nil then
                local BgMat
                local FlashFactor = BloodStrength > SecondLevelBloodStrength and FirstLevelFactor or SecondLevelFactor
                if CommonUtils.GetDeviceTypeByPlatformName()=="PC" then
                    BgMat = EffectUIWidget.Bg_1:GetDynamicMaterial()
                else
                    BgMat = EffectUIWidget.glassglow:GetDynamicMaterial()
                end
                if (BgMat ~= nil) then
                    BgMat:SetScalarParameterValue("Flash", FlashFactor)
                end
            end
        else
            if EffectUIWidget ~= nil and PreNearDeath then
                EffectUIWidget:BindToAnimationFinished(EffectUIWidget.Out, function ()
                    EffectUIWidget:UnbindAllFromAnimationFinished(EffectUIWidget.Out)
                    UIManager(self):UnLoadUI(UIConst.BattleNearDeathPCName)
                end)
                EMUIAnimationSubsystem:EMPlayAnimation(EffectUIWidget,EffectUIWidget.Out)
            end
        end
    end
end

function M:UpdateShieldScreenEffect()
    local SystemUIConfig = DataMgr.SystemUI[UIConst.BattleBrokenShieldPCName]
    if SystemUIConfig then
        local InAnimName=SystemUIConfig.Params.AnimName
        if InAnimName~=nil then
            local ScreenEffectUI = UIManager(self):PlayScreenEffectAnim(UIConst.LoadInConfig, UIConst.BattleBrokenShieldPCName, {{AnimName=InAnimName, StartTime=0.0, LoopNums=1}})
            -- local curTime = TimeUtils.NowTime()
            AudioManager(self):PlayUISound(ScreenEffectUI, "event:/ui/common/char_sheild_break", nil, nil)
        end
    end
end


return M
