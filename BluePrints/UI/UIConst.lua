
-- 存放一些关于UI的常量
local UIConst = {}

-- 界面的ZOrder，只能整数！！！！！！
UIConst.ZORDER_UNDER_ALL = -127 			    -- 最底层 Warning:可以往后添加自定义的层级
UIConst.ZORDER_FOR_DAMAGETIPS = -9              -- 各种指示器（伤害指示器）
UIConst.ZORDER_FOR_MORIBUND = -8 				-- 血量遮罩（没血了的时候的提示）
UIConst.ZORDER_FOR_INDICATORS = -7              -- 各种指引点
UIConst.ZORDER_FOT_TAKE_AIM_INDICATOR = -6      -- 瞄准指示
UIConst.ZORDER_FOR_MAINPAGE = -5 				-- 游戏主界面
UIConst.ZORDER_FOR_JOYSTICK = -4 				-- 摇杆、技能面板
UIConst.ZORDER_FOR_DESKTOP = -3 			    -- 主界面上的一些UI常驻
UIConst.ZORDER_FOR_DESKTOP_TEMP = -2 			-- 主界面上的一些UI临时
UIConst.ZORDER_FOR_LONG_DIS = -1 				-- 切场景，要盖住主界面上的按钮，但是不能挡住popup
UIConst.ZORDER_FOR_ZERO = 0 					-- 此层级的结构会与其他界面发生遮挡（UE之中默认的层级）
UIConst.ZORDER_FOR_NORMAL = 1 					-- 通常情况下为了提升一定的层级
UIConst.ZORDER_FOR_SECONDARY_POPUP = 5 			-- 二级界面通常的层级
UIConst.ZORDER_SCREEN_EFFECT = 8 			    -- 屏幕特效动画
UIConst.ZORDER_FOR_COMMON_TIP = 10          	-- 弹条、弹幕
UIConst.ZORDER_FOR_TOP_TIP = 11          	    -- 比弹条啥的高一级
UIConst.ZORDER_FOR_CHANGE_SCENE = 20          	-- 切场景相关
UIConst.ZORDER_FOR_GM_PANEL = 50          	    -- GM面板
UIConst.ZORDER_ABOVE_SystemGuide = 104 	        -- 高于系统引导
UIConst.ZORDER_FOR_NET_DISCONNECT = 110 	    -- 游戏内界面的最高层级（目前用于断线重连，如果有界面要超过这个值需要和交互策划确认一下）
UIConst.ZORDER_ABOVE_ALL = 127 	            	-- 在最顶层


-- UI蓝图的PackagePath

--1.桌面常驻界面
UIConst.WORLDTASKMAIN = "/Game/UI/UI_PC/MainInterfaceUI/WBP_WorldTask.WBP_WorldTask_C"                                  -- 任务面板
UIConst.BATTLEWEAPONHINT = "/Game/UI/UI_Phone/Battle/Battle_Weapon_Hint.Battle_Weapon_Hint_C"                           -- 战斗连击和弹药数
UIConst.SCENESTARTUI = "/Game/UI/WBP/Common/Class/Scene_StartUI.Scene_StartUI_C"                                        -- 初始化界面
UIConst.SCENESTARTUINEW = "/Game/UI/WBP/Common/Class/WBP_SceneStart.WBP_SceneStart_C"                                   -- 新版初始化界面

--2.辅助功能界面
-- UIConst.DAMAGEINDICATOR = "/Game/UI/UI_PC/Battle/Battle_Damage_Indicator_PC.Battle_Damage_Indicator_PC_C"            -- 旧版伤害指示器
UIConst.PICKUPITEMTIPS = "/Game/UI/UI_PC/PickUp/WBP_ButtomPickUpTips.WBP_ButtomPickUpTips_C"                            -- 拾取物品弹条
UIConst.PICKUPITEMPANEL = "/Game/BluePrints/UI/WBP_PickUpItemsPanel.WBP_PickUpItemsPanel_C"                             -- 拾取物品list选择
UIConst.TASKINDICATORUIBASE = "/Game/UI/UI_PC/Guide/Guide_Point/Guide_Icon_Task.Guide_Icon_Task"
UIConst.TASKINDICATORUI = {                                                                                             --任务指引
    Task = "/Game/UI/UI_PC/Guide/Guide_Point/Guide_Icon_Task_Mission.Guide_Icon_Task_Mission",
    Dynamic = "/Game/UI/UI_PC/Guide/Guide_Point/Guide_Icon_Task_Dynamic.Guide_Icon_Task_Dynamic",
    UnSpecialSide = "/Game/UI/UI_PC/Guide/Guide_Point/Guide_Icon_Task_UnSpecialSide.Guide_Icon_Task_UnSpecialSide"
}-- 任务指引
                      
UIConst.GUIDETEXTFLOAT = '/Game/UI/UI_PC/Guide/Guide_TextFloat_PC.Guide_TextFloat_PC_C'                                 -- 任务辅助文字提示
UIConst.GUIDEMAIN = "/Game/UI/UI_PC/Guide/Guide_Image/Guide_Image_Main.Guide_Image_Main_C"
UIConst.MONSTEREXPTIPS = "/Game/UI/UI_PC/Battle/JumpWord_Other.JumpWord_Other"                                    -- 怪物经验跳字
UIConst.GRENADESTIPS = "/Game/UI/WBP/Battle/Widget/WBP_Battle_Grenades.WBP_Battle_Grenades_C"                                  -- 手雷提示
UIConst.ACHIEVEMENTPANEL = "/Game/UI/UI_PC/Achievement/Achievement_PCNew.Achievement_PCNew_C"                           -- 成就相关

UIConst.BOSSBLOOD="/Game/UI/UI_PC/Battle/Battle_Blood_Boss_Part_PC_New.Battle_Blood_Boss_Part_PC_New_C"                 -- Boos血条护盾显示

UIConst.CAPTUREINTERACTIVE = "/Game/UI/UI_PC/Prologue/Prologue_Capture_PC.Prologue_Capture_PC"                          -- 捕获本特殊交互
UIConst.ENERGYSUPPLYBUFF = "/Game/UI/UI_PC/Guide/Guide_TextFloat02_PC.Guide_TextFloat02_PC_C"   
UIConst.WEAPONTIPS = "/Game/UI/UI_PC/MainInterfaceUI/WBP_Special_FullScreen.WBP_Special_FullScreen_C"                   -- 获取武器tips

UIConst.WARNINGHINT = "/Game/UI/UI_PC/Guide/Guide_Text_Warning_PC.Guide_Text_Warning_PC_C"
UIConst.DESTROYALARM = "/Game/UI/UI_PC/Battle/Destroy/Battle_Destroy_Alarm_PC.Battle_Destroy_Alarm_PC_C"
UIConst.WARNINGTOAST = "/Game/UI/UI_PC/Common/Common_Toast/Common_Toast_Warning_PC.Common_Toast_Warning_PC_C"


