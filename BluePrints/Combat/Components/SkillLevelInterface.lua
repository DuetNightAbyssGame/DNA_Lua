
local Component = {}

-- -- lua中调用，返回table就行了
-- function Component:GetSkillLevelInfo()
-- 	local Info = {}
-- 	Info.SkillLevel = self.SkillLevel or Const.DefaultSkillLevel
-- 	Info.SkillGrade = self.SkillGrade or Const.DefaultSkillGrade
-- 	Info.SkillWeaponType = self.SkillWeaponType
-- 	return Info
-- end

-- -- 蓝图/c++中调用，返回FSkillLevelStruct
-- function Component:GetSkillLevelInfo_Lua()
-- 	local Info = FSkillLevelStruct()
-- 	Info.SkillLevel = self.SkillLevel or Const.DefaultSkillLevel
-- 	Info.SkillGrade = self.SkillGrade or Const.DefaultSkillGrade
-- 	Info.SkillWeaponType = self.SkillWeaponType
-- 	return Info
-- end

-- -- lua中调用
-- function Component:SetSkillLevelInfo(Info)
-- 	self:ClearCppSkillLevelInfo()
-- 	Info = Info or {SkillLevel = Const.DefaultSkillLevel, SkillGrade = Const.DefaultSkillGrade}
-- 	self.SkillLevel = Info.SkillLevel
-- 	self.SkillGrade = Info.SkillGrade
-- 	self.SkillWeaponType = Info.SkillWeaponType
-- end

-- -- 蓝图/c++中调用
-- function Component:SetSkillLevelInfo_Lua(Info)
-- 	-- 这里实际上会走一遍Index，不过影响不大，因为这个频率很低。
-- 	-- 反过来SetSkillLevelInfo 调用 SetSkillLevelInfo_Lua会有影响
-- 	self:SetSkillLevelInfo(Info)
-- end

return Component
