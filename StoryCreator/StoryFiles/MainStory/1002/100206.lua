return {
	["storyName"] = "军团会议室",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "174228308433310206319",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206320",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206320",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206321",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206321",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206322",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206323",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206324",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206325",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206326",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206322",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206323",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206324",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206331",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206331",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206330",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206330",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206325",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206327",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206317",
			["endPort"] = "StoryEnd"
		},
		{
			["startStory"] = "174228308433310206326",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206327",
			["endPort"] = "In"
		},
		{
			["startStory"] = "174228308433310206316",
			["startPort"] = "StoryStart",
			["endStory"] = "17548930632194490",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17548930632194490",
			["startPort"] = "Success",
			["endStory"] = "17549800420471825479",
			["endPort"] = "In"
		},
		{
			["startStory"] = "17549800420471825479",
			["startPort"] = "Success",
			["endStory"] = "174228308433310206319",
			["endPort"] = "In"
		}
	},
	["storyNodeData"] = {
		["174228308433310206316"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206316",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = -704.2315140265073,
				["y"] = 387.95016641168456
			},
			["propsData"] = {
				["QuestChainId"] = 100206
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["174228308433310206317"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206317",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 1163.1686552819142,
				["y"] = 1032.561002860479
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["174228308433310206318"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206318",
			["type"] = "StoryNode",
			["name"] = "前往疗养院找小白",
			["pos"] = {
				["x"] = -398.20003070734555,
				["y"] = 89.74688840069132
			},
			["propsData"] = {
				["QuestId"] = 10020601,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020601",
				["QuestDeatil"] = "QuestDesc_10020601",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = true,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433310206335",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206336",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206334",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206332",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206332",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206333",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206333",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206340",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206340",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206335",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206337",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433310206341",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206341",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206342",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206345",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206359",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206355",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206364",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206364",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206365",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206333",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206343",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206355",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206358",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206337",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433310206367",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206376",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206377",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206376",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206378",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206376",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206379",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206378",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206381",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206384",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206386",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206386",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206415",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206422",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206420",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206422",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206423",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206423",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206424",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206434",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206440",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206450",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206451",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206424",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206450",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206424",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206449",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206451",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206338",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17431632209401577934",
						["startPort"] = "Out",
						["endQuest"] = "1743163176885793438",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1743163176885793438",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206345",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206375",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206376",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206434",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206433",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206440",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206433",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "174228308433410206440",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206441",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206440",
						["startPort"] = "Out",
						["endQuest"] = "17433228782203144988",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17433228782203144988",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206375",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17433228782203144988",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206441",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "174228308433310206341",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206334",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206366",
						["startPort"] = "Out",
						["endQuest"] = "17431638329073147879",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206375",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206357",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206378",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206382",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206381",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206379",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "174228308433310206381",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206384",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206381",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206389",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206421",
						["startPort"] = "Out",
						["endQuest"] = "174333073449216483666",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174333073449216483666",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206419",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174333073449216483666",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206422",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206355",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206362",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17431638329073147879",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206437",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206333",
						["startPort"] = "Out",
						["endQuest"] = "174333298919123283837",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174333298919123283837",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206355",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206345",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206368",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434025799083151247",
						["startPort"] = "Out",
						["endQuest"] = "17434025021573150755",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17434025799083151247",
						["startPort"] = "Out",
						["endQuest"] = "17434026995493936174",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434026995493936174",
						["startPort"] = "Out",
						["endQuest"] = "17434027019733936221",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434026995493936174",
						["startPort"] = "Out",
						["endQuest"] = "17434026339033151572",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "174228308433310206355",
						["startPort"] = "Out",
						["endQuest"] = "17434025799083151247",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206355",
						["startPort"] = "Out",
						["endQuest"] = "17434025021573150755",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434025799083151247",
						["startPort"] = "Out",
						["endQuest"] = "17434026339033151572",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434026995493936174",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206344",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206344",
						["startPort"] = "Out",
						["endQuest"] = "17434028495813937825",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17434028495813937825",
						["startPort"] = "Out",
						["endQuest"] = "17431632209401577934",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434034883354723100",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206368",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "174228308433310206345",
						["startPort"] = "Out",
						["endQuest"] = "17434034883354723100",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434034883354723100",
						["startPort"] = "Out",
						["endQuest"] = "17434035627214723758",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434035627214723758",
						["startPort"] = "Out",
						["endQuest"] = "17434035092904723431",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17434034883354723100",
						["startPort"] = "Out",
						["endQuest"] = "17434035092904723431",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434035627214723758",
						["startPort"] = "Out",
						["endQuest"] = "17434035860335508400",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434035860335508400",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206374",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206426",
						["startPort"] = "Out",
						["endQuest"] = "17434036278645508800",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "17434036278645508800",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206366",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434036278645508800",
						["startPort"] = "Out",
						["endQuest"] = "17433242071344713703",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434036278645508800",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206434",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434035627214723758",
						["startPort"] = "Out",
						["endQuest"] = "17434037314346294086",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434027019733936221",
						["startPort"] = "Out",
						["endQuest"] = "174333099458418052222",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434026995493936174",
						["startPort"] = "Out",
						["endQuest"] = "17434038691477864086",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174333099458418052222",
						["startPort"] = "Out",
						["endQuest"] = "17434028495813937825",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "17434028495813937825",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206346",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434035627214723758",
						["startPort"] = "Out",
						["endQuest"] = "17434212475307581366",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434035860335508400",
						["startPort"] = "Out",
						["endQuest"] = "17434212475307581366",
						["endPort"] = "Stop"
					},
					{
						["startQuest"] = "17434035860335508400",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206426",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206424",
						["startPort"] = "Out",
						["endQuest"] = "174351885508522786",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206333",
						["startPort"] = "Out",
						["endQuest"] = "17468732882993717717",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206381",
						["startPort"] = "Out",
						["endQuest"] = "1747214511106883637",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433310206341",
						["startPort"] = "Out",
						["endQuest"] = "1747214463721883321",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17477494242142607245",
						["startPort"] = "Out",
						["endQuest"] = "174228308433310206339",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17477510114547790170",
						["startPort"] = "Out",
						["endQuest"] = "17422816895915570931",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17422816895915570931"] = {
						["key"] = "17422816895915570931",
						["type"] = "SendMessageNode",
						["name"] = "reset",
						["pos"] = {
							["x"] = 1511.1315331092421,
							["y"] = 1332.3808788692904
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_EnlikeReset",
							["UnitId"] = -1
						}
					},
					["174228308433310206332"] = {
						["key"] = "174228308433310206332",
						["type"] = "GoToNode",
						["name"] = "goto 疗养院隐蔽处",
						["pos"] = {
							["x"] = -727.4730518744128,
							["y"] = 230.9957340188795
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190205,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190205"
						}
					},
					["174228308433310206333"] = {
						["key"] = "174228308433310206333",
						["type"] = "TalkNode",
						["name"] = "小白在等你",
						["pos"] = {
							["x"] = -480.08308425532425,
							["y"] = 225.6027384569225
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108501,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101085",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200064,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433310206334"] = {
						["key"] = "174228308433310206334",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 小白",
						["pos"] = {
							["x"] = -954.1530221367971,
							["y"] = 244.41772260068566
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190280
							}
						}
					},
					["174228308433310206335"] = {
						["key"] = "174228308433310206335",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 小白",
						["pos"] = {
							["x"] = -481.29242186491706,
							["y"] = 479.5624651633069
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190280
							}
						}
					},
					["174228308433310206336"] = {
						["key"] = "174228308433310206336",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 奥哥",
						["pos"] = {
							["x"] = -477.50985400628326,
							["y"] = 583.2156126681784
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190281
							}
						}
					},
					["174228308433310206337"] = {
						["key"] = "174228308433310206337",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -1508.8262571157493,
							["y"] = 229.93989563567362
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433310206338"] = {
						["key"] = "174228308433310206338",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 6102.064148031995,
							["y"] = 253.9384081844932
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433310206339"] = {
						["key"] = "174228308433310206339",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1670.5433755082768,
							["y"] = 1204.6910072954345
						},
						["propsData"] = {}
					},
					["174228308433310206340"] = {
						["key"] = "174228308433310206340",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停幽默音乐",
						["pos"] = {
							["x"] = -488.8167141061149,
							["y"] = 372.8488136924232
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["174228308433310206341"] = {
						["key"] = "174228308433310206341",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖城",
						["pos"] = {
							["x"] = -1215.3353489184628,
							["y"] = 224.346571172434
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					},
					["174228308433310206342"] = {
						["key"] = "174228308433310206342",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = -929.9119130297627,
							["y"] = 55.50256619810418
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["174228308433310206343"] = {
						["key"] = "174228308433310206343",
						["type"] = "SendMessageNode",
						["name"] = "恩里克走到一半停住",
						["pos"] = {
							["x"] = -484.9132511653102,
							["y"] = 111.23400382988481
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike1",
							["UnitId"] = -1
						}
					},
					["174228308433310206344"] = {
						["key"] = "174228308433310206344",
						["type"] = "GoToNode",
						["name"] = "躲箱子后面",
						["pos"] = {
							["x"] = 310.2547289453946,
							["y"] = 216.7663395711988
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190909,
							["GuideType"] = "P",
							["GuidePointName"] = "P_1190909"
						}
					},
					["174228308433310206345"] = {
						["key"] = "174228308433310206345",
						["type"] = "GoToNode",
						["name"] = "去台阶上方",
						["pos"] = {
							["x"] = 1063.6695180494419,
							["y"] = 204.49241434893617
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190911,
							["GuideType"] = "P",
							["GuidePointName"] = "P_1190911"
						}
					},
					["174228308433310206346"] = {
						["key"] = "174228308433310206346",
						["type"] = "SendMessageNode",
						["name"] = "恩里克等待2",
						["pos"] = {
							["x"] = 559.3653309717356,
							["y"] = 73.7039098455751
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike2",
							["UnitId"] = -1
						}
					},
					["174228308433310206355"] = {
						["key"] = "174228308433310206355",
						["type"] = "GoToNode",
						["name"] = "看到恩里克",
						["pos"] = {
							["x"] = -212.36674544346374,
							["y"] = 212.23177061026186
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190910,
							["GuideType"] = "P",
							["GuidePointName"] = "P_1190910"
						}
					},
					["174228308433310206357"] = {
						["key"] = "174228308433310206357",
						["type"] = "SendMessageNode",
						["name"] = "恩里克开始走3",
						["pos"] = {
							["x"] = 2782.9149511918135,
							["y"] = 379.35096421858566
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike3",
							["UnitId"] = -1
						}
					},
					["174228308433310206358"] = {
						["key"] = "174228308433310206358",
						["type"] = "SendMessageNode",
						["name"] = "恩里克继续走",
						["pos"] = {
							["x"] = -210.25411353352578,
							["y"] = 108.29622583299096
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike1_1",
							["UnitId"] = -1
						}
					},
					["174228308433310206359"] = {
						["key"] = "174228308433310206359",
						["type"] = "SendMessageNode",
						["name"] = "恩里克等待2_1",
						["pos"] = {
							["x"] = 1067.2407778941426,
							["y"] = 88.9748422993751
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike2_1",
							["UnitId"] = -1
						}
					},
					["174228308433310206362"] = {
						["key"] = "174228308433310206362",
						["type"] = "TalkNode",
						["name"] = "快跟上",
						["pos"] = {
							["x"] = -221.53382664507996,
							["y"] = -217.47731790091126
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433310206364"] = {
						["key"] = "174228308433310206364",
						["type"] = "CameraLookAtNode",
						["name"] = "看恩里克",
						["pos"] = {
							["x"] = -206.50391520244472,
							["y"] = 345.8474025974027
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "P_1190910",
							["ActorId"] = 0,
							["Duration"] = 0.5,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = false
						}
					},
					["174228308433310206365"] = {
						["key"] = "174228308433310206365",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "禁用跑跳和技能",
						["pos"] = {
							["x"] = -200.4324866310161,
							["y"] = 480.1331168831169
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = false,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"BulletJump",
								"Avoid"
							}
						}
					},
					["174228308433310206366"] = {
						["key"] = "174228308433310206366",
						["type"] = "CameraLookAtNode",
						["name"] = "看恩里克",
						["pos"] = {
							["x"] = 1650.701478308227,
							["y"] = 70.01714725909812
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "P1190935",
							["ActorId"] = 0,
							["Duration"] = 0.75,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["174228308433310206367"] = {
						["key"] = "174228308433310206367",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "激活跑跳和技能",
						["pos"] = {
							["x"] = -1213.5210604959807,
							["y"] = 78.30243275400267
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Avoid",
								"Jump",
								"BulletJump"
							}
						}
					},
					["174228308433310206368"] = {
						["key"] = "174228308433310206368",
						["type"] = "GoToNode",
						["name"] = "去台阶下方",
						["pos"] = {
							["x"] = 1352.8006748686098,
							["y"] = 614.5533026755852
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190916,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1190916"
						}
					},
					["174228308433310206370"] = {
						["key"] = "174228308433310206370",
						["type"] = "TalkNode",
						["name"] = "你到底要去哪里",
						["pos"] = {
							["x"] = 1158.195754915583,
							["y"] = -144.82834406972336
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20007501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433310206372"] = {
						["key"] = "174228308433310206372",
						["type"] = "TalkNode",
						["name"] = "怎么停下了",
						["pos"] = {
							["x"] = 1561.7248189549912,
							["y"] = -218.57815460401665
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20007601,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433310206374"] = {
						["key"] = "174228308433310206374",
						["type"] = "TalkNode",
						["name"] = "慢慢走",
						["pos"] = {
							["x"] = 2154.0792287693157,
							["y"] = 596.6079528230392
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123501,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433310206375"] = {
						["key"] = "174228308433310206375",
						["type"] = "GoToNode",
						["name"] = "去车后面",
						["pos"] = {
							["x"] = 2786.4358198647933,
							["y"] = 224.4630459495528
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190915,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1190915"
						}
					},
					["174228308433310206376"] = {
						["key"] = "174228308433310206376",
						["type"] = "GoToNode",
						["name"] = "去台阶上",
						["pos"] = {
							["x"] = 3125.3797997979036,
							["y"] = 230.98720053892478
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190917,
							["GuideType"] = "P",
							["GuidePointName"] = "P_119091701"
						}
					},
					["174228308433310206377"] = {
						["key"] = "174228308433310206377",
						["type"] = "CameraLookAtNode",
						["name"] = "看恩里克",
						["pos"] = {
							["x"] = 3288.1575775756814,
							["y"] = 394.87608942781367
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "P_119091702",
							["ActorId"] = 0,
							["Duration"] = 0.5,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = false
						}
					},
					["174228308433310206378"] = {
						["key"] = "174228308433310206378",
						["type"] = "SendMessageNode",
						["name"] = "恩里克开始走3",
						["pos"] = {
							["x"] = 3282.6580553587687,
							["y"] = 116.88695899303106
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike3_1",
							["UnitId"] = -1
						}
					},
					["174228308433310206379"] = {
						["key"] = "174228308433310206379",
						["type"] = "GoToNode",
						["name"] = "去告示牌后面",
						["pos"] = {
							["x"] = 3498.0614237295276,
							["y"] = 243.04916635089066
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190918,
							["GuideType"] = "P",
							["GuidePointName"] = "P_1190918"
						}
					},
					["174228308433310206381"] = {
						["key"] = "174228308433310206381",
						["type"] = "WaitOfTimeNode",
						["name"] = "等16S",
						["pos"] = {
							["x"] = 3510.1020220201253,
							["y"] = 112.09831165003587
						},
						["propsData"] = {
							["WaitTime"] = 16
						}
					},
					["174228308433310206382"] = {
						["key"] = "174228308433310206382",
						["type"] = "TalkNode",
						["name"] = "那家店是……",
						["pos"] = {
							["x"] = 3285.4866374047415,
							["y"] = -21.833312281588068
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123801,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433310206384"] = {
						["key"] = "174228308433310206384",
						["type"] = "GoToNode",
						["name"] = "去上面",
						["pos"] = {
							["x"] = 3859.290056208159,
							["y"] = 250.98720053892487
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190913,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1190913"
						}
					},
					["174228308433310206386"] = {
						["key"] = "174228308433310206386",
						["type"] = "GoToNode",
						["name"] = "坐下",
						["pos"] = {
							["x"] = 4078.480635743567,
							["y"] = 257.2010633045117
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190914,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1190914"
						}
					},
					["174228308433310206389"] = {
						["key"] = "174228308433310206389",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "激活跑跳和技能",
						["pos"] = {
							["x"] = 3830.0612610042353,
							["y"] = 130.02957477305296
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Avoid",
								"BulletJump"
							}
						}
					},
					["174228308433410206415"] = {
						["key"] = "174228308433410206415",
						["type"] = "WaitOfTimeNode",
						["name"] = "等1.5s",
						["pos"] = {
							["x"] = 4301.497161679953,
							["y"] = 272.7270840827023
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					},
					["174228308433410206416"] = {
						["key"] = "174228308433410206416",
						["type"] = "SendMessageNode",
						["name"] = "恩里克4",
						["pos"] = {
							["x"] = 4497.2808607395145,
							["y"] = 146.66125336169915
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike4",
							["UnitId"] = -1
						}
					},
					["174228308433410206419"] = {
						["key"] = "174228308433410206419",
						["type"] = "TalkNode",
						["name"] = "你们两个",
						["pos"] = {
							["x"] = 4938.104268859747,
							["y"] = 265.6627024461713
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123901,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206420"] = {
						["key"] = "174228308433410206420",
						["type"] = "CameraLookAtNode",
						["name"] = "看向少年",
						["pos"] = {
							["x"] = 5158.9682074786715,
							["y"] = 281.02617365174495
						},
						["propsData"] = {
							["TargetType"] = "Actor",
							["PointName"] = "",
							["ActorId"] = 1190928,
							["Duration"] = 1.5,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["174228308433410206421"] = {
						["key"] = "174228308433410206421",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成少年",
						["pos"] = {
							["x"] = 4711.412020866097,
							["y"] = 423.4440235503251
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190928
							}
						}
					},
					["174228308433410206422"] = {
						["key"] = "174228308433410206422",
						["type"] = "WaitOfTimeNode",
						["name"] = "等2S",
						["pos"] = {
							["x"] = 5162.872467113561,
							["y"] = 428.3353014407916
						},
						["propsData"] = {
							["WaitTime"] = 4
						}
					},
					["174228308433410206423"] = {
						["key"] = "174228308433410206423",
						["type"] = "WaitOfTimeNode",
						["name"] = "等2S",
						["pos"] = {
							["x"] = 5387.4152663022005,
							["y"] = 422.3085265929215
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["174228308433410206424"] = {
						["key"] = "174228308433410206424",
						["type"] = "TalkNode",
						["name"] = "文明城市",
						["pos"] = {
							["x"] = 5379.176936131422,
							["y"] = 264.261467769392
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123903,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200087",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200019,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206426"] = {
						["key"] = "174228308433410206426",
						["type"] = "GoToNode",
						["name"] = "去机器人身边",
						["pos"] = {
							["x"] = 1403.813007371138,
							["y"] = 229.21326760354455
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190932,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1190932"
						}
					},
					["174228308433410206433"] = {
						["key"] = "174228308433410206433",
						["type"] = "GoToNode",
						["name"] = "跟上恩里克",
						["pos"] = {
							["x"] = 2307.9715184666634,
							["y"] = 239.42695142451683
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190935,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1190935"
						}
					},
					["174228308433410206434"] = {
						["key"] = "174228308433410206434",
						["type"] = "WaitOfTimeNode",
						["name"] = "等25s",
						["pos"] = {
							["x"] = 2001.083744404978,
							["y"] = 231.96021043603656
						},
						["propsData"] = {
							["WaitTime"] = 25
						}
					},
					["174228308433410206437"] = {
						["key"] = "174228308433410206437",
						["type"] = "TalkNode",
						["name"] = "跟上去",
						["pos"] = {
							["x"] = 1985.3260719515597,
							["y"] = -149.71351204825652
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123701,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206440"] = {
						["key"] = "174228308433410206440",
						["type"] = "WaitOfTimeNode",
						["name"] = "等19S",
						["pos"] = {
							["x"] = 2294.2780496768746,
							["y"] = 102.69637138672303
						},
						["propsData"] = {
							["WaitTime"] = 19
						}
					},
					["174228308433410206441"] = {
						["key"] = "174228308433410206441",
						["type"] = "GoToNode",
						["name"] = "跟上恩里克",
						["pos"] = {
							["x"] = 2547.9012380826707,
							["y"] = 229.84612984082924
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190936,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1190936"
						}
					},
					["174228308433410206449"] = {
						["key"] = "174228308433410206449",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成赛琪母亲",
						["pos"] = {
							["x"] = 5646.579172061841,
							["y"] = 387.03942342487244
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190931
							}
						}
					},
					["174228308433410206450"] = {
						["key"] = "174228308433410206450",
						["type"] = "TalkNode",
						["name"] = "那位女士",
						["pos"] = {
							["x"] = 5646.579172061841,
							["y"] = 242.33354107193125
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123906,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206451"] = {
						["key"] = "174228308433410206451",
						["type"] = "TalkNode",
						["name"] = "恩里克去哪边了？",
						["pos"] = {
							["x"] = 5882.340861352943,
							["y"] = 245.6817288318837
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 200073,
							["GuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_SaiqiMother_1190931",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10124001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = false,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17428845450741317888"] = {
						["key"] = "17428845450741317888",
						["type"] = "TalkNode",
						["name"] = "狩猎后开车",
						["pos"] = {
							["x"] = -1229.2384967965243,
							["y"] = 740.9107142857143
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1743163176885793438"] = {
						["key"] = "1743163176885793438",
						["type"] = "TalkNode",
						["name"] = "看恩里克",
						["pos"] = {
							["x"] = 816.6113163201196,
							["y"] = 210.90109890109875
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10129301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101293",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "101293Nvzhu1",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17431632209401577934"] = {
						["key"] = "17431632209401577934",
						["type"] = "CameraLookAtNode",
						["name"] = "CameraLookAt",
						["pos"] = {
							["x"] = 804.8507048507048,
							["y"] = 352.4612054612055
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "101293LookAt1",
							["ActorId"] = 0,
							["Duration"] = 1,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["17431638329073147879"] = {
						["key"] = "17431638329073147879",
						["type"] = "TalkNode",
						["name"] = "看恩里克",
						["pos"] = {
							["x"] = 1990.349687443115,
							["y"] = 73.42140796243987
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10129401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101294",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1.5,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "P101294Nvzhu1",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17433228782203144988"] = {
						["key"] = "17433228782203144988",
						["type"] = "WaitOfTimeNode",
						["name"] = "等10S",
						["pos"] = {
							["x"] = 2569.393917503204,
							["y"] = 98.64909801241006
						},
						["propsData"] = {
							["WaitTime"] = 10
						}
					},
					["17433242071344713703"] = {
						["key"] = "17433242071344713703",
						["type"] = "SendMessageNode",
						["name"] = "恩里克开始走2_2",
						["pos"] = {
							["x"] = 1625.8317756220972,
							["y"] = -83.89735509719851
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike2_2",
							["UnitId"] = -1
						}
					},
					["174332941087812297149"] = {
						["key"] = "174332941087812297149",
						["type"] = "SendMessageNode",
						["name"] = "恩里克4",
						["pos"] = {
							["x"] = 4749.753647214855,
							["y"] = 148.90109890109895
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_FollowEnlike4_1",
							["UnitId"] = -1
						}
					},
					["174333073449216483666"] = {
						["key"] = "174333073449216483666",
						["type"] = "WaitOfTimeNode",
						["name"] = "等2S",
						["pos"] = {
							["x"] = 4946.799999999999,
							["y"] = 422.1250000000001
						},
						["propsData"] = {
							["WaitTime"] = 2
						}
					},
					["174333099458418052222"] = {
						["key"] = "174333099458418052222",
						["type"] = "TalkNode",
						["name"] = "躲一下",
						["pos"] = {
							["x"] = 816.2324675324675,
							["y"] = 662.0920329670331
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123601,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174333298919123283837"] = {
						["key"] = "174333298919123283837",
						["type"] = "GoToNode",
						["name"] = "找恩里克",
						["pos"] = {
							["x"] = -322.7548012931603,
							["y"] = 670.6428571428571
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191290,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QusetCheck_1191290"
						}
					},
					["17434025021573150755"] = {
						["key"] = "17434025021573150755",
						["type"] = "GoToNode",
						["name"] = "躲车后面",
						["pos"] = {
							["x"] = 88.49639085544995,
							["y"] = 793.8184904094346
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191291,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QusetCheck_1191291"
						}
					},
					["17434025799083151247"] = {
						["key"] = "17434025799083151247",
						["type"] = "WaitOfTimeNode",
						["name"] = "等6.5S",
						["pos"] = {
							["x"] = 84.67030389892805,
							["y"] = 668.2097947572606
						},
						["propsData"] = {
							["WaitTime"] = 6.5
						}
					},
					["17434026339033151572"] = {
						["key"] = "17434026339033151572",
						["type"] = "GoToNode",
						["name"] = "继续躲",
						["pos"] = {
							["x"] = 344.1485647684935,
							["y"] = 788.6010991050869
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191292,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QusetCheck_1191292"
						}
					},
					["17434026995493936174"] = {
						["key"] = "17434026995493936174",
						["type"] = "WaitOfTimeNode",
						["name"] = "等6.5S",
						["pos"] = {
							["x"] = 338.9311734641457,
							["y"] = 676.4271860616086
						},
						["propsData"] = {
							["WaitTime"] = 6.5
						}
					},
					["17434027019733936221"] = {
						["key"] = "17434027019733936221",
						["type"] = "WaitOfTimeNode",
						["name"] = "等12s",
						["pos"] = {
							["x"] = 584.9189899954407,
							["y"] = 667.8270905049912
						},
						["propsData"] = {
							["WaitTime"] = 12
						}
					},
					["17434028495813937825"] = {
						["key"] = "17434028495813937825",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "玩家和恩里克都到位",
						["pos"] = {
							["x"] = 558.6713623211822,
							["y"] = 209.34602265979265
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					},
					["17434034883354723100"] = {
						["key"] = "17434034883354723100",
						["type"] = "WaitOfTimeNode",
						["name"] = "等10S",
						["pos"] = {
							["x"] = 1355.041554628875,
							["y"] = 489.00948419825437
						},
						["propsData"] = {
							["WaitTime"] = 10
						}
					},
					["17434035092904723431"] = {
						["key"] = "17434035092904723431",
						["type"] = "GoToNode",
						["name"] = "去菜摊子前面",
						["pos"] = {
							["x"] = 1606.7379832003037,
							["y"] = 624.143412769683
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191293,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1191293"
						}
					},
					["17434035627214723758"] = {
						["key"] = "17434035627214723758",
						["type"] = "WaitOfTimeNode",
						["name"] = "等10S",
						["pos"] = {
							["x"] = 1591.604054628875,
							["y"] = 479.63448419825437
						},
						["propsData"] = {
							["WaitTime"] = 10
						}
					},
					["17434035860335508400"] = {
						["key"] = "17434035860335508400",
						["type"] = "WaitOfTimeNode",
						["name"] = "等15.4s",
						["pos"] = {
							["x"] = 1859.7290546288755,
							["y"] = 472.1344841982545
						},
						["propsData"] = {
							["WaitTime"] = 15.4
						}
					},
					["17434036278645508800"] = {
						["key"] = "17434036278645508800",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "玩家和恩里克都到位",
						["pos"] = {
							["x"] = 1658.9254832003032,
							["y"] = 213.92019848396848
						},
						["propsData"] = {
							["ListenCount"] = 1,
							["NeedFinishCount"] = 1
						}
					},
					["17434037314346294086"] = {
						["key"] = "17434037314346294086",
						["type"] = "TalkNode",
						["name"] = "这玩意又坏了？",
						["pos"] = {
							["x"] = 1592.675483200303,
							["y"] = 744.4112699125403
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123602,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17434038691477864086"] = {
						["key"] = "17434038691477864086",
						["type"] = "TalkNode",
						["name"] = "接货的怎么还不来",
						["pos"] = {
							["x"] = 595.1754832003028,
							["y"] = 792.6255556268261
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123201,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["17434212475307581366"] = {
						["key"] = "17434212475307581366",
						["type"] = "GoToNode",
						["name"] = "去咖啡厅前面",
						["pos"] = {
							["x"] = 1888.1163978967659,
							["y"] = 618.0834630966517
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191294,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_1191294"
						}
					},
					["174351885508522786"] = {
						["key"] = "174351885508522786",
						["type"] = "SendMessageNode",
						["name"] = "reset",
						["pos"] = {
							["x"] = 5611.714285714286,
							["y"] = 650.5714285714286
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_IcelakeCity_EnlikeReset",
							["UnitId"] = -1
						}
					},
					["17468732882993717717"] = {
						["key"] = "17468732882993717717",
						["type"] = "UpdateTaskBarAndTaskMainNode",
						["name"] = "更新任务目标",
						["pos"] = {
							["x"] = -326.49999999999994,
							["y"] = 837.625
						},
						["propsData"] = {
							["NewDescription"] = "QuestName_10020602",
							["NewDetail"] = "QuestDesc_10020602",
							["SubTaskTargetIndex"] = 0
						}
					},
					["1747214463721883321"] = {
						["key"] = "1747214463721883321",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "花店开门",
						["pos"] = {
							["x"] = -997.4555626598465,
							["y"] = 382.67391304347825
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {},
							["ManualItemIdList"] = {
								119002
							},
							["StateId"] = 26,
							["QuestId"] = 0
						}
					},
					["1747214511106883637"] = {
						["key"] = "1747214511106883637",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "花店关门",
						["pos"] = {
							["x"] = 3801.988153594772,
							["y"] = -5.4122807017547565
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {},
							["ManualItemIdList"] = {
								119002
							},
							["StateId"] = 2513,
							["QuestId"] = 0
						}
					},
					["1747214522112883768"] = {
						["key"] = "1747214522112883768",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "花店开门",
						["pos"] = {
							["x"] = 4720.78839869281,
							["y"] = 570.1432748538009
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {},
							["ManualItemIdList"] = {
								119002
							},
							["StateId"] = 26,
							["QuestId"] = 0
						}
					},
					["17477477418471743398"] = {
						["key"] = "17477477418471743398",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成小飞机",
						["pos"] = {
							["x"] = 34.47650244492345,
							["y"] = 159.253764656396
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191412
							}
						}
					},
					["17477494242142607245"] = {
						["key"] = "17477494242142607245",
						["type"] = "TalkNode",
						["name"] = "是你们？！",
						["pos"] = {
							["x"] = 1440.6479310163518,
							["y"] = 1213.0537646563962
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10123401,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = false,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "P10108512",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17477510114547790170"] = {
						["key"] = "17477510114547790170",
						["type"] = "WaitOfTimeNode",
						["name"] = "1",
						["pos"] = {
							["x"] = 1218.7876135560355,
							["y"] = 1342.9775741802055
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					}
				},
				["commentData"] = {
					["1743319517392787789"] = {
						["key"] = "1743319517392787789",
						["name"] = "恩里克暂停",
						["position"] = {
							["x"] = -520.3044375645002,
							["y"] = 17.05263157894717
						},
						["size"] = {
							["width"] = 262.94117647058835,
							["height"] = 675.8823529411766
						}
					},
					["1743319534956788068"] = {
						["key"] = "1743319534956788068",
						["name"] = "恩里克开始走",
						["position"] = {
							["x"] = -229.1279669762647,
							["y"] = 39.99380804953546
						},
						["size"] = {
							["width"] = 510,
							["height"] = 601.7647058823532
						}
					},
					["1743319579581788803"] = {
						["key"] = "1743319579581788803",
						["name"] = "恩里克暂停",
						["position"] = {
							["x"] = 298.51909184726463,
							["y"] = 38.229102167182646
						},
						["size"] = {
							["width"] = 225.88235294117646,
							["height"] = 605.2941176470589
						}
					},
					["1743319632618789574"] = {
						["key"] = "1743319632618789574",
						["name"] = "恩里克在台阶下面等着",
						["position"] = {
							["x"] = 550.8720330237353,
							["y"] = 2.9349845201238622
						},
						["size"] = {
							["width"] = 485.294117647059,
							["height"] = 630
						}
					},
					["1743319762591790266"] = {
						["key"] = "1743319762591790266",
						["name"] = "恩里克走到小孩子前",
						["position"] = {
							["x"] = 1053.3720330237352,
							["y"] = 29.670278637771162
						},
						["size"] = {
							["width"] = 1221.5774400350244,
							["height"] = 566.7565971524168
						}
					}
				}
			}
		},
		["174228308433310206319"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206319",
			["type"] = "StoryNode",
			["name"] = "跟踪恩里克",
			["pos"] = {
				["x"] = 119.73352535286969,
				["y"] = 376.33005696607887
			},
			["propsData"] = {
				["QuestId"] = 10020602,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020603",
				["QuestDeatil"] = "QuestDesc_10020603",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206453",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206452",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206457",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206458",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206453",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206457",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206459",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206460",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206453",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206459",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206452",
						["startPort"] = "Out",
						["endQuest"] = "175690459726711402",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "175690459726711402",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206454",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["174228308433410206452"] = {
						["key"] = "174228308433410206452",
						["type"] = "GoToNode",
						["name"] = "前往恩里克丢弃物品处",
						["pos"] = {
							["x"] = -968.7910084481878,
							["y"] = 213.8999260703921
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1180115,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1180115"
						}
					},
					["174228308433410206453"] = {
						["key"] = "174228308433410206453",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -1380.3040570123972,
							["y"] = 206.74423511496065
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206454"] = {
						["key"] = "174228308433410206454",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = -123.50227846211303,
							["y"] = 219.76855248712334
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206455"] = {
						["key"] = "174228308433410206455",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = -437.3391468904315,
							["y"] = 447.29362354447005
						},
						["propsData"] = {}
					},
					["174228308433410206457"] = {
						["key"] = "174228308433410206457",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖城",
						["pos"] = {
							["x"] = -1115.4901888004565,
							["y"] = -152.67645258448258
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					},
					["174228308433410206458"] = {
						["key"] = "174228308433410206458",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = -868.2485710935746,
							["y"] = -151.06591210426694
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["174228308433410206459"] = {
						["key"] = "174228308433410206459",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖",
						["pos"] = {
							["x"] = -1093.9009420747866,
							["y"] = 18.05306007986769
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					},
					["174228308433410206460"] = {
						["key"] = "174228308433410206460",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = -845.2801332213456,
							["y"] = -1.6439096171020466
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["175690459726711402"] = {
						["key"] = "175690459726711402",
						["type"] = "TalkNode",
						["name"] = "应该就是这个水潭",
						["pos"] = {
							["x"] = -716.1914617957115,
							["y"] = 217.05367371063622
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10124201,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206320"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206320",
			["type"] = "StoryNode",
			["name"] = "见证恩里克的秘密",
			["pos"] = {
				["x"] = 360.29259867900134,
				["y"] = 386.0289839416253
			},
			["propsData"] = {
				["QuestId"] = 10020603,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020603",
				["QuestDeatil"] = "QuestDesc_10020603",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206464",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206467",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206468",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206469",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206464",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206468",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206470",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206471",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206464",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206470",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206467",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206472",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434070403318649952",
						["startPort"] = "Out",
						["endQuest"] = "17434092751549436467",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434092751549436467",
						["startPort"] = "Out",
						["endQuest"] = "17434092642909436235",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174340988054211007975",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206476",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174340988054211007975",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206475",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434070403318649952",
						["startPort"] = "Out",
						["endQuest"] = "174340988054211007975",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206472",
						["startPort"] = "Out",
						["endQuest"] = "17434070403318649952",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17434070403318649952",
						["startPort"] = "Out",
						["endQuest"] = "174341082912413366781",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174341082912413366781",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206473",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206475",
						["startPort"] = "Out",
						["endQuest"] = "1743743557432530083",
						["endPort"] = "Input_1"
					},
					{
						["startQuest"] = "174228308433410206476",
						["startPort"] = "Out",
						["endQuest"] = "1743743557432530083",
						["endPort"] = "Input_2"
					},
					{
						["startQuest"] = "1743743557432530083",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206465",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["174228308433410206464"] = {
						["key"] = "174228308433410206464",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -946.8083860167263,
							["y"] = 214.24423511496065
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206465"] = {
						["key"] = "174228308433410206465",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1100.091192772534,
							["y"] = 187.09192837594043
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206466"] = {
						["key"] = "174228308433410206466",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 604.4823274685418,
							["y"] = 334.48593123677773
						},
						["propsData"] = {}
					},
					["174228308433410206467"] = {
						["key"] = "174228308433410206467",
						["type"] = "GoToNode",
						["name"] = "前往恩里克丢弃物品处",
						["pos"] = {
							["x"] = -586.9061127474519,
							["y"] = 248.78904574957173
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190675,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190675"
						}
					},
					["174228308433410206468"] = {
						["key"] = "174228308433410206468",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖",
						["pos"] = {
							["x"] = -604.5835914392246,
							["y"] = 10.401544928352578
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					},
					["174228308433410206469"] = {
						["key"] = "174228308433410206469",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = -360.9627825857836,
							["y"] = 9.037908564716176
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeNight",
							["UnitId"] = -1
						}
					},
					["174228308433410206470"] = {
						["key"] = "174228308433410206470",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖城",
						["pos"] = {
							["x"] = -595.2834415007322,
							["y"] = -124.14276410723795
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					},
					["174228308433410206471"] = {
						["key"] = "174228308433410206471",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = -351.6626326472913,
							["y"] = -125.50640047087433
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["174228308433410206472"] = {
						["key"] = "174228308433410206472",
						["type"] = "TalkNode",
						["name"] = "见证恩利克丢弃物品",
						["pos"] = {
							["x"] = -325.5800689990556,
							["y"] = 224.36276100598533
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108601,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101086",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200061,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206473"] = {
						["key"] = "174228308433410206473",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成骨灰盒",
						["pos"] = {
							["x"] = 382.12181889447066,
							["y"] = 495.5718145889566
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190549
							}
						}
					},
					["174228308433410206475"] = {
						["key"] = "174228308433410206475",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁骨灰盒",
						["pos"] = {
							["x"] = 608.2783371432131,
							["y"] = 90.4204902255418
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190549
							}
						}
					},
					["174228308433410206476"] = {
						["key"] = "174228308433410206476",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "停止站桩bgm",
						["pos"] = {
							["x"] = 610.2145227805682,
							["y"] = 213.78238732976504
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17434070403318649952"] = {
						["key"] = "17434070403318649952",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = 138.98056689760534,
							["y"] = 223.39817444219054
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1240646
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 10062,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuidePointName"] = "P1240646",
							["IsUseCount"] = false
						}
					},
					["17434092642909436235"] = {
						["key"] = "17434092642909436235",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "切换机关状态",
						["pos"] = {
							["x"] = 141.90685967176827,
							["y"] = 479.3874792550248
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {
								1190549
							},
							["ManualItemIdList"] = {},
							["StateId"] = 11301261,
							["QuestId"] = 0
						}
					},
					["17434092751549436467"] = {
						["key"] = "17434092751549436467",
						["type"] = "WaitOfTimeNode",
						["name"] = "等3S",
						["pos"] = {
							["x"] = 143.00219435736665,
							["y"] = 363.7992439609071
						},
						["propsData"] = {
							["WaitTime"] = 3
						}
					},
					["174340988054211007975"] = {
						["key"] = "174340988054211007975",
						["type"] = "TalkNode",
						["name"] = "见证恩利克丢弃物品",
						["pos"] = {
							["x"] = 372.6853623810268,
							["y"] = 217.20053901473776
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108701,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101087",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174341082912413366781"] = {
						["key"] = "174341082912413366781",
						["type"] = "WaitOfTimeNode",
						["name"] = "等0.4S",
						["pos"] = {
							["x"] = 371.65985336319005,
							["y"] = 362.2489496833531
						},
						["propsData"] = {
							["WaitTime"] = 0.4
						}
					},
					["1743743557432530083"] = {
						["key"] = "1743743557432530083",
						["type"] = "WaitQuestFinishedNode",
						["name"] = "22",
						["pos"] = {
							["x"] = 863.1185064935062,
							["y"] = 166.85714285714283
						},
						["propsData"] = {
							["ListenCount"] = 2,
							["NeedFinishCount"] = 2
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206321"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206321",
			["type"] = "StoryNode",
			["name"] = "奥哥潜入",
			["pos"] = {
				["x"] = 603.9767500324224,
				["y"] = 378.5859083363141
			},
			["propsData"] = {
				["QuestId"] = 10020604,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020604",
				["QuestDeatil"] = "QuestDesc_10020604",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206491",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206479",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206478",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206480",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206481",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206482",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206483",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206484",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206484",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206485",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206479",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206481",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206479",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206483",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206477",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206491",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206485",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206486",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206477",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206487",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206487",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206478",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206488",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206492",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206492",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206493",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206494",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206495",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206493",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206494",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206495",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206496",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1747292742026583401",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206489",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174228308433410206496",
						["startPort"] = "Out",
						["endQuest"] = "17592945221775235",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17592945221775235",
						["startPort"] = "Out",
						["endQuest"] = "1747292742026583401",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206477"] = {
						["key"] = "174228308433410206477",
						["type"] = "SkipRegionNode",
						["name"] = "传送玩家到恩里克办公室",
						["pos"] = {
							["x"] = -967.9406376083992,
							["y"] = 204.89171780743848
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101106,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["174228308433410206478"] = {
						["key"] = "174228308433410206478",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "设置玩家位置在恩里克办公室",
						["pos"] = {
							["x"] = -713.2133648811264,
							["y"] = 68.76184767756828
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_EnlikeOffice",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["174228308433410206479"] = {
						["key"] = "174228308433410206479",
						["type"] = "TalkNode",
						["name"] = "奥哥潜入登场",
						["pos"] = {
							["x"] = -479.78500292050705,
							["y"] = 199.2283805517152
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10020524,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206480"] = {
						["key"] = "174228308433410206480",
						["type"] = "SwitchStoryModeNode",
						["name"] = "开启剧情模式",
						["pos"] = {
							["x"] = -476.5588033226748,
							["y"] = 68.42542767422266
						},
						["propsData"] = {
							["IsOpen"] = true
						}
					},
					["174228308433410206481"] = {
						["key"] = "174228308433410206481",
						["type"] = "PickUpNode",
						["name"] = "与炉子交互",
						["pos"] = {
							["x"] = -227.62693800801486,
							["y"] = 69.05922798193569
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1200054
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 30003,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["174228308433410206482"] = {
						["key"] = "174228308433410206482",
						["type"] = "TalkNode",
						["name"] = "炉子没点着",
						["pos"] = {
							["x"] = 10.316784935708583,
							["y"] = 36.60767953038729
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10020527,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206483"] = {
						["key"] = "174228308433410206483",
						["type"] = "PickUpNode",
						["name"] = "与日志交互",
						["pos"] = {
							["x"] = -230.63095482453187,
							["y"] = 207.7995917847996
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {
								1200055
							},
							["QuestPickupId"] = -1,
							["UnitId"] = 30004,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuidePointName"] = "",
							["IsUseCount"] = false
						}
					},
					["174228308433410206484"] = {
						["key"] = "174228308433410206484",
						["type"] = "TalkNode",
						["name"] = "沉眠计划",
						["pos"] = {
							["x"] = 16.35182963239103,
							["y"] = 204.8763483615562
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10020528,
							["FlowAssetPath"] = "",
							["TalkType"] = "BlackISS",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206485"] = {
						["key"] = "174228308433410206485",
						["type"] = "TalkNode",
						["name"] = "恩里克回来了",
						["pos"] = {
							["x"] = 250.3517660062809,
							["y"] = 205.52270200790988
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10020531,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_10020531",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206486"] = {
						["key"] = "174228308433410206486",
						["type"] = "SwitchStoryModeNode",
						["name"] = "开启剧情模式",
						["pos"] = {
							["x"] = 487.7836128446815,
							["y"] = 206.84257332728475
						},
						["propsData"] = {
							["IsOpen"] = false
						}
					},
					["174228308433410206487"] = {
						["key"] = "174228308433410206487",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = -796.9639716311575,
							["y"] = -76.86126012185103
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["174228308433410206488"] = {
						["key"] = "174228308433410206488",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -947.8798145881548,
							["y"] = 551.077568448294
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206489"] = {
						["key"] = "174228308433410206489",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 779.010963907054,
							["y"] = 547.309849423754
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206490"] = {
						["key"] = "174228308433410206490",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1190.4575731368075,
							["y"] = 243.64007752969613
						},
						["propsData"] = {}
					},
					["174228308433410206491"] = {
						["key"] = "174228308433410206491",
						["type"] = "TalkNode",
						["name"] = "与此同时",
						["pos"] = {
							["x"] = -712.7466835817361,
							["y"] = 199.99317612199397
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108801,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206492"] = {
						["key"] = "174228308433410206492",
						["type"] = "SkipRegionNode",
						["name"] = "传送玩家到恩里克办公室",
						["pos"] = {
							["x"] = -708.0352999156195,
							["y"] = 561.4750289467111
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101106,
							["StartIndex"] = 1,
							["IsWhite"] = false
						}
					},
					["174228308433410206493"] = {
						["key"] = "174228308433410206493",
						["type"] = "TalkNode",
						["name"] = "与此同时",
						["pos"] = {
							["x"] = -453.73630270026763,
							["y"] = 549.3386653103476
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108801,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206494"] = {
						["key"] = "174228308433410206494",
						["type"] = "TalkNode",
						["name"] = "恩里克回来了",
						["pos"] = {
							["x"] = -212.0166003612862,
							["y"] = 547.7186723838295
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108901,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101089",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206495"] = {
						["key"] = "174228308433410206495",
						["type"] = "TalkNode",
						["name"] = "恩里克回来了",
						["pos"] = {
							["x"] = -209.272774202879,
							["y"] = 703.4501584604886
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108914,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_10108905",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206496"] = {
						["key"] = "174228308433410206496",
						["type"] = "SkipRegionNode",
						["name"] = "传送玩家到冰湖城",
						["pos"] = {
							["x"] = 68.60743632217935,
							["y"] = 559.4285714285713
						},
						["propsData"] = {
							["ModeType"] = 1,
							["Id"] = 101101,
							["StartIndex"] = 7,
							["IsWhite"] = false
						}
					},
					["1747292742026583401"] = {
						["key"] = "1747292742026583401",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "停止站桩bgm",
						["pos"] = {
							["x"] = 463.2996704884442,
							["y"] = 558.8169138209462
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17592945221775235"] = {
						["key"] = "17592945221775235",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 175.47058823529414,
							["y"] = 766.6397058823529
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "BP_1190675",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206322"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206322",
			["type"] = "StoryNode",
			["name"] = "前往贫民窟找奥哥",
			["pos"] = {
				["x"] = -447.14438583690367,
				["y"] = 563.2573721465025
			},
			["propsData"] = {
				["QuestId"] = 10020605,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020605",
				["QuestDeatil"] = "QuestDesc_10020605",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206500",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206501",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206503",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206504",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206501",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206505",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206505",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206498",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174228308433410206497",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206497",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206500",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206503",
						["startPort"] = "Out",
						["endQuest"] = "17449613721342455668",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206501",
						["startPort"] = "Out",
						["endQuest"] = "17449614643473269697",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206497"] = {
						["key"] = "174228308433410206497",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -1116.170794930875,
							["y"] = 207.00376118189212
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206498"] = {
						["key"] = "174228308433410206498",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 192.8352876340781,
							["y"] = 166.98013805167056
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206499"] = {
						["key"] = "174228308433410206499",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 39.85222232451554,
							["y"] = 357.66912270427724
						},
						["propsData"] = {}
					},
					["174228308433410206500"] = {
						["key"] = "174228308433410206500",
						["type"] = "GoToNode",
						["name"] = "goto 疗养院隐蔽处",
						["pos"] = {
							["x"] = -820.1094293943643,
							["y"] = 208.16093579726527
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190318,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190318"
						}
					},
					["174228308433410206501"] = {
						["key"] = "174228308433410206501",
						["type"] = "TalkNode",
						["name"] = "和奥哥对齐",
						["pos"] = {
							["x"] = -522.3485333116693,
							["y"] = 195.81964988468528
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10109001,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101090",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200002,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206503"] = {
						["key"] = "174228308433410206503",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖城",
						["pos"] = {
							["x"] = -796.8563187119516,
							["y"] = 30.856090382897996
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					},
					["174228308433410206504"] = {
						["key"] = "174228308433410206504",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = -553.2355098585108,
							["y"] = 28.063882590690167
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["174228308433410206505"] = {
						["key"] = "174228308433410206505",
						["type"] = "TalkNode",
						["name"] = "第二天",
						["pos"] = {
							["x"] = -244.16591243695467,
							["y"] = 161.4254177109439
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 20003701,
							["FlowAssetPath"] = "",
							["TalkType"] = "Black",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["ForceAutoPlay"] = true,
							["ShowSkipButton"] = false,
							["ShowAutoPlayButton"] = false,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "P101090_Nvzhu",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206507"] = {
						["key"] = "174228308433410206507",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "玩家放到贫民窟门口",
						["pos"] = {
							["x"] = -217.7465035062129,
							["y"] = 565.2926230168771
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "P101090_Nvzhu",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17449613721342455668"] = {
						["key"] = "17449613721342455668",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "激活奥哥",
						["pos"] = {
							["x"] = -547.4931457431458,
							["y"] = -102.56439393939394
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190284
							}
						}
					},
					["17449614643473269697"] = {
						["key"] = "17449614643473269697",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁奥哥",
						["pos"] = {
							["x"] = -199.67721861471864,
							["y"] = 326.81060606060606
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190284
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206323"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206323",
			["type"] = "StoryNode",
			["name"] = "前往疗养院",
			["pos"] = {
				["x"] = -160.388109249715,
				["y"] = 585.9722447797727
			},
			["propsData"] = {
				["QuestId"] = 10020606,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020606",
				["QuestDeatil"] = "QuestDesc_10020606",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206508",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206511",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206511",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206512",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206512",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206509",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174228308433410206508",
						["startPort"] = "QuestStart",
						["endQuest"] = "176406980927211258008",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "176406980927211258008",
						["startPort"] = "Out",
						["endQuest"] = "17639836889622733705",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206508"] = {
						["key"] = "174228308433410206508",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 100,
							["y"] = 140
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206509"] = {
						["key"] = "174228308433410206509",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1053.6631278894783,
							["y"] = 141.51500531684903
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206510"] = {
						["key"] = "174228308433410206510",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1049.7979963105313,
							["y"] = 288.92375730413517
						},
						["propsData"] = {}
					},
					["174228308433410206511"] = {
						["key"] = "174228308433410206511",
						["type"] = "GoToRegionNode",
						["name"] = "等待玩家进入疗养院",
						["pos"] = {
							["x"] = 378.9071682479433,
							["y"] = 141.3883181729042
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101106,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_LeaveSanatorium"
						}
					},
					["174228308433410206512"] = {
						["key"] = "174228308433410206512",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 站在门口的恩里克，虽然被隐藏了",
						["pos"] = {
							["x"] = 824.4452896335637,
							["y"] = 162.91641759162388
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1200065
							}
						}
					},
					["174228308433410206513"] = {
						["key"] = "174228308433410206513",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = 1039.3701351562404,
							["y"] = -187.59845507164738
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityDay",
							["UnitId"] = -1
						}
					},
					["174228308433410206514"] = {
						["key"] = "174228308433410206514",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖城",
						["pos"] = {
							["x"] = 428.2493263027995,
							["y"] = -194.23481870801098
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					},
					["17639836889622733705"] = {
						["key"] = "17639836889622733705",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,清晨",
						["pos"] = {
							["x"] = 669.9321417500755,
							["y"] = 434.7894736842105
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityDay",
							["UnitId"] = -1
						}
					},
					["176406980927211258008"] = {
						["key"] = "176406980927211258008",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖城",
						["pos"] = {
							["x"] = 387.5718406440242,
							["y"] = 413.4736842105263
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206324"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206324",
			["type"] = "StoryNode",
			["name"] = "找赛琪",
			["pos"] = {
				["x"] = 131.00788954992754,
				["y"] = 588.5638795802279
			},
			["propsData"] = {
				["QuestId"] = 10020607,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020607",
				["QuestDeatil"] = "QuestName_10020607",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206517",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206516",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206517",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206521",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206524",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206526",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206526",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206518",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174228308433410206516",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206520",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206522",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206527",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206527",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206524",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206521",
						["startPort"] = "Out",
						["endQuest"] = "17469817659997425112",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17469817659997425112",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206522",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206516",
						["startPort"] = "Out",
						["endQuest"] = "17469818474237425979",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206521",
						["startPort"] = "Out",
						["endQuest"] = "17469818559267426200",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17469818559267426200",
						["startPort"] = "Out",
						["endQuest"] = "17469821013299134603",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17469821013299134603",
						["startPort"] = "Out",
						["endQuest"] = "17469820756528280358",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206521",
						["startPort"] = "Out",
						["endQuest"] = "17491238392664102804",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206521",
						["startPort"] = "Out",
						["endQuest"] = "17555055643705260116",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206516"] = {
						["key"] = "174228308433410206516",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入疗养院",
						["pos"] = {
							["x"] = 72.83636157165569,
							["y"] = 37.91607994549167
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101106,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = ""
						}
					},
					["174228308433410206517"] = {
						["key"] = "174228308433410206517",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -227.92016806722688,
							["y"] = 177.75210084033614
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206518"] = {
						["key"] = "174228308433410206518",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1544.644166602371,
							["y"] = 194.20942169703784
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206519"] = {
						["key"] = "174228308433410206519",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1552.7987415061714,
							["y"] = 316.40137107474567
						},
						["propsData"] = {}
					},
					["174228308433410206520"] = {
						["key"] = "174228308433410206520",
						["type"] = "TalkNode",
						["name"] = "不要打草惊蛇",
						["pos"] = {
							["x"] = 354.9019460827606,
							["y"] = 9.000631086387589
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10109101,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = true,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206521"] = {
						["key"] = "174228308433410206521",
						["type"] = "GoToNode",
						["name"] = "goto赛琪房间",
						["pos"] = {
							["x"] = 69.9736461854389,
							["y"] = 177.03104913997183
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1200082,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1200082"
						}
					},
					["174228308433410206522"] = {
						["key"] = "174228308433410206522",
						["type"] = "TalkNode",
						["name"] = "是你。",
						["pos"] = {
							["x"] = 591.5202965228013,
							["y"] = 188.91321245402378
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10109301,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101093",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "P10109301",
							["CameraLookAtTartgetPoint"] = "QuestPoint_530103",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200006,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206523"] = {
						["key"] = "174228308433410206523",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 赛琪",
						["pos"] = {
							["x"] = 699.8569583347512,
							["y"] = -336.9338275348394
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1200087
							}
						}
					},
					["174228308433410206524"] = {
						["key"] = "174228308433410206524",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 赛琪",
						["pos"] = {
							["x"] = 1084.7495335086328,
							["y"] = 198.94835069307376
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1200087
							}
						}
					},
					["174228308433410206525"] = {
						["key"] = "174228308433410206525",
						["type"] = "TalkNode",
						["name"] = "赛琪？",
						["pos"] = {
							["x"] = 350.7240208387629,
							["y"] = 639.0045302366542
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10109201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101092",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200006,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206526"] = {
						["key"] = "174228308433410206526",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 恩里克（赛琪房间里的））",
						["pos"] = {
							["x"] = 1321.677163777475,
							["y"] = 196.09310603887377
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1200163
							}
						}
					},
					["174228308433410206527"] = {
						["key"] = "174228308433410206527",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "停止播放站桩bgm",
						["pos"] = {
							["x"] = 821.1959221679745,
							["y"] = 209.8270124051923
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17469817659997425112"] = {
						["key"] = "17469817659997425112",
						["type"] = "TalkNode",
						["name"] = "你在哭吗？",
						["pos"] = {
							["x"] = 335.35223720581797,
							["y"] = 190.25131752305668
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC017/SQ_OBT0101_SC017",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["17469818474237425979"] = {
						["key"] = "17469818474237425979",
						["type"] = "SendMessageNode",
						["name"] = "DoorOpen",
						["pos"] = {
							["x"] = 358.68557053915123,
							["y"] = -111.9709046991656
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "DoorOpen",
							["UnitId"] = -1
						}
					},
					["17469818559267426200"] = {
						["key"] = "17469818559267426200",
						["type"] = "SendMessageNode",
						["name"] = "DoorOpen",
						["pos"] = {
							["x"] = 333.1300149835957,
							["y"] = 330.25131752305674
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "DoorOpen",
							["UnitId"] = -1
						}
					},
					["17469820756528280358"] = {
						["key"] = "17469820756528280358",
						["type"] = "SendMessageNode",
						["name"] = "DoorOpen",
						["pos"] = {
							["x"] = 784.2411260947069,
							["y"] = 342.4735397452789
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "DoorOpen",
							["UnitId"] = -1
						}
					},
					["17469821013299134603"] = {
						["key"] = "17469821013299134603",
						["type"] = "WaitOfTimeNode",
						["name"] = "0.45",
						["pos"] = {
							["x"] = 552.0189038724845,
							["y"] = 336.91798418972337
						},
						["propsData"] = {
							["WaitTime"] = 0.45
						}
					},
					["17491238392664102804"] = {
						["key"] = "17491238392664102804",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "停止播放站桩bgm",
						["pos"] = {
							["x"] = 587.6990463101783,
							["y"] = 68.3657367744699
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt02/0050_story_saiqi_grow_flower",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = false
						}
					},
					["17555055643705260116"] = {
						["key"] = "17555055643705260116",
						["type"] = "PlayNormalSoundNode",
						["name"] = "开门声",
						["pos"] = {
							["x"] = 327.4957792207793,
							["y"] = 443.2035714285714
						},
						["propsData"] = {
							["EventPath"] = "open_door_outsider",
							["TargetPointName"] = "",
							["EventKey"] = "",
							["PlayAs2D"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206325"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206325",
			["type"] = "StoryNode",
			["name"] = "前往电梯",
			["pos"] = {
				["x"] = 55.80745356150361,
				["y"] = 1022.2766140340984
			},
			["propsData"] = {
				["QuestId"] = 10020612,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020612",
				["QuestDeatil"] = "QuestName_10020612",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206528",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206531",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206531",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206532",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206531",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206533",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206533",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206534",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206528",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206537",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206534",
						["startPort"] = "Out",
						["endQuest"] = "174394994128719170542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206534",
						["startPort"] = "Out",
						["endQuest"] = "174394997662319170973",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206534",
						["startPort"] = "Out",
						["endQuest"] = "174395001770319171335",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174394994128719170542",
						["startPort"] = "Out",
						["endQuest"] = "174395020401821532654",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206536",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206529",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174395020401821532654",
						["startPort"] = "Out",
						["endQuest"] = "1758523300992940268",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758523300992940268",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206535",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206535",
						["startPort"] = "Out",
						["endQuest"] = "1758523314104940650",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1758523314104940650",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206536",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206528"] = {
						["key"] = "174228308433410206528",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -599.144839767714,
							["y"] = 185.04164857774867
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206529"] = {
						["key"] = "174228308433410206529",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1621.449155268474,
							["y"] = 178.9668795341276
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206530"] = {
						["key"] = "174228308433410206530",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 762.8571428571429,
							["y"] = 485.71428571428567
						},
						["propsData"] = {}
					},
					["174228308433410206531"] = {
						["key"] = "174228308433410206531",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = -368.9205530440662,
							["y"] = 184.94847745869342
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_IceLake_2_Trafficway"
						}
					},
					["174228308433410206532"] = {
						["key"] = "174228308433410206532",
						["type"] = "TalkNode",
						["name"] = "无法离开冰湖城",
						["pos"] = {
							["x"] = -121.91305763005597,
							["y"] = 34.21851616199807
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10110001,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206533"] = {
						["key"] = "174228308433410206533",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成凯文",
						["pos"] = {
							["x"] = -10.432613924716401,
							["y"] = 205.10660972759067
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240059,
								1240673
							}
						}
					},
					["174228308433410206534"] = {
						["key"] = "174228308433410206534",
						["type"] = "GoToNode",
						["name"] = "前往电梯处",
						["pos"] = {
							["x"] = 293.3438148206096,
							["y"] = 196.53518115616208
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240045,
							["GuideType"] = "P",
							["GuidePointName"] = "TargetPoint_IceLake_2_Trafficway"
						}
					},
					["174228308433410206535"] = {
						["key"] = "174228308433410206535",
						["type"] = "TalkNode",
						["name"] = "谁在那里！",
						["pos"] = {
							["x"] = 1080.878189966732,
							["y"] = 203.70876026522492
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC018/SQ_OBT0101_SC018",
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = true,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206536"] = {
						["key"] = "174228308433410206536",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁凯文",
						["pos"] = {
							["x"] = 1363.8749799151346,
							["y"] = 213.4466388740713
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240059,
								1240673
							}
						}
					},
					["174228308433410206537"] = {
						["key"] = "174228308433410206537",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,黄昏",
						["pos"] = {
							["x"] = -351.37143448270217,
							["y"] = 382.2659429829426
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeTwilight",
							["UnitId"] = -1
						}
					},
					["174394994128719170542"] = {
						["key"] = "174394994128719170542",
						["type"] = "GoToNode",
						["name"] = "前往凯文埋尸处",
						["pos"] = {
							["x"] = 550.6901154401153,
							["y"] = 200.47498481051093
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240672,
							["GuideType"] = "P",
							["GuidePointName"] = "P1240672"
						}
					},
					["174394997662319170973"] = {
						["key"] = "174394997662319170973",
						["type"] = "TalkNode",
						["name"] = "是谁来着？",
						["pos"] = {
							["x"] = 306.245670995671,
							["y"] = -31.74723741171136
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10125201,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174395001770319171335"] = {
						["key"] = "174395001770319171335",
						["type"] = "CameraLookAtNode",
						["name"] = "CameraLookAt",
						["pos"] = {
							["x"] = 328.46789321789316,
							["y"] = 44.91942925495534
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "P1240672",
							["ActorId"] = 0,
							["Duration"] = 0.75,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["174395020401821532654"] = {
						["key"] = "174395020401821532654",
						["type"] = "CameraLookAtNode",
						["name"] = "CameraLookAt",
						["pos"] = {
							["x"] = 825.1345598845601,
							["y"] = 198.25276258828868
						},
						["propsData"] = {
							["TargetType"] = "Point",
							["PointName"] = "P1240672",
							["ActorId"] = 0,
							["Duration"] = 0.75,
							["EasingFunc"] = 4,
							["bDisableUserInput"] = true
						}
					},
					["174395126394321533845"] = {
						["key"] = "174395126394321533845",
						["type"] = "WaitOfTimeNode",
						["name"] = "1",
						["pos"] = {
							["x"] = 1003.3396880896881,
							["y"] = 470.1758395113656
						},
						["propsData"] = {
							["WaitTime"] = 1
						}
					},
					["1758523300992940268"] = {
						["key"] = "1758523300992940268",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1079.2187734549445,
							["y"] = 56.06451612903229
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/mute",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								101103
							},
							["bStoreToServer"] = false
						}
					},
					["1758523314104940650"] = {
						["key"] = "1758523314104940650",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 1360.377419354839,
							["y"] = 55.470161290322416
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206326"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206326",
			["type"] = "StoryNode",
			["name"] = "击败凯文",
			["pos"] = {
				["x"] = 318.0889910373413,
				["y"] = 1016.9229697880446
			},
			["propsData"] = {
				["QuestId"] = 10020613,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020613",
				["QuestDeatil"] = "QuestName_10020613",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "P10109922Player",
				["bUseQuestCoordinate"] = true,
				["bDeadTriggerQuestFail"] = true,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "TargetPoint_IceLake_2_Trafficway",
				["JumpId"] = 0,
				["FailBlackScreenText"] = "",
				["FadeInTime"] = 1,
				["FadeOutTime"] = 1,
				["ContinueTime"] = 1
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206542",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206541",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206538",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206543",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206548",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206550",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206550",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206546",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206548",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206543",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206544",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206541",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206552",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206543",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206551",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206546",
						["startPort"] = "Out",
						["endQuest"] = "17542952014596902284",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206543",
						["startPort"] = "Out",
						["endQuest"] = "17550719307063655520",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17550719307063655520",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206543",
						["startPort"] = "Out",
						["endQuest"] = "17585255097603733262",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206544",
						["startPort"] = "Out",
						["endQuest"] = "17585255569973733699",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17585255569973733699",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206540",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "174228308433410206552",
						["startPort"] = "Out",
						["endQuest"] = "17585256913163734912",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17585256913163734912",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206539",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["174228308433410206538"] = {
						["key"] = "174228308433410206538",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -1196.563912084837,
							["y"] = 266.5856738624036
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206539"] = {
						["key"] = "174228308433410206539",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 480.6417974384681,
							["y"] = 138.9119610167821
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206540"] = {
						["key"] = "174228308433410206540",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 203.27163242995314,
							["y"] = 562.3916164416914
						},
						["propsData"] = {}
					},
					["174228308433410206541"] = {
						["key"] = "174228308433410206541",
						["type"] = "KillMonsterNode",
						["name"] = "击杀怪物凯文",
						["pos"] = {
							["x"] = -266.61896896010586,
							["y"] = 125.42621644719404
						},
						["propsData"] = {
							["KillMonsterType"] = "Id",
							["MonsterNeedNums"] = 1,
							["IsShow"] = false,
							["GuideType"] = "P",
							["GuideName"] = "",
							["IsShowMonsterGuide"] = true,
							["StaticCreatorIdList"] = {
								1240046
							}
						}
					},
					["174228308433410206542"] = {
						["key"] = "174228308433410206542",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 怪物凯文",
						["pos"] = {
							["x"] = -588.3541150998288,
							["y"] = 112.62598558664033
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240046
							}
						}
					},
					["174228308433410206543"] = {
						["key"] = "174228308433410206543",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = -889.4855837020513,
							["y"] = 120.88433269898285
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_IceLake_2_Trafficway"
						}
					},
					["174228308433410206544"] = {
						["key"] = "174228308433410206544",
						["type"] = "GoToRegionNode",
						["name"] = "等待离开冰湖",
						["pos"] = {
							["x"] = -912.87693890716,
							["y"] = 548.0598818764768
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Leave",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = false,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_IceLake"
						}
					},
					["174228308433410206546"] = {
						["key"] = "174228308433410206546",
						["type"] = "MonitorPlayerStatusNode",
						["name"] = "监听玩家状态",
						["pos"] = {
							["x"] = -918.5120225337921,
							["y"] = 724.8214309625145
						},
						["propsData"] = {
							["ListenHPPercent"] = false,
							["ListenESPercent"] = false,
							["ListenSPPercent"] = false,
							["ListenDead"] = true
						}
					},
					["174228308433410206548"] = {
						["key"] = "174228308433410206548",
						["type"] = "WaitOfTimeNode",
						["name"] = "延迟等待",
						["pos"] = {
							["x"] = -763.0045172017602,
							["y"] = 917.2340183751021
						},
						["propsData"] = {
							["WaitTime"] = 1.9
						}
					},
					["174228308433410206549"] = {
						["key"] = "174228308433410206549",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = -143.6605278577708,
							["y"] = 912.408843549927
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "P100303Drop1",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = false,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["174228308433410206550"] = {
						["key"] = "174228308433410206550",
						["type"] = "RefreshPlayerNode",
						["name"] = "重新初始化玩家",
						["pos"] = {
							["x"] = -452.9654780454814,
							["y"] = 916.9946051769127
						},
						["propsData"] = {}
					},
					["174228308433410206551"] = {
						["key"] = "174228308433410206551",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,黄昏",
						["pos"] = {
							["x"] = -889.8714344827013,
							["y"] = -42.234057017056884
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeTwilight",
							["UnitId"] = -1
						}
					},
					["174228308433410206552"] = {
						["key"] = "174228308433410206552",
						["type"] = "WaitOfTimeNode",
						["name"] = "等死亡动画播完",
						["pos"] = {
							["x"] = -23.993939393939506,
							["y"] = 133.22626262626247
						},
						["propsData"] = {
							["WaitTime"] = 1.5
						}
					},
					["17542952014596902284"] = {
						["key"] = "17542952014596902284",
						["type"] = "FailBlackScreenNode",
						["name"] = "失败黑屏节点",
						["pos"] = {
							["x"] = -519.2738940777062,
							["y"] = 749.833206441937
						},
						["propsData"] = {
							["Text"] = "FailBlackScreenHode_1",
							["FadeInTime"] = 0,
							["FadeOutTime"] = 0.5,
							["ContinueTime"] = 2
						}
					},
					["17550719307063655520"] = {
						["key"] = "17550719307063655520",
						["type"] = "GoToNode",
						["name"] = "走到凯文身边",
						["pos"] = {
							["x"] = -588.1784759358285,
							["y"] = -40.396366919973666
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1241069,
							["GuideType"] = "P",
							["GuidePointName"] = "TargetPoint_IceLake_2_Trafficway"
						}
					},
					["17585255097603733262"] = {
						["key"] = "17585255097603733262",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = -600.336917562724,
							["y"] = 303.91935483870964
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/mute",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								101103
							},
							["bStoreToServer"] = false
						}
					},
					["17585255569973733699"] = {
						["key"] = "17585255569973733699",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = -391.8513162773453,
							["y"] = 563.9749721913237
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17585256913163734912"] = {
						["key"] = "17585256913163734912",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 234.80527746879233,
							["y"] = 145.00945494994446
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					}
				},
				["commentData"] = {
					["17214774469555185222"] = {
						["key"] = "17214774469555185222",
						["name"] = "失败处理",
						["position"] = {
							["x"] = -1049.0468082440518,
							["y"] = 467.67857381965734
						},
						["size"] = {
							["width"] = 1141.4285714285716,
							["height"] = 605.7142857142858
						}
					}
				}
			}
		},
		["174228308433310206327"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206327",
			["type"] = "StoryNode",
			["name"] = "与凯文对话",
			["pos"] = {
				["x"] = 586.7377415947343,
				["y"] = 1020.204874122906
			},
			["propsData"] = {
				["QuestId"] = 10020615,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020614",
				["QuestDeatil"] = "QuestName_10020614",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = true,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206553",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206556",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206556",
						["startPort"] = "Out",
						["endQuest"] = "17440129327094542",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17440129327094542",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206557",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206556",
						["startPort"] = "Out",
						["endQuest"] = "17440129548925053",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206556",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206559",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206557",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206558",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17440129327094542",
						["startPort"] = "Out",
						["endQuest"] = "17466201211321128740",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206558",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206554",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174228308433410206556",
						["startPort"] = "Out",
						["endQuest"] = "17585258437415595857",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206553"] = {
						["key"] = "174228308433410206553",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -97.2528826060915,
							["y"] = 207.18869778644816
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206554"] = {
						["key"] = "174228308433410206554",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1098.4583565734627,
							["y"] = 202.87042114863465
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206555"] = {
						["key"] = "174228308433410206555",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 960,
							["y"] = 340
						},
						["propsData"] = {}
					},
					["174228308433410206556"] = {
						["key"] = "174228308433410206556",
						["type"] = "GoToRegionNode",
						["name"] = "等待进入冰湖",
						["pos"] = {
							["x"] = 137.3009036012542,
							["y"] = 212.74878267000136
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101103,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "TargetPoint_IceLake_2_Trafficway"
						}
					},
					["174228308433410206557"] = {
						["key"] = "174228308433410206557",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 kevin",
						["pos"] = {
							["x"] = 646.4165274959039,
							["y"] = 214.52733719462697
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240048
							}
						}
					},
					["174228308433410206558"] = {
						["key"] = "174228308433410206558",
						["type"] = "TalkNode",
						["name"] = "喂，怎么这就走了",
						["pos"] = {
							["x"] = 644.2266190074808,
							["y"] = 72.94865797073388
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10110301,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = false,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206559"] = {
						["key"] = "174228308433410206559",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,黄昏",
						["pos"] = {
							["x"] = 404.4063432950756,
							["y"] = 565.869117586117
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeTwilight",
							["UnitId"] = -1
						}
					},
					["17440129327094542"] = {
						["key"] = "17440129327094542",
						["type"] = "TalkNode",
						["name"] = "别打了",
						["pos"] = {
							["x"] = 401.6273448773448,
							["y"] = 213.4633838383837
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10110201,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_101102",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = false,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "P101102Player",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200004,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17440129548925053"] = {
						["key"] = "17440129548925053",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成裹尸袋",
						["pos"] = {
							["x"] = 397.73845598845594,
							["y"] = 76.280844155844
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240674
							}
						}
					},
					["17466201211321128740"] = {
						["key"] = "17466201211321128740",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "关bgm",
						["pos"] = {
							["x"] = 634.227723363593,
							["y"] = 332.17768504743776
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17585258437415595857"] = {
						["key"] = "17585258437415595857",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "BGM节点",
						["pos"] = {
							["x"] = 400.62519201228884,
							["y"] = 405.87301587301585
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/mute",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {
								101103
							},
							["bStoreToServer"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206328"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206328",
			["type"] = "StoryNode",
			["name"] = "返回冰湖城门口",
			["pos"] = {
				["x"] = 893.7925282307343,
				["y"] = 1356.1604751979135
			},
			["propsData"] = {
				["QuestId"] = 10020616,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020615",
				["QuestDeatil"] = "QuestName_10020615",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = true,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206560",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206563",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206560",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206564",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206563",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206561",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174228308433410206560",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206565",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206560"] = {
						["key"] = "174228308433410206560",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -338.044367821231,
							["y"] = 296.5779406124731
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206561"] = {
						["key"] = "174228308433410206561",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 463.35452362393096,
							["y"] = 304.0745818972967
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206562"] = {
						["key"] = "174228308433410206562",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 450.7414419635513,
							["y"] = 493.6371361219233
						},
						["propsData"] = {}
					},
					["174228308433410206563"] = {
						["key"] = "174228308433410206563",
						["type"] = "GoToNode",
						["name"] = "goto 冰湖城门口",
						["pos"] = {
							["x"] = -64.28444834146077,
							["y"] = 300.25814024165146
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190005,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190005"
						}
					},
					["174228308433410206564"] = {
						["key"] = "174228308433410206564",
						["type"] = "TalkNode",
						["name"] = "凯文闲置",
						["pos"] = {
							["x"] = -52.73482781349684,
							["y"] = 110.61802000793637
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 200004,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_101102Kevin_1240048",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10110401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206565"] = {
						["key"] = "174228308433410206565",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,黄昏",
						["pos"] = {
							["x"] = -72.37143448270189,
							["y"] = 482.7659429829423
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeTwilight",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206329"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206329",
			["type"] = "StoryNode",
			["name"] = "【印象对话】",
			["pos"] = {
				["x"] = 462.4904288603582,
				["y"] = 803.9469886710453
			},
			["propsData"] = {
				["QuestId"] = 10020651,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "",
				["QuestDeatil"] = "",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206569",
						["startPort"] = "Option_1",
						["endQuest"] = "174228308433410206570",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206569",
						["startPort"] = "Option_2",
						["endQuest"] = "174228308433410206571",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206566",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206572",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206573",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206567",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174228308433410206566",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206574",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206574",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206573",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206566"] = {
						["key"] = "174228308433410206566",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 411.2662337662337,
							["y"] = 353.3225108225107
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206567"] = {
						["key"] = "174228308433410206567",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 2571.8631216228473,
							["y"] = 330.34344120156464
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206568"] = {
						["key"] = "174228308433410206568",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1657.8571428571431,
							["y"] = 813.5714285714286
						},
						["propsData"] = {}
					},
					["174228308433410206569"] = {
						["key"] = "174228308433410206569",
						["type"] = "TalkNode",
						["name"] = "别打了",
						["pos"] = {
							["x"] = 1134.8555528619572,
							["y"] = -264.7216271644438
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10110201,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101102",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "BlendOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200004,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200053,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "plus",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["PlusOptions"] = {
								{
									["OptionText"] = "10110214",
									["PlusId"] = 1007,
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								},
								{
									["OptionText"] = "10110216",
									["PlusId"] = 1010,
									["OverrideBlend"] = false,
									["OverrideOutype"] = "FadeOut",
									["OverrideOutTime"] = 0
								}
							},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206570"] = {
						["key"] = "174228308433410206570",
						["type"] = "TalkNode",
						["name"] = "别打了",
						["pos"] = {
							["x"] = 1423.9020228956188,
							["y"] = -281.7034632034634
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10110215,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101102",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200004,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200053,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206571"] = {
						["key"] = "174228308433410206571",
						["type"] = "TalkNode",
						["name"] = "别打了",
						["pos"] = {
							["x"] = 1427.2353562289518,
							["y"] = -136.85497835497853
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10110217,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101102",
							["BlendInTime"] = 0,
							["BlendOutTime"] = 1,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200004,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200053,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206572"] = {
						["key"] = "174228308433410206572",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,黄昏",
						["pos"] = {
							["x"] = 1168.1285655172965,
							["y"] = 665.7659429829421
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeTwilight",
							["UnitId"] = -1
						}
					},
					["174228308433410206573"] = {
						["key"] = "174228308433410206573",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "停止播放站桩BGM",
						["pos"] = {
							["x"] = 2319.609687350161,
							["y"] = 329.79543345782395
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["174228308433410206574"] = {
						["key"] = "174228308433410206574",
						["type"] = "TalkNode",
						["name"] = "别打了",
						["pos"] = {
							["x"] = 832.2999999999998,
							["y"] = 306.85714285714283
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10110201,
							["FlowAssetPath"] = "",
							["TalkType"] = "QuestImpression",
							["TalkStageName"] = "Stage_101102",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "P101102Player",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200004,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200069,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					}
				},
				["commentData"] = {}
			}
		},
		["174228308433310206330"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206330",
			["type"] = "StoryNode",
			["name"] = "散心",
			["pos"] = {
				["x"] = 638.0714285714286,
				["y"] = 569.2605872388481
			},
			["propsData"] = {
				["QuestId"] = 10020611,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020611",
				["QuestDeatil"] = "QuestName_10020611",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "P1240031",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206579",
						["startPort"] = "Fail",
						["endQuest"] = "174228308433410206580",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206580",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206582",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206584",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206587",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206589",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206577",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "174228308433410206575",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206590",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206582",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206592",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206592",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206589",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206585",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206588",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206579",
						["startPort"] = "Success",
						["endQuest"] = "174228308433410206594",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206594",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206585",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206583",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206584",
						["endPort"] = "Branch_1"
					},
					{
						["startQuest"] = "174228308433410206579",
						["startPort"] = "PassiveFail",
						["endQuest"] = "174228308433410206580",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17453019194873835654",
						["startPort"] = "Out",
						["endQuest"] = "17453019194873835655",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206579",
						["startPort"] = "Success",
						["endQuest"] = "17453029796455474413",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17453029796455474413",
						["startPort"] = "Out",
						["endQuest"] = "17453019194873835654",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206575",
						["startPort"] = "QuestStart",
						["endQuest"] = "17540313914132663960",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17540313914132663960",
						["startPort"] = "true",
						["endQuest"] = "174228308433410206579",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206575",
						["startPort"] = "QuestStart",
						["endQuest"] = "17540314826303651076",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17540313914132663960",
						["startPort"] = "false",
						["endQuest"] = "174228308433410206578",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206578",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206579",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206579",
						["startPort"] = "Fail",
						["endQuest"] = "175403591836510892888",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206579",
						["startPort"] = "PassiveFail",
						["endQuest"] = "175403591836510892888",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17540313914132663960",
						["startPort"] = "true",
						["endQuest"] = "1754555273954344418",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206578",
						["startPort"] = "Out",
						["endQuest"] = "1754555273954344418",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17453019194873835655",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206576",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["174228308433410206575"] = {
						["key"] = "174228308433410206575",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -1761.4454890020124,
							["y"] = 151.493269804549
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206576"] = {
						["key"] = "174228308433410206576",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 992.8070474249369,
							["y"] = 99.01079314512629
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206577"] = {
						["key"] = "174228308433410206577",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 986.7252032539284,
							["y"] = 262.4921271421803
						},
						["propsData"] = {}
					},
					["174228308433410206578"] = {
						["key"] = "174228308433410206578",
						["type"] = "GoToNode",
						["name"] = "goto 散步开始位置",
						["pos"] = {
							["x"] = -761.556152609497,
							["y"] = 279.88121746452435
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240031,
							["GuideType"] = "P",
							["GuidePointName"] = "P1240031"
						}
					},
					["174228308433410206579"] = {
						["key"] = "174228308433410206579",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = -290.53445691617804,
							["y"] = 140.3859546075163
						},
						["propsData"] = {
							["SpecialConfigId"] = 106,
							["BlackScreenImmediately"] = true
						}
					},
					["174228308433410206580"] = {
						["key"] = "174228308433410206580",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 赛琪AI2号",
						["pos"] = {
							["x"] = -4.884307031449893,
							["y"] = 269.8647770909664
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = true,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240050
							}
						}
					},
					["174228308433410206582"] = {
						["key"] = "174228308433410206582",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 259.8721476754551,
							["y"] = 268.621874181032
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "P10020611",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["174228308433410206583"] = {
						["key"] = "174228308433410206583",
						["type"] = "BranchQuestStartNode",
						["name"] = "子任务开始节点",
						["pos"] = {
							["x"] = -373.41244721389626,
							["y"] = -447.7576617799682
						},
						["propsData"] = {
							["AllQuestOptions"] = {
								{
									["IsNeedFinish"] = false,
									["BranchQuestName"] = "QuestName_10020611_1",
									["TargetBranchQuestKey"] = ""
								}
							},
							["IsSetCountInfo"] = false,
							["IsDifftation"] = false,
							["AllDiffGuideOptions"] = {}
						}
					},
					["174228308433410206584"] = {
						["key"] = "174228308433410206584",
						["type"] = "CheckBranchQuestFinishedNode",
						["name"] = "子任务结束节点",
						["pos"] = {
							["x"] = 340.4462484382778,
							["y"] = -481.33758505362545
						},
						["propsData"] = {
							["InputBranchQuestNumber"] = 1,
							["BranchQuestFinishOptions"] = {
								{
									["IsNeedFinish"] = false
								}
							}
						}
					},
					["174228308433410206585"] = {
						["key"] = "174228308433410206585",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = 224.35075141165936,
							["y"] = -164.2958614630599
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["174228308433410206587"] = {
						["key"] = "174228308433410206587",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 683.5056702395415,
							["y"] = -424.7055923591632
						},
						["propsData"] = {
							["IsShow"] = true,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_SaiqiWalkEnd"
						}
					},
					["174228308433410206588"] = {
						["key"] = "174228308433410206588",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 459.8502859179806,
							["y"] = -174.3083783244879
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_SaiqiWalkEnd"
						}
					},
					["174228308433410206589"] = {
						["key"] = "174228308433410206589",
						["type"] = "ShowOrHideTaskIndicatorNode",
						["name"] = "显示/隐藏任务指引点节点",
						["pos"] = {
							["x"] = 738.2156705333651,
							["y"] = 262.67623706012745
						},
						["propsData"] = {
							["IsShow"] = false,
							["bOpenRangeEffect"] = false,
							["GuideType"] = "P",
							["GuideName"] = "QuestPoint_SaiqiWalkEnd"
						}
					},
					["174228308433410206590"] = {
						["key"] = "174228308433410206590",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,黄昏",
						["pos"] = {
							["x"] = -1102.9428630541297,
							["y"] = 416.76594298294253
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeTwilight",
							["UnitId"] = -1
						}
					},
					["174228308433410206591"] = {
						["key"] = "174228308433410206591",
						["type"] = "TalkNode",
						["name"] = "过场动画黑屏衔接",
						["pos"] = {
							["x"] = -1417.4475182969788,
							["y"] = -93.79346530662383
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["TalkType"] = "Cinematic",
							["TalkStageName"] = "",
							["ShowFilePath"] = "/Game/AssetDesign/Story/Sequence/Common/Common_PureBlack",
							["BlendOutTime"] = 0.5,
							["InType"] = "BlendIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["ShowSkipButton"] = false,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["PauseGameGlobal"] = true,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideEffectCreature"] = true,
							["HideMechanismsFX"] = true,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								}
							},
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206592"] = {
						["key"] = "174228308433410206592",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停bgm",
						["pos"] = {
							["x"] = 493.5999999999997,
							["y"] = 265.60000000000014
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["174228308433410206594"] = {
						["key"] = "174228308433410206594",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停bgm",
						["pos"] = {
							["x"] = -23.90000000000032,
							["y"] = -193.24999999999997
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17453019194873835654"] = {
						["key"] = "17453019194873835654",
						["type"] = "WaitOfTimeNode",
						["name"] = "0.3",
						["pos"] = {
							["x"] = 272.01275856985285,
							["y"] = 52.148997592181814
						},
						["propsData"] = {
							["WaitTime"] = 0.3
						}
					},
					["17453019194873835655"] = {
						["key"] = "17453019194873835655",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = 424.70672408709424,
							["y"] = 151.33003207494033
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_Icelake_SaiqiWalkCleanUp",
							["UnitId"] = -1
						}
					},
					["17453029796455474413"] = {
						["key"] = "17453029796455474413",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 94.42013764973622,
							["y"] = -40.61518019185886
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "P10109922Nvzhu",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = true,
							["IsWhite"] = false
						}
					},
					["17540313914132663960"] = {
						["key"] = "17540313914132663960",
						["type"] = "ExecuteBlueprintFunctionCheckVarNode",
						["name"] = "判断是否两阶段连打",
						["pos"] = {
							["x"] = -1027.327602057441,
							["y"] = 138.43167731155853
						},
						["propsData"] = {
							["FunctionName"] = "Equal",
							["VarName"] = "SaiqiWalk100206",
							["Duration"] = 0,
							["VarInfos"] = {
								{
									["VarName"] = "Value",
									["VarValue"] = "1"
								}
							}
						}
					},
					["17540314826303651076"] = {
						["key"] = "17540314826303651076",
						["type"] = "PrintVarNode",
						["name"] = "打印SaiqiWalk100206",
						["pos"] = {
							["x"] = -1014.5036924481366,
							["y"] = 11.524626973891891
						},
						["propsData"] = {
							["VarName"] = "SaiqiWalk100206"
						}
					},
					["175403591836510892888"] = {
						["key"] = "175403591836510892888",
						["type"] = "SetVarNode",
						["name"] = "设置变量",
						["pos"] = {
							["x"] = 0.8067412405654864,
							["y"] = 394.7906272318035
						},
						["propsData"] = {
							["VarName"] = "SaiqiWalk100206",
							["VarValue"] = 0
						}
					},
					["1754555273954344418"] = {
						["key"] = "1754555273954344418",
						["type"] = "SetVarNode",
						["name"] = "设置变量",
						["pos"] = {
							["x"] = -528.6577921568887,
							["y"] = 39.48471747065084
						},
						["propsData"] = {
							["VarName"] = "SaiqiWalk100206",
							["VarValue"] = 0
						}
					}
				},
				["commentData"] = {
					["17214730289024893539"] = {
						["key"] = "17214730289024893539",
						["name"] = "临时处理的产物",
						["position"] = {
							["x"] = -418.07238510209595,
							["y"] = -561.2902704756203
						},
						["size"] = {
							["width"] = 1362.13448420689,
							["height"] = 272.8148591840994
						}
					}
				}
			}
		},
		["174228308433310206331"] = {
			["isStoryNode"] = true,
			["key"] = "174228308433310206331",
			["type"] = "StoryNode",
			["name"] = "前往泪湖",
			["pos"] = {
				["x"] = 378.695256916996,
				["y"] = 573.9305194805195
			},
			["propsData"] = {
				["QuestId"] = 10020608,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020608",
				["QuestDeatil"] = "QuestName_10020608",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = true,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101103,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "Mechanism_QuestTrigger_1240261",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "174228308433410206606",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206597",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "174228308433410206608",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206609",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206609",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206610",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206607",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206608",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206600",
						["startPort"] = "Fail",
						["endQuest"] = "174228308433410206601",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206601",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206606",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206595",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206607",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206600",
						["startPort"] = "PassiveFail",
						["endQuest"] = "174228308433410206601",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206599",
						["startPort"] = "Out",
						["endQuest"] = "17441070471244931502",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206599",
						["startPort"] = "Out",
						["endQuest"] = "17441070471244931503",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17441070471244931502",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206600",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206599",
						["startPort"] = "Out",
						["endQuest"] = "17441073198906850091",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17441073198906850090",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206596",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "174228308433410206600",
						["startPort"] = "Success",
						["endQuest"] = "17540339059725958376",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17540339059725958376",
						["startPort"] = "Out",
						["endQuest"] = "17441073198906850090",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17540339059725958376",
						["startPort"] = "Out",
						["endQuest"] = "17540353286757933192",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206595",
						["startPort"] = "QuestStart",
						["endQuest"] = "174228308433410206599",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "174228308433410206599",
						["startPort"] = "Out",
						["endQuest"] = "174228308433410206602",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["174228308433410206595"] = {
						["key"] = "174228308433410206595",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -918.3605835779014,
							["y"] = 499.41005947457546
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206596"] = {
						["key"] = "174228308433410206596",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1611.1607142857144,
							["y"] = 331.5357142857143
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["174228308433410206597"] = {
						["key"] = "174228308433410206597",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1604.107142857143,
							["y"] = 570.2142857142859
						},
						["propsData"] = {}
					},
					["174228308433410206598"] = {
						["key"] = "174228308433410206598",
						["type"] = "TalkNode",
						["name"] = "恩里克闲置",
						["pos"] = {
							["x"] = -436.04809254514976,
							["y"] = 227.0133384380535
						},
						["propsData"] = {
							["IsNpcNode"] = true,
							["NpcNodeInteractiveName"] = "",
							["NpcId"] = 200005,
							["GuideUIEnable"] = false,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_101093Enlike_1200088",
							["DelayShowGuideTime"] = 0,
							["IsPlayerTurnToNPC"] = true,
							["IsNPCTurnToPlayer"] = true,
							["FirstDialogueId"] = 10114401,
							["FlowAssetPath"] = "",
							["TalkType"] = "FreeSimple",
							["BlendInTime"] = 1,
							["BlendOutTime"] = 1,
							["InType"] = "BlendIn",
							["OutType"] = "BlendOut",
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = true,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "Player",
							["PlayerSwitchEmoIdle"] = true,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["174228308433410206599"] = {
						["key"] = "174228308433410206599",
						["type"] = "GoToNode",
						["name"] = "goto 冰湖出发点",
						["pos"] = {
							["x"] = -449.9099520190845,
							["y"] = 547.9214091677014
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1240261,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1240261"
						}
					},
					["174228308433410206600"] = {
						["key"] = "174228308433410206600",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "等待特殊任务开始并完成",
						["pos"] = {
							["x"] = 567.2917073851619,
							["y"] = 364.8563735698957
						},
						["propsData"] = {
							["SpecialConfigId"] = 107,
							["BlackScreenImmediately"] = true
						}
					},
					["174228308433410206601"] = {
						["key"] = "174228308433410206601",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1082.238783773099,
							["y"] = 570.4476434111659
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "QuestPoint_SaiqiWalkReset",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["174228308433410206602"] = {
						["key"] = "174228308433410206602",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,黄昏",
						["pos"] = {
							["x"] = -59.79112474387108,
							["y"] = 334.16073746061227
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeTwilight",
							["UnitId"] = -1
						}
					},
					["174228308433410206605"] = {
						["key"] = "174228308433410206605",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,黄昏",
						["pos"] = {
							["x"] = -20.704767816036238,
							["y"] = -70.23405701705718
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityTwilight",
							["UnitId"] = -1
						}
					},
					["174228308433410206606"] = {
						["key"] = "174228308433410206606",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停bgm",
						["pos"] = {
							["x"] = 1361.3490592148846,
							["y"] = 571.0000000000002
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["174228308433410206607"] = {
						["key"] = "174228308433410206607",
						["type"] = "RestoreRoleNode",
						["name"] = "恢复角色",
						["pos"] = {
							["x"] = -466.95092601757284,
							["y"] = 742.0620194385552
						},
						["propsData"] = {}
					},
					["174228308433410206608"] = {
						["key"] = "174228308433410206608",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "关闭 攻击放技能",
						["pos"] = {
							["x"] = -243.71210168401234,
							["y"] = 743.8951704980221
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Attack",
								"Skill1",
								"Skill2",
								"Skill3",
								"FallAttack",
								"SlideAttack",
								"Fire",
								"Avoid",
								"HeavyAttack",
								"FireInAir",
								"Slide",
								"Jump",
								"BulletJump"
							}
						}
					},
					["174228308433410206609"] = {
						["key"] = "174228308433410206609",
						["type"] = "ForbidWeaponByWeaponTagNode",
						["name"] = "禁用/启用武器节点",
						["pos"] = {
							["x"] = -6.8514044864730295,
							["y"] = 744.5195040591975
						},
						["propsData"] = {
							["WeaponTags"] = {
								"Melee"
							},
							["bForbid"] = false,
							["ForbidTag"] = "ForbidDefault",
							["bHidewhenForbid"] = true
						}
					},
					["174228308433410206610"] = {
						["key"] = "174228308433410206610",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = -4.594811762690824,
							["y"] = 850.0237502852079
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = false
						}
					},
					["17441070471244931502"] = {
						["key"] = "17441070471244931502",
						["type"] = "TalkNode",
						["name"] = "看景色",
						["pos"] = {
							["x"] = 266.57286058378236,
							["y"] = 366.5946275946275
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10124500,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_200044",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = true,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "P200044Nvzhu",
							["CameraLookAtTartgetPoint"] = "P1240651",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200006,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = true,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17441070471244931503"] = {
						["key"] = "17441070471244931503",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "放Bgm",
						["pos"] = {
							["x"] = 274.76426134252216,
							["y"] = 523.4418914418915
						},
						["propsData"] = {
							["SoundStateType"] = 0,
							["SoundPriority"] = 0,
							["SoundType"] = 0,
							["SoundPath"] = "event:/bgm/cbt02/0039_story_saiqi_see_flower",
							["ParamKey"] = "",
							["ParamValue"] = 0,
							["RelatedRegionId"] = {},
							["ClientRelatedRegionId"] = {},
							["bStoreToServer"] = true
						}
					},
					["17441073198906850089"] = {
						["key"] = "17441073198906850089",
						["type"] = "SendMessageNode",
						["name"] = "召唤装饰npc",
						["pos"] = {
							["x"] = 290.44750298011206,
							["y"] = 653.0776240667543
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_Icelake_SaiqiWalk",
							["UnitId"] = -1
						}
					},
					["17441073198906850090"] = {
						["key"] = "17441073198906850090",
						["type"] = "SendMessageNode",
						["name"] = "销毁装饰npc",
						["pos"] = {
							["x"] = 1359.9431426061863,
							["y"] = 333.8877438986134
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "Chapter01_Icelake_SaiqiWalkCleanUp",
							["UnitId"] = -1
						}
					},
					["17441073198906850091"] = {
						["key"] = "17441073198906850091",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成引导用的蝴蝶和花",
						["pos"] = {
							["x"] = 302.2635359809274,
							["y"] = 772.1614659629697
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1240651,
								1240652,
								1240653,
								1240654
							}
						}
					},
					["17540339059725958376"] = {
						["key"] = "17540339059725958376",
						["type"] = "SetVarNode",
						["name"] = "设置变量",
						["pos"] = {
							["x"] = 1085.348948072052,
							["y"] = 333.2232405322574
						},
						["propsData"] = {
							["VarName"] = "SaiqiWalk100206",
							["VarValue"] = 1
						}
					},
					["17540353286757933192"] = {
						["key"] = "17540353286757933192",
						["type"] = "PrintVarNode",
						["name"] = "打印SaiqiWalk100206",
						["pos"] = {
							["x"] = 1361.0483336359089,
							["y"] = 201.11456157680445
						},
						["propsData"] = {
							["VarName"] = "SaiqiWalk100206"
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17548930632194490"] = {
			["isStoryNode"] = true,
			["key"] = "17548930632194490",
			["type"] = "StoryNode",
			["name"] = "前往疗养院找小白",
			["pos"] = {
				["x"] = -426.49783866051325,
				["y"] = 359.0549511340587
			},
			["propsData"] = {
				["QuestId"] = 10020651,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020601",
				["QuestDeatil"] = "QuestDesc_10020601",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = true,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = true,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 0,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Point",
				["StoryGuidePointName"] = "",
				["JumpId"] = 0,
				["QuestUIId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17548930632214498",
						["startPort"] = "Out",
						["endQuest"] = "17548930632214496",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17548930632214496",
						["startPort"] = "Out",
						["endQuest"] = "17548930632214497",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17548930632214497",
						["startPort"] = "Out",
						["endQuest"] = "17548930632234504",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17548930632234504",
						["startPort"] = "Out",
						["endQuest"] = "17548930632214499",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17548930632224501",
						["startPort"] = "QuestStart",
						["endQuest"] = "17548930632234505",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17548930632234505",
						["startPort"] = "Out",
						["endQuest"] = "17548930632234506",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17548930632234505",
						["startPort"] = "Out",
						["endQuest"] = "17548930632214498",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17548930632234505",
						["startPort"] = "Out",
						["endQuest"] = "17548930632444579",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17548930632214499",
						["startPort"] = "Out",
						["endQuest"] = "1757332776534650965",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1757332776534650965",
						["startPort"] = "Out",
						["endQuest"] = "17548930632224502",
						["endPort"] = "Success"
					}
				},
				["nodeData"] = {
					["17548930632214496"] = {
						["key"] = "17548930632214496",
						["type"] = "GoToNode",
						["name"] = "goto 疗养院隐蔽处",
						["pos"] = {
							["x"] = 1302.526948125586,
							["y"] = 250.9957340188795
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1190205,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QuestTrigger_1190205"
						}
					},
					["17548930632214497"] = {
						["key"] = "17548930632214497",
						["type"] = "TalkNode",
						["name"] = "小白在等你",
						["pos"] = {
							["x"] = 1549.9169157446745,
							["y"] = 245.6027384569225
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10108501,
							["FlowAssetPath"] = "",
							["TalkType"] = "FixSimple",
							["TalkStageName"] = "Stage_101085",
							["BlendInTime"] = 0.5,
							["BlendOutTime"] = 0.5,
							["InType"] = "FadeIn",
							["OutType"] = "FadeOut",
							["ShowFadeDetail"] = false,
							["BlendEaseExp"] = 2,
							["UseProceduralCamera"] = false,
							["ProceduralCameraId"] = 1,
							["HideNpcs"] = false,
							["HideMonsters"] = true,
							["HideAllBattleEntity"] = true,
							["HideMechanismsFX"] = true,
							["ShowSkipButton"] = true,
							["ShowAutoPlayButton"] = true,
							["ShowReviewButton"] = true,
							["ShowWikiButton"] = true,
							["SkipToOption"] = false,
							["DisableNpcOptimization"] = false,
							["DoNotReceiveCharacterShadow"] = false,
							["PauseTimeElapse"] = false,
							["BeginNewTargetPointName"] = "",
							["EndNewTargetPointName"] = "",
							["CameraLookAtTartgetPoint"] = "",
							["RestoreStand"] = false,
							["PauseNpcBT"] = true,
							["TalkActors"] = {
								{
									["TalkActorType"] = "Player",
									["TalkActorId"] = 0,
									["TalkActorVisible"] = false,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 100001,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200064,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200021,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								},
								{
									["TalkActorType"] = "Npc",
									["TalkActorId"] = 200005,
									["TalkActorVisible"] = true,
									["AroundPlayer"] = false
								}
							},
							["OptionType"] = "normal",
							["FreezeWorldComposition"] = false,
							["bTravelFullLoadWorldComposition"] = false,
							["SwitchToMaster"] = "None",
							["bNpcActionKeepIn"] = true,
							["bNpcActionKeepOut"] = false,
							["bForceWaitNavLoaded"] = false,
							["NormalOptions"] = {},
							["OverrideFailBlend"] = false
						}
					},
					["17548930632214498"] = {
						["key"] = "17548930632214498",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 小白",
						["pos"] = {
							["x"] = 1075.8469778632018,
							["y"] = 264.41772260068564
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190280
							}
						}
					},
					["17548930632214499"] = {
						["key"] = "17548930632214499",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 小白",
						["pos"] = {
							["x"] = 1548.7075781350818,
							["y"] = 499.5624651633069
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190280
							}
						}
					},
					["17548930632224501"] = {
						["key"] = "17548930632224501",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 521.1737428842496,
							["y"] = 249.93989563567362
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17548930632224502"] = {
						["key"] = "17548930632224502",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1847.8489245512978,
							["y"] = 636.7703653151716
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17548930632224503"] = {
						["key"] = "17548930632224503",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 2471.1148040797048,
							["y"] = 1086.0481501525774
						},
						["propsData"] = {}
					},
					["17548930632234504"] = {
						["key"] = "17548930632234504",
						["type"] = "PlayOrStopBGMNode",
						["name"] = "暂停幽默音乐",
						["pos"] = {
							["x"] = 1541.183285893884,
							["y"] = 392.8488136924232
						},
						["propsData"] = {
							["SoundStateType"] = 3,
							["SoundPriority"] = 0,
							["SoundType"] = 0
						}
					},
					["17548930632234505"] = {
						["key"] = "17548930632234505",
						["type"] = "GoToRegionNode",
						["name"] = "等待位于冰湖城",
						["pos"] = {
							["x"] = 815.968998907623,
							["y"] = 244.346571172434
						},
						["propsData"] = {
							["RegionType"] = 1,
							["IsEnter"] = "Enter",
							["RegionId"] = 101101,
							["bGuideUIEnable"] = true,
							["GuideType"] = "P",
							["GuideName"] = "P10101202"
						}
					},
					["17548930632234506"] = {
						["key"] = "17548930632234506",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = 1100.0880869702362,
							["y"] = 75.50256619810416
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					},
					["17548930632444579"] = {
						["key"] = "17548930632444579",
						["type"] = "SwitchMechanismStateNode",
						["name"] = "花店开门",
						["pos"] = {
							["x"] = 984.5444373401524,
							["y"] = 481.67391304347825
						},
						["propsData"] = {
							["StaticCreatorIdList"] = {},
							["ManualItemIdList"] = {
								119002
							},
							["StateId"] = 26,
							["QuestId"] = 0
						}
					},
					["1757332776534650965"] = {
						["key"] = "1757332776534650965",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成 奥哥",
						["pos"] = {
							["x"] = 1596.6105263157897,
							["y"] = 622.6114416475972
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190281
							}
						}
					}
				},
				["commentData"] = {
					["1743319517392787789"] = {
						["key"] = "1743319517392787789",
						["name"] = "恩里克暂停",
						["position"] = {
							["x"] = 1523.4455624354994,
							["y"] = 62.052631578947164
						},
						["size"] = {
							["width"] = 262.94117647058835,
							["height"] = 675.8823529411766
						}
					}
				}
			}
		},
		["17549800420471825479"] = {
			["isStoryNode"] = true,
			["key"] = "17549800420471825479",
			["type"] = "StoryNode",
			["name"] = "前往疗养院找小白",
			["pos"] = {
				["x"] = -160.56739891326447,
				["y"] = 352.7745635035478
			},
			["propsData"] = {
				["QuestId"] = 10020652,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10020602",
				["QuestDeatil"] = "QuestDesc_10020602",
				["TaskRegionReName"] = "",
				["TaskSubRegionReName"] = "",
				["RecommendLevel"] = -1,
				["bIsStartQuest"] = false,
				["bIsEndQuest"] = false,
				["bIsNotifyGameMode"] = true,
				["bIsStartChapter"] = false,
				["bIsEndChapter"] = false,
				["bIsPlayBlackScreenOnComplete"] = false,
				["bIsPlayBlackScreenOnFail"] = false,
				["bIsDynamicEvent"] = false,
				["ResurgencePoint"] = "",
				["bUseQuestCoordinate"] = false,
				["bDeadTriggerQuestFail"] = false,
				["IsFairyLand"] = false,
				["IsBacktrack"] = false,
				["SubRegionId"] = 101101,
				["SubRegionIdList"] = {},
				["StoryGuideType"] = "Mechanism",
				["StoryGuidePointName"] = "1191290",
				["JumpId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {
					{
						["startQuest"] = "17549800420501825489",
						["startPort"] = "QuestStart",
						["endQuest"] = "17549800420671825549",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17549800420671825549",
						["startPort"] = "Out",
						["endQuest"] = "17549800866911826725",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17549800866911826725",
						["startPort"] = "Fail",
						["endQuest"] = "1756906523846962679",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17549800866911826725",
						["startPort"] = "PassiveFail",
						["endQuest"] = "1756906523846962679",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1756906523846962679",
						["startPort"] = "Out",
						["endQuest"] = "17549800420501825491",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "17549800866911826725",
						["startPort"] = "Success",
						["endQuest"] = "17574001025331311258",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17574001025331311258",
						["startPort"] = "Out",
						["endQuest"] = "17549800420501825490",
						["endPort"] = "Success"
					},
					{
						["startQuest"] = "17549800420501825489",
						["startPort"] = "QuestStart",
						["endQuest"] = "17587184370998384",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["17549800420501825489"] = {
						["key"] = "17549800420501825489",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = 521.1737428842496,
							["y"] = 249.93989563567362
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17549800420501825490"] = {
						["key"] = "17549800420501825490",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 1623.8812226879434,
							["y"] = 245.5082535139292
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["17549800420501825491"] = {
						["key"] = "17549800420501825491",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = 1644.0607349604181,
							["y"] = 488.63826535138816
						},
						["propsData"] = {}
					},
					["17549800420671825549"] = {
						["key"] = "17549800420671825549",
						["type"] = "GoToNode",
						["name"] = "找恩里克",
						["pos"] = {
							["x"] = 846.8611865201951,
							["y"] = 255.88461684514326
						},
						["propsData"] = {
							["GuideUIEnable"] = true,
							["StaticCreatorId"] = 1191290,
							["GuideType"] = "M",
							["GuidePointName"] = "Mechanism_QusetCheck_1191290"
						}
					},
					["17549800866911826725"] = {
						["key"] = "17549800866911826725",
						["type"] = "WaitingSpecialQuestStartAndFinishNode",
						["name"] = "跟踪恩里克",
						["pos"] = {
							["x"] = 1129.6614744904225,
							["y"] = 280.7154906497019
						},
						["propsData"] = {
							["SpecialConfigId"] = 120,
							["BlackScreenImmediately"] = false
						}
					},
					["1756906523846962679"] = {
						["key"] = "1756906523846962679",
						["type"] = "AsyncSetActorLocationAndRotationNode",
						["name"] = "异步设置玩家位置旋转",
						["pos"] = {
							["x"] = 1401.284160442913,
							["y"] = 389.81392234767515
						},
						["propsData"] = {
							["UnitId"] = 0,
							["NewTargetPointName"] = "P10108512",
							["FadeIn"] = false,
							["FadeOut"] = false,
							["bResetCamera"] = true,
							["bForceAsyncLoading"] = false,
							["IsWhite"] = false
						}
					},
					["17574001025331311258"] = {
						["key"] = "17574001025331311258",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "销毁 上一环任务生成的奥哥",
						["pos"] = {
							["x"] = 1389.0318305982446,
							["y"] = 259.14524617996614
						},
						["propsData"] = {
							["ActiveEnable"] = false,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1190281
							}
						}
					},
					["17587184370998384"] = {
						["key"] = "17587184370998384",
						["type"] = "SendMessageNode",
						["name"] = "发送消息,夜里",
						["pos"] = {
							["x"] = 1130,
							["y"] = 582.1457167300249
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "IcelakeCityNight",
							["UnitId"] = -1
						}
					}
				},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}