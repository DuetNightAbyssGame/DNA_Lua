-- Battle Event Name 触发顺序从上至下
local BattleEventName = {
	"InitDamage", -- 伤害初始化
	"InitDamaged", -- 受伤害初始化
	"CalculateDamage", -- 计算伤害
	"Damage", -- 受到伤害
	"Damaged", -- 受到伤害后
	"BreakCountDown", -- 固定次数受击

	"InitHeal", -- 治疗初始化
	"InitHealed", -- 受治疗初始化
	"CalculateHeal", -- 计算治疗
	"Heal", -- 受到治疗
	"Healed", -- 受到治疗后
	"EnterNode", -- 技能节点进入后
	"LeaveNode", -- 技能节点离开后

	"BeforeSkill", -- 技能前
	"AfterSkill", -- 技能（结束）后

	"BeforeSkillEffect", -- 技能效果前
	"AfterSkillEffect", -- 技能效果后

	"OnSelfDying", -- 角色濒死
	"OnBeforeDead",		--角色死亡前
	"OnAfterDead", 		-- 角色死亡后
	"OnPhantomDead",    -- 魅影死亡
	"OnPhantomRecover",  -- 魅影复活


	"OnMySummonDying",--召唤物死亡
	"OnRecover", -- 角色复活时
	
	"BeforeSpChanged",--成就能量变化前
	"SpChanged", -- 能量变化后
	"SecondSpChanged", -- 第二能量变化后
	"ComboCountChanged", -- 连击数变化后
	"AttackSpeedNormalChanged", -- 攻击速度变化后（只受buff影响）
	"SkillSpeedChanged", -- 技能速度变化后（只受buff影响）

	"OnCreateSummon", -- 召唤召唤物后

	"OnWeaponChanged", -- 武器变换后

	"AfterCutToughness", -- 削韧后
	"AfterBeCutToughness", -- 削韧后
	"OnToughnessToZero", -- 削韧到0
	
	"OnGetBullet",--拾取弹药后
	"OnConsumeBullet",--备弹消耗
	"OnMagazineBulletCleared", --弹夹内子弹数量变为0
	"OnGetDrop", --拾取掉落物后

	"EnterSlide", -- 进入滑铲时
	"QuitSlide", -- 退出滑铲时
	
	"EnterDodging", -- 闪避时

	"EnterLanding", -- 落地时

	"EnterBulletJump", -- 进入子弹跳时
	"QuitBulletJump", -- 退出子弹跳时

	"AddEnergyShield",	--增加护盾
	"AddedEnergyShield",--被增加护盾,
	
	"OnDisarm", --触发缴械
	
	"BeforeSupportSkill", --支援角色使用技能之前
	"AfterSupportSkill", --支援角色使用技能之后


	------------队友事件--------------
	"OnTeammateCanRecovery", -- 角色可以复活


	------------处刑相关事件--------------
	"RecoverMaxTNEvent",
	"EnterDefeatedEvent",
	"ExecuteCondemnedEvent",
	"BeCondemned",

	------------Buff---------------------
	"OnAddBuffToOther", -- 添加buff给其他角色
	"OnBuffRemovedFromTarget", -- buff从目标身上移除


	------------肉鸽--------------------
	"RougeParamSave",--肉鸽保存蓝图数据
	"RougeParamRecover",--肉鸽恢复蓝图数据
	"RougeEnterNewRoom", --肉鸽进入新房间
}

-- 只发送给队友的事件
BattleEventName.TeammateEvent = {
	OnTeammateCanRecovery = true
}

for i = 1, #BattleEventName do
	BattleEventName[BattleEventName[i]] = BattleEventName[i]
end

return BattleEventName
