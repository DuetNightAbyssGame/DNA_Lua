--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type LevelMap_Main_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")

function M:Construct()
    self.Super.Construct(self)
    self.AreaTable = {}
    self.ReturnHomePop = false
    self.ReturnHomeCondition = DataMgr.GlobalConstant.BackToHomeBaseCondition.ConstantValue
    self.ReturnHomeConditionRes = true
    -- self.TimeLineCondition = DataMgr.GlobalConstant.EXMapUnlockCondition.ConstantValue
    -- self.TimeLineConditionRes = true
    self.DeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"
    self.MapRegionType = "Now"
    self.bCanDragMap = false
    self.SliderPecent = GWorld.GameInstance.RegionMapScale or 0.5
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(UGameplayStatics.GetPlayerController(self, 0))
    self.CurrentMainRegionId = nil

    self:UpdateConditionRes()
    self.LevelMap_World:Init(self)
    self:InitWidgetVisibility()
    -- self:InitWildMap()
    self.Button_Area.OnClicked:Clear()
    self.Button_Area.OnClicked:Add(self, self.OnAreaClicked)
    self.Panel_Interactive:SetVisibility(ESlateVisibility.Collapsed)

    self.DispatchList = nil     --派遣列表
    self.DispatchDetail = nil --派遣详情弹窗
    self.DispatchItem = nil  --当前派遣实例
    self.DispatchId = -1      --当前派遣Id
    self.DispatchAgentList = nil    --派遣代理人列表

    -- self.Dispatch_List:ClearChildren()
    -- self.Dispatch_Detail:ClearChildren()
    ReddotManager.AddListener(DataMgr.ReddotNode.Dispatch.Name, self, self.OnReddotChange)
    
end

function M:Destruct()
    M.Super.Destruct(self)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    ReddotManager.RemoveListener(DataMgr.ReddotNode.Dispatch.Name, self)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:UpdateConditionRes()
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_open", "MapOpen", nil)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    local IsOpenMap, OpenRegionId, InitCompleteFunc, InitCompleteParam = ...
    self.IsOpenMap = IsOpenMap
    self.CurrentMainRegionId = OpenRegionId
    if InitCompleteFunc then
        self.InitCompleteFunc = type(InitCompleteFunc) == "function" and InitCompleteFunc or function()
            local FunctionName = "On"..InitCompleteFunc.."Click"
            if self.RealWildMap[FunctionName] then
                self.RealWildMap[FunctionName](self.RealWildMap, InitCompleteParam, true)
            end
            self.InitCompleteFunc = nil
        end
    end
    if not IsOpenMap then
        -- self.LevelMap_World:HideWorldMap() --@lhq 因为任务追踪和打开区域地图逻辑冲突，这里做一个播放融出动画临时解决办法
        self.AreaInfo:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self:InitCommonWidget()
end

function M:UpdateConditionRes()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        self.ReturnHomeConditionRes = ConditionUtils.CheckCondition(Avatar, self.ReturnHomeCondition)
        self.MapRegionType = "Now"
    end
end

function M:InitWidgetVisibility()
    -- self.Slider_Zoom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self:CheckToShowTimeLine(UE4.ESlateVisibility.Collapsed)
    self.Panel_UI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local Avatar = GWorld:GetAvatar()
    if not self.ReturnHomeConditionRes then
        self.Btn_ReturnHome:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Btn_ReturnHome:SetVisibility(ESlateVisibility.Visible)
    end
end

function M:InitBackToWorldMapGuidePoint(InRegionId)
    local QuestRegionMapId = nil
    local Info = TaskUtils:GetTrackingQuestDetailInfo()
    
    if Info and Info.SubRegionId and Info.SubRegionId > 0 then
        QuestRegionMapId = Info.SubRegionId
    else
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        local CurTrackingQuestChainId = Avatar.TrackingQuestChainId
        if CurTrackingQuestChainId == nil or CurTrackingQuestChainId == 0 then
            return false
        end
    
        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(CurTrackingQuestChainId, "Task")
        if IsEmptyTable(UIObjs) then
            return false
        end
    
        for _, v in pairs(UIObjs) do
            local TargetKey = v.GuideInfoCache.PointOrStaticCreatorName
            if TargetKey and GuidePointLocData[TargetKey] and GuidePointLocData[TargetKey].SubRegionId > 0 then
                QuestRegionMapId = GuidePointLocData[TargetKey].SubRegionId
            else
                ScreenPrint(string.format("CheckIsTrackingQuest: 指引点区域数据不存在, 任务区域信息获取失败，请检查导出数据, 指引点: %s", v:GetName()))
            end
            break
        end
    end
    

    -- local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
    -- if IconTexture then
    --     self.BackToWorldMap.GuidePoint.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
    -- end

    if not QuestRegionMapId or not DataMgr.SubRegion[QuestRegionMapId] or
    not DataMgr.SubRegion[QuestRegionMapId].RegionId 
    or not DataMgr.Region[DataMgr.SubRegion[QuestRegionMapId].RegionId]
    or not DataMgr.Region[DataMgr.SubRegion[QuestRegionMapId].RegionId].RegionMapId then
        return false
    end
    
    local IsInEXRegion = false
    local CurWorldMapIndex = 0
    local TaskMapIndex = 0

    local CurMapRegionMapId = DataMgr.Region[InRegionId].RegionMapId
    local TaskRegionMapId = DataMgr.Region[DataMgr.SubRegion[QuestRegionMapId].RegionId].RegionMapId

    for WorldMapId, Data in pairs(DataMgr.WorldMap) do
        for _, WorldMapRegion in pairs(Data.WorldMapRegion) do
            if WorldMapRegion == CurMapRegionMapId then
                CurWorldMapIndex = WorldMapId
                break
            end
        end
    end

    for WorldMapId, Data in pairs(DataMgr.WorldMap) do
        for _, WorldMapRegion in pairs(Data.WorldMapRegion) do
            if WorldMapRegion == TaskRegionMapId then
                TaskMapIndex = WorldMapId
                if Data.UIRegionType == "EX" then
                    IsInEXRegion = true
                end
                break
            end
        end
    end

    if IsInEXRegion then
        TaskUtils.TaskRegionMap = "EX"
    else
        TaskUtils.TaskRegionMap = "Now"
    end

    -- if QuestRegionMapId == Const.HomeBaseSubRegionId then --@lhq条件太多了, 我也不想这么写
    --     self.BackToWorldMap.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     return
    -- end

    -- if Info and Info.IsFairyLand then
    --     self.BackToWorldMap.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     return
    -- end

    -- if CurWorldMapIndex ~= TaskMapIndex and TaskUtils.TaskRegionMap == self.MapRegionType then
    --     self.BackToWorldMap.GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --     return
    -- end

    -- if CurWorldMapIndex ~= TaskMapIndex and TaskUtils.TaskRegionMap ~= self.MapRegionType then
    --     self.BackToWorldMap.GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --     return
    -- end

    -- if CurWorldMapIndex == TaskMapIndex and TaskUtils.TaskRegionMap == self.MapRegionType then
    --     self.BackToWorldMap.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     return
    -- end

    -- if CurWorldMapIndex == TaskMapIndex and TaskUtils.TaskRegionMap ~= self.MapRegionType then
    --     self.BackToWorldMap.GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --     return
    -- end
    
    -- self.BackToWorldMap.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

