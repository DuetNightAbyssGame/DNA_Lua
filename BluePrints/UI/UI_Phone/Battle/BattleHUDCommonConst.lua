----- @module BattleHUDCommonConst
----- @author HY
----- @date 2025/11/4

local BattleHUDCommonConst = {}

--- @table DesignBaseConfigInHUD 布局自定义基础配置数据(主要是技能面板)
--- @field WidgetClass string 控件类路径
--- @field WidgetName string 控件名称
--- @field TextMapContent string 文本映射表内容（用于布局设置界面显示）
--- @field InnerActiveSlateName string|table 控件内部可交互节点名称（拖拽时候会禁用掉，方式输入冲突）
--- @field MaskNodeName string|table 遮罩节点名称（用于显示边界）
--- @field LocalOffset FVector2D 本地偏移量（暂时没用到）
--- @field bHasExtraLimitArea boolean 是否有额外限制区域（用于移动按钮时的额外限制）
--- @field bNeedAddWorldPos boolean 存储到服务端时候是否需要添加世界位置
--- @field RelativeNodes table 相关节点名称列表（选中时候会额外显示出这里面的节点，取消选中的时候隐藏）
BattleHUDCommonConst.DesignBaseConfigInHUD = {
    SkillPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_CharSkill_M.WBP_Battle_CharSkill_M_C'",
        WidgetName = "Skill",
        TextMapContent = "UI_CustomLayout_WidgetName30",
        InnerActiveSlateName = {{"CharSkill_1", "Button_Area"}, {"CharSkill_2", "Button_Area"}},
        MaskNodeName = "Image_SkillPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    AtkMeleePos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AtkMelee_M.WBP_Battle_AtkMelee_M_C'",
        WidgetName = "AtkMelee",
        TextMapContent = "UI_CustomLayout_WidgetName27",
        InnerActiveSlateName = "Button_Area",
        MaskNodeName = "Image_AtkMeleePos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    AtkRangedPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AtkRanged_M.WBP_Battle_AtkRanged_M_C'",
        WidgetName = "AtkRanged",
        TextMapContent = "UI_CustomLayout_WidgetName24",
        InnerActiveSlateName = "Image_Main",
        MaskNodeName = "Image_AtkRangedPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    AtkRangedPosLeft = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AtkRangedLeft_M.WBP_Battle_AtkRangedLeft_M_C'",
        WidgetName = "AtkRangedLeft",
        TextMapContent = "UI_CustomLayout_WidgetName19",
        InnerActiveSlateName = {"Btn_AtkRange", "Image_Main"},
        MaskNodeName = "Image_AtkRangedPosLeft",
        -- LocalOffset = FVector2D(0, 0),   
    },
    JumpPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Jump_M.WBP_Battle_Jump_M_C'",
        WidgetName = "Jump",
        TextMapContent = "UI_CustomLayout_WidgetName31",
        InnerActiveSlateName = "Image_Main",
        MaskNodeName = "Image_JumpPos",
        -- LocalOffset = FVector2D(0, 0),
    },
    BulletJumpPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletJump_M.WBP_Battle_BulletJump_M_C'",
        WidgetName = "BulletJump01",
        TextMapContent = "UI_CustomLayout_WidgetName23",
        InnerActiveSlateName = "Btn_BulletJump",
        MaskNodeName = "Image_BulletJumpPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    BulletJumpPosLeft = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletJump_M.WBP_Battle_BulletJump_M_C'",
        WidgetName = "BulletJump02",
        TextMapContent = "UI_CustomLayout_WidgetName18",
        InnerActiveSlateName = "Btn_BulletJump",
        MaskNodeName = "Image_BulletJumpPosLeft",
        -- LocalOffset = FVector2D(0, 0),   
    },
    DodgePos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Dodge_M.WBP_Battle_Dodge_M_C'",
        WidgetName = "Dodge",
        TextMapContent = "UI_CustomLayout_WidgetName26",
        InnerActiveSlateName = {"Button_Area", "Button_Area_1"},
        MaskNodeName = {"Image_DodgeType01", "Image_Dodgetype02"},
        -- LocalOffset = FVector2D(0, 0),   
    },
    BulletPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Bullet_M.WBP_Battle_Bullet_M_C'",
        WidgetName = "Bullet",
        TextMapContent = "UI_CustomLayout_WidgetName25",
        InnerActiveSlateName = "Button_Area",
        MaskNodeName = "Image_BulletPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    BattleMenuPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_BattleMenuBtn_M.WBP_BattleMenuBtn_M_C'",
        WidgetName = "Battle_Menu",
        TextMapContent = "UI_CustomLayout_WidgetName22",
        InnerActiveSlateName = {"Image_Menu", "Image_Close"},
        MaskNodeName = "Image_BattleMenuPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    SupportSkillPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_SupportSkill_M.WBP_Battle_SupportSkill_M_C'",
        WidgetName = "SupportSkill",
        TextMapContent = "UI_CustomLayout_WidgetName28",
        InnerActiveSlateName = "Button_Area",
        MaskNodeName = "Image_SupportSkillPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    ExecutePos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Execute_M.WBP_Battle_Execute_M_C'",
        WidgetName = "Execute",
        TextMapContent = "UI_CustomLayout_WidgetName21",
        InnerActiveSlateName = "Btn_Execute",
        MaskNodeName = "Image_ExecutePos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    AimLockedPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AimLocked_M.WBP_Battle_AimLocked_M_C'",
        WidgetName = "AimLocked",
        TextMapContent = "UI_CustomLayout_WidgetName29",
        InnerActiveSlateName = "Button_Area",
        MaskNodeName = "Image_AimLockedPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    SquatPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Squat_M.WBP_Battle_Squat_M_C'",
        WidgetName = "Squat",
        TextMapContent = "UI_CustomLayout_WidgetName17",
        InnerActiveSlateName = "Button_Area",
        MaskNodeName = "Image_SquatPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    WalkPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Walk_M.WBP_Battle_Walk_M_C'",
        WidgetName = "Walk",
        TextMapContent = "UI_CustomLayout_WidgetName16",
        InnerActiveSlateName = "Button_Area",
        MaskNodeName = "Image_WalkPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    BattleCancelLeftPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletCancel_M.WBP_Battle_BulletCancel_M_C'",
        WidgetName = "CancelLeft",
        TextMapContent = "UI_CustomLayout_WidgetName14",
        InnerActiveSlateName = "Btn_Cancel",
        MaskNodeName = "Image_CancelPosLeft",
        -- LocalOffset = FVector2D(0, 0),   
    },
    BattleCancelRightPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletCancel_M.WBP_Battle_BulletCancel_M_C'",
        WidgetName = "CancelRight",
        TextMapContent = "UI_CustomLayout_WidgetName15",
        InnerActiveSlateName = "Btn_Cancel",
        MaskNodeName = "Image_CancelPosRight",
        -- LocalOffset = FVector2D(0, 0),   
    },
    SlideTacklePos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_SlideTackle_M.WBP_Battle_SlideTackle_M_C'",
        WidgetName = "SlideTackle",
        TextMapContent = "UI_CustomLayout_WidgetName32",
        InnerActiveSlateName = {"Image_Hotspot", "Button_Area"},
        MaskNodeName = "Image_SlideTackle",
        bIsNeedManualAdd = true,
        -- LocalOffset = FVector2D(0, 0),   
    },
    SlidingSlashPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_SlidingSlash_M.WBP_Battle_SlidingSlash_M_C'",
        WidgetName = "SlidingSlash",
        TextMapContent = "UI_CustomLayout_WidgetName33",
        InnerActiveSlateName = {"Image_Hotspot", "Button_Area"},
        MaskNodeName = "Image_SlidingSlash",
        bIsNeedManualAdd = true,
        -- LocalOffset = FVector2D(0, 0),   
    },
    MapPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomMap_M.WBP_SettingCustomMap_M_C'",
        WidgetName = "Map",
        TextMapContent = "UI_CustomLayout_WidgetName03",
        InnerActiveSlateName = "BtnMap",
        MaskNodeName = "Img_MapPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    TaskPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomTask_M.WBP_SettingCustomTask_M_C'",
        WidgetName = "Task",
        TextMapContent = "UI_CustomLayout_WidgetName05",
        InnerActiveSlateName = "BtnChTask",
        MaskNodeName = "Img_TaskPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    DropPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomDrop_M.WBP_SettingCustomDrop_M_C'",
        WidgetName = "Drop",
        TextMapContent = "UI_CustomLayout_WidgetName06",
        InnerActiveSlateName = "BtnChDrop",
        MaskNodeName = "Img_DropPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    SystemPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomSystem_M.WBP_SettingCustomSystem_M'",
        WidgetName = "System",
        TextMapContent = "UI_CustomLayout_WidgetName08",
        InnerActiveSlateName = "BtnSystem",
        MaskNodeName = "Img_SystemPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    TeamPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomTeam_M.WBP_SettingCustomTeam_M_C'",
        WidgetName = "Team",
        TextMapContent = "UI_CustomLayout_WidgetName09",
        InnerActiveSlateName = "BtnChTeam",
        MaskNodeName = "Img_TeamPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    SpSkillPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomSpSkill_M.WBP_SettingCustomSpSkill_M_C'",
        WidgetName = "SpSkill",
        TextMapContent = "UI_CustomLayout_WidgetName10",
        InnerActiveSlateName = "BtnSpSkill",
        MaskNodeName = "Img_SpSkillPos",
        -- LocalOffset = FVector2D(0, 0),   
        bNeedAddWorldPos = true,
    },
    BloodPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomBlood_M.WBP_SettingCustomBlood_M_C'",
        WidgetName = "Blood",
        TextMapContent = "UI_CustomLayout_WidgetName07",
        InnerActiveSlateName = "BtnBlood",
        MaskNodeName = "Img_BloodPos",
        -- LocalOffset = FVector2D(0, 0),   
    },
    MoveAutoPos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomMoveAuto_M.WBP_SettingCustomMoveAuto_M_C'",
        WidgetName = "MoveAuto",
        TextMapContent = "UI_CustomLayout_WidgetName13",
        InnerActiveSlateName = "BtnMoveAuto",
        MaskNodeName = "Image_MoveAutoPos",
        bNeedAddWorldPos = true,
        -- LocalOffset = FVector2D(0, 0),   
    },
    MovePos = {
        WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomMove_M.WBP_SettingCustomMove_M_C'",
        WidgetName = "Move",
        TextMapContent = "UI_CustomLayout_WidgetName20",
        InnerActiveSlateName = "Btn_Move",
        MaskNodeName = "Image_MovePos",
        -- LocalOffset = FVector2D(0, 0),   
        bHasExtraLimitArea = true,
        bNeedAddWorldPos = true,
        RelativeNodeName = "MoveRangePos"
    },
}

