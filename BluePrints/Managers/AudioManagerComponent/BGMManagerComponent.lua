local Component = {}

-- 把剧情线BGM信息记录到服务端
function Component:StoreLevelBGMInfoToAvatar(SoundType, EventName, Key, Value)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        DebugPrint("HYY_ Store BGM Info", SoundType, EventName, Key, Value)
        Avatar:UpdateSuitKey2Table(CommonConst.SuitType.PlayerCharacterSuit, CommonConst.PlayerCharacterSuit.BGM, SoundType, EventName, Key, Value)
    end
end

-- 待做,等服务端接口
-- 把剧情线BGM信息从服务端删除
function Component:RemoveLevelBGMInfoFromAvatar()
end

return Component