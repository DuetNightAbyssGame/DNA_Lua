--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local Guide_Icon_Point_C = Class("BluePrints.UI.BP_UIState_C")

---------------------------------------------------- 本指引点通用接口 ----------------------------------------------------

function Guide_Icon_Point_C:DebugPrint(...)
    DebugPrint("DungeonIndicator", ...)
end

function Guide_Icon_Point_C:AssignVector(from, to)
    to.X, to.Y, to.Z = from.X, from.Y, from.Z
end

function Guide_Icon_Point_C:AssignVector2D(from, to)
    to.X, to.Y = from.X, from.Y
end

function Guide_Icon_Point_C:GetBPName()
    if self.ConfigData == nil then
        return nil
    end
    return self.ConfigData.GuideIconAni
end

function Guide_Icon_Point_C:GetIconSize()
    if self.ConfigData == nil or self.ConfigData.GuideIconAni == nil then
        return FVector2D(64, 64)
    end
    return self.IconSize
end

function Guide_Icon_Point_C:GetRealDistance()
    return self.PointRealDistance
end

function Guide_Icon_Point_C:GetIconPathName()
    if self.ConfigData == nil then
        return ""
    end
    return self.ConfigData.GuideIconAni
end

----------------------------------------------------- 初始化相关函数 -----------------------------------------------------
local PhantomStateEnum = {
    Alive = 0,
    Dead = 1,
    Resurrecting = 2
}

function Guide_Icon_Point_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.ConfigData = nil

    self.TargetEid = nil                                -- 指引目标 Eid
    self.TargetActor = nil                              -- 指引目标 Actor
    self.TargetPointPos = nil                           -- 指引目标点位置（实际目标点位置，不在门上）

    self.OvalSize = FVector2D(0, 0)                     -- 范围限制椭圆大小
    self.CenterPos = FVector2D(0, 0)                    -- 屏幕坐标的中心点

    self.ScreenLocation = FVector2D(0, 0)               -- 指引点的屏幕坐标
    self.TargetWorldLoc = FVector(0, 0, 0)              -- 指引点的世界坐标（指引点的位置，可能在门上，插值目标点）
    self.CurrentWorldLoc = FVector(0, 0, 0)             -- 指引点的世界坐标（指引点的位置，可能在门上，插值当前点）

    self.TargetVisibility = true                        -- 指引点可见性（经过门时不刷新）
    self.TargetVisibilityOnDoor = true                  -- 指引点可见性（经过门时刷新）
    self.CurrentVisbilityOnDoor = true                  -- 指引点可见性（经过门时刷新）

    self.LocationLerpInterval = 3                       -- 指引点的世界坐标插值间隙

    self.GuideType = ""                                 -- 指引点的类型
    self.IconSize = nil                                 -- 指引 Icon 的大小
    self.BoardSize = FVector2D(30, 30)                  -- 指引显示范围边界大小
    self.DistanceUnit = GText("UI_SCALE_METER")         -- 指引点距离显示单位

    self.TargetOffsetOnDoor = 0                         -- 指引的偏移（挂在门上面的时候，插值目标点）
    self.CurrentOffsetOnDoor = 0                        -- 指引的偏移（挂在门上面的时候，插值当前点）
    self.OffsetLerpInterval = 150                       -- 指引点偏移插值间隙

    self.DoorPosition = FVector(0, 0, 0)                -- 指引点在门上时，门的位置
    self.DoorDirection = FVector(0, 0, 0)               -- 指引点在门上时，门的方向

    self.UseRealDistance = true                         -- 是否使用实际距离
    self.PointRealDistance = 0                          -- 指引的实际距离

    self.RequireInAnimation = false                     -- 是否需要入场动画
    self.RequireLookUpEntity = false                    -- 是否需要寻找对应的 Entity
    self.RequireDirectionArrow = false                  -- 是否需要显示方向箭头
    self.RequireFollowingActor = false                  -- 指引是否需要跟随 Actor
    self.PhantomGuideState = nil                        -- 魅影指引点状态

    self.States = {                                     -- 所有状态的枚举
        OnDoor = 0,                                     -- 在门上显示
        OnActor = 1,                                    -- 在 Actor 上显示
    }   
    self.Styles = {                                     -- 所有样式的枚举
        Single = 0,                                     -- 单个无堆叠
        Multiple = 1,                                   -- 指引点堆叠
        Disappearing = 2,                               -- 正在执行 Disappear
    }   
    self.State = self.States.OnActor                    -- 当前指引的状态
    self.Style = self.Styles.Single                     -- 当前指引的样式

    self.HideBehinds = {}                               -- 隐藏在背后的指引点
    self.SpawnDown = false                              -- 指引点是否生成完成
    self.FlyToTarget = true                             -- 生成出来之后是否要从角色身上飞到 Target 上
    self.CacheScreenPos = FVector2D(0, 0)

    self.TargetPhantomOpacity = 1                       -- 魅影指引点目标透明度
    self.CurrentPhantomOpacity = 1                      -- 魅影指引点当前透明度
    self.PhantomOpacityLerpInterval = 0.1               -- 魅影指引点透明度插值间隔
