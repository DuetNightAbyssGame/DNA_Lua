-- RPCè°ƒç”¨è®°å½•æ–‡ä»¶ï¼ˆåªè¯»ï¼‰
-- è‡ªåŠ¨ç”Ÿæˆï¼Œè¯·å‹¿æ‰‹åŠ¨ç¼–è¾‘

local RPC_Cache = {
	[1] = {
		func_name = "RequestEnterOnline",
		Params = {104104, {MountInfo = {MountState = 0, MountId = 0}, UseMechanism = {UseState = 0, UniqueId = 0}, CurrentState = 3, ActionBaseInfo = {IsCrouching = 0, Rotation = {Yaw = 147.77391052246, Pitch = 0.0, Roll = 0.0}, ForceSyncLocation = 0, Location = {X = 6848.1118164062, Y = -9553.458984375, Z = 1601.1832275391}}, UseTargetParam = {}, WeaponInfo = {ShowWeapon = "Melee"}}}
	},
	[2] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {286, 104104, "B\4Move\26H8\1B\5\29al\26C\"\15\13\2ÑÕE\21`:\21Æ\29·\24ÈD-\0\0€E5\0\0úCR\4Move\
\
\13\4êfÅ\21<\
İDHüÆÈ\6Z\
\13\3¸+Ã\21?^¤B"}
	},
	[3] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {287, 104104, "B\4Move\26H8\1B\5\29al\26C\"\15\13ılÔE\21/å\20Æ\29ö¶ÇD-\0\0€E5\0\0úCR\4Move\
\
\13\4êfÅ\21<\
İDHüÆÈ\6Z\
\13”‚áÃ\21_ÛWC"}
	},
	[4] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {288, 104104, "B\4Move\26H8\1B\5\29al\26C\"\15\13\27ËÒE\0210\20Æ\29·\20ÇD-\0\0€E5\0\0úCR\4Move\
\
\13\4êfÅ\21<\
İDHüÆÈ\6Z\
\13\0‚áÃ\0215ÚWC"}
	},
	[5] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {289, 104104, "B\4Move\26H8\1B\5\29’\31\27C\"\15\13\9%ÑE\21Í\28\20Æ\29çiÆD-\0\0€E5\0\0úCR\4Move\
\
\13=?hÅ\21´a×DHüÆÈ\6Z\
\13³\
âÃ\21ëšUC"}
	},
	[6] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {290, 104104, "B\4Move\26H8\1B\5\29\0309\29C\"\15\13Ä´ÏE\21ŸÇ\19Æ\29<ãÅD-\0\0€E5\0\0úCR\4Move\
\
\13q\9lÅ\21Ê7ÆDHıÆÈ\6Z\
\13ìÅãÃ\21ø\23NC"}
	},
	[7] = {
		func_name = "UpdateAndSavePlayerInfo",
		Params = {291, 104104, 104104, {X = 6808.2319335938, Y = -9534.373046875, Z = 1598.4456787109}, {Yaw = 157.22311401367, Pitch = 0.0, Roll = 0.0}}
	},
	[8] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {292, 104104, "B\4Move\26H8\1B\5\29£\5'C\"\15\13E\11ÎE\21 t\19Æ\29\0167ÅD-\0\0€E5\0\0úCR\4Move\
\
\13ÿuyÅ\21\18÷eDHıÆÈ\6Z\
\13z‰ìÃ\21ºà!C"}
	},
	[9] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {293, 104104, "B\6Action\
PÈ\1ıÆÈ\6ª\1\5\13\0\0€?à\1\1Ú\1\6Action\
\24\"\5\0294?(C\26\15\13E\11ÎE\21 t\19Æ\29\0167ÅDº\1\
\13\3¢z¿\21\13•P>B\12DodgeFeature"}
	},
	[10] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {294, 104104, "B\4Move\26H8\1B\5\0294?(C\"\15\13©¨ÊE\21\12\19\19Æ\29\26âÃD-\0\0€E5\0\0úCR\4Move\
\
\13ø¡|Å\21DŠ%DHıÆÈ\6Z\
\13¶DêÄ\21ÌöÂC"}
	},
	[11] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {295, 104104, "B\4Move\26H8\1B\5\0294?(C\"\15\13|?ÁE\21n\24\18Æ\29¼ÂD-\0\0€E5\0\0úCR\4Move\
\
\0134<}Å\21#\23\22DHıÆÈ\6Z\
\13ˆBÍÄ\21&ĞªC"}
	},
	[12] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {296, 104104, "B\4Move\26H8\1B\5\0294?(C\"\15\13›Æ¼E\21V¡\17Æ\29±ùÁD-\0\0€E5\0\0úCR\4Move\
\
\0134<}Å\21#\23\22DHıÆÈ\6Z\
\13\9¼Ä\21š\24„C"}
	},
	[13] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {297, 104104, "B\6Action\
jˆ\1\1\
\24\"\5\0294?(C\26\15\0134y¹E\21dI\17Æ\29\23*ÁDB\17NormalJumpFeature0\1à\1\1È\1ıÆÈ\6Ú\1\6Action*\15\29\0€´C\13\0€´C\21\0€´C’\1\15\13[H\\Ä\21ÙS7C\29\0\0zD\"\0"}
	},
	[14] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {298, 104104, "B\4Move\26M8\3B\5\29S’+C\"\15\13I&¸E\21£&\17Æ\29aÆÆD-\0\0€E5\0\0úCR\4Move\
\
\0134<}Å\21#\23\22DHıÆÈ\6Z\15\13†Š\\Ä\21cI2C\29M\9YD"}
	},
	[15] = {
		func_name = "UpdateRegionActorData",
		Params = {299, "BD75F54A4560446F0C86078BEDFC3DF6", 104104, 3, {IsActive = false, OpenState = false, StateId = 701001, CanOpen = true}, "Huaxu_Yanjindu_Art_0908BigObjs"}
	},
	[16] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {300, 104104, "B\4Move\26M8\3B\5\29S’+C\"\15\13f\5µE\0213Ø\16Æ\0294ßĞD-\0\0€E5\0\0aDR\4Move\
\
\0134<}Å\21#\23\22DHıÆÈ\6Z\15\13\
]Ä\21`\20(C\29uG\11D"}
	},
	[17] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {301, 104104, "B\4Move\26M8\3B\5\29S’+C\"\15\13nÆ±E\21N‹\16Æ\29Û®ÖD-\0\0€E5\0\0aDR\4Move\
\
\0134<}Å\21#\23\22DHıÆÈ\6Z\15\13l]Ä\21‡Ñ\31C\29s\11kC"}
	},
	[18] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {302, 104104, "B\4Move\26M8\3B\5\29S’+C\"\15\13\11s®E\21)@\16Æ\29\2\27ØD-\0\0€E5\0\0aDR\4Move\
\
\0134<}Å\21#\23\22DHıÆÈ\6Z\15\13¦µ]Ä\21ÜZ\25C\29«TıÀ"}
	},
	[19] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {303, 104104, "B\4Move\26M8\3B\5\29S’+C\"\15\13&-«E\21öø\15Æ\29_µÖD-\0\0€E5\0\0úCR\4Move\
\
\0134<}Å\21#\23\22DHşÆÈ\6Z\15\13Ië]Ä\21Lm\20C\29ƒp5Ã"}
	},
	[20] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {304, 104104, "B\4Move\02698\3B\5\29S’+C\"\15\13&-«E\21öø\15Æ\29ËşÂD-\0\0€E5\0\0úCR\4Move\
\0HşÆÈ\6Z\5\29<”hÄ"}
	},
	[21] = {
		func_name = "UploadPlayerOnlineClientMessage",
		Params = {305, 104104, "B\4Move\02648\1B\5\29S’+C\"\15\13\5+«E\21Îø\15Æ\29„‚¾D-\0\0€E5\0\0úCR\4Move\
\0HşÆÈ\6Z\0"}
	},
	[22] = {
		func_name = "UpdateAndSavePlayerInfo",
		Params = {306, 104104, 104104, {X = 5477.3774414062, Y = -9214.201171875, Z = 1524.0786132812}, {Yaw = 171.57157897949, Pitch = 0.0, Roll = 0.0}}
	},
	[23] = {
		func_name = "RequestLeaveOnline",
		Params = {104104}
	},
}

return RPC_Cache