-- function M:InitTimeLineGuidePoint()
--     local Info = TaskUtils:GetTrackingQuestDetailInfo()
--     if Info and Info.IsFairyLand then
--         self.TimeLine.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         return
--     end

--     local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
--     if IconTexture then
--         self.TimeLine.GuidePoint.Img_GuidePoint_Icon:SetBrushResourceObject(IconTexture)
--     end
    
--     if self.BackToWorldMap.GuidePoint.Visibility == UE4.ESlateVisibility.SelfHitTestInvisible then
--         self.TimeLine.GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     else
--         self.TimeLine.GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
-- end

function M:InitCommonWidget()
    self.Tab:Init({
        PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self),
        LeftKey = "Q",
        RightKey = "E",
        LeftGamePadKey = "LeftShoulder",
        RightGamePadKey = "RightShoulder",
        ChildWidgetName = "MapTabSubItem",
        Tabs = {
            [1] = {
                Text = GText("UI_Map_Title_World"),
                TabId = 1,
            },
            [2] = {
                Text = GText("UI_Map_Title_Region"),
                TabId = 2,
                IsLast = true
            }
        },
        SoundFunc = self.OnClickTabSound,
        SoundFuncReceiver = self
    })
    self.TabBack.Btn_Back.OnClicked:Add(self, self.OnReturnKeyDown)
    self.WildMapGamePadKeys = {
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A"
                }
            },
            Desc = GText("UI_RegionMap_AddMark"),
        },
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS"
                }
            },
            Desc = GText("UI_RegionMap_GotoPosition"),
        },
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_BACK"),
        },
    }
    self.WildMapGamePadEnsureKeys = {
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A"
                }
            },
            Desc = GText("UI_Tips_Ensure"),
        },
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS"
                }
            },
            Desc = GText("UI_RegionMap_GotoPosition"),
        },
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_BACK"),
        },
    }
    self.WildMapKeys = {
        {
            KeyInfoList={
                {
                    Type = "Text",
                    ImgShortPath = "Mouse_Button"
                }
            },
            Desc = GText("UI_RegionMap_Scale"),
        },
        {
            KeyInfoList={
                {
                    Type = "Text",
                    ImgShortPath = "LeftMouseButton"
                }
            },
            Desc = GText("UI_RegionMap_AddMark"),
        },
        {
            KeyInfoList={
                {
                    Type = "Text",
                    Text = "V",
                    Owner = self,
                    ClickCallback = self.OnGotoPositionKeyDown,
                }
            },
            Desc = GText("UI_RegionMap_GotoPosition"),
        },
        {
            KeyInfoList={
                {
                    Type = "Text",
                    Text = "Esc",
                    Owner = self,
                    ClickCallback = self.OnUIReturnKeyDown,
                }
            },
            Desc = GText("UI_BACK"),
        },
    }
    self.BackKey = {
        {
            KeyInfoList={
                {
                    Type = "Text",
                    Text = "Esc",
                    Owner = self,
                    ClickCallback = self.OnUIReturnKeyDown,
                }
            },
            Desc = GText("UI_BACK"),
        },
    }
    self.BackGamePadKey = {
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_BACK"),
        },
    }
         
    if self.DeviceInPc then
        self:InitBottomTab()
    end
    self.Tab:BindEventOnTabSelected(self, self.OnTabItemClick)
    self.Tab:SelectTab(2)

    local ConfigData = {
        InitValue = self.SliderPecent * 100,
        ClickInterval = 10,
        MinValue = 0,
        MaxValue = 100,
        OwnerPanel = self,
        AddBtnCallback = self.OnClickSliderAddorMinus,
        MinusBtnCallback = self.OnClickSliderAddorMinus,
        SliderChangeCallback = self.OnPlayerChangeSlider,
        PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self),
        ForbidGamePadLTRTKey = true,
    }
    self.Slider_Zoom:Init(ConfigData)

    if self.DeviceInPc then
        self.Btn_ReturnHome.Switch_Type:SetActiveWidgetIndex(0)
        self.Btn_ReturnHome.Key:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = "H"
                }
            }
        })
    else
        self.Btn_ReturnHome.Switch_Type:SetActiveWidgetIndex(1)
    end
    self.Btn_ReturnHome.Text_Return:SetText(GText("UI_WORLDMAP_RETURNHOMEBASE"))
    self.Btn_ReturnHome.Btn_Back.OnClicked:Add(self, self.OnReturnHomeKeyDown)
    self.Btn_ReturnHome.Btn_Back.OnPressed:Add(self, self.OnReturnHomePress)
    self.Btn_ReturnHome.Btn_Back.OnHovered:Add(self, self.OnReturnHomeHover)
    self.Btn_ReturnHome.Btn_Back.OnUnhovered:Add(self, self.OnReturnHomeUnhover)
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Normal)

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local TrackingId = Avatar.TrackingQuestChainId
        local IconObj = TaskUtils:GetIconTextureByQuestChainType(TrackingId)
        if IconObj then
            self.Btn_ReturnHome.GuidePoint.Img_GuidePoint_Icon:SetBrushResourceObject(IconObj)
        end

        if Avatar.QuestChains[TrackingId] then
            local DoingQuestId = Avatar.QuestChains[TrackingId].DoingQuestId
            if MissionIndicatorManager:GetTargetTaskSubRegionId(TrackingId, DoingQuestId) == Const.HomeBaseSubRegionId then
                self.Btn_ReturnHome.GuidePoint:SetVisibility(ESlateVisibility.SelfHitTestInvisible) 
            else
                self.Btn_ReturnHome.GuidePoint:SetVisibility(ESlateVisibility.Collapsed) 
            end
        else
            self.Btn_ReturnHome.GuidePoint:SetVisibility(ESlateVisibility.Collapsed) 
        end
    end

    --派遣
    self.Entrance_Dispatch.Btn_Click.OnClicked:Add(self, self.OnClickDispatch)
    self.Entrance_Dispatch.Text_Name:SetText(GText("UI_Disptach_Title"))