end

function Guide_Icon_Point_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    -- 解析参数赋值给成员
    self.TargetEid, self.TargetActor, self.TargetPointPos, self.ConfigData, self.RequireDirectionArrow,
        self.RequireFollowingActor, self.RequireLookUpEntity, self.RequireInAnimation, self.UseRealDistance = ...

    -- 初始化配置数据
    self:InitConfigData()

    -- 获取 Icon 的大小
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Guide_Node)
    self.IconSize = CanvasSlot:GetSize()
    self.CacheScreenPos = FVector2D(0, 0)
    
    -- 将指引点显示出来
    self:SetVisibilityOnDoor(true)
    self:SetVisibilityNotOnDoor(true)
end

function Guide_Icon_Point_C:InitConfigData()

    -- 从 TargetActor 设置指引点类型
    if IsValid(self.TargetActor) then
        self.GuideType = self.TargetActor.UnitType
    
    -- 从 ConfigData 设置指引点类型
    elseif self.ConfigData ~= nil then
        self.GuideType = self.ConfigData.UnitRealType
    end

    -- 给一个默认的 ConfigData
    if self.ConfigData == nil then
        self.ConfigData = {
            UnitType = "AOITriggerBox",
            GuideIconAni = "Evacuation", 
            GuideIconBPPath = "/Game/UI/UI_Phone/Battle/Battle_Main/Frames/Icon_MapMark_05.Icon_MapMark_05"
        }
    end

    -- 刷新指引点
    self:Refresh(self.ConfigData.GuideIconAni, self.RequireInAnimation)

    -- 生存本相关的初始化
	-- 放在这会有联机的问题，但是这个数据现在只用来显示 UI，先这样做了
	if (self.ConfigData.GuideIconAni == "lifeSupport_System" or self.ConfigData.GuideIconAni == "Guide_Icon_Survival") and not self.AddedSupplyCount then
		local GameState = UE4.UGameplayStatics.GetGameState(self)

        if GameState ~= nil then
			self.AddedSupplyCount = true
		end
	end

    -- 设置不同的指引点图标
    self:SetGuideImage(self.ConfigData.GuideIconImg)

    -- 初始化挖掘和破坏的 ABC 指引
    self:InitABCTextInSabotage()
    self:InitABCTextInExcavation()

    -- 显示重要指引点的名字
    if self.Text_PointName == nil then
        return
    end
    if self.ConfigData.GuideText ~= nil then
        self.Text_PointName:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_PointName:SetText(GText(self.ConfigData.GuideText))
    else self.Text_PointName:SetVisibility(UE4.ESlateVisibility.Collapsed) end
end

function Guide_Icon_Point_C:SetPhantomImgAvatar()
    if self.GuideType == "Phantom" and self.Phantom then
        if self.PhantomGuideState == PhantomStateEnum.Alive then
            local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
            local PhantomGuideIconImg = DataMgr.BattleChar[self.TargetActor.UnitId].GuideIconImg
            local NormalIconName = "T_Normal_"..PhantomGuideIconImg
            local IconImage = LoadObject(MiniIconPath..NormalIconName.."."..NormalIconName)
            self.Phantom.Img_Avatar:SetBrushResourceObject(IconImage)
        elseif self.PhantomGuideState == PhantomStateEnum.Dead then
            local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
            local PhantomGuideIconImg = DataMgr.BattleChar[self.TargetActor.UnitId].GuideIconImg
            local DeadIconName = "T_Dead_"..PhantomGuideIconImg
            local IconImage = LoadObject(MiniIconPath..DeadIconName.."."..DeadIconName)
            self.Phantom.Img_Avatar:SetBrushResourceObject(IconImage)
        end
    end