UIConst.NEWMAPLEVELSELECT = "/Game/UI/UI_PC/LevelMap/World/LevelMap_World_PC.LevelMap_World_PC_C"                       -- 地图选择
UIConst.MAPLEVELWORLDTIMELINE = "/Game/UI/UI_PC/LevelMap/World/LevelMap_World_TimeLine_PC.LevelMap_World_TimeLine_PC_C" --
UIConst.PRELOGINCGANIM = "/Game/UI/UI_PC/Video/WBP_CGMovie.WBP_CGMovie_C"                                               -- 开场CG相关
-- UIConst.LOGINMAINPAGE = "/Game/UI/LoadingTest/Spine_test/WBP_GameStartLoginUI.WBP_GameStartLoginUI_C"                -- 登录
UIConst.LOGINMAINPAGE = "/Game/UI/UI_PC/Login/Login_Main_PC.Login_Main_PC_C" 
UIConst.SERVERSELEC = "/Game/UI/UI_PC/Login/WBP_ServerSelect.WBP_ServerSelect_C"                                        -- 服务器选择
UIConst.ARMORYWEAPONCARD = '/Game/UI/WBP/Armory/PC/WBP_Armory_WeaponCardLevel_P.WBP_Armory_WeaponCardLevel_P_C'         -- 军械库3.0 武器同卡
UIConst.CHARRECORD_PC = '/Game/UI/WBP/Armory/PC/WBP_Armory_RecordSub_P.WBP_Armory_RecordSub_P'                           -- 军械库3.0 PC 角色档案详情
UIConst.CHARRECORD_MOBILE = '/Game/UI/WBP/Armory/Mobile/WBP_Armory_RecordSub_M.WBP_Armory_RecordSub_M'                   -- 军械库3.0 Mobile 角色档案详情
UIConst.CARDLEVEL_PC = '/Game/UI/WBP/Armory/PC/WBP_Armory_CardLevel_P.WBP_Armory_CardLevel_P'                           -- 军械库3.0 PC 同卡界面
UIConst.CARDLEVEL_MOBILE = '/Game/UI/WBP/Armory/Mobile/WBP_Armory_CardLevel_M.WBP_Armory_CardLevel_M'                   -- 军械库3.0 Mobile 同卡界面
UIConst.BATTLEMENUWEAPONCONFIG = '/Game/UI/WBP/Armory/Widget/BattleMenu/WBP_Armory_BattleMenu_Config.WBP_Armory_BattleMenu_Config'-- 军械库3.0 魅影装备页
UIConst.CHARPIECTURE = '/Game/UI/WBP/Archive/Widget/WBP_Archive_CharPicture.WBP_Archive_CharPicture'                     -- 军械库3.0 角色立绘


UIConst.UPGRADEPROMPT = '/Game/UI/WBP/Common/Dialog/WBP_Com_Dialog_Upgrade_Prompt.WBP_Com_Dialog_Upgrade_Prompt_C' -- 升级成功提示
UIConst.SKILLLEVELUP = '/Game/UI/WBP/Armory/Widget/CharSkill/WBP_Armory_CharSkillLevelUp.WBP_Armory_CharSkillLevelUp' -- 技能升级成功提示
UIConst.BAGSTUFFSALESELECTPC = "/Game/UI/WBP/Bag/PC/WBP_Bag_Sell_P.WBP_Bag_Sell_P_C"                                -- 背包道具选择出售界面(PC)
UIConst.BAGSTUFFSALESELECTMOBILE = "/Game/UI/WBP/Bag/Mobile/WBP_Bag_Sell_M.WBP_Bag_Sell_M_C"                                -- 背包道具选择出售界面(Mobile)
UIConst.WALNUTBAGSALESELECT = "/Game/UI/WBP/Walnut/PC/WBP_Walnut_Bag_Sell_P.WBP_Walnut_Bag_Sell_P"                      -- 核桃背包道具选择出售界面
UIConst.BAGITEMDETAILS  = '/Game/UI/WBP/Bag/Widget/WBP_Bag_Detail.WBP_Bag_Detail'                                       -- 背包物品详情
UIConst.FORGEMAIN = "/Game/UI/UI_PC/Forging/Page/Forging_Main_Page_PC.Forging_Main_Page_PC"                             -- 锻造主界面
UIConst.FORGESHOWNAME = "/Game/UI/UI_PC/Forging/Widget/Forging_ShowName_Widget_PC.Forging_ShowName_Widget_PC_C"         -- 锻造物品名字显示
UIConst.FORGE_CONFIRM_WINDOW = "/Game/UI/UI_PC/Forging/Dialog/Forging_Confirm_Dialog_PC.Forging_Confirm_Dialog_PC"      -- 锻造弹窗提示
UIConst.FORGING_TEST = "/Game/UI/UI_PC/Forging/Dialog/Forging_Test.Forging_Test"
UIConst.NPCSWITCHMAIN = "/Game/UI/UI_PC/Npc_Switch/Page/Npc_Switch_Page_PC.Npc_Switch_Page_PC_C"                        -- 看板娘切换PC主界面
UIConst.LOGINPATCHPAGE = "/Game/UI/UI_PC/Login/Login_Patch_PC.Login_Patch_PC_C"                                         -- patch界面
UIConst.GACHAMAIN="/Game/UI/UI_PC/Gacha/Gacha_PC.Gacha_PC_C"                                                            -- 抽卡主界面
UIConst.SHOPMAIN ="/Game/UI/UI_PC/Shop/Shop_Main_PC.Shop_Main_PC_C"                                                    -- 商城主UI
--UIConst.RecoverUI='/Game/UI/WBP/ActionPoint/WBP_AP_Dialog.WBP_AP_Dialog_C'
UIConst.SHOPITEMSINGLE = "/Game/UI/UI_PC/Shop/Shop_Purchase_Single_PC.Shop_Purchase_Single_PC_C"                        -- 商城单个物品
UIConst.SHOPITEMPACKAGE = "/Game/UI/UI_PC/Shop/Shop_Purchase_Package_PC.Shop_Purchase_Package_PC_C"                     -- 商城礼包
UIConst.ACHIEVEMENTSYSTEM ='/Game/UI/UI_PC/Achievement/Achievement_SystemDetail_PC.Achievement_SystemDetail_PC_C'                   -- 成就系统
UIConst.MAILMAIN = '/Game/UI/UI_PC/Mail/Mail_Main_PC.Mail_Main_PC_C'                                                    -- 邮箱系统
UIConst.PROLOGUEENDLOGO = "/Game/UI/WBP/ChapterStart/Widget/WBP_Chapter_Transition01.WBP_Chapter_Transition01_C"        -- 序章结束 Logo
UIConst.TASKPANEL = "/Game/UI/UI_PC/Task/Task_Main_PC.Task_Main_PC"                                                     -- 任务面板
UIConst.PORTRAIT="/Game/UI/UI_PC/Menu/Widget/Menu_Portrait_List.Menu_Portrait_List_C"                                   -- 换头像
UIConst.ScreenshotWidget = '/Game/UI/WBP/Camera/Widget/WBP_Camera_Screenshot.WBP_Camera_Screenshot_C'                   -- 相机系统保存照片界面
UIConst.ScreenshotWidget_AprilFools = '/Game/UI/WBP/Activity/Widget/Fool/Camera/WBP_Actvity_Fool_Camera_Screenshot.WBP_Actvity_Fool_Camera_Screenshot'  -- 相机系统保存照片界面（愚人节版）
--4.副本相关
UIConst.DUNGEONTRAININGFLOAT = "/Game/UI/UI_PC/Training_Ground/Training_Ground_KillNum_PC.Training_Ground_KillNum_PC_C"
UIConst.DUNGEONCHARACTERINTRO = "/Game/UI/UI_PC/Training_Ground/Training_Ground_PC.Training_Ground_PC"

UIConst.DUNGEONCOMRIGHTKEYTEXTDESCDATA = "/Game/UI/WBP/Common/Key/Com_RightKeyTextDesc_Data_PC.Com_RightKeyTextDesc_Data_PC_C"  -- 右侧通用按钮描述条的信息
UIConst.DUNGEONTRAININGMONSTERITEMDATA = "/Game/UI/WBP/Battle/Widget/Trainning/WBP_Battle_Training_Item_Data.WBP_Battle_Training_Item_Data_C"  -- 训练场待选怪物头像的信息

UIConst.DUNGEONTASKPANEL = "/Game/UI/UI_PC/MainInterfaceUI/WorldTaskEntryItem.WorldTaskEntryItem_C"
UIConst.DUNGEONSABOTAGEFLOAT = "/Game/UI/UI_PC/Battle/Destroy/Battle_TaskDestroy_Page_PC.Battle_TaskDestroy_Page_PC_C"                 --
UIConst.DUNGEONSABOTAGECHALLENGE = "/Game/UI/WBP/Dungeon/Sabotage/WBP_Dungeon_DestroyTaskBar.WBP_Dungeon_DestroyTaskBar_C"