-- @table ExtraNodeConfigInHUD 布局自定义额外节点配置（主要是一些技能面板以外的节点，比如地图、任务等）
BattleHUDCommonConst.ExtraNodeConfigInHUD = {
    Group_Map = {
        SettingNodeName = "MapPos",
        DefaultLayoutIndex = 1,    --- 默认位置索引（如果有多个默认位置的话，按照这个索引来，1代表第一个，以此类推）
    },
    Group_Task = {
        SettingNodeName = "TaskPos",
        DefaultLayoutIndex = 2,
    },
    Group_Drop = {
        SettingNodeName = "DropPos",
        DefaultLayoutIndex = 3,
    },
    Pos_Entry = {
        SettingNodeName = "SystemPos",
        bUseParentSlot = true,
        DefaultLayoutIndex = 4,
    },
    Team = {
        SettingNodeName = "TeamPos",
        DefaultLayoutIndex = 5,
    },
    HUD_Bar = {
        SettingNodeName = "BloodPos",
        DefaultLayoutIndex = 6,
    },
}

-- @table AllHasRelativeNodeWidgetList 所有有相关节点名称列表（用于选中某个节点时候额外显示的节点，取消选中时候隐藏）
BattleHUDCommonConst.AllHasRelativeNodeWidgetList = {
    "MovePos"
}

