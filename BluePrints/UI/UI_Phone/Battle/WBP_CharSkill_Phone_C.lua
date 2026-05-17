--
-- DESCRIPTION
-- 手机端技能+蓝条按键
-- @COMPANY **
-- @AUTHOR zhuyuhao
-- @DATE ${date} ${time}
--
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"

---@type CharSkill_Phone_C
local M = Class("BluePrints.UI.BP_UIState_C")

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

function M:Initialize(Initializer)
end

--function M:PreConstruct(IsDesignTime)
--end

--function M:Destruct()
--
--end

function M:Construct()
    self.Super.Construct(self)
    self.SkillItems = {self.CharSkill_1, self.CharSkill_2}
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    self.CharSkill_1:SetSkillIndex(1, UE.ESkillType.Skill1, ESkillName.Skill1, "Skill1", self)
    self.CharSkill_2:SetSkillIndex(2, UE.ESkillType.Skill2, ESkillName.Skill2, "Skill2", self)

    self:OnUpdateCharSp(nil, nil, self.OwnerPlayer)
    if self.OwnerPlayer then
        self.MaxSp = self.OwnerPlayer:GetAttr("MaxSp")
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--每0.1秒调用一次
function M:UpdateSkillInTimer()
    self.CharSkill_1:UpdateSkillInTimer()
    self.CharSkill_2:UpdateSkillInTimer()
end

function M:OnUpdateMaxSp(NewMaxSp)
    if not NewMaxSp then return end
    DebugPrint("@zyh 最新MaxSp更新为", NewMaxSp)
    self.MaxSp = NewMaxSp

    local SpPercent = math.min(math.max(self.NowSp / self.MaxSp,0), 1)

    self:Set_ProgressValue(SpPercent)
end

-- 对蓝条的修改 对技能是否满足蓝量的切换，都写在这里
function M:OnUpdateCharSp(NowSp, OldSp, Owner)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    if not Owner or Owner ~= self.OwnerPlayer then
        -- 部分UpdateMainPlayerSp事件是由服务端通知客户端的，因此联机下需要区分是否是自己的客户端
        return
    end
    if not self.MaxSp then
        self.MaxSp = self.OwnerPlayer:GetAttr("MaxSp")
    end
    if NowSp then
        self.NowSp = NowSp
    else
        self.NowSp = self.OwnerPlayer:GetAttr("Sp")
    end
    self.Total_Energy_Num:SetText(math.floor(self.NowSp))
    local SpPercent = math.min(math.max(self.NowSp / self.MaxSp,0), 1)

    self:Set_ProgressValue(SpPercent)
    --补上对技能蓝量的判断
    for i = 1, 2 do
        if not self.SkillItems[i].SkillInfo.CostSp then
            return
        end
        if self.NowSp < self.SkillItems[i].SkillInfo.CostSp then
            self.SkillItems[i].SkillInfo.HasEnoughSp = false
        else
            self.SkillItems[i].SkillInfo.HasEnoughSp = true
        end
    end
end

AssembleComponents(M)

return M
