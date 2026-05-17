local Class = _G.TypeClass
local AvatarEntity = require "BluePrints.Client.Wrapper.Entity".AvatarEntity
local Assemble = require "NetworkEngine.Common.Assemble"
local HeroUSDKUtils= require "Utils.HeroUSDKUtils"
local TimeUtils = require "Utils.TimeUtils"
local MiscUtils = require "Utils.MiscUtils"
local EMCache = require "EMCache.EMCache"
local pb = require "pb"

---@class ClientAvatar:ClientAvatarEntity
local Avatar = Class("Avatar", AvatarEntity)

Avatar.__Props__ = "BluePrints.Client.Implements.Avatar"

Avatar.__Component__ = {
	"BluePrints.Client.Entities.Components.EntityBase",
	"BluePrints.Client.Entities.Components.AvatarInfo",
	"BluePrints.Client.Entities.Components.Others",
	"BluePrints.Client.Entities.Components.Login",
	"BluePrints.Client.Entities.Components.AvatarStatus",
	"BluePrints.Client.Entities.Components.BattleCheck",
	"BluePrints.Client.Entities.Components.CharMgr",
	"BluePrints.Client.Entities.Components.WeaponMgr",
	"BluePrints.Client.Entities.Components.ResourceMgr",
	"BluePrints.Client.Entities.Components.ModMgr",
	"BluePrints.Client.Entities.Components.DungeonMgr",
	"BluePrints.Client.Entities.Components.BattleLogic",
	"BluePrints.Client.Entities.Components.BonusMgr",
	"BluePrints.Client.Entities.Components.QuestMgr",
	"BluePrints.Client.Entities.Components.TargetMgr",
	"BluePrints.Client.Entities.Components.PlayerInfoMgr",
	"BluePrints.Client.Entities.Components.AchvMgr",
	"BluePrints.Client.Entities.Components.DSMgr",
	"BluePrints.Client.Entities.Components.BlueMgr",
	"BluePrints.Client.Entities.Components.GachaMgr",
	"BluePrints.Client.Entities.Components.RankCom",
	"BluePrints.Client.Entities.Components.ShopMgr",
	"BluePrints.Client.Entities.Components.LSMgr",
	"BluePrints.Client.Entities.Components.Team",
	"BluePrints.Client.Entities.Components.ExploreMgr",
	"BluePrints.Client.Entities.Components.SuitMgr",
	"BluePrints.Client.Entities.Components.HardBoss",
	"BluePrints.Client.Entities.Components.MSDKUpload",
	"BluePrints.Client.Entities.Components.Mail",
	"BluePrints.Client.Entities.Components.PartyMgr",
	"BluePrints.Client.Entities.Components.SystemGuideMgr",
	"BluePrints.Client.Entities.CommonComponents.ResourceUseComponent",
	"BluePrints.Client.Entities.Components.ConditionMgr",
	"BluePrints.Client.Entities.Components.PayMgr",
	"BluePrints.Client.Entities.Components.GuideBook",
	"BluePrints.Client.Entities.Components.MarkPointMgr",
	"BluePrints.Client.Entities.Components.UIUnlockMgr",
	"BluePrints.Client.Entities.Components.CharAccessoryMgr",
	"BluePrints.Client.Entities.Components.RegionLogMgr",
	"BluePrints.Client.Entities.Components.RougeLikeMgr",
	"BluePrints.Client.Entities.Components.ExtendMgr",
	"BluePrints.Client.Entities.Components.TraceMgr",
	"BluePrints.Client.Entities.Components.Friend",
	"BluePrints.Client.Entities.Components.Pet",
	"BluePrints.Client.Entities.Components.BuffMgr",
	"BluePrints.Client.Entities.CommonComponents.AutoBattleTestComponent",
	"BluePrints.Client.Entities.Components.AvatarRegionRpcMgr",
	"BluePrints.Client.Entities.Components.AvatarRegionMgr",
	"BluePrints.Client.Entities.Components.ChatComp",
	"BluePrints.Client.Entities.Components.DynamicQuestMgr",
	"BluePrints.Client.Entities.Components.StarterQuest",
	"BluePrints.Client.Entities.Components.DailyLogin",
	"BluePrints.Client.Entities.Components.ImpressionShopMgr",
	"BluePrints.Client.Entities.Components.WikiEntry",
	"BluePrints.Client.Entities.Components.AppearanceMgr",
	"BluePrints.Client.Entities.Components.AbyssMgr",
	"BluePrints.Client.Entities.Components.DispathMgr",
	"Blueprints.Client.Entities.Components.Walnut",
	"Blueprints.Client.Entities.CommonComponents.GameModeWalnutComponent",
	"Blueprints.Client.Entities.Components.OnlineComp",
	"Blueprints.Client.Entities.Components.RegionMoveSyncMgr",
	"Blueprints.Client.Entities.Components.LevelSequence",
	"BluePrints.Client.Entities.Components.NewImpressionMgr",
	"BluePrints.Client.Entities.Components.ArchiveMgr",
	"BluePrints.Client.Entities.Components.FishMgr",
	"BluePrints.Client.Entities.Components.DetectiveQuestion",
	"BluePrints.Client.Entities.Components.SquadMgr",
	"BluePrints.Client.Entities.Components.PersonalInfoMgr",
	"BluePrints.Client.Entities.Components.MonthlyCardComp",
	"BluePrints.Client.Entities.Components.BattlePass",
	"BluePrints.Client.Entities.Components.DailyTaskMgr",
	"BluePrints.Client.Entities.Components.ModBookQuestComp",
	"BluePrints.Client.Entities.Components.ZhiLiuEntrust",
	"BluePrints.Client.Entities.Components.HoldModMgr",
	"BluePrints.Client.Entities.Components.MidTermMgr",
	"BluePrints.Client.Entities.Components.PaotaiGame",
	"BluePrints.Client.Entities.Components.LimitedResourceMgr",
	"BluePrints.Client.Entities.Components.CommonQuestActivity",
	"BluePrints.Client.Entities.Components.CommunityMgr",
	"BluePrints.Client.Entities.Components.TempleEventMgr",
	"BluePrints.Client.Entities.Components.MiscEnterWorldMgr",
	"BluePrints.Client.Entities.Components.FeiNaMgr",
	"BluePrints.Client.Entities.Components.TitleComp",
	"BluePrints.Client.Entities.Components.DoubleModDrop",
	"BluePrints.Client.Entities.Components.SettlementOnlineMgr",
	"BluePrints.Client.Entities.Components.TheaterActivity",
	"BluePrints.Client.Entities.Components.RaidSeasonMgr",
	"BluePrints.Client.Entities.Components.MountMgr",
	"BluePrints.Client.Entities.Components.WebJumpMgr",
	"BluePrints.Client.Entities.Components.WuyoushengActivity",
	"BluePrints.Client.Entities.Components.GiftComp",
	"BluePrints.Client.Entities.Components.RegionReputationMgr",
	"BluePrints.Client.Entities.Components.AutoChess",
	"BluePrints.Client.Entities.Components.AprilFoolsDayMgr",
	"BluePrints.Client.Entities.Components.SecondaryPasswordComp",
	"BluePrints.Client.Entities.Components.ComeBackMgr",
	"BluePrints.Client.Entities.Components.PhotoEventMgr",
	"BluePrints.Client.Entities.Components.ExtractionTreasureMgr",
	"Blueprints.Client.Entities.CommonComponents.DungeonGameObjectComponent",
	"BluePrints.Client.Entities.Components.TreasureHuntMgr",
	"BluePrints.Client.Entities.Components.BackpackPuzzleMgr",
	"BluePrints.Client.Entities.Components.GuildComp",
	"BluePrints.Client.Entities.Components.LimitedPrize",
	"Blueprints.Client.Entities.CommonComponents.ServerGameControlComponent",
	"BluePrints.Client.Entities.Components.AccessoryDrop",
}

