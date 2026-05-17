--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_TaskSubItem_C
local WBP_TaskSubItem_C = Class("BluePrints.UI.BP_UIState_C")
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local GuidePointLocData = require ("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local EMCache = require "EMCache.EMCache"

local QuestRealStateEnum = {
    Lock = 0, -- 0 锁定
    Doing = 1, -- 1 进行中限时
    Finished = 2, -- 2 已完成
    InProgress = -1 -- -1 进行中不限时 (@lhq 2024.1.15暂时废弃)
}

local QuestChainTypeEnum = {
    Main = 1,
    Normal = 2,
    Side = 3,
}

function WBP_TaskSubItem_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.Index = nil --
    self.State = nil -- GroupSwitcher状态 0-锁定 1-限时 2-已完成 -1 进行中不限时
    self.QuestName = nil
    self.QuestPosition = nil
    self.OwnerWidget = nil
    self.MainWidget = nil -- 最顶层的widget，目前是owner widget的owner
    self.QuestID = nil
    self.IsExpansion = false -- false表示收起 true表示展开
    self.IsDoingQuest = false
end

function WBP_TaskSubItem_C:OnAnimationStarted(Anim)
    if Anim == self.Text_Normal then
        self.Text_TaskName:SetColorAndOpacity(self.Text_TaskName_NormalColor)
        self.Text_TaskPosition:SetColorAndOpacity(self.Text_TaskPos_NormalColor)
    elseif Anim == self.Text_Select then
        self.Text_TaskName:SetColorAndOpacity(self.Text_TaskName_SelectColor)
        self.Text_TaskPosition:SetColorAndOpacity(self.Text_TaskPos_SelectColor)
    end
end

function WBP_TaskSubItem_C:Construct()
    EventManager:AddEvent(EventID.OnSelectQuestSubItem, self, self.OnQuestSelectedToStopAnimation)
    self.IsDestroied = false
end

function WBP_TaskSubItem_C:Destruct()
    self.Super.Destruct(self)
    self.Common_List_Subcell_PC.Button_Area.OnClicked:Clear()
    EventManager:RemoveEvent(EventID.OnSelectQuestSubItem, self, self.OnQuestSelectedToStopAnimation)
    self.IsDestroied = true
end

function WBP_TaskSubItem_C:OnQuestSelectedToStopAnimation(SelectId)
    if SelectId == nil or self.QuestChainId ~= SelectId then
        self:OnQuestUnSelect()
    end
end

function WBP_TaskSubItem_C:RefreshTaskSubItemInfo(Content)
    if not Content then
        print(_G.LogTag, "WBP_TaskSubItem_C.OnListItemObjectSet: Content is nil!")
        return
    end
    print(_G.LogTag,"SUbItem 1111111")
    self.State = Content.State
    self.OwnerWidget = Content.OwnerWidget  --- @type WBP_TaskListItem_C
    self.MainWidget = Content.MainWidget    --- @type WBP_TaskMain_PC_C Owner的Owner,后续被点击的回调需要调用它的方法，所以加了这个成员
    self.QuestID = Content.QuestID
    self.QuestChainId = Content.QuestChainId
    if self.QuestChainId ~= -1 then
        local UnlockTitle = DataMgr.QuestChain[self.QuestChainId].UnlockTitle   
    end
    self.IsDoingQuest = Content.IsDoingQuest
    self.IsNew = Content.IsNew
    -- self.Common_List_Subcell_PC.IsSelect = false
    self.QuestName = ""
    self.QuestPosition = ""
    self.TeleportPointName = ""
    if self.QuestChainId ~= -1 then
        local UnlockTitle = DataMgr.QuestChain[self.QuestChainId].UnlockTitle
        self:GetDetailInfo()    
    end

    --self.Common_List_Subcell_PC:UnbindAllFromAnimationFinished(self.Common_List_Subcell_PC.Select)
    -- self.Content = Content

    -- 初始化一些控件状态
    self.Group_Fold:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Group_Guide_Point:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.QuestChainId == -1 then
        self.StateSwitcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        -- 控制任务完成状态
        if self.State == QuestRealStateEnum.Finished or self.State == QuestRealStateEnum.Lock then
            self.StateSwitcher:SetActiveWidgetIndex(self.State)
            self.StateSwitcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.StateSwitcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

    end


    

    -- 是否可点击
    if self.State ~= QuestRealStateEnum.Finished then
        self.Common_List_Subcell_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Common_List_Subcell_PC:BindEventOnClicked(self, self.OnQuestSelected)
        self.Common_List_Subcell_PC.Button_Area.OnClicked:Add(self, self.OnSubItemClicked)

    else
        self.Common_List_Subcell_PC:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
    self:PlayImageTaskTypeAnimation()

    -- 是否为新任务
    if self.QuestChainId ~= -1 then
        local Type = DataMgr.QuestChain[self.QuestChainId].QuestChainType
        local TypeName = CommonConst.QuestTypeName[Type]
        local NodeName = DataMgr.ReddotNode[TypeName].Name
        local RedDotDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
        local IsNew = RedDotDetail[self.QuestChainId]
        --local NewQuestChainTable = EMCache:Get("NewQuestChainTable", true) or {}
        if IsNew == 1 then
            self.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- if Content.IsDoingQuest and self.OwnerWidget.CompletedQuetsId and #self.OwnerWidget.CompletedQuetsId > 0 and self.OwnerWidget.ShowCompleteCount > 0 then
    --     self.Group_Fold:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- else
    --     self.Group_Fold:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
    if self.QuestChainId == -1 then
        self.Text_TaskName:SetText(GText("Quest_ToBeContinued"))
        self.Text_TaskPosition:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        local UnlockTitle = DataMgr.QuestChain[self.QuestChainId].UnlockTitle   
        --self.Text_TaskPosition:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.State == QuestRealStateEnum.Lock and UnlockTitle then
            self.Text_TaskName:SetText(GText(UnlockTitle))
        else
            self.Text_TaskName:SetText(self.QuestName)
        end
        
        
    end
    if self.QuestPosition ~= "" then
        self.Text_TaskPosition:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_TaskPosition:SetText(self.QuestPosition)
    else
        self.Text_TaskPosition:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end



    -- self:OnQuestUnSelect()
end

function WBP_TaskSubItem_C:OnSubItemClicked()
    self.MainWidget.RootWidget:SetFocus()
end

-- 折叠已完成任务列表的按钮
function WBP_TaskSubItem_C:FoldButtonOnClited()
    -- local function AfterAnim()
    --     self.OwnerWidget:ShowCompletedQuestList(self.IsExpansion)
    -- end

    -- local Animation
    -- if self.IsExpansion then
    --     self.IsExpansion = false
    --     Animation = self.Fold
    -- else
    --     self.IsExpansion = true
    --     Animation = self.Expansion
    -- end

    -- self:UnbindAllFromAnimationFinished(Animation)
    -- self:BindToAnimationFinished(Animation,{self,AfterAnim})
    -- self:PlayAnimation(Animation)
    -- self.MainWidget.RootWidget:SetFocus()
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end
-- 被点击后的回调，显示任务的详情
function WBP_TaskSubItem_C:OnQuestSelected()
    -- local NewQuestChainTable = EMCache:Get("NewQuestChainTable", true) or {}
    -- if IsEmptyTable(NewQuestChainTable) == false and NewQuestChainTable[self.QuestChainId] then
    --     NewQuestChainTable[self.QuestChainId] = false
    --     EMCache:Set("NewQuestChainTable", NewQuestChainTable, true)
    --     self.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
    -- local AllQuestChainReddotCache = EMCache:Get("AllQuestChainReddotSet", true) or {}
    -- local QuestChainType = DataMgr.QuestChain[self.QuestChainId].QuestChainType

    -- if IsEmptyTable(AllQuestChainReddotCache) == false and AllQuestChainReddotCache[QuestChainType] and AllQuestChainReddotCache[QuestChainType][self.QuestChainId] ~= nil then
    --     AllQuestChainReddotCache[QuestChainType][self.QuestChainId] = true
    --     EMCache:Set("AllQuestChainReddotSet", AllQuestChainReddotCache, true)
    --     self.MainWidget:UpdateTabWidgetReddot()
    -- end
    if self.QuestChainId ~= -1 then
        local Type = DataMgr.QuestChain[self.QuestChainId].QuestChainType
        local TypeName = CommonConst.QuestTypeName[Type]
        local NodeName = DataMgr.ReddotNode[TypeName].Name
        local RedDotDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
        if RedDotDetail[self.QuestChainId] == 1 then
            ReddotManager.DecreaseLeafNodeCount(NodeName, 1, {QuestId = self.QuestChainId})
            self.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    self.MainWidget:ShowQuestDetailInfo(self)
    if self.QuestChainId ~= -1 then
        self.MainWidget:TriggerLevelHardWarningUIShow(self.QuestChainId, self.QuestID)
    end
    --self.MainWidget:TriggerLevelHardWarningUIShow(self.QuestChainId, self.QuestID)

    if self:IsAnimationPlaying(self.Text_Normal) then
        self:StopAnimation(self.Text_Normal)
    end
    self:PlayTextAnimation(self.Text_Select)
    self.OwnerWidget.Common_List_Cell_PC:PlayAnimation( self.OwnerWidget.Common_List_Cell_PC.Select)
    self.OwnerWidget.Common_List_Cell_PC.IsSelected = true
    self.MainWidget.CurSelectId = self.QuestChainId
    TaskUtils.TaskMainLastSelectId = self.QuestChainId
    --self.MainWidget.RootWidget:SetFocus()
    if self.OwnerWidget.OwnerWidget.UsingGamepad then
        self.Common_List_Subcell_PC:OnCellClicked()
        
    end
    EventManager:FireEvent(EventID.OnSelectQuestSubItem, self.QuestChainId)
    
    -- 切换ImageTaskTypeAnimation
    if self.OwnerWidget then
        self.OwnerWidget:RefreshSelectionAnimation()
    end
end

function WBP_TaskSubItem_C:OnQuestUnSelect()
    self.Common_List_Subcell_PC:OnCellUnSelect()
    self:PlayTextAnimation(self.Text_Normal)
    --self.OwnerWidget.Common_List_Cell_PC.Bg_Select:SetRenderOpacity(0)
    self.OwnerWidget.Common_List_Cell_PC:OnCellUnSelect()
    self.OwnerWidget.Common_List_Cell_PC.IsSelected = false
end

-- 主动触发任务点击，用于打开面板时显示上次浏览/追踪的任务
function WBP_TaskSubItem_C:SelectQuestProactively()
    self.Common_List_Subcell_PC:OnCellClicked()
end
-- 获取当前任务在STL中的数据
function WBP_TaskSubItem_C:GetDetailInfo()
    local Info = TaskUtils:GetQuestDetail(self.QuestChainId, self.QuestID)
    if Info and Info.SubRegionId ~= nil and Info.SubRegionId > 0 then
        self.SubRegionId = Info.SubRegionId
        
        -- 获取TeleportPointName
        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(self.QuestChainId, "Task")
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            if IsEmptyTable(UIObjs) then
                if DataMgr.QuestChain[self.QuestChainId] and DataMgr.QuestChain[self.QuestChainId].LockShowSubRegionId ~= nil
                and Avatar.QuestChains[self.QuestChainId]:IsLock() then
                    self.TeleportPointName = DataMgr.QuestChain[self.QuestChainId].LockShowTeleportPointName
                end
            end
        end

        for _, v in pairs(UIObjs) do
            local TargetKey = v.GuideInfoCache.PointOrStaticCreatorName
            if TargetKey and GuidePointLocData[TargetKey] then
                self.TeleportPointName = GuidePointLocData[TargetKey].TeleportPointName
            end
            break
        end
    else
        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(self.QuestChainId, "Task")
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            if IsEmptyTable(UIObjs) then
                if DataMgr.QuestChain[self.QuestChainId] and DataMgr.QuestChain[self.QuestChainId].LockShowSubRegionId ~= nil
                and Avatar.QuestChains[self.QuestChainId]:IsLock() then
                    self.SubRegionId = DataMgr.QuestChain[self.QuestChainId].LockShowSubRegionId
                    self.TeleportPointName = DataMgr.QuestChain[self.QuestChainId].LockShowTeleportPointName
                else
                    ScreenPrint(string.format("WBP_TaskSubItem_C: 任务面板Item加载区域信息获取失败，请检查STL是否配置指引点节点, 任务Id: %s", self.QuestID))
                end
            end
        end

        for _, v in pairs(UIObjs) do
            local TargetKey = v.GuideInfoCache.PointOrStaticCreatorName
            if TargetKey and GuidePointLocData[TargetKey] then
                self.SubRegionId = GuidePointLocData[TargetKey].SubRegionId
                self.TeleportPointName = GuidePointLocData[TargetKey].TeleportPointName
            else
                ScreenPrint(string.format("WBP_TaskSubItem_C: 指引点区域数据不存在, 任务区域信息获取失败，请检查导出数据, 指引点: %s", v:GetName()))
            end
            break
        end
    end

    if not Info then
        ScreenPrint(string.format("WBP_TaskSubItem_C: 任务节点信息获取失败，请检查STL节点, 任务Id: %s", self.QuestID))
        return
    end

    if self.SubRegionId == nil then
        self.SubRegionId = 0
    end

    self.RegionId = 0
    if self.SubRegionId and self.SubRegionId > 0 then
        self.RegionId = math.floor(self.SubRegionId/100)
        if Info.TaskRegionReName ~= "" then
            self.QuestPosition = GText(Info.TaskRegionReName).." —— "
        else
            self.QuestPosition = GText(DataMgr.Region[self.RegionId].RegionName).." —— "
        end
        if Info.TaskSubRegionReName ~= "" then
            self.QuestPosition = self.QuestPosition..GText(Info.TaskSubRegionReName)
        else
            if self.TeleportPointName == "" or self.TeleportPointName == nil then
                self.QuestPosition = self.QuestPosition..GText(DataMgr.SubRegion[self.SubRegionId].SubRegionName)
            else
                self.QuestPosition = self.QuestPosition..GText(self.TeleportPointName)
            end
        end
    else
        if Info.TaskRegionReName ~= "" then
            self.QuestPosition = GText(Info.TaskRegionReName).." —— "
        end
        if Info.TaskSubRegionReName ~= "" then
            self.QuestPosition = self.QuestPosition..GText(Info.TaskSubRegionReName)
        end
    end

    if not Info.QuestDescription or not DataMgr.TextMap[Info.QuestDescription] then
        self.QuestName = GText("UI_QUEST_UNKNOWN")
    else
        self.QuestName = GText(Info.QuestDescription)..TaskUtils:GetQuestCountExtraInfoString(self.QuestChainId,self.QuestID)
    end

    if not Info.QuestDeatil or not DataMgr.TextMap[Info.QuestDeatil] then
        self.QuestDeatil = GText("UI_QUEST_UNKNOWN")
    else
        self.QuestDeatil = GText(Info.QuestDeatil)
    end

    self:TrySetSTLDetail(self.QuestChainId, self.QuestID)
end

function WBP_TaskSubItem_C:TrySetSTLDetail(InQuestChain, InQuestId)
    local QuestExtraInfo = TaskUtils:GetQuestExtraInfo(InQuestChain, InQuestId)
    if not QuestExtraInfo or IsEmptyTable(QuestExtraInfo) then
        return
    end

    local HasNewDetail = false
    local HasNewDescrible = false
    local NewDetail = ""
    local NewDescription = ""
    for _, Data in pairs(QuestExtraInfo) do
        if Data.Node and Data.Node.Type == "UpdateTaskBarAndTaskMainNode" and Data.SubTaskIndex == 0 and Data.CurNode == 0 then
            NewDetail = Data.Detail
            HasNewDetail = true
            if Data.Description then
                NewDescription = Data.Description
                HasNewDescrible= true
            end
            break
        end
    end

    if HasNewDetail == false or NewDetail == "" then
        return
    end
    if HasNewDetail then
        self.QuestDeatil = GText(NewDetail)
    end
    if HasNewDescrible then
        self.QuestName = GText(NewDescription)..TaskUtils:GetQuestCountExtraInfoString(self.QuestChainId,self.QuestID)
    end
end

function WBP_TaskSubItem_C:OnTracking(QuestChainId)
    local Texture = TaskUtils:GetIconTextureByTrackQuestChainType(QuestChainId)
    if Texture then
        self.Common_GuidePoint_PC.Img_GuidePoint_Icon:SetBrushResourceObject(Texture)
    end

    self.Group_Guide_Point:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Common_GuidePoint_PC:PlayAnimation(self.Common_GuidePoint_PC.Loop,0,0)
    if self.Common_GuidePoint_PC.HoverFunction then
        self.Common_GuidePoint_PC.HoverFunction = nil
    end

    if self.Common_GuidePoint_PC.ClickFunction then
        self.Common_GuidePoint_PC.ClickFunction = nil
    end
end

function WBP_TaskSubItem_C:CancelTracking()
    self.Group_Guide_Point:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Common_GuidePoint_PC:StopAnimation(self.Common_GuidePoint_PC.Loop)
end
-- 选中/未被选中时的字体透明度不一样，用动效控制
function WBP_TaskSubItem_C:PlayTextAnimation(Anim)
    if self:IsAnimationPlaying(self.Text_Normal) then
        self:StopAnimation(self.Text_Normal)
    elseif self:IsAnimationPlaying(self.Text_Select) then
        self:StopAnimation(self.Text_Select)
    end

    self:PlayAnimation(Anim)
end

function WBP_TaskSubItem_C:PlayImageTaskTypeAnimation()
    local QuestChainType = nil
    if self.QuestChainId == -1 then
        QuestChainType = 1
    else
        QuestChainType = DataMgr.QuestChain[self.QuestChainId].QuestChainType
    end
    if QuestChainType == Const.MainQuestChainType or QuestChainType == Const.MainActivityQuestChainType then
        self:PlayAnimation(self.Task_MainColor)
    elseif QuestChainType == 2 then
        self:PlayAnimation(self.Task_DailyColor)
    elseif QuestChainType == Const.SideQuestChainType then
        self:PlayAnimation(self.Task_SideColor)
    elseif QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.SpecialSideQuestChainType then
        self:PlayAnimation(self.Task_SpecialColor)
    end
end


function WBP_TaskSubItem_C:OnFocusReceived(MyGeometry, InFocusEvent)

    -- if not next(self.OwnerWidget.CompletedQuetsId) then
    --     self.OwnerWidget.OwnerWidget:InitTabPadKeyInfoForBack()
    --     return UIUtils.Handle
    -- end
    -- self.OwnerWidget.OwnerWidget:InitTabPadKeyInfo()
    if self.MainWidget.CurSelectId ~= self.QuestChainId then
        self:OnQuestSelected()
    end
    self.OwnerWidget.OwnerWidget:InitTabPadKeyInfoForBack()
    return UIUtils.Handle
end

function WBP_TaskSubItem_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false

    if (InKeyName == "Gamepad_FaceButton_Bottom") then
        if self.Group_Fold:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            --self:FoldButtonOnClited()
            self:SetFocus()
            IsHandled = true
        end
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return WBP_TaskSubItem_C