end

function M:InitBottomTab()
    if self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then
        return
    end
    self.Key_Tip.Panel_Key:ClearChildren()
    self.Key_Esc = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
    self.Key_Tip.Panel_Key:AddChild(self.Key_Esc)
    self.Key_Esc:CreateCommonKey({
        KeyInfoList={
            {
                Type="Text",
                Text="Esc",
                Owner = self,
                ClickCallback = self.OnUIReturnKeyDown,
            }
        },
        Desc = GText("UI_BACK"),
    })
end

function M:InitWildMap()
    self.LevelMap_World:HideWorldMap()
    local WildMap = self:LoadOrUnLoadWildMap(true, false)
    local Avatar = GWorld:GetAvatar()
    local RegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
    local RealRegionId = nil
    if DataMgr.Region[RegionId].RegionMapId then
        RealRegionId = DataMgr.RegionMap[DataMgr.Region[RegionId].RegionMapId].RegionId
    end
    if RealRegionId then
        self.Slider_Zoom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Slider_Zoom:SetVisibility(ESlateVisibility.Collapsed)
    end
    WildMap.OriginalRegionId = RealRegionId
    WildMap:Init(false, RealRegionId, self)
    WildMap:OnScaleChange(self.SliderPecent)
end

function M:InitWildMapWithoutShow()
    local RegionMapPath = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Region.WBP_Map_Region_C"
    -- self.BackToWorldMap:SetVisibility(ESlateVisibility.Collapsed)
    self.Slider_Zoom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- self:CheckToShowTimeLine(ESlateVisibility.Collapsed)

    local WildMap = self:RealLoadOrUnLoad("RealWildMap", RegionMapPath, self.WildMap, true, self)
    self["RealWildMap"]:SetVisibility(UE4.ESlateVisibility.Collapsed)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local RegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
    local RegionMapId = DataMgr.Region[RegionId].RegionMapId
    WildMap:Init(false, DataMgr.RegionMap[RegionMapId].RegionId, self)
    WildMap:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- WildMap.MainMap.BackToWorldMap:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.AreaInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnTabItemClick(TabWidget)
    local TabId = TabWidget.Idx
    self.CurTabId = TabId
    if self.CurTabId == 1 then
        -- self.LevelMap_World:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:OnOpenWorldMap()
        self:UpdateWorldMapKeys()
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
        self.LevelMap_World.GamepadSelect:SetFocus()
        self.LevelMap_World.HoverBtnIdx = 0
        self.LevelMap_World.Select:StopAnimation(self.LevelMap_World.Select.Hover)
        self.LevelMap_World.Select:PlayAnimation(self.LevelMap_World.Select.Normal)
        if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            self.LevelMap_World.bCanDragMap = true
        end
        self.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        self.FloorWidget.Key_Controller_Up:SetVisibility(ESlateVisibility.Collapsed)
        self.FloorWidget.Key_Controller_Down:SetVisibility(ESlateVisibility.Collapsed)
        if self.Btn_Location then
            self.Btn_Location:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Slider_Zoom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.LevelMap_World:ResetTranslation()
    else
        local Avatar = GWorld:GetAvatar()
        local RegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
        local RealRegionId = self.CurrentMainRegionId
        if not RealRegionId and DataMgr.Region[RegionId].RegionMapId then
            RealRegionId = DataMgr.RegionMap[DataMgr.Region[RegionId].RegionMapId].RegionId
        end
        if RealRegionId and RealRegionId ~= 0 then
            self.Slider_Zoom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Slider_Zoom:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.FloorWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.Btn_Location then
            self.Btn_Location:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        self.WildMapKeysShow = true
        local WildMap = self:LoadOrUnLoadWildMap(true)
        if not self.IsOpenMap then--改异步以后，让任务自己去加载地图，不自动初始化
            WildMap.OriginalRegionId = RealRegionId
            WildMap.NormalInit = self.InitCompleteFunc == nil
            WildMap:Init(false, RealRegionId, self, function()
                WildMap:ShowMissionIndicatorsInRegionMap()
                WildMap:SetFocus()
                if self.InitCompleteFunc then
                    self.InitCompleteFunc()
                end
                self.InitCompleteFunc = nil
                WildMap:OnScaleChange(self.SliderPecent)
            end)
        else
            WildMap.MainMap = self
            WildMap.NormalInit = false
        end
        self.IsOpenMap = false
        self:UpdateWildMapKeys()
        self.AreaInfo:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        -- self.LevelMap_World:OnClickArea(self.LevelMap_World.AreaNameList[1].MapDataId)
    end
