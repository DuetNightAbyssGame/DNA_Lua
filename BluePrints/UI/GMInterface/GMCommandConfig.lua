--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

--  GM面板配置相关
-- 	指令元素: { {"text":指令名称, "mode":指令类型, "commands":{指令元素1, 指令元素2, ...}, ...}, ...}
-- 	字段含义:
--          mode        : "button|switch|edit|text|menu,决定该指令在UI中的样式，此字段必填，其他字段可选。"
--                        " (注：edit样式按回车会执行对应callback，但移动端不能使用回车键，所以edit样式建议使用带确认按钮的menu样式，参考【设置角色位置】指令)"
--          var_name    : "本地保存的变量名称，保存在GMVariable.lua，大部分情况与switch关联，该字段缺省也会自动改变switch的状态"
--          commands    : "保存该指令下的子指令,可以嵌套",
--          callback    : "回调函数名",
--          text        : "显示文本",
--          widget_path : "子菜单路径",
--          parameters  : "参数，当mode=button|switch时会作为callback函数的输入,当mode=menu时作为LoadUI的参数"
--          close_gm    : "指令执行后关闭GM面板,默认false"
--          data_func   : "mode=menu时获取数据（读表）的方法，在GMObjectUtils.lua中实现"
--
--  新增指令的方法：参照已有指令，在GMFunctionLibrary.lua中实现callback函数。
--                 不需要输入参数的命令行指令建议直接设置 callback="ExecConsoleCommand",parameters="需要执行的命令行指令"
local CommonUtils = require "Utils.CommonUtils"
local TipsPaths = {
    Common ='/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C',
    MultiInput = '/Game/UI/UI_PC/GM/GM_Tips_MultiInput_PC.GM_Tips_MultiInput_PC_C',
} 
local GMCommandConfig = {text = "GM指令", mode = "menu", commands = {}}
GMCommandConfig.commands = {
    {text = "常用", mode = "menu", commands = {}},
    {text = "战斗", mode = "menu", commands = {}},
    {text = "UI", mode = "menu", commands = {}},
    {text = "系统", mode = "menu", commands = {}},
    {text = "任务", mode = "menu", commands = {}},
    {text = "关卡", mode = "menu", commands = {}},
    {text = "音频", mode = "menu", commands = {}},
    {text = "其他", mode = "menu", commands = {}},
    {text = "自定义", mode = "menu", commands = {}},
    {text = "ShowFlags", mode = "menu", commands = {}},
    {text = "场景", mode = "menu", commands = {}},
}
for i,v in ipairs(GMCommandConfig.commands) do
    GMCommandConfig.commands[v.text] = v
