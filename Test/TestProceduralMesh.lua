--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type TestProceduralMesh_C
local M = Class()

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    self.ProceduralMesh:SetBoundsScale(1000000.0)
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

-- 创建带指定面数的长条形 Mesh
-- @param XCount:列数
-- @param YCount: 行数
-- @param UnitSize:格子的边长
function M:GenerateStripMesh(XCount, YCount, UnitSize)
    if not self.ProceduralMesh then
        DebugPrint("缺少 ProceduralMesh 组件")
        return
    end

    XCount = XCount or 10     -- 列
    YCount = YCount or 10     -- 行
    UnitSize = UnitSize or 100

    local Vertices, Triangles, Normals, UVs = {}, {}, {}, {}

    -- 顶点生成
    for y = 0, YCount do
        for x = 0, XCount do
            local posX = x * UnitSize
            local posY = y * UnitSize
            table.insert(Vertices, FVector(posX, posY, 0))
            table.insert(Normals, FVector(0, 0, 1))  -- 朝 +Z
            table.insert(UVs, FVector2D(x / XCount, y / YCount))
        end
    end

    -- 三角形生成
    for y = 0, YCount - 1 do
        for x = 0, XCount - 1 do
            local i = y * (XCount + 1) + x

            -- 三角形 1
            table.insert(Triangles, i)
            table.insert(Triangles, i + XCount + 1)
            table.insert(Triangles, i + 1)

            -- 三角形 2
            table.insert(Triangles, i + 1)
            table.insert(Triangles, i + XCount + 1)
            table.insert(Triangles, i + XCount + 2)
        end
    end

    -- 创建 Mesh
    self.ProceduralMesh:CreateMeshSection_LinearColor(
        0,
        Vertices,
        Triangles,
        Normals,
        UVs,
        nil,
        nil,
        false
    )

    local DebugMat = UE4.UMaterial.Load("/Engine/EngineDebugMaterials/WireframeMaterial")
    self.ProceduralMesh:SetMaterial(0, DebugMat)
    DebugPrint(string.format("平面生成成功：%d 行 × %d 列，共 %d 面（三角数 %d）",
        YCount, XCount, XCount * YCount, #Triangles / 3))
end

return M