end

function Guide_Icon_Point_C:TryPlayAppearAudio()
    if self.GuideType == "Task" then
        AudioManager(self):PlayUISound(self, "event:/ui/common/guide_point_show", nil, nil)
    end
end
----------------------------------------------------- 指引点行为函数 -----------------------------------------------------

function Guide_Icon_Point_C:SetGuideImage(ImageName)
    
    -- 从 UIConst 表读取 Image 路径
    local ImagePath = UIConst.DUNGEONINDICATORIMG[ImageName]
    if ImagePath ~= nil and self.Img_GuidePoint_Icon ~= nil then
        
        -- 加载 Icon 图片的 Object
        local IconImage = LoadObject(ImagePath)
        if IconImage == nil then
            self:DebugPrint("InitConfigData: 指引点 Icon 图片不存在！")
            return
        end

        -- 设置指引点的 Icon 图标
        self.Img_GuidePoint_Icon:SetBrushResourceObject(IconImage)
    end
end

function Guide_Icon_Point_C:Refresh(BPName, RequireInAnimation)

    -- 如果 BPName 不为空
    if BPName ~= nil then

        -- 如果 BPName_Arrows 存在，隐藏 Common_Arrwos
        if self[BPName.."_Arrows"] ~= nil and self.Common_Arrows ~= nil then
            self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

        -- 如果需要播放入场动画
        if RequireInAnimation == true then
            self:PlayAppearAnim() 
        end

        -- 如果 Panel_BPName 存在，显示 Panel_BPName
        BPName = "Panel_"..BPName
        if self[BPName] ~= nil then
            self[BPName]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    
    -- 如果 BPName 为空
    else

        -- 隐藏指引点
        self:SetVisibilityOnDoor(false)
        self:SetVisibilityNotOnDoor(false)
    end
end

function Guide_Icon_Point_C:Reset(TargetEid, TargetActor, TargetLocation, ConfigData, RequireDirectionArrow,
    RequireFollowingActor, RequireLookUpEntity, RequireInAnimation, UseRealDistance, IsResetPos)

    -- 重设指引点的各种参数
    self.TargetEid = TargetEid
    self.TargetActor = TargetActor
    self.TargetPointPos = TargetLocation
    self.UseRealDistance = UseRealDistance
    self.RequireInAnimation = RequireInAnimation
    self.RequireLookUpEntity = RequireLookUpEntity
    self.RequireDirectionArrow = RequireDirectionArrow
    self.RequireFollowingActor = RequireFollowingActor

    if IsResetPos then self.TargetOffsetOnDoor = 0 end
    if ConfigData ~= nil then self.ConfigData = ConfigData  end
    
    -- 初始化 ConfigData
    self:InitConfigData()
end

function Guide_Icon_Point_C:Disappear()
    -- 可能在播放退出动画，设置一次状态即可
    if (self.Style == self.Styles.Disappearing) then
        return
    end
    self.Style = self.Styles.Disappearing

    -- 如果指引点是正常的并且需要播放退出动画
    if self.ConfigData ~= nil and self.ConfigData.GuideIconAni ~= nil and self.RequireInAnimation then
        self:UnbindAllFromAnimationFinished(self.Out)

        -- 退出动画结束的回调，关闭播放完动画的 UI
        local function PlayAnimFinished()
            local StyleNode = "Panel_"..self.ConfigData.GuideIconAni
            if (self[StyleNode] ~= nil) then
                self[StyleNode]:SetVisibility(UE4.ESlateVisibility.Collapsed) 
            end
            self:Close()
        end

        -- 如果有退出动画，播放并绑定 Finish 回调
        if self.Out ~= nil then
            self:BindToAnimationFinished(self.Out, { self, PlayAnimFinished })
            self:PlayAnimation(self.Out)
        
        -- 如果没有退出动画，直接走 Finish 回调
        else PlayAnimFinished() end
    
    -- 如果指引点不正常或者不需要播放退出动画
    else
        self:Close()
    end
