--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_DungeonIndicatorUI_C = Class({
    "BluePrints.UI.BP_UIState_C",
    "BluePrints.Common.TimerMgr",
})
local ErrorLoc = FVector(2147483647, 2147483647, 2147483647)--INT_MAX
---------------------------------------------------- 本指引点通用接口 ----------------------------------------------------

function WBP_DungeonIndicatorUI_C:DebugPrint(...)
    DebugPrint("DungeonIndicator", ...)
end

function WBP_DungeonIndicatorUI_C:AssignVector(from, to)
    to.X, to.Y, to.Z = from.X, from.Y, from.Z
end

function WBP_DungeonIndicatorUI_C:AssignVector2D(from, to)
    to.X, to.Y = from.X, from.Y
end

-- function WBP_DungeonIndicatorUI_C:GetBPName()
--     if self.ConfigData == nil then
--         return nil
--     end
--     return self.ConfigData.GuideIconAni
-- end

function WBP_DungeonIndicatorUI_C:GetVisible()
    return self.TargetVisibilityOnDoor
end

-- function WBP_DungeonIndicatorUI_C:GetIconSize()
--     if self.ConfigData == nil or self.ConfigData.GuideIconAni == nil then
--         return FVector2D(64, 64)
--     end
--     return self.IconSize
-- end

function WBP_DungeonIndicatorUI_C:GetRealDistance()
    return self.PointRealDistance
end

function WBP_DungeonIndicatorUI_C:GetIconPathName()
    if self.ConfigData == nil then
        return ""
    end
    return self.GuideAnim
end

----------------------------------------------------- 初始化相关函数 -----------------------------------------------------
-- local EPhantomGuideState = {
--     Alive = 0,
--     Dead = 1,
--     Resurrecting = 2
-- }

-- function WBP_DungeonIndicatorUI_C:Initialize(Initializer)
--     self.Super.Initialize(self)
--     self.ConfigData = nil

--     self.TargetEid = nil                                -- 指引目标 Eid
--     self.TargetActor = nil                              -- 指引目标 Actor
--     self.TargetPointPos = FVector(0, 0, 0)              -- 指引目标点位置（实际目标点位置，不在门上）
--     self.IsGetPos = false                               -- 获得了指引目标点位置

--     self.OvalSize = FVector2D(0, 0)                     -- 范围限制椭圆大小
--     self.CenterPos = FVector2D(0, 0)                    -- 屏幕坐标的中心点

--     self.ScreenLocation = FVector2D(0, 0)               -- 指引点的屏幕坐标
--     self.TargetWorldLoc = FVector(0, 0, 0)              -- 指引点的世界坐标（指引点的位置，可能在门上，插值目标点）
--     self.CurrentWorldLoc = FVector(0, 0, 0)             -- 指引点的世界坐标（指引点的位置，可能在门上，插值当前点）

--     self.TargetVisibility = true                        -- 指引点可见性（经过门时不刷新）
--     self.TargetVisibilityOnDoor = true                  -- 指引点可见性（经过门时刷新）
--     self.CurrentVisbilityOnDoor = true                  -- 指引点可见性（经过门时刷新）

--     self.LocationLerpInterval = 3                       -- 指引点的世界坐标插值间隙

--     self.GuideType = ""                                 -- 指引点的类型
--     self.IconSize = nil                                 -- 指引 Icon 的大小
--     self.BoardSize = FVector2D(30, 30)                  -- 指引显示范围边界大小
--     self.DistanceUnit = GText("UI_SCALE_METER")         -- 指引点距离显示单位

--     self.TargetOffsetOnDoor = 0                         -- 指引的偏移（挂在门上面的时候，插值目标点）
--     self.CurrentOffsetOnDoor = 0                        -- 指引的偏移（挂在门上面的时候，插值当前点）
--     self.OffsetLerpInterval = 150                       -- 指引点偏移插值间隙

--     self.DoorPosition = FVector(0, 0, 0)                -- 指引点在门上时，门的位置
--     self.DoorDirection = FVector(0, 0, 0)               -- 指引点在门上时，门的方向

--     self.UseRealDistance = true                         -- 是否使用实际距离
--     self.PointRealDistance = 0                          -- 指引的实际距离

--     self.RequireInAnimation = false                     -- 是否需要入场动画
--     self.RequireLookUpEntity = false                    -- 是否需要寻找对应的 Entity
--     self.RequireDirectionArrow = false                  -- 是否需要显示方向箭头
--     self.RequireFollowingActor = false                  -- 指引是否需要跟随 Actor
--     self.PhantomGuideState = nil                        -- 魅影指引点状态

--     -- self.States = {                                     -- 所有状态的枚举
--     --     OnDoor = 0,                                     -- 在门上显示
--     --     OnActor = 1,                                    -- 在 Actor 上显示
--     -- }   
--     -- self.Styles = {                                     -- 所有样式的枚举
--     --     Single = 0,                                     -- 单个无堆叠
--     --     Multiple = 1,                                   -- 指引点堆叠
--     --     Disappearing = 2,                               -- 正在执行 Disappear
--     -- }   
--     -- self.State = self.States.OnActor                    -- 当前指引的状态
--     -- self.Style = self.Styles.Single                     -- 当前指引的样式

--     self.HideBehinds = {}                               -- 隐藏在背后的指引点
--     self.SpawnDown = false                              -- 指引点是否生成完成
--     self.FlyToTarget = true                             -- 生成出来之后是否要从角色身上飞到 Target 上
--     self.CacheScreenPos = FVector2D(0, 0)               -- 缓存屏幕指引点位置

--     self.TargetPhantomOpacity = 1                       -- 魅影指引点目标透明度
--     self.CurrentPhantomOpacity = 1                      -- 魅影指引点当前透明度
--     self.PhantomOpacityLerpInterval = 0.1               -- 魅影指引点透明度插值间隔    
-- end

function WBP_DungeonIndicatorUI_C:Destruct()
    self.Super.Destruct(self)
	self:ClearEventPreDestruct()
end

function WBP_DungeonIndicatorUI_C:AttachEventOnLoaded()
    local GuideType = self.GuideType
    if GuideType == "Phantom" then
        EventManager:AddEvent(EventID.OnTeamRecoveryStateChange, self, self.SetPhantomGuideStateByEvent)
        -- EventManager:AddEvent(EventID.ChangePhantomRecoverCount, self, self.SetPhantomRecoverCountChangeFlagByEvent)
    elseif GuideType == "Hostage" then
        EventManager:AddEvent(EventID.TriggerHostageVisibility, self, self.ChangeHostageVisibility)
        EventManager:AddEvent(EventID.TriggerHostageGuideLoop, self, self.TriggerDeadGuideDisplay)
    end
    EventManager:AddEvent(EventID.RecycleClassToCachePool, self, self.DisappearCacheIndicatorClass)
end