function Avatar:Init(eid)
	Avatar.Super.Init(self, eid)
	self.bClientEntity = true

	local content_path = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
	assert(pb.loadufsfile(content_path.."Script/NetworkEngine/Proto/pb/Attr.pb"))
	self.AttrTypes = {}
	for name, basename, type in pb.types() do
		self.AttrTypes[basename] = true
	end
end

function Avatar:OnBecomePlayer()
	Avatar.Super.OnBecomePlayer(self)
	local BP_Avatar = GWorld.GameInstance:GetAvatar()
	if BP_Avatar then
		BP_Avatar:SetClientAvatar(self)
	else
		assert(false, "登录出错，Avatar为空，8成你是用打包环境去运行工程了，回退你的仓库")
	end
	MissionIndicatorManager.TrackingSpecialSideQuestChainId = nil
	SystemGuideManager:AddListenerSystemGuide()
	---Note:EnterWorld的时候，Avatar属性不一定会同步完毕，不要再EnterWorld访问Avatar属性
	self:EnterWorld()

	-- 向服务端请求 hotfix 文件
	self:QueryHotfix()
	AudioManager(self):SetVoiceGender()

	local SerializeUtils = require "Utils.SerializeUtils"
	local s = "{['CommonCombatInfo']={['char_level']=60,['rangedweapon_mod_json']={},['pet_level']=20,['weapon_level_array']={'50','1'},['prominentweapon_mod_json']={},['skin_id']=210102,['meleeweapon_mod_json']={{['lv']=0,['id']=102003},{['lv']=0,['id']=32302},{['lv']=0,['id']=42311},{['lv']=0,['id']=42411},{['lv']=0,['id']=42006}},['weapon_id_array']={'10202','20401'},['char_id']=2101,['pet_breaknum']=0,['pet_id']=4079,['pet_entry_id']={},['char_mod_json']={{['lv']=5,['id']=41723},{['lv']=5,['id']=41424},{['lv']=5,['id']=41921},{['lv']=5,['id']=41724},{['lv']=0,['id']=41722},{['lv']=0,['id']=31512}}},['AvatarInfo']={['PhantomInfo2']={['UltraWeapons']={},['MeleeWeapon']={},['Pet']={},['RoleInfo']={['ModData']={{['Uuid']={['ObjIdStr']='6900AE75E1D864DAC2A60D4B'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'}},['Count']=1,['ModId']=11002,['Cost']=2,['LockState']=0},{['Uuid']={['ObjIdStr']='6900AE75E1D864DAC2A60D7F'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'}},['Count']=1,['ModId']=11001,['Cost']=2,['LockState']=0},{['Uuid']={['ObjIdStr']='6900A494E1D864DAC281EEC5'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'},{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'}},['Count']=1,['ModId']=31215,['Cost']=10,['LockState']=0},{['Uuid']={['ObjIdStr']='6900AE75E1D864DAC2A60D2B'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'}},['Count']=1,['ModId']=11004,['Cost']=5,['LockState']=0},{['Uuid']={['ObjIdStr']='6900C25AE1D864DAC2F0FFE8'},['Level']=3,['IsOriginal']=false,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'},{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'}},['Count']=1,['ModId']=31217,['Cost']=13,['LockState']=0},{['Uuid']={['ObjIdStr']='6900C2A6E1D864DAC2F233C6'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'},{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'},{['ObjIdStr']='6900A3B0E1D864DAC27ED5C5'}},['Count']=1,['ModId']=31512,['Cost']=2,['LockState']=0}},['AppearanceSuit']={['AccessorySuit']={[9]=50001,[8]=60001},['IsShowPartMesh']=true,['Colors']={-1,-1,-1,-1,-1,-1,-1,-1,-1},['IsCornerVisible']=true,['CharId']=5401,['SkinId']=5401},['Level']=50,['SlotData']={{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900AE75E1D864DAC2A60D4B'},['SlotId']=1},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900AE75E1D864DAC2A60D7F'},['SlotId']=2},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900A494E1D864DAC281EEC5'},['SlotId']=3},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900AE75E1D864DAC2A60D2B'},['SlotId']=4},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900C25AE1D864DAC2F0FFE8'},['SlotId']=5},{['Polarity']=-1,['ModEid']='',['SlotId']=6},{['Polarity']=-1,['ModEid']='',['SlotId']=7},{['Polarity']=-1,['ModEid']='',['SlotId']=8},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900C2A6E1D864DAC2F233C6'},['SlotId']=9}},['Exp']=0,['RoleId']=5401,['ModSuitIndex']=1,['SkillInfos']={{['SkillId']=540101,['SkillInfo']={['Level']=4}},{['SkillId']=540102,['SkillInfo']={['Level']=4}},{['SkillId']=540103,['SkillInfo']={['Level']=4}}},['ModPassives']={{1512,0}},['SkillTreeInfos']={{[2]={['LockState']=1,['TargetId']=540101},[3]={['LockState']=1,['TargetId']=540102}},{[2]={['LockState']=1,['TargetId']=540103},[3]={['LockState']=1,['TargetId']=540104}},{[2]={['LockState']=1,['TargetId']=540104},[3]={['LockState']=1,['TargetId']=100009}}},['ReplaceAttrs']={['CardLevelValues']={['MaxHp']=6.6416,['MaxES']=6.6416,['ATK_Fire']=6.6416,['DEF']=1,['ATK_Smash']=6.6416,['ATK_Default']=6.6416,['ATK_Spike']=6.6416,['ATK_Wind']=6.6416,['ATK_Water']=6.6416,['ATK_Thunder']=6.6416,['ATK_Dark']=6.6416,['ATK_Light']=6.6416,['ATK_Slash']=6.6416},['CardValues']={['ATK_Smash']=0,['MaxSp']=160,['EnmityValue']=0,['ATK_Wind']=19,['StrongValue']=0,['ATK_Thunder']=0,['SkillEfficiency']=1,['ATK_Light']=0,['SkillSustain']=1,['DropDistance']=1000,['SPD']=600,['ATK_Slash']=0,['DEF']=285,['ATK_Dark']=0,['ATK_Default']=0,['MaxES']=100,['MaxHp']=100,['ATK_Fire']=0,['SkillIntensity']=1,['ATK_Water']=0,['SkillRange']=1,['ATK_Spike']=0},['TotalValues']={['MaxHp']=531,['MaxSp']=219,['EnmityValue']=0,['ATK_Wind']=131.238016,['StrongValue']=0,['SkillIntensity']=1,['SkillEfficiency']=1.03,['ATK_Fire']=0.0,['SkillSustain']=1.15,['DropDistance']=3000,['ATK_Smash']=0.0,['MaxES']=664,['DEF']=285,['ATK_Dark']=0.0,['ATK_Default']=0.0,['SPD']=600,['ATK_Light']=0.0,['ATK_Slash']=0.0,['ATK_Spike']=0.0,['ATK_Water']=0.0,['ATK_Thunder']=0.0,['SkillRange']=1},['ModRateValues']={['SkillSustain']={0.15},['MaxHp']={-0.2},['ATK_Spike']={[2]=0.04},['MaxSp']={0.37},['SkillEfficiency']={0.03},['ATK_Fire']={[2]=0.04},['ATK_Default']={[2]=0.04},['ATK_Smash']={[2]=0.04},['ATK_Wind']={[2]=0.04},['ATK_Light']={[2]=0.04},['ATK_Thunder']={[2]=0.04},['ATK_Water']={[2]=0.04},['ATK_Dark']={[2]=0.04},['ATK_Slash']={[2]=0.04}},['ModAddValues']={['DropDistance']=2000}},['GradeLevel']=0,['EnhanceLevel']=3},['RangedWeapon']={['ModData']={},['Level']=1,['SlotData']={{['Polarity']=-1,['ModEid']='',['SlotId']=1},{['Polarity']=-1,['ModEid']='',['SlotId']=2},{['Polarity']=-1,['ModEid']='',['SlotId']=3},{['Polarity']=-1,['ModEid']='',['SlotId']=4},{['Polarity']=-1,['ModEid']='',['SlotId']=5},{['Polarity']=-1,['ModEid']='',['SlotId']=6},{['Polarity']=-1,['ModEid']='',['SlotId']=7},{['Polarity']=-1,['ModEid']='',['SlotId']=8}},['Exp']=0,['ModSuitIndex']=1,['ReplaceAttrs']={['CardLevelValues']={['ATK_Smash']=1,['ATK_Spike']=1,['ATK_Default']=1,['ATK_Fire']=1,['ATK_Wind']=1,['ATK_Slash']=1,['ATK_Thunder']=1,['ATK_Water']=1,['ATK_Dark']=1,['ATK_Light']=1},['CardValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=18,['ATK_Spike']=0,['TriggerProbability']=0.2,['AttackRange_RayLength']=0,['MagazineCapacity']=1,['AttackSpeed_HeavyAttack']=1,['BulletConver']=4.75,['ATK_Thunder']=0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Fire']=0,['MaxDistance']=4000,['ATK_Light']=0,['AttackSpeed_Normal']=1,['ATK_Dark']=0,['ATK_Slash']=0,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['ATK_Default']=0,['AttackRange_Normal']=0,['CRI']=0.26,['BulletMax']=150,['CRD']=2.2,['ATK_Water']=0,['ComboHoldTime']=10,['ATK_Wind']=0},['TotalValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=18,['ATK_Spike']=0,['TriggerProbability']=0.2,['AttackRange_RayLength']=0,['MagazineCapacity']=1,['ATK_Wind']=0,['MaxDistance']=4000,['ATK_Thunder']=0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Fire']=0,['BulletConver']=4.75,['ATK_Light']=0,['ATK_Dark']=0,['ATK_Slash']=0,['AttackSpeed_Normal']=1,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['ATK_Default']=0,['AttackRange_Normal']=0,['CRI']=0.26,['BulletMax']=150,['CRD']=2.2,['ATK_Water']=0,['ComboHoldTime']=10,['AttackSpeed_HeavyAttack']=1},['ModRateValues']={},['ModAddValues']={}},['AppearanceInfo']={['AccessoryId']=-1,['SkinId']=20602,['WeaponId']=20602,['Colors']={['SpecialColor']=-1,['Colors']={-1,-1,-1,-1}}},['ModPassives']={},['SkillInfos']={[2060201]={}},['WeaponId']=20602,['GradeLevel']=0,['EnhanceLevel']=0}},['CharacterInfo']={['UltraWeapons']={},['MeleeWeapon']={['ModData']={{['Uuid']={['ObjIdStr']='6900AE75E1D864DAC2A60D4F'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={{['ObjIdStr']='690052DFE1D864DAC2667E14'},{['ObjIdStr']='69032D15E1D864DAC27684E8'}},['CharUuids']={},['Count']=1,['ModId']=102003,['Cost']=30,['LockState']=0},{['Uuid']={['ObjIdStr']='69020E00E1D864DAC298F435'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={{['ObjIdStr']='690052DFE1D864DAC2667E14'}},['CharUuids']={},['Count']=1,['ModId']=32302,['Cost']=5,['LockState']=0},{['Uuid']={['ObjIdStr']='69030744E1D864DAC255EC16'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={{['ObjIdStr']='690052DFE1D864DAC2667E14'},{['ObjIdStr']='69032D15E1D864DAC27684E8'}},['CharUuids']={},['Count']=1,['ModId']=42311,['Cost']=15,['LockState']=0},{['Uuid']={['ObjIdStr']='690213C8E1D864DAC2A25C26'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={{['ObjIdStr']='690052DFE1D864DAC2667E14'}},['CharUuids']={},['Count']=1,['ModId']=42411,['Cost']=12,['LockState']=0},{['Uuid']={['ObjIdStr']='690213C8E1D864DAC2A25C2C'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={{['ObjIdStr']='690052DFE1D864DAC2667E14'}},['CharUuids']={},['Count']=3,['ModId']=42006,['Cost']=7,['LockState']=0}},['Level']=50,['SlotData']={{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900AE75E1D864DAC2A60D4F'},['SlotId']=1},{['Polarity']=-1,['ModEid']='',['SlotId']=2},{['Polarity']=-1,['ModEid']='',['SlotId']=3},{['Polarity']=-1,['ModEid']={['ObjIdStr']='69020E00E1D864DAC298F435'},['SlotId']=4},{['Polarity']=-1,['ModEid']={['ObjIdStr']='69030744E1D864DAC255EC16'},['SlotId']=5},{['Polarity']=-1,['ModEid']={['ObjIdStr']='690213C8E1D864DAC2A25C26'},['SlotId']=6},{['Polarity']=-1,['ModEid']={['ObjIdStr']='690213C8E1D864DAC2A25C2C'},['SlotId']=7},{['Polarity']=-1,['ModEid']='',['SlotId']=8}},['Exp']=0,['ModSuitIndex']=1,['ReplaceAttrs']={['CardLevelValues']={['ATK_Smash']=6.6416,['ATK_Spike']=6.6416,['ATK_Default']=6.6416,['ATK_Fire']=6.6416,['ATK_Wind']=6.6416,['ATK_Slash']=6.6416,['ATK_Thunder']=6.6416,['ATK_Water']=6.6416,['ATK_Dark']=6.6416,['ATK_Light']=6.6416},['CardValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=0,['ATK_Spike']=18,['TriggerProbability']=0.3,['AttackRange_RayLength']=0,['MagazineCapacity']=0,['ATK_Wind']=0,['MaxDistance']=0,['ATK_Thunder']=0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Light']=0,['ATK_Fire']=0,['ATK_Dark']=0,['ATK_Slash']=0,['ATK_Default']=0,['AttackSpeed_Normal']=1,['DEF']=0,['AttackSpeed_Reload']=1,['CRI']=0.24,['AttackRange_Normal']=0,['AttackSpeed_HeavyAttack']=1,['BulletMax']=0,['CRD']=2.15,['ATK_Water']=0,['ComboHoldTime']=10,['AttackRange_Bullet']=0},['TotalValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=0.0,['ATK_Spike']=143.45856,['TriggerProbability']=0.351,['AttackRange_RayLength']=0,['MagazineCapacity']=0,['ATK_Wind']=0.0,['MaxDistance']=0,['ATK_Thunder']=0.0,['AttackSpeed_FallAttack']=1.08,['MaxComboCount']=120,['ATK_Light']=0.0,['ATK_Fire']=0.0,['AttackSpeed_Normal']=1.25,['ATK_Dark']=0.0,['ATK_Default']=0.0,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['CRI']=0.24,['AttackRange_Normal']=80,['AttackSpeed_HeavyAttack']=1,['BulletMax']=0,['CRD']=2.15,['ATK_Water']=0.0,['ComboHoldTime']=10,['ATK_Slash']=0.0},['ModRateValues']={['ATK_Smash']={[3]=0.2},['ATK_Spike']={[3]=0.2},['AttackSpeed_Normal']={0.25},['TriggerProbability']={0.17},['ATK_Fire']={[3]=0.2},['ATK_Default']={[3]=0.2},['ATK_Water']={[3]=0.2},['ATK_Wind']={[3]=0.2},['ATK_Light']={[3]=0.2},['ATK_Thunder']={[3]=0.2},['ATK_Dark']={[3]=0.2},['AttackSpeed_FallAttack']={0.08},['ATK_Slash']={[3]=0.2}},['ModAddValues']={['AttackRange_Normal']=80}},['AppearanceInfo']={['AccessoryId']=-1,['SkinId']=10202,['WeaponId']=10202,['Colors']={['SpecialColor']=-1,['Colors']={-1,-1,-1,-1}}},['ModPassives']={{2302,0,false},{2311,0,false}},['SkillInfos']={[1020103]={},[1020104]={},[1020102]={},[1020201]={}},['WeaponId']=10202,['GradeLevel']=0,['EnhanceLevel']=3},['Pet']={['EntryIds']={},['PetId']=4079},['RoleInfo']={['ModData']={{['Uuid']={['ObjIdStr']='69033762E1D864DAC27F9999'},['Level']=5,['IsOriginal']=false,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6900A3B0E1D864DAC27ED5C5'}},['Count']=1,['ModId']=41723,['Cost']=16,['LockState']=0},{['Uuid']={['ObjIdStr']='69030AECE1D864DAC25934A0'},['Level']=5,['IsOriginal']=false,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6900A3B0E1D864DAC27ED5C5'}},['Count']=1,['ModId']=41424,['Cost']=24,['LockState']=0},{['Uuid']={['ObjIdStr']='69033D45E1D864DAC2854940'},['Level']=5,['IsOriginal']=false,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6900A3B0E1D864DAC27ED5C5'}},['Count']=1,['ModId']=41921,['Cost']=24,['LockState']=0},{['Uuid']={['ObjIdStr']='69033D65E1D864DAC2856AD8'},['Level']=5,['IsOriginal']=false,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6900A3B0E1D864DAC27ED5C5'}},['Count']=1,['ModId']=41724,['Cost']=16,['LockState']=0},{['Uuid']={['ObjIdStr']='69033653E1D864DAC27EA183'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6900A3B0E1D864DAC27ED5C5'}},['Count']=2,['ModId']=41722,['Cost']=12,['LockState']=0},{['Uuid']={['ObjIdStr']='6900C2A6E1D864DAC2F233C6'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'},{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'},{['ObjIdStr']='6900A3B0E1D864DAC27ED5C5'}},['Count']=1,['ModId']=31512,['Cost']=2,['LockState']=0}},['AppearanceSuit']={['AccessorySuit']={[3]=30003,[8]=60001,[2]=10015,[9]=50001},['IsShowPartMesh']=true,['Colors']={-1,-1,-1,-1,-1,-1,-1,-1,-1},['IsCornerVisible']=true,['CharId']=2101,['SkinId']=210102},['Level']=60,['SlotData']={{['Polarity']=-1,['ModEid']={['ObjIdStr']='69033762E1D864DAC27F9999'},['SlotId']=1},{['Polarity']=-1,['ModEid']={['ObjIdStr']='69030AECE1D864DAC25934A0'},['SlotId']=2},{['Polarity']=4,['ModEid']={['ObjIdStr']='69033D45E1D864DAC2854940'},['SlotId']=3},{['Polarity']=-1,['ModEid']={['ObjIdStr']='69033D65E1D864DAC2856AD8'},['SlotId']=4},{['Polarity']=-1,['ModEid']={['ObjIdStr']='69033653E1D864DAC27EA183'},['SlotId']=5},{['Polarity']=-1,['ModEid']='',['SlotId']=6},{['Polarity']=-1,['ModEid']='',['SlotId']=7},{['Polarity']=-1,['ModEid']='',['SlotId']=8},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900C2A6E1D864DAC2F233C6'},['SlotId']=9}},['Exp']=0,['RoleId']=2101,['ModSuitIndex']=1,['SkillInfos']={{['SkillId']=210101,['SkillInfo']={['Level']=6,['Grade']=2}},{['SkillId']=210102,['SkillInfo']={['Level']=6,['Grade']=2}},{['SkillId']=210103,['SkillInfo']={['Level']=6,['Grade']=2}},{['SkillId']=210104,['SkillInfo']={['Grade']=2}}},['ModPassives']={{1430,5},{1921,5,1},{1512,0}},['SkillTreeInfos']={{[2]={['LockState']=0,['TargetId']=210101},[3]={['LockState']=1,['TargetId']=210102}},{[2]={['LockState']=0,['TargetId']=210103},[3]={['LockState']=1,['TargetId']=210104}},{[2]={['LockState']=0,['TargetId']=210104},[3]={['LockState']=1,['TargetId']=210003}}},['ReplaceAttrs']={['CardLevelValues']={['MaxHp']=8.5685,['MaxES']=8.5685,['ATK_Fire']=8.5685,['DEF']=1,['ATK_Smash']=8.5685,['ATK_Default']=8.5685,['ATK_Spike']=8.5685,['ATK_Wind']=8.5685,['ATK_Water']=8.5685,['ATK_Thunder']=8.5685,['ATK_Dark']=8.5685,['ATK_Light']=8.5685,['ATK_Slash']=8.5685},['CardValues']={['ATK_Smash']=0,['MaxSp']=150,['EnmityValue']=0,['ATK_Wind']=0,['StrongValue']=0,['ATK_Thunder']=0,['SkillEfficiency']=1,['ATK_Light']=0,['SkillSustain']=1,['DropDistance']=1000,['SPD']=600,['ATK_Slash']=0,['DEF']=252,['ATK_Dark']=0,['ATK_Default']=0,['MaxES']=100,['MaxHp']=100,['ATK_Fire']=0,['SkillIntensity']=1,['ATK_Water']=25,['SkillRange']=1,['ATK_Spike']=0},['TotalValues']={['MaxHp']=1499,['MaxSp']=186,['EnmityValue']=0,['ATK_Wind']=0.0,['StrongValue']=0,['SkillIntensity']=1.54,['SkillEfficiency']=1.12,['ATK_Fire']=0.0,['SkillSustain']=1.18,['DropDistance']=3000,['ATK_Smash']=0.0,['MaxES']=857,['DEF']=441.0,['ATK_Dark']=0.0,['ATK_Default']=0.0,['SPD']=600,['ATK_Light']=0.0,['ATK_Slash']=0.0,['ATK_Spike']=0.0,['ATK_Water']=537.673375,['ATK_Thunder']=0.0,['SkillRange']=1.17},['ModRateValues']={['ATK_Smash']={[2]=1.51},['MaxSp']={0.24},['ATK_Wind']={[2]=1.51},['SkillIntensity']={0.54},['SkillEfficiency']={0.12},['ATK_Fire']={[2]=1.51},['SkillSustain']={0.18},['DEF']={0.75},['ATK_Light']={[2]=1.51},['ATK_Default']={[2]=1.51},['ATK_Dark']={[2]=1.51},['SkillRange']={0.17},['ATK_Thunder']={[2]=1.51},['ATK_Slash']={[2]=1.51},['ATK_Water']={[2]=1.51},['MaxHp']={0.75},['ATK_Spike']={[2]=1.51}},['ModAddValues']={['DropDistance']=2000}},['GradeLevel']=2,['EnhanceLevel']=4},['RangedWeapon']={['ModData']={},['Level']=1,['SlotData']={{['Polarity']=-1,['ModEid']='',['SlotId']=1},{['Polarity']=-1,['ModEid']='',['SlotId']=2},{['Polarity']=-1,['ModEid']='',['SlotId']=3},{['Polarity']=-1,['ModEid']='',['SlotId']=4},{['Polarity']=-1,['ModEid']='',['SlotId']=5},{['Polarity']=-1,['ModEid']='',['SlotId']=6},{['Polarity']=-1,['ModEid']='',['SlotId']=7},{['Polarity']=-1,['ModEid']='',['SlotId']=8}},['Exp']=0,['ModSuitIndex']=1,['ReplaceAttrs']={['CardLevelValues']={['ATK_Smash']=1,['ATK_Spike']=1,['ATK_Default']=1,['ATK_Fire']=1,['ATK_Wind']=1,['ATK_Slash']=1,['ATK_Thunder']=1,['ATK_Water']=1,['ATK_Dark']=1,['ATK_Light']=1},['CardValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=0,['ATK_Spike']=18,['TriggerProbability']=0.2,['AttackRange_RayLength']=0,['MagazineCapacity']=6,['AttackSpeed_HeavyAttack']=1,['BulletConver']=0.5,['ATK_Thunder']=0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Fire']=0,['MaxDistance']=2800,['ATK_Light']=0,['AttackSpeed_Normal']=1,['ATK_Dark']=0,['ATK_Slash']=0,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['ATK_Default']=0,['AttackRange_Normal']=0,['CRI']=0.2,['BulletMax']=60,['CRD']=1.8,['ATK_Water']=0,['ComboHoldTime']=10,['ATK_Wind']=0},['TotalValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=0,['ATK_Spike']=18,['TriggerProbability']=0.2,['AttackRange_RayLength']=0,['MagazineCapacity']=6,['ATK_Wind']=0,['MaxDistance']=2800,['ATK_Thunder']=0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Fire']=0,['BulletConver']=0.5,['ATK_Light']=0,['ATK_Dark']=0,['ATK_Slash']=0,['AttackSpeed_Normal']=1,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['ATK_Default']=0,['AttackRange_Normal']=0,['CRI']=0.2,['BulletMax']=60,['CRD']=1.8,['ATK_Water']=0,['ComboHoldTime']=10,['AttackSpeed_HeavyAttack']=1},['ModRateValues']={},['ModAddValues']={}},['AppearanceInfo']={['AccessoryId']=-1,['SkinId']=20401,['WeaponId']=20401,['Colors']={['SpecialColor']=-1,['Colors']={-1,-1,-1,-1}}},['ModPassives']={},['SkillInfos']={[2040101]={},[2040102]={}},['WeaponId']=20401,['GradeLevel']=0,['EnhanceLevel']=0}},['PhantomInfo1']={['UltraWeapons']={{['ModData']={},['Level']=50,['SlotData']={{['Polarity']=-1,['ModEid']='',['SlotId']=1},{['Polarity']=-1,['ModEid']='',['SlotId']=2},{['Polarity']=-1,['ModEid']='',['SlotId']=3},{['Polarity']=-1,['ModEid']='',['SlotId']=4}},['Exp']=0,['ModSuitIndex']=1,['ReplaceAttrs']={['CardLevelValues']={['ATK_Smash']=6.6416,['ATK_Spike']=6.6416,['ATK_Default']=6.6416,['ATK_Fire']=6.6416,['ATK_Wind']=6.6416,['ATK_Slash']=6.6416,['ATK_Thunder']=6.6416,['ATK_Water']=6.6416,['ATK_Dark']=6.6416,['ATK_Light']=6.6416},['CardValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=0,['ATK_Spike']=28,['TriggerProbability']=0.5,['AttackRange_RayLength']=0,['MagazineCapacity']=-1,['AttackSpeed_HeavyAttack']=1,['BulletConver']=1,['ATK_Thunder']=0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Fire']=0,['MaxDistance']=2800,['ATK_Light']=0,['AttackSpeed_Normal']=1,['ATK_Dark']=0,['ATK_Slash']=0,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['ATK_Default']=0,['AttackRange_Normal']=0,['CRI']=0.12,['BulletMax']=-1,['CRD']=1.5,['ATK_Water']=0,['ComboHoldTime']=10,['ATK_Wind']=0},['TotalValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=0.0,['ATK_Spike']=223.15776,['TriggerProbability']=0.5,['AttackRange_RayLength']=0,['MagazineCapacity']=-1,['ATK_Wind']=0.0,['MaxDistance']=2800,['ATK_Thunder']=0.0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Fire']=0.0,['BulletConver']=1,['ATK_Light']=0.0,['ATK_Dark']=0.0,['ATK_Slash']=0.0,['AttackSpeed_Normal']=1,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['ATK_Default']=0.0,['AttackRange_Normal']=0,['CRI']=0.12,['BulletMax']=-1,['CRD']=1.5,['ATK_Water']=0.0,['ComboHoldTime']=10,['AttackSpeed_HeavyAttack']=1},['ModRateValues']={['ATK_Smash']={[3]=0.2},['ATK_Spike']={[3]=0.2},['ATK_Default']={[3]=0.2},['ATK_Fire']={[3]=0.2},['ATK_Wind']={[3]=0.2},['ATK_Slash']={[3]=0.2},['ATK_Thunder']={[3]=0.2},['ATK_Water']={[3]=0.2},['ATK_Dark']={[3]=0.2},['ATK_Light']={[3]=0.2}},['ModAddValues']={}},['ModPassives']={},['SkillInfos']={[310122]={['Level']=4}},['WeaponId']=310101,['GradeLevel']=0,['EnhanceLevel']=4}},['MeleeWeapon']={},['Pet']={},['RoleInfo']={['ModData']={{['Uuid']={['ObjIdStr']='690218A0E1D864DAC2AAC8F2'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='69004996E1D864DAC22945C8'},{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'}},['Count']=1,['ModId']=31204,['Cost']=6,['LockState']=0},{['Uuid']={['ObjIdStr']='6900A494E1D864DAC281EEC5'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'},{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'}},['Count']=1,['ModId']=31215,['Cost']=10,['LockState']=0},{['Uuid']={['ObjIdStr']='69030AA8E1D864DAC258FA37'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'}},['Count']=1,['ModId']=41007,['Cost']=8,['LockState']=0},{['Uuid']={['ObjIdStr']='69030B8BE1D864DAC259BAE9'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'}},['Count']=2,['ModId']=41004,['Cost']=8,['LockState']=0},{['Uuid']={['ObjIdStr']='69030C88E1D864DAC25A92FB'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'}},['Count']=1,['ModId']=41434,['Cost']=19,['LockState']=0},{['Uuid']={['ObjIdStr']='6900C25AE1D864DAC2F0FFE8'},['Level']=3,['IsOriginal']=false,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'},{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'}},['Count']=1,['ModId']=31217,['Cost']=13,['LockState']=0},{['Uuid']={['ObjIdStr']='6900C2A6E1D864DAC2F233C6'},['Level']=0,['IsOriginal']=true,['CurrentModCardLevel']=0,['WeaponUuids']={},['CharUuids']={{['ObjIdStr']='6901B17DE1D864DAC22586B8'},{['ObjIdStr']='6901F0F5E1D864DAC26EB50F'},{['ObjIdStr']='69004996E1D864DAC22945C8'},{['ObjIdStr']='6901FDA4E1D864DAC27FEAC4'},{['ObjIdStr']='6900B410E1D864DAC2BA2D6D'},{['ObjIdStr']='6900A3B0E1D864DAC27ED5C5'}},['Count']=1,['ModId']=31512,['Cost']=2,['LockState']=0}},['AppearanceSuit']={['AccessorySuit']={[9]=50001,[8]=60001},['IsShowPartMesh']=true,['Colors']={-1,-1,-1,-1,-1,-1,-1,-1,-1},['IsCornerVisible']=true,['CharId']=3101,['SkinId']=3101},['Level']=50,['SlotData']={{['Polarity']=-1,['ModEid']={['ObjIdStr']='690218A0E1D864DAC2AAC8F2'},['SlotId']=1},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900A494E1D864DAC281EEC5'},['SlotId']=2},{['Polarity']=-1,['ModEid']={['ObjIdStr']='69030AA8E1D864DAC258FA37'},['SlotId']=3},{['Polarity']=-1,['ModEid']={['ObjIdStr']='69030B8BE1D864DAC259BAE9'},['SlotId']=4},{['Polarity']=-1,['ModEid']={['ObjIdStr']='69030C88E1D864DAC25A92FB'},['SlotId']=5},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900C25AE1D864DAC2F0FFE8'},['SlotId']=6},{['Polarity']=-1,['ModEid']='',['SlotId']=7},{['Polarity']=-1,['ModEid']='',['SlotId']=8},{['Polarity']=-1,['ModEid']={['ObjIdStr']='6900C2A6E1D864DAC2F233C6'},['SlotId']=9}},['Exp']=0,['RoleId']=3101,['ModSuitIndex']=1,['SkillInfos']={{['SkillId']=310101,['SkillInfo']={['Level']=4}},{['SkillId']=310102,['SkillInfo']={['Level']=4}},{['SkillId']=310103,['SkillInfo']={['Level']=4}},{['SkillId']=310104,['SkillInfo']={}}},['ModPassives']={{1430,0},{1512,0}},['SkillTreeInfos']={{[2]={['LockState']=0,['TargetId']=310101},[3]={['LockState']=1,['TargetId']=310102}},{[2]={['LockState']=0,['TargetId']=310103},[3]={['LockState']=1,['TargetId']=310104}},{[2]={['LockState']=0,['TargetId']=310104},[3]={['LockState']=1,['TargetId']=310003}}},['ReplaceAttrs']={['CardLevelValues']={['MaxHp']=6.6416,['MaxES']=6.6416,['ATK_Fire']=6.6416,['DEF']=1,['ATK_Smash']=6.6416,['ATK_Default']=6.6416,['ATK_Spike']=6.6416,['ATK_Wind']=6.6416,['ATK_Water']=6.6416,['ATK_Thunder']=6.6416,['ATK_Dark']=6.6416,['ATK_Light']=6.6416,['ATK_Slash']=6.6416},['CardValues']={['ATK_Smash']=0,['MaxSp']=150,['EnmityValue']=0,['ATK_Wind']=0,['StrongValue']=0,['ATK_Thunder']=0,['SkillEfficiency']=1,['ATK_Light']=0,['SkillSustain']=1,['DropDistance']=1000,['SPD']=600,['ATK_Slash']=0,['DEF']=240,['ATK_Dark']=0,['ATK_Default']=0,['MaxES']=105,['MaxHp']=105,['ATK_Fire']=23,['SkillIntensity']=1,['ATK_Water']=0,['SkillRange']=1,['ATK_Spike']=0},['TotalValues']={['MaxHp']=617,['MaxSp']=210,['EnmityValue']=0,['ATK_Wind']=0.0,['StrongValue']=0,['SkillIntensity']=1,['SkillEfficiency']=1.03,['ATK_Fire']=202.40276,['SkillSustain']=1.09,['DropDistance']=3000,['ATK_Smash']=0.0,['MaxES']=697,['DEF']=301.2,['ATK_Dark']=0.0,['ATK_Default']=0.0,['SPD']=600,['ATK_Light']=0.0,['ATK_Slash']=0.0,['ATK_Spike']=0.0,['ATK_Water']=0.0,['ATK_Thunder']=0.0,['SkillRange']=1},['ModRateValues']={['SkillSustain']={0.09},['ATK_Smash']={[2]=0.325},['ATK_Spike']={[2]=0.325},['MaxSp']={0.4},['MaxHp']={-0.115},['DEF']={0.255},['SkillEfficiency']={0.03},['ATK_Default']={[2]=0.325},['ATK_Fire']={[2]=0.325},['ATK_Wind']={[2]=0.325},['ATK_Slash']={[2]=0.325},['ATK_Thunder']={[2]=0.325},['ATK_Water']={[2]=0.325},['ATK_Dark']={[2]=0.325},['ATK_Light']={[2]=0.325}},['ModAddValues']={['DropDistance']=2000}},['GradeLevel']=0,['EnhanceLevel']=4},['RangedWeapon']={['ModData']={},['Level']=18,['SlotData']={{['Polarity']=-1,['ModEid']='',['SlotId']=1},{['Polarity']=-1,['ModEid']='',['SlotId']=2},{['Polarity']=-1,['ModEid']='',['SlotId']=3},{['Polarity']=-1,['ModEid']='',['SlotId']=4},{['Polarity']=-1,['ModEid']='',['SlotId']=5},{['Polarity']=-1,['ModEid']='',['SlotId']=6},{['Polarity']=-1,['ModEid']='',['SlotId']=7},{['Polarity']=-1,['ModEid']='',['SlotId']=8}},['Exp']=1535,['ModSuitIndex']=1,['ReplaceAttrs']={['CardLevelValues']={['ATK_Smash']=2.4505,['ATK_Spike']=2.4505,['ATK_Default']=2.4505,['ATK_Fire']=2.4505,['ATK_Wind']=2.4505,['ATK_Slash']=2.4505,['ATK_Thunder']=2.4505,['ATK_Water']=2.4505,['ATK_Dark']=2.4505,['ATK_Light']=2.4505},['CardValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=0,['ATK_Spike']=0,['TriggerProbability']=0.33,['AttackRange_RayLength']=0,['MagazineCapacity']=50,['AttackSpeed_HeavyAttack']=1,['BulletConver']=1.5,['ATK_Thunder']=0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Fire']=0,['MaxDistance']=2000,['ATK_Light']=0,['AttackSpeed_Normal']=1,['ATK_Dark']=0,['ATK_Slash']=19,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['ATK_Default']=0,['AttackRange_Normal']=0,['CRI']=0.15,['BulletMax']=120,['CRD']=2,['ATK_Water']=0,['ComboHoldTime']=10,['ATK_Wind']=0},['TotalValues']={['MultiShoot']=1,['AttackSpeed_SlideAttack']=1,['ATK_Smash']=0.0,['ATK_Spike']=0.0,['TriggerProbability']=0.5775,['AttackRange_RayLength']=0,['MagazineCapacity']=50,['ATK_Wind']=0.0,['MaxDistance']=2000,['ATK_Thunder']=0.0,['AttackSpeed_FallAttack']=1,['MaxComboCount']=120,['ATK_Fire']=0.0,['BulletConver']=1.5,['ATK_Light']=0.0,['ATK_Dark']=0.0,['ATK_Slash']=46.5595,['AttackSpeed_Normal']=1,['AttackRange_Bullet']=0,['DEF']=0,['AttackSpeed_Reload']=1,['ATK_Default']=0.0,['AttackRange_Normal']=0,['CRI']=0.15,['BulletMax']=120,['CRD']=2,['ATK_Water']=0.0,['ComboHoldTime']=10,['AttackSpeed_HeavyAttack']=1},['ModRateValues']={['TriggerProbability']={0.75}},['ModAddValues']={}},['AppearanceInfo']={['AccessoryId']=-1,['SkinId']=20503,['WeaponId']=20503,['Colors']={['SpecialColor']=-1,['Colors']={-1,-1,-1,-1}}},['ModPassives']={},['SkillInfos']={[2050301]={},[2050302]={}},['WeaponId']=20503,['GradeLevel']=0,['EnhanceLevel']=0}}}}"
	--local s = "{['AccessorySuit']={[3]=30003,[2]=10015}}"
	DebugPrint("Serialize", #s)
	local t = SerializeUtils:UnSerialize(s)
	local ts = SerializeUtils:Serialize(t, 9999999999)
	local tst = SerializeUtils:UnSerialize(ts)
	self.logger.debug("Serialize 3", tst)
	local tsts = SerializeUtils:Serialize(tst)
	self.logger.debug("Serialize", #tsts, SerializeUtils:Serialize(tst, 9999999999))
	local tstst = SerializeUtils:UnSerialize(tsts)
	DebugPrintTable(tstst)
end

function Avatar:QueryHotfix()
	local index = GWorld.HotfixDataIndex or 0
	self:CallServerMethod("QueryHotfix", index)
end

function Avatar:OnQueryHotfixSuccess(HotfixScript, HotfixIndex)
	self.logger.debug("OnQueryHotfixSuccess", HotfixScript, HotfixIndex)
	-- 执行热更
	local index = GWorld.HotfixDataIndex or 0
	if HotfixIndex and HotfixIndex > index then
		require("HotFix").ExecHotFix(HotfixIndex, HotfixScript)
		GWorld.HotfixDataIndex = HotfixIndex
	end
end

function Avatar:OnRefreshLogin(TimeOffset, TimeZone, IsNewAvatar)
	TimeUtils.SetTimeOffset(TimeOffset)
	TimeUtils.SetServerTimeZone(TimeZone)
	DebugPrint("Avatar：OnRefreshLogin | Call LoginSuccess")
	self:LoginSuccess()

	local HeroUSDKSubsystem = HeroUSDKSubsystem()
	if IsNewAvatar then
		HeroUSDKSubsystem:HeroSDKRoleCreate(HeroUSDKUtils.GenHeroHDCGameRoleInfo())
	end
end

function Avatar:OnRelayLogin(TimeOffset, TimeZone, IsNewAvatar)
	TimeUtils.SetTimeOffset(TimeOffset)
	TimeUtils.SetServerTimeZone(TimeZone)
	DebugPrint("Avatar：OnRelayLogin | Call LoginSuccess")
	self:LoginSuccess()
end

function Avatar:LoginSuccess()
	self:InitGameSetting()
	SystemGuideManager:InitCondition()
	local callback = function ()
		---Note：_OnLoginSuccess才能确保Avatar的属性同步完毕，但是_OnPropChange可能会比它更早执行
		self:_OnLoginSuccess()
		EventManager:FireEvent(EventID.OnLoginSuccess)
		GWorld.GameInstance:OnLoginSuccess()
	end
	local locaUselName = UE.UKismetSystemLibrary:GetPlatformUserName()
	self.logger.debug("LoginSuccess", GWorld.EnterMode, locaUselName)
	self:CallServer("OnLoginSuccess", callback, GWorld.EnterMode, locaUselName)
	if self.Hostnum == 399 then
		self:CallServerMethod("SetIp", UEMGameInstance.GetOuterIp())
	end
end

function Avatar:SA_LOG(log_type, event_name, infos)
	self:CallServerMethod("Client_SA_LOG", log_type, event_name, infos)
end

function Avatar:LeaveWorld()
	local BP_Avatar = GWorld.GameInstance:GetAvatar()
	if BP_Avatar then
		BP_Avatar:SetClientAvatar(nil)
	end
end

function Avatar:UseCDK(CDK,InCallback)
	local function Cb(ErrCode, Items)
		self.logger.debug("UseCDK", ErrorCode:Name(ErrCode),CommonUtils.TableToString(Items))
		if InCallback then
			InCallback(ErrCode, Items)
		end
	end
	self:CallServer("UseCDK",Cb, CDK)
end

function Avatar:RequestSetNowTime(NowTime)
	local function cb(ret, timestamp)
		if ret == ErrorCode.RET_SUCCESS then
			TimeUtils.OnRequestSetNowTime(timestamp)
		end
	end
	self:CallServer("RequestSetNowTime", cb, NowTime)
end

function Avatar:CheckTimeAcceleration()
	DebugPrint('CheckTimeAcceleration', TimeUtils.NowTime())
	self:CallServerMethod("CheckTimeAcceleration")
end
function Avatar:AceReceiveData(Data,Len)
	DebugPrint("AceReceiveData", Data, Len)
	local ACESubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UACESubsystem)
	if not ACESubsystem then
		return
	end
	local ByteTable = MiscUtils.StringToByteTable(Data)
	--GWorld.logger.debug("AceReceiveData", string.len(Data), CommonUtils.ToHex(Data))
	ACESubsystem:ReceivePacketFromServer(ByteTable)
end

function Avatar:QueryVersionControl(Callback)
	local function cb(Version)
		DebugPrint("QueryVersionControl", Version)
		if Callback then
			Callback(Version)
		end
	end

	self:CallServer("QueryVersionControl", cb)
end
------------------------------------- Props -------------------------------------
function Avatar:_OnPropChangeCurrentChar()
	self.NeedRefreshPlayer = true
end
function Avatar:OnEntityInitSuccess()
	DebugPrint("Avatar:OnEntityInitSuccess")
end
function Avatar:_OnPropChangeCurrentPet()
	self.NeedRefreshPlayer = true
	DebugPrint("Avatar:_OnPropChangeCurrentPet self.NeedRefreshPlayer:",self.NeedRefreshPlayer)
end

function Avatar:_OnPropChangePets(keys)
	self.NeedRefreshPlayer = true
	DebugPrint("Avatar:_OnPropChangePets",CommonUtils.TableToString(keys))
	-- if CommonUtils.Size(keys) ~= 2 then
	-- 	return 
	-- end
	-- local PetId = keys[1]
	-- if self.CurrentPet ~= PetId then
	-- 	return
	-- end
	-- local PropName = keys[2]
	-- if PropName == "BreakNum" then
	-- 	DebugPrint("Avatar:_OnPropChangePets self.NeedRefreshPlayer:",self.NeedRefreshPlayer)
	-- end
end
function Avatar:_OnPropChangeMeleeWeapon()
	self.NeedRefreshPlayer = true
end

function Avatar:_OnPropChangeRangedWeapon()
	self.NeedRefreshPlayer = true
end

function Avatar:_OnPropChangeLevel()
	local GameMode = UE.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if GameMode and GameMode:Cast(UE4.AEMGameMode) and GameMode:IsInRegion() then
		GameMode:UpdateRegionGameModeLevel()
	end
	for _,Info in pairs(DataMgr.PlayerLevelUp) do
		if Info.PlayerLevel <= self.Level and not self.LevelRewardsGot[Info.PlayerLevel] then
			local Node = ReddotManager.GetTreeNode("ExperienceItem")
            if not Node then
                ReddotManager.AddNode("ExperienceItem")
            end
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("ExperienceItem")
            if not CacheDetail[Info.PlayerLevel] then
                CacheDetail[Info.PlayerLevel] = 1
                ReddotManager.IncreaseLeafNodeCount("ExperienceItem")
            end
		end
    end
	EventManager:FireEvent(EventID.OnPlayerLevelUp)
end

function Avatar:_OnPropChangeMailUniqueID()
	EventManager:FireEvent(EventID.OnChangePropMailUniqueID)
end

function Avatar:_OnPropChangeActionPoint()
	EventManager:FireEvent(EventID.OnChangeActionPoint, CommonConst.ActionPoint)
end

function Avatar:_OnPropChangeChars(keys)
	self.NeedRefreshPlayer = true
	if CommonUtils.Size(keys) == 1 then
		local char = self.Chars[keys[1]]
		if char then
			char:_Init()
		end
	end
end
function Avatar:PrintServerLog(...)
	DebugPrint("Avatar:PrintServerLog", ...)	
end

function Avatar:_OnPropChangeCommonChars(keys)
	self.NeedRefreshPlayer = true
end

function Avatar:_OnPropChangeWeapons(keys)
	self.NeedRefreshPlayer = true
end

function Avatar:_OnPropChangeUWeapons(keys)
	self.NeedRefreshPlayer = true
end

function Avatar:_OnPropChangeMods(keys)
	self.NeedRefreshPlayer = true
end

function Avatar:ResetNeedRefreshPlayer()
	self.NeedRefreshPlayer = false
end

function Avatar:GetNeedRefreshPlayer()
	return self.NeedRefreshPlayer
end

function Avatar:_OnPropChangeResources(keys)
	if CommonUtils.Size(keys) == 1 then
		local ResourceId = keys[1]
		EventManager:FireEvent(EventID.OnPropSetResources,ResourceId)
	end
end

function Avatar:_OnPropChangeWheels(keys)
	EventManager:FireEvent(EventID.OnPropChangeWheels)
end

function Avatar:ResetOnReconnect()
end

------------------------------------- test -------------------------------------

function Avatar:ClientTest(...)
	self.logger.debug("ClientTest")
	local t = TimeUtils.NowTime()
	self.logger.debug(t)
	self.logger.debug(TimeUtils.TimestampToData(t))
	self.logger.debug(TimeUtils.TimeToStr(t))
	local function callback(result)
		PrintTable({result=result},3)
	end
	self:CallServer("ClientTest", callback)
end

function Avatar:CallbackTest()
	self.logger.debug("111111111111111111111 CallbackTest")
end


function Avatar:OnTestAutoBattle(ret, data, DSLog)
	print(_G.LogTag, "OnTestAutoBattle", ret, data, DSLog)
end

function Avatar:tt(GachaId)
	self:CallServerMethod("AddWalnut", 1000, 1)
	self:CallServerMethod("AddWalnut", 1001, 1)
	--self:GetGachaCumulativeReward(nil, tonumber(GachaId), -1)
end

function Avatar:SetHomeBaseBGM(BGMId)
	local function cb(ret)
		print(_G.LogTag,"SetHomeBaseBGM", ret)
	end
	self:CallServer("SetHomeBaseBGM", cb, BGMId)
end

function Avatar:SendToFeishuForBattle(msg, msg_title)
	self:CallServerMethod("SendToFeishuForBattle", msg, msg_title)
end

function Avatar:SendToFeishuForJQ(msg, msg_title)
	self:CallServerMethod("SendToFeishuForJQ", msg, msg_title)
end

function Avatar:SendToFeiShuForMonster(msg, msg_title)
	local LocalUser = UE.UKismetSystemLibrary:GetPlatformUserName()
	local res_msg = "设备名："..LocalUser.."\n"..msg
	self:CallServerMethod("SendToFeiShuForMonster", msg, msg_title)
end

function Avatar:SendToFeiShuForRegionMgr(msg, msg_title)
	self:CallServerMethod("SendToFeiShuForRegionMgr", msg, msg_title)
end

function Avatar:SendToFeishuForRougeLike(msg, msg_title)
	self:CallServerMethod("SendToFeishuForRougeLike", msg, msg_title)
end

function Avatar:SendToFeishuForCombatMonitor(msg)
	-- self:CallServerMethod("SendToFeishuForCombatMonitor", msg)
end

-- local trace_type = {
-- 	first = "剧情",
-- 	second = "第一章",
-- 	third = "其余分类",
-- }
-- local describe_info = {
-- 	title = "test_trace",
-- 	trace_content = "test_content"
-- }
---@param trace_type table
---@param describe_info table
function Avatar:SendTraceToQaWeb(trace_type, describe_info)
	self:CallServerMethod("SendTraceToQaWeb", trace_type, describe_info)
end

function Avatar:NotifyOpenCrashSight()
	print(_G.LogTag, "NotifyOpenCrashSight")
	local IsOpenCrashSight = EMCache:Get("IsOpenCrashSight")
	if not IsOpenCrashSight then
		EMCache:Set("IsOpenCrashSight",true)
		EMCache:SaveAll()
		if GWorld.GameInstance then
			GWorld.GameInstance:InitCrashSight()
		end
		
	end
end

function Avatar:SaveCreatePhantomInfo(RoleId, BTIndex, Info, ExtraInfo, Level)
	if not self.PhantomCreateInfo then
		self.PhantomCreateInfo = {}
	end
	if not self.PhantomCreateInfo[RoleId] then
		self.PhantomCreateInfo[RoleId] = {}
	end
	self.PhantomCreateInfo[RoleId].BTIndex = BTIndex
	self.PhantomCreateInfo[RoleId].Info = Info
	self.PhantomCreateInfo[RoleId].ExtraInfo = ExtraInfo
	self.PhantomCreateInfo[RoleId].Level = Level
end

function Avatar:ClearCreatePhantomInfo(PhantomRoleId)
	if not self.PhantomCreateInfo then
		return
	end
	if not self.PhantomCreateInfo[PhantomRoleId] then
		return
	end
	self.PhantomCreateInfo[PhantomRoleId] = nil
end


function Avatar:NotifyAppStoreRatingJump(IsShowGameRating)
	local PlatformName = MiscUtils:GetGameReviewPlatform()
	DebugPrint("NotifyAppStoreRatingJump Platform" , IsShowGameRating, PlatformName)	
	if not IsShowGameRating then
		if not HeroUSDKSubsystem():IsHeroSDKEnable() then
			DebugPrint("NotifyAppStoreRatingJump HeroUSDKSubsystem Is not Enable")	
			return
		end
		if PlatformName == "IOS" or PlatformName == "Google" then 
			HeroUSDKSubsystem():AppRatingWithType(0, "")
		elseif PlatformName == "TapTap" then
        	HeroUSDKSubsystem():AppRatingWithType(1, "")
		end
		return
	end
	if GWorld.GameInstance then
		local UIManager = GWorld.GameInstance:GetGameUIManager()
		UIManager:LoadUINew("GameReview")
	else 
		DebugPrint("NotifyAppStoreRatingJump GWorld.GameInstance is nil")	
	end
end

function Avatar:NeedOpenDigitalWatermark(Content)
	GWorld.bShouldShowWaterMark = true
	GWorld.WaterMarkContent = Content
	if GWorld.GameInstance then
		local UIManager = GWorld.GameInstance:GetGameUIManager()
		if UIManager then
			UIManager:ShowWaterMarkUI()
		end
	end
end

function Avatar:NeedCloseDigitalWatermark()
	GWorld.bShouldShowWaterMark = false
	GWorld.WaterMarkContent = nil
	if GWorld.GameInstance then
		local UIManager = GWorld.GameInstance:GetGameUIManager()
		if UIManager then
			UIManager:UnLoadUI("WaterMark")
		end
	end
end

function Avatar:SendClientLogToServer(Log)
	self:CallServerMethod("SendClientLogToServer", Log)
end

Assemble.AssembleComponents(Avatar)
Assemble.FormatProperties(Avatar)
return Avatar