UIConst.DUNGEONSETTLEMENTDEFEATREMINDER = "/Game/UI/UI_PC/Settlement/WBP_DungeonSettlement_DefeatReminder_PC.WBP_DungeonSettlement_DefeatReminder_PC_C" -- 失败结算提示
UIConst.DUNGEONSETTLEMENTVICTORYREMINDER = "/Game/UI/UI_PC/Settlement/WBP_DungeonSettlement_VictoryReminder_PC.WBP_DungeonSettlement_VictoryReminder_PC_C" -- 胜利结算提示
UIConst.DUNGEONSETTLEMENT = "/Game/UI/UI_PC/Settlement/WBP_DungeonSettlement_PC.WBP_DungeonSettlement_PC_C"             -- 结算界面  
UIConst.DUNGEONHIJACKFLOAT = "/Game/UI/UI_PC/Battle/Hijack/Hijack_Task_Page_PC.Hijack_Task_Page_PC_C"
UIConst.DUNGEONHIJACKFLOATPANEL = "/Game/UI/UI_PC/Battle/Hijack/Hijack_Main_Page_PC.Hijack_Main_Page_PC_C"
UIConst.DUNGEONBLACKSCREEN = "/Game/UI/UI_PC/Settlement/Settlement_BlackScreen_PC.Settlement_BlackScreen_PC_C"          -- 结算黑幕
UIConst.SETTLEMENTFAILURETIPS = "/Game/UI/WBP/Settlement/Widget/Settlement_FailTips_Content.Settlement_FailTips_Content_C"   -- 结算失败指引Tips

UIConst.DUNGEONSURVIVALFLOAT = "/Game/UI/UI_PC/Battle/Survival/Battle_Survival_PC.Battle_Survival_PC_C"
UIConst.DUNGEONSURVIVALPROFLOAT = "/Game/UI/UI_PC/Battle/Survival/Battle_Survival_PC.Battle_Survival_PC_C"
UIConst.DUNGEONDEFENCEPROFLOAT = "/Game/UI/UI_PC/Battle/Defense/Battle_Defense02_PC.Battle_Defense02_PC_C"                  -- 副本生存界面
UIConst.DUNGEONDEFENCEFLOAT = "/Game/UI/UI_PC/Battle/Defense/Battle_Defense_PC.Battle_Defense_PC_C"                         -- 副本防御界面
UIConst.DUNGEONERETREAT = "/Game/UI/UI_PC/Battle/Defense/Battle_Defense_Settlement_PC.Battle_Defense_Settlement_PC"                             -- 副本撤离投票
-- UIConst.DUNGEONEXCAVATION = "/Game/BluePrints/UI/Prologue/WBP_Prologue_Excavation.WBP_Prologue_Excavation_C"                                 -- 挖掘本数据界面
UIConst.DUNGEONEXCAVATION = "/Game/UI/UI_PC/Battle/Digging/Battle_Digging_List_PC.Battle_Digging_List_PC_C"                                     -- 挖掘本数据界面
UIConst.DUNGEONEXCAVATIONENERGYBARDATA = "/Game/UI/Blueprint/BP_Digging_EnergyBar_Data.BP_Digging_EnergyBar_Data_C"         -- 挖掘本挖掘机的信息
UIConst.DUNGEONEXCAVATIONENERGYBARUI = "/Game/UI/UI_PC/Battle/Digging/Battle_Digging_Energybar_PC_New.Battle_Digging_Energybar_PC_New_C"        -- 挖掘本挖掘机的信息显示
UIConst.DUNGEONCAPTUREFLOAT = "/Game/UI/UI_PC/Battle/Capture/Battle_Capture_Time.Battle_Capture_Time_C"                     -- 捕获本数据界面
UIConst.DUNGEONMATCHFLOAT = "/Game/UI/UI_Phone/Prologue_Map/Prologue_Info.Prologue_Info_C"                                  -- 副本匹配
UIConst.DUNGEONMATCHINGFLOAT = "/Game/UI/UI_Phone/Team/Team_Countdown.Team_Countdown_C"                                     -- 副本匹配中
UIConst.DUNGEONTOASTPANEL = "/Game/UI/UI_PC/Guide/Guide_TextFloat03_PC.Guide_TextFloat03_PC_C"
UIConst.EXCAVATIONDUNGEONTEXTFLOAT = '/Game/UI/WBP/Dungeon/Excavation/WBP_Dungeon_ExcavationToast_New.WBP_Dungeon_ExcavationToast_New' 
UIConst.DUNGEONEXTERMINATEFLOAT = "/Game/UI/WBP/Battle/Widget/Annihilate/WBP_Battle_Annihilate.WBP_Battle_Annihilate_C"     -- 副本歼灭界面
UIConst.DungeonFirstGuide = "/Game/UI/UI_PC/Battle/Battle_ImageGuide_PC.Battle_ImageGuide_PC_C"

--5.通用界面
UIConst.COMMONCHANGESCENE = "/Game/UI/WBP/Common/Loading/Widget/WBP_Com_ChangeScene.WBP_Com_ChangeScene_C"              -- 通用切换场景过渡
--6.其他内容
UIConst.GMCOMMANDPANEL = "/Game/UI/UI_PC/GM/GM_PC.GM_PC_C"                                                              -- GM面板
UIConst.GMTIPSHOTKEY = "/Game/UI/UI_PC/GM/GM_Tips_Hotkey_PC.GM_Tips_Hotkey_PC_C"                                        -- 快捷键面板
UIConst.GMTIPSMONSTER = "/Game/UI/UI_PC/GM/GM_Tips_Monster_PC.GM_Tips_Monster_PC_C"                                     -- 召怪面板
UIConst.GMBATTLEHISTORY = "/Game/UI/UI_PC/GM/WBP_GM_BattleHistory.WBP_GM_BattleHistory_C"                               -- 召怪面板
UIConst.MONSTERINFOPANEL = "/Game/BluePrints/UI/Debug/WBP_MonsterInfo.WBP_MonsterInfo_C"                                -- 战斗日志面板
UIConst.CAMERAKEEPSIGHTUI = "/Game/UI/WBP/Common/Class/WPB_CameraKeepSight.WPB_CameraKeepSight_C"                                        -- 相机视线检测UI   
UIConst.BUFFDEBUGPANEL = "/Game/BluePrints/UI/Debug/WBP_BuffDebugPanel.WBP_BuffDebugPanel_C"
UIConst.ATTRDEBUGPANEL = "/Game/BluePrints/UI/Debug/WBP_AttrDebugPanel.WBP_AttrDebugPanel_C"
UIConst.ComSortFullScreen = "/Game/UI/WBP/Common/FilterSort/WBP_Com_Sort_FullScreen.WBP_Com_Sort_FullScreen_C"


--7.测试内容/Game/UI/UI_UnknownReward/WBP_UnknownPickupUIState.WBP_UnknownPickupUIState
UIConst.UnknownRewardTipsUI = "/Game/UI/UI_UnknownReward/UnlnownRewardTips.UnlnownRewardTips_C"
UIConst.UnknownRewardManagerTipsUI = "/Game/UI/UI_UnknownReward/WBP_UnknownPickupUIState.WBP_UnknownPickupUIState_C"
UIConst.ExitTimeDown = "/Game/UI/ExitTimeDownUI/WBP_ExitTimeDown.WBP_ExitTimeDown_C"

--8.小游戏界面
-- UIConst.MINIGAMELINE = "/Game/BluePrints/Item/MiniGame/MiniGame.MiniGame_C"                                           -- 连线小游戏类别1
UIConst.MINIGAMELINE = '/Game/UI/UI_PC/MiniGame/MiGong/MiniGame_MiGong_PC.MiniGame_MiGong_PC_C'
UIConst.ZHUANQUANQUAN = "/Game/UI/UI_PC/MiniGame/MiniGame_ZhuanQuanQuan_PC.MiniGame_ZhuanQuanQuan_PC_C"