-- @table ManualAdditionConfigInHUD 布局设置中需要手动添加进HUD的配置（主要是非常规显示的节点，比如滑铲、滑斩等，这些控件不受默认的布局设置控制，需要额外的地方添加进来）
BattleHUDCommonConst.ManualAdditionConfigInHUD = {
    SlideTackle = {
        NodeIdx = 1,
        LayoutInHUDPosName = "SlideTacklePos",
        EffectWidgetName = "Jump",
        ShowText = GText("UI_CustomLayout_WidgetName32"),
    },
    SlidingSlash = {
        NodeIdx = 2,
        LayoutInHUDPosName = "SlidingSlashPos",
        EffectWidgetName = "Jump",
        ShowText = GText("UI_CustomLayout_WidgetName33"),
    },
}

-- @table LayOutSettingConfig 布局设置的相关配置
BattleHUDCommonConst.LayOutSettingConfig = {
    bIsSupportLongPress = false,                    --- 是否支持长按移动
    MoveOffsetStep = 1,                             --- 每次移动的偏移量
    DefaultScaleValue = 1.0,                        --- 默认缩放值
    MaxScaleValue = 2,                              --- 最大缩放值
    MinScaleValue = 0.2,                            --- 最小缩放值
    EdgeLimitThreshold = 0,                         --- 边缘限制阈值
    MaxOperationHistoryCount = 1,                   --- 最大操作历史记录数
}

-- @table VisualJoystickConfig 摇杆视觉相关配置
BattleHUDCommonConst.VisualJoystickConfig = {
    AreaRangeYPercentMin = 0.5,                     --- 操作区域Y轴最小百分比
    AreaRangeYPercentMax = 0.8,                     --- 操作区域Y轴最大百分比
    DefaultAreaRangeXPercent = 0.5,                 --- 默认可操作区域X轴百分比
    DefaultAreaRangeYPercent = 0.6,                 --- 默认可操作区域Y轴百分比
    -- CurAreaRangeXPercent = 0.5,                     --- 当前可操作区域X轴百分比
    -- CurAreaRangeYPercent = 0.5,                     --- 当前可操作区域Y轴百分比
}

-- 手动编辑布局的时候每次移动的偏移量
BattleHUDCommonConst.MoveOffsetStep = 5

-- @number SettingPageNpcId 设置页面的NpcId（设置白）
BattleHUDCommonConst.SettingPageNpcId = 900003

return BattleHUDCommonConst
