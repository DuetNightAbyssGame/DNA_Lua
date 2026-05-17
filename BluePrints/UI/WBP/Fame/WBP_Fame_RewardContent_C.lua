--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local RegionFameController = require("BluePrints.UI.WBP.Fame.RegionFameController")
local RegionFameModel = RegionFameController:GetModel()

---@type WBP_Fame_RewardContent_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.Fame_CompletionProgress.Btn_Reward.Button_Area.OnClicked:Add(self, self.OnGetAllRewardsBtnClicked)
end

function M:Destruct()
    self.Fame_CompletionProgress.Btn_Reward.Button_Area.OnClicked:Remove(self, self.OnGetAllRewardsBtnClicked)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    local CurRegionId = ...
    rawset(self, "CurRegionId", CurRegionId and tonumber(CurRegionId) or 1001)
    rawset(self, "CurRegionTabId", self.CurRegionId)

    self:InitRegionTab()
    self:RefreshRewardList()

    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FameRewardIn", nil)
end

-- function M:OnAnimationFinished(Animation)
--     if Animation == self.Auto_Out then
--         self:Close()
--     end
-- end

-- 界面tab标题初始化
function M:InitTitleDetail()
    local CurRegionName = self:GetRegionName(self.CurRegionId)
    self.Com_Tab:Init({
        DynamicNode={"Back", "ResourceBar", "BottomKey",},
        BottomKeyInfo = {
            {
                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc=GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        },
        StyleName = "Text",
        TitleName = GText("ReputationLevelReward_Title"),--string.format("%s·%s", GText(CurRegionName), GText("ReputationLevelReward_Title")),
        -- OverridenTopResouces = self.OverridenTopResouces,
        -- OnResourceBarAddedToFocusPath = self.OnResourceBarAddedToFocusPath,
        -- OnResourceBarRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath,
        OwnerPanel = self,
        BackCallback = self.CloseSelf
    })
end

-- 新增上方的地区页签逻辑
---@return nil
function M:InitRegionTab()
    -- 先准备地区页签配置数据（名称/图标/解锁状态等）
    self:InitRegionTabInfo()

    -- 初始化通用页签组件：Q/E 切换地区，标题使用奖励界面标题
    self.Com_Tab:Init({
        LeftKey = "Q", RightKe = "E", Tabs = self.AllRegionTabInfo,
        DynamicNode={"Back", "ResourceBar", "BottomKey",},
        BottomKeyInfo = {
            {
                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc=GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        },
        StyleName = "Text",
        TitleName = GText("ReputationLevelReward_Title"),
        -- OverridenTopResouces = self.OverridenTopResouces,
        -- OnResourceBarAddedToFocusPath = self.OnResourceBarAddedToFocusPath,
        -- OnResourceBarRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath,
        OwnerPanel = self,
        BackCallback = self.CloseSelf,
        LastFocusWidget = self.List_Item,
    })

    -- 绑定地区页签点击事件
    self.Com_Tab:BindEventOnTabSelected(self, self.OnRegionTabItemClick)
    -- 设置当前选中Tab
    self:AddDelayFrameFunc(
        function()
            -- 进入界面后默认选中当前地区，触发对应区域奖励刷新
            self.Com_Tab:SelectTabById(self.CurRegionTabId)
        end, 1, "FillWithRegionInfo"
    )
end

-- 初始化地区页签数据
---@return nil
function M:InitRegionTabInfo()
    ---@type FameRegionTabInfo[]
    local AllRegionTabInfo = {}

    -- 遍历地区配置，构建 Com_Tab 需要的页签数据结构
    for RegionId, TabData in pairs(DataMgr.RegionReputation) do
        -- 与任务界面一致：根据条件决定是否锁定
        local Locked = not RegionFameModel:CheckTabCondition(TabData.Condition)
        local LockToast = TabData.LockToast
        local TabName = GText(TabData.RegionName)
        table.insert(AllRegionTabInfo, {
            Text = TabName,
            IconPath = TabData.RegionIconPath,
            TabId = RegionId,
            IsLocked = Locked,
            LockReasonText = LockToast,
        })
    end

    -- 缓存到 self，供页签组件初始化使用
    rawset(self, "AllRegionTabInfo", AllRegionTabInfo)
end

-- 页签切换逻辑
---@param TabWidget table
---@return nil
function M:OnRegionTabItemClick(TabWidget)
    -- 新旧地区 ID：用于切换判断和失败回退
    local NewTabId = TabWidget:GetTabId()
    local OldTabId = self.CurRegionTabId

    -- 防御：配置缺失直接返回
    local NewData = DataMgr.RegionReputation[NewTabId]
    if not NewData then
        return
    end

    -- 未解锁时弹提示并恢复到旧页签
    if not self:CheckDungeonCondition(NewData.Condition) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(NewData.LockToast))

        local FallbackId = OldTabId or (self.AllRegionTabInfo[1] and self.AllRegionTabInfo[1].TabId)
        if FallbackId and FallbackId ~= NewTabId then
            self.Com_Tab:SelectTabById(FallbackId)
        end
        return
    end

    if OldTabId == NewTabId then
        return
    end

    -- 更新当前地区上下文并清理缓存名称
    rawset(self, "CurRegionTabId", NewTabId)
    rawset(self, "CurRegionId", NewTabId)
    rawset(self, "CurRegionName", nil)

    -- 切区后刷新奖励列表并回到奖励列表焦点
    self:RefreshRewardList()
    self:SetFocus()
end

---@param Condition any
---@return boolean
function M:CheckDungeonCondition(Condition)
    -- 角色不存在时默认不可进入
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    -- 无条件代表直接可进入
    if not Condition then
        return true
    end

    -- 条件系统校验失败则不可进入
    if ConditionUtils.CheckCondition(Avatar, Condition) == false then
        return false
    end
    return true
end


-- 初始化左侧最终大奖 注意！！ 有先后顺序 要在RefreshRewardList 后面，因为要用到奖励数据判定是否领完
function M:InitLeftReward()
    -- if self.FinishedRewardNum and self.TotalRewardNum and self.FinishedRewardNum < self.TotalRewardNum then
    -- -- 有未领取完的奖励 显示预览大奖
    local Content = {}
    Content.CurRegionId = self.CurRegionId
    Content.Parent = self
    local FameLevel = RegionFameModel:GetRegionFameLevel(self.CurRegionId)
    Content.CurrentFameLevel = FameLevel
    Content.OnMenuOpenChanged = self.OnMenuOpenChanged

    self.Reward:Init(Content)
    self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    --     return
    -- end
    -- -- 全部领取完 显示领完提示
    -- self.TextBlock_72:SetText(GText("Reputation_MaxLevel"))
    -- self.WidgetSwitcher_0:SetActiveWidgetIndex(1)
end

-- 刷新奖励列表数据和界面显示
function M:RefreshRewardList()
    local AllRewardsData = DataMgr.ReputationLevel[self.CurRegionId]
    if not AllRewardsData then
        return
    end

    -- 第一个可领取奖励Index
    local FirstReadyClaimIndex = nil
    -- 第一个不可领取的奖励Index
    local FirstNotClaimableIndex = nil
    -- 所有可领取的奖励
    local AllReadyClaimRewards = {}

    -- 新增改动：奖励列表按照可领取、不可领取、已领取的顺序排序显示
    local ReadyClaimContents = {}
    local NotClaimableContents = {}
    local AlreadyClaimedContents = {}

    local FinishedRewardNum = 0
    local TotalRewardNum = #AllRewardsData
    self.List_Item:ClearListItems()
    for Index, RewardInfo in ipairs(AllRewardsData) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())

        Content.Level = RewardInfo.ReputationLevel
        Content.State = RegionFameModel:GetTargetLevelRewardState(self.CurRegionId, Content.Level)
        Content.RewardID = RewardInfo.Reward
        Content.FameModel = RegionFameModel
        Content.RegionId = self.CurRegionId
        Content.Parent = self
        Content.OnReceiveRewardCallBack = function(Ret, RewardReturn, ReputationId, LevelInfo)
            if Ret and Ret == ErrorCode.RET_SUCCESS then
                self:RefreshRewardList()
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardReturn, false, function ()
                    self:SetFocus()
                end, self)
                return
            end

            local Error = DataMgr.ErrorCode[Ret]
            if Error ~= nil then
                UIManager(self):ShowError(Ret, 1.5)
            else
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
            end
        end
        Content.OnMenuOpenChanged = self.OnMenuOpenChanged

        if Content.State == CommonConst.FameRewardState.AlreadyClaimed then
            FinishedRewardNum = FinishedRewardNum + 1
            table.insert(AlreadyClaimedContents, Content)
        elseif Content.State == CommonConst.FameRewardState.ReadyClaim then
            table.insert(AllReadyClaimRewards, Content.Level)
            table.insert(ReadyClaimContents, Content)
        elseif Content.State == CommonConst.FameRewardState.NotClaimable then
            table.insert(NotClaimableContents, Content)
        end
    end

    local OrderedContents = {}
    for _, Content in ipairs(ReadyClaimContents) do
        table.insert(OrderedContents, Content)
    end
    for _, Content in ipairs(NotClaimableContents) do
        table.insert(OrderedContents, Content)
    end
    for _, Content in ipairs(AlreadyClaimedContents) do
        table.insert(OrderedContents, Content)
    end

    for DisplayIndex, Content in ipairs(OrderedContents) do
        Content.Index = DisplayIndex - 1
        self.List_Item:AddItem(Content)
        if Content.State == CommonConst.FameRewardState.ReadyClaim and not FirstReadyClaimIndex then
            FirstReadyClaimIndex = DisplayIndex
        elseif Content.State == CommonConst.FameRewardState.NotClaimable and not FirstNotClaimableIndex then
            FirstNotClaimableIndex = DisplayIndex
        end
    end

    rawset(self, "AllReadyClaimRewards", AllReadyClaimRewards)
    rawset(self, "FirstReadyClaimIndex", FirstReadyClaimIndex)
    rawset(self, "FirstNotClaimableIndex", FirstNotClaimableIndex)

    rawset(self, "FinishedRewardNum", FinishedRewardNum)
    rawset(self, "TotalRewardNum", TotalRewardNum)

    self:RewardListAutoScroll()

    self.Fame_CompletionProgress.Text01:SetText(string.format(GText("UI_Party_Parkour_FinishingRate")..": "))
    self.Fame_CompletionProgress.Text_Now:SetText(string.format("%d", FinishedRewardNum))
    self.Fame_CompletionProgress.Text_Total:SetText(string.format("%d", TotalRewardNum))
    self.Fame_CompletionProgress.Btn_Reward:SetText(GText("UI_Mail_Recieveall"))  
        
    -- 如果没有任何可领取的奖励，则置灰“一键领取”按钮
    if #self.AllReadyClaimRewards == 0 then
        self.Fame_CompletionProgress.Btn_Reward:ForbidBtn(true)--SetVisibility(UIConst.VisibilityOp.Collapsed)
    else      
        self.Fame_CompletionProgress.Btn_Reward:ForbidBtn(false)--SetVisibility(UIConst.VisibilityOp.Visible)
    end
    -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Change)

    self:InitLeftReward()