--9.对话界面
UIConst.BUBBLETALK2DEMPTY = "/Game/UI/UI_PC/Dialog/BP_Empty.BP_Empty_C"                                                 -- 气泡对话2D空白UI(转发屏幕事件)
UIConst.STORYWEAPONSELECT = '/Game/UI/WBP/Story/Widget/BP_Story_WeaponSelect.BP_Story_WeaponSelect_C'                                    -- 剧情中武器选择界面
UIConst.FaceItemTips = '/Game/UI/WBP/Chat/Widget/Face/WBP_Chat_FaceItemTips.WBP_Chat_FaceItemTips'
-- 10.头顶3dui
UIConst.NPCHeadWidget = "/Game/UI/UI_PC/NPC/NPC_UniformHeadWidget.NPC_UniformHeadWidget_C"
UIConst.DEFEATEDINTERACT = "/Game/UI/WBP/Battle/PC/WBP_Battle_Execute_P.WBP_Battle_Execute_P_C"
UIConst.DEFEATEDINTERACTHGUIDE = "/Game/UI/WBP/Battle/PC/WBP_Battle_ExecuteOutWindowArrow_PC.WBP_Battle_ExecuteOutWindowArrow_PC_C"

-- 11.肉鸽界面
UIConst.ROUGELIKEENTERTOAST = "/Game/UI/WBP/RougeLike/Widget/WBP_Rouge_EnterToast.WBP_Rouge_EnterToast_C"
UIConst.ROUGELIKESUCESSTOAST = "/Game/UI/WBP/Common/Toast/WBP_Com_ToastSuccess.WBP_Com_ToastSuccess_C"
-- 12.活动拍脸相关
UIConst.SEVENDAYSIGNPOPUPUI = "/Game/UI/WBP/Activity/Widget/SevenDay/WBP_Activity_SevenDayPopUp.WBP_Activity_SevenDayPopUp_C"
-- 13.钢琴系统
UIConst.PianoMusicScoreData = "/Game/UI/WBP/Piano/Widget/Piano_MusicScore_Data.Piano_MusicScore_Data_C"
UIConst.PianoMusicItemData = "/Game/UI/WBP/Piano/Widget/Piano_MusicItem_Data.Piano_MusicItem_Data_C"

-- 调试用UI（后续删除）
UIConst.TEXTMEMORYINFOFLOAT = "/Game/BluePrints/UI/Rank/WBP_TestInfoFloat.WBP_TestInfoFloat_C"

-------=======同一系列蓝图拆分(原本属于同一个蓝图，拆分出来几个子蓝图)===========---------
-- 副本指引
UIConst.DUNGEONINDICATOR = {
    Hostage = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Hostage.WBP_GuidePoint_Hostage",
    Annihilate_S = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Annihilate.WBP_GuidePoint_Annihilate",
    Excavation = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Level3.WBP_GuidePoint_Level3",
    Explore = "/Game/UI/UI_PC/World/ExploreToast/Explore_GuidePoint_PC.Explore_GuidePoint_PC",
    Phantom = "/Game/UI/UI_PC/Guide/Guide_Point/Guide_Icon_Phantom.Guide_Icon_Phantom",

    GuidePointLevel1 = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Level1.WBP_GuidePoint_Level1",
    GuidePointLevel2 = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Level2.WBP_GuidePoint_Level2",
    GuidePointMechLevel1 = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Mech_Level1.WBP_GuidePoint_Mech_Level1",
    GuidePointMechLevel2 = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Mech_Level2.WBP_GuidePoint_Mech_Level2",
}


-- 副本指引图标
UIConst.DUNGEONINDICATORIMG = {
    Guide_Chest = "/Game/UI/UI_PNG/Guide/GuidePoint/Guide_Chest.Guide_Chest",
    Guide_Transportation = "/Game/UI/UI_PNG/Guide/GuidePoint/Guide_Transportation.Guide_Transportation",
    Guide_SurvivalPro_Attack = "/Game/UI/UI_PNG/Guide/GuidePoint/Guide_SurvivalPro_Attack.Guide_SurvivalPro_Attack",
    Guide_SurvivalPro_Heal = "/Game/UI/UI_PNG/Guide/GuidePoint/Guide_SurvivalPro_Heal.Guide_SurvivalPro_Heal",
    Guide_SurvivalPro_Resource = "/Game/UI/UI_PNG/Guide/GuidePoint/Guide_SurvivalPro_Resource.Guide_SurvivalPro_Resource",
    Guide_KillMonsterNode = "/Game/UI/UI_PNG/Guide/GuidePoint/Guide_Enemy.Guide_Enemy",
    Guide_LifeSupport = "/Game/UI/UI_PNG/Guide/GuidePoint/Guide_LifeSupport.Guide_LifeSupport"
}

-- Key为构建UI时候传入的Name
-- 具体各个参数意义如下
-- popup: 打开时候是否隐藏其他一些特定界面，默认为false (会调用一次CloseResidentUI接口)
-- zorder: 界面的层级(默认层级，也可以在LoadUI的时候自定义层级)
-- swallow: 是否屏蔽下层点击, 默认屏蔽 (暂未实现)
-- addtostack: 是否需要加入stack之中，可以在脚本收到打开、关闭、更新等UI状态发生变化的行为（ReceiveEnterState），如需要关心此UI状态变化的建议设置为true, 默认为true
-- cache: 是否缓存整个界面，默认nil
-- allowmulti: 是否允许存在多个同样的界面，默认同时只能存在一个
-- haschildBP： 是否拥有多个同类型的蓝图（例如指引），默认否
-- limitcount: 允许存在的最大个数上限
-- specialvisiblemode：特殊情况下的显示模式 nil|blocked|forceshow
-- resource: UI蓝图的路径
-- StopWorldRender: 是否在打开此UI的时候停止场景的渲染,默认nil
-- isreload: 是否需要在切换场景之后重新打开,默认nil(不会重新创建)
-- eventlist: 创建完成之后需要监听的事件
-- needuimode: 是否需要切换成UI输入模式
-- 然后SystemUI表中的参数，理论上也可以往这里填... 比如IsStopGame

-- 隐藏UI相关(序章的StoryLine里面用)
UIConst.BloodBarPath = "BattleMain.PlayerBloodBar"                                                                      -- 角色血条
UIConst.EnergySkillPath = "BattleMain.Char_Skill.Energy_Skill"                                                       -- 角色其他技能
UIConst.MapPath = "BattleMain.Battle_Map"                                                                              -- 地图
UIConst.TaskPath = "TaskBar"                                                                             -- 任务图标
UIConst.EntrancePath = "BattleMain.ListView"
UIConst.SkillPhonePath = "BattleMain.Char_Skill.Skill"
UIConst.EscPath = "BattleMain.Btn_Esc"
UIConst.BattleWheelPath = "BattleMain.Char_Skill.Battle_Menu"

--UI 功能常量
--(resour路径如果填这个，则会从SystemUI表之中去读取相关值)
UIConst.LoadInConfig="LoadInConfig"                 
UIConst.FromUI="FromUI"

--引导toast
UIConst.GuideTextFloat = "/Game/UI/UI_PC/Guide/Guide_TextFloat_PC"

