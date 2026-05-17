-- Source Excel file path: ..\datas\Combat\MovementParams.xlsx
local T = {}
T.RT_1 = {
		0,
		270,
		0,
	}
T.RT_2 = {
		0.1,
	}
T.RT_3 = {
		1,
	}
T.RT_4 = {
		0,
		3600,
		0,
	}
T.RT_5 = {
		0.4,
	}
T.RT_6 = {
		1200,
	}
T.RT_7 = {
		20,
	}
T.RT_8 = {
		500,
	}
T.RT_9 = {
		0.2,
	}
T.RT_10 = {
		1000,
	}
T.RT_11 = {
		0,
		540,
		0,
	}
T.RT_12 = {
		0.6,
	}
T.RT_13 = {
		0.5,
	}
T.RT_14 = {
		3,
	}
T.RT_15 = {
		0.15,
	}
T.RT_16 = {
		0,
		100,
		0,
	}
T.RT_17 = {
		900,
	}
T.RT_18 = {
		2048,
	}
T.RT_19 = {
		0,
		54,
		0,
	}
T.RT_20 = {
		0,
		1800,
		0,
	}
T.RT_21 = {
		0,
	}
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("PlayerRotationRates", {
	AnimFly = {
		ParamentName = "AnimFly",
		ParamentValue = T.RT_1,
	},
	AvoidLaunchDelay = {
		ParamentName = "AvoidLaunchDelay",
		ParamentValue = T.RT_2,
	},
	AvoidMaintainTime = {
		ParamentName = "AvoidMaintainTime",
		ParamentValue = T.RT_3,
	},
	AvoidSpeed = {
		ParamentName = "AvoidSpeed",
		ParamentValue = {
			1800,
		},
	},
	AvoidStart = {
		ParamentName = "AvoidStart",
		ParamentValue = T.RT_4,
	},
	BlockHeadCheckHeight = {
		ParamentName = "BlockHeadCheckHeight",
		ParamentValue = {
			105,
		},
	},
	BoneHitCD = {
		ParamentName = "BoneHitCD",
		ParamentValue = {
			0.9,
		},
	},
	BuffAnimFlyDodgeSpeed = {
		ParamentName = "BuffAnimFlyDodgeSpeed",
		ParamentValue = {
			1500,
		},
	},
	BulletActionEndTime = {
		ParamentName = "BulletActionEndTime",
		ParamentValue = {
			0.8,
		},
	},
	BulletJump = {
		ParamentName = "BulletJump",
		ParamentValue = {
			540,
			20,
			0,
		},
	},
	BulletJumpAllowShootTime = {
		ParamentName = "BulletJumpAllowShootTime",
		ParamentValue = T.RT_5,
	},
	BulletJumpAllowSlideTime = {
		ParamentName = "BulletJumpAllowSlideTime",
		ParamentValue = {
			0.7,
		},
	},
	BulletJumpDashVelocity = {
		ParamentName = "BulletJumpDashVelocity",
		ParamentValue = T.RT_6,
	},
	BulletJumpPreparedTime = {
		ParamentName = "BulletJumpPreparedTime",
		ParamentValue = T.RT_2,
	},
	BulletJumpProtectAngle = {
		ParamentName = "BulletJumpProtectAngle",
		ParamentValue = T.RT_7,
	},
	BulletJumpRecoverGravityTime = {
		ParamentName = "BulletJumpRecoverGravityTime",
		ParamentValue = {
			0.11,
		},
	},
	BulletJumpResetCapTime = {
		ParamentName = "BulletJumpResetCapTime",
		ParamentValue = T.RT_5,
	},
	BulletJumpZVelocity = {
		ParamentName = "BulletJumpZVelocity",
		ParamentValue = T.RT_8,
	},
	BulletPrepareJumpDashVelocity = {
		ParamentName = "BulletPrepareJumpDashVelocity",
		ParamentValue = T.RT_6,
	},
	BulletPrepareJumpZVelocity = {
		ParamentName = "BulletPrepareJumpZVelocity",
		ParamentValue = {
			0.01,
		},
	},
	CanRecoveryDelayTime = {
		ParamentName = "CanRecoveryDelayTime",
		ParamentValue = {
			1.8,
		},
	},
	CanWallJumpAngle = {
		ParamentName = "CanWallJumpAngle",
		ParamentValue = {
			70,
		},
	},
	ContrZIgnoreAngle = {
		ParamentName = "ContrZIgnoreAngle",
		ParamentValue = T.RT_7,
	},
	CrouchWalkSpeed = {
		ParamentName = "CrouchWalkSpeed",
		ParamentValue = {
			160,
		},
	},
	DodgeZeroFrictionTime = {
		ParamentName = "DodgeZeroFrictionTime",
		ParamentValue = T.RT_9,
	},
	Drift = {
		ParamentName = "Drift",
		ParamentValue = {
			0,
			0,
			0,
		},
	},
	DriftFriction = {
		ParamentName = "DriftFriction",
		ParamentValue = T.RT_5,
	},
	DriftMinVelocity = {
		ParamentName = "DriftMinVelocity",
		ParamentValue = {
			400,
		},
	},
	EndSprintTime = {
		ParamentName = "EndSprintTime",
		ParamentValue = T.RT_9,
	},
	FirstJumpZVelocity = {
		ParamentName = "FirstJumpZVelocity",
		ParamentValue = T.RT_10,
	},
	Flying = {
		ParamentName = "Flying",
		ParamentValue = T.RT_11,
	},
	FlyingDodgeSpeed = {
		ParamentName = "FlyingDodgeSpeed",
		ParamentValue = {
			3000,
		},
	},
	ForbidNextAvoidTime = {
		ParamentName = "ForbidNextAvoidTime",
		ParamentValue = T.RT_12,
	},
	ForbidNextSlideTime = {
		ParamentName = "ForbidNextSlideTime",
		ParamentValue = T.RT_13,
	},
	HeavyHitCD = {
		ParamentName = "HeavyHitCD",
		ParamentValue = T.RT_14,
	},
	HeavyHitTime = {
		ParamentName = "HeavyHitTime",
		ParamentValue = {
			1.5,
		},
	},
	HitAddtiveCoolDown = {
		ParamentName = "HitAddtiveCoolDown",
		ParamentValue = T.RT_15,
	},
	HitAddtiveDuration = {
		ParamentName = "HitAddtiveDuration",
		ParamentValue = {
			0.3,
		},
	},
	HitFlyCD = {
		ParamentName = "HitFlyCD",
		ParamentValue = T.RT_2,
	},
	HitFlyXYZ = {
		ParamentName = "HitFlyXYZ",
		ParamentValue = {
			0,
			1000,
		},
	},
	HitRepelCD = {
		ParamentName = "HitRepelCD",
		ParamentValue = T.RT_14,
	},
	HitRepelTime = {
		ParamentName = "HitRepelTime",
		ParamentValue = T.RT_14,
	},
	InAir = {
		ParamentName = "InAir",
		ParamentValue = T.RT_16,
	},
	InvincibleAvoidTime = {
		ParamentName = "InvincibleAvoidTime",
		ParamentValue = T.RT_13,
	},
	JetJump = {
		ParamentName = "JetJump",
		ParamentValue = T.RT_1,
	},
	JetJumpFriction = {
		ParamentName = "JetJumpFriction",
		ParamentValue = T.RT_13,
	},
	JetRushDodgeSpeed = {
		ParamentName = "JetRushDodgeSpeed",
		ParamentValue = {
			4000,
		},
	},
	JetRushDodgeSpeedTime = {
		ParamentName = "JetRushDodgeSpeedTime",
		ParamentValue = T.RT_9,
	},
	LandHeavyTime = {
		ParamentName = "LandHeavyTime",
		ParamentValue = {
			2,
		},
	},
	LightHitRangedTime = {
		ParamentName = "LightHitRangedTime",
		ParamentValue = T.RT_3,
	},
	LightHitTime = {
		ParamentName = "LightHitTime",
		ParamentValue = T.RT_3,
	},
	MaxDyingTime = {
		ParamentName = "MaxDyingTime",
		ParamentValue = T.RT_7,
	},
	MaxInheritSpeed = {
		ParamentName = "MaxInheritSpeed",
		ParamentValue = T.RT_17,
	},
	MaxRecoveringPlayer = {
		ParamentName = "MaxRecoveringPlayer",
		ParamentValue = T.RT_14,
	},
	MaxWallJumpCount = {
		ParamentName = "MaxWallJumpCount",
		ParamentValue = T.RT_10,
	},
	MinPercentToHit = {
		ParamentName = "MinPercentToHit",
		ParamentValue = T.RT_2,
	},
	NormalWalkSpeed = {
		ParamentName = "NormalWalkSpeed",
		ParamentValue = T.RT_8,
	},
	OnGround = {
		ParamentName = "OnGround",
		ParamentValue = T.RT_11,
	},
	RecoverySpeed = {
		ParamentName = "RecoverySpeed",
		ParamentValue = T.RT_7,
	},
	RegionRecoverySpeed = {
		ParamentName = "RegionRecoverySpeed",
		ParamentValue = {
			-1,
		},
	},
	Reload = {
		ParamentName = "Reload",
		ParamentValue = T.RT_11,
	},
	RideFlyDec = {
		ParamentName = "RideFlyDec",
		ParamentValue = T.RT_18,
	},
	RideFlyHoldTime = {
		ParamentName = "RideFlyHoldTime",
		ParamentValue = T.RT_13,
	},
	RideMoveAcceleration = {
		ParamentName = "RideMoveAcceleration",
		ParamentValue = {
			512,
		},
	},
	RideMoveFirstJumpZ = {
		ParamentName = "RideMoveFirstJumpZ",
		ParamentValue = {
			1300,
		},
	},
	RideMoveFly = {
		ParamentName = "RideMoveFly",
		ParamentValue = {
			0,
			120,
			0,
		},
	},
	RideMoveFlyAcceleration = {
		ParamentName = "RideMoveFlyAcceleration",
		ParamentValue = T.RT_18,
	},
	RideMoveFlySpeed  = {
		ParamentName = "RideMoveFlySpeed ",
		ParamentValue = T.RT_6,
	},
	RideMoveInAir = {
		ParamentName = "RideMoveInAir",
		ParamentValue = T.RT_16,
	},
	RideMoveMax = {
		ParamentName = "RideMoveMax",
		ParamentValue = T.RT_19,
	},
	RideMoveMin = {
		ParamentName = "RideMoveMin",
		ParamentValue = T.RT_19,
	},
	RideMoveMinVelocity = {
		ParamentName = "RideMoveMinVelocity",
		ParamentValue = T.RT_8,
	},
	RideMoveSecondJumpStart = {
		ParamentName = "RideMoveSecondJumpStart",
		ParamentValue = T.RT_11,
	},
	RideMoveSecondJumpZ = {
		ParamentName = "RideMoveSecondJumpZ",
		ParamentValue = {
			1560,
		},
	},
	RideMoveTurnAngle1 = {
		ParamentName = "RideMoveTurnAngle1",
		ParamentValue = {
			85,
		},
	},
	RideMoveTurnAngle2 = {
		ParamentName = "RideMoveTurnAngle2",
		ParamentValue = {
			135,
		},
	},
	RideMoveTurnFinTime = {
		ParamentName = "RideMoveTurnFinTime",
		ParamentValue = {
			1.1,
		},
	},
	RideMoveTurnVelocity = {
		ParamentName = "RideMoveTurnVelocity",
		ParamentValue = {
			200,
		},
	},
	RideSprintTime = {
		ParamentName = "RideSprintTime",
		ParamentValue = T.RT_13,
	},
	SecondJumpAllowShootTime = {
		ParamentName = "SecondJumpAllowShootTime",
		ParamentValue = T.RT_9,
	},
	SecondJumpAllowSlideTime = {
		ParamentName = "SecondJumpAllowSlideTime",
		ParamentValue = {
			0.35,
		},
	},
	SecondJumpCold = {
		ParamentName = "SecondJumpCold",
		ParamentValue = {
			0.95,
		},
	},
	SecondJumpStart = {
		ParamentName = "SecondJumpStart",
		ParamentValue = T.RT_20,
	},
	SecondJumpZVelocity = {
		ParamentName = "SecondJumpZVelocity",
		ParamentValue = T.RT_6,
	},
	Shooting = {
		ParamentName = "Shooting",
		ParamentValue = {
			0,
			5400,
			0,
		},
	},
	Skill = {
		ParamentName = "Skill",
		ParamentValue = T.RT_20,
	},
	SlideGroundFriction = {
		ParamentName = "SlideGroundFriction",
		ParamentValue = T.RT_12,
	},
	SlideInAirFriction = {
		ParamentName = "SlideInAirFriction",
		ParamentValue = T.RT_21,
	},
	SlideLaunchDelay = {
		ParamentName = "SlideLaunchDelay",
		ParamentValue = T.RT_21,
	},
	SlideMaintainTime = {
		ParamentName = "SlideMaintainTime",
		ParamentValue = T.RT_21,
	},
	SlideSpeed = {
		ParamentName = "SlideSpeed",
		ParamentValue = T.RT_17,
	},
	SlideSpeedInAir = {
		ParamentName = "SlideSpeedInAir",
		ParamentValue = T.RT_17,
	},
	SlideStart = {
		ParamentName = "SlideStart",
		ParamentValue = T.RT_4,
	},
	SlideZeroFrictionTime = {
		ParamentName = "SlideZeroFrictionTime",
		ParamentValue = T.RT_13,
	},
	Sprint = {
		ParamentName = "Sprint",
		ParamentValue = {
			0,
			360,
			0,
		},
	},
	SprintAcceleration = {
		ParamentName = "SprintAcceleration",
		ParamentValue = T.RT_18,
	},
	SprintTurnColdTime = {
		ParamentName = "SprintTurnColdTime",
		ParamentValue = T.RT_3,
	},
	SprintTurnFinTime = {
		ParamentName = "SprintTurnFinTime",
		ParamentValue = {
			0.67,
		},
	},
	SprintTurnTriggerAngle = {
		ParamentName = "SprintTurnTriggerAngle",
		ParamentValue = {
			120,
		},
	},
	StartSprintTime = {
		ParamentName = "StartSprintTime",
		ParamentValue = T.RT_13,
	},
	StopAvoidTime = {
		ParamentName = "StopAvoidTime",
		ParamentValue = T.RT_3,
	},
	StopSlideTime = {
		ParamentName = "StopSlideTime",
		ParamentValue = T.RT_3,
	},
	StunToIdleBlendTime = {
		ParamentName = "StunToIdleBlendTime",
		ParamentValue = T.RT_15,
	},
	WalkSpeedRate = {
		ParamentName = "WalkSpeedRate",
		ParamentValue = {
			0.24,
		},
	},
	WallJumpAutoTime = {
		ParamentName = "WallJumpAutoTime",
		ParamentValue = T.RT_13,
	},
	WallJumpCold = {
		ParamentName = "WallJumpCold",
		ParamentValue = T.RT_5,
	},
	WallJumpColdDirection = {
		ParamentName = "WallJumpColdDirection",
		ParamentValue = T.RT_9,
	},
	WallJumpXYSpeed = {
		ParamentName = "WallJumpXYSpeed",
		ParamentValue = {
			10,
		},
	},
	WallJumpZSpeed = {
		ParamentName = "WallJumpZSpeed",
		ParamentValue = T.RT_10,
	},
})