end

-- 右侧奖励列表自动定位至对应位置
function M:RewardListAutoScroll()
    if self.FirstReadyClaimIndex then
        self.List_Item:NavigateToIndex(self.FirstReadyClaimIndex - 1)
    elseif self.FirstNotClaimableIndex then
        self.List_Item:NavigateToIndex(self.FirstNotClaimableIndex - 1)
    else
        self.List_Item:NavigateToIndex(self.List_Item:GetNumItems() - 1)
    end
end

function M:OnGetAllRewardsBtnClicked()
    if self.Fame_CompletionProgress.Btn_Reward:IsBtnForbidden() then--GetVisibility() == ESlateVisibility.Collapsed
        return
    end
	local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GetRegionReputationLevelReward(self.CurRegionId, self.AllReadyClaimRewards, function(Ret, RewardReturn, ReputationId, LevelInfo)
            if Ret and Ret == ErrorCode.RET_SUCCESS then
                self:RefreshRewardList()
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardReturn, false, function ()
                    self:SetFocus()
                end, self)
                return
            end

            local Error = DataMgr.ErrorCode[Ret]
            if Error ~= nil then
                UIManager(self):ShowError(Ret, 1.5)
            else
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
            end
        end)
    end
end

function M:GetRegionName(CurRegionId)
    if self.CurRegionName then
        return self.CurRegionName
    end
    CurRegionId = tonumber(CurRegionId)
    local CurRegionData = DataMgr.RegionReputation[CurRegionId]
    if not CurRegionData then
        return
    end
    local CurRegionName = CurRegionData.RegionName
    rawset(self, "CurRegionName", CurRegionName)
    return CurRegionName
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.Auto_Out) then
        return
    end
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:BeginAnimOutToExitWithInStack(true)
    self:Close()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FameRewardIn", nil)

    -- self:PlayAnimation(self.Auto_Out)