end

function M:UpdateWildMapKeys()
    if not self.DeviceInPc or not self.RealWildMap then
        return 
    end
    if self.RealWildMap.IsOpenDispatch == true then
        return
    end
    if self.WildMapKeysShow then
        if self.ReturnHomeConditionRes then
            self.Btn_ReturnHome:SetVisibility(ESlateVisibility.Visible)
        end
    else
        self.Btn_ReturnHome:SetVisibility(ESlateVisibility.Collapsed)
    end
    -- 判断任务详情界面WBP_Map_Task是否可见，若可见，Key_Tip的显示由LevelMap_Task_Widget_PC_C控制
    local MapTipsWidgetVisible = self.RealWildMap.MapTipsWidget and self.RealWildMap.MapTipsWidget:IsVisible()
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
        if not MapTipsWidgetVisible then
            self.Key_Tip:UpdateKeyInfo((self:IsInteractiveOpen() or not self.WildMapKeysShow) and self.BackGamePadKey or self.WildMapGamePadKeys)
        end
        self.Entrance_Dispatch.WS_Type:SetActiveWidgetIndex(1)
        self.Entrance_Dispatch.Icon_Key:CreateGamepadKey("X")
        self.Btn_ReturnHome.Switch_Type:SetActiveWidgetIndex(2)
        self.Btn_ReturnHome.Key_Controller:CreateGamepadKey(UIConst.GamePadImgKey.RightThumb)
    else
        -- if not MapTipsWidgetVisible or self.IsPanelOpen then
        self.Key_Tip:UpdateKeyInfo((self:IsInteractiveOpen() or not self.WildMapKeysShow) and self.BackKey or self.WildMapKeys)
        -- end
        self.Entrance_Dispatch.WS_Type:SetActiveWidgetIndex(0)
        self.Btn_ReturnHome.Switch_Type:SetActiveWidgetIndex(0)
        self.Entrance_Dispatch.Key:CreateCommonKey({
            KeyInfoList = {
            {
                Type="Text", 
                Text="L",
            }
            }
        })
    end

    if self.IsPanelOpen or self.RealWildMap.IsEmpty then
        self.Slider_Zoom:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Slider_Zoom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:UpdateWorldMapKeys()
    if not self.DeviceInPc then
        return 
    end
    local Keys = {
        {
            KeyInfoList={
                {
                    Type="Text",
                    Text="Esc",
                    Owner = self,
                    ClickCallback = self.OnUIReturnKeyDown,
                }
            },
            Desc = GText("UI_BACK"),
        }
    }

    local GamepadKeys = {
        {
            KeyInfoList={
                {
                    Type="Img",
                    ImgShortPath="B"
                }
            },
            Desc = GText("UI_BACK"),
        }
    }
    
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then 
        self.Key_Tip:UpdateKeyInfo(GamepadKeys)
    else
        self.Key_Tip:UpdateKeyInfo(Keys)
    end
end

-- function M:CheckToShowTimeLine(NewSlate)
--     if NewSlate == ESlateVisibility.Collapsed or NewSlate == ESlateVisibility.Hidden then
--         self.TimeLine:SetVisibility(NewSlate)
--         return
--     end
--     if self.TimeLineCondition and not self.TimeLineConditionRes then
--         self.TimeLine:SetVisibility(ESlateVisibility.Hidden)
--     else
--         self.TimeLine:SetVisibility(ESlateVisibility.Visible)
--     end
-- end

-----------------------------------ReturnHome-----------------------------------------
function M:OnReturnKeyDown()
    self:PlayOutAnim()
end

