require "UnLua"

local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local CameraGameUtils = require "BluePrints.UI.WBP.Activity.PC.CameraGame.CameraGameUtils"

---@type WBP_Activity_CameraGame_Base_C
local M = Class({"BluePrints.UI.BP_UIState_C",})

function M:Construct()
    --初始化Tab
    self:InitCommonTab()
    -- 领奖按钮绑定事件
    self.Btn_Photo.OnClicked:Add(self, self.OnRewardAndPhotoButtonClicked)
    -- 初始化变量
    self.Avatar = GWorld:GetAvatar()
    self.QCS = CommonConst.QuestChainState
    self.EventId = CameraGameUtils.GetEventId()
    self.ReddotType = CameraGameUtils.ReddotType
    self.ReddotNodeName = ActivityReddotHelper.GetEventMainNodeName(self.EventId)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Param1, Param2)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Param1, Param2)
    if Param2 and Param2[1] then
        local Index = tonumber(Param2[1]) or 1
        self.ListView_Left:NavigateToIndex(Index - 1)  -- 选中指定位置照片
    end

    -- 刷新下红点
    CameraGameUtils.RefreshReddot(self.EventId)

    -- 初始化拍照进度
    self:InitPhotoProgress()
    --初始化照片列表
    self:InitPhotoList()
    -- 入场动画
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/camera_sub_page_in", nil, nil)
    --监听红点
    self:AddReddotListen()
end

function M:Destruct()
    self:RemoveReddotListen()
    M.Super.Destruct(self)
end

-- 关闭界面
function M:CloseSelf()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:PlayAnimation(self.Out)
    -- 获取上一个栈中的UI
    local PreviousUI = UIManager():GetUnderState()
    if PreviousUI then
        local PreviousUIName = PreviousUI:GetName()
        if PreviousUIName == "ActivityMain" then
            EventManager:FireEvent(EventID.OnReturnToActivityEntry)
            EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
        end
    end
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:Close()
    end
end

-- 添加红点监听
function M:AddReddotListen()
    ActivityReddotHelper.AddReddotListenByEventId(self.EventId,
        {Obj=self, Func=function(self, Count, RdType, RdName)
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotNodeName)
            if not CacheDetail then
                return
            end

            for _, Content in pairs(self.PhotoItemContents) do
                Content.ReddotType = CacheDetail[Content.QuestChainId] or self.ReddotType.NONE
                if Content.SelfWidget then
                    Content.SelfWidget:UpdateReddot()
                end
            end
        end}
    )
end

-- 移除红点监听
function M:RemoveReddotListen()
    ActivityReddotHelper.RemoveReddotListenByEventId(self.EventId, self)
end

--初始化Tab
function M:InitCommonTab()
    self.Tab:Init(self.TabConfigData, true)
end

-- 初始化拍照进度
function M:InitPhotoProgress()
    self.Text_Title:SetText(GText("UI_PhotoEvent_Progress"))
    local CurCount, TotalCount = CameraGameUtils.GetPhotoProgress()
    self.Text_TitleNum01:SetText(CurCount)
    self.Text_TitleNum02:SetText("/"..TotalCount)
end

-- 初始化照片列表
function M:InitPhotoList()
    -- 选中的排序权重
    local GetSortWeight = function(Content)
        if Content.QuestState == self.QCS.finish then  -- 已完成
           return Content.RewardGot and 1 or 4 -- 未领取 4，已领取 1
        elseif (Content.QuestState  == self.QCS.unlock)
            or (Content.QuestState == self.QCS.doing) then  -- 已解锁/进行中 3
            return 3
        end

        return 1
    end

    self.ListView_Left:ClearListItems()
    self:CreatePhotoContent()
    self.PhotoItemContents = self.PhotoItemContents or {}
    local SelectedIndex = 0
    local SelectedWeight = 1
    for Index, Content in pairs(self.PhotoItemContents) do
        Content.Index = Index
        local Weight = GetSortWeight(Content)

        if Weight > SelectedWeight then
            SelectedIndex = Index - 1
            SelectedWeight = Weight
        end

        self.ListView_Left:AddItem(Content)
    end

    self.PhotoItemCount = #self.PhotoItemContents
    self.ListView_Left:NavigateToIndex(SelectedIndex)  -- 按优先级选中照片
    self.ListView_Left.BP_OnItemClicked:Clear()
    self.ListView_Left.BP_OnItemClicked:Add(self, self.OnPhotoItemClicked)
    self.ListView_Left.BP_OnItemIsHoveredChanged:Clear()
    self.ListView_Left.BP_OnItemIsHoveredChanged:Add(self, self.OnPhotoItemIsHoveredChanged)