end

function Guide_Icon_Point_C:ChangeStyle(Style, Count)
    if self.ConfigData == nil or self.ConfigData.GuideIconAni == nil then
        self:DebugPrint("ChangeStyle: 指引点未显示")
        return
    end

    -- 如果样式是 Single
    if Style == self.Styles.Single then
    
        -- 关闭数量显示
        if self.Panel_Quantity ~= nil then 
            self.Panel_Quantity:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

        -- 隐藏堆叠背景
        if self.Panel_GuidePoint_More ~= nil then
            self.Panel_GuidePoint_More:SetVisibility(UE4.ESlateVisibility.Collapsed) 
        end
    
    -- 如果样式是 Multiple
    elseif Style == self.Styles.Multiple then
    
        -- 打开数量显示
        if self.Text_Quantity ~= nil and self.Panel_Quantity ~= nil then
            self.Text_Quantity:SetText(tostring(Count))
            self.Panel_Quantity:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    
        -- 显示堆叠背景
        if self.Panel_GuidePoint_More ~= nil then
            self.Panel_GuidePoint_More:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    
        -- 如果样式是其他样式
    else self:DebugPrint("ChangeStyle: 样式不合法") end
end

function Guide_Icon_Point_C:GetVisible()
    return self.TargetVisibilityOnDoor
end

function Guide_Icon_Point_C:SetVisibilityNotOnDoor(Visible)
    self.TargetVisibility = Visible

    if self.TargetVisibility == true and self.TargetVisibilityOnDoor == true then
        self.Guide_Node:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    if self.TargetVisibility == false then
        self.Guide_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Guide_Icon_Point_C:SetVisibilityOnDoor(Visible, HideObjs)
    -- 如果要显示
    if Visible == true then

        self.TargetVisibilityOnDoor = true
        self.CurrentVisbilityOnDoor = true

    -- 如果要隐藏
    elseif Visible == false then
        self.TargetVisibilityOnDoor = false
    end

    -- 指引点遮挡的 Objs
    self.HideBehinds = HideObjs

    if self.TargetVisibility == true and self.TargetVisibilityOnDoor == true then
        self.Guide_Node:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

------------------------------------------------------ 动画播放函数 ------------------------------------------------------

function Guide_Icon_Point_C:PlayAppearAnim()
    if self.In ~= nil then
        self:PlayAnimation(self.In)
    end
end

function Guide_Icon_Point_C:RePlayAppearAnim()
    if self.Loop ~= nil then
        self:PlayAnimation(self.Loop, 0, 2)
    end 
end

----------------------------------------------------- 更新指引点位置 -----------------------------------------------------

function Guide_Icon_Point_C:GetTargetPosition(SceneManager)
    if self.RequireLookUpEntity == true then

        -- 需要 Tick 搜寻 Actor
        self.TargetActor = Battle(self):GetEntity(self.TargetEid)

        -- 如果可以从 Battle 中获得数据
        if IsValid(self.TargetActor) then

            -- 取消 RequireLookUpEntity 标记
            self.RequireLookUpEntity = false
            self.GuideType = self.TargetActor.UnitType
            -- self:InitPhantomConfigData()

        -- 如果从 Battle 中获取不到数据
        else

            -- 直接去拿序列化数据
            local ClientGuideData = SceneManager.CurSceneGuideEids[self.TargetEid]
            if ClientGuideData ~= nil then
                
                -- 如果是结构化的数据
                if ClientGuideData.Type == "DataStruct" then
                    
                    -- 如果可以拿到 Entity.Loc 则直接使用
                    if ClientGuideData.Entity and ClientGuideData.Entity.Loc then
                        self.TargetPointPos = ClientGuideData.Entity.Loc
                    else self:DebugPrint("GetTargetPosition: Entity.Loc 无效") end
                
                -- 如果不是结构化数据
                else
                    local RealEntity = Battle(self):GetEntity(ClientGuideData.Entity)
                    -- 如果 Entity 合法则 GetActorLocation
                    if IsValid(RealEntity) then
                        self.TargetPointPos = RealEntity:K2_GetActorLocation()
                    else
                        -- self:DebugPrint("GetTargetPosition: Entity:K2_GetActorLocation 无效")
                    end
                end
            
            -- 如果拿不到当前 Scene 的 GuideEids[TargetEid]
            else
                -- self:DebugPrint("GetTargetPosition: ClientGuideData 无效")
            end
        end

    elseif not IsValid(self.TargetActor) then

        self:DebugPrint("GetTargetPosition: 重新获取 TargetActor 实例")
        self.RequireLookUpEntity = true
    end