UIConst.AllUIConfig = {
    ["SceneStartUI"] = {addtostack=false, resource=UIConst.SCENESTARTUINEW},  -- 初始化界面
    -- ["DamageIndicator"] = {popup=false, addtostack=false, allowmulti=true, limitcount=10, resource=UIConst.DAMAGEINDICATOR,},
    ["PickUpInfoTips"] = {popup=false, addtostack=false, allowmulti=false, resource=UIConst.PICKUPITEMTIPS,},
    ["PickUpInfoTipsFullOff"] = {popup=false, addtostack=false, resource=UIConst.PICKUPITEMTIPS,},
    ["PickUpChooseItemInfo"] = {popup=false, addtostack=false, resource=UIConst.PICKUPITEMPANEL,},
    ["CommonChangeScene"] = {popup=false, addtostack=false, resource=UIConst.COMMONCHANGESCENE, needuimode = true,},
    ["WorldTaskPanel"] = {popup=false, addtostack=false, resource=UIConst.WORLDTASKMAIN,},
    ["AchievementPanel"] = {eventlist = {"StartTalk", "EndTalk"},},
    ["BattleWeaponHint"] = {popup=false, addtostack=false, resource=UIConst.BATTLEWEAPONHINT,},
    ["BagStuffSelectToList"] = {popup=false, addtostack=false,},
    ["TaskPanel"] = {popup=true, addtostack=false, resource=UIConst.TASKPANEL,},
    ["NpcSwitchMain"] = {popup=true, addtostack=false, resource=UIConst.NPCSWITCHMAIN,},
    ["TaskIndicator"] = {popup=false, addtostack=false, resource=UIConst.TASKINDICATORUI, haschildBP=true},
    ["GuideTextFloat"] = {popup=false, addtostack=false, resource=UIConst.GUIDETEXTFLOAT,},
    ["PreLoginCgAnim"] = {popup=false, addtostack=false, resource=UIConst.PRELOGINCGANIM,},
    ["ServerSelect"] = {popup=false, swallow=true, addtostack=true, resource=UIConst.SERVERSELEC,},
    ["LoginPatchPage"] = {popup=false, addtostack=false, resource=UIConst.LOGINPATCHPAGE},
    ["DungenonSettlement"]= {popup=false, addtostack=false, resource=UIConst.DUNGEONSETTLEMENT, needuimode = true},
    ["DungenonIndicator"] = {popup=false, addtostack=false, resource=UIConst.DUNGEONINDICATOR, haschildBP=true},
    ["DungenonSurviveFloat"] = {popup=false, addtostack=false, resource=UIConst.DUNGEONSURVIVALFLOAT,},
    ["DungenonDefenseFloat"] = {popup=false, addtostack=false, resource=UIConst.DUNGEONDEFENCEFLOAT,},
    ["DungenonRetreat"] = {popup=false, addtostack=false, resource=UIConst.DUNGEONERETREAT,},
    ["Vote"] = {popup=false, addtostack=false, needuimode = true, resource=UIConst.DUNGEONERETREAT,},
    ["BranchTaskReceiveTips"] = {popup=true, addtostack=true, resource=UIConst.LoadInConfig, needuimode = true},
    ["ArmoryMain"] = {popup=true, addtostack=true, resource=UIConst.LoadInConfig, needuimode = true},
    ["CharRecord"] = {popup=true, addtostack=true, needuimode = true,IsStopGame=true},
    ["DyeMain"] = {popup=true, addtostack=true, needuimode = true,IsStopGame=true},
    ["ArmoryBattleMenuWeaponConfig"] = {popup=true, addtostack=false, resource=UIConst.BATTLEMENUWEAPONCONFIG, needuimode = true,IsStopGame=true},
    ["UpgradePrompt"] = {popup=true,addtostack=false, resource=UIConst.UPGRADEPROMPT,needuimode = true},
    ["SkillLevelUp"] = {popup=true,addtostack=false, resource=UIConst.SKILLLEVELUP,needuimode = true},
    ["ForgeMain"] = {popup=true, addtostack=false, resource=UIConst.FORGEMAIN, needuimode = true},
    ["ForgeShowName"] = {popup=false, addtostack=false, resource=UIConst.FORGESHOWNAME},
    ["MonsterExpWord"] = {popup=false, addtostack=false, allowmulti=true, resource=UIConst.MONSTEREXPTIPS,},
    ["BossBlood"] = {popup=false,addtostack=false,allowmulti=false,resource=UIConst.BOSSBLOOD},
    ["GachaMain"] = {popup=true, addtostack=false, resource=UIConst.GACHAMAIN, needuimode = true},
    ["MailMain"] = {popup=true, addtostack=false, resource=UIConst.GACHAMAIN, needuimode = true},
    ["MainMain"] = {popup=true, addtostack=false, resource=UIConst.GACHAMAIN, needuimode = true},
    ["GMCommandPanel"] = {swallow=true, specialvisiblemode="forceshow", addtostack=true, resource=UIConst.GMCOMMANDPANEL, needuimode = true, IsStopGame=true},
    ["GMTipsHotkey"] = {swallow=true, specialvisiblemode="forceshow", addtostack=true, resource=UIConst.GMTIPSHOTKEY,needuimode = true,IsStopGame=true},
    ["GMTipsMonster"] = {swallow=true, specialvisiblemode="forceshow", addtostack=true, resource=UIConst.GMTIPSMONSTER,needuimode = true,IsStopGame=true},
    ["GMBattleHistory"] = {swallow=true, specialvisiblemode="forceshow", addtostack=true, resource=UIConst.GMTIPSMONSTER,needuimode = true,IsStopGame=true},
    ["UnknownRewardTipsUI"] = {popup = false, addtostack = false, resource = UIConst.UnknownRewardTipsUI,},
    ["UnknownRewardManagerTipsUI"] = {popup = false, addtostack = false, resource = UIConst.UnknownRewardManagerTipsUI,},
    ["MonsterInfo"] = {popup=false, addtostack=true, resource=UIConst.MONSTERINFOPANEL,},
    ["ExitTimeDown"] = {popup = false, addtostack = false, resource = UIConst.ExitTimeDown,},
    ["DungeonMatchFloat"] = {popup = false, addtostack = false, resource = UIConst.DUNGEONEMATCHFLOAT,},
    ["DungeonMatchingFloat"] = {popup = false, addtostack = false, resource = UIConst.DUNGEONEMATCHINGFLOAT,},
    ["DungeonExterminateFloat"] = {popup = false, addtostack = false, resource = UIConst.DUNGEONEXTERMINATEFLOAT,},
    ["GrenadesTips"] = {popup=false, addtostack=false, allowmulti=true, resource=UIConst.GRENADESTIPS,},
    ["WeaponTips"] = {popup=false, addtostack=false,needuimode = true, resource=UIConst.WEAPONTIPS},
    ["SevenDaySignPopUp"] = {popup=true, addtostack=false, resource=UIConst.SEVENDAYSIGNPOPUPUI, needuimode = true, zorder=47},

    ["ShopMain"] = {popup=true, addtostack = false, needuimode = true, resource = UIConst.SHOPMAIN},
    ["ShopItemSingle"] = {popup=false, addtostack = false, needuimode = false, resource = UIConst.SHOPITEMSINGLE},
    ["ShopItemPackage"] = {popup=false, addtostack = false, needuimode = false, resource = UIConst.SHOPITEMPACKAGE},

    ["DefeatedInteract"] = {popup=false, addtostack=false,  resource=UIConst.DEFEATEDINTERACT},
    ["StoryWeaponSelect"] = {popup=true, addtostack=true, resource=UIConst.STORYWEAPONSELECT, needuimode = true},
	["DungeonFirstGuide"] = {needuimode=true,},
    ["AchievementSystem"] = {popup=true, addtostack=false, resource=UIConst.ACHIEVEMENTSYSTEM, needuimode = true},
    ["LevelMapMain"] = {popup = true, addtostack = true, needuimode = true,},
    ["GuideMain"] = {popup = true, addtostack = false, resource = UIConst.GUIDEMAIN, needuimode = true},
    ["ZhuanQuanQuan"] = {popup = true, addtostack = true, resource = UIConst.ZHUANQUANQUAN, needuimode = true},
    ["ConnectLine"] = {popup = true, addtostack = true, resource = UIConst.MINIGAMELINE, needuimode = true},
    ["ChangePortrain"]={popup=false, addtostack=true,resource = UIConst.PORTRAIT, needuimode = true},
    ["CameraKeepSightUI"] = {popup=false, addtostack=false,specialvisiblemode="forceshow", resource = UIConst.CAMERAKEEPSIGHTUI,needuimode = true},
    ["ComSortFullScreen"] = {popup=false, addtostack=false,resource = UIConst.ComSortFullScreen,needuimode = true},
    ["EXPLORETOASTTIPS"] = {specialvisiblemode="forceshow"},
    ["EXPLORETOASTFAIL"] = {specialvisiblemode="forceshow"},
    ["EXPLORETOASTSUCCESS"] = {specialvisiblemode="forceshow"},
    ["GetItemTip"]={popup=false,resource = UIConst.GetItemsTip, needuimode = true},
    ["UpgradeTip"]={popup=false,resource = UIConst.UpgradeTip, needuimode = true},
    ["CharPicture"] = {popup=true, addtostack=false, resource=UIConst.CHARPIECTURE, needuimode = true,IsStopGame=true},
}

