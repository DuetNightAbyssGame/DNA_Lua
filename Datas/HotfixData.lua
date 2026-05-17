
-- hotfix_data格式
-- 示例
-- local hotfix_data = 
--[[
-- 请在此处编写HotFix代码,请找组长Review
-- 1.更新导表
DataMgr.GlobalConstant.SurvivalValue.ConstantValue = 1

-- 2.更新简单Table
local Const = require("Const")
-- 增删变量,直接赋值
-- Const.XX = 1
-- 添加函数，可以直接赋值
-- Const.XXX = function( ... )
-- 	PrintTable({XXX=1})
-- end
-- 替换函数,需要调用HotFix
-- 注意,简单Table的替换函数,不能增加upvalue
HotFix(Const, "XXX",
	function(... )
	end
)

-- 3.更新UE对象
-- 增删变量,不支持
-- 只支持增加函数，替换函数和局部删除函数

-- 3.1 替换BP_PlayerCharacter_C的函数，注意这里替换的是BP_PlayerCharacter_C经过AssembleComponents之后的函数
-- 先require
local BP_PlayerCharacter_C = require("BluePrints.Char.BP_PlayerCharacter_C")
-- 替换函数，调用接口替换,不能增加upvalue,如果旧的函数里,新的upvalue可以通过self:Get_G()获取到_G表
HotFix(BP_PlayerCharacter_C, "FF5",
	function(self, ... )
		self:Get_G().PrintTable({NEWFF5 = 1})
	end
)

-- 3.2替换战斗单位GetEid函数
-- 先require
local EffectSourceInterface = require("BluePrints.Combat.Components.EffectSourceInterface")
-- 替换函数，调用接口替换,不能增加upvalue,如果旧的函数里,新的upvalue可以通过self:Get_G()获取到_G表
HotFix(EffectSourceInterface, "GetEid",
	function(self)
		local Eid = self:GetEid_Lua()
		self:Get_G().print("GetEid Log:", Eid)
		return Eid
	end
)

-- 3.3 BP_MonsterCharacter_C增加GetEid3函数，删除Monster身上的GetEid4函数
-- 先require
local BP_MonsterCharacter_C = require("BluePrints.Char.BP_MonsterCharacter_C")
-- 增加函数
HotFix(BP_MonsterCharacter_C, "GetEid3",
	function(self, ... )
		PrintTable({GetEid3 = 1})
	end
)
-- 删除函数，不能删除已有对象已经调用过的函数（已经调用过的，会缓存在对象身上
HotFix(BP_MonsterCharacter_C, "GetEid4", nil)
-- 但是可以替换成空函数
HotFix(BP_MonsterCharacter_C, "GetEid4", function( ... ) end)
]]

local hotfix_data = [[
-- 请在此处编写HotFix代码,请组长编写

]]

-- 文档：
-- https://herogames.feishu.cn/wiki/NgRDwmmIsixfnkklB9Xc54jtnjg
return { 
	index = 0,
	script = hotfix_data,
	client_version = {
		
	},
	force_update_version = "0",
	patch_version = {
		["1"] = "0"
	}
}