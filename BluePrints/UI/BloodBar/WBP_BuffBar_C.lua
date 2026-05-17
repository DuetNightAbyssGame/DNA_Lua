--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_BuffBar_C
local WBP_BuffBar_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_BuffBar_C:Initialize(Initializer)
    self.Super.Initialize(self)
    -- self.WeaknessGroupList = {}
    -- self.WeaknessIconList = {}
    -- self.WeaknessAnimList = {}
    -- self.DamageTypeToIndex = {}
end

-- function WBP_BuffBar_C:Init(IsBoss)
--     self.WeaknessGroupList = {self.Group_01,self.Group_02,self.Group_03}
--     self.WeaknessIconList = {self.Icon01,self.Icon02,self.Icon03}
--     self.WeaknessAnimList = {self.Restrained_01,self.Restrained_02,self.Restrained_03}
--     if IsBoss then
--         self:PlayAnimation(self.Boss_Space)
--     else
--         self:PlayAnimation(self.Monster_Space)
--     end
-- end

-- function WBP_BuffBar_C:RefreshWeaknessIcons(WeaknessTypes)
--     for index = 1, #self.WeaknessIconList do
--         local WeaknessType = WeaknessTypes[index]
        
--         if WeaknessType then
--             self.WeaknessGroupList[index]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--             local WeaknessIcon = DataMgr.DamageType[WeaknessType].WeaknessIcon
--             if WeaknessIcon then
--                 local IconObj = LoadObject(string.format("Texture2D'%s'", WeaknessIcon))
--                 local ImgMat = self.WeaknessIconList[index]:GetDynamicMaterial()
--                 ImgMat:SetTextureParameterValue("MainTex", IconObj)

--                 self.DamageTypeToIndex[WeaknessType] = index
--             end
--         else
--             self.WeaknessGroupList[index]:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         end
--     end
-- end

-- function WBP_BuffBar_C:PlayWeaknessEffect(DamageType)
--     self.WeaknessBuffInnerCDFlag = self.WeaknessBuffInnerCDFlag or {}
--     self.DamageTypeToIndex = self.DamageTypeToIndex or {}
    
--     local Index = self.DamageTypeToIndex[DamageType]
--     if Index then
--         if not self.WeaknessBuffInnerCDFlag[DamageType] then
--             self:PlayAnimation(self.WeaknessAnimList[Index])

--             -- 弱点动效闪烁加一个隐藏cd（拍个cd为动效的时长），防止过高频的伤害同时触发
--             self.WeaknessBuffInnerCDFlag[DamageType] = true
--             self:AddTimer(INNER_WEAK_EFFECT_CD, function()
--                 self.WeaknessBuffInnerCDFlag[DamageType] = nil
--             end)
--         end
--     end
-- end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return WBP_BuffBar_C