-- 尽可能用lua枚举，而不是ESlateVisiblity，减少脚本与引擎的通信次数
UIConst.VisibilityOp = {
    ["Visible"] = 0, -- Visible and hit-testable (can interact with cursor). Default value.
    ["Collapsed"] = 1, -- Not visible and takes up no space in the layout (obviously not hit-testable)
    ["Hidden"] = 2, -- Not visible but occupies layout space (obviously not hit-testable)
    ["HitTestInvisible"] = 3, --  Visible but not hit-testable (cannot interact with cursor) and children in the hierarchy (if any) are also not hit-testable.
    ["SelfHitTestInvisible"] = 4, -- Visible but not hit-testable (cannot interact with cursor) and doesn't affect hit-testing on children (if any)
}

-- 界面手柄按键
UIConst.GamePadKey = {
    LeftAnalogX = "Gamepad_LeftX",
    LeftAnalogY = "Gamepad_LeftY",
    RightAnalogX = "Gamepad_RightX",
    RightAnalogY = "Gamepad_RightY",
    LeftTriggerAnalog = "Gamepad_LeftTriggerAxis",
    RightTriggerAnalog = "Gamepad_RightTriggerAxis",

    -- 左边摇杆按下\右边摇杆按下
    LeftThumb = "Gamepad_LeftThumbstick",
    RightThumb = "Gamepad_RightThumbstick",

    -- 中间按键相关（左右菜单键）
    SpecialLeft = "Gamepad_Special_Left",
    SpecialRight = "Gamepad_Special_Right",
    SpecialLeft_X = "Gamepad_Special_Left_X",
    SpecialRight_X = "Gamepad_Special_Right_X",
    SpecialLeft_Y = "Gamepad_Special_Left_Y",
    SpecialRight_Y = "Gamepad_Special_Right_Y",

    -- 右边X、Y、A、B四个按钮
    FaceButtonBottom = "Gamepad_FaceButton_Bottom",
    FaceButtonRight = "Gamepad_FaceButton_Right",
    FaceButtonLeft = "Gamepad_FaceButton_Left",
    FaceButtonTop = "Gamepad_FaceButton_Top",

    -- LS、LT、RS、RT 左边肩键、右边肩键、左边扳机、右边扳机
    LeftShoulder = "Gamepad_LeftShoulder",
    RightShoulder = "Gamepad_RightShoulder",
    LeftTriggerThreshold = "Gamepad_LeftTrigger",
    RightTriggerThreshold = "Gamepad_RightTrigger",

    -- 左边十字键
    DPadUp = "Gamepad_DPad_Up",
    DPadDown = "Gamepad_DPad_Down",
    DPadRight = "Gamepad_DPad_Right",
    DPadLeft = "Gamepad_DPad_Left",

    -- 左边摇杆
    LeftStickUp = "Gamepad_LeftStick_Up",
    LeftStickDown = "Gamepad_LeftStick_Down",
    LeftStickRight = "Gamepad_LeftStick_Right",
    LeftStickLeft = "Gamepad_LeftStick_Left",

    -- 右边摇杆
    RightStickUp = "Gamepad_RightStick_Up",
    RightStickDown = "Gamepad_RightStick_Down",
    RightStickRight = "Gamepad_RightStick_Right",
    RightStickLeft = "Gamepad_RightStick_Left",
}

UIConst.GamePadImgKey = {
    -- 右边X、Y、A、B四个按钮
    FaceButtonBottom = "A",
    FaceButtonRight = "B",
    FaceButtonLeft = "X",
    FaceButtonTop = "Y",

    -- LS、LT、RS、RT 左边肩键、右边肩键、左边扳机、右边扳机
   LeftShoulder = "LB",
   RightShoulder = "RB",
   LeftTriggerThreshold = "LT",
   RightTriggerThreshold = "RT",

    -- 左边摇杆按下\右边摇杆按下
    LeftThumb = "LS",
    RightThumb = "RS",

    -- 左边十字键
    DPadUp = "Up",
    DPadDown = "Down",
    DPadLeft = "Left",
    DPadRight = "Right",

    -- 中间按键相关（左右菜单键）
    SpecialLeft = "View",
    SpecialRight = "Menu",

    -- 扳机模拟值
    RightTriggerAnalog = "RV",
    LeftTriggerAnalog = "LV",
}

-- 允许出现的同一类型的UI出现的最大个数
UIConst.MAXEXISTNUM = 1000

-- UI 名字，用于加载、卸载、获取 UI
UIConst.InteractiveUIName = "InteractiveUI"
UIConst.BattleHitShieldPCName = "HitShieldEffect"
UIConst.BattleBrokenShieldPCName = "BrokenShieldEffect"
UIConst.BattleNearDeathPCName="NearDeathBlood"
UIConst.WarningHintName = "WarningHintName"
UIConst.DestroyAlarmName = "DestroyAlarm"
UIConst.CommonSetUP="CommonSetUp"
UIConst.MenuLevel="MenuLevel"
UIConst.MenuWorld="MenuWorld"
UIConst.CommonDialogTip="CommonDialogTip"
UIConst.SkillDetails="SkillDetails"
UIConst.RecoverUI="RecoverUI"
UIConst.GetItemsTip="RougeGetItemsTip"
UIConst.UpgradeTip="RougeUpgradeTip"


-- UI Tip类型
UIConst.Tip_Quest = "QuestTips"                         -- 任务开始结束
UIConst.Tip_CommonTop = "CommonTopTips"                 -- 通用HUD提示 (2024.9.19 和UIConst.Tip_CommonToast样式统一)
UIConst.Tip_CommonWarning = "CommonWarningTips"         -- 副本警告提示
UIConst.Tip_CombineWarning = "CombineWarningTips"       -- 组合警告提示
UIConst.Tip_CommonToast = "CommonToastMain"             -- 通用界面内提示
UIConst.Tip_ExcavationToast = "ExcavationToast"         -- 挖掘关的提示Toast
UIConst.Tip_CommonDialogTip="CommonDialogTip"           -- 
UIConst.Tip_StoryToast = "CommonStoryToast"             -- 副本警告提示

-- 通用的Button点击音效
-- UIConst.ClickSe = UE4.UFMODBlueprintStatics.FindEventbyName("event:/ui/common/click")

-- 灰绿蓝紫金
UIConst.RarityColor = {
    [1]="d1d1d1ff",
    [2]="4cb587ff",
    [3]="708fffff",
    [4]="b77cffff",
    [5]="de9f49ff",
}

UIConst.RarityColorName = {
    "Grey",
    "Green",
    "Blue",
    "Purple",
    "Yellow",
    "Black",
}

-- 需要支持PopUp一些UI的Name
UIConst.PopUpUIName = {
    SpecificSystemList = {
        "Battle",
        "Common",
        "Guide",
    },
    SpecificUIList = {
        "MenuLevel",
        "MenuWorld",
    },
}

UIConst.BATTLE_MENU_BEHAVIOUR_TYPE = {
    IN_BATTLE_MENU = 1,
    ARMOURY_BATTLE_MENU = 2,
}

-- DPI基准值
UIConst.DPIBaseOnSize = {
    PC={
        X = 1920,
        Y = 1080,
    },
    Mobile={
        X = 1600,
        Y = 900,
    },
}