function WBP_DungeonIndicatorUI_C:ClearEventPreDestruct()
    EventManager:RemoveEvent(EventID.OnTeamRecoveryStateChange, self)
    -- EventManager:RemoveEvent(EventID.ChangePhantomRecoverCount, self)
    EventManager:RemoveEvent(EventID.RecycleClassToCachePool, self)
    EventManager:RemoveEvent(EventID.TriggerHostageVisibility, self)
    EventManager:RemoveEvent(EventID.TriggerHostageGuideLoop, self)

end

function WBP_DungeonIndicatorUI_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local TargetPointPos = nil

    -- 解析参数赋值给成员
    self.TargetEid, self.TargetActor, TargetPointPos, self.ConfigData, self.RequireDirectionArrow,
        self.RequireFollowingActor, self.RequireLookUpEntity, self.RequireInAnimation, self.UseRealDistance = ...

    self.TargetActor = Battle(self):GetEntity(self.TargetEid)

    if TargetPointPos ~= nil then
        self.TargetPointPos = TargetPointPos
    end
    DebugPrint("HTY WBP_DungeonIndicatorUI_C:OnLoaded self.TargetPointPos", self.TargetPointPos, "self.TargetEid", self.TargetEid)
    self:OnIndicatorLoaded()
end

function WBP_DungeonIndicatorUI_C:Close()
    if self.IsFromPool then
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.IsActiveInPoor = false
        self.GameState:AddIndicatorToPool(self.GuideType, self)
        self.IndicatorStyle = EIndicatorStyle.Single
    else
        self.Super.Close(self)
    end
end

-- function WBP_DungeonIndicatorUI_C:SetGuideImage(ImageName)
    
--     -- 从 UIConst 表读取 Image 路径
--     local ImagePath = UIConst.DUNGEONINDICATORIMG[ImageName]
--     if ImagePath ~= nil and self.Img_GuidePoint_Icon ~= nil then
        
--         -- 加载 Icon 图片的 Object
--         local IconImage = LoadObject(ImagePath)
--         if IconImage == nil then
--             self:DebugPrint("InitConfigData: 指引点 Icon 图片不存在！")
--             return
--         end

--         -- 设置指引点的 Icon 图标
--         self.Img_GuidePoint_Icon:SetBrushResourceObject(IconImage)
--     end
-- end

function WBP_DungeonIndicatorUI_C:InitConfigData()

    -- 从 TargetActor 设置指引点类型
    local TargetActor = self.TargetActor
    if IsValid(TargetActor) then
        self.GuideType = TargetActor.UnitType
    -- 从 ConfigData 设置指引点类型
    end

    local ConfigData = self.ConfigData
    local GuideIconBPPath = nil
    if ConfigData ~= nil then
        GuideIconBPPath = ConfigData.GuideIconBPPath
        local RealGuideType = self.SceneManager:GetGuideTypeByBPPath(ConfigData.GuideIconAni, ConfigData.GuideIconBPPath)
        if RealGuideType ~= "" then
            self.GuideType = RealGuideType
        end
    else
        return
    end

    self:AttachEventOnLoaded()
    self:OnInitConfig()
    self:InitIndicatorByConfigData(self.GuideAnim or "", GuideIconBPPath or "", ConfigData.GuideText or "")
    self:InitFlyToTarget()
end

function WBP_DungeonIndicatorUI_C:RequestSnapShotInfo()
    DebugPrint("RequestSnapShotInfo TargetEid", self.TargetEid)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    PlayerCharacter.RPCComponent:RequestGuideInfo(self.TargetEid)
end

function WBP_DungeonIndicatorUI_C:SetGuideColor(ImagePath)
    local GuidePointBase = self.WBP_GuidePoint_Base
    local PathColor = GuidePointBase.GuideColorMap:Find(ImagePath)
    if PathColor ~= nil then
        local ArrowColor = PathColor.ArrowColor
        local GeometryColor = PathColor.GeometryColor
        GuidePointBase.ArrowColor = ArrowColor
        GuidePointBase.GeometryColor = GeometryColor
        local ImgMaterial = self.ImgMaterial
        ImgMaterial:SetVectorParameterValue("ArrowColor", ArrowColor)
        ImgMaterial:SetVectorParameterValue("GeometryColor", GeometryColor)
    end
end

function WBP_DungeonIndicatorUI_C:OnInitConfig()
    rawset(self, "InitConfigDataWithType", self["InitConfigDataWithType_"..self.GuideType])
    if self.InitConfigDataWithType then
        self.InitConfigDataWithType(self)
    end
    local Sustained = self.Sustained
    if self.ConfigData.GuideIconAni == "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_BlastRobot.WBP_GuidePoint_BlastRobot" and Sustained and self.TargetActor then
        local MonsterDelayTime = self.TargetActor.GuideDelayTime
        local PlayTime = Sustained:GetEndTime() - Sustained:GetStartTime()
        local NewSpeed = PlayTime / MonsterDelayTime
        self:PlayAnimation(Sustained, 0, 1, EUMGSequencePlayMode.Forward, NewSpeed)
    end

    local PlayerIndex = self.ConfigData.PlayerIndex
    if PlayerIndex and PlayerIndex > 0 then
        rawset(self, "PlayerIndex", PlayerIndex)
    end
    -- self:SetArrowWidgetColor()
end

-- function WBP_DungeonIndicatorUI_C:InitFlyToTarget()
--     if self.SpawnDown == false and (self.GuideType == "Monster" or self.GuideType == "Mechanism") then
--         self.FlyToTarget = false
-- 	else
-- 		self.FlyToTarget = true
--     end
-- end

-- function WBP_DungeonIndicatorUI_C:SetArrowWidgetColor()
--     if self.GuideType == "Monster" and self.ConfigData.GuideIconBPPath == "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_TreasureHunter.T_Gp_TreasureHunter" then
--         local TreasureSlateColor = self.Color_Purple
--         self:SetArrowColor(TreasureSlateColor.SpecifiedColor)
--     end
-- end

function WBP_DungeonIndicatorUI_C:SetPhantomImgAvatar()
    if self.ConfigData.PlayerIndex and self.ConfigData.PlayerIndex > 0 then
        UE4.UResourceLibrary.LoadObjectAsync(self, self.ConfigData.GuideIconBPPath, {self, WBP_DungeonIndicatorUI_C.OnPhantomImgIconLoadFinish})
        return
    end
    if self.ConfigData.BattleRoleId == nil or DataMgr.BattleChar[self.ConfigData.BattleRoleId] == nil or DataMgr.BattleChar[self.ConfigData.BattleRoleId].GuideIconImg == nil then
        return
    end

    if self.GuideType == "Phantom" and self.Phantom ~= nil then
        if self.CurPhantomGuideState == EPhantomGuideState.Alive then
            local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
            local PhantomGuideIconImg = DataMgr.BattleChar[self.ConfigData.BattleRoleId].GuideIconImg

            local NormalIconName = "T_Normal_"..PhantomGuideIconImg
            UE4.UResourceLibrary.LoadObjectAsync(self, MiniIconPath..NormalIconName.."."..NormalIconName, {self, WBP_DungeonIndicatorUI_C.OnPhantomImgIconLoadFinish})

        elseif self.CurPhantomGuideState == EPhantomGuideState.Dead then
            local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
            local PhantomGuideIconImg = DataMgr.BattleChar[self.ConfigData.BattleRoleId].GuideIconImg

            local DeadIconName = "T_Dead_"..PhantomGuideIconImg
            UE4.UResourceLibrary.LoadObjectAsync(self, MiniIconPath..DeadIconName.."."..DeadIconName, {self, WBP_DungeonIndicatorUI_C.OnPhantomImgIconLoadFinish})
        end
    end
