local T = {
    Dongguo = {
        RT_1 = {
            MonsterSpawn = {
                [9804001] = 5,
                [9805001] = 5,
                [9806001] = 5,
                [9806002] = 5,
                [9807001] = 5,
                [9808001] = 5,
                [9809001] = 5,
                [9809002] = 5,
            },
        },
    },
    Prologue_optimization = {
        RT_1 = {
            MonsterSpawn = {
                [6001005] = 10,
                [6002001] = 8,
                [6003001] = 8,
                [6004001] = 2,
                [7001001] = 10,
                [7002001] = 12,
                [7003001] = 5,
                [7004001] = 5,
            },
        },
    },
}
local ReadOnly = {
    Dongguo = T.Dongguo.RT_1,
    Prologue_optimization = T.Prologue_optimization.RT_1,
}
return ReadOnly