UIConst.EnumTimeStyleType = {
    YMDAndHMS = 1,
    YMD = 2,
    HMS = 3,
}

-- 界面关系
UIConst.WidgetAllStateTag = {
    Precedence = 1,     -- 界面之间为抢占关系，拥有抢占关系的页面加载的时候表里的一些界面默认隐藏且过程之中创建的也隐藏（详细关系见SystemUI表），关闭当前页面再重新显示这些被隐藏的UI
    Mutual = 2,         -- 界面之间为互斥关系，拥有互斥关系的页面加载的时候如果有其他互斥界面存在则自身隐藏（详细关系见SystemUI表），其他互斥界面都不存在的时候再重新显示
    Queue = 3,          -- 界面之间为队列关系，拥有队列关系其他页面加载时候先不创建，而是会加入一个队列之中，前一个界面关闭了后一个界面再进行加载）
    Group = 4,          -- 界面之间为同组关系，此界面存在时，除同组关系外的其他页面隐藏，且在界面存在期间，不是同组关系内界面加载时，也隐藏，界面结束时，显示所有被隐藏的UI
    Exclusive = 9,      -- 页面独占，其他界面隐藏
    Blocked = 10,       -- 页面独占，其他界面不创建
}

-- 所有UI的隐藏Tag
UIConst.CommonHideTagName = {
    UIPopUp = "UIPopUp",
    SystemOpen = "SystemOpen",
    UIStackChange = "UIStackChange",
    DefaultTag = "DefaultTag",
    GMShowUIOnly = "GMShowUIOnly",
}

-- 当前游戏UI显示状态模式集合
-- 1: HUD模式
-- 2：系统界面
UIConst.GameUIShowState = {
	HUD = 1,
	System = 2,
}

---#region 界面跳转相关
---界面跳转动画效果优化开关
UIConst.IsEnablePageJumpAnimEffect = true

-- 跳转回来过程之中动画的播放速率（避免中间漏出场景） 
UIConst.AnimOutSpeedWithPageJump = 
{
    LittleFastSpeed = 3,
    NormalFastSpeed = 5,
    MoreFastSpeed = 10,

    MaxSpeed = 60,
}

-- 栈内界面效果结构的配置
UIConst.AnimWithJumpConfig = {
    -- 界面名字 = {
    --             InAnimWithJumpTime=StackChange切换的In动画时间, 
    --             OutAnimWithJumpTime=StackChange切换的Out动画时间, 
    --             IsNeedFadeOut=在有其他界面入栈时是否需要淡出效果, 
    --             EndFadeOutValue=淡出结束时的透明度值, 默认0.75,  
    --             IsNeedFadeIn=在有其他界面出栈时是否需要淡入效果, 默认true, 
    --             IsNeedMatchTime=淡入是否需要匹配当前界面的时间, 默认false,
    --         },
    -- 例如 ShopMain = {InAnimWithJumpTime=0.5, OutAnimWithJumpTime=1}, 没有重写的变量会使用Normal里面配置的值,
    ShopMain = {InAnimWithJumpTime=0.05, IsNeedFadeOut=false},
    AutoChessMain = {IsNeedFadeOut=false},
    FameMain={IsNeedFadeOut=false, IsNeedFadeIn=true},
    Normal = {InAnimWithJumpTime=0.3, OutAnimWithJumpTime=0.1, IsNeedFadeOut=true, EndFadeOutValue=0.75, IsNeedFadeIn=false, IsNeedMatchAnimTime=false},
}
---#endregion

-- 以下界面打开时，无视其他关卡指引点显隐规则，指引点加载后仍需显示
-- 需要同时在SystemUI表中保证关卡指引点主UI（GuideIconMain）保持显示
UIConst.DungeonIndicatorShowWidgets =  {"BattleFort"}

UIConst.RedDotType = 
{
    CommonRedDot = EReddotType.Normal,
    NewRedDot = EReddotType.New,
    GreyRedDot = EReddotType.Gray,
}
-- 优化项相关开关
UIConst.OptimizeSwitch = {
    PC = {
        UI_WRAPPING_WITH_INVALIDBOX = false,            -- 使用InvalidBox来Wrap
        UI_WRAPPING_WITH_RETAINERBOX = false,           -- 使用RetainerBox来Wrap
        UI_ADD_IN_CACHE = false,                        -- 添加到缓存池
    },
    Mobile = {
        UI_WRAPPING_WITH_INVALIDBOX = true,             -- 使用InvalidBox来Wrap
        UI_WRAPPING_WITH_RETAINERBOX = true,            -- 使用RetainerBox来Wrap
        UI_ADD_IN_CACHE = false,                        -- 添加到缓存池
    },
}

-- 拍照界面隐藏按钮名
UIConst.PhotoCameraHiddenButton = {
    Role = "Hide_Role",
    Player = "Hide_Player",
    NPC = "Hide_NPC",
    Monster = "Hide_Monster",
    Pet = "Hide_Pet",
}

-- 隐藏战斗单位的方式
UIConst.EnumHideBattleUnitStyle = {
    NormalShowAndHideAll = 1,                           -- 正常隐藏、显示
    NormalShowAndHideAllExceptSelf = 2,                 -- 正常隐藏、显示（除了角色自身）
    InstantShowAll = 11,                                -- 正常隐藏，显示提前（会在Out动画播放开始显示出来）
    InstantShowAllExceptSelf = 12,                      -- 正常隐藏，显示提前（会在Out动画播放开始显示出来，除了角色自身）
    DelayHideAll = 13,                                  -- 延后隐藏（会在In动画播放完成之后隐藏），正常显示
    DelayHideAllExceptSelf = 14,                        -- 延后隐藏（会在In动画播放完成之后隐藏），正常显示
}

UIConst.IndicatorCategoryTable = {
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_BlastRobot.WBP_GuidePoint_BlastRobot"] = "Monster",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Hostage.WBP_GuidePoint_Hostage"] = "Hostage",
    ["/Game/UI/UI_PC/World/ExploreToast/Explore_GuidePoint_PC.Explore_GuidePoint_PC"] = "Mechanism",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Annihilate.WBP_GuidePoint_Annihilate"] = "Monster",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Level3.WBP_GuidePoint_Level3"] = "Mechanism",
    ["/Game/UI/UI_PC/Guide/Guide_Point/Guide_Icon_Phantom.Guide_Icon_Phantom"] = "Phantom",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Entrance.WBP_GuidePoint_Entrance"] = "Mechanism",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Alert.WBP_GuidePoint_Alert"] = "AlertActor",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Pet.WBP_GuidePoint_Pet"] = "Pet",
}

UIConst.IndicatorCategoryIconTable = {
    -- Destroy
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DestroyTarget_A.T_Gp_DestroyTarget_A"] = "Monster",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DestroyTarget_B.T_Gp_DestroyTarget_B"] = "Monster",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DestroyTarget_C.T_Gp_DestroyTarget_C"] = "Monster",
    -- Evacuation
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Evacuation.T_Gp_Evacuation"] = "Mechanism",
    -- Expedition
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_LifeSupport.T_Gp_LifeSupport"] = "Mechanism",
    -- Guide_Point
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission.T_Gp_MainMission"] = "Mechanism",
    -- Guide_Point_Red
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DefeatMission.T_Gp_DefeatMission"] = "Mechanism",
    -- Rou
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Battle01.T_Gp_Rou_Battle01"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Battle02.T_Gp_Rou_Battle02"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Battle03.T_Gp_Rou_Battle03"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Battle04.T_Gp_Rou_Battle04"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Event01.T_Gp_Rou_Event01"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Shop01.T_Gp_Rou_Shop01"] = "Mechanism",
    -- Survival
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SurvivalPro_Attack.T_Gp_SurvivalPro_Attack"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SurvivalPro_Heal.T_Gp_SurvivalPro_Heal"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SurvivalPro_Resource.T_Gp_SurvivalPro_Resource"] = "Mechanism",
    -- WorldExploration
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Chest.T_Gp_Chest"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_EastScan.T_Gp_EastScan"] = "Mechanism",
}