end

function Guide_Icon_Point_C:AdjustTargetPosition()
    -- 是否需要每帧调整 TargetPosition
    if not IsValid(self.TargetActor) or not IsValid(self.TargetActor) then
        return
    end

    -- 只有不是 Monster 且不需要跟踪
    if self.TargetActor.UnitType ~= "Monster"
        and self.RequireFollowingActor == false
        and self.TargetPointPos ~= nil then
        return
    end

    -- 如果  TargetPosition 为空，就创建出来
    if self.TargetPointPos == nil then
        self.TargetPointPos = FVector(0, 0, 0)
    end

    -- 重新计算 TargetPosition
    local TargetActorLocation = self.TargetActor:K2_GetActorLocation()
    self:AssignVector(TargetActorLocation, self.TargetPointPos)

    -- 如果 TargetActor 是胶囊
    if self.TargetActor.CapsuleComponent and self.TargetActor.CapsuleComponent.GetUnscaledCapsuleHalfHeight then
        self.TargetPointPos.Z = TargetActorLocation.Z + self.TargetActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight() * 0.8
        if self.TargetActor.UnitType == "Phantom" then
            self.TargetPointPos.Z = TargetActorLocation.Z + self.TargetActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight() * 1.0
        end
    
    -- 如果 TargetActor 是球体
    elseif self.TargetActor.Sphere and self.TargetActor.Sphere.GetScaledSphereRadius then
        self.TargetPointPos.Z = TargetActorLocation.Z
            + self.TargetActor.Sphere:GetScaledSphereRadius()
    
    -- 如果 TargetActor 是盒体
    elseif self.TargetActor.Box and self.TargetActor.Box.GetScaledBoxExtent then
        self.TargetPointPos.Z = TargetActorLocation.Z
            + self.TargetActor.Box:GetScaledBoxExtent().Z
    end
end

function Guide_Icon_Point_C:CheckPhantomIsNeedChangeIconState()
    local function TryPlayResurgenceSuccessFromResurrectEnd()
        if self.PhantomGuideState == PhantomStateEnum.Resurrecting then
            DebugPrint("Guide_Icon_Point_C:TryPlayResurgenceSuccessFromResurrectEnd", self.TargetEid)
            self:BindToAnimationFinished(self.Resurgence_Success, {self, self.PlayPhantomNormalAnimation})
            self:PlayAnimation(self.Resurgence_Success)
        end
    end

    if self.TargetActor:IsInRecovering() and self.PhantomGuideState ~= PhantomStateEnum.Resurrecting then
        DebugPrint("Guide_Icon_Point_C:CheckPhantomIsNeedChangeIconState Recovering", self.TargetEid)
        self.PhantomGuideState = PhantomStateEnum.Resurrecting
        self:PlayAnimation(self.Resurgence)
        return true
    elseif self.TargetActor:IsDead() and self.PhantomGuideState == PhantomStateEnum.Alive then
        DebugPrint("Guide_Icon_Point_C:CheckPhantomIsNeedChangeIconState dead", self.TargetEid)
        if self.PhantomGuideState == PhantomStateEnum.Alive then
            self:PlayAnimation(self.Dead)
            if self:GetCanRecoveryCount() <= 0 and self.TargetActor:IsDead() then
                local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
                local UIManager = GameInstance:GetGameUIManager()
                UIManager:ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, 'TOAST_PHANTOM_ISDEAD')
            end
        end
        self.PhantomGuideState = PhantomStateEnum.Dead
        return true
    elseif not self.TargetActor:IsDead() and self.PhantomGuideState ~= PhantomStateEnum.Alive then
        TryPlayResurgenceSuccessFromResurrectEnd()
        self.PhantomGuideState = PhantomStateEnum.Alive
        DebugPrint("Guide_Icon_Point_C:CheckPhantomIsNeedChangeIconState alive", self.TargetEid)
        self:PlayAnimation(self.Normal)
        return true
    elseif not self.TargetActor:IsInRecovering() and self.TargetActor:IsDead() and self.PhantomGuideState == PhantomStateEnum.Resurrecting then
        DebugPrint("Guide_Icon_Point_C:CheckPhantomIsNeedChangeIconState dead", self.TargetEid)
        self.PhantomGuideState = PhantomStateEnum.Dead
        self:PlayAnimation(self.Dead)
        return true
    end

    return false