end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

--region 输入相关
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadButtonDown(InKeyName)
        if not IsEventHandled then
            IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
        end
    else
        IsEventHandled = self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
        if not IsEventHandled then
            IsEventHandled = self:Handle_OnPCButtonDown(InKeyName)
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:Handle_OnGamePadButtonDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.LeftThumb then
        self.bPreviewingAllRewards = true
        self:SetFocus()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.bPreviewingAllRewards then
            self.bPreviewingAllRewards = nil
            self:SetFocus()
            IsEventHandled = true
        end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
        self:OnGetAllRewardsBtnClicked()
    end
    return IsEventHandled
end

function M:Handle_OnPCButtonDown(InKeyName)
    return false
end

function M:SetFocus()
    if self.bPreviewingAllRewards then
        self.Reward.List_Item:SetFocus()
    else
        self:RewardListAutoScroll()
    end
end
--endregion

--region 手柄相关
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end

    --- 输入设备切换通知
    rawset(self, "CurInputDeviceType", CurInputDevice)
    rawset(self, "CurGamepadName", CurGamepadName)

    self:UpdateUIStyleInPlatform()
    self:SetFocus()
end

function M:UpdateUIStyleInPlatform()
    if self.SelectedRewardIdx then
        local Item = self.List_Item:GetItemAt(self.SelectedRewardIdx)
        if Item.SelfWidget then
            Item.SelfWidget:UpdateGamePadStyle()
        end
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if not rawget(self, "GamePadKeyInited") then
            rawset(self, "GamePadKeyInited", true)
            local ImgPath = UIUtils.UtilsGetKeyIconPathInGamepad("Y", self.CurGamepadName)
            local Img = LoadObject(ImgPath)
            self.Fame_CompletionProgress.Btn_Reward.Img_GamePad:SetBrushResourceObject(Img)
        end
        self.Fame_CompletionProgress.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Fame_CompletionProgress.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self.Reward:UpdateUIStyleInPlatform()
end

function M:UpdateSelectedRewardIdx(NewIdx)
    rawset(self, "SelectedRewardIdx", NewIdx)
end

-- 菜单打开关闭相关 根据Tips的开关状态更新底部提示
function M:OnMenuOpenChanged(IsOpen)
    if IsOpen then
        self.Com_Tab:UpdateBottomKeyInfo({
            -- {
            --     GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc=GText("UI_Tips_Ensure")
            -- },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
            }
        })
    else
        self.Com_Tab:UpdateBottomKeyInfo({
            {
                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc=GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        })
    end
end

return M
