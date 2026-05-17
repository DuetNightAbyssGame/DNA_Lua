local BP_LightObjectFunctionLibrary_C = Class()

-- 建议按照模块区分编写：👇
BP_LightObjectFunctionLibrary_C._components = {
    "BluePrints.Char.LightObjectFunctionLibrary.LightObjectSample",
    "BluePrints.Char.CharacterComponent.MonsterComponent.NewNPCInitLogicEMComponent_C",
    "BluePrints.Char.CharacterComponent.MonsterComponent.NewMonInitLogicEMComponent_C",
    "BluePrints.Char.CharacterComponent.MonsterComponent.NewPhantomInitLogicEMComponent_C"
}

AssembleComponents(BP_LightObjectFunctionLibrary_C)
return BP_LightObjectFunctionLibrary_C