local StubInfos = {}
-- 需要进行插桩替换的C++函数，将签名注册在这里
-- 格式如： {Name = "UHitLogicComponent::GetHitMontage"}
-- 可指定额外参数IgnoreReturn，若IgnoreReturn为true，插桩函数执行完毕后不会返回

StubInfos.StubFunctionList = {
    -- {Name = "UHitLogicComponent::GetHitMontage", IgnoreReturn = true},
    {Name = "AMonsterCharacter::RealInitInfoLua_Stamp"},
}

-- 如果对象未绑定Lua脚本，可以将类名写在这里，动态绑定Lua脚本
-- 格式如： "HitLogicComponent" = "BluePrints.StubOverrides.HitLogicCompTest"
StubInfos.DyncBindings = {
    -- ["HitLogicComponent"] = "BluePrints.StubOverrides.HitLogicCompTest"
}

return StubInfos