end
-- 常用
GMCommandConfig.commands["常用"].commands = {
    {text = "查看快捷键", mode = "menu",data_func = "GetHotKeyCmdObjs", widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Hotkey_PC.GM_Tips_Hotkey_PC_C',parameters = {UIConst.GMTIPSHOTKEY,"GMTipsHotkey"},},
    {text = "胶囊体绘制",mode = "switch", var_name="EnableDrawDebugSphere", callback = "SetDrawDebugSphere"},
    {text = "设置角色位置", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands={
            {text = "保存当前位置",mode = "button", callback = "SavePlayerWorldPos"},
            {text = "填入保存的位置",mode = "button", callback = "FillInPlayerWorldPos",parameters = {"设置角色位置"}},
            {text="X", mode = "edit",},
            {text="Y", mode = "edit",},
            {text="Z", mode = "edit",},
            {text="执行", mode = "button", callback = "ModifyPlayerWorldPos",},
        },
    },
    {text = "打印当前环境",mode = "menu",widget_path = TipsPaths.MultiInput,
    commands= {
        {text = "打印所有信息", mode = "button", callback ="PrintEnvironment"},
        {text = "打印玩家信息", mode = "button", callback ="PrintPlayerInfo"},
        {text = "打印关卡信息", mode = "button",  callback ="PrintLevelInfo"},
        {text = "打印动态事件信息", mode = "edit",  callback ="PrintDynamicEventInfo"},
        {text = "执行", mode = "button",callback ="PrintDynamicEventInfo"}
    }
    },
    {text = "开启动态事件并传送",mode = "menu",data_func = "GetDynCmdObjs",widget_path = TipsPaths.Common,
    commands= {
        {text = "动态事件ID", mode = "edit", callback ="ForceStartDynQuest"},
    }
    },
    {text = "动画根运动", mode = "switch", callback = "ModifyRootAnimation"},
    {text = "DrawCall显示", mode = "switch", callback = "SetDrawCallInfo"},
    {text = "免伤", mode = "switch", callback = "SetPlayerInvincible"},
    {text = "设置LogMask", mode = "menu",widget_path = TipsPaths.MultiInput,
        commands={
            {text="不屏蔽任何Log", mode = "switch", var_name="EnableOpenLogMask", callback = "SetLogMaskIsOpen", },
            {text="LogMask Name", mode = "edit", callback = "UpdateLogMaskInfo",},
            {text = "执行", mode = "button",callback ="UpdateLogMaskInfo"}
        },
    },
    {text = "打印玩家当前buff", mode = "button", callback = "PrintPlayerBuff",},
    {text = "切换角色", mode = "menu",data_func = "GetCharCmdObjs", widget_path = TipsPaths.Common,
        commands = {
            {text="角色Id", mode = "edit", callback = "ChangeRole", },
            {text = "执行", mode = "button",callback ="ChangeRole"}
        },
    },
    {text = "生成怪物", mode = "menu",data_func = "GetMonsterCmdObjs",widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Monster_PC.GM_Tips_Monster_PC_C',parameters = {UIConst.GMTIPSMONSTER,"GMTipsMonster"},},
    {text = "切换武器", mode = "menu",data_func = "GetWeaponCmdObjs", widget_path = TipsPaths.Common,
        commands = {
            {text="武器Id", mode = "edit", callback = "ChangeWeapon"},
            {text = "执行", mode = "button",callback ="ChangeWeapon"}
        }
    },
    {text = "身体勾边", mode = "switch", var_name="EnableDrawOutline", callback = "SetOutlineEnabled",},
    {text = "头发勾边", mode = "switch", var_name="EnableDrawHairOutline", callback = "SetHairOutlineEnabled",},
    {text = "材质边缘光", mode = "switch", var_name="EnableDrawMaterialCharacterRim", callback = "SetMaterialCharacterRimEnabled",},
    {text = "后处理边缘光", mode = "switch", var_name="EnableDrawPostProcessCharacterRim", callback = "SetPostProcessCharacterRimEnabled",},
    {text = "角色相机Dither", mode = "switch", var_name="EnableCharacterDither", callback = "SetCharacterDitherEnabled",},
    {text = "清除任务", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm CleanAllQuest"}},
    {text = "自动复位相机Pitch", mode = "switch",var_name = "AutoResetCameraPitch", callback = "SetAutoResetCameraPitch",},
    {text = "自动复位弹簧臂", mode = "switch",var_name = "AutoResetSpringArm",  callback = "SetAutoResetSpringArm",},
    {text = "修改触控速度", mode = "menu", widget_path = TipsPaths.MultiInput, 
        commands = {
            {text="Pitch速率", mode = "edit", callback = "ChangeTouchPitchSpeed"},
            {text="Yaw速率", mode = "edit", callback = "ChangeTouchYawSpeed"},
            {text="Pitch每帧角度上限", mode = "edit", callback = "ChangeTouchPitchLimit"},
            {text="Yaw每帧角度上限", mode = "edit", callback = "ChangeTouchYawLimit"},
            {text="执行", mode = "button", callback = "ChangeTouchConfig",},
        }
    },
    {text = "关闭大招镜头CD", mode = "switch",  var_name="DisableSkillFeatureCD", callback = "SwitchSkillFeatureCD"},
    {text = "解锁区域传送点", mode = "switch",  var_name="UnlockRegionTeleport", callback = "UnlockRegionTeleport"},
    {text = "约束相机宽高比", mode = "switch", var_name = "EnableConstrainAspect", callback = "SetConstrainAspect"},
    {text = "场景特效是否暂停", mode = "switch", var_name = "EnableFXPaused", callback = "SwitchFXPaused"},
}
-- 战斗
GMCommandConfig.commands["战斗"].commands = {
    {text = "神", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM God"}},
    {text = "幽灵", mode = "switch", var_name = "EnableGhost",callback = "SetPlayerGhost"},
    {text = "闪现", mode = "button", callback = "Teleport"},
    {text = "免伤", mode = "switch", callback = "SetPlayerInvincible"},
    {text = "免控", mode = "switch", callback = "SetPlayerSuperArmor"},
    {text = "无限子弹", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM MaxBullet"}},
    {text = "无限攻击", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM MaxAttack"}},
    {text = "无限防御", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM MaxDefence"}},
    {text = "无限能量", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM MaxSp"}},
    {text = "无限生命", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM MaxHp"}},
    {text = "重置技能CD", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM RSCd"}, close_gm = true,},

    {text = "关闭伤害/治疗", mode = "switch", callback ="ForbidDamage"},
    {text = "关闭表现", mode = "switch", callback ="ForbidPlay"},

    {text = "满触发概率", mode = "switch", callback = "MaxTriggerProbability"},
    {text = "一刀清韧", mode = "switch", callback = "ClearToughness"},
    {text = "重置怪物技能CD", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM UpdateMonCd"}},
    {text = "暴击率测试", mode = "menu",widget_path = TipsPaths.MultiInput,
        commands = {
            {text="暴击率", mode = "edit", callback = "SetCritRate", },
            {text = "执行", mode = "button",callback ="SetCritRate"}
        },
    },
    {text = "打印伤害详细信息", mode = "switch", callback = "ShowDamageDetails"},
    {text = "输出角色战斗属性信息", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM ShowRealAttr"}},
    {text = "显示所有怪物Eid", mode = "switch", callback = "ShowMonsterEids"},
    {text = "打印玩家当前buff", mode = "button", callback = "PrintPlayerBuff",},
    {text = "打印玩家属性", mode = "menu",widget_path = TipsPaths.MultiInput,
        commands = {
            {text="属性名", mode = "edit", callback = "PrintPlayerAttr", },
            {text = "执行", mode = "button",callback ="PrintPlayerAttr"}
        },
    },
    {text = "切换角色", mode = "menu",data_func = "GetCharCmdObjs", widget_path = TipsPaths.Common,
        commands = {
            {text="角色Id", mode = "edit", callback = "ChangeRole", },
            {text = "执行", mode = "button",callback ="ChangeRole"}
        },
    },
    {text = "战斗历史打印", mode = "menu", widget_path = '/Game/UI/UI_PC/GM/WBP_GM_BattleHistory.WBP_GM_BattleHistory_C',parameters = {UIConst.GMBATTLEHISTORY,"GMTipsMonster"}},
    {text = "生成怪物", mode = "menu", data_func = "GetMonsterCmdObjs", widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Monster_PC.GM_Tips_Monster_PC_C',parameters = {UIConst.GMTIPSMONSTER,"GMTipsMonster"},},
    {text = "杀所有敌方怪物", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM KM"},close_gm = true,},
    {text = "自杀", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM KM self"},close_gm = true,},
    {text = "复活", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM Recovery"},close_gm = true,},
    {text = "Billboard显隐", mode = "switch", var_name = "EnableShowBillboard", callback = "ShowOrHideBillboard",},
    {text = "副本胜利", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm ExitBattle 1"},close_gm = true,},
    {text = "副本失败", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm ExitBattle 0"},close_gm = true,},
    {text = "玩家胜利", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm PlayerEnd 1"},close_gm = true,},
    {text = "玩家失败", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm PlayerEnd 0"},close_gm = true,},
    {text = "打印当前按键技能", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm PrintSkill"}},
    {text = "怪物使用技能", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text = "怪物ID", mode = "edit",},
            {text = "技能序号", mode = "edit",},
            {text = "执行", mode = "button", callback = "ReuseSkill",},
        },
    },
    {text = "场上所有飞行魅影使用区域寻路规则", mode = "switch", var_name = "ForcePhantomUseRegionRule", callback = "SetPhantomForceUseRegionRule"},
    {text = "创建魅影",mode = "menu", data_func = "GetCPCmdObjs", widget_path = TipsPaths.Common,
        commands = {
            {text="Id 数量 行为树Id", mode = "edit", callback = "CreatePhantom", },
            {text = "执行", mode = "button",callback ="CreatePhantom"}
        }
    },
    {text = "清除魅影", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm ClearPhantoms"}},
    {text = "击杀魅影", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm KillAllPhantoms"},close_gm = true,},
    {text = "创建召唤物",mode = "menu", data_func = "GetCMSCmdObjs", widget_path = TipsPaths.Common,
        commands = {
            {text="召唤物Id 数量", mode = "edit", callback = "CreateMechanismSummon", },
            {text = "执行", mode = "button",callback ="CreateMechanismSummon"}
        }
    },
    {text = "脱离卡死", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm RL"}},
    {text = "修改玩家移动速率", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text = "速率", mode = "edit", callback = "SpeedUp"},
            {text = "执行", mode = "button", callback = "SpeedUp",},
        },
    },
    {text = "移动到防守出发点", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm StartBattle"}},

    {
        text = "网络|模拟延迟", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text="延迟", mode = "edit", callback = "NetDelay", },
            {text = "执行", mode = "button",callback ="NetDelay"}
        },
    },
    {
        text = "网络|模拟延迟波动", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text="波动", mode = "edit", callback = "NetPktLagVariance", },
            {text = "执行", mode = "button",callback ="NetPktLagVariance"}
        },
    },
    {
        text = "网络|丢包", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text="概率", mode = "edit", callback = "NetPktLoss", },
            {text = "执行", mode = "button",callback ="NetPktLoss"}
        },
    },
    {
        text = "网络|乱序发包", mode = "button", widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C', callback = "NetPktOrder"
    },
    {
        text = "网络|重复发包", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text="概率", mode = "edit", callback = "NetPktDup", },
            {text = "执行", mode = "button",callback ="NetPktDup"}
        },
    },
}
-- UI
GMCommandConfig.commands["UI"].commands = {
    {text = "切换界面模式", mode = "menu",widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C',
        commands= {
            {text="端游模式", mode = "button", callback = "SetUIShowModePC", },
            {text="手游模式", mode = "button", callback = "SetUIShowModeMobile", },
        },
    },
    {text = "自定义标题栏", mode = "switch", var_name="EnableCustomTitleBar", callback = "ToggleCustomTitleBar"},
    {text = "编辑器模式下也显示自定义标题栏", mode = "switch", var_name="ForceUseCustomTitleBar", callback = "ToggleForceCustomTitleBar"},
    {text="屏幕Message", mode = "switch", var_name = "EnableScreenMessages", callback = "SetShowScreenMessage", },
    {text = "切换系统语言", mode = "menu",widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C',
        commands= {
            {text="中文", mode = "button", callback = "ChangeSysLanguage", parameters = {CommonConst.SystemLanguages.CN}},
            {text="English", mode = "button", callback = "ChangeSysLanguage", parameters = {CommonConst.SystemLanguages.EN}},
        },
    },
    {text = "设置界面DPI缩放", mode = "menu",widget_path = TipsPaths.MultiInput,
        commands = {
            {text="Scale", mode = "edit", callback = "SetDPIScale", },
            {text = "执行", mode = "button",callback ="SetDPIScale"}
        },
    },
    {text = "隐藏特定UI", mode = "menu",widget_path = TipsPaths.MultiInput,
        commands = {
            {text="界面名称", mode = "edit", callback = "DoHideUI", },
            {text = "执行", mode = "button",callback ="DoHideUI"}
        },
    },
    {text = "显示特定UI", mode = "menu",widget_path = TipsPaths.MultiInput,
    commands = {
        {text="界面名称", mode = "edit", callback = "DoShowUI", },
        {text = "执行", mode = "button",callback ="DoShowUI"}
    },
    },
    {text = "只显示特定UI", mode = "menu",widget_path = TipsPaths.MultiInput,
    commands = {
        {text="界面名称", mode = "edit", callback = "DoShowUIOnly",close_gm = true },
        {text = "执行", mode = "button",callback ="DoShowUIOnly"}
    },
    },
    {text = "显示怪物指引点", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm smgi 1"}},
    {text = "隐藏怪物指引点", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm smgi 0"}},
    {text = "隐藏/显示小地图", mode = "button", callback = "HideOrShowMiniMap"},
    {text = "整备预览模式", mode = "button", callback = "OpenPreviewArmory"},
    {text = "成就系统", mode = "switch", var_name="EnableShowAchievement", callback = "ShowAchievement"},
    {text = "跳字显隐", mode = "switch", callback = "HideJumpWord"},
    {text = "隐藏GM入口(移动端)", mode = "button", callback = "HideGMBtnInHUD"},
    {text="关卡加载信息显隐", mode = "switch",var_name = "EnableShowLevelLoadingInfo", callback = "SetShowLevelLoadingInfo"},
}
-- 系统
GMCommandConfig.commands["系统"].commands = {
    {text = "获得所有角色", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aac"}},
    {text = "获得所有角色包含未外放的", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aacf"}},
    {text = "获得指定角色",mode = "menu",widget_path = TipsPaths.MultiInput,
        commands= {
            {text = "角色id",mode = "edit",callback ="AddOneChar"},
            {text = "等级(选填)",mode = "edit",},
            {text = "执行",mode = "button",callback ="AddOneChar"}
        },
    },
    {text = "删除指定角色",mode = "menu",widget_path = TipsPaths.MultiInput,
        commands= {
            {text = "角色id",mode = "edit",callback ="DeleteOneChar"},
            {text = "执行",mode = "button",callback ="DeleteOneChar"}
        },
    },
    {text = "设置当前角色的等级",mode = "menu",widget_path = TipsPaths.MultiInput,
        commands= {
            {text = "等级",mode = "edit",callback ="SetCharLevel"},
            {text = "执行",mode = "button",callback ="SetCharLevel"}
        },
    },
    {text = "提升角色阶级",mode = "menu",widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C',
        commands= {
            {text = "提升角色阶级1级", mode = "button", callback ="SetCurrentCharGrade", parameters = {1}},
            {text = "提升角色阶级2级", mode = "button", callback ="SetCurrentCharGrade", parameters = {2}},
            {text = "提升角色阶级3级", mode = "button", callback ="SetCurrentCharGrade", parameters = {3}},
            {text = "提升角色阶级4级", mode = "button", callback ="SetCurrentCharGrade", parameters = {4}},
            {text = "提升角色阶级5级", mode = "button", callback ="SetCurrentCharGrade", parameters = {5}},
            {text = "提升角色阶级6级", mode = "button", callback ="SetCurrentCharGrade", parameters = {6}}
        }
    },
    {text = "所有角色满级", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm macml"}},
    {text = "获得所有皮肤", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aas"}},
    {text = "获得所有配饰", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aad"}},
    {text = "获得所有武器", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aaw"}},
    {text = "获得所有武器包含未外放的", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aawf"}},
    {text = "设置当前武器阶级",mode = "menu",widget_path = TipsPaths.MultiInput,
        commands= {
            {text = "阶级",mode = "edit",callback ="scwg"},
            {text = "执行",mode = "button",callback ="scwg"}
        },
    },
    {text = "删除所有武器", mode = "button", callback ="ExecConsoleCommand",parameters = {"sgm daw"}},
    {text = "所有武器满级", mode = "button", callback ="ExecConsoleCommand",parameters = {"sgm mawml"}},
    {text = "设置所有武器的等级",mode = "menu",widget_path = TipsPaths.MultiInput,
        commands= {
            {text = "等级",mode = "edit",callback ="sawl"},
            {text = "执行",mode = "button",callback ="sawl"}
        },
    },
    {text = "设置所有武器阶级",mode = "menu",widget_path = TipsPaths.MultiInput,
        commands= {
            {text = "阶级",mode = "edit",callback ="sawg"},
            {text = "执行",mode = "button",callback ="sawg"}
        },
    },
    {text = "获得所有魔之楔", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aam"}},
    {text = "获得所有魔之楔包含未外放的", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aamf"}},
    {text = "获得大量铜币", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm ar 101 100000000"}},
    {text = "获得大量升级、突破材料", mode = "button", callback ="GetLevelUpResources", parameters = {1000}},
    {text = "获得大量魔之楔升级材料", mode = "button", callback ="GetModLevelUpResources", parameters = {10000000}},
    {text = "增加所有资源", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aar"}},
    {text = "增加某种资源", mode = "menu", data_func = "GetResourceCmdObjs", widget_path = TipsPaths.Common,
        commands= {
            {text="资源Id 数量", mode = "edit", callback = "AddResource", },
            {text = "执行", mode = "button",callback ="AddResource"}
        }
    },
    {text = "生成掉落物", mode = "menu", data_func = "GetDropCmdObjs", widget_path = TipsPaths.Common,
        commands= {
            {text="掉落物Id 数量", mode = "edit", callback = "GetDrop", },
            {text = "执行", mode = "button",callback ="GetDrop"}
        }
    },
    {text = "获得所有宠物", mode = "button", callback ="GetAllPet"},
    {text = "解锁条件", mode = "menu",widget_path = TipsPaths.MultiInput,
        commands = {
            {text="条件Id", mode = "edit", callback = "CompleteCondition", },
            {text = "执行", mode = "button",callback ="CompleteCondition"}
        }
    },
    {text = "解锁系统", mode = "menu",widget_path = TipsPaths.MultiInput,
        commands = {
            {text="系统名称", mode = "edit", callback = "MockSystemCondition", },
            {text = "执行", mode = "button",callback ="MockSystemCondition"}
        }
    },
    {text = "解锁所有系统", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm MockAllSystemCondition"}},
    {text = "解锁所有系统(服务端)", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm CompleteSystemCondition"}},
    {text = "解锁所有系统(服务端)(霸体版)", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm CompleteSystemConditionWithoutGuide"}},
    {text = "跳过所有引导", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm SuccessAllSystemGuide"}},
    {text = "解锁全部委托入口", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm UnLockAllDungeonSelectLevels"}},
    {text = "解锁全部委托副本", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm UnLockAllDungeonLevels"}},
    {text = "打印教学手册", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm PrintGuideBook"}},
    {text = "领取指定教学奖励", mode = "menu",widget_path = TipsPaths.MultiInput,
     commands = {
         {text="教学id", mode = "edit", callback = "GuideBookGetReward", },
         {text = "执行", mode = "button",callback ="GuideBookGetReward"}
     }
    },
    {text = "完成所有任务", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm saq"}},
    {text = "设置玩家等级",mode = "menu",widget_path = TipsPaths.MultiInput,
        commands= {
            {text = "等级",mode = "edit",callback ="sl"},
            {text = "执行",mode = "button",callback ="sl"}
        },
    },
    {text = "成为高玩", mode = "button", callback ="ExecConsoleCommand",parameters = {"sgm bhp"}},
    {text = "联机动作界面", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text = "打开模式(1主人/2被邀请/-1关闭)", mode = "edit", callback = "OpenOnlineActionView"},
            {text = "执行", mode = "button", callback = "OpenOnlineActionView", close_gm = true}
        }
    },
    {text = "多人挑战界面", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text = "挑战Id", mode = "edit", callback = "OpenMultiChallenge"},
            {text = "执行", mode = "button", callback = "OpenMultiChallenge", close_gm = true}
        }
    },
    {text = "解锁怪物图鉴", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm UnlockMonsterGallery"}},
    {text = "获得所有称号", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm A:GmGetAllTitle()"}},
    {text = "获得所有称号框", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm A:GmGetAllTitleFrame()"}},
    {text = "获得所有头像", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aah"}},
    {text = "获得所有头像框", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm aahf"}},
    {text = "打开送礼商店", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm GiftController:OpenGiftShopMainGM()"}},
    {text = "设置送礼额度", mode = "menu", widget_path = TipsPaths.MultiInput,
        commands = {
            {text = "额度", mode = "edit", callback = "SetGiftQuota"},
            {text = "执行", mode = "button", callback = "SetGiftQuota"}
        }
    },
    {text = "能给谁送礼（仅自己）", mode = "menu", data_func = "GetFriendCmdObjs", widget_path = TipsPaths.Common},
    {text = "刷新送礼次数", mode = "button", callback ="ExecConsoleCommand", parameters = {"sgm OnMonthlyRefreshGift"}},
    {text = "送礼商店忽略好友限制", mode = "switch", var_name = "IgnoreGiftShopFriendLimit", callback = "SwitchIgnoreGiftShopFriendLimit"},
}
-- 任务
GMCommandConfig.commands["任务"].commands = {
}
-- 关卡
GMCommandConfig.commands["关卡"].commands = {
    {text = "血清/维生值一直满", mode = "switch", callback = 'SwitchSurvivalValueChange'},
    {text = "显示玩家行动路线", mode = "switch", callback = 'RecordePlayerRoute'},
    {text = "切换到特殊任务测试环境", mode = "button", callback = "ChangeToSpecialQuestScene"},
    {text = "开始10000号特殊任务", mode = "button", callback = "StartSpecialQuest_10000"},
    {text = "查看当前关卡信息", mode = "button", callback ="ExecConsoleCommand",parameters = {"gm ScanLevel"}},
    {text = "新号开启序章西比尔BOSS战", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm StartXibiBoss"}},
    {text = "解锁梦魇残声全部难度", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm UnlockHardBoss true"}},
    {text = "切换成女主", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm ChangeToMaster"}},
    {text = "切换成军械库角色", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm ChangeBackToHero"}},
    {text = "防御核心无敌", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm DefCoreGod"}},
    {text = "动态刷怪无视点位规则", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm DMS"}},
    {text = "显示动态刷怪日志", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm DPMS"}},
    {text = "打印所有序列化数据", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm RSS"}},
    {text = "打印所有怪物缓存数据", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm RMC"}},
    {text = "打印所有静态刷新点数据", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm RSC"}},
    {text = "直接开始投票", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm StartVote"}, close_gm = true},
    {text = "副本确定生成宠物事件时直接触发宠物事件", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm SpawnPet"}, close_gm = true},
    {text = "一键打印关卡关键信息", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm PrintLevelDebugInfo"}},
    {text = "区域迷雾分块", mode = "switch",  var_name="ShowRegionmapPane", callback = "ShowRegionmapPane"},
    {text = "编辑器下使用手机参数", mode = "switch", var_name = "UseMapPhoneInPC", callback = "SetUseMapPhoneInPC"},
    {text = "一键进入好区域联机测试", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm ReadyForRegonOnline"}},
    {text = "传送到区域联机测试区域", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm SkipRegion 1 999701 1"}},
    {text = "随机角色", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm RandomChar"}},
}
-- 音频
GMCommandConfig.commands["音频"].commands = {
    {text = "ListenerDebug开关", mode = "switch", var_name = "EnableAudioListenerDebug", callback = "SetAudioListenerDebugEnabled"},
    {text = "BGM开关", mode = "switch", var_name = "EnableBGM", callback = "SetBGMEnabled"},
    {text = "BGMDebug开关", mode = "switch", var_name = "BGMEnableDebug", callback = "SetBGMDebugEnabled"},
    {text = "预配音效开关", mode = "switch", var_name = "EnableEMPreviewSound", callback = "SetEMPreviewSoundEnabled"},
    {text = "打印BGM信息", mode = "button", callback ="ExecConsoleCommand",parameters = {"GM PrintBGMInfo"}},
    {text = "打印Bus音量", mode = "button", callback ="ExecConsoleCommand",parameters = {"GM GetAllBusVolume"}},
    {text = "打印Bus暂停状态", mode = "button", callback ="ExecConsoleCommand",parameters = {"GM GetAllBusPauseState"}},
    {text = "重新加载所有Bank", mode = "button", callback ="ExecConsoleCommand",parameters = {"GM ReloadAllBank"}},
    {text = "DrawDebug开关", mode = "switch", var_name = "EnableDrawDebug", callback = "SetDrawDebugEnabled"},
    {text = "音源点Debug开关", mode = "switch", var_name = "SoundPointCompDebugEnabled", callback = "SetSoundPointCompDebugEnabled"},
    {text = "Spline水域Debug开关", mode = "switch", var_name = "SoundSplineDrawDebug", callback = "SetSoundSplineDrawDebug"},
    {text = "打印当前Cache的声音", mode = "button", callback ="ExecConsoleCommand", parameters = {"GM ShowCacheSe"}},
    {text = "打开ReverbDebug", mode = "switch", var_name = "ReverbLogicDebug", callback = "SetReverbLogicDebug"},
    {text = "当前是否插入耳机", mode = "button", callback ="ExecConsoleCommand",parameters = {"GM PrintHeadPhonePlugIn"}},
    {text = "打开LineSoundDebug", mode = "switch", var_name = "LineSoundDebug", callback = "SetLineSoundDebug"},
    {text = "打开SectorSoundDebug", mode = "switch", var_name = "SectorSoundDebug", callback = "SetSectorSoundDebug"},
    {text = "打开CircularSoundDebug", mode = "switch", var_name = "CircularSoundDebug", callback = "SetCircularSoundDebug"},
}

-- 其他
GMCommandConfig.commands["其他"].commands = {
    {text = "TakeRecorder录制设置", mode = "switch", callback = "SetTakeRecorderCapture"},
    {text = "截图", mode = "menu",widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C',
        commands= {
            {text="1280x720", mode = "button",  callback ="ExecConsoleCommand",close_gm = true, parameters = {"HighResShot 1280x720"}},
            {text="1920x1080", mode = "button", callback = "ExecConsoleCommand",close_gm = true, parameters = {"HighResShot 1920x1080"}},
            {text="2560x1440", mode = "button",  callback = "ExecConsoleCommand",close_gm = true, parameters = {"HighResShot 2560x1440"}},
            {text="3840x2160", mode = "button",  callback = "ExecConsoleCommand",close_gm = true, parameters = {"HighResShot 3840x2160"}},
        },
    },
    {text = "打印内存报告", mode = "button", callback ="ExecConsoleCommand",parameters = {"memreport -full"}},
    {text = "禁用PakCache", mode = "button", callback ="ExecConsoleCommand",parameters = {"pakcache.enable 0"}},
    {text="TAA", mode = "menu",widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C',
        commands={
            {text="低", mode = "button",callback = "ChangeTAAQuality", parameters={99}},
            {text="中", mode = "button",callback = "ChangeTAAQuality", parameters={140}},
            {text="高", mode = "button",callback = "ChangeTAAQuality", parameters={160}},
        }
    },
    {text = "DLSS", mode = "menu", widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C',
        commands={
            {text="关闭", mode = "button",callback = "ChangeDLSSQuality", parameters={0}},
            {text="自动", mode = "button",callback = "ChangeDLSSQuality", parameters={1}},
            {text="质量", mode = "button",callback = "ChangeDLSSQuality", parameters={2}},
            {text="平衡", mode = "button",callback = "ChangeDLSSQuality", parameters={3}},
            {text="性能", mode = "button",callback = "ChangeDLSSQuality", parameters={4}},
            {text="超级性能", mode = "button",callback = "ChangeDLSSQuality", parameters={5}},
            {text="DLAA", mode = "button",callback = "ChangeDLSSQuality", parameters={6}},
        }
    },
    {text = "DLSS帧生成", mode = "menu",widget_path = '/Game/UI/UI_PC/GM/GM_Tips_Common_PC.GM_Tips_Common_PC_C',
        commands= {
            {text="关闭", mode = "button", callback = "ChangeDLSSFGQuality", parameters = {0}},
            {text="自动", mode = "button", callback = "ChangeDLSSFGQuality", parameters = {1}},
            {text="2X", mode = "button",  callback = "ChangeDLSSFGQuality", parameters = {2}},
            {text="3X", mode = "button",  callback = "ChangeDLSSFGQuality", parameters = {3}},
            {text="4X", mode = "button",  callback = "ChangeDLSSFGQuality", parameters = {4}},
        },
    },
    {text="显示内存信息", mode = "button", callback = "SetShowMemoryInfo"},
    {text = "SimpleRVT", mode = "switch", callback = "SwitchSimpleRuntimeTexture"},
    {text = "手机端软件剔除", mode = "switch", callback = "SwitchMobileSoftwareOcclusion"},
    {text = "软件剔除用于Mask", mode = "switch", callback = "SwitchAllowSoftwareOcclusionForMask"},
    {text = "软件剔除可见性调试视图", mode = "switch", callback = "SwitchSoftwareOcclusionVisualizeBuffer"},
    -- {text = "像素雾", mode = "switch", var_name = "EnableMobilePostProcessFog", callback = "SwitchMobilePostProcessFog"},
    {text = "硬件剔除", mode = "switch", var_name = "EnableHardwareOcclusion", callback = "SwitchHardwareOcclusion"},
    {text = "HZBOcclusion", mode = "switch", var_name = "EnableHZBOcclusion", callback = "SwitchHZBOcclusion"},
    {text = "stat unit", mode = "button", callback ="ExecConsoleCommand", parameters = {"stat unit"}},
    {text = "stat memory", mode = "button", callback ="ExecConsoleCommand", parameters = {"stat memory"}},
    {text = "stat levels", mode = "button", callback ="ExecConsoleCommand", parameters = {"stat levels"}},
    {text = "StatLevelsColumnWidth", mode = "button", callback ="ExecConsoleCommand", parameters = {"stats.StatLevelsColumnWidth 200"}},
    {text = "stat rhi", mode = "button", callback ="ExecConsoleCommand", parameters = {"stat rhi"}},
    {text = "stat SceneRendering", mode = "button", callback ="ExecConsoleCommand", parameters = {"stat SceneRendering"}},
    {text = "stat gpu", mode = "button", callback ="ExecConsoleCommand", parameters = {"stat gpu"}},
    {text = "包体上传PSO", mode = "button", callback ="ExecConsoleCommand", parameters = {"r.ShaderPipelineCache.Upload"}},
    {text = "DynamicShadows",mode = "switch", var_name="EnableDynamicShadows", callback = "ShowFlags", parameters = {"DynamicShadows"}},
    {text = "GlobalIllumination",mode = "switch", var_name="EnableGlobalIllumination", callback = "ShowFlags", parameters = {"GlobalIllumination"}},
    {text = "InstancedFoliage",mode = "switch", var_name="EnableInstancedFoliage", callback = "ShowFlags", parameters = {"InstancedFoliage"}},
    {text = "InstancedGrass",mode = "switch", var_name="EnableInstancedGrass", callback = "ShowFlags", parameters = {"InstancedGrass"}},
    {text = "PointLights",mode = "switch", var_name="EnablePointLights", callback = "ShowFlags", parameters = {"PointLights"}},
    {text = "ReflectionEnvironment",mode = "switch", var_name="EnableReflectionEnvironment", callback = "ShowFlags", parameters = {"ReflectionEnvironment"}},
    {text = "SkyLighting",mode = "switch", var_name="EnableSkyLighting", callback = "ShowFlags", parameters = {"SkyLighting"}},
    {text = "Materials",mode = "switch", var_name="EnableMaterials", callback = "ShowFlags", parameters = {"Materials"}},
    {text = "DirectLighting",mode = "switch", var_name="EnableDirectLighting", callback = "ShowFlags", parameters = {"DirectLighting"}},
    {text = "PostProcessing",mode = "switch", var_name="EnablePostProcessing", callback = "ShowFlags", parameters = {"PostProcessing"}},
    {text = "Bloom",mode = "switch", var_name="EnableBloom", callback = "ShowFlags", parameters = {"Bloom"}},
    {text = "Rendering",mode = "switch", var_name="EnableRendering", callback = "ShowFlags", parameters = {"Rendering"}},
    {text = "Translucency",mode = "switch", var_name="EnableTranslucency", callback = "ShowFlags", parameters = {"Translucency"}},
    {text = "设置白天", mode = "button", callback ="SetTimeOfDay",parameters = {"day"}},
    {text = "设置晚上", mode = "button", callback ="SetTimeOfDay",parameters = {"night"}},
    {text = "显示可拾取掉落物", mode = "switch", var_name = "PrintPickupTriggerTick", callback ="PrintPickupTriggerTick"},
    {text = "开关GPDebug", mode = "button", callback ="ExecConsoleCommand", parameters = {"EnableGDT"}},
    {text = "GPDebug.AI", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm GDTAI"}},
    {text = "GPDebug.EMBT", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm GDTEMBT"}},
    {text = "GPDebug.AnimCache", mode = "button", callback ="ExecConsoleCommand", parameters = {"gm GDTAnimCache"}},
}
-- 自定义
GMCommandConfig.commands["自定义"].commands = {}
-- ShowFlags
GMCommandConfig.commands["ShowFlags"].commands = {}
--场景
GMCommandConfig.commands["场景"].commands = {
    {text = "根据拼接关进入副本", mode = "menu",widget_path = TipsPaths.MultiInput,
    commands={
        {text="拼接关名称", mode = "edit",callback ="FindDungeonForArtMap",},
        {text = "进入副本", mode = "button",callback ="FindDungeonForArtMap"}
    },
},
}

-- 如果是GM整合指令
local Keys = CommonUtils.Keys(DataMgr.GMIntegration)
table.sort(Keys)
for _, FunctionName in pairs(Keys) do
    local GMIntegrationData = DataMgr.GMIntegration[FunctionName]
    local GMTab = GMIntegrationData.GMTab or "自定义"
    if not GMCommandConfig.commands[GMTab] then
        GMTab = "自定义"
    end
    table.insert(GMCommandConfig.commands[GMTab].commands, {
        text = GMIntegrationData.GMDisplayName or FunctionName,
        mode = "button",
        callback ="ExecConsoleCommand",
        parameters = {"gm " .. FunctionName},
    })
end

for i,v in ipairs(GMCommandConfig.commands) do
    GMCommandConfig.commands[v.text] = nil
end

return GMCommandConfig