end

-- 创建照片内容数据
function M:CreatePhotoContent()
    if not self.Avatar then
        return
    end

    local GetReddotType = function(QuestChainId)
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotNodeName) 
        if not CacheDetail then
            return self.ReddotType.NONE
        end

        return CacheDetail[QuestChainId]
    end

    self.PhotoItemContents = {}
    -- 创建Item数据
    for _, Data in pairs(DataMgr.PhotoEvent[self.EventId] or {}) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.ParentWidget = self
        Content.Index = Data.PhotoTaskId  -- 任务顺序
        Content.PhotoTaskId = Data.PhotoTaskId  -- 任务索引
        Content.QuestChainId = Data.QuestChain  -- 任务链ID
        Content.PhotoPath = Data.PhotoView  -- 照片路径
        Content.RewardId = Data.RewardView  -- 奖励ID
        Content.RewardGot = self.Avatar.PhotoActRewardGot[Data.QuestChain]   -- 奖励是否领取
        Content.ReddotType = GetReddotType(Data.QuestChain)
        Content.TextTitle = Data.Content1
        Content.TextContent = Data.Content2

        local QuestChain = self.Avatar.QuestChains[Data.QuestChain]  -- 任务链数据
        Content.QuestState  = QuestChain and QuestChain.State or self.QCS.unlock  -- 任务阶段
        if Content.QuestState == self.QCS.lock then  -- 已锁定
            Content.UnlockTime = Data.StartTime and Data.StartTime:GetTime()  -- 解锁时间
        end

        self:OnPhotoListContentCreated(Content)
        table.insert(self.PhotoItemContents, Content)
    end

    -- 计算照片顺序排序权重
    local GetSortWeight = function(Content)
        if Content.QuestState == self.QCS.finish then  -- 已完成
           return Content.RewardGot and 3 or 4 -- 未领取 4，已领取 3
        elseif (Content.QuestState  == self.QCS.unlock)
            or (Content.QuestState == self.QCS.doing) then  -- 已解锁/进行中 2
            return 2
        end
        return 1  -- 待解锁 1
    end

    -- 照片顺序排序：已完成未领取->已完成已领取->已解锁/进行中->待解锁
    table.sort(self.PhotoItemContents, function(a, b)
        local weightA = GetSortWeight(a)
        local weightB = GetSortWeight(b)
        if weightA ~= weightB then
            return weightA > weightB
        else  -- 权重相同时，按配置表的索引 Index 排序
            return a.Index < b.Index
        end
    end)
end

-- 点击后取消New红点
function M:CancelNewReddot(Content)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(CameraGameUtils.ReddotNodeName)
    if not CacheDetail then
        return
    end
    local QuestChainId = Content.QuestChainId
    if CacheDetail[QuestChainId] ~= self.ReddotType.NEW then
        return
    end

    CacheDetail[QuestChainId] = self.ReddotType.SEEN
    ReddotManager.DecreaseLeafNodeCount(CameraGameUtils.ReddotNodeName)
end

-- 照片点击事件
function M:OnPhotoItemClicked(Content)
    -- 相同条目
    if self.ContentClicked == Content then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/camera_photo_click", nil, nil)
    -- 条目对应的控件
    local ItemWidget = Content.SelfWidget
    if not ItemWidget then
        return
    end
    -- 取消New红点状态
    self:CancelNewReddot(Content)
    -- 选中动画
    ItemWidget:StopAnimation(ItemWidget.Normal)
    ItemWidget:PlayAnimation(ItemWidget.Click)
    -- 取消上一次选中
    if self.ContentClicked then
        local LastItemWidget = self.ContentClicked.SelfWidget
        if LastItemWidget then
            LastItemWidget:StopAnimation(LastItemWidget.Click)
            LastItemWidget:PlayAnimation(LastItemWidget.Normal)
        end
    end
    -- 记录当前选中
    self.ContentClicked = Content
    self.CurQuestState = Content.QuestState

    -- 聚焦处理
    self:OnPhotoListItemAddedToFocusPath(Content)

    -- 滚动框设置到顶部
    self.ScrollBox_Message:ScrollToStart()
    -- 手柄刷新底部按键提示，描述过长需要显示上下滚动
    if self.IsGamepadInput then
        self:UpdateBottomKeyInfo()
    end

    self.WBP_BG:PlayAnimation(self.WBP_BG.Refresh)
    -- 刷新右侧详细内容
    self:AddTimer(0.1, function()
        self:RefreshMainPhotoView(Content)
    end)
end