function M:OnUIReturnKeyDown()
    if(self.DispatchAgentList ~= nil) then
        self.DispatchAgentList:OnClickClose()
        self.DispatchAgentList = nil
        return
    end
    if (self.DispatchList ~= nil and self.DispatchDetail ~= nil) or (self.DispatchList ~= nil) then
        if self.DispatchList then
            self.DispatchList:Close()             
        end
        self.Dispatch = nil
        self.DispatchList = nil
        return
    end
    if self.RealWildMap and not self.RealWildMap.IsEmpty and self.RealWildMap:ClosePanel() then
        return
    end
    if self:IsInteractiveOpen() then
        self:OnAreaClicked()
        self.RealWildMap:SetFocus()
        return
    end
    self:OnReturnKeyDown()
end

function M:OnGotoPositionKeyDown()
    self.RealWildMap:OpenOptionSelect()
end

function M:OnReturnHomeKeyDown()
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Normal)
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Click)
    local Params = {}
    Params.LeftCallbackFunction = function(Data) 
        self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Normal)
        self.ReturnHomePop = false
    end
    Params.RightCallbackFunction = function(Data) 
        self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Normal)
        self:ReturnHome()
    end
    Params.CloseBtnCallbackFunction = function(Data) 
        self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Normal)
        self.ReturnHomePop = false
    end
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    self.ReturnHomePop = UIManager:ShowCommonPopupUI(100037, Params, self)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
end

function M:ReturnHome()
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    if GameMode:HandleLevelDeliver(1, 210101, 1) then
        self:PlayOutAnim()
    end
end

function M:OnReturnHomePress()
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Normal)
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Press)
end
function M:OnReturnHomeHover()
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Normal)
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Hover)
end
function M:OnReturnHomeUnhover()
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.Normal)
    self.Btn_ReturnHome:PlayAnimation(self.Btn_ReturnHome.UnHover)
end

function M:OnOpenWorldMap()
    self.RealWildMap:Close()
    self:LoadOrUnLoadWildMap(false, true)
    self.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnClickTabSound()
    print(_G.LogTag,"LXZ OnClickTabSound")
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

-----------------------------------ReturnHome-----------------------------------------

function M:PlayOutAnim()
    if self:IsAnimationPlaying(self.Auto_In) or self:IsAnimationPlaying(self.Auto_Out) then
        return
    end
    if self.RealWildMap then
        self.RealWildMap:PlayCloseAnimation()
        GWorld.GameInstance.RegionMapScale = self.SliderPecent
    end
    AudioManager(self):SetEventSoundParam(self, "MapOpen", {ToEnd = 1})
    self.LevelMap_World:HideWorldMap()
    self:Close()
end

function M:RealClose()
    if self.DispatchList then
        self.DispatchList:RealClose()
    end
    if self.DispatchDetail then
        self.DispatchDetail:RealClose()
    end
    if self.DispatchAgentList then
        self.DispatchAgentList:OnClose()
    end
    if self.RealWildMap then
        self.RealWildMap:Close()
    end
   
    self:LoadOrUnLoadWildMap(false, false)
    M.Super.RealClose(self)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    print(_G.LogTag,"LXZ OnKeyDown", InKeyName)
    local OpenMapKey = CommonUtils:GetActionMappingKeyName("OpenMap")
    if (InKeyName == "Escape") or InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if(self.DispatchAgentList ~= nil) then
            self.DispatchAgentList:OnClickClose()
            self.DispatchAgentList = nil
            return UWidgetBlueprintLibrary.Handled()
        end
        if (self.DispatchList ~= nil and self.DispatchDetail ~= nil) or (self.DispatchList ~= nil) then 
            if self.DispatchList then
                self.DispatchList:Close() 
            end
            self.Dispatch = nil
            self.DispatchList = nil
            return UWidgetBlueprintLibrary.Handled()
        end
        if (self.DispatchList == nil and self.DispatchDetail ~= nil and self.DispatchAgentList == nil) then
            self.RealWildMap:ClosePanel()
            return UWidgetBlueprintLibrary.Handled()
        end
        if self:IsInteractiveOpen() then
            self:OnAreaClicked()
            self.RealWildMap:SetFocus()
            return UWidgetBlueprintLibrary.Handled()
        end
        if self.RealWildMap and self.RealWildMap.MapTipsWidget and self.RealWildMap.MapTipsWidget:GetVisibility()==ESlateVisibility.SelfHitTestInvisible then
            self.RealWildMap:ClosePanel()
            self.RealWildMap:SetFocus()
            return UWidgetBlueprintLibrary.Handled()
        end
        if self.RealWildMap and self.RealWildMap.ChanllengeTips and self.RealWildMap.ChanllengeTips:IsVisible() then
            self.RealWildMap:ClosePanel()
            return UWidgetBlueprintLibrary.Handled()
        end

        self:OnReturnKeyDown()
        return UWidgetBlueprintLibrary.Handled()
    elseif(InKeyName == OpenMapKey and self.bIsCanCloseByHotKey) then
        self:PlayOutAnim()
        return UWidgetBlueprintLibrary.Handled()
    elseif(InKeyName == "H" or InKeyName == UIConst.GamePadKey.RightThumb) and self.ReturnHomeConditionRes then
        self:OnReturnHomeKeyDown()
        return UWidgetBlueprintLibrary.Handled()
    else
        if self.DeviceInPc then
            if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
                self.Tab:Handle_KeyEventOnGamePad(InKeyName)
            else
                self.Tab:Handle_KeyEventOnPC(InKeyName)
            end
        end
        return UWidgetBlueprintLibrary.Unhandled()
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.CurTabId == 1 then
        DebugPrint("jly OnPreviewKeyDown", InKeyName)
        return self.LevelMap_World:Handle_KeyEventOnGamePad(InKeyName)
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseWheelTurned(Percent)
    if self.RealWildMap then
        self.SliderPecent = Percent
    end
    self.Slider_Zoom:OnSliderValueChanged(Percent)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_process_bar_drag", nil, nil)