end

function Guide_Icon_Point_C:PlayPhantomNormalAnimation()
    self:PlayAnimation(self.Normal)
end

function Guide_Icon_Point_C:SetIconStateStyle()
    self:SetPhantomImgAvatar()
    if self.PhantomGuideState == PhantomStateEnum.Alive then
        self.Phantom.Bar_Circle:GetDynamicMaterial():SetScalarParameterValue("Percent",  1)
        self.Panel_RemainTimes:SetRenderOpacity(0)
        self.Panel_Rescue:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif self.PhantomGuideState == PhantomStateEnum.Dead then
        self.Phantom.Bg_Black01:SetVisibility(UE4.ESlateVisibility.Collapsed)
        local CanRecoveryCount = self:GetCanRecoveryCount()
        if CanRecoveryCount > 0 then
            self.Text_Times:SetText(CanRecoveryCount)
        end
        self.Text_Distance:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    elseif self.PhantomGuideState == PhantomStateEnum.Resurrecting then
        self.Panel_Rescue:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Guide_Icon_Point_C:UpdatePhantomVisbility()
    if self.TargetActor:IsDead() then
        if self:GetCanRecoveryCount() <= 0 then
            self.TargetPhantomOpacity = 0
        else self.TargetPhantomOpacity = 1 end
    else
        -- 方案一
        local CameraMgr = UE4.UGameplayStatics.GetPlayerCameraManager(self, 0)
        if CameraMgr == nil then return end

        local HitScene = UE4.UKismetSystemLibrary.LineTraceSingle(self, self.TargetWorldLoc,
            CameraMgr:GetCameraLocation(), ETraceTypeQuery.TraceScene, false, nil, 0, FHitResult(), true)
        
        if self.IsOutElliptic or HitScene then
            self.TargetPhantomOpacity = 1
        else self.TargetPhantomOpacity = 0 end

        -- 方案二
        -- if self.TargetActor ~= nil and self.TargetActor:WasRecentlyRendered(0.1) then
        --     local CameraMgr = UE4.UGameplayStatics.GetPlayerCameraManager(self, 0)
        --     if CameraMgr == nil then return end

        --     local HitScene = UE4.UKismetSystemLibrary.LineTraceSingle(self, self.TargetWorldLoc,
        --         CameraMgr:GetCameraLocation(), ETraceTypeQuery.TraceScene, false, nil, 0, FHitResult(), true)

        --     if HitScene then self.TargetPhantomOpacity = 1 
        --     else self.TargetPhantomOpacity = 0 end
        -- else self.TargetPhantomOpacity = 1 end
    end

    self.CurrentPhantomOpacity = UE4.UKismetMathLibrary.Lerp(
        self.CurrentPhantomOpacity,self.TargetPhantomOpacity, self.PhantomOpacityLerpInterval)
    self:SetRenderOpacity(self.CurrentPhantomOpacity)
end

function Guide_Icon_Point_C:UpdatePhantomGuide()
    if self:CheckPhantomIsNeedChangeIconState() then
        self:SetIconStateStyle()
    end
    self:UpdatePhantomCanRecoveryCount()
    self:UpdateRecoveryBarCircle()
end