end

function WBP_DungeonIndicatorUI_C:OnPhantomImgIconLoadFinish(Object)
    if Object then
        self.Phantom.Img_Avatar:SetBrushResourceObject(Object)
    end
end

----------------------------------------------------- 指引点行为函数 -----------------------------------------------------

-- function WBP_DungeonIndicatorUI_C:Refresh(BPName, RequireInAnimation)

--     -- 如果 BPName 不为空
--     if BPName ~= nil then

--         -- 如果 BPName_Arrows 存在，隐藏 Common_Arrwos
--         if self[BPName.."_Arrows"] ~= nil and self.Common_Arrows ~= nil then
--             self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         end

--         -- 如果需要播放入场动画
--         if RequireInAnimation == true then
--             self:PlayAppearAnim() 
--         end

--         -- 如果 Panel_BPName 存在，显示 Panel_BPName
--         BPName = "Panel_"..BPName
--         if self[BPName] ~= nil then
--             self[BPName]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         end
    
--     -- 如果 BPName 为空
--     else

--         -- 隐藏指引点
--         self:SetVisibilityOnDoor(false)
--         self:SetVisibilityNotOnDoor(false)
--     end
-- end

function WBP_DungeonIndicatorUI_C:Reset(TargetEid, TargetActor, TargetLocation, ConfigData, RequireDirectionArrow,
    RequireFollowingActor, RequireLookUpEntity, RequireInAnimation, UseRealDistance, IsResetPos)

    if ConfigData ~= nil then self.ConfigData = ConfigData  end
    
    self:Reset_Cpp(TargetEid, TargetActor, TargetLocation, RequireDirectionArrow,
    RequireFollowingActor, RequireLookUpEntity, RequireInAnimation, UseRealDistance, IsResetPos)
    -- -- 重设指引点的各种参数
    -- self.TargetEid = TargetEid
    -- self.TargetActor = TargetActor
    -- self.UseRealDistance = UseRealDistance
    -- self.RequireInAnimation = RequireInAnimation
    -- self.RequireLookUpEntity = RequireLookUpEntity
    -- self.RequireDirectionArrow = RequireDirectionArrow
    -- self.RequireFollowingActor = RequireFollowingActor

    -- if TargetLocation ~= nil then
    --     self.TargetPointPos = TargetLocation
    -- end

    -- -- 获取外部引用，更新屏幕中心和椭圆大小
    -- self:GetExternalReferences()
    -- -- self:GetCenterPosAndOvalSize()

    -- if IsResetPos then self.TargetOffsetOnDoor = 0 end

    -- if ConfigData ~= nil then self.ConfigData = ConfigData  end
    
    -- -- 初始化 ConfigData
    -- self:InitConfigData()
    
    -- -- 获取 Icon 的大小
    -- local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Main)
    -- if not CanvasSlot then
    --     local Slots = self.Main.Slots:ToTable()
    --     CanvasSlot = Slots[1]
    -- end
    -- self.IconSize = CanvasSlot:GetSize()
    
    -- -- 指引点距离显示单位
    -- self.DistanceUnit = GText("UI_SCALE_METER")

    -- -- 注册 SignificanceManager 控制 Tick 频率
    -- self:RegisterSignificanceManager()
end

function WBP_DungeonIndicatorUI_C:InitConfigDataWithType_Pet()
    if self.ConfigData and self.ConfigData.GuideDuration and self.ConfigData.GuideCloseRange then
        self.ShowTime = self.ConfigData.GuideDuration
        self.CloseDistance = self.ConfigData.GuideCloseRange
        self.RegionImagePath = self.ConfigData.GuideIconBPPath2
    end
end

function WBP_DungeonIndicatorUI_C:InitConfigDataWithType_Mechanism()
    if self.ConfigData and self.ConfigData.GuideDuration and self.ConfigData.GuideCloseRange then
        self.ShowTime = self.ConfigData.GuideDuration
        self.CloseDistance = self.ConfigData.GuideCloseRange
    end
end

function WBP_DungeonIndicatorUI_C:CheckNeedPlayFinishAnim()
    return self.ConfigData ~= nil and self.ConfigData.GuideIconAni ~= nil and self.RequireInAnimation
end

function WBP_DungeonIndicatorUI_C:GetStyleNodeName()
    if not self.ConfigData then
        -- return ""
        return
    end
    -- 此处应该是最早的，存一下
    local GuideAnim = self.SceneManager:GetGuideGuideAnimByBPPath(self.ConfigData.GuideIconAni, self.ConfigData.GuideIconBPPath)
    self.GuideAnim = GuideAnim
    -- return "Panel_"..GuideAnim
end

-- function WBP_DungeonIndicatorUI_C:Disappear()
--     -- 可能在播放退出动画，设置一次状态即可
--     if (self.IndicatorStyle == EIndicatorStyle.Disappearing) then
--         return
--     end
--     self.IndicatorStyle = EIndicatorStyle.Disappearing

--     -- 如果指引点是正常的并且需要播放退出动画
--     if self.ConfigData ~= nil and self.ConfigData.GuideIconAni ~= nil and self.RequireInAnimation then
--         self:UnbindAllFromAnimationFinished(self.Out)

--         -- 退出动画结束的回调，关闭播放完动画的 UI
--         local function PlayAnimFinished()
--             local StyleNode = "Panel_"..self.ConfigData.GuideIconAni
--             if (self[StyleNode] ~= nil) then
--                 self[StyleNode]:SetVisibility(UE4.ESlateVisibility.Collapsed) 
--             end
    
--             -- 取消注册 SignificanceManager 控制 Tick 频率
--             self:UnregisterSignificanceManager()

--             -- 关闭 UI
--             self:Close()
--         end

--         -- 如果有退出动画，播放并绑定 Finish 回调
--         if self.Out ~= nil then
--             self:BindToAnimationFinished(self.Out, { self, PlayAnimFinished })
--             self:PlayAnimation(self.Out)
        
--         -- 如果没有退出动画，直接走 Finish 回调
--         else PlayAnimFinished() end
    
--     -- 如果指引点不正常或者不需要播放退出动画
--     else
--         -- 取消注册 SignificanceManager 控制 Tick 频率
--         self:UnregisterSignificanceManager()

--         -- 关闭 UI
--         self:Close()
--     end
-- end

