local AutoChessConst = {}

AutoChessConst.LevelSelectType = {
    Linear = 1,
    Random = 2,
}

AutoChessConst.FSMStates = {
    MainPage = 1,                   -- 主界面
    MonsterPage_Main = 2,           -- 怪物总览界面，聚焦ListView
    MonsterPage_FocusRight = 3,     -- 怪物总览界面，聚焦右侧详情
    EquipsPage_Main = 4,            -- 装备总览界面，聚焦ListView
    EquipsPage_FocusSort = 5,       -- 装备总览界面，聚焦筛选排序
}

AutoChessConst.AutoChessCoin = 219

return AutoChessConst