function Guide_Icon_Point_C:UpdatePhantomCanRecoveryCount()
    if self.TargetActor:IsDead() then
        local CanRecoveryCount = self:GetCanRecoveryCount()
        if CanRecoveryCount > 0 and not self.TargetActor:IsInRecovering() then
            self.Panel_RemainTimes:SetRenderOpacity(1.0)
            self.Text_Times:SetText(CanRecoveryCount)
        end
    end
end

function Guide_Icon_Point_C:UpdateRecoveryBarCircle()
    if self.TargetActor:IsInRecovering() and self.PhantomGuideState == PhantomStateEnum.Resurrecting then
        self.Text_Percent:SetText(math.floor(self.TargetActor:GetRecoveryPercent()))
        self.Phantom.Bar_Circle:GetDynamicMaterial():SetScalarParameterValue("Percent",  self.TargetActor:GetRecoveryPercent() / 100)
    end
end

function Guide_Icon_Point_C:GetCanRecoveryCount()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local PhantomRecoveryCount = Player.PlayerState.PhantomRecoveryCount
    local PhantomRecoveryMaxCount = Player.PlayerState.PhantomRecoveryMaxCount
    return PhantomRecoveryMaxCount - PhantomRecoveryCount
end

function Guide_Icon_Point_C:UpdateIndicator()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance == nil then
        self:DebugPrint("UpdateIndicator: GameInstance 不存在")
        return
    end
    
    local SceneManager = GameInstance:GetSceneManager()
    if SceneManager == nil then
        self:DebugPrint("UpdateIndicator: SceneManager 不存在")
        return
    end

    if self.GuideType == "Phantom" and self.Phantom then
        self:UpdatePhantomGuide()
        self:UpdatePhantomVisbility()
    end

    -- 获取 TargetPosition 并调整位置
    self:GetTargetPosition(SceneManager)
    self:AdjustTargetPosition()

    if not IsValid(self.TargetActor) and self.TargetPointPos == nil then
        self:Disappear()
        return
    end

    -- 获取 PlayerCharacter
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    if not IsValid(Player) or self.TargetPointPos == nil then
        self:DebugPrint("UpdateIndicator: Player 不存在")
        return
    end

    -- 获取 PlayerController
    local Controller = Player:GetController()

    -- 获取指引点是否在门上和门的位置
    
    local IsOnDoor = SceneManager:CaluCurGuideNeedShowPos(
        self.TargetEid, self.DoorPosition, self.DoorDirection)
    
    -- 如果在门上就设置状态并调整位置
    if IsOnDoor == true then
        self.State = self.States.OnDoor

        self:AssignVector(self.DoorPosition, self.TargetWorldLoc)
        self.TargetWorldLoc.Z = self.DoorPosition.Z + 150
    else
        self.State = self.States.OnActor
        self:AssignVector(self.TargetPointPos, self.TargetWorldLoc)
    end

    -- 是否从角色位置生成飞到目标位置
    if self.SpawnDown == false then
        self.SpawnDown = true

        -- 指引点当前位置设为角色位置
        if self.FlyToTarget == true then
            self:AssignVector(Player:K2_GetActorLocation(), self.CurrentWorldLoc)
        
        -- 指引点当前位置设为目标位置
        else self:AssignVector(self.TargetWorldLoc, self.CurrentWorldLoc) end
    end
    
    -- 计算视口的中心位置和限制范围的椭圆大小
    local ViewportSize = UIManager(self):GetViewportSize()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.CenterPos.X, self.CenterPos.Y  = ViewportSize.X * 0.5, ViewportSize.Y * 0.463
        self.OvalSize.X, self.OvalSize.Y = 0.6 * ViewportSize.X * 0.5, 0.55 * ViewportSize.Y * 0.5
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.CenterPos.X, self.CenterPos.Y  = ViewportSize.X * 0.5, ViewportSize.Y * 0.4723
        self.OvalSize.X, self.OvalSize.Y = 0.620 * ViewportSize.X * 0.5, 0.532 * ViewportSize.Y * 0.5
    end
    
    if not Controller:IsA(APlayerController) then
        return
    end

    -- 根据目标的世界坐标计算屏幕坐标（插值）
    local CurrentOffsetOnDoor, LocLerpFinished, IndicatorAngle, TargetDistance,
        CurrentDistance, IsOutElliptic, IsOutScreen =
        UUIFunctionLibrary.LerpAndProjectWorldToScreenInEllipse(

            Controller, self.TargetWorldLoc, self.CurrentWorldLoc, self.LocationLerpInterval,
            self.ScreenLocation, self.CenterPos, self.OvalSize, self.BoardSize, self.State == self.States.OnDoor,
            self.TargetOffsetOnDoor, self.CurrentOffsetOnDoor, self.OffsetLerpInterval, false, 0, 0, 0, false
        
        )
    self.IsOutScreen = IsOutScreen
    self.IsOutElliptic = IsOutElliptic
    self.CurrentOffsetOnDoor = CurrentOffsetOnDoor
    
    -- 等待指引点位置移动完成后隐藏
    if LocLerpFinished == true and self.TargetVisibilityOnDoor == false and self.CurrentVisbilityOnDoor == true then
        self.Guide_Node:SetVisibility(ESlateVisibility.Collapsed)
        self.CurrentVisbilityOnDoor = false
    end

    -- 是否使用实际 Actor 的距离
    if self.UseRealDistance then
        TargetDistance = UKismetMathLibrary.Vector_Distance(
            Player.CurrentLocation, self.TargetPointPos
        ) / 100.0
    end
    self.PointRealDistance = TargetDistance

    -- 设置指引点在屏幕边缘时隐藏数字显示箭头
    self:SetArrowAndNumVisiblity(IndicatorAngle)

    -- 把指引点的 UI 设置在屏幕坐标上
    local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Guide_Node)
    local ViewPortScale = UWidgetLayoutLibrary.GetViewportScale(self)
    self.CacheScreenPos:Set(self.ScreenLocation.X / ViewPortScale, self.ScreenLocation.Y / ViewPortScale)
    CanvasSlot:SetPosition(self.CacheScreenPos)