function WBP_DungeonIndicatorUI_C:ChangeStyle(IndicatorStyle, Count)
    if self.ConfigData == nil or self.ConfigData.GuideIconAni == nil then
        self:DebugPrint("ChangeStyle: 指引点未显示")
        return
    end

    if self.IndicatorStyle == EIndicatorStyle.Disappearing then
        return
    end

    if IndicatorStyle == EIndicatorStyle.Multiple and self.IsNeedMultipleShow then
        self.IndicatorStyle = EIndicatorStyle.Multiple
        -- 打开数量显示
        if self.Text_Quantity ~= nil and self.Panel_Quantity ~= nil then
            self.Text_Quantity:SetText(tostring(Count))
            self.Panel_Quantity:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        -- 显示堆叠背景
        if self.Panel_GuidePoint_More ~= nil then
            self.Panel_GuidePoint_More:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            if self.WBP_GuidePoint_Base ~= nil and self.ImgMaterial ~= nil then
                self.ImgMaterial:SetScalarParameterValue("HasMore", 1)
            end
        end
    elseif IndicatorStyle == EIndicatorStyle.Single then
        self.IndicatorStyle = EIndicatorStyle.Single
        -- 关闭数量显示
        if self.Panel_Quantity ~= nil then 
            self.Panel_Quantity:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        -- 隐藏堆叠背景
        if self.Panel_GuidePoint_More ~= nil then
            self.Panel_GuidePoint_More:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            if self.WBP_GuidePoint_Base ~= nil and self.ImgMaterial ~= nil then
                self.ImgMaterial:SetScalarParameterValue("HasMore", 0)
            end
        end
    end
end

function WBP_DungeonIndicatorUI_C:SetVisibilityNotOnDoor(Visible)
    self.TargetVisibility = Visible

    if self.TargetVisibility == true and self.TargetVisibilityOnDoor == true then
        self.Main:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    if self.TargetVisibility == false then
        self.Main:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_DungeonIndicatorUI_C:Show(ShowTag)
    WBP_DungeonIndicatorUI_C.Super.Show(self, ShowTag)
end

function WBP_DungeonIndicatorUI_C:Hide(HideTag)
    for _, Widget in pairs(UIConst.DungeonIndicatorShowWidgets) do
        if HideTag == "InUIConfigure"..Widget then
            return
        end
    end
    WBP_DungeonIndicatorUI_C.Super.Hide(self, HideTag)
end

-- function WBP_DungeonIndicatorUI_C:SetVisibilityOnDoor(Visible, HideObjs)
--     -- 如果要显示
--     if Visible == true then

--         self.TargetVisibilityOnDoor = true
--         self.CurrentVisbilityOnDoor = true

--     -- 如果要隐藏
--     elseif Visible == false then
--         self.TargetVisibilityOnDoor = false
--     end

--     -- 指引点遮挡的 Objs
--     self.HideBehinds = HideObjs

--     if self.TargetVisibility == true and self.TargetVisibilityOnDoor == true then
--         self.Main:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end
-- end

------------------------------------------------------ 动画播放函数 ------------------------------------------------------

function WBP_DungeonIndicatorUI_C:PlayAppearAnim()
    if self.In ~= nil then
        self:PlayAnimation(self.In)
    end
end

function WBP_DungeonIndicatorUI_C:RePlayAppearAnim()
    if self.Loop ~= nil then
        self:PlayAnimation(self.Loop, 0, 2)
    elseif self.WBP_GuidePoint_Base then
        self.WBP_GuidePoint_Base:PlayAnimation(self.WBP_GuidePoint_Base.Loop, 0, 2)
    end
end

function WBP_DungeonIndicatorUI_C:PlayLoopAnim()
    if self.Loop ~= nil then
        self:PlayAnimation(self.Loop, 0)
    elseif self.WBP_GuidePoint_Base then
        self.WBP_GuidePoint_Base:PlayAnimation(self.WBP_GuidePoint_Base.Loop, 0)
    end
end

function WBP_DungeonIndicatorUI_C:PlayConfigLoopAnim()
    if self.NeedPlayConfigLoop then
        self:PlayLoopAnim()
    elseif self.ConfigData and self.ConfigData.GuideIconBPPath then
        if self.WBP_GuidePoint_Base then
            local PathColorConfig = self.WBP_GuidePoint_Base.GuideColorMap:Find(self.ConfigData.GuideIconBPPath)
            if PathColorConfig and PathColorConfig.NeedPlayConfigLoop then
                self:PlayLoopAnim()
            end
        end
    end
end

----------------------------------------------------- 更新指引点位置 -----------------------------------------------------

function WBP_DungeonIndicatorUI_C:GetCurSceneGuideEidEntityAsFSnapShotInfo()
    local ClientGuideData = self.SceneManager.CurSceneGuideEids[self.TargetEid]
    if ClientGuideData ~= nil and ClientGuideData.IsDataStruct == true then
        return ClientGuideData.Entity
    else 
        return FSnapShotInfo()
    end
end

function WBP_DungeonIndicatorUI_C:GetCurSceneGuideEidEntityAsActor()
    local ClientGuideData = self.SceneManager.CurSceneGuideEids[self.TargetEid]
    if ClientGuideData ~= nil and ClientGuideData.IsDataStruct == false then
        return Battle(self):GetEntity(ClientGuideData.Entity)
    else 
        return nil 
    end
end

-- function WBP_DungeonIndicatorUI_C:GetTargetActorUnitType()
--     return self.TargetActor.UnitType or ""
-- end

function WBP_DungeonIndicatorUI_C:GetFromGText(Name)
    return GText(Name) or ""
end

-- function WBP_DungeonIndicatorUI_C:GetTargetPosition()
--     if self.RequireLookUpEntity == true then
--         self.IsGetPos = false

--         -- 需要 Tick 搜寻 Actor
--         self.TargetActor = Battle(self):GetEntity(self.TargetEid)

--         -- 如果可以从 Battle 中获得数据
--         if IsValid(self.TargetActor) then

--             -- 取消 RequireLookUpEntity 标记
--             self.RequireLookUpEntity = false
--             self.GuideType = self.TargetActor.UnitType

--         -- 如果从 Battle 中获取不到数据
--         else

--             -- 直接去拿序列化数据
--             local ClientGuideData = self.SceneManager.CurSceneGuideEids[self.TargetEid]
--             if ClientGuideData ~= nil then
                
--                 -- 如果是结构化的数据
--                 if ClientGuideData.Type == "DataStruct" then
                    
--                     -- 如果可以拿到 Entity.Loc 则直接使用
--                     if ClientGuideData.Entity and ClientGuideData.Entity.Loc then
--                         self.TargetPointPos = ClientGuideData.Entity.Loc
--                         self.IsGetPos = true
--                     else self:DebugPrint("GetTargetPosition: Entity.Loc 无效") end
                
--                 -- 如果不是结构化数据
--                 else
                    
--                     -- 如果 Entity 合法则 GetActorLocation
--                     if IsValid(ClientGuideData.Entity) then
--                         self.TargetPointPos = ClientGuideData.Entity:K2_GetActorLocation()
--                         self.IsGetPos = true
--                     else
--                         -- self:DebugPrint("GetTargetPosition: Entity:K2_GetActorLocation 无效")
--                     end
--                 end
            