end

function M:OnClickSliderAddorMinus(CurrentCount, OldNumberValue)
    -- local Percent = self.Slider_Zoom.Slider_Zoom:GetValue()
    self.SliderPecent = CurrentCount / 100
    if self.RealWildMap then
        self.RealWildMap:OnScaleChange(self.SliderPecent)
        AudioManager(self):PlayUISound(self, "event:/ui/common/map_process_bar_drag", nil, nil)
    end
end

function M:OnPlayerChangeSlider(Value)
    -- local Percent = self.Slider_Zoom.Slider_Zoom:GetValue()
    self.SliderPecent = Value/100
    if self.RealWildMap then
        self.RealWildMap:OnScaleChange(self.SliderPecent)
        AudioManager(self):PlayUISound(self, "event:/ui/common/map_process_bar_drag", nil, nil)
    end
end
-----------------------------------------动态载入相关------------------------------------------

function M:GetMainRegionId()
    
end

function M:LoadOrUnLoadWildMap(bLoad, bShowWorldMap)
    --创建或删除野外地图
    local RegionMapPath = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Region.WBP_Map_Region_C"
    if bLoad then
        -- self.BackToWorldMap:SetVisibility(ESlateVisibility.Visible)
        self.Slider_Zoom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.ReturnHomeConditionRes then
            self.Btn_ReturnHome:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self.LevelMap_World:HideWorldMap()
        -- self:CheckToShowTimeLine(ESlateVisibility.Collapsed)
        AudioManager(self):PlayUISound(self, "event:/ui/common/map_switch_to_level", "", nil)
    else
        self.Slider_Zoom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_ReturnHome:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if bShowWorldMap then
            self.LevelMap_World:ShowWorldMap()
        end
        self.CurrentMainRegionId = nil
        -- self:CheckToShowTimeLine(ESlateVisibility.Visible)
        AudioManager(self):PlayUISound(self, "event:/ui/common/map_switch_to_chapter", "", nil)
    end

    return self:RealLoadOrUnLoad("RealWildMap", RegionMapPath, self.WildMap, bLoad, self)
end

function M:RealLoadOrUnLoad(WidgetName, Path, Parent, bLoad, Root)
    self.HasOpenWildMap = bLoad
    if Root[WidgetName] and bLoad == false then
        -- self.Tab:UpdateTopTitle(GText("UI_Map_Title_World"))
        Root[WidgetName]:RemoveFromParent()
        Root[WidgetName] = nil
        return Root[WidgetName]
    end

    if not Root[WidgetName] and bLoad == true then
        -- self.Tab:UpdateTopTitle(GText("UI_Map_Title_Region"))
        Root[WidgetName] = self:LoadTempWidget(Path, Parent, Root)
        Root[WidgetName].RootPage = Root
        return Root[WidgetName]
    end

    if Root[WidgetName] and bLoad == true then
        Root[WidgetName]:RemoveFromParent()
        Root[WidgetName] = self:LoadTempWidget(Path, Parent, Root)
        Root[WidgetName].RootPage = Root
        return Root[WidgetName]
    end
end

--动态载入一个临时UI
function M:LoadTempWidget(Path, Parent, Root)
    local TempWidget = self:CreateWidgetToParent(Parent, Path, false)
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(TempWidget)
    if CanvasSlot then
        Root:SetWidgetOffset(CanvasSlot, 0, 0, 0, 0)
        Root:SetWidgetAnchors(CanvasSlot, FVector2D(0,0), FVector2D(1,1))
    end
    TempWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    return TempWidget
end

function M:CreateWidgetToParent(Parent, Path, NeedShowInWindow, ZOrder)
    local Widget = UIManager(Parent):CreateWidget(Path, NeedShowInWindow, ZOrder)
    Parent:AddChild(Widget)
    return Widget
end