-- 刷新右侧详细内容
function M:RefreshMainPhotoView(Content)
    -- 显示与隐藏一些控件
    local Visibility = UIConst.VisibilityOp.Visible
    if Content.QuestState == self.QCS.lock then  -- 未解锁
        Visibility = UIConst.VisibilityOp.Collapsed
    end
    self.List_Reward:SetVisibility(Visibility)
    self.Switch_Btn:SetVisibility(Visibility)
    self.Text_PhotoTitle:SetVisibility(Visibility)
    self.Text_Message:SetVisibility(Visibility)

    -- 已完成
    if (Content.QuestState == self.QCS.finish) then
        -- 标题
        self.Text_PhotoTitle:SetText(GText(Content.TextTitle))
        -- 描述
        self.Text_Message:SetText(GText(Content.TextContent))
        -- 设置照片
        self.WBP_BG.Switch_Type:SetActiveWidgetIndex(0)
        self.WBP_BG.Image_Normal:SetBrushFromTexture(Content.Texture)
        -- 刷新奖励
        self:RefreshRewardList()
        -- 切换按钮状态
        if Content.RewardGot then  -- 已领取
            self.Switch_Btn:SetActiveWidget(self.Btn_PhotoDis)
            self.Text_PhotoDis:SetText(GText("UI_Reward_Received"))
        else  -- 未领取：前往拍照/领取奖励
            self.Switch_Btn:SetActiveWidget(self.Btn_Photo)
            self.Text_Photo:SetText(GText("UI_Mail_Recieve"))
        end
    -- 已解锁/进行中
    elseif  (Content.QuestState == self.QCS.unlock)
        or (Content.QuestState == self.QCS.doing) then
        -- 标题
        self.Text_PhotoTitle:SetText(GText(Content.TextTitle))
        -- 描述
        self.Text_Message:SetText(GText(Content.TextContent))
        self.WBP_BG.Switch_Type:SetActiveWidgetIndex(1)
        self.WBP_BG.Image_None:SetBrushFromTexture(Content.Texture)
        -- 刷新奖励
        self:RefreshRewardList()
        self.Switch_Btn:SetActiveWidget(self.Btn_Photo)
        self.Text_Photo:SetText(GText("UI_PhotoEvent_Goto"))
    -- 待解锁
    else
        -- 切换显示
        self.WBP_BG.Switch_Type:SetActiveWidgetIndex(2)
        -- 剩余解锁时间
        local IsSucccess = self:SetUnlockTimeText(Content)
        -- 拍照解锁条件
        if not IsSucccess then
            self:SetUnlockConditionText(Content)
        end
    end
end

-- 设置剩余解锁时间的文本
function M:SetUnlockTimeText(Content)
    if (not Content) or (not Content.UnlockTime) then
        return false
    end

    local TimeDict, _ = UIUtils.GetLeftTimeStrStyle2(Content.UnlockTime)
    if not TimeDict then
        return false
    end

    local ZeroCount = 0
    local RemainTimeText = ""
    for TimeCount, ThisTimeInfo in ipairs(TimeDict) do
        if (TimeCount > 2) then
            DebugPrint("CameraGame: WBP_Com_Time SetTimeText TimeCount too much, 2 need but get more")
            break
        end
        RemainTimeText = string.format("%s%02d%s", RemainTimeText, ThisTimeInfo.TimeValue,
            GText("UI_GameEvent_TimeRemain_" .. ThisTimeInfo.TimeType))

        if (ThisTimeInfo.TimeValue == 0) then
            ZeroCount = ZeroCount + 1
        end
    end

    if (ZeroCount > 1) then
        return false
    end

    RemainTimeText = string.format(GText("UI_PhotoEvent_Unlock"), RemainTimeText)
    self.WBP_BG.Text_Lock:SetText(RemainTimeText)
    return true
end

-- 设置解锁条件文本
function M:SetUnlockConditionText(Content)
    if (not Content) or (not Content.QuestChainId) then
        return
    end

    local EventData = DataMgr.PhotoEvent[self.EventId]
    if not EventData then
        return
    end

    local QuestData = EventData[Content.PhotoTaskId]
    if not QuestData then
        return
    end

    local ConditionText = string.format(GText("UI_PhotoEvent_Quest"), GText(QuestData.Content3))
    self.WBP_BG.Text_Lock:SetText(ConditionText)
end