UIConst.IndicatorAnimTable = {
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_BlastRobot.WBP_GuidePoint_BlastRobot"] = "Blast",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Hostage.WBP_GuidePoint_Hostage"] = "Hostage",
    ["/Game/UI/UI_PC/World/ExploreToast/Explore_GuidePoint_PC.Explore_GuidePoint_PC"] = "Guide_Point",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Annihilate.WBP_GuidePoint_Annihilate"] = "Annihilate_S",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Level3.WBP_GuidePoint_Level3"] = "Excavation",
    ["/Game/UI/UI_PC/Guide/Guide_Point/Guide_Icon_Phantom.Guide_Icon_Phantom"] = "Phantom",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Entrance.WBP_GuidePoint_Entrance"] = "Entrance",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Alert.WBP_GuidePoint_Alert"] = "Alert",
    ["/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Pet.WBP_GuidePoint_Pet"] = "Pet",
}

UIConst.IndicatorAnimIconTable = {
    -- Destroy
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DestroyTarget_A.T_Gp_DestroyTarget_A"] = "Destroy",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DestroyTarget_B.T_Gp_DestroyTarget_B"] = "Destroy",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DestroyTarget_C.T_Gp_DestroyTarget_C"] = "Destroy",
    -- Evacuation
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Evacuation.T_Gp_Evacuation"] = "Evacuation",
    -- Expedition
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_LifeSupport.T_Gp_LifeSupport"] = "Mechanism",
    -- Guide_Point
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission.T_Gp_MainMission"] = "Mechanism",
    -- Guide_Point_Red
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DefeatMission.T_Gp_DefeatMission"] = "Mechanism",
    -- Rou
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Battle01.T_Gp_Rou_Battle01"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Battle02.T_Gp_Rou_Battle02"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Battle03.T_Gp_Rou_Battle03"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Battle04.T_Gp_Rou_Battle04"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Event01.T_Gp_Rou_Event01"] = "Mechanism",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rou_Shop01.T_Gp_Rou_Shop01"] = "Mechanism",
    -- Survival
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SurvivalPro_Attack.T_Gp_SurvivalPro_Attack"] = "Guide_Icon_Survival",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SurvivalPro_Heal.T_Gp_SurvivalPro_Heal"] = "Guide_Icon_Survival",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SurvivalPro_Resource.T_Gp_SurvivalPro_Resource"] = "Guide_Icon_Survival",
    -- WorldExploration
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Chest.T_Gp_Chest"] = "WorldExploration",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Trans01.T_Gp_Trans01"] = "WorldExploration",
    ["/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_EastScan.T_Gp_EastScan"] = "Mechanism",
    
}

UIConst.DungeonTaskPath = {
    MainMission = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission.T_Gp_MainMission",
    DefeatMission = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DefeatMission_L.T_Gp_DefeatMission_L",
    Boss = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Boss.T_Gp_Boss",
    Evacuation = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Evacuation.T_Gp_Evacuation",
    SpecialEnemy = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpecialEnemy.T_Gp_SpecialEnemy",
}

UIConst.FXAccessoryTypes = {
    ["FX_Dead"]        = true,
    ["FX_Teleport"]    = true,
    ["FX_Footprint"]   = true,
    ["FX_PlungingATK"] = true,
    ["FX_HelixLeap"]   = true,
    ["MVP"]            = true,
}

UIConst.HidePlayerAccessoryTypes = {
    ["FX_Dead"]      = true,
    ["FX_Footprint"] = true,
}

UIConst.AccessoryTypeTextMap = {
    ["Hat"]             = "UI_SkinPreview_Accessory_Hat",
    ["Head"]            = "UI_SkinPreview_Accessory_Head",
    ["Face"]            = "UI_SkinPreview_Accessory_Face",
    ["Waist"]           = "UI_SkinPreview_Accessory_Waist",
    ["Back"]            = "UI_SkinPreview_Accessory_Back",
    ["Tail"]            = "UI_SkinPreview_Accessory_Tail",
    ["FX_Dead"]         = "UI_SkinPreview_Accessory_FX_Dead",
    ["FX_Teleport"]     = "UI_SkinPreview_Accessory_FX_Teleport",
    ["FX_Footprint"]    = "UI_SkinPreview_Accessory_FX_Footprint",
    ["FX_Body"]         = "UI_SkinPreview_Accessory_FX_Body",
    ["MVP"]             = "UI_SkinPreview_Accessory_MVP",
    ["FX_PlungingATK"]  = "UI_SkinPreview_Accessory_FX_PlungingATK",
    ["FX_HelixLeap"]    = "UI_SkinPreview_Accessory_FX_HelixLeap",
    ["WeaponAccessory"] = "UI_SkinPreview_Accessory_Weapon",
}

UIConst.ErrorCategory = {
    HUD = "主界面",
    Abyss = "大秘境",
    Achievement = "成就系统",
    Artivity = "活动",
    Anglin = "钓鱼",
    Announcement = "公告",
    Archive = "图鉴",
    Armory = "军械库",
    Bag = "背包",
    BattlePass = "战令",
    Camera = "相机系统",
    Char = "角色",
    Chat = "聊天",
    Clock = "时间调整系统",
    Dispatch = "派遣",
    Dungeon = "委托",
    Entertainment = "邀约",
    Forging = "锻造系统",
    Friend = "好友系统",
    Gacha = "抽卡",
    GuideBook = "教学手册",
    Invite = "入驻",
    Mail = "邮箱",
    Map = "地图",
    Mod = "魔之楔",
    Polarity = "极化系统",
    Quest = "任务系统",
    Rouge = "肉鸽系统",
    Shop = "商城",
    Skill = "技能",
    Temple = "神庙",
    Wiki = "百科",

    BasicModule = "基础模块",
    Others = "未知分类",
}

UIConst.ShopBannerType = {
    Common = 0,
    MonthCard = 1,
    DailyPack = 2
}

UIConst.ButtonState = {
    None = 0,
    Press = 1,
    Hovered = 2,
    Unhovered = 3,
    Release = 4,
    Click = 5,
}

UIConst.MouseButton =
{
    LeftMouseButton = true,
    RightMouseButton = true,
    MiddleMouseButton = true,
    ThumbMouseButton = true,
    ThumbMouseButton2 = true,
    MouseScrollUp = true,
    MouseScrollDown = true,
    MouseX = true,
    MouseY = true,
    MouseWheelAxis = true,
}

UIConst.MVPSkipShowTime = 0.6

UIConst.InputNumMode = {
    ENABLE_PWD = 1,  -- 开启二级密码（双行输入）
    VERIFY_PWD = 2,  -- 验证密码（单行输入）
    DISABLE_PWD = 3, -- 关闭密码（单行输入）
    NUMBER     = 4,  -- 通用数字输入（单行数字）
}

UIConst.SkinPreviewItemTypes = {
    ["Skin"]            = true,
    ["WeaponSkin"]      = true,
    ["CharAccessory"]   = true,
    ["WeaponAccessory"] = true,
    ["Mount"]           = true,
    ["Hair"]            = true,
}

-- 限制预览的手势动作ID列表
UIConst.LimitPreviewResource = {
    [41037] = true,
    [41038] = true,
    [41039] = true,
    [41042] = true,
    [41043] = true,
    [41044] = true,
    [41045] = true,
}

UIConst.BlockingTime = 3
UIConst.MaxBlockTime = 10

---#region 分层组织相关
UIConst.bUseHierarchicalLayer = false        -- 是否使用分层组织结构

UIConst.HierarchicalLayer = {
    "Background",       -- 背景层
    "HUD",              -- HUD层
    "Tack",             -- 堆叠层
    "System",           -- 系统界面层
    "Top",              -- 上层界面层(二级页面)
    "Popup",            -- 弹出层(最顶层)
}

---#endregion

return UIConst