function M:HideWildMapByNotInRegion()
    -- self.BackToWorldMap:SetVisibility(ESlateVisibility.Collapsed)
    self.Slider_Zoom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self:CheckToShowTimeLine(ESlateVisibility.Visible)

    local RegionMapPath = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Region.WBP_Map_Region_C"
    local WildMap = self:RealLoadOrUnLoad("RealWildMap", RegionMapPath, self.WildMap, true, self)
    self["RealWildMap"]:SetVisibility(UE4.ESlateVisibility.Collapsed)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local RegionId = DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId
    local RegionMapId = DataMgr.Region[RegionId].RegionMapId
    WildMap:Init(false, DataMgr.RegionMap[RegionMapId].RegionId, self)
    WildMap:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.RealWildMap:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self.RealWildMap.MainMap.BackToWorldMap:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.AreaInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OpenSelectList(SelectTable)
    if self.ScrollBox_Interactive:GetChildrenCount() > 0 then
        return
    end
    self.Panel_Interactive:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.ScrollBox_Interactive:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Interactive_Locate:SetVisibility(ESlateVisibility.Collapsed)
    -- local anchors=self.Overlay_Interactive.Slot:GetAnchors()
    -- anchors.Minimum=UKismetMathLibrary.Vector2D_Zero()
    -- anchors.Maximum=UKismetMathLibrary.Vector2D_Zero()
    -- self.Overlay_Interactive.Slot:SetAnchors(anchors)
    -- self.Overlay_Interactive.Slot:SetAlignment(UKismetMathLibrary.Vector2D_Zero())
    self:AddTimer(0.001,function()
	local ItemSize=FVector2D(612,60)--先直接按蓝图写死
    local AbsolutePosition = UUIFunctionLibrary.GetGeometryAbsolutePosition(SelectTable[1]:GetCachedGeometry())
    local LocalPosition = USlateBlueprintLibrary.AbsoluteToLocal(self.Panel_Interactive:GetCachedGeometry(),AbsolutePosition)
    -- LocalPosition:Set(LocalPosition.X+SelectTable[1]:GetDesiredSize().X,LocalPosition.Y)
    local MaxSize = self.RealWildMap.ScreenSize*2 - self.RealWildMap.BgHeight
    local Alignment =self.Overlay_Interactive.Slot:GetAlignment()
    if LocalPosition.Y + #SelectTable*ItemSize.Y >= MaxSize.Y then
        Alignment:Set(0,1)
    else
        Alignment:Set(0,0)
    end
    if LocalPosition.X + SelectTable[1]:GetDesiredSize().X + ItemSize.X > MaxSize.X then
        Alignment:Set(1,Alignment.Y)
    else
        LocalPosition:Set(LocalPosition.X+SelectTable[1]:GetDesiredSize().X,LocalPosition.Y)
        Alignment:Set(0,Alignment.Y)
    end
    self.Overlay_Interactive.Slot:SetAlignment(Alignment)
    self.Overlay_Interactive:SetRenderTranslation(LocalPosition)
    end)
    -- if #SelectTable > 1 then
    --     self.Img_Mouse:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- else
        self.Img_Mouse:SetVisibility(ESlateVisibility.Collapsed)
    -- end
    for i = 1, #SelectTable do 
        local Item = UIManager(self):_CreateWidgetNew("RegionMapSelectItem")
        self.ScrollBox_Interactive:AddChild(Item)
        Item:Init(SelectTable[i],self)
        if i == 1 then
            Item:SetFocus()
        end
    end
    self:UpdateWildMapKeys()
end

function M:OpenOptionSelect()
    self.Panel_Interactive:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.ScrollBox_Interactive:SetVisibility(ESlateVisibility.Collapsed)
    self.Interactive_Locate:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Interactive_Locate.Wbox:GetChildAt(0):SetFocus()
    for _,Child in pairs(self.Interactive_Locate.Wbox:GetAllChildren():ToTable()) do 
        Child:PlayAnimation(Child.In)
    end
    self:UpdateWildMapKeys()
end

function M:OnAreaClicked()
    if self:IsInteractiveOpen() and not self.AreaClicked then
        self.AreaClicked = true
        for _,Child in pairs(self.ScrollBox_Interactive:GetAllChildren():ToTable()) do
            Child:PlayAnimation(Child.Out)
        end
        for _,Child in pairs(self.Interactive_Locate.Wbox:GetAllChildren():ToTable()) do 
            Child:PlayAnimation(Child.Out)
        end
        self.RealWildMap:ClosePanel(false)
        self:AddTimer(0.2,function()
            self.AreaClicked = false
            self.ScrollBox_Interactive:ClearChildren()
            self.Panel_Interactive:SetVisibility(ESlateVisibility.Collapsed)
            -- self.RealWildMap:SetFocus()
            self:UpdateWildMapKeys()
        end)
    end
end

function M:IsInteractiveOpen()
    return self.Panel_Interactive:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
end

-------------------派遣界面相关------------------

--点击派遣按钮
function M:OnClickDispatch()
    DebugPrint("OnClickDispatch")
    self.RealWildMap.IsOpenDispatch = true
    self.RealWildMap:ClosePanel(true)
    self.RealWildMap:CloseForDispatch(true)
    self.RealWildMap:OnPanelOpen(5)
    self.Panel_UI:SetVisibility(ESlateVisibility.Collapsed)
    self:ShoworHideTopTab(false)
    self.DispatchList = self:CreateWidgetNew("DispatchList")
    if self.DispatchList == nil then
         return
    end
    self.Dispatch_List:AddChild(self.DispatchList)
    self.DispatchList:InitDispatch(self)
end

--关闭派遣界面
function M:OnCloseDispatch()
    DebugPrint("OnCloseDispatch")
    self.RealWildMap.IsOpenDispatch = false
    self.RealWildMap:ClosePanel(false)
    self.RealWildMap:CloseForDispatch(false)
    self.Panel_UI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:ShoworHideTopTab(true)
    if(self.DispatchDetail ~= nil) then
        self.DispatchDetail:Close()
    end
    self.DispatchDetail = nil
    self.DispatchList = nil
    self.Dispatch = nil
    self.RealWildMap:BackToOriginalRegion()
    self:InitBottomTab()
end

--打开代理人列表
function M:OpenAgentList()
    if self.DispatchList ~= nil then
        self.DispatchList:SetVisibility(ESlateVisibility.Collapsed)
    end

    self.RealWildMap.IsOpenDispatch = true
    self.RealWildMap:CloseForDispatch(true)
    if self.DispatchAgentList == nil then
        self.DispatchAgentList = self:CreateWidgetNew("DispatchAgentList")
        self.Dispatch_AgentList:AddChild(self.DispatchAgentList)
        self.DispatchAgentList:InitAgentList(self)
    else
        self.DispatchAgentList:Refresh()
    end