--             -- 如果拿不到当前 Scene 的 GuideEids[TargetEid]
--             else
--                 -- self:DebugPrint("GetTargetPosition: ClientGuideData 无效")
--             end
--         end

--     elseif not IsValid(self.TargetActor) then

--         self:DebugPrint("GetTargetPosition: 重新获取 TargetActor 实例")
--         self.RequireLookUpEntity = true
--     end
-- end

-- function WBP_DungeonIndicatorUI_C:AdjustTargetPosition()
--     -- 是否需要每帧调整 TargetPosition
--     if not IsValid(self.TargetActor) then
--         return
--     end

--     -- 只有不是 Monster 且不需要跟踪
--     if self.TargetActor.UnitType ~= "Monster"
--         and self.RequireFollowingActor == false
--         and self.IsGetPos == true then
--         return
--     end

--     -- 重新计算 TargetPosition
--     local TargetActorLocation = self.TargetActor:K2_GetActorLocation()
--     self:AssignVector(TargetActorLocation, self.TargetPointPos)
--     self.IsGetPos = true

--     -- 如果 TargetActor 是胶囊
--     if self.TargetActor.CapsuleComponent and self.TargetActor.CapsuleComponent.GetUnscaledCapsuleHalfHeight then
--         self.TargetPointPos.Z = TargetActorLocation.Z + self.TargetActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight() * 0.8
--         if self.TargetActor.UnitType == "Phantom" then
--             self.TargetPointPos.Z = TargetActorLocation.Z + self.TargetActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight() * 1.0
--         end
    
--     -- 如果 TargetActor 是球体
--     elseif self.TargetActor.Sphere and self.TargetActor.Sphere.GetScaledSphereRadius then
--         self.TargetPointPos.Z = TargetActorLocation.Z
--             + self.TargetActor.Sphere:GetScaledSphereRadius()
    
--     -- 如果 TargetActor 是盒体
--     elseif self.TargetActor.Box and self.TargetActor.Box.GetScaledBoxExtent then
--         self.TargetPointPos.Z = TargetActorLocation.Z
--             + self.TargetActor.Box:GetScaledBoxExtent().Z
--     end
-- end

function WBP_DungeonIndicatorUI_C:CaluCurGuideNeedShowPos()
    return self.SceneManager:CaluCurGuideNeedShowPos(self.TargetEid, self.DoorPosition, self.DoorDirection)
end

function WBP_DungeonIndicatorUI_C:SetMechanismRelativePosition()
    if self.TargetActor and self.TargetActor.GetGuidePos then
        local RelativePosition = self.TargetActor:GetGuidePos()
        if RelativePosition then
            self.MechanismLoc.X = RelativePosition.X
            self.MechanismLoc.Y = RelativePosition.Y
            self.MechanismLoc.Z = RelativePosition.Z
        end
    end
end

function WBP_DungeonIndicatorUI_C:SetArrowColor(Color)
    if self.Common_Arrows then
        self.Common_Arrows:SetColorAndOpacity(Color)
    else
        self.ImgMaterial:SetVectorParameterValue("ArrowColor", Color)
    end
end

-- function WBP_DungeonIndicatorUI_C:UpdateIndicator()
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     if GameInstance == nil then
--         self:DebugPrint("UpdateIndicator: GameInstance 不存在")
--         return
--     end
    
--     local SceneManager = GameInstance:GetSceneManager()
--     if SceneManager == nil then
--         self:DebugPrint("UpdateIndicator: SceneManager 不存在")
--         return
--     end

--     if self.GuideType == "Phantom" and self.Phantom then
--         self:UpdatePhantomIndicator()
--     end

--     -- 获取 TargetPosition 并调整位置
--     self:GetTargetPosition(SceneManager)
--     self:AdjustTargetPosition()

--     if not IsValid(self.TargetActor) and self.TargetPointPos == nil then
--         self:Disappear()
--         return
--     end

--     -- 获取 PlayerCharacter
--     local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
--     if not IsValid(Player) or self.TargetPointPos == nil then
--         self:DebugPrint("UpdateIndicator: Player 不存在")
--         return
--     end

--     -- 获取 PlayerController
--     local Controller = Player:GetController()

--     -- 获取指引点是否在门上和门的位置
--     local IsOnDoor = SceneManager:CaluCurGuideNeedShowPos(
--         self.TargetEid, self.DoorPosition, self.DoorDirection)
    
--     -- 如果在门上就设置状态并调整位置
--     if IsOnDoor == true then
--         self.State = self.States.OnDoor

--         self:AssignVector(self.DoorPosition, self.TargetWorldLoc)
--         self.TargetWorldLoc.Z = self.DoorPosition.Z + 150
--     else
--         self.State = self.States.OnActor
--         self:AssignVector(self.TargetPointPos, self.TargetWorldLoc)
--     end

--     -- 是否从角色位置生成飞到目标位置
--     if self.SpawnDown == false then
--         self.SpawnDown = true

--         -- 指引点当前位置设为角色位置
--         if self.FlyToTarget == true then
--             self:AssignVector(Player:K2_GetActorLocation(), self.CurrentWorldLoc)
        
--         -- 指引点当前位置设为目标位置
--         else self:AssignVector(self.TargetWorldLoc, self.CurrentWorldLoc) end
--     end
    
--     -- 计算视口的中心位置和限制范围的椭圆大小
--     local ViewportSize = UIManager(self):GetViewportSize()
--     if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
--         self.CenterPos.X, self.CenterPos.Y  = ViewportSize.X * 0.5, ViewportSize.Y * 0.463
--         self.OvalSize.X, self.OvalSize.Y = 0.6 * ViewportSize.X * 0.5, 0.55 * ViewportSize.Y * 0.5
--     elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
--         self.CenterPos.X, self.CenterPos.Y  = ViewportSize.X * 0.5, ViewportSize.Y * 0.4723
--         self.OvalSize.X, self.OvalSize.Y = 0.620 * ViewportSize.X * 0.5, 0.532 * ViewportSize.Y * 0.5
--     end
    
--     if not Controller:IsA(APlayerController) then
--         return
--     end

--     -- 根据目标的世界坐标计算屏幕坐标（插值）
--     local CurrentOffsetOnDoor, LocLerpFinished, IndicatorAngle, TargetDistance,
--         CurrentDistance, IsOutElliptic, IsOutScreen =
--         UUIFunctionLibrary.LerpAndProjectWorldToScreenInEllipse(

--             Controller, self.TargetWorldLoc, self.CurrentWorldLoc, self.LocationLerpInterval,
--             self.ScreenLocation, self.CenterPos, self.OvalSize, self.BoardSize, self.State == self.States.OnDoor,
--             self.TargetOffsetOnDoor, self.CurrentOffsetOnDoor, self.OffsetLerpInterval, false, 0, 0, 0, false
        
--         )
--     self.IsOutScreen = IsOutScreen
--     self.IsOutElliptic = IsOutElliptic
--     self.CurrentOffsetOnDoor = CurrentOffsetOnDoor
    
