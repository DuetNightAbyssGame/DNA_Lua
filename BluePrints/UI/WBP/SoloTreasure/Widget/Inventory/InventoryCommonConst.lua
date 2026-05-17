local InventoryCommonConst = {
    PocketType = {
		Default = 0,
		Bag = 1,	    -- 玩家的背包
		Mechanism = 2,	    -- 局内的可搜索的容器（含献祭面板）
		Recycle = 3,	    -- 回收站
    },
    -- 手柄光标吸附优先级
    -- LOW:   单次定位（初始化/Drop 后自动定位），受 bForbidAdsorption 限制
    -- HIGH:  持续跟随（悬停物品期间），不受 bForbidAdsorption 限制，可覆盖 LOW
    -- FORCE: 强制吸附（如拖入回收站），不受任何限制，同时锁定摇杆输入
    AdsorptionPriority = {
        LOW   = 1,
        HIGH  = 2,
        FORCE = 3,
    },
	DefaultDragWidgetPath = '/Game/UI/WBP/SoloTreasure/Widget/WBP_Treasure_Item_Drag.WBP_Treasure_Item_Drag',
	Direction = {
		Horizontal = 0,
		Vertical = 1,
	},
	MaxTreasureLoadCountInSingleFrame = 1,
	DragDetectedThreshold = 10,
	GamepadAnalogDeadzone = 0.5,
	-- 玩家累计移动超过此像素距离才视为"有意图移动"，小于此值视为误触不影响吸附
	AdsorptionCancelThreshold = 15,
	IdleTimeToTryAdsorption = 0.1,
	RecycleListEmptyNum = 8,
	RecyclePocketNamePrefix = "Recycle",
	SearchPocketNamePrefix = "WBP_Search_Bag",
	RecycleBtnState = {
		Normal = 1,
		DragingOver = 2,
		Draging = 3,
	},
	QuickTransferType = {
		RightClick = 1,
		AltAndLeftClick = 2,
	},
}

return InventoryCommonConst