-- Hover和UnHover动画
function M:OnPhotoItemIsHoveredChanged(Content, IsHovered)
    -- 手柄
    if self.IsGamepadInput then
        return
    end

    local ItemWidget = Content.SelfWidget
    if not ItemWidget then
        return
    end
    if self.ContentClicked == Content then
        return
    end
    if IsHovered then
        ItemWidget:StopAnimation(ItemWidget.UnHover)
        ItemWidget:PlayAnimation(ItemWidget.Hover)
    else
        ItemWidget:StopAnimation(ItemWidget.Hover)
        ItemWidget:PlayAnimation(ItemWidget.UnHover)
    end
end

-- 刷新奖励列表数据
function M:RefreshRewardList()
    local PhotoContent = self.ContentClicked
    if not PhotoContent then return end

    -- 创建对应照片的奖励数据
    local RewardList = RewardUtils:GetRewardViewInfoById(PhotoContent.RewardId)
    if not RewardList or #RewardList == 0 then
        return
    end
    self.List_Reward:ClearListItems()
    for _, RewardInfo in pairs(RewardList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.ItemType = RewardInfo.Type
        Content.UnitId = RewardInfo.Id
        Content.Rarity = RewardInfo.Rarity or 1
        Content.Icon = ItemUtils.GetItemIconPath(RewardInfo.Id, RewardInfo.Type)
        Content.IsShowDetails = true
        Content.IsSelect = false
        Content.bHasGot = PhotoContent.RewardGot
        Content.UIName = "ActivityCamreaGame"
        if RewardInfo.Quantity then
            if #RewardInfo.Quantity > 1 then
                Content.Count = RewardInfo.Quantity[1]
                Content.MaxCount = RewardInfo.Quantity[2]
            else
                Content.Count = RewardInfo.Quantity[1]
            end
        end
        self:OnRewardListContentCreated(Content)
        self.List_Reward:AddItem(Content)
    end
    self.List_Reward:ScrollIndexIntoView(0)
end

-- “领取奖励” 和“前往拍照"  点击事件
function M:OnRewardAndPhotoButtonClicked()
    if not self.ContentClicked then
        return
    end

    -- “前往拍照”：跳转到大地图
    if (self.ContentClicked.QuestState ~= self.QCS.finish)  then
        local QuestChainId = self.ContentClicked.QuestChainId
        if not self.Avatar.QuestChains[QuestChainId] then
            return
        end
        local RegionPointId = nil
        for key, _ in pairs(DataMgr.PhotoEvent) do
            for key, value in pairs(_) do
                if value.QuestChain == QuestChainId then
                    RegionPointId = value.RegionPoint              
                    break
                end
            end
            
        end
        if not RegionPointId then
            return
        end
        local SubRegionId = DataMgr.RegionPoint[RegionPointId].SubRegion
        local RegionId = DataMgr.SubRegion[SubRegionId].RegionId
        local MainMap = UIManager(self):LoadUINew("LevelMapMain", false, RegionId, "RegionPoint", RegionPointId)
        -- if MainMap then
        --     local DoingQuestId = self.Avatar.QuestChains[QuestChainId].DoingQuestId
        --     local TargetSubRegionId = MissionIndicatorManager:GetTargetTaskSubRegionId(QuestChainId, DoingQuestId)
        --     MainMap.RealWildMap:ChangeRegionForSmartIndicator(TargetSubRegionId, QuestChainId)
        -- end
        return
    end

    -- 奖励已领取
    if self.Avatar.PhotoActRewardGot[self.ContentClicked.QuestChainId] then
        return
    end

    -- 领取奖励
    local Callback = function(ErrCode, Rewards)
        -- 弱网处理
        self:BlockAllUIInput(false)
        -- 错误码处理
        if not ErrorCode:Check(ErrCode) then
            return
        end

        -- 弹出领奖弹窗
        UIManager(self):LoadUINew("GetItemPage",  nil, nil, nil, Rewards, self.PlayOutAnim, self, true)

        -- 切换按钮显示
        self.Switch_Btn:SetActiveWidget(self.Btn_PhotoDis)
        self.Text_PhotoDis:SetText(GText("UI_Reward_Received"))
        -- 更新奖励领取状态
        self.ContentClicked.RewardGot = true
        -- 刷新奖励列表
        self:RefreshRewardList()
    end

    self:BlockAllUIInput(true)
    self.Avatar:GetPhotoQuestFinishReward(Callback, self.ContentClicked.QuestChainId)
end

-- Begin 在子类实现，目的是区分PC和移动端的逻辑
function M:OnPhotoListContentCreated(Content)
end

function M:OnRewardListContentCreated(Content)
end

function M:OnPhotoListItemAddedToFocusPath(Content)
end

function M:UpdateBottomKeyInfo()
end
-- End 在子类实现

return M