--     -- 等待指引点位置移动完成后隐藏
--     if LocLerpFinished == true and self.TargetVisibilityOnDoor == false and self.CurrentVisbilityOnDoor == true then
--         self.Guide_Node:SetVisibility(ESlateVisibility.Collapsed)
--         self.CurrentVisbilityOnDoor = false
--     end

--     -- 是否使用实际 Actor 的距离
--     if self.UseRealDistance then
--         TargetDistance = UKismetMathLibrary.Vector_Distance(
--             Player.CurrentLocation, self.TargetPointPos
--         ) / 100.0
--     end
--     self.PointRealDistance = TargetDistance

--     -- 设置指引点在屏幕边缘时隐藏数字显示箭头
--     self:SetArrowAndNumVisiblity(IndicatorAngle)

--     -- 把指引点的 UI 设置在屏幕坐标上
--     local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Guide_Node)
--     local ViewPortScale = UWidgetLayoutLibrary.GetViewportScale(self)
--     self.CacheScreenPos:Set(self.ScreenLocation.X / ViewPortScale, self.ScreenLocation.Y / ViewPortScale)
--     CanvasSlot:SetPosition(self.CacheScreenPos)
-- end

-- function WBP_DungeonIndicatorUI_C:GetDistanceText()
--     -- 小于 1m
--     if self.PointRealDistance < 1 then
--         return "<1"..self.DistanceUnit
--     end

--     -- 在 1-9999m 之间，拼接数值和单位
--     if self.PointRealDistance <= 9999 then
--         return tostring(math.ceil(self.PointRealDistance))..self.DistanceUnit
--     end

--     -- 大于 9999m
--     return ">9999"..self.DistanceUnit
-- end

-- function WBP_DungeonIndicatorUI_C:SetArrowAndNumVisiblity(IndicatorAngle)
--     -- 指引点在屏幕的边缘
--     if self.RequireDirectionArrow and self.IsOutElliptic then
        
--         -- 打开方向箭头的显示
--         self.Common_Arrows:SetRenderTransformAngle(IndicatorAngle + 45)
--         self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

--         if self.GuideType == "Phantom" and self.Phantom then
--             -- if self.TargetActor:IsDead() and self.PhantomGuideState == EPhantomGuideState.Dead then
--             --     self.Panel_RemainTimes:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             -- end
--             -- if self.TargetActor:IsInRecovering() and self.PhantomGuideState == EPhantomGuideState.Resurrecting then
--             --     self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             -- end
            
--             if self.CurPhantomGuideState == EPhantomGuideState.Dead then
--                 self.Panel_RemainTimes:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             end
--             if self.CurPhantomGuideState == EPhantomGuideState.Resurrecting then
--                 self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             end
--         end
--         -- 关闭距离数字的显示
--         self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
    
--     -- 指引点在屏幕内部
--     else
        
--         -- 关闭方向箭头的显示
--         self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)

--         -- 打开距离数字的显示
--         self.Text_Distance:SetText(self:GetDistanceText())
--         self.Text_Distance:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

--         if self.PointRealDistance <= 2 and self.GuideType == "Task" then
--             self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         end

--         if self.GuideType == "Phantom" and self.Phantom then
--             -- if self.TargetActor:IsDead() and self.PhantomGuideState == EPhantomGuideState.Dead then
--             --     self.Panel_RemainTimes:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--             -- elseif  self.TargetActor:IsInRecovering() and self.PhantomGuideState == EPhantomGuideState.Resurrecting then
--             --     self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             -- end
--             if self.CurPhantomGuideState == EPhantomGuideState.Dead then
--                 self.Panel_RemainTimes:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--             elseif self.CurPhantomGuideState == EPhantomGuideState.Resurrecting then
--                     self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             end
--         end
--     end
-- end

------------------------------------------------- 破坏关卡精英怪指引接口 -------------------------------------------------

function WBP_DungeonIndicatorUI_C:InitABCTextInSabotage(GuideIconAni)
    if GuideIconAni ~= "Destroy" then
        return
    end

    if self.TargetEid == nil then
        self:DebugPrint("InitABCTextInSabotage: TargetEid 不存在")
        return
    end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance == nil then
        self:DebugPrint("InitABCTextInSabotage: GameInstance 不存在")
        return
    end

    local SceneManager = GameInstance:GetSceneManager()
    if SceneManager == nil then
        self:DebugPrint("InitABCTextInSabotage: SceneManager 不存在")
        return
    end

    -- -- 设置 TextLetter 组件的 Text 内容
    -- self.Text_Letter:SetText(SceneManager:GetABCText(SceneManager.SabotageABCMap, self.TargetEid, 26))
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	if Player ~= nil then
		Player.RPCComponent:RequestSabotageGuideInfo_Client(self, self.SetABCTextInSabotage_Callback)
	end
end

-- Eids: TArray, 顺序为ABC顺序
function WBP_DungeonIndicatorUI_C:SetABCTextInSabotage_Callback(Eids, UnitIds)
    -- 从传入的Eids中找到对应的Index
    local index = 0
    for i, Eid in pairs(Eids) do
        if Eid == self.TargetEid then
            index = i
            break
        end
    end
    if index == 0 then
        return
    end
    local ABCLetter = string.char(string.byte('A') + index - 1)
    DebugPrint("WBP_DungeonIndicatorUI_C ABCLetter", ABCLetter, "Eid", self.TargetEid, "index", index)

    local SceneManager = GWorld.GameInstance:GetSceneManager()
    if SceneManager == nil then
        self:DebugPrint("InitABCTextInSabotage: SceneManager 不存在")
        return
    end
    local RetPath = SceneManager:GetSabotageABCIconPath(ABCLetter)
    UE4.UResourceLibrary.LoadObjectAsync(self, RetPath, {self, WBP_DungeonIndicatorUI_C.OnGuideIconLoadFinish})

end

function WBP_DungeonIndicatorUI_C:GetTextLetter()
    if self.Text_Letter == nil then
        return nil
    end

    -- 返回 TextLetter 组件的 Text 内容
    return self.Text_Letter:GetText()
end

------------------------------------------------- 挖掘关卡挖掘机指引接口 -------------------------------------------------

function WBP_DungeonIndicatorUI_C:GetExcavationEfficiency()
    local Ent = Battle(self):GetEntity(self.TargetEid)
    if Ent ~= nil and Ent.Efficiency ~= nil then
        return Ent.Efficiency
    end
    return 0
end

function WBP_DungeonIndicatorUI_C:GetExcavationABCLetter()
    -- 优先从实体上拿 GuideOrderIndex
    local Ent = Battle(self):GetEntity(self.TargetEid)
    if Ent ~= nil and Ent.GuideOrderIndex ~= nil then
        local Index = (Ent.GuideOrderIndex - 1) % 6
        return string.char(string.byte('A') + Index)
    end

    -- 兼容机关可能被序列化拿不到实体的情况：
    -- 从 GameState 里按 Eid 取事先记录好的顺序（例如充能机关用 CreatorId 顺序）
    DebugPrint("JLy GetExcavationABCLetter", self.TargetEid)
    if self.GameState and self.GameState.GuideOrderMap then
        local OrderIndex = self.GameState.GuideOrderMap:FindRef(self.TargetEid)
        DebugPrint("JLy GetExcavationABCLetter OrderIndex", OrderIndex)
        if OrderIndex and OrderIndex > 0 then
            local Index = (OrderIndex - 1) % 6
            return string.char(string.byte('A') + Index)
        end
    end

    return " "