end

--创建刷新派遣详情
function M:CreateOrRefreshDispatchDetail(Dispatch)    
    if self.DispatchDetail == nil then
        self.DispatchDetail = self:CreateWidgetNew("DispatchDetail")
        self.Dispatch_Detail:AddChild(self.DispatchDetail)
        self.DispatchDetail.Owner = self
        self.DispatchDetail:InitDispatchDetail(Dispatch)
    else
        self.DispatchDetail:RrefreshDispatchDetail(Dispatch)
    end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local OpenMapKey = CommonUtils:GetActionMappingKeyName("OpenMap")
    if InKeyName == OpenMapKey then
        self.bIsCanCloseByHotKey = true
    end
    return UWidgetBlueprintLibrary.Unhandled()
end


function M:OnReddotChange()
    local RedNode = ReddotManager.GetTreeNode(DataMgr.ReddotNode.Dispatch.Name)
    if RedNode.Count > 0 then
        self.Entrance_Dispatch.Reddot:SetVisibility(ESlateVisibility.Visible)
    else
        self.Entrance_Dispatch.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    end
end


function M:InitPadTab()   
    -- self.Tab:UpdateBottomKeyInfo({{ 
    --             GamePadInfoList =  {{
    --                 Type="Img", 
    --                 ImgShortPath="RS", 
    --                 Owner=self
    --             }},
    --             Desc = GText("UI_Controller_CheckReward"), 
    --             bLongPress = false,
    --         },
    --         { 
    --             GamePadInfoList =  {{
    --                 Type="Img", 
    --                 ImgShortPath="A", 
    --                 Owner=self
    --             }},
    --             Desc = GText("PROLOGUE_SELECTGUN_TIP_4"), 
    --             bLongPress = false,
    --         },
    --         { 
    --             GamePadInfoList =  {{
    --                 Type="Img", 
    --                 ImgShortPath="B", 
    --                 ClickCallback=self.OnReturnKeyDown, 
    --                 Owner=self, 
    --             }},
    --             Desc = GText("UI_BACK"), 
    --             bLongPress = false
    --         }})
end

function M:ShoworHideTopTab(bShow)
    -- if not self.DeviceInPc then
    --     return
    -- end
    if bShow then
        self.Tab_Top:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Tab_Top:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:ShoworHideBottomTab(bShow)
    if not self.DeviceInPc then
        return
    end
    if bShow then
        self.Tab_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Tab_Bottom:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if self.LastInputDevice == CurInputDevice then
        return
    end
    self.LastInputDevice = CurInputDevice
    if self.CurTabId == 1 then
        self:UpdateWorldMapKeys()
        self.LevelMap_World.GamepadSelect:SetFocus()
        self.FloorWidget.Key_Controller_Up:SetVisibility(ESlateVisibility.Collapsed)
        self.FloorWidget.Key_Controller_Down:SetVisibility(ESlateVisibility.Collapsed)
    else
        self:UpdateWildMapKeys()
        if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
            if self:IsInteractiveOpen() then
                if self.Interactive_Locate:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
                    self.Interactive_Locate.Wbox:GetChildAt(0):SetFocus()
                elseif self.ScrollBox_Interactive:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
                    self.ScrollBox_Interactive:GetChildAt(0):SetFocus()
                end
            elseif self.RealWildMap then
                if self.RealWildMap.IsOpenDispatch == true then
                    if self.DispatchAgentList ~= nil then
                        self.DispatchAgentList.List_Agent:SetFocus()
                    end
                    if self.DispatchList ~= nil then
                        self.DispatchList:SetFocus()
                    end
                else
                    if self.DispatchDetail then
                        self.DispatchDetail:SetFocus()
                    elseif not self.RealWildMap.LastPanelId then
                        self.RealWildMap:SetFocus()
                    end 
                end
            end
        else
            local TopUI = UIManager(self):GetLastestAndFocusableUIWidgetObj()
            TopUI:SetFocus()
        end
    end
end

--确保每个子界面都有自己的默认SetFocus，不走UIState的SetFocus
function M:SetFocus_Lua()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.DispatchAgentList == nil and self.DispatchList == nil and self.DispatchDetail then
        self.DispatchDetail:SetFocus()
        return UWidgetBlueprintLibrary.Handle
    elseif self.DispatchAgentList then
        self.DispatchAgentList.List_Agent:SetFocus()
        return UWidgetBlueprintLibrary.Handle
    elseif self.DispatchList then
        self.DispatchList:SetFocus()
        return UWidgetBlueprintLibrary.Handle
    end
    if self.CurTabId == 2 then
        self.RealWildMap:SetFocus()
        return UWidgetBlueprintLibrary.Handle
    end
    return UWidgetBlueprintLibrary.Unhandle
end

-- 世界地图临时导航，特供cbt3使用，暂时写死
-- 待世界地图重新支持拖动时需重做

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    if self.CurTabId == 1 then
        return self.LevelMap_World:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:GetRegionMapBlock()
    if self.RealWildMap then
        return self.RealWildMap:GetRegionMapBlock()
    end
    return ''
end

function M:SetRegionMapBlock(Block)
    if self.RealWildMap then
        self.RealWildMap:SetRegionMapBlock(Block)
    end
end

return M
