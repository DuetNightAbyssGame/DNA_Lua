return {
	["storyName"] = "Home",
	["storyDescription"] = "",
	["lineData"] = {
		{
			["startStory"] = "17410072607242040045",
			["startPort"] = "StoryStart",
			["endStory"] = "1732783210919573783",
			["endPort"] = "In"
		},
		{
			["startStory"] = "1732783210919573783",
			["startPort"] = "Success",
			["endStory"] = "17410072607242040046",
			["endPort"] = "StoryEnd"
		}
	},
	["storyNodeData"] = {
		["1732783210919573783"] = {
			["isStoryNode"] = true,
			["key"] = "1732783210919573783",
			["type"] = "StoryNode",
			["name"] = "剧院外",
			["pos"] = {
				["x"] = 1219.1427550284327,
				["y"] = 285.2132579736025
			},
			["propsData"] = {
				["QuestId"] = 0,
				["QuestDescriptionComment"] = "",
				["QuestDescription"] = "QuestName_10030602",
				["QuestDeatil"] = "QuestDesc_10030602",
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
						["startQuest"] = "1732783210919573788",
						["startPort"] = "Out",
						["endQuest"] = "1732783210919573786",
						["endPort"] = "Fail"
					},
					{
						["startQuest"] = "1730789001102622452",
						["startPort"] = "Out",
						["endQuest"] = "1730789001102622453",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1730789001102622452",
						["startPort"] = "Out",
						["endQuest"] = "1730789001102622454",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1730789001102622450",
						["startPort"] = "Out",
						["endQuest"] = "1730789001102622452",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1730789001102622452",
						["startPort"] = "Out",
						["endQuest"] = "1730789001102622456",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17409938014972259",
						["startPort"] = "Out",
						["endQuest"] = "1730789001102622450",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17411618964474478",
						["startPort"] = "Out",
						["endQuest"] = "17409938014972259",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1730789001102622451",
						["startPort"] = "Out",
						["endQuest"] = "1741005961812529882",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1741005961812529882",
						["startPort"] = "Out",
						["endQuest"] = "17411618964474478",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210919573784",
						["startPort"] = "QuestStart",
						["endQuest"] = "1732783210919573788",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17409938014972259",
						["startPort"] = "Out",
						["endQuest"] = "17485031989062630",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1748504499645978",
						["startPort"] = "Out",
						["endQuest"] = "17411604850441600",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1732783210919573784",
						["startPort"] = "QuestStart",
						["endQuest"] = "1730789001102622451",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1730789001102622453",
						["startPort"] = "Out",
						["endQuest"] = "17307911090101257971",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "1730789001102622453",
						["startPort"] = "Out",
						["endQuest"] = "17411605029752671",
						["endPort"] = "In"
					},
					{
						["startQuest"] = "17411605029752671",
						["startPort"] = "Out",
						["endQuest"] = "1748504499645978",
						["endPort"] = "In"
					}
				},
				["nodeData"] = {
					["1730789001102622450"] = {
						["key"] = "1730789001102622450",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效 子弹跳/攻击",
						["pos"] = {
							["x"] = -2000.8220048455373,
							["y"] = 56.67786903389435
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = false,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"BulletJump",
								"Attack",
								"Avoid",
								"Slide",
								"Skill1",
								"Jump",
								"Fire"
							}
						}
					},
					["1730789001102622451"] = {
						["key"] = "1730789001102622451",
						["type"] = "ChangeRoleNode",
						["name"] = "切换角色",
						["pos"] = {
							["x"] = -3002.599302059092,
							["y"] = 85.6422148226711
						},
						["propsData"] = {
							["QuestRoleId"] = 11030111,
							["IsPlayFX"] = false
						}
					},
					["1730789001102622452"] = {
						["key"] = "1730789001102622452",
						["type"] = "PlayerSwitchWalkRunNode",
						["name"] = "玩家走跑切换-走",
						["pos"] = {
							["x"] = -1710.062256508526,
							["y"] = 53.518000341589016
						},
						["propsData"] = {
							["Rate"] = 1,
							["Mode"] = "ToRun"
						}
					},
					["1730789001102622453"] = {
						["key"] = "1730789001102622453",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = -1367.168777764382,
							["y"] = 231.9487292141058
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "EnergySkill",
							["ActionParam"] = "None",
							["ShowOrHide"] = true
						}
					},
					["1730789001102622454"] = {
						["key"] = "1730789001102622454",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = -1373.0752273300227,
							["y"] = -83.82049678271784
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "BloodBar",
							["ActionParam"] = "None",
							["ShowOrHide"] = true
						}
					},
					["1730789001102622456"] = {
						["key"] = "1730789001102622456",
						["type"] = "ShowOrHideUINode",
						["name"] = "显示或隐藏UI",
						["pos"] = {
							["x"] = -1372.1551736853057,
							["y"] = 74.49647467502527
						},
						["propsData"] = {
							["Function"] = "HideUIInScreen",
							["UIParam"] = "Map",
							["ActionParam"] = "None",
							["ShowOrHide"] = true
						}
					},
					["17307911090101257971"] = {
						["key"] = "17307911090101257971",
						["type"] = "TalkNode",
						["name"] = "开车",
						["pos"] = {
							["x"] = -977.1376814522378,
							["y"] = 222.40203475292384
						},
						["propsData"] = {
							["IsNpcNode"] = false,
							["FirstDialogueId"] = 10036305,
							["FlowAssetPath"] = "",
							["TalkType"] = "Guide",
							["bIsStandalone"] = true,
							["GuideMeshIndexList"] = {},
							["IsPlayStartSound"] = false,
							["GuideTalkStyle"] = "Normal",
							["OverrideFailBlend"] = false
						}
					},
					["1732783210919573784"] = {
						["key"] = "1732783210919573784",
						["type"] = "QuestStartNode",
						["name"] = "QuestStart",
						["pos"] = {
							["x"] = -3545.9417748436754,
							["y"] = 558.1634755769636
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210919573785"] = {
						["key"] = "1732783210919573785",
						["type"] = "QuestSuccessNode",
						["name"] = "QuestSuccess",
						["pos"] = {
							["x"] = 128.0620708492537,
							["y"] = 512.2562629938684
						},
						["propsData"] = {
							["ModeType"] = 0
						}
					},
					["1732783210919573786"] = {
						["key"] = "1732783210919573786",
						["type"] = "QuestFailNode",
						["name"] = "QuestFail",
						["pos"] = {
							["x"] = -1761.0814398302914,
							["y"] = 995.3346448126867
						},
						["propsData"] = {}
					},
					["1732783210919573788"] = {
						["key"] = "1732783210919573788",
						["type"] = "WaitingSpecialQuestFailNode",
						["name"] = "等待特殊任务失败",
						["pos"] = {
							["x"] = -2885.211683179514,
							["y"] = 984.911085265008
						},
						["propsData"] = {}
					},
					["17409938014972259"] = {
						["key"] = "17409938014972259",
						["type"] = "AtmosphereNpcHideNode",
						["name"] = "氛围NPC显示/隐藏节点",
						["pos"] = {
							["x"] = -2298.093137254902,
							["y"] = 57
						},
						["propsData"] = {
							["IsHide"] = true,
							["AtmosphereTagList"] = {
								"cp2iclsphide"
							}
						}
					},
					["1741005961812529882"] = {
						["key"] = "1741005961812529882",
						["type"] = "SendMessageNode",
						["name"] = "发送消息",
						["pos"] = {
							["x"] = -2770,
							["y"] = 228
						},
						["propsData"] = {
							["MessageType"] = "GameMode",
							["MessageContent"] = "cp2theaairwallact",
							["UnitId"] = -1
						}
					},
					["17411604850441600"] = {
						["key"] = "17411604850441600",
						["type"] = "SpecialQuestSuccessNode",
						["name"] = "成功完成特殊任务",
						["pos"] = {
							["x"] = -230.94285714285735,
							["y"] = 497.4857142857144
						},
						["propsData"] = {}
					},
					["17411605029752671"] = {
						["key"] = "17411605029752671",
						["type"] = "PickUpNode",
						["name"] = "拾取物品",
						["pos"] = {
							["x"] = -988,
							["y"] = 454
						},
						["propsData"] = {
							["bActiveEnable"] = true,
							["StaticCreatorIdList"] = {},
							["QuestPickupId"] = -1,
							["UnitId"] = 100306,
							["UnitCount"] = 1,
							["bGuideUIEnable"] = true,
							["GuideType"] = "N",
							["GuidePointName"] = "Npc_1191201",
							["IsUseCount"] = false
						}
					},
					["17411618964474478"] = {
						["key"] = "17411618964474478",
						["type"] = "ChangeStaticCreatorNode",
						["name"] = "生成/销毁节点",
						["pos"] = {
							["x"] = -2582.156862745098,
							["y"] = 49.081232492997216
						},
						["propsData"] = {
							["ActiveEnable"] = true,
							["EnableBlackScreenSync"] = false,
							["EnableFadeIn"] = false,
							["EnableFadeOut"] = false,
							["NewTargetPointName"] = "",
							["StaticCreatorIdList"] = {
								1191199,
								1191200,
								1191201,
								1191202,
								1191203,
								1191204,
								1191419,
								1191420,
								1191421,
								1191422
							}
						}
					},
					["1742553095876885"] = {
						["key"] = "1742553095876885",
						["type"] = "PlayerAlongSplineMoveNode",
						["name"] = "玩家沿路径移动节点",
						["pos"] = {
							["x"] = -1409.375,
							["y"] = 702
						},
						["propsData"] = {
							["SplineActorIndex"] = 10030601,
							["WalkType"] = 0,
							["MoveSpeedRate"] = 1,
							["ExitBlendTime"] = 0.5,
							["IsTriggerable"] = false,
							["CanMoveReverse"] = false
						}
					},
					["17485031989062630"] = {
						["key"] = "17485031989062630",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效 子弹跳/攻击",
						["pos"] = {
							["x"] = -1992.4158864276526,
							["y"] = -106.29170829170815
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = false,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Skill2",
								"Skill3"
							}
						}
					},
					["1748504499645978"] = {
						["key"] = "1748504499645978",
						["type"] = "ActivePlayerSkillsNode",
						["name"] = "失效 子弹跳/攻击",
						["pos"] = {
							["x"] = -256.2079432138262,
							["y"] = 720
						},
						["propsData"] = {
							["PlayerId"] = 0,
							["bActiveEnable"] = true,
							["ActiveType"] = "Lock",
							["SkillNameList"] = {
								"Skill2",
								"Skill3"
							}
						}
					}
				},
				["commentData"] = {}
			}
		},
		["17410072607242040045"] = {
			["isStoryNode"] = true,
			["key"] = "17410072607242040045",
			["type"] = "StoryStartNode",
			["name"] = "StoryStart",
			["pos"] = {
				["x"] = 800,
				["y"] = 300
			},
			["propsData"] = {
				["QuestChainId"] = 0
			},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		},
		["17410072607242040046"] = {
			["isStoryNode"] = true,
			["key"] = "17410072607242040046",
			["type"] = "StoryEndNode",
			["name"] = "StoryEnd",
			["pos"] = {
				["x"] = 2077.0882352941176,
				["y"] = 294.52941176470586
			},
			["propsData"] = {},
			["questNodeData"] = {
				["lineData"] = {},
				["nodeData"] = {},
				["commentData"] = {}
			}
		}
	},
	["commentData"] = {}
}