end

-- function WBP_DungeonIndicatorUI_C:InitABCTextInExcavation()
--     if self.ConfigData.GuideIconAni ~= "Excavation" or self.Text_Letter == nil then
--         return 
--     end

--     if self.TargetEid == nil then
--         self:DebugPrint("InitABCTextInSabotage: TargetEid 不存在")
--         return
--     end

--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     if GameInstance == nil then
--         self:DebugPrint("InitABCTextInSabotage: GameInstance 不存在")
--         return
--     end

--     local SceneManager = GameInstance:GetSceneManager()
--     if SceneManager == nil then
--         self:DebugPrint("InitABCTextInSabotage: SceneManager 不存在")
--         return
--     end

--     local Ent = Battle(self):GetEntity(self.TargetEid)
--     local Level_str = Ent.Efficiency
    
--     if Level_str == 1 then
--         self.Level_1:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Level_2:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Level_3:SetVisibility(UE4.ESlateVisibility.Collapsed)
    
--     elseif Level_str == 2 then
--         self.Level_1:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Level_2:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Level_3:SetVisibility(UE4.ESlateVisibility.Collapsed)

--     elseif Level_str == 3 then
--         self.Level_1:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Level_2:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Level_3:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end

--     -- 设置 TextLetter 组件的 Text 内容
--     self.Text_Letter:SetText(SceneManager:GetABCText(SceneManager.ExcavationABCMap, self.TargetEid, 6))
-- end

-- function WBP_DungeonIndicatorUI_C:GetSceneLevelIdStr(TargetEid)
--     if self.SceneManager.Guide2LevelInfo[TargetEid] ~= nil then
--         return self.SceneManager.Guide2LevelInfo[TargetEid].LevelID;
--     end
--     return ""
-- end

-- function WBP_DungeonIndicatorUI_C:GetSceneDoorNameStr(TargetEid)
--     if self.SceneManager.Guide2LevelInfo[TargetEid] ~= nil then
--         return self.SceneManager.Guide2LevelInfo[TargetEid].InDoorName;
--     end
--     return ""
-- end

----------------------------------------------------- 魅影指引点功能 -----------------------------------------------------

-- function WBP_DungeonIndicatorUI_C:PlayPhantomNormalAnimation()
--     self:PlayAnimation(self.Normal)
-- end

-- function WBP_DungeonIndicatorUI_C:SetIconStateStyle()
--     self:SetPhantomImgAvatar()
--     if self.PhantomGuideState == EPhantomGuideState.Alive then
--         self.Phantom.Bar_Circle:GetDynamicMaterial():SetScalarParameterValue("Percent",  1)
--         self.Panel_RemainTimes:SetRenderOpacity(0)
--         self.Panel_Rescue:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     elseif self.PhantomGuideState == EPhantomGuideState.Dead then
--         self.Phantom.Bg_Black01:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         local CanRecoveryCount = self:GetCanRecoveryCount()
--         if CanRecoveryCount > 0 then
--             self.Text_Times:SetText(CanRecoveryCount)
--         end
--         self.Text_Distance:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

--     elseif self.PhantomGuideState == EPhantomGuideState.Resurrecting then
--         self.Panel_Rescue:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
-- end

-- function WBP_DungeonIndicatorUI_C:UpdatePhantomVisbility()
--     if self.TargetActor:IsDead() then
--         if self:GetCanRecoveryCount() <= 0 then
--             self.TargetPhantomOpacity = 0
--         else self.TargetPhantomOpacity = 1 end
--     else
--         -- 方案一
--         local CameraMgr = UE4.UGameplayStatics.GetPlayerCameraManager(self, 0)
--         if CameraMgr == nil then return end

--         local HitScene = UE4.UKismetSystemLibrary.LineTraceSingle(self, self.TargetWorldLoc,
--             CameraMgr:GetCameraLocation(), ETraceTypeQuery.TraceScene, false, nil, 0, FHitResult(), true)
        
--         if self.IsOutElliptic or HitScene then
--             self.TargetPhantomOpacity = 1
--         else self.TargetPhantomOpacity = 0 end

--         -- 方案二
--         -- if self.TargetActor ~= nil and self.TargetActor:WasRecentlyRendered(0.1) then
--         --     local CameraMgr = UE4.UGameplayStatics.GetPlayerCameraManager(self, 0)
--         --     if CameraMgr == nil then return end

--         --     local HitScene = UE4.UKismetSystemLibrary.LineTraceSingle(self, self.TargetWorldLoc,
--         --         CameraMgr:GetCameraLocation(), ETraceTypeQuery.TraceScene, false, nil, 0, FHitResult(), true)

--         --     if HitScene then self.TargetPhantomOpacity = 1 
--         --     else self.TargetPhantomOpacity = 0 end
--         -- else self.TargetPhantomOpacity = 1 end
--     end

--     self.CurrentPhantomOpacity = UE4.UKismetMathLibrary.Lerp(
--         self.CurrentPhantomOpacity,self.TargetPhantomOpacity, self.PhantomOpacityLerpInterval)
--     self:SetRenderOpacity(self.CurrentPhantomOpacity)
-- end

-- function WBP_DungeonIndicatorUI_C:UpdatePhantomIndicator()
    -- if self:CheckPhantomIsNeedChangeIconState() then
    --     self:SetIconStateStyle()
    -- end
    -- self:UpdatePhantomCanRecoveryCount()
    -- self:UpdateRecoveryBarCircle()
    -- self:UpdatePhantomVisbility()
-- end

function WBP_DungeonIndicatorUI_C:TriggerDeadGuideDisplay(IsLoop)
    if self.WBP_GuidePoint_Base and self.WBP_GuidePoint_Base.Loop and IsLoop then
        self.WBP_GuidePoint_Base:PlayAnimation(self.WBP_GuidePoint_Base.Loop, 0, 0)
        local IconImagePath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rescue_HostageB.T_Gp_Rescue_HostageB'
        UE4.UResourceLibrary.LoadObjectAsync(self, IconImagePath, {self, WBP_DungeonIndicatorUI_C.OnGuideIconLoadFinish})

        EventManager:FireEvent(EventID.OnHostageDeadUpdateMiniMap, true)
        EventManager:FireEvent(EventID.TriggerHostageBattleMapChangeStyle, true)

    elseif not IsLoop then
        self:StopAllAnimations()
        if self.WBP_GuidePoint_Base then
            self.WBP_GuidePoint_Base:StopAllAnimations()
        end
        local IconImagePath = '/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rescue_HostageA.T_Gp_Rescue_HostageA'
        UE4.UResourceLibrary.LoadObjectAsync(self, IconImagePath, {self, WBP_DungeonIndicatorUI_C.OnGuideIconLoadFinish})

        EventManager:FireEvent(EventID.OnHostageDeadUpdateMiniMap, false)
        EventManager:FireEvent(EventID.TriggerHostageBattleMapChangeStyle, false)
    end

    if IsLoop then
        self:SetArrowColor(self.Color_Red.SpecifiedColor)
    else
        self:SetArrowColor(self.Color_Blue.SpecifiedColor)
    end