end

function Guide_Icon_Point_C:GetDistanceText()
    -- 小于 1m
    if self.PointRealDistance < 1 then
        return "<1"..self.DistanceUnit
    end

    -- 在 1-9999m 之间，拼接数值和单位
    if self.PointRealDistance <= 9999 then
        return tostring(math.ceil(self.PointRealDistance))..self.DistanceUnit
    end

    -- 大于 9999m
    return ">9999"..self.DistanceUnit
end

function Guide_Icon_Point_C:SetArrowAndNumVisiblity(IndicatorAngle)
    local StyleNodeName = self.ConfigData and self.ConfigData.GuideIconAni or ""
    -- 指引点在屏幕的边缘
    if self.RequireDirectionArrow and self.IsOutElliptic then
        
        -- 打开方向箭头的显示
        if self[StyleNodeName.."_Arrows"] ~= nil then
            self[StyleNodeName.."_Arrows"]:SetRenderTransformAngle(IndicatorAngle + 45)
            self[StyleNodeName.."_Arrows"]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Common_Arrows:SetRenderTransformAngle(IndicatorAngle + 45)
            self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end

    if self.GuideType == "Phantom" and self.Phantom then
        if self.TargetActor:IsDead() and self.PhantomGuideState == PhantomStateEnum.Dead then
            self.Panel_RemainTimes:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if self.TargetActor:IsInRecovering() and self.PhantomGuideState == PhantomStateEnum.Resurrecting then
            self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end


        -- 关闭距离数字的显示
        self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
    
    -- 指引点在屏幕内部
    else
        
        -- 关闭方向箭头的显示
        if self[StyleNodeName .. "_Arrows"] ~= nil then
            self[StyleNodeName .. "_Arrows"]:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.Common_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

        -- 打开距离数字的显示
        self.Text_Distance:SetText(self:GetDistanceText())
        self.Text_Distance:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

        if self.PointRealDistance <= 2 and self.GuideType == "Task" then
            self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

        if self.GuideType == "Phantom" and self.Phantom then
            if self.TargetActor:IsDead() and self.PhantomGuideState == PhantomStateEnum.Dead then
                self.Panel_RemainTimes:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            elseif  self.TargetActor:IsInRecovering() and self.PhantomGuideState == PhantomStateEnum.Resurrecting then
                self.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
end

return Guide_Icon_Point_C