end

function WBP_DungeonIndicatorUI_C:OnGuideIconLoadFinish(Object)
    if Object ~= nil then
        if self.Img_GuidePoint_Icon then
            self.Img_GuidePoint_Icon:SetBrushResourceObject(Object)
        else
            self.ImgMaterial:SetTextureParameterValue("GuideIcon", Object)
        end
    end
    self.IsIconLoaded = true
end

function WBP_DungeonIndicatorUI_C:ChangeHostageVisibility(IsShow)
    if IsShow then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_DungeonIndicatorUI_C:SetPhantomRecoverCountChangeFlagByEvent()
    self.IsChangeRecoverCount = true
end

function WBP_DungeonIndicatorUI_C:SetPhantomGuideStateByEvent(PhantomEid, State, PrevState)
    if self.TargetEid ~= PhantomEid then
        return
    end
    local PreState = self.CurPhantomGuideState
    if State == UE4.ETeamRecoveryState.Dying then
        self.CurPhantomGuideState = EPhantomGuideState.Dead
    elseif State == UE4.ETeamRecoveryState.IsWaitingRecover then
        self.CurPhantomGuideState = EPhantomGuideState.Resurrecting
    elseif State == UE4.ETeamRecoveryState.Alive then
        self.CurPhantomGuideState = EPhantomGuideState.Alive
    end

    if State == UE4.ETeamRecoveryState.Alive and PrevState == UE4.ETeamRecoveryState.IsWaitingRecover then
        self:SetPhantomRecoverCountChangeFlagByEvent()
    end
    
    -- if PreState == EPhantomGuideState.Resurrecting and self.CurPhantomGuideState == EPhantomGuideState.Dead then
    --     self.IsStopRecover = true
    -- end

    self.IsNeedChangeState = true
end

function WBP_DungeonIndicatorUI_C:DisappearCacheIndicatorClass(Eid)
    if self.TargetEid == Eid and self.IsActiveInPoor then
        self:Disappear()
        self.IsActiveInPoor = false
    end
end

function WBP_DungeonIndicatorUI_C:UpdatePhantomCanRecoveryCount()
    if self.TargetActor:IsDead() then
        local CanRecoveryCount = self:GetCanRecoveryCount()
        if CanRecoveryCount > 0 and not self.TargetActor:IsInRecovering() then
            self.Panel_RemainTimes:SetRenderOpacity(1.0)
            self.Text_Times:SetText(CanRecoveryCount)
        end
    end
end

function WBP_DungeonIndicatorUI_C:UpdateRecoveryBarCircle()
    self.Text_Percent:SetText(math.floor(self.TargetActor:GetRecoveryPercent()))
    self.Phantom.Bar_Circle:GetDynamicMaterial():SetScalarParameterValue("Percent",  self.TargetActor:GetRecoveryPercent() / 100)
end

function WBP_DungeonIndicatorUI_C:GetCanPhantomRecoveryCount()
    if self.TargetActor:IsPhantom() then
        return self.TargetActor:GetRecoveryMaxCount() - self.TargetActor:GetRecoveryCount()
    end

    return 0
end

----------------------------------------------------- 怪物警戒 -----------------------------------------------------
function WBP_DungeonIndicatorUI_C:UpdateAlertUI(DeltaSeconds)
    -- DebugPrint("zwk  ", self.AlertValue, self.LastAlertValue)
    if self.AlertValue > 0 and self.ReadyShowAlert then
        -- 首次出现播放入场动画
        self.Guide_Node:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.IsMax = false
        self.ReadyShowAlert = false
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)
        self:SetArrowColor(self.Color_White.SpecifiedColor)
        -- 首次直接满警戒值播放max
        if self.AlertValue >= self.MaxAlertValue and not self.IsMax then
            self.IsMax = true
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Max)
            self:SetArrowColor(self.Color_Red.SpecifiedColor)
        end
    elseif self.AlertValue >= self.MaxAlertValue and not self.IsMax then
        -- 涨满播放Max
        self.IsMax = true
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Max)
        self:SetArrowColor(self.Color_Red.SpecifiedColor)
    elseif self.AlertValue <= 0 and not self.ReadyShowAlert then
        -- 降回0或脱战(-1)播放Out动画，重置变量
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Out)
        self.ReadyShowAlert = true
        self.FirstDown = false
        self.IsMax = false
        self:StopAlertAudio()
    elseif self.AlertValue > 0 and not self.ReadyShowAlert and self.AlertValue > self.LastAlertValue and self.CanUpAnim and self.FirstDown then
        -- 非首次但是开始上升播放Rising
        self.IsMax = false
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Rising)
    elseif self.AlertValue >= 0 and not self.ReadyShowAlert and self.AlertValue <= self.LastAlertValue and self.CanDownAim then
        -- 开始下降倒放Rising同时播放Normal
        self.IsMax = false
        EMUIAnimationSubsystem:EMStopAnimation(self, self.Max)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Rising, EUMGSequencePlayMode.Reverse)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    end

    if self.AlertValue > 0 and self.AlertValue <= self.MaxAlertValue and self.AlertValue >= self.LastAlertValue then
        self.CanUpAnim = false
        self.CanDownAim = true
        self:CalChange(DeltaSeconds)
    elseif self.AlertValue >= 0 and self.AlertValue <= self.MaxAlertValue and self.AlertValue <= self.LastAlertValue then
        self.CanUpAnim = true
        self.CanDownAim = false
        self.FirstDown = true
        self:CalChange(DeltaSeconds)
    end
end

function WBP_DungeonIndicatorUI_C:CalChange(DeltaSeconds)
    -- 在每个Alert值更新间隔（0.3s）内均匀增减警戒值
    local Times = DeltaSeconds / 0.02
    if Times <= 0 then
        Times = 1
    end
    local SingleChangeValue = (self.AlertValue - self.LastAlertValue) / Times
    Times = math.floor(Times)
    self.Bar:SetPercent(self.LastAlertValue / self.MaxAlertValue)
    self:AddTimer(0.02, self.ChangeBar, true, -1, "ChangeBar", nil, Times, SingleChangeValue)
end

function WBP_DungeonIndicatorUI_C:ChangeBar(Times, SingleChangeValue)
    self.TimerTimes = self.TimerTimes + 1
    local Percent = self.Bar.Percent
    self.Bar:SetPercent(Percent + SingleChangeValue / self.MaxAlertValue)
    if self.TimerTimes >= Times then
        self.TimerTimes = 0
        self:RemoveTimer("ChangeBar")
    end
end
----------------------------------------------------- 怪物警戒END -----------------------------------------------------

return WBP_DungeonIndicatorUI_C